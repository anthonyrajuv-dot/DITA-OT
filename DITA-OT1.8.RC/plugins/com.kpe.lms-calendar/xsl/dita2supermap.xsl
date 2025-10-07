<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    exclude-result-prefixes="xs functx ditaarch" version="2.0">

    <!-- Generate a bookmap (supermap) that directs what the eventual PACE maps will contain. -->


    <xsl:import href="functx-1.0.xsl"/>
<!--    <xsl:import href="new_topic_task.xsl"/>-->

    <xsl:param name="BASE_DIR"/>
    <xsl:param name="OUT_DIR"/>

    <xsl:output encoding="UTF-8" method="xml" indent="yes"/>

    <xsl:template match="/">
        <xsl:apply-templates select="*[contains(@class, ' bookmap/bookmap ')]"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/bookmap ')]">
        <xsl:variable name="bookmeta" select="*[contains(@class, ' bookmap/bookmeta ')][1]"
            as="element()*"/>
        <!-- Required for name_base. -->
        <xsl:variable name="brand">
            <xsl:apply-templates
                select="$bookmeta/*[contains(@class,' topic/prodinfo ')][1]/*[contains(@class, ' topic/brand ')][1]"
            />
        </xsl:variable>
        <!-- Required for name_base. -->
        <xsl:variable name="series">
            <xsl:apply-templates
                select="$bookmeta/*[contains(@class,' topic/prodinfo ')][1]/*[contains(@class, ' topic/series ')][1]"
            />
        </xsl:variable>
        <xsl:variable name="name_base" select="concat($brand,'_',$series)"/>

        <!-- Get the course number from the most recent VRM. -->
        <xsl:variable name="course_num" select="$bookmeta/prodinfo/vrmlist/vrm[1]/@version"/>

        <supermap>
            <xsl:attribute name="title">
                <xsl:value-of select="$series"/>
            </xsl:attribute>
            <xsl:attribute name="id">
                <xsl:apply-templates
                    select="$bookmeta/*[contains(@class,' bookmap/bookid ')][1]/*[contains(@class,' bookmap/bookpartno ')][1]"
                />
            </xsl:attribute>
            <xsl:attribute name="name_base" select="$name_base"/>
            <xsl:attribute name="course_num" select="$course_num"/>
            
            <!-- Find the category in the metadata and create a category attribute. -->
            <xsl:variable name="category">
                <xsl:apply-templates select="$bookmeta/*[contains(@class,' topic/category ')][1]"/>
            </xsl:variable>
            <xsl:attribute name="category">
                <xsl:choose>
                    <xsl:when test="$category = ''">
                        <xsl:text>default</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$category"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>


            <!-- Content of navtitle is necessary for determining if the first chapter is an introduction. -->
            <xsl:variable name="navtitle" as="node()*">
                <xsl:choose>
                    <xsl:when
                        test="*[contains(@class,' bookmap/chapter ')][1]/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]">
                        <xsl:copy-of
                            select="*[contains(@class,' bookmap/chapter ')][1]/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]"
                        />
                    </xsl:when>
                    <xsl:when test="@navtitle">
                        <xsl:value-of select="@navtitle"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>

            <!-- Handle the contents of the map. -->
            <!-- This value is either 1 or 0. The number is used to calculate the Unit number. -->
            <!-- There are two ways to do this; neither is satisfactory: 
                1) We can compare the title to "Course Introduction", which is VERY undependable. 
                2) We can see if the first chapter contains any topicheads. If it doesn't, it's an intro; if it does, it's a regular chapter. 
                I'm going with #2, but still holding #1 just in case.
                3) Had to add this, because in QBank pre-test and post-test, the chapter doesn't contain topicheads, either.
                -->
            <xsl:variable name="has_intro" as="xs:integer">
                <xsl:choose>

<!--                    <xsl:when test="contains(lower-case($navtitle/text()),'course introduction')">
                        <xsl:value-of select="1"/>
                    </xsl:when>-->
                    <xsl:when
                        test="*[contains(@class,' bookmap/chapter ')][1]/*[contains(@class,' mapgroup-d/topichead ')]">
                        <xsl:value-of select="0"/>
                    </xsl:when>
                    <xsl:when
                        test="*[contains(@class,' bookmap/chapter ')][1]/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/category ')]/text() != 'default'">
                        <xsl:value-of select="0"/>
                    </xsl:when>
                    
                    <xsl:otherwise>
                        <xsl:value-of select="1"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:message>has_intro for <xsl:value-of select="$navtitle"/> is: <xsl:value-of
                    select="$has_intro"/>.</xsl:message>

            <xsl:apply-templates select="*[contains(@class,' bookmap/chapter ')]">
                <xsl:with-param name="has_intro" select="$has_intro"/>
                <xsl:with-param name="name_base" select="$name_base"/>
            </xsl:apply-templates>

            <los_summary>
                <xsl:call-template name="find_unique_los">
                    <xsl:with-param name="has_intro" select="$has_intro"/>
                </xsl:call-template>
            </los_summary>

        </supermap>
    </xsl:template>

    <xsl:template name="get_navtitle">
        <xsl:choose>
            <xsl:when
                test="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]">
                <xsl:copy-of 
                    select="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]/node()"
                />
            </xsl:when>
            <xsl:when test="@navtitle">
                <xsl:value-of select="@navtitle"/>
            </xsl:when>
            <xsl:when test="@outputclass = 'final-exam'">
                <xsl:text>Final Exam</xsl:text>
            </xsl:when>
<!--            <xsl:when test="@outputclass = 'exam'">
                <xsl:text>Final Exam</xsl:text>
            </xsl:when>-->
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="get_shortdesc">
        <xsl:choose>
            <xsl:when test="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/data ') and @name='short_title']">
                <xsl:apply-templates 
                    select="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/data ') and @name='short_title']"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="*[contains(@class, ' bookmap/chapter ')]" priority="100">
        <xsl:param name="has_intro" as="xs:integer" select="0"/>
        <xsl:param name="name_base"/>

<xsl:variable name="navtitle">
            <xsl:call-template name="get_navtitle"/>
        </xsl:variable>
        
        <xsl:variable name="unit_number"
            select="count(preceding-sibling::*[contains(@class,' bookmap/chapter ')])  + (1 - $has_intro)"/>

        <xsl:choose>
            <xsl:when test="@processing-role='resource-only'">
                <!-- Do nothing. -->
            </xsl:when>
            <xsl:when test="$has_intro = 1 and $unit_number = 0">
                <topichead navtitle="Introduction">
                    <xsl:attribute name="name_base">
                        <xsl:value-of select="concat($name_base,'_I1')"/>
                    </xsl:attribute>
                    <xsl:attribute name="unit">
                        <xsl:value-of select="'I.1'"/>
                    </xsl:attribute>
                    <xsl:apply-templates
                        select="*[contains(@class,' map/topicref ') and not(contains(@class,' subjectScheme/subjectdef '))]"
                    />
                </topichead>
            </xsl:when>
            
           
            <!--PSB 6/8/15: Added  "and not[contains($navtitle,'Unit')]" to fix error with the word "Conclusion" in a unit -->
            <xsl:when test="contains($navtitle,'Conclusion') and not[contains($navtitle,'Unit')]">
                <topichead navtitle="Conclusion">
                    <xsl:attribute name="name_base">
                        <xsl:value-of select="concat($name_base,'_C1')"/>
                    </xsl:attribute>
                    <xsl:attribute name="unit">
                        <xsl:value-of select="'C.1'"/>
                    </xsl:attribute>
                    <xsl:apply-templates
                        select="*[contains(@class,' map/topicref ') and not(contains(@class,' subjectScheme/subjectdef '))]">
                        <xsl:with-param name="conclusion" select="true()"/>
                    </xsl:apply-templates>
                </topichead>
            </xsl:when>
            <xsl:otherwise>
                <topichead>
                    <xsl:attribute name="name_base">
                        <xsl:value-of select="concat($name_base,'_U',$unit_number)"/>
                    </xsl:attribute>
                    <xsl:attribute name="unit">
                        <xsl:value-of select="concat('U.',$unit_number)"/>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:choose>
                            <!-- This is really ugly. It would be far better if the chapter just out and said "final exam". -->
                            <xsl:when test="@outputclass = 'final-exam'">
                                <xsl:text>final-exam</xsl:text>
                            </xsl:when>
