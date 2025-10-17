<?xml version="1.0" encoding="UTF-8" ?>
<!-- This file is part of the DITA Open Toolkit project hosted on 
     Sourceforge.net. See the accompanying license.txt file for 
     applicable licenses.-->
<!-- (c) Copyright IBM Corp. 2004, 2005 All Rights Reserved. -->

<!DOCTYPE xsl:stylesheet [

  <!ENTITY gt            "&gt;">
  <!ENTITY lt            "&lt;">
  <!ENTITY rbl           " ">
  <!ENTITY nbsp          "&#xA0;">    <!-- &#160; -->
  <!ENTITY quot          "&#34;">
  <!ENTITY copyr         "&#169;">
  ]>
  
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
  xmlns:saxon="http://icl.com/saxon" extension-element-prefixes="saxon"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:java="org.dita.dost.util.StringUtils" exclude-result-prefixes="java dita-ot ditamsg">

  <!-- map2htmltoc.xsl   main stylesheet
     Convert DITA map to a simple HTML table-of-contents view.
     Input = one DITA map file
     Output = one HTML file for viewing/checking by the author.

     Options:
        OUTEXT  = XHTML output extension (default is '.html')
        WORKDIR = The working directory that contains the document being transformed.
                   Needed as a directory prefix for the @href "document()" function calls.
                   Default is './'
-->


  <xsl:output method="xml" indent="no" encoding="UTF-8"/>

  <!-- *************************** Command line parameters *********************** -->
  <!-- need transtype to distinguish SCORM from epub transforms. -->
  <xsl:param name="TRANSTYPE"/>

  <!--<xsl:param name="OUTEXT" select="'.html'"/>-->
  <xsl:param name="OUTEXT" select="'.shtml'"/>
  <!-- "htm" and "html" are valid values -->
  <xsl:param name="WORKDIR" select="'./'"/>
  <xsl:param name="DITAEXT">
    <xsl:choose>
      <xsl:when test="$TRANSTYPE='scorm1.2'">
        <xsl:text>.dita</xsl:text>
      </xsl:when>
      <xsl:when test="$TRANSTYPE='scorm1.2_custom'">
        <xsl:text>.dita</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>.xml</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <xsl:param name="FILEREF" select="'file://'"/>
  <xsl:param name="contenttarget" select="'contentwin'"/>
  <xsl:param name="CSS"/>
  <xsl:param name="CSSPATH"/>
  <xsl:param name="OUTPUTCLASS"/>
  <!-- class to put on body element. -->
  <!-- the path back to the project. Used for c.gif, delta.gif, css to allow user's to have
  these files in 1 location. -->
  <xsl:param name="PATH2PROJ">
    <xsl:apply-templates select="/processing-instruction('path2project')" mode="get-path2project"/>
  </xsl:param>
  
  <!-- Define a newline character -->
  <xsl:variable name="newline">
    <xsl:text>
