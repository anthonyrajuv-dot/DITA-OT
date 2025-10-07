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
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:rx="http://www.renderx.com/XSL/Extensions"
    version="2.0">

    <!-- !!!!!!! NOTE !!!!!!
       Attribute sets are additive. They do not behave like XSL templates.
       To override an attribute set, you must specify new values that replace 
       the values from commons-attr.xsl. -->

    <!-- common attribute sets -->

    <xsl:attribute-set name="common.border__top">
        <xsl:attribute name="border-top-style">
            <xsl:value-of select="$table-border-top-style"/>
        </xsl:attribute>
        <xsl:attribute name="border-top-width">
            <xsl:value-of select="$table-border-top-width"/>
        </xsl:attribute>
        <xsl:attribute name="border-top-color">
            <xsl:value-of select="$table-border-top-color"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="common.border__bottom">
        <xsl:attribute name="border-bottom-style">
            <xsl:value-of select="$table-border-bottom-style"/>
        </xsl:attribute>
        <xsl:attribute name="border-bottom-width">
            <xsl:value-of select="$table-border-bottom-width"/>
        </xsl:attribute>
        <xsl:attribute name="border-bottom-color">
            <xsl:value-of select="$table-border-bottom-color"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- Turn off left/right borders for tables. -->
    <xsl:attribute-set name="common.border__left">
        <xsl:attribute name="border-left-style">
            <xsl:value-of select="$table-border-left-style"/>
        </xsl:attribute>
        <xsl:attribute name="border-left-width">
            <xsl:value-of select="$table-border-left-width"/>
        </xsl:attribute>
        <xsl:attribute name="border-left-color">
            <xsl:value-of select="$table-border-left-color"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="common.border__right">
        <xsl:attribute name="border-right-style">
            <xsl:value-of select="$table-border-right-style"/>
        </xsl:attribute>
        <xsl:attribute name="border-right-width">
            <xsl:value-of select="$table-border-right-width"/>
        </xsl:attribute>
        <xsl:attribute name="border-right-color">
            <xsl:value-of select="$table-border-right-color"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="common.head__bottom">
        <xsl:attribute name="border-bottom-style">
            <xsl:value-of select="$table-head-bottom-style"/>
        </xsl:attribute>
        <xsl:attribute name="border-bottom-width">
            <xsl:value-of select="$table-head-bottom-width"/>
        </xsl:attribute>
        <xsl:attribute name="border-bottom-color">
            <xsl:value-of select="$table-head-bottom-color"/>
        </xsl:attribute>
    </xsl:attribute-set>
    

    <xsl:attribute-set name="common.border"
        use-attribute-sets="common.border__top common.border__right common.border__bottom common.border__left"/>

    <xsl:attribute-set name="common.noborder">
        <xsl:attribute name="border-left-style">none</xsl:attribute>
        <xsl:attribute name="border-right-style">none</xsl:attribute>
        <xsl:attribute name="border-top-style">none</xsl:attribute>
        <xsl:attribute name="border-bottom-style">none</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="base-font">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$default-font-size"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$default-line-height"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- titles -->
    <xsl:attribute-set name="common.title">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$level-1-family"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- paragraph-like blocks -->
    <xsl:attribute-set name="common.block">
        <xsl:attribute name="space-before">0.6em</xsl:attribute>
        <xsl:attribute name="space-after">0.6em</xsl:attribute>
    </xsl:attribute-set>


    <xsl:attribute-set name="common.link">
        <xsl:attribute name="color">
            <xsl:value-of select="$link-font-color"/>
        </xsl:attribute>
        <!-- Normally the size of a link is the same size as it's containing font.
          If you need to specify a size, do it here. -->
        <!--      <xsl:attribute name="font-size">
          <xsl:value-of select="$link-font-size"/>
      </xsl:attribute>-->
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$link-font-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$link-font-style"/>
        </xsl:attribute>
        <xsl:attribute name="border-bottom-style">
            <xsl:value-of select="$link-underscore-style"/>
        </xsl:attribute>
        <xsl:attribute name="border-bottom-width">
            <xsl:value-of select="$link-underscore-width"/>
        </xsl:attribute>
        <xsl:attribute name="border-bottom-color">
            <xsl:value-of select="$link-underscore-color"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- common element specific attribute sets -->

    <xsl:attribute-set name="tm">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="tm__content">
        <xsl:attribute name="font-size">75%</xsl:attribute>
        <xsl:attribute name="baseline-shift">20%</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="tm__content__service">
        <xsl:attribute name="font-size">40%</xsl:attribute>
        <xsl:attribute name="baseline-shift">50%</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="author"> 
        <xsl:attribute name="font-family">
            <xsl:value-of select="$author-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$author-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$author-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$author-style"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$author-color"/>
        </xsl:attribute>
        
    </xsl:attribute-set>

    <xsl:attribute-set name="source"> </xsl:attribute-set>

    <!-- [SP] The next three sets control the formatting of the chapter/appendix/part
              titles. There are three parts:
              * The word ("Chapter" or "Appendix" or "Part")
              * The number (or letter)
              * The actual title (topic/title).
              -->
    <!-- Allow more precise control over the chapter/appendix/part name. -->
    <xsl:attribute-set name="__part__frontmatter__name__inline">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$part-number-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$part-number-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$part-number-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$part-number-style"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$part-number-color"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__chapter__frontmatter__name__inline">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$chap-appx-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$chap-appx-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$chap-appx-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$chap-appx-style"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$chap-appx-color"/>
        </xsl:attribute>
    </xsl:attribute-set>