<!--                            <xsl:when test="@outputclass = 'exam' and contains(lower-case(@navtitle),'final exam')">
                                <xsl:text>final-exam</xsl:text>
                            </xsl:when>-->
                            <xsl:otherwise>
                                <xsl:text>chapter</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                    
                    <!-- Determine the Unit Map type -->
                    <xsl:variable name="raw_category" select="ancestor::bookmap/bookmeta[1]/category[1]/text()"/>
                    <xsl:variable name="unit_map_type">
                        <xsl:choose>
<!--                            <xsl:when test="topicref[1]/topicmeta/navtitle/text() = 'Final Exam'">
                                <xsl:text>final-exam</xsl:text>
                            </xsl:when>-->
                            <xsl:when test="@outputclass = 'final-exam'">final-exam</xsl:when>
                            <xsl:when test="$raw_category = 'qbank'">qbank</xsl:when>
                            <xsl:when test="contains($raw_category,'calendar')">calendar</xsl:when>
                            <xsl:otherwise>toc</xsl:otherwise>
                        </xsl:choose>
                        
                    </xsl:variable>
                    
                    <xsl:attribute name="unit_map_type">
                        <xsl:value-of select="$unit_map_type"/>
                    </xsl:attribute>
                    
                    <xsl:if test="$unit_map_type = 'final-exam'">
                        <xsl:attribute name="task_href">
                            <xsl:value-of select="@href"/>
                        </xsl:attribute>
                        <!-- Normally shortdesc is a topicref attribute, but in the case of a final exam, it's 
                             an attribute for topichead.-->
                        <xsl:attribute name="shortdesc">
                            <xsl:call-template name="get_shortdesc"/>
                        </xsl:attribute>
                    </xsl:if>
                    
                    <xsl:message>navtitle is: <xsl:value-of select="$navtitle"/>.</xsl:message>
                    <navtitle>
                        <xsl:choose>
                            <xsl:when test="empty($navtitle)">
                                <xsl:value-of select="concat('Unit ',$unit_number)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy-of select="$navtitle"/>
                            </xsl:otherwise>
                        </xsl:choose>
                        
                    </navtitle>

                    <!-- Make a determination: is this a QBank, a TOC map or a Calendar map. -->
<!--                    <xsl:comment>unit_map_type is <xsl:value-of select="$unit_map_type"/>.</xsl:comment>-->
                    
                    <xsl:choose>
                        <xsl:when test="$unit_map_type = 'toc'">
                            <xsl:apply-templates select="*[contains(@class,' mapgroup-d/topichead ')]"/>
                        </xsl:when>
                        <xsl:when test="$unit_map_type = 'qbank'">
                            <!-- Create a topicref to the kpe-task. -->
                            <topicref>
                                <xsl:attribute name="orig_href">
                                    <xsl:value-of select="@href"/>
                                </xsl:attribute>
                                <!-- Set the task_category. If it's not a task, find another related value. -->
                                <xsl:attribute name="task_category">
                                    <xsl:text>exam</xsl:text>
                                </xsl:attribute>
                                
                                <xsl:attribute name="type">
                                    <xsl:text>exam</xsl:text>
                                </xsl:attribute>
                                <xsl:if test="empty($navtitle)">
                                    <navtitle>
                                        <xsl:copy-of select="$navtitle"/>
                                    </navtitle>
                                </xsl:if>
                            </topicref>
                            
                            <xsl:apply-templates select="*[contains(@class,' map/topicref ')]" mode="Learning_Exam"/>
                            
                        </xsl:when>
                        <xsl:when test="$unit_map_type = 'final-exam'">
                            
                            
                            <xsl:apply-templates select="*[contains(@class,' classify-d/topicsubject ')]"/>
                            
                            <xsl:comment>final-exam transform: Now handle the topicref.</xsl:comment>
                            <!-- it has to be a topicref, not anything that inherits from topicref. -->
                            
                            <xsl:apply-templates select="topicref"/>
                        </xsl:when>
                        <xsl:when test="$unit_map_type = 'calendar'">
                            
                            <xsl:apply-templates select="*[contains(@class,' mapgroup-d/topichead ')]"/>
                            
                            <xsl:comment>Calendar transform: Now handle the topicref.</xsl:comment>
                            <!-- it has to be a topicref, not anything that inherits from topicref. -->
                            
                            <xsl:apply-templates select="topicref"/>
                        </xsl:when>
                    </xsl:choose>
                    
                    
                </topichead>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>


    <xsl:template match="*[contains(@class,' mapgroup-d/topichead ')]">
        <xsl:choose>
            <xsl:when test="parent::chapter">
                <xsl:apply-templates select="*[contains(@class,' map/topicref ')]"/>
            </xsl:when>
            <xsl:otherwise>
                <topichead>
                    <xsl:attribute name="navtitle">
                        <xsl:value-of select="@navtitle"/>
                    </xsl:attribute>
                    
                    <xsl:apply-templates select="*[contains(@class,' map/topicref ')]"/>
                </topichead>
                
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>

    <!-- [SP] 2015-04-16 sfb: I don't believe this is ever used. Nothing else uses this mode. -->
    <xsl:template match="*[contains(@class,' map/topicref ') and @type='kpe-task']" mode="optional-task">
        <!-- Create a topicref to the kpe-task. -->
        <xsl:variable name="navtitle">
            <xsl:call-template name="get_navtitle"/>
        </xsl:variable>
        <xsl:comment>DOES ANYTHING GENERATE THIS???</xsl:comment>
        
        <topicref>
            <xsl:attribute name="orig_href">
                <xsl:value-of select="@href"/>
            </xsl:attribute>
            <!-- Set the task_category. If it's not a task, find another related value. -->
            <xsl:attribute name="task_category">
                <xsl:text>exam</xsl:text>
            </xsl:attribute>
            
            <xsl:attribute name="type">
                <xsl:text>exam</xsl:text>
            </xsl:attribute>
            <xsl:if test="not(empty($navtitle))">
                <navtitle>
                    <xsl:copy-of select="$navtitle"/>
                </navtitle>
            </xsl:if>

            <!-- Handle the topicrefs inside the topichead (moved back inside). -->
            <xsl:apply-templates select="*[contains(@class,' map/topicref ')]" mode="Learning_Exam"/>      
            
        </topicref>
  
        
    </xsl:template>
    
    
    <!-- [SP] 2015-01-12: Passthru for topicgroup. -->
    <xsl:template match="*[contains(@class,' mapgroup-d/topicgroup ')]">
        <xsl:param name="conclusion" as="xs:boolean" select="false()"/>
        
        <xsl:apply-templates>
            <xsl:with-param name="conclusion" select="$conclusion"/>
        </xsl:apply-templates>
    </xsl:template>
        
    
    <!-- Topicref that is not a head or group or subject or subjectdef element. -->
    <xsl:template
        match="*[contains(@class,' map/topicref ') 
        and not(contains(@class,' mapgroup-d/topichead '))
        and not(contains(@class,' mapgroup-d/topicgroup '))
        and not(contains(@class,' classify-d/topicsubject '))
        and not(contains(@class,' subjectScheme/subjectdef '))]">
        <xsl:param name="conclusion" as="xs:boolean" select="false()"/>

<!--        <xsl:comment>Handing topicref (@href = <xsl:value-of select="@href"/>).</xsl:comment>-->
        <xsl:variable name="navtitle">
            <xsl:call-template name="get_navtitle"/>
        </xsl:variable>
        
        <xsl:variable name="shortdesc">
            <xsl:call-template name="get_shortdesc"/>
        </xsl:variable>

        <!-- Need the content of the file. -->
        <xsl:variable name="topic" select="document(@href)/*" as="element()*"/>
        
        <xsl:variable name="fn_count" select="count($topic/descendant-or-self::*[contains(@class,' topic/fn ')])"/>

        <xsl:variable name="task_category">
            <xsl:choose>
                <xsl:when test="contains($topic/@class,' kpe-question/kpe-question ')">
                    <xsl:text>kpe-question</xsl:text>
                </xsl:when>
                <xsl:when test="contains($topic/@class,' kpe-overview/kpe-overview ')">
                    <xsl:text>kpe-overview</xsl:text>
                </xsl:when>
                <xsl:when test="contains($topic/@class,' kpe-concept/kpe-concept ')">
                    <xsl:text>kpe-concept</xsl:text>
                </xsl:when>
                <xsl:when test="contains($topic/@class,' kpe-assessmentOverview/kpe-assessmentOverview ')">
                    <xsl:text>kpe-assessmentOverview</xsl:text>
                </xsl:when>
