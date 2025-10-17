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
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">

    <!-- Scriptorium added the following templates for general use throughout the book. -->
<!--    <!-\- No longer used.  Derelict. -\->
    <xsl:template name="oddHeader">
        <fo:block xsl:use-attribute-sets="__body__odd__header">
            <fo:retrieve-marker retrieve-class-name="current-h2"/>
        </fo:block>
    </xsl:template>

    <!-\- No longer used.  Derelict. -\->
    <xsl:template name="evenHeader">
        <xsl:param name="type"/>
        <xsl:comment>type = <xsl:value-of select="$type"/></xsl:comment>
        <fo:block xsl:use-attribute-sets="__body__even__header">
            <xsl:if test="contains($type,'chapter') and $folio-in-headers='yes'">
                <!-\- TODO: This needs to come from a variable, not hard-coded text. -\->
                <xsl:text>Chapter </xsl:text>
                <fo:retrieve-marker retrieve-class-name="current-topic-number"/>
                <xsl:text>: </xsl:text>
            </xsl:if>
            <xsl:if test="contains($type,'appendix') and $folio-in-headers='yes'">
                <!-\- TODO: This needs to come from a variable, not hard-coded text. -\->
                <xsl:text>Appendix </xsl:text>
                <fo:retrieve-marker retrieve-class-name="current-topic-number"/>
                <xsl:text>: </xsl:text>
            </xsl:if>
            <fo:retrieve-marker retrieve-class-name="current-header"/>
        </fo:block>
    </xsl:template>-->

    <xsl:template name="get_product_info">
        <xsl:variable name="prodinfo"
            select="$map/*[contains(@class, ' map/topicmeta ')][1]/
                                                   *[contains(@class, ' topic/prodinfo ')][1]"/>

        <fo:inline font-weight="bold">
            <!-- [SP] Changed to prognum. -->
            <xsl:value-of select="$map//*[contains(@class,' bookmap/bookpartno ')][1]"/>
        </fo:inline>
        <xsl:variable name="vrmlist" select="$prodinfo/*[contains(@class,' topic/vrmlist ')]"/>
        <xsl:text> • Rev </xsl:text>
        <xsl:value-of select="$vrmlist/*[contains(@class,' topic/vrm ')][1]/@version"/>
        <xsl:text> • </xsl:text>
        <xsl:value-of select="$vrmlist/*[contains(@class,' topic/vrm ')][1]/@release"/>
    </xsl:template>

    <xsl:template name="oddFooter">
        <fo:block xsl:use-attribute-sets="__body__odd__footer">
            <fo:list-block>
                <fo:list-item>
                    <fo:list-item-label>
                        <fo:block text-align="left" margin-left="{$header-margin-left}">
<!--                            <xsl:call-template name="get_product_info"/>-->
                        </fo:block>
                    </fo:list-item-label>
                    <fo:list-item-body>
                        <fo:block text-align="right">
                            <fo:page-number/>
                        </fo:block>
                    </fo:list-item-body>
                </fo:list-item>
            </fo:list-block>
        </fo:block>
    </xsl:template>

    <xsl:template name="evenFooter">
        <fo:block xsl:use-attribute-sets="__body__even__footer">
            <fo:list-block>
                <fo:list-item>
                    <fo:list-item-label>
                        <fo:block text-align="left" margin-left="0in">
                            <fo:page-number/>
                        </fo:block>
                    </fo:list-item-label>
                    <fo:list-item-body>
                        <fo:block text-align="left" margin-left="{$header-margin-left}">
