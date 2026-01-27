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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" version="1.0">
    
    <!--    <xsl:variable name="tableAttrs" select="'../../attrs/spdf2_tables-attr.xsl'"/>-->
    
    
    <!-- contents of table entries or similer structures -->
    <!-- Scriptorium parameterized values. -->
    <xsl:attribute-set name="common.table.body.entry">
        
       <!-- <xsl:attribute name="start-indent">
            <xsl:choose>
                <xsl:when test="$pdfFormatter='fop'">
                    <xsl:value-of select="concat('-',$side-bar-width,'pt')"/>
                </xsl:when>
                <xsl:otherwise>0pt</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>

        <!-\- Scriptorium parameterized margin-left to offset the default picked up in FOP. -\->
        <xsl:attribute name="margin-left">
            <xsl:choose>
                <xsl:when test="$pdfFormatter='fop'">
                    <xsl:value-of select="concat('-',($side-bar-width - 3),'pt')"/>
                </xsl:when>
                <xsl:otherwise>3pt</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>-->
        <xsl:attribute name="margin-right">
            <xsl:value-of select="$table-body-lrmargins"/>
        </xsl:attribute>
        <xsl:attribute name="margin-top">
            <xsl:value-of select="$table-body-tbmargins"/>
        </xsl:attribute>
        <xsl:attribute name="margin-bottom">
            <xsl:value-of select="$table-body-tbmargins"/>
        </xsl:attribute>
        <xsl:attribute name="font-family">
            <xsl:value-of select="$table-body-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$table-body-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$table-body-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$table-body-style"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$table-body-color"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$table-body-line-height"/>
        </xsl:attribute>
        <!--<xsl:attribute name="space-before">3pt</xsl:attribute>
        <xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
        <xsl:attribute name="space-after">3pt</xsl:attribute>
        <xsl:attribute name="space-after.conditionality">retain</xsl:attribute>
        <xsl:attribute name="start-indent">3pt</xsl:attribute>
        <xsl:attribute name="end-indent">3pt</xsl:attribute>-->
        
    </xsl:attribute-set>
    
    <xsl:attribute-set name="common.table.head.entry">
        <!-- Scriptorium parameterized margin-left to offset the default picked up in FOP. -->
        <xsl:attribute name="margin-left">
            <xsl:variable name="standard-margin">
                <xsl:value-of select="substring-before($side-col-width,'pt')"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$pdfFormatter='fop'">
                    <xsl:value-of select="concat('-',($standard-margin - 3),'pt')"/>
                </xsl:when>
                <xsl:otherwise>3pt</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="margin-right">
            <xsl:value-of select="$table-head-lrmargins"/>
        </xsl:attribute>
        <xsl:attribute name="margin-top">
            <xsl:value-of select="$table-head-tbmargins"/>
        </xsl:attribute>
        <xsl:attribute name="margin-bottom">
            <xsl:value-of select="$table-head-tbmargins"/>
        </xsl:attribute>
        
        <xsl:attribute name="font-family">
            <xsl:value-of select="$table-head-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$table-head-size"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$table-head-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$table-head-style"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$table-head-color"/>
        </xsl:attribute>

        <xsl:attribute name="line-height">
            <xsl:value-of select="$table-head-line-height"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    
    <xsl:attribute-set name="table.title">
        <xsl:attribute name="space-before">
            <xsl:value-of select="$table-title-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="font-family">
            <xsl:value-of select="$table-title-family"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:value-of select="$table-title-size"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$table-title-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:value-of select="$table-title-weight"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">
            <xsl:value-of select="$table-title-style"/>
        </xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$table-title-color"/>
        </xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$table-title-space-after"/>
        </xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <!-- must shift 3pts left, because it's now within a table head. -->
        <xsl:attribute name="margin-left">-3pt</xsl:attribute>
        <xsl:attribute name="margin-bottom">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__tableframe__none"/>

    <xsl:attribute-set name="__tableframe__top" use-attribute-sets="common.border__top">
        <!-- Scriptorium added conditional "retain" for border to preserve border at page breaks -->
        <xsl:attribute name="border-before-width.conditionality">retain</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__tableframe__bottom" use-attribute-sets="common.border__bottom">
        <!-- Scriptorium added conditional "retain" for border to preserve border at page breaks -->
        <xsl:attribute name="border-before-width.conditionality">retain</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="thead__tableframe__bottom" use-attribute-sets="common.head__bottom">
        <!-- Scriptorium added conditional "retain" for border to preserve border at page breaks -->
        <xsl:attribute name="border-after-width.conditionality">retain</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="table" use-attribute-sets="base-font">
        <!--It is a table container -->
        <xsl:attribute name="space-before">
            <xsl:value-of select="$table-space-before"/>
        </xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:value-of select="$table-space-after"/>
        </xsl:attribute>
        
    </xsl:attribute-set>
    

    <xsl:attribute-set name="table.tgroup">
        <!--It is a table-->
        <!-- Scriptorium made layout auto (doesn't work in fop). -->
        <xsl:attribute name="table-layout">
            <xsl:choose>
                <xsl:when test="$pdfFormatter='fop'">fixed</xsl:when>
                <xsl:otherwise>auto</xsl:otherwise>
            </xsl:choose>
            
        </xsl:attribute> 
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>        
    </xsl:attribute-set>
    
    <xsl:attribute-set name="tgroup.thead" use-attribute-sets="common.head__bottom">
        <!--Table head-->
    </xsl:attribute-set>
    

    <xsl:attribute-set name="table__tableframe__all" use-attribute-sets="table__tableframe__topbot table__tableframe__sides">
        <xsl:attribute name="border-before-width.conditionality">retain</xsl:attribute>
        <xsl:attribute name="border-after-width.conditionality">retain</xsl:attribute>  
    </xsl:attribute-set>
    
    <xsl:attribute-set name="table__tableframe__topbot" use-attribute-sets="table__tableframe__top table__tableframe__bottom">
        <xsl:attribute name="border-before-width.conditionality">retain</xsl:attribute>
        <xsl:attribute name="border-after-width.conditionality">retain</xsl:attribute>  
    </xsl:attribute-set>
    

    <xsl:attribute-set name="tbody.row">
        <xsl:attribute name="keep-together.within-page">3</xsl:attribute>
        <!--Table body row-->
        <!-- [SP] Reset to 0 for fop. -->
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
        <!--        <xsl:attribute name="start-indent">
            <xsl:choose>
                <xsl:when test="$pdfFormatter='fop'">
                    <xsl:value-of select="concat('-',$side-bar-width,'pt')"/>
                </xsl:when>
                <xsl:otherwise>0pt</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>-->
        
    </xsl:attribute-set>

    <xsl:attribute-set name="thead.row.entry">
        <!--head cell-->
        <xsl:attribute name="background-color">
            <xsl:value-of select="$table-head-bgcolor"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="shaded.row.entry">
        <xsl:attribute name="background-color">#cccccc</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="tfoot.row.entry">
        <!--footer cell-->
    </xsl:attribute-set>
    
    <!-- %%%%% Caption attributes -->
    
    <xsl:attribute-set name="caption.row">
        <!--Head row-->
    </xsl:attribute-set>
    
    
    <xsl:attribute-set name="caption.row.entry">
        <!--head cell-->
        <xsl:attribute name="background-color">
            <xsl:value-of select="$table-head-bgcolor"/>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="caption.row.entry__content" use-attribute-sets="common.table.body.entry common.table.head.entry">
        <xsl:attribute name="margin-bottom">0pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <!--head cell contents-->
    </xsl:attribute-set>
    
    

    <xsl:attribute-set name="simpletable">
        <!--It is a table container -->
        <!-- Scriptorium parameterized font size. -->
        <xsl:attribute name="font-size">
            <xsl:value-of select="$default-font-size"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="sthead.stentry__keycol-content">
        <!-- Scriptorium parameterized margin-left to offset the default picked up in FOP. -->
       <xsl:attribute name="background-color">
            <xsl:value-of select="$table-head-bgcolor"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="strow.stentry__keycol-content">
        <xsl:attribute name="background-color">
            <xsl:value-of select="$table-head-bgcolor"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="properties">
        <!--It is a table container -->
        <xsl:attribute name="font-size">
            <xsl:value-of select="$default-font-size"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="property.entry__keycol-content">
        <xsl:attribute name="background-color">
            <xsl:value-of select="$table-head-bgcolor"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="prophead.entry__keycol-content">
        <xsl:attribute name="background-color">
            <xsl:value-of select="$table-head-bgcolor"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="choicetable">
        <!--It is a table container -->
        <xsl:attribute name="font-size">
            <xsl:value-of select="$default-font-size"/>
        </xsl:attribute>
    </xsl:attribute-set>

</xsl:stylesheet>
