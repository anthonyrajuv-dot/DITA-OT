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
    xmlns:fo="http://www.w3.org/1999/XSL/Format" version="1.0">

    <!-- Set basic text indent to 0. -->
    <xsl:variable name="toc.text-indent" select="'0pt'"/>
    <!-- Set sub-entry indent to 18pt. -->
    <xsl:variable name="toc.toc-indent" select="'18pt'"/>


    <!-- Override OT with externalized attribute values. -->
    <xsl:attribute-set name="__toc__header">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$chap-appx-title-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$chap-appx-title-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$chap-appx-title-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$chap-appx-title-style"/>
        </xsl:attribute>
        <xsl:attribute name="margin-top">0pc</xsl:attribute>
        <xsl:attribute name="padding-top">0pc</xsl:attribute>
        <xsl:attribute name="padding-bottom">0.4pc</xsl:attribute>
        <xsl:attribute name="margin-bottom">1.0pc</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <!-- Scriptorium added border controls. -->
        <xsl:attribute name="border-bottom-style">
            <xsl:value-of select="$chap-appx-border-style"/>
        </xsl:attribute>
        <xsl:attribute name="border-bottom-width">
            <xsl:value-of select="$chap-appx-border-width"/>
        </xsl:attribute>
        <xsl:attribute name="border-bottom-color">
            <xsl:value-of select="$chap-appx-border-color"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__link">
        <xsl:attribute name="line-height">150%</xsl:attribute>
        <!--xsl:attribute name="font-size">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
            <xsl:value-of select="concat(string(20 - number($level) - 4), 'pt')"/>
        </xsl:attribute-->
    </xsl:attribute-set>

    <!-- [SP] Added section to level calculation. -->
    <xsl:attribute-set name="__toc__topic__content">
        <xsl:attribute name="padding-top">
            <xsl:variable name="level"
                select="count(ancestor-or-self::*[contains(@class, ' topic/topic ') or contains(@class, ' topic/section ')])"/>
            <xsl:choose>
                <xsl:when test="$level = 1">
                    <xsl:value-of select="$toc-chapter-space-above"/>
                </xsl:when>
                <xsl:otherwise>0pt</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="last-line-end-indent">-22pt</xsl:attribute>
        <xsl:attribute name="end-indent">22pt</xsl:attribute>
        <xsl:attribute name="text-indent">0in</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>

        <!-- Scriptorium parameterized font controls. Refer to basic-settings.xsl for the values of these variables. -->
        <!-- [SP] Added section to level calculation. -->
        <xsl:attribute name="font-size">
            <xsl:variable name="level"
                select="count(ancestor-or-self::*[contains(@class, ' topic/topic ') or contains(@class, ' topic/section ')])"/>
            <xsl:choose>
                <xsl:when test="$level = 1">
                    <xsl:value-of select="$toc-level-1-size"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$toc-level-2-size"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:variable name="level"
                select="count(ancestor-or-self::*[contains(@class, ' topic/topic ') or contains(@class, ' topic/section ')])"/>
            <xsl:choose>
                <xsl:when test="$level = 1">
                    <xsl:value-of select="$toc-level-1-weight"/>
                </xsl:when>
                <xsl:otherwise>normal</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__chapter__content" use-attribute-sets="__toc__topic__content">
        <!-- Scriptorium parameterized font controls. Refer to basic-settings.xsl for the values of these variables. -->
        <!-- [SP] Override text indent from topic__content.  -->
        <xsl:attribute name="text-indent">0in</xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$toc-chapter-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$toc-chapter-weight"/>
        </xsl:attribute>
        <xsl:attribute name="padding-top">
            <xsl:value-of select="$toc-chapter-space-above"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$toc-chapter-color"/>
        </xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <!-- [SP] Get the margins to play right in the list-block. -->
        <xsl:attribute name="margin-right">0pt</xsl:attribute>
        <xsl:attribute name="last-line-end-indent">0pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__appendix__content" use-attribute-sets="__toc__topic__content">
        <!-- Scriptorium parameterized font controls. Refer to basic-settings.xsl for the values of these variables. -->
        <xsl:attribute name="text-indent">0in</xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$toc-chapter-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$toc-chapter-weight"/>
        </xsl:attribute>
        <xsl:attribute name="padding-top">
            <xsl:value-of select="$toc-chapter-space-above"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$toc-chapter-color"/>
        </xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <!-- [SP] Get the margins to play right in the list-block. -->
        <xsl:attribute name="margin-right">0pt</xsl:attribute>
        <xsl:attribute name="last-line-end-indent">0pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__part__content" use-attribute-sets="__toc__topic__content">
        <!-- Scriptorium parameterized font controls. Refer to basic-settings.xsl for the values of these variables. -->
        <xsl:attribute name="font-size">
            <xsl:value-of select="$toc-part-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$toc-part-weight"/>
        </xsl:attribute>
        <xsl:attribute name="padding-top">
            <xsl:value-of select="$toc-part-space-above"/>
        </xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>
