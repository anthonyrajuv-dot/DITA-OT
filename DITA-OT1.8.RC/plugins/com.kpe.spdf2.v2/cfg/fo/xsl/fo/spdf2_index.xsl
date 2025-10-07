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

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:exsl="http://exslt.org/common"
    xmlns:exslf="http://exslt.org/functions"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:comparer="com.idiominc.ws.opentopic.xsl.extension.CompareStrings"
    extension-element-prefixes="exsl"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
    exclude-result-prefixes="opentopic-index exsl comparer opentopic-func exslf ot-placeholder">

    <!-- [SP] Make en-space. -->
    <xsl:variable name="index.separator">
        <xsl:text>&#x2002;</xsl:text>
    </xsl:variable>


    <xsl:template match="opentopic-index:see-also-childs" mode="index-postprocess">
        <fo:block xsl:use-attribute-sets="index.entry__content">
            <fo:inline xsl:use-attribute-sets="index.see-also.label">
                <xsl:call-template name="insertVariable">
                    <xsl:with-param name="theVariableID" select="'Index See Also String'"/>
                </xsl:call-template>
            </fo:inline>
            <!-- [SP] Remove basic-link to target until we figure out why we're getting errors. -->
            <!--<fo:basic-link>
                <xsl:attribute name="internal-destination">
                    <xsl:apply-templates select="opentopic-index:index.entry[1]"
                        mode="get-see-destination"/>
                </xsl:attribute>-->
            <xsl:apply-templates select="opentopic-index:index.entry[1]" mode="get-see-value"/>
            <!--            </fo:basic-link>-->
        </fo:block>
    </xsl:template>

    <xsl:template match="opentopic-index:see-childs" mode="index-postprocess">
        <xsl:choose>
            <xsl:when test="parent::*[@no-page = 'true']">
                <fo:inline xsl:use-attribute-sets="index.see.label">
                    <xsl:call-template name="insertVariable">
                        <xsl:with-param name="theVariableID" select="'Index See String'"/>
                    </xsl:call-template>
                </fo:inline>
                <!-- [SP] Remove basic-link to target until we figure out why we're getting errors. -->
                <!--            <fo:basic-link>
                    <xsl:attribute name="internal-destination">
                        <xsl:apply-templates select="opentopic-index:index.entry[1]"
                            mode="get-see-destination"/>
                    </xsl:attribute>-->
                <xsl:apply-templates select="opentopic-index:index.entry[1]"
                        mode="get-see-value"/>
                <!--</fo:basic-link>-->
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="output-message">
                    <xsl:with-param name="msgnum">011</xsl:with-param>
                    <xsl:with-param name="msgsev">E</xsl:with-param>
                    <xsl:with-param name="msgparams">
                        <xsl:text>%1=</xsl:text>
                        <xsl:value-of
                            select="if (following-sibling::opentopic-index:see-also-childs) then 'index-see-also' else 'indexterm'"/>
                        <xsl:text>;</xsl:text>
                        <xsl:text>%2=</xsl:text>
                        <xsl:value-of select="../@value"/>
                    </xsl:with-param>
                </xsl:call-template>
                <fo:block xsl:use-attribute-sets="index.entry__content">
                    <fo:inline xsl:use-attribute-sets="index.see-also.label">
                        <xsl:call-template name="insertVariable">
                            <xsl:with-param name="theVariableID" select="'Index See Also String'"/>
                        </xsl:call-template>
                    </fo:inline>
                    <fo:basic-link>
                        <xsl:attribute name="internal-destination">
                            <xsl:apply-templates select="opentopic-index:index.entry[1]"
                                mode="get-see-destination"/>
                        </xsl:attribute>
                        <xsl:apply-templates select="opentopic-index:index.entry[1]"
                            mode="get-see-value"/>
                    </fo:basic-link>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <xsl:template match="*" mode="make-index-ref">
        <xsl:param name="idxs" select="()"/>
        <xsl:param name="inner-text" select="()"/>
        <xsl:param name="no-page"/>
        <fo:block xsl:use-attribute-sets="index.term">
            <!-- change test from "position() = 1" to "has children". -->
            <xsl:if test="child::opentopic-index:entry">
                <xsl:attribute name="keep-with-next">always</xsl:attribute>
            </xsl:if>
            <fo:inline>
                <xsl:choose>
                    <xsl:when test="$useFrameIndexMarkup ne 'true'">
                        <xsl:apply-templates select="$inner-text/node()"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="__formatText">
                            <xsl:with-param name="text" select="$inner-text"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </fo:inline>
            <!-- XXX: XEP has this, should base too? -->
            <!--xsl:for-each select="$idxs">
        <fo:inline id="{@value}"/>
      </xsl:for-each-->
            <xsl:if test="not($no-page)">
                <xsl:if test="$idxs">
                    <xsl:copy-of select="$index.separator"/>
                    <fo:index-page-citation-list>
                        <xsl:for-each select="$idxs">
                            <!-- [SP] remove spaces from index target keys. -->
                            <fo:index-key-reference ref-index-key="{@value}"
                                xsl:use-attribute-sets="__index__page__link"/>
                        </xsl:for-each>
                    </fo:index-page-citation-list>
                </xsl:if>
            </xsl:if>
            <!-- [SP] Fix 1.6 bug. using see-also-childs here was introducing extra 
                      (poorly indented) output in the wrong place. Removed "or opentopic-index:see-also-childs" -->
            <xsl:for-each select="opentopic-index:see-childs">
                <!--                <xsl:for-each select="opentopic-index:see-childs | opentopic-index:see-also-childs">-->
                <xsl:apply-templates select="." mode="index-postprocess"/>
            </xsl:for-each>
        </fo:block>
    </xsl:template>




</xsl:stylesheet>
