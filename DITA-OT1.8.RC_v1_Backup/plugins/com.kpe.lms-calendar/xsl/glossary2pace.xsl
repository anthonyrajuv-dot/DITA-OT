<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output doctype-public="-//KPE//DTD DITA KPE Glossary Entry//EN" doctype-system="kpe-glossEntry.dtd"
        method="xml"/>
    
    <xsl:template match="processing-instruction()">
        <!-- Do nothing.-->
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:apply-templates select="processing-instruction()"/>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="kpe-glossEntry">
        
        <xsl:copy>
            <xsl:apply-templates select="@*"/>

            <xsl:apply-templates select="node()"/>
            
        </xsl:copy>
        
    </xsl:template>
    
    <xsl:template match="node()[not(self::processing-instruction())]">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            
            <xsl:apply-templates select="node()"/>
            
        </xsl:copy>
        
    </xsl:template>
    
    <xsl:template match="tm" mode="#all" priority="100">
        <xsl:variable name="content">
<!--            <xsl:apply-templates mode="identity"/>-->
            <xsl:apply-templates/>
        </xsl:variable>
        <xsl:variable name="char">
            <xsl:choose>
                <xsl:when test="@tmtype = 'tm'">&#x2122;</xsl:when>
                <xsl:when test="@tmtype = 'reg'">&#xae;</xsl:when>
                <xsl:when test="@tmtype = 'service'">&#x2120;</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat(normalize-space($content),$char)"/>
    </xsl:template>
    
    
    
    
    <!-- Identity transform for attributes. -->
    <xsl:variable name="exclude_attributes" select="'domains class xtrf xtrc ditaarch:DITAArchVersion'"/>
    <xsl:template match="@*">
        <xsl:if test="not(contains($exclude_attributes, name()))">
            <xsl:copy>
                <xsl:apply-templates/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>
    
</xsl:stylesheet>