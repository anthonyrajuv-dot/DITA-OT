<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:functx="http://www.functx.com"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"    
    exclude-result-prefixes="xs functx ditaarch" version="2.0">
    
    <!-- Generate a bookmap (supermap) that directs what the eventual PACE maps will contain. -->
    

    <xsl:import href="functx-1.0.xsl"/>
    <xsl:import href="new_topic_task.xsl"/>

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

            <!-- Content of navtitle is necessary for determining if the first chapter is an introduction. -->
            <xsl:variable name="navtitle"
                select="*[contains(@class,' bookmap/chapter ')][1]/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]"
                as="element()*"/>

            <!-- Handle the contents of the map. -->
            <!-- This value is either 1 or 0. The number is used to calculate the Unit number. -->
            <xsl:variable name="has_intro" as="xs:integer">
                <xsl:choose>
                    <xsl:when test="contains(lower-case($navtitle/text()),'introduction')">
                        <xsl:value-of select="1"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="0"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:apply-templates select="*[contains(@class,' bookmap/chapter ')]">
                <xsl:with-param name="has_intro" select="$has_intro"/>
                <xsl:with-param name="name_base" select="$name_base"/>
            </xsl:apply-templates>
            
            <los_summary>
                <xsl:call-template name="find_unique_los"/>
            </los_summary>

        </supermap>
    </xsl:template>
   

    <xsl:template match="*[contains(@class, ' bookmap/chapter ')]" priority="100">
        <xsl:param name="has_intro" as="xs:integer"/>
        <xsl:param name="name_base"/>

        <xsl:variable name="navtitle"
            select="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]"
            as="element()*"/>

        <xsl:variable name="unit_number"
            select="count(preceding-sibling::*[contains(@class,' bookmap/chapter ')])  + (1 - $has_intro)"/>

        <xsl:choose>
            <xsl:when test="$has_intro = 1 and $unit_number = 0">
                <topichead navtitle="Introduction">
                    <xsl:attribute name="name_base">
                        <xsl:value-of select="concat($name_base,'_I1')"/>
                    </xsl:attribute>
                    <xsl:attribute name="unit">                        
                        <xsl:value-of select="'I.1'"/>
                    </xsl:attribute>
<!--                    <xsl:apply-templates 
                        select="*[contains(@class,' map/topicref ') and not(contains(@class,' subjectScheme/subjectdef '))]" mode="unit"/>-->
                    <xsl:apply-templates 
                        select="*[contains(@class,' map/topicref ') and not(contains(@class,' subjectScheme/subjectdef '))]"/>
                </topichead>
            </xsl:when>
            <xsl:when test="contains($navtitle,'Conclusion')">
                <topichead navtitle="Conclusion">
                    <xsl:attribute name="name_base">
                        <xsl:value-of select="concat($name_base,'_C1')"/>
                    </xsl:attribute>
                    <xsl:attribute name="unit">                        
                        <xsl:value-of select="'C.1'"/>
                    </xsl:attribute>
<!--                    <xsl:apply-templates 
                        select="*[contains(@class,' map/topicref ') and not(contains(@class,' subjectScheme/subjectdef '))]" mode="unit">
                        <xsl:with-param name="conclusion" select="true()"/>
                    </xsl:apply-templates>-->
                    <xsl:apply-templates 
                        select="*[contains(@class,' map/topicref ') and not(contains(@class,' subjectScheme/subjectdef '))]">
                        <xsl:with-param name="conclusion" select="true()"/>
                    </xsl:apply-templates>
                </topichead>
            </xsl:when>
            <xsl:otherwise>
                <topichead>
                    <xsl:attribute name="navtitle">
                        <xsl:value-of select="concat('Unit ',$unit_number)"/>                        
                    </xsl:attribute>
                    <xsl:attribute name="name_base">
                        <xsl:value-of select="concat($name_base,'_U',$unit_number)"/>                                
                    </xsl:attribute>
                    <xsl:attribute name="unit">
                        <xsl:value-of select="concat('U.',$unit_number)"/>                        
                    </xsl:attribute>
<!--                    <xsl:apply-templates 
                        select="*[contains(@class,' map/topicref ') and not(contains(@class,' subjectScheme/subjectdef '))]" mode="unit"/>  -->
                    <xsl:apply-templates 
                        select="*[contains(@class,' map/topicref ') and not(contains(@class,' subjectScheme/subjectdef '))]"/>                    
                </topichead>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    
<!--    <!-\- The unit topicref has added another layer to things. -\->
    <xsl:template match="*[contains(@class,' map/topicref ') and not(contains(@class,' subjectScheme/subjectdef '))]" mode="unit">
        <xsl:param name="conclusion" as="xs:boolean" select="false()"/>
        
        <!-\- The unit topicref may have an href to a concept topic about the unit. Create a new topicref for it. -\->
        <xsl:if test="@href and @href != ''">
            <topicref>
                <xsl:attribute name="orig_href">
                    <xsl:value-of select="@href"/>
                </xsl:attribute>
                <xsl:attribute name="type">
                    <xsl:value-of select="@type"/>
                </xsl:attribute>
                <xsl:attribute name="task_category">
                    <xsl:value-of select="@type"/>
                </xsl:attribute>
            </topicref>
        </xsl:if>
        <xsl:apply-templates select="*[contains(@class,' map/topicref ') and not(contains(@class,' subjectScheme/subjectdef '))]" >
            <xsl:with-param name="conclusion" select="$conclusion"/>
        </xsl:apply-templates>
    </xsl:template>