<!--                            <xsl:call-template name="get_product_info"/>-->
                        </fo:block>
                    </fo:list-item-body>
                </fo:list-item>
            </fo:list-block>
        </fo:block>
    </xsl:template>

    <!-- Create layout for common heads. -->
    <xsl:template name="header_layout">
        <xsl:param name="side" select="'odd'"/>

        <fo:block>
            <xsl:call-template name="processAttrSetReflection">
                <xsl:with-param name="attrSet" select="concat($side,'__header')"/>
                <xsl:with-param name="path" select="'../../cfg/fo/attrs/spdf2_commons-attr.xsl'"/>
                <!--                <xsl:with-param name="path" select="'../../cfg/fo/attrs/commons-attr.xsl'"/>-->
            </xsl:call-template>

            <fo:block xsl:use-attribute-sets="__header__current__title">
                <fo:retrieve-marker retrieve-class-name="current-header"/>
            </fo:block>
        </fo:block>

    </xsl:template>



    <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
    <!-- [SP] The OT offers many, many variations for headers and footers for different sections of a book,
         and a multitude of locations (first, odd, even, last). The SPDF plugin simplifies this
         by using the same odd/even headers and footers across all pages. If you need a bit more 
         diversity, modify these templates as necessary (or revert back to the original 
         static-content.xsl templates).
    -->
    <xsl:template name="insertBodyOddHeader">

        <fo:static-content flow-name="odd-body-header">
            <xsl:call-template name="header_layout">
                <xsl:with-param name="side" select="'odd'"/>
            </xsl:call-template>
        </fo:static-content>

    </xsl:template>

    <xsl:template name="insertBodyEvenHeader">
        <fo:static-content flow-name="even-body-header">
            <xsl:call-template name="header_layout">
                <xsl:with-param name="side" select="'even'"/>
            </xsl:call-template>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyFirstHeader">
        <!-- No header on first body pages. -->
                <fo:static-content flow-name="first-body-header">
                <xsl:call-template name="header_layout">
                    <xsl:with-param name="side" select="'odd'"/>
                </xsl:call-template>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyFirstFooter">
        <fo:static-content flow-name="first-body-footer">
            <xsl:call-template name="oddFooter"/>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyLastHeader">
        <fo:static-content flow-name="last-body-header">
            <xsl:choose>
                <xsl:when test="$last-page = 'blank'">
                    <fo:block xsl:use-attribute-sets="__body__last__header"> </fo:block>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Last is only used when the page is last and contains no content.
                         That implies it's always going to be an even page. -->
                    <xsl:call-template name="header_layout">
                        <xsl:with-param name="side" select="'even'"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
            
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyLastFooter">
        <fo:static-content flow-name="last-body-footer">
            <xsl:choose>
                <xsl:when test="$last-page = 'blank'">
                    <fo:block xsl:use-attribute-sets="__body__last__footer"> </fo:block>                    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="evenFooter"/>
                </xsl:otherwise>
            </xsl:choose>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyFootnoteSeparator">
        <fo:static-content flow-name="xsl-footnote-separator">
            <fo:block>
                <fo:leader xsl:use-attribute-sets="__body__footnote__separator"/>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyOddFooter">
        <fo:static-content flow-name="odd-body-footer">
            <xsl:call-template name="oddFooter"/>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyEvenFooter">
        <fo:static-content flow-name="even-body-footer">
            <xsl:call-template name="evenFooter"/>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertTocOddHeader">
        <fo:static-content flow-name="odd-toc-header">
            <xsl:call-template name="header_layout">
                <xsl:with-param name="side" select="'odd'"/>
            </xsl:call-template>
        </fo:static-content>

    </xsl:template>

    <xsl:template name="insertTocEvenHeader">
        <fo:static-content flow-name="even-toc-header">
            <xsl:call-template name="header_layout">
                <xsl:with-param name="side" select="'even'"/>
            </xsl:call-template>
        </fo:static-content>

    </xsl:template>

    <xsl:template name="insertTocOddFooter">
        <fo:static-content flow-name="odd-toc-footer">
            <xsl:call-template name="oddFooter"/>
        </fo:static-content>

    </xsl:template>

    <xsl:template name="insertTocEvenFooter">
        <fo:static-content flow-name="even-toc-footer">
            <xsl:call-template name="evenFooter"/>
        </fo:static-content>

    </xsl:template>

    <xsl:template name="insertIndexOddHeader">
        <fo:static-content flow-name="odd-index-header">
            <xsl:call-template name="header_layout">
                <xsl:with-param name="side" select="'odd'"/>
            </xsl:call-template>
        </fo:static-content>

    </xsl:template>

    <xsl:template name="insertIndexEvenHeader">
        <fo:static-content flow-name="even-index-header">
            <xsl:call-template name="header_layout">
                <xsl:with-param name="side" select="'even'"/>
            </xsl:call-template>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertIndexOddFooter">
        <fo:static-content flow-name="odd-index-footer">
            <xsl:call-template name="oddFooter"/>
        </fo:static-content>

    </xsl:template>

    <xsl:template name="insertIndexEvenFooter">
        <fo:static-content flow-name="even-index-footer">
            <xsl:call-template name="evenFooter"/>
        </fo:static-content>
    </xsl:template>
    
    <xsl:template name="insertColophonFirstFooter">
        <fo:static-content flow-name="first-body-footer">
            <xsl:call-template name="oddFooter"/>
        </fo:static-content>
    </xsl:template>
    

    <xsl:template name="insertColophonOddHeader">
        <fo:static-content flow-name="odd-body-header">
            <xsl:call-template name="header_layout">
                <xsl:with-param name="side" select="'odd'"/>
            </xsl:call-template>
        </fo:static-content>
        
    </xsl:template>
    
    <xsl:template name="insertColophonEvenHeader">
        <fo:static-content flow-name="even-body-header">
            <xsl:call-template name="header_layout">
                <xsl:with-param name="side" select="'even'"/>
            </xsl:call-template>
        </fo:static-content>
    </xsl:template>
    
    <xsl:template name="insertColophonOddFooter">
        <fo:static-content flow-name="odd-body-footer">
            <xsl:call-template name="oddFooter"/>
        </fo:static-content>
        
    </xsl:template>
    
    <xsl:template name="insertColophonEvenFooter">
        <fo:static-content flow-name="even-body-footer">
            <xsl:call-template name="evenFooter"/>
        </fo:static-content>
    </xsl:template>
    
    <xsl:template name="insertPrefaceOddHeader">
        <fo:static-content flow-name="odd-body-header">
            <xsl:call-template name="header_layout">
                <xsl:with-param name="side" select="'odd'"/>
            </xsl:call-template>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceEvenHeader">
        <fo:static-content flow-name="even-body-header">
            <xsl:call-template name="header_layout">
                <xsl:with-param name="side" select="'even'"/>
            </xsl:call-template>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceFirstHeader">
        <fo:static-content flow-name="first-body-header">
            <xsl:call-template name="header_layout">
                <xsl:with-param name="side" select="'odd'"/>
            </xsl:call-template>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceFirstFooter">
        <fo:static-content flow-name="first-body-footer">
            <xsl:call-template name="oddFooter"/>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceLastHeader">
        <!-- Direct copy of pdf2 plugin, doesn't insert anything. -->
        <fo:static-content flow-name="last-body-header">
            <fo:block xsl:use-attribute-sets="__body__last__header"> </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceLastFooter">
        <!-- Direct copy of pdf2 plugin, doesn't insert anything. -->
        <fo:static-content flow-name="last-body-footer">
            <fo:block xsl:use-attribute-sets="__body__last__footer"> </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceFootnoteSeparator">
        <fo:static-content flow-name="xsl-footnote-separator">
            <fo:block>
                <fo:leader xsl:use-attribute-sets="__body__footnote__separator"/>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceOddFooter">
        <fo:static-content flow-name="odd-body-footer">
            <xsl:call-template name="oddFooter"/>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceEvenFooter">
        <fo:static-content flow-name="even-body-footer">
            <xsl:call-template name="evenFooter"/>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertFrontMatterOddHeader">
        <!-- [SP] 2014-03-31: Commented out for FOP testing. -->
