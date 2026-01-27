<?xml version="1.0" encoding="UTF-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
            xmlns:relpath="http://dita2indesign/functions/relpath"
            xmlns:oxygen="http://www.oxygenxml.com/functions"
            xmlns="http://www.oxygenxml.com/ns/webhelp/toc"
            exclude-result-prefixes="relpath oxygen"
            version="2.0">
    

  <!-- EXM-34368 Stylesheet to handle DITA elements -->
  <xsl:import href="plugin:org.dita.xhtml:xsl/dita2html-base.xsl"/>
  <xsl:import href="dita-utilities.xsl"/>
  <xsl:import href="../functions.xsl"/>
  <!-- EXM-34663 - Importing the stylesheet that contains some functions for working with relative paths. -->
  <xsl:import href="original/relpath_util.xsl"/>
  
    <xsl:output 
        method="xml" 
        encoding="UTF-8"/>  
    
  <!-- Extension of output files for example .html -->
  <xsl:param name="OUT_EXT" select="'.html'"/>
    <!-- the file name containing filter/flagging/revision information
        (file name and extension only - no path).  - testfile: revflag.dita -->
    <xsl:param name="FILTERFILE"/>
    
    <!-- The document tree of filterfile returned by document($FILTERFILE,/)-->
    <xsl:variable name="FILTERFILEURL">
        <xsl:choose>
            <xsl:when test="not($FILTERFILE)"/> <!-- If no filterfile leave empty -->
            <xsl:when test="starts-with($FILTERFILE, 'file:')">
                <xsl:value-of select="$FILTERFILE"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="starts-with($FILTERFILE, '/')">
                        <xsl:text>file://</xsl:text><xsl:value-of select="$FILTERFILE"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>file:/</xsl:text><xsl:value-of select="$FILTERFILE"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="FILTERDOC"
        select="if (string-length($FILTERFILEURL) > 0)
        then document($FILTERFILEURL, /)
        else ()"/>
    
    <xsl:variable name="passthrough-attrs" as="element()*"
        select="$FILTERDOC/val/prop[@action = 'passthrough']"/>

  <xsl:key name="kTopicHrefs" 
               match="*[contains(@class, ' map/topicref ')]
                            [@href]
                            [not(@scope) or @scope = 'local']
                            [not(@processing-role) or @processing-role = 'normal']
                            [not(@format) or @format = 'dita' or @format = 'DITA']" 
               use="@href"/>
    
    <xsl:template match="/">
        <toc>
            <title>
                <xsl:variable name="topicTitle" 
                    select="/*[contains(@class,' map/map ')]/*[contains(@class,' topic/title ')][1]"/>
                <xsl:choose>
                    <xsl:when test="exists($topicTitle)">
                        <xsl:element name="span" exclude-result-prefixes="#all">
                            <xsl:attribute name="class"
                                select="oxygen:extractLastClassValue($topicTitle/@class)"/>
                            <xsl:apply-templates select="$topicTitle/node()"/>                                                            
                        </xsl:element>
                    </xsl:when>
                   
                    <xsl:when test="/*[contains(@class,' map/map ')]/@title">
                        <xsl:value-of select="/*[contains(@class,' map/map ')]/@title"/>
                    </xsl:when>
                </xsl:choose>
            </title>
            <xsl:apply-templates mode="toc-webhelp"/>
        </toc>
  </xsl:template>
    
    
  <xsl:template match="text()" mode="toc-webhelp"/>
    
  <xsl:template match="*[contains(@class, ' map/topicref ') 
                  and not(@processing-role='resource-only')
                  and not(@toc='no')
                  and not(ancestor::*[contains(@class, ' map/reltable ')])]" 
                  mode="toc-webhelp">
      
      <xsl:variable name="title" as="node()*">
          <xsl:variable 
              name="navTitleElem" 
              select="*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/navtitle ')]"/>
          <xsl:choose>
              <xsl:when test="$navTitleElem">
                  <!-- Fix the href attribute in the navtitle -->
                  <xsl:variable name="navTitle_hrefFixed">
                      <xsl:apply-templates select="$navTitleElem" mode="fixHRef"/>
                  </xsl:variable>
                      
                  <xsl:apply-templates select="$navTitle_hrefFixed/*/node()"/>
                  <!--<xsl:apply-templates select="$navTitleElem/node()"/>-->
              </xsl:when>
              <xsl:when test="@navtitle">
                  <xsl:value-of select="@navtitle"/>
              </xsl:when>
          </xsl:choose>
      </xsl:variable>
      
        <xsl:choose>
            <xsl:when test="@href or @copy-to or not(empty($title))">
                <topic>  
                    <xsl:choose>
                        <xsl:when test="@copy-to">
                            <xsl:attribute name="href">
                                <xsl:call-template name="replace-extension">
                                    <xsl:with-param name="filename" select="@copy-to"/>
                                    <xsl:with-param name="extension" select="$OUT_EXT"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:when test="@href">
                            <xsl:attribute name="href">
                                <xsl:call-template name="replace-extension">
                                    <xsl:with-param name="filename" select="@href"/>
                                    <xsl:with-param name="extension" select="$OUT_EXT"/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="href" select="'javascript:void(0)'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="@collection-type">
                        <xsl:attribute name="collection-type" select="@collection-type"/>
                    </xsl:if>
                    <xsl:if test="@outputclass">
                        <xsl:attribute name="outputclass" select="@outputclass"/>
                    </xsl:if>
                    <xsl:if test="@scope and not(@scope='local')">
                        <xsl:attribute name="scope" select="@scope"/>
                    </xsl:if>
                    <xsl:if test="exists($passthrough-attrs)">
                        <xsl:for-each select="@*">
                            <xsl:if test="$passthrough-attrs[@att = name(current()) and (empty(@val) or (some $v in tokenize(current(), '\s+') satisfies $v = @val))]">
                                <xsl:attribute name="data-{name()}" select="."/>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="generate-id(key('kTopicHrefs', @href)[1]) = generate-id()">
                        <xsl:variable name="resourceid" select="*[contains(@class, ' map/topicmeta ')]/@resourceid"/>
                        <xsl:if test="string-length($resourceid) > 0">
                            <xsl:attribute name="data-id"><xsl:value-of select="$resourceid"/></xsl:attribute>
                        </xsl:if>
                    </xsl:if>
                    
                    <title>
                        <xsl:choose>
                            <xsl:when test="not(empty($title))">
                                <xsl:copy-of select="$title"/>
                            </xsl:when>
                            <xsl:otherwise>***</xsl:otherwise>
                        </xsl:choose>
                    </title>
                    
                    <xsl:apply-templates mode="toc-webhelp"/>
                </topic>
            </xsl:when>
            <xsl:otherwise>
                <!-- Do not contribute a level in the TOC, but recurse in the child topicrefs -->
                <xsl:apply-templates mode="toc-webhelp"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!-- 
        Templates in 'fixHRef' mode used to fix the href location when the 'xtrf' attribute is present  
    -->
    <xsl:template match="node()" mode="fixHRef">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="#current"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Copy any attribute -->
    <xsl:template match="@*" mode="fixHRef">
        <xsl:copy/>
    </xsl:template>
    
    <!-- Recompute the relative path for the @href in the context of the parent map -->
    <xsl:template match="@href" mode="fixHRef">        
        <xsl:variable name="xtrf" select="parent::node()/@xtrf"/>        
        <xsl:variable name="mapXtrf" select="ancestor::map[1]/@xtrf"/>
        <xsl:choose>
            <xsl:when test="exists($xtrf) and exists($mapXtrf)">
                <xsl:variable name="pDoc" select="relpath:getParent(relpath:toUrl($xtrf))"/>
                
                <!-- Make path absolute -->
                <xsl:variable name="aPath" select="concat($pDoc, '/', .)"/>
                
                <!-- fix ../.. in the path -->
                <xsl:variable name="aPath" select="relpath:getAbsolutePath($aPath)"/>
                
                <!-- Get the map URL -->
                <xsl:variable name="mapURL" select="relpath:toUrl($mapXtrf)"/>                
                
                <!-- Make the path relative in the context of the map -->
                <xsl:variable name="relPath" select="relpath:getRelativePath(
                    relpath:getParent($mapURL), 
                    $aPath)"/>
                <xsl:attribute name="href" select="$relPath"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy/>                
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
</xsl:stylesheet>