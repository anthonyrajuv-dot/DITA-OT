<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    xmlns:opentopic="http://www.idiominc.com/opentopic" xmlns:m="http://www.w3.org/1998/Math/MathML"
    exclude-result-prefixes="xs functx ditaarch opentopic m" version="2.0">



    <!--SP Stylesheet created by Scriptorium Publishing. Code comments preceded with SP -->

    <!-- Shell template for CFA output. Imports the contents of the default processing (dita2idml.xsl), which is shared by CFA and RE. -->

    <xsl:template name="story">
        <Story Self="aaa">
            <xsl:apply-templates/>
        </Story>
    </xsl:template>

    <xsl:template match="kpe-question[last()]" priority="22">
        <xsl:apply-templates/>
        <xsl:call-template name="answerkey"/>
    </xsl:template>

    <xsl:include href="dita2idml.xsl"/>

    <xsl:template match="lcAnswerContent | lcAnswerContent2" priority="20">
        <xsl:variable name="prefix">
            <xsl:number value="count(../preceding-sibling::*) + 1" format="A"/>
            <xsl:text>.</xsl:text>
        </xsl:variable>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'lcanswercontent'"/>
            <xsl:with-param name="prefix" select="$prefix"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="answerkey">
        <!--SP insert header information -->
        <xsl:call-template name="selftestheader">
            <xsl:with-param name="heading">Concept Checkers: Answers</xsl:with-param>
        </xsl:call-template>

        <xsl:for-each
            select="../kpe-question/kpe-questionbody/lcInteraction/lcSingleSelect2/lcAnswerOptionGroup2/lcAnswerOption2/lcCorrectResponse2">
            <xsl:variable name="prefix">
                <xsl:number
                    value="count(ancestor::*[contains(@class,' kpe-question/kpe-question ')][1]/preceding-sibling::*[contains(@class,' kpe-question/kpe-question ')]) + 1"
                    format="1"/>
                <xsl:text>.</xsl:text>
            </xsl:variable>
            <xsl:variable name="answer">
                <xsl:number value="count(../preceding-sibling::*) + 1" format="A"/>
            </xsl:variable>

            <xsl:choose>
                <xsl:when test="../../../lcFeedbackCorrect2/p">
                    <xsl:apply-templates select="../../../lcFeedbackCorrect2/p" mode="answer">
                        <xsl:with-param name="ditaname" select="'lcfeedbackcorrect'"/>
                        <xsl:with-param name="prefix" select="$prefix"/>
                        <xsl:with-param name="answer" select="$answer"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>

                    <xsl:apply-templates select="../../../lcFeedbackCorrect2" mode="answer">
                        <xsl:with-param name="ditaname" select="'lcfeedbackcorrect'"/>
                        <xsl:with-param name="prefix" select="$prefix"/>
                        <xsl:with-param name="answer" select="$answer"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>

    </xsl:template>

    <xsl:template match="lcFeedbackCorrect2" mode="answer">
        <xsl:param name="ditaname"/>
        <xsl:param name="prefix"/>
        <xsl:param name="answer"/>
        <xsl:message>Handling lcFeedbackCorrect2 in CFA</xsl:message>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="$ditaname"/>
            <xsl:with-param name="prefix" select="$prefix"/>
            <xsl:with-param name="answer" select="$answer"/>
        </xsl:call-template>

    </xsl:template>

    <xsl:template match="p[1]" mode="answer" priority="50">
        <xsl:param name="ditaname"/>
        <xsl:param name="prefix"/>
        <xsl:param name="answer"/>

        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="$ditaname"/>
            <xsl:with-param name="prefix" select="$prefix"/>
            <xsl:with-param name="answer" select="$answer"/>
        </xsl:call-template>

    </xsl:template>

    <xsl:template match="p" mode="answer">
        <xsl:param name="ditaname"/>
        <xsl:param name="prefix"/>
        <xsl:param name="answer"/>

        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="$ditaname"/>
            <xsl:with-param name="prefix" select="$tab"/>
            <xsl:with-param name="answer" select="$answer"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="lcObjectivesStem" priority="50">

        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'lcobjectivesstem'"/>
        </xsl:call-template>
    </xsl:template>

<!--    <xsl:template
        match="*[contains(@class,' concept/concept ')]/*[contains(@class,' topic/title ')]"
        priority="4">
        <xsl:variable name="parent_id" select="parent::*/@id"/>
        <xsl:variable name="parent_topicref" select="$map//*[@id = $parent_id]"/>
        <xsl:variable name="topic_navtitle" select="$parent_topicref/topicmeta/*[contains(@class,' topic/navtitle ')]"/>
        <xsl:message>Value of $topic_navtitle is <xsl:value-of select="$topic_navtitle"/></xsl:message>
        <xsl:choose>
            <xsl:when test="count($topic_navtitle) &gt; 0">
                <xsl:for-each select="$topic_navtitle">
                    <xsl:call-template name="processpara">
                        <xsl:with-param name="ditaname" select="'chaptertitle'"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'chaptertitle'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->

</xsl:stylesheet>