<!--        <fo:static-content flow-name="odd-frontmatter-header">
            <xsl:call-template name="header_layout">
                <xsl:with-param name="side" select="'odd'"/>
            </xsl:call-template>
        </fo:static-content>-->
    </xsl:template>

    <xsl:template name="insertFrontMatterEvenHeader">
        <fo:static-content flow-name="even-frontmatter-header">
            <xsl:call-template name="header_layout">
                <xsl:with-param name="side" select="'even'"/>
            </xsl:call-template>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertFrontMatterLastHeader">
        <fo:static-content flow-name="last-frontmatter-header">
            <!-- Essentially reproduces pdf2 action.  -->
            <xsl:call-template name="header_layout">
                <xsl:with-param name="side" select="'even'"/>
            </xsl:call-template>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertFrontMatterLastFooter">
        <!-- Ditto on comment in LastHeader. -->
        <fo:static-content flow-name="last-frontmatter-footer">
            <xsl:call-template name="evenFooter"/>
        </fo:static-content>
    </xsl:template>

    <!-- [SP] Because we're using footnotes to force the trademark statement to the bottom of p.ii, 
             we don't want a footnote separator appearing.  This comment turns the separator off. -->
    <xsl:template name="insertFrontMatterFootnoteSeparator">
        <fo:static-content flow-name="xsl-footnote-separator">
            <fo:block>
                <!--<fo:leader xsl:use-attribute-sets="__body__footnote__separator"/>-->
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <!-- Override to insert image, if one is defined. -->
    <xsl:template name="insertFrontMatterOddFooter">
        <xsl:variable name="bookmeta" select="//*[contains(@class,' bookmap/bookmeta ')]"/>

        <fo:static-content flow-name="first-frontmatter-footer">

            <fo:block xsl:use-attribute-sets="__frontmatter__first__footer">
                <xsl:variable name="cover_image"
                    select="$bookmeta/*[contains(@class,' topic/data ')]/*[contains(@class,' topic/image ')]/@href"/>
                <xsl:if test="$cover_image != ''">
                    <xsl:variable name="cover_image_path"
                        select="concat($input.dir.url, $cover_image)"/>
                    <xsl:comment>$cover_image_path is <xsl:value-of select="$cover_image_path"/></xsl:comment>
                    <fo:float>
                        <fo:block>
                            <fo:external-graphic src="url({$cover_image_path})"
                                xsl:use-attribute-sets="image"/>
                        </fo:block>
                    </fo:float>
                </xsl:if>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertFrontMatterEvenFooter">
        <fo:static-content flow-name="even-frontmatter-footer">
            <xsl:call-template name="evenFooter"/>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertGlossaryOddHeader">
        <fo:static-content flow-name="odd-glossary-header">
            <xsl:call-template name="header_layout">
                <xsl:with-param name="side" select="'odd'"/>
            </xsl:call-template>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertGlossaryEvenHeader">
        <fo:static-content flow-name="even-glossary-header">
            <xsl:call-template name="header_layout">
                <xsl:with-param name="side" select="'even'"/>
            </xsl:call-template>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertGlossaryOddFooter">
        <fo:static-content flow-name="odd-glossary-footer">
            <xsl:call-template name="oddFooter"/>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertGlossaryEvenFooter">
        <fo:static-content flow-name="even-glossary-footer">
            <xsl:call-template name="evenFooter"/>
        </fo:static-content>
    </xsl:template>
    
    <xsl:template name="insertColophonStaticContents">
        <xsl:call-template name="insertColophonOddFooter"/>
        <xsl:if test="$mirror-page-margins">
            <xsl:call-template name="insertColophonEvenFooter"/>
        </xsl:if>
        <xsl:call-template name="insertColophonOddHeader"/>
        <xsl:if test="$mirror-page-margins">
            <xsl:call-template name="insertColophonEvenHeader"/>
        </xsl:if>
    </xsl:template>
    
   <!-- <xsl:template name="insertColophonStaticContents">
        <xsl:call-template name="insertBodyFootnoteSeparator"/>
        <xsl:call-template name="insertColophonOddFooter"/>
        <xsl:if test="$mirror-page-margins">
            <xsl:call-template name="insertColophonEvenFooter"/>
        </xsl:if>
        <xsl:call-template name="insertColophonOddHeader"/>
        <xsl:if test="$mirror-page-margins">
            <xsl:call-template name="insertColophonEvenHeader"/>
        </xsl:if>
        <xsl:call-template name="insertColophonFirstHeader"/>
        <xsl:call-template name="insertColophonFirstFooter"/>
        <xsl:call-template name="insertColophonLastHeader"/>
        <xsl:call-template name="insertColophonLastFooter"/>
    </xsl:template>-->
    

</xsl:stylesheet>
