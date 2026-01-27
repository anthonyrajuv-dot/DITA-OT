<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:m="http://www.w3.org/1998/Math/MathML" xmlns:functx="http://www.functx.com"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    exclude-result-prefixes="m xs functx ditaarch" version="2.0">
    <xsl:import href="functx-1.0.xsl"/>
    <xsl:param name="OUT_DIR"/>
    <xsl:strip-space elements="*"/>
    <xsl:variable name="newline" select="'&#10;   '"/>

    <!-- #### NEW TOPIC ###################################################################### -->
    <xsl:template match="/" mode="new_topic">
        <xsl:param name="unit"/>
        <xsl:param name="task_category"/>
        <xsl:param name="topic_id"/>
        <xsl:param name="navtitle"/>
        
        <xsl:apply-templates select="*[contains(@class,' topic/topic ')]" mode="new_topic">
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="task_category" select="$task_category"/>
            <xsl:with-param name="topic_id" select="$topic_id"/>
            <xsl:with-param name="navtitle" select="$navtitle"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/topic ')]" mode="new_topic">
        <xsl:param name="unit"/>
        <xsl:param name="task_category"/>
        <xsl:param name="topic_id"/>
        <xsl:param name="navtitle"/>
        
        <xsl:variable name="category" select="descendant::lmsCategory[1]/@value"/>
        <xsl:variable name="category_init_cap"
            select="concat(upper-case(substring($category,1,1)),lower-case(substring($category,2)))"/>

        <topic>
            <xsl:attribute name="id">
                <xsl:value-of select="$topic_id"/>
                <!--                <xsl:value-of select="replace(@id,'_task_','_topic_')"/>-->
            </xsl:attribute>
            <xsl:value-of select="$newline"/>
            <xsl:comment>Source file (new_topic 2): <xsl:value-of select="@xtrf"/>.</xsl:comment>
            <xsl:value-of select="$newline"/>


            <!--            <xsl:choose>
                <xsl:when test="contains('activity reading',@task_category)">
                    <!-\- This is only for the current PDC topic set. -\->
                    <title>Task Overview</title>                    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="new_tt_common"/>
                </xsl:otherwise>
            </xsl:choose>-->

            <title>
                <xsl:choose>
                    <xsl:when test="not(empty($navtitle))">
                        <xsl:apply-templates select="$navtitle" mode="identity"/>
                    </xsl:when>
                    <xsl:when
                        test="*[contains(@class,' topic/titlealts ')]/*[contains(@class,' topic/navtitle ')]">
                        <xsl:apply-templates
                            select="*[contains(@class,' topic/titlealts ')]/*[contains(@class,' topic/navtitle ')]"
                        />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="*[contains(@class,' topic/title ')]"/>
                    </xsl:otherwise>
                </xsl:choose>
            </title>

            <prolog>
                <metadata>
                    <xsl:variable name="lmsCategory" select="descendant::lmsCategory[1]/@value"/>
                    <xsl:variable name="completion" select="descendant::completion[1]/@value"/>
                    <category>
                        <xsl:choose>
                            <xsl:when test="$lmsCategory = 'activity' and $completion = 'manual'">
                                <xsl:text>reading</xsl:text>
                            </xsl:when>
                            <xsl:when test="$lmsCategory = 'reading' and $completion = 'auto'">
                                <xsl:text>default</xsl:text>
                            </xsl:when>
                            <xsl:when test="$task_category = 'kpe-overview'">
                                <xsl:text>default</xsl:text>
                            </xsl:when>
                            <xsl:when test="$lmsCategory != ''">
                                <xsl:value-of select="$lmsCategory"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>default</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </category>

                    <!-- [SP] 2014-06-16: Duration is no longer shown in topics. -->
                    <!--                    <othermeta name="duration">
                        <xsl:attribute name="content">
                            <xsl:value-of select="descendant::duration[1]/@value"/>
                        </xsl:attribute>
                    </othermeta>-->
                    <xsl:apply-templates select="descendant::metadata" mode="get_topic_metadata"/>
                </metadata>
            </prolog>
            <!-- Karissa says no! -->
            <!--            <shortdesc>
                <xsl:value-of select="concat($category_init_cap,' ',$unit)"/>
            </shortdesc>
-->
            <body>
                <xsl:apply-templates select="*[contains(@class,' topic/body ')]/node()"
                    mode="identity">
                    <xsl:with-param name="type" select="'topic'"/>
                </xsl:apply-templates>
                <xsl:variable name="stream_data"
                    select="*[contains(@class,' topic/prolog ')]/*[contains(@class,' topic/metadata ')]/*[contains(@class,' topic/data') and @name = 'stream57presentation']"/>
                <xsl:if test="$stream_data/@value">
                    <data name="stream57presentation">
                        <xsl:attribute name="value">
                            <xsl:value-of select="$stream_data/@value"/>
                        </xsl:attribute>
                    </data>
                </xsl:if>
                <xsl:call-template name="check_footnotes"/>

            </body>
        </topic>
    </xsl:template>

    <xsl:template match="metadata" mode="get_topic_metadata">
        <xsl:apply-templates
            select="assessmentType | questionRandomize | duration | distractorRandomize"
            mode="get_metadata"/>
    </xsl:template>



    <!-- #### NEW TASK ###################################################################### -->
    <xsl:template match="/" mode="new_task">
        <xsl:param name="unit"/>
        <xsl:param name="topic_id"/>
        <xsl:param name="category_number"/>
        <xsl:param name="lesson_number"/>
        <xsl:param name="navtitle"/>
        
        <xsl:apply-templates select="*[contains(@class,' topic/topic ')]" mode="new_task">
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="topic_id" select="$topic_id"/>
            <xsl:with-param name="category_number" select="$category_number"/>
            <xsl:with-param name="lesson_number" select="$lesson_number"/>
            <xsl:with-param name="navtitle" select="$navtitle"/>
            
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/topic ')]" mode="new_task">
        <xsl:param name="unit"/>
        <xsl:param name="topic_id"/>
        <xsl:param name="category_number"/>
        <xsl:param name="lesson_number"/>
        <xsl:param name="navtitle"/>
        

        <xsl:variable name="unit_only">
            <xsl:choose>
                <xsl:when test="starts-with($unit,'C.')">
                    <xsl:value-of select="'C'"/>
                </xsl:when>
                <xsl:when test="starts-with($unit,'I.')">
                    <xsl:value-of select="'I'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after($unit,'.')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!--        <xsl:variable name="category" select="descendant::lmsCategory[1]/@value"/>
        <xsl:variable name="category_init_cap"
            select="concat(upper-case(substring($category,1,1)),lower-case(substring($category,2)))"/>-->
        <xsl:variable name="label">
            <xsl:call-template name="get_label">
                <xsl:with-param name="task_category"
                    select="descendant-or-self::lmsCategory[1]/@value"/>
            </xsl:call-template>
        </xsl:variable>

        <kaptask>
            <xsl:attribute name="id">
                <xsl:value-of select="$topic_id"/>
            </xsl:attribute>
            <xsl:value-of select="$newline"/>
            <xsl:comment>Source file (new_task): <xsl:value-of select="@xtrf"/>.</xsl:comment>
            <xsl:value-of select="$newline"/>
            
            <xsl:choose>
                <xsl:when test="not(empty($navtitle))">
                    <title>
                        <xsl:apply-templates select="$navtitle" mode="identity"/>
                    </title>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="*[contains(@class,' topic/title ')]"
                        mode="new_tt_common">
                        <xsl:with-param name="prefix"
                            select="concat($label,' ',$lesson_number,' &gt; ')"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
            <prolog>
                <metadata>
                    <othermeta name="duration">
                        <xsl:attribute name="content">
                            <xsl:choose>
                                <xsl:when test="descendant::duration[1]/@value">
                                    <xsl:value-of select="descendant::duration[1]/@value"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>00:00</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </othermeta>
                </metadata>
            </prolog>
            <shortdesc>
                <xsl:value-of select="concat($label,' ',$lesson_number)"/>
            </shortdesc>
            <body>
                <xsl:apply-templates select="*[contains(@class,' topic/body ')]/node()"
                    mode="identity">
                    <xsl:with-param name="type" select="'task'"/>
                </xsl:apply-templates>
                <xsl:call-template name="check_footnotes"/>

            </body>
        </kaptask>
    </xsl:template>

    <!-- #### NEW ASSESSMENT ###################################################################### -->
    <xsl:template match="/" mode="new_assessment">
        <xsl:param name="unit"/>
        <xsl:param name="topic_id"/>
        
        <xsl:apply-templates select="*[contains(@class,' topic/topic ')]" mode="new_assessment">
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="topic_id" select="$topic_id"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' topic/topic ')]" mode="new_assessment">
        <xsl:param name="topic_id"/>
        
        <assessmentItem xmlns="http://www.imsglobal.org/xsd/imsqti_v2p1"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.imsglobal.org/xsd/imsqti_v2p1 http://www.imsglobal.org/xsd/imsqti_v2p1.xsd"
            title="Question" timeDependent="false" adaptive="false">
            <xsl:attribute name="identifier">
                <xsl:value-of select="$topic_id"/>
                <!--                <xsl:value-of select="replace(@id,'_task_','_ques_')"/>-->
            </xsl:attribute>
            <xsl:value-of select="$newline"/>
            <xsl:comment>Source file (new_assessment): <xsl:value-of select="@xtrf"/>.</xsl:comment>
            <xsl:value-of select="$newline"/>
            <responseDeclaration identifier="Q" cardinality="single">
                <!-- Not sure that this is needed in this case. -->
                <!--                <correctResponse>
                    <value>
                        <xsl:variable name="correct_index"
                            select="count(lcAnswerOptionGroup2/lcAnswerOption2[lcCorrectResponse2]/preceding-sibling::lcAnswerOption2) + 1"/>
                        <xsl:number value="$correct_index" format="A"/>
                    </value>
                    
                </correctResponse>-->
            </responseDeclaration>

            <outcomeDeclaration identifier="SCORE" cardinality="single" baseType="float">
                <defaultValue>
                    <value>0</value>
                </defaultValue>
            </outcomeDeclaration>
            <outcomeDeclaration identifier="MAXSCORE" cardinality="single" baseType="float">
                <defaultValue>
                    <value>100</value>
                </defaultValue>
            </outcomeDeclaration>
            <itemBody>
                <xsl:apply-templates select="*[contains(@class,' topic/body ')]/node()"
                    mode="identity">
                    <xsl:with-param name="type" select="'assessment'"/>
                </xsl:apply-templates>
                <extendedTextInteraction responseIdentifier="Q"/>
            </itemBody>
        </assessmentItem>
    </xsl:template>

    <!-- #### NEW ASSESSMENT FROM QUESTION ######################################################### -->
    <xsl:template match="/" mode="new_assessment_from_q">
        <xsl:param name="unit"/>
        <xsl:param name="topic_id"/>
        <xsl:param name="question_number"/>
        
        <xsl:apply-templates select="*[contains(@class,' topic/topic ')]"
            mode="new_assessment_from_q">
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="topic_id" select="$topic_id"/>
            <xsl:with-param name="question_number" select="$question_number"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/topic ')]" mode="new_assessment_from_q">
        <xsl:param name="unit"/>
        <xsl:param name="topic_id"/>
        <xsl:param name="question_number"/>
        
        <assessmentItem xmlns="http://www.imsglobal.org/xsd/imsqti_v2p1"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.imsglobal.org/xsd/imsqti_v2p1 http://www.imsglobal.org/xsd/imsqti_v2p1.xsd"
            title="Question" timeDependent="false" adaptive="false">
            <xsl:attribute name="identifier">
                <xsl:value-of select="$topic_id"/>
                <!--                <xsl:value-of select="replace(@id,'_task_','_ques_')"/>-->
            </xsl:attribute>
            <xsl:value-of select="$newline"/>
            <xsl:comment>Source file (new_assessment_from_q): <xsl:value-of select="@xtrf"/>.</xsl:comment>
            <xsl:value-of select="$newline"/>
            
            <!-- [SP] 2016-05-16 sfb: If this is an open question, we need an outcomeDeclaration for score(s). -->
            <xsl:variable name="open_questions" select="descendant::lcOpenQuestion2" as="element()*"/>
            <xsl:if test="count($open_questions) &gt; 0">
                <xsl:apply-templates select="$open_questions" mode="outcomeDeclaration"/>
            </xsl:if>
            
            <!-- includes lcSingleSelect2, lcTrueFalse2, lcOpenQuestion2. -->
            <xsl:apply-templates 
                select="descendant-or-self::*[contains(@class,' learningInteractionBase2-d/lcInteractionBase ')]"
                mode="new_learning_question">
                <xsl:with-param name="unit" select="$unit"/>
                <xsl:with-param name="q_number" select="$question_number"/>
                <xsl:with-param name="task_number" select="''"/>
            </xsl:apply-templates>
        </assessmentItem>
    </xsl:template>

    <!-- #### NEW QUESTION ###################################################################### -->
    <xsl:template match="/" mode="new_question">
        <xsl:param name="unit"/>
        <xsl:param name="assessment"/>
        <xsl:param name="question_item"/>
        <xsl:param name="topicref" as="element()*"/>
        <xsl:param name="topic_id"/>
        <xsl:param name="navtitle"/>
        
        <xsl:apply-templates select="*[contains(@class,' topic/topic ')]" mode="new_question">
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="assessment" select="$assessment"/>
            <xsl:with-param name="question_item" select="$question_item"/>
            <xsl:with-param name="topicref" select="$topicref"/>
            <xsl:with-param name="topic_id" select="$topic_id"/>
            <xsl:with-param name="navtitle" select="$navtitle"/>
        </xsl:apply-templates>
    </xsl:template>

    <!-- The question is a QTI question. -->
    <xsl:template match="*[contains(@class,' topic/topic ')]" mode="new_question">
        <xsl:param name="unit"/>
        <xsl:param name="assessment"/>
        <xsl:param name="question_item"/>
        <xsl:param name="topicref" as="element()*"/>
        <xsl:param name="topic_id"/>
        <xsl:param name="navtitle"/>
        
        <xsl:variable name="unit_only">
            <xsl:choose>
                <xsl:when test="starts-with($unit,'C.')">
                    <xsl:value-of select="'C'"/>
                </xsl:when>
                <!-- There probably won't be questions in introductory material, 
                    but I just copied this variable definition from new_task. -->
                <xsl:when test="starts-with($unit,'I.')">
                    <xsl:value-of select="'I'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after($unit,'.')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- NOTE THIS IS A BIG HACK:
             because xmlns:xs is used already by XSL for its extended functions, this causes a collision 
             with the xmlns:xs required by question topics.
             To solve this, we create these temporarily with xmlns:xstemp, then delete the -temp in 
             post processing (in build_dita2pace.xml). -->
        <question xmlns:temp="temphttp://www.w3.org/2001/XMLSchema"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:f="Functions"
            xsi:noNamespaceSchemaLocation="urn:kaplan:names:tc:dita:xsd:question.xsd">
            <xsl:attribute name="id">
                <xsl:value-of select="$topic_id"/>
                <!--                <xsl:value-of select="replace(@id,'_task','')"/>-->
            </xsl:attribute>
            <xsl:value-of select="$newline"/>
            <xsl:comment>Source file (new_question): <xsl:value-of select="@xtrf"/>.</xsl:comment>
            <xsl:value-of select="$newline"/>
            <xsl:variable name="lmsCategory" select="descendant::lmsCategory[1]/@value"/>
            <xsl:variable name="lmsCategory_initcap"
                select="concat(upper-case(substring($lmsCategory,1,1)),substring($lmsCategory,2))"/>
            <title>
                <xsl:choose>
                    <xsl:when test="not(empty($navtitle))">
                        <xsl:apply-templates select="$navtitle" mode="identity"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($lmsCategory_initcap,' ',$unit_only,'.',$assessment)"/>                
                    </xsl:otherwise>
                </xsl:choose>
                
            </title>
            <prolog>
                <metadata>
                    <!-- According to the spec this is always "test_quiz" for assignment topics. -->
                    <category>test_quiz</category>
                    <othermeta name="duration">
                        <xsl:attribute name="content">
                            <xsl:choose>
                                <xsl:when test="descendant::duration[1]/@value">
                                    <xsl:value-of select="descendant::duration[1]/@value"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>00:00</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>

                        </xsl:attribute>
                    </othermeta>
                    <!-- TODO: Additional othermeta items are drawn from the related Assessment Overview topic. -->
                </metadata>
            </prolog>
            <questionGroup>
                <questionItem href="{$question_item}">
                    <!-- Switching context back to supermap. -->
                    <xsl:apply-templates select="$topicref/topicsubject" mode="new_question"/>
                </questionItem>
            </questionGroup>
        </question>
    </xsl:template>
    
    <xsl:variable name="los_summary" select="/supermap/los_summary" as="element()*"/>
    
    <xsl:template match="topicsubject" mode="new_question">
        <!-- Get the unique portion of the topicsubject href filename. -->
        <xsl:variable name="file_id" select="concat('_los_',substring-after(@orig_href,'_los_'))"/>
        <!-- Find the los element in los_summary that matches the string. -->
        <xsl:variable name="los_element" select="$los_summary/los[contains(@orig_href,$file_id)]"
            as="element()*"/>
        <xsl:variable name="los_number" select="functx:index-of-node($los_summary/*,$los_element)"/>
        <data name="learningObjective">
            <xsl:attribute name="value">
                <xsl:value-of
                    select="concat('../los/',/supermap/@name_base,'_LOG',$los_number,'_LO',$los_number,'.dita')"
                />
            </xsl:attribute>
        </data>
    </xsl:template>

    <!-- #### NEW EXAM MAP (question) ###################################################################### -->
    <xsl:template match="examMap" mode="new_exam_map">
        <xsl:param name="unit"/>
        <xsl:param name="name_base"/>
        <xsl:param name="exam_number"/>
        <xsl:param name="topic_id"/>
        <xsl:param name="source_file"/>
        <xsl:param name="assessment_type"/>

        <!--        <xsl:param name="topicref" as="element()*"/>-->
        <xsl:apply-templates select="." mode="new_exam_map_contents">
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="name_base" select="$name_base"/>
            <xsl:with-param name="exam_number" select="$exam_number"/>
            <!--            <xsl:with-param name="question_item" select="$question_item"/>-->
            <xsl:with-param name="topic_id" select="$topic_id"/>
            <xsl:with-param name="source_file" select="$source_file"/>
            <xsl:with-param name="assessment_type" select="$assessment_type"/>
        </xsl:apply-templates>
    </xsl:template>

    <!-- The exam map is a QTI Question. -->
    <xsl:template match="examMap" mode="new_exam_map_contents">
        <!--        <xsl:template match="topicref" mode="new_exam_map_contents">-->
        <xsl:param name="unit"/>
        <xsl:param name="name_base"/>
        <xsl:param name="exam_number"/>
        <xsl:param name="topic_id"/>
        <xsl:param name="source_file"/>
        <xsl:param name="assessment_type"/>
        
        <!--        <xsl:param name="question_item"/>-->
        <!-- NOTE THIS IS A BIG HACK:
             because xmlns:xs is used already by XSL for its extended functions, this causes a collision 
             with the xmlns:xs required by question topics.
             To solve this, we create these temporarily with xmlns:xs-temp, then delete the -temp in 
             post processing (in build_dita2pace.xml). -->
        <question xmlns:temp="temphttp://www.w3.org/2001/XMLSchema"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:f="Functions"
            xsi:noNamespaceSchemaLocation="urn:kaplan:names:tc:dita:xsd:question.xsd">
            <xsl:attribute name="id">
                <xsl:value-of select="$topic_id"/>
                <!--                <xsl:value-of select="@id"/>-->
            </xsl:attribute>
            <xsl:value-of select="$newline"/>
            <xsl:comment>Source file (new_exam_map_contents): "<xsl:value-of select="@orig_href"/>".</xsl:comment>
            <xsl:value-of select="$newline"/>

            <title>
                <!-- Moved from title attribute to <navtitle> element. -->
                <xsl:apply-templates select="navtitle" mode="identity"/>