<!--                <xsl:when test="parent::*/@navtitle = 'Unit Exam'">
                    <xsl:text>exam</xsl:text>
                </xsl:when>-->
                <!-- [SP] 2015-01-14: lmsCategory wins over everything. -->
                <xsl:when test="$topic//lmsCategory[1]/@value">
                    <xsl:value-of select="$topic//lmsCategory[1]/@value"/>
                </xsl:when>
                
                
                <xsl:when test="@type and @type != ''">
                    <xsl:message>Using @type (<xsl:value-of select="@type"/>).</xsl:message>
                    <xsl:value-of select="@type"/>
                </xsl:when>
                <xsl:when test="name($topic) = 'kpe-summary'">
                    <xsl:text>kpe-summary</xsl:text>
                </xsl:when>
                <xsl:when test="name($topic) = 'kpe-glossEntry'">
                    <xsl:text>kpe-glossEntry</xsl:text>
                </xsl:when>
                <xsl:otherwise>
<!--                    <xsl:value-of select="name($topic)"/>-->
                    <xsl:value-of select="concat('*unknown* (',name($topic),')')"/>
<!--                    <xsl:text>*unknown*</xsl:text>-->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
<!--        <xsl:message>task_category is <xsl:value-of select="$task_category"/>.</xsl:message>-->
        
        <!-- Set these variables before chunking starts: -->
        <xsl:variable name="task_category_attr">
            <xsl:choose>
                <xsl:when test="$task_category != ''">
                    <xsl:value-of select="$task_category"/>
                </xsl:when>
                <xsl:when test="contains(@href,'_los_overview_')">
                    <xsl:value-of select="'los_overview'"/>
                </xsl:when>
                <xsl:when test="contains(@href,'_summary_')">
                    <xsl:value-of select="'summary'"/>
                </xsl:when>
                <xsl:when test="name($topic) = 'kpe-concept'">
                    <xsl:value-of select="'page_turner'"/>
                </xsl:when>
                <xsl:when test="name($topic) = 'concept'">
                    <xsl:value-of select="'page_turner'"/>
                </xsl:when>
            </xsl:choose>            
        </xsl:variable>
        
        <xsl:variable name="type_attr">
            <xsl:choose>
                <xsl:when test="@outputclass='exam'">
                    <xsl:value-of select="'exam'"/>
                </xsl:when>
                <xsl:when test="contains('activity presentation reading default',$task_category)">
                    <xsl:value-of select="'topic'"/>
                </xsl:when>
                <xsl:when test="$task_category = 'assignment'">
                    <xsl:value-of select="'question'"/>
                </xsl:when>
                <xsl:when test="$task_category = 'kpe-question'">
                    <xsl:value-of select="'question'"/>
                </xsl:when>
                <xsl:when test="$task_category = 'kpe-overview'">
                    <xsl:value-of select="'kpe-overview'"/>
                </xsl:when>
                <xsl:when test="$task_category = 'kpe-assessmentOverview'">
                    <xsl:value-of select="'exam'"/>
                </xsl:when>
                <xsl:when test="$task_category = 'exam'">
                    <xsl:value-of select="'exam'"/>
                </xsl:when>
                <xsl:when test="$task_category = 'kpe-summary'">
                    <xsl:value-of select="'summary'"/>
                </xsl:when>
                <xsl:when test="$task_category = '' and contains(@href,'_summary_')">
                    <xsl:value-of select="'summary'"/>
                </xsl:when>
                <xsl:when test="$task_category = 'kpe-concept'">
                    <xsl:value-of select="'concept'"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
<!--        <xsl:message>type_attr is <xsl:value-of select="$type_attr"/>.</xsl:message>-->
        
        
        <!-- If a single topic and no chunking, generate a single topicref. 
             Otherwise, generate a topicref for each chunk. -->
        
        <!-- [SP] 2014-06-18: FOR CHUNKING:
             We've needed to deal with topicrefs differently, based on topicref type for a while,
             Add a choose that determines which kind of topicref we're creating
             This includes creating multiple topicrefs for chunked topics. 
             
        -->
<!--        <xsl:variable name="chunk_count" select="count($topic//section[title]) + count($topic//data[@name='pace_break' and upper-case(@value)='Y'])"/>-->
        <xsl:variable name="chunk_count" select="count($topic//section) + count($topic//data[@name='pace_break' and upper-case(@value)='Y'])"/>
        <xsl:message>For <xsl:value-of select="@href"/>, chunk_count is: <xsl:value-of select="$chunk_count"/>.</xsl:message>
        <xsl:variable name="has_chunking">
            <xsl:choose>
                <!-- Doesn't make any difference. -->
<!--                <!-\- [SP] 2015-01-14: Nasty exception: assessmentOverviews contain a single section. -\->
                <xsl:when test="$task_category = 'kpe-assessmentOverview'">
                    <xsl:value-of select="false()"/>
                </xsl:when>-->
                <!-- [SP] 2015-04-08: Calendar change: allow tasks to have chunking. -->
                <xsl:when test="$chunk_count &gt; 0 and (contains(name($topic),'concept') or contains(name($topic),'task'))">
                    <xsl:value-of select="true()"/>
                </xsl:when>
