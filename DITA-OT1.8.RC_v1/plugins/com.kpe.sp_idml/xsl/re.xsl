<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    xmlns:opentopic="http://www.idiominc.com/opentopic" xmlns:m="http://www.w3.org/1998/Math/MathML"
    exclude-result-prefixes="xs functx ditaarch opentopic m" version="2.0">



    <!--SP Stylesheet created by Scriptorium Publishing. Code comments preceded with SP -->

    <!-- Shell template for CFA output. Imports the contents of the default processing (dita2idml.xsl), which is shared by CFA and RE. -->


    <!-- SP This is a very fragile template for unit exam questions. It assumes that unit exam questions have an empty title. We need
           metadata to distinguish between case study questions and unit exame questions. Both use kpe-question -->

    <xsl:template name="story">
        <Story Self="aaa">
            <xsl:apply-templates/>
            <xsl:call-template name="answerkey"/>
        </Story>

        <!-- SP insert three-column flows for key terms -->

        <xsl:for-each select="//section[@outputclass = 'no_bold_on_term']/sl">
            <Story Self="{generate-id()}" AppliedTOCStyle="n" TrackChanges="false" StoryTitle="$ID/"
                AppliedNamedGrid="n">
                <StoryPreference OpticalMarginAlignment="false" OpticalMarginSize="12"
                    FrameType="TextFrameType" StoryOrientation="Horizontal"
                    StoryDirection="LeftToRightDirection"/>
                <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/key_term">
                    <CharacterStyleRange
                        AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">

                        <xsl:for-each select="sli">
                            <Content>
                                <xsl:value-of select="normalize-space(.)"/>
                            </Content>
                            <Br/>
                        </xsl:for-each>
                    </CharacterStyleRange>
                </ParagraphStyleRange>
            </Story>
        </xsl:for-each>

        <!-- SP insert flows for margin notes (callouts)-->

        <xsl:for-each select="//callout">
            <Story Self="{generate-id()}" AppliedTOCStyle="n" TrackChanges="false" StoryTitle="$ID/"
                AppliedNamedGrid="n">
                <StoryPreference OpticalMarginAlignment="false" OpticalMarginSize="12"
                    FrameType="TextFrameType" StoryOrientation="Horizontal"
                    StoryDirection="LeftToRightDirection"/>
                <InCopyExportOption IncludeGraphicProxies="true" IncludeAllResources="false"/>
                <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/figure_head">
                    <CharacterStyleRange
                        AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                        <Table Self="t{generate-id()}" HeaderRowCount="0" FooterRowCount="0"
                            BodyRowCount="2" ColumnCount="1"
                            AppliedTableStyle="TableStyle/$ID/[No table style]"
                            TableDirection="LeftToRightDirection">
                            <Row Self="t{generate-id()}row0" Name="0" SingleRowHeight="3"
                                MinimumHeight="3" AutoGrow="false"/>
                            <Row Self="t{generate-id()}row1" Name="1"
                                SingleRowHeight="123.94087707519532"
                                MinimumHeight="113.98289001464843"/>
                            <Column Self="t{generate-id()}Column0" Name="0" SingleColumnWidth="132"/>
                            <Cell Self="t{generate-id()}cell1" Name="0:0" RowSpan="1" ColumnSpan="1"
                                AppliedCellStyle="CellStyle/MN_header" AppliedCellStylePriority="1"
                                FillColor="Color/Black" LeftEdgeStrokePriority="1"
                                RightEdgeStrokePriority="1" TopEdgeStrokePriority="1"
                                BottomEdgeStrokePriority="4">
                                <!--                                <ParagraphStyleRange
                                    AppliedParagraphStyle="ParagraphStyle/$ID/[No paragraph style]">
                                    <CharacterStyleRange
                                        AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                                        <Properties>
                                            <AppliedFont type="string">Goudy Oldstyle
                                                Std</AppliedFont>
                                        </Properties>
                                    </CharacterStyleRange>
                                </ParagraphStyleRange>-->
                            </Cell>
                            <Cell Self="t{generate-id()}cell2" Name="0:1" RowSpan="1" ColumnSpan="1"
                                AppliedCellStyle="CellStyle/MN_body" AppliedCellStylePriority="2"
                                FillColor="Color/Black" FillTint="10" LeftEdgeStrokePriority="1"
                                RightEdgeStrokePriority="1" TopEdgeStrokePriority="4"
                                BottomEdgeStrokePriority="1">
                                <xsl:apply-templates/>
                            </Cell>
                        </Table>
                    </CharacterStyleRange>
                </ParagraphStyleRange>
            </Story>
        </xsl:for-each>
    </xsl:template>

    <!--SP Add handling for lcIntro-->
    <xsl:template match="lcIntro" priority="50">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'lcIntro'"/>
        </xsl:call-template>
    </xsl:template>

    <!--SP Add handling for RE_directions paragraph style-->

    <xsl:template match="kpe-questionBody/lcIntro[following-sibling::lcInteraction/lcMatching2]"
        priority="51">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'redirections'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template
        match="kpe-questionBody/lcIntro[matches(ancestor::kpe-question/title, 'Activity:.*')]"
        priority="51">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'redirections'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template
        match="kpe-assessmentOverviewBody/section/p[ancestor::kpe-assessmentOverview/title = 'True or False']"
        priority="51">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'redirections'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template
        match="kpe-assessmentOverviewBody/section/p[ancestor::kpe-assessmentOverview/title = 'Multiple Choice']"
        priority="51">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'redirections'"/>
        </xsl:call-template>
    </xsl:template>

    <!--PSB 9/4/15 Added p[1] to get first paragraph of question to tie to number-->
    <xsl:template match="lcQuestion2/p[1][string-length(ancestor::title/text()) = 0]" priority="25">
        <xsl:variable name="prefix">
            <xsl:number value="count(ancestor::kpe-question[1]/preceding-sibling::kpe-question) + 1"
                format="1"/>
            <xsl:text>.</xsl:text>
        </xsl:variable>
        <xsl:variable name="ditaname">
            <xsl:choose>
                <xsl:when
                    test="ancestor::kpe-question/kpe-questionBody/lcInteraction/lcSingleSelect2[@outputclass = 'true_false']">
                    <xsl:choose>
                        <xsl:when test="$prefix = '1.'">
                            <xsl:text>truefalsefirst</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>truefalse</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$prefix = '1.'">
                    <xsl:text>lcquestion1</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>lcquestion</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="$ditaname"/>
            <!--   <xsl:with-param name="prefix" select="$prefix"/>-->
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="lcAnswerContent | lcAnswerContent2" priority="20">
        <!--    <xsl:variable name = "prefix">
            <xsl:number value="count(../preceding-sibling::*) + 1" format="A"/>
            <xsl:text>.</xsl:text>
        </xsl:variable>-->
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'lcanswercontent'"/>
            <!--    <xsl:with-param name="prefix" select="$prefix"/>-->
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="answerkey">
        <!--SP insert header information -->
        <xsl:call-template name="processpara">
            <xsl:with-param name="prefix">
                <xsl:text>Answer Key</xsl:text>
                <xsl:value-of select="$tab"/>
            </xsl:with-param>
            <xsl:with-param name="ditaname">unittitle</xsl:with-param>
        </xsl:call-template>



        <xsl:for-each select="//kpe-assessmentOverview[@outputclass = 'topic_intro']">
            <xsl:apply-templates mode="answer"/>

        </xsl:for-each>


        <xsl:for-each select="//kpe-assessmentOverview[@outputclass = 'rationale_key']">
            <xsl:apply-templates select="title" mode="rationale_key"/>
            <xsl:apply-templates select="descendant::*[contains(@class,' learning2-d/lcCorrectResponse2 ')] | 
                descendant::*[contains(@class,' learning2-d/lcMatchTable2 ')] | 
                descendant::*[contains(@class,' learning2-d/lcOpenAnswer2 ')]" mode="rationale_key"/>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="kpe-assessmentOverview[@outputclass = 'rationale_key']/title"
        mode="rationale_key">
        <xsl:variable name="prefix">
            <xsl:text>Answer Key for </xsl:text>
        </xsl:variable>
        <xsl:call-template name="processpara">
            <xsl:with-param name="prefix" select="$prefix"/>
            <xsl:with-param name="ditaname" select="'quiztitle'"/>
        </xsl:call-template>

    </xsl:template>

    <xsl:template match="kpe-assessmentOverview[@outputclass = 'topic_intro']/title" mode="answer">
        <xsl:variable name="prefix">
            <xsl:text>Unit </xsl:text>
            <xsl:value-of
                select="count(preceding::kpe-assessmentOverview[@outputclass = 'topic_intro']/title) + 1"/>
            <xsl:text> </xsl:text>
        </xsl:variable>
        <xsl:variable name="suffix" select="' Answers'"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="prefix" select="$prefix"/>
            <xsl:with-param name="ditaname" select="'quiztitle'"/>
            <xsl:with-param name="suffix" select="$suffix"/>
        </xsl:call-template>

    </xsl:template>

    <xsl:template match="lcOpenAnswer2" mode="rationale_key">
        <xsl:param name="ditaname"/>
        <xsl:param name="answer"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'lcfeedbackcorrect'"/>
            <xsl:with-param name="answer" select="$answer"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="lcFeedbackCorrect2" mode="rationale_key">
        <xsl:param name="ditaname"/>
        <xsl:param name="answer"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'lcfeedbackcorrect'"/>
            <xsl:with-param name="answer" select="$answer"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="lcOpenAnswer2/p" mode="rationale_key">
        <xsl:param name="ditaname"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'lcfeedbackcorrect'"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="lcOpenAnswer2/emphasisBold" mode="rationale_key">
        <xsl:param name="ditaname"/>
        <!--        <xsl:param name="prefix"/>-->
        <!--        <xsl:param name="answer"/>-->
        <!--        <xsl:variable name="prefix">
            <xsl:number
                value="count(ancestor::*[contains(@class,' kpe-question/kpe-question ')][1]/preceding-sibling::*[contains(@class,' kpe-question/kpe-question ')]) + 1"
                format="1"/>
            <xsl:text>.</xsl:text>
        </xsl:variable>-->
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="$ditaname"/>
            <!--            <xsl:with-param name="answer" select="$answer"/>-->
        </xsl:call-template>

    </xsl:template>
    
