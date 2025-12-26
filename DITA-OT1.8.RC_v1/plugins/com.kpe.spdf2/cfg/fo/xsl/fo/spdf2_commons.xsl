<?xml version="1.0" encoding="UTF-8"?>
<!-- 
   Scriptorium overrides for fo/xsl/commons.xsl.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:dita2xslfo="http://dita-ot.sourceforge.net/ns/200910/dita2xslfo" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions" xmlns:opentopic="http://www.idiominc.com/opentopic" xmlns:utils="urn:utils" exclude-result-prefixes="xs utils" version="2.0">
    <xsl:import href="../function/resolve-topicprompt.xsl"/>    
    <xsl:param name="OUTPUT_TYPE" select="'course'"/>

    <xsl:output encoding="UTF-8" method="xml"/>


    <xsl:template match="*" mode="commonTopicProcessing">

        <!--        <xsl:if test="$OUTPUT_TYPE = 'course'">
            
            
        </xsl:if>
    
-->
        <xsl:variable name="topicrefShortdesc">
            <xsl:call-template name="getTopicrefShortdesc"/>
        </xsl:variable>
        <!-- [SP] 06-Feb-2013: Create empty id block, based on @xtrf filename. -->
        <xsl:comment>Cross-book link target</xsl:comment>
        <fo:block>
            <xsl:attribute name="id">
                <xsl:call-template name="get_file_id">
                    <xsl:with-param name="source" select="@xtrf"/>
                </xsl:call-template>
            </xsl:attribute>
        </fo:block>

        <xsl:if test="@oid">
            <xsl:comment>sps oid processing.</xsl:comment>
            <fo:block>
                <xsl:attribute name="id">
                    <xsl:value-of select="@oid"/>
                </xsl:attribute>
            </fo:block>
        </xsl:if>
        <!-- [SP] 2015-01-16: For Qbank (testbank), use the navtitle in the map, rather than the title. -->
        <xsl:choose>
            <xsl:when test="contains(@class,' kpe-assessmentOverview/kpe-assessmentOverview ') and $OUTPUT_TYPE = 'testbank'">
                <xsl:variable name="my_id" select="@id"/>
                <xsl:variable name="topicref" select="$map//*[@id = $my_id]"/>

                <!--                <xsl:value-of select="$topicref/@navtitle"/>-->
                <xsl:apply-templates select="$topicref/@navtitle" mode="processTopicTitle"/>

            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="*[contains(@class, ' topic/title ')]"/>
            </xsl:otherwise>
        </xsl:choose>


        <xsl:apply-templates select="*[contains(@class, ' topic/prolog ')]"/>
        <xsl:choose>
            <!-- When topic has an abstract, we cannot override shortdesc -->
            <xsl:when test="*[contains(@class, ' topic/abstract ')]">
                <xsl:apply-templates select="*[not(contains(@class, ' topic/title ')) and
                    not(contains(@class, ' topic/prolog ')) and
                    not(contains(@class, ' topic/shortdesc ')) and
                    not(contains(@class, ' topic/topic '))]"/>
            </xsl:when>
            <xsl:when test="$topicrefShortdesc/*">
                <xsl:apply-templates select="$topicrefShortdesc/*"/>
                <xsl:apply-templates select="*[not(contains(@class, ' topic/title ')) and
                    not(contains(@class, ' topic/prolog ')) and
                    not(contains(@class, ' topic/shortdesc ')) and
                    not(contains(@class, ' topic/topic '))]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="*[not(contains(@class, ' topic/title ')) and
                    not(contains(@class, ' topic/prolog ')) and
                    not(contains(@class, ' topic/topic '))]"/>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:apply-templates select="." mode="buildRelationships"/>
        <xsl:apply-templates select="*[contains(@class,' topic/topic ')]"/>
        <xsl:apply-templates select="." mode="topicEpilog"/>
    </xsl:template>

    <!-- [SP] 06-Feb-2013: Build an ID based on the @xtrf filename. -->
    <xsl:template name="get_file_id">
        <xsl:param name="source"/>
        <xsl:variable name="filename">
            <xsl:call-template name="substring-after-last">
                <xsl:with-param name="string" select="translate($source,'\','/')"/>
                <xsl:with-param name="last" select="'/'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="translate($filename,'.','_')"/>
    </xsl:template>

    <xsl:template name="substring-after-last">
        <xsl:param name="string"/>
        <xsl:param name="last"/>

        <xsl:choose>
            <xsl:when test="contains($string,$last)">
                <xsl:call-template name="substring-after-last">
                    <xsl:with-param name="string" select="substring-after($string,$last)"/>
                    <xsl:with-param name="last" select="$last"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$string"/>
            </xsl:otherwise>
        </xsl:choose>


    </xsl:template>


    <!-- [SP] Override to include topic/section in the id select statement, 
              because this is called from section processing too. -->
    <xsl:template name="getTopicrefShortdesc">
        <xsl:variable name="id" select="ancestor-or-self::*[contains(@class, ' topic/topic ') or contains(@class, ' topic/section ')][1]/@id"/>
        <xsl:variable name="mapTopicref" select="key('map-id', $id)"/>
        <xsl:copy-of select="$mapTopicref/*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' map/shortdesc ')]"/>
    </xsl:template>

    <!-- Bookmap Chapter processing  -->
    <xsl:template name="processTopicChapter">
        <xsl:comment>Starting new chapter...</xsl:comment>
        <!-- [SP] Build chapter number so it can be used in heading. -->
        <xsl:variable name="id" select="@id"/>
        <xsl:variable name="mapTopicref" select="$map//*[@id = $id]"/>
        <xsl:variable name="topicChapters">
            <xsl:copy-of select="$map//*[contains(@class, ' bookmap/chapter ')]"/>
        </xsl:variable>

        <xsl:variable name="chapterNumber">
            <xsl:number format="1" value="count($topicChapters/*[@id = $id]/preceding-sibling::*) + 1"/>
        </xsl:variable>
        <xsl:variable name="title" select="$mapTopicref/*[contains(@class,' map/topicmeta ')][1]/*[contains(@class,' topic/navtitle ')][1]/text()"/>
        <fo:page-sequence master-reference="body-sequence" xsl:use-attribute-sets="__force__page__count">
            <xsl:call-template name="startPageNumbering"/>
            <xsl:call-template name="insertBodyStaticContents"/>
            <fo:flow flow-name="xsl-region-body">
                <fo:block xsl:use-attribute-sets="topic">
                    <xsl:call-template name="commonattributes"/>

                    <!-- This test does not work if there's a part containing the topic. -->
                    <!--<xsl:if test="not(ancestor::*[contains(@class, ' topic/topic ')])">-->
                    <fo:marker marker-class-name="current-topic-number">
                        <!-- Scriptorium placed chapter number in current-topic-number for rendering the chapter 
                                number in the header, if it is desired.
                                <xsl:number format="1"/>-->
                        <xsl:value-of select="$chapterNumber"/>
                    </fo:marker>
                    <fo:marker marker-class-name="current-header">
                        <xsl:value-of select="$title"/>
                        <!--<xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                            <xsl:apply-templates select="." mode="getTitle"/>
                        </xsl:for-each>-->
                    </fo:marker>
                    <!--</xsl:if>-->

                    <xsl:apply-templates select="*[contains(@class,' topic/prolog ')]"/>
                    <!-- [SP] No need for chapter static content in generic spdf2 format. -->
                    <!--				    <xsl:call-template name="insertChapterFirstpageStaticContent">
						<xsl:with-param name="type" select="'chapter'"/>
					</xsl:call-template>
-->
                    <fo:block xsl:use-attribute-sets="topic.title">
                        <!-- added by William on 2009-07-02 for indexterm bug:2815485 start-->
                        <xsl:call-template name="pullPrologIndexTerms"/>
                        <!-- added by William on 2009-07-02 for indexterm bug:2815485 end-->

                        <fo:block>
                            <!-- [SP] Add chapter name and number. -->

                            <xsl:choose>
                                <xsl:when test="contains($title,'Exam') or contains($title,'Quiz')">
                                    <!--do nothing-->
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:call-template name="insertChapterLabel">
                                        <xsl:with-param name="type" select="'chapter'"/>
                                    </xsl:call-template>
                                </xsl:otherwise>
                            </xsl:choose>

                            <!-- TODO: this puts the chapter number and title on separate lines.
                                   Double check the output fo to see if it can be made more efficient.-->
                            <!--<xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                                <xsl:apply-templates select="." mode="getTitle"/>
                            </xsl:for-each>-->
                            <xsl:value-of select="$title"/>
                        </fo:block>
                    </fo:block>

                    <xsl:choose>
                        <xsl:when test="$chapterLayout='BASIC'">
                            <xsl:apply-templates select="*[not(contains(@class, ' topic/topic ') or contains(@class, ' topic/title ') or
                                                                                                                contains(@class, ' topic/prolog '))]"/>
                            <xsl:apply-templates select="." mode="buildRelationships"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="." mode="createMiniToc"/>
                        </xsl:otherwise>
                    </xsl:choose>

                    <xsl:comment>Done with mini-toc, now starting the rest of the topics...</xsl:comment>
                    <xsl:apply-templates select="*[contains(@class,' topic/topic ')]"/>
                </fo:block>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>

    <!--  Bookmap Appendix processing  -->
    <xsl:template name="processTopicAppendix">
        <!-- [SP] Build chapter number so it can be used in heading. -->
        <xsl:variable name="id" select="@id"/>
        <xsl:variable name="topicChapters">
            <xsl:copy-of select="$map//*[contains(@class, ' bookmap/chapter ')]"/>
        </xsl:variable>
        <xsl:variable name="chapterNumber">
            <xsl:number format="1" value="count($topicChapters/*[@id = $id]/preceding-sibling::*) + 1"/>
        </xsl:variable>

        <fo:page-sequence master-reference="body-sequence" xsl:use-attribute-sets="__force__page__count">
            <xsl:call-template name="startPageNumbering"/>
            <xsl:call-template name="insertBodyStaticContents"/>
            <fo:flow flow-name="xsl-region-body">
                <fo:block xsl:use-attribute-sets="topic">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:if test="not(ancestor::*[contains(@class, ' topic/topic ')])">
                        <fo:marker marker-class-name="current-topic-number">
                            <!-- Scriptorium placed chapter number in current-topic-number for rendering the chapter 
                                number in the header, if it is desired.
                                <xsl:number format="1"/>-->
                            <xsl:value-of select="$chapterNumber"/>
                        </fo:marker>
                        <fo:marker marker-class-name="current-header">
                            <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                                <xsl:apply-templates select="." mode="getTitle"/>
                            </xsl:for-each>
                        </fo:marker>
                    </xsl:if>

                    <xsl:apply-templates select="*[contains(@class,' topic/prolog ')]"/>
                    <!-- [SP] No need for chapter static content in generic spdf2 format. -->
                    <!-- <xsl:call-template name="insertChapterFirstpageStaticContent">
						<xsl:with-param name="type" select="'chapter'"/>
					</xsl:call-template>
-->
                    <fo:block xsl:use-attribute-sets="topic.title">
                        <!-- added by William on 2009-07-02 for indexterm bug:2815485 start-->
                        <xsl:call-template name="pullPrologIndexTerms"/>
                        <!-- added by William on 2009-07-02 for indexterm bug:2815485 end-->

                        <fo:block>
                            <!-- [SP] Add chapter name and number. -->
                            <xsl:call-template name="insertChapterLabel">
                                <xsl:with-param name="type" select="'appendix'"/>
                            </xsl:call-template>
                            <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                                <xsl:apply-templates select="." mode="getTitle"/>
                                <!-- xxxxx -->
                            </xsl:for-each>
                        </fo:block>
                    </fo:block>

                    <xsl:choose>
                        <xsl:when test="$chapterLayout='BASIC'">
                            <xsl:apply-templates select="*[not(contains(@class, ' topic/topic ') or contains(@class, ' topic/title ') or
                                contains(@class, ' topic/prolog '))]"/>
                            <xsl:apply-templates select="." mode="buildRelationships"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="." mode="createMiniToc"/>
                        </xsl:otherwise>
                    </xsl:choose>

                    <xsl:apply-templates select="*[contains(@class,' topic/topic ')]"/>
                </fo:block>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>

    <!--  Bookmap Part processing  -->
    <xsl:template name="processTopicPart">
        <!-- [SP] Build chapter number so it can be used in heading. -->
        <xsl:variable name="id" select="@id"/>
        <xsl:variable name="topicParts">
            <xsl:copy-of select="$map//*[contains(@class, ' bookmap/part ')]"/>
        </xsl:variable>
        <xsl:variable name="partNumber">
            <xsl:number format="I" value="count($topicParts/*[@id = $id]/preceding-sibling::*) + 1"/>
        </xsl:variable>

        <fo:page-sequence master-reference="body-sequence" xsl:use-attribute-sets="__force__page__count">
            <xsl:call-template name="startPageNumbering"/>
            <xsl:call-template name="insertBodyStaticContents"/>
            <fo:flow flow-name="xsl-region-body">
                <fo:block xsl:use-attribute-sets="topic">
                    <xsl:call-template name="commonattributes"/>

                    <!-- Don't need markers for parts. -->
                    <xsl:if test="not(ancestor::*[contains(@class, ' topic/topic ')])">
                        <fo:marker marker-class-name="current-part-number">
                            <!-- Scriptorium placed part number in current-topic-number for rendering the part 
                                number in the header, if it is desired.
                                <xsl:number format="1"/>-->
                            <xsl:value-of select="$partNumber"/>
                        </fo:marker>
                        <fo:marker marker-class-name="current-part-header">
                            <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                                <xsl:apply-templates select="." mode="getTitle"/>
                            </xsl:for-each>
                        </fo:marker>
                    </xsl:if>

                    <!-- [SP] Add a part image, if there is one in part/topicmeta/data/image. -->
                    <xsl:variable name="part_image" select="$topicParts/*[@id = $id]/topicmeta/data/image"/>
                    <xsl:variable name="part_image_href" select="$part_image/@href"/>
                    <xsl:if test="$part_image_href != ''">
                        <xsl:variable name="part_image_path" select="concat($input.dir.url,$part_image_href)"/>
                        <xsl:comment>part_image path is: <xsl:value-of select="$part_image_path"/>.</xsl:comment>
                        <xsl:variable name="image_width">
                            <xsl:choose>
                                <xsl:when test="$part_image/@width and $part_image/@width != ''">
                                    <xsl:value-of select="$part_image/@width"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:text>300px</xsl:text>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <fo:block text-align="center">
                            <fo:external-graphic src="url({$part_image_path})" xsl:use-attribute-sets="image" content-width="{$image_width}"/>
                        </fo:block>
                    </xsl:if>



                    <xsl:apply-templates select="*[contains(@class,' topic/prolog ')]"/>
                    <!-- [SP] No need for part static content in generic spdf2 format. -->
                    <!--				    <xsl:call-template name="insertChapterFirstpageStaticContent">
						<xsl:with-param name="type" select="'part'"/>
					</xsl:call-template>