</xsl:text>
  </xsl:variable>

  <xsl:template match="processing-instruction('path2project')" mode="get-path2project">
    <xsl:value-of select="."/>
  </xsl:template>

  <!-- *********************************************************************************
     Setup the HTML wrapper for the table of contents
     ********************************************************************************* -->
  <!--Added by William on 2009-11-23 for bug:2900047 extension bug start -->
  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$TRANSTYPE = 'scorm1.2'">
        <xsl:call-template name="generate-toc"/>
        
      </xsl:when>
      <xsl:when test="$TRANSTYPE = 'scorm1.2_custom'">
        <xsl:call-template name="generate-toc"/>
        
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="generate-toc.epub"/>
        
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!--Added by William on 2009-11-23 for bug:2900047 extension bug end -->
  <!--  -->
  <!-- [SP] Override overall processing to simply generate a <ul>.
          The output file will be sourced into HTML files in the dita2htmlImpl_sps_xhtml.xsl. -->

  <xsl:template name="generate-toc.epub">
    <!-- [SP] Removed all HTML-ness from the output, because the output will be used as source
               for each individual page. -->
    <xsl:if test="string-length($OUTPUTCLASS) &gt; 0">
      <xsl:attribute name="class">
        <xsl:value-of select="$OUTPUTCLASS"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:value-of select="$newline"/>
    <xsl:apply-templates/>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <!-- Nexus for map/map -->
  <xsl:template match="/*[contains(@class, ' map/map ')]">
    <xsl:choose>
      <xsl:when test="$TRANSTYPE = 'scorm1.2'">
        <xsl:apply-templates select="." mode="toc"/>
        
      </xsl:when>
      <xsl:when test="$TRANSTYPE = 'scorm1.2_custom'">
        <xsl:apply-templates select="." mode="toc"/>
        
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="map-map.noscorm"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- *********************************************************************************
     If processing only a single map, setup the HTML wrapper and output the contents.
     Otherwise, just process the contents.
     ********************************************************************************* -->
  <xsl:template match="/*[contains(@class, ' map/map ')]" mode="map-map.noscorm">
    <xsl:param name="pathFromMaplist"/>

    <xsl:if
      test=".//*[contains(@class, ' map/topicref ')][not(@toc='no')][not(@processing-role='resource-only')]">
      <ul>
        <!-- [SP] Add an id to the ul to keep track of local storage. -->
        <xsl:attribute name="id">
          <xsl:choose>
            <xsl:when test="@id and @id != ''">
              <xsl:value-of select="@id"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="xtrf_filename">
                <xsl:call-template name="substring-after-last">
                  <xsl:with-param name="input" select="translate(@xtrf,'\','/')"/>
                  <xsl:with-param name="substr" select="'/'"/>
                </xsl:call-template>
              </xsl:variable>
              <xsl:value-of select="substring-before($xtrf_filename,'.')"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:value-of select="$newline"/>

        <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]">
          <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
        </xsl:apply-templates>
      </ul>
      <xsl:value-of select="$newline"/>
    </xsl:if>

  </xsl:template>
  
  <!-- nexus for map/topicref -->
  <xsl:template match="*[contains(@class, ' map/topicref ')]
    [not(@toc = 'no')]
    [not(@processing-role = 'resource-only')]">
    
    <xsl:choose>
      <xsl:when test="$TRANSTYPE = 'scorm1.2'">
        <xsl:apply-templates select="." mode="toc"/>
      </xsl:when>
      <xsl:when test="$TRANSTYPE = 'scorm1.2_custom'">
        <xsl:apply-templates select="." mode="toc"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="." mode="map-topicref.noscorm"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  

  <!-- *********************************************************************************
     Output each topic as an <li> with an A-link. Each item takes 2 values:
     - A title. If a navtitle is specified on <topicref>, use that.
       Otherwise try to open the file and retrieve the title. First look for a navigation title in the topic,
       followed by the main topic title. Last, try to use <linktext> specified in the map.
       Failing that, use *** and issue a message.
     - An HREF is optional. If none is specified, this will generate a wrapper.
       Include the HREF if specified.
     - Ignore if TOC=no.

     If this topicref has any child topicref's that will be part of the navigation,
     output a <ul> around them and process the contents.
     ********************************************************************************* -->
  <xsl:template
    match="*[contains(@class, ' map/topicref ')][not(@toc='no')][not(@processing-role='resource-only')]" mode="map-topicref.noscorm">
    <xsl:param name="pathFromMaplist"/>
    <xsl:param name="level" select="1"/>

    <xsl:variable name="title">
      <xsl:apply-templates select="." mode="get-navtitle"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$title and $title!=''">
        <xsl:variable name="haschildren"
          select="descendant::*[contains(@class, ' map/topicref ')][not(contains(@toc,'no'))][not(@processing-role='resource-only')]"/>
        <xsl:variable name="collapsed_icon">
          <xsl:call-template name="getString">
            <xsl:with-param name="stringName" select="'collapsed_icon'"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="terminal_icon">
          <xsl:call-template name="getString">
            <xsl:with-param name="stringName" select="'terminal_icon'"/>
          </xsl:call-template>
        </xsl:variable>

        <li>
          <xsl:attribute name="id">
            <xsl:value-of select="generate-id()"/>
          </xsl:attribute>
          <xsl:choose>
            <xsl:when test="$level &lt;= 5 and $haschildren">
              <!--<span class="toc_branch" onclick="toggle_nav(this,event)">-->
              <span class="toc_branch" onclick="toggle_nav(this,event)">
                <xsl:variable name="expand_string">
                  <xsl:call-template name="getString">
                    <xsl:with-param name="stringName" select="'expand_string'"/>
                  </xsl:call-template>
                </xsl:variable>
                <!--<xsl:attribute name="alt">
                  <xsl:value-of select="$expand_string"/>
                </xsl:attribute>-->
                <xsl:attribute name="title">
                  <xsl:value-of select="$expand_string"/>
                </xsl:attribute>
                <!--<img style="margin-right: 6px;" src="{$collapsed_icon}" alt="{$expand_string}"/>-->
                <!--<canvas title="Click to expand" class="Click to expand" height="9px" width="9px"/>-->
                <!--<xsl:text>&#43;&#32;</xsl:text>-->
                <xsl:text>&#32;</xsl:text>
              </span>

            </xsl:when>
            <xsl:when test="$level &lt;= 6 and not($haschildren)">
              <!--<span class="toc_branch">-->
              <span class="toc_branch">
                <!--<img style="margin-right: 6px;" src="{$terminal_icon}" alt="no children"/>-->
                <xsl:text>&#32;</xsl:text>
              </span>
            </xsl:when>
            <xsl:otherwise>
              <!--<span class="toc_branch">
                <img style="margin-right: 6px;" src="{$terminal_icon}"/>
              </span>-->
            </xsl:otherwise>
          </xsl:choose>
          <xsl:choose>
            <!-- If there is a reference to a DITA or HTML file, and it is not external: -->
            <xsl:when test="@href and not(@href='')">
              <xsl:element name="a">
                <xsl:attribute name="href">
                  <xsl:choose>
                    <!-- What if targeting a nested topic? Need to keep the ID? -->
                    <!-- edited by william on 2009-08-06 for bug:2832696 start -->
                    <xsl:when
                      test="contains(@copy-to, $DITAEXT) and not(contains(@chunk, 'to-content')) and 
                    (not(@format) or @format = 'dita' or @format='ditamap' ) ">
                      <!-- edited by william on 2009-08-06 for bug:2832696 end -->
                      <xsl:if test="not(@scope='external')">
                        <xsl:value-of select="$pathFromMaplist"/>
                      </xsl:if>
                      <!-- added by William on 2009-11-26 for bug:1628937 start-->
                      <xsl:value-of select="java:getFileName(@copy-to,$DITAEXT)"/>
                      <!-- added by William on 2009-11-26 for bug:1628937 end-->
                      <xsl:value-of select="$OUTEXT"/>
                      <xsl:if test="not(contains(@copy-to, '#')) and contains(@href, '#')">
                        <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
                      </xsl:if>
                    </xsl:when>
                    <!-- edited by william on 2009-08-06 for bug:2832696 start -->
                    <xsl:when
                      test="contains(@href,$DITAEXT) and (not(@format) or @format = 'dita' or @format='ditamap')">
                      <!-- edited by william on 2009-08-06 for bug:2832696 end -->
                      <xsl:if test="not(@scope='external')">
                        <xsl:value-of select="$pathFromMaplist"/>
                      </xsl:if>
                      <!-- added by William on 2009-11-26 for bug:1628937 start-->
                      <!--xsl:value-of select="substring-before(@href,$DITAEXT)"/-->
                      <xsl:value-of select="java:getFileName(@href,$DITAEXT)"/>
                      <!-- added by William on 2009-11-26 for bug:1628937 end-->
                      <xsl:value-of select="$OUTEXT"/>
                      <xsl:if test="contains(@href, '#')">
                        <xsl:value-of select="concat('#', substring-after(@href, '#'))"/>
                      </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                      <!-- If non-DITA, keep the href as-is -->
                      <xsl:if test="not(@scope='external')">
                        <xsl:value-of select="$pathFromMaplist"/>
                      </xsl:if>
                      <xsl:value-of select="@href"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>

                <xsl:if
                  test="@scope='external' or @type='external' or ((@format='PDF' or @format='pdf') and not(@scope='local'))">
                  <xsl:attribute name="target">_blank</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="$title"/>
              </xsl:element>
            </xsl:when>

            <xsl:otherwise>
              <xsl:value-of select="$title"/>
            </xsl:otherwise>
          </xsl:choose>

          <!-- If there are any children that should be in the TOC, process them -->
          <xsl:choose>
            <!-- [SP] Restrict the TOC to two levels. -->
            <xsl:when test="$level &gt;= 5">
              <!-- [SP] Do nothing. -->
            </xsl:when>
            <xsl:when
              test="descendant::*[contains(@class, ' map/topicref ')][not(contains(@toc,'no'))][not(@processing-role='resource-only')]">
              <xsl:value-of select="$newline"/>
              <ul>
                <!-- [SP] sub-levels <xsl:if test="$level = 1">-->
                <xsl:attribute name="id">
                  <xsl:value-of select="concat('ul_key',generate-id(.))"/>
                </xsl:attribute>

                <xsl:if test="$level &lt; 6">
                  <xsl:attribute name="style">display:none</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="$newline"/>
                <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]">
                  <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
                  <!-- [SP] Keep track of the level. -->
                  <xsl:with-param name="level" select="$level + 1"/>
                </xsl:apply-templates>
              </ul>
              <xsl:value-of select="$newline"/>
            </xsl:when>
          </xsl:choose>
        </li>
        <xsl:value-of select="$newline"/>
      </xsl:when>
      <xsl:otherwise>
        <!-- if it is an empty topicref (with no title). -->
        <xsl:apply-templates select="*[contains(@class, ' map/topicref ')]">
          <xsl:with-param name="pathFromMaplist" select="$pathFromMaplist"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->

