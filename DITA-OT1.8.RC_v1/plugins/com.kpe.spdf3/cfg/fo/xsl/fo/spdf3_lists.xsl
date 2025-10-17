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

<!-- Elements for steps have been relocated to task-elements.xsl -->
<!-- Templates for <dl> are in tables.xsl -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"         
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"    
    version="2.0">

    <!-- [SP] Added test for <sl> with outputclass="twocol". -->
    <xsl:template match="*[contains(@class, ' topic/sl ')]">
        <xsl:choose>
            <xsl:when test="@outputclass='twocol'">
               <xsl:call-template name="use-two-columns"/>                
            </xsl:when>
            <xsl:otherwise>
                <!-- Back to our regular programming. -->
                <fo:list-block xsl:use-attribute-sets="sl">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates/>
                </fo:list-block>                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Display the contents of an <sl> in two columns. -->
    <xsl:template name="use-two-columns">
        <xsl:variable name="item_count" select="ceiling(count(*[contains(@class, ' topic/sli ')]) div 2)"/>
        <xsl:variable name="left-items" select="*[contains(@class, ' topic/sli ')][position() &lt;= $item_count]"/>
        <xsl:variable name="right-items" select="*[contains(@class, ' topic/sli ')][position() &gt; $item_count]"/>
        
        <xsl:variable name="two-col-width" select="concat($column-width div 2,'pt')"/>        
        
        <fo:table>
            <xsl:call-template name="commonattributes"/>
            <fo:table-column column-width="{$two-col-width}"/>
            <fo:table-column column-width="{$two-col-width}"/>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell> <!-- First column -->
                        <fo:list-block xsl:use-attribute-sets="sl">
                            <xsl:apply-templates select="$left-items"/> 
                        </fo:list-block>
                    </fo:table-cell>
                    <fo:table-cell> <!-- Second column -->
                        <fo:list-block xsl:use-attribute-sets="sl">
                            <xsl:apply-templates select="$right-items"/> 
                        </fo:list-block>
                    </fo:table-cell>
                </fo:table-row>
             </fo:table-body>
        </fo:table>
    </xsl:template>
    
    <!--Definition list-->
    <!-- [SP] When <dl> has outputclass="block" use fo:block, rather than table layout. -->
    <xsl:template match="*[contains(@class, ' topic/dl ')]">
        
        <!-- [SP] Choose statement and test/otherwise commented out. 
            Source is not discriminating between block or table, so all dl content was being formatted as a table. 
            Should content specify block in the future, uncomment the entire xsl:choose logic in this template. -->
        
        <!--<xsl:choose>
            <xsl:when test="@outputclass = 'block'">-->
                <fo:block xsl:use-attribute-sets="dl__block">
                    <xsl:call-template name="commonattributes"/>
                    <!-- Usually a block style doesn't use heads, so ignore dlhead. -->
                    <xsl:choose>
                        <xsl:when test="contains(@otherprops,'sortable')">
                            <xsl:apply-templates select="*[contains(@class, ' topic/dlentry ')]" mode="block">
                                <xsl:sort select="opentopic-func:getSortString(normalize-space( opentopic-func:fetchValueableText(*[contains(@class, ' topic/dt ')]) ))" lang="{$locale}"/>
                            </xsl:apply-templates>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="*[contains(@class, ' topic/dlentry ')]" mode="block"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:block>
            <!--</xsl:when>
            <xsl:otherwise>
                <fo:table xsl:use-attribute-sets="dl">
                    <xsl:call-template name="commonattributes"/>
                    <fo:table-column column-width="20%"/>
                    <fo:table-column column-width="80%"/>
                    <xsl:apply-templates select="*[contains(@class, ' topic/dlhead ')]"/>
                    <fo:table-body xsl:use-attribute-sets="dl__body">
                        <xsl:choose>
                            <xsl:when test="contains(@otherprops,'sortable')">
                                <xsl:apply-templates select="*[contains(@class, ' topic/dlentry ')]">
                                    <xsl:sort select="opentopic-func:getSortString(normalize-space( opentopic-func:fetchValueableText(*[contains(@class, ' topic/dt ')]) ))" lang="{$locale}"/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="*[contains(@class, ' topic/dlentry ')]"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:table-body>
                </fo:table>
            </xsl:otherwise>
        </xsl:choose>-->
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' topic/dlentry ')]" mode="block">
        <fo:block xsl:use-attribute-sets="dlentry__block">
            <xsl:call-template name="commonattributes"/>
                <xsl:apply-templates select="*[contains(@class, ' topic/dt ')]" mode="block"/>
                <xsl:apply-templates select="*[contains(@class, ' topic/dd ')]" mode="block"/>
        </fo:block>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' topic/dt ')]" mode="block">
        <fo:block xsl:use-attribute-sets="dlentry.dt__block">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' topic/dd ')]" mode="block">
        <fo:block xsl:use-attribute-sets="dlentry.dd__block">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
    <!-- [SP] Use the OT 1.6 style for returning levels. -->
    <xsl:template match="*" mode="get-list-level" as="xs:integer">
        <xsl:value-of select="count(ancestor::*[contains(@class,' topic/ul ')])"/>
    </xsl:template>
        
    <xsl:template match="*[contains(@class, ' topic/ul ')]/*[contains(@class, ' topic/li ')]">
        <fo:list-item xsl:use-attribute-sets="ul.li">
            <fo:list-item-label xsl:use-attribute-sets="ul.li__label">
                <fo:block xsl:use-attribute-sets="ul.li__label__content">
                    <fo:inline>
                        <xsl:call-template name="commonattributes"/>
                    </fo:inline>
                    <!-- [SP] Select different bullet characters, depending on level.  -->
                    <xsl:variable name="level" as="xs:integer">
                        <xsl:apply-templates select="." mode="get-list-level"/>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="$level = 1">
                            <!-- [SP] I think this was an error, the inline was an empty tag. 
                                      Lift the bullet above the baseline.  -->
                            <fo:inline id="{@id}" baseline-shift="0pt">
                                <xsl:call-template name="insertVariable">
                                    <xsl:with-param name="theVariableID" select="'Unordered List bullet'"/>
                                </xsl:call-template>
                            </fo:inline>
                        </xsl:when>
                        
                        <xsl:when test="$level = 2">
                            <fo:inline id="{@id}" baseline-shift="0pt">
                                <xsl:call-template name="insertVariable">
                                    <xsl:with-param name="theVariableID" select="'Unordered List bullet level 2'"/>
                                </xsl:call-template>
                            </fo:inline>
                        </xsl:when>
                        
                        <xsl:otherwise>
                            <!--[SP] Currently no third-level bullets defined.-->
                            <xsl:message>SD_PDF ********** Used third-level bullet, but not defined. </xsl:message>
                        </xsl:otherwise>
                    </xsl:choose>
                    <!--                    <xsl:call-template name="insertVariable">
                        <xsl:with-param name="theVariableID" select="'Unordered List bullet'"/>
                    </xsl:call-template>-->
                    
                </fo:block>
            </fo:list-item-label>
            
            <fo:list-item-body xsl:use-attribute-sets="ul.li__body">
                <fo:block xsl:use-attribute-sets="ul.li__content">
                    <xsl:apply-templates/>
                </fo:block>
            </fo:list-item-body>
            
        </fo:list-item>
    </xsl:template>
    
    

</xsl:stylesheet>