-->
                    <fo:block xsl:use-attribute-sets="part.title">
                        <!-- added by William on 2009-07-02 for indexterm bug:2815485 start-->
                        <xsl:call-template name="pullPrologIndexTerms"/>
                        <!-- added by William on 2009-07-02 for indexterm bug:2815485 end-->

                        <!-- [SP] Add chapter name and number. -->
                        <fo:block>
                            <xsl:call-template name="insertChapterLabel">
                                <xsl:with-param name="type" select="'part'"/>
                            </xsl:call-template>

                            <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                                <xsl:apply-templates select="." mode="getTitle"/>
                            </xsl:for-each>
                        </fo:block>

                    </fo:block>

                    <fo:block page-break-before="always">
                        <xsl:choose>
                            <xsl:when test="$chapterLayout='BASIC'">
                                <xsl:apply-templates select="*[not(contains(@class, ' topic/topic ') or contains(@class, ' topic/title ') or
                                contains(@class, ' topic/prolog '))]"/>
                                <xsl:apply-templates select="." mode="buildRelationships"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="." mode="createMiniToc"/>
                            </xsl:otherwise>
                        </xsl:choose>

                        <!--                    <xsl:apply-templates select="*[not(contains(@class, ' topic/topic '))]"/>-->

                        <xsl:for-each select="*[contains(@class,' topic/topic ')]">
                            <xsl:variable name="topicType">
                                <xsl:call-template name="determineTopicType"/>
                            </xsl:variable>
                            <xsl:if test="$topicType = 'topicSimple'">
                                <xsl:apply-templates select="."/>
                            </xsl:if>
                        </xsl:for-each>
                    </fo:block>
                </fo:block>
            </fo:flow>
        </fo:page-sequence>
        <xsl:for-each select="*[contains(@class,' topic/topic ')]">
            <xsl:variable name="topicType">
                <xsl:call-template name="determineTopicType"/>
            </xsl:variable>
            <xsl:if test="not($topicType = 'topicSimple')">
                <xsl:apply-templates select="."/>
            </xsl:if>
        </xsl:for-each>

    </xsl:template>

    <!-- [SP] Handle Colophon topic. -->
    <!--    <xsl:template name="processTopicColophon">
        <fo:page-sequence master-reference="body-sequence" format="1" xsl:use-attribute-sets="__force__page__count">
            <!-\-            <xsl:call-template name="insertColophonStaticContents"/>-\->
            <xsl:call-template name="insertBodyStaticContents"/>
            <fo:flow flow-name="xsl-region-body">
                <xsl:call-template name="commonattributes"/>
                <fo:block xsl:use-attribute-sets="topic">
                    <xsl:if test="not(ancestor::*[contains(@class, ' topic/topic ')])">
                        <fo:marker marker-class-name="current-topic-number">
                            <xsl:number format="1"/>
                        </fo:marker>
                        <fo:marker marker-class-name="current-header">
                            <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                                <xsl:apply-templates select="." mode="getTitle"/>
                            </xsl:for-each>
                        </fo:marker>
                    </xsl:if>

                    <xsl:apply-templates select="*[contains(@class,' topic/prolog ')]"/>

                    <xsl:call-template name="insertChapterFirstpageStaticContent">
                        <xsl:with-param name="type" select="'preface'"/>
                    </xsl:call-template>

                    <fo:block xsl:use-attribute-sets="topic.title">
                        <xsl:call-template name="pullPrologIndexTerms"/>
                        <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                            <xsl:apply-templates select="." mode="getTitle"/>
                        </xsl:for-each>
                    </fo:block>

                    <!-\-<xsl:call-template name="createMiniToc"/>-\->

                    <xsl:apply-templates select="*[not(contains(@class,' topic/title '))]"/>
                </fo:block>
            </fo:flow>
        </fo:page-sequence>

    </xsl:template>
-->
    <!-- [SP] Handle Final Exam topic. -->
    <xsl:template name="processTopicFinalExam">
        <fo:page-sequence master-reference="final-exam-sequence" format="1" xsl:use-attribute-sets="__force__page__count">
            <!--            <xsl:call-template name="insertColophonStaticContents"/>-->
            <xsl:call-template name="insertBodyStaticContents"/>
            <fo:flow flow-name="xsl-region-body">
                <xsl:call-template name="commonattributes"/>
                <fo:block xsl:use-attribute-sets="topic">
                    <xsl:if test="not(ancestor::*[contains(@class, ' topic/topic ')])">
                        <fo:marker marker-class-name="current-topic-number">
                            <xsl:number format="1"/>
                        </fo:marker>
                        <fo:marker marker-class-name="current-header">
                            <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                                <xsl:apply-templates select="." mode="getTitle"/>
                            </xsl:for-each>
                        </fo:marker>
                    </xsl:if>

                    <!--                    <xsl:apply-templates select="*[contains(@class,' topic/prolog ')]"/>
-->
                    <!--                    <xsl:call-template name="insertChapterFirstpageStaticContent">
                        <xsl:with-param name="type" select="'preface'"/>
                    </xsl:call-template>
-->
                    <!-- TODO: Insert first page content for final exams. -->

                    <fo:block xsl:use-attribute-sets="final.exam.partno">
                        <xsl:value-of select="$map/*[contains(@class,' bookmap/bookmeta ')]
                            /*[contains(@class,' bookmap/bookid ')]
                            /*[contains(@class,' bookmap/bookpartno ')]"/>

                    </fo:block>

                    <fo:block xsl:use-attribute-sets="final.exam.title" text-align="left">
                        <xsl:call-template name="pullPrologIndexTerms"/>
                        <xsl:choose>
                            <xsl:when test="contains($OUTPUT_TYPE,'final_alt')">
                                <xsl:value-of select="$map//*[contains(@class,' bookmap/booktitlealt ')][1]"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                                    <xsl:apply-templates select="." mode="getTitle"/>
                                </xsl:for-each>

                            </xsl:otherwise>
                        </xsl:choose>
                        <!-- [SP] 2015-03-11: Add product line to title-->
                        <xsl:variable name="product_line">
                            <xsl:choose>
                                <xsl:when test="starts-with($OUTPUT_TYPE,'final_')">
                                    <xsl:value-of select="$map/bookmeta[1]/prodinfo[1]/series[1]"/>
                                    <xsl:text> </xsl:text>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:if test="$product_line != ''">
                            <xsl:value-of select="concat(': ',$product_line)"/>
                        </xsl:if>
                    </fo:block>

                    <!--<xsl:call-template name="createMiniToc"/>-->

                    <xsl:apply-templates select="*[not(contains(@class,' topic/title '))]"/>
                </fo:block>
            </fo:flow>
        </fo:page-sequence>

    </xsl:template>
	
	
	

    <!-- [SP] Handle Final Exam topic. -->
    <xsl:template name="processTestBank">
        <xsl:param name="topics"/>

        <fo:page-sequence master-reference="final-exam-sequence" format="1" xsl:use-attribute-sets="__force__page__count">
            <!--            <xsl:call-template name="insertColophonStaticContents"/>-->
            <xsl:call-template name="insertBodyStaticContents"/>
            <fo:flow flow-name="xsl-region-body">
                <xsl:call-template name="commonattributes"/>
                <fo:block xsl:use-attribute-sets="topic">
                    <xsl:if test="not(ancestor::*[contains(@class, ' topic/topic ')])">
                        <fo:marker marker-class-name="current-topic-number">
                            <xsl:number format="1"/>
                        </fo:marker>
                        <fo:marker marker-class-name="current-header">
                            <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                                <xsl:apply-templates select="." mode="getTitle"/>
                            </xsl:for-each>
                        </fo:marker>
                    </xsl:if>

                    <fo:block xsl:use-attribute-sets="final.exam.title" text-align="left">
                        <xsl:call-template name="pullPrologIndexTerms"/>
                        <xsl:text>Testbank:  </xsl:text>
                        <xsl:value-of select="$map/*[contains(@class,' bookmap/bookmeta ')]
                            /*[contains(@class,' bookmap/bookid ')]
                            /*[contains(@class,' bookmap/bookpartno ')]"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$map/*[contains(@class,' bookmap/booktitle ')]
                            /*[contains(@class,' bookmap/mainbooktitle ')]"/>
                        <xsl:text> </xsl:text>
                        <xsl:variable name="edition" select="$map/*[contains(@class,' bookmap/bookmeta ')]
                            /*[contains(@class,' bookmap/bookid ')]
                            /*[contains(@class,' bookmap/edition ')]"/>
                        <xsl:choose>
                            <xsl:when test="$edition != ''">
                                <xsl:value-of select="concat('v',format-number($edition,'##.0'))"/>
                            </xsl:when>
                            <xsl:otherwise/>
                        </xsl:choose>



                        <!-- TODO: Get the remaining title information. -->
                        <!--                            <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                                <xsl:apply-templates select="." mode="getTitle"/>
                            </xsl:for-each>-->
                    </fo:block>

                    <!--<xsl:call-template name="createMiniToc"/>-->

                    <xsl:apply-templates select="$topics"/>
                </fo:block>
            </fo:flow>
        </fo:page-sequence>

    </xsl:template>

    <!-- [SP] Handle section, inserting page break, if outputclass="page". -->
    <xsl:template match="*[contains(@class,' topic/section ')]">
        <fo:block xsl:use-attribute-sets="section">
            <xsl:call-template name="commonattributes"/>
            <!-- [SP] Handle page breaking (shhhhh). -->
            <xsl:if test="@outputclass='pagebreak'">
                <xsl:attribute name="page-break-before">page</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="." mode="dita2xslfo:section-heading"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <!-- [SP] Handle section titles.   
            Blown away by how little the basic implementation of topic/title does (just uses 
            the attribute set "section.title") without accounting for where in the topic hierarchy
            this might occur.
            Re-implemented to mirror commons.xsl processing of topic titles.
        -->
    <xsl:template match="*[contains(@class,' topic/section ')]/*[contains(@class,' topic/title ')]">
        <xsl:apply-templates select="." mode="processSectionTitle"/>
    </xsl:template>

    <xsl:template match="*" mode="processSectionTitle">

        <xsl:variable name="level" as="xs:integer">
            <xsl:apply-templates select="." mode="get-topic-level"/>
        </xsl:variable>
        <!--        <xsl:message>Just called get-topic-level.  level is <xsl:value-of select="$level"/>.</xsl:message>
        <xsl:message>title is <xsl:apply-templates select="." mode="getTitle"/>.</xsl:message>
-->

        <!--        <xsl:comment>Level is: <xsl:value-of select="$level"/>.</xsl:comment>-->
        <!--        Added call to createTopicAttrsName to mirror topic title hierarchy.-->
        <xsl:variable name="attrSet1">
            <xsl:apply-templates select="." mode="createTopicAttrsName">
                <!-- But, of course, it can't be at the SAME level as the count of topics;
                     it has to be the next level down (in the hierarchy). -->
                <xsl:with-param name="theCounter" select="$level + 1"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="attrSet1A" select="concat(substring-before($attrSet1,'.topic.title'),'.section.title')"/>
        <xsl:comment>attrSet1A is: <xsl:value-of select="$attrSet1A"/>.</xsl:comment>
        <xsl:variable name="attrSet2" select="concat($attrSet1, '__content')"/>
        <xsl:comment>attrSet2 is: <xsl:value-of select="$attrSet2"/>.</xsl:comment>        

        <fo:block>
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="processAttrSetReflection">
                <xsl:with-param name="attrSet" select="$attrSet1A"/>
                <xsl:with-param name="path" select="'../../cfg/fo/attrs/spdf2_commons-attr.xsl'"/>
            </xsl:call-template>

            <fo:block>
                <xsl:call-template name="processAttrSetReflection">
                    <xsl:with-param name="attrSet" select="$attrSet2"/>
                    <xsl:with-param name="path" select="'../../cfg/fo/attrs/commons-attr.xsl'"/>
                </xsl:call-template>
                <!-- For sections there is no level 1. -->
                <xsl:if test="$level = 2">
                    <fo:marker marker-class-name="current-h2">                    	
                        <xsl:apply-templates select="." mode="getTitle"/>
                    </fo:marker>
                </xsl:if>

                <!-- This one must exist, because of bad xrefs in large docs. -->
                <fo:inline id="{parent::node()/@id}"/>

                <fo:inline>
                    <xsl:attribute name="id">
                        <xsl:call-template name="generate-toc-id">
                            <!-- Change from double-dot, because that would cause duplicate ids. -->
                            <xsl:with-param name="element" select="."/>
                        </xsl:call-template>
                    </xsl:attribute>
                </fo:inline>
                <!-- added by William on 2009-07-02 for indexterm bug:2815485 start-->
                <xsl:call-template name="pullPrologIndexTerms"/>
                <!-- added by William on 2009-07-02 for indexterm bug:2815485 end-->                
            	<xsl:apply-templates select="." mode="getTitle"/>
            </fo:block>
        </fo:block>
    </xsl:template>

    <!-- [SP] Modify level calculation to handle parts and sections (and maps vs. bookmaps). -->
    <xsl:template match="*" mode="get-topic-level" as="xs:integer" priority="10">

        <xsl:variable name="bookmap_correction" as="xs:integer">
            <xsl:choose>
                <xsl:when test="contains($map/@class,' bookmap/bookmap ')">
                    <xsl:value-of select="'0'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'1'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- If the title is a child of section, the id will not be reliable.
              Need to find the the id of the containing topic. -->
        <xsl:variable name="in_section" select="contains(parent::*/@class,' topic/section ')"/>

        <xsl:variable name="overview_correction" as="xs:integer">
            <xsl:choose>
                <xsl:when test="contains(parent::*/@class,' kpe-overview/kpe-overview ')">
                    <xsl:value-of select="'-1'"/>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:value-of select="'0'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!--        <xsl:variable name="nested_concept_correction" as="xs:integer">
            <xsl:choose>
                <xsl:when test="contains(@class,' topic/topic concept/concept kpe-concept/kpe-concept ')">
                    <xsl:value-of select="'-2'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'0'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>-->


        <!-- when in the toc, we're dealing with topics; when in topics, we're dealing with title. -->
        <xsl:variable name="id">
            <xsl:choose>

                <xsl:when test="$in_section">
                    <xsl:value-of select="ancestor::*[contains(@class,' topic/topic ')][1]/@id"/>
                </xsl:when>
                <xsl:when test="contains(@class,' topic/title ')">
                    <xsl:value-of select="parent::*/@id"/>
                </xsl:when>
                <!-- <xsl:when test="contains(@class,' topic/navtitle ')">
                    <xsl:value-of select="ancestor::topicref/@id"/>
                </xsl:when>-->
                <xsl:otherwise>
                    <xsl:value-of select="@id"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!--<xsl:message>In get-topic-level.  $in_section is <xsl:value-of select="$in_section"/>.</xsl:message>