<!-- xxxxx -->
    <!-- Allow more precise control over the chapter/appendix/part number. -->
    <!--<xsl:attribute-set name="__chapter__frontmatter__number__inline">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$chap-appx-number-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$chap-appx-number-weight"/>
        </xsl:attribute>
    </xsl:attribute-set>-->

    <!-- Scriptorium: Chapter and appendix title -->
    <xsl:attribute-set name="topic.title">
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
        <xsl:attribute name="line-height">
            <xsl:value-of select="$chap-appx-title-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$chap-appx-title-color"/>
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
    <xsl:attribute-set name="final.exam.title">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$cover-level-1-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$cover-level-1-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$cover-level-1-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$cover-level-1-style"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$cover-level-1-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$cover-level-1-color"/>
        </xsl:attribute>
        <xsl:attribute name="margin-top">0pc</xsl:attribute>
        <xsl:attribute name="padding-top">0pc</xsl:attribute>
        <xsl:attribute name="padding-bottom">0.4pc</xsl:attribute>
        <xsl:attribute name="margin-bottom">1.0pc</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>

        <xsl:attribute name="text-align">center</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="final.exam.partno">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$cover-level-2-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$cover-level-2-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$cover-level-2-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$cover-level-2-style"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$cover-level-2-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$cover-level-2-color"/>
        </xsl:attribute>
        <xsl:attribute name="margin-top">0pc</xsl:attribute>
        <xsl:attribute name="padding-top">0pc</xsl:attribute>
        <xsl:attribute name="padding-bottom">0.4pc</xsl:attribute>
        <xsl:attribute name="margin-bottom">1.0pc</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>

        <xsl:attribute name="text-align">center</xsl:attribute>
    </xsl:attribute-set>
    
    
    <!-- Scriptorium: Part title -->
    <xsl:attribute-set name="part.title">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$part-title-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$part-title-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$part-title-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$part-title-style"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$part-title-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$part-title-color"/>
        </xsl:attribute>
        
        <xsl:attribute name="margin-top">0pc</xsl:attribute>
        <xsl:attribute name="padding-top">0pc</xsl:attribute>
        <xsl:attribute name="padding-bottom">0.4pc</xsl:attribute>
        <xsl:attribute name="margin-bottom">1.0pc</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        
        <xsl:attribute name="border-bottom-style">
            <xsl:value-of select="$part-border-style"/>
        </xsl:attribute>
        <xsl:attribute name="border-bottom-width">
            <xsl:value-of select="$part-border-width"/>
        </xsl:attribute>
        <xsl:attribute name="border-bottom-color">
            <xsl:value-of select="$part-border-color"/>
        </xsl:attribute>
        
    </xsl:attribute-set>
    
    <!-- Scriptorium: Frontmatter title -->
    <xsl:attribute-set name="topic.frontmatter.title">
        <!-- Scriptorium override title border. -->
        <xsl:attribute name="border-bottom">0pt none white</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.title__content">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <!-- Scriptorium: level 1 topic -->
    <!-- Turned off common border bottom. -->
    <xsl:attribute-set name="topic.topic.title" use-attribute-sets="common.title common.noborder">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$level-1-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$level-1-size"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$level-1-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$level-1-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$level-1-style"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$level-1-color"/>
        </xsl:attribute>
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$level-1-indent"/>
        </xsl:attribute>
        <xsl:attribute name="margin-right">
            <xsl:choose>
                <xsl:when test="$level-1-head-style = 'run-in'">
                    <xsl:value-of select="$head-right-margin"/>                    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'0px'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        
        <!-- Override padding from commons-attr.xsl. -->
        <xsl:attribute name="padding-top">0pt</xsl:attribute>

        <!-- Scriptorium stubbed out margin-top and added the space to space-before 
            because margin-top does not allow for conditional exclusion at the tops of pages. -->
        <!--        <xsl:attribute name="margin-top"></xsl:attribute>
        <xsl:attribute name="margin-bottom"></xsl:attribute>-->
        <xsl:attribute name="space-before">
            <xsl:value-of select="$level-1-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$level-1-space-after"/>
        </xsl:attribute>
        <!-- space-after is stronger than space-before on a paragraph. -->
        <xsl:attribute name="space-after.precedence">10</xsl:attribute>
        <!-- Scriptorium removed the padding because the rules are not longer present.
            <xsl:attribute name="padding-top">1pc</xsl:attribute> -->
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <!-- Scriptorium: level 1 section (a rarity). -->
    <xsl:attribute-set name="topic.section.title">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$level-1-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$level-1-size"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$level-1-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$level-1-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$level-1-style"/>
        </xsl:attribute>
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$level-1-indent"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$level-1-color"/>
        </xsl:attribute>
        <xsl:attribute name="margin-right">
            <!--            <xsl:value-of select="$head-right-margin"/>-->
        </xsl:attribute>
        <!-- Scriptorium removed border. Also reduced space-before from 27pt. -->
        <!--<xsl:attribute name="border-bottom">1pt solid black</xsl:attribute>-->
        <xsl:attribute name="space-before">
            <xsl:value-of select="$level-1-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$level-1-space-after"/>
        </xsl:attribute>
        <!-- space-after is stronger than space-before on a paragraph. -->
        <xsl:attribute name="space-after.precedence">10</xsl:attribute>

        <!-- Scriptorium removed the padding because the rules are not longer present.
            <xsl:attribute name="padding-top">1pc</xsl:attribute> -->
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <!-- Level-1 content. -->
    <xsl:attribute-set name="topic.topic.title__content">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
    </xsl:attribute-set>

    <!-- Scriptorium: level 2 topic -->
    <xsl:attribute-set name="topic.topic.topic.title" use-attribute-sets="common.title">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$level-2-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$level-2-size"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$level-2-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$level-2-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$level-2-style"/>
        </xsl:attribute>
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$level-2-indent"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$level-2-color"/>
        </xsl:attribute>
        <xsl:attribute name="space-before">
            <xsl:value-of select="$level-2-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$level-2-space-after"/>
        </xsl:attribute>
        <!-- space-after is stronger than space-before on a paragraph. -->
        <xsl:attribute name="space-after.precedence">10</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <!-- Scriptorium: level 2 section -->
    <xsl:attribute-set name="topic.topic.section.title" use-attribute-sets="base-font common.title">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$level-2-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$level-2-size"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$level-2-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$level-2-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$level-2-style"/>
        </xsl:attribute>
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$level-2-indent"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$level-2-color"/>
        </xsl:attribute>
        <xsl:attribute name="space-before">
            <xsl:value-of select="$level-2-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$level-2-space-after"/>
        </xsl:attribute>
        <!-- space-after is stronger than space-before on a paragraph. -->
        <xsl:attribute name="space-after.precedence">10</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <!-- Level-2 content. -->
    <xsl:attribute-set name="topic.topic.topic.title__content"> </xsl:attribute-set>

    <!-- Scriptorium: level-3 topic -->
    <xsl:attribute-set name="topic.topic.topic.topic.title"
        use-attribute-sets="base-font common.title">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$level-3-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$level-3-size"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$level-3-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$level-3-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$level-3-style"/>
        </xsl:attribute>
        <xsl:attribute name="space-before">
            <xsl:value-of select="$level-3-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$level-3-space-after"/>
        </xsl:attribute>
        <!-- space-after is stronger than space-before on a paragraph. -->
        <xsl:attribute name="space-after.precedence">10</xsl:attribute>
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$level-3-indent"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$level-3-color"/>
        </xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <!-- Scriptorium: level-3 section -->
    <xsl:attribute-set name="topic.topic.topic.section.title">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$level-3-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$level-3-size"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$level-3-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$level-3-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$level-3-style"/>
        </xsl:attribute>
        <xsl:attribute name="space-before">
            <xsl:value-of select="$level-3-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$level-3-space-after"/>
        </xsl:attribute>
        <!-- space-after is stronger than space-before on a paragraph. -->
        <xsl:attribute name="space-after.precedence">10</xsl:attribute>
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$level-3-indent"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$level-3-color"/>
        </xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <!-- Level-3 content. -->
    <xsl:attribute-set name="topic.topic.topic.topic.title__content"> </xsl:attribute-set>

    <!-- Scriptorium: level-4 topic -->
    <xsl:attribute-set name="topic.topic.topic.topic.topic.title">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$level-4-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$level-4-size"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$level-4-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$level-4-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$level-4-style"/>
        </xsl:attribute>
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$level-4-indent"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$level-4-color"/>
        </xsl:attribute>

        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <!-- Scriptorium: level-4 section -->
    <xsl:attribute-set name="topic.topic.topic.topic.section.title">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$level-4-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$level-4-size"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$level-4-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$level-4-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$level-4-style"/>
        </xsl:attribute>
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$level-4-indent"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$level-4-color"/>
        </xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <!-- Level-4 content. -->
    <xsl:attribute-set name="topic.topic.topic.topic.topic.title__content"> </xsl:attribute-set>

    <!-- Scriptorium: level-5 topic -->
    <xsl:attribute-set name="topic.topic.topic.topic.topic.title"
        use-attribute-sets="base-font common.title">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$level-5-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$level-5-size"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$level-5-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$level-5-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$level-5-style"/>
        </xsl:attribute>
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$level-5-indent"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$level-5-color"/>
        </xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>
    <!-- Scriptorium: level-5 topic -->
    <xsl:attribute-set name="topic.topic.topic.topic.section.title"
        use-attribute-sets="base-font common.title">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$level-5-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$level-5-size"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$level-5-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$level-5-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$level-5-style"/>
        </xsl:attribute>
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$level-5-indent"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$level-5-color"/>
        </xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.topic.topic.topic.topic.title__content"> </xsl:attribute-set>

    <xsl:attribute-set name="topic.topic.topic.topic.topic.topic.title"
        use-attribute-sets="base-font common.title">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$level-6-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$level-6-size"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$level-6-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$level-6-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$level-6-style"/>
        </xsl:attribute>
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$level-6-indent"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$level-6-color"/>
        </xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="topic.topic.topic.topic.topic.section.title"
        use-attribute-sets="base-font common.title">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$level-6-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$level-6-size"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$level-6-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$level-6-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$level-6-style"/>
        </xsl:attribute>
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$level-6-indent"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$level-6-color"/>
        </xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.topic.topic.topic.topic.topic.title__content"> </xsl:attribute-set>

    <xsl:attribute-set name="section.title" use-attribute-sets="common.title">
        <xsl:attribute name="font-family">Sans</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="space-before">10pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="example.title" use-attribute-sets="common.title">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$example-title-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="space-after">5pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="fig">
        <xsl:attribute name="space-before.optimum">
            <xsl:value-of select="$figure-space-before"/>
        </xsl:attribute>
        <!-- Turned off, because we've moved title before the figure. -->
        <xsl:attribute name="keep-with-next.within-page">auto</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="fig.title" use-attribute-sets="base-font common.title">
        <!-- Scriptorium modified title format: removed ".optimum" from space-before and space-after 
        and changed keep-with-previous to keep-with-next. -->
        <xsl:attribute name="font-family">
            <xsl:value-of select="$figure-title-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$figure-title-size"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$figure-title-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$figure-title-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$figure-title-style"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$figure-title-color"/>
        </xsl:attribute>
        <xsl:attribute name="space-before">
            <xsl:value-of select="$figure-title-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$figure-title-space-after"/>
        </xsl:attribute>
        <!-- Turn ON keep with next. -->
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
        <xsl:attribute name="keep-with-previous.within-page">auto</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="topic" use-attribute-sets="base-font">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$default-font-size"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="titlealts" use-attribute-sets="common.border">
        <xsl:attribute name="background-color">#f0f0d0</xsl:attribute>
        <xsl:attribute name="border-style">solid</xsl:attribute>
        <xsl:attribute name="border-color">black</xsl:attribute>
        <xsl:attribute name="border-width">thin</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="navtitle" use-attribute-sets="common.title">
        <xsl:attribute name="font-family">Sans</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="navtitle__label">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="searchtitle"> </xsl:attribute-set>

    <xsl:attribute-set name="searchtitle__label">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="body__toplevel" use-attribute-sets="base-font">
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$side-col-width"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$default-font-size"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="body__secondLevel" use-attribute-sets="base-font">
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$side-col-width"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$default-font-size"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="body" use-attribute-sets="base-font">
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$side-col-width"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$default-font-size"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="abstract" use-attribute-sets="body"> </xsl:attribute-set>

    <!-- Inline shortdesc. -->
    <xsl:attribute-set name="shortdesc"> 
