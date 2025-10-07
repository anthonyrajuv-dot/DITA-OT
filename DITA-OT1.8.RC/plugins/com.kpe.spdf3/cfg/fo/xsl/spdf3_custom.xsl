<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">

    <!-- To keep overrides organized, this stylesheet doesn't contain any override templates.
        Instead, they are imported using filenames that parallel their org.dita.pdf2/xsl/fo 
        origins. -->

    <xsl:import href="common/spdf3_attr-set-reflection.xsl"/>

    <xsl:import href="fo/spdf3_commons.xsl"/>
    <xsl:import href="fo/spdf3_root-processing.xsl"/>
    <xsl:import href="fo/spdf3_bookmarks.xsl"/>
    <xsl:import href="fo/spdf3_toc.xsl"/>
    <xsl:import href="fo/spdf3_front-matter.xsl"/>
    <xsl:import href="fo/spdf3_static-content.xsl"/>
    <xsl:import href="fo/spdf3_tables.xsl"/>
    <xsl:import href="fo/spdf3_lists.xsl"/>
    <xsl:import href="fo/spdf3_preface.xsl"/>
    <xsl:import href="fo/spdf3_glossary.xsl"/>
    <xsl:import href="fo/spdf3_index.xsl"/>

    <!-- TODO: Integrate. -->
    <xsl:import href="../spdf3_layout-masters.xsl"/>
    
   
    
</xsl:stylesheet>