-->
        <xsl:variable name="initial_count" as="xs:integer">
            <xsl:value-of select="count(ancestor-or-self::*[contains(@class,' topic/topic ')])"/>
        </xsl:variable>

        <!-- If this the current section is contained in a part, counts need to be reduced by one.-->
        <xsl:variable name="part_correction" as="xs:integer">
            <xsl:choose>
                <xsl:when test="$map//*[@id = $id]/ancestor::*[contains(@class,' bookmap/part ')]">
                    <xsl:value-of select="'-1'"/>
                </xsl:when>
                <!-- [SP] Shoe-horning in topicref nesting correction...
                      If current section is contained in a task, counts need to be reduced by one. -->
                <!--<xsl:when test="$map//*[@id = $id]/ancestor::*[@type='kpe-task']">
                    <xsl:value-of select="'-1'"/>
                </xsl:when>-->
                <!-- xxxxx -->
                <!--<xsl:when test="$map//*[contains(@class,' topic/section ')]/preceding-sibling::*[@class,' topic/p ']">
                    <xsl:value-of select="'-1'"/>
                </xsl:when>-->
                <xsl:otherwise>
                    <xsl:value-of select="'0'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!-- Add together the count, plus all the corrections, and return the value. -->
        <xsl:choose>
            <xsl:when test="($initial_count + $part_correction + $bookmap_correction + $overview_correction) &gt; 4">
                <xsl:value-of select="$initial_count + $part_correction + $bookmap_correction + $overview_correction - 1"/>
            </xsl:when>
            <!--<xsl:when test="($initial_count + $part_correction + $bookmap_correction + $overview_correction) &gt; 6">
                <xsl:value-of select="4"/>
            </xsl:when>-->
            <xsl:otherwise>
                <xsl:value-of select="$initial_count + $part_correction + $bookmap_correction + $overview_correction"/>
            </xsl:otherwise>
        </xsl:choose>
        <!--<xsl:value-of select="$initial_count + $part_correction + $bookmap_correction + $overview_correction"/>-->

    </xsl:template>

    <!-- [SP] Generate chapter label all on one line.  
        Derived from insertChapterFirstpageStaticContent. -->
    <xsl:template name="insertChapterLabel">
        <xsl:param name="type"/>
        <xsl:attribute name="id">
            <xsl:call-template name="generate-toc-id"/>
        </xsl:attribute>
        <xsl:choose>
            <xsl:when test="$type = 'chapter'">
                <fo:inline xsl:use-attribute-sets="__chapter__frontmatter__name__inline">
                    <!--<xsl:call-template name="insertVariable">
                        <xsl:with-param name="theVariableID" select="'Chapter with number'"/>-->
                    <!-- xxxxx -->
                    <!--<xsl:with-param name="theParameters">
                            <number>
                                <!-\- [SP] removed the separate block for the chapter number to keep it on the same line. -\->
                                <fo:inline
                                    xsl:use-attribute-sets="__chapter__frontmatter__number__inline">
                                    <xsl:apply-templates select="key('map-id', @id)[1]"
                                        mode="topicTitleNumber"/>
                                </fo:inline>
                            </number>
                        </xsl:with-param>-->
                    <!--</xsl:call-template>-->
                </fo:inline>
            </xsl:when>
            <xsl:when test="$type = 'appendix'">
                <fo:inline xsl:use-attribute-sets="__chapter__frontmatter__name__inline">
                    <!--<xsl:call-template name="insertVariable">
                        <xsl:with-param name="theVariableID" select="'Appendix with number'"/>-->
                    <!-- xxxxx -->
                    <!--<xsl:with-param name="theParameters">
                            <number>
                                <fo:inline
                                    xsl:use-attribute-sets="__chapter__frontmatter__number__inline">
                                    <xsl:apply-templates select="key('map-id', @id)[1]"
                                        mode="topicTitleNumber"/>
                                </fo:inline>
                            </number>
                        </xsl:with-param>-->
                    <!--</xsl:call-template>-->
                </fo:inline>
            </xsl:when>

            <xsl:when test="$type = 'part'">
                <fo:block text-align="center" xsl:use-attribute-sets="__part__frontmatter__name__inline">
                    <!--<xsl:call-template name="insertVariable">
                        <xsl:with-param name="theVariableID" select="'Part with number'"/>-->
                    <!-- xxxxx -->
                    <!--<xsl:with-param name="theParameters">
                            <number>
                                <fo:inline
                                    xsl:use-attribute-sets="__chapter__frontmatter__number__inline">
                                    <xsl:apply-templates select="key('map-id', @id)[1]"
                                        mode="topicTitleNumber"/>
                                </fo:inline>
                            </number>
                        </xsl:with-param>-->
                    <!--</xsl:call-template>-->
                </fo:block>
            </xsl:when>
            <xsl:when test="$type = 'preface'">
                <!--                    <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__inline">
                        <xsl:call-template name="insertVariable">
                            <xsl:with-param name="theVariableID" select="'Preface title'"/>
                        </xsl:call-template>
                    </fo:block>-->
            </xsl:when>
            <xsl:when test="$type = 'notices'">
                <fo:inline xsl:use-attribute-sets="__chapter__frontmatter__name__inline">
                    <xsl:call-template name="insertVariable">
                        <xsl:with-param name="theVariableID" select="'Notices title'"/>
                    </xsl:call-template>
                </fo:inline>
            </xsl:when>
        </xsl:choose>

    </xsl:template>


    <xsl:template name="insertChapterFirstpageStaticContent">
        <xsl:param name="type"/>
        <fo:block>
            <xsl:attribute name="id">
                <xsl:call-template name="generate-toc-id"/>
            </xsl:attribute>
            <xsl:choose>
                <xsl:when test="$type = 'chapter'">
                    <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
                        <xsl:call-template name="insertVariable">
                            <xsl:with-param name="theVariableID" select="'Chapter with number'"/>
                            <xsl:with-param name="theParameters">
                                <number>
                                    <!-- [SP] removed the separate block for the chapter number to keep it on the same line. -->
                                    <fo:block xsl:use-attribute-sets="__chapter__frontmatter__number__container">
                                        <xsl:apply-templates select="key('map-id', @id)[1]" mode="topicTitleNumber"/>
                                    </fo:block>
                                </number>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </xsl:when>
                <xsl:when test="$type = 'appendix'">
                    <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
                        <xsl:call-template name="insertVariable">
                            <xsl:with-param name="theVariableID" select="'Appendix with number'"/>
                            <xsl:with-param name="theParameters">
                                <number>
                                    <fo:block xsl:use-attribute-sets="__chapter__frontmatter__number__container">
                                        <xsl:apply-templates select="key('map-id', @id)[1]" mode="topicTitleNumber"/>
                                    </fo:block>
                                </number>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </xsl:when>

                <xsl:when test="$type = 'part'">
                    <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
                        <xsl:call-template name="insertVariable">
                            <xsl:with-param name="theVariableID" select="'Part with number'"/>
                            <xsl:with-param name="theParameters">
                                <number>
                                    <fo:block xsl:use-attribute-sets="__chapter__frontmatter__number__container">
                                        <xsl:apply-templates select="key('map-id', @id)[1]" mode="topicTitleNumber"/>
                                    </fo:block>
                                </number>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </xsl:when>
                <xsl:when test="$type = 'preface'">
                    <!--                    <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
                        <xsl:call-template name="insertVariable">
                            <xsl:with-param name="theVariableID" select="'Preface title'"/>
                        </xsl:call-template>
                    </fo:block>-->
                </xsl:when>
                <xsl:when test="$type = 'notices'">
                    <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
                        <xsl:call-template name="insertVariable">
                            <xsl:with-param name="theVariableID" select="'Notices title'"/>
                        </xsl:call-template>
                    </fo:block>
                </xsl:when>
            </xsl:choose>
        </fo:block>
    </xsl:template>

    <!-- RDA: From RFE 2882109, combining this rule with existing rules for
              concept, task, reference later in this file to reduce duplicated
              code. Continue calling the named process* templates in order to
              ensure backwards compatibility; ideally though, a single template would
              be called for all types, deferring the override decision to match rules. -->
    <!-- [SP] Override topic/topic processing to eliminate trademarklist from output. -->
    <xsl:template match="*[contains(@class, ' topic/topic ')]">
        <xsl:variable name="topicType">
            <xsl:call-template name="determineTopicType"/>
        </xsl:variable>

        <xsl:variable name="exam_type">
            <xsl:choose>
                <xsl:when test="descendant-or-self::*[contains(@class,' kpe-commonMeta-d/lmsCategory ') and @value='test_exam_primary']">
                    <xsl:text>test_exam_primary</xsl:text>
                </xsl:when>
            	<!-- ARV: Added on 24/07/2025 -->
            	<xsl:when test="descendant-or-self::*[contains(@class,' kpe-commonMeta-d/lmsCategory ') and @value='test_exam_secondary']">
                    <xsl:text>test_exam_secondary</xsl:text>
                </xsl:when>
                <xsl:when test="descendant-or-self::*[contains(@class,' kpe-commonMeta-d/lmsCategory ') and @value!='test_exam_primary']">
                    <xsl:value-of select="descendant-or-self::*[contains(@class,' kpe-commonMeta-d/lmsCategory ')]/@value"/>
                </xsl:when>
                <!--                <xsl:when test="descendant-or-self::*[@name='AssessmentType' and @value='test-exam-primary']">
                   <xsl:text>test-exam-primary</xsl:text>
                </xsl:when>
                <xsl:when test="descendant-or-self::*[@name='AssessmentType' and @value!='test-exam-primary']">
                    <xsl:value-of select="descendant-or-self::*[@name='AssessmentType']/@value"/>
                </xsl:when>-->
                <xsl:otherwise>
                    <!-- Nothing. -->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:comment>topicType is <xsl:value-of select="$topicType"/>.</xsl:comment>
        <xsl:comment>exam_type is <xsl:value-of select="$exam_type"/>.</xsl:comment>

        <xsl:choose>
            <!--            <xsl:when test="$exam_type = 'test-exam-primary' and $OUTPUT_TYPE = 'course'">
                <!-\- Ignore it. -\->
            </xsl:when>
