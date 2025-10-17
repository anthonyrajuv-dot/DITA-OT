<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:functx="http://www.functx.com"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"    
    exclude-result-prefixes="xs functx ditaarch" version="2.0">

    <xsl:import href="functx-1.0.xsl"/>
    <xsl:import href="new_topic_task.xsl"/>

    <xsl:param name="BASE_DIR"/>
    <xsl:param name="OUT_DIR"/>
    
    <xsl:output encoding="UTF-8" method="xml" indent="yes"
        doctype-public="-//OASIS//DTD DITA Map//EN" doctype-system="map.dtd"/>
    
    <xsl:strip-space elements="*"/>
    
    <!-- Create a global variable so that we can refer back to the supermap. -->
    <xsl:variable name="supermap" select="/supermap" as="element()*"/>
    
    <!-- Create a global variable so that we can refer back to the los. -->
    <xsl:variable name="los_summary" select="/supermap/los_summary" as="element()*"/>

    <xsl:template match="/">
        <xsl:apply-templates select="supermap"/>
    </xsl:template>

    <xsl:template match="supermap">
        <map>
            <xsl:attribute name="title">
                <xsl:value-of select="@title"/>
            </xsl:attribute>
            <xsl:attribute name="id">
                <xsl:value-of select="@id"/>
            </xsl:attribute>

            <!-- Handle topicheads. -->
            <xsl:apply-templates select="topichead"/>
            
            <!-- Create the final exam map outside all other topic heads. -->
            <xsl:apply-templates select="topichead[@unit_map_type='final-exam']/examMap">
                
            </xsl:apply-templates>

            <!-- Handle LOS. -->
            <xsl:apply-templates select="los_summary"/>

            <!-- Build the reltable... -->
            <!-- Commented out for MREP-19, until PACE requires it again. -->
            
            <!--            
            <reltable title="Table Mapping">
                <relheader>
                    <relcolspec type="topic"/>
                    <relcolspec type="topic"/>
                    <relcolspec type="topic"/>
                </relheader>
                <xsl:apply-templates select="topichead" mode="reltable"/>
            </reltable>
-->

        </map>
    </xsl:template>
    
    <!-- Top level topichead. -->
    <xsl:template match="topichead">
        <!-- Made these parameters so that subordinate topicheads behave correctly...I think. -->
        <xsl:param name="all_topic_refs" select="topicref[@type='topic' or @type='concept']" as="element()*"/>
        <xsl:param name="all_question_refs" select="topicref[@type='question']" as="element()*"/>
        <xsl:param name="all_exam_refs" select="topicref[@type='exam']" as="element()*"/>
        <!-- Added for QBank -->
        <xsl:param name="all_exam_maps" select="descendant-or-self::examMap" as="element()*"/>
        
        <!-- [SP] 2015-01-13: Don't display topichead in qbank output. -->
        <xsl:choose>
            <xsl:when test="@unit_map_type = 'qbank'">
                <xsl:apply-templates select="*[not(self::examMap[@assessment_type='test-exam-primary'])]">
                    <xsl:with-param name="all_topic_refs" select="$all_topic_refs"/>
                    <xsl:with-param name="all_question_refs" select="$all_question_refs"/>
                    <xsl:with-param name="all_exam_refs" select="$all_exam_refs"/>
                    <xsl:with-param name="all_exam_maps" select="$all_exam_maps"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:attribute name="navtitle">
                        <xsl:choose>
                            <xsl:when test="navtitle">
                                <xsl:apply-templates select="navtitle"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@navtitle"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                	<xsl:attribute name="audience">
                		<xsl:choose>
                			<xsl:when test="audience">
                				<xsl:apply-templates select="audience"/>
                			</xsl:when>
                			<xsl:otherwise>
                				<xsl:value-of select="@audience"/>
                			</xsl:otherwise>
                		</xsl:choose>
                	</xsl:attribute>
                    
                    <xsl:apply-templates select="*[not(self::examMap[@assessment_type='test-exam-primary']) and not(self::navtitle)]">
                        <xsl:with-param name="all_topic_refs" select="$all_topic_refs"/>
                        <xsl:with-param name="all_question_refs" select="$all_question_refs"/>
                        <xsl:with-param name="all_exam_refs" select="$all_exam_refs"/>
                        <xsl:with-param name="all_exam_maps" select="$all_exam_maps"/>
                    </xsl:apply-templates>
                </xsl:copy>
                
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:copy/>
    </xsl:template>


    <xsl:template match="topicref">
        <xsl:param name="all_topic_refs" as="element()*"/>
        <xsl:param name="all_question_refs" as="element()*"/>
        <xsl:param name="all_exam_refs" as="element()*"/>
        <xsl:param name="all_exam_maps" as="element()*"/>
        
        <xsl:variable name="topic_number" select="functx:index-of-node($all_topic_refs,.)"/>
        <xsl:variable name="question_number" select="functx:index-of-node($all_question_refs,.)"/>
        <xsl:variable name="exam_number" select="functx:index-of-node($all_exam_refs,.)"/>
        
<!--        <xsl:variable name="task_number" select="count(preceding-sibling::topicref) + 1"/>-->
        <xsl:variable name="task_number" select="count(preceding-sibling::topicref[@task_category!='page_turner']) + 1"/>

        <!-- For MREP-19: Assuming lesson numbers always take the form: "Lesson mumble: title" -->
        <xsl:variable name="lesson_number">
            <xsl:if test="parent::topichead[starts-with(navtitle[1]/text(),'Lesson')]">
                <xsl:value-of select="replace(parent::topichead/navtitle[1]/text(),'^Lesson\s([^:]*): .*$','$1')"/>
            </xsl:if>
        </xsl:variable>
        
        <!-- Get the category number. -->
        <xsl:variable name="this_category" select="@task_category"/>
        <xsl:variable name="category_number" select="count(preceding-sibling::topicref[@task_category=$this_category]) + 1"/>
        
        <!-- Get the navtitle. -->
        <xsl:variable name="navtitle" select="navtitle[1]/node()"/>
        
        <!-- Create the related files. -->
        <xsl:variable name="topic" select="document(@orig_href)/*" as="element()*"/>
        
