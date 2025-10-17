<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA Open Toolkit project.
  See the accompanying license.txt file for applicable licenses.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"    
    xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">

        <!-- [SP] 26-Oct-2012: Override to create watermarks, if needed. -->
    <xsl:attribute-set name="simple-page-master">
        <xsl:attribute name="page-width">
            <xsl:value-of select="$page-width"/>
        </xsl:attribute>
        <xsl:attribute name="page-height">
            <xsl:value-of select="$page-height"/>
        </xsl:attribute>
        
        <!-- If the <permissions> element view attribute is populated, use it to determine the watermark. -->
        <xsl:attribute name="background-image">
            <xsl:variable name="watermark_type">
                <xsl:choose>
                    <xsl:when test="$map//*[contains(@class,' bookmap/bookmeta ')][1]//*[contains(@class,' topic/permissions ')]/@view">
                        <xsl:value-of select="$map//*[contains(@class,' bookmap/bookmeta ')][1]//*[contains(@class,' topic/permissions ')]/@view"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>none</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="watermarkImagePath">
                <xsl:call-template name="insertVariable">
                    <xsl:with-param name="theVariableID" select="concat($watermark_type,' Watermark Image Path')"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="concat('url(',$artworkPrefix, $watermarkImagePath,')')"/>
        </xsl:attribute>
        <!-- [SP] 2014-03-31: Commented out for fop testing. -->
<!--        <xsl:attribute name="axf:background-content-width">100pt</xsl:attribute>-->
        
        <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
        <xsl:attribute name="background-position-horizontal">center</xsl:attribute>
        
    </xsl:attribute-set>
    

    <xsl:attribute-set name="region-body.odd">
        <xsl:attribute name="margin-top">
            <xsl:value-of select="$page-margin-top"/>
        </xsl:attribute>
        <xsl:attribute name="margin-bottom">
            <xsl:value-of select="$page-margin-bottom"/>
        </xsl:attribute>
        <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-left' else 'margin-right'}">
            <xsl:choose>
                <!-- support legacy parameter -->
                <xsl:when test="normalize-space($page-margin-left)">
                    <xsl:call-template name="output-message">
                        <xsl:with-param name="msg">[WARN]: The $page-margin-left configuration
                            variable has been deprecated. Use $page-margin-inside and
                            $page-margin-outside instead.</xsl:with-param>
                    </xsl:call-template>
                    <xsl:value-of select="$page-margin-left"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$page-margin-inside"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-right' else 'margin-left'}">
            <xsl:choose>
                <!-- support legacy parameter -->
                <xsl:when test="normalize-space($page-margin-right)">
                    <xsl:call-template name="output-message">
                        <xsl:with-param name="msg">[WARN]: The $page-margin-right configuration
                            variable has been deprecated. Use $page-margin-inside and
                            $page-margin-outside instead.</xsl:with-param>
                    </xsl:call-template>
                    <xsl:value-of select="$page-margin-right"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$page-margin-outside"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="region-body.even">
        <xsl:attribute name="margin-top">
            <xsl:value-of select="$page-margin-top"/>
        </xsl:attribute>
        <xsl:attribute name="margin-bottom">
            <xsl:value-of select="$page-margin-bottom"/>
        </xsl:attribute>
        <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-left' else 'margin-right'}">
            <xsl:choose>
                <!-- support legacy parameter -->
                <xsl:when test="normalize-space($page-margin-left)">
                    <xsl:call-template name="output-message">
                        <xsl:with-param name="msg">[WARN]: The $page-margin-left configuration
                            variable has been deprecated. Use $page-margin-inside and
                            $page-margin-outside instead.</xsl:with-param>
                    </xsl:call-template>
                    <xsl:value-of select="$page-margin-left"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$page-margin-outside"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-right' else 'margin-left'}">
            <xsl:choose>
                <!-- support legacy parameter -->
                <xsl:when test="normalize-space($page-margin-right)">
                    <xsl:call-template name="output-message">
                        <xsl:with-param name="msg">[WARN]: The $page-margin-right configuration
                            variable has been deprecated. Use $page-margin-inside and
                            $page-margin-outside instead.</xsl:with-param>
                    </xsl:call-template>
                    <xsl:value-of select="$page-margin-right"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$page-margin-inside"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="region-body.first" use-attribute-sets="region-body.odd">
        <xsl:attribute name="margin-top">
            <xsl:value-of select="$first-margin-top"/>
        </xsl:attribute>

    </xsl:attribute-set>

    <xsl:attribute-set name="region-body__frontmatter.odd" use-attribute-sets="region-body.odd">
        <xsl:attribute name="margin-top">0.6in</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="region-body__frontmatter.even" use-attribute-sets="region-body.even">
        <xsl:attribute name="margin-top">0.6in</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="region-body__index.odd" use-attribute-sets="region-body.odd">
        <xsl:attribute name="column-count">
            <xsl:value-of select="$index-columns"/>
        </xsl:attribute>
        <xsl:attribute name="column-gap">
            <xsl:value-of select="$index-gap"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="region-body__index.even" use-attribute-sets="region-body.even">
        <xsl:attribute name="column-count">
            <xsl:value-of select="$index-columns"/>
        </xsl:attribute>
        <xsl:attribute name="column-gap">
            <xsl:value-of select="$index-gap"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="region-body__index.first" use-attribute-sets="region-body__index.odd">
        <xsl:attribute name="margin-top">
            <xsl:value-of select="$first-margin-top"/>
        </xsl:attribute>
        
    </xsl:attribute-set>
    
    <!-- ANSWER KEY -->
    <xsl:attribute-set name="region-body__answer-key.odd" use-attribute-sets="region-body.odd">
    </xsl:attribute-set>
    
    <xsl:attribute-set name="region-body__answer-key.even" use-attribute-sets="region-body.even">
    </xsl:attribute-set>
    
    <xsl:attribute-set name="region-body__answer-key.first" use-attribute-sets="region-body__answer-key.odd">
        <xsl:attribute name="margin-top">
            <xsl:value-of select="$first-margin-top"/>
        </xsl:attribute>
        
    </xsl:attribute-set>
    
    
    <xsl:attribute-set name="region-before">
        <xsl:attribute name="extent">
            <xsl:value-of select="$page-margin-top"/>
        </xsl:attribute>
        <xsl:attribute name="display-align">before</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="region-after">
        <xsl:attribute name="extent">
            <xsl:value-of select="$page-margin-bottom"/>
        </xsl:attribute>
        <xsl:attribute name="display-align">before</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="region-after-frontmatter-first">
        <xsl:attribute name="extent">
            <xsl:value-of select="'2in'"/>
        </xsl:attribute>
        <xsl:attribute name="display-align">after</xsl:attribute>
    </xsl:attribute-set>
    

</xsl:stylesheet>
