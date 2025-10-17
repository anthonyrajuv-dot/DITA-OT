<?xml version="1.0" encoding="UTF-8" ?>
<!-- [SP] Create the content.opf file. -->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:saxon="http://icl.com/saxon" extension-element-prefixes="saxon"
   xmlns:opf="http://www.idpf.org/2007/opf" xmlns:dc="http://purl.org/dc/elements/1.1/"
   exclude-result-prefixes="dc opf" xmlns="http://www.idpf.org/2007/opf">
   <xsl:import href="../../../xsl/common/output-message.xsl"/>
   <xsl:import href="../../../xsl/common/dita-utilities.xsl"/>

   <xsl:output method="xml" encoding="UTF-8"/>

   <xsl:param name="BASE_DIR"/>
   <xsl:param name="ancillary_list"/>
   <xsl:param name="out_dir"/>
   <xsl:param name="file.separator"/>

   <xsl:include href="xslhtml/page_builder.xsl"/>

   <xsl:variable name="msgprefix" select="'SPS'"/>

   <xsl:variable name="alpha_uc" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
   <xsl:variable name="alpha_lc" select="'abcdefghijklmnopqrstuvwxyz'"/>

   <xsl:template match="/">
      
      <xsl:call-template name="cover_builder">
         <xsl:with-param name="book_title"
            select="ancestor::bookmeta/preceding-sibling::booktitle/mainbooktitle"/>
         <xsl:with-param name="outdir" select="$out_dir"/>
      </xsl:call-template>
      
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="/*[contains(@class, ' map/map ')]">

      <package xmlns="http://www.idpf.org/2007/opf">
         <xsl:copy-of
            select="document('')/xsl:stylesheet/namespace::*[not(local-name() = 'xsl' or local-name() = 'saxon')]"/>
         <xsl:attribute name="version">
            <!-- [SP] 2015-02-27: EPUB3 -->
            <xsl:value-of select="'3.0'"/>
         </xsl:attribute>
         <xsl:attribute name="unique-identifier">
            <xsl:value-of select="'bookid'"/>
         </xsl:attribute>

<!-- Minimal set of EPUB3 metadata: 
            
            
    <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
        <dc:identifier id="pub-id">urn:uuid:A1B0D67E-2E81-4DF5-9E67-A64CBE366809</dc:identifier>
        <dc:title>Norwegian Wood</dc:title>
        <dc:language>en</dc:language>
        <meta property="dcterms:modified">2011-01-01T12:00:00Z</meta>
    </metadata>
    
    -->
         <metadata>
            <dc:identifier id="bookid">
               <xsl:choose>
                  <xsl:when test="//@isbn">
                     <xsl:value-of select="//@isbn"/>
                  </xsl:when>
                  <xsl:otherwise>id0123456789</xsl:otherwise>
               </xsl:choose>
            </dc:identifier>
            <dc:title>
               <xsl:value-of select="./booktitle/mainbooktitle"/>
            </dc:title>
            <dc:language>
               <xsl:choose>
                  <xsl:when test="@xml:lang">
                     <xsl:value-of select="@xml:lang"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="'en'"/>
                  </xsl:otherwise>
               </xsl:choose>
            </dc:language>
            
            <dc:creator>
               <!-- [SP] 2015-03-04: Commented out for now. Sam says hard code it. -->
<!--               <xsl:for-each select="./bookmeta/authorinformation/organizationinfo/namedetails/organizationnamedetails/organizationname">
                  <xsl:choose>
                     <xsl:when test="position() = last()">
                         <xsl:value-of select="normalize-space(.)"/>
                     </xsl:when>
                     <xsl:otherwise>
                         <xsl:value-of select="concat(normalize-space(.),', ')"/>
                     </xsl:otherwise>
                  </xsl:choose>
               </xsl:for-each>
               <xsl:text> </xsl:text>-->
               <xsl:text>Kaplan Professional Education</xsl:text>
            </dc:creator>
            <meta property="dcterms:modified">2011-01-01T12:00:00Z</meta>
            <meta name="cover" content="cover-image"/>
         </metadata>

         <manifest>
            <!-- [SP] 2015-02-27: EPUB3 nav. Change toc.ncx to nav.html -->
            <item id="nav" properties="nav" href="nav.html" media-type="application/xhtml+xml"/>
            <!-- Add entry for the static cover. -->
