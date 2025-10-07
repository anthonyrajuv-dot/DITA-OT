<?xml version='1.0' encoding="UTF-8"?>

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
    xmlns:xs="http://www.w3.org/2001/XMLSchema"     xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    xmlns:exsl="http://exslt.org/common"     xmlns:exslf="http://exslt.org/functions"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:dita2xslfo="http://dita-ot.sourceforge.net/ns/200910/dita2xslfo"
    extension-element-prefixes="exsl"
    exclude-result-prefixes="xs opentopic-func exslf exsl dita2xslfo"
    version="2.0">

    
    <!-- [SP] 29-Oct-2012: Modify basic tgroup to handle tables without heads. -->
    <xsl:template match="*[contains(@class, ' topic/tgroup ')]">
        <xsl:if test="not(@cols)">
            <xsl:call-template name="output-message">
                <xsl:with-param name="msgnum">006</xsl:with-param>
                <xsl:with-param name="msgsev">E</xsl:with-param>
            </xsl:call-template>
        </xsl:if>
        
        <xsl:variable name="scale">
            <xsl:call-template name="getTableScale"/>
        </xsl:variable>
        
        <xsl:variable name="table">
            <fo:table xsl:use-attribute-sets="table.tgroup">
                <xsl:call-template name="commonattributes"/>
                
                <xsl:call-template name="displayAtts">
                    <xsl:with-param name="element" select=".."/>
                </xsl:call-template>
                
                <xsl:if test="(parent::*/@pgwide) = '1'">
                    <xsl:attribute name="start-indent">0</xsl:attribute>
                    <xsl:attribute name="end-indent">0</xsl:attribute>
                    <xsl:attribute name="width">auto</xsl:attribute>
                </xsl:if>
                
                <xsl:choose>
                    <!-- If there is no table head specified, but there IS a title... -->
                    <xsl:when test="not(*[contains(@class,' topic/thead ')]) and preceding-sibling::*[contains(@class,' topic/title ')]">
                        <!--<xsl:message>No head in table <xsl:value-of select="preceding-sibling::*[contains(@class,' topic/title ')]"/></xsl:message>-->
                        <!-- Because there is no head, we have to create one artificially (and handle all the group elements by hand. -->
                        <xsl:apply-templates select="*[contains(@class,' topic/colspec ')]"/>
                        <xsl:call-template name="create_header"/>
                        <xsl:apply-templates select="*[contains(@class,' topic/tbody ')]"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates/>
                    </xsl:otherwise>
                </xsl:choose>
                
            </fo:table>
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="not($scale = '')">
                <xsl:apply-templates select="exsl:node-set($table)" mode="setTableEntriesScale"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="$table"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- [SP] 29-Oct-2012: Create a header by hand, because there is no thead. -->
    <xsl:template name="create_header">
        <fo:table-header xsl:use-attribute-sets="tgroup.thead">
            <xsl:call-template name="test.axf.footers"/>
            <xsl:call-template name="add-caption"/>
        </fo:table-header>
    </xsl:template>    
    

   <!-- [SP] 10-Jan-2013: Footnotes in table headers cause all sorts of problems when the table wraps 
                           across multiple pages.  This fix prevents the footnote from being repeated on subsequent pages.
                           It's not really an ideal solution, but it's the only one that works now. -->
    
    <xsl:template name="test.axf.footers">
        <xsl:choose>
            <xsl:when test="$pdfFormatter='ah'">
                <xsl:attribute name="axf:repeat-footnote-in-table-header">false</xsl:attribute>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    

    <!-- [SP] Add table title to table head. -->
    <xsl:template match="*[contains(@class, ' topic/thead ')]">
        <fo:table-header xsl:use-attribute-sets="tgroup.thead">
            <xsl:call-template name="test.axf.footers"/>
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="add-caption"/>
            <xsl:apply-templates/>
        </fo:table-header>
    </xsl:template>

    <!-- [SP] Create the row and cell for the caption. -->
    <xsl:template name="add-caption">
        <fo:table-row xsl:use-attribute-sets="caption.row">
            <xsl:call-template name="commonattributes"/>
            <fo:table-cell xsl:use-attribute-sets="caption.row.entry">
                <xsl:call-template name="commonattributes"/>

                <xsl:attribute name="number-columns-spanned">
                    <!-- [SP] 29-Oct-2012: Added or-self, because this could be called from tgroup, for tables without a header row. -->
                    <xsl:value-of
                        select="count(ancestor-or-self::*[contains(@class, ' topic/tgroup ')][1]/*[contains(@class, ' topic/colspec ')])"
                    />
                </xsl:attribute>

                <xsl:call-template name="generateTableEntryBorder"/>
                <fo:block xsl:use-attribute-sets="caption.row.entry__content">
                    <xsl:apply-templates
                        select="ancestor::*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]"
                        mode="table-caption"/>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>
    
<!--    add shading to entries marked outputclass="shade"-->
    
    <!--<xsl:template match="entry[@outputclass = 'shade']">
        <fo:table-cell background-color="#cccccc">
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="applySpansAttrs"/>
            <xsl:call-template name="applyAlignAttrs"/>
            <xsl:call-template name="generateTableEntryBorder"/>
            <fo:block xsl:use-attribute-sets="tbody.row.entry__content">
                <xsl:call-template name="processEntryContent"/>
                <xsl:text>FOUND IT!</xsl:text>
            </fo:block>
        </fo:table-cell>
    </xsl:template>-->
    
    

    <!-- [SP] Create the table caption, along with a continued label. -->
    <xsl:template match="*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]"
        mode="table-caption">
        
<!--        <xsl:variable name="table_number" select="count(preceding::*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]) + 1"/>
-->        
        <fo:block xsl:use-attribute-sets="table.title">
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="insertVariable">
                <xsl:with-param name="theVariableID" select="'Table'"/>
                <xsl:with-param name="theParameters">
                    <number>                        
                        <xsl:number level="any"
                            count="*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]"
                            from="/"/>
                    </number>
                    <title>
                        <xsl:apply-templates/>
                        <fo:retrieve-table-marker retrieve-class-name="continued" />
                    </title>
                </xsl:with-param>
            </xsl:call-template>
        </fo:block>
    </xsl:template>

    <!-- We're handling the title in header processing, so don't do anything with title. -->
    <xsl:template match="*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]"/>

    <!-- [SP] Add keep processing to improve pagination. -->
    <xsl:template match="*[contains(@class, ' topic/tbody ')]/*[contains(@class, ' topic/row ')]">
        <fo:table-row xsl:use-attribute-sets="tbody.row">
            <!-- Prevent widows and orphans. -->
            <xsl:if test="count(preceding-sibling::*[contains(@class, ' topic/row ')]) = 0">
                <xsl:attribute name="page-break-after">avoid</xsl:attribute>
            </xsl:if>
            <xsl:if test="count(following-sibling::*[contains(@class, ' topic/row ')]) = 0">
                <xsl:attribute name="page-break-before">avoid</xsl:attribute>
            </xsl:if>
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:table-row>
    </xsl:template>

    <!-- [SP] Override table cell processing to add the continuation marker. -->
    <xsl:template
        match="*[contains(@class, ' topic/tbody ')]/*[contains(@class, ' topic/row ')]/*[contains(@class, ' topic/entry ')]">
        <fo:table-cell xsl:use-attribute-sets="tbody.row.entry">
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="applySpansAttrs"/>
            <xsl:call-template name="applyAlignAttrs"/>
            <xsl:call-template name="generateTableEntryBorder"/>
            <xsl:if test="@outputclass = 'shade'">
                <xsl:attribute name="background-color">#cccccc</xsl:attribute>
            </xsl:if>
            <!-- Set continuation marker on first cell of first row only. -->
            <xsl:if test="count(preceding-sibling::*[contains(@class, ' topic/entry ')]) = 0 and
                count(parent::*/preceding-sibling::*[contains(@class, ' topic/row ')]) = 0">
                <fo:block>
                    <fo:marker marker-class-name="continued"/>
                </fo:block>
                <fo:block>
                    <fo:marker marker-class-name="continued">
                        <xsl:call-template name="insertVariable">
                            <xsl:with-param name="theVariableID" select="'Continued'"/>
                        </xsl:call-template>
                    </fo:marker>
                </fo:block>
            </xsl:if>
            <fo:block-container>
                <fo:block xsl:use-attribute-sets="tbody.row.entry__content">
                    <xsl:if test="ancestor::*[contains(@class,' learning2-d/lcAnswerContent2 ') and following-sibling::*[contains(@class,' learning2-d/lcCorrectResponse2 ')]]">
                        <xsl:attribute name="font-weight">bold</xsl:attribute>
                    </xsl:if>
                    <xsl:call-template name="processEntryContent"/>
                </fo:block>
            </fo:block-container>
        </fo:table-cell>
    </xsl:template>


    <!-- XML Exchange Table Model Document Type Definition default is 1 -->
    <xsl:variable name="table.rowsep-default" select="$cell-frames-row"/>
    <!-- XML Exchange Table Model Document Type Definition default is 1 -->
    <xsl:variable name="table.colsep-default" select="$cell-frames-column"/>


</xsl:stylesheet>
