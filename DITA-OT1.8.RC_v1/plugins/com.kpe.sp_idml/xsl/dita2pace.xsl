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

            <xsl:apply-templates/>

            <!-- Build the reltable... -->
            <reltable title="Table Mapping">
                <relheader>
                    <relcolspec type="topic"/>
                    <relcolspec type="topic"/>
                    <relcolspec type="topic"/>
                </relheader>
               <!-- <xsl:apply-templates select="topichead"
                    mode="reltable">
                    <xsl:with-param name="has_intro" select="$has_intro"/>
                    <xsl:with-param name="name_base" select="concat($brand,'_',$series)"/>
                </xsl:apply-templates>-->
            </reltable>

        </map>
    </xsl:template>
    
    <xsl:template match="topichead">
        <xsl:copy>
            <xsl:variable name="all_topic_refs" select="topicref[@type='topic']" as="element()*"/>
            <xsl:variable name="all_question_refs" select="topicref[@type='question']" as="element()*"/>
            <xsl:apply-templates>
                <xsl:with-param name="all_topic_refs" select="$all_topic_refs"/>
                <xsl:with-param name="all_question_refs" select="$all_question_refs"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:copy/>
    </xsl:template>


    <xsl:template match="topicref">
        <xsl:param name="all_topic_refs" as="element()*"/>
        <xsl:param name="all_question_refs" as="element()*"/>
        
        <xsl:variable name="topic_number" select="functx:index-of-node($all_topic_refs,.)"/>
        <xsl:variable name="question_number" select="functx:index-of-node($all_question_refs,.)"/>
        
        <!-- Create the related files. -->
        <xsl:variable name="topic" select="document(@orig_href)/*" as="element()*"/>

        <!-- Determine the outputs needed. -->
        <xsl:choose>
            <xsl:when test="contains('activity presentation reading',@task_category)">
                <xsl:call-template name="new_topic">
                    <xsl:with-param name="topic" select="$topic"/>
                    <xsl:with-param name="name_base" select="parent::topichead/@name_base"/>
                    <xsl:with-param name="topic_number" select="$topic_number"/>
                </xsl:call-template>
                <xsl:call-template name="new_task">
                    <xsl:with-param name="topic" select="$topic"/>
                    <xsl:with-param name="name_base" select="parent::topichead/@name_base"/>
                    <xsl:with-param name="topic_number" select="$topic_number"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="@task_category = 'assignment'">
                <xsl:call-template name="new_question">
                    <xsl:with-param name="topic" select="$topic"/>
                    <xsl:with-param name="name_base" select="parent::topichead/@name_base"/>
                    <xsl:with-param name="question_number" select="$question_number"/>
                </xsl:call-template>
                <xsl:call-template name="new_task">
                    <xsl:with-param name="topic" select="$topic"/>
                    <xsl:with-param name="name_base" select="parent::topichead/@name_base"/>
                    <xsl:with-param name="topic_number" select="$question_number"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
        
    </xsl:template>

    <xsl:template name="new_topic">
        <xsl:param name="topic"/>
        <xsl:param name="name_base"/>
        <xsl:param name="topic_number"/>
        
        <xsl:variable name="file_name" select="concat('topics/',$name_base,'_TOPIC',$topic_number,'.dita')"/>
        
        <!-- Create a topicref element for the topic. -->
        <topicref>
            <xsl:attribute name="href">
                <xsl:value-of select="$file_name"/>
            </xsl:attribute>
        </topicref>

        <xsl:variable name="out_file" select="concat('file:///',translate($OUT_DIR,'\','/'),'/',$file_name)"/>
        <xsl:message>(new_topic) out_file is "<xsl:value-of select="$out_file"/>".</xsl:message>
        
        <!-- Process the href file into a new file -->
        <xsl:result-document href="{$out_file}" 
            doctype-public="-//OASIS//DTD DITA Topic//EN" 
            doctype-system="topic.dtd">
            <!-- All mode="new_topic" templates are defined in new_topic_task.xsl. -->
            <xsl:apply-templates select="$topic" mode="new_topic"/>
        </xsl:result-document>
        
    </xsl:template>

    <xsl:template name="new_task">
        <xsl:param name="topic"/>
        <xsl:param name="name_base"/>
        <xsl:param name="topic_number"/>
        
        <xsl:variable name="file_name" select="concat('tasks/',$name_base,'_TASK',$topic_number,'.dita')"/>
        
        <xsl:variable name="out_file" select="concat('file:///',translate($OUT_DIR,'\','/'),'/',$file_name)"/>
        <xsl:message>(new_task) out_file is "<xsl:value-of select="$out_file"/>".</xsl:message>
        
        <!-- Process the href file into a new file -->
        <xsl:result-document href="{$out_file}"
            doctype-public="-//KPE//DTD DITA KPE Learning Task//EN"
            doctype-system="kpe-task.dtd">
            <!-- All mode="new_topic" templates are defined in new_topic_task.xsl. -->
            <xsl:apply-templates select="$topic" mode="new_task"/>
        </xsl:result-document>
        
    </xsl:template>

    <xsl:template name="new_question">
        <xsl:param name="topic"/>
        <xsl:param name="name_base"/>
        <xsl:param name="question_number"/>
        
        <xsl:variable name="file_name" select="concat('questions/',$name_base,'_A',$question_number,'.dita')"/>
        
        <xsl:variable name="out_file" select="concat('file:///',translate($OUT_DIR,'\','/'),'/',$file_name)"/>
        <xsl:message>(new_question) out_file is "<xsl:value-of select="$out_file"/>".</xsl:message>
        
        <!-- Process the href file into a new file -->
        <xsl:result-document href="{$out_file}" method="text">
            <!-- All mode="new_topic" templates are defined in new_topic_task.xsl. -->
            <xsl:apply-templates select="$topic" mode="new_question"/>
        </xsl:result-document>
        
    </xsl:template>
    

