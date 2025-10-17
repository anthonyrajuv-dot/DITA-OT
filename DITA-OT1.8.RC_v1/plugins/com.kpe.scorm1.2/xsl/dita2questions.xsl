<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:exsl="http://exslt.org/common"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:exslf="http://exslt.org/functions"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
    extension-element-prefixes="exsl"
    exclude-result-prefixes="opentopic-index opentopic exslf opentopic-func ot-placeholder"
    version="2.0">
    
    <xsl:template match="/">
        <xsl:message>In dita2questions.xsl</xsl:message>
        <xsl:apply-templates select="bookmap"/>
        
    </xsl:template>
    
    <xsl:template match="bookmap">
<!--        <xsl:message>Matching on bookmap</xsl:message>-->
        <xsl:apply-templates select="//*[contains(@class,' kpe-assessmentOverview/kpe-assessmentOverview ')]"/>
        
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' kpe-assessmentOverview/kpe-assessmentOverview ')]">
        <xsl:variable name="quiz_number" select="count(preceding::*[contains(@class,' kpe-assessmentOverview/kpe-assessmentOverview ')])+1"/>
        <xsl:variable name="quiz_name" select="concat('questions',$quiz_number,'.js')"/>
        
<!--        <xsl:message>
            quiz_name is <xsl:value-of select="$quiz_name"/>
        </xsl:message>
        
        <xsl:message>
            quiz_number is <xsl:value-of select="$quiz_number"/>
        </xsl:message>-->
        
        <xsl:result-document href="{$quiz_name}" indent="yes" method="text">
            <xsl:apply-templates select="*[contains(@class,' kpe-question/kpe-question ')]"/>
        </xsl:result-document>
    </xsl:template>
    
<!--    [SP-JLC] Generate individual questions -->
    <xsl:template match="*[contains(@class,' kpe-question/kpe-question ')]">
        <xsl:variable name="question_type">
            <xsl:choose>
                <xsl:when test="descendant::*[contains(@class,' learning2-d/lcSingleSelect2 ')]">QUESTION_TYPE_CHOICE</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="question_number" select="count(preceding::*[contains(@class,' learningAssessment/learningAssessment ')])"/>
        <xsl:variable name="answer_options">
            <xsl:apply-templates select="descendant::*[contains(@class,' learning2-d/lcAnswerOptionGroup2 ')]"/>
        </xsl:variable>
        <xsl:variable name="rationale">
            <xsl:apply-templates select="descendant::*[contains(@class,' learning2-d/lcFeedbackCorrect2 ')]"/>
        </xsl:variable>        
        
<!--        <xsl:message>Value of rationale is <xsl:value-of select="$rationale"/></xsl:message>-->
        
        <xsl:text>test.AddQuestion( new Question ("com.kaplan.interactions.quiz_</xsl:text><xsl:value-of select="$question_number"/><xsl:text>",</xsl:text>
        <xsl:text>new Array(</xsl:text>
           <xsl:apply-templates select="descendant::*[contains(@class,' learning2-d/lcQuestion2 ')]" mode="handle_question"/>
        <xsl:text>),</xsl:text>
        <xsl:value-of select="$question_type"/>,
        <xsl:text>new Array(</xsl:text><xsl:value-of select="normalize-space($answer_options)"/><xsl:text>),</xsl:text>
        <xsl:text>"</xsl:text><xsl:apply-templates select="descendant::*[contains(@class,' learning2-d/lcAnswerOption2 ')][child::*[contains(@class,' learning2-d/lcCorrectResponse2 ')]]" mode="answer"/><xsl:text>",</xsl:text>
        <xsl:text>"</xsl:text><xsl:value-of select="normalize-space($rationale)"/><xsl:text>",</xsl:text>
        <xsl:text>"obj_kaplansample")</xsl:text>
        <xsl:text>);</xsl:text>
