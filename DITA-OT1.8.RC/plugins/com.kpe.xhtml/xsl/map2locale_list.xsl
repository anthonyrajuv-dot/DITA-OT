<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1">

    <xsl:import href="../../../xsl/common/output-message.xsl"/>
    <xsl:import href="../../../xsl/common/dita-utilities.xsl"/>
    <xsl:variable name="msgprefix" select="'SPS'"/>
    
    <xsl:param name="allstrings" select="'../../../xsl/common/allstrings.xml'"/>

    <!-- This file must have a doctype because we're using the DOST.jar defined Ant task "<xmlpropertyreader>". -->
    <xsl:output method="xml" indent="yes" encoding="UTF-8" doctype-system="http://java.sun.com/dtd/properties.dtd"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' map/map ')]">
       <xsl:call-template name="getStrings"/>
    </xsl:template>
    
    
    <xsl:template name="getStrings">
        <xsl:param name="stringFileList" select="document($allstrings)/allstrings/stringfile"/>
        <xsl:param name="stringFile">#none#</xsl:param>
        <xsl:variable name="ancestorlang">
            <!-- Get the current language -->
            <xsl:call-template name="getLowerCaseLang"/>
        </xsl:variable>
        
        <!-- Use the new getString template interface -->
        <!-- Determine which file holds translations for the current language -->
        <xsl:variable name="stringfile"
            select="document($stringFileList)/*/lang[@xml:lang=$ancestorlang]/@filename"/>

        <!-- Gather all strings from all files, so that we can override dups. -->
        <xsl:variable name="all_str" select="document($stringfile)/strings/str"/>
        
        <!-- output a comment header and the current locale. -->
        <properties>
            <xsl:text>&#x0A;</xsl:text>
            <xsl:comment>Locale properties derived from <xsl:value-of select="$stringfile"/>.</xsl:comment>
            <xsl:text>&#x0A;</xsl:text>
            <entry>
                <xsl:attribute name="key">sps_locale</xsl:attribute>
                <xsl:value-of select="$ancestorlang"/>
            </entry>
        
            <xsl:for-each select="$all_str">
                <xsl:sort select="@name"/>
                <xsl:variable name="current" select="@name"/>
                <xsl:variable name="new_id" select="generate-id()"/>
                <xsl:variable name="count_others" select="count($all_str[@name = $current])"/>
                
                <xsl:choose>
                    <xsl:when test="$count_others = 2 and generate-id($all_str[@name = $current][1]) = $new_id">
                        <!-- If there are more than two, and this is the first one, ignore. -->
                    </xsl:when>
                    <xsl:otherwise>
                        <entry>
                            <xsl:attribute name="key">
                                <xsl:value-of select="translate(normalize-space(@name),' ','_')"/>
                            </xsl:attribute>
                            <xsl:value-of select="normalize-space(.)"/>
                        </entry>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each> 
        </properties>
        
    </xsl:template>
    
</xsl:stylesheet>