<?xml version="1.0" encoding="UTF-8" ?>
<!-- This file is part of the DITA Open Toolkit project hosted on 
     Sourceforge.net. See the accompanying license.txt file for 
     applicable licenses.-->
<!-- Parts of this file are (c) Copyright IBM Corp. 2004, 2005 All Rights Reserved. -->

<!DOCTYPE xsl:stylesheet [

  <!ENTITY gt            "&gt;">
  <!ENTITY lt            "&lt;">
  <!ENTITY rbl           " ">
  <!ENTITY nbsp          "&#xA0;">    <!-- &#160; -->
  <!ENTITY quot          "&#34;">
  <!ENTITY copyr         "&#169;">  
  <!ENTITY reg           "&#174;">
]>

<!-- [SP] Changes added by Scriptorium are identified with [SP].
          The TRANSTYPE parameter indicates which transform is being used, which allows the transform 
          to be shared with other HTML-based DITA customizations.  

          When necessary, an <xsl:choose> or <xsl:if> is used to 
          produce output specific for one transformation or the other.           
-->          

<!-- [SP] TO DO

        
-->


<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
    xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
    xmlns:exsl="http://exslt.org/common"
    xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links"
    exclude-result-prefixes="dita2html ditamsg exsl related-links">
    <!-- 
            xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"    
    exclude-result-prefixes="dita2html ditamsg exsl related-links">
        -->
    <xsl:import href="sps_utils.xsl"/>


    <!-- [SP] TRANSTYPE param, defined in html_params.xml (and added by the integrator). 
              Specifies the transformation type.-->
    <xsl:param name="TRANSTYPE"/>
    <!-- [SP] MAPFILE param, defined in html_params.xml (and added by the integrator). 
              Specifies the preprocessed map file in the temp folder.
              (full path) -->

    <xsl:param name="MAPFILE"/>
    <!-- [SP] INPUT param, defined in html_params.xml (and added by the integrator). 
              Specifies the actual input map file (${args.input})-->
    <xsl:param name="INPUT"/>

    <!-- [SP] TOPIC_LIST param, defined in html_params.xml (and added by the integrator). 
        Specifies the the topic_list.xml file, which summarizes the topics. -->
    <xsl:param name="TOPIC_LIST"/>

    <!-- [SP] ${user.input.file}. same as MAPFILE, but no path. -->

    <xsl:param name="MAPFILE_FILE"/>

    <xsl:param name="OUTPUT_DIR"/>

    <xsl:param name="WORKDIR" select="'./'"/>

    <!-- [SP] file and dir params -->
    <xsl:param name="file.separator"/>
    <xsl:param name="FILEDIR"/>

    <xsl:param name="FILENAME"/>


    <!-- [SP] concat FILEDIR, FILENAME -->
    <xsl:variable name="current_path_file">
        <xsl:choose>
            <xsl:when test="$FILEDIR = '.'">
                <xsl:value-of select="$FILENAME"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($FILEDIR, '/', $FILENAME)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- [SP] fix the 1.6.3 PATH2PROJ bug for files created via @copy-to;
        if PATH2PROJ is not correct, replace it with the right value -->

    <!-- [SP] original <xsl:param name="PATH2PROJ">
        <xsl:apply-templates select="/processing-instruction('path2project')" mode="get-path2project"/>
        </xsl:param> -->

    <xsl:param name="PATH2PROJ">
        <xsl:apply-templates select="/processing-instruction('path2project')"
            mode="get-path2project"/>
    </xsl:param>

    <xsl:template match="processing-instruction('path2project')" mode="get-path2project">
        <xsl:variable name="p2p_level">
            <xsl:call-template name="get-level">
                <xsl:with-param name="current_path_file" select="translate(., '\', '/')"/>
                <xsl:with-param name="counter" select="0"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$p2p_level != $page_level">
                <xsl:call-template name="path_to_root">
                    <xsl:with-param name="counter" select="$page_level"/>
                    <xsl:with-param name="parent_path"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- [SP] <xsl:value-of select="."/> -->
                <xsl:value-of select="translate(., '\', '/')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- [SP] handy debug msgs, called in 'chapter-setup' template. -->
    <xsl:param name="DEBUG"/>

    <xsl:template name="debug_msgs">
        <xsl:message> debug info: $FILEDIR = <xsl:value-of select="$FILEDIR"/> $FILENAME =
                <xsl:value-of select="$FILENAME"/> $current_path_file = <xsl:value-of
                select="$current_path_file"/> $INPUT = <xsl:value-of select="$INPUT"/> $MAPFILE =
                <xsl:value-of select="$MAPFILE"/> $MAPFILE_FILE = <xsl:value-of
                select="$MAPFILE_FILE"/> $OUTPUTDIR = <xsl:value-of select="$OUTPUTDIR"/> $PATH2PROJ
            = <xsl:value-of select="$PATH2PROJ"/> $TOPIC_LIST = <xsl:value-of select="$TOPIC_LIST"/>
            $TRANSTYPE = <xsl:value-of select="$TRANSTYPE"/> $WORKDIR = <xsl:value-of
                select="$WORKDIR"/> $page_level = <xsl:value-of select="$page_level"/>
            <xsl:value-of select="$newline"/>
        </xsl:message>
    </xsl:template>

    <!-- [SP] how many levels down from root? -->
    <xsl:variable name="page_level">
        <xsl:call-template name="get-level">
            <xsl:with-param name="current_path_file" select="$current_path_file"/>
            <!-- 0 = root -->
            <xsl:with-param name="counter" select="0"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="apos">'</xsl:variable>
    <!-- [SP] This just helps keep the file clean(er) when editing in oXygen. -->
    <xsl:variable name="newline" select="'&#x0A;'"/>

    <!-- [SP] 2015-01-16: TODO: replace with XSL 2.0 functions. -->
    <xsl:variable name="alpha_uc">
        <xsl:call-template name="getString">
            <xsl:with-param name="stringName" select="'alpha_uc'"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="alpha_lc">
        <xsl:call-template name="getString">
            <xsl:with-param name="stringName" select="'alpha_lc'"/>
        </xsl:call-template>
    </xsl:variable>

    <xsl:variable name="topic.list">
        <!-- Because this stylesheet is integrated with dita2htmlImpl, prevent
            attempted opens of TOPIC_LIST from non kpe_xhtml transforms. -->
        <xsl:if test="$TRANSTYPE = 'kpe_xhtml'">
            <xsl:copy-of select="document(concat('file:///', $TOPIC_LIST))"/>
        </xsl:if>
    </xsl:variable>


    <!-- [SP] 26-Apr-2013: Parameterize the doctype attributes (requires XSL 1.1) -->

    <xsl:variable name="doctype-public">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'kpe_xhtml'">
                <xsl:value-of select="'-//W3C//DTD XHTML 1.0 Transitional//EN'"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:value-of select="'-//W3C//DTD XHTML 1.1//EN'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'-//W3C//DTD XHTML 1.0 Transitional//EN'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="doctype-system">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'kpe_xhtml'">
                <xsl:value-of select="'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:value-of select="'http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="omit-xml">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'kpe_xhtml'">
                <xsl:value-of select="'no'"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:value-of select="'yes'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'no'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="indent-value">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'kpe_xhtml'">
                <xsl:value-of select="'yes'"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:value-of select="'no'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'yes'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <!-- Commented out in early xhtml.. 
        <xsl:output method="xml" doctype-system="about:legacy-compat"/>-->
    <!-- Original kpe_xhtml output statement
        <xsl:output method="xml" encoding="UTF-8" indent="yes"/>-->

    <!-- Original sepub3 output statement 
        <xsl:output method="xml" encoding="utf-8" indent="no" doctype-public="-//W3C//DTD XHTML 1.1//EN"
        doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" omit-xml-declaration="yes"/>
