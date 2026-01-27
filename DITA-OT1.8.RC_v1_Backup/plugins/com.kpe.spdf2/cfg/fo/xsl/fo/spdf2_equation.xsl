<?xml version="1.0" encoding="UTF-8"?>
<!-- 
   Scriptorium overrides for fo/xsl/commons.xsl.
-->

<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:dita2xslfo="http://dita-ot.sourceforge.net/ns/200910/dita2xslfo" 
    xmlns:opentopic="http://www.idiominc.com/opentopic" 
    xmlns:m="http://www.w3.org/1998/Math/MathML"
    exclude-result-prefixes="m"
    version="2.0">

    <xsl:template match="*[contains(@class, ' equation-d/equation-figure ')]">
        <fo:block margin-left="10pt" start-indent="10pt" padding-left="10pt">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' equation-d/equation-block ')]">
        <fo:block margin-left="10pt" start-indent="10pt" padding-left="10pt">
            <xsl:choose>
                <xsl:when test="*[contains(@class,' mathml-d/mathml ')]">
                        <fo:instream-foreign-object>
                            <xsl:apply-templates/>
                        </fo:instream-foreign-object>                
                </xsl:when>
                <xsl:otherwise>
                    <fo:block>
                        <xsl:apply-templates/>
                    </fo:block>
                </xsl:otherwise>
            </xsl:choose>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class,' equation-d/equation-inline ')]">
        <xsl:choose>
            <xsl:when test="*[contains(@class,' mathml-d/mathml ')]">
                <fo:instream-foreign-object>
                    <xsl:apply-templates/>
                </fo:instream-foreign-object>                
            </xsl:when>
            <xsl:otherwise>
                <fo:inline>
                    <xsl:apply-templates/>
                </fo:inline>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class,' mathml-d/mathml ')]">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="m:math">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="math"/>
        </xsl:copy>
<!--        <xsl:copy-of select="."/>    -->
    </xsl:template>
    
    <xsl:template match="@* | node()" mode="math">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="math"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- [SP] 2018-04-17 sfb: Make fractions larger-->
    <xsl:template match="m:mfrac" mode="math">
        <m:mstyle mathsize="16pt">
            <xsl:copy>
                <xsl:apply-templates select="@* | node()" mode="math"/>                
            </xsl:copy>
        </m:mstyle>
    </xsl:template>
    
    <!-- [SP] 2018-04-17 sfb: Ignore annotation, which isn't supported by Antenna House. -->
    <xsl:template match="m:annotation" mode="math">
        <!-- do nothing. -->
    </xsl:template>


</xsl:stylesheet>