<!--    <xsl:template match="*[contains(@class,' map/map ')]" mode="sub_map">
        <xsl:param name="name_base"/>
        <xsl:apply-templates
            select="*[contains(@class,' map/topicref ') and (not(@processing-role) or @processing-role != 'resource-only')]"
            mode="sub_map">
            <xsl:with-param name="name_base" select="$name_base"/>
        </xsl:apply-templates>

    </xsl:template>

    <xsl:template match="*[contains(@class,' map/topicref ')]" mode="sub_map">
        <xsl:param name="name_base"/>

        <xsl:variable name="topic_number"
            select="count(preceding-sibling::*[contains(@class,' map/topicref ') and (not(@processing-role) or @processing-role != 'resource-only')]) + 1"/>
        <topicref>
            <xsl:attribute name="href">
                <xsl:value-of select="concat('topics/',$name_base,'_TOPIC',$topic_number,'.dita')"/>
            </xsl:attribute>
            <xsl:attribute name="oldhref">
                <xsl:value-of select="@href"/>
            </xsl:attribute>
        </topicref>
    </xsl:template>
-->
    <!-- RELTABLES ###################################################### -->
    <xsl:template match="*[contains(@class, ' bookmap/chapter ')]" mode="reltable" priority="100">
        <xsl:param name="has_intro" as="xs:integer"/>
        <xsl:param name="name_base"/>

        <!--        <xsl:comment>Handling reltable for chapter.</xsl:comment>
        <xsl:text>&#10;</xsl:text>-->
        <xsl:variable name="unit_number"
            select="count(preceding-sibling::*[contains(@class,' bookmap/chapter ')])  + (1 - $has_intro)"/>
        <xsl:variable name="unit_id">
            <xsl:choose>
                <xsl:when test="$has_intro = 1 and $unit_number = 0">
                    <xsl:value-of select="'I1'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('U',$unit_number)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:apply-templates select="*[contains(@class,' map/topicref ')]" mode="reltable">
            <xsl:with-param name="name_base" select="concat($name_base,'_',$unit_id)"/>
        </xsl:apply-templates>

    </xsl:template>

    <xsl:template match="*[contains(@class,' map/topicref ')]" mode="reltable">
        <xsl:param name="name_base"/>

        <!--        <xsl:comment>Handling reltable for topicref.</xsl:comment>
        <xsl:text>&#10;</xsl:text>
-->
        <xsl:variable name="topic_number"
            select="count(preceding-sibling::*[contains(@class,' map/topicref ') and (not(@processing-role) or @processing-role != 'resource-only')]) + 1"/>

        <xsl:apply-templates select="*[contains(@class,' classify-d/topicsubject ')]"
            mode="reltable">
            <xsl:with-param name="name_base" select="$name_base"/>
            <xsl:with-param name="topic_number" select="$topic_number"/>
        </xsl:apply-templates>

    </xsl:template>

    <xsl:template match="*[contains(@class,' classify-d/topicsubject ')]" mode="reltable"
        priority="50">
        <xsl:param name="name_base"/>
        <xsl:param name="topic_number"/>

        <!--        <xsl:comment>    Handling reltable for topicsubject.</xsl:comment>
        <xsl:text>&#10;</xsl:text>

-->
        <xsl:variable name="all_los"
            select="ancestor::*[contains(@class,' bookmap/bookmap ')]/descendant::*[contains(@class,' classify-d/topicsubject ')]"/>

        <!--        <xsl:comment>count of all los is: <xsl:value-of select="count($all_los)"/>. </xsl:comment>-->
        <xsl:variable name="los_number" select="functx:index-of-node($all_los,.)"/>

        <relrow>
            <relcell>
                <xsl:attribute name="href">
                    <xsl:value-of
                        select="concat('topics/',$name_base,'_TOPIC',$topic_number,'.dita')"/>
                </xsl:attribute>
            </relcell>
            <relcell>
                <xsl:attribute name="href">
                    <xsl:value-of select="concat('tasks/',$name_base,'_TASK',$topic_number,'.dita')"
                    />
                </xsl:attribute>
            </relcell>
            <relcell>
                <xsl:attribute name="href">
                    <xsl:value-of
                        select="concat('los/',$name_base,'_LOG',$los_number,'_LO',$los_number,'.dita')"
                    />
                </xsl:attribute>
            </relcell>
        </relrow>

    </xsl:template>



</xsl:stylesheet>
