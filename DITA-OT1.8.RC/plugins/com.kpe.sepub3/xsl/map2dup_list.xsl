<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:saxon="http://icl.com/saxon" extension-element-prefixes="saxon"
   exclude-result-prefixes="xs">
   <xsl:import href="../../../xsl/common/output-message.xsl"/>
   <xsl:import href="../../../xsl/common/dita-utilities.xsl"/>

   <xsl:output method="xml" encoding="UTF-8" indent="yes"/>

   <xsl:param name="BASE_DIR"/>

   <xsl:variable name="msgprefix" select="'SPS'"/>

   <xsl:variable name="alpha_uc" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
   <xsl:variable name="alpha_lc" select="'abcdefghijklmnopqrstuvwxyz'"/>

   <xsl:template match="/">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="/*[contains(@class, ' map/map ')]">
      <map>
         <xsl:apply-templates select="*[contains(@class,' map/topicref ')]"/>
      </map>
   </xsl:template>
   
   <!-- [SP] 2015-01-20: Override subjectdef elements. -->
   <xsl:template match="*[contains(@class, ' subjectScheme/subjectdef ')]" priority="100">
      <!-- Do nothing. -->
   </xsl:template>
   <!-- [SP] 2015-01-20: Override topicsubject elements. -->
   <xsl:template match="*[contains(@class, ' classify-d/topicsubject ')]" priority="100">
      <!-- Do nothing. -->
   </xsl:template>
   
   <!-- [SP] 2015-01-20: Override glossref elements. -->
   <xsl:template match="*[contains(@class, ' glossref-d/glossref ')]" priority="100">
      <!-- Do nothing. -->
   </xsl:template>
   
   
   <!-- [SP] 14-Jan-2013: Exclude trademarklist from the TOC. It's there for frontmatter only. -->
   <!-- [SP] 26-Apr-2013:  Don't include it if @toc = 'no'. -->
   <xsl:template match="*[contains(@class, ' map/topicref ')]">
      
      <!-- See if the content is re-used. -->
      <xsl:variable name="curr_href" select="@href"/>
      <xsl:variable name="identical_sibs" select="count(preceding::*[@href = $curr_href])"/>
      <xsl:if test="$identical_sibs &gt; 0">
         
         <xsl:variable name="new_href_1" select="replace($curr_href,'\.xml$','.html')"/>
         <xsl:variable name="new_href_2" select="replace($new_href_1,'\.dita$','.html')"/>
         
         <topicref>
            
            <xsl:attribute name="id">
               <xsl:value-of select="generate-id()"/>
            </xsl:attribute>  
            <xsl:attribute name="src_href">
               <xsl:value-of select="$new_href_2"/>
<!--               <xsl:value-of select="concat('topics/',$new_href_2)"/>-->
            </xsl:attribute>
            <xsl:attribute name="href">
               <!-- Handle either form of termination. -->
               <xsl:variable name="new_href_1" select="replace($curr_href,'\.xml$','.html')"/>
               <xsl:variable name="new_href_2" select="replace($new_href_1,'\.dita$','.html')"/>
               
<!--               <xsl:variable name="new_href_3" select="concat('topics/',$new_href_2)"/>-->
               <xsl:variable name="replacement" select="concat('_d',$identical_sibs,'.html')"/>
               
               <!-- Final href. -->
               <xsl:value-of select="replace($new_href_2,'\.html$',$replacement)"/>
            </xsl:attribute>
               
         </topicref>
      </xsl:if>
      <!-- This doesn't need to be nested, because we're not trying to produce a hierarchical list. -->
      <xsl:apply-templates select="*[contains(@class, 'map/topicref')]"/>
   </xsl:template>

</xsl:stylesheet>