<!--                <xsl:when test="$topic//section[title] or $topic//data[@name='pace_break' and upper-case(@value)='Y']">
                    <xsl:value-of select="true()"/>
                </xsl:when>-->
                <xsl:otherwise>
                    <xsl:value-of select="false()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="whitespace" select="'&#x9;&#xA;&#xD;&#x20;'"/>
        
        <!-- See if there is content BEFORE the first section or pacebreak. -->
        <!-- (Assuming that a reasonable content creator wouldn't put a pace_break at the beginning of the topic body.) -->
        <xsl:variable name="before_section" as="node()*" 
            select="$topic//section[1]/preceding-sibling::node()[self::element() or self::text()]"/>
        <xsl:variable name="has_initial_content">
            <!-- is it whitespace? or is it actual text. -->
            <xsl:choose>
                <!-- More than one node says that at least one node is an element, 
                    therefore there IS content before the <section>. -->
                <xsl:when test="count($before_section) &gt; 1">
                    <xsl:value-of select="true()"/>
                </xsl:when>
                <xsl:when test="$before_section[1][self::text()]">
                    <xsl:variable name="first_text" select="normalize-space(translate($before_section[1],$whitespace,'    '))"/>
                    <xsl:choose>
                        <xsl:when test="$first_text = ''">
                            <xsl:value-of select="false()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="true()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="true()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:message>has_initial_content is: <xsl:value-of select="$has_initial_content"/>.</xsl:message>
        
        <xsl:if test="$has_chunking = true()">
            <xsl:text>&#x0A;</xsl:text>
<!--            <xsl:comment>The following topic has <xsl:value-of select="$chunk_count"/> chunks.</xsl:comment>  -->
<!--            <xsl:comment>Its class attribute is "<xsl:value-of select="$topic/@class"/>".</xsl:comment>-->
            <xsl:text>&#x0A;</xsl:text>
        </xsl:if>
        
        <!-- At this point, we need to perform some separate processing if the current topic needs chunking.
             We need to chunk and create a topicref for each separate chunk. 
             The problem is, the topicref may need to contain refs to other topics?
             We no longer have topic nesting below the topicref level! no worries.
             
        -->
        <xsl:choose>
            <xsl:when test="$has_chunking = true() and ($chunk_count &gt; 1 or ($chunk_count = 1 and $has_initial_content = true()))">
<!--                <xsl:comment>pace_breaks: <xsl:value-of select="count($topic//data[@name='pace_break' and upper-case(@value)='Y'])"/>.</xsl:comment>-->
<!--                <xsl:comment>sections that contain pace breaks: <xsl:value-of select="count($topic//section/data[@name='pace_break' and upper-case(@value)='Y'])"/>.</xsl:comment>-->

                <!-- Build a temporary structure (the chunk_map) that maps the location of each chunk. -->
                
                <xsl:message>Creating chunk_map.</xsl:message>
                <xsl:variable name="chunk_map" as="element()*">
                    <xsl:apply-templates select="$topic/descendant-or-self::*[contains(@class,' topic/body ')]" mode="chunk_map"/>
                </xsl:variable>

                <xsl:message>chunk_map contains <xsl:value-of select="count($chunk_map/descendant::*)"/> elements.</xsl:message>
                
                <xsl:call-template name="chunk_map_iterator">
                    <xsl:with-param name="topic" select="$topic"/>
                    <xsl:with-param name="chunk_map" select="$chunk_map"/>
                    <xsl:with-param name="task_category_attr" select="$task_category_attr"/>
                    <xsl:with-param name="type_attr" select="$type_attr"/>
                    <xsl:with-param name="navtitle" select="$navtitle"/>
                    <xsl:with-param name="shortdesc" select="$shortdesc"/>
<!--                    <xsl:with-param name="fn_count" select="$fn_count"/>-->
                </xsl:call-template>
                
            </xsl:when>
            <xsl:when test="$task_category = 'kpe-assessmentOverview'">                
                <xsl:apply-templates select="." mode="Learning_Exam"/>
            </xsl:when>
            
            <xsl:otherwise>
                <!-- Just create a single topicref. -->
                <!-- TODO: check to see if the href has been used already in the map.
                     If so, add an identifier to the name (TBD)
                     
                     <xsl:variable name="preceding_count" select="count(preceding::*[@orig_href=$orig_href])"/>
 
                     -->
                <topicref>
                    <xsl:attribute name="orig_href">
                        <xsl:value-of select="@href"/>
                    </xsl:attribute>
                    <!-- Set the task_category. If it's not a task, find another related value. -->
                    <xsl:attribute name="task_category">
                        <xsl:value-of select="$task_category_attr"/>
                    </xsl:attribute>
                    
                    <xsl:attribute name="type">
                        <xsl:value-of select="$type_attr"/>
                    </xsl:attribute>
                    <xsl:if test="$shortdesc != ''">
                        <xsl:attribute name="shortdesc">
                            <xsl:value-of select="$shortdesc"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="fn_count">
                        <xsl:value-of select="$fn_count"/>
                    </xsl:attribute>
                    <xsl:message>type "<xsl:value-of select="$type_attr"/>" for href: <xsl:value-of select="@href"/>.</xsl:message>
                    <xsl:if test="not(empty($navtitle))">
                        <navtitle>
                            <xsl:copy-of select="$navtitle"/>
                        </navtitle>
                    </xsl:if>
                    
                    <!-- [SP] 2015-04-06: Moved inside of topicref, from after </xsl:choose> -->
                    <!-- For page-turner topics, the topicsubject elements are preceding siblings, not children. -->
                    <xsl:choose>
                        <xsl:when test="name($topic) = 'kpe-concept'">
                            <!-- Page turner. -->
                            <xsl:comment>handing preceding sibling topicsubject elements for kpe-concept.</xsl:comment>
                            <xsl:apply-templates
                                select="preceding-sibling::*[contains(@class,' classify-d/topicsubject ')]"/>
                            
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- Handle the topicsubject elements that were keyref'ed. -->
                            <xsl:comment>Handling topicsubject. </xsl:comment>
                            <xsl:apply-templates select="*[contains(@class,' classify-d/topicsubject ')]"/>
                            
                            <!-- Handle any nested topicrefs (specifically, note no @class matching). -->
                            <xsl:comment>Handling nested topicrefs. </xsl:comment>
                            <xsl:apply-templates select="topicref"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </topicref>
                
            </xsl:otherwise>
        </xsl:choose>
        
        <!-- [SP] 2015-04-06: (xsl:choose was here.)-->
        
        <!-- Handle normal nested topicrefs. -->
        <!-- I'm not sure if there will be any nested topicrefs that are not of type topic.-->
        <xsl:if test="not(@type='kpe-assessmentOverview')">
            <xsl:apply-templates
                select="*[contains(@class,' map/topicref ') 
                and not(contains(@class,' classify-d/topicsubject ')) 
                and not(contains(@class,' subjectScheme/subjectdef ')) 
                and not(@type='kpe-assessmentOverview')
                and not(contains(@href,'topics/'))
                ]">
                
                <xsl:with-param name="conclusion" select="$conclusion"/>
            </xsl:apply-templates>            
        </xsl:if>
        
        <!-- [SP] 2015-04-16 sfb: This doesn't seem to do anything, and in fact, causes extra examMaps to be created. -->
        <!--        <xsl:apply-templates
            select="*[contains(@class,' map/topicref ') and @type='kpe-assessmentOverview']"
            mode="Learning_Exam"/>
        -->        
        
    </xsl:template>

    <!-- Walk through the chunk map, creating topicrefs and output topics. -->
    <xsl:template name="chunk_map_iterator">
        <xsl:param name="topic" as="element()*"/>
        <xsl:param name="chunk_map" as="element()*"/>
        <xsl:param name="task_category_attr"/>
        <xsl:param name="type_attr"/>
        <xsl:param name="navtitle"/>
        <xsl:param name="shortdesc"/>
        <xsl:param name="counter" select="1" as="xs:integer"/>
        
        <!-- Dereference the current chunk. -->
        <xsl:variable name="chunk" select="$chunk_map/descendant::*[position() = $counter]"/>
        <xsl:message>chunk type is <xsl:value-of select="name($chunk)"/>.</xsl:message>
        
        <!-- De-reference the ID. -->
        <xsl:variable name="chunk_id">
            <xsl:choose>
                <!-- Counter is 1 when we're dealing with the piece of the file up to the start of the first chunk. -->
                <xsl:when test="$counter = 1">
                    <xsl:value-of select="$chunk_map/@id"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Get the id of the nth node in the map. -->
                    <xsl:value-of select="$chunk/@id"/>