<!--    <xsl:attribute name="keep-with-next.within-column">
        <xsl:variable name="level"
            select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
        <xsl:variable name="mapTopicref" select="key('map-id', @id)[1]"/>
        <xsl:choose>
            <xsl:when test="$mapTopicref/ancestor::*[contains(@class, ' bookmap/part ')]">
                <xsl:value-of>always</xsl:value-of>
            </xsl:when>
            <xsl:when test="$level &lt; 2">
                <xsl:value-of>always</xsl:value-of>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of>auto</xsl:value-of>                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:attribute>
-->    

    <xsl:attribute-set name="__toc__preface__content" use-attribute-sets="__toc__topic__content">
        <!-- Scriptorium parameterized font controls. Refer to basic-settings.xsl for the values of these variables. -->
        <xsl:attribute name="font-size">
            <xsl:value-of select="$toc-chapter-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$toc-chapter-weight"/>
        </xsl:attribute>
        <xsl:attribute name="padding-top">
            <xsl:value-of select="$toc-chapter-space-above"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__notices__content" use-attribute-sets="__toc__topic__content">
        <!-- Scriptorium parameterized font controls. Refer to basic-settings.xsl for the values of these variables. -->
        <xsl:attribute name="font-size">
            <xsl:value-of select="$toc-chapter-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$toc-chapter-weight"/>
        </xsl:attribute>
        <xsl:attribute name="padding-top">
            <xsl:value-of select="$toc-chapter-space-above"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__toc__indent__index" use-attribute-sets="__toc__indent">
        <xsl:attribute name="start-indent"><xsl:value-of select="$side-col-width"/> + <xsl:value-of select="$toc.text-indent"/></xsl:attribute>
        <xsl:attribute name="space-before">10pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__toc__index__content" use-attribute-sets="__toc__topic__content">
        <!-- Scriptorium parameterized font controls. Refer to basic-settings.xsl for the values of these variables. -->
        <xsl:attribute name="font-size">
            <xsl:value-of select="$toc-chapter-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$toc-chapter-weight"/>
        </xsl:attribute>
        <xsl:attribute name="padding-top">
            <xsl:value-of select="$toc-chapter-space-above"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Added for back compatibility since __toc__content was renamed into __toc__topic__content-->
    <xsl:attribute-set name="__toc__content" use-attribute-sets="__toc__topic__content"> </xsl:attribute-set>

    <xsl:attribute-set name="__toc__title"> </xsl:attribute-set>

    <xsl:attribute-set name="__toc__page-number">
        <xsl:attribute name="start-indent">-<xsl:value-of select="$toc.text-indent"
            /></xsl:attribute>
        <xsl:attribute name="keep-together.within-line">always</xsl:attribute>
    </xsl:attribute-set>


    <xsl:attribute-set name="__toc__leader">
        <xsl:attribute name="leader-pattern">space</xsl:attribute>
        <xsl:attribute name="leader-length">
            <xsl:value-of select="$toc-leader-length"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- [SP] Added section to level calculation. -->
    <!--<xsl:attribute-set name="__toc__indent">
        <xsl:attribute name="margin-left">0pt