<!--        <xsl:message>old_href is: <xsl:value-of select="@orig_href"/></xsl:message>-->

        <!-- Determine the outputs needed. -->
        <xsl:message>*** Creating topic files for: <xsl:value-of select="@task_category"/>.</xsl:message>
        <xsl:choose>
            <xsl:when test="@task_category = 'reading' and parent::*/@unit_map_type='unit-exam'">
                <xsl:call-template name="new_topic">
                    <xsl:with-param name="topic" select="$topic"/>
                    <xsl:with-param name="name_base" select="ancestor::topichead[@name_base][1]/@name_base"/>
                    <xsl:with-param name="unit" select="ancestor::topichead[@unit][1]/@unit"/>
                    <xsl:with-param name="topic_number" select="$topic_number"/>
                    <xsl:with-param name="task_category" select="@task_category"/>
                    <xsl:with-param name="navtitle" select="$navtitle"/>
                </xsl:call-template>
            </xsl:when>
            
            <xsl:when test="contains('activity presentation reading default',@task_category)">
                <xsl:call-template name="new_topic">
                    <xsl:with-param name="topic" select="$topic"/>
                    <xsl:with-param name="name_base" select="ancestor::topichead[@name_base][1]/@name_base"/>
                    <xsl:with-param name="unit" select="ancestor::topichead[@unit][1]/@unit"/>
                    <xsl:with-param name="topic_number" select="$topic_number"/>
                    <xsl:with-param name="task_category" select="@task_category"/>
                    <xsl:with-param name="navtitle" select="$navtitle"/>
                </xsl:call-template>
                <xsl:call-template name="new_task">
                    <xsl:with-param name="topic" select="$topic"/>
                    <xsl:with-param name="name_base" select="ancestor::topichead[@name_base][1]/@name_base"/>
                    <xsl:with-param name="unit" select="ancestor::topichead[@unit][1]/@unit"/>
                    <xsl:with-param name="category_number" select="$category_number"/>
                    <xsl:with-param name="lesson_number" select="$lesson_number"/>
                    <xsl:with-param name="navtitle" select="$navtitle"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="@task_category = 'assignment'">
                <xsl:call-template name="new_task">
                    <xsl:with-param name="topic" select="$topic"/>
                    <xsl:with-param name="name_base" select="ancestor::topichead[@name_base][1]/@name_base"/>
                    <xsl:with-param name="unit" select="ancestor::topichead[@unit][1]/@unit"/>
                    <xsl:with-param name="category_number" select="$category_number"/>
                    <xsl:with-param name="lesson_number" select="$lesson_number"/>
                    <xsl:with-param name="navtitle" select="$navtitle"/>
                </xsl:call-template>
                <xsl:call-template name="new_assessment">
                    <xsl:with-param name="topic" select="$topic"/>
                    <xsl:with-param name="name_base" select="ancestor::topichead[@name_base][1]/@name_base"/>
                    <xsl:with-param name="unit" select="ancestor::topichead[@unit][1]/@unit"/>
                    <xsl:with-param name="question_number" select="$question_number"/>
                </xsl:call-template>
                <xsl:call-template name="new_question">
                    <xsl:with-param name="topic" select="$topic"/>
                    <xsl:with-param name="name_base" select="ancestor::topichead[@name_base][1]/@name_base"/>
                    <xsl:with-param name="unit" select="ancestor::topichead[@unit][1]/@unit"/>
                    <xsl:with-param name="question_number" select="$question_number"/>
                    <xsl:with-param name="navtitle" select="$navtitle"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="@task_category = 'quiz'">
                <xsl:call-template name="new_topic">
                    <xsl:with-param name="topic" select="$topic"/>
                    <xsl:with-param name="name_base" select="ancestor::topichead[@name_base][1]/@name_base"/>
                    <xsl:with-param name="unit" select="ancestor::topichead[@unit][1]/@unit"/>
                    <xsl:with-param name="topic_number" select="$topic_number"/>
                    <xsl:with-param name="task_category" select="@task_category"/>
                    <xsl:with-param name="navtitle" select="$navtitle"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="@task_category = 'exam'">
                <!-- Exams behave differently. -->
                <!-- Final exam doesn't generate a task, but generates a topic. -->
                <xsl:choose>
                    <xsl:when test="parent::*/@unit_map_type='final-exam' or parent::*/@unit_map_type='qbank' or parent::*/@unit_map_type='unit-exam'">
                        <xsl:call-template name="new_topic">
                            <xsl:with-param name="topic" select="$topic"/>
                            <xsl:with-param name="name_base" select="ancestor::topichead[@name_base][1]/@name_base"/>
                            <xsl:with-param name="unit" select="ancestor::topichead[@unit][1]/@unit"/>
                            <xsl:with-param name="topic_number" select="$topic_number"/>
                            <xsl:with-param name="task_category" select="@task_category"/>
                            <xsl:with-param name="navtitle" select="$navtitle"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="new_exam_task">
                            <xsl:with-param name="topic" select="$topic"/>
                            <xsl:with-param name="name_base" select="ancestor::topichead[@name_base][1]/@name_base"/>
                            <xsl:with-param name="unit" select="ancestor::topichead[@unit][1]/@unit"/>
                            <xsl:with-param name="task_number" select="$task_number"/>
                            <xsl:with-param name="exam_number" select="$exam_number"/>
                            <xsl:with-param name="navtitle" select="$navtitle"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>

                <!-- [SP] 2014-06-16: Not sure if this is correct for MREP-19... -->
                <!-- Prep for context switch. -->
                <xsl:variable name="name_base" select="ancestor::topichead[@name_base][1]/@name_base"/>
                <xsl:variable name="unit" select="ancestor::topichead[@unit][1]/@unit"/>
                
                <!-- Switch the context into the examMap. -->
                <!-- (Final exam goes outside of the last topichead, and is handled separately) -->
                <xsl:for-each select="following-sibling::examMap">
