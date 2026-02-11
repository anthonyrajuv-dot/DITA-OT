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
    xmlns:xs="http://www.w3.org/2001/XMLSchema"             
    version="2.0">

    <xsl:attribute-set name="linklist.title">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <!--Common-->
    <xsl:attribute-set name="li.widows-orphans">
        <xsl:attribute name="keep-with-next.within-page">
            <xsl:choose>
                <xsl:when test="parent::*[contains(@class,' task/steps ')]">auto</xsl:when>
                <xsl:when test="count(parent::*/*[contains(@class,' topic/li ')]) &lt;= 3">auto</xsl:when>
                <xsl:when test="count(preceding-sibling::*[contains(@class,' topic/li ')]) &lt; 1">always</xsl:when>
                <xsl:when test="count(following-sibling::*[contains(@class,' topic/li ')]) = 1">always</xsl:when>
                <xsl:otherwise>auto</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="keep-with-previous.within-page">
            <xsl:choose>
                <xsl:when test="parent::*[contains(@class,' task/steps ')]">auto</xsl:when>
                <xsl:when test="count(parent::*/*[contains(@class,' topic/li ')]) &lt;= 3">auto</xsl:when>
                <!-- Ensure that last two items stay together. -->
<!--                <xsl:when test="count(following-sibling::*[contains(@class,' topic/li ')]) = 1">always</xsl:when>-->
                <xsl:when test="count(following-sibling::*[contains(@class,' topic/li ')]) = 1">auto</xsl:when>
                <!-- Ensure that first item stays with stem. -->
                <xsl:when test="count(preceding-sibling::*[contains(@class,' topic/li ')]) = 0">auto</xsl:when>
                <xsl:otherwise>auto</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        
    </xsl:attribute-set>
    
    <xsl:attribute-set name="sli.widows-orphans">
        <xsl:attribute name="keep-with-next.within-page">
            <xsl:choose>
                <xsl:when test="count(parent::*/*[contains(@class,' topic/sli ')]) &lt;= 3">auto</xsl:when>
                <xsl:when test="count(preceding-sibling::*[contains(@class,' topic/sli ')]) &lt; 1">always</xsl:when>
                <xsl:when test="count(following-sibling::*[contains(@class,' topic/sli ')]) = 1">always</xsl:when>
                <xsl:otherwise>auto</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="keep-with-previous.within-page">
            <xsl:choose>
                <xsl:when test="count(parent::*/*[contains(@class,' topic/sli ')]) &lt;= 3">auto</xsl:when>
                <!-- Ensure that last two items stay together. -->
                <xsl:when test="count(following-sibling::*[contains(@class,' topic/sli ')]) = 1">always</xsl:when>
                <!-- Ensure that first item stays with stem. -->
                <xsl:when test="count(preceding-sibling::*[contains(@class,' topic/sli ')]) = 0">auto</xsl:when>
                <xsl:otherwise>auto</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        
    </xsl:attribute-set>
    
    
    <!--Unordered list-->
    <xsl:attribute-set name="ul" use-attribute-sets="common.block">
        <!-- From lists-attr.xsl (but just in case you need to fiddle with it...) -->
        <!--   <xsl:attribute name="provisional-distance-between-starts">5mm</xsl:attribute>
               <xsl:attribute name="provisional-label-separation">1mm</xsl:attribute>-->
        <xsl:attribute name="space-after.optimum">7pt</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-before.optimum">2pt</xsl:attribute>
        <xsl:attribute name="space-before.maximum">4pt</xsl:attribute>
        <!-- [SP] Added keep-together. -->
        <!--   And turned off again...     -->
<!--        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>-->
                <xsl:attribute name="margin-left">
                    <xsl:value-of select="$ul-indent"/>
                </xsl:attribute>
    </xsl:attribute-set>

    <!-- [SP] Added Second-level Unordered list-->
    <xsl:attribute-set name="ul-2">
        <xsl:attribute name="provisional-distance-between-starts">5mm</xsl:attribute>
        <xsl:attribute name="provisional-label-separation">1mm</xsl:attribute>
        <xsl:attribute name="space-after.optimum">7pt</xsl:attribute>
        <xsl:attribute name="space-before.optimum">2pt</xsl:attribute>
        <!-- [SP] Added keep-together. -->
        <xsl:attribute name="keep-together.within-column">always</xsl:attribute>
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$ul-indent-2"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="ul.li" use-attribute-sets="li.widows-orphans">
        <xsl:attribute name="space-before">
            <xsl:value-of select="$ul-li-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="space-before.optimum">
            <xsl:value-of select="$ul-li-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$ul-li-space-after"/>
        </xsl:attribute>
        <xsl:attribute name="space-after.optimum">
            <xsl:value-of select="$ul-li-space-after"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ul.li__label">
        <xsl:attribute name="keep-together.within-line">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>
        <xsl:attribute name="end-indent">label-end()</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ul.li__label__content">
        <!-- [SP] 08-Jan-2013: Had to specify the font and size, which is dependent on level. -->
        <xsl:attribute name="font-family">SansNarrow</xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:variable name="level" as="xs:integer">
                <xsl:apply-templates select="." mode="get-list-level"/>
            </xsl:variable>
            <!--<xsl:choose>
                <xsl:when test="$level = 1">
                    <xsl:value-of select="$ul-li-bullet-size"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$ul-li2-bullet-size"/>
                </xsl:otherwise>
            </xsl:choose>-->
        </xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ul.li__body">
        <xsl:attribute name="start-indent">body-start()</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ul.li__content">
    </xsl:attribute-set>

    <!--Ordered list-->
    
