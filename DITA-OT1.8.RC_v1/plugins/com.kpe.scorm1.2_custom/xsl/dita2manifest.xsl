<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:param name="BASE_DIR"/>
    <xsl:param name="OUT_DIR"/>
    <xsl:param name="premanifest"/>
    <xsl:variable name="premanifest_fixed" select="replace($premanifest,'\\','/')"/>

    <!-- [SP] Discard the supermap that's passed in to start this transform -->

    <xsl:template match="*"/>
    
    <xsl:variable name="course_title" select="//*[contains(@class,' bookmap/mainbooktitle ')]"/>
    

    <xsl:output method="xml" standalone="no" indent="yes"/>
    <xsl:template match="/">
        <xsl:message>course_title is <xsl:value-of select="$course_title"/></xsl:message>
        <manifest identifier="Kaplan_Manifest" version="1.0"
            xmlns="http://www.imsproject.org/xsd/imscp_rootv1p1p2"
            xmlns:adlcp="http://www.adlnet.org/xsd/adlcp_rootv1p2"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.imsproject.org/xsd/imscp_rootv1p1p2 imscp_rootv1p1p2.xsd
        http://www.imsglobal.org/xsd/imsmd_rootv1p2p1 imsmd_rootv1p2p1.xsd
        http://www.adlnet.org/xsd/adlcp_rootv1p2 adlcp_rootv1p2.xsd">
            <metadata>
                <schema>ADL SCORM</schema>
                <schemaversion>1.2</schemaversion>
                <adlcp:location>metadata.xml</adlcp:location>
            </metadata>
            <organizations default="TOC1">
                <organization identifier="TOC1">
                    <title><xsl:value-of select="$course_title"/></title>
                    <item identifier="I_SCO0" identifierref="SCO0">
                        <title><xsl:value-of select="$course_title"/></title>
                    </item>
                </organization>
            </organizations>
            <resources>
                <resource identifier="SCO0" type="webcontent" adlcp:scormtype="sco" href="shared/launchpage.html">
                    <xsl:call-template name="generate_manifest">
                        <xsl:with-param name="premanifest_fixed" select="$premanifest_fixed"/>
                    </xsl:call-template>                  
                </resource>
            </resources>
        </manifest>
    </xsl:template>
    
    <xsl:template name="generate_manifest">
        <xsl:param name="premanifest_fixed"/>
        
        <!--        <xsl:message>Value of $premanifest_fixed is <xsl:value-of select="$premanifest_fixed"/></xsl:message>-->
        <xsl:variable name="manifest_item">
            <xsl:choose>
                <xsl:when test="contains($premanifest_fixed,';')">
                    <xsl:value-of select="substring-before($premanifest_fixed,';')"/>
                </xsl:when>
                <xsl:when test="not(contains($premanifest_fixed,';')) and $premanifest_fixed != ''">
                    <xsl:value-of select="$premanifest_fixed"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="manifest_item_norm" select="normalize-space($manifest_item)"/>
        
        <file href="{$manifest_item_norm}"/>
        
        <!-- Now recurse, as necessary. -->
        <xsl:choose>
            <xsl:when test="contains($premanifest_fixed,';')">
                <xsl:call-template name="generate_manifest">
                    <xsl:with-param name="premanifest_fixed"
                        select="substring-after($premanifest_fixed,';')"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