<!--PSB 9/3/15 Added support for b-->
    <xsl:template match="lcOpenAnswer2/b" mode="rationale_key">
        <xsl:param name="ditaname"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="$ditaname"/>
        </xsl:call-template>
    </xsl:template>
<!--    <xsl:template match="lcFeedbackCorrect2/b | lcOpenAnswer2/b" mode="rationale_key">
        <xsl:param name="ditaname"/>
        <!-\-        <xsl:param name="prefix"/>-\->
        <!-\-        <xsl:param name="answer"/>-\->
        <!-\-        <xsl:variable name="prefix">
            <xsl:number
                value="count(ancestor::*[contains(@class,' kpe-question/kpe-question ')][1]/preceding-sibling::*[contains(@class,' kpe-question/kpe-question ')]) + 1"
                format="1"/>
            <xsl:text>.</xsl:text>
        </xsl:variable>-\->
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="$ditaname"/>
            <!-\-            <xsl:with-param name="answer" select="$answer"/>-\->
        </xsl:call-template>
        
    </xsl:template>-->
    <xsl:template match="lcOpenAnswer2/emphasisItalics" mode="rationale_key">
        <xsl:param name="ditaname"/>
        <!--        <xsl:param name="prefix"/>-->
        <!--        <xsl:param name="answer"/>-->
        <!--        <xsl:variable name="prefix">
            <xsl:number
                value="count(ancestor::*[contains(@class,' kpe-question/kpe-question ')][1]/preceding-sibling::*[contains(@class,' kpe-question/kpe-question ')]) + 1"
                format="1"/>
            <xsl:text>.</xsl:text>
        </xsl:variable>-->
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="$ditaname"/>
            <!--            <xsl:with-param name="answer" select="$answer"/>-->
        </xsl:call-template>

    </xsl:template>
<!--    PSB 9/3/15 Added support for i-->

    <xsl:template match="lcOpenAnswer2/i" mode="rationale_key">
        <xsl:param name="ditaname"/>
        <!--        <xsl:param name="prefix"/>-->
        <!--        <xsl:param name="answer"/>-->
        <!--        <xsl:variable name="prefix">
            <xsl:number
                value="count(ancestor::*[contains(@class,' kpe-question/kpe-question ')][1]/preceding-sibling::*[contains(@class,' kpe-question/kpe-question ')]) + 1"
                format="1"/>
            <xsl:text>.</xsl:text>
        </xsl:variable>-->
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="$ditaname"/>
            <!--            <xsl:with-param name="answer" select="$answer"/>-->
        </xsl:call-template>
        
    </xsl:template>
    
  

    
    