<!--                    <xsl:value-of select="$chunk_map/descendant::*[position() = $counter]/@id"/>-->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <!-- Identify the element type. (Do it at this level, because you'll need the info twice.) -->
        <xsl:variable name="ref-element">
            <xsl:choose>
                <xsl:when test="$counter = 1 and $chunk_map/descendant::*/@empty='yes'">
                    <xsl:text>topicref</xsl:text>
                </xsl:when>
                
                <xsl:when 
                    test="contains($topic/@class,' kpe-task/kpe-task ') 
                          and $chunk_map/descendant::*/@empty='yes' 
                          and $counter = 2">
                    <xsl:text>topicref</xsl:text>
                </xsl:when>
                <xsl:when test="contains($topic/@class,' kpe-task/kpe-task ') and $counter &gt; 1">
                    <xsl:text>task-chunk</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>topicref</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
<!--        <xsl:comment>ref-element is <xsl:value-of select="$ref-element"/>.</xsl:comment>-->
        
        <!-- This is getting tricky. If we're dealing with a task that has chunks, the first
             chunk of the task generates a topicref, and the remaining chunks are nested AS SIBLINGS
             within that topicref. 
        -->
        <xsl:variable name="first-task-chunk">
            <xsl:choose>
                <!-- Don't need to worry about it for non-task topicref. -->
                <xsl:when test="not(contains($topic/@class,' kpe-task/kpe-task '))">
                    <xsl:text>no</xsl:text>    
                </xsl:when>
                <xsl:when test="$counter = 1 and not($chunk_map/descendant::*/@empty='yes')">
                    <xsl:text>yes</xsl:text>    
                </xsl:when>
                <xsl:when test="$counter = 2 and $chunk_map/descendant::*/@empty='yes'">
                    <xsl:text>yes</xsl:text>    
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>no</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
<!--        <xsl:comment>first-task-chunk is <xsl:value-of select="$first-task-chunk"/>.</xsl:comment>-->
        
        
        <!-- If the initial chunk is empty, skip the topicref and output file creation. -->
        <xsl:choose>
            <xsl:when test="$counter = 1 and $chunk_map/descendant::*/@empty='yes'">
                <xsl:message>  Skipping empty initial chunk.</xsl:message>
                <xsl:comment>  Skipping empty initial chunk.</xsl:comment>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>  de-referenced id (type: <xsl:value-of select="name($chunk)"/>) is <xsl:value-of select="$chunk_id"/>.</xsl:message>
                
                <xsl:variable name="href" select="@href"/>
                
                <!-- Get the path portion of the href. -->
                <xsl:variable name="file_path" select="replace(@href,'^(.*)/[^/]*$','$1')"/>
                <!-- Get the filename potion of the href, minus the extension. -->
                <xsl:variable name="base_filename" select="replace(@href,'^.*/([^/]*).dita$','$1')"/>
                
                <xsl:message>  file_path is <xsl:value-of select="$file_path"/>.</xsl:message>
                <xsl:message>  base_filename is <xsl:value-of select="$base_filename"/>.</xsl:message>
                
                <!-- Determine the sequence number for the chunk. -->
                <xsl:variable name="sequence">
                    <xsl:text>_</xsl:text>
                    <xsl:number value="$counter" format="a"/>                    
                </xsl:variable>
                
                <xsl:variable name="filename" select="concat($file_path,'/',$base_filename,$sequence,'.dita')"/>
                <xsl:message>  filename is <xsl:value-of select="$filename"/>.</xsl:message>
                
                <xsl:variable name="topic_id" select="concat($base_filename,$sequence)"/>
                <xsl:message>  topic_id is <xsl:value-of select="$topic_id"/>.</xsl:message>
                
                <!-- Process the new topic into a variable, so we can count the number of <fn> elements. -->
                <xsl:variable name="new_topic_chunk" as="element()*">
                    <!-- Passes in the entire topic. We then have to find the chunk and output only that portion. -->
                    <xsl:apply-templates select="$topic" mode="chunk_topic">
                        <xsl:with-param name="chunk_id" select="$chunk_id"/>
                        <xsl:with-param name="counter" select="$counter"/>
                        <xsl:with-param name="chunk_map" select="$chunk_map"/>
                        <xsl:with-param name="topic_id" select="$topic_id"/>
                    </xsl:apply-templates>
                    
                </xsl:variable>
                
                <!-- Generate the new file. -->
                <xsl:result-document href="{$filename}" 
                    doctype-public="-//OASIS//DTD DITA Topic//EN" 
                    doctype-system="http://docs.oasis-open.org/dita/v1.1/OS/dtd/topic.dtd">
                    <!-- All mode="new_topic" templates are defined in new_topic_task.xsl. -->
                    <xsl:copy-of select="$new_topic_chunk"/>
                </xsl:result-document>
                
                <!-- Count the number of <fn> elements. -->
                <xsl:variable name="fn_count" select="count($new_topic_chunk/descendant-or-self::*[contains(@class,' topic/fn ')])"/>
                
                <!-- Create the reference. -->
                <xsl:element name="{$ref-element}" >
                    <xsl:attribute name="orig_href">
                        <xsl:value-of select="$filename"/>
                    </xsl:attribute>
                    <!-- Set the task_category. If it's not a task, find another related value. -->
                    <xsl:attribute name="task_category">
                        <xsl:value-of select="$task_category_attr"/>
                    </xsl:attribute>
                    
                    <xsl:attribute name="type">
                        <xsl:value-of select="$type_attr"/>
                    </xsl:attribute>
<!--                    <xsl:message>  ** preceding sibling type is <xsl:value-of select="name($chunk/preceding-sibling::*[1])"/>.</xsl:message>-->
                    <xsl:if test="$shortdesc != ''">
                        <xsl:attribute name="shortdesc">
                            <xsl:value-of select="$shortdesc"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:attribute name="fn_count">
                        <xsl:value-of select="$fn_count"/>
                    </xsl:attribute>
                    
                    <!--                    <xsl:message>  ** preceding sibling type is <xsl:value-of select="name($chunk/preceding-sibling::*[1])"/>.</xsl:message>-->
                    <!-- [SP] 2015-06-18 sfb: NOTE! this was not in the calendar tranform at all. -->
                    <xsl:if test="not(empty($navtitle))">
                        <navtitle>
                            <xsl:choose>
                                <xsl:when test="$counter = 1">
                                    <xsl:copy-of select="$navtitle"/>
                                </xsl:when>
                                <xsl:when test="$counter = 2 and $chunk/preceding-sibling::initial/@empty='yes'">
                                    <xsl:copy-of select="$navtitle"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:copy-of select="$navtitle"/>
                                    <xsl:value-of select="' (cont.)'"/>                            
                                </xsl:otherwise>
                            </xsl:choose>
                        </navtitle>
                    </xsl:if>
                    
                    <xsl:if test="$first-task-chunk = 'yes'">
                        <xsl:call-template name="chunk_map_iterator">
                            <xsl:with-param name="topic" select="$topic"/>
                            <xsl:with-param name="chunk_map" select="$chunk_map"/>
                            <xsl:with-param name="task_category_attr" select="$task_category_attr"/>
                            <xsl:with-param name="type_attr" select="$type_attr"/>
                            <xsl:with-param name="navtitle" select="$navtitle"/>
                            <xsl:with-param name="shortdesc" select="$shortdesc"/>
                            <xsl:with-param name="counter" select="$counter + 1"/>
                        </xsl:call-template>
                        
                        <!-- Handle the topicsubject elements that were keyref'ed. -->
                        <xsl:comment>Handling topicsubject. </xsl:comment>
                        <xsl:apply-templates select="*[contains(@class,' classify-d/topicsubject ')]"/>
                        
                        <!-- Handle any nested topicrefs (specifically, note no @class matching). -->
                        <xsl:comment>Handling nested topicrefs. </xsl:comment>
                        <xsl:apply-templates select="topicref"/>
                    </xsl:if>
                    
                    <!-- For page-turner topics (concepts nested in tasks), 
                        the topicsubject elements are preceding siblings, not children. -->
                    <xsl:if test="name($topic) = 'kpe-concept'">
<!--                        <xsl:comment>handing preceding sibling topicsubject elements for kpe-concept.</xsl:comment>-->
                        <xsl:apply-templates
                            select="preceding-sibling::*[contains(@class,' classify-d/topicsubject ')]"/>
                    </xsl:if>
                    
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>

        <!-- Then recurse with the next chunk, if we need. -->
        <xsl:if test="$counter &lt; count($chunk_map/descendant::*) and $first-task-chunk = 'no'">
            <xsl:call-template name="chunk_map_iterator">
                <xsl:with-param name="topic" select="$topic"/>
                <xsl:with-param name="chunk_map" select="$chunk_map"/>
                <xsl:with-param name="task_category_attr" select="$task_category_attr"/>
                <xsl:with-param name="type_attr" select="$type_attr"/>
                <xsl:with-param name="navtitle" select="$navtitle"/>
                <xsl:with-param name="shortdesc" select="$shortdesc"/>
                <xsl:with-param name="counter" select="$counter + 1"/>
            </xsl:call-template>
        </xsl:if>
        
<!--        <!-\- Finally, if we're in a chunked task, we may need to deal with subjects. -\->
        <!-\- In the case of chunked tasks, we also want to handle any nested topicsubject or topicrefs. -\->
        <!-\- Handle the topicsubject elements that were keyref'ed. -\->
        <xsl:comment>XYZZY: class is <xsl:value-of select="$topic/@class"/>. </xsl:comment>
        <xsl:comment>element is <xsl:value-of select="name($topic)"/>. </xsl:comment>
        <xsl:if test="contains($topic/@class,' kpe-task/kpe-task ')">
            <xsl:comment>Handling nested topicsubject?</xsl:comment>
            <xsl:apply-templates select="*[contains(@class,' classify-d/topicsubject ')]"/>
        </xsl:if>
        
-->    </xsl:template>
    
    <xsl:template match="*[contains(@class,' topic/body ')]" mode="chunk_map" priority="100">
        <chunk_map>
            <xsl:attribute name="id">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>
            
            <!-- Create placeholder for initial content. -->
            <initial>
                <!-- Indicate whether it's empty or not. -->
                <xsl:attribute name="empty">
                    <xsl:choose>
                        <xsl:when test="name(*[1]) = 'section'">
                            <xsl:text>yes</xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>no</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </initial>
            
            <xsl:apply-templates select="*" mode="chunk_map"/>
            
        </chunk_map>
        
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' topic/section ')]" mode="chunk_map" priority="100">
        <section>
            <xsl:attribute name="id">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>
            
            <xsl:apply-templates select="*" mode="chunk_map"/>
            
        </section>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' topic/data ') and @name='pace_break' and upper-case(@value)='Y']" mode="chunk_map" priority="100">
        <break>
            <xsl:attribute name="id">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>
        </break>
    </xsl:template>
    
    <xsl:template match="*" mode="chunk_map">
        <xsl:apply-templates select="*" mode="chunk_map"/>
    </xsl:template>
      
    <xsl:template match="*[contains(@class,' map/topicref ') and @type='kpe-assessmentOverview']"
        mode="Learning_Exam">

        <xsl:variable name="topic" select="document(@href)/*" as="element()*"/>
        <xsl:variable name="category" select="$topic//lmsCategory/@value"/>
        <xsl:variable name="navtitle">
            <xsl:call-template name="get_navtitle"/>
        </xsl:variable>