<!--            added mathml here-->
            <item href="topics/cover.html" id="cover" media-type="application/xhtml+xml" properties="mathml"/>
            
            <!-- [SP] 2015-01-20: Exclude subjectdef and glossref terms.  classify-d/topicsubject -->
            <xsl:for-each
               select="descendant-or-self::*[
                   (contains(@class, ' map/topicref ') and @href 
                   and (@chunk = 'to-content')
                   and not(contains(@class,' subjectScheme/subjectdef ') 
                              or contains(@class,' classify-d/topicsubject ')
                              )
                   ) 
                   or contains(@class, ' map/topicref bookmap/part ')  
                   or contains(@outputclass, 'cover_image')]">
<!-- Removed glossref from the not clause:
                  or contains(@class,' glossref-d/glossref ')
                  
                  -->

               <xsl:variable name="navtitle-trans" select="translate(@navtitle,$alpha_uc,$alpha_lc)"/>
               <xsl:variable name="output_filename"
                  select="concat('topics/',translate($navtitle-trans,' ','_'),'.html')"/>
               
                
               <item>
                  <xsl:attribute name="href">
                     <xsl:choose>
                        <xsl:when test="@href and not(contains(@outputclass,'cover_image'))">
                           <!-- See if the content is re-used. -->
                           <xsl:variable name="curr_href" select="@href"/>
                           <xsl:variable name="identical_sibs" select="count(preceding::*[@href = $curr_href])"/>
<!--                           <xsl:message>For <xsl:value-of select="@href"/> identical_sibs is <xsl:value-of select="$identical_sibs"/>.</xsl:message>-->

                           <xsl:variable name="new_href_1" select="replace($curr_href,'\.xml#?.*$','.html')"/>
                           <xsl:variable name="new_href_2" select="replace($new_href_1,'\.dita#?.*$','.html')"/>
<!--                           <xsl:message>For <xsl:value-of select="$new_href_2"/> identical_sibs is <xsl:value-of select="$identical_sibs"/>.</xsl:message>-->
                           <xsl:variable name="new_href_3" select="concat('topics/',$new_href_2)"/>
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
                        </xsl:when>
                        <xsl:when test="contains(@class, ' map/topicref bookmap/part ')">
                           <xsl:value-of select="$output_filename"/>
                        </xsl:when>
                        <xsl:when test="contains(@outputclass,'cover_image')">
                           <xsl:value-of select="concat('topics/','cover.html')"/>
                        </xsl:when>
                     </xsl:choose>

                  </xsl:attribute>
                  <xsl:attribute name="id">
                     <xsl:choose>
                        <xsl:when test="contains(@outputclass,'cover_image')">
                           <xsl:text>cover</xsl:text>
                        </xsl:when>
                        <xsl:when test="@id">
                           <xsl:value-of select="@id"/>
                        </xsl:when>
                        <xsl:otherwise>
                           <xsl:value-of select="generate-id()"/>
                        </xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
<!--                  added mathml here-->
                  <xsl:attribute name="properties">
                     <xsl:value-of select="'mathml'"/>
                  </xsl:attribute>
                  
                  <xsl:attribute name="media-type">
                     <xsl:value-of select="'application/xhtml+xml'"/>
                  </xsl:attribute>
               </item>

               <xsl:if test="contains(@class, ' map/topicref bookmap/part ')">
                  <xsl:call-template name="part_builder">
                     <xsl:with-param name="part_content" select="."/>
                     <xsl:with-param name="navtitle-trans" select="$navtitle-trans"/>
                     <xsl:with-param name="outdir" select="$out_dir"/>
                  </xsl:call-template>
               </xsl:if>

               <xsl:if test="contains(@outputclass, 'cover_image')">