<!--                    <xsl:for-each select="following-sibling::examMap[@assessment_type!='test-exam-primary']">-->
                    <xsl:call-template name="new_exam_map">
                        <xsl:with-param name="topic" select="$topic"/>
                        <xsl:with-param name="name_base" select="$name_base"/>
                        <xsl:with-param name="exam_number" select="$exam_number"/>
                        <xsl:with-param name="unit" select="$unit"/>
                        <xsl:with-param name="navtitle">
                            <xsl:copy-of select="navtitle[1]"/>
                        </xsl:with-param>
                    </xsl:call-template>
                    
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="@task_category = 'concept' or @task_category = 'page_turner' or @task_category='kpe-concept'">
                <!-- So do concepts. -->
                <xsl:call-template name="new_concept">
                    <xsl:with-param name="topic" select="$topic"/>
                    <xsl:with-param name="name_base" select="ancestor::topichead[@name_base][1]/@name_base"/>
                    <xsl:with-param name="unit" select="ancestor::topichead[@unit][1]/@unit"/>
                    <xsl:with-param name="topic_number" select="$topic_number"/>
                    <xsl:with-param name="task_category" select="@task_category"/>
                    <xsl:with-param name="navtitle" select="$navtitle"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="@task_category = 'los_overview'">
                <xsl:call-template name="new_los_overview">
                    <xsl:with-param name="topic" select="$topic"/>
                    <xsl:with-param name="name_base" select="ancestor::topichead[@name_base][1]/@name_base"/>
                    <xsl:with-param name="unit" select="ancestor::topichead[@unit][1]/@unit"/>
                    <xsl:with-param name="topic_number" select="$topic_number"/>
                    <xsl:with-param name="navtitle" select="$navtitle"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="@task_category = 'summary' or @task_category = 'kpe-summary'">
                <xsl:call-template name="new_summary">
                    <xsl:with-param name="topic" select="$topic"/>
                    <xsl:with-param name="name_base" select="ancestor::topichead[@name_base][1]/@name_base"/>
                    <xsl:with-param name="unit" select="ancestor::topichead[@unit][1]/@unit"/>
                    <xsl:with-param name="topic_number" select="$topic_number"/>
                    <xsl:with-param name="navtitle" select="$navtitle"/>
                </xsl:call-template>
            </xsl:when>
            <!-- Added for MREP-19 QBank -->
            <xsl:when test="@task_category = 'kpe-question'">
                <xsl:call-template name="new_assessment_from_q">
                    <xsl:with-param name="topic" select="$topic"/>
                    <xsl:with-param name="name_base" select="ancestor::topichead[@name_base][1]/@name_base"/>
                    <xsl:with-param name="unit" select="ancestor::topichead[@unit][1]/@unit"/>
                    <xsl:with-param name="question_number" select="$question_number"/>
                    <xsl:with-param name="navtitle" select="$navtitle"/>
                </xsl:call-template>
            </xsl:when>
            
            <xsl:when test="@task_category = 'kpe-overview'">
                <xsl:call-template name="new_learning_overview">
                    <xsl:with-param name="topic" select="$topic"/>
                    <xsl:with-param name="task_category" select="@task_category"/>
                    <xsl:with-param name="navtitle" select="$navtitle"/>
                </xsl:call-template>
                
            </xsl:when>
            
            <!-- Ignore glossEntry elements. -->
            <xsl:when test="@task_category = 'kpe-glossEntry'">
                <!-- Do nothing. -->
            </xsl:when>
                
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="examMap">
        <xsl:param name="all_topic_refs" as="element()*"/>
        <xsl:param name="all_question_refs" as="element()*"/>
        <xsl:param name="all_exam_refs" as="element()*"/>
        <xsl:param name="all_exam_maps" as="element()*"/>
        <!-- This processing is handled through handling task_category="exam". -->
        
        <xsl:if test="not(preceding-sibling::topicref[@type='exam']) 
            or (@assessment_type='test-exam-primary' and ancestor::supermap[@category='default'])">
                        
            <xsl:variable name="exam_map_number" select="functx:index-of-node($all_exam_maps,.)"/>
            
            <xsl:variable name="topic" select="document(@orig_href)/*" as="element()*"/>
            <xsl:message>Creating new exam map from examMap template </xsl:message>
            <xsl:call-template name="new_exam_map">
                <xsl:with-param name="topic" select="$topic"/>
                <xsl:with-param name="name_base" select="ancestor::topichead[@name_base]/@name_base"/>
                <xsl:with-param name="exam_number" select="$exam_map_number"/>
                <xsl:with-param name="unit" select="ancestor::topichead[@unit]/@unit"/>
                <xsl:with-param name="assessment_type" select="@assessment_type"/>
            </xsl:call-template>
        </xsl:if>
        
    </xsl:template>

    <xsl:template name="get_file_id_base">
        <xsl:param name="orig_href"/>
        
        <xsl:variable name="file_id_base" select="replace(@orig_href,'.*/([^/]*)\.dita','$1')"/>
        <!-- May have to move this check back to supermap, because chunked topics can affect this. -->
        <!-- Check an identifer on the name, looking for similar preceding files. -->
        <!-- Had to change the compare, because the file name might be the same, but the original
             files might live in separate folders. -->
        <xsl:variable name="preceding_count" select="count(preceding::*[contains(@orig_href,concat($file_id_base,'.dita'))])"/>
        <xsl:choose>
            <xsl:when test="$preceding_count &gt; 0">
                <xsl:variable name="number">
                    <xsl:number value="$preceding_count" format="a"/>
                </xsl:variable>
                <xsl:value-of select="concat($file_id_base,'R',$number)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$file_id_base"/>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>

    <xsl:template name="new_topic">
        <xsl:param name="topic"/>
        <xsl:param name="name_base"/>
        <xsl:param name="unit"/>
        <xsl:param name="topic_number"/>
        <xsl:param name="task_category"/>
        <xsl:param name="navtitle"/>
        
        <xsl:variable name="file_id_base">
            <xsl:call-template name="get_file_id_base">
                <xsl:with-param name="orig_href" select="@orig_href"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:message>file_id_base is: <xsl:value-of select="$file_id_base"/>.</xsl:message>

        <!-- MREP: filename derived from original file. -->
        <xsl:variable name="file_name">
            <xsl:choose>
                <xsl:when test="matches($file_id_base,'^(.*)_(.*)_(.*)_(\d*)(.*)$')">
                    <xsl:value-of select="replace($file_id_base,'^(.*)_(.*)_(.*)_(\d*)(.*)$','topics/$1_topic_$3_$4$5.dita')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('topics/',$file_id_base,'.dita')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <!-- Create a topicref element for the topic. -->
        <topicref>
            <xsl:attribute name="href">
                <xsl:value-of select="$file_name"/>
            </xsl:attribute>
        </topicref>

        <xsl:variable name="out_file" select="concat('file:///',translate($OUT_DIR,'\','/'),'/',$file_name)"/>
        <xsl:message>orig_href is <xsl:value-of select="@orig_href"/></xsl:message>
        <xsl:message>(new_topic) out_file is "<xsl:value-of select="$out_file"/>".</xsl:message>
        
        <!-- Process the href file into a new file -->
        <xsl:result-document href="{$out_file}" 
            doctype-public="-//OASIS//DTD DITA Topic//EN" 
            doctype-system="http://docs.oasis-open.org/dita/v1.1/OS/dtd/topic.dtd">
            <!-- All mode="new_topic" templates are defined in new_topic_task.xsl. -->
           
            <xsl:apply-templates select="$topic" mode="new_topic">
                <xsl:with-param name="unit" select="$unit"/>
                <xsl:with-param name="task_category" select="$task_category"/>
                <xsl:with-param name="topic_id" select="$file_id_base"/>
                <xsl:with-param name="navtitle" select="$navtitle"/>
            </xsl:apply-templates>
        </xsl:result-document>
        
    </xsl:template>
    
    <xsl:template name="new_learning_overview">
        <xsl:param name="topic"/>
        <xsl:param name="task_category"/>
        <xsl:param name="navtitle"/>
        
        <xsl:variable name="file_id_base">
            <xsl:call-template name="get_file_id_base">
                <xsl:with-param name="orig_href" select="@orig_href"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:message>file_id_base is: <xsl:value-of select="$file_id_base"/>.</xsl:message>
        
        <!-- MREP: filename is original file name. -->
        <xsl:variable name="file_name" select="concat('overviews/',$file_id_base,'.dita')"/>
        
        <!-- Create a topicref element for the topic. -->
        <topicref>
            <xsl:attribute name="href">
                <xsl:value-of select="$file_name"/>
            </xsl:attribute>
        </topicref>
        
        <xsl:variable name="out_file" select="concat('file:///',translate($OUT_DIR,'\','/'),'/',$file_name)"/>
        <xsl:message>orig_href is <xsl:value-of select="@orig_href"/></xsl:message>
        <xsl:message>(new_learning_overview) out_file is "<xsl:value-of select="$out_file"/>".</xsl:message>
        
        <!-- Process the href file into a new file -->
        <xsl:result-document href="{$out_file}" 
            doctype-public="-//OASIS//DTD DITA Topic//EN" 
            doctype-system="http://docs.oasis-open.org/dita/v1.1/OS/dtd/topic.dtd">
            <!-- All mode="new_topic" templates are defined in new_topic_task.xsl. -->
            
            <!-- I may have to create a new template for new_learning_overview. -->
            <!-- Unit is now meanlingless. -->
            <xsl:apply-templates select="$topic" mode="new_los_overview">
