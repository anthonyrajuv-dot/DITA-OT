<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:opentopic-i18n="http://www.idiominc.com/opentopic/i18n"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    exclude-result-prefixes="opentopic-index opentopic opentopic-i18n opentopic-func dita-ot xs"
    version="2.0">

    <xsl:key name="id" match="*[@id]" use="@id"/>
    <xsl:key name="map-id" match="opentopic:map//*[@id]" use="@id"/>
    
    <xsl:variable name="amp" select="'&#x026;'"/>
    
    <xsl:output encoding="UTF-8" method="html"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="bookmap"/>
    </xsl:template>

    <xsl:template match="bookmap">
        <xsl:apply-templates select="opentopic:map"/>
    </xsl:template>
    
    <xsl:template match="opentopic:map">
        <xsl:text>&#10;</xsl:text>
        <html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en-us" lang="en-us">
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
            <meta name="copyright" content="(C) Copyright 2016"/>
            <meta name="DC.rights.owner" content="(C) Copyright 2016"/>
            <meta name="DC.Type" content="contents"/>
            <meta name="DC.Title" content="Table of Contents"/>
            <meta name="DC.Format" content="XHTML"/>
            <meta name="DC.Identifier" content="toc"/>
            
            <title>Table of Contents</title>
            
            <!-- saved from url=(0014)about:internet -->
            
            
            
<!--            <script src="../../js/scriptorium_page.js" type="text/javascript">  </script>
            <link rel="stylesheet" type="text/css" href="../../css/scriptorium_print.css" media="print"/>
            <link rel="stylesheet" type="text/css" href="../../css/scriptorium_style.css"/>
            <link rel="stylesheet" type="text/css" href="../../css/scriptorium_print.css" media="print"/>
-->
            <link rel="stylesheet" type="text/css" href="style.css"/>
        </head>
        <body id="toc">
            <div class="section_cont" id="main_body">
                <ul class="toc">
                    <xsl:apply-templates select="*[contains(@class,' map/topicref ') and not(@toc='no') and not(@processing-role='resource-only')]"/>
                </ul>
                
                                
            </div>
        </body>
        </html>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' mapgroup-d/topicgroup ')]" priority="10">
<!--        <xsl:comment>topicgroup</xsl:comment>-->
        <xsl:apply-templates select="*[contains(@class,' map/topicref ') and not(@toc='no') and not(@processing-role='resource-only')]"/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' mapgroup-d/topichead ')]"  priority="10">
<!--        <xsl:comment>topichead</xsl:comment>-->
        <xsl:apply-templates select="*[contains(@class,' map/topicref ') and not(@toc='no') and not(@processing-role='resource-only')]"/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' map/topicref ') and @type='kpe-concept' or @type='kpe-task']">
<!--        <xsl:comment>topicref</xsl:comment>-->
        <xsl:variable name="index_loc">
            <xsl:call-template name="get_index_loc"/>
        </xsl:variable>
        
        <li class="toc">
            <xsl:attribute name="id">
                <xsl:value-of select="concat('page_',$index_loc)"/>
            </xsl:attribute>
            <a class="toc" href="#" onclick="parent.newPage({$index_loc}); return false; ">
