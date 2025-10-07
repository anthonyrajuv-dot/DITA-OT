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

<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
  xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
  xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
  xmlns:exsl="http://exslt.org/common" xmlns:java="org.dita.dost.util.ImgUtils"
  xmlns:url="org.dita.dost.util.URLUtils"
  exclude-result-prefixes="dita-ot dita2html ditamsg exsl java url">


  <!-- [SP] namespaces holding
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="dita-ot dita2html ditamsg exsl java url #default xhtml"
  -->


  <!-- =========== OTHER STYLESHEET INCLUDES/IMPORTS =========== -->
  <xsl:include href="get-meta_sepub3.xsl"/>
  <xsl:include href="rel-links_sepub3.xsl"/>
  <!-- =========== OUTPUT METHOD =========== -->

  <!-- XHTML output with XML syntax -->
  <!--  <xsl:output method="xml" encoding="utf-8" indent="no" doctype-public="-//W3C//DTD XHTML 1.1//EN"
    doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd" omit-xml-declaration="yes"/>
-->

  <!-- [SP] store name of mapfile here SSO
     used to create chapter and appendix prefixes later -->
  <xsl:param name="MAPFILE"/>
  <xsl:param name="BASE_DIR"/>
  <xsl:param name="force.pngs"/>
  
  <!-- Global variable containing the entire map. -->
  <!-- TODO: eventually eliminate all other document() calls that open $MAPFILE. -->
  <xsl:variable name="map" select="document(concat('file:///',$MAPFILE))"/>

   <!-- topic handling for kpe-glossEntry. -->
  <xsl:template match="*[contains(@class,' kpe-glossEntry/kpe-glossEntry ')]">
    <xsl:apply-templates/>
  </xsl:template>
  
  
  <!-- child topics get a div wrapper and fall through -->
  <xsl:template match="*[contains(@class, ' topic/topic ')]" mode="child.topic" name="child.topic">
    <xsl:param name="nestlevel">
      <xsl:choose>
        <!-- Limit depth for historical reasons, could allow any depth. Previously limit was 5. -->
        <xsl:when test="count(ancestor::*[contains(@class, ' topic/topic ')]) > 9">9</xsl:when>
        <xsl:otherwise><xsl:value-of select="count(ancestor::*[contains(@class, ' topic/topic ')])"/></xsl:otherwise>
      </xsl:choose>
    </xsl:param>
      <xsl:choose>
        <xsl:when test="$TRANSTYPE='sepub3'">
          <xsl:call-template name="gen-topic.sepub3"/>      
        </xsl:when>
        <xsl:otherwise>
          <div class="nested{$nestlevel}">
            <xsl:call-template name="gen-topic"/>      
          </div><xsl:value-of select="$newline"/>
        </xsl:otherwise>
      </xsl:choose>
  </xsl:template>
  
  <xsl:template name="gen-topic.sepub3">
    <xsl:param name="nestlevel">
      <xsl:choose>
        <!-- Limit depth for historical reasons, could allow any depth. Previously limit was 5. -->
        <xsl:when test="count(ancestor::*[contains(@class, ' topic/topic ')]) > 9">9</xsl:when>
        <xsl:otherwise><xsl:value-of select="count(ancestor::*[contains(@class, ' topic/topic ')])"/></xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <xsl:choose>
      <xsl:when test="contains(@class,' kpe-assessmentOverview/kpe-assessmentOverview ')">
        <xsl:call-template name="gen-topic.sepub3.kpe-assessmentOverview"/>
      </xsl:when>
      <xsl:when test="contains(@class,' kpe-question/kpe-question ')">
        <xsl:call-template name="gen-topic.sepub3.kpe-question"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>    
        
        <!-- Test if we're in an answer key. -->
        <xsl:variable name="my_id" select="@id"/>
        <xsl:variable name="outputclass" select="$map//*[contains(@href,$my_id)]/@outputclass"/>
        
        <xsl:if test="$outputclass='Answer_Key'">
          <xsl:call-template name="handle_answer_key"/>            
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  
  <xsl:template name="gen-topic.sepub3.kpe-assessmentOverview">
    <xsl:apply-templates select="*[contains(@class,' topic/title ')]"/>
    <ol>
      <xsl:apply-templates select="*[not(contains(@class,' topic/title '))]"/>
    </ol>
    
    <!-- If this is a quiz, insert the Answer Key -->
    <xsl:if test="descendant::*[contains(@class,' kpe-commonMeta-d/lmsCategory ') and value='test_exam_secondary']">
      
      <p class="unit_title">Quiz Answers</p>
      <ol>
        <xsl:apply-templates select="*[not(contains(@class,' topic/title '))]"/>
      </ol>
    </xsl:if>
    
  </xsl:template>
  <xsl:template name="gen-topic.sepub3.kpe-question">
    <li>
      <xsl:call-template name="gen-toc-id"/>
      
      <xsl:apply-templates/>
    </li>
  </xsl:template>
  
  <xsl:template name="gen-topic.sepub3.old_graveyard">
<!--    
    <xsl:choose>
      <xsl:when test="parent::dita and not(preceding-sibling::*)">
        <!-\- Do not reset xml:lang if it is already set on <html> -\->
        <!-\- Moved outputclass to the body tag -\->
        <!-\- Keep ditaval based styling at this point (replace DITA-OT 1.6 and earlier call to gen-style) -\->
        <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/@outputclass" mode="add-ditaval-style"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="commonattributes">
          <xsl:with-param name="default-output-class" select="concat('nested', $nestlevel)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="gen-toc-id"/>
    <xsl:call-template name="setidaname"/>
    <xsl:choose>
    </xsl:choose>
