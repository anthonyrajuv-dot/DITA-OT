<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1">

    <xsl:import href="../../../xsl/common/output-message.xsl"/>
    <xsl:import href="../../../xsl/common/dita-utilities.xsl"/>
    <xsl:variable name="msgprefix" select="'SPS'"/>
    
    <xsl:param name="bookmap_name" select="'bookmap'"/>
    <xsl:param name="FILE_EXT" select="'.shtml'"/>

    <!-- This file must have a doctype because we're using the DOST.jar defined Ant task "<xmlpropertyreader>". -->
    <xsl:output method="xml" indent="yes" encoding="UTF-8" doctype-system="http://java.sun.com/dtd/properties.dtd"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' map/map ')]">
        <xsl:variable name="landing_page">
            <xsl:apply-templates select="descendant-or-self::*[contains(@class,' map/topicref ') and @outputclass='landing_page'][1]"/> 
        </xsl:variable>

        <xsl:text>&#x0A;</xsl:text>
        <xsl:comment>Landing page property derived from <xsl:value-of select="$bookmap_name"/>.</xsl:comment>
        <xsl:text>&#x0A;</xsl:text>
        <landing>
            <page>
                <xsl:value-of select="$landing_page"/>
            </page>
        </landing>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' map/topicref ') and @outputclass='landing_page']">
            <xsl:choose>
                <xsl:when test="contains(@href,'.xml')">
                    <xsl:value-of select="concat(substring-before(@href,'.xml'),$FILE_EXT)"/>
                </xsl:when>
                <xsl:when test="contains(@href,'.dita')">
                    <xsl:value-of select="concat(substring-before(@href,'.dita'),$FILE_EXT)"/>
                </xsl:when>
            </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>