<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">

    <!-- To keep overrides organized, this stylesheet doesn't contain any override templates.
        Instead, they are imported using filenames that parallel their org.dita.pdf2/xsl/fo 
        origins. -->

    <xsl:import href="common/spdf4_attr-set-reflection.xsl"/>

    <xsl:import href="fo/spdf4_commons.xsl"/>
    <xsl:import href="fo/spdf4_root-processing.xsl"/>
    <xsl:import href="fo/spdf4_bookmarks.xsl"/>
    <xsl:import href="fo/spdf4_toc.xsl"/>
    <xsl:import href="fo/spdf4_front-matter.xsl"/>
    <xsl:import href="fo/spdf4_static-content.xsl"/>
    <xsl:import href="fo/spdf4_tables.xsl"/>
    <xsl:import href="fo/spdf4_lists.xsl"/>
    <xsl:import href="fo/spdf4_preface.xsl"/>
    <xsl:import href="fo/spdf4_glossary.xsl"/>
    <xsl:import href="fo/spdf4_index.xsl"/>

    <!-- TODO: Integrate. -->
    <xsl:import href="../spdf4_layout-masters.xsl"/>
    
   
    
</xsl:stylesheet>