<!--        <xsl:comment>Added at line 996.</xsl:comment>-->
        <examMap>
            <xsl:attribute name="orig_href">
                <xsl:value-of select="@href"/>
            </xsl:attribute>
            <!-- [SP] 2016-09-02 sfb: Add task_category, so this is handled correctly within tasks.-->
            <xsl:attribute name="task_category">
                <xsl:text>exam</xsl:text>
            </xsl:attribute>
            <xsl:if test="$category != ''">
                <xsl:attribute name="assessment_type">
                    <xsl:value-of select="$category"/>
                </xsl:attribute>
            </xsl:if>

            <navtitle>
                <xsl:copy-of select="$navtitle"/>
            </navtitle>
            <!-- Create entries for each of the topicrefs. -->
            <xsl:apply-templates select="topicref" mode="exam_topicref"/>
<!--            <xsl:apply-templates
                select="*[contains(@class,' map/topicref ') and not(contains(@class,' subjectScheme/subjectdef '))]"
                mode="exam_topicref"/>-->
        </examMap>

    </xsl:template>

    <xsl:template match="*[contains(@class, ' map/topicref ')]" mode="exam_topicref">
        <topicref orig_href="{@href}" type="{@type}" task_category="{@type}">
            <xsl:apply-templates select="*[contains(@class,' classify-d/topicsubject ')]"/>
            <xsl:apply-templates select="difficulty"/>
            <xsl:apply-templates select="sortOrder"/>
        </topicref>
    </xsl:template>
<!--PSB UPDATED TO INCLUDE @BASE 11/11/16-->
    <xsl:template match="*[contains(@class,' classify-d/topicsubject ')]">
        <topicsubject>
            <xsl:attribute name="orig_href">
                <xsl:value-of select="@href"/>
            </xsl:attribute>
            <xsl:attribute name="keyref">
                <xsl:value-of select="@keyref"/>
            </xsl:attribute>
            <xsl:if test="@base">
                <xsl:attribute name="base">
                    <xsl:value-of select="@base"/>
                </xsl:attribute>                
            </xsl:if>
        </topicsubject>
        
        
        <!--<xsl:choose>
            <xsl:when test="@orig_href and @orig_href != ''">
                <topicsubject>
                    <xsl:attribute name="orig_href">
                        <xsl:value-of select="@href"/>
                    </xsl:attribute>
                    <xsl:attribute name="keyref">
                        <xsl:value-of select="@keyref"/>
                    </xsl:attribute>
                </topicsubject>
            </xsl:when>
            <xsl:when test="@href and @href != ''">
                <topicsubject>
                    <xsl:attribute name="orig_href">
                        <xsl:value-of select="@href"/>
                    </xsl:attribute>
                    <xsl:attribute name="keyref">
                        <xsl:value-of select="@keyref"/>
                    </xsl:attribute>
                </topicsubject>
            </xsl:when>
            <xsl:otherwise>
                <topicsubject>
                    <xsl:attribute name="keyref">
                        <xsl:value-of select="@keyref"/>
                    </xsl:attribute>
                </topicsubject>
            </xsl:otherwise>
            
        </xsl:choose>-->
    </xsl:template>
    
    <xsl:template match="sortOrder">
        <sortOrder>
            <xsl:apply-templates/>
        </sortOrder>
    </xsl:template>
    
    <xsl:template match="difficulty">
        <difficulty>
            <xsl:attribute name="value">
                <xsl:value-of select="@value"/>
            </xsl:attribute>
        </difficulty>
    </xsl:template>

    <xsl:template name="find_unique_los">
        <xsl:param name="has_intro"/>

        <xsl:variable name="all_subject_defs"
            select="//*[contains(@class,' subjectScheme/subjectdef ')]"/>
        <xsl:for-each-group select="$all_subject_defs" group-by="@keys">
            <xsl:variable name="subjectdef" select="current-group()[1]"/>
            <xsl:variable name="title">
                <xsl:apply-templates
                    select="current-group()[descendant::*[contains(@class,' topic/navtitle ') and child::text() != '']][1]/descendant::*[contains(@class,' topic/navtitle ')]"
                />
            </xsl:variable>

            <xsl:variable name="keys" select="$subjectdef/@keys"/>


            <xsl:if test="$subjectdef/@href">
                <los>
                    <!-- Deprecating name.  Check with Sarah to see if she's using it. -->
                    <xsl:attribute name="name" select="$keys"/>
                    <xsl:attribute name="keys" select="$keys"/>
                    <xsl:attribute name="orig_href" select="$subjectdef/@href"/>
                    <xsl:if test="$title != ''">
                        <xsl:attribute name="title" select="$title"/>
                    </xsl:if>
                </los>
            </xsl:if>

        </xsl:for-each-group>

    </xsl:template>
    
    <!-- This portion of the code takes in the entire topic, a chunk ID, and the chunk map.
         It then finds the chunk and transforms it to the output stream. -->
        
    <!-- CHUNKING IDENTITY TRANSFORMS -->
    <xsl:template match="node()" mode="chunk_topic">
        <xsl:param name="chunk_id"/>
        <xsl:param name="counter"/>
        <xsl:param name="chunk_map" as="element()*"/>
        <xsl:param name="topic_id"/>
        
        <xsl:copy>
            <xsl:choose>
                <!-- If we're in a topic. -->
                <xsl:when test="contains(@class,' topic/topic ')">
                    <!-- Insert our own ID.-->
                    <xsl:attribute name="id">
                        <xsl:value-of select="$topic_id"/>
                    </xsl:attribute>
                    <!-- Process other attributes (but not ID). -->
                    <xsl:apply-templates select="@*[not(name() = 'id')]" mode="chunk_topic"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="@*" mode="chunk_topic"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="node()" mode="chunk_topic">
                <xsl:with-param name="chunk_id" select="$chunk_id"/>
                <xsl:with-param name="counter" select="$counter"/>
                <xsl:with-param name="chunk_map" select="$chunk_map"/>
                <xsl:with-param name="topic_id" select="$topic_id"/>
                
            </xsl:apply-templates>
        </xsl:copy>
        
    </xsl:template>
    
    <!-- General attribute handler. -->
    <xsl:template match="@*" mode="chunk_topic">
        <xsl:copy/>
    </xsl:template>
    
    <!-- Add "(cont.)" to titles, if needed.
         (Only modify title for section or topic titles.) -->
    <xsl:template match="*[contains(@class,' topic/title ') and (parent::section or parent::*[contains(@class,' topic/topic ')])]" mode="chunk_topic" priority="100">
        <xsl:param name="chunk_id"/>
        <xsl:param name="counter"/>
        <xsl:param name="chunk_map" as="element()*"/>
        <xsl:param name="topic_id"/>
        
        
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="chunk_topic"/>
            <xsl:apply-templates select="node()" mode="chunk_topic">
                <xsl:with-param name="chunk_id" select="$chunk_id"/>
                <xsl:with-param name="counter" select="$counter"/>
                <xsl:with-param name="chunk_map" select="$chunk_map"/>
                <xsl:with-param name="topic_id" select="$topic_id"/>
            </xsl:apply-templates>

            <!-- Add "if" for subsequent entries. -->
            <!-- Need to check if first chunk was empty. 
                 There may be better ways to work this out, but this works...
                -->
             <!-- [SP] 2015-06-18 sfb: See note above, these are probably related. -->
            <xsl:variable name="chunk" select="$chunk_map/descendant::*[position() = $counter]"/>
            <xsl:choose>
                <xsl:when test="$counter = 1 or ($counter = 2 and $chunk/preceding-sibling::initial/@empty='yes')">
                    <!-- Do nothing. -->
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text> (cont.)</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
            