<!--                <xsl:attribute name="href">
                    <xsl:value-of select="concat('../',replace(@ohref,'\.(dita|xml)$','.html'))"/>
                </xsl:attribute>-->
                <xsl:apply-templates select="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]"/>
            </a>
            <xsl:choose>
                <xsl:when test="*[contains(@class,' map/topicref ') and not(@toc='no') and not(@processing-role='resource-only')]">
                    <ul class="toc">
                        <xsl:apply-templates select="*[contains(@class,' map/topicref ') and not(@toc='no') and not(@processing-role='resource-only')]"/>
                    </ul>
                </xsl:when>
            </xsl:choose>
        </li>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' map/topicref ') and contains(@class,' bookmap/chapter ')]" priority="10">
        <!--        <xsl:comment>topicref</xsl:comment>-->
        <xsl:variable name="index_loc">
            <xsl:call-template name="get_index_loc"/>
        </xsl:variable>
        
        <li class="toc">
            <xsl:attribute name="id">
                <xsl:value-of select="concat('chap_',$index_loc)"/>
            </xsl:attribute>
            <!-- [SP] 2016-05-13 sfb: Don't make chapter heads a link (for now).  -->
            <xsl:apply-templates select="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]"/>
            
            <xsl:choose>
                <xsl:when test="*[contains(@class,' map/topicref ') and not(@toc='no') and not(@processing-role='resource-only')]">
                    <ul class="toc">
                        <xsl:apply-templates select="*[contains(@class,' map/topicref ') and not(@toc='no') and not(@processing-role='resource-only')]"/>
                    </ul>
                </xsl:when>
            </xsl:choose>
        </li>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' map/topicref ') and @type='kpe-assessmentOverview']" priority="10">
        
        <xsl:variable name="index_loc">
            <xsl:call-template name="get_index_loc"/>
        </xsl:variable>
        
        <!--        <xsl:comment>assessment</xsl:comment>-->
        <xsl:variable name="assessment_count" select="count(preceding::*[contains(@type,'kpe-assessmentOverview')])+1"/>
        <xsl:variable name="assessment_loc" select="concat('questions',$assessment_count,'.js')"/>
        <xsl:variable name="assessment_id" select="@id"/>
        
        <xsl:variable name="real_assessment" select="key('id', $assessment_id)"/>
        
<!--        <xsl:variable name="real_assessment" select="//kpe-assessmentOverview[@id = $assessment_id]"/>-->
        <xsl:variable name="minimumPassScore">
            <xsl:choose>
                <xsl:when test="$real_assessment/prolog/metadata/minimumPassScore/@value != ''">
                    <xsl:value-of select="$real_assessment/prolog/metadata/minimumPassScore/@value"/>
                </xsl:when>
                <!-- Default to pass rate of 70 if no pass rate is set -->
                <xsl:otherwise>70</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="assessment_type" select="$real_assessment/prolog/metadata/lmsCategory/@value"/>
        <xsl:comment>minimumPassScore is <xsl:value-of select="$minimumPassScore"/></xsl:comment>
        <li class="toc">
            <xsl:attribute name="id">
                <xsl:value-of select="concat('page_',$index_loc)"/>
            </xsl:attribute>
            <a target="contentFrame">
                <xsl:attribute name="href">
                    <xsl:value-of select="concat('assessmenttemplate.html?questions=',$assessment_count,$amp,'passrate=',$minimumPassScore,$amp,'assessmenttype=',$assessment_type)"/>
<!--                    <xsl:value-of select="concat('../',replace(@ohref,'\.(dita|xml)$','.html'))"/>-->
                </xsl:attribute>
                <xsl:apply-templates select="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]"/>
            </a>
        </li>
    </xsl:template>
    
    <!-- Deep six anything other than concept, assessmentOverview, and task topicrefs. -->
    <xsl:template match="topicref[@type!='kpe-concept' and @type!='kpe-assessmentOverview' and @type!='kpe-task']">
        <!-- Do nothing. -->
    </xsl:template>
        
    
    <xsl:template name="get_index_loc">
        <xsl:variable name="ancestor_loc" select="count(ancestor::topicref[not(contains(@class, ' bookmap/chapter ')) and contains(@type, 'kpe-assessmentOverview') or contains(@type, 'kpe-concept') or contains(@type, 'kpe-task') and not(@toc='no') and not(@processing-role='resource-only')])"/>
        
        <xsl:variable name="preceding_loc"
            select="count(preceding::topicref[not(contains(@class, ' bookmap/chapter ')) and contains(@type, 'kpe-assessmentOverview') or contains(@type, 'kpe-concept') or contains(@type, 'kpe-task')  and not(@toc='no') and not(@processing-role='resource-only')])"/>
        
        <xsl:value-of select="$ancestor_loc + $preceding_loc"/>
        
<!--        <xsl:value-of
            select="count(preceding::topicref[(@type='kpe-concept' or @type='kpe-assessmentOverview') and not(@toc='no') and not(@processing-role='resource-only')])"/>-->
        
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' map/topicmeta ')]"/>

</xsl:stylesheet>
