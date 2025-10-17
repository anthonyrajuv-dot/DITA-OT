<?xml version="1.0"?>

<!-- 
Copyright © 2004-2006 by Idiom Technologies, Inc. All rights reserved. 
IDIOM is a registered trademark of Idiom Technologies, Inc. and WORLDSERVER
and WORLDSTART are trademarks of Idiom Technologies, Inc. All other 
trademarks are the property of their respective owners. 

IDIOM TECHNOLOGIES, INC. IS DELIVERING THE SOFTWARE &quot;AS IS,&quot; WITH 
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
Software or its derivatives. In no event shall Idiom Technologies, Inc.&apos;s
liability for any damages hereunder exceed the amounts received by Idiom
Technologies, Inc. as a result of this transaction.

These terms and conditions supersede the terms and conditions in any
licensing agreement to the extent that such terms and conditions conflict
with those set forth herein.

This file is part of the DITA Open Toolkit project hosted on Sourceforge.net. 
See the accompanying license.txt file for applicable licenses.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">
    
    <!-- Override OT with externalized attribute values. -->
    <xsl:attribute-set name="__index__label">
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
    
    <xsl:attribute-set name="__index__letter-group">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$index-letter-group-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$index-letter-group-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$index-letter-group-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$index-letter-group-style"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$index-letter-group-color"/>
        </xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$index-letter-group-space-after"/>
        </xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:variable name="index-letter-group-font-size">16</xsl:variable>
    <xsl:variable name="index-letter-group-font-family">Sans</xsl:variable>
    <xsl:variable name="index-letter-group-font-color" select="$purple"/>
    
    
    <xsl:attribute-set name="index.link">
        <xsl:attribute name="font-family">
            <xsl:value-of select="$index-link-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$index-link-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$index-link-weight"/>
        </xsl:attribute>        
        <xsl:attribute name="font-style">
            <xsl:value-of select="$index-link-style"/>
        </xsl:attribute>        
        <xsl:attribute name="color">
            <xsl:value-of select="$index-link-color"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__index__page__link" use-attribute-sets="index.link">
        <xsl:attribute name="page-number-treatment">link</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="index.entry">
        <xsl:attribute name="space-after">14pt</xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$index-entry-size"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$index-entry-line-height"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    
    <xsl:attribute-set name="index-indents">
        <xsl:attribute name="end-indent">5pt</xsl:attribute>
        <xsl:attribute name="last-line-end-indent">0pt</xsl:attribute>
        <xsl:attribute name="start-indent">
<!--            <xsl:value-of select="'4em'"/>-->
            <xsl:value-of select="$index-indent"/>
        </xsl:attribute>
        <xsl:attribute name="text-indent">
<!--            <xsl:value-of select="'-4em'"/>-->
            <xsl:value-of select="concat('-',$index-indent)"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$index-entry-size"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="index.entry__content">
        <xsl:attribute name="start-indent">
            <xsl:value-of select="$index-left-margin"/>
        </xsl:attribute>
    </xsl:attribute-set>


</xsl:stylesheet>