-->

            <!-- [SP] ignore all exams for course_no_questions output -->
            <!--<xsl:when test="$exam_type = 'test-exam-primary' and $OUTPUT_TYPE = 'course_no_questions'">
                <!-\- Ignore it. -\->
            </xsl:when>
            <xsl:when test="$exam_type = 'test-exam-secondary' and $OUTPUT_TYPE = 'course_no_questions'">
                <!-\- Ignore it. -\->
            </xsl:when>
            <xsl:when test="$exam_type = 'test-quiz' and $OUTPUT_TYPE = 'course_no_questions'">
                <!-\- Ignore it. -\->
            </xsl:when>-->
            <!-- [SP] end ignore -->



            <xsl:when test="$exam_type = 'test_exam_primary' and contains($OUTPUT_TYPE,'final_')">
                <xsl:call-template name="processTopicFinalExam"/>
            </xsl:when>
        	

            <!-- [SP]: Don't display the trademarklist, it's already handled in frontmatter. -->
            <xsl:when test="$topicType = 'topicTradeMarkList'">
                <xsl:message>Ignoring trademark list.</xsl:message>
            </xsl:when>

            <xsl:when test="$topicType = 'topicChapter' and $OUTPUT_TYPE = 'testbank'">
                <xsl:comment>Handling chapter.</xsl:comment>
                <xsl:choose>
                    <xsl:when test="contains(@class,' concept/concept ')">
                        <xsl:apply-templates select="." mode="processConcept"/>
                    </xsl:when>
                    <xsl:when test="contains(@class,' task/task ')">
                        <xsl:apply-templates select="." mode="processTask"/>
                    </xsl:when>
                    <xsl:when test="contains(@class,' reference/reference ')">
                        <xsl:apply-templates select="." mode="processReference"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="." mode="processTopic"/>
                        <!-- Comes back to commonTopicProcessing. -->
                    </xsl:otherwise>
                </xsl:choose>

                <!--                <xsl:call-template name="processTopicChapter"/>-->
            </xsl:when>
            <xsl:when test="$topicType = 'topicChapter'">
                <xsl:call-template name="processTopicChapter"/>
            </xsl:when>
            <xsl:when test="$topicType = 'topicAppendix'">
                <xsl:call-template name="processTopicAppendix"/>
            </xsl:when>
            <xsl:when test="$topicType = 'topicPart'">
                <xsl:call-template name="processTopicPart"/>
            </xsl:when>
            <xsl:when test="$topicType = 'topicPreface'">
                <xsl:call-template name="processTopicPreface"/>
            </xsl:when>
            <!--            <xsl:when test="$topicType = 'topicColophon'">
                <xsl:call-template name="processTopicColophon"/>
            </xsl:when>-->
            <xsl:when test="$topicType = 'topicNotices'">
                <xsl:if test="$retain-bookmap-order">
                    <xsl:call-template name="processTopicNotices"/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="$topicType = 'topicSimple'">
                <xsl:variable name="page-sequence-reference">
                    <xsl:choose>
                        <xsl:when test="$mapType = 'bookmap'">
                            <xsl:value-of select="'body-sequence'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'ditamap-body-sequence'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="not(ancestor::*[contains(@class,' topic/topic ')])">
                        <fo:page-sequence master-reference="{$page-sequence-reference}" xsl:use-attribute-sets="__force__page__count">
                            <xsl:call-template name="insertBodyStaticContents"/>
                            <fo:flow flow-name="xsl-region-body">
                                <xsl:choose>
                                    <xsl:when test="contains(@class,' concept/concept ')">
                                        <xsl:apply-templates select="." mode="processConcept"/>
                                    </xsl:when>
                                    <xsl:when test="contains(@class,' task/task ')">
                                        <xsl:apply-templates select="." mode="processTask"/>
                                    </xsl:when>
                                    <xsl:when test="contains(@class,' reference/reference ')">
                                        <xsl:apply-templates select="." mode="processReference"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates select="." mode="processTopic"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:flow>
                        </fo:page-sequence>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <!-- [SP] omit questions -->
                            <xsl:when test="contains(@class,' kpe-assessmentOverview/kpe-assessmentOverview ') and $OUTPUT_TYPE = 'course_no_questions'">
                                <!-- do nothing -->
                            </xsl:when>
                            <!-- [ARV: 11/12/2025] omit Rationale -->
                        	<xsl:when test="contains(@class,' learning2-d/lcFeedbackCorrect2 ') and $OUTPUT_TYPE = 'course_no_answers'">
                                <!-- do nothing -->
                            </xsl:when>

                            <xsl:when test="contains(@class,' concept/concept ')">
                                <xsl:apply-templates select="." mode="processConcept"/>
                            </xsl:when>
                            <xsl:when test="contains(@class,' task/task ')">
                                <xsl:apply-templates select="." mode="processTask"/>
                            </xsl:when>
                            <xsl:when test="contains(@class,' reference/reference ')">
                                <xsl:apply-templates select="." mode="processReference"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="." mode="processTopic"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <!--[SP] skip abstract (copyright) from usual content. It will be processed from the front-matter-->
            <xsl:when test="$topicType = 'topicAbstract'"/>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="processUnknowTopic">
                    <xsl:with-param name="topicType" select="$topicType"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Override basic chapter numbering, because parts screw up the calculation. -->
    <!-- |
        opentopic:map/*[contains(@class, ' map/topicref ')]"-->

    <xsl:template match="*[contains(@class, ' bookmap/chapter ')]" mode="topicTitleNumber" priority="-1">
        <!-- Can't use the number template, because it only allows "down" axes. -->
        <!--        <xsl:number format="1" count="*[contains(@class, ' bookmap/chapter ')]"/>-->
        <xsl:variable name="quiz_count" select="count(preceding::*[contains(@class, ' bookmap/chapter ')]
            [contains(*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]/text(),'Quiz')])"/>
        <xsl:variable name="exam_count" select="count(preceding::*[contains(@class, ' bookmap/chapter ')]
            [contains(*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]/text(),'Exam')])"/>
        <xsl:value-of select="count(preceding::*[contains(@class, ' bookmap/chapter ')]) + 1 - $quiz_count - $exam_count"/>
    </xsl:template>

    <xsl:template match="*[contains(@class,' map/shortdesc ')]">
        <xsl:if test="$show-shortdesc='yes'">
            <xsl:apply-templates select="." mode="format-shortdesc-as-block"/>
        </xsl:if>
    </xsl:template>

    <!-- For SF Bug 2879171: modify so that shortdesc is inline when inside
         abstract with only other text or inline markup. -->
    <xsl:template match="*[contains(@class,' topic/shortdesc ')]">
        <xsl:variable name="format-as-block">
            <xsl:choose>
                <xsl:when test="not(parent::*[contains(@class,' topic/abstract ')])">yes</xsl:when>
                <xsl:when test="preceding-sibling::*[contains(@class,' topic/p ') or contains(@class,' topic/dl ') or
                    contains(@class,' topic/fig ') or contains(@class,' topic/lines ') or
                    contains(@class,' topic/lq ') or contains(@class,' topic/note ') or
                    contains(@class,' topic/ol ') or contains(@class,' topic/pre ') or
                    contains(@class,' topic/simpletable ') or contains(@class,' topic/sl ') or
                    contains(@class,' topic/table ') or contains(@class,' topic/ul ')]">yes</xsl:when>
                <xsl:when test="following-sibling::*[contains(@class,' topic/p ') or contains(@class,' topic/dl ') or
                    contains(@class,' topic/fig ') or contains(@class,' topic/lines ') or
                    contains(@class,' topic/lq ') or contains(@class,' topic/note ') or
                    contains(@class,' topic/ol ') or contains(@class,' topic/pre ') or
                    contains(@class,' topic/simpletable ') or contains(@class,' topic/sl ') or
                    contains(@class,' topic/table ') or contains(@class,' topic/ul ')]">yes</xsl:when>
                <xsl:otherwise>no</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:if test="$show-shortdesc='yes'">
            <xsl:choose>
                <xsl:when test="$format-as-block='yes'">
                    <xsl:apply-templates select="." mode="format-shortdesc-as-block"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="." mode="format-shortdesc-as-inline"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

    </xsl:template>

    <!-- [SP] If topic contains online media, display filename. -->

    <xsl:template match="*[contains(@class, ' topic/object ')]">
        <xsl:comment>Handling topic/object.</xsl:comment>
        <fo:block xsl:use-attribute-sets="p.object" id="{@id}">
            <xsl:call-template name="commonattributes"/>
            <xsl:text>[Interactive Event: </xsl:text>
            <xsl:value-of select="tokenize(@codetype, '/')[last()]"/>
            <xsl:text>]</xsl:text>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <!-- [SP] Wrap lcObjectivesStem in paragraph block. -->

    <xsl:template match="*[contains(@class, ' learningBase/lcObjectivesStem ')]">
        <xsl:comment>Creating lcObjectivesStem block.</xsl:comment>
        <fo:block xsl:use-attribute-sets="p" id="{@id}">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <!-- [SP] modify topic/p handling to deal with table entries and notes. -->
    <xsl:template match="*[contains(@class, ' topic/p ')]">
        <!-- [SP] If the paragraph is contained in a table entry or in a note, use much smaller space
                  around it. -->
        <xsl:comment>Handling topic/p.</xsl:comment>
        <xsl:choose>
            <!-- The source attribute on <p> allows for nice formatting of source attribution
                 info after <lq> elements. Automatically inserts em-dash before source. -->
            <xsl:when test="@outputclass = 'source'">
                <fo:block xsl:use-attribute-sets="p.source" id="{@id}">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:text>&#x2012;</xsl:text>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>
            <xsl:when test="parent::*[contains(@class,' topic/lq ')]">
                <fo:block xsl:use-attribute-sets="lq" id="{@id}">
                    <xsl:call-template name="commonattributes"/>
                    <!-- Make first lq paragraph bind to preceding block. -->
                    <xsl:choose>
                        <xsl:when test="following-sibling::*[contains(@class, ' topic/lq ')] 
                            or preceding-sibling::*[contains(@class, ' topic/lq ')]">
                            <!-- Don't add anything. -->
                        </xsl:when>
                        <xsl:when test="count(preceding-sibling::*[contains(@class, ' topic/p ')]) = 0">
                            <xsl:attribute name="keep-with-previous.within-page">always</xsl:attribute>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>
            <xsl:when test="parent::*[contains(@class,' topic/entry ')]">
                <fo:block xsl:use-attribute-sets="table-p" id="{@id}">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>
            <!-- [SP] Admonition text is in-line with the first paragraph, so
                      must detect first <p> in <note>. -->
            <xsl:when test="parent::*[contains(@class,' topic/note ')] and count(preceding-sibling::*[contains(@class,' topic/p ')]) = 0">
                <fo:block xsl:use-attribute-sets="note-p" id="{@id}">
                    <xsl:call-template name="commonattributes"/>
                			<xsl:call-template name="placeNoteLabel"/>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>
            <!-- any other paragraph under a note. -->
            <xsl:when test="parent::*[contains(@class,' topic/note ')]">
                <fo:block xsl:use-attribute-sets="note-p" id="{@id}">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:block xsl:use-attribute-sets="p" id="{@id}">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- [SP] Changed order of note processing, so that the note block is emitted, then it's up to the
         topic/p template to insert the admonition label as an inline. -->
    <xsl:template match="*[contains(@class,' topic/note ')]">
        <xsl:variable name="noteType">
            <xsl:choose>
                <xsl:when test="@type = 'other' and @othertype">
                    <xsl:value-of select="@othertype"/>
                </xsl:when>
                <xsl:when test="@type">
                    <xsl:value-of select="@type"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'note'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="noteImagePath">
            <xsl:call-template name="insertVariable">
                <xsl:with-param name="theVariableID" select="concat($noteType, ' Note Image Path')"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not($noteImagePath = '')">
                <fo:table xsl:use-attribute-sets="note__table">
                    <fo:table-column xsl:use-attribute-sets="note__image__column"/>
                    <fo:table-column xsl:use-attribute-sets="note__text__column"/>
                    <fo:table-body>
                        <fo:table-row>
                            <fo:table-cell xsl:use-attribute-sets="note__image__entry">
                                <fo:block>
                                    <fo:external-graphic src="url({concat($artworkPrefix, $noteImagePath)})" content-width="65%" xsl:use-attribute-sets="image"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="note__text__entry">
                                <!-- [SP] Emit the note block, then handle the contents of the note. -->
                                <fo:block xsl:use-attribute-sets="note">
                                    <xsl:call-template name="commonattributes"/>
                                    <!-- [SP] Throw up your hands for pseudo-mixed content. -->
                                    <xsl:choose>
                                        <xsl:when test="child::*[1][contains(@class,' topic/p ')]">
                                            <xsl:apply-templates/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <!-- [SP] There is no p that's a child of the note, so do it for the user. -->
                                            <fo:block xsl:use-attribute-sets="note-p" id="{@id}">
                                                <xsl:call-template name="commonattributes"/>
                                                <xsl:call-template name="placeNoteLabel"/>
                                                <xsl:apply-templates/>
                                            </fo:block>

                                        </xsl:otherwise>
                                    </xsl:choose>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </xsl:when>
            <xsl:otherwise>
                <!-- [SP] Emit the note block, then handle the contents of the note. -->
                <fo:block xsl:use-attribute-sets="note">
                    <xsl:call-template name="commonattributes"/>
                    <!-- [SP] Throw up your hands for pseudo-mixed content. -->
                    <xsl:choose>
                        <xsl:when test="child::*[1][contains(@class,' topic/p ')]">
                            <xsl:apply-templates/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- [SP] There is no p that's a child of the note, so do it for the user. -->
                            <fo:block xsl:use-attribute-sets="note-p" id="{@id}">
                                <xsl:call-template name="commonattributes"/>
                                <xsl:call-template name="placeNoteLabel"/>
                                <xsl:apply-templates/>
                            </fo:block>

                        </xsl:otherwise>
                    </xsl:choose>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- [SP] Derived from template with mode="placeNoteContent". -->
    <xsl:template name="placeNoteLabel">

        <fo:inline xsl:use-attribute-sets="note__label">
            <xsl:choose>
                <xsl:when test="@type='note' or not(@type)">
                    <fo:inline xsl:use-attribute-sets="note__label__note">
                        <xsl:call-template name="insertVariable">
                            <xsl:with-param name="theVariableID" select="'Note'"/>
                        </xsl:call-template>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@type='notice'">
                    <fo:inline xsl:use-attribute-sets="note__label__notice">
                        <xsl:call-template name="insertVariable">
                            <xsl:with-param name="theVariableID" select="'Notice'"/>
                        </xsl:call-template>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@type='tip'">
                    <fo:inline xsl:use-attribute-sets="note__label__tip">
                        <xsl:call-template name="insertVariable">
                            <xsl:with-param name="theVariableID" select="'Tip'"/>
                        </xsl:call-template>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@type='fastpath'">
                    <fo:inline xsl:use-attribute-sets="note__label__fastpath">
                        <xsl:call-template name="insertVariable">
                            <xsl:with-param name="theVariableID" select="'Fastpath'"/>
                        </xsl:call-template>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@type='restriction'">
                    <fo:inline xsl:use-attribute-sets="note__label__restriction">
                        <xsl:call-template name="insertVariable">
                            <xsl:with-param name="theVariableID" select="'Restriction'"/>
                        </xsl:call-template>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@type='important'">
                    <fo:inline xsl:use-attribute-sets="note__label__important">
                        <xsl:call-template name="insertVariable">
                            <xsl:with-param name="theVariableID" select="'Important'"/>
                        </xsl:call-template>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@type='remember'">
                    <fo:inline xsl:use-attribute-sets="note__label__remember">
                        <xsl:call-template name="insertVariable">
                            <xsl:with-param name="theVariableID" select="'Remember'"/>
                        </xsl:call-template>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@type='attention'">
                    <fo:inline xsl:use-attribute-sets="note__label__attention">
                        <xsl:call-template name="insertVariable">
                            <xsl:with-param name="theVariableID" select="'Attention'"/>
                        </xsl:call-template>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@type='caution'">
                    <fo:inline xsl:use-attribute-sets="note__label__caution">
                        <xsl:call-template name="insertVariable">
                            <xsl:with-param name="theVariableID" select="'Caution'"/>
                        </xsl:call-template>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@type='danger'">
                    <fo:inline xsl:use-attribute-sets="note__label__danger">
                        <xsl:call-template name="insertVariable">
                            <xsl:with-param name="theVariableID" select="'Danger'"/>
                        </xsl:call-template>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@type='warning'">
                    <fo:inline xsl:use-attribute-sets="note__label__danger">
                        <xsl:call-template name="insertVariable">
                            <xsl:with-param name="theVariableID" select="'Warning'"/>
                        </xsl:call-template>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@type='other'">
                    <fo:inline xsl:use-attribute-sets="note__label__other">
                        <xsl:choose>
                            <xsl:when test="@othertype">
                                <xsl:value-of select="@othertype"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>[</xsl:text>
                                <xsl:value-of select="@type"/>
                                <xsl:text>]</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:inline>
                </xsl:when>
            </xsl:choose>
        	<fo:inline>: </fo:inline>
        </fo:inline>
    </xsl:template>
	
	<!-- [ARV: 25-12-2025] Added to make label bold -->
	<!--<xsl:template match="*[contains(@class, ' topic/note ')]/label">
		<fo:inline font-weight="bold">
			<xsl:apply-templates/>
		</fo:inline>
	</xsl:template>-->

    <!-- [SP] Make figure title appear at the top of figures, rather than after. -->
    <xsl:template match="*[contains(@class,' topic/fig ')]">
        <fo:block xsl:use-attribute-sets="fig">
            <xsl:call-template name="commonattributes"/>
            <xsl:if test="not(@id)">
                <xsl:attribute name="id">
                    <xsl:call-template name="get-id"/>
                </xsl:attribute>
            </xsl:if>
            <!-- Reverse title and figure order. -->
            <xsl:apply-templates select="*[contains(@class,' topic/title ')]"/>
            <xsl:apply-templates select="*[not(contains(@class,' topic/title '))]"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/lq ')]">
        <fo:block>
            <xsl:call-template name="commonattributes"/>
            <xsl:choose>
                <xsl:when test="@href or @reftitle">
                    <xsl:call-template name="processAttrSetReflection">
                        <xsl:with-param name="attrSet" select="'lq'"/>
                        <xsl:with-param name="path" select="'../../cfg/fo/attrs/commons-attr.xsl'"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="processAttrSetReflection">
                        <xsl:with-param name="attrSet" select="'lq_simple'"/>
                        <xsl:with-param name="path" select="'../../cfg/fo/attrs/commons-attr.xsl'"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
            <!-- Force lq to stay with previous. -->
            <!-- Should probably modify the attribute sets...um don't know why not. -->
            <xsl:attribute name="keep-with-previous.within-page">always</xsl:attribute>

            <xsl:apply-templates/>
        </fo:block>
        <xsl:choose>
            <xsl:when test="@href">
                <fo:block xsl:use-attribute-sets="lq_link">
                    <fo:basic-link>
                        <xsl:call-template name="buildBasicLinkDestination">
                            <xsl:with-param name="scope" select="@scope"/>
                            <xsl:with-param name="href" select="@href"/>
                        </xsl:call-template>

                        <xsl:choose>
                            <xsl:when test="@reftitle">
                                <xsl:value-of select="@reftitle"/>
                            </xsl:when>
                            <xsl:when test="not(@type = 'external' or @format = 'html')">
                                <xsl:apply-templates select="." mode="insertReferenceTitle">
                                    <xsl:with-param name="href" select="@href"/>
                                    <xsl:with-param name="titlePrefix" select="''"/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@href"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:basic-link>
                </fo:block>
            </xsl:when>
            <xsl:when test="@reftitle">
                <fo:block xsl:use-attribute-sets="lq_title">
                    <xsl:value-of select="@reftitle"/>
                </fo:block>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <!-- [SP] overriding topic/image to handle Kaplan outputclass. -->
    <xsl:template match="*[contains(@class,' topic/image ')]">
        <!-- PSB 9/3/15 EDITED TO ALLOW FOR IMAGE PROCESSING        -->
        <xsl:if test="@outputclass='digital'"/>
        <!-- build any pre break indicated by style -->
        <xsl:choose>
            <xsl:when test="parent::fig">
                <!-- NOP if there is already a break implied by a parent property -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="not(@placement='inline')">
                    <!-- generate an FO break here -->
                    <fo:block>&#160;</fo:block>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:choose>
            <xsl:when test="not(@placement = 'inline')">
                <!--                <fo:float xsl:use-attribute-sets="image__float">-->
                <fo:block xsl:use-attribute-sets="image__block">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates select="." mode="placeImage">
                        <xsl:with-param name="imageAlign" select="@align"/>
                        <xsl:with-param name="href" select="if (@scope = 'external') then @href else concat($input.dir.url, @href)"/>
                        <xsl:with-param name="height" select="@height"/>
                        <xsl:with-param name="width" select="@width"/>
                    </xsl:apply-templates>
                </fo:block>
                <!--                </fo:float>-->
            </xsl:when>
            <xsl:otherwise>
                <fo:inline xsl:use-attribute-sets="image__inline">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates select="." mode="placeImage">
                        <xsl:with-param name="imageAlign" select="@align"/>
                        <xsl:with-param name="href" select="if (@scope = 'external') then @href else concat($input.dir.url, @href)"/>
                        <xsl:with-param name="height" select="@height"/>
                        <xsl:with-param name="width" select="@width"/>
                    </xsl:apply-templates>
                </fo:inline>
            </xsl:otherwise>
        </xsl:choose>

        <!-- build any post break indicated by style -->
        <xsl:choose>
            <xsl:when test="parent::fig">
                <!-- NOP if there is already a break implied by a parent property -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="not(@placement='inline')">
                    <!-- generate an FO break here -->
                    <fo:block>&#160;</fo:block>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        <!--</xsl:if>-->
    </xsl:template>

    <!-- [SP] Eliminate OT warnings by providing a default image alignment value if none is provided. -->
    <xsl:template match="*" mode="placeImage">
        <!-- Add default value for align, so we can test that it wasn't specified. -->
        <xsl:param name="imageAlign" select="'#none#'"/>
        <xsl:param name="href"/>
        <xsl:param name="height"/>
        <xsl:param name="width"/>

        <!-- Test image alignment. -->
        <xsl:variable name="imageAlignTested">
            <xsl:choose>
                <!-- Trickier than expected to pick up a non-specified value. -->
                <!-- If not specified, use the $image-align value from spdf2_BasicSettings.xsl. -->
                <xsl:when test="$imageAlign = '#none#' or normalize-space($imageAlign)=''">
                    <xsl:value-of select="$image-align"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$imageAlign"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!--Using align attribute set according to image @align attribute-->
        <xsl:call-template name="processAttrSetReflection">
            <!-- [SP] Using tested image align value. -->
            <xsl:with-param name="attrSet" select="concat('__align__', $imageAlignTested)"/>
            <xsl:with-param name="path" select="'../../cfg/fo/attrs/commons-attr.xsl'"/>
        </xsl:call-template>
        <fo:external-graphic src="url({$href})" xsl:use-attribute-sets="image">
            <!--Setting image height if defined-->
            <xsl:if test="$height">
                <xsl:attribute name="content-height">
                    <!--The following test was commented out because most people found the behavior
                 surprising.  It used to force images with a number specified for the dimensions
                 *but no units* to act as a measure of pixels, *if* you were printing at 72 DPI.
                 Uncomment if you really want it. -->
                    <xsl:choose>
                        <!--xsl:when test="not(string(number($height)) = 'NaN')">
                        <xsl:value-of select="concat($height div 72,'in')"/>
                      </xsl:when-->
                        <xsl:when test="not(string(number($height)) = 'NaN')">
                            <xsl:value-of select="concat($height, 'px')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$height"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:if>
            <!--Setting image width if defined-->
            <xsl:if test="$width">
                <xsl:attribute name="content-width">
                    <xsl:choose>
                        <!--xsl:when test="not(string(number($width)) = 'NaN')">
                        <xsl:value-of select="concat($width div 72,'in')"/>
                      </xsl:when-->
                        <xsl:when test="not(string(number($width)) = 'NaN')">
                            <xsl:value-of select="concat($width, 'px')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$width"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="not($width) and not($height) and @scale">
                <xsl:attribute name="content-width">
                    <xsl:value-of select="concat(@scale,'%')"/>
                </xsl:attribute>
            </xsl:if>
        </fo:external-graphic>
    </xsl:template>

    <!--GK100213 Customization for question numbering -->
    <xsl:template match="*[contains(@class, ' learning2-d/lcQuestion2 ')]">
        <!-- [SP] If the paragraph is contained in a table entry or in a note, use much smaller space
                  around it. -->
        <xsl:comment>Handling learning2-d/lcQuestion2.</xsl:comment>
        <fo:block xsl:use-attribute-sets="lcQuestion2" id="{@id}">
            <xsl:call-template name="commonattributes"/>
            <xsl:variable name="item_number" select="count(ancestor::*[contains(@class, ' kpe-question/kpe-question ')][1]/preceding-sibling::*[contains(@class, ' kpe-question/kpe-question ')])+1"/>

            <!-- [SP] 2015-01-16: There was a division between courses, final, and qbank on displaying QIDs.
                                  With LMS 3.0, that division has gone away: always display the QIDs.
                                  And show the original DITA file name.
            -->
            <fo:list-block space-after="6pt">
                <fo:list-item>
                    <fo:list-item-label end-indent="2in">
                        <fo:block>
                            <xsl:value-of select="concat('QUESTION# ',$item_number)"/>
                        </fo:block>
                    </fo:list-item-label>
                    <fo:list-item-body start-indent="2in">
                        <!-- Get ready for question ID stuff. -->
                        <!--                                <xsl:variable name="product_line" select="$map//*[contains(@class,' topic/series ')][1]"/>-->
                        <!-- [SP] 2015-01-16: Old QID was the product line and number. Now we want the DITA filename. -->
                        <!-- [SP] 2015-03-11: Remove product line from QID title.-->
                        <xsl:variable name="product_line">
                            <xsl:choose>
                                <xsl:when test="starts-with($OUTPUT_TYPE,'final_')">
                                    <xsl:value-of select="$map/bookmeta[1]/prodinfo[1]/series[1]"/>
                                    <xsl:text> </xsl:text>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:variable>
                        <!--                        <xsl:variable name="question_id" select="concat($product_line,'_ques_',format-number($item_number,'000000'))"/>
-->
                        <!-- Ensure that the slashes run the right way. -->
                        <xsl:variable name="dita_file" select="replace(translate(@xtrf,'\','/'),'^.*/([^/]*.dita)$','$1')"/>

                        <fo:block text-align="right">
                            <!--                            <xsl:value-of select="concat('[QID: ',$question_id,']')"/>-->
                            <!--                            <xsl:value-of select="concat('[QID: ',$product_line,$dita_file,']')"/>-->
                            <xsl:value-of select="concat('[QID: ',$dita_file,']')"/>
                        </fo:block>
                        <xsl:variable name="legacy_id" select="ancestor-or-self::*[contains(@class,' kpe-question/kpe-question ')]/descendant::*[contains(@class,' kpe-commonMeta-d/legacyID ')]/@value"/>
                        <xsl:if test="$legacy_id != ''">
                            <fo:block text-align="right">
                                <xsl:value-of select="concat('[',$legacy_id,']')"/>
                            </fo:block>
                        </xsl:if>
                    </fo:list-item-body>
                </fo:list-item>
            </fo:list-block>

            <!-- (old course/no course decision stuff, remove eventually. ) -->
            <!--            <xsl:choose>   
                <xsl:when test="$OUTPUT_TYPE = 'course'">
                    <!-\- Output the question number and move on to the content of the question. -\->
                    <xsl:number value="$item_number" 
                        format="1"/>
                    <xsl:text>. </xsl:text> 
                </xsl:when>
                <xsl:otherwise>
                    <fo:list-block space-after="6pt">
                        <fo:list-item>
                            <fo:list-item-label end-indent="3in">
                                <fo:block>
                                    <xsl:value-of select="concat('QUESTION# ',$item_number)"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="3in">
                                <!-\- Get ready for question ID stuff. -\->