-->    
  </xsl:template>
  
  <!-- These next three are required to pass the answer_key param down to the lcFeedbackCorrect. -->
  <xsl:template match="*[contains(@class,' kpe-question/kpe-questionBody ')]" priority="100">
    <xsl:param name="answer_key"/>
    <xsl:apply-templates>
      <xsl:with-param name="answer_key" select="$answer_key"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="*[contains(@class,' learningBase/lcInteraction ')]" priority="100">
    <xsl:param name="answer_key"/>
    <xsl:apply-templates>
      <xsl:with-param name="answer_key" select="$answer_key"/>
    </xsl:apply-templates>
  </xsl:template>

  <xsl:template match="*[contains(@class,' learning2-d/lcSingleSelect2 ')]" priority="100">
    <xsl:param name="answer_key"/>
    <xsl:apply-templates>
      <xsl:with-param name="answer_key" select="$answer_key"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <!--  PSB 7/31/15 Added to include Open Questions-->
  <xsl:template match="*[contains(@class,' learning2-d/lcOpenQuestion2 ')]" priority="100">
    <xsl:param name="answer_key"/>
    <xsl:apply-templates>
      <xsl:with-param name="answer_key" select="$answer_key"/>
    </xsl:apply-templates>
  </xsl:template>
  
  
  <xsl:template name="handle_answer_key">
    <!-- Find all assessment overviews. Worry about exam/quiz later. -->
    <xsl:apply-templates select="$map//*[contains(@class,' map/topicref ') and @type='kpe-assessmentOverview']" mode="handle_answer_key"/>
  </xsl:template>
  
  <!-- Use the topicref to open the file containing the assessment -->
  <xsl:template match="*[contains(@class,' map/topicref ')]" mode="handle_answer_key">
    <xsl:variable name="topic_file" select="substring-before(@href,'#')"/>
    <xsl:variable name="topic_id" select="substring-after(@href,'#')"/>
    <xsl:apply-templates select="document(concat($BASE_DIR,$topic_file))" mode="handle_answer_key">
      <xsl:with-param name="topic_id" select="$topic_id"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="/" mode="handle_answer_key">
    <xsl:param name="topic_id"/>
    
    <!-- Weed out any assessmentOverview that's not test_exam_primary. -->
    <xsl:apply-templates 
      select="//*[contains(@class,' kpe-assessmentOverview/kpe-assessmentOverview ') 
      and @id=$topic_id 
      and descendant::*[contains(@class,' kpe-commonMeta-d/lmsCategory ') and @value='test_exam_primary']]" mode="answer_key_output"/>          
    
  </xsl:template>
  
  <!-- OK! Ready to output the Answer Key! -->
  <xsl:template match="*[contains(@class,' kpe-assessmentOverview/kpe-assessmentOverview ')]" mode="answer_key_output">
    <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="answer_key_output"/>
    <ol>
      <xsl:apply-templates select="*[contains(@class,' kpe-question/kpe-question ')]" mode="answer_key_output">
        <xsl:with-param name="answer_key" select="'true'"/>
      </xsl:apply-templates>
    </ol>
  </xsl:template>
  
  <xsl:template match="*[contains(@class,' topic/title ')]" mode="answer_key_output">
    <h1><xsl:apply-templates/></h1>
  </xsl:template>
  
  <xsl:template match="*[contains(@class,' kpe-question/kpe-question ')]" mode="answer_key_output">
    
    <li>
      <xsl:apply-templates>
        <xsl:with-param name="answer_key" select="'true'"/>
      </xsl:apply-templates>
    </li>
  </xsl:template>
  
  
  
   <!-- Titles -->

  <xsl:template match="*[contains(@class,' topic/title ')]" mode="topic_title_sepub3">
    <xsl:param name="headinglevel"/>
    <xsl:choose>
      <xsl:when test="ancestor::*[contains(@class,' kpe-glossEntry/kpe-glossEntry ')]">
        <p>
          <b>
            <xsl:apply-templates/>
          </b>
        </p>
      </xsl:when>
      <xsl:when test="ancestor::*[contains(@class,' topic/topic ') and @outputclass='topic_intro']">
        <p class="unit_title">
          <xsl:apply-templates/>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <h1>
          <xsl:apply-templates/>
        </h1>
        <!--        <xsl:element name="h{$headinglevel}">
          <xsl:apply-templates/>
        </xsl:element>-->
      </xsl:otherwise>
    </xsl:choose>


    <xsl:value-of select="$newline"/>
  </xsl:template>


  <!-- =========== BODY/SECTION (not sensitive to nesting depth) =========== -->

  <xsl:template match="*[contains(@class,' topic/body ')]" mode="body.sepub3">
    <xsl:variable name="flagrules">
      <xsl:call-template name="getrules"/>
    </xsl:variable>
    <!--    <xsl:message>XYZZY: KEYREF-FILE is <xsl:value-of select="$KEYREF-FILE"/>.</xsl:message>-->
    <div>
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="gen-style">
        <xsl:with-param name="flagrules" select="$flagrules"/>
      </xsl:call-template>
      <xsl:call-template name="setidaname"/>
      <xsl:call-template name="start-flags-and-rev">
        <xsl:with-param name="flagrules" select="$flagrules"/>
      </xsl:call-template>
      <!-- here, you can generate a toc based on what's a child of body -->
      <!--xsl:call-template name="gen-sect-ptoc"/-->
      <!-- Works; not always wanted, though; could add a param to enable it.-->

      <!-- Insert prev/next links. since they need to be scoped by who they're 'pooled' with, apply-templates in 'hierarchylink' mode to linkpools (or related-links itself) when they have children that have any of the following characteristics:
       - role=ancestor (used for breadcrumb)
       - role=next or role=previous (used for left-arrow and right-arrow before the breadcrumb)
       - importance=required AND no role, or role=sibling or role=friend or role=previous or role=cousin (to generate prerequisite links)
       - we can't just assume that links with importance=required are prerequisites, since a topic with eg role='next' might be required, while at the same time by definition not a prerequisite -->

      <!-- Added for DITA 1.1 "Shortdesc proposal" -->
      <!-- get the abstract para -->
      <xsl:apply-templates select="preceding-sibling::*[contains(@class,' topic/abstract ')]"
        mode="outofline"/>

      <!-- get the shortdesc para -->
      <xsl:apply-templates select="preceding-sibling::*[contains(@class,' topic/shortdesc ')]"
        mode="outofline"/>

      <!-- Insert pre-req links - after shortdesc - unless there is a prereq section about -->
      <xsl:apply-templates select="following-sibling::*[contains(@class,' topic/related-links ')]"
        mode="prereqs"/>

      <xsl:apply-templates/>

      <xsl:call-template name="end-flags-and-rev">
        <xsl:with-param name="flagrules" select="$flagrules"/>
      </xsl:call-template>
    </div>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <!--  <xsl:template match="*[contains(@class,' topic/body ')]" mode="body.sepub3">
    <xsl:variable name="flagrules">
      <xsl:call-template name="getrules"/>
    </xsl:variable>
    <xsl:comment>body.sepub3</xsl:comment>
    <div>
      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="gen-style">
        <xsl:with-param name="flagrules" select="$flagrules"/>
      </xsl:call-template>
      <xsl:call-template name="setidaname"/>
      <xsl:call-template name="start-flags-and-rev">
        <xsl:with-param name="flagrules" select="$flagrules"/>
      </xsl:call-template>
      <!-\- here, you can generate a toc based on what's a child of body -\->
      <!-\-xsl:call-template name="gen-sect-ptoc"/-\->
      <!-\- Works; not always wanted, though; could add a param to enable it.-\->
      
      <!-\- Insert prev/next links. since they need to be scoped by who they're 'pooled' with, apply-templates in 'hierarchylink' mode to linkpools (or related-links itself) when they have children that have any of the following characteristics:
       - role=ancestor (used for breadcrumb)
       - role=next or role=previous (used for left-arrow and right-arrow before the breadcrumb)
       - importance=required AND no role, or role=sibling or role=friend or role=previous or role=cousin (to generate prerequisite links)
       - we can't just assume that links with importance=required are prerequisites, since a topic with eg role='next' might be required, while at the same time by definition not a prerequisite -\->
      
      <!-\- Added for DITA 1.1 "Shortdesc proposal" -\->
      <!-\- get the abstract para -\->
      <xsl:apply-templates select="preceding-sibling::*[contains(@class,' topic/abstract ')]"
        mode="outofline"/>
      
      <!-\- get the shortdesc para -\->
      <xsl:apply-templates select="preceding-sibling::*[contains(@class,' topic/shortdesc ')]"
        mode="outofline"/>
      
      <!-\- Insert pre-req links - after shortdesc - unless there is a prereq section about -\->
      <xsl:apply-templates select="following-sibling::*[contains(@class,' topic/related-links ')]"
        mode="prereqs"/>
      
      <xsl:apply-templates/>
      
      <xsl:call-template name="end-flags-and-rev">
        <xsl:with-param name="flagrules" select="$flagrules"/>
      </xsl:call-template>
    </div>
    <xsl:value-of select="$newline"/>
  </xsl:template>
-->
  <!-- =========== BASIC BODY ELEMENTS =========== -->

  <!-- paragraphs -->
  <xsl:template match="*[contains(@class,' topic/p ')]" mode="p.sepub3" name="topic.p.sepub3">
    <!-- To ensure XHTML validity, need to determine whether the DITA kids are block elements.
      If so, use div_class="p" instead of p -->
    <xsl:choose>
      <xsl:when test="parent::*[contains(@class,' topic/fig ')]">
        <p class="figure_body">
          <xsl:apply-templates/>
        </p>
      </xsl:when>
      <xsl:when test="parent::*[contains(@class,' kpe-common-d/sample ')]">
        <p class="example_body">
          <xsl:apply-templates/>
        </p>
      </xsl:when>
      <xsl:when
        test="descendant::*[contains(@class,' topic/pre ')] or
       descendant::*[contains(@class,' topic/ul ')] or
       descendant::*[contains(@class,' topic/sl ')] or
       descendant::*[contains(@class,' topic/ol ')] or
       descendant::*[contains(@class,' topic/lq ')] or
       descendant::*[contains(@class,' topic/dl ')] or
       descendant::*[contains(@class,' topic/note ')] or
       descendant::*[contains(@class,' topic/lines ')] or
       descendant::*[contains(@class,' topic/fig ')] or
       descendant::*[contains(@class,' topic/table ')] or
       descendant::*[contains(@class,' topic/simpletable ')]">
        <div>
          <!--          <xsl:call-template name="commonattributes"/>-->
          <xsl:call-template name="setid"/>
          <xsl:apply-templates select="." mode="outputContentsWithFlagsAndStyle"/>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <p>
          <!--          <xsl:call-template name="commonattributes"/>-->
          <xsl:call-template name="setid"/>
          <xsl:apply-templates select="." mode="outputContentsWithFlagsAndStyle"/>
        </p>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/lq ')]" name="topic.lq">
    <blockquote>
  <!--    <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="setidaname"/>
 -->
      <xsl:apply-templates select="."  mode="lq-fmt" />
    </blockquote><xsl:value-of select="$newline"/>
  </xsl:template>
  

  <xsl:template match="*[contains(@class,' topic/lq ')]" mode="lq-fmt">
    <!-- Abandoning flagging, etc. just output blockquote. -->
      <xsl:choose>
        <!-- If there's an element in the lq, just deal with it. -->
        <xsl:when test="element()">
          <xsl:apply-templates/>          
        </xsl:when>
        <!-- If not, wrap it in a <p>. -->
        <xsl:otherwise>
          <p>
            <xsl:apply-templates/>
          </p>
        </xsl:otherwise>
      </xsl:choose>
    