<!--            <xsl:if test="$counter &gt; 1 and not($chunk/preceding-sibling::initial/@empty='yes')">
                <xsl:text> (cont.)</xsl:text>            
            </xsl:if>-->
        </xsl:copy>
    </xsl:template>

    <!-- Body: where (most) everything happens. -->
    <xsl:template match="*[contains(@class,' topic/body ')]" mode="chunk_topic" priority="100">
        <xsl:param name="chunk_id"/>
        <xsl:param name="counter"/>
        <xsl:param name="chunk_map" as="element()*"/>
        <xsl:param name="topic_id"/>
        
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="chunk_topic"/>
            
            <!-- Now figure out what chunk to drop in... -->
            <!-- The cases are:
                 * break at the body level
                 * break at the section level
                 * the first chunk before the first break or section.
                 * a section. -->
<!--            <xsl:comment>In chunk_topic, looking for a <xsl:value-of select="name($chunk_map/descendant::*[position()=$counter])"/>.</xsl:comment>-->
            <xsl:choose>
                <!-- We're looking for a break. -->
                <xsl:when test="name($chunk_map/descendant::*[position()=$counter]) ='break'">
                    <xsl:choose>
                        <!-- If the break has a parent that's a section, we'll have to open the section first. -->
                        <xsl:when test="$chunk_map/descendant::*[position()=$counter]/parent::*[name() = 'section']">
                            
                            <xsl:variable name="parent_section_id" select="$chunk_map/descendant::*[position() = $counter]/parent::*/@id"/>
<!--                            <xsl:comment>chunk_topic for parent section id=<xsl:value-of select="$parent_section_id"/>.</xsl:comment>-->
                            <xsl:apply-templates select="section[generate-id() = $parent_section_id]" mode="chunk_topic">
                                <xsl:with-param name="chunk_id" select="$chunk_id"/>
                                <xsl:with-param name="counter" select="$counter"/>
                                <xsl:with-param name="chunk_map" select="$chunk_map"/>
                                <xsl:with-param name="topic_id" select="$topic_id"/>
                                
                            </xsl:apply-templates>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- Find the position of the data element. -->
                            <xsl:variable name="start_pos" 
                                select="count(*[descendant-or-self::data[@name='pace_break' and upper-case(@value)='Y' and generate-id() = $chunk_id]]/preceding-sibling::*)+1"/>
                            <!-- Gather all elements into a variable. -->
<!--                            <xsl:comment>start_pos is <xsl:value-of select="$start_pos"/>.</xsl:comment>-->
                            
                            <xsl:variable name="elements_after_break" as="element()*"
                                select="*[descendant-or-self::data[@name='pace_break' and upper-case(@value)='Y' and generate-id() = $chunk_id]]/following-sibling::*"/>
                            
                            <xsl:comment>elements_after_break contains <xsl:value-of select="count($elements_after_break)"/> elements.</xsl:comment>
                            <!-- Ensure that break_elements don't contain another pace_break, or a section. -->
                            <xsl:variable name="before_next_break_or_end_1" as="node()*">
                                <xsl:choose>
                                    <xsl:when test="$elements_after_break/descendant-or-self::data[@name='pace_break' and upper-case(@value)='Y']">
                                        <xsl:variable name="end_pos" 
                                            select="count($elements_after_break[descendant-or-self::data[@name='pace_break' and upper-case(@value)='Y']][1]/preceding-sibling::*) + 1"/>
<!--                                        <xsl:comment>end_pos (break) is <xsl:value-of select="$end_pos"/>.</xsl:comment>-->
                                        <xsl:copy-of select="*[position() &gt; $start_pos and position() &lt; $end_pos]"/>
                                    </xsl:when>
                                    <xsl:when test="$elements_after_break/descendant-or-self::section">
                                        <xsl:variable name="end_pos" 
                                            select="count($elements_after_break[descendant-or-self::section][1]/preceding-sibling::*) + 1"/>
<!--                                        <xsl:comment>end_pos (section) is <xsl:value-of select="$end_pos"/>.</xsl:comment>-->
                                        <xsl:copy-of select="*[position() &gt; $start_pos and position() &lt; $end_pos]"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:copy-of select="$elements_after_break"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
<!--                            <xsl:comment>before_next_break_or_end_1 contains <xsl:value-of select="count($before_next_break_or_end_1)"/> elements.</xsl:comment>-->
                            
                            <!-- Now process those elements. -->
                            <xsl:apply-templates select="$before_next_break_or_end_1" mode="chunk_break">
                                <xsl:with-param name="chunk_id" select="$chunk_id"/>
                                <xsl:with-param name="counter" select="$counter"/>
                                <xsl:with-param name="chunk_map" select="$chunk_map"/>
                            </xsl:apply-templates>                        
                            
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <!-- There are no breaks and no sections, just do an identity transform, up to the first break or section. -->
                <xsl:when test="xs:integer($counter) = 1">
                    <!-- Just process the content before the first break or section. -->
                    <xsl:choose>
                        <xsl:when test="data[@name='pace_break' and upper-case(@value)='Y']">
                            <!-- I'm puzzled why these come out in the right order, because they should be reversed. -->
                            <xsl:apply-templates select="data[@name='pace_break' and upper-case(@value)='Y']/preceding-sibling::*" mode="chunk_topic_identity"/>
                        </xsl:when>
                        <xsl:when test="section">
                            <xsl:apply-templates select="*[not(self::section)]" mode="chunk_topic_identity"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
                <!-- Process a section. -->
                <xsl:otherwise>
                    <xsl:apply-templates select="section[generate-id() = $chunk_id]" mode="chunk_topic">
                        <xsl:with-param name="chunk_id" select="$chunk_id"/>
                        <xsl:with-param name="counter" select="$counter"/>
                        <xsl:with-param name="chunk_map" select="$chunk_map"/>
                        <xsl:with-param name="topic_id" select="$topic_id"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/section ')]" mode="chunk_topic" priority="100">
        <xsl:param name="chunk_id"/>
        <xsl:param name="counter"/>
        <xsl:param name="chunk_map" as="element()*"/>
        <xsl:param name="topic_id"/>
        
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="chunk_topic"/>

            <!-- Find the section element in the map again. -->
            <xsl:variable name="chunk_map_element" select="$chunk_map/descendant::*[position() = $counter]" as="element()"/>
<!--            <xsl:comment>Got <xsl:value-of select="name($chunk_map_element)"/>. </xsl:comment>-->
            
            <xsl:choose>
                <!-- We're in a section and we're looking for a section...good. -->
                <xsl:when test="name($chunk_map_element) = 'section'">
                    <!-- Test to see if the section contains any breaks. -->
                    <xsl:choose>
                        <!-- There is a break in this section.  Yikes.  -->
                        <xsl:when test="descendant-or-self::data[@name='pace_break' and upper-case(@value)='Y']">
                            <!-- Process the content up to that break. -->
                            <!-- Get the elements up to the break. -->
                            <xsl:variable name="break_elements" as="element()*"
                                select="*[descendant-or-self::data[@name='pace_break' and upper-case(@value)='Y']][1]/preceding-sibling::*"/>
<!--                            <xsl:comment>break_elements contains <xsl:value-of select="count($break_elements)"/> elements.</xsl:comment>-->
                            
                            <xsl:apply-templates select="$break_elements" mode="chunk_break">
                                <xsl:with-param name="chunk_id" select="$chunk_id"/>
                                <xsl:with-param name="counter" select="$counter"/>
                                <xsl:with-param name="chunk_map" select="$chunk_map"/>
                            </xsl:apply-templates>                        

                        </xsl:when>
                        <!-- No breaks, proceed with caution. -->
                        <xsl:otherwise>
                            <xsl:apply-templates select="node()" mode="chunk_topic_identity"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    
                </xsl:when>
                <!-- We're in a section, but we're looking for a specific break. Uh oh. -->
                <xsl:when test="name($chunk_map_element) = 'break'">
                    <!-- Process the section title with "(cont.)". -->
                    <xsl:apply-templates select="title" mode="chunk_topic">
                        <xsl:with-param name="chunk_id" select="$chunk_id"/>
                        <xsl:with-param name="counter" select="$counter"/>
                        <xsl:with-param name="chunk_map" select="$chunk_map"/>
                        <xsl:with-param name="topic_id" select="$topic_id"/>                       
                    </xsl:apply-templates>
                    
                    <!-- Find the position of the data element. -->
                    <xsl:variable name="start_pos" 
                        select="count(*[descendant-or-self::data[@name='pace_break' and upper-case(@value)='Y' and generate-id() = $chunk_id]]/preceding-sibling::*)+1"/>
                    <!-- Gather all elements into a variable. -->