-->
    <!--    <xsl:output method="xml" encoding="UTF-8"
        doctype-public="{$doctype-public}"
        doctype-system="{$doctype-system}"
    />-->
    <!--
        omit-xml-declaration="{$omit-xml}"
        indent="{$indent-value}" 

        -->
    <xsl:output method="xml" encoding="utf-8" indent="no" doctype-public="-//W3C//DTD XHTML 1.1//EN"
        doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" omit-xml-declaration="yes"/>

    <xsl:template name="chapter-setup">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'kpe_xhtml'">
                <xsl:call-template name="chapter-setup.kpe_xhtml"/>
                <!--                <xsl:apply-templates select="." mode="chapter-setup-xhtml"/>-->
            </xsl:when>
            <!-- [SP] 29-Apr-2013: For anything other than XHTLM, must use apply templates with a mode. -->

            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:apply-templates select="." mode="chapter-setup.sepub3"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'sps_help'">
                <xsl:apply-templates select="." mode="chapter-setup.sps_help"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="chapter-setup.kpe_xhtml"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- ========== DEFAULT PAGE LAYOUT ========== -->
    <!-- [SP] Overridden to add HTML namespace. -->
    <xsl:template name="chapter-setup.kpe_xhtml">

        <!-- [SP] output debug msgs -->
        <xsl:if test="$DEBUG = 'yes'">
            <xsl:call-template name="debug_msgs"/>
        </xsl:if>

        <!--<xsl:if test="contains(document(concat('file:///',$MAPFILE))//*[contains(@href,$FILENAME)]/@status,'new')">
            <xsl:message>
                #####
                #####
                #####
                this file is new.
            </xsl:message>
        </xsl:if>-->


        <html xmlns="http://www.w3.org/1999/xhtml">
            <xsl:call-template name="setTopicLanguage"/>
            <xsl:value-of select="$newline"/>
            <xsl:call-template name="chapterHead"/>
            <xsl:call-template name="chapterBody_xhtml"/>

        </html>
    </xsl:template>

    <!-- [SP] Override generateChapterTitle to just get the title from the bookmap. -->
    <xsl:template name="generateChapterTitle">
        <!-- Title processing - special handling for short descriptions -->
        <title>
            <!-- [SP] modify for ditamaps (and not just bookmaps) -->
            <!--<xsl:value-of
                select="document(concat('file:///',$MAPFILE))/descendant::*[contains(@class,' bookmap/mainbooktitle ')]"
            />-->
            <xsl:variable name="main_title"
                select="document(concat('file:///', $MAPFILE))/descendant::*[contains(@class, ' bookmap/mainbooktitle ')]"/>
            <xsl:choose>
                <xsl:when test="$main_title != ''">
                    <xsl:value-of select="$main_title"/>
                </xsl:when>
                <xsl:otherwise>
                    <!--<xsl:value-of select="document(concat('file:///',$MAPFILE))/descendant::*/@title"/>-->
                    <xsl:value-of
                        select="document(concat('file:///', $MAPFILE))/descendant::*/topicref[1]/@navtitle"/>

                </xsl:otherwise>
            </xsl:choose>
        </title>
        <xsl:value-of select="$newline"/>
    </xsl:template>


    <!-- [SP] The template gen-user-scripts is designed to be overridden, so that 
            we can implement changes such as this.
            Add links to our scripts. -->
    <xsl:template name="gen-user-scripts">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'kpe_xhtml'">
                <xsl:apply-templates select="." mode="gen-user-scripts.xhtml"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:apply-templates select="." mode="gen-user-scripts.sepub3"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'sps_help'">
                <xsl:apply-templates select="." mode="gen-user-scripts.sps_help"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="gen-user-scripts.xhtml"/>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="/|node()|@*" mode="gen-user-scripts.xhtml">
        <!-- to customize: copy this to your override transform, add the content you want. -->
        <!-- It will be placed before the ending HEAD tag -->
        <!-- see (or enable) the named template "script-sample" for an example -->
        <!-- [SP] Depending on the transformation type, source in different js files. -->
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'scorm1.2'"/>
            <xsl:when test="$TRANSTYPE = 'scorm1.2_custom'"/>
            <xsl:otherwise>
                <xsl:value-of select="$newline"/>
                <script src="{$PATH2PROJ}js/scriptorium_page.js" type="text/javascript"><xsl:text>  </xsl:text></script>
                <xsl:value-of select="$newline"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- [SP] The template gen-user-header is designed to be overridden, so that 
        we can implement changes such as this.
        Create the page header. -->
    <xsl:template match="/|node()|@*" mode="gen-user-header">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'kpe_xhtml'">
                <xsl:apply-templates select="." mode="gen-user-header.kpe_xhtml"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:apply-templates select="." mode="gen-user-header.sepub3"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'sps_help'">
                <xsl:apply-templates select="." mode="gen-user-header.sps_help"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="gen-user-header.kpe_xhtml"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="/|node()|@*" mode="gen-user-header.kpe_xhtml">
        <!-- to customize: copy this to your override transform, add the content you want. -->
        <!-- it will be placed in the running header section of the XHTML. -->
    </xsl:template>


    <!-- [SP] Build breadcrumbs.  -->
    <xsl:template name="breadcrumbs">
        <!-- TEMPORARY PLACEHOLDER TEXT -->
        <!-- [SP] <nav class="breadcrumbs" id="bcrumbs"> -->
        <div class="breadcrumbs" id="bcrumbs">
            <xsl:call-template name="corporate_breadcrumbs"/>
            <p class="lcl_crumbs">

                <xsl:variable name="this_id" select="@id"/>

                <!-- <xsl:message>TOPIC_LIST is <xsl:value-of select="$TOPIC_LIST"/>.</xsl:message> -->
                <!--        <xsl:variable name="topic.list" select="document(concat('file:///',$TOPIC_LIST))"/>-->

                <!-- Always show the path to home. -->
                <xsl:variable name="welcome_item"
                    select="$topic.list//descendant-or-self::topicref[@home = 'yes'][1]"/>
                <xsl:variable name="welcome_href" select="$welcome_item/@href"/>
                <!-- <xsl:message>welcome_href is: <xsl:value-of select="$welcome_href"/>.</xsl:message> -->
                <a>
                    <xsl:attribute name="href">
                        <!--<xsl:value-of
                            select="concat($PATH2PROJ,substring-before($welcome_href,'.xml'),'.html')"
                        />-->
                        <!-- [SP] 14-Feb-2013: Generalized to use fix_href. -->
                        <xsl:variable name="fixed_href">
                            <xsl:call-template name="fix_href">
                                <xsl:with-param name="href" select="$welcome_href"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="concat($PATH2PROJ, $fixed_href)"/>

                    </xsl:attribute>
                    <xsl:call-template name="get_map_title"/>
                </a>

                <!-- Find the current topic in the topic_list. -->
                <xsl:variable name="q_nodes"
                    select="$topic.list/descendant-or-self::*[@href = $current_path_file]"/>

                <xsl:choose>
                    <xsl:when test="count($q_nodes) &gt; 1">
                        <xsl:message>
                            <xsl:text>kpe-XHTML *******: Found duplicate ID (</xsl:text>
                            <xsl:value-of select="$this_id"/>
                            <xsl:text>) for the following topics:</xsl:text>
                            <xsl:apply-templates select="$q_nodes" mode="report_dup"/>
                            <xsl:text>&#x0A;</xsl:text>
                        </xsl:message>

                        <!--<xsl:for-each select="$q_nodes">
                            <xsl:message>
                                
                                
                                qnodes count = <xsl:value-of select="count($q_nodes)"/>
                                
                                curr xtrc = <xsl:value-of select="//@xtrc"/>
                                curr xtrf = <xsl:value-of select="//@xtrf"/>
                                
                                1. qnodes xtrc = <xsl:value-of select="$q_nodes[1]/@xtrc"/>
                                1. qnodes xtrf = <xsl:value-of select="$q_nodes[1]/@xtrf"/>
                                
                                2. qnodes xtrc = <xsl:value-of select="$q_nodes[2]//@xtrc"/>
                                2. qnodes xtrf = <xsl:value-of select="$q_nodes[2]//@xtrf"/>
                                
                            </xsl:message>
                        </xsl:for-each>-->

                    </xsl:when>
                    <!-- As long as we're not at the Welcome page, gather all the ancestor topicrefs. -->
                    <!-- Note that this shifts context to the topic_list.xml file. -->
                    <!--<xsl:when test="not($q_nodes[1]/@home)">-->
                    <xsl:when test="not($q_nodes[1]/@home)">


                        <xsl:call-template name="getString">
                            <xsl:with-param name="stringName" select="'breadcrumb_separator'"/>
                        </xsl:call-template>
                        <xsl:apply-templates select="$q_nodes[1]" mode="crumbs">
                            <!--<xsl:with-param name="this_id" select="$this_id"/>-->

                            <xsl:with-param name="current_path_file" select="$current_path_file"/>
                            <!--<xsl:with-param name="q_nodes_preceding" select="$q_nodes_preceding"/>
                            <xsl:with-param name="MAPFILE_prec" select="$MAPFILE_prec"/>-->
                        </xsl:apply-templates>
                    </xsl:when>
                </xsl:choose>
            </p>

            <!-- [SP] add pre-next links to body top -->
            <xsl:call-template name="prev-next"/>

            <!-- [SP] </nav> -->
        </div>
    </xsl:template>

    <!-- [SP] Get the main title from the map file. -->
    <!-- [SP] 27-Feb-2013: These next two templates will have to be moved/modified to work when moved to the TOC. -->

    <xsl:template name="get_pdf_href">
        <a>
            <!-- [SP] pdf href mods-->
            <!--<xsl:variable name="map_filename"
                select=" concat($PATH2PROJ,'../pdf/',substring-before($MAPFILE_FILE,'.ditamap'),'.pdf')"/>-->
            <xsl:variable name="map_filename"
                select="concat($PATH2PROJ, 'downloads/', substring-before($MAPFILE_FILE, '.ditamap'), '.pdf')"/>

            <xsl:attribute name="href">
                <xsl:value-of select="$map_filename"/>
            </xsl:attribute>
            <xsl:call-template name="getString">
                <xsl:with-param name="stringName" select="'PDFs'"/>
            </xsl:call-template>
        </a>
    </xsl:template>

    <xsl:template name="get_epub_href">
        <a>
            <!-- [SP] epub href mods-->
            <!--<xsl:variable name="map_filename"
                select=" concat($PATH2PROJ,'../epub/',substring-before($MAPFILE_FILE,'.ditamap'),'.epub')"/>-->
            <xsl:variable name="map_filename"
                select="concat($PATH2PROJ, 'downloads/', substring-before($MAPFILE_FILE, '.ditamap'), '.epub')"/>
            <xsl:attribute name="href">
                <xsl:value-of select="$map_filename"/>
            </xsl:attribute>
            <xsl:call-template name="getString">
                <xsl:with-param name="stringName" select="'EPUBs'"/>
            </xsl:call-template>
        </a>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/data ')]">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'sps_help'">
                <xsl:apply-templates select="." mode="data.sps_help"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:apply-templates select="." mode="data.sepub3"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- Do nothing. -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/data-about ')][@type = 'pdf_reference']"
        mode="pdf_reference">
        <xsl:apply-templates select="*[contains(@class, ' topic/data')]" mode="pdf_reference"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/data ')]" mode="pdf_reference">
        <xsl:value-of select="@href"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/data ')][@datatype]">
        <xsl:choose>
            <xsl:when test="@datatype = 'si'">
                <span class="si ushow">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@datatype = 'us'">
                <span class="us uhide">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- [SP] Get the main title from the map file. -->
    <xsl:template name="get_map_title">
        <!--<xsl:apply-templates
            select="document(concat('file:///',$MAPFILE))/descendant::*[contains(@class,' bookmap/mainbooktitle ')]"
        />-->


        <!-- [SP] modify for ditamaps (and not just bookmaps) -->
        <!--<xsl:value-of
                select="document(concat('file:///',$MAPFILE))/descendant::*[contains(@class,' bookmap/mainbooktitle ')]"
            />-->
        <!--<xsl:variable name="main_title" select="document(concat('file:///',$MAPFILE))/descendant::*[contains(@class,' bookmap/mainbooktitle ')]"/>-->
        <xsl:variable name="main_title">
            <xsl:apply-templates
                select="document(concat('file:///', $MAPFILE))/descendant::*[contains(@class, ' bookmap/mainbooktitle ')]"
            />
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$main_title != ''">
                <xsl:value-of select="$main_title"/>
            </xsl:when>
            <xsl:otherwise>
                <!--<xsl:value-of select="document(concat('file:///',$MAPFILE))/descendant::*/@title"/>-->
                <xsl:value-of
                    select="document(concat('file:///', $MAPFILE))/descendant::*/topicref[1]/@navtitle"/>

            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- [SP] Get the company-specific breadcrumbs from metadata in the map file. -->
    <xsl:template name="corporate_breadcrumbs">
        <!--<p class="corp_crumbs">
            <xsl:apply-templates
                select="document(concat('file:///',$MAPFILE))/descendant::*[contains(@class,' topic/data-about ')][@type='external_breadcrumbs']"
                mode="corporate_breadcrumbs"/>
        </p>-->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/data-about ')][@type = 'external_breadcrumbs']"
        mode="corporate_breadcrumbs">
        <xsl:apply-templates select="*[contains(@class, ' topic/data')]"
            mode="corporate_breadcrumbs"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/data ')]" mode="corporate_breadcrumbs">
        <a>
            <xsl:attribute name="href">
                <xsl:value-of select="@href"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </a>
        <xsl:if test="position() != last()">
            <xsl:call-template name="getString">
                <xsl:with-param name="stringName" select="'breadcrumb_separator'"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*" mode="report_dup">
        <xsl:value-of select="@href"/>
        <xsl:text>&#x0A;</xsl:text>
    </xsl:template>

    <!-- In the context of the topic_list.xml file (which doesn't have class attributes), 
         recursively display the previous links. -->
    <xsl:template match="topicref | topichead | topicgroup" mode="crumbs">
        <!--<xsl:param name="this_id"/>-->

        <xsl:param name="current_path_file"/>

        <xsl:variable name="at_current" select="@href = $current_path_file"/>

        <xsl:variable name="parent_count" select="count(ancestor::*[name() != 'map'])"/>
        <!--        <xsl:message>at_current is <xsl:value-of select="$at_current"/>.</xsl:message>
        <xsl:message>parent_count is <xsl:value-of select="$parent_count"/>.</xsl:message>
-->
        <!-- If there are parents, show them... -->
        <xsl:if test="$parent_count &gt; 0 and not(parent::*/@home)">
            <!-- Look for parent topics -->
            <xsl:apply-templates select="parent::*" mode="crumbs">
                <!--<xsl:with-param name="this_id" select="$this_id"/>-->
                <xsl:with-param name="current_path_file" select="$current_path_file"/>
            </xsl:apply-templates>
            <xsl:call-template name="getString">
                <xsl:with-param name="stringName" select="'breadcrumb_separator'"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:choose>
            <!-- See if we're at the home node. -->
            <xsl:when test="@home = 'yes'">
                <!-- Don't do anything. -->
            </xsl:when>
            <!-- See if we're at the current topic (or a topichead). -->
            <!--<xsl:when test="$at_current or not(@href)">-->
            <xsl:when test="$at_current or not(@href)">
                <xsl:apply-templates select="title" mode="crumbs"/>
            </xsl:when>
            <!-- Handle normally-->
            <xsl:otherwise>
                <a>
                    <xsl:attribute name="href">
                        <xsl:variable name="fixed_href">
                            <!-- [SP] 14-Feb-2013: Generalized to use fix_href. -->
                            <xsl:call-template name="fix_href">
                                <xsl:with-param name="href" select="@href"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="concat($PATH2PROJ, $fixed_href)"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="title" mode="crumbs"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- [SP] Get the name of the link, using either the linktext or, if it isn't available, the navtitle. -->
    <xsl:template match="title" mode="crumbs">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template name="gen-user-footer">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'kpe_xhtml'">
                <xsl:apply-templates select="." mode="gen-user-footer.kpe_xhtml"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:apply-templates select="." mode="gen-user-footer.sepub3"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'sps_help'">
                <xsl:apply-templates select="." mode="gen-user-footer.sps_help"/>
            </xsl:when>
            <!--     [SPJLC] Do not generate standard "previous, next, email" footer for SCORM       -->
            <xsl:when test="$TRANSTYPE = 'scorm1.2'"/>
            <xsl:when test="$TRANSTYPE = 'scorm1.2_custom'"/>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="gen-user-footer.kpe_xhtml"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="/|node()|@*" mode="gen-user-footer.kpe_xhtml">
        <!-- to customize: copy this to your override transform, add the content you want. -->
        <!-- it will be placed in the running footing section of the XHTML. -->
        <!-- [SP] Create the page footer. -->
        <!-- [SP] <footer> -->
        <div class="footer_cont">
            <!-- [SP] print page -->
            <!--<p id="print_this" onclick="javascript:window.print();">Print this page</p>-->
            <xsl:call-template name="prev-next"/>
            <div class="print_email">

                <!--<br/>-->
                <xsl:variable name="book_title">
                    <xsl:call-template name="get_map_title"/>
                </xsl:variable>

                <xsl:variable name="chapter_title">
                    <xsl:apply-templates select="title" mode="crumbs"/>
                    <!--<xsl:call-template name="generateChapterTitle"/>-->
                </xsl:variable>


                <xsl:variable name="mail_to_href"
                    select="concat('javascript:email_this(&quot;', $book_title, ': ', $chapter_title, '&quot;)')"/>
                <p class="mail_this">
                    <!--<a href="{$mail_to_href}"><img src="{$PATH2PROJ}images/envelope_small.png" alt="Email this topic"/>Email this topic</a>-->
                    <a href="{$mail_to_href}">
                        <!--<img src="{$PATH2PROJ}images/envelope_small.png"
                            alt="Email this topic"/>-->
                        <img src="{$PATH2PROJ}images/envelope_small.png" alt="Email this topic"
                        />Email this topic</a>
                </p>
                <p class="print_this">
                    <a href="javascript:window.print();">
                        <!--<img src="{$PATH2PROJ}images/printer_small.png" alt="Print this page"/>-->
                        <img src="{$PATH2PROJ}images/printer_small.png" alt="Print this page"/>Print
                        this page</a>
                </p>
            </div>

            <!--<p class="copyright">
                <xsl:call-template name="getString">
                    <xsl:with-param name="stringName" select="'copyright'"/>
                </xsl:call-template>
            </p>-->



            <!-- ########################################
                [SP] footer code begin -->

            <!-- [SP] scriptorium includes -->
            <xsl:value-of select="$newline"/>
            <xsl:comment> scriptorium - FOOTER BEGIN </xsl:comment>
            <xsl:value-of select="$newline"/>
            <!--<xsl:comment>#include virtual="../../../../footer.htm"</xsl:comment> -->
            <!--<xsl:comment>#include virtual="../../../<xsl:value-of select="$PATH2PROJ"/>footer.htm"</xsl:comment>-->
            <xsl:comment>#include virtual="/footer.htm"</xsl:comment>
            <xsl:value-of select="$newline"/>
            <xsl:comment> scriptorium -  FOOTER END </xsl:comment>
            <xsl:value-of select="$newline"/>

            <!--<xsl:comment> scriptorium - FOOTER BEGIN </xsl:comment>
            <xsl:value-of select="$newline"/>

            <xsl:variable name="footer_file" select="concat('FILE:///',$OUTPUTDIR,'\footer.htm')"/>
            <xsl:copy-of select="document($footer_file)"/>

            <xsl:comment> scriptorium -  FOOTER END </xsl:comment>
            <xsl:value-of select="$newline"/>-->

            <!-- ########################################
                [SP] footer code end -->

            <!-- [SP] </footer> -->
        </div>
    </xsl:template>

    <xsl:template name="prev-next">
        <!--    <xsl:variable name="topic_list" select="document(concat('file:///',$TOPIC_LIST))"/>        -->
        <!-- Get the ID of the current topic. -->
        <xsl:variable name="current_id" select="//*[contains(@class, ' topic/topic ')]/@id"/>

        <!-- switch context to the topic_list. -->
        <!-- [SP] subdirs mods -->
        <!-- ORIGINAL <xsl:for-each select="$topic.list//topicref[@id = $current_id][1]">-->

        <xsl:for-each select="$topic.list//topicref[@href = $current_path_file][1]">

            <p class="prev_next">
                <!-- Handle the previous link. -->
                <xsl:call-template name="generate_prev"/>
                <xsl:call-template name="getString">
                    <xsl:with-param name="stringName" select="'sep_string'"/>
                </xsl:call-template>
                <xsl:call-template name="generate_next"/>
            </p>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="generate_prev">
        <xsl:variable name="prev_text">
            <xsl:call-template name="getString">
                <xsl:with-param name="stringName" select="'prev_string'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="prev_href">
            <xsl:choose>
                <xsl:when test="count(preceding-sibling::topicref) = 0 and parent::topicref">
                    <xsl:value-of select="parent::topicref[1]/@href"/>
                </xsl:when>
                <xsl:when test="count(preceding-sibling::topicref) = 0"> </xsl:when>
                <!-- [SP] <xsl:when test="preceding-sibling::topicref[1]/child::topicref">
                    <xsl:value-of
                    select="preceding-sibling::topicref[1]/child::topicref[last()]/@href"/>
                    </xsl:when> -->
                <!-- [SP] see if there's a preceding topicref[1] -->
                <xsl:when test="preceding::topicref[1]">
                    <xsl:value-of select="preceding::topicref[1]/@href"/>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="preceding-sibling::topicref[1]/@href"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="fixed_href">
            <xsl:call-template name="fix_href">
                <xsl:with-param name="href" select="$prev_href"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="normalize-space($fixed_href) = ''">
                <xsl:value-of select="$prev_text"/>
            </xsl:when>
            <xsl:otherwise>
                <a>
                    <!-- [SP] subdirs mods -->
                    <!-- ORIGINAL -->
                    <!--<xsl:attribute name="href">
                    <xsl:value-of select="$fixed_href"/>
                </xsl:attribute>
                <xsl:value-of select="$prev_text"/>-->

                    <xsl:attribute name="href">
                        <!-- [SP] relative links fix -->

                        <!-- 
                        
                        when page level is > 0 
                            add ('../' x $page_level) before the href;
                        otherwise
                            use the href as it is
                        
                        -->
                        <xsl:variable name="parent_dir_string">
                            <xsl:call-template name="path_to_root">
                                <xsl:with-param name="counter" select="$page_level"/>
                            </xsl:call-template>
                        </xsl:variable>

                        <xsl:value-of select="concat($parent_dir_string, $fixed_href)"/>
                    </xsl:attribute>
                    <xsl:value-of select="$prev_text"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="generate_next">
        <xsl:variable name="next_text">
            <xsl:call-template name="getString">
                <xsl:with-param name="stringName" select="'next_string'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="next_href">
            <xsl:choose>
                <!-- If the node has children. -->
                <!-- [SP] subdirs mods -->
                <!-- ORIGINAL <xsl:when test="child::topicref">
                    <xsl:value-of select="child::topicref[1]/@href"/>
                </xsl:when>-->
                <!--<xsl:when test="child::topicref[parent::map or parent::topicref/parent::map]">
                    <xsl:value-of select="child::topicref[1]/@href"/>
                </xsl:when>-->
                <xsl:when test="child::topicref">
                    <xsl:value-of select="child::topicref[1]/@href"/>
                </xsl:when>

                <!-- If there are no following siblings -->
                <xsl:when test="count(following-sibling::topicref) = 0">
                    <xsl:choose>
                        <!-- See if there's a parent that has following siblings. -->
                        <!-- [SP] <xsl:when
                            test="parent::topicref and parent::topicref/following-sibling::topicref">
                            <xsl:value-of
                            select="parent::topicref[1]/following-sibling::topicref[1]/@href"/>
                            </xsl:when> -->

                        <!-- [SP] See if there's a following topicref[1] -->
                        <xsl:when test="following::topicref[1]">
                            <xsl:value-of select="following::topicref[1]/@href"/>
                        </xsl:when>


                        <!-- Otherwise, don't return a value. -->
                        <xsl:otherwise/>


                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="following-sibling::topicref[1]/@href"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="fixed_href">
            <xsl:call-template name="fix_href">
                <xsl:with-param name="href" select="$next_href"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="normalize-space($fixed_href) = ''">
                <xsl:value-of select="$next_text"/>
            </xsl:when>
            <xsl:otherwise>
                <a>
                    <!-- [SP] subdirs mods -->
                    <!-- ORIGINAL -->
                    <!--<xsl:attribute name="href">
                    <xsl:value-of select="$fixed_href"/>
                </xsl:attribute>
                <xsl:value-of select="$next_text"/>-->

                    <xsl:attribute name="href">
                        <!--<xsl:value-of select="$fixed_href"/>-->
                        <!-- [SP] relative links fix -->

                        <!-- 
                        
                        when page level is > 0 
                            add ('../' x $page_level) before the href;
                        otherwise
                            use the href as it is
                        
                        -->
                        <xsl:variable name="parent_dir_string">
                            <xsl:call-template name="path_to_root">
                                <xsl:with-param name="counter" select="$page_level"/>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:value-of select="concat($parent_dir_string, $fixed_href)"/>
                    </xsl:attribute>
                    <xsl:value-of select="$next_text"/>
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="map" mode="get-next">
        <xsl:param name="current_id"/>
    </xsl:template>

    <!-- [SP] default CSS overrides -->

    <!-- Generate links to CSS files -->
    <xsl:template name="generateCssLinks">
        <xsl:variable name="childlang">
            <xsl:choose>
                <!-- Update with DITA 1.2: /dita can have xml:lang -->
                <xsl:when test="self::dita[not(@xml:lang)]">
                    <xsl:for-each select="*[1]">
                        <xsl:call-template name="getLowerCaseLang"/>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="getLowerCaseLang"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="direction">
            <xsl:apply-templates select="." mode="get-render-direction">
                <xsl:with-param name="lang" select="$childlang"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="urltest">
            <!-- test for URL -->
            <xsl:call-template name="url-string">
                <xsl:with-param name="urltext">
                    <xsl:value-of select="concat($CSSPATH, $CSS)"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="($direction = 'rtl') and ($urltest = 'url')">
                <link rel="stylesheet" type="text/css" href="{$CSSPATH}{$bidi-dita-css}"/>
            </xsl:when>
            <xsl:when test="($direction = 'rtl') and ($urltest = '')">
                <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$CSSPATH}{$bidi-dita-css}"
                />
            </xsl:when>
            <xsl:when test="($urltest = 'url')">
                <link rel="stylesheet" type="text/css" href="{$CSSPATH}{$dita-css}"/>
            </xsl:when>
            <xsl:otherwise>
                <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$CSSPATH}{$dita-css}"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$newline"/>
        <!-- Add user's style sheet if requested to -->
        <xsl:if test="string-length($CSS) > 0">
            <xsl:choose>
                <xsl:when test="$urltest = 'url'">
                    <link rel="stylesheet" type="text/css" href="{$CSSPATH}{$CSS}"/>
                </xsl:when>
                <xsl:otherwise>
                    <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$CSSPATH}{$CSS}"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:value-of select="$newline"/>
        </xsl:if>
    </xsl:template>

    <!-- [SP] end default CSS overrides -->



    <!-- [SP] Add links to our CSS. -->
    <xsl:template name="gen-user-styles">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'kpe_xhtml'">
                <xsl:apply-templates select="." mode="gen-user-styles.xhtml"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:apply-templates select="." mode="gen-user-styles.sepub3"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'sps_help'">
                <xsl:apply-templates select="." mode="gen-user-styles.xhtml"/>
                <xsl:apply-templates select="." mode="gen-user-styles.sps_help"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="gen-user-styles.xhtml"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="/|node()|@*" mode="gen-user-styles.xhtml">
        <!-- to customize: copy this to your override transform, add the content you want. -->
        <!-- It will be placed before the ending HEAD tag -->
        <!-- [SP] Depending on the transformation type, source in different css files. -->

        <!-- [SP] add link to their main styles -->
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'scorm1.2'">
                <link rel="stylesheet" type="text/css" href="../commonltr.css" media="print"/>
                <xsl:value-of select="$newline"/>
                <link rel="stylesheet" type="text/css" href="../shared/style.css"/>
                <xsl:value-of select="$newline"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'scorm1.2_custom'">
                <link rel="stylesheet" type="text/css" href="../commonltr.css" media="print"/>
                <xsl:value-of select="$newline"/>
                <link rel="stylesheet" type="text/css" href="../shared/style.css"/>
                <xsl:value-of select="$newline"/>
            </xsl:when>
            <xsl:otherwise>
                <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}css/scriptorium_print.css"
                    media="print"/>
                <xsl:value-of select="$newline"/>
                <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}css/scriptorium_style.css"/>
                <xsl:value-of select="$newline"/>
                <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}css/scriptorium_print.css"
                    media="print"/>
            </xsl:otherwise>
        </xsl:choose>
        <!--        <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}css/scriptorium_print.css"
            media="print"/>
        <xsl:value-of select="$newline"/>
        <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}css/scriptorium_style.css"/>
        <xsl:value-of select="$newline"/>
        <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}css/scriptorium_print.css"
            media="print"/>
        <xsl:value-of select="$newline"/>-->
    </xsl:template>

    <!-- [SP] Modified to add Mark of the Web. -->
    <xsl:template name="gen-user-head">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'kpe_xhtml'">
                <xsl:apply-templates select="." mode="gen-user-head.kpe_xhtml"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:apply-templates select="." mode="gen-user-head.sepub3"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'sps_help'">
                <xsl:apply-templates select="." mode="gen-user-head.sps_help"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="gen-user-head.kpe_xhtml"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="/|node()|@*" mode="gen-user-head.kpe_xhtml">
        <!-- to customize: copy this to your override transform, add the content you want. -->
        <!-- it will be placed in the HEAD section of the XHTML. -->
        <xsl:value-of select="$newline"/>
        <xsl:comment> saved from url=(0014)about:internet </xsl:comment>
        <xsl:value-of select="$newline"/>
        <!-- Add in the favicon. -->
        <!--        <link rel="shortcut icon" href="images/scriptorium.ico"/>-->
        <xsl:value-of select="$newline"/>
        <!-- And HTML5 Shiv for IE. //html5shiv.googlecode.com/svn/trunk/html5.js-->
        <!--<xsl:comment>[if lt IE 9]&gt;
           &lt;script src="http://html5shiv.googlecode.com/svn/trunk/html5.js"&gt;&lt;/script&gt;
        &lt;![endif]</xsl:comment>-->
        <xsl:value-of select="$newline"/>

        <!--<xsl:comment>[scale override for mobile Safari]</xsl:comment>
        <xsl:value-of select="$newline"/>
        <meta name="viewport" content="width=device-width; initial-scale=1.0"/>-->

    </xsl:template>

    <xsl:template match="*" mode="chapterHead">
        <head>
            <xsl:value-of select="$newline"/>
            <!-- initial meta information -->
            <xsl:call-template name="generateCharset"/>
            <!-- Set the character set to UTF-8 -->
            <xsl:call-template name="generateDefaultCopyright"/>
            <!-- Generate a default copyright, if needed -->
            <xsl:call-template name="generateDefaultMeta"/>
            <!-- Standard meta for security, robots, etc -->
            <xsl:call-template name="getMeta"/>
            <!-- Process metadata from topic prolog -->
            <xsl:call-template name="copyright"/>
            <!-- Generate copyright, if specified manually -->
            <xsl:call-template name="generateCssLinks"/>
            <!-- Generate links to CSS files -->
            <xsl:call-template name="generateChapterTitle"/>
            <!-- Generate the <title> element -->
            <xsl:call-template name="gen-user-head"/>
            <!-- include user's XSL HEAD processing here -->
            <xsl:call-template name="gen-user-scripts"/>
            <!-- include user's XSL javascripts here -->
            <xsl:call-template name="gen-user-styles"/>
            <!-- include user's XSL style element and content here -->
            <xsl:call-template name="processHDF"/>
            <!-- Add user HDF file, if specified -->
        </head>
        <xsl:value-of select="$newline"/>
    </xsl:template>

    <xsl:template name="chapterBody_xhtml">
        <xsl:apply-templates select="." mode="chapterBody_xhtml"/>
    </xsl:template>

    <xsl:template match="*" mode="chapterBody_xhtml">
        <xsl:variable name="flagrules">
            <xsl:call-template name="getrules"/>
        </xsl:variable>
        <xsl:variable name="conflictexist">
            <xsl:call-template name="conflict-check">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="thisfile">
            <xsl:value-of select="concat($WORKDIR, '-', $FILENAME)"/>
        </xsl:variable>
        <!-- [SP] The topic might be wrapped in a <dita> tag.  -->
        <xsl:variable name="my_id">
            <xsl:value-of select="descendant-or-self::*[@id][1]/@id"/>
        </xsl:variable>

        <!-- [SP] If the transtype is sps_help, set the content of the onload attribute. -->
        <xsl:variable name="unix_path2proj" select="translate($PATH2PROJ, '\', '/')"/>

        <!-- [SP] Set the body attributes. -->
        <!--<body bgcolor="white" text="black" link="blue" vlink="#840084" alink="blue"
            onload="javascript:check_nav();">-->
        <xsl:element name="body">
            <!--<xsl:attribute name="onload">javascript:make_cookie();get_current_link();check_nav();width_query();</xsl:attribute>-->
            <xsl:if test="not(contains($TRANSTYPE, 'scorm1.2'))">
                <xsl:attribute name="onload">javascript:init();</xsl:attribute>
            </xsl:if>


            <!--<xsl:copy-of select="$prev_next"/>-->
            <!-- Already put xml:lang on <html>; do not copy to body with commonattributes -->
            <xsl:call-template name="gen-style">
                <xsl:with-param name="conflictexist" select="$conflictexist"/>
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
            <xsl:call-template name="setidaname"/>
            <xsl:value-of select="$newline"/>
            <xsl:call-template name="start-flagit">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
            <xsl:call-template name="start-revflag">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
            <!-- [SP] This was a DITA-OT breadcrumb call. -->
            <!-- <xsl:call-template name="generateBreadcrumbs"/> -->


            <!-- ########################################
                [SP] header code begin -->

            <!-- [SP] scriptorium includes -->
            <xsl:if test="not(contains($TRANSTYPE, 'scorm1.2'))">
                <xsl:comment> scriptorium - HEADER BEGIN </xsl:comment>
                <xsl:value-of select="$newline"/>
                <xsl:comment>#include virtual="/header.htm"</xsl:comment>
                <xsl:value-of select="$newline"/>
                <xsl:comment> scriptorium -  HEADER END </xsl:comment>
                <xsl:value-of select="$newline"/>
            </xsl:if>

            <!-- ########################################
                [SP] header code end -->

            <xsl:call-template name="gen-user-header"/>
            <!-- include user's XSL running header here -->

            <!-- [SP] add pre-next links to body top -->
            <!--<xsl:call-template name="prev-next"/>-->

            <!-- [SP] More approriately placed breadcrumb call. -->
            <xsl:if test="not(contains($TRANSTYPE, 'scorm1.2'))">
                <xsl:call-template name="breadcrumbs"/>
            </xsl:if>


            <!-- [SP] logo -->
            <!--<div class="logo">-->

            <!-- [SP] subdirs mods -->
            <!-- <img src="images/logo.png" width="150" />-->

            <!--    <p class="login">
                    <a href="link.html">Customer login</a>
                </p>
            </div>-->

            <!-- Include a user's XSL call here to generate a toc based on what's a child of topic -->
            <!-- [SP] Used to insert the nav section on the left side of the page. -->
            <!-- [SP] print page -->
            <!--<p id="print_this" onclick="javascript:window.print();">Print this page</p>-->
            <xsl:if test="not(contains($TRANSTYPE, 'scorm1.2'))">
                <div class="print_email">
                    <p class="print_this">
                        <a href="javascript:window.print();">
                            <!--<img src="{$PATH2PROJ}images/printer_small.png" alt="Print this page"/>-->
                            <img src="{$PATH2PROJ}images/printer_small.png" alt="Print this page"
                            />Print this page</a>
                    </p>
                    <!--<br/>-->
                    <xsl:variable name="book_title">
                        <xsl:call-template name="get_map_title"/>
                    </xsl:variable>

                    <xsl:variable name="chapter_title">
                        <xsl:apply-templates select="title" mode="crumbs"/>
                        <!--<xsl:call-template name="generateChapterTitle"/>-->
                    </xsl:variable>


                    <xsl:variable name="mail_to_href"
                        select="concat('javascript:email_this(&quot;', $book_title, ': ', $chapter_title, '&quot;)')"/>
                    <p class="mail_this">
                        <!--<a href="{$mail_to_href}"><img src="{$PATH2PROJ}images/envelope_small.png" alt="Email this topic"/>Email this topic</a>-->
                        <a href="{$mail_to_href}">
                            <!--<img src="{$PATH2PROJ}images/envelope_small.png"
                            alt="Email this topic"/>-->
                            <img src="{$PATH2PROJ}images/envelope_small.png" alt="Email this topic"
                            />Email this topic</a>
                    </p>
                </div>
            </xsl:if>

            <xsl:call-template name="gen-user-sidetoc"/>

            <!-- [SP] More approriately placed breadcrumb call. -->
            <!--<xsl:call-template name="breadcrumbs"/>-->
            <!-- [SP] <section id="main_body"> -->
            <div class="section_cont" id="main_body">
                <xsl:apply-templates/>
                <!-- this will include all things within topic; therefore, -->
                <!-- title content will appear here by fall-through -->
                <!-- followed by prolog (but no fall-through is permitted for it) -->
                <!-- followed by body content, again by fall-through in document order -->
                <!-- followed by related links -->
                <!-- followed by child topics by fall-through -->
                <!-- [SP] If the topic has outputclass trademark, insert the revision history list. -->
                <xsl:if
                    test="ancestor-or-self::*[contains(@class, ' topic/topic ') and starts-with(@outputclass, 'trademark')]">
                    <xsl:call-template name="revision-history"/>
                </xsl:if>
                <xsl:if test="//fn">
                    <hr/>
                </xsl:if>

                <xsl:call-template name="gen-endnotes"/>
                <!-- [SP] </section> -->
            </div>

            <!--<xsl:call-template name="gen-endnotes"/>-->
            <!-- include footnote-endnotes -->
            <xsl:call-template name="gen-user-footer"/>
            <!-- include user's XSL running footer here -->
            <xsl:call-template name="processFTR"/>
            <!-- Include XHTML footer, if specified -->
            <xsl:call-template name="end-revflag">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
            <xsl:call-template name="end-flagit">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>

            <!--</body>-->
        </xsl:element>
        <xsl:value-of select="$newline"/>
    </xsl:template>



    <!-- [SP] Insert the sidebar and TOC. -->
    <!--<xsl:variable name="toc_file" select="concat('FILE:///',$OUTPUTDIR,'\index.html')"/>-->
    <!-- [SP] 01-Feb-2013: Must generalize file separator. -->
    <xsl:variable name="toc_file"
        select="concat('FILE:///', $OUTPUTDIR, $file.separator, 'index.shtml')"/>

    <!-- [SP] 29-Jan-2013: Split processing for epub and xhtml. -->

    <xsl:template name="gen-user-sidetoc">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'kpe_xhtml'">
                <xsl:apply-templates select="." mode="gen-user-sidetoc-xhtml"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:apply-templates select="." mode="gen-user-sidetoc-sepub3"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="gen-user-sidetoc-xhtml"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="gen-user-sidetoc-xhtml">

        <!-- <xsl:message>
            ##### toc_file is : <xsl:value-of select="$toc_file"/>
        </xsl:message>-->

        <div class="sidebar" id="sidebar">
            <div class="box open" id="sidebar_box">
                <div id="nav_handle" title="Click to hide" onclick="menu_toggle()">

                    <!-- [SP] subdirs mods -->
                    <!-- ORIGINAL <img id="nav_handle_img" src="images/nav_handle_small.png" alt="click to hide"/> -->
                    <!-- [SP] toc_copier -->
                    <!--<img id="nav_handle_img" alt="click to hide">
                        <xsl:attribute name="src">

                            <xsl:value-of select="concat($PATH2PROJ,'images/nav_handle_small.png')"
                            />
                        </xsl:attribute>
                    </img>-->
                    <div id="nav_handle_img" title="click to hide">
                        <xsl:text>  </xsl:text>
                    </div>

                </div>
                <!-- [SP] changed to avoid id conflict with scriptorium main.css -->
                <!--<nav class="sections" id="navigation">-->
                <!-- [SP] <nav class="sections" id="side_navigation"> -->
                <div class="sections" id="side_navigation">
                    <!-- TODO: Generalize this so the file name is passed in as a parameter. -->
                    <!-- [SP] toc_copier <xsl:variable name="toc_file"
                        select="concat('FILE:///',$OUTPUTDIR,'\index.html')"/>
                        <xsl:copy-of select="document($toc_file)"/> -->
                    <!--<xsl:variable name="toc_depth">
                        <xsl:choose>
                            <xsl:when test="$page_level = '0'">
                                <xsl:value-of select="''"/>                                
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat('_',$page_level)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="toc_file"
                        select="concat('FILE:///',$OUTPUTDIR,'\index',$toc_depth,'.html')"/>
                    <xsl:copy-of select="document($toc_file)"/>-->
                    <!-- [SP] Pull in the TOC from the toc file, fixing up the hrefs to link appropriately (toc_copy). -->
                    <!--                    <xsl:apply-templates select="document($toc_file)/node()|document($toc_file)/@*" mode="toc_copy"/>-->
                    <!-- [SP] 20-Feb-2013: Don't include TOC, SSI instead. -->
                    <!--                    <xsl:value-of select="$newline"/>
                    <xsl:comment>scriptorium - TOC BEGIN</xsl:comment>
                    <xsl:value-of select="$newline"/>
                    <xsl:comment>#include file="<xsl:value-of select="concat($PATH2PROJ,$VOLNAME,'toc.html')"/>" </xsl:comment>
                    <xsl:value-of select="$newline"/>
                    <xsl:comment>scriptorium - TOC END</xsl:comment>
                    <xsl:value-of select="$newline"/>
