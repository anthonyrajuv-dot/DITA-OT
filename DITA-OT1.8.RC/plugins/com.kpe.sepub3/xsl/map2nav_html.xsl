<?xml version="1.0" encoding="UTF-8" ?>
<!-- [SP] Create the nav.html file. -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:epub="http://www.idpf.org/2007/ops"
   xmlns:saxon="http://icl.com/saxon" extension-element-prefixes="saxon"
   exclude-result-prefixes="xs epub">
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
      <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
      
      <html>
         <head>
            <meta charset="utf-8" />
            <title>Table of Contents</title>
<!--            <link rel="stylesheet" type="text/css" href="../css/epub-spec.css" />-->
         </head>
         <body>

            <!-- [SP] 2015-02-26: EPUB3 change-->
            <nav epub:type="toc">
               <xsl:copy-of
                  select="document('')/xsl:stylesheet/namespace::*[not(local-name() = 'xsl' or local-name() = 'saxon')]"/>
<!--               <xsl:attribute name="version">
                  <xsl:value-of select="'2005-1'"/>
               </xsl:attribute>-->
               <xsl:attribute name="xml:lang">
                  <xsl:choose>
                     <xsl:when test="@xml:lang">
                        <xsl:value-of select="@xml:lang"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:value-of select="'en'"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>

               <h1><xsl:value-of select="./booktitle/mainbooktitle"/></h1>
               <ol>
                  <!-- [SP] add appendix to processing list SSO -->
      <!--            <xsl:apply-templates
                      select="frontmatter/*[@href]|frontmatter/booklists/*[@href]|topicref/*[@href]"/>-->
                  <!-- [SP] 14-Jan-2013: Greatly simplified apply-templates.  -->
                  <!-- [SP] 26-Apr-2013:  Added preface.-->
                  <xsl:apply-templates
                       select="*[contains(@class,' map/topicref ') and @href] 
                       | *[contains(@class, ' bookmap/frontmatter ')]/*[contains(@class,' map/topicref ') and @href]
                       | *[contains(@class, ' bookmap/frontmatter ')]/*[contains(@class, ' bookmap/preface ')]/*[contains(@class,' map/topicref ') and @href]
                       | *[contains(@class, ' bookmap/backmatter ')]/*[contains(@class, ' bookmap/booklists ')]/*[contains(@class, ' bookmap/glossarylist ')]/*[contains(@class,' map/topicref ') and @href]
                       | *[contains(@class, ' bookmap/backmatter ')]/*[contains(@class, ' map/topicref ') and @outputclass='Answer_Key' and @href]
                       "/>
               </ol>
            </nav>
         </body>
      </html>
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
   <xsl:template match="*[(contains(@class, ' map/topicref ') or contains(@class,'cover_image')) 
      and not(contains(@class,' bookmap/trademarklist ') or @type='kpe-question' or @type='kpe-glossEntry') 
        and not(@toc = 'no')]">
         <li>
            <!-- See if the content is re-used. -->
            <xsl:variable name="curr_href" select="@href"/>
            <xsl:variable name="identical_sibs" select="count(preceding::*[@href = $curr_href])"/>
            <!--                           <xsl:message>For <xsl:value-of select="@href"/> identical_sibs is <xsl:value-of select="$identical_sibs"/>.</xsl:message>-->
            
            <xsl:variable name="new_href_1" select="replace($curr_href,'\.xml','.html')"/>
            <xsl:variable name="new_href_2" select="replace($new_href_1,'\.dita','.html')"/>
            <!--                           <xsl:message>For <xsl:value-of select="$new_href_2"/> identical_sibs is <xsl:value-of select="$identical_sibs"/>.</xsl:message>-->
            
            <xsl:variable name="new_href_3" select="concat('topics/',$new_href_2)"/>
            <a>
               <xsl:attribute name="href">
                  
                  <xsl:choose>
                     <xsl:when test="$identical_sibs = 0">
                        <xsl:value-of select="$new_href_3"/>
                     </xsl:when>
                     <xsl:otherwise>
                        <xsl:variable name="replacement" select="concat('_d',$identical_sibs,'.html')"/>
                        <!--                                 <xsl:message>newstring is: <xsl:value-of select="$replacement"/>.</xsl:message>-->
                        <xsl:value-of select="replace($new_href_3,'\.html$',$replacement)"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:attribute>
               
            <!-- [SP] 2015-03-11: KPE doesn't want prefixes. -->
             <xsl:choose>
                <!-- [SP] implement prefixes for parts, chapters, and appendix SSO -->
                 <!--                       <xsl:when test="name(.) = 'part'">  -->
                <xsl:when test="contains(@class,' bookmap/part ')">
<!--                   <xsl:variable name="partnumber">
                      <xsl:text>Part </xsl:text>
                      <xsl:value-of
                         select="count(preceding::*[(name() = 'part')])+1"/>
                      <xsl:text>: </xsl:text>
                   </xsl:variable>
                   <xsl:value-of select="$partnumber"/>-->
                   <xsl:value-of select="./@navtitle"/>
                </xsl:when>
                <xsl:when test="contains(@class,' bookmap/chapter ')">
<!--                   <xsl:variable name="chapternumber">
                      <xsl:text>Chapter </xsl:text>
                      <xsl:value-of
                         select="count(preceding::*[contains(@class,' bookmap/chapter ')])+1"/>
                      <xsl:text>: </xsl:text>
                   </xsl:variable>
                   <xsl:value-of select="$chapternumber"/>
-->                   
                   <!-- [SP] test for @navtitle and then fall back on topicmeta/navtitle SSO-->
                   <xsl:choose>
                      <xsl:when test="./@navtitle">
                         <xsl:value-of select="./@navtitle"/>
                      </xsl:when>
                      <xsl:otherwise>
                         <xsl:value-of select="./topicmeta/navtitle"/>
                      </xsl:otherwise>
                   </xsl:choose>
                </xsl:when>
    <!--            <xsl:when test="name(.) = 'appendix'">-->
                <xsl:when test="contains(@class,' bookmap/appendix ')">
<!--                   <xsl:variable name="appnumber">
                      <xsl:text>Appendix </xsl:text>
                      <!-\- [SP] count number of preceding appendix elements. Don't forget to change to letters. Also, this will NOT work if the number of appendixes is more than 9! SSO-\->
                      <xsl:value-of
                         select="translate(xs:string(count(preceding::*[contains(@class,' bookmap/appendix ')])+1),'123456789','ABCDEFGHI')"/>
                      <xsl:text>: </xsl:text>
                   </xsl:variable>
                   <xsl:value-of select="$appnumber"/>-->
                   <!-- [SP] test for @navtitle and then fall back on topicmeta/navtitle SSO-->
                   <xsl:choose>
                      <xsl:when test="./@navtitle">
                         <xsl:value-of select="./@navtitle"/>
                      </xsl:when>
                      <xsl:otherwise>
                         <xsl:value-of select="./topicmeta/navtitle"/>
                      </xsl:otherwise>
                   </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                   <xsl:value-of select="./topicmeta/navtitle"/>
                </xsl:otherwise>
             </xsl:choose>
          </a>
<!--            <content>
            <xsl:choose>
               <xsl:when test="name(.) = 'image'">
                  <xsl:attribute name="src">
                     <xsl:value-of select="concat('topics/','cover.html')"/>
                  </xsl:attribute>
               </xsl:when>
<!-\-               <xsl:when test="name() = 'part'">-\->
                <xsl:when test="contains(@class,' bookmap/part ')">
                  <xsl:attribute name="src">
                     <!-\-<xsl:value-of select="descendant-or-self::image/@href"/>-\->
                     <xsl:variable name="navtitle-trans"
                        select="translate(@navtitle,$alpha_uc,$alpha_lc)"/>
                     <xsl:value-of
                        select="concat('topics/',translate($navtitle-trans,' ','_'),'.html')"/>
                  </xsl:attribute>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:attribute name="src">
                     
                     <!-\- See if the content is re-used. -\->
                     <xsl:variable name="curr_href" select="@href"/>
                     <xsl:variable name="identical_sibs" select="count(preceding::*[@href = $curr_href])"/>
                     <!-\-                           <xsl:message>For <xsl:value-of select="@href"/> identical_sibs is <xsl:value-of select="$identical_sibs"/>.</xsl:message>-\->
                     
                     <xsl:variable name="new_href_1" select="replace($curr_href,'\.xml','.html')"/>
                     <xsl:variable name="new_href_2" select="replace($new_href_1,'\.dita','.html')"/>
                     <!-\-                           <xsl:message>For <xsl:value-of select="$new_href_2"/> identical_sibs is <xsl:value-of select="$identical_sibs"/>.</xsl:message>-\->
                     
                     <xsl:variable name="new_href_3" select="concat('topics/',$new_href_2)"/>
                     <xsl:choose>
                        <xsl:when test="$identical_sibs = 0">
                           <xsl:value-of select="$new_href_3"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:variable name="replacement" select="concat('_d',$identical_sibs,'.html')"/>
                           <!-\-                                 <xsl:message>newstring is: <xsl:value-of select="$replacement"/>.</xsl:message>-\->
                           <xsl:value-of select="replace($new_href_3,'\.html$',$replacement)"/>
                        </xsl:otherwise>
                     </xsl:choose>
                     
<!-\-                      <xsl:choose>
                          <xsl:when test="contains(./@href,'.xml')">
                              <xsl:value-of
                                  select="concat('topics/',substring-before(./@href,'.xml'),'.html')"/>
                          </xsl:when>
                          <xsl:when test="contains(./@href,'.dita')">
                              <xsl:value-of
                                  select="concat('topics/',substring-before(./@href,'.dita'),'.html')"/>
                          </xsl:when>
                      </xsl:choose>-\->
                  </xsl:attribute>
               </xsl:otherwise>
            </xsl:choose>
         </content>-->
            <xsl:if test="*[contains(@class, 'map/topicref') and not(@type='kpe-glossEntry')]|booklists/*[contains(@class, 'map/topicref')]">
               <ol>
                  <xsl:apply-templates
                     select="*[contains(@class, 'map/topicref') and not(@type='kpe-glossEntry')]|booklists/*[contains(@class, 'map/topicref')]"
                  />
               </ol>
            </xsl:if>   
         </li>
   </xsl:template>

</xsl:stylesheet>