<!--        <xsl:attribute-set name="shortdesc" use-attribute-sets="body"> -->
            <xsl:attribute name="visibility">visible</xsl:attribute>
<!--           <xsl:choose>
               <xsl:when test="$show-shortdesc = 'yes'">visible</xsl:when>
               <xsl:otherwise>collapse</xsl:otherwise>
           </xsl:choose>
       </xsl:attribute>        -->
    </xsl:attribute-set>

    <xsl:attribute-set name="topic__shortdesc" use-attribute-sets="body">
        <!-- Scriptorium modified shortdesc format to set it off. -->
        <xsl:attribute name="margin-left" select="$side-col-width"/>
        <xsl:attribute name="margin-bottom">6pt</xsl:attribute>
        <xsl:attribute name="visibility">visible</xsl:attribute>
<!--            <xsl:choose>
                <xsl:when test="$show-shortdesc = 'yes'">visible</xsl:when>
                <xsl:otherwise>collapse</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>        -->
    </xsl:attribute-set>

    <xsl:attribute-set name="section" use-attribute-sets="base-font">
        <xsl:attribute name="line-height">
            <xsl:value-of select="$default-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="space-before">0.6em</xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$default-font-size"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="section__content"> </xsl:attribute-set>

    <xsl:attribute-set name="example" use-attribute-sets="base-font common.border">
        <xsl:attribute name="line-height">
            <xsl:value-of select="$default-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="space-before">0.6em</xsl:attribute>
        <xsl:attribute name="margin-left">0.5in</xsl:attribute>
        <xsl:attribute name="margin-right">0.5in</xsl:attribute>
        <xsl:attribute name="padding">5pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="example__content"> </xsl:attribute-set>

    <xsl:attribute-set name="desc">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="prolog" use-attribute-sets="base-font">
        <xsl:attribute name="start-indent">72pt</xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$default-font-size"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="p" use-attribute-sets="common.block">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$default-font-size"/>
        </xsl:attribute>
        <xsl:attribute name="text-indent">0em</xsl:attribute>
        <xsl:attribute name="space-before">
            <xsl:value-of select="$body-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="space-before.precedence">0</xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$body-space-after"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <!-- [SP] formatting of referenced object filename. -->
    
    <xsl:attribute-set name="p.object" use-attribute-sets="common.block">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$default-font-size"/>
        </xsl:attribute>
        <xsl:attribute name="color">red</xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="text-indent">0em</xsl:attribute>
        <xsl:attribute name="space-before">
            <xsl:value-of select="$body-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="space-before.precedence">0</xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$body-space-after"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <!--GK_100213 Special for question numbering-->
    <xsl:attribute-set name="lcQuestion2" use-attribute-sets="common.block">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$default-font-size"/>
        </xsl:attribute>
        <xsl:attribute name="text-indent">0em</xsl:attribute>
        <xsl:attribute name="space-before">
            <xsl:value-of select="$body-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="space-before.precedence">0</xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$body-space-after"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <!--GK_100213 Special for answer choice lettering-->
    <xsl:attribute-set name="lcAnswerContent2" use-attribute-sets="common.block">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$default-font-size"/>
        </xsl:attribute>
        <xsl:attribute name="text-indent">0em</xsl:attribute>
        <xsl:attribute name="space-before">
            <xsl:value-of select="$body-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="space-before.precedence">0</xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$body-space-after"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
   
    <!-- Special for "What people are saying" page. -->
    <xsl:attribute-set name="p.source" use-attribute-sets="common.block">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$default-font-size"/> * 0.8</xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$secondary-line-height"/>
        </xsl:attribute>
        
        <!-- Tighten up with preceding para. -->
        <xsl:attribute name="space-before">
            <xsl:value-of select="$body-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="space-before.precedence">10</xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$body-space-after"/>
        </xsl:attribute>
        <xsl:attribute name="margin-left">100pt</xsl:attribute>
        <xsl:attribute name="start-indent">5pt</xsl:attribute>
        <xsl:attribute name="text-indent">-5pt</xsl:attribute>
        <xsl:attribute name="keep-with-previous">always</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="table-p">
        <xsl:attribute name="text-indent">0em</xsl:attribute>
        <xsl:attribute name="space-before">0em</xsl:attribute>
        <xsl:attribute name="space-after">0em</xsl:attribute>
        <xsl:attribute name="margin">0pt</xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$table-body-line-height"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note-p">
        <xsl:attribute name="text-indent">0em</xsl:attribute>
        <xsl:attribute name="space-before">2pt</xsl:attribute>
        <xsl:attribute name="space-after">2pt</xsl:attribute>
        <xsl:attribute name="margin">0pt</xsl:attribute>
    </xsl:attribute-set>

    <!-- Removed border and made indents much smaller (18pt). -->
    <xsl:attribute-set name="lq" use-attribute-sets="base-font common.border">
        <!-- 80% of default -->
        <xsl:attribute name="font-family">
            <xsl:value-of select="$quote-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$quote-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$quote-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$quote-style"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$quote-color"/>
        </xsl:attribute>
        
        <xsl:attribute name="text-align">
            <xsl:value-of select="$quote-text-align"/>
        </xsl:attribute>
        <xsl:attribute name="space-before">
            <xsl:value-of select="$quote-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="start-indent">
            <xsl:value-of select="$quote-start-indent"/>
        </xsl:attribute>
        <!-- Can't use end-indent, because it affects the paragraph, not the bordered block. -->