<!--                <!-\- [SP] 6-Jan-2015: Simplifying Peyton's change. the type is already 
                    in <examMap @title> in the supermap. -\->
                <xsl:variable name="exam_type" select="@title"/>
                <xsl:value-of select="$exam_type"/>-->
            </title>

            <!--            <xsl:comment>opening @orig_href.</xsl:comment>-->
            <xsl:variable name="source_tree" select="document(@orig_href)"/>
            <!--            <xsl:comment>source_tree is <xsl:value-of select="name($source_tree/*[1])"/>.</xsl:comment>-->

            <prolog>
                <metadata>
                    <!-- Pull metadata from assessment_overview @orig_href. -->
                    <xsl:apply-templates
                        select="$source_tree/descendant-or-self::*[contains(@class,' topic/prolog ')]"
                        mode="get_metadata">
                        <xsl:with-param name="assessment_type" select="@assessment_type"/>
                    </xsl:apply-templates>
                </metadata>
            </prolog>

            <xsl:apply-templates
                select="$source_tree/descendant::*[contains(@class,' topic/body ')]" mode="identity"/>

            <questionGroup>
                <xsl:apply-templates select="topicref" mode="exam_topics">
                    <xsl:with-param name="unit" select="$unit"/>
                    <xsl:with-param name="name_base" select="$name_base"/>
                    <xsl:with-param name="exam_number" select="$exam_number"/>
                </xsl:apply-templates>
            </questionGroup>
        </question>
    </xsl:template>

    <xsl:template match="topicref" mode="exam_topics">
        <xsl:param name="unit"/>
        <xsl:param name="name_base"/>
        <xsl:param name="exam_number"/>
        <xsl:param name="navtitle"/> <!-- Might not be used. -->
        
        <xsl:variable name="file_id_base">
            <xsl:call-template name="get_file_id_base">
                <xsl:with-param name="orig_href" select="@orig_href"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:message>file_id_base is: <xsl:value-of select="$file_id_base"/>.</xsl:message>

        <!--        <!-\- MREP: filename derived from original file. -\->
        <xsl:variable name="file_name" select="replace(@orig_href,'.*/([^/]*\.[^/]*)$','questions/$1')"/>
-->
        <xsl:variable name="file_name" select="concat($file_id_base,'.xml')"/>

        <!-- Create proper question item topics for each of the topicref/@orig_href. -->
        <xsl:variable name="assessment_type" select="parent::examMap/@assessment_type"/>

        <xsl:variable name="exam_type">
            <xsl:choose>
                <xsl:when test="$assessment_type = 'test-exam-primary'">
                    <xsl:text>FE</xsl:text>
                </xsl:when>
                <xsl:otherwise>E</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="q_number" select="count(preceding-sibling::topicref) + 1"/>
        <xsl:variable name="identifier"
            select="concat($name_base,'_',$exam_type,$exam_number,'_Q',$q_number)"/>

        <!-- Determine the name of the new topic. -->
        <!--        <xsl:variable name="file_name" select="concat('questions/',$identifier,'.xml')"/>
-->
        <!-- Create the question-item topic. -->
<!--        <xsl:variable name="out_file"
            select="concat('file:///',translate($OUT_DIR,'\','/'),'/questions/',$file_name)"/>-->
        <xsl:variable name="out_file"
            select="concat('questions/',$file_name)"/>
        <xsl:message>(new_learning_question) out_file is "<xsl:value-of select="$out_file"/>".</xsl:message>
        <!-- Because we're going to be changing context (to $topic), we need the current element. -->
        <xsl:variable name="topicref" select="." as="element()*"/>
        
        <!-- [SP] 2016-06-03 sfb: Build a subtree that associates @base values with subq numbers. -->

        <!-- And load the current topic. -->
        <xsl:variable name="topic" select="document(@orig_href)/*" as="element()*"/>
        
        <xsl:variable name="base_list" as="element()*">
            <xsl:apply-templates select="$topic" mode="get_base"/>
        </xsl:variable>

        <!-- Create the questionItem element. -->
        <questionItem>
            <xsl:attribute name="href">
                <xsl:value-of select="$file_name"/>
            </xsl:attribute>
            <!-- [SP] 2016-06-03 sfb: DRAW EQUIVALENCE BETWEEN @base and Q id. -->
            
            
            <!-- Create the <data> item from the nested topicsubject element. -->
            <xsl:apply-templates select="topicsubject" mode="find_los">
                <xsl:with-param name="q_number" select="$q_number"/>
                <xsl:with-param name="base_list" select="$base_list"/>
            </xsl:apply-templates>
        <xsl:apply-templates select="difficulty">
                <xsl:with-param name="q_number" select="$q_number"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="sortOrder"/>
     
            
        </questionItem>

        <!-- Process the href file into a new file -->
        <xsl:result-document href="{$out_file}" method="xml" indent="yes" doctype-public="''"
            doctype-system="''">
            <!-- All mode="new_topic" templates are defined in new_topic_task.xsl. -->
            <xsl:apply-templates select="$topic" mode="new_learning_question">
                <!--                <xsl:with-param name="unit" select="$unit"/>-->
                <xsl:with-param name="unit" select="concat($exam_type,$exam_number)"/>
                <xsl:with-param name="task_number" select="$exam_number"/>
                <xsl:with-param name="q_number" select="$q_number"/>
                <xsl:with-param name="identifier" select="$topic/@id"/>
            </xsl:apply-templates>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template match="kpe-question" mode="get_base">
        <xsl:for-each select="//*[contains(@class,' learningInteractionBase2-d/lcInteractionBase ') and @base]">
            <base>
                <xsl:attribute name="base">
                    <xsl:value-of select="@base"/>
                </xsl:attribute>
                <xsl:attribute name="subq_number">
                    <xsl:value-of select="count(preceding::*[contains(@class,' learningInteractionBase2-d/lcInteractionBase ')]) + 1"/>
                </xsl:attribute>
            </base>
        </xsl:for-each>
    </xsl:template>
	
	
	<xsl:template match="kpe-summary" mode="get_base">
		<xsl:for-each select="//*[contains(@class,' learningInteractionBase2-d/lcInteractionBase ') and @base]">
			<base>
				<xsl:attribute name="base">
					<xsl:value-of select="@base"/>
				</xsl:attribute>
				<xsl:attribute name="subq_number">
					<xsl:value-of select="count(preceding::*[contains(@class,' learningInteractionBase2-d/lcInteractionBase ')]) + 1"/>
				</xsl:attribute>
			</base>
		</xsl:for-each>
	</xsl:template>
	

    <xsl:template match="topicsubject" mode="find_los">
        <xsl:param name="q_number"/>
        <xsl:param name="base_list" as="element()*"/>
        
        <xsl:variable name="name_base" select="/supermap/@name_base"/>
        <!-- Find determine the los name from the keyref attribute. -->
        <!-- Get the keyref attribute before finding unit. -->
        <!--        <xsl:variable name="keyref" select="@keyref"/>
        <xsl:variable name="los" select="$los_summary/los[@keys = $keyref]"/>
        <xsl:variable name="los_number" select="functx:index-of-node($los_summary/*,$los)"/>
        <xsl:variable name="file_name"
            select="concat('../los/',$name_base,'_LOG',$los_number,'_LO',$los_number,'.dita')"/>
-->
        <xsl:variable name="file_id_base" select="replace(@orig_href,'.*/([^/]*)\.dita','$1')"/>

        <xsl:variable name="file_name" select="concat('../los/',$file_id_base,'.dita')"/>

        <xsl:variable name="ts_base" select="@base"/>

        <xsl:variable name="subq_number">
            <xsl:choose>
                <xsl:when test="count($base_list) &gt; 0">
                    <xsl:number value="$base_list[@base = $ts_base]/@subq_number" format="a"/>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:if test="count($base_list) &gt; 0 and $subq_number = ''">
            <xsl:message>******* WARNING: No subquestion exists with the base name <xsl:value-of select="$ts_base"/>.</xsl:message>
        </xsl:if>

        <data name="learningObjective">
            <xsl:attribute name="value">
                <xsl:value-of select="$file_name"/>
            </xsl:attribute>
            <xsl:attribute name="datatype">
                <xsl:value-of select="concat('Q',$q_number,$subq_number)"/>
            </xsl:attribute>
        </data>
    </xsl:template>

    <xsl:template match="difficulty">
        <xsl:param name="q_number"/>
        <data name="difficulty">
            <xsl:attribute name="value">
                <xsl:value-of select="@value"/>
            </xsl:attribute>
            <xsl:attribute name="datatype">
                <xsl:value-of select="concat('Q',$q_number)"/>
            </xsl:attribute>
        </data>
    </xsl:template>
    
    
    
    <xsl:template match="sortOrder">
        <sort-order>
           <xsl:apply-templates/>
        </sort-order>
    </xsl:template>

    <!-- [SP] 2014-06-25: Removed intermediate "metadata" element, which seems to have gone away. -->
    <xsl:template match="/" mode="get_metadata">
        <xsl:param name="assessment_type"/>
        <xsl:apply-templates select="//prolog/lmsCategory" mode="get_metadata"/>
        <xsl:choose>
            <xsl:when test="$assessment_type = 'test-exam-primary'">
                <!-- Don't bother with this metadata for final exams. -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="//prolog" mode="get_metadata"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="prolog" mode="get_metadata">
        <!-- Removed select="metadata" -->
        <xsl:apply-templates mode="get_metadata"/>
    </xsl:template>

    <xsl:template match="metadata" mode="get_metadata">
        <xsl:apply-templates
            select="lmsCategory | assessmentType | questionRandomize | duration | distractorRandomize"
            mode="get_metadata"/>

    </xsl:template>

    <xsl:template match="assessmentType" mode="get_metadata">
        <category>
            <xsl:value-of select="translate(@value,'-','_')"/>
        </category>
    </xsl:template>

    <xsl:template match="lmsCategory" mode="get_metadata">
        <category>
            <xsl:value-of select="@value"/>
        </category>
    </xsl:template>

    <xsl:template match="questionRandomize" mode="get_metadata">
        <othermeta name="QuestionRandomize">
            <xsl:attribute name="content">
                <xsl:choose>
                    <xsl:when test="@value='yes'">
                        <xsl:value-of select="'true'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'false'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </othermeta>
    </xsl:template>

    <xsl:template match="duration" mode="get_metadata">
        <othermeta name="duration">
            <xsl:attribute name="content">
                <xsl:choose>
                    <xsl:when test="@value">
                        <xsl:value-of select="@value"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>00:00</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </othermeta>
    </xsl:template>

    <xsl:template match="distractorRandomize" mode="get_metadata">

        <!-- This note was a carry-over from v2: Do nothing for QTI Question files. 
             I'm now ignoring it. -->
        <othermeta name="DistractorRandomize">
            <xsl:attribute name="content">
                <xsl:choose>
                    <xsl:when test="@value='yes'">
                        <xsl:value-of select="'true'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'false'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </othermeta>

    </xsl:template>

    <!-- #### NEW LEARNING QUESTION ###################################################################### -->
    <xsl:template match="/" mode="new_learning_question">
        <xsl:param name="unit"/>
        <xsl:param name="task_number"/>
        <xsl:param name="q_number"/>
        <xsl:param name="identifier"/>
        
        <xsl:apply-templates select="*[contains(@class,' topic/topic ')]"
            mode="new_learning_question">
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="task_number" select="$task_number"/>
            <xsl:with-param name="q_number" select="$q_number"/>
            <xsl:with-param name="identifier" select="$identifier"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/topic ')]" mode="new_learning_question">
        <xsl:param name="unit"/>
        <xsl:param name="task_number"/>
        <xsl:param name="q_number"/>
        <xsl:param name="identifier"/>
        
        <assessmentItem xmlns="http://www.imsglobal.org/xsd/imsqti_v2p1"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://www.imsglobal.org/xsd/imsqti_v2p1 http://www.imsglobal.org/xsd/imsqti_v2p1.xsd"
            identifier="{$identifier}" title="Question" timeDependent="false" adaptive="false">
            <xsl:value-of select="$newline"/>
            <xsl:comment>Source file (learning_question): <xsl:value-of select="@xtrf"/>.</xsl:comment>
            <xsl:value-of select="$newline"/>
            <!--            PSB ADDED PROLOG STUFF-->
            <!--   on hold until LMS update       -->
            <!--<prolog>
                <metadata>
                    <xsl:variable name="difficulty" select="descendant::difficulty[1]/@value"/>
                    <difficulty>
                        <xsl:choose>
                            <xsl:when test="$difficulty = 'basic'">
                                <xsl:text>basic</xsl:text>
                            </xsl:when>
                            <xsl:when test="$difficulty = 'intermediate'">
                                <xsl:text>intermediate</xsl:text>
                            </xsl:when>
                            <xsl:when test="$difficulty = 'advanced'">
                                <xsl:text>advanced</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                    </difficulty>
                </metadata>
            </prolog>
            -->
            <xsl:apply-templates
                select="*[contains(@class,' learningAssessment/learningAssessmentbody ')]"
                mode="new_learning_question">
                <xsl:with-param name="unit" select="$unit"/>
                <xsl:with-param name="q_number" select="$q_number"/>
                <xsl:with-param name="task_number" select="$task_number"/>
            </xsl:apply-templates>
        </assessmentItem>
    </xsl:template>
    <!--    <!-\- Priority required to get above the topic/topic in the previous template. -\->
    <xsl:template match="*[contains(@class,' learningAssessment/learningAssessment ')]" mode="new_learning_question_A">
        <xsl:param name="unit"/>
        <xsl:param name="task_number"/>
        <xsl:apply-templates select="*[contains(@class,' learningAssessment/learningAssessmentbody ')]" mode="new_learning_question">
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="task_number" select="$task_number"/>
        </xsl:apply-templates>
        
    </xsl:template>