<!-\-                                <xsl:variable name="product_line" select="$map//*[contains(@class,' topic/series ')][1]"/>-\->
                                <xsl:variable name="product_line" select="$map/bookmeta[1]/prodinfo[1]/series[1]"/>
                                <xsl:variable name="question_id" select="concat($product_line,'_ques_',format-number($item_number,'000000'))"/>
                                <fo:block text-align="right">
                                    <xsl:value-of select="concat('[QID: ',$question_id,']')"/>
                                </fo:block>
                                <xsl:variable name="legacy_id" 
                                    select="ancestor::*[contains(@class,' kpe-question/kpe-question ')]/descendant::*[contains(@class,' kpe-commonMeta-d/legacyID ')]/@value"/>

                                <fo:block text-align="right">
                                    <xsl:value-of select="concat('[',$legacy_id,']')"/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </fo:list-block>
                    
                </xsl:otherwise>
                
            </xsl:choose>-->
        	
        	
        	
        	<xsl:comment>[Custom-DEBUG] Checking for prompts inside .job.xml</xsl:comment>
        	<xsl:message>[Custom-DEBUG] Checking for prompts inside .job.xml</xsl:message>
        	
        	<xsl:variable name="thisFile" select="replace(translate(@xtrf, '\\', '/'), '^.*/', '')"/>
        	
        	<xsl:message>thisFile: <xsl:value-of select="$thisFile"/></xsl:message>
        	
        	
        	<xsl:variable name="allTopicrefs" select="utils:get-all-topicrefs($map)"/>
        	<xsl:variable name="myTopicref"
        		select="$allTopicrefs[contains(@ohref, $thisFile) or contains(@href, $thisFile)][1]"/>
        	<xsl:message>myTopicref: <xsl:value-of select="$myTopicref/@href"/></xsl:message>
        	
        	<xsl:variable name="originalMapPath"
        		select="concat('file:/', translate($myTopicref/@xtrf, '\\', '/'))"/>
        	<xsl:message>originalMapPath: <xsl:value-of select="$originalMapPath"/></xsl:message>
        	
        	<xsl:variable name="originalMap" select="document($originalMapPath)"/>
        	
        	<xsl:variable name="originalRef"
        		select="$originalMap//topicref[ends-with(@href, $thisFile)]"/>
        	<xsl:message>originalRef: <xsl:value-of select="$originalRef/@href"/></xsl:message>
        	
        	<xsl:variable name="promptKey"
        		select="$originalRef/*[local-name()='topicprompt']/@keyref"/>
        	<xsl:message>promptKey: <xsl:value-of select="$promptKey"/></xsl:message>
        	
        	
        	<xsl:choose>
        		<xsl:when test="$promptKey != ''">
        			<!-- Step 1: Resolve .job.xml using safe base -->
        			<xsl:variable name="job-uri" select="resolve-uri('.job.xml', base-uri(/))"/>
        			
        			
        			<xsl:comment>Prompts exist!!</xsl:comment>
        			<xsl:message>job-uri resolved: <xsl:value-of select="$job-uri"/></xsl:message>
        			
        			<xsl:variable name="jobFile" as="document-node()?">
        				<xsl:choose>
        					<xsl:when test="unparsed-text-available($job-uri)">
        						<xsl:sequence select="document($job-uri)"/>
        					</xsl:when>
        					<xsl:otherwise>
        						<xsl:message>[WARNING] .job.xml not found or unreadable at:
        							<xsl:value-of select="$job-uri"/></xsl:message>
        					</xsl:otherwise>
        				</xsl:choose>
        			</xsl:variable>
        			
        			<xsl:variable name="promptdefHref"
        				select="($jobFile//file[contains(@path, concat($promptKey,'.dita'))]/@path)[1]"/>
        			<xsl:message>promptdefHref: <xsl:value-of select="$promptdefHref"/></xsl:message>
        			
        			<!-- Derive temp root from job-uri -->
        			<xsl:variable name="temp-root" select="replace($job-uri, '/[^/]+$', '/')"/>
        			
        			<xsl:message>Temp path: <xsl:value-of select="$temp-root"/></xsl:message>
        			
        			<xsl:variable name="promptdefMap"
        				select="document(concat($temp-root, $promptdefHref))"/>
        			
        			<xsl:message>Prompt-path: <xsl:value-of
        				select="concat($temp-root, $promptdefHref)"/></xsl:message>
        			
        			<xsl:choose>
        				<xsl:when test="exists($promptdefMap)">
        					<xsl:message>Processing Prompts inside kpe-prompt.... </xsl:message>
        					<xsl:apply-templates select="$promptdefMap//*[contains(@class, ' learning2-d/lcPrompt2 ')]"/>
        				</xsl:when>
        				<xsl:otherwise>
        					<fo:block color="red">[Prompt map not resolved, key: <xsl:value-of
        						select="$promptKey"/>]</fo:block>
        				</xsl:otherwise>
        			</xsl:choose>
        		</xsl:when>
        	</xsl:choose>
        	
        	
        	
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
	
	
	<!-- ARV_26-03-2025 GMAT update -->
	<xsl:template match="*[contains(@class, ' learning2-d/lcQuestionPrompt2 ')]">
		<!-- [SP] If the paragraph is contained in a table entry or in a note, use much smaller space
                  around it. -->
		<xsl:comment>Handling learning2-d/lcQuestionPrompt2.</xsl:comment>
		<fo:block xsl:use-attribute-sets="lcQuestionPrompt2" id="{@id}">
			<xsl:call-template name="commonattributes"/>
			<xsl:variable name="item_number" select="count(ancestor::*[contains(@class, ' kpe-question/kpe-question ')][1]/preceding-sibling::*[contains(@class, ' kpe-question/kpe-question ')])+1"/>
			
			<!-- [SP] 2015-01-16: There was a division between courses, final, and qbank on displaying QIDs.
                                  With LMS 3.0, that division has gone away: always display the QIDs.
                                  And show the original DITA file name.
            -->
			<fo:list-block space-after="6pt">
				<fo:list-item>
					<fo:list-item-label end-indent="2in">
						
						<xsl:choose>
							<xsl:when test="(not(parent::lcGraphicsInterpretation) and not(parent::lcMultiSourceReasoningMultiple) and not(parent::lcMultiSourceReasoningSingle) and not(parent::lcReadingComprehension) and not(parent::lcTableAnalysis) and not(parent::lcTwoPartAnalysis) )">
								<fo:block>
									<xsl:value-of select="concat('QUESTION# ',$item_number)"/>
								</fo:block>
							</xsl:when>
						</xsl:choose>
						
						
					</fo:list-item-label>
					<fo:list-item-body start-indent="2in">
						<!-- Get ready for question ID stuff. -->
						<!--                                <xsl:variable name="product_line" select="$map//*[contains(@class,' topic/series ')][1]"/>-->
						<!-- [SP] 2015-01-16: Old QID was the product line and number. Now we want the DITA filename. -->
						<!-- [SP] 2015-03-11: Remove product line from QID title.-->
						<xsl:variable name="product_line">
							<xsl:choose>
								<xsl:when test="starts-with($OUTPUT_TYPE,'final_')">
									<xsl:value-of select="$map/bookmeta[1]/prodinfo[1]/series[1]"/>
									<xsl:text> </xsl:text>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<!--                        <xsl:variable name="question_id" select="concat($product_line,'_ques_',format-number($item_number,'000000'))"/>
