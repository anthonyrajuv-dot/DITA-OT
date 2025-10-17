<?xml version='1.0'?>

<!-- 
Copyright © 2004-2006 by Idiom Technologies, Inc. All rights reserved. 
IDIOM is a registered trademark of Idiom Technologies, Inc. and WORLDSERVER
and WORLDSTART are trademarks of Idiom Technologies, Inc. All other 
trademarks are the property of their respective owners. 

IDIOM TECHNOLOGIES, INC. IS DELIVERING THE SOFTWARE "AS IS," WITH 
ABSOLUTELY NO WARRANTIES WHATSOEVER, WHETHER EXPRESS OR IMPLIED,  AND IDIOM
TECHNOLOGIES, INC. DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING
BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
PURPOSE AND WARRANTY OF NON-INFRINGEMENT. IDIOM TECHNOLOGIES, INC. SHALL NOT
BE LIABLE FOR INDIRECT, INCIDENTAL, SPECIAL, COVER, PUNITIVE, EXEMPLARY,
RELIANCE, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF 
ANTICIPATED PROFIT), ARISING FROM ANY CAUSE UNDER OR RELATED TO  OR ARISING 
OUT OF THE USE OF OR INABILITY TO USE THE SOFTWARE, EVEN IF IDIOM
TECHNOLOGIES, INC. HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. 

Idiom Technologies, Inc. and its licensors shall not be liable for any
damages suffered by any person as a result of using and/or modifying the
Software or its derivatives. In no event shall Idiom Technologies, Inc.'s
liability for any damages hereunder exceed the amounts received by Idiom
Technologies, Inc. as a result of this transaction.

These terms and conditions supersede the terms and conditions in any
licensing agreement to the extent that such terms and conditions conflict
with those set forth herein.

This file is part of the DITA Open Toolkit project hosted on Sourceforge.net. 
See the accompanying license.txt file for applicable licenses.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic-i18n="http://www.idiominc.com/opentopic/i18n"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    exclude-result-prefixes="opentopic-index opentopic opentopic-i18n opentopic-func dita-ot xs"
    version="2.0">
    
    <!-- Options for OUTPUT_TYPE are:
            course
            final_no_answers
            final_with_answers
            final_alt_no_answers
            final_alt_with_answers
            testbank 
    
    -->
    
    <xsl:param name="OUTPUT_TYPE" select="'course'"/>
    <xsl:param name="KPE_FILENAMES" select="false()"/>
    <xsl:param name="ANSWER_KEY" select="false()"/>
    <xsl:param name="TESTY_TESTER" select="false()"/>
    
    <!-- [SP] Layout Masters and Metadata processing differs for FOP and AH.  
         Detect the pdfFormatter and use the correct order.
         -->
    <xsl:template match="/" name="rootTemplate">
        
        <xsl:message>OUTPUT_TYPE is <xsl:value-of select="$OUTPUT_TYPE"/>.</xsl:message>
        <xsl:message>KPE_FILENAMES is <xsl:value-of select="$KPE_FILENAMES"/>.</xsl:message>
        <xsl:message>ANSWER_KEY is <xsl:value-of select="$ANSWER_KEY"/>.</xsl:message>
        
        <xsl:call-template name="validateTopicRefs"/>
        
        <fo:root xsl:use-attribute-sets="__fo__root">
            <xsl:comment>pdfFormatter is <xsl:value-of select="$pdfFormatter"/></xsl:comment>
            <xsl:choose>
<!--                <xsl:when test="$pdfFormatter = 'ah'">
                    <xsl:attribute name="xmlns:axf">http://www.antennahouse.com/names/XSL/Extensions</xsl:attribute>
                </xsl:when>-->
                <xsl:when test="$pdfFormatter = 'fop'">
                    <xsl:call-template name="createLayoutMasters"/>
                    <xsl:call-template name="createMetadata"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="createMetadata"/>
                    <xsl:call-template name="createLayoutMasters"/>
                </xsl:otherwise>
            </xsl:choose>
            