<!--        <xsl:attribute name="end-indent">
            <xsl:value-of select="$quote-end-indent"/>
        </xsl:attribute>-->
        <xsl:attribute name="margin-right">
            <xsl:value-of select="$quote-end-indent"/>
        </xsl:attribute>
        <xsl:attribute name="keep-together.within-page">always</xsl:attribute>
        <xsl:attribute name="keep-with-previous.within-page">auto</xsl:attribute>

        <xsl:attribute name="border-top-style">
            <xsl:value-of select="$quote-border-top-style"/>
        </xsl:attribute>
        <xsl:attribute name="border-top-width">
            <xsl:value-of select="$quote-border-top-width"/>
        </xsl:attribute>
        <xsl:attribute name="border-top-color">
            <xsl:value-of select="$quote-border-top-color"/>
        </xsl:attribute>
        <xsl:attribute name="padding-top">
            <xsl:value-of select="$quote-border-top-padding"/>
        </xsl:attribute>
        
        <xsl:attribute name="border-bottom-style">
            <xsl:value-of select="$quote-border-bottom-style"/>
        </xsl:attribute>
        <xsl:attribute name="border-bottom-width">
            <xsl:value-of select="$quote-border-bottom-width"/>
        </xsl:attribute>
        <xsl:attribute name="border-bottom-color">
            <xsl:value-of select="$quote-border-bottom-color"/>
        </xsl:attribute>