<!--                <xsl:apply-templates select="$topic" mode="new_topic">-->
                <xsl:with-param name="task_category" select="$task_category"/>
                <xsl:with-param name="topic_id" select="$file_id_base"/>
                <xsl:with-param name="navtitle" select="$navtitle"/>
            </xsl:apply-templates>
        </xsl:result-document>
        
    </xsl:template>
    
    
    <xsl:template name="new_task">
        <xsl:param name="topic"/>
        <xsl:param name="name_base"/>
        <xsl:param name="unit"/>
        <xsl:param name="task_number"/>
        <xsl:param name="category_number"/>
        <xsl:param name="lesson_number"/>
        <xsl:param name="navtitle"/>
        
        <xsl:variable name="file_id_base">
            <xsl:call-template name="get_file_id_base">
                <xsl:with-param name="orig_href" select="@orig_href"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:message>file_id_base is: <xsl:value-of select="$file_id_base"/>.</xsl:message>
        
        <!-- MREP: filename derived from original file. -->
        <xsl:variable name="file_name">
            <xsl:choose>
                <xsl:when test="matches($file_id_base,'^(.*)_(.*)_(.*)_(\d*)(.*)$')">
                    <xsl:value-of select="replace($file_id_base,'^(.*)_(.*)_(.*)_(\d*)(.*)$','tasks/$1_task_$3_$4$5.dita')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('tasks/',$file_id_base,'.dita')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
<!--        <xsl:variable name="file_name" select="replace($file_id_base,'^(.*)_(.*)_(.*)_(\d*)(.*)$','tasks/$1_task_$3_$4$5.dita')"/>-->
        <xsl:variable name="out_file" select="concat('file:///',translate($OUT_DIR,'\','/'),'/',$file_name)"/>

        <xsl:message>orig_href is <xsl:value-of select="@orig_href"/></xsl:message>
        <xsl:message>(new_task) out_file is "<xsl:value-of select="$out_file"/>".</xsl:message>
        
        <!-- Process the href file into a new file -->
        <xsl:result-document href="{$out_file}" indent="yes" 
            doctype-public="-//OASIS//DTD DITA Topic//EN"
            doctype-system="http://docs.oasis-open.org/dita/v1.1/OS/dtd/topic.dtd" >
            <!--            doctype-system="topic.dtd">-->
            
            <!-- All mode="new_topic" templates are defined in new_topic_task.xsl. -->
            <xsl:apply-templates select="$topic" mode="new_task">
                <xsl:with-param name="unit" select="$unit"/>
                <xsl:with-param name="topic_id" select="$file_id_base"/>
                <xsl:with-param name="category_number" select="$category_number"/>
                <xsl:with-param name="lesson_number" select="$lesson_number"/>
                <xsl:with-param name="navtitle" select="$navtitle"/>
            </xsl:apply-templates>
        </xsl:result-document>
        
    </xsl:template>

    <xsl:template name="new_assessment">
        <xsl:param name="topic"/>
        <xsl:param name="name_base"/>
        <xsl:param name="unit"/>
        <xsl:param name="question_number"/>
        <xsl:param name="task_category"/>
        
        <!-- NOTE: The current LMS has implemented the assessment and question file naming backwards.
            The assessment should just have A{num} and the question should have A{num}_Q{num}. -->
        
        <!-- ASSUMES that there is only one question associated with the assessment. 
             If ever that should change, this needs to be handled differently. 
        -->
        <xsl:variable name="file_id_base">
            <xsl:call-template name="get_file_id_base">
                <xsl:with-param name="orig_href" select="@orig_href"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:message>file_id_base is: <xsl:value-of select="$file_id_base"/>.</xsl:message>
        
        <!-- MREP: filename derived from original file. -->
        <xsl:variable name="file_name" select="replace($file_id_base,'^(.*)_(.*)_(.*)_(\d*)(.*)$','questions/$1_overview_$3_$4$5.dita')"/>
        
<!--        <xsl:variable name="topic_id" select="concat($name_base,'_A',$question_number,'_Q1')"/>
        
        <xsl:variable name="file_name" select="concat('questions/',$topic_id,'.xml')"/>
-->        
        <xsl:variable name="out_file" select="concat('file:///',translate($OUT_DIR,'\','/'),'/',$file_name)"/>
        <xsl:message>(new_assessment) out_file is "<xsl:value-of select="$out_file"/>".</xsl:message>
        
        <!-- Create a topicref element for the assessment. -->
        <xsl:if test="$task_category = 'kpe-question'">
            <topicref>
                <xsl:attribute name="href">
                    <xsl:value-of select="$file_name"/>
                </xsl:attribute>
            </topicref>
        </xsl:if>
        
        
        <!-- Process the href file into a new file -->
        <xsl:result-document href="{$out_file}" method="xml" indent="yes" doctype-public="''" doctype-system="''">
            
            <!-- All mode="new_topic" templates are defined in new_topic_task.xsl. -->
            <xsl:apply-templates select="$topic" mode="new_assessment">
                <xsl:with-param name="unit" select="$unit"/>
                <xsl:with-param name="topic_id" select="$file_id_base"/>
            </xsl:apply-templates>
        </xsl:result-document>
        
    </xsl:template>
    
    <xsl:template name="new_assessment_from_q">
        <xsl:param name="topic"/>
        <xsl:param name="name_base"/>
        <xsl:param name="unit"/>
        <xsl:param name="question_number"/>
        <xsl:param name="navtitle"/>
        
        <xsl:variable name="file_id_base">
            <xsl:call-template name="get_file_id_base">
                <xsl:with-param name="orig_href" select="@orig_href"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:message>file_id_base is: <xsl:value-of select="$file_id_base"/>.</xsl:message>
        
        
<!--        <xsl:variable name="topic_id" select="concat($name_base,'_Q',$question_number)"/>
        
        <xsl:variable name="file_name" select="concat('questions/',$topic_id,'.xml')"/>
