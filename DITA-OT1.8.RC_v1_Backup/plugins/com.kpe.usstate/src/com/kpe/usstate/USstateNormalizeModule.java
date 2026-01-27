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
 * Let S = <usstate> value, NS = "NO_" + S.
 *
 * USstate values are in exactly one of two forms:
 *
 *   1) Plain codes (no NO_ at all), e.g.:
 *        USstate="TN|AL|MD|SC|NJ|NC|..."
 *      Rule:
 *        - If any token == S      -> USstate="S"
 *        - Else                  -> USstate="NO_S"
 *
 *   2) All NO_-prefixed codes, e.g.:
 *        USstate="NO_TN|NO_AL|NO_MD|NO_SC|NO_NJ|..."
 *      Rule:
 *        - If any token == NS     -> USstate="NS"
 *        - Else                  -> remove the USstate attribute
 *
 * Only the USstate attribute (value or whole attribute) is changed;
 * all other attributes and markup are left intact.
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
     * Given mainState S from <usstate>:
     *   - If USstate has plain codes (no NO_) -> use plain-state rules.
     *   - If all tokens are NO_*             -> use NO_-state rules.
     *
     * Returns true if any attribute value was changed or removed.
     */
    private boolean normalizeFileUSstateText(final File file, final String mainState) throws Exception {
        final String main = (mainState == null) ? "" : mainState.trim();
        if (main.isEmpty()) {
            return false;
        }

        // Java 8-compatible way to read the file as UTF-8
        String content = new String(Files.readAllBytes(file.toPath()), StandardCharsets.UTF_8);

        // Match [space]USstate="...". We include leading whitespace so we can remove
        // the whole attribute cleanly when needed.
        Pattern pattern = Pattern.compile("\\s+USstate\\s*=\\s*\"([^\"]*)\"");
        Matcher m = pattern.matcher(content);
        StringBuffer sb = new StringBuffer();
        boolean changed = false;

        while (m.find()) {
            String oldVal = m.group(1);
            String newVal = computeNewUSstateValueWithDelete(oldVal, main);

            // Changed if value differs OR we remove the attribute
            if (newVal == null || !newVal.equals(oldVal)) {
                changed = true;
            }

            String replacement;
            if (newVal == null) {
                // Remove the entire attribute (including leading whitespace)
                replacement = "";
            } else {
                // Keep a single leading space and updated value
                replacement = " USstate=\"" + newVal + "\"";
            }

            m.appendReplacement(sb, Matcher.quoteReplacement(replacement));
        }
        m.appendTail(sb);

        if (changed) {
            // Java 8-compatible way to write the file as UTF-8
            Files.write(file.toPath(), sb.toString().getBytes(StandardCharsets.UTF_8));
        }

        return changed;
    }

    /**
     * Compute new USstate value, or null if attribute should be removed.
     *
     * Let:
     *   S  = main
     *   NS = "NO_" + main
     *
     * Given oldVal "v1|v2|...":
     *   tokens = non-empty, trimmed pieces split by '|'
     *
     *   allNo  = all tokens start with "NO_"
     *
     *   If !allNo (plain codes case):
     *      - If any token == S  -> return S
     *      - Else               -> return NS
     *
     *   If allNo (NO_ case):
     *      - If any token == NS -> return NS
     *      - Else               -> return null (remove attribute)
     */
    private String computeNewUSstateValueWithDelete(String oldVal, String main) {
        if (oldVal == null) {
            // No explicit rule given; treat as "no values" -> we can choose NS
            return "NO_" + main;
        }

        String v = oldVal.trim();
        if (v.isEmpty()) {
            // Empty -> also treat as "no explicit values" -> NS
            return "NO_" + main;
        }

        String[] parts = v.split("\\|");
        boolean allNo = true;
        boolean hasState = false;
        boolean hasNOS = false;
        String ns = "NO_" + main;

        for (String p : parts) {
            String tok = p.trim();
            if (tok.isEmpty()) {
                continue;
            }

            if (!tok.startsWith("NO_")) {
                allNo = false;
            }
            if (tok.equals(main)) {
                hasState = true;
            }
            if (tok.equals(ns)) {
                hasNOS = true;
            }
        }

        if (!allNo) {
            // Plain codes case
            if (hasState) {
                return main;
            } else {
                return ns;
            }
        } else {
            // All NO_* case
            if (hasNOS) {
                return ns;
            } else {
                return null; // remove attribute
            }
        }
    }
}