-->
    <xsl:template match="*[contains(@class,' learningAssessment/learningAssessmentbody ')]"
        mode="new_learning_question">
        <xsl:param name="unit"/>
        <xsl:param name="task_number"/>
        <xsl:param name="q_number"/>
        
        <xsl:message>In learningAssessmentbody. lcInteraction count is <xsl:value-of select="count(*[contains(@class,' learningBase/lcInteraction ')])"/>.</xsl:message>
        
        <!-- [SP] 2016-04-27 sfb: Modifications to support multi-part questions. -->
        <xsl:choose>
            
            <xsl:when test="count(*[contains(@class,' learningBase/lcInteraction ')]) &gt; 1">
                <xsl:message>#### INFO: got multipart question. </xsl:message>
                <xsl:call-template name="multipart_learning_question">
                    <xsl:with-param name="unit" select="$unit"/>
                    <xsl:with-param name="q_number" select="$q_number"/>
                    <xsl:with-param name="task_number" select="$task_number"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>#### INFO: got single question. </xsl:message>
                <xsl:apply-templates select="*[contains(@class,' learningBase/lcInteraction ')]"
                    mode="new_learning_question">
                    <xsl:with-param name="unit" select="$unit"/>
                    <xsl:with-param name="q_number" select="$q_number"/>
                    <xsl:with-param name="task_number" select="$task_number"/>
                </xsl:apply-templates>
                
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>

    <xsl:template match="*[contains(@class,' learningBase/lcInteraction ')]" mode="new_learning_question">
        <xsl:param name="unit"/>
        <xsl:param name="q_number"/>
        <xsl:param name="task_number"/>
        
        <xsl:apply-templates mode="new_learning_question">
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="q_number" select="$q_number"/>
            <xsl:with-param name="task_number" select="$task_number"/>
        </xsl:apply-templates>
    </xsl:template>


    <!-- Match anything else while in new_learning_question OR new_multipart_learning_question mode. -->
    <xsl:template match="*" mode="new_learning_question new_multipart_learning_question">
        <xsl:param name="unit"/>
        <xsl:param name="q_number"/>
        <xsl:param name="task_number"/>
        
        <xsl:message>%%%% NOTE: encountered unhandled interaction type (<xsl:value-of select="name()"/>).</xsl:message>
        
        <xsl:apply-templates mode="new_learning_question">
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="q_number" select="$q_number"/>
            <xsl:with-param name="task_number" select="$task_number"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <!-- [SP] 2016-04-27 sfb: Multi-part questions require doing things somewhat differently... -->
    <!-- Context is kpe-questionBody-->
    <xsl:template name="multipart_learning_question">
        <xsl:param name="unit"/>
        <xsl:param name="q_number"/>
        <xsl:param name="task_number"/>

        <!-- Create responseDeclarations for all lcInteractions. -->
        <xsl:apply-templates select="*[contains(@class,' learningBase/lcInteraction ')]" mode="multipart_responseDeclarations">
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="q_number" select="$q_number"/>
            <xsl:with-param name="subq_number">
                <xsl:number count="*[contains(@class,' learningBase/lcInteraction ')]" format="a" level="single"/>
            </xsl:with-param>
            <xsl:with-param name="task_number" select="$task_number"/>
        </xsl:apply-templates>
        
        <itemBody>
            <xsl:apply-templates mode="new_multipart_learning_question">
                <xsl:with-param name="unit" select="$unit"/>
                <xsl:with-param name="q_number" select="$q_number"/>
                <xsl:with-param name="task_number" select="$task_number"/>
            </xsl:apply-templates>            
        </itemBody>
        
        <responseProcessing template="explanationTemplate.xml"/>
        <!-- Create modalFeedback divs for all lcInteractions. -->
        <modalFeedback outcomeIdentifier="EXPLANATION" identifier="completed" showHide="show">
            <!-- need to apply on all lcFeedbackCorrect2 elements in all lcInterractions -->
<!--            <xsl:apply-templates select="lcFeedbackCorrect2"/>-->
            <xsl:apply-templates select="*[contains(@class,' learningBase/lcInteraction ')]" mode="multipart_modalFeedback">
                <xsl:with-param name="unit" select="$unit"/>
                <xsl:with-param name="q_number" select="$q_number"/>
                <xsl:with-param name="subq_number">
                    <xsl:number count="*[contains(@class,' learningBase/lcInteraction ')]" format="a" level="single"/>
                </xsl:with-param>
                <xsl:with-param name="task_number" select="$task_number"/>
            </xsl:apply-templates>
        </modalFeedback>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' learningBase/lcIntro ')]" mode="new_multipart_learning_question">
        <xsl:choose>
            <xsl:when test="node()[1][self::text()]">
                <p>
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="vignette"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*" mode="vignette">
        <xsl:variable name="e_name" select="name()"/>
        <xsl:element name="{$e_name}">
            <xsl:apply-templates select="@*" mode="vignette"/>
            <xsl:apply-templates mode="vignette"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="@*" mode="vignette">
        <xsl:variable name="name" select="name()"/>
        <xsl:if test="name() != 'xtrf' and name() != 'xtrc' and name() != 'class' and name() != 'xmlns:m'">
            
            <xsl:copy/>
        </xsl:if>
    </xsl:template>
    
    
    <xsl:template match="*[contains(@class,' learningBase/lcInteraction ')]" mode="multipart_responseDeclarations">
        <xsl:param name="unit"/>
        <xsl:param name="q_number"/>
        <xsl:param name="subq_number"/>
        <xsl:param name="task_number"/>
        
        <xsl:variable name="subq_number">
            <xsl:number count="*[contains(@class,' learningBase/lcInteraction ')]" format="a" level="single"/>
        </xsl:variable>
        <responseDeclaration identifier="{concat('Q',$q_number,$subq_number)}" cardinality="single">
<!--            <xsl:call-template name="get_correct_single"/>-->
            <!-- Don't call get_correct for an open question. -->
            <xsl:if test="not(lcOpenQuestion2)">
                <xsl:call-template name="get_correct_multiple"/>
            </xsl:if>
            <mapping defaultValue="0">
                <xsl:choose>
                    <xsl:when test="lcOpenQuestion2">
                        <xsl:apply-templates select="descendant::lcQuestion2"
                            mode="get_mapEntry_open"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="descendant::lcAnswerOption2"
                            mode="get_mapEntry"/>
                    </xsl:otherwise>
                </xsl:choose>
            </mapping>
        </responseDeclaration>
        
    </xsl:template>

    <xsl:template match="*[contains(@class,' learningBase/lcInteraction ')]" mode="multipart_modalFeedback">
        <xsl:param name="unit"/>
        <xsl:param name="q_number"/>
        <xsl:param name="subq_number"/>
        <xsl:param name="task_number"/>
        
        <xsl:variable name="subq_number">
            <xsl:number count="*[contains(@class,' learningBase/lcInteraction ')]" format="a" level="single"/>
        </xsl:variable>
        <div label="{concat('Q',$q_number,$subq_number)}">
            <xsl:apply-templates select="descendant::lcFeedbackCorrect2 | descendant::lcOpenAnswer2" mode="modalFeedback"/>
        </div>
        
    </xsl:template>
    
    <xsl:template match="lcFeedbackCorrect2 | lcOpenAnswer2" mode="modalFeedback">
        <xsl:choose>
            <xsl:when test="node()[1][self::text()]">
                <p>
                    <xsl:apply-templates/>
                </p>
            </xsl:when>
            <xsl:otherwise>
                <!-- vignette handling works for lcFeedbackCorrect2 also. -->
                <xsl:apply-templates mode="vignette"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' learningBase/lcInteraction ')]" mode="new_multipart_learning_question">
        <xsl:param name="unit"/>
        <xsl:param name="q_number"/>
        <xsl:param name="task_number"/>
        
        <xsl:apply-templates mode="new_multipart_learning_question">
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="q_number" select="$q_number"/>
            <xsl:with-param name="subq_number">
                <xsl:number count="*[contains(@class,' learningBase/lcInteraction ')]" format="a" level="single"/>
            </xsl:with-param>
            <xsl:with-param name="task_number" select="$task_number"/>
        </xsl:apply-templates>
    </xsl:template>
    
    <!-- Also used by new_assessment_from_q. -->
    <xsl:template match="lcSingleSelect2 | lcTrueFalse2" mode="new_learning_question">
        <xsl:param name="unit"/>
        <xsl:param name="q_number"/>
        <xsl:param name="task_number"/>
        
        <responseDeclaration xmlns="http://www.imsglobal.org/xsd/imsqti_v2p1" identifier="{concat('Q',$q_number)}" cardinality="single">
            <xsl:call-template name="get_correct_single"/>
            <mapping defaultValue="0">
                <xsl:apply-templates select="lcAnswerOptionGroup2/lcAnswerOption2"
                    mode="get_mapEntry"/>
            </mapping>
        </responseDeclaration>
        <itemBody  xmlns="http://www.imsglobal.org/xsd/imsqti_v2p1">

            <!-- [SP] 2016-06-13 sfb: Note that single questions have the prompt in a p before the choiceInteraction.
                      In multi-part questions, the prompt is part of the choiceInteraction. 
            -->
            <!-- Detect if the lcQuestion2 contains its own paragraphs, or if it's just plain text. -->
            <xsl:choose>
                <xsl:when test="lcQuestion2/node()[self::text()]">
                    <p>
                        <xsl:apply-templates select="lcQuestion2"/>
                    </p>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="lcQuestion2/*" mode="identity">
                        <xsl:with-param name="type" select="'question'"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>

            <choiceInteraction responseIdentifier="{concat('Q',$q_number)}" maxChoices="1"
                shuffle="true">
                
                <xsl:apply-templates select="lcAnswerOptionGroup2/lcAnswerOption2" mode="get_choice"
                />
            </choiceInteraction>
        </itemBody>
        <responseProcessing  xmlns="http://www.imsglobal.org/xsd/imsqti_v2p1" template="explanationTemplate.xml"/>
        <modalFeedback  xmlns="http://www.imsglobal.org/xsd/imsqti_v2p1" outcomeIdentifier="EXPLANATION" identifier="completed" showHide="show">
            <xsl:apply-templates select="lcFeedbackCorrect2|lcOpenAnswer2"/>
        </modalFeedback>
    </xsl:template>

    <!--    PSB TO TEST MULTI SELECT QUESTIONS-->
    
   
    <xsl:template match="lcMultipleSelect2" mode="new_learning_question">
        <xsl:param name="unit"/>
        <xsl:param name="q_number"/>
        <xsl:param name="task_number"/>
        <responseDeclaration xmlns="http://www.imsglobal.org/xsd/imsqti_v2p1"
            identifier="{concat('Q',$q_number)}" cardinality="multiple">
            <xsl:call-template name="get_correct_MS"/>
            <mapping defaultValue="0">
                <xsl:apply-templates select="lcAnswerOptionGroup2/lcAnswerOption2"
                    mode="get_mapEntry"/>
            </mapping>
        </responseDeclaration>
        <itemBody xmlns="http://www.imsglobal.org/xsd/imsqti_v2p1">
            <!-- [SP] 2016-06-13 sfb: Note that single questions have the prompt in a p before the choiceInteraction.
                      In multi-part questions, the prompt is part of the choiceInteraction. 
            -->
            <!-- Detect if the lcQuestion2 contains its own paragraphs, or if it's just plain text. -->
            <xsl:choose>
                <xsl:when test="lcQuestion2/node()[self::text()]">
                    <p>
                        <xsl:apply-templates select="lcQuestion2"/>
                    </p>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="lcQuestion2/*" mode="identity">
                        <xsl:with-param name="type" select="'question'"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
            
            <choiceInteraction responseIdentifier="{concat('Q',$q_number)}" shuffle="true">
                
                <xsl:apply-templates select="lcAnswerOptionGroup2/lcAnswerOption2" mode="get_choice"
                />
            </choiceInteraction>
        </itemBody>
        <responseProcessing xmlns="http://www.imsglobal.org/xsd/imsqti_v2p1"
            template="explanationTemplate.xml"/>
        <modalFeedback xmlns="http://www.imsglobal.org/xsd/imsqti_v2p1"
            outcomeIdentifier="EXPLANATION" identifier="completed" showHide="show">
            <xsl:apply-templates select="lcFeedbackCorrect2"/>
        </modalFeedback>
    </xsl:template>
    
    
    
    
    
<!--PSB: This fixes pointvalue in single essay questions. Multiple pieces of this template were updated. 6/1/2017 -->
    <xsl:template match="lcOpenQuestion2" mode="new_learning_question">
        <xsl:param name="unit"/>
        <xsl:param name="q_number"/>
        <xsl:param name="task_number"/>
        
        <responseDeclaration xmlns="http://www.imsglobal.org/xsd/imsqti_v2p1" identifier="{concat('Q',$q_number)}" cardinality="single">
            <!-- There is no "correct" to get for an open question. -->
            <!--            <xsl:call-template name="get_correct_single"/>-->
            <mapping defaultValue="0">
                <xsl:apply-templates select="lcQuestion2" mode="get_mapEntry_open"/>
            </mapping>
        </responseDeclaration>
        <itemBody  xmlns="http://www.imsglobal.org/xsd/imsqti_v2p1">
            <extendedTextInteraction responseIdentifier="{concat('Q',$q_number)}" minStrings="1"
                textFormat="plain">
                <!-- Detect if the lcQuestion2 contains its own paragraphs, or if it's just plain text. -->
                <xsl:choose>
                    <xsl:when test="lcQuestion2/node()[self::text()]">
                        <prompt>
                            <p><b>ARV</b>
                                <xsl:apply-templates select="lcQuestion2"/>
                            </p>
                        </prompt>
                    </xsl:when>
                    <xsl:otherwise>
                        <!--                    <xsl:comment>lcQuestion2 with block elements.</xsl:comment>-->
                    	<prompt><b>ARV</b>
                            <xsl:apply-templates select="lcQuestion2/*" mode="identity">
                                <xsl:with-param name="type" select="'question'"/>
                            </xsl:apply-templates>
                        </prompt>
                    </xsl:otherwise>
                </xsl:choose>
                
            </extendedTextInteraction>
        </itemBody>
        <responseProcessing  xmlns="http://www.imsglobal.org/xsd/imsqti_v2p1" template="explanationTemplate.xml"/>
        <modalFeedback  xmlns="http://www.imsglobal.org/xsd/imsqti_v2p1" outcomeIdentifier="EXPLANATION" identifier="completed" showHide="show">
            <!--updated to say lcOpenAnswer2 instead of lcFeedbackCorrect2 psb 3/1/2017-->
        <xsl:apply-templates select="lcFeedbackCorrect2|lcOpenAnswer2"/>
        </modalFeedback>
    </xsl:template>
    
    <!-- [SP] 2016-04-28 sfb: QTI April 2016. -->
    <!-- TODO: See if we need to do something for "Also used by new_assessment_from_q". -->
    <xsl:template match="lcSingleSelect2 | lcTrueFalse2" mode="new_multipart_learning_question">
        <xsl:param name="unit"/>
        <xsl:param name="q_number"/>
        <xsl:param name="subq_number"/>
        <xsl:param name="task_number"/>
        
        <choiceInteraction responseIdentifier="{concat('Q',$q_number,$subq_number)}" maxChoices="1"
            shuffle="true">
            <!-- Detect if the lcQuestion2 contains its own paragraphs, or if it's just plain text. -->
            <xsl:choose>
                <xsl:when test="lcQuestion2/node()[self::text()]">
                    <prompt>
                        <p>
                            <xsl:apply-templates select="lcQuestion2"/>
                        </p>
                    </prompt>
                </xsl:when>
                <xsl:otherwise>
                    <!--                    <xsl:comment>lcQuestion2 with block elements.</xsl:comment>-->
                    <prompt>
                        <xsl:apply-templates select="lcQuestion2/*" mode="identity">
                            <xsl:with-param name="type" select="'question'"/>
                        </xsl:apply-templates>
                    </prompt>
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:apply-templates select="lcAnswerOptionGroup2/lcAnswerOption2" mode="get_choice"
            />
        </choiceInteraction>
    </xsl:template>
    
