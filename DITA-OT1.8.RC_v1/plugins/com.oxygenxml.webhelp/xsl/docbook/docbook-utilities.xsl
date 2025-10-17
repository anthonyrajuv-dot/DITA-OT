<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <!--Use some code from DITA templates to i18n static texts-->
    <xsl:import href="../dita/original/dita-utilities.xsl"/>
    <xsl:include href="../dita/original/output-message.xsl"/>
    <xsl:include href="../common-utilities.xsl"/>
    <xsl:variable name="msgprefix">DOCBOOK</xsl:variable>
    
    <!-- Uses the DITA localization architecture, but our strings. -->
    <xsl:template name="getWebhelpString">
        <xsl:param name="stringName" />
        <xsl:param name="stringFileList" select="document('../../oxygen-webhelp/resources/localization/allstrings.xml')/allstrings/stringfile"/>
        <xsl:call-template name="getString">
            <xsl:with-param name="stringName" select="$stringName"/>
            <xsl:with-param name="stringFileList" select="$stringFileList"/>
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>