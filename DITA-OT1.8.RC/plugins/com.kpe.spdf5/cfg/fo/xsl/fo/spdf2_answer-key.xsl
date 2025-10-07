<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic-i18n="http://www.idiominc.com/opentopic/i18n"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    exclude-result-prefixes="opentopic-index opentopic opentopic-i18n opentopic-func dita-ot xs"
    version="2.0">
    
    <xsl:template name="build-answer-key">
        
        <xsl:message>BUILDING ANSWER KEY</xsl:message>
        <!-- Only process on assessments -->
        <!-- Have to manually insert page-sequence/flow because it's getting skipped in this processing -->
        <fo:page-sequence master-reference="answer-key-sequence">
            <xsl:call-template name="insertAnswerKeyStaticContents"/>
            
            <fo:flow flow-name="xsl-region-body">
                <xsl:apply-templates select="$map/descendant::*[contains(@class,' bookmap/mainbooktitle ')]" mode="answer-key"/>
                <xsl:apply-templates select="//*[contains(@class,' kpe-assessmentOverview/kpe-assessmentOverview ')]" mode="answer-key"/>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' bookmap/mainbooktitle ')]" mode="answer-key">
        <fo:block xsl:use-attribute-sets="answer-key-title">
            <xsl:apply-templates/>
        </fo:block>
        <fo:block xsl:use-attribute-sets="answer-key-subtitle">
            <xsl:text>Quiz &amp; Unit Test Questions Answer Key</xsl:text>
        </fo:block>
    </xsl:template>
    
    
    <xsl:template match="*[contains(@class,' kpe-assessmentOverview/kpe-assessmentOverview ')]" mode="answer-key">
        <fo:block xsl:use-attribute-sets="overview_title">
            <xsl:apply-templates select="parent::*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/title ')]" mode="answer-key"/>
            <xsl:text> - </xsl:text>
            <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="answer-key"/>
        </fo:block>
        
        <xsl:apply-templates select="*[contains(@class,' kpe-question/kpe-question ')]" mode="answer-key"/>
        
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' topic/title ')]" mode="answer-key">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' kpe-question/kpe-question ')]" mode="answer-key">
        <fo:block xsl:use-attribute-sets="kpe-question">
            <fo:block>
                <xsl:variable name="q_number" select="count(preceding-sibling::*[contains(@class,' kpe-question/kpe-question ')]) + 1"/>
                <xsl:variable name="dita_file" select="replace(translate(@xtrf, '\', '/'), '^.*/([^/]*)\.dita$', '$1')"/>
                
                <xsl:value-of select="concat($q_number,'. QID: ', $dita_file)"/>
            </fo:block>
            <fo:block space-after="6pt">
                <xsl:variable 
                    name="correct_answer_option" 
                    select="descendant::*[contains(@class,' learning2-d/lcAnswerOption2 ')][child::*[contains(@class,' learning2-d/lcCorrectResponse2 ')]]"/>
                <xsl:variable name="distractor">
                    <xsl:number select="$correct_answer_option" format="A"/>
                </xsl:variable>
                <xsl:value-of select="concat($distractor,'. ')"/>
                <xsl:apply-templates 
                    select="$correct_answer_option/*[contains(@class,' learning2-d/lcAnswerContent2 ')]" mode="answer-key"/>
            </fo:block>
            
            <xsl:apply-templates select="descendant::*[contains(@class,' learning2-d/lcFeedbackCorrect2 ')]" mode="answer-key"/>
            
        </fo:block>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' learning2-d/lcFeedbackCorrect2 ')]" mode="answer-key">
        <fo:block space-before="6pt" space-after="6pt">
            <xsl:apply-templates mode="answer-key"/>
        </fo:block>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' topic/p ')]" mode="answer-key">
        <fo:block>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
    
    
</xsl:stylesheet>