-->        
        <xsl:variable name="file_name" select="concat('questions/',$file_id_base,'.xml')"/>
        <xsl:variable name="out_file" select="concat('file:///',translate($OUT_DIR,'\','/'),'/',$file_name)"/>
        
        <xsl:message>(new_assessment_from_q) out_file is "<xsl:value-of select="$out_file"/>".</xsl:message>
        
        <!-- Create a topicref element for the assessment. -->

        <topicref>
            <xsl:attribute name="href">
                <xsl:value-of select="$file_name"/>
            </xsl:attribute>
        </topicref>
        
        <!-- Process the href file into a new file -->
        <xsl:result-document href="{$out_file}" method="xml" indent="yes" doctype-public="''" doctype-system="''">
            
            <!-- All mode="new_topic" templates are defined in new_topic_task.xsl. -->
            <xsl:apply-templates select="$topic" mode="new_assessment_from_q">
                <xsl:with-param name="unit" select="$unit"/>
                <xsl:with-param name="topic_id" select="$file_id_base"/>
                <xsl:with-param name="question_number" select="$question_number"/>
            </xsl:apply-templates>
        </xsl:result-document>
        
    </xsl:template>

    <!-- Create a QTI Question. -->
    <xsl:template name="new_question">
        <xsl:param name="topic"/>
        <xsl:param name="name_base"/>
        <xsl:param name="question_number"/>
        <xsl:param name="unit"/>
        <xsl:param name="navtitle"/>
        
        <xsl:variable name="file_id_base">
            <xsl:call-template name="get_file_id_base">
                <xsl:with-param name="orig_href" select="@orig_href"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:message>file_id_base is: <xsl:value-of select="$file_id_base"/>.</xsl:message>
        
        <!-- MREP: filename derived from original file. -->
        <xsl:variable name="file_name" select="replace($file_id_base,'^(.*)_(.*)_(.*)_(\d*)(.*)$','questions/$1_ques_$3_$4$5.dita')"/>

        <!-- Create a topicref element for the assessment. -->
        <topicref>
            <xsl:attribute name="href">
                <xsl:value-of select="$file_name"/>
            </xsl:attribute>
        </topicref>
        
        <xsl:variable name="out_file" select="concat('file:///',translate($OUT_DIR,'\','/'),'/',$file_name)"/>
        <xsl:message>(new_question) out_file is "<xsl:value-of select="$out_file"/>".</xsl:message>
        
        <!-- Because we're going to be changing context (to $topic), we need the current element. -->
        <xsl:variable name="topicref" select="." as="element()*"/>
        
        <!-- Process the href file into a new file -->
        <xsl:result-document href="{$out_file}" method="xml" doctype-public="''" doctype-system="''">
            
            <!-- All mode="new_topic" templates are defined in new_topic_task.xsl. -->
            <xsl:apply-templates select="$topic" mode="new_question">
                <xsl:with-param name="unit" select="$unit"/>
<!--                <xsl:with-param name="unit" select="substring-after($unit,'.')"/>-->
                <xsl:with-param name="assessment" select="$question_number"/>
                <xsl:with-param name="question_item" select="concat($name_base,'_A',$question_number,'_Q1.xml')"/>
                <xsl:with-param name="topicref" select="$topicref"/>
                <xsl:with-param name="topic_id" select="$file_id_base"/>
                <xsl:with-param name="navtitle" select="$navtitle"/>
            </xsl:apply-templates>
        </xsl:result-document>
        
    </xsl:template>
    
    <xsl:template name="new_exam_task">
        <xsl:param name="topic"/>
        <xsl:param name="name_base"/>
        <xsl:param name="task_number"/>
        <xsl:param name="unit"/>
        <xsl:param name="exam_number"/>
        <xsl:param name="navtitle"/>
        
        
        <xsl:variable name="file_id_base">
            <xsl:call-template name="get_file_id_base">
                <xsl:with-param name="orig_href" select="@orig_href"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:message>file_id_base is: <xsl:value-of select="$file_id_base"/>.</xsl:message>
        
        <!-- MREP: filename derived from original file. -->
        <xsl:variable name="file_name" select="replace($file_id_base,'^(.*)_(.*)_(.*)_(\d*)(.*)$','tasks/$1_task_$3_$4$5.dita')"/>
        
        <!-- Create a topicref element for the task. -->
        <topicref>
            <xsl:attribute name="href">
                <xsl:value-of select="$file_name"/>
            </xsl:attribute>
        </topicref>
        
        <xsl:variable name="out_file" select="concat('file:///',translate($OUT_DIR,'\','/'),'/',$file_name)"/>        
        <xsl:message>(new_exam_task) out_file is "<xsl:value-of select="$out_file"/>".</xsl:message>
        
        <!-- Because we're going to be changing context (to $topic), we need the current element. -->
        <xsl:variable name="topicref" select="." as="element()*"/>
        
        <!-- Process the href file into a new file -->
        <xsl:result-document href="{$out_file}" method="xml" doctype-public="-//OASIS//DTD DITA Topic//EN" 
            doctype-system="http://docs.oasis-open.org/dita/v1.1/OS/dtd/topic.dtd" indent="yes">
                        
            <!-- All mode="new_topic" templates are defined in new_topic_task.xsl. -->
            <xsl:apply-templates select="$topic" mode="new_exam_task">
                <xsl:with-param name="unit" select="$unit"/>
                <xsl:with-param name="task_number" select="$task_number"/>
                <xsl:with-param name="exam_number" select="$exam_number"/>
                <xsl:with-param name="topic_id" select="$file_id_base"/>
                <xsl:with-param name="navtitle" select="$navtitle"/>
            </xsl:apply-templates>
        </xsl:result-document>
        
    </xsl:template>
    
    <xsl:template name="new_exam_map">
        <xsl:param name="topic"/>
        <xsl:param name="name_base"/>
        <xsl:param name="exam_number"/>
        <xsl:param name="unit"/>
        <xsl:param name="assessment_type"/>
        <xsl:param name="navtitle"/>
        
        <xsl:variable name="file_id_base">
            <xsl:call-template name="get_file_id_base">
                <xsl:with-param name="orig_href" select="@orig_href"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:message>file_id_base is: <xsl:value-of select="$file_id_base"/>.</xsl:message>
        
<!--        <!-\- MREP: filename derived from original file. -\->
        <xsl:variable name="file_name" select="replace(@orig_href,'.*/([^/]*\.[^/]*)$','questions/$1')"/>
-->
        <xsl:variable name="file_name" select="concat('questions/',$file_id_base,'.dita')"/>
        
<!--        <xsl:variable name="file_name" select="replace($file_id_base,'^(.*)_(.*)_(.*)_(\d*)(.*)$','questions/$1_overview_$3_$4$5.dita')"/>-->
        <xsl:variable name="out_file" select="concat('file:///',translate($OUT_DIR,'\','/'),'/',$file_name)"/>
        
        <!-- Must first determine if this is a unit exam or a final exam. -->
        <xsl:variable name="exam_map_href" select="@orig_href"/>
        <xsl:variable name="assessment_type" select="@assessment_type"/>
        
        <xsl:variable name="exam_type">
            <xsl:choose>
                <xsl:when test="$assessment_type = 'test-exam-primary'">
                    <xsl:text>FE</xsl:text>
                </xsl:when>
                <xsl:otherwise>E</xsl:otherwise>
            </xsl:choose>
            
        </xsl:variable>
        
        <xsl:variable name="topic_id" select="concat($name_base,'_',$exam_type,$exam_number)"/>