<!--    <xsl:template match="lcOpenQuestion2" mode="new_learning_question">
        <xsl:param name="unit"/>
        <xsl:param name="q_number"/>
        <xsl:param name="task_number"/>
        
        <extendedTextInteraction responseIdentifier="{concat('Q',$q_number)}" minStrings="1"
            textFormat="plain">
            <!-\- Detect if the lcQuestion2 contains its own paragraphs, or if it's just plain text. -\->
            <xsl:choose>
                <xsl:when test="lcQuestion2/node()[self::text()]">
                    <prompt>
                        <p>
                            <xsl:apply-templates select="lcQuestion2"/>
                        </p>
                    </prompt>
                </xsl:when>
                <xsl:otherwise>
                    <!-\-                    <xsl:comment>lcQuestion2 with block elements.</xsl:comment>-\->
                    <prompt>
                        <xsl:apply-templates select="lcQuestion2/*" mode="identity">
                            <xsl:with-param name="type" select="'question'"/>
                        </xsl:apply-templates>
                    </prompt>
                </xsl:otherwise>
            </xsl:choose>
            
        </extendedTextInteraction>
    </xsl:template>
-->
    <xsl:template match="lcOpenQuestion2" mode="new_multipart_learning_question">
        <xsl:param name="unit"/>
        <xsl:param name="q_number"/>
        <xsl:param name="subq_number"/>
        <xsl:param name="task_number"/>
        
        <extendedTextInteraction responseIdentifier="{concat('Q',$q_number,$subq_number)}" minStrings="1"
            textFormat="plain">
            <!-- Detect if the lcQuestion2 contains its own paragraphs, or if it's just plain text. -->
            <xsl:choose>
                <xsl:when test="lcQuestion2/node()[self::text()]">
                    <prompt>
                        <p>
                            <xsl:apply-templates select="lcQuestion2"/>
                        </p>
                    </prompt>
                </xsl:when>
                <xsl:otherwise>
                    <!--                    <xsl:comment>lcQuestion2 with block elements.</xsl:comment>-->
                    <prompt>
                        <xsl:apply-templates select="lcQuestion2/*" mode="identity">
                            <xsl:with-param name="type" select="'question'"/>
                        </xsl:apply-templates>
                    </prompt>
                </xsl:otherwise>
            </xsl:choose>
            
        </extendedTextInteraction>
    </xsl:template>
    
    <!-- Updated 6/1/2017 psb-->
    <xsl:template match="lcFeedbackCorrect2|lcOpenAnswer2">
        <!-- lcFeedbackCorrect2 may contain normal elements, or it might contain text (without a wrapping element), 
            in which case, it might contain "Reference:". If it contains "Reference:", it needs to be divided into 
            two paragraphs (text up to "Reference:" in one and "Reference:" and the remaining text in another. -->


        <!--
        
        <p>The correct answer is &#34;Consolidating material and equipment costs and
            committing these monies the first time the item is required&#34;. Only the consolidation of
            M&#38;E cost is a procurement action. The other answers are scope, quality, and risk
            actions.</p>
        <p>Reference: <i>A Guide to the Project Management Body of Knowledge (PMBOK&#174;
            Guide)</i>&#8212;Fourth Edition, Chapter 12, Section 12.3.</p>
-->
        <xsl:choose>
            <xsl:when test="node()[self::text()]">
                <xsl:comment>lcFeedbackCorrect2 containing text.</xsl:comment>

                <!-- Gather all the current nodes. -->
                <xsl:variable name="nodes" as="node()*">
                    <xsl:copy-of select="."/>
                    <!--                    <xsl:choose>
                        <xsl:when test="p and count(p) = 1">
                            <xsl:copy-of select="p/node()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:copy-of select="."/>
                        </xsl:otherwise>
                    </xsl:choose>-->
                </xsl:variable>
                <!--        <xsl:message>count of nodes is <xsl:value-of select="count($nodes)"/>.</xsl:message>
        <xsl:message>content of nodes is <xsl:copy-of select="$nodes"/></xsl:message>-->
                <!-- Create a map indicating where the "Reference" is. -->
                <xsl:variable name="node_map">
                    <xsl:call-template name="build_reference_map">
                        <xsl:with-param name="nodes" select="$nodes"/>
                    </xsl:call-template>
                </xsl:variable>
                <!--        <xsl:comment>Node map is "<xsl:value-of select="$node_map"/>"</xsl:comment>            -->
                <xsl:choose>
                    <xsl:when test="contains($node_map,'R')">
                        <xsl:variable name="R_pos"
                            select="string-length(substring-before($node_map,'R')) + 1"/>
                        <p>
                            <xsl:apply-templates select="$nodes/node()[position() &lt;= $R_pos]"
                                mode="before_reference"/>
                        </p>
                        <p>
                            <xsl:apply-templates select="$nodes/node()[position() &gt;= $R_pos]"
                                mode="after_reference"/>
                        </p>
                    </xsl:when>
                    <xsl:otherwise>
                        <p>
                            <xsl:apply-templates select="$nodes" mode="identity"/>
                        </p>
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:when>
            <xsl:otherwise>
                <!--<xsl:comment>lcFeedbackCorrect2 or lcOpenAnswer2 containing elements.</xsl:comment>-->
                <xsl:apply-templates select="*" mode="identity">
                    <xsl:with-param name="type" select="'question'"/>
                </xsl:apply-templates>
            </xsl:otherwise>

        </xsl:choose>

    </xsl:template>
    <xsl:template match="node()" mode="before_reference">
        <xsl:choose>
            <xsl:when test="self::text() and contains(.,'Reference:')">
                <xsl:value-of select="substring-before(.,'Reference:')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="identity">
                    <xsl:with-param name="type" select="'question'"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="node()" mode="after_reference">
        <xsl:choose>
            <xsl:when test="self::text() and contains(.,'Reference:')">
                <xsl:text>Reference: </xsl:text>
                <xsl:value-of select="substring-after(.,'Reference: ')"/>
            </xsl:when>
            <xsl:otherwise>
                <!--                <xsl:message>Handling node: <xsl:value-of select="."/></xsl:message>-->
                <xsl:apply-templates select="." mode="identity">
                    <xsl:with-param name="type" select="'question'"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- These should be handled by identity... -->
    <!--    <xsl:template match="@*|node()" mode="reference">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="reference"/>
        </xsl:copy>
    </xsl:template>
    <xsl:template match="ph" mode="reference">
            <xsl:apply-templates select="node()" mode="reference"/>
    </xsl:template>
    <xsl:template match="cite" mode="reference">
        <i>
            <xsl:apply-templates select="node()" mode="reference"/>
        </i>
    </xsl:template>
    <xsl:template match="@class" mode="reference"/>
    <xsl:template match="@xtrf" mode="reference"/>
    <xsl:template match="@xtrc" mode="reference"/>
    
    
-->
    <xsl:template name="build_reference_map">
        <xsl:param name="nodes" as="node()*"/>
        <xsl:for-each select="$nodes/node()">
            <xsl:choose>
                <xsl:when test="self::text()">
                    <xsl:choose>
                        <xsl:when test="contains(.,'Reference: ')">
                            <xsl:text>R</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>.</xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>.</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="lcAnswerOption2" mode="get_choice">
        <xsl:variable name="map_index" select="count(preceding-sibling::lcAnswerOption2) + 1"/>
        <xsl:variable name="identifier">
            <xsl:number value="$map_index" format="A"/>
        </xsl:variable>
        <simpleChoice xmlns="http://www.imsglobal.org/xsd/imsqti_v2p1" identifier="{$identifier}">
            <xsl:apply-templates select="lcAnswerContent2" mode="identity">
                <xsl:with-param name="type" select="'question'"/>
            </xsl:apply-templates>
        </simpleChoice>
    </xsl:template>

    <xsl:template match="lcAnswerContent2" mode="identity" priority="100">
        <xsl:param name="type"/>

        <xsl:apply-templates mode="identity">
            <xsl:with-param name="type" select="$type"/>
        </xsl:apply-templates>

    </xsl:template>

    <xsl:template match="p[pointValue]" mode="identity" priority="100">
        <!-- Do nothing. -->
    </xsl:template>

    <xsl:template match="pointValue" mode="identity" priority="100">
        <!-- Do nothing. -->
    </xsl:template>

    <xsl:template name="get_correct_single">
        <correctResponse xmlns="http://www.imsglobal.org/xsd/imsqti_v2p1">
            <value>
                <xsl:variable name="correct_index"
                    select="count(lcAnswerOptionGroup2/lcAnswerOption2[lcCorrectResponse2]/preceding-sibling::lcAnswerOption2) + 1"/>
                <xsl:number value="$correct_index" format="A"/>
            </value>
        </correctResponse>
    </xsl:template>
    
    <!--    testing for MS MC Questions-->
    <xsl:template name="get_correct_MS">
        <correctResponse xmlns="http://www.imsglobal.org/xsd/imsqti_v2p1">
            <xsl:for-each select="lcAnswerOptionGroup2/lcAnswerOption2[lcCorrectResponse2]">
            <value>
                <xsl:variable name="correct_index"
                    select="count(preceding-sibling::lcAnswerOption2) + 1"/>
                <xsl:number value="$correct_index" format="A"/>
            </value>
            </xsl:for-each>
        </correctResponse>
    </xsl:template>

    <!-- When dealing in multipart questions, the xpaths are slightly different. -->
    <xsl:template name="get_correct_multiple">
        <correctResponse>
            <value>
                <xsl:variable name="correct_index"
                    select="count(descendant::lcAnswerOption2[lcCorrectResponse2]/preceding-sibling::lcAnswerOption2) + 1"/>
                <xsl:number value="$correct_index" format="A"/>
            </value>
        </correctResponse>
    </xsl:template>
    
    <xsl:template match="lcAnswerOption2" mode="get_mapEntry">
        <xsl:variable name="map_index" select="count(preceding-sibling::lcAnswerOption2) + 1"/>
        <xsl:variable name="mapKey">
            <xsl:number value="$map_index" format="A"/>
        </xsl:variable>
        <xsl:variable name="mappedValue">
            <xsl:choose>
                <!--  psb added p  2/1/16            -->
                <xsl:when
                    test="lcAnswerContent2/p/pointValue/@value">
                    <xsl:value-of select="lcAnswerContent2/p/pointValue/@value"/>
                </xsl:when>
                <xsl:when
                    test="lcAnswerContent2/pointValue/@value">
                    <xsl:value-of select="lcAnswerContent2/pointValue/@value"/>
                </xsl:when>
<xsl:otherwise>
                    <xsl:value-of select="'0'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <mapEntry xmlns="http://www.imsglobal.org/xsd/imsqti_v2p1" mapKey="{$mapKey}" mappedValue="{$mappedValue}"/>
    </xsl:template>
    
    <!--psb: this has to stay as p/pointvalue/@value to get this mappedValue chunk to come through vignettes correctly-->
    <xsl:template match="lcQuestion2" mode="get_mapEntry_open">
        
        <xsl:variable name="mappedValue">
            <xsl:choose>
                <xsl:when test="p/pointValue/@value">
                    <xsl:value-of select="p/pointValue/@value"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'0'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <mapEntry xmlns="http://www.imsglobal.org/xsd/imsqti_v2p1" mapKey="OPENQUESTION" mappedValue="{$mappedValue}"/>
    </xsl:template>
    
    <!-- #### NEW EXAM TASK ###################################################################### -->
    <xsl:template match="/" mode="new_exam_task">
        <xsl:param name="unit"/>
        <xsl:param name="task_number"/>
        <xsl:param name="exam_number"/>
        <xsl:param name="topic_id"/>
        <xsl:param name="navtitle"/>
        
        <!--        <xsl:param name="question_item"/>-->
        <xsl:apply-templates select="*[contains(@class,' topic/topic ')]" mode="new_exam_task">
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="task_number" select="$task_number"/>
            <xsl:with-param name="exam_number" select="$exam_number"/>
            <xsl:with-param name="topic_id" select="$topic_id"/>
            <xsl:with-param name="navtitle" select="$navtitle"/>
            <!--            <xsl:with-param name="question_item" select="$question_item"/>-->
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/topic ')]" mode="new_exam_task">
        <xsl:param name="unit"/>
        <xsl:param name="task_number"/>
        <xsl:param name="exam_number"/>
        <xsl:param name="topic_id"/>
        <xsl:param name="navtitle"/>
        
        <!--        <xsl:param name="question_item"/>-->

        <xsl:variable name="final"
            select="contains(*[contains(@class,' topic/title ')]/text(),'Final')"/>
        <xsl:variable name="unit_only" select="substring-after($unit,'.')"/>

        <xsl:variable name="label">
            <xsl:call-template name="get_label">
                <xsl:with-param name="task_category"
                    select="descendant-or-self::lmsCategory[1]/@value"/>
            </xsl:call-template>
        </xsl:variable>

        <kaptask>
            <xsl:attribute name="id">
                <xsl:value-of select="$topic_id"/>
            </xsl:attribute>
            <xsl:value-of select="$newline"/>
            <xsl:comment>Source file (new_exam_task): <xsl:value-of select="@xtrf"/>.</xsl:comment>
            <xsl:value-of select="$newline"/>
            
            <xsl:choose>
                <xsl:when test="not(empty($navtitle))">
                    <title>
                        <xsl:apply-templates select="$navtitle" mode="identity"/>
                    </title>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="new_tt_common">
                        <xsl:with-param name="prefix">
                            <xsl:value-of select="concat($label,' &gt; ')"/>
                        </xsl:with-param>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
            <prolog>
                <metadata>
                    <othermeta name="duration">
                        <xsl:attribute name="content">
                            <xsl:choose>
                                <xsl:when test="descendant::duration[1]/@value">
                                    <xsl:value-of select="descendant::duration[1]/@value"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>00:00</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                            <!--                            <xsl:value-of
                                select="*[contains(@class,' topic/prolog ')]/*[contains(@class,' topic/metadata ')]/*[contains(@class,' kpe-durationMeta-d/duration ')]/@value"
                            />-->
                        </xsl:attribute>
                    </othermeta>
                </metadata>
            </prolog>
            <shortdesc>
                <xsl:choose>
                    <xsl:when test="$final">
                        <xsl:value-of select="concat('Final Exam ',$unit)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('Unit Exam ',$unit_only,'.',$exam_number)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </shortdesc>
            <body>
                <xsl:apply-templates select="*[contains(@class,' topic/body ')]/node()"
                    mode="identity">
                    <xsl:with-param name="type" select="'topic'"/>
                </xsl:apply-templates>
                <xsl:call-template name="check_footnotes"/>

            </body>
        </kaptask>
    </xsl:template>

    <!-- #### NEW CONCEPT ###################################################################### -->
    <xsl:template match="/" mode="new_concept">
        <xsl:param name="unit"/>
        <xsl:param name="topic_id"/>
        <xsl:param name="task_category"/>
        <xsl:param name="navtitle"/>

        <xsl:apply-templates select="*[contains(@class,' topic/topic ')]" mode="new_concept">
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="topic_id" select="$topic_id"/>
            <xsl:with-param name="task_category" select="$task_category"/>
            <xsl:with-param name="navtitle" select="$navtitle"/>
        </xsl:apply-templates>
    </xsl:template>    
    
    <xsl:template match="*[contains(@class,' topic/topic ')]" mode="new_concept">
        <xsl:param name="unit"/>
        <xsl:param name="topic_id"/>
        <xsl:param name="task_category"/>
        <xsl:param name="navtitle"/>

        <xsl:call-template name="get_label">
            <xsl:with-param name="task_category"/>
        </xsl:call-template>


        <!--        <xsl:variable name="category" select="descendant::lmsCategory[1]/@value"/>
        <xsl:variable name="category_init_cap"
            select="concat(upper-case(substring($category,1,1)),lower-case(substring($category,2)))"/>-->
        <xsl:variable name="label">
            <xsl:call-template name="get_label">
                <xsl:with-param name="task_category" select="descendant::lmsCategory[1]/@value"/>
            </xsl:call-template>
        </xsl:variable>

        <topic>
            <xsl:attribute name="id">
                <!-- MREP: id now comes from id of source. -->
                <xsl:value-of select="$topic_id"/>
                <!--                <xsl:value-of select="$topic_id"/>-->
            </xsl:attribute>
            <xsl:value-of select="$newline"/>
            <xsl:comment>Source file (new_concept): <xsl:value-of select="@xtrf"/>.</xsl:comment>
            <xsl:value-of select="$newline"/>

            <xsl:choose>
                <xsl:when test="not(empty($navtitle))">
                    <title>
                        <xsl:apply-templates select="$navtitle" mode="identity"/>
                    </title>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="new_tt_common"/>
                </xsl:otherwise>
            </xsl:choose>

            <prolog>
                <metadata>
                    <xsl:variable name="lmsCategory" select="descendant::lmsCategory[1]/@value"/>
                    <xsl:variable name="completion" select="descendant::completion[1]/@value"/>
                    <category>
                        <xsl:choose>
                            <xsl:when test="$lmsCategory = 'activity' and $completion = 'manual'">
                                <xsl:text>reading</xsl:text>
                            </xsl:when>
                            <xsl:when test="$lmsCategory = 'reading' and $completion = 'auto'">
                                <xsl:text>default</xsl:text>
                            </xsl:when>
                            <xsl:when test="$lmsCategory != ''">
                                <xsl:value-of select="$lmsCategory"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>default</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </category>
                    <!-- <xsl:variable name="completion" select="descendant::completion[1]/@value"/>-->
                    <!-- Just add in the category anyway. -->
                    <!--<category>default</category>-->
                    <!--                    <xsl:if test="$completion = 'auto' and $task_category = 'page_turner'">
                        <category>
                            <xsl:text>default</xsl:text>
                        </category>
                    </xsl:if>-->
                    <othermeta name="duration">
                        <xsl:attribute name="content">
                            <xsl:choose>
                                <xsl:when test="descendant::duration[1]/@value">
                                    <xsl:value-of select="descendant::duration[1]/@value"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>00:00</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </othermeta>
                </metadata>
            </prolog>
            <body>
                <xsl:apply-templates select="*[contains(@class,' topic/body ')]/node()"
                    mode="identity">
                    <xsl:with-param name="type" select="'topic'"/>
                </xsl:apply-templates>
                <xsl:call-template name="check_footnotes"/>
            </body>
        </topic>
    </xsl:template>
    
    <!-- #### NEW LOS (MASTER) ###################################################################### -->
    <xsl:template match="/" mode="new_los_master">
        <xsl:param name="title"/>
        <xsl:apply-templates select="*[contains(@class,' topic/topic ')]" mode="new_los_master">
            <xsl:with-param name="title" select="$title"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/topic ')]" mode="new_los_master">
        <xsl:param name="title"/>
        <xsl:variable name="blooms" select="descendant::BloomsTaxonomy[1]/@value"/>
        <xsl:variable name="category" select="descendant::lmsCategory[1]/@value"/>
        <xsl:variable name="category_init_cap"
            select="concat(upper-case(substring($category,1,1)),lower-case(substring($category,2)))"/>
        <learningOverview>
            <xsl:attribute name="id">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
            <xsl:value-of select="$newline"/>
            <xsl:comment>Source file (new_los_master): <xsl:value-of select="@xtrf"/>.</xsl:comment>
            <xsl:value-of select="$newline"/>

            <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="new_tt_common"/>
            <!--            <title>
<!-\-                <xsl:value-of select="$title"/>-\->
            </title>-->
            <!-- [SP] 12-Jan-15 sfb: No longer need shortdesc on learning overviews;
                       commented out. -->
            <!--            <shortdesc>
                <xsl:value-of select="$title"/>
            </shortdesc>-->
            <xsl:choose>
                <xsl:when test="descendant::BloomsTaxonomy">
                    <prolog>
                        <metadata>
                            <BloomsTaxonomy>
                                <xsl:value-of select="$blooms"/>
                            </BloomsTaxonomy>
                        </metadata>
                    </prolog>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
            <learningOverviewBody>
                <lcObjectives>
                    <lcObjectivesStem>
                        <xsl:text>After successfully completing this unit, you should be able to:</xsl:text>
                    </lcObjectivesStem>
                    <lcObjectivesGroup>
                        <lcObjective>
                            <xsl:apply-templates
                                select="descendant::*[contains(@class,' learningBase/lcObjective ')]/*[contains(@class,' topic/ph ')]"
                            />
                        </lcObjective>
                    </lcObjectivesGroup>
                </lcObjectives>
            </learningOverviewBody>
        </learningOverview>
    </xsl:template>


    <!-- #### NEW LOS OVERVIEW ###################################################################### -->
    <xsl:template match="/" mode="new_los_overview">
        <xsl:param name="unit"/>
        <xsl:param name="navtitle"/>
        
        <xsl:apply-templates select="*[contains(@class,' topic/topic ')]" mode="new_los_overview">
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="navtitle" select="$navtitle"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/topic ')]" mode="new_los_overview">
        <xsl:param name="unit"/>
        <xsl:param name="navtitle"/>
        <!--        psb added this 6-1-2017-->
        <xsl:param name="topic_id"/>
        <!--        <xsl:variable name="category" select="descendant::lmsCategory[1]/@value"/>
        <xsl:variable name="category_init_cap"
            select="concat(upper-case(substring($category,1,1)),lower-case(substring($category,2)))"/>-->
        <xsl:variable name="label">
            <xsl:call-template name="get_label">
                <xsl:with-param name="task_category" select="descendant::lmsCategory[1]/@value"/>
            </xsl:call-template>
        </xsl:variable>

        <topic>
            <xsl:attribute name="id">
                <!--                psb updated this next line to fix ID not updating on los overviews 6/1/2017-->
            <xsl:value-of select="$topic_id"/>
                <!--<xsl:value-of select="@id"/>-->
            </xsl:attribute>
            <xsl:value-of select="$newline"/>
            <xsl:comment>Source file (new_los_overview): <xsl:value-of select="@xtrf"/>.</xsl:comment>
            <xsl:value-of select="$newline"/>
            <xsl:choose>
                <xsl:when test="not(empty($navtitle))">
                    <title>
                        <xsl:apply-templates select="$navtitle" mode="identity"/>
                    </title>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="new_tt_common"/>
                </xsl:otherwise>
            </xsl:choose>
            <prolog>
                <metadata>
                    <xsl:variable name="lmsCategory" select="descendant::lmsCategory[1]/@value"/>
                    <xsl:variable name="completion" select="descendant::completion[1]/@value"/>
                    <category>
                        <xsl:choose>
                            <xsl:when test="$lmsCategory = 'activity' and $completion = 'manual'">
                                <xsl:text>reading</xsl:text>
                            </xsl:when>
                            <xsl:when test="$lmsCategory = 'reading' and $completion = 'auto'">
                                <xsl:text>default</xsl:text>
                            </xsl:when>
                            <xsl:when test="$lmsCategory != ''">
                                <xsl:value-of select="$lmsCategory"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>default</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </category>
                    <othermeta name="duration">
                        <xsl:attribute name="content">
                            <xsl:choose>
                                <xsl:when test="descendant::duration[1]/@value">
                                    <xsl:value-of select="descendant::duration[1]/@value"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>00:00</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </othermeta>
                </metadata>
            </prolog>
            <!--  Doesn't seem like the shortdesc is covered in the spec, so I'm leaving it out for now. -->
            <!--            <shortdesc>
                <xsl:value-of select="concat($category_init_cap,' ',$unit)"/>
            </shortdesc>-->
            <body>
                <xsl:apply-templates select="*[contains(@class,' topic/body ')]/node()"
                    mode="identity">
                    <xsl:with-param name="type" select="'overview'"/>
                </xsl:apply-templates>
                <xsl:call-template name="check_footnotes"/>

            </body>
        </topic>
    </xsl:template>
    
    <!-- #### NEW SUMMARY ###################################################################### -->
    <xsl:template match="/" mode="new_summary">
        <xsl:param name="unit"/>
        <xsl:param name="navtitle"/>
        
        <xsl:apply-templates select="*[contains(@class,' topic/topic ')]" mode="new_summary">
            <xsl:with-param name="unit" select="$unit"/>
            <xsl:with-param name="navtitle" select="$navtitle"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/topic ')]" mode="new_summary">
        <xsl:param name="unit"/>
        <xsl:param name="navtitle"/>
        
           <!--        <xsl:variable name="category" select="descendant::lmsCategory[1]/@value"/>
        <xsl:variable name="category_init_cap"
            select="concat(upper-case(substring($category,1,1)),lower-case(substring($category,2)))"/>-->
        <xsl:variable name="label">
            <xsl:call-template name="get_label">
                <xsl:with-param name="task_category" select="descendant::lmsCategory[1]/@value"/>
            </xsl:call-template>
        </xsl:variable>

        <topic>
            <xsl:attribute name="id">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
            <xsl:value-of select="$newline"/>
            <xsl:comment>(new_summary) Source file: <xsl:value-of select="@xtrf"/>.</xsl:comment>
            <xsl:value-of select="$newline"/>
            <xsl:choose>
                <xsl:when test="not(empty($navtitle))">
                    <xsl:value-of select="$navtitle"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="new_tt_common"/>
                </xsl:otherwise>
            </xsl:choose>
            <prolog>
                <metadata>
                    <category>default</category>
                    <othermeta name="duration">
                        <xsl:attribute name="content">
                            <xsl:choose>
                                <xsl:when test="descendant::duration[1]/@value">
                                    <xsl:value-of select="descendant::duration[1]/@value"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>00:00</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:attribute>
                    </othermeta>
                </metadata>
            </prolog>
            <!--  Doesn't seem like the shortdesc is covered in the spec, so I'm leaving it out for now. -->
            <!--            <shortdesc>
                <xsl:value-of select="concat($category_init_cap,' ',$unit)"/>
            </shortdesc>-->

            <body>
                <xsl:apply-templates select="*[contains(@class,' topic/body ')]/node()"
                    mode="identity">
                    <xsl:with-param name="type" select="'summary'"/>
                </xsl:apply-templates>
                <xsl:call-template name="check_footnotes"/>

            </body>
        </topic>
    </xsl:template>

    <!-- #### COMMON ###################################################################### -->
    <xsl:template match="*[contains(@class,' topic/title ')]" mode="new_tt_common">
        <xsl:param name="prefix" select="''"/>
        <title>
            <xsl:value-of select="$prefix"/>
            <xsl:apply-templates mode="identity" xml:space="default"/>
        </title>
    </xsl:template>

    <xsl:template name="get_label">
        <xsl:param name="task_category" select="parent::*//lmsCategory[1]/@value"/>

        <xsl:choose>
            <xsl:when test="$task_category = 'reading' or $task_category = 'presentation'">
                <xsl:text>Prepare</xsl:text>
            </xsl:when>
            <xsl:when test="$task_category = 'activity' or $task_category = 'quiz'">
                <xsl:text>Practice</xsl:text>
            </xsl:when>
            <xsl:when test="$task_category = 'assignment' or $task_category = 'exam'">
                <xsl:text>Perform</xsl:text>
            </xsl:when>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="check_footnotes">
        <xsl:variable name="footnotes" select="descendant-or-self::*[contains(@class,' topic/fn ')]"/>

        <xsl:if test="count($footnotes) &gt; 0">
            <hr/>
            <xsl:apply-templates select="$footnotes" mode="footnotes"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/fn ')]" mode="footnotes">
        <xsl:variable name="topic_pos">
            <xsl:value-of select="count(preceding::*[contains(@class,' topic/fn ')]) + 1"/>
            <!--            <xsl:choose>
                <xsl:when test="@otherprops">
                    <xsl:value-of select="@otherprops"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-\- This topic wasn't chunked, so we need to count preceding footnotes now. -\->
                    <xsl:value-of select="count(preceding::*[contains(@class,' topic/fn ')]) + 1"/>
                </xsl:otherwise>
            </xsl:choose>-->
        </xsl:variable>
        <xsl:variable name="fn_offset">
            <xsl:call-template name="get_fn_offset"/>
        </xsl:variable>
        <!--        <xsl:message>topic_pos is <xsl:value-of select="$topic_pos"/>.</xsl:message>
        <xsl:message>fn_offset is <xsl:value-of select="$fn_offset"/>.</xsl:message>
        
-->
        <p>
            <sup>
                <xsl:value-of select="$topic_pos + $fn_offset"/>
            </sup>
            <xsl:apply-templates mode="identity"/>
        </p>
    </xsl:template>

    <xsl:template name="get_fn_offset">
        <xsl:variable name="topic_id" select="ancestor::*[contains(@class,' topic/topic ')]/@id"/>
        <xsl:variable name="topicref"
            select="$supermap/descendant::topicref[contains(@orig_href,concat($topic_id,'.dita'))]"/>
        <xsl:variable name="prev_fn_counts" select="$topicref/preceding-sibling::topicref/@fn_count"/>
        <!--        <xsl:message>prev_fn_counts for <xsl:value-of select="$topic_id"/> is "<xsl:value-of select="$prev_fn_counts"/>".</xsl:message>
        <xsl:message>sum of prev_fn_counts is <xsl:value-of select="sum($prev_fn_counts)"/>. </xsl:message>-->
        <xsl:value-of select="sum($prev_fn_counts)"/>

    </xsl:template>

    <!-- #### IDENTITY TRANSFORM ########################################################## -->
    <!-- Identity transform. -->
    <!-- Any template that wants to usurp functionality from this template must 
        use priority="100" and mode="identity". -->
    <xsl:template match="@*|node()[not(self::text())]" mode="identity">
        <xsl:param name="type"/>
        <xsl:copy exclude-result-prefixes="#all">
            <xsl:apply-templates select="@*|node()" mode="identity">
                <xsl:with-param name="type" select="$type"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <xsl:variable name="apos">&#39;</xsl:variable>
    <xsl:template match="text()" mode="#all">
        <xsl:variable name="string_1" select="replace(.,'&amp;','&amp;#038;')"/>
        <xsl:variable name="string_2" select="replace($string_1,'&lt;','&amp;#060;')"/>
        <xsl:variable name="string_3" select="replace($string_2,'&gt;','&amp;#062;')"/>
        <xsl:variable name="string_4" select="replace($string_3,'&#34;','&amp;#034;')"/>
        <xsl:variable name="string_5" select="replace($string_4,$apos,'&amp;#039;')"/>
        <xsl:variable name="string_6" select="replace($string_5,'-','&amp;#045;')"/>
        <xsl:variable name="string_7" select="translate($string_6,'&#10;',' ')"/>
        <xsl:variable name="string_8" select="replace($string_7,'  *',' ')"/>
        <!--        <xsl:message>Replaced characters in: <xsl:value-of select="$string_8"/>.</xsl:message>-->
        <xsl:value-of select="$string_8" disable-output-escaping="yes"/>
    </xsl:template>
	
	<!--MW updated so dash remains as dash in navtitle-->
	<xsl:template match="navtitle" mode="#all">
		<xsl:variable name="string_1" select="replace(.,'&amp;','&amp;#038;')"/>
		<xsl:variable name="string_2" select="replace($string_1,'&lt;','&amp;#060;')"/>
		<xsl:variable name="string_3" select="replace($string_2,'&gt;','&amp;#062;')"/>
		<xsl:variable name="string_4" select="replace($string_3,'&#34;','&amp;#034;')"/>
		<xsl:variable name="string_5" select="replace($string_4,$apos,'&amp;#039;')"/>
		<xsl:variable name="string_6" select="replace($string_5,'-','-')"/>
		<xsl:variable name="string_7" select="translate($string_6,'&#10;',' ')"/>
		<xsl:variable name="string_8" select="replace($string_7,'  *',' ')"/>
		<!--        <xsl:message>Replaced characters in: <xsl:value-of select="$string_8"/>.</xsl:message>-->
		<xsl:value-of select="$string_8" disable-output-escaping="yes"/>
	</xsl:template>

    <!-- kpe-assessmentOverviewBody -->
    <xsl:template match="*[contains(@class,' topic/body ')]" mode="identity" priority="100">
        <xsl:param name="type"/>

        <body>
            <xsl:apply-templates mode="identity">
                <xsl:with-param name="type" select="$type"/>
            </xsl:apply-templates>
            <xsl:call-template name="check_footnotes"/>

        </body>
    </xsl:template>

    <!-- Just ignore sections. -->
    <xsl:template match="section" mode="identity" priority="100">
        <xsl:param name="type"/>
        <xsl:apply-templates select="title" mode="PACE_section"/>
        <xsl:apply-templates select="node()[not(self::title)]" mode="identity">
            <xsl:with-param name="type" select="$type"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="title" mode="PACE_section" priority="100">
        <h3>
            <xsl:apply-templates mode="identity"/>
        </h3>
    </xsl:template>

    <xsl:template match="label" mode="identity" priority="100">
        <p>
            <strong>
                <xsl:apply-templates mode="identity"/>
            </strong>
        </p>
    </xsl:template>

    <xsl:template match="context" mode="identity" priority="100">
        <xsl:param name="type"/>
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates mode="identity">
                    <xsl:with-param name="type" select="$type"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:apply-templates mode="identity">
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:apply-templates>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- [SP] 2015-04-08: Divided up handing of video and flash objects. -->
    <xsl:template match="object" mode="identity" priority="100">
        <xsl:param name="type"/>
        <!-- video objects are distinguished from flash object by the presence of a codebase attribute in flash.-->
        <xsl:choose>
            <xsl:when test="@codebase">
                <xsl:call-template name="handle_flash_object">
                    <xsl:with-param name="type" select="$type"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="handle_video_object">
                    <xsl:with-param name="type" select="$type"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="handle_video_object">
        <xsl:param name="type"/>

        <xsl:value-of select="@codetype"/>
        <!-- [SP] 2015-04-13: Change of how video objects are handled. -->
        <!--        <data name="ucmsId">
            <xsl:attribute name="value">
                <xsl:value-of select="@classid"/>
            </xsl:attribute>
        </data>-->
        <xsl:apply-templates select="node()" mode="identity"/>
    </xsl:template>

    <!--    [psb] handle UCMS in vignettes-->
    <xsl:template match="object" mode="vignette" priority="100">
        <xsl:param name="type"/>
        <!-- video objects are distinguished from flash object by the presence of a codebase attribute in flash.-->
        <xsl:call-template name="handle_video_object">
            <xsl:with-param name="type" select="$type"/>
        </xsl:call-template>
    </xsl:template>
    

    <xsl:template name="handle_flash_object">
        <xsl:param name="type"/>

        <xsl:choose>
            <!-- Don't show objects in tasks. -->
            <xsl:when test="$type != 'task'">
                <xsl:copy>
                    <xsl:variable name="path">
                        <xsl:value-of select="replace(@data,'.*/(.*)$','/assets/$1')"/>
                    </xsl:variable>
                    <xsl:attribute name="data" select="$path"/>
                    <xsl:apply-templates select="@*[name() != 'data']" mode="identity"/>
                    <param value="{$path}" name="movie"/>
                    <param value="high" name="quality"/>
                    <param value="false" name="menu"/>
                    <param name="allowScriptAccess" value="always"/>
                    <param name="wmode" value="opaque"/>
                    <xsl:apply-templates select="node()" mode="identity"/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="descendant-or-self::text()">
                <!-- Output any text that might be in the object element. -->
                <xsl:apply-templates select="node()" mode="identity"/>
            </xsl:when>
            <xsl:otherwise>
                <!-- Do nothing.-->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="param" mode="identity" priority="100">
        <!-- Do nothing.-->
    </xsl:template>

    <xsl:template match="fig" mode="identity" priority="100">
        <xsl:param name="type"/>
        <div>
            <xsl:if test="@id">
                <xsl:attribute name="id">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
            </xsl:if>
            <!-- [SP] 2015-01-12: figure titles should use italics (em). -->
            <xsl:apply-templates select="title" mode="ital_title"/>
            <xsl:apply-templates select="node()[not(self::title)]" mode="identity">
                <xsl:with-param name="type" select="$type"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>

    <xsl:template match="title" mode="strong_title" priority="100">
        <p>
            <strong>
                <xsl:apply-templates mode="identity"/>
            </strong>
        </p>
    </xsl:template>
    <xsl:template match="title" mode="ital_title" priority="100">
        <p>
            <em>
                <xsl:apply-templates mode="identity"/>
            </em>
        </p>
    </xsl:template>

    <!-- Don't show images in tasks. -->
    <xsl:template match="image" mode="identity" priority="100">
        <xsl:param name="type"/>

        <!--        <xsl:comment>Handling image with type=<xsl:value-of select="$type"/>.</xsl:comment>-->
        <xsl:choose>
            <xsl:when test="@outputclass='print'">
                <!-- Do nothing. -->
            </xsl:when>
            <xsl:when test="$type != 'task'">
                <!-- Per Karissa: centered images need to be contained in <div align="center">...</div>. -->
                <xsl:choose>
                    <xsl:when test="@align='center'">
                        <div align="center">
                            <xsl:call-template name="handle_image">
                                <xsl:with-param name="type" select="$type"/>
                            </xsl:call-template>
                        </div>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="handle_image">
                            <xsl:with-param name="type" select="$type"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <!-- Do nothing. -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="handle_image">
        <xsl:param name="type"/>
        <xsl:choose>
            <xsl:when test="$type = 'question' or $type = 'assessment'">
                <img>
                    <xsl:attribute name="src">
                        <xsl:value-of select="replace(@href,'^.*/([^/]*)$','/assets/$1')"/>
                    </xsl:attribute>
                	<xsl:if test="alt">
                		<xsl:attribute name="alt">
                			<xsl:value-of select="alt"/>
                		</xsl:attribute>
                	</xsl:if>
                    <xsl:apply-templates select="@*[not(name() = 'href')]|node()" mode="identity">
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:apply-templates>
                </img>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:attribute name="href">
                        <xsl:value-of select="replace(@href,'^.*/([^/]*)$','/assets/$1')"/>
                    </xsl:attribute>
                    <xsl:attribute name="placement">break</xsl:attribute>
                    <xsl:apply-templates
                        select="@*[not(name() = 'href') and not(name()='outputclass') and not(name()='placement')]|node()"
                        mode="identity">
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:apply-templates>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
	
	<!-- ARV added on 09-10-2025 -->
	<xsl:template match="alt" mode="identity" priority="100">
		<xsl:param name="type"/>
		<!-- alt tag are for topic files only. For questions it should be an attribute. -->
		<xsl:if test="$type != 'question' and $type != 'assessment' ">
			<alt>
				<xsl:apply-templates mode="identity">
					<xsl:with-param name="type" select="$type"/>
				</xsl:apply-templates>
			</alt>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="callout" mode="identity" priority="100">
        <xsl:param name="type"/>
        <!-- Callouts are for InDesign only. Do nothing. -->
        <!--        <div>
            <xsl:apply-templates mode="identity">
                <xsl:with-param name="type" select="$type"/>
            </xsl:apply-templates>
        </div>
-->
    </xsl:template>

    <!--changed mode to "#all" to work in questions 5/25/2017-->
    <xsl:template match="equation-block" priority="100" mode="#all"><!-- mode="identity" -->
        <xsl:param name="type"/>
        <p style="margin-left:60px;">
            <xsl:apply-templates mode="identity">
                <xsl:with-param name="type" select="$type"/>
            </xsl:apply-templates>
        </p>
    </xsl:template>

    <!--added PSB 5/25/2017-->
    <xsl:template match="equation-figure" mode="#all" priority="100">
        <xsl:param name="type"/>
        <div style="margin-left:60px;">
            <xsl:apply-templates mode="identity">
                <xsl:with-param name="type" select="$type"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>

    <!--psb changed mode to "#all" to work in questions 5/25/2017-->
    <xsl:template match="sample" mode="#all" priority="100">
        <xsl:param name="type"/>
        <div style="margin-left:30px; margin-right:50px;">
            <xsl:apply-templates mode="identity">
                <xsl:with-param name="type" select="$type"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>
    
    <!--MW added for Securities additions for color-->
    <xsl:template match="sample [@othertype = 'example' or @outputclass = 'example']" mode="#all" priority="100">
        <xsl:param name="type"/>
        <div style="display:block; background-color: #C8E1FC; padding-top:5px; padding-bottom:10px; border-left-style:solid; border-left-color:#240F6E; border-left-width:8px; border-radius:5px;">
            <div style="margin-left:30px; margin-right:30px;">
                <xsl:apply-templates mode="identity">
                    <xsl:with-param name="type" select="$type"/>
                </xsl:apply-templates>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="sample [@othertype = 'take_note' or @outputclass = 'take_note']" mode="#all" priority="100">
        <xsl:param name="type"/>
        <div style="display:block; background-color: #C8E1C8; padding-top:5px; padding-bottom:10px; border-left-style:solid; border-left-color:#240F6E; border-left-width:8px; border-radius:5px;">
            <div style="margin-left:30px; margin-right:30px;">
                <xsl:apply-templates mode="identity">
                    <xsl:with-param name="type" select="$type"/>
                </xsl:apply-templates>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="sample [@othertype = 'test_topic_alert' or @outputclass = 'test_topic_alert']" mode="#all" priority="100">
        <xsl:param name="type"/>
        <div style="display:block; background-color: #F5CABF; padding-top:5px; padding-bottom:10px; border-left-style:solid; border-left-color:#240F6E; border-left-width:8px; border-radius:5px;">
            <div style="margin-left:30px; margin-right:30px;">
                <xsl:apply-templates mode="identity">
                    <xsl:with-param name="type" select="$type"/>
                </xsl:apply-templates>
            </div>
        </div>
    </xsl:template>
    
    <xsl:template match="sample [@othertype = 'practice_question' or @outputclass = 'practice_question']" mode="#all" priority="100">
        <xsl:param name="type"/>
        <div style="display:block; background-color: #F8E59A; padding-top:5px; padding-bottom:10px; border-left-style:solid; border-left-color:#240F6E; border-left-width:8px; border-radius:5px;">
            <div style="margin-left:30px; margin-right:30px;">
                <xsl:apply-templates mode="identity">
                    <xsl:with-param name="type" select="$type"/>
                </xsl:apply-templates>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="lq" mode="identity vignette" priority="100">
        <xsl:param name="type"/>
        <div style="margin-left:30px; margin-right:50px;">
            <xsl:choose>
                <xsl:when test="p">
                    <xsl:apply-templates mode="identity">
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <p>
                        <xsl:apply-templates mode="identity">
                            <xsl:with-param name="type" select="$type"/>
                        </xsl:apply-templates>
                    </p>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

    <!--PSB ADDED CENTER 5/4/16-->
    <xsl:template match="p[@outputclass = 'center']" mode="#all">
        <p align="center">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    <!--PSB ADDED LOS PARA AND NOTE PROCESSING-->
    <xsl:template match="p[@outputclass = 'los']" mode="#all">
        <h3>
            <xsl:apply-templates mode="identity"/>
        </h3>
    </xsl:template>
    <xsl:template match="note[@outputclass = 'los']" mode="#all">
        <h3>
            <xsl:apply-templates mode="identity"/>
        </h3>
    </xsl:template>
    
    
    <!-- UL should be passed with no attributes. -->
    <xsl:template match="ul" mode="identity" priority="100">
        <xsl:copy>
            <xsl:apply-templates mode="identity"/>
        </xsl:copy>
    </xsl:template>

    <!-- ol may have an outputclass, which needs to be output as @type, with modified values. -->
    <xsl:template match="ol" mode="identity vignette" priority="100">
        <xsl:copy>
            <xsl:choose>
                <xsl:when test="@outputclass">
                    <xsl:attribute name="type">
                        <xsl:choose>
                            <xsl:when test="@outputclass='ol_alpha'">
                                <xsl:text>A</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="@outputclass='ol_loweralpha'">
                                <xsl:text>a</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="@outputclass='ol_roman'">
                                <xsl:text>I</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="@outputclass='ol_lowerroman'">
                                <xsl:text>i</xsl:text>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates select="@*[not(name()='outputclass')]|node()" mode="identity"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="steps" mode="identity" priority="100">
        <xsl:param name="type"/>
        <ol>
            <xsl:apply-templates select="node()" mode="identity">
                <xsl:with-param name="type" select="$type"/>
            </xsl:apply-templates>
        </ol>
    </xsl:template>
    <xsl:template match="step" mode="identity" priority="100">
        <xsl:param name="type"/>
        <li>
            <xsl:apply-templates select="@*|node()" mode="identity">
                <xsl:with-param name="type" select="$type"/>
            </xsl:apply-templates>
        </li>
    </xsl:template>
    <xsl:template match="cmd" mode="identity" priority="100">
        <xsl:param name="type"/>
        <p>
            <xsl:apply-templates mode="identity">
                <xsl:with-param name="type" select="$type"/>
            </xsl:apply-templates>
        </p>
    </xsl:template>
    <!-- Info contains a <p> already, so just strip the info. -->
    <xsl:template match="info" mode="identity" priority="100">
        <xsl:param name="type"/>
        <xsl:apply-templates mode="identity">
            <xsl:with-param name="type" select="$type"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="result" mode="identity" priority="100">
        <xsl:param name="type"/>
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates mode="identity">
                    <xsl:with-param name="type" select="$type"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:apply-templates mode="identity">
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:apply-templates>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- [SP] 2015-04-14: Added processing for <desc> to <p> -->
    <xsl:template match="desc" mode="identity" priority="100">
        <xsl:param name="type"/>
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates mode="identity">
                    <xsl:with-param name="type" select="$type"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <p>
                    <xsl:apply-templates mode="identity">
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:apply-templates>
                </p>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
    <xsl:template match="*[contains(@class,' topic/ph ') and @outputclass='strike']">
        <span style="text-decoration: overline">
            <xsl:apply-templates/>
        </span>
    </xsl:template>-->
    
<!--    <xsl:template match="*[contains(@class,' topic/ph ') and @outputclass='strike']">
        <span style="text-decoration: line-through">
            <xsl:apply-templates/>
        </span>
    </xsl:template>-->
    


    <!-- If there's a ph with no attributes, throw it away. -->
    <xsl:template match="ph" mode="identity vignette" priority="100">
        <xsl:choose>
            <xsl:when test="@outputclass='strike'">
                <span style="text-decoration: line-through">
                    <xsl:apply-templates/>
                </span>
            </xsl:when>
            <xsl:when test="@outputclass='line_break'">
                <br/>
            </xsl:when>
            <xsl:when test="@outputclass='los'">
                <br/>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:when test="@outputclass='overline'">
                <span style="text-decoration: overline">
                    <xsl:apply-templates/>
                </span>
                </xsl:when>
            <xsl:when test="count(attribute::*) &gt; 3">
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()" mode="identity"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="@*|node()" mode="identity"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="cite" mode="#all" priority="100">
        <i>
            <xsl:apply-templates mode="identity"/>
        </i>
    </xsl:template>

    <!--PSB TESTING FOR LINE BREAK-->

    <!--    <xsl:template match="*[contains(@class,' topic/data ') and @name='line_break' and upper-case(@value)='Y']">
   <br/>
        <xsl:apply-templates mode="identity"/>
    </xsl:template>-->


    <!--  PSB UPDATED TMTYPE FUNCTIONALITY TO INCLUDE <sup> around (r)  -->
    <xsl:template match="*[contains(@class, ' topic/tm ')]" mode="#all" priority="10">
        <xsl:apply-templates/>
        <xsl:choose>
            <xsl:when test="@tmtype='service'">&#x2120;</xsl:when>
            <xsl:when test="@tmtype='tm'">&#8482;</xsl:when>
            <xsl:when test="@tmtype='reg'">
                <sup>&#174;</sup>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>[Error in tm type]</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <!--
 <xsl:template match="tm" mode="#all" priority="100">
        <xsl:variable name="content">
            <xsl:apply-templates mode="identity"/>
        </xsl:variable>
        <xsl:variable name="char">
            <xsl:choose>
                <xsl:when test="@tmtype = 'tm'">&#x2122;</xsl:when>
                <xsl:when test="@tmtype = 'reg'">&#xAE;</xsl:when>
                <xsl:when test="@tmtype = 'service'">&#x2120;</xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="concat(normalize-space($content),$char)"/>
    </xsl:template>-->

    <xsl:template match="xref" mode="identity" priority="100">
        <xsl:param name="type"/>

        <!--        <xsl:variable name="target_file" select="substring-before(@href,'#')"/>
        <xsl:variable name="target_ids" select="substring-after(@href,'#')"/>
        <xsl:comment>target_file is: "<xsl:value-of select="$target_file"/>".</xsl:comment>
        
        <xsl:variable name="target_type">
            <xsl:apply-templates select="document($target_file)" mode="get_target_type">
                <xsl:with-param name="target_ids" select="$target_ids"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:comment>target_type is: "<xsl:value-of select="$target_type"/>".</xsl:comment>
-->
        <xsl:choose>
            <!-- xrefs to figures should be title only. Need to add non-breaking space because LMS can't deal with things correctly -->
            <xsl:when test="contains(@href,'/fig_')">
                <xsl:text>&#160;</xsl:text>
                <strong>
                    <xsl:apply-templates/>
                </strong>
            </xsl:when>

            <xsl:when test="$type='task' or $type='overview'">
                <xsl:apply-templates mode="identity"/>
            </xsl:when>
            <xsl:when test="$type='topic'">
                <xref target="_blank">
                    <xsl:apply-templates select="@href|@scope|node()" mode="identity">
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:apply-templates>
                </xref>
            </xsl:when>
            <xsl:when test="$type='question' or $type='assessment'">
                <a target="_blank">
                    <xsl:apply-templates select="@href|node()" mode="identity">
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:apply-templates>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <xref target="_blank">
                    <xsl:apply-templates select="@*|node()" mode="identity">
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:apply-templates>
                </xref>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="*[contains(@class,' topic/fn ')]" mode="identity" priority="100">
        <!-- Generate a footnote reference. -->
        <xsl:variable name="topic_pos">
            <xsl:value-of select="count(preceding::*[contains(@class,' topic/fn ')]) + 1"/>
            <!--            <xsl:choose>
                <xsl:when test="@otherprops">
                    <xsl:value-of select="@otherprops"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-\- This topic wasn't chunked, so we need to count preceding footnotes now. -\->
                    <xsl:value-of select="count(preceding::*[contains(@class,' topic/fn ')]) + 1"/>
                </xsl:otherwise>
            </xsl:choose>-->
        </xsl:variable>
        <xsl:variable name="fn_offset">
            <xsl:call-template name="get_fn_offset"/>
        </xsl:variable>

        <sup>
            <xsl:value-of select="$topic_pos + $fn_offset"/>
        </sup>

    </xsl:template>


    <!-- GET TARGET TYPE -->

    <xsl:template match="/" mode="get_target_type">
        <xsl:param name="target_ids"/>

        <xsl:variable name="topic_id" select="substring-before($target_ids,'/')"/>
        <xsl:variable name="element_id" select="substring-after($target_ids,'/')"/>

        <xsl:value-of select="name(//*[@id = $element_id])"/>
    </xsl:template>

    <xsl:template match="/" mode="get_fig_title">
        <xsl:param name="target_ids"/>

        <xsl:variable name="topic_id" select="substring-before($target_ids,'/')"/>
        <xsl:variable name="element_id" select="substring-after($target_ids,'/')"/>

        <xsl:apply-templates select="*[@id = $element_id]/*[contains(@class,' topic/title ')]"/>
    </xsl:template>

    <!--psb added this for vignettes 6/1/17-->
    
    <xsl:template match="*[contains(@class,' topic/dl ')]" mode="vignette" priority="100">
        <xsl:apply-templates mode="identity"/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' topic/dlentry ')]" mode="vignette" priority="100">
        <xsl:apply-templates mode="identity"/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' topic/dt ')]" mode="vignette" priority="100"
        xml:space="default">
        <p>
            <strong>
                <xsl:choose>
                    <xsl:when test="count(ancestor::*[contains(@class,' topic/dl ')]) = 2"
                        xml:space="default">
                        <em>
                            <xsl:apply-templates mode="identity"/>
                        </em>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates mode="identity"/>
                    </xsl:otherwise>
                </xsl:choose>
            </strong>
        </p>
        </xsl:template>
    
    <xsl:template match="*[contains(@class,' topic/dd ')]" mode="vignette" priority="100">
        <xsl:apply-templates mode="identity"/>
    </xsl:template>
    
    <xsl:template match="image" mode="vignette">
        <xsl:param name="type"/>
                       <img>
            <xsl:attribute name="src">
                        <xsl:value-of select="replace(@href,'^.*/([^/]*)$','/assets/$1')"/>
                    </xsl:attribute>
        <xsl:apply-templates select="@*[not(name() = 'href')]|node()" mode="identity">
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:apply-templates>
                </img>
    </xsl:template>
    
    <xsl:template match="@href" mode="vignette" priority="100">
        <xsl:param name="type"/>
        <xsl:variable name="target">
            <!--            <xsl:message>determining target for <xsl:value-of select="@href"/>.</xsl:message>-->            
        <xsl:choose>
                <xsl:when test="contains(.,'/assets/core_content/digital/')">
                    <xsl:value-of select="replace(.,'^.*/assets/core_content/digital/','/assets/')"
                    />
                </xsl:when>
                <xsl:when test="contains(.,'/assets/digital/')">
                    <xsl:value-of select="replace(.,'^.*/assets/digital/','/assets/')"/>
                </xsl:when>
                <xsl:when test="contains(.,'/assets/core_content/')">
                    <xsl:value-of select="replace(.,'^.*/assets/core_content/','/assets/')"/>
                </xsl:when>
                <xsl:when test="matches(.,'^(\.\./)+assets/')">
                    <xsl:value-of select="replace(.,'^(\.\./)+assets/','/assets/')"/>
                </xsl:when>
                <xsl:when test="starts-with(.,'..')">
                    <xsl:value-of select="substring-after(.,'..')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
    <xsl:choose>
            <xsl:when test="parent::image and ($type = 'question' or $type='assessment')">
                <xsl:attribute name="src">
                    <xsl:value-of select="$target"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="href">
                    <xsl:value-of select="$target"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="xref" mode="vignette" priority="100">
        <xsl:param name="type"/>
        
        <!--        <xsl:variable name="target_file" select="substring-before(@href,'#')"/>
        <xsl:variable name="target_ids" select="substring-after(@href,'#')"/>
        <xsl:comment>target_file is: "<xsl:value-of select="$target_file"/>".</xsl:comment>
        
        <xsl:variable name="target_type">
            <xsl:apply-templates select="document($target_file)" mode="get_target_type">
                <xsl:with-param name="target_ids" select="$target_ids"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:comment>target_type is: "<xsl:value-of select="$target_type"/>".</xsl:comment>