-->
						<!-- Ensure that the slashes run the right way. -->
						<xsl:variable name="dita_file" select="replace(translate(@xtrf,'\','/'),'^.*/([^/]*.dita)$','$1')"/>
						
						
						<xsl:choose>
							<xsl:when test="(not(parent::lcGraphicsInterpretation) and not(parent::lcMultiSourceReasoningMultiple) and not(parent::lcMultiSourceReasoningSingle) and not(parent::lcReadingComprehension) and not(parent::lcTableAnalysis) and not(parent::lcTwoPartAnalysis) )">
								<fo:block text-align="right">
									<!--                            <xsl:value-of select="concat('[QID: ',$question_id,']')"/>-->
									<!--                            <xsl:value-of select="concat('[QID: ',$product_line,$dita_file,']')"/>-->
									<xsl:value-of select="concat('[QID: ',$dita_file,']')"/>
								</fo:block>
							</xsl:when>
						</xsl:choose>
						
						
						
						<xsl:variable name="legacy_id" select="ancestor-or-self::*[contains(@class,' kpe-question/kpe-question ')]/descendant::*[contains(@class,' kpe-commonMeta-d/legacyID ')]/@value"/>
						
						<xsl:choose>
							<xsl:when test="(not(parent::lcGraphicsInterpretation) and not(parent::lcMultiSourceReasoningMultiple) and not(parent::lcMultiSourceReasoningSingle) and not(parent::lcReadingComprehension) and not(parent::lcTableAnalysis) and not(parent::lcTwoPartAnalysis) ) and ($legacy_id != '') ">
								<fo:block text-align="right">
									<xsl:value-of select="concat('[LegacyID: ',$legacy_id,']')"/>
								</fo:block>
							</xsl:when>
						</xsl:choose>
						
						<!--<xsl:if test="($legacy_id != '')">
							<fo:block text-align="right">
								<xsl:value-of select="concat('[LegacyID: ',$legacy_id,']')"/>
							</fo:block>
						</xsl:if>-->
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
			
			<!-- (old course/no course decision stuff, remove eventually. ) -->
			<!--            <xsl:choose>   
                <xsl:when test="$OUTPUT_TYPE = 'course'">
                    <!-\- Output the question number and move on to the content of the question. -\->
                    <xsl:number value="$item_number" 
                        format="1"/>
                    <xsl:text>. </xsl:text> 
                </xsl:when>
                <xsl:otherwise>
                    <fo:list-block space-after="6pt">
                        <fo:list-item>
                            <fo:list-item-label end-indent="3in">
                                <fo:block>
                                    <xsl:value-of select="concat('QUESTION# ',$item_number)"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="3in">
                                <!-\- Get ready for question ID stuff. -\->