<!--        <xsl:variable name="file_name" select="concat('questions/',$topic_id,'.dita')"/>-->
        
        <!-- Create a topicref element for the assessment. -->
        <topicref>
            <xsl:attribute name="href">
                <xsl:value-of select="$file_name"/>
            </xsl:attribute>
        </topicref>
        
        <xsl:message>(new_exam_map) out_file is "<xsl:value-of select="$out_file"/>".</xsl:message>
        
        <!-- Because we're going to be changing context (to $topic), we need the current element. -->
        
        <!-- (Actually, I don't think we need this.  What we do need is the metadata from the assessment overview. -->
        <xsl:variable name="topicref" select="." as="element()*"/>
        
        <!-- Process the href file into a new file -->
        <xsl:result-document href="{$out_file}" method="xml" doctype-public="''" doctype-system="''">
<!--            doctype-public="-//OASIS//DTD DITA Topic//EN" 
            doctype-system="http://docs.oasis-open.org/dita/v1.1/OS/dtd/topic.dtd">-->
            
            <!-- All mode="new_topic" templates are defined in new_topic_task.xsl. -->
            <!-- We can't use select="$topic", because we still have to build out the 
                 map of questions from the supermap.  -->
            <xsl:apply-templates select="." mode="new_exam_map">
                <xsl:with-param name="unit" select="substring-after($unit,'.')"/>
                <xsl:with-param name="name_base" select="$name_base"/>
                <xsl:with-param name="exam_number" select="$exam_number"/>
                <xsl:with-param name="topic_id" select="$file_id_base"/>
                <!-- new_exam_map is the only one that doesn't process a topic file directly. -->
                <xsl:with-param name="source_file" select="$topic/@xtrf"/>
                <xsl:with-param name="assessment_type" select="$assessment_type"/>
            </xsl:apply-templates>
        </xsl:result-document>
<!--        <xsl:apply-templates select="topicref" mode="exam_topics"/>
-->            
<!--        <xsl:apply-templates/>-->
        
        
    </xsl:template>
    
    <xsl:template name="new_concept">
        <xsl:param name="topic"/>
        <xsl:param name="name_base"/>
        <xsl:param name="unit"/>
        <xsl:param name="topic_number"/>
        <xsl:param name="task_category"/>
        <xsl:param name="navtitle"/>
        
        <xsl:variable name="file_id_base">
            <xsl:call-template name="get_file_id_base">
                <xsl:with-param name="orig_href" select="@orig_href"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:message>file_id_base is: <xsl:value-of select="$file_id_base"/>.</xsl:message>
        
        <!-- TODO: I believe topic_id can be eliminated throughout the PACE transform, it's been supplanted 
            by file_id_base. -->
<!--        <xsl:variable name="topic_id" select="concat($name_base,'_TOPIC',$topic_number)"/>-->
        
        <!-- [SP] 2014-06-16: In MREP-19, the file name for a concept is the same as its source. -->
<!--        <xsl:variable name="file_name" select="concat('topics/',$topic_id,'.dita')"/>-->
        
        <xsl:variable name="file_name" select="concat('topics/',$file_id_base,'.dita')"/>
        
        <!-- Create a topicref element for the topic. -->
        <topicref>
            <xsl:attribute name="href">
                <xsl:value-of select="$file_name"/>
            </xsl:attribute>
            
            <!-- [SP] 2020-11-18 sfb: Add code to handle child topicrefs. -->
    
            <xsl:apply-templates select="topicref"/>
            
        </topicref>
        
        <xsl:variable name="out_file" select="concat('file:///',translate($OUT_DIR,'\','/'),'/',$file_name)"/>
        <xsl:message>(new_concept) out_file is "<xsl:value-of select="$out_file"/>".</xsl:message>
        
        <!-- Process the href file into a new file -->
        <xsl:result-document href="{$out_file}" 
            doctype-public="-//OASIS//DTD DITA Topic//EN" 
            doctype-system="http://docs.oasis-open.org/dita/v1.1/OS/dtd/topic.dtd">
            <!-- All mode="new_topic" templates are defined in new_topic_task.xsl. -->
            <xsl:comment>Chunking is <xsl:value-of select="@chunking"/>.</xsl:comment>
            <xsl:apply-templates select="$topic" mode="new_concept">
                <xsl:with-param name="unit" select="$unit"/>
<!--                <xsl:with-param name="topic_id" select="$topic_id"/>-->
                <xsl:with-param name="topic_id" select="$file_id_base"/>
                <xsl:with-param name="task_category" select="$task_category"/>
                <xsl:with-param name="navtitle" select="$navtitle"/>
                <xsl:with-param name="chunking">
                    <xsl:choose>
                        <xsl:when test="@chunking and @chunking='false'">
                            <xsl:value-of select="false()"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="true()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:with-param>
            </xsl:apply-templates>
        </xsl:result-document>
        
    </xsl:template>
    
    <xsl:template name="new_los_overview">
        <xsl:param name="topic"/>
        <xsl:param name="name_base"/>
        <xsl:param name="unit"/>
        <xsl:param name="topic_number"/>
        <xsl:param name="navtitle"/>
        <!-- TODO: Check the folder location. -->
        
        <xsl:variable name="file_name" select="concat('overview/',$name_base,'_TOPIC',$topic_number,'.dita')"/>
        
        <!-- Create a topicref element for the topic. -->
        <topicref>
            <xsl:attribute name="href">
                <xsl:value-of select="$file_name"/>
            </xsl:attribute>
        </topicref>
        
        <xsl:variable name="out_file" select="concat('file:///',translate($OUT_DIR,'\','/'),'/',$file_name)"/>
        <xsl:message>(new_los_overview) out_file is "<xsl:value-of select="$out_file"/>".</xsl:message>
        
        <!-- Process the href file into a new file -->
        <xsl:result-document href="{$out_file}" 
            doctype-public="-//OASIS//DTD DITA Topic//EN" 
            doctype-system="http://docs.oasis-open.org/dita/v1.1/OS/dtd/topic.dtd">
            <!-- All mode="new_topic" templates are defined in new_topic_task.xsl. -->
            
            <xsl:apply-templates select="$topic" mode="new_los_overview">
                <xsl:with-param name="unit" select="$unit"/>
                <xsl:with-param name="navtitle" select="$navtitle"/>
            </xsl:apply-templates>
        </xsl:result-document>
        
    </xsl:template>
    
    <xsl:template name="new_summary">
        <xsl:param name="topic"/>
        <xsl:param name="name_base"/>
        <xsl:param name="unit"/>
        <xsl:param name="topic_number"/>
        <xsl:param name="navtitle"/>
        
        <!-- TODO: Check the folder location. -->
<!--        <xsl:variable name="file_name" select="concat('overview/',$name_base,'_TOPIC',$topic_number,'.dita')"/>-->
        <xsl:variable name="file_name" select="replace(@orig_href,'.*/([^/]*\.[^/]*)$','summaries/$1')"/>
        
        <!-- Create a topicref element for the topic. -->
        <topicref>
            <xsl:attribute name="href">
                <xsl:value-of select="$file_name"/>
            </xsl:attribute>
        </topicref>
        
        <xsl:variable name="out_file" select="concat('file:///',translate($OUT_DIR,'\','/'),'/',$file_name)"/>
        <xsl:message>(new_summary) out_file is "<xsl:value-of select="$out_file"/>".</xsl:message>
        
        <!-- Process the href file into a new file -->
        <xsl:result-document href="{$out_file}" 
            doctype-public="-//OASIS//DTD DITA Topic//EN" 
            doctype-system="http://docs.oasis-open.org/dita/v1.1/OS/dtd/topic.dtd">
            <!-- All mode="new_topic" templates are defined in new_topic_task.xsl. -->
            
            <xsl:apply-templates select="$topic" mode="new_summary">
                <xsl:with-param name="unit" select="$unit"/>
                <xsl:with-param name="navtitle" select="$navtitle"/>
            </xsl:apply-templates>
        </xsl:result-document>
    </xsl:template>
    

    <!-- RELTABLES ###################################################### -->
    
    <xsl:template match="topichead" mode="reltable">
        <xsl:apply-templates select="topicref" mode="reltable"/>
    </xsl:template>
    
    <!-- Default case. -->
    
    <xsl:template match="topicref[@task_category != 'assignment' 
                              and @task_category != 'exam' 
                              and @task_category != 'kpe-question']" mode="reltable">
        <xsl:variable name="topic_number"
            select="count(preceding-sibling::topicref[@task_category != 'assignment' and @task_category != 'exam']) + 1"/>
        <xsl:variable name="page_turner_offset" as="xs:integer">
            <xsl:choose>
                <xsl:when test="@task_category = 'page_turner'">0</xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
                </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="task_number"
            select="count(preceding-sibling::topicref[@task_category != 'page_turner']) + $page_turner_offset"/>
    <xsl:apply-templates select="topicsubject" mode="reltable">
            <xsl:with-param name="topic_number" select="$topic_number"/>
            <xsl:with-param name="task_number" select="$task_number"/>
            <xsl:with-param name="type" select="'topic'"/>
        </xsl:apply-templates>

    </xsl:template>