<!--    PSB 9/18 added support for ol, ul-->
    <xsl:template match="lcOpenAnswer2/ul/li" mode="rationale_key">
        <xsl:param name="ditaname"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'lcfeedbackcorrect'"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="lcOpenAnswer2/ol/li" mode="rationale_key">
        <xsl:param name="ditaname"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'lcfeedbackcorrect'"/>
        </xsl:call-template>
    </xsl:template>
    <!--End of lcOpenAnswer2 addition-->








    <!--    <xsl:template match="*[contains(@class,' topic/table ')]" mode="rationale_key">
        <xsl:variable name="colcount" select="tgroup/@cols"/>
        <xsl:variable name="allcolwidths" select="tgroup/colspec/@colwidth"/>

        <Table TableDirection="LeftToRightDirection">
            <xsl:attribute name="Self" select="generate-id()"/>
            <xsl:attribute name="ColumnCount" select="$colcount"/>
            <xsl:attribute name="HeaderRowCount" select="count(tgroup/thead/row)"/>
            <xsl:attribute name="BodyRowCount" select="count(tgroup/tbody/row)"/>
            <xsl:attribute name="FooterRowCount" select="count(tgroup/tfoot/row)"/>
            <xsl:attribute name="AppliedTableStyle">TableStyle/ExampleTable</xsl:attribute>

            <xsl:variable name="tableid" select="generate-id()"/>

            <xsl:for-each select="tgroup/*/row">
                <xsl:variable name="rowcount" select="position() - 1"/>
                <Row Self="{$tableid}Row{$rowcount}" Name="{$rowcount}"/>
            </xsl:for-each>



            <xsl:call-template name="tablecols">
                <xsl:with-param name="colcount" select="$colcount"/>
                <xsl:with-param name="allcolwidths" select="$allcolwidths"/>
                <xsl:with-param name="colspec" select="$allcolwidths[$colcount+1]"/>
                <xsl:with-param name="defaultcolwidth" select="floor($pagewidth div $colcount)"/>
                <xsl:with-param name="tableid" select="$tableid"/>
            </xsl:call-template>

            <xsl:apply-templates/>
        </Table>
        <Br/>

    </xsl:template>-->

    <xsl:template
        match="kpe-questionBody | lcInteraction | lcSingleSelect2 | lcAnswerOptionGroup2 | lcAnswerOption2"
        mode="answer">
        <xsl:apply-templates mode="answer"/>
    </xsl:template>

<!--    <xsl:template match="kpe-question">
        <xsl:apply-templates mode="rationale_key"/>
    </xsl:template>-->

    <!--    <xsl:template
        match="kpe-questionBody | lcInteraction | lcSingleSelect2 | lcAnswerOptionGroup2 | lcAnswerOption2"
        mode="rationale_key">
        <xsl:apply-templates mode="rationale_key"/>
    </xsl:template>-->





