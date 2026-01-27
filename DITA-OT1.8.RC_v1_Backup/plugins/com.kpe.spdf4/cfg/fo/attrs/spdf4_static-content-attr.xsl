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
    version="2.0">
  <!-- [SP] Override the general attribute sets with values from spdf4_basic-settings.xsl. -->

  <xsl:attribute-set name="odd__header">
      <xsl:attribute name="margin-right">
          <xsl:value-of select="$page-margin-outside"/>
      </xsl:attribute>
      <xsl:attribute name="margin-left">
          <xsl:value-of select="$page-margin-inside"/>
      </xsl:attribute>
      <xsl:attribute name="margin-top">
          <xsl:value-of select="$header-margin-top"/>
      </xsl:attribute>
      <xsl:attribute name="margin-bottom">
          <xsl:value-of select="$header-rule-to-body"/>
      </xsl:attribute>
      <xsl:attribute name="font-weight">
          <xsl:value-of select="$header-font-weight"/>
      </xsl:attribute>
      <xsl:attribute name="font-style">
          <xsl:value-of select="$header-font-style"/>
      </xsl:attribute>
      <xsl:attribute name="font-family">
          <xsl:value-of select="$header-font-family"/>
      </xsl:attribute>
      <xsl:attribute name="font-size">
          <xsl:value-of select="$header-font-size"/>
      </xsl:attribute>
      <!-- Don't get confused, this is the bottom of the header, not top of the body. -->
      <xsl:attribute name="border-bottom-width">
          <xsl:value-of select="$header-rule-thickness"/>
      </xsl:attribute>
      <xsl:attribute name="border-bottom-color">
          <xsl:value-of select="$header-rule-color"/>
      </xsl:attribute>
      <xsl:attribute name="border-bottom-style">
          <xsl:value-of select="$header-rule-style"/>
      </xsl:attribute>
      <xsl:attribute name="padding-bottom">
          <xsl:value-of select="$header-text-to-rule"/>
      </xsl:attribute>
      <xsl:attribute name="text-align">right</xsl:attribute>
      <xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="even__header">
      <xsl:attribute name="text-align">left</xsl:attribute>
      <xsl:attribute name="margin-right">
          <xsl:value-of select="$page-margin-inside"/>
      </xsl:attribute>
      <xsl:attribute name="margin-left">
          <xsl:value-of select="$page-margin-outside"/>
      </xsl:attribute>
      <xsl:attribute name="margin-top">
          <xsl:value-of select="$header-margin-top"/>
      </xsl:attribute>
      <xsl:attribute name="margin-bottom">
          <xsl:value-of select="$header-rule-to-body"/>
      </xsl:attribute>
      <xsl:attribute name="font-weight">
          <xsl:value-of select="$header-font-weight"/>
      </xsl:attribute>
      <xsl:attribute name="font-style">
          <xsl:value-of select="$header-font-style"/>
      </xsl:attribute>
      <xsl:attribute name="font-family">
          <xsl:value-of select="$header-font-family"/>
      </xsl:attribute>
      <xsl:attribute name="font-size">
          <xsl:value-of select="$header-font-size"/>
      </xsl:attribute>
      <!-- Don't get confused, this is the bottom of the header, not top of the body. -->
      <xsl:attribute name="border-bottom-width">
          <xsl:value-of select="$header-rule-thickness"/>
      </xsl:attribute>
      <xsl:attribute name="border-bottom-color">
          <xsl:value-of select="$header-rule-color"/>
      </xsl:attribute>
      <xsl:attribute name="border-bottom-style">
          <xsl:value-of select="$header-rule-style"/>
      </xsl:attribute>
      <xsl:attribute name="padding-bottom">
          <xsl:value-of select="$header-text-to-rule"/>
      </xsl:attribute>
      <xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="odd__footer">
    <!-- [SP] Note, this was right in the old spdf. -->  
    <xsl:attribute name="text-align">end</xsl:attribute>
      <xsl:attribute name="margin-right">
          <xsl:value-of select="$page-margin-outside"/>
      </xsl:attribute>
      <xsl:attribute name="margin-left">
          <xsl:value-of select="$page-margin-inside"/>
      </xsl:attribute>
      <xsl:attribute name="margin-top">
          <xsl:value-of select="$footer-body-to-rule"/>
      </xsl:attribute>
      <xsl:attribute name="font-weight">
          <xsl:value-of select="$footer-font-weight"/>
      </xsl:attribute>
      <xsl:attribute name="font-style">
          <xsl:value-of select="$footer-font-style"/>
      </xsl:attribute>
      <xsl:attribute name="font-family">
          <xsl:value-of select="$footer-font-family"/>
      </xsl:attribute>
      <xsl:attribute name="font-size">
          <xsl:value-of select="$footer-font-size"/>
      </xsl:attribute>
      <!-- Don't get confused, this is the top of the footer, not bottom of the body. -->
      <xsl:attribute name="border-top-width">
          <xsl:value-of select="$footer-rule-thickness"/>
      </xsl:attribute>
      <xsl:attribute name="border-top-color">
          <xsl:value-of select="$footer-rule-color"/>
      </xsl:attribute>
      <xsl:attribute name="border-top-style">
          <xsl:value-of select="$footer-rule-style"/>
      </xsl:attribute>
      <xsl:attribute name="padding-top">
          <xsl:value-of select="$footer-rule-to-text"/>
      </xsl:attribute>
      <xsl:attribute name="space-after.conditionality">retain</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="even__footer">
      <xsl:attribute name="text-align">left</xsl:attribute>
      <xsl:attribute name="margin-right">
          <xsl:value-of select="$page-margin-inside"/>
      </xsl:attribute>
      <xsl:attribute name="margin-left">
          <xsl:value-of select="$page-margin-outside"/>
      </xsl:attribute>
      <xsl:attribute name="margin-top">
          <xsl:value-of select="$footer-body-to-rule"/>
      </xsl:attribute>
      <xsl:attribute name="font-weight">
          <xsl:value-of select="$footer-font-weight"/>
      </xsl:attribute>
      <xsl:attribute name="font-style">
          <xsl:value-of select="$footer-font-style"/>
      </xsl:attribute>
      <xsl:attribute name="font-family">
          <xsl:value-of select="$footer-font-family"/>
      </xsl:attribute>
      <xsl:attribute name="font-size">
          <xsl:value-of select="$footer-font-size"/>
      </xsl:attribute>
      <!-- Don't get confused, this is the top of the footer, not bottom of the body. -->
      <xsl:attribute name="border-top-width">
          <xsl:value-of select="$footer-rule-thickness"/>
      </xsl:attribute>
      <xsl:attribute name="border-top-color">
          <xsl:value-of select="$footer-rule-color"/>
      </xsl:attribute>
      <xsl:attribute name="border-top-style">
          <xsl:value-of select="$footer-rule-style"/>
      </xsl:attribute>
      <xsl:attribute name="padding-top">
          <xsl:value-of select="$footer-rule-to-text"/>
      </xsl:attribute>
      <xsl:attribute name="space-after.conditionality">retain</xsl:attribute>
  </xsl:attribute-set>
  
    <!-- Scriptorium added to control header style more tightly. -->
    <!-- (sfb: not sure if these are used anymore.) -->
    <xsl:attribute-set name="header_style">
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$header-font-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$header-font-style"/>
        </xsl:attribute>
        <xsl:attribute name="font-family">
            <xsl:value-of select="$header-font-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$header-font-size"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <!-- Scriptorium added to control footer style more tightly. -->
    <!-- (sfb: not sure if these are used anymore.) -->
    <xsl:attribute-set name="footer_style">
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$footer-font-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$footer-font-style"/>
        </xsl:attribute>
        <xsl:attribute name="font-family">
            <xsl:value-of select="$footer-font-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$footer-font-size"/>
        </xsl:attribute>
    </xsl:attribute-set>
  
  <xsl:attribute-set name="pagenum">
    <xsl:attribute name="font-weight">bold</xsl:attribute>
  </xsl:attribute-set>
    
    <xsl:attribute-set name="__frontmatter__first__footer">
        <!-- [SP] Note, this was right in the old spdf. -->  
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="margin-right">
            <xsl:value-of select="$page-margin-outside"/>
        </xsl:attribute>
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$page-margin-inside"/>
        </xsl:attribute>
        <!-- Don't get confused, this is the top of the footer, not bottom of the body. -->
        <xsl:attribute name="border-top-width">
            <xsl:value-of select="'0pt'"/>
        </xsl:attribute>
        <xsl:attribute name="border-top-color">
            <xsl:value-of select="$footer-rule-color"/>
        </xsl:attribute>
        <xsl:attribute name="border-top-style">
            <xsl:value-of select="'none'"/>
        </xsl:attribute>
        <xsl:attribute name="padding-top">
            <xsl:value-of select="$footer-rule-to-text"/>
        </xsl:attribute>
        <xsl:attribute name="space-after.conditionality">retain</xsl:attribute>
    </xsl:attribute-set>
    
    
    <xsl:attribute-set name="__body__even__header" use-attribute-sets="even__header">
    </xsl:attribute-set>
    

    <xsl:attribute-set name="__body__first__header" use-attribute-sets="odd__header">
    <!-- spdf added these: -->
        <!-- 
        <xsl:attribute name="margin-right">
            <xsl:value-of select="$page-margin-outside"/>
        </xsl:attribute>
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$page-margin-inside"/>
        </xsl:attribute>
        
        -->
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__toc__even__header" use-attribute-sets="even__header">
        <xsl:attribute name="color">black</xsl:attribute>
    </xsl:attribute-set>
    
    
    
    <xsl:attribute-set name="__header__title">
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$header-font-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$header-font-style"/>
        </xsl:attribute>
        <xsl:attribute name="font-family">
            <xsl:value-of select="$header-font-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$header-font-size"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$header-font-color"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="__header__subtitle">
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$header-font-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$header-font-style"/>
        </xsl:attribute>
        <xsl:attribute name="font-family">
            <xsl:value-of select="$header-font-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$header-font-size"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$header-font-color"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__header__current__title">
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$header-font-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$header-font-style"/>
        </xsl:attribute>
        <xsl:attribute name="font-family">
            <xsl:value-of select="$header-font-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$header-font-size"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$header-font-color"/>
        </xsl:attribute>
        
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__chapter__frontmatter__name__container">
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
        <xsl:attribute name="text-align">right</xsl:attribute>
        
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-bottom-style">solid</xsl:attribute> 
        <xsl:attribute name="border-top-width">2pt</xsl:attribute>
        <xsl:attribute name="border-bottom-width">2pt</xsl:attribute>
        <xsl:attribute name="padding-top">10pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">3pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">12pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__chapter__frontmatter__number__container">
        <xsl:attribute name="font-size">
            <xsl:value-of select="$chap-appx-number-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$chap-appx-number-weight"/>
        </xsl:attribute>
    </xsl:attribute-set>

</xsl:stylesheet>