<xsl:template match="topicref[@task_category = 'assignment']" mode="reltable">
        
        <xsl:variable name="assignment_number"
            select="count(preceding-sibling::topicref[@task_category = 'assignment']) + 1"/>
        <xsl:variable name="page_turner_offset" as="xs:integer">
            <xsl:choose>
                <xsl:when test="@task_category = 'page_turner'">0</xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="task_number"
            select="count(preceding-sibling::topicref[@task_category != 'page_turner']) + $page_turner_offset"/>
<!--        <xsl:variable name="task_number"
            select="count(preceding-sibling::topicref[@task_category != 'page_turner']) + 1"/>-->
        
        <xsl:apply-templates select="topicsubject" mode="reltable">
            <xsl:with-param name="topic_number" select="$assignment_number"/>
            <xsl:with-param name="task_number" select="$task_number"/>
            <xsl:with-param name="type" select="'assignment'"/>
        </xsl:apply-templates>
        
    </xsl:template>
    
    <xsl:template match="topicref[@task_category = 'exam']" mode="reltable">
        
        <xsl:variable name="exam_number"
            select="count(preceding-sibling::topicref[@task_category = 'exam']) + 1"/>
        <xsl:variable name="page_turner_offset" as="xs:integer">
            <xsl:choose>
                <xsl:when test="@task_category = 'page_turner'">0</xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="task_number"
            select="count(preceding-sibling::topicref[@task_category != 'page_turner']) + $page_turner_offset"/>
        <!--
        <xsl:variable name="task_number"
            select="count(preceding-sibling::topicref[@task_category != 'page_turner']) + 1"/>
        -->
        <xsl:apply-templates select="topicsubject" mode="reltable">
            <xsl:with-param name="topic_number" select="$exam_number"/>
            <xsl:with-param name="task_number" select="$task_number"/>
            <xsl:with-param name="type" select="'exam'"/>
        </xsl:apply-templates>
        
    </xsl:template>

    <!-- Seems only to be for QBank, so the exam stuff isn't necessary. -->
    <xsl:template match="topicref[@task_category = 'kpe-question']" mode="reltable">
        
<!--        <xsl:variable name="exam_number"
            select="count(preceding-sibling::topicref[@task_category = 'exam']) + 1"/>
        <xsl:variable name="page_turner_offset" as="xs:integer">
            <xsl:choose>
                <xsl:when test="@task_category = 'page_turner'">0</xsl:when>
                <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
-->  
        <xsl:variable name="topic_number" 
            select="count(preceding-sibling::topicref[@task_category = 'kpe-question']) + 1"/>
        
        
<!--         
        <xsl:variable name="task_number"
            select="count(preceding-sibling::topicref[@task_category != 'page_turner']) + $page_turner_offset"/>
        <!-\-
        <xsl:variable name="task_number"
            select="count(preceding-sibling::topicref[@task_category != 'page_turner']) + 1"/>
        -\->
-->
        <xsl:apply-templates select="topicsubject" mode="reltable">
            <xsl:with-param name="topic_number" select="$topic_number"/>
                <!--
            <xsl:with-param name="task_number" select="$task_number"/>-->
            <xsl:with-param name="type" select="'kpe-question'"/>
        </xsl:apply-templates>
        
    </xsl:template>
    
    <xsl:template match="topicsubject" mode="reltable" priority="50">
        <xsl:param name="topic_number"/>
        <xsl:param name="task_number"/>
        <xsl:param name="type" select="'topic'"/>

        <!-- Use the los_summary element in the supermap to handle the numbering. -->
        <!--        <xsl:comment>count of all los is: <xsl:value-of select="count($all_los)"/>. </xsl:comment>-->
        <!-- get the keyref. -->
        <xsl:variable name="keyref" select="@keyref"/>
        
        <xsl:variable name="los_number" select="count(/supermap/los_summary/los[@keys = $keyref]/preceding-sibling::los) + 1"/>
        <xsl:variable name="root_name_base" select="/supermap/@name_base"/>
        <xsl:variable name="name_base" select="ancestor::topichead/@name_base"/>
        <relrow>
           <relcell>
               <topicref>
                   <xsl:attribute name="href">
                       <xsl:choose>
                           <xsl:when test="$type='topic'">
                               <xsl:value-of
                                   select="concat('topics/',$name_base,'_TOPIC',$topic_number,'.dita')"/>                               
                           </xsl:when>
                           <xsl:when test="$type='assignment'">
                               <xsl:value-of
                                   select="concat('questions/',$name_base,'_A',$topic_number,'.dita')"/>                               
                           </xsl:when>
                           <xsl:when test="$type='kpe-question'">
                               <xsl:value-of
                                   select="concat('questions/',$name_base,'_Q',$topic_number,'.xml')"/>                               
                           </xsl:when>
                           <xsl:when test="$type='exam' and following-sibling::examMap/@assessment_type = 'test-exam-primary'">
                               <xsl:value-of
                                   select="concat('questions/',$name_base,'_FE',$topic_number,'.dita')"/>                               
                           </xsl:when>
                           <xsl:when test="$type='exam'">
                               <xsl:value-of
                                   select="concat('questions/',$name_base,'_E',$topic_number,'.dita')"/>                               
                           </xsl:when>
                       </xsl:choose>
                   </xsl:attribute>
               </topicref>
           </relcell>
           <relcell>
               <topicref>
                   <xsl:if test="$type != 'kpe-question'">
                       <xsl:attribute name="href">
                           <xsl:value-of select="concat('tasks/',$name_base,'_TASK',$task_number,'.dita')"/>
                       </xsl:attribute>
                   </xsl:if>
               </topicref>
           </relcell>
           <relcell>
               <topicref>
                   <xsl:attribute name="href">
                   <xsl:value-of
                       select="concat('los/',$root_name_base,'_LOG',$los_number,'_LO',$los_number,'.dita')"
                   />
               </xsl:attribute>
               </topicref>
           </relcell>
        </relrow>
    </xsl:template>
    
    <!-- ################ HANDLE LOS ##################################### -->
    
    <xsl:template match="los_summary">
        <xsl:apply-templates select="los"/>
    </xsl:template>
    
    <xsl:template match="los">
        <!-- Create the related files. -->
        <xsl:variable name="topic" select="document(@orig_href)/*" as="element()*"/>
        <xsl:variable name="los_number" select="functx:index-of-node($los_summary/*,.)"/>
        
        <!-- Get the keys attribute before finding unit. -->
        <xsl:variable name="keys" select="@keys"/>
        
        <!-- Find the first topicsubject in which the keys appears. This will give the topichead for the unit. -->
        <xsl:variable name="topicsubject" select="//topicsubject[@keyref = $keys]"/>
        <xsl:variable name="topichead" select="$topicsubject[1]/ancestor::topichead" as="element()*"/>
        <xsl:variable name="unit" select="$topichead/@unit"/>
        
        <!-- Within the topichead, gather all topicsubject elements. -->