<!--    this is a test-->
    
    <xsl:attribute-set name="ol" use-attribute-sets="common.block">
        <xsl:attribute name="provisional-distance-between-starts">5mm</xsl:attribute>
        <xsl:attribute name="provisional-label-separation">1mm</xsl:attribute>
        <xsl:attribute name="space-after.optimum">7pt</xsl:attribute>
        <xsl:attribute name="space-before.optimum">7pt</xsl:attribute>
		  <xsl:attribute name="margin-left">
		  	<xsl:value-of select="$ol-indent"/>
		  </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ol.li" use-attribute-sets="li.widows-orphans">
        <xsl:attribute name="space-before">
            <xsl:value-of select="$ol-li-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="space-before.optimum">
            <xsl:value-of select="$ol-li-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$ol-li-space-after"/>
        </xsl:attribute>
        <xsl:attribute name="space-after.optimum">
            <xsl:value-of select="$ol-li-space-after"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ol.li__label">
        <xsl:attribute name="keep-together.within-line">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>
        <xsl:attribute name="end-indent">label-end()</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ol.li__label__content">
        <!-- Scriptorium changed alignment to right for consistent spacing between label and text. -->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <!-- Made numbers normal. -->
        <xsl:attribute name="font-weight">normal</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ol.li__body">
        <xsl:attribute name="start-indent">body-start()</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="ol.li__content">
    </xsl:attribute-set>

    <!--Simple list-->
    <xsl:attribute-set name="sl.sli" use-attribute-sets="sli.widows-orphans">
        <xsl:attribute name="space-before">
            <xsl:value-of select="$sl-sli-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="space-before.optimum">
            <xsl:value-of select="$sl-sli-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$sl-sli-space-after"/>
        </xsl:attribute>
        <xsl:attribute name="space-after.optimum">
            <xsl:value-of select="$sl-sli-space-after"/>
        </xsl:attribute>
    </xsl:attribute-set>
        
    <xsl:attribute-set name="sl.sli" use-attribute-sets="sli.widows-orphans">
        <xsl:attribute name="space-after.optimum">1.5pt</xsl:attribute>
        <xsl:attribute name="space-before.optimum">1.5pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="sl.sli__label">
        <xsl:attribute name="keep-together.within-line">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>
        <xsl:attribute name="end-indent">label-end()</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="sl.sli__label__content">
        <xsl:attribute name="text-align">left</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="sl.sli__body">
        <xsl:attribute name="start-indent">body-start()</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="sl.sli__content">
    </xsl:attribute-set>

    <!-- Block-mode dl list styles.  Because these are handled by spdf2_lists.xsl. -->
    <xsl:attribute-set name="dl__block">
    </xsl:attribute-set>
    
    <xsl:attribute-set name="dlentry__block">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$dl.block-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$dl.block-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$dl.block-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$dl.block-style"/>
        </xsl:attribute>
        
        <xsl:attribute name="space-before">
            <xsl:value-of select="$dl.block-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="space-before">
            <xsl:value-of select="$dl.block-space-after"/>
        </xsl:attribute>
<!--        <xsl:attribute name="space-before.precedence">0</xsl:attribute>
        <xsl:attribute name="space-after.precedence">10</xsl:attribute>-->
    </xsl:attribute-set>
    
    <xsl:attribute-set name="dlentry.dt__block">
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$dl.block-dt-weight"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="dlentry.dd__block">
        <!-- [SP] Commented out to prevent indentation. -->
        <!--<xsl:attribute name="start-indent">
            <xsl:value-of select="$dl.block-dd-start-indent"/>
        </xsl:attribute>-->
    </xsl:attribute-set>
    
    
</xsl:stylesheet>