-->
                </div>

                <!-- [SP] 27-Feb-2013: Evaluating how to group under SSI.
                    Depends on how much behavior is derived from these divs.
                    It might be a simple matter of moving things, or it could be more complicated.
               -->

                <div class="pdflink">
                    <p>
                        <img alt="View PDF">
                            <xsl:attribute name="src">

                                <!-- [SP] pdf href mods -->
                                <xsl:value-of select="$PATH2PROJ"/>
                                <!--<xsl:value-of select="concat('../',$PATH2PROJ)"/>-->
                                <xsl:call-template name="getString">
                                    <xsl:with-param name="stringName" select="'PDF_icon'"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </img>
                        <xsl:call-template name="get_pdf_href"/>
                    </p>
                </div>

                <!-- [SP] epub href mods -->
                <div class="epublink">
                    <p>
                        <img alt="Download EPUB">
                            <xsl:attribute name="src">
                                <xsl:value-of select="$PATH2PROJ"/>
                                <!--<xsl:value-of select="concat('../',$PATH2PROJ)"/>-->
                                <xsl:call-template name="getString">
                                    <xsl:with-param name="stringName" select="'EPUB_icon'"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </img>
                        <xsl:call-template name="get_epub_href"/>
                    </p>
                </div>

                <!--<div class="search">
                    <form>
                        <input type="search" title="Search" size="25" placeholder="search"/>
                        <br/>
                        <select>
                            <option value="document">In this document</option>
                            <option value="all">In all documents</option>
                        </select>
                        <input class="search" type="submit" value="Search"/>
                    </form>
                </div>-->
            </div>
            <!-- [SP] Create a button to toggle the SI/Common units. -->
            <!--<div class="unittoggle">
                <form>
                    <button type="button" onclick="toggle_units()" id="unit_button">
                        <xsl:call-template name="getString">
                            <xsl:with-param name="stringName" select="'Units_US'"/>
                        </xsl:call-template>
                    </button>
                </form>
            </div>-->
        </div>

    </xsl:template>

    <!-- [SP] toc-copying -->
    <xsl:template match="node() | @*" mode="toc_copy">
        <!-- [SP] start each li on a new line. -->
        <xsl:choose>
            <xsl:when test="name(.) = 'li'">
                <xsl:value-of select="$newline"/>
            </xsl:when>
        </xsl:choose>
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="toc_copy"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@href" mode="toc_copy">
        <xsl:variable name="parent_string">
            <xsl:call-template name="path_to_root">
                <xsl:with-param name="counter" select="$page_level"/>
                <xsl:with-param name="parent_path"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:attribute name="href">
            <!-- [SP] 22-Feb-2013: While testing, turn off concat. -->
            <xsl:value-of select="."/>
            <!--            <xsl:value-of select="concat($parent_string,.)"/>-->
        </xsl:attribute>
    </xsl:template>

    <!--<xsl:template match="@shape" mode="toc_copy"/>-->

    <xsl:template match="text()" mode="toc_copy" priority="2">
        <xsl:copy-of select="translate(., '&nbsp;“”', ' &quot;&quot;')"/>
    </xsl:template>
    <!-- [SP] end toc-copying -->

    <xsl:template match="*[contains(@class, ' topic/body ')]" name="topic.body">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:apply-templates select="." mode="body.sepub3"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'kpe_xhtml'">
                <xsl:apply-templates select="." mode="body.kpe_xhtml"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="body.kpe_xhtml"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- [SP] Override to eliminate div. -->
    <xsl:template match="*[contains(@class, ' topic/body ')]" mode="body.kpe_xhtml">

        <!-- here, you can generate a toc based on what's a child of body -->
        <!--xsl:call-template name="gen-sect-ptoc"/-->
        <!-- Works; not always wanted, though; could add a param to enable it.-->

        <!-- Insert prev/next links. since they need to be scoped by who they're 'pooled' with, apply-templates in 'hierarchylink' mode to linkpools (or related-links itself) when they have children that have any of the following characteristics:
       - role=ancestor (used for breadcrumb)
       - role=next or role=previous (used for left-arrow and right-arrow before the breadcrumb)
       - importance=required AND no role, or role=sibling or role=friend or role=previous or role=cousin (to generate prerequisite links)
       - we can't just assume that links with importance=required are prerequisites, since a topic with eg role='next' might be required, while at the same time by definition not a prerequisite -->

        <xsl:apply-templates/>
    </xsl:template>

    <!-- called shortdesc processing - para at start of topic -->
    <!-- [SP] Override to eliminate. -->
    <xsl:template match="*[contains(@class, ' topic/shortdesc ')]" mode="outofline">
        <!-- Do nothing. -->
    </xsl:template>


    <!-- NESTED TOPIC TITLES (sensitive to nesting depth, but are still processed for contained markup) -->
    <!-- 1st level - topic/title -->
    <!-- Condensed topic title into single template without priorities; use $headinglevel to set heading.
     If desired, somebody could pass in the value to manually set the heading level -->
    <!-- [SP] Overridden to eliminate class name. -->
    <!-- [SP] 11-Mar-2013: Handle transtype conflicts. -->
    <xsl:template match="*[contains(@class, ' topic/topic ')]/*[contains(@class, ' topic/title ')]">
        <xsl:param name="headinglevel">
            <xsl:choose>
                <xsl:when test="count(ancestor::*[contains(@class, ' topic/topic ')]) > 6"
                    >6</xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(ancestor::*[contains(@class, ' topic/topic ')])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:param>
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:apply-templates select="." mode="topic_title_sepub3">
                    <xsl:with-param name="headinglevel" select="$headinglevel"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:comment>calling topic_title_xhtml</xsl:comment>
                <xsl:apply-templates select="." mode="topic_title_xhtml">
                    <xsl:with-param name="headinglevel" select="$headinglevel"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/title ')]" mode="topic_title_xhtml">
        <xsl:param name="headinglevel"/>
        <xsl:element name="h{$headinglevel}">

            <!--            <xsl:attribute name="class">topictitle<xsl:value-of select="$headinglevel"/></xsl:attribute>-->
            <xsl:call-template name="commonattributes">
                <!--                <xsl:with-param name="default-output-class">topictitle<xsl:value-of select="$headinglevel"/></xsl:with-param>-->
            </xsl:call-template>
            <xsl:if test="$headinglevel = '1'">
                <!-- [SP] 27-Mar-2013: Pick up new from the topic itself, not the map. -->
                <xsl:if
                    test="ancestor-or-self::*[contains(@class, ' topic/topic ') and contains(@status, 'new')]">
                    <!--<xsl:if test="contains(document(concat('file:///',$MAPFILE))//*[contains(@href,$FILENAME)]/@status,'new')">-->
                    <xsl:message> ***** This topic is new. ***** </xsl:message>
                    <img alt="New topic" src="{concat($PATH2PROJ,'images/New_Command.png')}"
                        width="40px" height="40px"/>
                </xsl:if>
            </xsl:if>

            <xsl:apply-templates/>
        </xsl:element>
        <xsl:value-of select="$newline"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/p ')]">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'sps_help'">
                <!--                <xsl:apply-templates select="." mode="p.sps_help"/>-->
                <xsl:apply-templates select="." mode="p.kpe_xhtml"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'kpe_xhtml'">
                <xsl:apply-templates select="." mode="p.kpe_xhtml"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:apply-templates select="." mode="p.sepub3"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="p.kpe_xhtml"/>
            </xsl:otherwise>
            <!--            <xsl:otherwise>
                <xsl:apply-templates select="." mode="p.kpe_xhtml"/>
            </xsl:otherwise>-->
        </xsl:choose>

    </xsl:template>


    <!-- [SP] Basic paragraph template. Overrides adds code to handle <p>s in <dd>, twisties, and notes. -->
    <xsl:template match="*[contains(@class, ' topic/p ')]" mode="p.kpe_xhtml" name="topic.p">
        <xsl:variable name="flagrules">
            <xsl:call-template name="getrules"/>
        </xsl:variable>
        <xsl:variable name="conflictexist">
            <xsl:call-template name="conflict-check">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
        </xsl:variable>
        <!-- To ensure XHTML validity, need to determine whether the DITA kids are block elements.
            If so, use div_class="p" instead of p -->
        <xsl:choose>
            <!-- [SP] Look for the first <p> in the first <dd> (without any text nodes before it). -->
            <xsl:when
                test="
                    parent::*[contains(@class, ' topic/dd ')][1] and
                    count(preceding-sibling::*[contains(@class, ' topic/p ')]) = 0 and
                    count(preceding-sibling::text()[normalize-space(.) != '']) = 0">
                <p>
                    <xsl:call-template name="setidaname"/>
                    <xsl:call-template name="start-flagit">
                        <xsl:with-param name="flagrules" select="$flagrules"/>
                    </xsl:call-template>
                    <xsl:call-template name="revblock">
                        <xsl:with-param name="flagrules" select="$flagrules"/>
                    </xsl:call-template>
                    <xsl:call-template name="end-flagit">
                        <xsl:with-param name="flagrules" select="$flagrules"/>
                    </xsl:call-template>
                </p>
            </xsl:when>
            <!-- [SP] Addition to handle notes. -->
            <!-- The first <p> element in a note gets the appropriate admonition text.  Subsequent paragraphs are handled by themselves. -->
            <!--                <xsl:when test="parent::*[contains(@class,' topic/note ')] and count(preceding-sibling::*[contains(@class,' topic/p ')]) = 0">-->
            <xsl:when
                test="parent::*[contains(@class, ' topic/note ')] and @outputclass = 'notetitle'">
                <xsl:variable name="type">
                    <xsl:choose>
                        <xsl:when test="parent::*[contains(@class, ' topic/note ')]/@type">
                            <xsl:value-of select="parent::*[contains(@class, ' topic/note ')]/@type"
                            />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'note'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <p class="{$type}title">
                    <xsl:call-template name="setidaname"/>
                    <xsl:call-template name="gen-style">
                        <xsl:with-param name="conflictexist" select="$conflictexist"/>
                        <xsl:with-param name="flagrules" select="$flagrules"/>
                    </xsl:call-template>
                    <xsl:call-template name="start-flagit">
                        <xsl:with-param name="flagrules" select="$flagrules"/>
                    </xsl:call-template>
                    <!-- [SP] Find the note type and display the admonition text -->
                    <xsl:call-template name="show-admonition"/>
                    <xsl:call-template name="revblock">
                        <xsl:with-param name="flagrules" select="$flagrules"/>
                    </xsl:call-template>
                    <xsl:call-template name="end-flagit">
                        <xsl:with-param name="flagrules" select="$flagrules"/>
                    </xsl:call-template>
                </p>
            </xsl:when>

            <xsl:when
                test="
                    descendant::*[contains(@class, ' topic/pre ')] or
                    descendant::*[contains(@class, ' topic/screen ')] or
                    descendant::*[contains(@class, ' topic/ul ')] or
                    descendant::*[contains(@class, ' topic/sl ')] or
                    descendant::*[contains(@class, ' topic/ol ')] or
                    descendant::*[contains(@class, ' topic/lq ')] or
                    descendant::*[contains(@class, ' topic/dl ')] or
                    descendant::*[contains(@class, ' topic/note ')] or
                    descendant::*[contains(@class, ' topic/lines ')] or
                    descendant::*[contains(@class, ' topic/fig ')] or
                    descendant::*[contains(@class, ' topic/table ')] or
                    descendant::*[contains(@class, ' topic/simpletable ')]">
                <div class="p">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:call-template name="setidaname"/>
                    <xsl:call-template name="gen-style">
                        <xsl:with-param name="conflictexist" select="$conflictexist"/>
                        <xsl:with-param name="flagrules" select="$flagrules"/>
                    </xsl:call-template>
                    <xsl:call-template name="start-flagit">
                        <xsl:with-param name="flagrules" select="$flagrules"/>
                    </xsl:call-template>
                    <xsl:call-template name="revblock">
                        <xsl:with-param name="flagrules" select="$flagrules"/>
                    </xsl:call-template>
                    <xsl:call-template name="end-flagit">
                        <xsl:with-param name="flagrules" select="$flagrules"/>
                    </xsl:call-template>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:call-template name="commonattributes"/>
                    <xsl:call-template name="setidaname"/>
                    <xsl:call-template name="gen-style">
                        <xsl:with-param name="conflictexist" select="$conflictexist"/>
                        <xsl:with-param name="flagrules" select="$flagrules"/>
                    </xsl:call-template>
                    <xsl:call-template name="start-flagit">
                        <xsl:with-param name="flagrules" select="$flagrules"/>
                    </xsl:call-template>
                    <xsl:call-template name="revblock">
                        <xsl:with-param name="flagrules" select="$flagrules"/>
                    </xsl:call-template>
                    <xsl:call-template name="end-flagit">
                        <xsl:with-param name="flagrules" select="$flagrules"/>
                    </xsl:call-template>
                </p>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$newline"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/note ')]">
        <xsl:apply-templates select="." mode="note.kpe_xhtml"/>
        <!--        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:apply-templates select="." mode="note_sepub3"/>
            </xsl:when>
            <!-\-            <xsl:when test="$TRANSTYPE = 'sps_help'">
                
            </xsl:when>-\->
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="note.kpe_xhtml"/>
            </xsl:otherwise>
        </xsl:choose>-->
    </xsl:template>

    <!-- Fixed SF Bug 1405184 "Note template for XHTML should be easier to override" -->
    <!-- RFE 2703335 reduces duplicated code by adding common processing rules.
     To override all notes, match the note element's class attribute directly, as in this rule.
     To override a single note type, match the class with mode="process.note.(selected-type)"
     To override all notes except danger and caution, match the class with mode="process.note.common-processing" -->
    <xsl:template match="*[contains(@class, ' topic/note ')]" mode="note.kpe_xhtml">
        <xsl:call-template name="spec-title"/>
        <xsl:choose>
            <xsl:when test="@type = 'note'">
                <xsl:apply-templates select="." mode="process.note"/>
            </xsl:when>
            <xsl:when test="@type = 'tip'">
                <xsl:apply-templates select="." mode="process.note.tip"/>
            </xsl:when>
            <xsl:when test="@type = 'fastpath'">
                <xsl:apply-templates select="." mode="process.note.fastpath"/>
            </xsl:when>
            <xsl:when test="@type = 'important'">
                <xsl:apply-templates select="." mode="process.note.important"/>
            </xsl:when>
            <xsl:when test="@type = 'remember'">
                <xsl:apply-templates select="." mode="process.note.remember"/>
            </xsl:when>
            <xsl:when test="@type = 'restriction'">
                <xsl:apply-templates select="." mode="process.note.restriction"/>
            </xsl:when>
            <xsl:when test="@type = 'attention'">
                <xsl:apply-templates select="." mode="process.note.attention"/>
            </xsl:when>
            <xsl:when test="@type = 'caution'">
                <xsl:apply-templates select="." mode="process.note.caution"/>
            </xsl:when>
            <xsl:when test="@type = 'danger'">
                <xsl:apply-templates select="." mode="process.note.danger"/>
            </xsl:when>
            <xsl:when test="@type = 'warning'">
                <xsl:apply-templates select="." mode="process.note.warning"/>
            </xsl:when>
            <xsl:when test="@type = 'other'">
                <xsl:apply-templates select="." mode="process.note.other"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="process.note"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="$newline"/>
    </xsl:template>

    <!-- [SP] Add the admonition text to a note.  Context is note/p. -->
    <xsl:template name="show-admonition">
        <xsl:variable name="type"
            select="ancestor-or-self::*[contains(@class, ' topic/note ')][1]/@type"/>
        <xsl:variable name="othertype"
            select="ancestor-or-self::*[contains(@class, ' topic/note ')][1]/@othertype"/>
        <xsl:choose>
            <xsl:when test="$type = 'note'">
                <span class="admonition">
                    <xsl:call-template name="getString">
                        <xsl:with-param name="stringName" select="'Note'"/>
                    </xsl:call-template>
                </span>
                <!--<xsl:text>&#160;&#160;</xsl:text>-->
                <xsl:text>  </xsl:text>
            </xsl:when>
            <xsl:when test="$type = 'tip'">
                <span class="admonition">
                    <xsl:call-template name="getString">
                        <xsl:with-param name="stringName" select="'Tip'"/>
                    </xsl:call-template>
                </span>
                <!--<xsl:text>&#160;&#160;</xsl:text>-->
                <xsl:text>  </xsl:text>
            </xsl:when>
            <xsl:when test="$type = 'important'">
                <span class="admonition">
                    <xsl:call-template name="getString">
                        <xsl:with-param name="stringName" select="'Important'"/>
                    </xsl:call-template>
                </span>
                <!--<xsl:text>&#160;&#160;</xsl:text>-->
                <xsl:text>  </xsl:text>
            </xsl:when>
            <xsl:when test="$type = 'caution'">
                <span class="admonition">
                    <xsl:call-template name="getString">
                        <xsl:with-param name="stringName" select="'Caution'"/>
                    </xsl:call-template>
                </span>
                <!--<xsl:text>&#160;&#160;</xsl:text>-->
                <xsl:text>  </xsl:text>
            </xsl:when>
            <xsl:when test="$type = 'warning'">
                <span class="admonition">
                    <xsl:call-template name="getString">
                        <xsl:with-param name="stringName" select="'Warning'"/>
                    </xsl:call-template>
                </span>
                <!--<xsl:text>&#160;&#160;</xsl:text>-->
                <xsl:text>  </xsl:text>
            </xsl:when>
            <xsl:when test="$othertype = 'warning'">
                <span class="admonition">
                    <xsl:call-template name="getString">
                        <xsl:with-param name="stringName" select="'Warning'"/>
                    </xsl:call-template>
                </span>
                <!--<xsl:text>&#160;&#160;</xsl:text>-->
                <xsl:text>  </xsl:text>
            </xsl:when>
            <!-- Standard note (no type attribute specified). -->
            <xsl:otherwise>
                <xsl:message>kpe-XHTML ******** Unrecognized admonition type "<xsl:value-of
                        select="$type"/>"</xsl:message>
                <!-- Note doesn't get admonition text. -->
                <!--                <span class="admonition">
                    <xsl:call-template name="getString">
                        <xsl:with-param name="stringName" select="'Note'"/>
                    </xsl:call-template>
                </span><xsl:text>&#160;&#160;</xsl:text>-->
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!-- [SP] Override to remove style on ul. -->
    <xsl:template match="*[contains(@class, ' topic/ul ')]" mode="ul-fmt">
        <xsl:variable name="flagrules">
            <xsl:call-template name="getrules"/>
        </xsl:variable>
        <!-- edited by William on 2009-06-16 for bullet bug:2782503 start-->
        <!--br/-->
        <!-- edited by William on 2009-06-16 for bullet bug:2782503 end-->

        <xsl:call-template name="start-flagit">
            <xsl:with-param name="flagrules" select="$flagrules"/>
        </xsl:call-template>
        <xsl:call-template name="start-revflag">
            <xsl:with-param name="flagrules" select="$flagrules"/>
        </xsl:call-template>
        <ul>
            <!-- [SP] remove style. 
                25-Apr-2013. Not sure why this was done. Class ul is needed by epub. -->
            <!--
            <xsl:call-template name="commonattributes"/> -->
            <xsl:attribute name="class">ul</xsl:attribute>
            <xsl:call-template name="gen-style">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
            <xsl:apply-templates select="@compact"/>
            <xsl:call-template name="setid"/>
            <xsl:apply-templates/>
        </ul>
        <xsl:call-template name="end-revflag">
            <xsl:with-param name="flagrules" select="$flagrules"/>
        </xsl:call-template>
        <xsl:call-template name="end-flagit">
            <xsl:with-param name="flagrules" select="$flagrules"/>
        </xsl:call-template>
        <xsl:value-of select="$newline"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/ol ')]">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'sps_help'">
                <xsl:apply-templates select="." mode="ol.sps_help"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'kpe_xhtml'">
                <xsl:apply-templates select="." mode="ol.kpe_xhtml"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:apply-templates select="." mode="ol.sepub3"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="ol.kpe_xhtml"/>
            </xsl:otherwise>
            <!--            <xsl:otherwise>
                <xsl:apply-templates select="." mode="ol.kpe_xhtml"/>
            </xsl:otherwise>-->
        </xsl:choose>

    </xsl:template>

    <!-- [SP] Ditto for <ol>s. -->
    <!-- Ordered List - 1st level - Handle levels 1 to 9 thru OL-TYPE attribution -->
    <!-- Updated to use a single template, use count and mod to set the list type -->
    <xsl:template match="*[contains(@class, ' topic/ol ')]" mode="ol.kpe_xhtml">
        <!-- [SP] Added test for db.procedure, if so, this is a big NOP. -->
        <xsl:if test="not(@outputclass) or (@outputclass and @outputclass != 'db.procedure')">
            <xsl:variable name="flagrules">
                <xsl:call-template name="getrules"/>
            </xsl:variable>
            <xsl:variable name="conflictexist">
                <xsl:call-template name="conflict-check">
                    <xsl:with-param name="flagrules" select="$flagrules"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="olcount"
                select="count(ancestor-or-self::*[contains(@class, ' topic/ol ')])"/>
            <!-- The offending line.  -->
            <!--<br/>-->
            <xsl:call-template name="start-flagit">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
            <xsl:call-template name="start-revflag">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
            <xsl:call-template name="setaname"/>
            <ol>
                <xsl:call-template name="commonattributes"/>
                <xsl:call-template name="gen-style">
                    <xsl:with-param name="conflictexist" select="$conflictexist"/>
                    <xsl:with-param name="flagrules" select="$flagrules"/>
                </xsl:call-template>
                <xsl:apply-templates select="@compact"/>
                <xsl:choose>
                    <xsl:when test="$olcount mod 3 = 1"/>
                    <xsl:when test="$olcount mod 3 = 2">
                        <xsl:attribute name="type">a</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="type">i</xsl:attribute>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:call-template name="setid"/>
                <xsl:apply-templates/>
            </ol>
            <xsl:call-template name="end-revflag">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
            <xsl:call-template name="end-flagit">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
            <xsl:value-of select="$newline"/>

        </xsl:if>
    </xsl:template>

    <!-- [SP] Override section processing. -->
    <!-- section processor - div with no generated title -->
    <xsl:template match="*[contains(@class, ' topic/section ')]" name="topic.section">
        <xsl:variable name="flagrules">
            <xsl:call-template name="getrules"/>
        </xsl:variable>

        <!-- [SP] <section> -->
        <div>
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="$TRANSTYPE = 'sepub3'">
                        <xsl:text>section</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>section_cont</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <!--            <xsl:call-template name="commonattributes"/>-->
            <xsl:call-template name="gen-style">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
            <xsl:call-template name="gen-toc-id"/>
            <xsl:call-template name="setidaname"/>
            <xsl:call-template name="start-flagit">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
            <xsl:variable name="revtest">
                <xsl:if test="@rev and not($FILTERFILE = '') and ($DRAFT = 'yes')">
                    <xsl:call-template name="find-active-rev-flag">
                        <xsl:with-param name="allrevs" select="@rev"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$revtest = 1">
                    <!-- Rev is active - add the DIV -->
                    <div class="{@rev}">
                        <xsl:apply-templates select="." mode="section-fmt"/>
                    </div>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Rev wasn't active - process normally -->
                    <xsl:apply-templates select="." mode="section-fmt"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="end-flagit">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
            <!-- [SP] </section> -->
        </div>
        <xsl:value-of select="$newline"/>
    </xsl:template>

    <!-- [SP] Override section title processing. -->
    <xsl:template
        match="*[contains(@class, ' topic/section ')]/*[contains(@class, ' topic/title ')]"
        name="topic.section_title">
        <h2>
            <xsl:apply-templates/>
        </h2>

        <!--        <xsl:param name="headLevel">
            <xsl:variable name="headCount">
                <xsl:value-of select="count(ancestor::*[contains(@class,' topic/topic ')])+1"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$headCount > 6">h6</xsl:when>
                <xsl:otherwise>h<xsl:value-of select="$headCount"/></xsl:otherwise>
            </xsl:choose>
        </xsl:param>
        <xsl:element name="{$headLevel}">
            <xsl:attribute name="class">sectiontitle</xsl:attribute>
            <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class" select="'sectiontitle'"/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </xsl:element>-->
    </xsl:template>
    <!--    <!-\- [SP] Override section title processing. -\->
    <xsl:template
        match="*[contains(@class,' topic/example ')]/*[contains(@class,' topic/title ')]"
        name="topic.section_title">
        <xsl:param name="headLevel">
            <xsl:variable name="headCount">
                <xsl:value-of select="count(ancestor::*[contains(@class,' topic/topic ')])+1"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$headCount > 6">h6</xsl:when>
                <xsl:otherwise>h<xsl:value-of select="$headCount"/></xsl:otherwise>
            </xsl:choose>
        </xsl:param>
        <xsl:element name="{$headLevel}">
            <xsl:attribute name="class">sectiontitle</xsl:attribute>
            <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class" select="'sectiontitle'"/>
            </xsl:call-template>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>-->

    <!-- [SP] Handle the table cell attributes.  -->
    <!-- TODO may not need this for scriptorium. -->
    <xsl:template name="doentry">
        <xsl:variable name="this-colname">
            <xsl:value-of select="@colname"/>
        </xsl:variable>
        <!-- Rowsep/colsep: Skip if the last row or column. Only check the entry and colsep;
            if set higher, will already apply to the whole table. -->

        <xsl:variable name="flagrules">
            <xsl:call-template name="getrules"/>
            <xsl:call-template name="getrules-parent"/>
        </xsl:variable>

        <xsl:variable name="framevalue">
            <xsl:choose>
                <xsl:when
                    test="ancestor::*[contains(@class, ' topic/table ')][1]/@frame and ancestor::*[contains(@class, ' topic/table ')][1]/@frame != ''">
                    <xsl:value-of select="ancestor::*[contains(@class, ' topic/table ')][1]/@frame"
                    />
                </xsl:when>
                <xsl:otherwise>all</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="rowsep">
            <xsl:choose>
                <!-- If there are more rows, keep rows on -->
                <xsl:when test="not(../following-sibling::*)">
                    <xsl:choose>
                        <xsl:when
                            test="$framevalue = 'all' or $framevalue = 'bottom' or $framevalue = 'topbot'"
                            >1</xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@rowsep">
                    <xsl:value-of select="@rowsep"/>
                </xsl:when>
                <xsl:when test="../@rowsep">
                    <xsl:value-of select="../@rowsep"/>
                </xsl:when>
                <xsl:when
                    test="@colname and ../../../*[contains(@class, ' topic/colspec ')][@colname = $this-colname]/@rowsep">
                    <xsl:value-of
                        select="../../../*[contains(@class, ' topic/colspec ')][@colname = $this-colname]/@rowsep"
                    />
                </xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="colsep">
            <xsl:choose>
                <!-- If there are more columns, keep rows on -->
                <xsl:when test="not(following-sibling::*)">
                    <xsl:choose>
                        <xsl:when test="$framevalue = 'all' or $framevalue = 'sides'">1</xsl:when>
                        <xsl:otherwise>0</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="@colsep">
                    <xsl:value-of select="@colsep"/>
                </xsl:when>
                <xsl:when
                    test="@colname and ../../../*[contains(@class, ' topic/colspec ')][@colname = $this-colname]/@colsep">
                    <xsl:value-of
                        select="../../../*[contains(@class, ' topic/colspec ')][@colname = $this-colname]/@colsep"
                    />
                </xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- 5/15/09 SL commented, all tables are formatted identically, so class is unnecessary.-->
        <!-- [SP] 26-Apr-2013: That may have been true for one client, but not all clients. Unhiding. -->
        <xsl:choose>
            <xsl:when test="$rowsep = '0' and $colsep = '0'">
                <xsl:attribute name="class">nocellnorowborder</xsl:attribute>
            </xsl:when>
            <xsl:when test="$rowsep = '1' and $colsep = '0'">
                <xsl:attribute name="class">row-nocellborder</xsl:attribute>
            </xsl:when>
            <xsl:when test="$rowsep = '0' and $colsep = '1'">
                <xsl:attribute name="class">cell-norowborder</xsl:attribute>
            </xsl:when>
            <xsl:when test="$rowsep = '1' and $colsep = '1'">
                <xsl:attribute name="class">cellrowborder</xsl:attribute>
            </xsl:when>
        </xsl:choose>

        <xsl:call-template name="commonattributes"/>
        <xsl:if test="@morerows">
            <xsl:attribute name="rowspan">
                <!-- set the number of rows to span -->
                <xsl:value-of select="@morerows + 1"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="@spanname">
            <xsl:attribute name="colspan">
                <!-- get the number of columns to span from the corresponding spanspec -->
                <xsl:call-template name="find-spanspec-colspan"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="@namest and @nameend">
            <!-- get the number of columns to span from the specified named column values -->
            <xsl:attribute name="colspan">
                <xsl:call-template name="find-colspan"/>
            </xsl:attribute>
        </xsl:if>
        <!-- If align is on the tgroup, use it (parent=row, then tbody|thead|tfoot, then tgroup) -->
        <xsl:if test="../../../@align">
            <xsl:attribute name="align">
                <xsl:value-of select="../../../@align"/>
            </xsl:attribute>
        </xsl:if>
        <!-- If align is specified on a colspec or spanspec, that takes priority over tgroup -->
        <xsl:if test="@colname">
            <!-- Removed $this-colname variable, because it is declared above -->
            <xsl:if
                test="../../../*[contains(@class, ' topic/colspec ')][@colname = $this-colname][@align]">
                <xsl:attribute name="align">
                    <xsl:value-of
                        select="../../../*[contains(@class, ' topic/colspec ')][@colname = $this-colname]/@align"
                    />
                </xsl:attribute>
            </xsl:if>
        </xsl:if>
        <xsl:if test="@spanname">
            <xsl:variable name="this-spanname">
                <xsl:value-of select="@spanname"/>
            </xsl:variable>
            <xsl:if
                test="../../../*[contains(@class, ' topic/spanspec ')][@spanname = $this-spanname][@align]">
                <xsl:attribute name="align">
                    <xsl:value-of
                        select="../../../*[contains(@class, ' topic/spanspec ')][@spanname = $this-spanname]/@align"
                    />
                </xsl:attribute>
            </xsl:if>
        </xsl:if>
        <!-- If align is locally specified, that takes priority over all -->
        <xsl:if test="@align">
            <xsl:attribute name="align">
                <xsl:value-of select="@align"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="@char">
            <xsl:attribute name="char">
                <xsl:value-of select="@char"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="@charoff">
            <xsl:attribute name="charoff">
                <xsl:value-of select="@charoff"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:choose>
            <xsl:when test="@valign">
                <xsl:attribute name="valign">
                    <xsl:value-of select="@valign"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="ancestor::*[contains(@class, ' topic/row ')]/@valign">
                <xsl:attribute name="valign">
                    <xsl:value-of select="ancestor::*[contains(@class, ' topic/row ')]/@valign"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="valign">top</xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
        <!-- [SP] 26-Apr-2013: ePub doesn't like width. -->
        <xsl:if
            test="
                ../../../*[contains(@class, ' topic/colspec ')]/@colwidth and
                not(@namest) and not(@nameend) and not(@spanspec) and $TRANSTYPE != 'sepub3'">
            <xsl:variable name="entrypos">
                <!-- Current column -->
                <xsl:call-template name="find-entry-start-position"/>
            </xsl:variable>
            <xsl:variable name="totalwidth">
                <!-- Total width of the column, in units -->
                <xsl:apply-templates select="../../../*[contains(@class, ' topic/colspec ')][1]"
                    mode="count-colwidth"/>
            </xsl:variable>
            <xsl:variable name="thiswidth">
                <!-- Width of this column, in units -->
                <xsl:choose>
                    <xsl:when
                        test="../../../*[contains(@class, ' topic/colspec ')][number($entrypos)]/@colwidth">
                        <xsl:value-of
                            select="substring-before(../../../*[contains(@class, ' topic/colspec ')][number($entrypos)]/@colwidth, '*')"
                        />
                    </xsl:when>
                    <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <!-- Width = width of this column / width of table, times 100 to make a percent -->
            <xsl:attribute name="width">
                <xsl:value-of select="($thiswidth div $totalwidth) * 100"/>
                <xsl:text>%</xsl:text>
            </xsl:attribute>
        </xsl:if>

        <!-- If @rowheader='firstcol' on table, and this entry is in the first column,
            output an ID and the firstcol class -->
        <xsl:if test="../../../../@rowheader = 'firstcol'">
            <xsl:variable name="startpos">
                <xsl:call-template name="find-entry-start-position"/>
            </xsl:variable>
            <xsl:if test="number($startpos) = 1">
                <xsl:attribute name="class">firstcol</xsl:attribute>
                <xsl:attribute name="id">
                    <xsl:value-of select="generate-id(.)"/>
                </xsl:attribute>
            </xsl:if>
        </xsl:if>

        <xsl:choose>
            <!-- When entry is in a thead, output the ID -->
            <xsl:when test="@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="parent::*/parent::*[contains(@class, ' topic/thead ')]">
                <xsl:attribute name="id">
                    <xsl:value-of select="generate-id(.)"/>
                </xsl:attribute>
            </xsl:when>
            <!-- otherwise, add @headers if needed -->
            <xsl:otherwise>
                <xsl:call-template name="add-headers-attribute"/>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:choose>
            <!-- When entry is empty, output a blank -->
            <xsl:when test="not(* | text() | processing-instruction())">
                <xsl:text disable-output-escaping="yes">&amp;#xA0;</xsl:text>
                <!-- nbsp -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="revtest">
                    <xsl:if test="@rev and not($FILTERFILE = '') and ($DRAFT = 'yes')">
                        <xsl:call-template name="find-active-rev-flag">
                            <xsl:with-param name="allrevs" select="@rev"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:variable>
                <xsl:variable name="revtest-row">
                    <xsl:if test="../@rev and not($FILTERFILE = '') and ($DRAFT = 'yes')">
                        <xsl:call-template name="find-active-rev-flag">
                            <xsl:with-param name="allrevs" select="../@rev"/>
                        </xsl:call-template>
                    </xsl:if>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$revtest = 1">
                        <!-- Entry Rev is active - add the span -->
                        <span class="{@rev}">
                            <xsl:call-template name="start-revflag">
                                <xsl:with-param name="flagrules" select="$flagrules"/>
                            </xsl:call-template>
                            <xsl:apply-templates/>
                            <xsl:call-template name="end-revflag">
                                <xsl:with-param name="flagrules" select="$flagrules"/>
                            </xsl:call-template>
                        </span>
                    </xsl:when>
                    <xsl:when test="$revtest-row = 1">
                        <!-- Row Rev is active - add the span -->
                        <span class="{../@rev}">
                            <xsl:call-template name="start-revflag-parent">
                                <xsl:with-param name="flagrules" select="$flagrules"/>
                            </xsl:call-template>
                            <xsl:apply-templates/>
                            <xsl:call-template name="end-revflag-parent">
                                <xsl:with-param name="flagrules" select="$flagrules"/>
                            </xsl:call-template>
                        </span>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Rev wasn't active - process normally -->
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
    <!-- [SP] Overrides for image processing. -->
    <xsl:template name="topic-image">
        <xsl:variable name="ends-with-svg">
            <xsl:call-template name="ends-with">
                <xsl:with-param name="text" select="@href"/>
                <xsl:with-param name="with" select="'.svg'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="ends-with-svgz">
            <xsl:call-template name="ends-with">
                <xsl:with-param name="text" select="@href"/>
                <xsl:with-param name="with" select="'.svgz'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="ends-with-png">
            <xsl:call-template name="ends-with">
                <xsl:with-param name="text" select="@href"/>
                <xsl:with-param name="with" select="'.png'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="svg_name">
            <xsl:choose>
                <xsl:when test="($ends-with-svg = 'true' or $ends-with-svgz = 'true')">
                    <!--<xsl:message>
                    #####
                    ends-with-svg = <xsl:value-of select="$ends-with-svg"/>
                    </xsl:message>-->
                    <!-- [SP] <xsl:value-of select="@href"/> -->
                    <xsl:value-of select="@href"/>
                </xsl:when>
                <xsl:when test="$ends-with-png">
                    <xsl:value-of select="concat(substring-before(@href, '.png'), '.svg')"/>
                    <!--<xsl:value-of select="@href"/>-->
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <!--<a target="image_view">
            <xsl:if test="not(@outputclass) or @outputclass != 'nolink'">
                <xsl:attribute name="href">
                    <xsl:value-of select="$svg_name"/>
        


                </xsl:attribute>
            </xsl:if>
            <xsl:variable name="isSVG" select="$ends-with-svg = 'true' or $ends-with-svgz = 'true'"/>
            <xsl:choose>
                <xsl:when test="$isSVG">
                    <xsl:element name="embed">
                        <xsl:call-template name="commonattributes">
                            <xsl:with-param name="default-output-class">
                                <xsl:if test="@placement='break'">
                    
                                    <xsl:choose>
                                        <xsl:when test="@align='left'">imageleft</xsl:when>
                                        <xsl:when test="@align='right'">imageright</xsl:when>
                                        <xsl:when test="@align='center'">imagecenter</xsl:when>
                                    </xsl:choose>
                                </xsl:if>
                            </xsl:with-param>
                        </xsl:call-template>
                        <xsl:call-template name="setid"/>
                        <xsl:attribute name="src">
                            <xsl:value-of select="@href"/>
                    

                        </xsl:attribute>
                        <xsl:apply-templates select="@height|@width"/>
                    </xsl:element>
                </xsl:when>
                <xsl:otherwise>
        -->
        <xsl:element name="img">
            <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class">
                    <xsl:if test="@placement = 'break'">
                        <!--Align only works for break-->
                        <xsl:choose>
                            <xsl:when test="@align = 'left'">imageleft</xsl:when>
                            <xsl:when test="@align = 'right'">imageright</xsl:when>
                            <xsl:when test="@align = 'center'">imagecenter</xsl:when>
                        </xsl:choose>
                    </xsl:if>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="setid"/>
            <xsl:choose>
                <xsl:when test="*[contains(@class, ' topic/longdescref ')]">
                    <xsl:apply-templates select="*[contains(@class, ' topic/longdescref ')]"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="@longdescref"/>
                </xsl:otherwise>
            </xsl:choose>

            <!--<xsl:apply-templates select="@href|@height|@width"/>-->
            <xsl:apply-templates select="@height | @width"/>

            <xsl:attribute name="src">
                <xsl:choose>
                    <!-- [SP] 11-Mar-2013: Use PNGs instead of SVGs. The force.pngs parameter must be set to "true". -->
                    <xsl:when test="$force.pngs = 'true' and contains(@href, '.svg')">
                        <xsl:value-of select="concat(substring-before(@href, '.svg'), '.png')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@href"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>


            <!-- Add by Alan for Bug:#2900417 on Date: 2009-11-23 begin -->
            <xsl:apply-templates select="@scale"/>
            <!-- Add by Alan for Bug:#2900417 on Date: 2009-11-23 end   -->
            <xsl:choose>
                <xsl:when test="*[contains(@class, ' topic/alt ')]">
                    <xsl:variable name="alt-content">
                        <xsl:apply-templates select="*[contains(@class, ' topic/alt ')]"
                            mode="text-only"/>
                    </xsl:variable>
                    <xsl:attribute name="alt">
                        <xsl:value-of select="normalize-space($alt-content)"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:when test="@alt">
                    <xsl:attribute name="alt">
                        <xsl:value-of select="@alt"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="alt">
                        <xsl:value-of select="@href"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
        <!-- </xsl:otherwise>
            </xsl:choose>
        </a>-->
    </xsl:template>


    <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
    <!-- [SP] Overrides for note processing. 
    -->
    <xsl:template match="*" mode="process.note.common-processing">
        <xsl:param name="type" select="@type"/>
        <xsl:param name="othertype" select="@othertype"/>
        <xsl:param name="title">

            <xsl:variable name="var_stringName">
                <xsl:choose>
                    <xsl:when test="$type = 'other' and $othertype = 'warning'">
                        <xsl:value-of select="$othertype"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$type"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:call-template name="getString">
                <!-- For the parameter, turn "note" into "Note", caution => Caution, etc -->
                <!--<xsl:with-param name="stringName"
                    select="concat(translate(substring($type, 1, 1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
                    substring($type, 2))"
                />-->
                <xsl:with-param name="stringName"
                    select="
                        concat(translate(substring($var_stringName, 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
                        substring($var_stringName, 2))"/>



            </xsl:call-template>
        </xsl:param>
        <xsl:variable name="flagrules">
            <xsl:call-template name="getrules"/>
        </xsl:variable>

        <!--<div class="{$type}">-->
        <div>
            <xsl:attribute name="class">
                <xsl:choose>
                    <xsl:when test="$othertype = 'warning'">
                        <xsl:value-of select="$othertype"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$type"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>

            <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class" select="$type"/>
            </xsl:call-template>
            <xsl:call-template name="gen-style">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
            <xsl:call-template name="setidaname"/>
            <xsl:call-template name="start-flagit">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
            <!-- Insert icon, if there is one. -->
            <xsl:choose>
                <xsl:when test="$othertype = 'warning'">
                    <!--<xsl:message>
                        #####
                        @othertype = 'warning'.
                    </xsl:message>-->
                    <img alt="Warning">
                        <xsl:attribute name="src">
                            <xsl:value-of select="$PATH2PROJ"/>
                            <!--<xsl:value-of select="concat('../',$PATH2PROJ)"/>-->
                            <xsl:call-template name="getString">
                                <xsl:with-param name="stringName" select="'Warning_note'"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </img>
                </xsl:when>
                <xsl:when test="$type = 'note'">
                    <img alt="Note">
                        <xsl:attribute name="src">
                            <xsl:value-of select="$PATH2PROJ"/>
                            <!--<xsl:value-of select="concat('../',$PATH2PROJ)"/>-->
                            <xsl:call-template name="getString">
                                <xsl:with-param name="stringName" select="'Note_note'"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </img>
                </xsl:when>
                <xsl:when test="$type = 'warning'">
                    <img alt="Warning">
                        <xsl:attribute name="src">
                            <xsl:value-of select="$PATH2PROJ"/>
                            <!--<xsl:value-of select="concat('../',$PATH2PROJ)"/>-->
                            <xsl:call-template name="getString">
                                <xsl:with-param name="stringName" select="'Warning_note'"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </img>
                </xsl:when>
                <xsl:when test="$type = 'caution'">
                    <img alt="Caution">
                        <xsl:attribute name="src">
                            <xsl:value-of select="$PATH2PROJ"/>
                            <!--<xsl:value-of select="concat('../',$PATH2PROJ)"/>-->
                            <xsl:call-template name="getString">
                                <xsl:with-param name="stringName" select="'Caution_note'"/>
                            </xsl:call-template>
                        </xsl:attribute>
                    </img>
                </xsl:when>
            </xsl:choose>

            <xsl:if
                test="not(child::*[contains(@class, ' topic/p ') and @outputclass = 'notetitle'])">
                <p class="{$type}title">
                    <xsl:call-template name="show-admonition"/>
                    <xsl:text> </xsl:text>
                </p>
            </xsl:if>
            <xsl:call-template name="revblock">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
            <xsl:call-template name="end-flagit">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
        </div>
    </xsl:template>

    <xsl:template match="*" mode="process.note">
        <xsl:apply-templates select="." mode="process.note.common-processing">
            <!-- Force the type to note, in case new unrecognized values are added
         before translations exist (such as Warning) -->
            <xsl:with-param name="type" select="'note'"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="*" mode="process.note.tip">
        <xsl:apply-templates select="." mode="process.note.common-processing"/>
    </xsl:template>

    <xsl:template match="*" mode="process.note.fastpath">
        <xsl:apply-templates select="." mode="process.note.common-processing"/>
    </xsl:template>

    <xsl:template match="*" mode="process.note.important">
        <xsl:apply-templates select="." mode="process.note.common-processing"/>
    </xsl:template>

    <xsl:template match="*" mode="process.note.remember">
        <xsl:apply-templates select="." mode="process.note.common-processing"/>
    </xsl:template>

    <xsl:template match="*" mode="process.note.restriction">
        <xsl:apply-templates select="." mode="process.note.common-processing"/>
    </xsl:template>

    <xsl:template match="*" mode="process.note.warning">
        <xsl:apply-templates select="." mode="process.note.common-processing"/>
    </xsl:template>

    <xsl:template match="*" mode="process.note.attention">
        <xsl:apply-templates select="." mode="process.note.common-processing"/>
    </xsl:template>

    <xsl:template match="*" mode="process.note.other">
        <xsl:choose>
            <xsl:when test="@othertype">
                <xsl:apply-templates select="." mode="process.note.common-processing">
                    <xsl:with-param name="type" select="'note'"/>
                    <xsl:with-param name="title" select="@othertype"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="process.note.common-processing">
                    <xsl:with-param name="type" select="'note'"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- [SP] In OT XHTML Caution behaves differently from other admonitions.  
        Overriding that behavior so that it behaves like warning. -->
    <xsl:template match="*" mode="process.note.caution">
        <xsl:apply-templates select="." mode="process.note.common-processing"/>
    </xsl:template>

    <!-- Caution and Danger both use a div for the title, so they do not
     use the common note processing template. -->
    <!--    <xsl:template match="*" mode="process.note.caution">
        <xsl:variable name="flagrules">
            <xsl:call-template name="getrules"/>
        </xsl:variable>
        <div class="cautiontitle">
            <xsl:call-template name="commonattributes"/>
            <xsl:attribute name="class">cautiontitle</xsl:attribute>
            <xsl:call-template name="setidaname"/>    
            <xsl:call-template name="start-flagit">
                <xsl:with-param name="flagrules" select="$flagrules"></xsl:with-param>     
            </xsl:call-template>
            <xsl:call-template name="getString">
                <xsl:with-param name="stringName" select="'Caution'"/>
            </xsl:call-template>
            <xsl:call-template name="getString">
                <xsl:with-param name="stringName" select="'ColonSymbol'"/>
            </xsl:call-template>
        </div>
        <div class="caution">
            <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class" select="'caution'"/>
            </xsl:call-template>
            <xsl:call-template name="gen-style">
                <xsl:with-param name="flagrules" select="$flagrules"></xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="revblock">
                <xsl:with-param name="flagrules" select="$flagrules"></xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="end-flagit">
                <xsl:with-param name="flagrules" select="$flagrules"></xsl:with-param> 
            </xsl:call-template>
        </div>  
    </xsl:template>
    
-->
    <xsl:template match="*" mode="process.note.danger">
        <xsl:variable name="flagrules">
            <xsl:call-template name="getrules"/>
        </xsl:variable>
        <div class="dangertitle">
            <xsl:call-template name="commonattributes"/>
            <xsl:attribute name="class">dangertitle</xsl:attribute>
            <xsl:call-template name="setidaname"/>
            <xsl:call-template name="start-flagit">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
            <xsl:call-template name="getString">
                <xsl:with-param name="stringName" select="'Danger'"/>
            </xsl:call-template>
        </div>
        <div class="danger">
            <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class" select="'danger'"/>
            </xsl:call-template>
            <xsl:call-template name="gen-style">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
            <xsl:call-template name="revblock">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
            <xsl:call-template name="end-flagit">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
        </div>
    </xsl:template>

    <!-- [SP] Override table processing to move caption and modify formatting. -->
    <xsl:template name="dotable">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:apply-templates select="." mode="dotable.sepub3"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'sps_help'">
                <xsl:apply-templates select="." mode="dotable.sps_help"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="dotable.kpe_xhtml"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="dotable.kpe_xhtml">
        <xsl:variable name="flagrules">
            <xsl:call-template name="getrules"/>
        </xsl:variable>
        <xsl:variable name="conflictexist">
            <xsl:call-template name="conflict-check">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:call-template name="start-flagit">
            <xsl:with-param name="flagrules" select="$flagrules"/>
        </xsl:call-template>
        <xsl:call-template name="start-revflag">
            <xsl:with-param name="flagrules" select="$flagrules"/>
        </xsl:call-template>
        <xsl:call-template name="setaname"/>
        <!-- [SP] Moved from within table to outside of table for width issues.  -->
        <xsl:call-template name="place-tbl-lbl"/>
        <!-- title and desc are processed elsewhere -->

        <table cellpadding="4" cellspacing="0" summary="">
            <xsl:variable name="colsep">
                <xsl:choose>
                    <xsl:when test="*[contains(@class, ' topic/tgroup ')]/@colsep">
                        <xsl:value-of select="*[contains(@class, ' topic/tgroup ')]/@colsep"/>
                    </xsl:when>
                    <xsl:when test="@colsep">
                        <xsl:value-of select="@colsep"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="rowsep">
                <xsl:choose>
                    <xsl:when test="*[contains(@class, ' topic/tgroup ')]/@rowsep">
                        <xsl:value-of select="*[contains(@class, ' topic/tgroup ')]/@rowsep"/>
                    </xsl:when>
                    <xsl:when test="@rowsep">
                        <xsl:value-of select="@rowsep"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:call-template name="setid"/>
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="gen-style">
                <xsl:with-param name="conflictexist" select="$conflictexist"/>
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
            <xsl:call-template name="setscale"/>
            <!-- When a table's width is set to page or column, force it's width to 100%. If it's in a list, use 90%.
                Otherwise, the table flows to the content -->
            <xsl:choose>
                <xsl:when
                    test="(@expanse = 'page' or @pgwide = '1') and (ancestor::*[contains(@class, ' topic/li ')] or ancestor::*[contains(@class, ' topic/dd ')])">
                    <xsl:attribute name="width">90%</xsl:attribute>
                </xsl:when>
                <xsl:when
                    test="(@expanse = 'column' or @pgwide = '0') and (ancestor::*[contains(@class, ' topic/li ')] or ancestor::*[contains(@class, ' topic/dd ')])">
                    <xsl:attribute name="width">90%</xsl:attribute>
                </xsl:when>
                <xsl:when test="(@expanse = 'page' or @pgwide = '1')">
                    <xsl:attribute name="width">100%</xsl:attribute>
                </xsl:when>
                <xsl:when test="(@expanse = 'column' or @pgwide = '0')">
                    <xsl:attribute name="width">100%</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="@outputclass = 'db.table'">
                    <xsl:attribute name="border">0</xsl:attribute>
                </xsl:when>
                <xsl:when test="@frame = 'all' and $colsep = '0' and $rowsep = '0'">
                    <xsl:attribute name="border">0</xsl:attribute>
                </xsl:when>
                <xsl:when test="not(@frame) and $colsep = '0' and $rowsep = '0'">
                    <xsl:attribute name="border">0</xsl:attribute>
                </xsl:when>
                <xsl:when test="@frame = 'sides'">
                    <xsl:attribute name="frame">vsides</xsl:attribute>
                    <xsl:attribute name="border">1</xsl:attribute>
                </xsl:when>
                <xsl:when test="@frame = 'top'">
                    <xsl:attribute name="frame">above</xsl:attribute>
                    <xsl:attribute name="border">1</xsl:attribute>
                </xsl:when>
                <xsl:when test="@frame = 'bottom'">
                    <xsl:attribute name="frame">below</xsl:attribute>
                    <xsl:attribute name="border">1</xsl:attribute>
                </xsl:when>
                <xsl:when test="@frame = 'topbot'">
                    <xsl:attribute name="frame">hsides</xsl:attribute>
                    <xsl:attribute name="border">1</xsl:attribute>
                </xsl:when>
                <xsl:when test="@frame = 'none'">
                    <xsl:attribute name="frame">void</xsl:attribute>
                    <xsl:attribute name="border">1</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="frame">border</xsl:attribute>
                    <xsl:attribute name="border">1</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="@outputclass = 'db.table'">
                    <xsl:attribute name="border">0</xsl:attribute>
                </xsl:when>
                <xsl:when test="@frame = 'all' and $colsep = '0' and $rowsep = '0'">
                    <xsl:attribute name="border">0</xsl:attribute>
                </xsl:when>
                <xsl:when test="not(@frame) and $colsep = '0' and $rowsep = '0'">
                    <xsl:attribute name="border">0</xsl:attribute>
                </xsl:when>
                <xsl:when test="$colsep = '0' and $rowsep = '0'">
                    <xsl:attribute name="rules">none</xsl:attribute>
                    <xsl:attribute name="border">0</xsl:attribute>
                </xsl:when>
                <xsl:when test="$colsep = '0'">
                    <xsl:attribute name="rules">rows</xsl:attribute>
                </xsl:when>
                <xsl:when test="$rowsep = '0'">
                    <xsl:attribute name="rules">cols</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="rules">all</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="*[contains(@class, ' topic/tgroup ')]"/>
        </table>
        <xsl:value-of select="$newline"/>
        <xsl:call-template name="end-revflag">
            <xsl:with-param name="flagrules" select="$flagrules"/>
        </xsl:call-template>
        <xsl:call-template name="end-flagit">
            <xsl:with-param name="flagrules" select="$flagrules"/>
        </xsl:call-template>
    </xsl:template>


    <!-- [SP] Override table caption processing to modify formatting. -->
    <!-- table caption -->
    <xsl:template name="place-tbl-lbl">
        <xsl:param name="stringName"/>
        <!-- Number of table/title's before this one -->
        <xsl:variable name="tbl-count-actual"
            select="count(preceding::*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]) + 1"/>

        <!-- normally: "Table 1. " -->
        <xsl:variable name="ancestorlang">
            <xsl:call-template name="getLowerCaseLang"/>
        </xsl:variable>

        <xsl:choose>
            <!-- title -or- title & desc -->
            <xsl:when test="*[contains(@class, ' topic/title ')]">
                <!-- [SP] add expanding table functionality -->
                <!--<div id="expand" onclick="expand_table(this)"><img src="{$PATH2PROJ_url}images/expand_icon.png" alt="expand icon" title="Click to expand in new window."/>-->
                <div class="expand" onclick="expand_table(this)">
                    <!--<img src="{$PATH2PROJ}images/expand_icon.png" alt="expand icon"
                        title="Click to expand in new window."/>-->
                    <img src="{$PATH2PROJ}images/expand_icon.png" alt="expand icon"
                        title="Click to expand in new window."/>
                </div>

                <p>
                    <!-- [SP] Hiding initial span containing "Table" and the number. -->
                    <!--<span class="figure_table_cap1">
                        <xsl:choose>     <!-\- Hungarian: "1. Table " -\->
                            <xsl:when test="( (string-length($ancestorlang)=5 and contains($ancestorlang,'hu-hu')) or (string-length($ancestorlang)=2 and contains($ancestorlang,'hu')) )">
                                <xsl:value-of select="$tbl-count-actual"/><xsl:text>. </xsl:text>
                                <xsl:call-template name="getString">
                                    <xsl:with-param name="stringName" select="'Table'"/>
                                </xsl:call-template><xsl:text> </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="getString">
                                    <xsl:with-param name="stringName" select="'Table'"/>
                                </xsl:call-template><xsl:text> </xsl:text><xsl:value-of select="$tbl-count-actual"/><xsl:text>. </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </span>-->
                    <span class="fig_table_caption">
                        <xsl:apply-templates select="./*[contains(@class, ' topic/title ')]"
                            mode="tabletitle"/>
                    </span>
                    <xsl:if test="*[contains(@class, ' topic/desc ')]">
                        <xsl:text>. </xsl:text>
                        <span class="tabledesc">
                            <xsl:for-each select="./*[contains(@class, ' topic/desc ')]">
                                <xsl:call-template name="commonattributes"/>
                            </xsl:for-each>
                            <xsl:apply-templates select="./*[contains(@class, ' topic/desc ')]"
                                mode="tabledesc"/>
                        </span>
                    </xsl:if>
                </p>
            </xsl:when>
            <!-- desc -->
            <xsl:when test="*[contains(@class, ' topic/desc ')]">
                <span class="tabledesc">
                    <xsl:for-each select="./*[contains(@class, ' topic/desc ')]">
                        <xsl:call-template name="commonattributes"/>
                    </xsl:for-each>
                    <xsl:apply-templates select="./*[contains(@class, ' topic/desc ')]"
                        mode="tabledesc"/>
                </span>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Figure caption -->
    <!-- [SP] Overrides to show only the title, not "Figure" and the number. -->
    <xsl:template name="place-fig-lbl">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:apply-templates select="." mode="place-fig-lbl.sepub3"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'sps_help'">
                <xsl:apply-templates select="." mode="place-fig-lbl.sps_help"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="place-fig-lbl.kpe_xhtml"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="place-fig-lbl.kpe_xhtml">
        <xsl:param name="stringName"/>

        <xsl:variable name="ancestorlang">
            <xsl:call-template name="getLowerCaseLang"/>
        </xsl:variable>
        <xsl:choose>
            <!-- title -or- title & desc -->
            <xsl:when test="*[contains(@class, ' topic/title ')]">
                <!-- [SP] add expanding figure functionality -->
                <!--<div id="expand" onclick="expand_figure(this)"><img src="{$PATH2PROJ_url}images/expand_icon.png" alt="expand icon" title="Click to expand in new window."/>-->
                <div class="expand" onclick="expand_figure(this)">
                    <img src="{$PATH2PROJ}images/expand_icon.png" alt="expand icon"
                        title="Click to expand in new window."/>
                </div>

                <div class="pFigureTitle">
                    <span class="figcap">
                        <!--                        <xsl:choose>
                            <!-\- Hungarian: "1. Figure " -\->
                            <xsl:when
                                test="( (string-length($ancestorlang)=5 and contains($ancestorlang,'hu-hu')) or (string-length($ancestorlang)=2 and contains($ancestorlang,'hu')) )">
                                <xsl:call-template name="count_figures"/>
                                <xsl:text>. </xsl:text>
                                <xsl:call-template name="getString">
                                    <xsl:with-param name="stringName" select="'Figure'"/>
                                </xsl:call-template>
                                <xsl:text> </xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:call-template name="getString">
                                    <xsl:with-param name="stringName" select="'Figure'"/>
                                </xsl:call-template>
                                <xsl:text> </xsl:text>
                                <!-\- Scriptorium: add section or appendix number, if necessary. -\->
                                <xsl:if test="$sect_appx != ''">
                                    <xsl:value-of select="$sect_appx"/>
                                    <xsl:text>.</xsl:text>
                                </xsl:if>
                                <!-\- Get the figure number -\->
                                <xsl:call-template name="count_figures"/>
                                <!-\- Colon to separate label from text. -\->
                                <xsl:text>: </xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>-->
                        <xsl:apply-templates select="./*[contains(@class, ' topic/title ')]"
                            mode="figtitle"/>
                    </span>
                </div>
                <xsl:if test="*[contains(@class, ' topic/desc ')]">
                    <xsl:text>. </xsl:text>
                    <span class="figdesc">
                        <xsl:for-each select="./*[contains(@class, ' topic/desc ')]">
                            <xsl:call-template name="commonattributes"/>
                        </xsl:for-each>
                        <xsl:apply-templates select="./*[contains(@class, ' topic/desc ')]"
                            mode="figdesc"/>
                    </span>
                </xsl:if>
            </xsl:when>
            <!-- desc -->
            <xsl:when test="*[contains(@class, ' topic/desc ')]">
                <span class="figdesc">
                    <xsl:for-each select="./*[contains(@class, ' topic/desc ')]">
                        <xsl:call-template name="commonattributes"/>
                    </xsl:for-each>
                    <xsl:apply-templates select="./*[contains(@class, ' topic/desc ')]"
                        mode="figdesc"/>
                </span>
            </xsl:when>
        </xsl:choose>
    </xsl:template>



    <!-- [SP] The DocBook to DITA conversion created a number of outputclass attributes with values containing periods (.).
              When converted to HTML class attributes, the period is an illegal character in CSS, because it's used to separate
              HTML tag names from styles (div.myStyle).  Modified this template to replace any periods in outputclass attributes
              with underscores. This template is called from commonattributes.
    -->
    <xsl:template match="@outputclass">
        <xsl:attribute name="class">
            <xsl:value-of select="translate(., '.', '_')"/>
        </xsl:attribute>
    </xsl:template>

    <!-- [SP] Override glossary processing. -->
    <!-- =========== GLOSSARY =========== -->
    <xsl:template match="*[contains(@class, ' glossentry/glossdef ')]">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:apply-templates select="." mode="glossentry_glossdef.sepub3"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="glossentry_glossdef.xhtml"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' glossentry/glossdef ')]"
        mode="glossentry_glossdef.xhtml">
        <xsl:apply-imports/>
    </xsl:template>

    <!-- [SP] Override definition list processing. -->
    <!-- =========== DEFINITION LIST =========== -->

    <!-- DL -->
    <xsl:template match="*[contains(@class, ' topic/dl ')]" name="topic.dl">
        <xsl:variable name="revtest">
            <xsl:if test="@rev and not($FILTERFILE = '') and ($DRAFT = 'yes')">
                <xsl:call-template name="find-active-rev-flag">
                    <xsl:with-param name="allrevs" select="@rev"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$revtest = 1">
                <!-- Rev is active - add the DIV -->
                <div class="{@rev}">
                    <xsl:apply-templates select="." mode="dl-fmt"/>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <!-- Rev wasn't active - process normally -->
                <xsl:apply-templates select="." mode="dl-fmt"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--    <!-\- [SP] Previous help implementation puts all entries in a single dl/dd. 
              Not a wise thing, but I'm mirroring the behavior. -\->
    <xsl:template match="*[contains(@class,' topic/dl ')]" mode="dl-fmt">
        <div class="variablelist">
            <dl>
                <dd>

                    <xsl:variable name="flagrules">
                        <xsl:call-template name="getrules"/>
                    </xsl:variable>
                    <xsl:variable name="conflictexist">
                        <xsl:call-template name="conflict-check">
                            <xsl:with-param name="flagrules" select="$flagrules"/>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:call-template name="start-flagit">
                        <xsl:with-param name="flagrules" select="$flagrules"/>
                    </xsl:call-template>
                    <xsl:call-template name="start-revflag">
                        <xsl:with-param name="flagrules" select="$flagrules"/>
                    </xsl:call-template>
                    <xsl:call-template name="setaname"/>
                    <!-\- Handle the dlentry elements. -\->
                    <xsl:apply-templates/>

                    <xsl:call-template name="end-revflag">
                        <xsl:with-param name="flagrules" select="$flagrules"/>
                    </xsl:call-template>
                    <xsl:call-template name="end-flagit">
                        <xsl:with-param name="flagrules" select="$flagrules"/>
                    </xsl:call-template>
                    <xsl:value-of select="$newline"/>
                </dd>
            </dl>
        </div>
    </xsl:template>

    <!-\- DL entry -\->
    <xsl:template match="*[contains(@class,' topic/dlentry ')]" name="topic.dlentry">
        <div class="varlist">
            <xsl:apply-templates select="*[contains(@class,' topic/dt ')]"/>
            <xsl:apply-templates select="*[contains(@class,' topic/dd ')]"/>
        </div>
    </xsl:template>

    <!-\- DL term -\->
    <!-\- [SP] Note that the implementation here assumes that there is only one 
              <dt> element.   DITA allows multiple terms, but the HTML output format doesn't 
              permit easy display of such an occurrence. -\->
    <xsl:template match="*[contains(@class,' topic/dt ')]" name="topic.dt">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:apply-templates select="." mode="dt.sepub3"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'sps_help'">
                <xsl:apply-templates select="." mode="dt.sps_help"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="dt.kpe_xhtml"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
        
    <xsl:template match="*[contains(@class,' topic/dt ')]" mode="dt.kpe_xhtml" name="topic.dt.kpe_xhtml">
        <div class="term">
            <!-\- handle non-compact list items -\->
            <xsl:apply-templates select="../@xml:lang"/>
            <!-\- Get from DLENTRY, then override with local -\->
            <xsl:call-template name="setidaname"/>
            <!-\- handle ID on a DLENTRY -\->
            <xsl:if test="parent::*/@id">
                <xsl:call-template name="parent-id"/>
            </xsl:if>
            <xsl:call-template name="revtext"/>
        </div>
        <xsl:value-of select="$newline"/>
    </xsl:template>

    <!-\- DL description -\->
    <xsl:template match="*[contains(@class,' topic/dd ')]" name="topic.dd">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE='sepub3'">
                <xsl:apply-templates select="." mode="dd.sepub3"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE='sps_help'">
                <xsl:apply-templates select="." mode="dd.sps_help"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="dd.kpe_xhtml"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
        <!-\- [SP] <dd> has to be handled before <dt> because the <dt> has to be in the first paragraph output.
         -\->
    <xsl:template match="*[contains(@class,' topic/dd ')]" mode="dd.kpe_xhtml" name="topic.dd.kpe_xhtml">
        <xsl:variable name="flagrules">
            <xsl:call-template name="getrules"/>
        </xsl:variable>
        <xsl:variable name="conflictexist">
            <xsl:call-template name="conflict-check">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:call-template name="start-flagit">
            <xsl:with-param name="flagrules" select="$flagrules"/>
        </xsl:call-template>
        <xsl:call-template name="start-revflag-parent">
            <xsl:with-param name="flagrules" select="$flagrules"/>
        </xsl:call-template>
        <xsl:call-template name="revblock">
            <xsl:with-param name="flagrules" select="$flagrules"/>
        </xsl:call-template>
        <xsl:call-template name="end-revflag-parent">
            <xsl:with-param name="flagrules" select="$flagrules"/>
        </xsl:call-template>
        <xsl:call-template name="end-flagit">
            <xsl:with-param name="flagrules" select="$flagrules"/>
        </xsl:call-template>
        <xsl:value-of select="$newline"/>
    </xsl:template>
