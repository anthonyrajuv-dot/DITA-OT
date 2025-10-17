<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
   xmlns:xs="http://www.w3.org/2001/XMLSchema" 
   xmlns:fo="http://www.w3.org/1999/XSL/Format"
   xmlns:dita2xslfo="http://dita-ot.sourceforge.net/ns/200910/dita2xslfo" 
   xmlns:opentopic="http://www.idiominc.com/opentopic" version="2.0">

   <!--GK100213 Customization for question numbering -->
   <xsl:template match="*[contains(@class, ' learning2-d/lcQuestion2 ')]">
      <!-- [SP] If the paragraph is contained in a table entry or in a note, use much smaller space
                  around it. -->
      <xsl:comment>Handling learning2-d/lcQuestion2.</xsl:comment>
      <fo:block xsl:use-attribute-sets="lcQuestion2" id="{@id}">
         <xsl:call-template name="commonattributes"/>
         <xsl:variable name="item_number" select="count(ancestor::*[contains(@class, ' kpe-question/kpe-question ')][1]/preceding-sibling::*[contains(@class, ' kpe-question/kpe-question ')]) + 1"/>

         <!-- [SP] 2015-01-16: There was a division between courses, final, and qbank on displaying QIDs.
                                  With LMS 3.0, that division has gone away: always display the QIDs.
                                  And show the original DITA file name.
            -->
         <fo:list-block space-after="6pt">
            <fo:list-item>
               <fo:list-item-label end-indent="2in">
                  <fo:block>
                     <xsl:value-of select="concat('QUESTION# ', $item_number)"/>
                  </fo:block>
               </fo:list-item-label>
               <fo:list-item-body start-indent="2in">
                  <!-- [SP] 2018-08-20 sfb: With the addition of the Filename info when KPE.filenames is set, the QID is no longer necessary. -->
                  
<!--                  <!-\- Get ready for question ID stuff. -\->
                  <!-\-                                <xsl:variable name="product_line" select="$map//*[contains(@class,' topic/series ')][1]"/>-\->
                  <!-\- [SP] 2015-01-16: Old QID was the product line and number. Now we want the DITA filename. -\->
                  <!-\- [SP] 2015-03-11: Remove product line from QID title.-\->
                  <xsl:variable name="product_line">
                     <xsl:choose>
                        <xsl:when test="starts-with($OUTPUT_TYPE, 'final_')">
                           <xsl:value-of select="$map/bookmeta[1]/prodinfo[1]/series[1]"/>
                           <xsl:text> </xsl:text>
                        </xsl:when>
                     </xsl:choose>
                  </xsl:variable>
                  <!-\-                        <xsl:variable name="question_id" select="concat($product_line,'_ques_',format-number($item_number,'000000'))"/>
-\->
                  <!-\- Ensure that the slashes run the right way. -\->
                  <xsl:variable name="dita_file" select="replace(translate(@xtrf, '\', '/'), '^.*/([^/]*.dita)$', '$1')"/>

                  <fo:block text-align="right">
                     <!-\-                            <xsl:value-of select="concat('[QID: ',$question_id,']')"/>-\->
                     <!-\-                            <xsl:value-of select="concat('[QID: ',$product_line,$dita_file,']')"/>-\->
                     <xsl:value-of select="concat('[QID: ', $dita_file, ']')"/>
                  </fo:block>
                  <xsl:variable name="legacy_id" select="ancestor-or-self::*[contains(@class, ' kpe-question/kpe-question ')]/descendant::*[contains(@class, ' kpe-commonMeta-d/legacyID ')]/@value"/>
                  <xsl:if test="$legacy_id != ''">
                     <fo:block text-align="right">
                        <xsl:value-of select="concat('[', $legacy_id, ']')"/>
                     </fo:block>
                  </xsl:if>-->
               </fo:list-item-body>
            </fo:list-item>
         </fo:list-block>

         <xsl:apply-templates/>
      </fo:block>
   </xsl:template>
   
   <xsl:template match="*[contains(@class, ' learning2-d/lcAnswerOptionGroup2 ')]/*[contains(@class, ' learning2-d/lcAnswerOption2 ')]">
      <fo:list-item xsl:use-attribute-sets="ol.li">
         <fo:list-item-label xsl:use-attribute-sets="ol.li__label">
            <fo:block xsl:use-attribute-sets="ol.li__label__content">
               <fo:inline>
                  <xsl:call-template name="commonattributes"/>
               </fo:inline>
               <xsl:call-template name="insertVariable">
                  <xsl:with-param name="theVariableID" select="'Ordered List Number'"/>
                  <xsl:with-param name="theParameters">
                     <number>
                        <xsl:number format="A"/>
                     </number>
                  </xsl:with-param>
               </xsl:call-template>
            </fo:block>
         </fo:list-item-label>
         
         <fo:list-item-body xsl:use-attribute-sets="ol.li__body">
            <fo:block xsl:use-attribute-sets="ol.li__content">
               <xsl:apply-templates/>
            </fo:block>
         </fo:list-item-body>
         
      </fo:list-item>
   </xsl:template>
   
   
   
   
   <!-- Options for OUTPUT_TYPE are:
            course
            final_no_answers
            final_with_answers
            final_alt_no_answers
            final_alt_with_answers
            testbank 
    
    -->

   <!--GK100213 Customization for answer choice bold -->
   <xsl:template match="*[contains(@class, ' learning2-d/lcAnswerContent2 ')]">
      <!-- [SP] If the paragraph is contained in a table entry or in a note, use much smaller space
                  around it. -->
      <xsl:comment>Handling learning2-d/lcAnswerContent2.</xsl:comment>
      <fo:block xsl:use-attribute-sets="lcAnswerContent2" id="{@id}">
         <xsl:call-template name="commonattributes"/>
         <xsl:variable name="correct" select="count(../lcCorrectResponse2)"/>
         <xsl:choose>
            <xsl:when test="$correct &gt; 0 and not(contains($OUTPUT_TYPE, 'no_answers'))">
               <xsl:attribute name="font-weight">bold</xsl:attribute>
            </xsl:when>
         </xsl:choose>
         <xsl:apply-templates/>
      </fo:block>

   </xsl:template>
   
   <!-- [SP] Handle inline qualifier formatting. -->
   
   <xsl:template match="*[contains(@class, ' kpe-question-d/qualifier ')]" priority="100">
      <xsl:comment>Handling kpe-question-d/qualifier.</xsl:comment>
      <fo:inline xsl:use-attribute-sets="qualifier" id="{@id}">
         <xsl:call-template name="commonattributes"/>
         <xsl:apply-templates/>
      </fo:inline>
   </xsl:template>
   
   <!-- Hide lcFeedbackCorrect2 when OUTPUT_TYPE includes no_answers. -->
   <xsl:template match="*[contains(@class, ' learning2-d/lcFeedbackCorrect2 ')]">
      
      <xsl:if test="not(contains($OUTPUT_TYPE, 'no_answers'))">
         
         <xsl:apply-imports/>
      </xsl:if>
      
   </xsl:template>
   
   

</xsl:stylesheet>