<!-- [SP] 2016-03-09 sfb: Not needed and conflicts with OT function of the same name. -->
<!--  <!-\- [SP] Utility function. Returns the substring before the last occurrence of substr. -\->
  <xsl:template name="substring-before-last">
    <xsl:param name="input"/>
    <xsl:param name="substr"/>
    <xsl:if test="$substr and contains($input, $substr)">
      <xsl:variable name="temp" select="substring-after($input, $substr)"/>
      <xsl:value-of select="substring-before($input, $substr)"/>
      <xsl:if test="contains($temp, $substr)">
        <xsl:value-of select="$substr"/>
        <xsl:call-template name="substring-before-last">
          <xsl:with-param name="input" select="$temp"/>
          <xsl:with-param name="substr" select="$substr"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>
-->
  <!-- [SP] Utility function. Returns the substring after the last occurrence of substr. -->
  <xsl:template name="substring-after-last">
    <xsl:param name="input"/>
    <xsl:param name="substr"/>
    <!--		working with (<xsl:value-of select="$input"/>, <xsl:value-of select="$substr"/>). -->
    <!-- Extract the string which comes after the first occurence -->
    <xsl:variable name="temp" select="substring-after($input,$substr)"/>
    <xsl:choose>
      <xsl:when test="string-length($temp)=0">
        <xsl:value-of select="$input"/>
      </xsl:when>
      <xsl:when test="not(contains($temp,$substr))">
        <xsl:value-of select="$temp"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="substring-after-last">
          <xsl:with-param name="input" select="$temp"/>
          <xsl:with-param name="substr" select="$substr"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>




</xsl:stylesheet>