<!--            <xsl:if test="not($ANSWER_KEY)">
                <xsl:call-template name="createFrontMatter"/>
            </xsl:if>-->
            
            <xsl:if test="$OUTPUT_TYPE = 'course' and not($ANSWER_KEY)">
                
                <xsl:call-template name="createBookmarks"/>
                
                <xsl:call-template name="createFrontMatter"/>
                
                <xsl:if test="not($retain-bookmap-order)">
                    <xsl:call-template name="createToc"/>
                </xsl:if>
                
            </xsl:if>
            
            <xsl:if test="$OUTPUT_TYPE = 'course_no_questions' and not($ANSWER_KEY)">
                
                <xsl:call-template name="createBookmarks"/>
                
                <xsl:call-template name="createFrontMatter"/>
                
                <xsl:if test="not($retain-bookmap-order)">
                    <xsl:call-template name="createToc"/>
                </xsl:if>
                
            </xsl:if>
            
            
            <xsl:choose>
                <xsl:when test="$ANSWER_KEY">
                    <xsl:call-template name="build-answer-key"/>
                </xsl:when>
                <xsl:when test="$OUTPUT_TYPE = 'course'">
                    <!-- Try to exclude Final Exam chapters...-->
<!--                    <xsl:apply-templates select="/*[contains(@class,' bookmap/bookmap ')]
                        /*[contains(@class,' topic/topic ')]"/>-->
                    <!-- [SP] 2015-03-09: added descendant-or-self because of changed location of assessmentOverview. -->
                    <xsl:apply-templates select="/*[contains(@class,' bookmap/bookmap ')]
                        /*[contains(@class,' topic/topic ') and 
                        not(*[contains(@class,' kpe-assessmentOverview/kpe-assessmentOverview ')] 
                        and descendant-or-self::*[contains(@class,' kpe-commonMeta-d/lmsCategory ') and @value='test_exam_primary'] )]"/>
                    
                </xsl:when>
                <xsl:when test="$OUTPUT_TYPE = 'course_no_questions'">
                    <xsl:apply-templates select="/*[contains(@class,' bookmap/bookmap ')]
                        /*[contains(@class,' topic/topic ') and 
                        not(*[contains(@class,' kpe-assessmentOverview/kpe-assessmentOverview ')] 
                        and descendant-or-self::*[contains(@class,' kpe-commonMeta-d/lmsCategory ') and @value='test_exam_primary'] )]"/>
                </xsl:when>
                
                
                    <xsl:when test="$OUTPUT_TYPE = 'testbank'">
                    <!-- This has to be a special case. Short-circuit the standard topic processing to create the page-sequence. -->
                    <xsl:call-template name="processTestBank">
                        <xsl:with-param name="topics" select="/*[contains(@class,' bookmap/bookmap ')]/
                            descendant::*[contains(@class,' kpe-assessmentOverview/kpe-assessmentOverview ')]"/>
                    </xsl:call-template>
                   
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="/*[contains(@class,' bookmap/bookmap ')]/descendant-or-self::*[contains(@class,' kpe-assessmentOverview/kpe-assessmentOverview ') 
                        and descendant-or-self::*[contains(@class,' kpe-commonMeta-d/lmsCategory ') and @value='test_exam_primary']]"/>
<!--                    <xsl:apply-templates select="/*[contains(@class,' bookmap/bookmap ')]/*[contains(@class,' topic/topic ')]/*[contains(@class,' kpe-assessmentOverview/kpe-assessmentOverview ') 
                        and descendant-or-self::*[contains(@class,' kpe-commonMeta-d/lmsCategory ') and @value='test_exam_primary']]"/>-->
                </xsl:otherwise>
            </xsl:choose>
            
            <xsl:if test="not($retain-bookmap-order) and $OUTPUT_TYPE = 'course' and not($ANSWER_KEY)">
                <xsl:call-template name="createIndex"/>
            </xsl:if>
            
        </fo:root>
    </xsl:template>
    
    
   
    <!-- [SP] Make the bookrestriction type a variable. -->
    <!--      I think this is a relic of spdf(1). probably not necessary. -->
    <xsl:variable name="bookRestriction">
        <xsl:value-of 
            select="/*/opentopic:map//*[contains(@class, ' bookmap/bookmeta ')]/*[contains(@class, ' bookmap/bookrights ')]/*[contains(@class, ' bookmap/bookrestriction ')]/@value"/>
    </xsl:variable>
    
    <xsl:variable name="map" select="//opentopic:map"/>

    <!-- [SP] Modified to include sections. -->
    <xsl:variable name="topicNumbers">
        <xsl:for-each select="//*[(contains(@class, ' topic/topic ') and not(contains(@class, ' bkinfo/bkinfo '))) or contains(@class, ' topic/section ')]">
            <topic id="{@id}" guid="{generate-id()}"/>
        </xsl:for-each>
    </xsl:variable>


	

</xsl:stylesheet>