<!--    <xsl:template match="kpe-assessmentOverviewBody" mode="rationale_key">
        <apply-templates mode="rationale_key"/>
    </xsl:template>-->

    <xsl:template match="kpe-assessmentOverviewBody" mode="answer">
        <!--        <xsl:apply-templates mode="letter_key"/>-->
        <xsl:variable name="questions" select="../kpe-question" as="element()*"/>
        <xsl:variable name="q_count" select="count($questions)"/>
        <xsl:variable name="q_count_third" select="ceiling($q_count div 3)"/>

        <!--        HeaderRowCount="0" FooterRowCount="0" BodyRowCount="1"
					ColumnCount="3" AppliedTableStyle="TableStyle/$ID/[Basic Table]"
					TableDirection="LeftToRightDirection"-->

        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/$ID/[No paragraph style]">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                <Table Self="t{generate-id()}" HeaderRowCount="0" FooterRowCount="0"
                    BodyRowCount="1" ColumnCount="3"
                    AppliedTableStyle="TableStyle/$ID/[No table style]"
                    TableDirection="LeftToRightDirection">
                    <Row Self="t{generate-id()}row0" Name="0" MinimumHeight="3" AutoGrow="true"/>
                    <Column Self="t{generate-id()}Column0" Name="0" SingleColumnWidth="132"/>
                    <Column Self="t{generate-id()}Column1" Name="1" SingleColumnWidth="132"/>
                    <Column Self="t{generate-id()}Column2" Name="2" SingleColumnWidth="132"/>
                    <Cell Self="t{generate-id()}cell0" Name="0:0" RowSpan="1" ColumnSpan="1"
                        AppliedCellStyle="CellStyle/MN_body" AppliedCellStylePriority="0">
                        <xsl:apply-templates select="$questions[position() &lt;= $q_count_third]"
                            mode="letter_key"/>
                    </Cell>
                    <Cell Self="t{generate-id()}cell1" Name="1:0" RowSpan="1" ColumnSpan="1"
                        AppliedCellStyle="CellStyle/MN_body" AppliedCellStylePriority="0">
                        <xsl:apply-templates
                            select="$questions[position() &gt; $q_count_third and position() &lt;= ($q_count_third * 2)]"
                            mode="letter_key"/>
                    </Cell>
                    <Cell Self="t{generate-id()}cell2" Name="2:0" RowSpan="1" ColumnSpan="1"
                        AppliedCellStyle="CellStyle/MN_body" AppliedCellStylePriority="0">
                        <xsl:apply-templates
                            select="$questions[position() &gt; ($q_count_third * 2)]"
                            mode="letter_key"/>
                    </Cell>

                </Table>
            </CharacterStyleRange>
            <Br/>
        </ParagraphStyleRange>
        <!--        Commenting out conditional processing for letter keys-->
        <!--        <xsl:choose>
            <xsl:when test="ancestor::*[@outputclass='letter_key']">
                <xsl:apply-templates mode="letter_key"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="answer"/>
            </xsl:otherwise>
        </xsl:choose>-->

    </xsl:template>

    <!--SP The following elements are being discarded in answer processing-->

    <xsl:template
        match="lcAnswerContent | lcAnswerContent2 | lcQuestion2 | lcFeedbackCorrect2 | lcIntro"
        mode="answer"/>


    <!--        <xsl:template
        match="lcAnswerContent | lcAnswerContent2 | lcQuestion2 | lcFeedbackCorrect2 | lcIntro"
        mode="letter_key"/>-->

    <xsl:template match="lcCorrectResponse2" mode="letter_key">
        <xsl:variable name="answercount">
            <xsl:number
                value="count(ancestor::*[contains(@class, ' kpe-question/kpe-question ')][1]/preceding-sibling::*[contains(@class, ' kpe-question/kpe-question ')]) + 1"
                format="1"/>
        </xsl:variable>
        <xsl:variable name="answer">
            <xsl:number value="count(../preceding-sibling::*) + 1" format="a"/>
            <xsl:text> </xsl:text>
        </xsl:variable>

        <xsl:variable name="ditaname">
            <xsl:choose>
                <xsl:when test="$answercount = '1'">
                    <xsl:text>answer1</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>answer</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/QnA_AnsTable">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                <Content>
                    <xsl:value-of select="concat($answercount, '. ', $answer)"/>
                </Content>
            </CharacterStyleRange>
            <Br/>
        </ParagraphStyleRange>

    </xsl:template>

    <!-- [SPJLC] This template outputs the lcFeedbackCorrect2 element associated with Single Select
    and Matching questions -->
    <xsl:template match="lcCorrectResponse2 | lcMatchTable2" mode="rationale_key">
        <xsl:variable name="answercount">
            <xsl:number
                value="count(ancestor::*[contains(@class, ' kpe-question/kpe-question ')][1]/preceding-sibling::*[contains(@class, ' kpe-question/kpe-question ')]) + 1"
                format="1"/>
        </xsl:variable>

        <!-- If we're in a Matching question, do not calculate an answer -->
        <xsl:variable name="answer">
            <xsl:choose>
                <xsl:when test=".[contains(@class, ' learning2-d/lcMatchTable2 ')]"/>
                <xsl:otherwise>
                    <xsl:number value="count(../preceding-sibling::*) + 1" format="a"/>
                    <xsl:text> </xsl:text>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:variable>

        <xsl:variable name="ditaname">
            <xsl:choose>
                <xsl:when test="$answercount = '1'">
                    <xsl:text>answer1</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>answer</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- PSB NOTES: Deleted this and it stopped duplicating MC rationale, but also stopped putting in answer letter       -->
        <xsl:apply-templates select="following::lcFeedbackCorrect2[1]" mode="rationale_key">
            <xsl:with-param name="ditaname" select="$ditaname"/>
            <xsl:with-param name="answer" select="$answer"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="lcCorrectResponse2" mode="answer">
        <xsl:variable name="answercount">
            <xsl:number
                value="count(ancestor::*[contains(@class, ' kpe-question/kpe-question ')][1]/preceding-sibling::*[contains(@class, ' kpe-question/kpe-question ')]) + 1"
                format="1"/>
        </xsl:variable>
        <xsl:variable name="answer">
            <xsl:number value="count(../preceding-sibling::*) + 1" format="a"/>
            <xsl:text> </xsl:text>
        </xsl:variable>

        <xsl:variable name="ditaname">
            <xsl:choose>
                <xsl:when test="$answercount = '1'">
                    <xsl:text>answer1</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>answer</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="../../../lcFeedbackCorrect2/p">
                <xsl:apply-templates select="../../../lcFeedbackCorrect2/p" mode="answerkey">
                    <xsl:with-param name="ditaname" select="$ditaname"/>
                    <xsl:with-param name="answer" select="$answer"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="../../../lcFeedbackCorrect2" mode="answerkey">
                    <xsl:with-param name="ditaname" select="$ditaname"/>
                    <xsl:with-param name="answer" select="$answer"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
            <xsl:when test="../lcOpenAnswer2/p">
                <xsl:apply-templates select="../lcOpenAnswer2/p" mode="answerkey">
                    <xsl:with-param name="ditaname" select="$ditaname"/>
                    <xsl:with-param name="answer" select="$answer"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="../lcOpenAnswer2" mode="answerkey">
                    <xsl:with-param name="ditaname" select="$ditaname"/>
                    <xsl:with-param name="answer" select="$answer"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="p[1]" mode="answer" priority="50">
        <xsl:param name="ditaname"/>
        <xsl:param name="prefix"/>
        <xsl:param name="answer"/>

        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="$ditaname"/>
            <xsl:with-param name="prefix" select="concat($prefix, $tab)"/>
            <xsl:with-param name="answer" select="$answer"/>
        </xsl:call-template>

    </xsl:template>


    <xsl:template match="p" mode="answer">
        <xsl:param name="ditaname"/>
        <xsl:param name="prefix"/>
        <xsl:param name="answer"/>

        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="$ditaname"/>
            <xsl:with-param name="prefix" select="concat($tab, $tab)"/>
            <xsl:with-param name="answer" select="$answer"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="lcObjectivesStem" priority="50">

        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'lcobjectivesstem'"/>
            <xsl:with-param name="prefix" select="concat('Learning Objectives', $tab)"/>
            <!--            <xsl:with-param name="suffix" select="':'"/>-->
            <!-- PSB commented out : added to learning objective stem 4/23/15 -->
        </xsl:call-template>
    </xsl:template>

    <!-- SP processing to insert semicolons after learning objectives. Last objective is in the Key Terms topic -->
    <!-- SPJLC Commenting out- 2015 spec calls for this to be removed -->

    <xsl:template match="lcObjective" priority="50">
        <!--        <xsl:variable name="suffix">
            <xsl:choose>
                <xsl:when test="count(following-sibling::lcObjective) = 0">
                    <xsl:text>; and </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>;</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>-->
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicli'"/>
            <!--            <xsl:with-param name="suffix-last" select="$suffix"/>-->
        </xsl:call-template>
    </xsl:template>

    <xsl:template
        match="
            lcObjective/*[contains(@class, ' hi-d/b ')] |
            section[@outputclass = 'no_bold_on_term']/p/*[contains(@class, ' hi-d/b ')]"
        priority="25">
        <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/HEAD_c">
            <xsl:apply-templates mode="cstyleset">
                <xsl:with-param name="cstyle" select="'b'"/>
            </xsl:apply-templates>
        </CharacterStyleRange>

    </xsl:template>

    <xsl:template match="kpe-overview/title[contains(text(), 'Key Terms')]" priority="50"/>
    <xsl:template match="kpe-overview/title[contains(text(), 'Learning Objectives')]" priority="50"/>
    <xsl:template match="kpe-assessmentOverview/title[contains(text(), 'Study Guide')]"
        priority="51"/>

    <xsl:template match="section[@outputclass = 'no_bold_on_term']/p" priority="50">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicli'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="callout/p" priority="50">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'figbody'"/>
        </xsl:call-template>
    </xsl:template>

  

    <!-- SP process key terms into three columns -->

    <xsl:template match="section[@outputclass = 'no_bold_on_term']/sl" priority="50">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/KeyTerms_BoxInline">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                <TextFrame Self="self{generate-id()}" ParentStory="{generate-id()}"
                    PreviousTextFrame="n" NextTextFrame="n" ContentType="TextType"
                    ParentInterfaceChangeCount="" TargetInterfaceChangeCount=""
                    LastUpdatedInterfaceChangeCount="" OverriddenPageItemProps=""
                    HorizontalLayoutConstraints="FlexibleDimension FixedDimension FlexibleDimension"
                    VerticalLayoutConstraints="FlexibleDimension FixedDimension FlexibleDimension"
                    GradientFillStart="0 0" GradientFillLength="0" GradientFillAngle="0"
                    GradientStrokeStart="0 0" GradientStrokeLength="0" GradientStrokeAngle="0"
                    Locked="false" LocalDisplaySetting="Default" GradientFillHiliteLength="0"
                    GradientFillHiliteAngle="0" GradientStrokeHiliteLength="0"
                    GradientStrokeHiliteAngle="0"
                    AppliedObjectStyle="ObjectStyle/$ID/[Normal Text Frame]" Visible="true"
                    Name="$ID/" ItemTransform="1 0 0 1 199.5 43.36744384765598">
                    <Properties>
                        <PathGeometry>
                            <GeometryPathType PathOpen="false">
                                <PathPointArray>
                                    <PathPointType Anchor="-199.5 -65" LeftDirection="-199.5 -65"
                                        RightDirection="-199.5 -65"/>
                                    <PathPointType Anchor="-199.5 -43.36744384765598"
                                        LeftDirection="-199.5 -43.36744384765598"
                                        RightDirection="-199.5 -43.36744384765598"/>
                                    <PathPointType Anchor="142.49999999999997 -43.36744384765598"
                                        LeftDirection="142.49999999999997 -43.36744384765598"
                                        RightDirection="142.49999999999997 -43.36744384765598"/>
                                    <PathPointType Anchor="142.49999999999997 -65"
                                        LeftDirection="142.49999999999997 -65"
                                        RightDirection="142.49999999999997 -65"/>
                                </PathPointArray>
                            </GeometryPathType>
                        </PathGeometry>
                    </Properties>
                    <TextFramePreference TextColumnCount="3" TextColumnFixedWidth="106"
                        TextColumnMaxWidth="0" AutoSizingType="On"
                        AutoSizingReferencePoint="CenterPoint" UseMinimumHeightForAutoSizing="false"
                        MinimumHeightForAutoSizing="0" UseMinimumWidthForAutoSizing="false"
                        MinimumWidthForAutoSizing="0" UseNoLineBreaksForAutoSizing="false"/>
                    <AnchoredObjectSetting AnchoredPosition="InlinePosition" SpineRelative="false"
                        LockPosition="false" PinPosition="true" AnchorPoint="BottomRightAnchor"
                        HorizontalAlignment="LeftAlign" HorizontalReferencePoint="TextFrame"
                        VerticalAlignment="BottomAlign" VerticalReferencePoint="LineBaseline"
                        AnchorXoffset="0" AnchorYoffset="0" AnchorSpaceAbove="0"/>
                    <TextWrapPreference Inverse="false" ApplyToMasterPageOnly="false"
                        TextWrapSide="BothSides" TextWrapMode="None">
                        <Properties>
                            <TextWrapOffset Top="0" Left="0" Bottom="0" Right="0"/>
                        </Properties>
                    </TextWrapPreference>
                    <ObjectExportOption AltTextSourceType="SourceXMLStructure"
                        ActualTextSourceType="SourceXMLStructure" CustomAltText="$ID/"
                        CustomActualText="$ID/" ApplyTagType="TagFromStructure"
                        CustomImageConversion="false" ImageConversionType="JPEG"
                        CustomImageSizeOption="SizeRelativeToPageWidth"
                        ImageExportResolution="Ppi300" GIFOptionsPalette="AdaptivePalette"
                        GIFOptionsInterlaced="true" JPEGOptionsQuality="High"
                        JPEGOptionsFormat="BaselineEncoding" ImageAlignment="AlignLeft"
                        ImageSpaceBefore="0" ImageSpaceAfter="0" UseImagePageBreak="false"
                        ImagePageBreak="PageBreakBefore" CustomImageAlignment="false"
                        SpaceUnit="CssPixel" CustomLayout="false"
                        CustomLayoutType="AlignmentAndSpacing">
                        <Properties>
                            <AltMetadataProperty NamespacePrefix="$ID/" PropertyPath="$ID/"/>
                            <ActualMetadataProperty NamespacePrefix="$ID/" PropertyPath="$ID/"/>
                        </Properties>
                    </ObjectExportOption>
                </TextFrame>
                <Br/>
            </CharacterStyleRange>
        </ParagraphStyleRange>
    </xsl:template>

    <!-- SP process callouts -->

    <xsl:template match="callout/label" priority="14">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'fighead'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="callout/ul/li" priority="14">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'figli'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="callout" priority="50">
        <xsl:call-template name="anchor_callout"/>
    </xsl:template>

    <xsl:template name="anchor_callout">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/figure_head">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                <TextFrame Self="self{generate-id()}" ParentStory="{generate-id()}"
                    PreviousTextFrame="n" NextTextFrame="n" ContentType="TextType"
                    ParentInterfaceChangeCount="" TargetInterfaceChangeCount=""
                    LastUpdatedInterfaceChangeCount="" OverriddenPageItemProps=""
                    HorizontalLayoutConstraints="FlexibleDimension FixedDimension FlexibleDimension"
                    VerticalLayoutConstraints="FlexibleDimension FixedDimension FlexibleDimension"
                    FillColor="Swatch/None" FillTint="-1" CornerRadius="12" StrokeWeight="0"
                    MiterLimit="4" EndCap="ButtEndCap" EndJoin="MiterEndJoin"
                    StrokeType="StrokeStyle/$ID/Solid" LeftLineEnd="None" RightLineEnd="None"
                    StrokeColor="Swatch/None" StrokeTint="-1" GradientFillStart="0 0"
                    GradientFillLength="0" GradientFillAngle="0" GradientStrokeStart="0 0"
                    GradientStrokeLength="0" GradientStrokeAngle="0" GapColor="Swatch/None"
                    GapTint="-1" StrokeAlignment="CenterAlignment" Locked="false"
                    LocalDisplaySetting="Default" GradientFillHiliteLength="0"
                    GradientFillHiliteAngle="0" GradientStrokeHiliteLength="0"
                    GradientStrokeHiliteAngle="0" AppliedObjectStyle="ObjectStyle/MN_box"
                    CornerOption="None" Visible="true" Name="$ID/" TopLeftCornerOption="None"
                    TopRightCornerOption="None" BottomLeftCornerOption="None"
                    BottomRightCornerOption="None" TopLeftCornerRadius="12"
                    TopRightCornerRadius="12" BottomLeftCornerRadius="12"
                    BottomRightCornerRadius="12" ItemTransform="1 0 0 1 66 -93.33289001464846">
                    <Properties>
                        <PathGeometry>
                            <GeometryPathType PathOpen="false">
                                <PathPointArray>
                                    <PathPointType Anchor="-66 -40" LeftDirection="-66 -40"
                                        RightDirection="-66 -40"/>
                                    <PathPointType Anchor="-66 93.33289001464846"
                                        LeftDirection="-66 93.33289001464846"
                                        RightDirection="-66 93.33289001464846"/>
                                    <PathPointType Anchor="66 93.33289001464846"
                                        LeftDirection="66 93.33289001464846"
                                        RightDirection="66 93.33289001464846"/>
                                    <PathPointType Anchor="66 -40" LeftDirection="66 -40"
                                        RightDirection="66 -40"/>
                                </PathPointArray>
                            </GeometryPathType>
                        </PathGeometry>
                    </Properties>
                    <TextFramePreference TextColumnCount="1" TextColumnGutter="12"
                        TextColumnFixedWidth="132" UseFixedColumnWidth="false"
                        FirstBaselineOffset="AscentOffset" MinimumFirstBaselineOffset="0"
                        VerticalJustification="TopAlign" VerticalThreshold="0" IgnoreWrap="false"
                        UseFlexibleColumnWidth="false" TextColumnMaxWidth="0" AutoSizingType="Off"
                        AutoSizingReferencePoint="CenterPoint" UseMinimumHeightForAutoSizing="false"
                        MinimumHeightForAutoSizing="0" UseMinimumWidthForAutoSizing="false"
                        MinimumWidthForAutoSizing="0" UseNoLineBreaksForAutoSizing="false"
                        VerticalBalanceColumns="false">
                        <Properties>
                            <InsetSpacing type="list">
                                <ListItem type="unit">0</ListItem>
                                <ListItem type="unit">0</ListItem>
                                <ListItem type="unit">0</ListItem>
                                <ListItem type="unit">0</ListItem>
                            </InsetSpacing>
                        </Properties>
                    </TextFramePreference>
                    <AnchoredObjectSetting AnchorXoffset="0.25" AnchorYoffset="0.2584162962434675"/>
                    <BaselineFrameGridOption UseCustomBaselineFrameGrid="false"
                        StartingOffsetForBaselineFrameGrid="0"
                        BaselineFrameGridRelativeOption="TopOfInset" BaselineFrameGridIncrement="12">
                        <Properties>
                            <BaselineFrameGridColor type="enumeration"
                                >LightBlue</BaselineFrameGridColor>
                        </Properties>
                    </BaselineFrameGridOption>
                    <TextWrapPreference Inverse="false" ApplyToMasterPageOnly="false"
                        TextWrapSide="BothSides" TextWrapMode="None">
                        <Properties>
                            <TextWrapOffset Top="0" Left="0" Bottom="0" Right="0"/>
                        </Properties>
                    </TextWrapPreference>
                    <ObjectExportOption AltTextSourceType="SourceXMLStructure"
                        ActualTextSourceType="SourceXMLStructure" CustomAltText="$ID/"
                        CustomActualText="$ID/" ApplyTagType="TagFromStructure"
                        CustomImageConversion="false" ImageConversionType="JPEG"
                        CustomImageSizeOption="SizeRelativeToPageWidth"
                        ImageExportResolution="Ppi300" GIFOptionsPalette="AdaptivePalette"
                        GIFOptionsInterlaced="true" JPEGOptionsQuality="High"
                        JPEGOptionsFormat="BaselineEncoding" ImageAlignment="AlignLeft"
                        ImageSpaceBefore="0" ImageSpaceAfter="0" UseImagePageBreak="false"
                        ImagePageBreak="PageBreakBefore" CustomImageAlignment="false"
                        SpaceUnit="CssPixel" CustomLayout="false"
                        CustomLayoutType="AlignmentAndSpacing">
                        <Properties>
                            <AltMetadataProperty NamespacePrefix="$ID/" PropertyPath="$ID/"/>
                            <ActualMetadataProperty NamespacePrefix="$ID/" PropertyPath="$ID/"/>
                        </Properties>
                    </ObjectExportOption>
                </TextFrame>
                <Properties>
                    <PathGeometry>
                        <GeometryPathType PathOpen="false">
                            <PathPointArray>
                                <PathPointType Anchor="-66 -40" LeftDirection="-66 -40"
                                    RightDirection="-66 -40"/>
                                <PathPointType Anchor="-66 93.33289001464846"
                                    LeftDirection="-66 93.33289001464846"
                                    RightDirection="-66 93.33289001464846"/>
                                <PathPointType Anchor="66 93.33289001464846"
                                    LeftDirection="66 93.33289001464846"
                                    RightDirection="66 93.33289001464846"/>
                                <PathPointType Anchor="66 -40" LeftDirection="66 -40"
                                    RightDirection="66 -40"/>
                            </PathPointArray>
                        </GeometryPathType>
                    </PathGeometry>
                </Properties>
                <TextFramePreference TextColumnCount="1" TextColumnGutter="12"
                    TextColumnFixedWidth="132" UseFixedColumnWidth="false"
                    FirstBaselineOffset="AscentOffset" MinimumFirstBaselineOffset="0"
                    VerticalJustification="TopAlign" VerticalThreshold="0" IgnoreWrap="false"
                    UseFlexibleColumnWidth="false" TextColumnMaxWidth="0" AutoSizingType="Off"
                    AutoSizingReferencePoint="CenterPoint" UseMinimumHeightForAutoSizing="false"
                    MinimumHeightForAutoSizing="0" UseMinimumWidthForAutoSizing="false"
                    MinimumWidthForAutoSizing="0" UseNoLineBreaksForAutoSizing="false"
                    VerticalBalanceColumns="false">
                    <Properties>
                        <InsetSpacing type="list">
                            <ListItem type="unit">0</ListItem>
                            <ListItem type="unit">0</ListItem>
                            <ListItem type="unit">0</ListItem>
                            <ListItem type="unit">0</ListItem>
                        </InsetSpacing>
                    </Properties>
                </TextFramePreference>
                <AnchoredObjectSetting AnchorXoffset="0.25" AnchorYoffset="0.2584162962434675"/>
                <BaselineFrameGridOption UseCustomBaselineFrameGrid="false"
                    StartingOffsetForBaselineFrameGrid="0"
                    BaselineFrameGridRelativeOption="TopOfInset" BaselineFrameGridIncrement="12">
                    <Properties>
                        <BaselineFrameGridColor type="enumeration"
                            >LightBlue</BaselineFrameGridColor>
                    </Properties>
                </BaselineFrameGridOption>
                <TextWrapPreference Inverse="false" ApplyToMasterPageOnly="false"
                    TextWrapSide="BothSides" TextWrapMode="None">
                    <Properties>
                        <TextWrapOffset Top="0" Left="0" Bottom="0" Right="0"/>
                    </Properties>
                </TextWrapPreference>
                <ObjectExportOption AltTextSourceType="SourceXMLStructure"
                    ActualTextSourceType="SourceXMLStructure" CustomAltText="$ID/"
                    CustomActualText="$ID/" ApplyTagType="TagFromStructure"
                    CustomImageConversion="false" ImageConversionType="JPEG"
                    CustomImageSizeOption="SizeRelativeToPageWidth" ImageExportResolution="Ppi300"
                    GIFOptionsPalette="AdaptivePalette" GIFOptionsInterlaced="true"
                    JPEGOptionsQuality="High" JPEGOptionsFormat="BaselineEncoding"
                    ImageAlignment="AlignLeft" ImageSpaceBefore="0" ImageSpaceAfter="0"
                    UseImagePageBreak="false" ImagePageBreak="PageBreakBefore"
                    CustomImageAlignment="false" SpaceUnit="CssPixel" CustomLayout="false"
                    CustomLayoutType="AlignmentAndSpacing">
                    <Properties>
                        <AltMetadataProperty NamespacePrefix="$ID/" PropertyPath="$ID/"/>
                        <ActualMetadataProperty NamespacePrefix="$ID/" PropertyPath="$ID/"/>
                    </Properties>
                </ObjectExportOption>
                <Br/>
            </CharacterStyleRange>

        </ParagraphStyleRange>

    </xsl:template>

    <!-- SPJLC Split dl and dlentry processing to count number of sibling dls for proper paragraph style assignment -->

    <xsl:template match="dl">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="dlentry">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="dd" priority="50">
        <xsl:choose>
            <xsl:when test="child::*[contains(@class, ' kpe-common-d/callout ')]">
                <xsl:for-each select="callout">
                    <xsl:call-template name="anchor_callout"/>
                </xsl:for-each>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'topicp'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'topicp'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="dl/dlentry/dt" priority="50">
        <xsl:choose>
            <xsl:when test="count(ancestor::*[contains(@class, ' topic/dl ')]) &gt; 1">
                <xsl:call-template name="processpara">
                    <!-- Use HEAD_d -->
                    <xsl:with-param name="ditaname" select="'topictitle'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <!-- Use HEAD_c -->
                    <xsl:with-param name="ditaname" select="'termtitle'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template match="dl/dlentry/dd/p" priority="50">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicp'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template
        match="*[contains(@class, ' concept/concept ') or contains(@class, ' kpe-summary/kpe-summary ')]/*[contains(@class, ' topic/title ')]"
        priority="4">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'chaptertitle'"/>
        </xsl:call-template>
    </xsl:template>

    <!-- JLCSP Commenting out unitnum processing in order to use navtitles for unit titles if available -->

    <xsl:template match="kpe-concept[@outputclass = 'topic_intro']/title" priority="14">
        <xsl:variable name="id">
            <xsl:value-of select="parent::*/@id"/>
        </xsl:variable>
        <xsl:variable name="map" select="//opentopic:map"/>
        <xsl:variable name="maploc" select="$map//*[$id = @id]" as="element()*"/>
        <xsl:variable name="topic_navtitle"
            select="$maploc/topicmeta/*[contains(@class, ' topic/navtitle ')]"/>
        <!--        <xsl:variable name="unitnum">
            <xsl:choose>
                <xsl:when
                    test="not($maploc/ancestor-or-self::*[contains(@class, ' bookmap/frontmatter ') or contains(@class, ' bookmap/backmatter ')])">
                    <xsl:value-of
                        select="concat('Unit ', 
                count($maploc/preceding-sibling::*[contains(@class, ' bookmap/chapter ') and not(ancestor-or-self::*[contains(@class, ' bookmap/frontmatter ') or contains(@class, ' bookmap/backmatter ')])]) + 1, ' ')"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <!-\-Returns nothing-\->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>-->
        <xsl:choose>
            <xsl:when test="count($topic_navtitle) &gt; 0">
                <xsl:for-each select="$topic_navtitle">
                    <xsl:call-template name="processpara">
                        <xsl:with-param name="ditaname" select="'unittitle'"/>
                        <!--            <xsl:with-param name="prefix" select="$unitnum"/>-->
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'unittitle'"/>
                    <!--            <xsl:with-param name="prefix" select="$unitnum"/>-->
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>









    <!-- PSB: Add in mapping topic titles that are LOS to learning_objective with outputclass="los"-->
    <xsl:template match="kpe-concept/title[@outputclass = 'los']" priority="100">
        <xsl:variable name="id">
            <xsl:value-of select="parent::*/@id"/>
        </xsl:variable>
        <xsl:variable name="map" select="//opentopic:map"/>
        <xsl:variable name="maploc" select="$map//*[$id = @id]" as="element()*"/>
        <xsl:variable name="topic_navtitle"
            select="$maploc/topicmeta/*[contains(@class, ' topic/navtitle ')]"/>


        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topictitlelos'"/>
        </xsl:call-template>
    </xsl:template>


    <!--PSB: Add in ability to match <p outputclass="los"> to learning_objective-->
    <xsl:template match="p[@outputclass = 'los']" priority="101">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topictitlelos'"/>
        </xsl:call-template>
    </xsl:template>


    <!-- PSB: Add in mapping topic titles that are Key Concept LOS to KC_LO with outputclass="kc"-->
    <xsl:template match="kpe-summary/title[@outputclass = 'kc']" priority="100">
        <xsl:variable name="id">
            <xsl:value-of select="parent::*/@id"/>
        </xsl:variable>
        <xsl:variable name="map" select="//opentopic:map"/>
        <xsl:variable name="maploc" select="$map//*[$id = @id]" as="element()*"/>
        <xsl:variable name="topic_navtitle"
            select="$maploc/topicmeta/*[contains(@class, ' topic/navtitle ')]"/>


        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topictitlekc'"/>
        </xsl:call-template>
    </xsl:template>



    <!-- PSB: Add in mapping topic titles to B-heads with outputclass="b_head"-->
    <xsl:template match="kpe-concept/title[@outputclass = 'b_head']" priority="100">
        <xsl:variable name="id">
            <xsl:value-of select="parent::*/@id"/>
        </xsl:variable>
        <xsl:variable name="map" select="//opentopic:map"/>
        <xsl:variable name="maploc" select="$map//*[$id = @id]" as="element()*"/>
        <xsl:variable name="topic_navtitle"
            select="$maploc/topicmeta/*[contains(@class, ' topic/navtitle ')]"/>


        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'sectiontitle'"/>
        </xsl:call-template>
    </xsl:template>

    <!-- PSB: Add in mapping topic titles to C-heads with outputclass="c_head"-->
    <xsl:template match="kpe-concept/title[@outputclass = 'c_head']" priority="100">
        <xsl:variable name="id">
            <xsl:value-of select="parent::*/@id"/>
        </xsl:variable>
        <xsl:variable name="map" select="//opentopic:map"/>
        <xsl:variable name="maploc" select="$map//*[$id = @id]" as="element()*"/>
        <xsl:variable name="topic_navtitle"
            select="$maploc/topicmeta/*[contains(@class, ' topic/navtitle ')]"/>


        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'termtitle'"/>
        </xsl:call-template>
    </xsl:template>

    <!-- PSB: Add in mapping topic titles to D-heads with outputclass="d_head"-->
    <xsl:template match="kpe-concept/title[@outputclass = 'd_head']" priority="100">
        <xsl:variable name="id">
            <xsl:value-of select="parent::*/@id"/>
        </xsl:variable>
        <xsl:variable name="map" select="//opentopic:map"/>
        <xsl:variable name="maploc" select="$map//*[$id = @id]" as="element()*"/>
        <xsl:variable name="topic_navtitle"
            select="$maploc/topicmeta/*[contains(@class, ' topic/navtitle ')]"/>


        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topictitle'"/>
        </xsl:call-template>
    </xsl:template>









    <xsl:template match="kpe-assessmentOverview[@outputclass = 'topic_intro']/title" priority="101">
        <xsl:variable name="id">
            <xsl:value-of select="parent::*/@id"/>
        </xsl:variable>
        <xsl:variable name="map" select="//opentopic:map"/>
        <xsl:variable name="maploc" select="$map//*[$id = @id]" as="element()*"/>
        <xsl:variable name="topic_navtitle"
            select="$maploc/topicmeta/*[contains(@class, ' topic/navtitle ')]"/>
        <!--        <xsl:variable name="unitnum">
            <xsl:choose>
                <xsl:when
                    test="not($maploc/ancestor-or-self::*[contains(@class, ' bookmap/frontmatter ') or contains(@class, ' bookmap/backmatter ')])">
                    <xsl:value-of
                        select="concat('Unit ', 
                count($maploc/preceding-sibling::*[contains(@class, ' bookmap/chapter ') and not(ancestor-or-self::*[contains(@class, ' bookmap/frontmatter ') or contains(@class, ' bookmap/backmatter ')])]) + 1, ' ')"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <!-\-Returns nothing-\->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>-->
        <xsl:choose>
            <xsl:when test="count($topic_navtitle) &gt; 0">
                <xsl:for-each select="$topic_navtitle">
                    <xsl:call-template name="processpara">
                        <xsl:with-param name="ditaname" select="'quiztitle'"/>
                        <!--            <xsl:with-param name="prefix" select="$unitnum"/>-->
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'quiztitle'"/>
                    <!--            <xsl:with-param name="prefix" select="$unitnum"/>-->
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

        <!--        SPJLC Commenting out to correctly fetch navtitle for unit quizzes-->
        <!--        <xsl:variable name="prefix">
            <xsl:text>Unit </xsl:text>
            <xsl:value-of
                select="count(preceding::kpe-assessmentOverview[@outputclass = 'topic_intro']/title) + 1"/>
            <xsl:text> </xsl:text>
        </xsl:variable>
        <xsl:call-template name="processpara">
            <xsl:with-param name="prefix" select="$prefix"/>
            <xsl:with-param name="ditaname" select="'quiztitle'"/>
        </xsl:call-template>-->
    </xsl:template>

    <!-- SP   Handle proper processing of glossdef elements-->
    <xsl:template match="glossdef" priority="50">
        <xsl:variable name="label">
            <xsl:value-of select="preceding-sibling::glossterm[1]"/>
            <!-- SP em space -->
            <xsl:text> </xsl:text>
        </xsl:variable>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'glossdef'"/>
            <xsl:with-param name="prefix" select="$label"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="kpe-glossEntry" priority="50">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="glossterm" priority="50"/>

    <xsl:template match="kpe-assessmentOverview/title" priority="50">
        <xsl:variable name="ditaname">
            <xsl:text>
                chaptertitle
            </xsl:text>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="title = 'True or False'">
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname"> chaptertitle </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="title = 'Multiple Choice'">
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname"> chaptertitle </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="kpe-assessmentOverview/title" priority="51">
        <xsl:param name="ditaname"/>

        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname">
                <xsl:text>chaptertitle</xsl:text>
            </xsl:with-param>
        </xsl:call-template>

    </xsl:template>

    <!--<xsl:template match="kpe-assessmentOverview/title['Study Guide']" priority="51"/>-->

    <xsl:template match="kpe-question/title" priority="50">
        <xsl:param name="ditaname"/>

        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname">
                <xsl:text>chaptertitle</xsl:text>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>





    <xsl:include href="dita2idml.xsl"/>

</xsl:stylesheet>
