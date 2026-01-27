<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">

    <!-- To keep overrides organized, this stylesheet doesn't contain any override templates.
        Instead, they are imported using filenames that parallel their org.dita.pdf2/xsl/fo 
        origins. -->

    <xsl:import href="common/spdf2_attr-set-reflection.xsl"/>

    <xsl:import href="fo/spdf2_commons.xsl"/>
    <xsl:import href="fo/spdf2_root-processing.xsl"/>
    <xsl:import href="fo/spdf2_bookmarks.xsl"/>
    <xsl:import href="fo/spdf2_toc.xsl"/>
    <xsl:import href="fo/spdf2_front-matter.xsl"/>
    <xsl:import href="fo/spdf2_static-content.xsl"/>
    <xsl:import href="fo/spdf2_tables.xsl"/>
    <xsl:import href="fo/spdf2_lists.xsl"/>
    <xsl:import href="fo/spdf2_preface.xsl"/>
    <xsl:import href="fo/spdf2_glossary.xsl"/>
    <xsl:import href="fo/spdf2_index.xsl"/>
    
    <!-- Domains come after main-line processing. -->
    <xsl:import href="fo/spdf2_equation.xsl"/>
    <xsl:import href="fo/spdf2_learning2.xsl"/>
    <xsl:import href="fo/spdf2_answer-key.xsl"/>
    
    <!-- TODO: Integrate. -->
    <xsl:import href="../spdf2_layout-masters.xsl"/>
    
   
    
</xsl:stylesheet>
