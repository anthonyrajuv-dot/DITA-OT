<?xml version="1.0" encoding="UTF-8" ?>
<!-- SFB 16-Jun-10: generate indexterm list. -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:saxon="http://icl.com/saxon"
   extension-element-prefixes="saxon">
   
   <xsl:output method="xml" indent="yes"/>

   <!-- *********************************************************************************
     Setup the HTML wrapper for the table of contents
     ********************************************************************************* -->

    <xsl:template match="/">
       <sps_index>
          <xsl:apply-templates/>
       </sps_index>   
    </xsl:template>



   <!-- *********************************************************************************
    If processing only a single map, setup the HTML wrapper and output the contents.
    Otherwise, just process the contents.
    ********************************************************************************* -->
  
 
    <xsl:template match="/*[contains(@class, ' map/map ')]">
        <xsl:param name="pathFromMaplist"/>
              <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]">
                <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
            </xsl:apply-templates>
        
    </xsl:template>

    <xsl:template match="*[contains(@class, ' map/topicref ')]">
        <xsl:param name="pathFromMaplist"/>
       <xsl:choose>
          <xsl:when test="@format = 'dita'">
             <xsl:apply-templates select="document(@href)//*[contains(@class,' topic/indexterm ') 
                                           and parent::*[not(contains(@class, ' topic/indexterm '))]]">
                <xsl:with-param name="href" select="@href"/>
             </xsl:apply-templates>
          </xsl:when>
          <xsl:when test="@format = 'ditamap'">
             <xsl:apply-templates select="document(@href)"/>
          </xsl:when>
          <xsl:otherwise>
             <xsl:apply-templates select="document(@href)//*[contains(@class,' topic/indexterm ') 
                                           and parent::*[not(contains(@class, ' topic/indexterm '))]]">
                <xsl:with-param name="href" select="@href"/>
             </xsl:apply-templates>
          </xsl:otherwise>
       </xsl:choose>
       <!-- Look for topicrefs that are nested in this topicref. -->
       <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]">
          <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
       </xsl:apply-templates>
       
    </xsl:template>

   <xsl:template match="*[contains(@class,' topic/indexterm ')]">
      <xsl:param name="href"/>
<!--      <xsl:message>Got index term <xsl:value-of select="."/></xsl:message>-->
      <indexterm>
            <xsl:variable name="raw_text">
               <xsl:for-each select="text()">
                  <xsl:value-of select="."/>
               </xsl:for-each>               
            </xsl:variable>
            <xsl:variable name="sort_text">
               <xsl:choose>
                  <xsl:when test="*[contains(@class, ' indexing-d/index-sort-as ')]">
                     <xsl:apply-templates select="*[contains(@class, ' indexing-d/index-sort-as ')]"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="normalize-space($raw_text)"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>
            <!-- sfb 13-Dec-10: replace title content to eliminate spaces and newlines. -->
            <xsl:variable name="title">
               <!--<xsl:apply-templates  select="ancestor::*/*[contains(@class,' topic/title ')]"/>-->
               <xsl:apply-templates  select="ancestor::*/*[contains(@class,' topic/title ') and not(parent::*[contains(@class,' topic/section ')])]"/>
            </xsl:variable>         
            <xsl:attribute name="sortstring">
               <xsl:value-of select="normalize-space($sort_text)"/>
            </xsl:attribute>
            <xsl:attribute name="title">
               <xsl:value-of select="normalize-space(translate($title,'&#x20; ','  '))"/>
            </xsl:attribute>
         <xsl:if test="index-see">
            <xsl:attribute name="index-see">
               <xsl:value-of select="normalize-space(index-see)"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:if test="index-see-also">
            <xsl:attribute name="index-see-also">
               <xsl:value-of select="normalize-space(index-see-also)"/>
            </xsl:attribute>
         </xsl:if>
            
            <!-- If this is a leaf node, include an href -->
            <xsl:if test="not(*[contains(@class,' topic/indexterm ')])">
               <xsl:attribute name="href">
                  <xsl:value-of select="$href"/>                  
               </xsl:attribute>
            </xsl:if>
            <xsl:variable name="display_text">
               <xsl:apply-templates select="text() | 
                  *[contains(@class,' topic/keyword ')] | 
                  *[contains(@class,' topic/term ')]" mode="get-contents"/>
            </xsl:variable>         
         <text>
            <xsl:value-of select="normalize-space($display_text)"/>
         </text>
            <!-- Handle sub-index entries. -->
            <xsl:apply-templates select="*[contains(@class,' topic/indexterm ')]">
               <xsl:with-param name="href" select="$href"/>
            </xsl:apply-templates>
      </indexterm>
   </xsl:template>
   
   <xsl:template match="node()" mode="get-contents">
      <xsl:copy>
         <xsl:apply-templates/>
      </xsl:copy>
         
   </xsl:template>
   
<!--   <xsl:template match="text()">
      <xsl:value-of select="text()"/>
   </xsl:template>
-->
   <xsl:template match="*[contains(@class, ' indexing-d/index-sort-as ')]">
      <xsl:for-each select="text()">
         <xsl:value-of select="."/>
      </xsl:for-each>               
   </xsl:template>

   
</xsl:stylesheet>
