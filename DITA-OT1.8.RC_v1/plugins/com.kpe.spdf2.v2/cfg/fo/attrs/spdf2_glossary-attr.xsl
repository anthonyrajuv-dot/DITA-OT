<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA Open Toolkit project.
  See the accompanying license.txt file for applicable licenses.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">
    <!--GK_100213 Special for glossentry-->
    <xsl:attribute-set name="glossentry" use-attribute-sets="common.block">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$body-size"/>
        </xsl:attribute>
        <xsl:attribute name="text-indent">0em</xsl:attribute>
        <xsl:attribute name="space-before">
            <xsl:value-of select="$body-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="space-before.precedence">0</xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$body-space-after"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <!--GK_100213 Special for glossterm-->
    <xsl:attribute-set name="__glossary__term" use-attribute-sets="common.block">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$body-size"/>
        </xsl:attribute>
        <xsl:attribute name="text-indent">0em</xsl:attribute>
        <xsl:attribute name="space-before">
            <xsl:value-of select="$body-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="space-before.precedence">0</xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$body-space-after"/>
        </xsl:attribute>
        <xsl:attribute name="page-break-after">avoid</xsl:attribute>
    </xsl:attribute-set>
        
</xsl:stylesheet>