<!-\-                                <xsl:variable name="product_line" select="$map//*[contains(@class,' topic/series ')][1]"/>-\->
                                <xsl:variable name="product_line" select="$map/bookmeta[1]/prodinfo[1]/series[1]"/>
                                <xsl:variable name="question_id" select="concat($product_line,'_ques_',format-number($item_number,'000000'))"/>
                                <fo:block text-align="right">
                                    <xsl:value-of select="concat('[QID: ',$question_id,']')"/>
                                </fo:block>
                                <xsl:variable name="legacy_id" 
                                    select="ancestor::*[contains(@class,' kpe-question/kpe-question ')]/descendant::*[contains(@class,' kpe-commonMeta-d/legacyID ')]/@value"/>

                                <fo:block text-align="right">
                                    <xsl:value-of select="concat('[',$legacy_id,']')"/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </fo:list-block>
                    
                </xsl:otherwise>
                
            </xsl:choose>-->
		    
		    
		    <xsl:comment>[Custom-DEBUG] Checking for prompts inside .job.xml</xsl:comment>
			<xsl:message>[Custom-DEBUG] Checking for prompts inside .job.xml</xsl:message>
		    
		    <xsl:variable name="thisFile" select="replace(translate(@xtrf, '\\', '/'), '^.*/', '')"/>
			
			<xsl:message>thisFile: <xsl:value-of select="$thisFile"/></xsl:message>
			
		    
		    <xsl:variable name="allTopicrefs" select="utils:get-all-topicrefs($map)"/>
			<xsl:variable name="myTopicref"
				select="$allTopicrefs[contains(@ohref, $thisFile) or contains(@href, $thisFile)][1]"/>
			<xsl:message>myTopicref: <xsl:value-of select="$myTopicref/@href"/></xsl:message>
		    
		    <xsl:variable name="originalMapPath"
		        select="concat('file:/', translate($myTopicref/@xtrf, '\\', '/'))"/>
			<xsl:message>originalMapPath: <xsl:value-of select="$originalMapPath"/></xsl:message>
			
		    <xsl:variable name="originalMap" select="document($originalMapPath)"/>
		    
			<xsl:variable name="originalRef"
				select="$originalMap//topicref[ends-with(@href, $thisFile)]"/>
			<xsl:message>originalRef: <xsl:value-of select="$originalRef/@href"/></xsl:message>
		    
			<xsl:variable name="promptKey"
				select="$originalRef/*[local-name()='topicprompt']/@keyref"/>
			<xsl:message>promptKey: <xsl:value-of select="$promptKey"/></xsl:message>
		    
		    
            <xsl:choose>
                <xsl:when test="$promptKey != ''">
                    <!-- Step 1: Resolve .job.xml using safe base -->
                    <xsl:variable name="job-uri" select="resolve-uri('.job.xml', base-uri(/))"/>
                	
                    
                    <xsl:comment>Prompts exist!!</xsl:comment>
                    <xsl:message>job-uri resolved: <xsl:value-of select="$job-uri"/></xsl:message>

                    <xsl:variable name="jobFile" as="document-node()?">
                        <xsl:choose>
                            <xsl:when test="unparsed-text-available($job-uri)">
                                <xsl:sequence select="document($job-uri)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:message>[WARNING] .job.xml not found or unreadable at:
                                        <xsl:value-of select="$job-uri"/></xsl:message>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:variable name="promptdefHref"
                        select="($jobFile//file[contains(@path, concat($promptKey,'.dita'))]/@path)[1]"/>
                	<xsl:message>promptdefHref: <xsl:value-of select="$promptdefHref"/></xsl:message>

                    <!-- Derive temp root from job-uri -->
                    <xsl:variable name="temp-root" select="replace($job-uri, '/[^/]+$', '/')"/>

                    <xsl:message>Temp path: <xsl:value-of select="$temp-root"/></xsl:message>

                    <xsl:variable name="promptdefMap"
                        select="document(concat($temp-root, $promptdefHref))"/>

                    <xsl:message>Prompt-path: <xsl:value-of
                            select="concat($temp-root, $promptdefHref)"/></xsl:message>

                    <xsl:choose>
                        <xsl:when test="exists($promptdefMap)">
                            <xsl:message>Processing Prompts inside kpe-prompt.... </xsl:message>
                            <xsl:apply-templates select="$promptdefMap//*[contains(@class, ' learning2-d/lcPrompt2 ')]"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <fo:block color="red">[Prompt map not resolved, key: <xsl:value-of
                                    select="$promptKey"/>]</fo:block>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>
			
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	
	
	
	
	
    


	<!-- ARV_17-04-2025 GMAT update -->
    <xsl:template match="(*[contains(@class, ' learning2-d/lcTwoPartAnalysis ')]) | (*[contains(@class, ' learning2-d/lcMultiSourceReasoningMultiple ')]) | (*[contains(@class, ' learning2-d/lcMultiSourceReasoningSingle ')]) | (*[contains(@class, ' learning2-d/lcReadingComprehension ')]) | (*[contains(@class, ' learning2-d/lcTableAnalysis ')]) | (*[contains(@class, ' learning2-d/lcGraphicsInterpretation ')])">
		<!-- [SP] If the paragraph is contained in a table entry or in a note, use much smaller space
                  around it. -->
		<xsl:comment>Handling learning2-d/lcTwoPartAnalysis, learning2-d/lcMultiSourceReasoningMultiple, learning2-d/lcMultiSourceReasoningSingle, learning2-d/lcReadingComprehension, learning2-d/lcTableAnalysis, learning2-d/lcGraphicsInterpretation.</xsl:comment>
        
        
        
		<fo:block xsl:use-attribute-sets="lcMultiSourceReasoningMultiple" id="{@id}">
			<xsl:call-template name="commonattributes"/>
			<xsl:variable name="item_number" select="count(ancestor::*[contains(@class, ' kpe-question/kpe-question ')][1]/preceding-sibling::*[contains(@class, ' kpe-question/kpe-question ')])+1"/>
			
			<!-- [SP] 2015-01-16: There was a division between courses, final, and qbank on displaying QIDs.
                                  With LMS 3.0, that division has gone away: always display the QIDs.
                                  And show the original DITA file name.
            -->
			<fo:list-block space-after="6pt">
				<fo:list-item>
					<fo:list-item-label end-indent="2in">
					    <xsl:if test="self::*[not(parent::lcPrompt2)]">
						    <fo:block>
							<xsl:value-of select="concat('QUESTION# ',$item_number)"/>
						</fo:block>
						</xsl:if>
					</fo:list-item-label>
					<fo:list-item-body start-indent="2in">
						<!-- Get ready for question ID stuff. -->
						<!--                                <xsl:variable name="product_line" select="$map//*[contains(@class,' topic/series ')][1]"/>-->
						<!-- [SP] 2015-01-16: Old QID was the product line and number. Now we want the DITA filename. -->
						<!-- [SP] 2015-03-11: Remove product line from QID title.-->
						<xsl:variable name="product_line">
							<xsl:choose>
								<xsl:when test="starts-with($OUTPUT_TYPE,'final_')">
									<xsl:value-of select="$map/bookmeta[1]/prodinfo[1]/series[1]"/>
									<xsl:text> </xsl:text>
								</xsl:when>
							</xsl:choose>
						</xsl:variable>
						<!--                        <xsl:variable name="question_id" select="concat($product_line,'_ques_',format-number($item_number,'000000'))"/>
-->
						<!-- Ensure that the slashes run the right way. -->
						<xsl:variable name="dita_file" select="replace(translate(@xtrf,'\','/'),'^.*/([^/]*.dita)$','$1')"/>
						
						<fo:block text-align="right">
							<!--                            <xsl:value-of select="concat('[QID: ',$question_id,']')"/>-->
							<!--                            <xsl:value-of select="concat('[QID: ',$product_line,$dita_file,']')"/>-->
							<xsl:value-of select="concat('[QID: ',$dita_file,']')"/>
						</fo:block>
						<xsl:variable name="legacy_id" select="ancestor-or-self::*[contains(@class,' kpe-question/kpe-question ')]/descendant::*[contains(@class,' kpe-commonMeta-d/legacyID ')]/@value"/>
					    <xsl:if test="$legacy_id != ''">
						    <fo:block text-align="right">
								<xsl:value-of select="concat('[LegacyID: ',$legacy_id,']')"/>
							</fo:block>
						</xsl:if>
					</fo:list-item-body>
				</fo:list-item>
			</fo:list-block>
			
			
			<!--<xsl:if test="lcTabQuestionContext2/lcQuestionContextTab/lcQuestionContextTabLabel[node()]">
				<fo:block space-before="10pt" color="red" text-align="left">
					<fo:inline font-weight="bold">Context_Tab_Label: </fo:inline>
					<xsl:apply-templates select="lcTabQuestionContext2/lcQuestionContextTab/lcQuestionContextTabLabel"/>
				</fo:block>
			</xsl:if>-->
			
			<!-- (old course/no course decision stuff, remove eventually. ) -->
			<!--            <xsl:choose>   
                <xsl:when test="$OUTPUT_TYPE = 'course'">
                    <!-\- Output the question number and move on to the content of the question. -\->
                    <xsl:number value="$item_number" 
                        format="1"/>
                    <xsl:text>. </xsl:text> 
                </xsl:when>
                <xsl:otherwise>
                    <fo:list-block space-after="6pt">
                        <fo:list-item>
                            <fo:list-item-label end-indent="3in">
                                <fo:block>
                                    <xsl:value-of select="concat('QUESTION# ',$item_number)"/>
                                </fo:block>
                            </fo:list-item-label>
                            <fo:list-item-body start-indent="3in">
                                <!-\- Get ready for question ID stuff. -\->