-->
        <xsl:choose>
            <!-- xrefs to figures should be title only. Need to add non-breaking space because LMS can't deal with things correctly -->
            <xsl:when test="contains(@href,'/fig_')">
                <xsl:text>&#160;</xsl:text>
                <strong>
                    <xsl:apply-templates/>                    
                </strong>
            </xsl:when>
            <xsl:when test="$type='question' or $type='assessment'">
                <a target="_blank">
                    <xsl:apply-templates select="@href|node()" mode="identity">
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:apply-templates>                    
                </a>
            </xsl:when>
        <xsl:otherwise>
                <xref target="_blank">
                    <xsl:apply-templates select="@*|node()" mode="identity">
                        <xsl:with-param name="type" select="$type"/>
                    </xsl:apply-templates>
                </xref>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    

    <!--<xsl:template match="table" mode="vignette" priority="100">
        <table>
            <xsl:apply-templates select="title" mode="vignette"/>
            <xsl:apply-templates select="tgroup" mode="vignette"/>
        </table>
    </xsl:template>

    <xsl:template match="colspec" mode="vignette" priority="100">
        
        <!-\- Do nothing. -\->
    </xsl:template>

    <xsl:template match="title" mode="vignette" priority="100">
        <caption>
            <xsl:apply-templates/>
        </caption>
    </xsl:template>

    <xsl:template match="tgroup" mode="vignette" priority="100">
        <!-\- handle thead, and tbody -\->
        <xsl:apply-templates mode="vignette"/>
    </xsl:template>

    <xsl:template match="thead" mode="vignette" priority="100">
        <thead>
            <xsl:apply-templates mode="vignette"/>
        </thead>
    </xsl:template>

    <xsl:template match="tbody" mode="vignette" priority="100">
        <tbody>
            <xsl:apply-templates mode="vignette"/>
        </tbody>
    </xsl:template>

    <xsl:template match="row" mode="vignette" priority="100">
        <tr>
            <xsl:apply-templates mode="vignette"/>
        </tr>
    </xsl:template>

    <xsl:template match="entry" mode="vignette" priority="100">
        <xsl:choose>
            <xsl:when test="ancestor::thead">
                <th>
                    <xsl:apply-templates mode="identity"/>
                </th>
            </xsl:when>
            <xsl:otherwise>
                <td>
                    <xsl:apply-templates mode="identity"/>
                </td>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