<!--    
    <xsl:variable name="flagrules">
      <xsl:call-template name="getrules"/>
    </xsl:variable>
    <xsl:call-template name="start-revflag">
      <xsl:with-param name="flagrules" select="$flagrules"/>
    </xsl:call-template>

    <!-\- [SP] place unwrapped blockquote content in a {p} tag. -\->
    <!-\- <xsl:variable name="unwrappedText" select="child::text()"></xsl:variable>
  <!-\\-<xsl:message>**********</xsl:message>
  <xsl:message>* text outside of element: <xsl:value-of select="$unwrappedText"/></xsl:message>
  <xsl:message>**********</xsl:message>  -\\->
  <p>
    <xsl:value-of select="$unwrappedText"/>
  </p>
  <xsl:apply-templates select="./*"/>-\->
    <xsl:apply-templates/>
    
    <!-\- Handling @href and @titleref attributes (moved). -\->
    
    <xsl:call-template name="end-revflag">
      <xsl:with-param name="flagrules" select="$flagrules"/>
    </xsl:call-template>
    
    -->

    <xsl:choose>
      <xsl:when test="@href">
        <!-- Insert citation as link, use @href as-is -->
        <br/>
        <div style="text-align:right">
          <a>
            <xsl:attribute name="href">
              <xsl:choose>
                <xsl:when test="contains(@href,$DITAEXT)">
                  <xsl:value-of select="substring-before(@href,$DITAEXT)"/>
                  <xsl:value-of select="$OUTEXT"/>
                  <xsl:value-of select="substring-after(@href,$DITAEXT)"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="@href"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <xsl:choose>
              <xsl:when test="@type='external'">
                <xsl:attribute name="target">_blank</xsl:attribute>
              </xsl:when>
              <xsl:otherwise><!--nop - no target needed for internal or biblio types (OR-should internal force DITA xref-like processing? What is intent? @type is only internal/external/bibliographic) --></xsl:otherwise>
            </xsl:choose>
            <cite>
              <xsl:choose>
                <xsl:when test="@reftitle">
                  <xsl:value-of select="@reftitle"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="@href"/>
                </xsl:otherwise>
              </xsl:choose>
            </cite>
          </a>
        </div>
      </xsl:when>
      <xsl:when test="@reftitle">
        <!-- Insert citation text -->
        <br/>
        <div style="text-align:right">
          <cite>
            <xsl:value-of select="@reftitle"/>
          </cite>
        </div>
      </xsl:when>
      <xsl:otherwise><!--nop - do nothing--></xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>
  <!-- PSB EDIT 9/3/15-->
  <xsl:template match="tm" mode="#all" priority="100">
    <xsl:variable name="content">
      <xsl:apply-templates mode="identity"/>
    </xsl:variable>
    <xsl:variable name="char">
      <xsl:choose>
        <xsl:when test="@tmtype = 'tm'">&#x2122;</xsl:when>
        <xsl:when test="@tmtype = 'reg'">&#xae;</xsl:when>
        <xsl:when test="@tmtype = 'service'">&#x2120;</xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:value-of select="concat(normalize-space($content),$char)"/>
  </xsl:template>
  <!-- Ordered List - 1st level - Handle levels 1 to 9 thru OL-TYPE attribution -->
  <!-- Updated to use a single template, use count and mod to set the list type -->
  <!-- <xsl:template match="*[contains(@class,' topic/ol ')]" name="topic.ol">
    <xsl:choose>
      <xsl:when test="$TRANSTYPE = 'sps_help'">
        <xsl:apply-templates select="." mode="ol.sps_help"/>
      </xsl:when>
      <xsl:when test="$TRANSTYPE = 'kpe_xhtml'">
        <xsl:apply-templates select="." mode="ol.kpe_xhtml"/>
      </xsl:when>
      <xsl:when test="$TRANSTYPE = 'sepub3'">
        <xsl:apply-templates select="." mode="ol.sepub3"/>
      </xsl:when>
    </xsl:choose>
    
  </xsl:template>
  -->

  <xsl:template match="*[contains(@class,' topic/ol ')]" mode="ol.sepub3" name="topic.ol.sepub3">
    <xsl:variable name="flagrules">
      <xsl:call-template name="getrules"/>
    </xsl:variable>
    <xsl:variable name="olcount" select="count(ancestor-or-self::*[contains(@class,' topic/ol ')])"/>
    <!-- edited by William on 2009-06-16 for bullet bug:2782503 start-->
    <!--br/-->
    <!-- edited by William on 2009-06-16 for bullet bug:2782503 end-->
    <xsl:call-template name="start-flags-and-rev">
      <xsl:with-param name="flagrules" select="$flagrules"/>
    </xsl:call-template>
    <xsl:call-template name="setaname"/>
    <ol>
      <!--      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="gen-style">
        <xsl:with-param name="flagrules" select="$flagrules"/>
      </xsl:call-template>-->
      <xsl:apply-templates select="@compact"/>
      <xsl:choose>
        <xsl:when test="@outputclass">
          <xsl:attribute name="type">
            <xsl:choose>
              <xsl:when test="@outputclass='ol_alpha'">
                <xsl:text>A</xsl:text>
              </xsl:when>
            </xsl:choose>
            <xsl:choose>
              <xsl:when test="@outputclass='ol_loweralpha'">
                <xsl:text>a</xsl:text>
              </xsl:when>
            </xsl:choose>
            <xsl:choose>
              <xsl:when test="@outputclass='ol_roman'">
                <xsl:text>I</xsl:text>
              </xsl:when>
            </xsl:choose>
            <xsl:choose>
              <xsl:when test="@outputclass='ol_lowerroman'">
                <xsl:text>i</xsl:text>
              </xsl:when>
            </xsl:choose>
          </xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:call-template name="setid"/>
      <xsl:apply-templates/>
    </ol>
    <xsl:call-template name="end-flags-and-rev">
      <xsl:with-param name="flagrules" select="$flagrules"/>
    </xsl:call-template>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <xsl:template match="*[contains(@class,' learningBase/lcObjectivesGroup ')]" priority="100">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="*[contains(@class,' topic/li ')]">
    <xsl:choose>
      <xsl:when
        test="parent::*[contains(@class,' topic/ul')] and ancestor::*[contains(@class,' topic/fig ')]">
        <li class="figure_bullet">
          <xsl:apply-templates/>
        </li>

      </xsl:when>
      <xsl:when
        test="parent::*[contains(@class,' topic/ul')] and ancestor::*[contains(@class,' kpe-common-d/sample ')]">
        <li class="example">
          <xsl:apply-templates/>
        </li>

      </xsl:when>
      <xsl:when test="contains(@class,' learningBase/lcObjective ')">
        <p class="learning_objective">
          <xsl:apply-templates mode="lcObjective"/>
        </p>
      </xsl:when>
      <xsl:otherwise>
        <li>
          <xsl:apply-templates/>
        </li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*[contains(@class,' topic/ph ')]" mode="lcObjective">
    <xsl:apply-templates/>
  </xsl:template>
  


  <!-- =========== DEFINITION LIST =========== -->

  <!-- DL -->
  <!-- [SP] 12-Apr-2013: Commented older version of the template out. Handled by xhtml transform. -->
  <!--  <xsl:template match="*[contains(@class,' topic/dl ')]" name="topic.dl">
    <xsl:variable name="revtest">
      <xsl:apply-templates select="." mode="mark-revisions-for-draft"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$revtest=1">
        <!-\- Rev is active - add the DIV -\->
        <div class="{@rev}">
          <xsl:apply-templates select="." mode="dl-fmt"/>
        </div>
      </xsl:when>
      <xsl:otherwise>
        <!-\- Rev wasn't active - process normally -\->
        <xsl:apply-templates select="." mode="dl-fmt"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>-->

  <!-- DL, sent to h3/h4.-->
  <xsl:template match="*[contains(@class,' topic/dl ')]" name="topic.dl">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- DL entry -->
  <!-- [SP] 12-Apr-2013: Let xhtml handle this.  If the div added by xhtml causes problems,
           then add a fork. -->
  <xsl:template match="*[contains(@class,' topic/dlentry ')]" name="topic.dlentry">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="*[contains(@class,' topic/dt ')]" name="topic.dt">
    <xsl:choose>
      <!-- dt buried in two dl's gets h4. -->
      <xsl:when test="count(ancestor-or-self::*[contains(@class,' topic/dl ')]) &gt; 1">
        <h4>
          <xsl:apply-templates/>
        </h4>
      </xsl:when>
      <xsl:otherwise>
        <h3>
          <xsl:apply-templates/>
        </h3>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[contains(@class,' topic/dd ')]" name="topic.dd">
    <xsl:apply-templates/>
  </xsl:template>




  <!-- =========== PHRASES =========== -->

  <xsl:template match="*[contains(@class,' topic/ph ')]" mode="ph.sepub3">
    <xsl:variable name="flagrules">
      <xsl:call-template name="getrules"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="@keyref">
        <xsl:apply-templates select="." mode="turning-to-link">
          <xsl:with-param name="keys" select="@keyref"/>
          <xsl:with-param name="flagrules" select="$flagrules"/>
          <xsl:with-param name="type" select="'ph'"/>
        </xsl:apply-templates>
      </xsl:when>
      <!--  <!-\- [SP] when phrase is not in a p, wrap it in a p. But not lq...-\->
    <xsl:when test="not(parent::p) or not(parent::lq)">
      <p>
      <span>
        <xsl:call-template name="commonattributes"/>
        <xsl:call-template name="gen-style">
          <xsl:with-param name="flagrules" select="$flagrules"></xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="setidaname"/>   
        <xsl:call-template name="flagcheck"/>
        <xsl:call-template name="start-flagit"><xsl:with-param name="flagrules" select="$flagrules"/></xsl:call-template>       
        <xsl:call-template name="revtext">
          <xsl:with-param name="flagrules" select="$flagrules"/>
        </xsl:call-template>
        <xsl:call-template name="end-flagit"><xsl:with-param name="flagrules" select="$flagrules"/></xsl:call-template>     
      </span>
      </p>
    </xsl:when>-->
      <xsl:otherwise>
        <span>
          <xsl:call-template name="commonattributes"/>
          <xsl:call-template name="gen-style">
            <xsl:with-param name="flagrules" select="$flagrules"/>
          </xsl:call-template>
          <xsl:call-template name="setidaname"/>
          <xsl:call-template name="flagcheck"/>
          <xsl:call-template name="start-flagit">
            <xsl:with-param name="flagrules" select="$flagrules"/>
          </xsl:call-template>
          <xsl:call-template name="revtext">
            <xsl:with-param name="flagrules" select="$flagrules"/>
          </xsl:call-template>
          <xsl:call-template name="end-flagit">
            <xsl:with-param name="flagrules" select="$flagrules"/>
          </xsl:call-template>
        </span>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="add-br-for-empty-cmd"/>
  </xsl:template>


  <!-- =========== IMAGE/OBJECT =========== -->
  <!-- [SP] 14-Feb-2013: Detect transtype for handling images. -->
  <xsl:template match="*[contains(@class,' topic/image ')]">
    <xsl:choose>
      <xsl:when test="$TRANSTYPE = 'sepub3'">
        <xsl:call-template name="topic.image.sepub3"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="topic.image"/>
      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

  <xsl:template name="topic.image.sepub3">
    <xsl:variable name="flagrules">
      <xsl:call-template name="getrules"/>
    </xsl:variable>
    <!-- build any pre break indicated by style -->
    <xsl:choose>
      <xsl:when test="parent::fig[contains(@frame,'top ')]">
        <!-- NOP if there is already a break implied by a parent property -->
      </xsl:when>
      <xsl:when test="@outputclass='print'">
        <!-- Do nothing. -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:choose>
          <xsl:when test="(@placement='break')">
            <br/>
            <xsl:call-template name="start-flagit">
              <xsl:with-param name="flagrules" select="$flagrules"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="flagcheck"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="start-revflag">
      <xsl:with-param name="flagrules" select="$flagrules"/>
    </xsl:call-template>
    <xsl:call-template name="setaname"/>
    <xsl:choose>
      <xsl:when test="@placement='break'">
        <!--Align only works for break-->

        <xsl:choose>
          <xsl:when test="@align='left' or @align='right' or @align='center'">
            <div class="image{@align}">
              <!--              <xsl:call-template name="topic-image"/>-->
              <xsl:call-template name="topic-image-sepub3"/>
            </div>
          </xsl:when>
          <!--          <xsl:when test="@align='right'">
            <div class="imageright">
              <xsl:call-template name="topic-image-sepub3"/>
            </div>
          </xsl:when>
          <xsl:when test="@align='center'">
            <div class="imagecenter">
              <xsl:call-template name="topic-image-sepub3"/>
            </div>
          </xsl:when>-->
          <xsl:otherwise>
            <!--            <xsl:call-template name="topic-image"/>-->
            <xsl:call-template name="topic-image-sepub3"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <!--        <xsl:call-template name="topic-image"/>-->
        <xsl:call-template name="topic-image-sepub3"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="end-revflag">
      <xsl:with-param name="flagrules" select="$flagrules"/>
    </xsl:call-template>
    <xsl:call-template name="end-flagit">
      <xsl:with-param name="flagrules" select="$flagrules"/>
    </xsl:call-template>
    <!-- build any post break indicated by style -->
    <xsl:if test="not(@placement='inline')">
      <br/>
    </xsl:if>
    <!-- image name for review -->
    <xsl:if test="$ARTLBL='yes'"> [<xsl:value-of select="@href"/>] </xsl:if>
  </xsl:template>

  <xsl:template name="topic-image-sepub3">
    <xsl:variable name="ends-with-svg">
      <xsl:call-template name="ends-with">
        <xsl:with-param name="text" select="@href"/>
        <xsl:with-param name="with" select="'.svg'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="ends-with-svgz">
      <xsl:call-template name="ends-with">
        <xsl:with-param name="text" select="@href"/>
        <xsl:with-param name="with" select="'.svgz'"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="isSVG" select="$ends-with-svg = 'true' or $ends-with-svgz = 'true'"/>
    <!--    <xsl:message>Image: outputclass is <xsl:value-of select="@outputclass"/>.</xsl:message>-->
    <xsl:choose>
      <xsl:when test="$isSVG">
        <!--<object data="file.svg" type="image/svg+xml" width="500" height="200">-->
        <!-- now invoke the actual content and its alt text -->
        <!-- [SP] 15-Jan-2013: Fixed svg handling. -->
        <object width="75%" height="75%" type="image/svg+xml">
          <xsl:call-template name="commonattributes">
            <xsl:with-param name="default-output-class">
              <xsl:if test="@placement='break'">
                <!--Align only works for break-->
                <xsl:choose>
                  <xsl:when test="@align='left'">imageleft</xsl:when>
                  <xsl:when test="@align='right'">imageright</xsl:when>
                  <xsl:when test="@align='center'">imagecenter</xsl:when>
                </xsl:choose>
              </xsl:if>
            </xsl:with-param>
          </xsl:call-template>
          <xsl:call-template name="setid"/>
          <xsl:attribute name="data">
            <xsl:value-of select="@href"/>
          </xsl:attribute>
          <xsl:apply-templates select="@height|@width"/>

          <!--<param name="wmode" value="transparent" />
          -->
        </object>
      </xsl:when>
      <xsl:when test="@outputclass='print'">
        <!-- Do nothing. -->
      </xsl:when>
      <xsl:otherwise>
        <img>
          <xsl:call-template name="commonattributes">
            <xsl:with-param name="default-output-class">
              <xsl:if test="@placement='break'">
                <!--Align only works for break-->
                <xsl:choose>
                  <xsl:when test="@align='left'">imageleft</xsl:when>
                  <xsl:when test="@align='right'">imageright</xsl:when>
                  <xsl:when test="@align='center'">imagecenter</xsl:when>
                </xsl:choose>
              </xsl:if>
            </xsl:with-param>
          </xsl:call-template>
          <xsl:call-template name="setid"/>
          <xsl:choose>
            <xsl:when test="*[contains(@class, ' topic/longdescref ')]">
              <xsl:apply-templates select="*[contains(@class, ' topic/longdescref ')]"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="@longdescref"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:apply-templates select="@href|@height|@width"/>
          <!-- Add by Alan for Bug:#2900417 on Date: 2009-11-23 begin -->
          <xsl:apply-templates select="@scale"/>
          <!-- Add by Alan for Bug:#2900417 on Date: 2009-11-23 end   -->
          <xsl:choose>
            <xsl:when test="*[contains(@class,' topic/alt ')]">
              <xsl:variable name="alt-content">
                <xsl:apply-templates select="*[contains(@class,' topic/alt ')]" mode="text-only"/>
              </xsl:variable>
              <xsl:attribute name="alt">
                <xsl:value-of select="normalize-space($alt-content)"/>
              </xsl:attribute>
            </xsl:when>
            <xsl:when test="@alt">
              <xsl:attribute name="alt">
                <xsl:value-of select="@alt"/>
              </xsl:attribute>
            </xsl:when>
            <!-- [SP] when no alt attr, use the filename -->
            <xsl:otherwise>
              <xsl:attribute name="alt">
                <xsl:value-of select="concat('image filename: ',@href)"/>
              </xsl:attribute>
            </xsl:otherwise>
          </xsl:choose>
        </img>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ===================================================================== -->

  <!-- =========== CALS (OASIS) TABLE =========== -->


  <!-- Contains transform-specific call. -->
  <xsl:template match="*" mode="dotable.sepub3">
    <xsl:variable name="flagrules">
      <xsl:call-template name="getrules"/>
    </xsl:variable>
    <xsl:call-template name="start-flags-and-rev">
      <xsl:with-param name="flagrules" select="$flagrules"/>
    </xsl:call-template>
    <xsl:call-template name="setaname"/>
    <table cellpadding="4" cellspacing="0" summary="">
      <xsl:variable name="colsep">
        <xsl:choose>
          <xsl:when test="*[contains(@class,' topic/tgroup ')]/@colsep">
            <xsl:value-of select="*[contains(@class,' topic/tgroup ')]/@colsep"/>
          </xsl:when>
          <xsl:when test="@colsep">
            <xsl:value-of select="@colsep"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="rowsep">
        <xsl:choose>
          <xsl:when test="*[contains(@class,' topic/tgroup ')]/@rowsep">
            <xsl:value-of select="*[contains(@class,' topic/tgroup ')]/@rowsep"/>
          </xsl:when>
          <xsl:when test="@rowsep">
            <xsl:value-of select="@rowsep"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:call-template name="setid"/>
      <xsl:call-template name="commonattributes"/>
      <xsl:apply-templates select="." mode="generate-table-summary-attribute"/>
      <xsl:call-template name="gen-style">
        <xsl:with-param name="flagrules" select="$flagrules"/>
      </xsl:call-template>
      <xsl:call-template name="setscale"/>
      <!-- When a table's width is set to page or column, force it's width to 100%. If it's in a list, use 90%.
       Otherwise, the table flows to the content -->
      <xsl:choose>
        <xsl:when
          test="(@expanse='page' or @pgwide='1')and (ancestor::*[contains(@class,' topic/li ')] or ancestor::*[contains(@class,' topic/dd ')] )">
          <xsl:attribute name="width">90%</xsl:attribute>
        </xsl:when>
        <xsl:when
          test="(@expanse='column' or @pgwide='0') and (ancestor::*[contains(@class,' topic/li ')] or ancestor::*[contains(@class,' topic/dd ')] )">
          <xsl:attribute name="width">90%</xsl:attribute>
        </xsl:when>
        <xsl:when test="(@expanse='page' or @pgwide='1')">
          <xsl:attribute name="width">100%</xsl:attribute>
        </xsl:when>
        <xsl:when test="(@expanse='column' or @pgwide='0')">
          <xsl:attribute name="width">100%</xsl:attribute>
        </xsl:when>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="@frame='all' and $colsep='0' and $rowsep='0'">
          <xsl:attribute name="border">0</xsl:attribute>
        </xsl:when>
        <xsl:when test="not(@frame) and $colsep='0' and $rowsep='0'">
          <xsl:attribute name="border">0</xsl:attribute>
        </xsl:when>
        <xsl:when test="@frame='sides'">
          <xsl:attribute name="frame">vsides</xsl:attribute>
          <xsl:attribute name="border">1</xsl:attribute>
        </xsl:when>
        <xsl:when test="@frame='top'">
          <xsl:attribute name="frame">above</xsl:attribute>
          <xsl:attribute name="border">1</xsl:attribute>
        </xsl:when>
        <xsl:when test="@frame='bottom'">
          <xsl:attribute name="frame">below</xsl:attribute>
          <xsl:attribute name="border">1</xsl:attribute>
        </xsl:when>
        <xsl:when test="@frame='topbot'">
          <xsl:attribute name="frame">hsides</xsl:attribute>
          <xsl:attribute name="border">1</xsl:attribute>
        </xsl:when>
        <xsl:when test="@frame='none'">
          <xsl:attribute name="frame">void</xsl:attribute>
          <xsl:attribute name="border">1</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="frame">border</xsl:attribute>
          <xsl:attribute name="border">1</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="@frame='all' and $colsep='0' and $rowsep='0'">
          <xsl:attribute name="border">0</xsl:attribute>
        </xsl:when>
        <xsl:when test="not(@frame) and $colsep='0' and $rowsep='0'">
          <xsl:attribute name="border">0</xsl:attribute>
        </xsl:when>
        <xsl:when test="$colsep='0' and $rowsep='0'">
          <xsl:attribute name="rules">none</xsl:attribute>
          <xsl:attribute name="border">0</xsl:attribute>
        </xsl:when>
        <xsl:when test="$colsep='0'">
          <xsl:attribute name="rules">rows</xsl:attribute>
        </xsl:when>
        <xsl:when test="$rowsep='0'">
          <xsl:attribute name="rules">cols</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="rules">all</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="place-tbl-lbl-sepub3"/>

      <!-- title and desc are processed elsewhere -->
      <xsl:apply-templates select="*[contains(@class,' topic/tgroup ')]"/>
    </table>
    <xsl:value-of select="$newline"/>
    <xsl:call-template name="end-flags-and-rev">
      <xsl:with-param name="flagrules" select="$flagrules"/>
    </xsl:call-template>
  </xsl:template>


  <xsl:template
    match="*[contains(@class,' topic/entry') and ancestor::*[contains(@class,' topic/thead ')]]">
    <th>
      <xsl:apply-templates/>
    </th>
  </xsl:template>

  <xsl:template
    match="*[contains(@class,' topic/entry') and ancestor::*[contains(@class,' topic/tbody ')]]">
    <td>
      <xsl:apply-templates/>
    </td>
  </xsl:template>
  <!-- end of table section -->



  <!-- =========== FOOTNOTE =========== -->
  <xsl:template match="*[contains(@class,' topic/fn ')]" name="topic.fn">
    <xsl:param name="xref"/>
    <!-- when FN has an ID, it can only be referenced, otherwise, output an a-name & a counter -->
    <xsl:if test="not(@id) or $xref='yes'">
      <xsl:variable name="fnid">
        <xsl:number from="/" level="any"/>
      </xsl:variable>
      <xsl:variable name="callout">
        <xsl:value-of select="@callout"/>
      </xsl:variable>
      <xsl:variable name="convergedcallout">
        <xsl:choose>
          <xsl:when test="string-length($callout)> 0">
            <xsl:value-of select="$callout"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$fnid"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <!-- [SP] @name is invalid here, changed to @id; when a is not wrapped in a p tag, wrap it -->
      <xsl:choose>
        <xsl:when test="not(parent::p) and not(parent::lq) and not(parent::li) and not(parent::dd)">
          <p>
            <a id="fnsrc_{$fnid}" href="#fntarg_{$fnid}">
              <sup>
                <xsl:value-of select="$convergedcallout"/>
              </sup>
            </a>
          </p>
        </xsl:when>
        <xsl:otherwise>
          <a id="fnsrc_{$fnid}" href="#fntarg_{$fnid}">
            <sup>
              <xsl:value-of select="$convergedcallout"/>
            </sup>
          </a>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- Inlines, domains, etc. -->
  <xsl:template match="*[contains(@class,' hi-d/sub ')]">
    <sub>
      <xsl:apply-templates/>
    </sub>
  </xsl:template>

  <xsl:template match="*[contains(@class,' hi-d/sup ')]">
    <sup>
      <xsl:apply-templates/>
    </sup>
  </xsl:template>
  
  <xsl:template match="emphasisItalics">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>


  <xsl:template match="*[contains(@class,' hi-d/i ')]">
    <i>
      <xsl:apply-templates/>
    </i>
  </xsl:template>