-->
    <xsl:template match="*[contains(@class,' map/topicref ') 
        and not(contains(@class,' classify-d/topicsubject '))
        and not(contains(@class,' subjectScheme/subjectdef '))]">
        <xsl:param name="conclusion" as="xs:boolean" select="false()"/>

        <!-- Don't need a number in the supermap. -->
<!--        <xsl:variable name="topic_number"
            select="count(preceding-sibling::*[contains(@class,' map/topicref ') and (not(@processing-role) or @processing-role != 'resource-only')]) + 1"/>
-->
        <!-- Need the content of the file...I think. -->
        <xsl:variable name="topic" select="document(@href)/*" as="element()*"/>
        
        <xsl:variable name="task_category" select="$topic//taskCategory[1]/@value"/>

        <topicref>
            <xsl:attribute name="orig_href">
                <xsl:value-of select="@href"/>
            </xsl:attribute>
            <xsl:attribute name="task_category">
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
                </xsl:choose>
            </xsl:attribute>
            <xsl:attribute name="type">
                <xsl:choose>
                    <xsl:when test="contains('activity presentation reading',$task_category)">
                        <xsl:value-of select="'topic'"/>
                    </xsl:when>
                    <xsl:when test="$task_category = 'assignment'">
                        <xsl:value-of select="'question'"/>
                    </xsl:when>
                    <xsl:when test="$task_category = 'exam'">
                        <xsl:value-of select="'exam'"/>
                    </xsl:when>
                    <xsl:when test="$task_category = '' and contains(@href,'_summary_')">
                        <xsl:value-of select="'summary'"/>
                    </xsl:when>                    
                </xsl:choose>
            </xsl:attribute>
            <!-- Handle the topicsubject elements that were keyref'ed. -->
            <xsl:apply-templates select="*[contains(@class,' classify-d/topicsubject ')]"/>            
            <!-- Handle normal nested topicrefs. -->
            <xsl:apply-templates select="*[contains(@class,' map/topicref ') 
                and not(contains(@class,' classify-d/topicsubject ')) 
                and not(contains(@class,' subjectScheme/subjectdef ')) 
                and not(@type='kpe-assessmentOverview')
                ]">
                <xsl:with-param name="conclusion" select="$conclusion"/>
            </xsl:apply-templates>            
            <!-- Handle nested topicref (was the Learning Exam map). -->
            <xsl:apply-templates select="*[contains(@class,' map/topicref ') and @type='kpe-assessmentOverview']" mode="Learning_Exam"/>            
        </topicref>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' map/topicref ') and @type='kpe-assessmentOverview']" mode="Learning_Exam">
        <examMap>
            <xsl:attribute name="orig_href">
                <xsl:value-of select="@href"/>
            </xsl:attribute>
            
            <xsl:attribute name="title">
                <xsl:apply-templates select="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]"/>
            </xsl:attribute>
            <!-- Create entries for each of the topicrefs. -->
            <xsl:apply-templates select="*[contains(@class,' map/topicref ')]" mode="exam_topicref"/>
        </examMap>
    
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' map/topicref ')]" mode="exam_topicref">
        <topicref orig_href="{@href}">
            <xsl:apply-templates select="*[contains(@class,' classify-d/topicsubject ')]"/>            
        </topicref>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' classify-d/topicsubject ')]">
        <topicsubject>
            <xsl:attribute name="orig_href">
                <xsl:value-of select="@href"/>
            </xsl:attribute>
            <xsl:attribute name="keyref">
                <xsl:value-of select="@keyref"/>
            </xsl:attribute>
        </topicsubject>
        
    </xsl:template>
    
    <xsl:template name="find_unique_los">
        <xsl:variable name="all_subject_defs" select="//*[contains(@class,' subjectScheme/subjectdef ')]"/>
        <xsl:for-each-group select="$all_subject_defs" group-by="@keys">
            <xsl:variable name="subjectdef" select="current-group()[1]"/>
            <xsl:variable name="title">
                <xsl:apply-templates 
                    select="current-group()[descendant::*[contains(@class,' topic/navtitle ')  and child::text() != '']][1]/descendant::*[contains(@class,' topic/navtitle ')]"/>
            </xsl:variable>

            <xsl:if test="$subjectdef/@href">                                
                <los>
                    <!-- Deprecating name.  Check with Sarah to see if she's using it. -->
                    <xsl:attribute name="name" select="$subjectdef/@keys"/>
                    <xsl:attribute name="keys" select="$subjectdef/@keys"/>
                    <xsl:attribute name="orig_href" select="$subjectdef/@href"/>
                    <xsl:if test="$title != ''">
                        <xsl:attribute name="title" select="$title"/>            
                    </xsl:if>
                </los>
            </xsl:if>
            
        </xsl:for-each-group>
        
    </xsl:template>

</xsl:stylesheet>