<!--        <xsl:attribute name="padding-bottom">
            <xsl:value-of select="$quote-border-bottom-padding"/>
        </xsl:attribute>-->
        
        <xsl:attribute name="border-left-style">
            <xsl:value-of select="$quote-border-left-style"/>
        </xsl:attribute>
        <xsl:attribute name="border-left-width">
            <xsl:value-of select="$quote-border-left-width"/>
        </xsl:attribute>
        <xsl:attribute name="border-left-color">
            <xsl:value-of select="$quote-border-left-color"/>
        </xsl:attribute>
<!--        <xsl:attribute name="padding-left">
            <xsl:value-of select="$quote-border-left-padding"/>
        </xsl:attribute>-->
        
        <xsl:attribute name="border-right-style">
            <xsl:value-of select="$quote-border-right-style"/>
        </xsl:attribute>
        <xsl:attribute name="border-right-width">
            <xsl:value-of select="$quote-border-right-width"/>
        </xsl:attribute>
        <xsl:attribute name="border-right-color">
            <xsl:value-of select="$quote-border-right-color"/>
        </xsl:attribute>
<!--        <xsl:attribute name="padding-right">
            <xsl:value-of select="$quote-border-right-padding"/>
        </xsl:attribute>-->        
    </xsl:attribute-set>

    <xsl:attribute-set name="lq_simple" use-attribute-sets="lq"/>

    <xsl:attribute-set name="lq_link" use-attribute-sets="base-font common.link">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$default-font-size"/>
        </xsl:attribute>
        <xsl:attribute name="space-after">10pt</xsl:attribute>
        <xsl:attribute name="end-indent">
            <xsl:value-of select="$quote-end-indent"/>
        </xsl:attribute>
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="font-weight">regular</xsl:attribute>
        <xsl:attribute name="color">blue</xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="lq_title" use-attribute-sets="base-font">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$default-font-size"/>
        </xsl:attribute>
        <xsl:attribute name="space-after">10pt</xsl:attribute>
        <xsl:attribute name="end-indent">
            <xsl:value-of select="$quote-end-indent"/>
        </xsl:attribute>
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="font-weight">regular</xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="q">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="figgroup">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note" use-attribute-sets="common.block">
        <xsl:attribute name="space-before">0.6em</xsl:attribute>
        <xsl:attribute name="space-after">0.6em</xsl:attribute>
        <xsl:attribute name="margin-left">18pt</xsl:attribute>
        <xsl:attribute name="padding-top">4pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">4pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__table" use-attribute-sets="common.block">
        <xsl:attribute name="space-before">0.6em</xsl:attribute>
        <xsl:attribute name="space-after">0.6em</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__image__column">
        <xsl:attribute name="column-number">1</xsl:attribute>
        <xsl:attribute name="column-width">32pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__text__column">
        <xsl:attribute name="column-number">2</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__image__entry">
        <xsl:attribute name="padding-right">5pt</xsl:attribute>
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__text__entry">
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__label">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__label__note"> </xsl:attribute-set>

    <xsl:attribute-set name="note__label__notice"> </xsl:attribute-set>

    <xsl:attribute-set name="note__label__tip"> </xsl:attribute-set>

    <xsl:attribute-set name="note__label__fastpath"> </xsl:attribute-set>

    <xsl:attribute-set name="note__label__restriction"> </xsl:attribute-set>

    <xsl:attribute-set name="note__label__important"> </xsl:attribute-set>

    <xsl:attribute-set name="note__label__remember"> </xsl:attribute-set>

    <xsl:attribute-set name="note__label__attention"> </xsl:attribute-set>

    <xsl:attribute-set name="note__label__caution"> </xsl:attribute-set>

    <xsl:attribute-set name="note__label__danger"> </xsl:attribute-set>

    <xsl:attribute-set name="note__label__warning"> </xsl:attribute-set>

    <xsl:attribute-set name="note__label__other"> </xsl:attribute-set>

    <xsl:attribute-set name="pre" use-attribute-sets="base-font common.block">
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <!--        <xsl:attribute name="space-before">1.2em</xsl:attribute>
        <xsl:attribute name="space-after">0.8em</xsl:attribute>-->
        <xsl:attribute name="white-space-treatment">preserve</xsl:attribute>
        <xsl:attribute name="white-space-collapse">false</xsl:attribute>
        <xsl:attribute name="linefeed-treatment">preserve</xsl:attribute>
        <xsl:attribute name="wrap-option">wrap</xsl:attribute>
        <xsl:attribute name="background-color">White</xsl:attribute>
        <xsl:attribute name="font-family">Monospaced</xsl:attribute>
        <!-- Scriptorium changed font size to use a separate default value. -->
        <xsl:attribute name="font-size">
            <xsl:value-of select="$monospace-font-size"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$monospace-line-height"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__spectitle">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__border__top">
        <xsl:attribute name="border-top-color">black</xsl:attribute>
        <xsl:attribute name="border-top-width">thin</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__border__bot">
        <xsl:attribute name="border-bottom-color">black</xsl:attribute>
        <xsl:attribute name="border-bottom-width">thin</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__border__sides">
        <xsl:attribute name="border-left-color">black</xsl:attribute>
        <xsl:attribute name="border-left-width">thin</xsl:attribute>
        <xsl:attribute name="border-right-color">black</xsl:attribute>
        <xsl:attribute name="border-right-width">thin</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__border__all" use-attribute-sets="common.border">
        <xsl:attribute name="border-style">solid</xsl:attribute>
        <xsl:attribute name="border-color">black</xsl:attribute>
        <xsl:attribute name="border-width">thin</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="lines" use-attribute-sets="base-font">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$default-font-size"/>
        </xsl:attribute>
        <xsl:attribute name="space-before">0.8em</xsl:attribute>
        <xsl:attribute name="space-after">0.8em</xsl:attribute>
        <!--        <xsl:attribute name="white-space-treatment">ignore-if-after-linefeed</xsl:attribute>-->
        <xsl:attribute name="white-space-collapse">true</xsl:attribute>
        <xsl:attribute name="linefeed-treatment">preserve</xsl:attribute>
        <xsl:attribute name="wrap-option">wrap</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="keyword">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
    </xsl:attribute-set>

   
    <xsl:attribute-set name="term">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <!-- [SP] handling in-line italic and bold formatting. -->
    <xsl:attribute-set name="emphasisItalics">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="emphasisBold">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    