-->

    <!-- Handle tables in PACE output. -->
    <xsl:template match="table" mode="identity vignette" priority="100">
        <xsl:apply-templates select="title" mode="PACE_table"/>
        <xsl:apply-templates select="tgroup" mode="PACE_table"/>
    </xsl:template>
    <xsl:template match="title" mode="PACE_table vignette">
        <caption align="top">
            <b>
                <xsl:apply-templates/>
            </b>
        </caption>
    </xsl:template>
    <xsl:template match="tgroup" mode="PACE_table vignette">
        <table>
           <!-- <xsl:attribute name="border">1</xsl:attribute>-->
            <!--            PSB Increased from 3 to 5 6/15/2017-->
            <xsl:attribute name="cellpadding">5</xsl:attribute>
            <xsl:choose>
                <xsl:when test="../@pgwide">
                    <xsl:attribute name="width">100%</xsl:attribute>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
            <xsl:variable name="colsep">
                <xsl:choose>
                    <xsl:when test="../@colsep">
                        <xsl:value-of select="../@colsep"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="rowsep">
                <xsl:choose>
                    <xsl:when test="../@rowsep">
                        <xsl:value-of select="../@rowsep"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="../@frame = 'all'">
                    <xsl:attribute name="frame">border</xsl:attribute>
                    <xsl:attribute name="border">1</xsl:attribute>
                <xsl:attribute name="bordercolor">#000000</xsl:attribute>
                </xsl:when>
                <xsl:when test="../@frame = 'sides'">
                    <xsl:attribute name="frame">vsides</xsl:attribute>
                    <xsl:attribute name="border">1</xsl:attribute>
                <xsl:attribute name="bordercolor">#000000</xsl:attribute>
                </xsl:when>
                <xsl:when test="../@frame = 'top'">
                    <xsl:attribute name="frame">above</xsl:attribute>
                    <xsl:attribute name="border">1</xsl:attribute>
                <xsl:attribute name="bordercolor">#000000</xsl:attribute>
                </xsl:when>
                <xsl:when test="../@frame = 'bottom'">
                    <xsl:attribute name="frame">below</xsl:attribute>
                    <xsl:attribute name="border">1</xsl:attribute>
                <xsl:attribute name="bordercolor">#000000</xsl:attribute>
                </xsl:when>
                <xsl:when test="../@frame = 'topbot'">
                    <xsl:attribute name="frame">hsides</xsl:attribute>
                    <xsl:attribute name="border">1</xsl:attribute>
                <xsl:attribute name="bordercolor">#000000</xsl:attribute>
                </xsl:when>
                <xsl:when test="../@frame = 'none'"> 
                <xsl:attribute name="frame">void</xsl:attribute>
                    <xsl:attribute name="border">0</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="frame">border</xsl:attribute>
                    <xsl:attribute name="border">1</xsl:attribute>
                <xsl:attribute name="bordercolor">#000000</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="$colsep = '0' and $rowsep = '0'">
                    <xsl:attribute name="rules">none</xsl:attribute>
                   </xsl:when>
                <xsl:when test="$colsep = '0'">
                    <xsl:attribute name="rules">rows</xsl:attribute>
                </xsl:when>
                <xsl:when test="$rowsep = '0'">
                    <xsl:attribute name="rules">cols</xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="rules">all</xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="thead" mode="PACE_table"/>
            <xsl:apply-templates select="tbody" mode="PACE_table"/>
        </table>
    </xsl:template>
    <xsl:template match="thead" mode="PACE_table vignette">
        <xsl:apply-templates select="row" mode="PACE_table_head"/>
    </xsl:template>
    <xsl:template match="row" mode="PACE_table_head vignette">
        <xsl:variable name="rowsep">
            <xsl:choose>
                <xsl:when test="../@rowsep">
                    <xsl:value-of select="../@rowsep"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <xsl:choose>
                <xsl:when test="@rowsep = '1'">
                    <xsl:attribute name="class">border_bottom</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates select="entry" mode="PACE_table_head"/>
        </tr>
    </xsl:template>
    <xsl:template match="entry" mode="PACE_table_head vignette">
        <th bgcolor="#cccccc">
            <xsl:choose>
                <xsl:when test="@align">
                      <xsl:attribute name="align">
                    <xsl:value-of select="@align"/>
                </xsl:attribute>
                </xsl:when>
                <!--                PSB changed default from left to center 6/15/2017 -->
                <xsl:otherwise>
                    <xsl:attribute name="align">center</xsl:attribute>   
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="@valign">
                <xsl:attribute name="valign">
                    <xsl:value-of select="@valign"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="@morerows">
                <xsl:attribute name="rowspan"> <!-- set the number of rows to span -->
                    <xsl:value-of select="@morerows+1"/>
                </xsl:attribute>
            </xsl:if>
                        <xsl:choose>
                <!--<xsl:when test="@rowsep = '0' and @colsep = '0'">
                    <xsl:apply-templates/>
                </xsl:when>-->
                
                <xsl:when test="@rowsep = '1' and @colsep = '1'">
                   <xsl:attribute name="class">border_bottom border_right</xsl:attribute>
                </xsl:when>
                <xsl:when test="@rowsep = '1'">
                    <xsl:attribute name="class">border_bottom</xsl:attribute>
                </xsl:when>
                <xsl:when test="@rowsep = '1' and @colsep = '0'">
                    <xsl:attribute name="class">border_bottom</xsl:attribute>
                </xsl:when>
                <xsl:when test="@rowsep = '1' and @colsep = '0'">
                    <xsl:attribute name="class">border_bottom</xsl:attribute>
                </xsl:when>
                <xsl:when test="@colsep = '1'">
                    <xsl:attribute name="class">border_right</xsl:attribute>
                </xsl:when>
                <xsl:when test="@rowsep = '0' and @colsep = '1'">
                    <xsl:attribute name="class">border_right</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="@namest and @nameend">
                <xsl:attribute name="colspan">
                    <xsl:call-template name="find-colspan"/>
                </xsl:attribute>
            </xsl:if>
            
            <xsl:if test="../../../*[contains(@class, ' topic/colspec ')]/@colwidth and
                not(@namest) and not(@nameend) and not(@spanspec)">
                <xsl:variable name="entrypos">    <!-- Current column -->
                    <xsl:call-template name="find-entry-start-position"/>
                </xsl:variable>
                <xsl:variable name="colspec" select="../../../*[contains(@class, ' topic/colspec ')][number($entrypos)]"/>
                <xsl:variable name="totalwidth">  <!-- Total width of the column, in units -->
                    <xsl:apply-templates select="../../../*[contains(@class, ' topic/colspec ')][1]" mode="count-colwidth"/>
                </xsl:variable>
                <xsl:variable name="proportionalWidth" select="contains($colspec/@colwidth, '*')"/>
                <xsl:variable name="thiswidth">   <!-- Width of this column, in units -->
                    <xsl:choose>
                        <xsl:when test="$colspec/@colwidth">
                            <xsl:choose>
                                <xsl:when test="$proportionalWidth">
                                    <!--<xsl:value-of select="substring-before($colspec/@colwidth, '*')"/>-->
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$colspec/@colwidth"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>1</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <!-- Width = width of this column / width of table, times 100 to make a percent -->
                <xsl:attribute name="width">
                 <!--   <xsl:choose>
                        <xsl:when test="$proportionalWidth">
                            <xsl:value-of select="($thiswidth div $totalwidth) * 100"/>
                            <xsl:text>%</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>-->
                            <xsl:value-of select="$thiswidth"/>
                        <!--</xsl:otherwise>
                    </xsl:choose>-->
                </xsl:attribute>
            </xsl:if>  
            
            
            <xsl:apply-templates mode="identity"/>
        </th>
    </xsl:template>


    <xsl:template match="tbody" mode="PACE_table vignette">
        <xsl:apply-templates select="row" mode="PACE_table_body"/>
    </xsl:template>


    <xsl:template match="row" mode="PACE_table_body vignette">
        <xsl:variable name="rowsep">
            <xsl:choose>
                <xsl:when test="../@rowsep">
                    <xsl:value-of select="../@rowsep"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <tr>
            <xsl:choose>
                <xsl:when test="@rowsep = '1'">
                    <xsl:attribute name="class">border_bottom</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates select="entry" mode="PACE_table_body"/>
        </tr>
    </xsl:template>

    <!--PSB 6-1 added alignment for table entries    -->
    <xsl:template match="entry" mode="PACE_table_body vignette">

        <td>
            <xsl:if test="@align">
                <xsl:attribute name="align">
                    <xsl:value-of select="@align"/>
                </xsl:attribute>
                </xsl:if>
            <xsl:if test="@valign">
                <xsl:attribute name="valign">
                    <xsl:value-of select="@valign"/>
                </xsl:attribute>
            </xsl:if>
             
            <xsl:if test="@morerows">
                <xsl:attribute name="rowspan"> <!-- set the number of rows to span -->
                    <xsl:value-of select="@morerows+1"/>
                </xsl:attribute>
            </xsl:if>
            
            <xsl:choose>
            	<!-- ARV:11-07-2025 Commented-out because it is redundant -->
                <!--<xsl:when test="@rowsep = '0' and @colsep = '0'">
                    <xsl:apply-templates/>
                </xsl:when>-->
                
                <xsl:when test="@rowsep = '1' and @colsep = '1'">
                    <xsl:attribute name="class">border_bottom border_right</xsl:attribute>
                </xsl:when>
                <xsl:when test="@rowsep = '1'">
                    <xsl:attribute name="class">border_bottom</xsl:attribute>
                </xsl:when>
                <xsl:when test="@rowsep = '1' and @colsep = '0'">
                    <xsl:attribute name="class">border_bottom</xsl:attribute>
                </xsl:when>
                <xsl:when test="@rowsep = '1' and @colsep = '0'">
                    <xsl:attribute name="class">border_bottom</xsl:attribute>
                </xsl:when>
                <xsl:when test="@colsep = '1'">
                    <xsl:attribute name="class">border_right</xsl:attribute>
                </xsl:when>
                <xsl:when test="@rowsep = '0' and @colsep = '1'">
                    <xsl:attribute name="class">border_right</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="@namest and @nameend">
                <xsl:attribute name="colspan">
                    <xsl:call-template name="find-colspan"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="../../../*[contains(@class, ' topic/colspec ')]/@colwidth and
                not(@namest) and not(@nameend) and not(@spanspec)">
                <xsl:variable name="entrypos">    <!-- Current column -->
                    <xsl:call-template name="find-entry-start-position"/>
                </xsl:variable>
                <xsl:variable name="colspec" select="../../../*[contains(@class, ' topic/colspec ')][number($entrypos)]"/>
                <xsl:variable name="totalwidth">  <!-- Total width of the column, in units -->
                    <xsl:apply-templates select="../../../*[contains(@class, ' topic/colspec ')][1]" mode="count-colwidth"/>
                </xsl:variable>
                <xsl:variable name="proportionalWidth" select="contains($colspec/@colwidth, '*')"/>
                <xsl:variable name="thiswidth">   <!-- Width of this column, in units -->
                    <xsl:choose>
                        <xsl:when test="$colspec/@colwidth">
                            <xsl:choose>
                                <xsl:when test="$proportionalWidth">
                                   <!--<xsl:value-of select="substring-before($colspec/@colwidth, '*')"/>-->
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$colspec/@colwidth"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>1</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <!-- Width = width of this column / width of table, times 100 to make a percent -->
                <xsl:attribute name="width">
                  <!--  <xsl:choose>
                        <xsl:when test="$proportionalWidth">
                            <xsl:value-of select="($thiswidth div $totalwidth) * 100"/>
                            <xsl:text>%</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>-->
                            <xsl:value-of select="$thiswidth"/>
                        <!--</xsl:otherwise>
                    </xsl:choose>-->
                </xsl:attribute>
            </xsl:if>
            <xsl:choose>
            <xsl:when test="@outputclass = 'shade'">
                <xsl:attribute name="bgcolor">#cccccc</xsl:attribute>
            </xsl:when>
         </xsl:choose>
            
            
            <xsl:apply-templates mode="identity"/>
        </td>

    </xsl:template>







    <!-- Find the number of column spans between name-start and name-end attrs -->
    <xsl:template name="find-colspan">
        <xsl:variable name="startpos">
            <xsl:call-template name="find-entry-start-position"/>
        </xsl:variable>
        <xsl:variable name="endpos">
            <xsl:call-template name="find-entry-end-position"/>
        </xsl:variable>
        <xsl:value-of select="$endpos - $startpos + 1"/>
    </xsl:template>

    <!-- Find the starting column of an entry in a row. -->
    <xsl:template name="find-entry-start-position">
        <xsl:choose>
            
            <!-- if the column number is specified, use it -->
            <xsl:when test="@colnum">
                <xsl:value-of select="@colnum"/>
            </xsl:when>
            
            <!-- If there is a defined column name, check the colspans to determine position -->
            <xsl:when test="@colname">
                <!-- count the number of colspans before the one this entry references, plus one -->
                <xsl:value-of select="number(count(../../../*[contains(@class, ' topic/colspec ')][@colname = current()/@colname]/preceding-sibling::*)+1)"/>
            </xsl:when>
            
            <!-- If the starting column is defined, check colspans to determine position -->
            <xsl:when test="@namest">
                <xsl:value-of select="number(count(../../../*[contains(@class, ' topic/colspec ')][@colname = current()/@namest]/preceding-sibling::*)+1)"/>
            </xsl:when>
            
          
            
            <!-- Otherwise, just use the count of cells in this row -->
            <xsl:otherwise>
                <xsl:variable name="prev-sib">
                    <xsl:value-of select="count(preceding-sibling::*)"/>
                </xsl:variable>
                <xsl:value-of select="$prev-sib+1"/>
            </xsl:otherwise>
            
        </xsl:choose>
    </xsl:template>
    
    <!-- Find the end column of a cell. If the cell does not span any columns,
     the end position is the same as the start position. -->
    <xsl:template name="find-entry-end-position">
        <xsl:param name="startposition" select="0"/>
        <xsl:choose>
            <xsl:when test="@nameend">
                <xsl:value-of select="number(count(../../../*[contains(@class, ' topic/colspec ')][@colname = current()/@nameend]/preceding-sibling::*)+1)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$startposition"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Check <thead> entries, and return IDs for those which match the desired column -->
    <xsl:template match="*[contains(@class, ' topic/thead ')]/*[contains(@class, ' topic/row ')]/*[contains(@class, ' topic/entry ')]" mode="findmatch">
        <xsl:param name="startmatch">1</xsl:param>  <!-- start column of the tbody cell -->
        <xsl:param name="endmatch">1</xsl:param>    <!-- end column of the tbody cell -->
        <xsl:variable name="entrystartpos">         <!-- start column of this thead cell -->
            <xsl:call-template name="find-entry-start-position"/>
        </xsl:variable>
        <xsl:variable name="entryendpos">           <!-- end column of this thead cell -->
            <xsl:call-template name="find-entry-end-position">
                <xsl:with-param name="startposition" select="$entrystartpos"/>
            </xsl:call-template>
        </xsl:variable>
        <!-- The test cell can be any of the following:
       * completely before the header range (ignore id)
       * completely after the header range (ignore id)
       * completely within the header range (save id)
       * partially before, partially within (save id)
       * partially within, partially after (save id)
       * completely surrounding the header range (save id) -->
        <xsl:choose>
            <!-- Ignore this header cell if it  starts after the tbody cell we are testing -->
            <xsl:when test="number($endmatch) &lt; number($entrystartpos)"/>
            <!-- Ignore this header cell if it ends before the tbody cell we are testing -->
            <xsl:when test="number($startmatch) > number($entryendpos)"/>
            <!-- Otherwise, this header lines up with the tbody cell, so use the ID -->
            <xsl:otherwise>
                <xsl:value-of select="generate-id(.)"/>
                <xsl:text> </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Check the first column for entries that line up with the test row.
     Any entries that line up need to have the header saved. This template is first
     called with the first entry of the first row in <tbody>. It is called from here
     on the next cell in column one.            -->
    <xsl:template match="*[contains(@class, ' topic/entry ')]" mode="check-first-column">
        <xsl:param name="startMatchRow" select="1"/>   <!-- First row of the tbody cell we are matching -->
        <xsl:param name="endMatchRow" select="1"/>     <!-- Last row of the tbody cell we are matching -->
        <xsl:param name="startCurrentRow" select="1"/> <!-- First row of the column-1 cell we are testing -->
        <xsl:variable name="endCurrentRow">            <!-- Last row of the column-1 cell we are testing -->
            <xsl:choose>
                <!-- If @morerows, the cell ends at startCurrentRow + @morerows. Otherise, start=end. -->
                <xsl:when test="@morerows">
                    <xsl:value-of select="number($startCurrentRow)+number(@morerows)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$startCurrentRow"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <!-- When the current column-1 cell ends before the tbody cell we are matching -->
            <xsl:when test="number($endCurrentRow) &lt; number($startMatchRow)">
                <!-- Call this template again with the next entry in column one -->
                <xsl:if test="parent::*/parent::*/*[number($endCurrentRow)+1]">
                    <xsl:apply-templates select="parent::*/parent::*/*[number($endCurrentRow)+1]/*[1]" mode="check-first-column">
                        <xsl:with-param name="startMatchRow" select="$startMatchRow"/>
                        <xsl:with-param name="endMatchRow" select="$endMatchRow"/>
                        <xsl:with-param name="startCurrentRow" select="number($endCurrentRow)+1"/>
                    </xsl:apply-templates>
                </xsl:if>
            </xsl:when>
            <!-- If this column-1 cell starts after the tbody cell we are matching, jump out of recursive loop -->
            <xsl:when test="number($startCurrentRow) > number($endMatchRow)"/>
            <!-- Otherwise, the column-1 cell is aligned with the tbody cell, so save the ID and continue -->
            <xsl:otherwise>
                <xsl:value-of select="generate-id(.)"/>
                <xsl:text> </xsl:text>
                <!-- If we are not at the end of the tbody cell, and more rows exist, continue testing column 1 -->
                <xsl:if test="number($endCurrentRow) &lt; number($endMatchRow) and
                    parent::*/parent::*/*[number($endCurrentRow)+1]">
                    <xsl:apply-templates select="parent::*/parent::*/*[number($endCurrentRow)+1]/*[1]" mode="check-first-column">
                        <xsl:with-param name="startMatchRow" select="$startMatchRow"/>
                        <xsl:with-param name="endMatchRow" select="$endMatchRow"/>
                        <xsl:with-param name="startCurrentRow" select="number($endCurrentRow)+1"/>
                    </xsl:apply-templates>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>







    <!-- Handle dls in PACE output. -->
    <xsl:template match="*[contains(@class,' topic/dl ')]" mode="identity" priority="100">
        <xsl:apply-templates mode="identity"/>
    </xsl:template>
    <xsl:template match="*[contains(@class,' topic/dlentry ')]" mode="identity" priority="100">
        <xsl:apply-templates mode="identity"/>
    </xsl:template>
    <xsl:template match="*[contains(@class,' topic/dt ')]" mode="identity" priority="100"
        xml:space="default">
        <p>
            <strong>
                <xsl:choose>
                    <xsl:when test="count(ancestor::*[contains(@class,' topic/dl ')]) = 2"
                        xml:space="default">
                        <em>
                            <xsl:apply-templates mode="identity"/>
                        </em>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates mode="identity"/>
                    </xsl:otherwise>
                </xsl:choose>
            </strong>
        </p>
    </xsl:template>
    <xsl:template match="*[contains(@class,' topic/dd ')]" mode="identity" priority="100">
        <xsl:apply-templates mode="identity"/>
    </xsl:template>



    <!-- Fix href to remove .. before /assets -->
    <!-- Also, replace @href with @src for images in questions and assessments. -->
    <xsl:template match="@href" mode="identity" priority="100">
        <xsl:param name="type"/>
        <xsl:variable name="target">
            <!--            <xsl:message>determining target for <xsl:value-of select="@href"/>.</xsl:message>-->
            <xsl:choose>
                <xsl:when test="contains(.,'/assets/core_content/digital/')">
                    <xsl:value-of select="replace(.,'^.*/assets/core_content/digital/','/assets/')"
                    />
                </xsl:when>
                <xsl:when test="contains(.,'/assets/digital/')">
                    <xsl:value-of select="replace(.,'^.*/assets/digital/','/assets/')"/>
                </xsl:when>
                <xsl:when test="contains(.,'/assets/core_content/')">
                    <xsl:value-of select="replace(.,'^.*/assets/core_content/','/assets/')"/>
                </xsl:when>
                <xsl:when test="matches(.,'^(\.\./)+assets/')">
                    <xsl:value-of select="replace(.,'^(\.\./)+assets/','/assets/')"/>
                </xsl:when>
                <xsl:when test="starts-with(.,'..')">
                    <xsl:value-of select="substring-after(.,'..')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="parent::image and ($type = 'question' or $type='assessment')">
                <xsl:attribute name="src">
                    <xsl:value-of select="$target"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="href">
                    <xsl:value-of select="$target"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Fix image alignment attributes -->
    <xsl:template match="@align" mode="identity" priority="100">
        <xsl:choose>
            <xsl:when test=".='center' and parent::image">
                <!-- Do nothing. -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="@placement" mode="identity" priority="100">
        <!--        <xsl:message>
            Parent is <xsl:value-of select="name(parent::*)"/>;
            Content is "<xsl:value-of select="."/>";
            Align is <xsl:value-of select="parent::image/@align"/>.
        </xsl:message>-->
        <xsl:choose>
            <xsl:when test="parent::image and .='inline' and parent::image/@align='center'">
                <xsl:attribute name="placement">
                    <xsl:text>break</xsl:text>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- reference to glossary terms need to be modified from keyrefs to ids.-->
    <xsl:template match="term[@keyref]" mode="#all" priority="101">
        <xsl:param name="type"/>

        <!-- TODO (16-Jun-2014) Term in an sli within a kpe-overview must be changed to <strong>. -->
        <!-- Still trying to figure out when we handle kpe-overviewbody -->
        <term>
            <xsl:attribute name="id">
                <xsl:value-of select="@keyref"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </term>
    </xsl:template>

    <!-- Simple terms get converted to strong. -->
    <xsl:template match="term" mode="identity" priority="100">
        <xsl:param name="type"/>
        <strong>
            <xsl:apply-templates mode="identity"/>
        </strong>
    </xsl:template>

    <!-- Do not show draft-comment. -->

    <xsl:template match="draft-comment" mode="identity" priority="100">
        <!-- Do nothing. -->
    </xsl:template>

    <!-- Handle lcObjectives. -->
    <xsl:template match="lcObjectives" mode="identity" priority="100">
        <xsl:apply-templates mode="identity"/>
    </xsl:template>

    <xsl:template match="lcObjectivesStem" mode="identity" priority="100">
        <p>
            <xsl:apply-templates mode="identity"/>
        </p>
    </xsl:template>

    <xsl:template match="lcObjectivesGroup" mode="identity" priority="100">
        <ul>
            <xsl:apply-templates mode="identity"/>
        </ul>
    </xsl:template>

    <xsl:template match="lcObjective" mode="identity" priority="100">
        <li>
            <xsl:apply-templates mode="identity"/>
        </li>
    </xsl:template>

    <xsl:template match="lcReview" mode="identity" priority="100">
        <xsl:apply-templates mode="identity"/>
    </xsl:template>

    <xsl:template match="sl" mode="identity" priority="100">
        <xsl:apply-templates mode="identity"/>
    </xsl:template>

    <xsl:template match="sli" mode="identity" priority="100">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>

    <!--psb added CDATA stuff 4-19-2016-->
    
    
    <xsl:template name="wrap_cdata">
        <xsl:value-of select="." disable-output-escaping="yes"/>
        <xsl:text disable-output-escaping="yes">
        <![CDATA[]]>
      </xsl:text>
    </xsl:template>
    
    <xsl:template match="foreign" mode="identity" priority="100">
        <p>
            <xsl:call-template name="wrap_cdata"/>
        </p>
    </xsl:template>

    <!-- Deep six the bad attributes. -->
    <xsl:template match="@xtrf|@xtrc" mode="identity" priority="100"/>
    <xsl:template match="@class" mode="identity" priority="100"/>
    <xsl:template match="@ditaarch:DITAArchVersion" priority="100"/>
    <!--    <xsl:template match="@xmlns:ditaarch"/>-->
    <!--    <xsl:template match="namespace::*" mode="identity"/>-->

    <!-- [SP] 2014-05-27: Add handler for misc. character styles. -->
    <!--PSB 9/29/15 Updated to include "mode="#all"    -->
    <xsl:template match="*[contains(@class,' kpe-question-d/qualifier ')]" mode="#all" priority="100">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>

    <xsl:template match="*[contains(@class,' kpe-common-d/emphasisBold ')]|emphasisBold" mode="#all"
        priority="100">
        <strong>
            <xsl:apply-templates/>
        </strong>
    </xsl:template>

