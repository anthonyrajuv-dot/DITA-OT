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
    version="1.0">

    <xsl:attribute-set name="__frontmatter">
        <xsl:attribute name="text-align">center</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__frontmatter__title">
        <!-- [SP] Made some adjustments in position and size. -->
        <xsl:attribute name="margin-top">2.5in</xsl:attribute>
        <xsl:attribute name="font-family">
            <xsl:value-of select="$cover-level-1-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$cover-level-1-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$cover-level-1-weight"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$cover-level-1-color"/>
        </xsl:attribute>
        <xsl:attribute name="letter-spacing">0.5pt</xsl:attribute>
        <xsl:attribute name="line-height">140%</xsl:attribute>
    </xsl:attribute-set>

    <!-- [SP] Derived from __frontmatter__title -->
    <xsl:attribute-set name="__frontmatter__doctype">
        <xsl:attribute name="margin-top">40pt</xsl:attribute>
        <xsl:attribute name="font-family">
            <xsl:value-of select="$cover-level-2-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$cover-level-2-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$cover-level-2-weight"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$cover-level-2-color"/>
        </xsl:attribute>
        <xsl:attribute name="letter-spacing">0.5pt</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__frontmatter__subtitle">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$cover-level-2-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$cover-level-2-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$cover-level-2-weight"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$cover-level-2-color"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">140%</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__frontmatter__owner">
        <xsl:attribute name="margin-top">3pc</xsl:attribute>
       <xsl:attribute name="font-family">Sans</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="line-height">normal</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__frontmatter__owner__container">
        <xsl:attribute name="position">absolute</xsl:attribute>
        <!--<xsl:attribute name="top">210mm</xsl:attribute>-->
        <!--<xsl:attribute name="bottom">20mm</xsl:attribute>-->
        <xsl:attribute name="right">20mm</xsl:attribute>
        <xsl:attribute name="left">20mm</xsl:attribute>
        <xsl:attribute name="display-align">after</xsl:attribute>
        
    </xsl:attribute-set>

    <xsl:attribute-set name="__frontmatter__owner__container_content">
        <xsl:attribute name="text-align">center</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__frontmatter__mainbooktitle">
        <!--<xsl:attribute name=""></xsl:attribute>-->
    </xsl:attribute-set>

    <xsl:attribute-set name="__frontmatter__booklibrary">
        <!--<xsl:attribute name=""></xsl:attribute>-->
    </xsl:attribute-set>
    
    <xsl:attribute-set name="cover_image">
<!--        <xsl:attribute name="left">-120pt</xsl:attribute>-->
        <xsl:attribute name="margin-left">0pt</xsl:attribute>
        <xsl:attribute name="margin-top">120pt</xsl:attribute>
    </xsl:attribute-set>
    

	<xsl:attribute-set name="bookmap.summary">
		<xsl:attribute name="font-size">9pt</xsl:attribute>
	</xsl:attribute-set>

<!-- Scriptorium additions for p.ii -->
    <xsl:attribute-set name="pii_block">
        <xsl:attribute name="space-before">14pt</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="pii_para">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$copyright-family"/>
        </xsl:attribute>        
        <xsl:attribute name="font-size">
            <xsl:value-of select="$copyright-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$copyright-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$copyright-style"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$copyright-color"/>
        </xsl:attribute>
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$side-col-width"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$copyright-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after">2pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="trademark_block">
        <xsl:attribute name="space-before">14pt</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="trademark_para">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$trademark-family"/>
        </xsl:attribute>        
        <xsl:attribute name="font-size">
            <xsl:value-of select="$trademark-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$trademark-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$trademark-style"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$trademark-color"/>
        </xsl:attribute>
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$side-col-width"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$trademark-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after">2pt</xsl:attribute>
    </xsl:attribute-set>
    

</xsl:stylesheet>