<!-- 07/24/2015 PSB: Added commandWord processing    -->
    <xsl:attribute-set name="commandWord">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="qualifier">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="ph">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="boolean">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
        <xsl:attribute name="color">green</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="state">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
        <xsl:attribute name="color">red</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="alt"> </xsl:attribute-set>

    <xsl:attribute-set name="object"> </xsl:attribute-set>

    <xsl:attribute-set name="param"> </xsl:attribute-set>

    <xsl:attribute-set name="draft-comment" use-attribute-sets="common.border">
        <xsl:attribute name="background-color">#FF99FF</xsl:attribute>
        <xsl:attribute name="color">#CC3333</xsl:attribute>
        <xsl:attribute name="border-style">solid</xsl:attribute>
        <xsl:attribute name="border-color">black</xsl:attribute>
        <xsl:attribute name="border-width">thin</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="draft-comment__label">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="required-cleanup">
        <xsl:attribute name="background">yellow</xsl:attribute>
        <xsl:attribute name="color">#CC3333</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="required-cleanup__label">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="fn">
        <xsl:attribute name="font-size">8pt</xsl:attribute>
        <xsl:attribute name="color">purple</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="fn__id">
        <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="fn__callout">
        <!-- Add a bit more space between text and callout. -->
        <xsl:attribute name="margin-left">1pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="fn__body" use-attribute-sets="base-font">
        <xsl:attribute name="provisional-distance-between-starts">8mm</xsl:attribute>
        <xsl:attribute name="provisional-label-separation">2mm</xsl:attribute>
        <xsl:attribute name="line-height">1.2</xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$secondary-font-size"/>
        </xsl:attribute>
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__align__left">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="display-align">before</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__align__right">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="display-align">before</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__align__center">
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="display-align">before</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__align__justify">
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="display-align">before</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="indextermref">
        <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="cite">
        <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="concept"> </xsl:attribute-set>

    <xsl:attribute-set name="conbody" use-attribute-sets="body"> </xsl:attribute-set>

    <xsl:attribute-set name="topichead"> </xsl:attribute-set>

    <xsl:attribute-set name="topicgroup"> </xsl:attribute-set>

    <xsl:attribute-set name="topicmeta"> </xsl:attribute-set>

    <xsl:attribute-set name="searchtitle"> </xsl:attribute-set>

    <xsl:attribute-set name="searchtitle__label">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="publisher"> </xsl:attribute-set>

    <xsl:attribute-set name="copyright"> </xsl:attribute-set>

    <xsl:attribute-set name="copyryear"> </xsl:attribute-set>

    <xsl:attribute-set name="copyrholder"> </xsl:attribute-set>

    <xsl:attribute-set name="critdates"> </xsl:attribute-set>

    <xsl:attribute-set name="created"> </xsl:attribute-set>

    <xsl:attribute-set name="revised"> </xsl:attribute-set>

    <xsl:attribute-set name="permissions"> </xsl:attribute-set>

    <xsl:attribute-set name="category"> </xsl:attribute-set>

    <xsl:attribute-set name="audience"> </xsl:attribute-set>

    <xsl:attribute-set name="keywords"> </xsl:attribute-set>

    <xsl:attribute-set name="prodinfo"> </xsl:attribute-set>

    <xsl:attribute-set name="prodname"> </xsl:attribute-set>

    <xsl:attribute-set name="vrmlist"> </xsl:attribute-set>

    <xsl:attribute-set name="vrm"> </xsl:attribute-set>

    <xsl:attribute-set name="brand"> </xsl:attribute-set>

    <xsl:attribute-set name="series"> </xsl:attribute-set>

    <xsl:attribute-set name="platform"> </xsl:attribute-set>

    <xsl:attribute-set name="prognum"> </xsl:attribute-set>

    <xsl:attribute-set name="featnum"> </xsl:attribute-set>

    <xsl:attribute-set name="component"> </xsl:attribute-set>

    <xsl:attribute-set name="othermeta"> </xsl:attribute-set>

    <xsl:attribute-set name="resourceid"> </xsl:attribute-set>

    <xsl:attribute-set name="reference"> </xsl:attribute-set>

    <xsl:attribute-set name="refbody" use-attribute-sets="body"> </xsl:attribute-set>

    <xsl:attribute-set name="refsyn"> </xsl:attribute-set>

    <xsl:attribute-set name="metadata"> </xsl:attribute-set>

    <xsl:attribute-set name="image__float"> </xsl:attribute-set>

    <xsl:attribute-set name="image__block"> </xsl:attribute-set>

    <xsl:attribute-set name="image__inline"> </xsl:attribute-set>

    <xsl:attribute-set name="image"> </xsl:attribute-set>

    <xsl:attribute-set name="__unresolved__conref">
        <xsl:attribute name="color">#CC3333</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__fo__root" use-attribute-sets="base-font">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$body-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$body-size"/>
        </xsl:attribute>
        <xsl:attribute name="xml:lang" select="translate($locale, '_', '-')"/>
        <xsl:attribute name="writing-mode" select="$writing-mode"/>
    </xsl:attribute-set>

    <xsl:attribute-set name="__force__page__count">
        <xsl:attribute name="force-page-count">
            
            <xsl:value-of select="'auto'"/>
            
        <!-- [SP] Page count is currently set to 'auto' (delete empty pages) for the entire publishing run.
              To make the page count 'even', comment out <xsl:value-of select="'auto'"/> above and uncomment the entire xsl:choose block below. -->    
            
         <!--
             <xsl:choose>
                <xsl:when test="name(/*) = 'bookmap'">
                    <xsl:value-of select="'even'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'auto'"/>
                </xsl:otherwise>
             </xsl:choose>
          -->
            
        </xsl:attribute>
    </xsl:attribute-set>
 
    <!-- [SP] Added attribute sets for notes. -->
    <!-- Describe the label for notes, which comes before the body rule.  -->
    <xsl:attribute-set name="__note__label">
        <xsl:attribute name="margin-bottom">2pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__note__label__base">
        <xsl:attribute name="margin-right">1em</xsl:attribute>
    </xsl:attribute-set>


    <xsl:attribute-set name="note__label__warning" use-attribute-sets="__note__label__base"> </xsl:attribute-set>

    <!-- Describe the basic border and padding layout for notes. -->
    <xsl:attribute-set name="__note__base">
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-width">0.5pt</xsl:attribute>
        <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
        <xsl:attribute name="border-bottom-width">0.5pt</xsl:attribute>
        <xsl:attribute name="padding-top">6pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">4pt</xsl:attribute>
        <!-- colors should be overridden by specific styles. -->
        <xsl:attribute name="border-top-color">#0C1E63</xsl:attribute>
        <xsl:attribute name="border-bottom-color">#0C1E63</xsl:attribute>
        <xsl:attribute name="color">#0C1E63</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__note" use-attribute-sets="__note__base">
        <xsl:attribute name="border-top-color">#0C1E63</xsl:attribute>
        <xsl:attribute name="border-bottom-color">#0C1E63</xsl:attribute>
        <xsl:attribute name="color">#0C1E63</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__color__note" use-attribute-sets="__note__label">
        <xsl:attribute name="color">#0C1E63</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__caution" use-attribute-sets="__note__base">
        <xsl:attribute name="border-top-color">#C70C47</xsl:attribute>
        <xsl:attribute name="border-bottom-color">#C70C47</xsl:attribute>
        <xsl:attribute name="color">#C70C47</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="note__color__caution" use-attribute-sets="__note__label">
        <xsl:attribute name="color">#C70C47</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__warning" use-attribute-sets="__note__base">
        <xsl:attribute name="border-top-color">#C70C47</xsl:attribute>
        <xsl:attribute name="border-bottom-color">#C70C47</xsl:attribute>
        <xsl:attribute name="color">#C70C47</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__color__warning" use-attribute-sets="__note__label">
        <xsl:attribute name="color">#C70C47</xsl:attribute>
    </xsl:attribute-set>

</xsl:stylesheet>
