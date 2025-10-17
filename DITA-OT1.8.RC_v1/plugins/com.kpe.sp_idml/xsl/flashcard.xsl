<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    xmlns:opentopic="http://www.idiominc.com/opentopic" xmlns:m="http://www.w3.org/1998/Math/MathML"
    exclude-result-prefixes="xs functx ditaarch opentopic m" version="2.0">
    
    <xsl:template name="flashcardfront">
        <Story Self="bbb">
            <xsl:for-each select="//topicref">
                <xsl:variable name="myid" select="@id"/>
                <xsl:variable name="unittitle" select="preceding-sibling::topichead[1]/topicmeta/navtitle"/>
                <xsl:for-each select="//kpe-glossEntry[@id = $myid]">
                <!--select="." is used here to ensure that we actually process on kpe-glossEntry, rather than processing within it-->
                    <xsl:apply-templates select="." mode="flashcardfront">
                        <xsl:with-param name="unittitle" select="$unittitle"/>
                    </xsl:apply-templates>
                </xsl:for-each>
            </xsl:for-each>
        </Story>
    </xsl:template>
    
    <xsl:template name="flashcardback">
        <Story Self="ccc">
            <xsl:for-each select="//topicref">
                <xsl:variable name="myid" select="@id"/>
                <xsl:variable name="unittitle" select="preceding-sibling::topichead[1]/topicmeta/navtitle"/>
                <xsl:for-each select="//kpe-glossEntry[@id = $myid]">
                    <!--select="." is used here to ensure that we actually process on kpe-glossEntry, rather than processing within it-->
                    <xsl:apply-templates select="." mode="flashcardback">
                        <xsl:with-param name="unittitle" select="$unittitle"/>
                    </xsl:apply-templates>
                </xsl:for-each>
            </xsl:for-each>
        </Story>
    </xsl:template>
    
    <xsl:template match="kpe-glossEntry" mode="flashcardfront">
        <xsl:param name="unittitle" as="element()*"/>
        <xsl:apply-templates select="glossterm" mode="flashcardfront">
            <xsl:with-param name="unittitle" select="$unittitle"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="kpe-glossEntry" mode="flashcardback">
        <xsl:param name="unittitle" as="element()*"/>
        <xsl:apply-templates select="glossdef" mode="flashcardback">
            <xsl:with-param name="unittitle" select="$unittitle"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="glossterm" mode="flashcardfront">
        <xsl:param name="unittitle" as="element()*"/>
        <xsl:apply-templates select="$unittitle" mode="flashcards"/>
        <xsl:call-template name="processpara">
           <xsl:with-param name="ditaname" select="'sli'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="glossdef" mode="flashcardback">
        <xsl:param name="unittitle" as="element()*"/>
        <xsl:apply-templates select="$unittitle" mode="flashcards"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicp'"/>
        </xsl:call-template>
    </xsl:template>    
    
    <xsl:template match="navtitle" mode="flashcards">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'chaptertitle'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="story"/>

    <xsl:include href="dita2idml.xsl"/>

</xsl:stylesheet>