<!--8/6/15 PSB: Added commandWord processing-->
    <xsl:template match="*[contains(@class,' kpe-common-d/commandWord ')]|commandWord" mode="#all"
        priority="100">
        <strong>
            <xsl:apply-templates/>
        </strong>
    </xsl:template>
  
    <xsl:template match="*[contains(@class,' kpe-common-d/emphasisItalics ')]|emphasisItalics"
        mode="#all" priority="100">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>

    <xsl:template match="*[contains(@class,' hi-d/i ')]"
        mode="#all" priority="100">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>
    <xsl:template match="*[contains(@class,' hi-d/b ')]"
        mode="#all" priority="100">
        <strong>
            <xsl:apply-templates/>
        </strong>
    </xsl:template>

    <xsl:template match="*[contains(@class,' kpe-common-d/legalCite ')]" mode="#all" priority="100">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>

    <xsl:template match="foreignWord" mode="#all" priority="100">
        <em>
            <xsl:apply-templates/>
        </em>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/indexterm ')]" mode="#all" priority="100">
        <!-- Do nothing. -->
    </xsl:template>

    <xsl:template match="*[contains(@class,' hi-d/u ')]" priority="100" mode="#all">
        <u>
            <xsl:apply-templates/>
        </u>
    </xsl:template>


<!--    PSB added 6/15/2017 -->
    <xsl:template match="p[@outputclass = 'indent']" mode="#all">
        <xsl:param name="type"/>
        <p style="margin-left:70px;"><xsl:apply-templates/></p>
    </xsl:template>
    <xsl:template match="p[@outputclass = 'indent_2']" mode="#all">
        <xsl:param name="type"/>
        <p style="margin-left:140px;"><xsl:apply-templates/></p>
    </xsl:template>
<!--    PSB added 6/15/2017-->
    <xsl:template match="sum" priority="100" mode="#all">
        <u><xsl:apply-templates/></u>
    </xsl:template>
<!--    PSB added 6/15/2017-->
   
    <xsl:template match="total" priority="100" mode="#all">
        <u style="border-bottom:1px solid"><xsl:apply-templates/></u>
    </xsl:template>
    
    <xsl:template match="sub" mode="#all" priority="100">
        <sub>
            <xsl:apply-templates/>
        </sub>
    </xsl:template>
    <xsl:template match="sup" mode="#all" priority="100">
        <sup>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>
    
</xsl:stylesheet>
