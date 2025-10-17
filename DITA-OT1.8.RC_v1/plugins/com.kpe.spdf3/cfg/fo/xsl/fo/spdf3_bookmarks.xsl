<?xml version='1.0'?>

<!--
Copyright © 2004-2006 by Idiom Technologies, Inc. All rights reserved.
IDIOM is a registered trademark of Idiom Technologies, Inc. and WORLDSERVER
and WORLDSTART are trademarks of Idiom Technologies, Inc. All other
trademarks are the property of their respective owners.

IDIOM TECHNOLOGIES, INC. IS DELIVERING THE SOFTWARE "AS IS," WITH
ABSOLUTELY NO WARRANTIES WHATSOEVER, WHETHER EXPRESS OR IMPLIED,  AND IDIOM
TECHNOLOGIES, INC. DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING
BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE AND WARRANTY OF NON-INFRINGEMENT. IDIOM TECHNOLOGIES, INC. SHALL NOT
BE LIABLE FOR INDIRECT, INCIDENTAL, SPECIAL, COVER, PUNITIVE, EXEMPLARY,
RELIANCE, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF
ANTICIPATED PROFIT), ARISING FROM ANY CAUSE UNDER OR RELATED TO  OR ARISING
OUT OF THE USE OF OR INABILITY TO USE THE SOFTWARE, EVEN IF IDIOM
TECHNOLOGIES, INC. HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.

Idiom Technologies, Inc. and its licensors shall not be liable for any
damages suffered by any person as a result of using and/or modifying the
Software or its derivatives. In no event shall Idiom Technologies, Inc.'s
liability for any damages hereunder exceed the amounts received by Idiom
Technologies, Inc. as a result of this transaction.

These terms and conditions supersede the terms and conditions in any
licensing agreement to the extent that such terms and conditions conflict
with those set forth herein.

This file is part of the DITA Open Toolkit project hosted on Sourceforge.net. 
See the accompanying license.txt file for applicable licenses.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:exsl="http://exslt.org/common"
                xmlns:opentopic="http://www.idiominc.com/opentopic"
                xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
                xmlns:exslf="http://exslt.org/functions"
                xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
                xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
                extension-element-prefixes="exsl"
                exclude-result-prefixes="opentopic-index opentopic exslf opentopic-func ot-placeholder"
                version="2.0">

    <xsl:variable name="map" select="//opentopic:map"/>

    <xsl:template match="*[contains(@class, ' topic/topic ')]" mode="bookmark">
        <xsl:variable name="mapTopicref" select="key('map-id', @id)[1]"/>
        <xsl:variable name="topicTitle">
            <xsl:call-template name="getNavTitle">
                <!-- [SPS] getNavTitle no longer takes a topicNumber. -->
<!--              <xsl:with-param name="topicNumber" select="1"/>-->
            </xsl:call-template>
        </xsl:variable>
        <!-- [SP] Get topic type, so we can make decisions about format. -->
        <xsl:variable name="topicType">
            <xsl:call-template name="determineTopicType"/>
        </xsl:variable>

        
        <xsl:choose>
            <!-- [SP] Don't show bookmark for bookabstract ("what people are saying..."). -->
            <xsl:when test="contains($mapTopicref/@class,' bookmap/bookabstract ')">
                <!-- Do nothing. -->
            </xsl:when>
          <xsl:when test="$mapTopicref[@toc = 'yes' or not(@toc)] or
                          not($mapTopicref)">
            <fo:bookmark>
                <xsl:attribute name="internal-destination">
                    <xsl:call-template name="generate-toc-id"/>
                </xsl:attribute>
                    <xsl:if test="$bookmarkStyle!='EXPANDED'">
                        <xsl:attribute name="starting-state">hide</xsl:attribute>
                    </xsl:if>
                <fo:bookmark-title>
                    <xsl:variable name="number">
                        <xsl:apply-templates select="key('map-id', @id)[1]"
                            mode="topicTitleNumber"/>
                    </xsl:variable>
                    
                    <!-- [SP] Format the bookmark depending on topic type. -->
                    <xsl:choose>
                        <xsl:when test="$topicType = 'topicPart'">
                            <xsl:value-of select="normalize-space($topicTitle)"/>
                        </xsl:when>
                        <xsl:when test="$topicType = 'topicChapter' and contains($topicTitle, 'Quiz')">
                            <xsl:value-of select="normalize-space($topicTitle)"/>
                        </xsl:when>
                        <xsl:when test="$topicType = 'topicChapter' and contains($topicTitle, 'Exam')">
                            <xsl:value-of select="normalize-space($topicTitle)"/>
                        </xsl:when>
                        <xsl:when test="$topicType = 'topicChapter' or $topicType = 'topicAppendix'">
                            <xsl:value-of select="normalize-space(concat($number,': ',$topicTitle))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(concat($number,' ',$topicTitle))"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:bookmark-title>
                <xsl:apply-templates mode="bookmark"/>
            </fo:bookmark>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="bookmark"/>
          </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


</xsl:stylesheet>