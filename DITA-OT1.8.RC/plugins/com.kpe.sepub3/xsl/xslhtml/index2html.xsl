<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
    xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
    xmlns:exsl="http://exslt.org/common" xmlns:java="org.dita.dost.util.ImgUtils"
    xmlns:url="org.dita.dost.util.URLUtils" xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xhtml="http://www.w3.org/1999/xhtml"
    exclude-result-prefixes="dita-ot dita2html ditamsg exsl java url #default xhtml">

    <xsl:output method="xml"
        encoding="utf-8" 
        indent="no" />
<!-- 
            doctype-public="-//W3C//DTD XHTML 1.1//EN"
        doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"       
        omit-xml-declaration="yes"
    -->

    <xsl:param name="SOURCEFILE"/>
    <xsl:param name="PATH2PROJ"/>
    <xsl:param name="file.separator"/>

    <xsl:variable name="abs_path">
        <xsl:call-template name="substring-before-last">
            <xsl:with-param name="input" >
                <xsl:choose>
                    <xsl:when test="$file.separator = '/'">
                        <xsl:value-of select="translate($SOURCEFILE,'\',$file.separator)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="translate($SOURCEFILE,'/',$file.separator)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="substr" select="$file.separator"/>
        </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="newline" select="'&#x0A;'"/>

   <!-- <xsl:output method="xml" indent="no" omit-xml-declaration="yes"/>-->

    <xsl:variable name="alpha_uc" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    <xsl:variable name="alpha_lc" select="'abcdefghijklmnopqrstuvwxyz'"/>

    <xsl:template match="/">
        <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
        
        <html xmlns="http://www.w3.org/1999/xhtml" xmlns:epub="http://www.idpf.org/2007/ops">
            
            <head>
<!--                <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>-->
                <!-- [SP] comment out default stylesheet SSO -->
            <!--    <link rel="stylesheet" type="text/css" href="commonltr.css"/>-->
<!--                <link rel="stylesheet" type="text/css" href="local.css"/>-->
                <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}css/kpe_epub.css"/>
                <title>final_index</title>
            </head>
            <body class="index">
                <xsl:apply-templates select="group_index"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="group_index">
        <xsl:value-of select="$newline"/>
        <h1 class="index">Index</h1>
        <xsl:call-template name="one-letter">
            <xsl:with-param name="current" select="$alpha_uc"/>
        </xsl:call-template>
        <xsl:value-of select="$newline"/>
    </xsl:template>

    <xsl:template name="one-letter">
        <xsl:param name="current"/>
        <xsl:if test="string-length($current)>0">
            <xsl:variable name="this_letter" select="substring($current,1,1)"/>
            <xsl:variable name="matching_terms"
                select="group[translate(substring(@sortstring,1,1),$alpha_lc,$alpha_uc) = $this_letter]"/>
            <xsl:if test="count($matching_terms) > 0">
                <h2 class="index">
                    <xsl:value-of select="$this_letter"/>
                </h2>
                <xsl:value-of select="$newline"/>
                <ul class="simple_index">
                    <xsl:value-of select="$newline"/>
                    <xsl:apply-templates select="$matching_terms">
                        <xsl:sort select="translate(@sortstring,$alpha_uc,$alpha_lc)"/>
                    </xsl:apply-templates>
                </ul>
                <xsl:value-of select="$newline"/>
            </xsl:if>
            <xsl:call-template name="one-letter">
                <xsl:with-param name="current" select="substring($current,2)"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template match="group[parent::group_index]">
        <li class="li level 1">
            <xsl:variable name="trans_ncname" select="translate(text[1],' :,/&#8220;&#8221;&#8216;&#8217;&#40;&#41;','_')"/>
            <xsl:attribute name="id">
                <xsl:value-of
                    select="$trans_ncname"/>
            </xsl:attribute>
            <xsl:apply-templates select="group"/>
            <xsl:choose>
                <xsl:when test="count(entry) &gt; 1">
                    <xsl:value-of select="@sortstring"/>
                    <xsl:for-each select="entry">
                        <xsl:if test="not(position() = 1)">
                            <xsl:text>,</xsl:text>
                        </xsl:if>
                        <xsl:text xml:space="preserve"> </xsl:text>
                        <a>                            
                            <xsl:attribute name="href">
                                <xsl:call-template name="fix_href">
                                    <xsl:with-param name="href" select="@href"/>
                                </xsl:call-template>
                            </xsl:attribute>
                            <xsl:value-of select="position()"/>
                        </a>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="entry[not(@index-see-also)]"/>
                </xsl:otherwise>
            </xsl:choose>
        </li>
    </xsl:template>

    <xsl:template match="group[parent::group]">
        <xsl:value-of select="../@sortstring"/>
        <ul class="ul level 2">
            <xsl:for-each select="entry">
                <xsl:sort select="translate(@sortstring,$alpha_uc,$alpha_lc)"/>
                <li class="li level 2">
                    <xsl:apply-templates select="."/>
                </li>
            </xsl:for-each>
            <xsl:for-each select="parent::group/entry[@index-see-also]">
                <xsl:sort select="translate(@sortstring,$alpha_uc,$alpha_lc)"/>
                <li class="li level 2">
                    <xsl:apply-templates select="."/>
                </li>
            </xsl:for-each>
        </ul>
    </xsl:template>

    <xsl:template match="entry">
        <xsl:choose>
            <xsl:when test="@index-see">
                <xsl:value-of select="@sortstring"/>
                <xsl:text>, </xsl:text>
                <i>see</i>
                <xsl:text> </xsl:text>
                <a>
                    <xsl:variable name="trans_ncname" select="translate(@index-see,' ,&#8220;&#8221;&#8216;&#8217;&#40;&#41;','_')"/>
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat('#',$trans_ncname)"
                        />
                    </xsl:attribute>
                    
                    <xsl:value-of select="@index-see"/>
                </a>
            </xsl:when>
            <xsl:when test="@index-see-also">
                <xsl:text> </xsl:text>
                <i>see also</i>
                <xsl:text> </xsl:text>
                <a>
                    <xsl:variable name="trans_ncname" select="translate(@index-see-also,' ,&#8220;&#8221;&#8216;&#8217;&#40;&#41;','_')"/>
                    <xsl:attribute name="href">
                        <xsl:value-of select="concat('#',$trans_ncname)"/>
                    </xsl:attribute>
                    <xsl:value-of select="@index-see-also"/>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <a>                    
                    <xsl:attribute name="href">
                        <xsl:call-template name="fix_href">
                            <xsl:with-param name="href" select="@href"/>
                        </xsl:call-template>
                    </xsl:attribute>
                    <xsl:value-of
                        select="preceding-sibling::text[1]"/>                    
                </a>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="fix_href">
        <xsl:param name="href"/>
        <xsl:choose>
            <xsl:when test="contains($href,'.xml')">
                <xsl:value-of select="concat(substring-before($href,'.xml'),'.html')"/>
            </xsl:when>
            <xsl:when test="contains($href,'.dita')">
                <xsl:value-of select="concat(substring-before($href,'.dita'),'.html')"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="substring-before-last">
        <xsl:param name="input"/>
        <xsl:param name="substr"/>
        <xsl:if test="$substr and contains($input, $substr)">
            <xsl:variable name="temp" select="substring-after($input, $substr)"/>
            <xsl:value-of select="substring-before($input, $substr)"/>
            <xsl:if test="contains($temp, $substr)">
                <xsl:value-of select="$substr"/>
                <xsl:call-template name="substring-before-last">
                    <xsl:with-param name="input" select="$temp"/>
                    <xsl:with-param name="substr" select="$substr"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