-->
    <!-- =========== PHRASES =========== -->

    <!-- phrase presentational style - have to use a low priority otherwise topic/ph always wins -->
    <!-- should not need priority, default is low enough -->
    <xsl:template match="*[contains(@class, ' topic/ph ')]">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:apply-templates select="." mode="ph.sepub3"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-imports/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
    <!-- [SP] Overrides for rel-links.xsl. -->
    <!-- Entirely override the processing of related links (for now). -->

    <!--    <xsl:template match="*[contains(@class, ' topic/related-links ')]">
        <!-\- Do nothing -\->
    </xsl:template>    
-->
    <!-- [SP] 27-Feb-12: Allow overrides of parent links -->
    <xsl:template name="parentlink" match="*[contains(@class, ' topic/link ')][@role = 'parent']"
        priority="2">
        <!-- Do nothing -->
        <!-- [SP] provide div open and close tags, so that #main_body doesn't wrap #footer_cont -->
        <xsl:text>&#32;</xsl:text>
    </xsl:template>

    <!--children links - handle all child or descendant links except those in linklists or ordered collection-types.
Each child is indented, the linktext is bold, and the shortdesc appears in normal text directly below the link, to create a summary-like appearance.-->
    <!-- [SP] Added introductory text. -->
    <xsl:template name="ul-child-links">
        <xsl:if
            test="descendant::*[contains(@class, ' topic/link ')][@role = 'child' or @role = 'descendant'][not(parent::*/@collection-type = 'sequence')][not(ancestor::*[contains(@class, ' topic/linklist ')])]">
            <xsl:value-of select="$newline"/>
            <p class="childlinkintro">
                <xsl:call-template name="getString">
                    <xsl:with-param name="stringName" select="'child_link_intro'"/>
                </xsl:call-template>
            </p>
            <xsl:value-of select="$newline"/>
            <xsl:value-of select="$newline"/>
            <ul class="ullinks">
                <xsl:value-of select="$newline"/>
                <!--once you've tested that at least one child/descendant exists, apply templates to only the unique ones-->
                <xsl:apply-templates
                    select="
                        descendant::*
                        [generate-id(.) = generate-id(key('link', concat(ancestor::*[contains(@class, ' topic/related-links ')]/parent::*[contains(@class, ' topic/topic ')]/@id, ' ', @href, @type, @role, @platform, @audience, @importance, @outputclass, @keyref, @scope, @format, @otherrole, @product, @otherprops, @rev, @class, child::*))[1])]
                        [contains(@class, ' topic/link ')]
                        [@role = 'child' or @role = 'descendant']
                        [not(parent::*/@collection-type = 'sequence')]
                        [not(ancestor::*[contains(@class, ' topic/linklist ')])]"
                    mode="FORCE-ME"/>
            </ul>
            <xsl:value-of select="$newline"/>
        </xsl:if>

    </xsl:template>

    <!--basic child processing-->
    <!-- [SP] Overrides to change formatting (removing <strong>). From rel-links.xsl. -->
    <!-- [SP] 26-Apr-2013: Someone, somewhere was intercepting this and just using div. FORCE-ME makes this template handle it only. -->
    <xsl:template
        match="*[contains(@class, ' topic/link ')][@role = 'child' or @role = 'descendant']"
        priority="10" name="topic.link_child" mode="FORCE-ME">
        <xsl:variable name="flagrules">
            <xsl:call-template name="getrules"/>
        </xsl:variable>
        <xsl:variable name="el-name">
            <xsl:choose>
                <!-- [SP] 26-Apr-2013: It's not clear why <div> would ever be legal here.  -->
                <xsl:when test="$TRANSTYPE = 'sepub3'">li</xsl:when>
                <xsl:when test="contains(../@class, ' topic/linklist ')">div</xsl:when>
                <xsl:otherwise>li</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="{$el-name}">
            <xsl:attribute name="class">ulchildlink</xsl:attribute>
            <xsl:call-template name="commonattributes">
                <xsl:with-param name="default-output-class" select="'ulchildlink'"/>
            </xsl:call-template>
            <!-- Allow for unknown metadata (future-proofing) -->
            <xsl:apply-templates
                select="*[contains(@class, ' topic/data ') or contains(@class, ' topic/foreign ')]"/>
            <xsl:call-template name="start-flags-and-rev">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
            <!--            <strong>-->
            <xsl:apply-templates select="." mode="related-links:unordered.child.prefix"/>
            <xsl:apply-templates select="." mode="add-link-highlight-at-start"/>
            <a>
                <xsl:apply-templates select="." mode="add-linking-attributes"/>
                <xsl:apply-templates select="." mode="add-hoverhelp-to-child-links"/>

                <!--use linktext as linktext if it exists, otherwise use href as linktext-->
                <xsl:choose>
                    <xsl:when test="*[contains(@class, ' topic/linktext ')]">
                        <xsl:apply-templates select="*[contains(@class, ' topic/linktext ')]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <!--use href-->
                        <xsl:call-template name="href"/>
                    </xsl:otherwise>
                </xsl:choose>
            </a>
            <xsl:apply-templates select="." mode="add-link-highlight-at-end"/>
            <!--</strong>-->
            <xsl:call-template name="end-flags-and-rev">
                <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
            <!-- [SP] 28-Jan-2013: Eliminate brief description from section list.  -->
            <!--<br/>
            <xsl:value-of select="$newline"/>-->
            <!--add the description on the next line, like a summary-->
            <!--<xsl:apply-templates select="*[contains(@class, ' topic/desc ')]"/>-->
        </xsl:element>
        <xsl:value-of select="$newline"/>
    </xsl:template>




    <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
    <!-- [SP] Overrides for flag.xsl. -->

    <!-- Removed from processing for now until I see how mixed content gets handled in 1.5. -->

    <!-- Because of the way that formats many of it's notes and dl's the admonition or dt has 
         to appear inside the first <p> tag emitted in HTML.  In pernicious mixed content, this is hard, 
         because there might not be a DITA <p> element.  So we need to detect a) are we in a sensitive
         element (<note>, <dlentry>, and so on), and b) is there pernicious mixed content.
    -->

    <!-- Output starting & ending flag for "blocked" text.
        Use instead of 'apply-templates' for block areas (P, Note, DD, etc) -->
    <!--    <xsl:template name="revblock">
        <xsl:param name="flagrules"/>
        <xsl:choose>
            <xsl:when test="@rev and not($FILTERFILE='') and ($DRAFT='yes')"> <!-\- draft rev mode, add div w/ rev attr value -\->
                <xsl:variable name="revtest"> 
                    <xsl:call-template name="find-active-rev-flag">
                        <xsl:with-param name="allrevs" select="@rev"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$revtest=1">
                        <div class="{@rev}">
                            <xsl:call-template name="start-mark-rev">
                                <xsl:with-param name="revvalue" select="@rev"/>
                                <xsl:with-param name="flagrules" select="$flagrules"/> 
                            </xsl:call-template>
                            <xsl:call-template name="term-or-admonition"/>
                            <xsl:call-template name="end-mark-rev">
                                <xsl:with-param name="revvalue" select="@rev"/>
                                <xsl:with-param name="flagrules" select="$flagrules"/> 
                            </xsl:call-template>
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="@rev and not($FILTERFILE='')">    <!-\- normal rev mode -\->
                <xsl:call-template name="start-mark-rev">
                    <xsl:with-param name="revvalue" select="@rev"/>
                    <xsl:with-param name="flagrules" select="$flagrules"/> 
                </xsl:call-template>
                <xsl:call-template name="term-or-admonition"/>
                <xsl:call-template name="end-mark-rev">
                    <xsl:with-param name="revvalue" select="@rev"/>
                    <xsl:with-param name="flagrules" select="$flagrules"/> 
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="term-or-admonition"/>
            </xsl:otherwise>  <!-\- rev mode -\->
        </xsl:choose>
    </xsl:template>