<!--  PSB UPDATED 9/15/15-->
  <xsl:template match="*[contains(@class,' hi-d/b ')]">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>
  
<!--PSB ADDED 9/15/15-->
  
  <xsl:template match="emphasisBold">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>
  
  <xsl:template match="qualifier">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>

  <xsl:template match="term">
    <strong>
      <xsl:apply-templates/>
    </strong>
  </xsl:template>


  <xsl:template match="legalCite">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>


  <xsl:template match="cite">
    <em>
      <xsl:apply-templates/>
    </em>
  </xsl:template>







  <!-- ===================================================================== -->
  <!-- ========== GENERAL SUPPORT/DOC CONTENT MANAGEMENT          ========== -->
  <!-- ===================================================================== -->


  <!-- ========= NAMED TEMPLATES (call by name, only) ========== -->
  <!-- named templates that can be used anywhere -->


  <!-- ========== Section-like generated content =========== -->


  <!-- Catch footnotes that should appear at the end of the topic, and output them. -->
  <!-- [SP] 24-Apr-2013: Contains SP overrides. -->

  <xsl:template match="*[contains(@class,' topic/fn ')]" mode="genEndnote">
    <xsl:variable name="flagrules">
      <xsl:call-template name="getrules"/>
    </xsl:variable>
    <p class="footnote">
      <xsl:variable name="fnid">
        <xsl:number from="/" level="any"/>
      </xsl:variable>
      <xsl:variable name="callout">
        <xsl:value-of select="@callout"/>
      </xsl:variable>
      <xsl:variable name="convergedcallout">
        <xsl:choose>
          <xsl:when test="string-length($callout)> 0">
            <xsl:value-of select="$callout"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$fnid"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>

      <xsl:call-template name="commonattributes"/>
      <xsl:call-template name="gen-style">
        <xsl:with-param name="flagrules" select="$flagrules"/>
      </xsl:call-template>
      <xsl:choose>
        <xsl:when test="@id and not(@id='')">
          <xsl:variable name="topicid">
            <xsl:value-of select="ancestor::*[contains(@class,' topic/topic ')][1]/@id"/>
          </xsl:variable>
          <xsl:variable name="refid">
            <xsl:value-of select="$topicid"/>
            <xsl:text>/</xsl:text>
            <xsl:value-of select="@id"/>
          </xsl:variable>
          <xsl:choose>
            <xsl:when test="key('xref',$refid)">
              <a>
                <xsl:call-template name="setid"/>
                <sup>
                  <xsl:value-of select="$convergedcallout"/>
                </sup>
              </a>
              <xsl:text>  </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <sup>
                <xsl:value-of select="$convergedcallout"/>
              </sup>
              <xsl:text>  </xsl:text>
            </xsl:otherwise>
          </xsl:choose>

        </xsl:when>
        <xsl:otherwise>
          <a>
            <!-- [SP] @name is invalid, changed to @id -->
            <xsl:attribute name="id">
              <xsl:text>fntarg_</xsl:text>
              <xsl:value-of select="$fnid"/>
            </xsl:attribute>
            <xsl:attribute name="href">
              <xsl:text>#fnsrc_</xsl:text>
              <xsl:value-of select="$fnid"/>
            </xsl:attribute>
            <sup>
              <xsl:value-of select="$convergedcallout"/>
            </sup>
          </a>
          <xsl:text>  </xsl:text>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:call-template name="start-flags-and-rev">
        <xsl:with-param name="flagrules" select="$flagrules"/>
      </xsl:call-template>
      <xsl:apply-templates/>
      <xsl:call-template name="end-flags-and-rev">
        <xsl:with-param name="flagrules" select="$flagrules"/>
      </xsl:call-template>
    </p>
  </xsl:template>


  <!-- ========== "FORMAT" MACROS  - Table title, figure title, InfoNavGraphic ========== -->
  <!--
 | These macros support globally-defined formatting constants for
 | document content.  Some elements have attributes that permit local
 | control of formatting; such logic is part of the pertinent template rule.
 +-->


  <!-- table caption -->
  <!-- [SP] 24-Apr-2013: sepub3 specific.  -->
  <xsl:template name="place-tbl-lbl-sepub3">
    <xsl:param name="stringName"/>
    <!-- Number of table/title's before this one -->
    <xsl:variable name="tbl-count-actual"
      select="count(preceding::*[contains(@class,' topic/table ')]/*[contains(@class,' topic/title ')])+1"/>

    <!-- normally: "Table 1. " -->
    <xsl:variable name="ancestorlang">
      <xsl:call-template name="getLowerCaseLang"/>
    </xsl:variable>

    <xsl:choose>
      <!-- title -or- title & desc -->
      <xsl:when test="*[contains(@class,' topic/title ')]">
        <caption>
          <span class="tablecap">
            <!-- [SP] no table numbering for EPUB SSO -->
            <!-- <xsl:choose>     <!-\- Hungarian: "1. Table " -\->
          <xsl:when test="( (string-length($ancestorlang)=5 and contains($ancestorlang,'hu-hu')) or (string-length($ancestorlang)=2 and contains($ancestorlang,'hu')) )">
           <xsl:value-of select="$tbl-count-actual"/><xsl:text>. </xsl:text>
           <xsl:call-template name="getString">
            <xsl:with-param name="stringName" select="'Table'"/>
           </xsl:call-template><xsl:text> </xsl:text>
          </xsl:when>
          <xsl:otherwise>
           <xsl:call-template name="getString">
            <xsl:with-param name="stringName" select="'Table'"/>
           </xsl:call-template><xsl:text> </xsl:text><xsl:value-of select="$tbl-count-actual"/><xsl:text>. </xsl:text>
          </xsl:otherwise>
         </xsl:choose>-->
            <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="tabletitle"/>
          </span>
          <xsl:if test="*[contains(@class,' topic/desc ')]">
            <xsl:text>. </xsl:text>
            <span class="tabledesc">
              <xsl:for-each select="*[contains(@class,' topic/desc ')]">
                <xsl:call-template name="commonattributes"/>
              </xsl:for-each>
              <xsl:apply-templates select="*[contains(@class,' topic/desc ')]" mode="tabledesc"/>
            </span>
          </xsl:if>
        </caption>
      </xsl:when>
      <!-- desc -->
      <xsl:when test="*[contains(@class,' topic/desc ')]">
        <span class="tabledesc">
          <xsl:for-each select="*[contains(@class,' topic/desc ')]">
            <xsl:call-template name="commonattributes"/>
          </xsl:for-each>
          <xsl:apply-templates select="*[contains(@class,' topic/desc ')]" mode="tabledesc"/>
        </span>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]"
    mode="tabletitle">
    <p class="figure_title">
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <!-- Figure caption -->
  <!-- [SP] 24-Apr-2013: Contains sepub3 changes. -->

  <xsl:template match="*" mode="place-fig-lbl.sepub3">
    <xsl:param name="stringName"/>
    <!-- Number of fig/title's including this one -->
    <xsl:variable name="fig-count-actual"
      select="count(preceding::*[contains(@class,' topic/fig ')]/*[contains(@class,' topic/title ')])+1"/>
    <xsl:variable name="ancestorlang">
      <xsl:call-template name="getLowerCaseLang"/>
    </xsl:variable>
    <xsl:choose>
      <!-- title -or- title & desc -->
      <xsl:when test="*[contains(@class,' topic/title ')]">
            <!--<p class="figcap">-->
        <!-- [SP] no figure numbers SSO -->
        <!--<xsl:choose>      <!-\- Hungarian: "1. Figure " -\->
        <xsl:when test="( (string-length($ancestorlang)=5 and contains($ancestorlang,'hu-hu')) or (string-length($ancestorlang)=2 and contains($ancestorlang,'hu')) )">
         <xsl:value-of select="$fig-count-actual"/><xsl:text>. </xsl:text>
         <xsl:call-template name="getString">
          <xsl:with-param name="stringName" select="'Figure'"/>
         </xsl:call-template><xsl:text> </xsl:text>
        </xsl:when>
        <xsl:otherwise>
         <xsl:call-template name="getString">
          <xsl:with-param name="stringName" select="'Figure'"/>
         </xsl:call-template><xsl:text> </xsl:text><xsl:value-of select="$fig-count-actual"/><xsl:text>. </xsl:text>
        </xsl:otherwise>
       </xsl:choose>-->
        <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="figtitle"/>

        <!--</p>-->
        <xsl:if test="*[contains(@class,' topic/desc ')]">
          <xsl:text>. </xsl:text>
          <span class="figdesc">
            <xsl:for-each select="*[contains(@class,' topic/desc ')]">
              <xsl:call-template name="commonattributes"/>
            </xsl:for-each>
            <xsl:apply-templates select="*[contains(@class,' topic/desc ')]" mode="figdesc"/>
          </span>
        </xsl:if>
      </xsl:when>
      <!-- desc -->
      <xsl:when test="*[contains(@class, ' topic/desc ')]">
        <span class="figdesc">
          <xsl:for-each select="*[contains(@class,' topic/desc ')]">
            <xsl:call-template name="commonattributes"/>
          </xsl:for-each>
          <xsl:apply-templates select="*[contains(@class,' topic/desc ')]" mode="figdesc"/>
        </span>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')]"
    mode="figtitle">
    <p class="figure_title">
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <!-- ===================================================================== -->
  <!-- Handling sample content. -->
  <!-- kp-common-d sample and label. -->


  <xsl:template match="*[contains(@class,' kpe-common-d/sample ')]">

    <xsl:apply-templates/>

  </xsl:template>


  <xsl:template match="*[contains(@class,' kpe-common-d/label ')]">
    <p class="example_title">
      <xsl:apply-templates/>
    </p>
  </xsl:template>

  <xsl:template
    match="*[contains(@class,' equation-d/equation-block') and ancestor::*[contains(@class,' kpe-common-d/sample ')]]">
    <p class="example_formula">
      <xsl:apply-templates/>
    </p>

  </xsl:template>


  <!-- ===================================================================== -->

  <!-- ========== STUBS FOR USER PROVIDED OVERRIDE EXTENSIONS ========== -->

  <xsl:template match="/|node()|@*" mode="gen-user-head.sepub3">
    <!-- to customize: copy this to your override transform, add the content you want. -->
    <!-- it will be placed in the HEAD section of the XHTML. -->
  </xsl:template>

  <xsl:template match="/|node()|@*" mode="gen-user-header.sepub3">
    <!-- to customize: copy this to your override transform, add the content you want. -->
    <!-- it will be placed in the running heading section of the XHTML. -->
  </xsl:template>

  <xsl:template match="/|node()|@*" mode="gen-user-footer.sepub3">
    <!-- to customize: copy this to your override transform, add the content you want. -->
    <!-- it will be placed in the running footing section of the XHTML. -->
  </xsl:template>

  <xsl:template name="gen-user-sidetoc">
    <xsl:choose>
      <xsl:when test="$TRANSTYPE='kpe_xhtml'">
        <xsl:apply-templates select="." mode="gen-user-sidetoc-xhtml"/>
      </xsl:when>
      <xsl:when test="$TRANSTYPE='sepub3'">
        <xsl:apply-templates select="." mode="gen-user-sidetoc-sepub3"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/|node()|@*" mode="gen-user-sidetoc-sepub3">
    <!-- to customize: copy this to your override transform, add the content you want. -->
    <!-- Uncomment the line below to have a "freebie" table of contents on the top-right -->
  </xsl:template>

  <!--  <xsl:template name="gen-user-scripts">
    <xsl:choose>
      <xsl:when test="$TRANSTYPE='kpe_xhtml'">
        <xsl:apply-templates select="." mode="gen-user-scripts-xhtml"/>
      </xsl:when>
      <xsl:when test="$TRANSTYPE='sepub3'">
        <xsl:apply-templates select="." mode="gen-user-scripts-sepub3"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>-->

  <xsl:template match="/|node()|@*" mode="gen-user-scripts.sepub3">
    <!-- to customize: copy this to your override transform, add the content you want. -->
    <!-- It will be placed before the ending HEAD tag -->
    <!-- see (or enable) the named template "script-sample" for an example -->
  </xsl:template>

  <xsl:template match="/|node()|@*" mode="gen-user-styles.sepub3">
    <!-- to customize: copy this to your override transform, add the content you want. -->
    <!-- It will be placed before the ending HEAD tag -->

    <!--    <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}css/kpe_main.css"/>
    <xsl:value-of select="$newline"/>-->
    <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}css/kpe_style.css"/>
    <xsl:value-of select="$newline"/>
    <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}css/kpe_epub.css"/>

  </xsl:template>


  <!-- ===================================================================== -->

  <!-- ========== DEFAULT PAGE LAYOUT ========== -->

  <xsl:template match="*" mode="chapter-setup.sepub3">
    <html>
      <!--  xmlns="http://www.w3.org/1999/xhtml" -->
      <!-- [SP] omit xml:lang and lang attributes -->
      <!--<xsl:call-template name="setTopicLanguage"/>-->
      <xsl:value-of select="$newline"/>
      <xsl:call-template name="chapterHead_sepub3"/>
      <xsl:call-template name="chapterBody_sepub3"/>
    </html>
  </xsl:template>

  <xsl:template name="chapterHead_sepub3">
    <head>
      <xsl:value-of select="$newline"/>
      <!-- initial meta information -->
      <xsl:call-template name="generateCharset"/>
      <!-- Set the character set to UTF-8 -->
      <xsl:call-template name="generateDefaultCopyright"/>
      <!-- Generate a default copyright, if needed -->
      <xsl:call-template name="generateDefaultMeta"/>
      <!-- Standard meta for security, robots, etc -->
      <xsl:call-template name="getMeta"/>
      <!-- Process metadata from topic prolog -->
      <xsl:call-template name="copyright"/>
      <!-- Generate copyright, if specified manually -->
      <xsl:call-template name="generateCssLinks"/>
      <!-- Generate links to CSS files -->
      <xsl:call-template name="generateChapterTitle"/>
      <!-- Generate the <title> element -->
      <xsl:call-template name="gen-user-head"/>
      <!-- include user's XSL HEAD processing here -->
      <xsl:call-template name="gen-user-scripts"/>
      <!-- include user's XSL javascripts here -->
      <xsl:call-template name="gen-user-styles"/>
      <!-- include user's XSL style element and content here -->
      <xsl:call-template name="processHDF"/>
      <!-- Add user HDF file, if specified -->
    </head>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <!-- Generate links to CSS files -->
  <!-- [SP] 23-Apr-2013: Leaving this one in for now. -->
  <xsl:template name="generateCssLinks">
    <xsl:variable name="childlang">
      <xsl:choose>
        <!-- Update with DITA 1.2: /dita can have xml:lang -->
        <xsl:when test="self::dita[not(@xml:lang)]">
          <xsl:for-each select="*[1]">
            <xsl:call-template name="getLowerCaseLang"/>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="getLowerCaseLang"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="direction">
      <xsl:apply-templates select="." mode="get-render-direction">
        <xsl:with-param name="lang" select="$childlang"/>
      </xsl:apply-templates>
    </xsl:variable>
    <xsl:variable name="urltest">
      <!-- test for URL -->
      <xsl:call-template name="url-string">
        <xsl:with-param name="urltext">
          <xsl:value-of select="concat($CSSPATH,$CSS)"/>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <!-- [SP] Just say no to default OT stylesheets SSO -->
    <!-- <xsl:choose>
      <xsl:when test="($direction='rtl') and ($urltest='url') ">
        <link rel="stylesheet" type="text/css" href="{$CSSPATH}{$bidi-dita-css}" />
      </xsl:when>
      <xsl:when test="($direction='rtl') and ($urltest='')">
        <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$CSSPATH}{$bidi-dita-css}" />
      </xsl:when>
      <xsl:when test="($urltest='url')">
        <link rel="stylesheet" type="text/css" href="{$CSSPATH}{$dita-css}" />
      </xsl:when>
      <xsl:otherwise>
        <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$CSSPATH}{$dita-css}" />
      </xsl:otherwise>
    </xsl:choose>-->
    <xsl:value-of select="$newline"/>
    <!-- Add user's style sheet if requested to -->
    <xsl:if test="string-length($CSS)>0">
      <xsl:choose>
        <xsl:when test="$urltest='url'">
          <link rel="stylesheet" type="text/css" href="{$CSSPATH}{$CSS}"/>
        </xsl:when>
        <xsl:otherwise>
          <link rel="stylesheet" type="text/css" href="{$PATH2PROJ}{$CSSPATH}{$CSS}"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="$newline"/>
    </xsl:if>

  </xsl:template>

  <xsl:template name="chapterBody_sepub3">
    <xsl:apply-templates select="." mode="chapterBody_sepub3"/>
  </xsl:template>

  <xsl:template match="*" mode="chapterBody_sepub3">
    <xsl:variable name="flagrules">
      <xsl:call-template name="getrules"/>
    </xsl:variable>
    <body>
      <!-- Already put xml:lang on <html>; do not copy to body with commonattributes -->
      <xsl:call-template name="gen-style">
        <xsl:with-param name="flagrules" select="$flagrules"/>
      </xsl:call-template>
      <!--output parent or first "topic" tag's outputclass as class -->
      <xsl:if test="@outputclass">
        <xsl:attribute name="class">
          <xsl:value-of select="@outputclass"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="self::dita">
        <xsl:if test="*[contains(@class,' topic/topic ')][1]/@outputclass">
          <xsl:attribute name="class">
            <xsl:value-of select="*[contains(@class,' topic/topic ')][1]/@outputclass"/>
          </xsl:attribute>
        </xsl:if>
      </xsl:if>
      <xsl:apply-templates select="." mode="addAttributesToBody"/>
      <xsl:call-template name="setidaname"/>
      <xsl:value-of select="$newline"/>
      <xsl:call-template name="start-flags-and-rev">
        <xsl:with-param name="flagrules" select="$flagrules"/>
      </xsl:call-template>
      <xsl:call-template name="generateBreadcrumbs"/>
      <xsl:call-template name="gen-user-header"/>
      <!-- include user's XSL running header here -->
      <xsl:call-template name="processHDR"/>
      <xsl:if test="$INDEXSHOW='yes'">
        <xsl:apply-templates
          select="/*/*[contains(@class,' topic/prolog ')]/*[contains(@class,' topic/metadata ')]/*[contains(@class,' topic/keywords ')]/*[contains(@class,' topic/indexterm ')] |
                                     /dita/*[1]/*[contains(@class,' topic/prolog ')]/*[contains(@class,' topic/metadata ')]/*[contains(@class,' topic/keywords ')]/*[contains(@class,' topic/indexterm ')]"
        />
      </xsl:if>
      <!-- Include a user's XSL call here to generate a toc based on what's a child of topic -->
      <xsl:call-template name="gen-user-sidetoc"/>
      <xsl:apply-templates/>
      <!-- this will include all things within topic; therefore, -->
      <!-- title content will appear here by fall-through -->
      <!-- followed by prolog (but no fall-through is permitted for it) -->
      <!-- followed by body content, again by fall-through in document order -->
      <!-- followed by related links -->
      <!-- followed by child topics by fall-through -->

      <xsl:call-template name="gen-endnotes"/>
      <!-- include footnote-endnotes -->
      <xsl:call-template name="gen-user-footer"/>
      <!-- include user's XSL running footer here -->
      <xsl:call-template name="processFTR"/>
      <!-- Include XHTML footer, if specified -->
      <xsl:call-template name="end-flags-and-rev">
        <xsl:with-param name="flagrules" select="$flagrules"/>
      </xsl:call-template>
    </body>
    <xsl:value-of select="$newline"/>
  </xsl:template>

  <!-- [SP] 23-Apr-2013: Might want to get more specific about why this is necessary. -->
  <xsl:template match="*[contains(@class,' topic/data ')]" mode="data.sepub3"/>




  <!-- L&TC Specializations. -->
  <xsl:template match="*[contains(@class, ' learning2-d/lcAnswerOptionGroup2 ')]">
    <xsl:param name="answer_key"/>
    <ol>
      <xsl:apply-templates>
        <xsl:with-param name="answer_key" select="$answer_key"/>
      </xsl:apply-templates>
    </ol>
  </xsl:template>

  <xsl:template match="*[contains(@class,' learning2-d/lcQuestion2 ')]" priority="100">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="*[contains(@class,' learning2-d/lcAnswerOption2 ')]" priority="100">
    <xsl:param name="answer_key"/>
    
    <xsl:choose>
      <xsl:when test="$answer_key = 'true' and *[contains(@class,' learning2-d/lcCorrectResponse2 ')]">
        <b>
        <li>
          <xsl:choose>
            <xsl:when test="*[' learning2-d/lcAnswerContent2 ']">
              <xsl:attribute name="class">
                <xsl:text>q_distractor</xsl:text>
              </xsl:attribute>
            </xsl:when>
          </xsl:choose>
          <xsl:apply-templates/>
        </li>
        </b>
      </xsl:when>
      <xsl:otherwise>
        <li>
          <xsl:choose>
            <xsl:when test="*[' learning2-d/lcAnswerContent2 ']">
              <xsl:attribute name="class">
                <xsl:text>q_distractor</xsl:text>
              </xsl:attribute>
            </xsl:when>
          </xsl:choose>
          <xsl:apply-templates/>
        </li>
        
      </xsl:otherwise>
    </xsl:choose>
    
  </xsl:template>

  <xsl:template match="*[contains(@class,' learning2-d/lcAnswerContent2 ')]" priority="100">
    <xsl:apply-templates/>
  </xsl:template>
  
  
  <!--PSB 7/31/15 Added lcOpenAnswer2-->
  <xsl:template match="*[contains(@class,' learning2-d/lcFeedbackCorrect2 ')] | *[contains(@class, ' learning2-d/lcOpenAnswer2 ')]" priority="100">
    <xsl:param name="answer_key"/>

      

    <!-- Only apply-templates if we're in an answer key. -->
    <xsl:if test="$answer_key = 'true'">
      <xsl:apply-templates/>
    </xsl:if>
  </xsl:template>
  

  <!--PSB ADDED LOS TITLE-->
  <xsl:template match="*[contains(@class,' topic/title ') and @outputclass='los']">
    <p class="los">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  <!--PSB ADDED b-head TITLE-->
  <xsl:template match="*[contains(@class,' topic/title ') and @outputclass='b_head']">
    <h2>
      <xsl:apply-templates/>
    </h2>
  </xsl:template>
  <!--PSB ADDED c-head TITLE-->
  <xsl:template match="*[contains(@class,' topic/title ') and @outputclass='c_head']">
    <h3>
      <xsl:apply-templates/>
    </h3>
  </xsl:template>
  <!--PSB ADDED d-head TITLE-->
  <xsl:template match="*[contains(@class,' topic/title ') and @outputclass='d_head']">
    <h4>
      <xsl:apply-templates/>
    </h4>
  </xsl:template>
  <!--PSB ADDED KC LOS-->
  <xsl:template match="*[contains(@class,' topic/title ') and @outputclass='kc']">
    <p class="kc_los">
      <xsl:apply-templates/>
    </p>
  </xsl:template><!--PSB ADDED list_unnumber-->
  <xsl:template match="*[contains(@class,' topic/p ') and @outputclass='indent']">
    <p class="list_unnumber">
      <xsl:apply-templates/>
    </p>
  </xsl:template>
  
<!--  PSB added strikethrough-->
  <xsl:template match="*[contains(@class,' topic/ph ') and @outputclass='strike']">
    <span class="strike">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  <xsl:template match="u">
    <span class="underline">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  <xsl:template match="sum">
    <span class="underline">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  <xsl:template match="total">
    <span class="double_underline">
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  
  
</xsl:stylesheet>
