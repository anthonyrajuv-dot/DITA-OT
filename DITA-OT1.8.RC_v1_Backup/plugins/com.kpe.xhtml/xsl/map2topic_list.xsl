<?xml version="1.0" encoding="UTF-8" ?>
<!-- [SP] Create a hierarchical list of topics, so that we can compute the bookmarks easier. -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:saxon="http://icl.com/saxon" extension-element-prefixes="saxon">
   <xsl:import href="../../../xsl/common/output-message.xsl"/>
   <xsl:import href="../../../xsl/common/dita-utilities.xsl"/>

   <xsl:output method="xml" encoding="UTF-8" doctype-public="-//OASIS//DTD DITA Map//EN"
      doctype-system="map.dtd"/>

   <xsl:param name="BASE_DIR"/>

   <!-- [SP] subdirs mods -->
   <xsl:param name="TOPICS_DIR"/>
   <xsl:param name="file.separator"/>

   <xsl:variable name="msgprefix" select="'SPS'"/>


   <xsl:template match="/">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="/*[contains(@class, ' map/map ')]">
      <map>
         <xsl:if test="@xml:lang">
            <xsl:attribute name="xml:lang">
               <xsl:value-of select="@xml:lang"/>
            </xsl:attribute>
         </xsl:if>
         <xsl:comment>XSLT engine is: <xsl:value-of select="concat(system-property('xsl:vendor'),'; implements version ',format-number(system-property('xsl:version'),'##0.0#'),'.')"/></xsl:comment>
         <xsl:apply-templates select="*[contains(@class,' topic/title ')]">
            <xsl:with-param name="name" select="name()"/>
         </xsl:apply-templates>
          
          <xsl:comment>Now process topicref elements.</xsl:comment>

         <xsl:apply-templates select="*[contains(@class,' map/topicref ') and @print != 'no' and @processing-role != 'resource-only']"/>
      </map>
   </xsl:template>


   <xsl:template match="*[contains(@class,' map/topicref ')]">

      <!-- [SP] subdirs mods -->
      <!--<xsl:variable name="topics_sub">
         <xsl:choose>
            <xsl:when test="contains($TOPICS_DIR,$file.separator)">
               <xsl:value-of select="substring-before($TOPICS_DIR,$file.separator)"/>
            </xsl:when>
            <xsl:otherwise>
               
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>-->


<!--      <xsl:variable name="home_id"
         select="generate-id(//*[contains(@class,' map/topicref ') and @href][1])"/>-->
       <xsl:variable name="home_id"
           select="generate-id(//*[contains(@class,' map/topicref ') and @outputclass='landing_page'][1])"/>
       
       
      <xsl:choose>
         <xsl:when test="*[contains(@class,' map/topicmeta ')]">
            <xsl:variable name="element_name">
               <xsl:choose>
                  <xsl:when test="contains(@class,' map/topichead ')">
                     <xsl:text>topichead</xsl:text>
                  </xsl:when>
                  <xsl:when test="contains(@class,' map/topicgroup ')">
                     <xsl:text>topicgroup</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:text>topicref</xsl:text>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:variable>

            <xsl:element name="{$element_name}">
               <!-- If this is the first topicref in the entire document, label it as "home". -->
               <xsl:if test="generate-id() = $home_id">
                  <xsl:attribute name="home">
                     <xsl:value-of select="'yes'"/>
                  </xsl:attribute>
               </xsl:if>
               <xsl:if test="@href">
                  <xsl:attribute name="href">
                     <!-- [SP] subdirs mods -->
                     <!-- ORIGINAL <xsl:value-of select="@href"/>-->
                     <!--<xsl:choose>
                        <xsl:when test="contains(@href,'\') or contains(@href,'/')">
                           <xsl:value-of select="concat($topics_sub,'/',@href)"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="@href"/>
                        </xsl:otherwise>
                     </xsl:choose>-->
                     <xsl:value-of select="@href"/>

                  </xsl:attribute>
                  <xsl:attribute name="id">
                     <!-- [SP] subdirs mods -->
                     <!-- ORIGINAL <xsl:call-template name="get_id"/>-->
                     <!--<xsl:call-template name="get_id">
                        <xsl:with-param name="topics_sub" select="$topics_sub"/>
                     </xsl:call-template>-->
                     <xsl:call-template name="get_id"/>

                  </xsl:attribute>
               </xsl:if>
               <xsl:choose>
                  <xsl:when
                     test="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' map/linktext ')]">
                     <title>
                        <xsl:apply-templates
                           select="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' map/linktext ')][1]"
                        />
                     </title>
                  </xsl:when>
                  <xsl:when
                     test="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]">
                     <title>
                        <xsl:apply-templates
                           select="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')][1]"
                        />
                     </title>
                  </xsl:when>
                  <xsl:when test="@navtitle">
                     <title>
                        <xsl:apply-templates select="@navtitle"/>
                     </title>
                  </xsl:when>
               </xsl:choose>

               <!-- now handle the remaining topicrefs. -->
                <xsl:apply-templates select="*[contains(@class,' map/topicref ') and not(@print = 'no')]"/>
            </xsl:element>
         </xsl:when>
         <xsl:otherwise>
            <!-- now handle the remaining topicrefs. -->
             <xsl:apply-templates select="*[contains(@class,' map/topicref ') and not(@print = 'no')]"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="*[contains(@class,' topic/title ')]">
      <title>
         <xsl:apply-templates/>
      </title>
   </xsl:template>

   <xsl:template name="get_id">
      <!-- [SP] subdirs mods -->
      <!-- ORIGINAL <xsl:variable name="dita_file" select="concat('file:///',$BASE_DIR,@href)"/>-->
      <!--<xsl:param name="topics_sub"/>-->
      <!--<xsl:variable name="dita_file" select="concat('file:///',$BASE_DIR,$topics_sub,'/',@href)"/>-->
      
      <!--<xsl:variable name="dita_file">
         <xsl:choose>
            <xsl:when test="contains($TOPICS_DIR,'\') or contains($TOPICS_DIR,'/')">
               <xsl:value-of select="concat('file:///',$BASE_DIR,$topics_sub,'/',@href)"/>
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="concat('file:///',$BASE_DIR,@href)"/>
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>-->
      <xsl:variable name="dita_file" select="concat('file:///',$BASE_DIR,@href)"/>
      

      <!--      <xsl:message>Opening <xsl:value-of select="$dita_file"/>.</xsl:message>-->
      <xsl:variable name="topic_id">
         <xsl:value-of select="document($dita_file)/descendant-or-self::*[@id]/@id"/>
      </xsl:variable>
      <xsl:choose>
         <xsl:when test="$topic_id = 'topic-1' or $topic_id = 'taskId'">
            <xsl:message>The ID <xsl:value-of select="$topic_id"/> is probably non-unique. Please
               modify file <xsl:value-of select="@href"/>.</xsl:message>
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="$topic_id"/>
         </xsl:otherwise>
      </xsl:choose>

   </xsl:template>

</xsl:stylesheet>