<!--                    <xsl:comment>start_pos is <xsl:value-of select="$start_pos"/>.</xsl:comment>-->
                    
                    <xsl:variable name="elements_after_break" as="element()*"
                        select="*[descendant-or-self::data[@name='pace_break' and upper-case(@value)='Y' and generate-id() = $chunk_id]]/following-sibling::*"/>
                    
<!--                    <xsl:comment>elements_after_break contains <xsl:value-of select="count($elements_after_break)"/> elements.</xsl:comment>-->
                    <!-- Ensure that break_elements don't contain another pace_break. -->
                    <xsl:variable name="before_next_break_or_end_2" as="node()*">
                        <xsl:choose>
                            <xsl:when test="$elements_after_break/descendant-or-self::data[@name='pace_break' and upper-case(@value)='Y']">
                                <xsl:variable name="end_pos" 
                                    select="count($elements_after_break[descendant-or-self::data[@name='pace_break' and upper-case(@value)='Y']][1]/preceding-sibling::*) + 1"/>
<!--                                <xsl:comment>end_pos is <xsl:value-of select="$end_pos"/>.</xsl:comment>-->
                                <xsl:copy-of select="*[position() &gt; $start_pos and position() &lt; $end_pos]"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:copy-of select="$elements_after_break"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
<!--                    <xsl:comment>before_next_break_or_end_2 contains <xsl:value-of select="count($before_next_break_or_end_2)"/> elements.</xsl:comment>-->
                    
                    
                    <!-- Now process those elements. -->
                    <xsl:apply-templates select="$before_next_break_or_end_2" mode="chunk_break">
                        <xsl:with-param name="chunk_id" select="$chunk_id"/>
                        <xsl:with-param name="counter" select="$counter"/>
                        <xsl:with-param name="chunk_map" select="$chunk_map"/>
                    </xsl:apply-templates>                        

                </xsl:when>
            </xsl:choose>
            
        </xsl:copy>
        
    </xsl:template>
    
    
    <!-- Found a break...  -->    
    <xsl:template match="data[@name='pace_break' and upper-case(@value)='Y']" mode="find_break_in_section" priority="100">
        <xsl:param name="chunk_id"/>
        <xsl:param name="counter"/>
        <xsl:param name="chunk_map" as="element()*"/>
        
        <!-- At this point, we don't need to make any decision, just throw away the break. 
            (all the decisions about before or after the break have been handled by it's ancestors. -->
    </xsl:template>
    
    <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
    <!-- Identity transform to process everything except things before or after a break. -->
    <!-- This template only gets elements that must be output. The question is: how much of the element should get output. -->
    <xsl:template match="node()" mode="chunk_break">
        <xsl:param name="chunk_id"/>
        <xsl:param name="counter"/>
        <xsl:param name="chunk_map" as="element()*"/>
        
        <xsl:choose>
            <!-- The current element doesn't contain a break, so just output it. -->
            <xsl:when test="not(descendant-or-self::data[@name='pace_break' and upper-case(@value)='Y'])">
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()" mode="chunk_topic_identity"/> 
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="chunk_map_element" select="$chunk_map/descendant::*[position() = $counter]" as="element()"/>
                <xsl:copy>
                    <xsl:apply-templates select="@*" mode="chunk_break"/>
                    <xsl:choose>
                        <!-- Are we looking for the elements before a break or after? -->
                        <!-- We can tell by seeing if the element contains the specific break. -->
                        <xsl:when test="descendant-or-self::data[@name='pace_break' and upper-case(@value)='Y' and generate-id() = $chunk_id]">
                            <!-- Find the elements after the break. -->
                            <!-- Find the position of the data element. -->
                            <xsl:variable name="start_pos" 
                                select="count(*[descendant-or-self::data[@name='pace_break' and upper-case(@value)='Y' and generate-id() = $chunk_id]]/preceding-sibling::*)+1"/>
                            <!-- Gather all elements into a variable. -->
<!--                            <xsl:comment>start_pos is <xsl:value-of select="$start_pos"/>.</xsl:comment>-->
                            
                            <xsl:variable name="elements_after_break" as="element()*"
                                select="*[descendant-or-self::data[@name='pace_break' and upper-case(@value)='Y' and generate-id() = $chunk_id]]/following-sibling::*"/>
                            
<!--                            <xsl:comment>elements_after_break contains <xsl:value-of select="count($elements_after_break)"/> elements.</xsl:comment>-->
                            <!-- Ensure that break_elements don't contain another pace_break. -->
                            <xsl:variable name="before_next_break_or_end_3" as="node()*">
                                <xsl:choose>
                                    <xsl:when test="$elements_after_break/descendant-or-self::data[@name='pace_break' and upper-case(@value)='Y']">
                                        <xsl:variable name="end_pos" 
                                            select="count($elements_after_break[descendant-or-self::data[@name='pace_break' and upper-case(@value)='Y']][1]/preceding-sibling::*) + 1"/>
                                        <xsl:copy-of select="*[position() &gt; $start_pos and position() &lt; $end_pos]"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:copy-of select="$elements_after_break"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
<!--                            <xsl:comment>before_next_break_or_end_3 contains <xsl:value-of select="count($before_next_break_or_end_3)"/> elements.</xsl:comment>-->
                            
                            <!-- Now process those elements. -->
                            <xsl:apply-templates select="$before_next_break_or_end_3" mode="chunk_break">
                                <xsl:with-param name="chunk_id" select="$chunk_id"/>
                                <xsl:with-param name="counter" select="$counter"/>
                                <xsl:with-param name="chunk_map" select="$chunk_map"/>
                            </xsl:apply-templates>                        
                            
                        </xsl:when>
                        <!--  So we're looking for the end of a break. -->                   
                        <xsl:otherwise>
                            <!-- Find the elements before the break. -->
                            <!-- Get the elements up to the break. -->
                            <xsl:variable name="break_elements" as="element()*"
                                select="*[descendant-or-self::data[@name='pace_break' and upper-case(@value)='Y']][1]/preceding-sibling::*"/>
<!--                            <xsl:comment>break_elements contains <xsl:value-of select="count($break_elements)"/> elements.</xsl:comment>-->
                            <xsl:apply-templates select="$break_elements" mode="chunk_break">
                                <xsl:with-param name="chunk_id" select="$chunk_id"/>
                                <xsl:with-param name="counter" select="$counter"/>
                                <xsl:with-param name="chunk_map" select="$chunk_map"/>
                            </xsl:apply-templates>                        
                                
                        </xsl:otherwise>
                        
                    </xsl:choose>
                </xsl:copy>
                
                
            </xsl:otherwise>
        </xsl:choose>
            
    </xsl:template>
    <xsl:template match="@*" mode="chunk_break">
        <xsl:copy/>
    </xsl:template>
    
    <!-- Handle fn. -->
    <xsl:template match="*[contains(@class,' topic/fn ')]" mode="chunk_break">
        <xsl:copy>
            <!-- otherprops probably isn't necessary. -->
            <xsl:attribute name="otherprops">
                <xsl:value-of select="count(preceding::*[contains(@class,' topic/fn ')]) + 1"/>
            </xsl:attribute>
            <xsl:apply-templates select="@* | node()" mode="chunk_topic_identity"/>
        </xsl:copy>
    </xsl:template>
    

    <xsl:template match="data[@name='pace_break' and upper-case(@value)='Y']" mode="chunk_break" priority="100">
        <!-- Do nothing. -->
    </xsl:template>
    
    
    <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
    <!-- Identity transform to output chunk content. -->
    <xsl:template match="@*|node()" mode="chunk_topic_identity">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" mode="chunk_topic_identity"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Have to detect fn's and determine its position. -->
    <xsl:template match="*[contains(@class,' topic/fn ')]" mode="chunk_topic_identity">
        <xsl:copy>
            <xsl:attribute name="otherprops">
                <xsl:value-of select="count(preceding::*[contains(@class,' topic/fn ')]) + 1"/>
            </xsl:attribute>
            <xsl:apply-templates select="@* | node()" mode="chunk_topic_identity"/>
        </xsl:copy>
    </xsl:template>
    

</xsl:stylesheet>