-->
    <!-- [SP] Do the actual detection and replacement. -->
    <xsl:template name="term-or-admonition">
        <xsl:choose>
            <!-- If the first node is a non-whitespace text node. 
                 And make sure we're not simply handling content from within a <p>. -->
            <xsl:when
                test="child::node()[1][self::text() and normalize-space(self::text()) != ''] and not(contains(@class, ' topic/p '))">
                <!-- Build a look-ahead map, showing the organization of the content, one letter per node. -->
                <xsl:variable name="node_map">
                    <xsl:call-template name="make-map">
                        <xsl:with-param name="node_set" select="./node()"/>
                    </xsl:call-template>
                </xsl:variable>
                <!-- If the map contains a B, that's the beginning of block-mode content.  
                     Count the number of nodes before the B. -->
                <xsl:variable name="pernicious_extent">
                    <xsl:choose>
                        <xsl:when test="contains($node_map, 'B')">
                            <xsl:value-of select="string-length(substring-before($node_map, 'B'))"/>
                        </xsl:when>
                        <!-- If there is no 'B', use all nodes. -->
                        <xsl:otherwise>
                            <xsl:value-of select="string-length($node_map)"/>
                        </xsl:otherwise>
                    </xsl:choose>

                </xsl:variable>

                <p>
                    <xsl:choose>
                        <xsl:when test="contains(@class, ' topic/note ')">
                            <xsl:call-template name="show-admonition"/>
                        </xsl:when>
                    </xsl:choose>

                    <!-- Insert the admonition -->
                    <xsl:apply-templates select="node()[position() &lt;= $pernicious_extent]"/>
                </p>
                <!-- Handle any subsequent nodes...if any. -->
                <xsl:apply-templates select="node()[position() &gt; $pernicious_extent]"/>
            </xsl:when>
            <!-- If the first node is a p. This will be handled correctly in ' topic/p '. -->
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>

        </xsl:choose>

    </xsl:template>

    <!-- process the TM tag -->
    <xsl:template match="*[contains(@class, ' topic/tm ')]" name="topic.tm">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'sepub3'">
                <xsl:apply-templates select="." mode="tm.sepub3"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="tm.kpe_xhtml"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- Silly IBM implementation expects @tmclass to be ibm, ibmsub, or special.  Grrrrr. -->
    <xsl:template match="*[contains(@class, ' topic/tm ')]" mode="tm.kpe_xhtml"
        name="topic.tm.kpe_xhtml">

        <xsl:apply-templates/>
        <!-- output the TM content -->
        <!-- Ensure the attribute is lowercase. -->
        <xsl:variable name="tmtype" select="translate(@tmtype, $alpha_uc, $alpha_lc)"/>
        <xsl:choose>
            <xsl:when test="@tmtype = 'tm'">&#x2122;</xsl:when>
            <xsl:when test="@tmtype = 'service'">
                <span class="servicemark">SM</span>
            </xsl:when>
            <!-- Circle R -->
            <xsl:when test="@tmtype = 'reg'">
                <sup>&#174;</sup>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>Invalid tmtype attribute <xsl:value-of select="$tmtype"/></xsl:message>
            </xsl:otherwise>
        </xsl:choose>


    </xsl:template>
    <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
    <!-- Handle bodydiv for revision history. -->
    <!-- TODO: localize strings. -->

    <xsl:template match="*[contains(@class, ' topic/bodydiv ')][@outputclass = 'revisions']"
        name="revision-history">
        <!-- [SP] <section> -->
        <div class="section_cont">
            <h2>
                <xsl:call-template name="getString">
                    <xsl:with-param name="stringName" select="'revision_history_title'"/>
                </xsl:call-template>
            </h2>
            <div class="tablenoborder TEST">
                <p class="TEST">

                    <span class="fig_table_caption">
                        <xsl:call-template name="getString">
                            <xsl:with-param name="stringName" select="'revision_history_table'"/>
                        </xsl:call-template>
                    </span>
                </p>
                <table cellspacing="0" cellpadding="4" border="1" rules="all" frame="border"
                    class="table" width="600px">
                    <thead align="left" class="thead">
                        <tr class="row">
                            <th valign="top" class="entry">
                                <p class="p tabletitle">
                                    <xsl:call-template name="getString">
                                        <xsl:with-param name="stringName"
                                            select="'revision_history_date'"/>
                                    </xsl:call-template>
                                </p>
                            </th>
                            <th valign="top" class="entry">
                                <p class="p tabletitle">
                                    <xsl:call-template name="getString">
                                        <xsl:with-param name="stringName"
                                            select="'revision_history_page'"/>
                                    </xsl:call-template>
                                </p>
                            </th>
                            <th valign="top" class="entry">
                                <p class="p tabletitle">
                                    <xsl:call-template name="getString">
                                        <xsl:with-param name="stringName"
                                            select="'revision_history_changed'"/>
                                    </xsl:call-template>
                                </p>
                            </th>
                            <th valign="top" class="entry">
                                <p class="p tabletitle">
                                    <xsl:call-template name="getString">
                                        <xsl:with-param name="stringName"
                                            select="'revision_history_rev'"/>
                                    </xsl:call-template>
                                </p>
                            </th>
                        </tr>
                    </thead>
                    <tbody class="tbody">
                        <xsl:apply-templates
                            select="
                                document(concat('file:///', $MAPFILE))/
                                *[contains(@class, ' bookmap/bookmap ')]/
                                *[contains(@class, ' bookmap/bookmeta ')]/
                                *[contains(@class, ' topic/prodinfo ')]/
                                *[contains(@class, ' topic/vrmlist ')]"
                            mode="history"/>
                    </tbody>
                </table>
            </div>
            <!-- [SP] </section> -->
        </div>
    </xsl:template>


    <xsl:template match="*[contains(@class, ' topic/vrmlist ')]" mode="history">
        <xsl:apply-templates select="*[contains(@class, ' topic/vrm ')]" mode="history"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/vrm ')]" mode="history">
        <tr class="row">
            <td class="entry" valign="top">
                <p class="p">
                    <xsl:value-of select="@release"/>
                </p>
            </td>
            <!-- [SP] I advise strongly against listing the page that changed, because 
                it's meaningful for only one output medium (and potentially only one
                localization. -->
            <td class="entry" valign="top">
                <p class="p">
                    <xsl:choose>
                        <xsl:when test="@otherprops and @otherprops != ''">
                            <xsl:value-of select="@release"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>—</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </p>
            </td>
            <td class="entry" valign="top">
                <p class="p">
                    <xsl:value-of select="@modification"/>
                </p>
            </td>
            <td class="entry" valign="top">
                <p class="p">
                    <xsl:value-of select="@version"/>
                </p>
            </td>
        </tr>
    </xsl:template>

    <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->

    <!-- [SP] Utility function. Returns the substring before the last occurrence of substr. -->
    <xsl:template name="substring-before-last">
        <xsl:param name="input"/>
        <xsl:param name="substr"/>
        <xsl:if test="$substr and contains($input, $substr)">
            <xsl:variable name="temp" select="substring-after($input, $substr)"/>
            <xsl:value-of select="substring-before($input, $substr)"/>
            <xsl:if test="contains($temp, $substr)">
                <xsl:value-of select="$substr"/>
                <xsl:call-template name="substring-before-last">
                    <xsl:with-param name="input" select="$temp"/>
                    <xsl:with-param name="substr" select="$substr"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <!-- [SP] Utility function. Returns the substring after the last occurrence of substr. -->
    <xsl:template name="substring-after-last">
        <xsl:param name="input"/>
        <xsl:param name="substr"/>
        <!--		working with (<xsl:value-of select="$input"/>, <xsl:value-of select="$substr"/>). -->
        <!-- Extract the string which comes after the first occurence -->
        <xsl:variable name="temp" select="substring-after($input, $substr)"/>
        <xsl:choose>
            <xsl:when test="string-length($temp) = 0">
                <xsl:value-of select="$input"/>
            </xsl:when>
            <xsl:when test="not(contains($temp, $substr))">
                <xsl:value-of select="$temp"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="substring-after-last">
                    <xsl:with-param name="input" select="$temp"/>
                    <xsl:with-param name="substr" select="$substr"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- [SP] Create a look-ahead map that identifies the nodes in the current node set. -->
    <!-- Global variable containing valid class names of block nodes. -->
    <xsl:variable name="block_names" select="' topic/p topic/ol topic/ul topic/note '"/>

    <xsl:template name="make-map">
        <xsl:param name="node_set"/>
        <xsl:choose>
            <xsl:when test="$node_set[1][self::text()]">
                <xsl:text>T</xsl:text>
            </xsl:when>
            <xsl:when test="$node_set[1][contains($block_names, self::node()/@class)]">
                <xsl:text>B</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>I</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="count($node_set) &gt; 1">
            <xsl:call-template name="make-map">
                <xsl:with-param name="node_set" select="$node_set[position() &gt; 1]"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <!-- Utility function to replace .xml with .html in an href. -->
    <xsl:template name="fix_href">
        <xsl:param name="href"/>
        <xsl:choose>
            <xsl:when test="contains($href, '.xml')">
                <xsl:value-of select="concat(substring-before($href, '.xml'), '.shtml')"/>
            </xsl:when>
            <xsl:when test="contains($href, '.dita')">
                <xsl:value-of select="concat(substring-before($href, '.dita'), '.shtml')"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- return nothing. -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- [SP] Utility function to count subdir depth of current file 
        (# of times '/' appears in path from $FILEDIR); returns integer. -->
    <xsl:template name="get-level">
        <xsl:param name="counter"/>
        <xsl:param name="current_path_file"/>
        <xsl:choose>
            <xsl:when test="contains($current_path_file, '/')">
                <xsl:call-template name="get-level">
                    <xsl:with-param name="current_path_file"
                        select="substring-after($current_path_file, '/')"/>
                    <xsl:with-param name="counter" select="$counter + 1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$counter"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- [SP] Utility function to build XPATH strings to root. 
        Used to verify/correct $PATH2PROJ. -->
    <xsl:template name="path_to_root">
        <xsl:param name="counter"/>
        <xsl:param name="parent_path"/>
        <xsl:choose>
            <xsl:when test="$counter &gt; 0">
                <xsl:call-template name="path_to_root">
                    <xsl:with-param name="counter" select="$counter - 1"/>
                    <xsl:with-param name="parent_path" select="concat($parent_path, '../')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$parent_path"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- [SP] override default charset -->
    <xsl:template name="generateCharset">
        <xsl:choose>
            <xsl:when test="$TRANSTYPE = 'kpe_xhtml'">
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
                <xsl:value-of select="$newline"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'scorm1.2'">
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
                <xsl:value-of select="$newline"/>
            </xsl:when>
            <xsl:when test="$TRANSTYPE = 'scorm1.2_custom'">
                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
                <xsl:value-of select="$newline"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- [SP] Utility function for debugging : compare two values for equality, return yes|no -->
    <!--<xsl:template name="equal_test">
        <xsl:param name="first_val"/>
        <xsl:param name="second_val"/>
        <xsl:choose>
            <xsl:when test="$first_val = $second_val">yes</xsl:when>
            <xsl:otherwise>no</xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->

    <!-- [SP] Utility template to replace nbsp's -->
    <!--<xsl:template match="text()">
        <xsl:variable name="fixed_reg">&reg;</xsl:variable>
            
        
        <xsl:copy-of select="translate(.,'®',$fixed_reg)"/>                    
    </xsl:template>-->


</xsl:stylesheet>