<!-\-            <xsl:variable name="level"
                select="count(ancestor-or-self::*[contains(@class, ' topic/topic ') or contains(@class, ' topic/section ')])"/>
            <xsl:choose>
                <xsl:when test="ancestor-or-self::*[contains(@class, ' topic/topic ') or contains(@class, ' topic/section ')]">
                    <xsl:value-of
                        select="concat(string($static-toc-indent + (number($level) * $incremental-toc-indent)), 'pt')"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of
                        select="concat(string($static-toc-indent + $incremental-toc-indent), 'pt')"
                    />
                </xsl:otherwise>
            </xsl:choose>-\->
        </xsl:attribute>
    </xsl:attribute-set>-->

    <!-- [SP] Account for chapters within parts. -->
    <xsl:attribute-set name="__toc__indent">
        <xsl:attribute name="start-indent">
            <xsl:variable name="level"
                select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
            <xsl:variable name="mapTopicref" select="key('map-id', @id)[1]"/>
            <xsl:variable name="normalized_level">
                <xsl:choose>
                    <xsl:when test="$mapTopicref/ancestor::*[contains(@class, ' bookmap/part ')]">
                        <xsl:value-of select="$level - 1 "/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$level"/>
                    </xsl:otherwise>                    
                </xsl:choose>
            </xsl:variable>

            <xsl:value-of
                select="concat($side-col-width, ' + (', string($normalized_level - 1), ' * ', $toc.toc-indent, ') + ', $toc.text-indent)"
            />
        </xsl:attribute>
                
        <!-- Frontmatter entries shouldn't be set with no line spacing. -->
    </xsl:attribute-set>


    <xsl:attribute-set name="__toc__mini">
        <xsl:attribute name="font-size">10.5pt</xsl:attribute>
        <xsl:attribute name="font-family">Sans</xsl:attribute>
        <xsl:attribute name="end-indent">5pt</xsl:attribute>
        <!-- Scriptorium added additional space after miniTOC. -->
        <xsl:attribute name="space-after.optimum">9pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini__header" use-attribute-sets="__toc__mini">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini__list">
        <xsl:attribute name="provisional-distance-between-starts">1.5pc</xsl:attribute>
        <xsl:attribute name="provisional-label-separation">1pc</xsl:attribute>
        <!-- Scriptorium added to space-after to set off the mini-list. -->
        <xsl:attribute name="space-after">14pt</xsl:attribute>
        <xsl:attribute name="space-before.optimum">9pt</xsl:attribute>
        <!-- Scriptorium added margin-left to indent the mini-list. -->
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$side-col-width"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini__label">
        <xsl:attribute name="keep-together.within-line">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>
        <xsl:attribute name="end-indent">label-end()</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini__body">
        <xsl:attribute name="start-indent">body-start()</xsl:attribute>
    </xsl:attribute-set>

    <!-- SF Bug 1815571: page-break-after must be on fo:table rather than fo:table-body
                         in order to produce valid XSL-FO 1.1 output. -->
    <xsl:attribute-set name="__toc__mini__table">
        <xsl:attribute name="table-layout">fixed</xsl:attribute>
        <xsl:attribute name="width">100%</xsl:attribute>
        <xsl:attribute name="page-break-after">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini__table__body">
        <!-- SF Bug 1815571: moved page-break-after to __toc__mini__table -->
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini__table__column_1">
        <xsl:attribute name="column-number">1</xsl:attribute>
        <xsl:attribute name="column-width">35%</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini__table__column_2">
        <xsl:attribute name="column-number">2</xsl:attribute>
        <xsl:attribute name="column-width">65%</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini__summary">
        <xsl:attribute name="padding-left">10pt</xsl:attribute>
        <xsl:attribute name="border-left">solid 1px black</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__topic__content__glossary"
        use-attribute-sets="__toc__chapter__content">
        <!-- Scriptorium modified attribute set to use the values for chapter headings -->
        <!--  <xsl:attribute name="last-line-end-indent">-22pt</xsl:attribute>
        <xsl:attribute name="end-indent">22pt</xsl:attribute>
        <xsl:attribute name="text-indent">-.2in</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">justify</xsl:attribute>
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-top">20pt</xsl:attribute> -->
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__indent__glossary" use-attribute-sets="__toc__indent">
        <!-- Scriptorium modified attribute set to use the values for chapter headings -->
        <!--  <xsl:attribute name="margin-left">72pt</xsl:attribute> -->
    </xsl:attribute-set>

</xsl:stylesheet>
