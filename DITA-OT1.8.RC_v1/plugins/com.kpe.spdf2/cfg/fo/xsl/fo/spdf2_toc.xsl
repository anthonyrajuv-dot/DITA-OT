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
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:exsl="http://exslt.org/common"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:exslf="http://exslt.org/functions"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
    extension-element-prefixes="exsl"
    exclude-result-prefixes="opentopic exslf opentopic-func ot-placeholder"
    version="2.0">
  
    <xsl:template match="*[contains(@class, ' topic/topic ')]" mode="toc">
        <xsl:param name="include"/>
        <xsl:variable name="topicLevel" as="xs:integer">
            <xsl:apply-templates select="." mode="get-topic-level"/>
        </xsl:variable>
        <xsl:if test="$topicLevel &lt; $tocMaximumLevel">
            <xsl:variable name="mapTopicref" select="key('map-id', @id)[1]"/>
            <xsl:choose>
                <!-- In a future version, suppressing Notices in the TOC should not be hard-coded. -->
                <xsl:when test="$mapTopicref/self::*[contains(@class, ' bookmap/notices ')]"/>
                <!-- [SP] omit bookabstract. -->
                <xsl:when test="$mapTopicref/self::*[contains(@class, ' bookmap/bookabstract ')]"/>
                <xsl:when test="$mapTopicref[@toc = 'yes' or not(@toc)] or
                    (not($mapTopicref) and $include = 'true')">
                    <xsl:comment>using __toc__indent</xsl:comment>
                    <fo:block xsl:use-attribute-sets="__toc__indent">
                        <xsl:variable name="tocItemContent">
                            <fo:basic-link xsl:use-attribute-sets="__toc__link">
                                <xsl:attribute name="internal-destination">
                                    <xsl:call-template name="generate-toc-id"/>
                                </xsl:attribute>
                                <xsl:apply-templates select="$mapTopicref" mode="tocPrefix"/>
                                <fo:inline xsl:use-attribute-sets="__toc__title">
                                    <xsl:call-template name="getNavTitle" />
                                </fo:inline>
                                <fo:inline xsl:use-attribute-sets="__toc__page-number">
                                    <fo:leader xsl:use-attribute-sets="__toc__leader"/>
                                    <fo:page-number-citation>
                                        <xsl:attribute name="ref-id">
                                            <xsl:call-template name="generate-toc-id"/>
                                        </xsl:attribute>
                                    </fo:page-number-citation>
                                </fo:inline>
                            </fo:basic-link>
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="not($mapTopicref)">
                                <xsl:apply-templates select="." mode="tocText">
                                    <xsl:with-param name="tocItemContent" select="$tocItemContent"/>
                                    <xsl:with-param name="currentNode" select="."/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:comment>Looking for toc with <xsl:value-of select="$mapTopicref/@class"/></xsl:comment>
                                <xsl:apply-templates select="$mapTopicref" mode="tocText">
                                    <xsl:with-param name="tocItemContent" select="$tocItemContent"/>
                                    <xsl:with-param name="currentNode" select="."/>
                                </xsl:apply-templates>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:block>
                    <xsl:apply-templates mode="toc">
                        <xsl:with-param name="include" select="'true'"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="toc">
                        <xsl:with-param name="include" select="'true'"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
    
    
    <!-- [SP] Modified the TOC header to be formatted consistently with other headers. -->
    <xsl:template name="createTocHeader">
<!--        <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container"  id="{$id.toc}">

            <xsl:call-template name="insertChapterFirstpageStaticContent">
                <xsl:with-param name="type" select="'contents'"/>
            </xsl:call-template>
        </fo:block>-->
         <fo:block xsl:use-attribute-sets="__toc__header" id="{$id.toc}">
             <!-- Make parallel to chapter titles. -->
             <fo:block xsl:use-attribute-sets="topic.title__content"> 
                 <xsl:call-template name="insertVariable">
                     <xsl:with-param name="theVariableID" select="'Table of Contents'"/>
                 </xsl:call-template>
             </fo:block>
        </fo:block> 
    </xsl:template>
    
    <!-- [SP] Deal with frontmatter topics in TOC...except for bookabstract. -->
    <xsl:template match="*[contains(@class, ' map/topicref ')][ancestor::*[contains(@class,' bookmap/frontmatter ')]]" mode="tocText">
        <!--  and not(contains(@class,' bookmap/bookabstract ')) -->
        <xsl:param name="tocItemContent"/>
        <xsl:param name="currentNode"/>
               
        <xsl:for-each select="$currentNode">
            <fo:block xsl:use-attribute-sets="__toc__topic__content">
                <xsl:attribute name="padding-top">
                    <xsl:text>0pt</xsl:text>
                </xsl:attribute>
                <xsl:copy-of select="$tocItemContent"/>
            </fo:block>
        </xsl:for-each>
    </xsl:template>
    
    <!-- [SP] Add an entry in the TOC for the index. -->
    <xsl:template match="ot-placeholder:indexlist" mode="toc">
        <fo:block xsl:use-attribute-sets="__toc__indent__index">
            <fo:block xsl:use-attribute-sets="__toc__index__content">
                <fo:basic-link internal-destination="{$id.index}" xsl:use-attribute-sets="__toc__link">
                    
                    <fo:inline xsl:use-attribute-sets="__toc__title">
                        <xsl:call-template name="insertVariable">
                            <xsl:with-param name="theVariableID" select="'Index'"/>
                        </xsl:call-template>
                    </fo:inline>
                    
                    <fo:inline xsl:use-attribute-sets="__toc__page-number">
                        <fo:leader xsl:use-attribute-sets="__toc__leader"/>
                        <fo:page-number-citation ref-id="{$id.index}"/>
                    </fo:inline>
                    
                </fo:basic-link>
            </fo:block>
        </fo:block>
    </xsl:template>
    
    
</xsl:stylesheet>