package com.kpe.usstate;

import org.dita.dost.util.Job;
import org.dita.dost.util.Job.FileInfo;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.xml.sax.EntityResolver;
import org.xml.sax.InputSource;

import java.io.File;
import java.io.FileInputStream;
import java.io.StringReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Normalize USstate attribute based on main bookmap <prodinfo><usstate>.
 *
 * Main map example:
 *   <bookmap>
 *     <bookmeta>
 *       <prodinfo>
 *         <usstate>RI</usstate>
 *       </prodinfo>
 *     </bookmeta>
 *   </bookmap>
 *
 * Behavior:
 *   - If @USstate value is a pipe-separated list containing <usstate>,
 *     rewrite to just <usstate>.
 *   - If it does NOT contain <usstate>, rewrite to NO_<usstate>.
 *
 * Only the USstate attribute value is changed; all other markup is preserved as-is.
 */
public class USstateNormalizeModule {

    /**
     * Entry point for Ant <java>.
     * args[0] = dita.temp.dir (the temp directory used by DITA-OT / Job)
     */
    public static void main(String[] args) throws Exception {
        if (args.length < 1) {
            System.err.println("USstateNormalizeModule: expected tempDir argument");
            return;
        }
        new USstateNormalizeModule().execute(args[0]);
    }

    /**
     * Main execution logic, called from Ant.
     */
    public void execute(final String tempDirPath) throws Exception {
        final File tempDir = new File(tempDirPath);
        final Job job = new Job(tempDir);

        final String inputDirPath = job.getInputDir();  // e.g. Oxygen temp project dir
        final String inputMapPath = job.getInputMap();  // e.g. o_Rhode_Island.ditamap

        if (inputDirPath == null || inputMapPath == null) {
            System.out.println("USstateNormalizeModule: no inputDir or inputMap, nothing to do.");
            return;
        }

        final File inputDir = new File(inputDirPath);
        final File mainMapFile = new File(inputDir, inputMapPath);

        if (!mainMapFile.exists()) {
            System.out.println("USstateNormalizeModule: main map not found: " + mainMapFile);
            return;
        }

        final String mainState = extractMainState(mainMapFile);
        if (mainState == null || mainState.trim().isEmpty()) {
            System.out.println("USstateNormalizeModule: no <usstate> found in main map.");
            return;
        }

        final String mainStateNorm = mainState.trim();
        System.out.println("USstateNormalizeModule: main state = " + mainStateNorm);

        // Iterate all files in the job
        final Map<String, FileInfo> files = job.getFileInfo();
        for (FileInfo fi : files.values()) {
            // Only process active, non-resource-only DITA / DITAMAP files
            if (!fi.isActive || fi.isResourceOnly) {
                continue;
            }
            if (fi.format != null && !"dita".equals(fi.format) && !"ditamap".equals(fi.format)) {
                continue;
            }

            final File f = new File(inputDir, fi.file);
            if (!f.exists()) {
                continue;
            }

            boolean changed = normalizeFileUSstateText(f, mainStateNorm);
            if (changed) {
                System.out.println("USstateNormalizeModule: normalized " + f.getAbsolutePath());
            }
        }
    }

    /**
     * Create a DocumentBuilder that does NOT load external DTDs.
     * Used only for reading the main map to get <usstate>.
     */
    private DocumentBuilder createSafeDocumentBuilder() throws Exception {
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        dbf.setNamespaceAware(false);

        // Disable DTD loading / validation where possible
        try {
            dbf.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
        } catch (Exception e) {
            // ignore if not supported
        }
        try {
            dbf.setFeature("http://xml.org/sax/features/validation", false);
        } catch (Exception e) {
            // ignore if not supported
        }

        DocumentBuilder db = dbf.newDocumentBuilder();

        // Block external entity resolution
        db.setEntityResolver(new EntityResolver() {
            @Override
            public InputSource resolveEntity(String publicId, String systemId) {
                return new InputSource(new StringReader("")); // empty DTD
            }
        });

        return db;
    }

    /**
     * Read <prodinfo><usstate> from the main map.
     */
    private String extractMainState(final File mainMapFile) throws Exception {
        final DocumentBuilder db = createSafeDocumentBuilder();

        final Document doc;
        final FileInputStream in = new FileInputStream(mainMapFile);
        try {
            doc = db.parse(in);
        } finally {
            in.close();
        }

        Node root = doc.getDocumentElement();
        Node usstate = findFirstElementByName(root, "usstate");
        if (usstate != null && usstate.getTextContent() != null) {
            return usstate.getTextContent().trim();
        }

        return null;
    }

    private Node findFirstElementByName(Node node, String name) {
        if (node == null) return null;

        if (name.equals(node.getNodeName())) return node;

        Node child = node.getFirstChild();
        while (child != null) {
            Node found = findFirstElementByName(child, name);
            if (found != null) return found;
            child = child.getNextSibling();
        }
        return null;
    }

    /**
     * Normalize all @USstate attributes in a file by text replacement only.
     *
     * Rules (given mainState from <usstate>):
     *   - If USstate value (pipe list) contains mainState → set to mainState.
     *   - If NOT → set to "NO_" + mainState.
     *
     * Returns true if any attribute value was changed.
     */
    private boolean normalizeFileUSstateText(final File file, final String mainState) throws Exception {
        final String main = (mainState == null) ? "" : mainState.trim();
        if (main.isEmpty()) {
            return false;
        }

        // Java 8-compatible way to read the file as UTF-8
        String content = new String(Files.readAllBytes(file.toPath()), StandardCharsets.UTF_8);

        // Match USstate="...". We replace only the value, not other attributes or markup.
        Pattern pattern = Pattern.compile("USstate\\s*=\\s*\"([^\"]*)\"");
        Matcher m = pattern.matcher(content);
        StringBuffer sb = new StringBuffer();
        boolean changed = false;

        while (m.find()) {
            String oldVal = m.group(1);
            String newVal = computeNewUSstateValue(oldVal, main);

            if (!newVal.equals(oldVal)) {
                changed = true;
            }

            String replacement = "USstate=\"" + Matcher.quoteReplacement(newVal) + "\"";
            m.appendReplacement(sb, replacement);
        }
        m.appendTail(sb);

        if (changed) {
            // Java 8-compatible way to write the file as UTF-8
            Files.write(file.toPath(), sb.toString().getBytes(StandardCharsets.UTF_8));
        }

        return changed;
    }

    /**
     * Compute the new USstate value given the old one and main state.
     *
     * - If old value equals main, or contains main as a |token| → return main.
     * - Otherwise → return "NO_" + main.
     */
    private String computeNewUSstateValue(String oldVal, String main) {
        if (oldVal == null) {
            return "NO_" + main;
        }
        String v = oldVal.trim();
        if (v.isEmpty()) {
            return "NO_" + main;
        }

        String wrappedVal  = "|" + v + "|";
        String wrappedMain = "|" + main + "|";

        if (v.equals(main) || wrappedVal.contains(wrappedMain)) {
            return main;
        } else {
            return "NO_" + main;
        }
    }
}