<!--        <xsl:text>test.AddQuestion( new Question ("com.kaplan.interactions.quiz_</xsl:text><xsl:value-of select="$question_number"/><xsl:text>",</xsl:text>
        <xsl:apply-templates select="descendant::*[contains(@class,' learning2-d/lcQuestion2 ')]" mode="handle_question"/>
        <xsl:value-of select="$question_type"/>,
        <xsl:text>new Array(</xsl:text><xsl:apply-templates select="descendant::*[contains(@class,' learning2-d/lcAnswerOptionGroup2 ')]"/><xsl:text>),</xsl:text>
        <xsl:text>"</xsl:text><xsl:apply-templates select="descendant::*[contains(@class,' learning2-d/lcAnswerOption2 ')][child::*[contains(@class,' learning2-d/lcCorrectResponse2 ')]]" mode="answer"/><xsl:text>",</xsl:text>
        <xsl:text>"obj_kaplansample")</xsl:text>
        <xsl:text>);</xsl:text>
-->    </xsl:template>
    
<!--    [SP-JLC] Process question body -->
    <xsl:template match="*[contains(@class,' learning2-d/lcQuestion2 ')]" mode="handle_question">
        <xsl:choose>
            <xsl:when test="child::*[contains(@class,' topic/p ')]"><xsl:apply-templates mode="handle_question"/></xsl:when>
            <xsl:otherwise>
                <xsl:text>"</xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text>"</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' topic/p ')]" mode="handle_question">
        <xsl:variable name="processed-block">
            <xsl:apply-templates select="." mode="process-block"/>
        </xsl:variable>
        <xsl:text>"</xsl:text><xsl:value-of select="normalize-space($processed-block)"/><xsl:text>"</xsl:text>
<!--        <xsl:text>"</xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text>"</xsl:text>-->
        <xsl:if test="following-sibling::*[contains(@class,' topic/p ')]"><xsl:text>,</xsl:text></xsl:if>
    </xsl:template>
    
<!--    [SP-JLC] Process answers -->
    <xsl:template match="*[contains(@class,' learning2-d/lcAnswerOptionGroup2 ')]">
        <xsl:apply-templates select="*[contains(@class,' learning2-d/lcAnswerOption2 ')]"/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' learning2-d/lcAnswerContent2 ')]">
        <xsl:choose>
            <xsl:when test="parent::*/count(following-sibling::*) = 0"><xsl:text>"</xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text>"</xsl:text></xsl:when>
            <xsl:otherwise><xsl:text>"</xsl:text><xsl:value-of select="normalize-space(.)"/><xsl:text>",</xsl:text></xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
<!--    [SP-JLC] Process correct answer -->
    <xsl:template match="*[contains(@class,' learning2-d/lcAnswerOption2 ')][child::*[contains(@class,' learning2-d/lcCorrectResponse2 ')]]" mode="answer">
<!--        <xsl:message>Found the answer node!</xsl:message>-->
        <xsl:apply-templates select="*[contains(@class,' learning2-d/lcAnswerContent2 ')]" mode="answer"/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' learning2-d/lcAnswerContent2 ')]" mode="answer"><xsl:value-of select="normalize-space(.)"/></xsl:template>
    
<!--   [SP-JLC] Process inline elements, escape quotes -->
    <xsl:template match="*" mode="process-block">
        <xsl:apply-templates mode="process-block"/>
    </xsl:template>
    
    <xsl:template match="text()" mode="process-block">
        <xsl:variable name="replaced-quotes">"</xsl:variable>
        <xsl:variable name="replace-quotes" select="'&amp;quot;'"/>
        <xsl:variable name="current-node" select="."/>
        <xsl:variable name="replaced-node" select="replace($current-node, $replaced-quotes, $replace-quotes)"/> 
        
        <xsl:value-of select="normalize-space($replaced-node)" disable-output-escaping="yes"/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' hi-d/b ')]" mode="process-block">
        &lt;b><xsl:value-of select="normalize-space(.)"/>&lt;/b>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' hi-d/i ')]" mode="process-block">
        &lt;i><xsl:value-of select="normalize-space(.)"/>&lt;/i>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' hi-d/u ')]" mode="process-block">
        &lt;u><xsl:value-of select="normalize-space(.)"/>&lt;/u>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' learning2-d/lcFeedbackCorrect2 ')]">
        <xsl:apply-templates mode="process-block"/>
    </xsl:template>
    
</xsl:stylesheet>