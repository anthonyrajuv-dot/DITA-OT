<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
    xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
    xmlns:exsl="http://exslt.org/common" xmlns:java="org.dita.dost.util.ImgUtils"
    xmlns:url="org.dita.dost.util.URLUtils" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="dita-ot dita2html ditamsg exsl java url #default xhtml">

    <xsl:param name="part_content"/>
    <xsl:param name="navtitle-trans"/>
    <xsl:param name="outdir"/>

    <xsl:template name="part_builder">
        <xsl:param name="part_content"/>
        <xsl:param name="navtitle-trans"/>
        <xsl:param name="outdir"/>
<!--testing for xhtml didn't work psb-->
        <xsl:variable name="output_filename"
            select="concat('file:///',$outdir,translate($navtitle-trans,' ','_'),'.html')"/>

        <xsl:result-document href="{$output_filename}">
            <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
<!--                    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>-->
                    <!-- [SP] comment out the default stylesheet because it causes trouble SSO -->
                  <!--  <link rel="stylesheet" type="text/css" href="commonltr.css"/>-->
                    <link rel="stylesheet" type="text/css" href="local.css"/>
                    <title>
                        <xsl:value-of select="@navtitle"/>
                    </title>
                </head>
                <body>
                    <div class="part_body">
                        <img>
                            <xsl:attribute name="alt">
                                <xsl:value-of select="@navtitle"/>
                            </xsl:attribute>
                            <xsl:attribute name="class" select="'image'"/>
                            <xsl:attribute name="id" select="./descendant::image/@id"/>
                            <xsl:attribute name="src">
                                <xsl:value-of select="./descendant::image/@href"/>
                            </xsl:attribute>
                        </img>
                        <h1 class="part_title">
                            <!-- [SP] add processing for Part n SSO -->
                                <xsl:variable name="partnumber">
                                    <xsl:text>Part </xsl:text>
                                    <xsl:value-of
                                        select="count(preceding::*[(name() = 'part')])+1"/>
                                    <xsl:text>: </xsl:text>
                                </xsl:variable>
                                        <xsl:value-of select="$partnumber"/>
                            <xsl:value-of select="@navtitle"/>
                        </h1>
                    </div>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>

    <xsl:template name="cover_builder">
        <xsl:param name="book_title"/>
        <xsl:param name="outdir"/>
        <xsl:variable name="output_filename" select="concat('file:///',$outdir,'cover.html')"/>
<!--psb testing for xhtml didn't work-->
        <xsl:result-document href="{$output_filename}">
            <html xmlns="http://www.w3.org/1999/xhtml">
                <head>
<!--                    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>-->
                    <!-- [SP] comment out default CSS 
                    <link rel="stylesheet" type="text/css" href="commonltr.css"/>-->
<!--                    <link rel="stylesheet" type="text/css" href="local.css"/>-->
                    <title>
                        <xsl:value-of select="$book_title"/>
                    </title>
                </head>
                <body>
                    <div class="cover_body">
                        <!-- KPE wants blank document. -->
<!--                        <img>
                            <xsl:attribute name="alt">
                                <xsl:value-of select="@class"/>
                            </xsl:attribute>
                            <xsl:attribute name="class" select="'image'"/>
                            <!-\- [SP] 29-Apr-2013: No need for an ID, and there is no @id value. -\->
                            <!-\- <xsl:attribute name="id" select="./@id"/> -\->
                            <xsl:attribute name="src">
                                <xsl:value-of select="./@href"/>
                            </xsl:attribute>
                        </img>-->
                    </div>
                </body>
            </html>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>