<!--        <xsl:variable name="all_topicsubjects" select="$topichead//topicsubject" as="element()*"/>-->
        <xsl:variable name="all_topicsubjects" as="element()*">
            <topicsubjects>
                <xsl:for-each select="$topichead//topicsubject">
                    <xsl:copy>
                       <xsl:apply-templates select="@*" mode="identity"/>                    
                    </xsl:copy>
                </xsl:for-each>
            </topicsubjects>
        </xsl:variable>
        
<!--        <xsl:message>Found <xsl:value-of select="count($all_topicsubjects)"/> topicsubjects elements. **************************</xsl:message>
        <xsl:message>Found <xsl:value-of select="count($all_topicsubjects/topicsubject)"/> topicsubject elements. **************************</xsl:message>
        
        <xsl:message>Position of keyref for <xsl:value-of select="$keys"/> is <xsl:value-of select="count($all_topicsubjects/topicsubject[@keyref = $keys][1]/preceding-sibling::topicsubject)"/>. **************************</xsl:message>
-->        
<!--        <xsl:apply-templates select="$all_topicsubjects[@keyref=$keys][1]" mode="dump_topicsubjects"/>-->
        
        <!-- Find the @keys topicsubject and count preceding siblings. -->
        <xsl:variable name="unit_los_number" select="count($all_topicsubjects/topicsubject[@keyref = $keys][1]/preceding-sibling::topicsubject) + 1"/>
<!--        <xsl:variable name="unit_los_number" select="count($topicsubject[1]/preceding-sibling::topicsubject) + 1"/>-->
        
        <xsl:call-template name="new_los_master">
            <xsl:with-param name="topic" select="$topic"/>
            <xsl:with-param name="name_base" select="/supermap/@name_base"/>
            <xsl:with-param name="course_num" select="/supermap/@course_num"/>
            <xsl:with-param name="los_number" select="$los_number"/>
            <!-- Zero-filled unit number. -->
            <xsl:with-param name="unit">
                <xsl:choose>
                    <xsl:when test="$unit = 'I.1'">
                        <xsl:value-of select="'00'"/>
                    </xsl:when>
                    <!-- in QBank, unit was a zero-length string. -->
                    <xsl:when test="string-length($unit) = 0">
                        <xsl:value-of select="'00'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:number value="xs:integer(substring-after($unit,'U.'))" format="00"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:with-param>
            <xsl:with-param name="unit_los_number" select="$unit_los_number"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="topicsubject" mode="dump_topicsubjects">
        <xsl:message>
            <xsl:value-of select="name()"/> (parent: <xsl:value-of select="name(parent::*)"/>) 
            keyref: <xsl:value-of select="@keyref"/>
            preceding-siblings: <xsl:value-of select="count(preceding-sibling::*)"/>
            preceding: <xsl:value-of select="count(preceding::*)"/>
            position: <xsl:value-of select="count(preceding-sibling::*)"/>
        </xsl:message>
    </xsl:template>
    
    <xsl:template name="new_los_master">
        <xsl:param name="topic"/>
        <xsl:param name="name_base"/>
        <xsl:param name="course_num"/>
        <xsl:param name="los_number"/>
        <xsl:param name="unit"/>
        <xsl:param name="unit_los_number"/>
        
        
        <!-- MREP: filename now comes from the original filename. -->
<!--        <xsl:variable name="file_name" select="concat('los/',$name_base,'_LOG',$los_number,'_LO',$los_number,'.dita')"/>-->
        <xsl:variable name="file_name" select="replace(@orig_href,'.*/([^/]*\.[^/]*)$','los/$1')"/>
                
        <xsl:variable name="out_file" select="concat('file:///',translate($OUT_DIR,'\','/'),'/',$file_name)"/>
        <xsl:message>(new_los_master) out_file is "<xsl:value-of select="$out_file"/>".</xsl:message>
        
        <!-- Create zero-filled integer forms of the course number and LOS number. -->
        <xsl:variable name="course_num_zi">
            <xsl:number value="$course_num" format="00"/>
        </xsl:variable>
<!--        <xsl:variable name="los_number_zi">
            <xsl:number value="$los_number" format="00"/>
        </xsl:variable>-->
        <xsl:variable name="unit_los_number_zi">
            <xsl:number value="$unit_los_number" format="00"/>
        </xsl:variable>
        <!--        <xsl:variable name="title" select="concat('LOS ',$course_num_zi,'.',$unit,'.',$los_number_zi)"/>-->
        <xsl:variable name="title" select="concat('LOS ',$course_num_zi,'.',$unit,'.',$unit_los_number_zi)"/>
        
        <!-- Process the href file into a new file -->
        <xsl:result-document href="{$out_file}" 
            doctype-public="-//OASIS//DTD DITA Learning Overview//EN" 
            doctype-system="learningOverview.dtd">
            
            
            
            <!-- All mode="new_topic" templates are defined in new_topic_task.xsl. -->
            <xsl:apply-templates select="$topic" mode="new_los_master">
                <xsl:with-param name="title" select="$title"/>
            </xsl:apply-templates>
            
        </xsl:result-document>
        
    </xsl:template>
	
    
</xsl:stylesheet>