<!-- Probably won't get called, because there is no cover_image at this time. -->
<!--                  <xsl:call-template name="cover_builder">
                     <xsl:with-param name="cover_content" select="."/>
                     <xsl:with-param name="book_title"
                        select="ancestor::bookmeta/preceding-sibling::booktitle/mainbooktitle"/>
                     <xsl:with-param name="outdir" select="$out_dir"/>
                  </xsl:call-template>-->

               </xsl:if>
            </xsl:for-each>

            <xsl:call-template name="manifest_ancillary">
               <xsl:with-param name="list_param" select="$ancillary_list"/>
            </xsl:call-template>
            <item id="index" href="topics/index.html" media-type="application/xhtml+xml" properties="mathml"/>
<!--            added properties mathml here         -->
         </manifest>
         <!-- [SP] 2015-02-27: don't need toc="ncx" in EPUB3. -->
         <spine>
               <itemref linear="no" idref="cover"/>
            <xsl:for-each
               select="descendant-or-self::*[
                  (contains(@class, ' map/topicref ') and @href 
                  and (@chunk = 'to-content')
                  
                     and not(contains(@class,' subjectScheme/subjectdef ') 
                      or contains(@class,' classify-d/topicsubject ')
                      or contains(@class,' glossref-d/glossref '))
                  ) 
                  or contains(@class, ' map/topicref bookmap/part ')]">
               <itemref>
                  <xsl:attribute name="idref">
                     <xsl:value-of select="generate-id()"/>
                  </xsl:attribute>
               </itemref>
            </xsl:for-each>
            <itemref idref="index"/>
         </spine>
      </package>
   </xsl:template>

   <xsl:template name="manifest_ancillary">
      <xsl:param name="list_param"/>
      <xsl:param name="counter" select="1"/>
      <xsl:if test="string-length($list_param) != 0">
         <xsl:variable name="list_next">
            <xsl:choose>
               <xsl:when test="contains($list_param,',')">
                  <xsl:value-of select="substring-before($list_param,',')"/>
               </xsl:when>
               <xsl:otherwise>
                  <xsl:value-of select="$list_param"/>
               </xsl:otherwise>
            </xsl:choose>
         </xsl:variable>
         <item>
            <xsl:attribute name="href">
               <xsl:value-of select="concat('topics/',translate($list_next,'\','/'))"/>
            </xsl:attribute>
            <xsl:attribute name="id">
               <xsl:value-of select="concat('added',generate-id(),$counter)"/>
            </xsl:attribute>
            <xsl:attribute name="media-type">
               <xsl:choose>
                  <xsl:when
                     test="contains(upper-case(substring-after($list_next,'.')),'JPG')">
                     <xsl:value-of select="'image/jpeg'"/>
                  </xsl:when>
                  <xsl:when
                     test="contains(upper-case(substring-after($list_next,'.')),'JPEG')">
                     <xsl:value-of select="'image/jpeg'"/>
                  </xsl:when>
                  <xsl:when
                     test="contains(upper-case(substring-after($list_next,'.')),'SVG')">
                     <xsl:value-of select="concat('application/',substring-after($list_next,'.'))"/>
                  </xsl:when>
                  <xsl:when
                     test="contains(upper-case(substring-after($list_next,'.')),'TTF')">
                     <xsl:value-of select="'application/octet-stream'"/>
                  </xsl:when>
                  <xsl:when
                     test="contains(upper-case(substring-after($list_next,'.')),'CSS')">
                     <xsl:value-of select="'text/css'"/>
                  </xsl:when>
                  <xsl:otherwise>
                     <xsl:value-of select="concat('image/',substring-after($list_next,'.'))"/>
                  </xsl:otherwise>
               </xsl:choose>
            </xsl:attribute>
         </item>
         <xsl:call-template name="manifest_ancillary">
            <xsl:with-param name="list_param" select="substring-after($list_param,',')"/>
            <xsl:with-param name="counter" select="$counter + 1"/>
         </xsl:call-template>
      </xsl:if>
   </xsl:template>

</xsl:stylesheet>