<!-\-                                <xsl:variable name="product_line" select="$map//*[contains(@class,' topic/series ')][1]"/>-\->
                                <xsl:variable name="product_line" select="$map/bookmeta[1]/prodinfo[1]/series[1]"/>
                                <xsl:variable name="question_id" select="concat($product_line,'_ques_',format-number($item_number,'000000'))"/>
                                <fo:block text-align="right">
                                    <xsl:value-of select="concat('[QID: ',$question_id,']')"/>
                                </fo:block>
                                <xsl:variable name="legacy_id" 
                                    select="ancestor::*[contains(@class,' kpe-question/kpe-question ')]/descendant::*[contains(@class,' kpe-commonMeta-d/legacyID ')]/@value"/>

                                <fo:block text-align="right">
                                    <xsl:value-of select="concat('[',$legacy_id,']')"/>
                                </fo:block>
                            </fo:list-item-body>
                        </fo:list-item>
                    </fo:list-block>
                    
                </xsl:otherwise>
                
            </xsl:choose>-->
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	
	
	<xsl:template match="lcQuestionContextTabLabel">
		<fo:block 
			space-before="20pt" 
			color="darkblue"
			font-family="sans-serif"
			font-size="12pt"
			margin-top="25pt">
			
			<fo:inline font-weight="bold">TabContext: </fo:inline>
			<xsl:apply-templates/>
		</fo:block>
	</xsl:template>
	
	
	
	
	
	

    <!-- Options for OUTPUT_TYPE are:
            course
            final_no_answers
            final_with_answers
            final_alt_no_answers
            final_alt_with_answers
            testbank 
    
    -->
	
	<!--<xsl:template match="lcAnswerOptionGroup2">
		<xsl:choose>
			<xsl:when test="lcAnswerOptionGroupLabel[node()]">
				<fo:block background-color="lightgray" color="blue" xsl:use-attribute-sets="lcAnswerOptionGroupLabel" id="{@id}">
					<xsl:call-template name="commonattributes"/>
					<xsl:apply-templates/>					
				</fo:block>
			</xsl:when>
			<xsl:when test="lcAnswerOption2">
				<xsl:message>ARV: <xsl:value-of select="local-name()"/></xsl:message>
				<xsl:apply-templates select="lcAnswerOption2/lcAnswerContent2"/>
			</xsl:when>
		</xsl:choose>
		
	</xsl:template>-->
	
	<xsl:template match="lcAnswerOptionGroup2">
		<!-- Render the label if present -->
		<xsl:if test="lcAnswerOptionGroupLabel[node()]">
			<fo:block margin-left="6pt" border-left="2pt solid darkblue" padding-top="6pt" padding-left="8pt" padding-bottom="2pt" padding-right="8pt" color="blue" xsl:use-attribute-sets="lcAnswerOptionGroupLabel" id="{@id}-label">
				<xsl:call-template name="commonattributes"/>
				<fo:inline font-size="11pt" color="#a9a19f" font-weight="bold">Label: </fo:inline>
				<fo:inline color="darkblue"><xsl:apply-templates select="lcAnswerOptionGroupLabel"/></fo:inline>
			</fo:block>
		</xsl:if>
		
		<!-- Now render the answer choices as a list -->
		<fo:list-block start-indent="6pt" provisional-label-separation="6pt" provisional-distance-between-starts="12pt">
			<xsl:apply-templates select="lcAnswerOption2"/>
		</fo:list-block>
	</xsl:template>
	<xsl:template match="lcAnswerOption2">
		<fo:list-item>
			<fo:list-item-label end-indent="label-end()">
				<fo:block>•</fo:block> <!-- or number if desired -->
			</fo:list-item-label>
			
			<fo:list-item-body start-indent="body-start()">
				<xsl:apply-templates select="lcAnswerContent2"/>
			</fo:list-item-body>
		</fo:list-item>
	</xsl:template>
	
	

    <!--GK100213 Customization for answer choice bold -->
    <xsl:template match="*[contains(@class, ' learning2-d/lcAnswerContent2 ')]">
        <!-- [SP] If the paragraph is contained in a table entry or in a note, use much smaller space
                  around it. -->
        <xsl:comment>Handling learning2-d/lcAnswerContent2.</xsl:comment>
    	
    	<!-- ARV: Added for Gmat lcAnswerOptionGroupLabel  -->
		<!--<xsl:choose>
			<xsl:when test="ancestor::lcAnswerOptionGroup2[lcAnswerOptionGroupLabel[node()]] and not(parent::lcAnswerOption2/preceding-sibling::lcAnswerOption2)">
				<fo:block background-color="lightgray" color="blue" xsl:use-attribute-sets="lcAnswerOptionGroupLabel" id="{@id}">
					<xsl:call-template name="commonattributes"/>
					<xsl:apply-templates select="ancestor::lcAnswerOptionGroup2/lcAnswerOptionGroupLabel"/>					
				</fo:block>
			</xsl:when>
		</xsl:choose>-->
    	
    	
        <fo:block xsl:use-attribute-sets="lcAnswerContent2" id="{@id}">
            <xsl:call-template name="commonattributes"/>
        	
            <xsl:variable name="correct" select="count(../lcCorrectResponse2)"/>
            <xsl:choose>
                <xsl:when test="$correct &gt; 0 and not(contains($OUTPUT_TYPE,'no_answers'))">
                    <xsl:attribute name="font-weight">bold</xsl:attribute>
                </xsl:when>
            </xsl:choose>
            <xsl:apply-templates/>
        </fo:block>

    </xsl:template>
	
	
	
	<!--ARV: Customization GMAT ContextOptions -->
	<xsl:template match="*[contains(@class, ' learning2-d/lcQuestionContextOptions2 ')]">
		<!-- [SP] If the paragraph is contained in a table entry or in a note, use much smaller space
                  around it. -->
		<xsl:comment>Handling learning2-d/lcQuestionContextOptions2.</xsl:comment>
		<fo:list-block>
			<fo:list-item>
				<fo:list-item-label end-indent="0in">
					<fo:block>
						<fo:inline font-size="12pt" color="#68615f" font-weight="bold">Context-Options: </fo:inline>
					</fo:block>
				</fo:list-item-label>
				<fo:list-item-body start-indent="1.5in">
					<fo:block color="#68615f" xsl:use-attribute-sets="lcQuestionContextOptions2" id="{@id}">
						<xsl:call-template name="commonattributes"/>
						<xsl:apply-templates select="select/option"/>
					</fo:block>
				</fo:list-item-body>
			</fo:list-item>
		</fo:list-block>
		
	</xsl:template>
	
	<!--ARV: Customization GMAT ContextName -->
	<xsl:template match="option">
		<fo:block font-size="12pt">
			<xsl:value-of select="."/>
		</fo:block>
	</xsl:template>
	

	
	<!--ARV: Customization GMAT ContextName -->
	<xsl:template match="*[contains(@class, ' learning2-d/lcQuestionContextName ')]">
        <!-- [SP] If the paragraph is contained in a table entry or in a note, use much smaller space
                  around it. -->
        <xsl:comment>Handling learning2-d/lcQuestionContextName.</xsl:comment>
		  <fo:block xsl:use-attribute-sets="lcQuestionContextName" id="{@id}">
		  		<xsl:call-template name="commonattributes"/>
		  	<fo:inline font-size="12pt" color="#68615f" font-weight="bold">Context-Name: </fo:inline>
		  	<fo:inline font-size="12pt" color="#68615f"><xsl:value-of select="."/></fo:inline>
		  	
        </fo:block>		  
    </xsl:template>

	
	<!--ARV: Customization GMAT ContextType -->
	<xsl:template match="*[contains(@class, ' learning2-d/lcQuestionContextType ')]">
        <!-- [SP] If the paragraph is contained in a table entry or in a note, use much smaller space
                  around it. -->
        <xsl:comment>Handling learning2-d/lcQuestionContextType.</xsl:comment>
		<fo:block margin-bottom="15pt" xsl:use-attribute-sets="lcQuestionContextType" id="{@id}">
			<xsl:call-template name="commonattributes"/>
			<fo:inline font-size="12pt" color="#68615f" font-weight="bold">Context-Type: </fo:inline>
			<fo:inline font-size="12pt" color="#68615f"><xsl:value-of select="."/></fo:inline>
		</fo:block>		
    </xsl:template>
	
    <!--ARV: Customization GMAT Reading Comprehension text-indent -->	
    <xsl:template match="lcQuestionContext2/p[ancestor::lcPrompt2[@questionType='RC']]" priority="100">
        <fo:block xsl:use-attribute-sets="lcQuestionPrompt2" text-indent="2.5em">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>	
	
	
	
	<!-- [ARV 25/5/2025] Handle text-indent. -->	
	<xsl:template match="*[contains(@class,' topic/p ') and @outputclass='text_indent']">
		<xsl:comment>Handling outputclass="text_indent".</xsl:comment>
		<fo:block text-indent="2.5em">
			<xsl:apply-templates/>
		</fo:block>		
	</xsl:template>
	

    <!-- [SP] Handle inline emphasisItalics formatting. -->

    <xsl:template match="*[contains(@class, ' kpe-common-d/emphasisItalics ')]" priority="100">
        <xsl:comment>Handling kpe-common-d/emphasisItalics.</xsl:comment>
        <fo:inline xsl:use-attribute-sets="emphasisItalics" id="{@id}">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <!-- [SP] Handle inline emphasisBold formatting. -->

    <xsl:template match="*[contains(@class, ' kpe-common-d/emphasisBold ')]" priority="100">
        <xsl:comment>Handling kpe-common-d/emphasisBold.</xsl:comment>
        <fo:inline xsl:use-attribute-sets="emphasisBold" id="{@id}">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <!-- [PSB 7/24/15] Handle inline commandWord formatting. -->

    <xsl:template match="*[contains(@class, ' kpe-common-d/commandWord ')]" priority="100">
        <xsl:comment>Handling kpe-common-d/commandWord.</xsl:comment>
        <fo:inline xsl:use-attribute-sets="commandWord" id="{@id}">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <!-- [PSB 5/5/16] Handle inline strikethrough formatting. -->

    <xsl:template match="*[contains(@class,' topic/ph ') and @outputclass='strike']">
        <xsl:comment>Handling outputclass="strike".</xsl:comment>
        <fo:inline text-decoration="line-through">
            <xsl:apply-templates select="*|text()"/>
        </fo:inline>
    </xsl:template>
    
    <!-- [SP] 2018-05-29 sfb: Added line_break formatting. -->
    <xsl:template match="*[contains(@class,' topic/ph ') and @outputclass='line_break']">
        <!-- Empty block has the same effect as a newline, but without requiring linefeed-treatment="preserve". -->
        <fo:block/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' topic/ph ') and @outputclass='los']">
        <xsl:apply-templates/>
        <fo:block/>
    </xsl:template>

    <!-- [PSB 5/5/16] Handle inline sum/underline formatting. -->
    <xsl:template match="sum">
        <fo:inline text-decoration="underline">
            <xsl:apply-templates select="*|text()"/>
        </fo:inline>
    </xsl:template>

    <!-- [PSB 5/5/16] Handle inline total/double-underline formatting. -->
    <xsl:template match="total">
        <fo:inline text-decoration="underline">
            <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
            <xsl:attribute name="border-bottom-width">0.5pt</xsl:attribute>
            <xsl:attribute name="border-bottom-color">black</xsl:attribute>
            <xsl:apply-templates select="*|text()"/>
        </fo:inline>
    </xsl:template>


    <!-- [PSB 5/5/16] Handle inline overline formatting. -->

    <xsl:template match="*[contains(@class,' topic/ph ') and @outputclass='overline']">
        <xsl:comment>Handling outputclass="overline".</xsl:comment>
        <fo:inline text-decoration="overline">
            <xsl:apply-templates select="*|text()"/>
        </fo:inline>
    </xsl:template>

   



    <!--  [PSB 5/17/16] Handle CDATA tables  -->
    <!--    keep trying-->
  <!--  <xsl:template name="wrap_cdata">
        <xsl:value-of select="." disable-output-escaping="yes"/>
        <xsl:text disable-output-escaping="yes">
        <![CDATA[]]>
      </xsl:text>
    </xsl:template>

    <xsl:template match="foreign" mode="identity" priority="100">
        <fo:block>
            <xsl:call-template name="wrap_cdata"/>
        </fo:block>
    </xsl:template>
    -->
    
    <xsl:template match="foreign">
        <!-- [SP] If the paragraph is contained in a table entry or in a note, use much smaller space
                  around it. -->
        <xsl:comment>Handling topic/foreign.</xsl:comment>
    
            <!-- The source attribute on <p> allows for nice formatting of source attribution
                 info after <lq> elements. Automatically inserts em-dash before source. -->
           
                <fo:block xsl:use-attribute-sets="p" id="{@id}">
                    <xsl:call-template name="commonattributes"/>
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
	<xsl:template match="*[contains(@class, ' learning2-d/lcFeedbackCorrect2 ') or contains(@class, ' learning2-d/lcOpenAnswer2 ')]">

        <xsl:if test="not(contains($OUTPUT_TYPE,'no_answers'))">
        	
        	<fo:block 
        		space-before="20pt" 
        		color="darkgreen"
        		font-family="sans-serif"
        		font-size="12pt"
        		margin-top="25pt">
        		<!--<xsl:if test="lcOpenAnswer2/p">-->
        			<fo:inline font-weight="bold">Rationale: </fo:inline>
        		<!--</xsl:if>-->
        	</fo:block>

            <xsl:apply-imports/>
        </xsl:if>

    </xsl:template>

	<!-- ARV Added on 16-07-2025 -->
	<xsl:template match="essaySection">
		<xsl:variable name="sectionDoc" select="document(@href)"/>
		
		<fo:block color="darkblue" margin-bottom="10pt" font-size="12pt" text-decoration="underline" font-weight="bold">Section</fo:block>
		<!-- Pull the content from <issue> -->
		<fo:block font-weight="bold">Issue:</fo:block>
		<xsl:apply-templates select="$sectionDoc//issue"/>
		
		<!-- Pull the content from <rules> -->
		<fo:block font-weight="bold">Rules:</fo:block>
		<xsl:apply-templates select="$sectionDoc//rules"/>
		
		<!-- Pull the content from <analysis> -->
		<fo:block font-weight="bold">Analysis:</fo:block>
		<xsl:apply-templates select="$sectionDoc//analysis"/>
		
		<!-- Pull the content from <conclusion> -->
		<fo:block font-weight="bold">Conclusion:</fo:block>
		<xsl:apply-templates select="$sectionDoc//conclusion"/>
	</xsl:template>

    <!-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->

    <!-- [SP] Added colophon to topic types. -->
    <xsl:template match="*" mode="determineTopicType">
        <!-- Default, when not matching a bookmap type, is topicSimple -->
        <xsl:text>topicSimple</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/chapter ')]" mode="determineTopicType">
        <xsl:text>topicChapter</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/appendix ')]" mode="determineTopicType">
        <xsl:text>topicAppendix</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/preface ')]" mode="determineTopicType">
        <xsl:text>topicPreface</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/part ')]" mode="determineTopicType">
        <xsl:text>topicPart</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/abbrevlist ')]" mode="determineTopicType">
        <xsl:text>topicAbbrevList</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/bibliolist ')]" mode="determineTopicType">
        <xsl:text>topicBiblioList</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/booklist ')]" mode="determineTopicType">
        <xsl:text>topicBookList</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/figurelist ')]" mode="determineTopicType">
        <xsl:text>topicFigureList</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/indexlist ')]" mode="determineTopicType">
        <xsl:text>topicIndexList</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/toc ')]" mode="determineTopicType">
        <xsl:text>topicTocList</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/glossarylist ')]" mode="determineTopicType">
        <xsl:text>topicGlossaryList</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/trademarklist ')]" mode="determineTopicType">
        <xsl:text>topicTradeMarkList</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/notices ')]" mode="determineTopicType">
        <xsl:text>topicNotices</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/colophon ')]" mode="determineTopicType">
        <xsl:text>topicColophon</xsl:text>
    </xsl:template>

    <!-- [SP] 2015-03-24: Footnote handling.-->
    <!-- Change to restart numbering at each Unit (Chapter). -->
    <xsl:template match="*[contains(@class,' topic/fn ')]">
        <xsl:variable name="fn_number">
            <xsl:choose>
                <xsl:when test="@callout">
                    <xsl:value-of select="@callout"/>
                </xsl:when>
                <xsl:otherwise>
                    <!--                    <xsl:number level="any" count="*[contains(@class,' topic/fn ') and not(@callout)]"/>-->
                    <!-- [SP] 2015-03-24: Have to drop xsl:number in favor or a preceding count, capped by the unit. -->
                    <xsl:variable name="unit_id" select="ancestor::*[contains(@class,' topic/topic ')][position() = last()]/@id"/>
                    <xsl:value-of select="count(preceding::*[contains(@class,' topic/fn ') and not(@callout) and ancestor::*[@id = $unit_id]]) + 1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <fo:inline>
            <xsl:call-template name="commonattributes"/>
        </fo:inline>
        <fo:footnote>
            <xsl:choose>
                <xsl:when test="not(@id)">
                    <fo:inline xsl:use-attribute-sets="fn__callout">
                        <xsl:value-of select="$fn_number"/>
                    </fo:inline>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Footnote with id does not generate its own callout. -->
                    <fo:inline/>
                </xsl:otherwise>
            </xsl:choose>

            <fo:footnote-body>
                <fo:list-block xsl:use-attribute-sets="fn__body">
                    <fo:list-item>
                        <fo:list-item-label end-indent="label-end()">
                            <fo:block text-align="right">
                                <fo:inline xsl:use-attribute-sets="fn__callout">
                                    <xsl:value-of select="$fn_number"/>
                                </fo:inline>
                            </fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body start-indent="body-start()">
                            <fo:block>
                                <!--                                <xsl:value-of select="."/>-->
                                <xsl:apply-templates/>
                            </fo:block>
                        </fo:list-item-body>
                    </fo:list-item>
                </fo:list-block>
            </fo:footnote-body>
        </fo:footnote>
    </xsl:template>



</xsl:stylesheet>
