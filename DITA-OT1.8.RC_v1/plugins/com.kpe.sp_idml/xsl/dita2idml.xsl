<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:functx="http://www.functx.com"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"
    xmlns:opentopic="http://www.idiominc.com/opentopic" xmlns:m="http://www.w3.org/1998/Math/MathML"
    exclude-result-prefixes="xs functx ditaarch opentopic m" version="2.0">



    <!--SP Stylesheet created by Scriptorium Publishing. Code comments preceded with SP -->

    <!--SP STYLELIST is set in the build file and contains the file name for the InDesign style catalogs.
       OUTPUTDIR is set in the build file and contains the output directory name.
       SEPARATOR is set in the build file and contains the platform-specific directory separator character (: for Mac) -->

    <xsl:param name="STYLELIST"/>
    <xsl:param name="OUTPUTDIR"/>
    <xsl:param name="SEPARATOR"/>
    <!--SP FLASHCARD is captured in the build file from the command line, and will throw processing into flashcard mode-->
    <xsl:param name="FLASHCARD"/>

    <!-- SP Set up map variable -->
    <xsl:variable name="map" select="//opentopic:map"/>

    <!--SP need tab characters. List of whitespace stuff -->
    <xsl:variable name="tab" select="'&#09;'"/>
    <xsl:variable name="whitespace" select="'&#x9;&#xA;&#xD;&#x20;'"/>

    <!--SP InDesign units of measure are points, 72 points per inch -->

    <!-- default live area on the page is 531 points -->
    <xsl:variable name="pagewidth" select="396" as="xs:integer"/>
    <xsl:variable name="parafile" select="concat('file:///', $STYLELIST)"/>

    <!--SP extract each style catalog from the stylelist configuration file and store it in a variable. -->
    <xsl:variable name="charstyles"
        select="document($parafile)/InDesignStyleCatalog/RootCharacterStyleGroup" as="element()*"/>
    <xsl:variable name="parastyles"
        select="document($parafile)/InDesignStyleCatalog/RootParagraphStyleGroup" as="element()*"/>

    <xsl:output method="xml" standalone="yes" indent="yes"/>
    <xsl:template match="/">
        <xsl:message>Creating InCopy document...</xsl:message>
        <xsl:processing-instruction name="aid">style="50" type="snippet" readerVersion="6.0"
            featureSet="257" product="9.0(244)"</xsl:processing-instruction>

        <xsl:processing-instruction name="aid">SnippetType="InCopyInterchange"</xsl:processing-instruction>

        <!--SP locate character and paragraph styles and output them in the ICML file-->

        <Document DOMVersion="9.0" Self="d">
            <xsl:copy-of select="$charstyles"/>
            <xsl:copy-of select="$parastyles"/>

            <idPkg:Graphic xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging"
                DOMVersion="9.0">
                <Color Self="Color/PANTONE 307 U" Name="PANTONE 307 U"/>
            </idPkg:Graphic>

            <RootCellStyleGroup Self="u76">
                <CellStyle Self="CellStyle/$ID/[None]"
                    AppliedParagraphStyle="ParagraphStyle/$ID/[No paragraph style]"
                    Name="$ID/[None]"/>
                <CellStyle Self="CellStyle/$ID/[None]"
                    AppliedParagraphStyle="ParagraphStyle/$ID/[No paragraph style]"
                    Name="$ID/[None]"/>
                <CellStyle Self="CellStyle/MN_header"
                    AppliedParagraphStyle="ParagraphStyle/$ID/[No paragraph style]" Name="MN_header"/>
                <CellStyle Self="CellStyle/MN_body"
                    AppliedParagraphStyle="ParagraphStyle/$ID/[No paragraph style]" Name="MN_body"/>
            </RootCellStyleGroup>

            <RootTableStyleGroup Self="u78">
                <TableStyle Self="TableStyle/ExampleTable" Name="ExampleTable"/>
                <TableStyle Self="TableStyle/ProfNote" Name="ProfNote"/>
                <TableStyle Self="TableStyle/$ID/[No table style]" Name="[No table style]"/>
                <TableStyle Self="TableStyle/MN" Name="MN"
                    HeaderRegionCellStyle="CellStyle/MN_header"
                    BodyRegionCellStyle="CellStyle/MN_body"/>
            </RootTableStyleGroup>

            <RootObjectStyleGroup Self="u81">
                <ObjectStyle Self="ObjectStyle/$ID/[None]" Name="$ID/[None]"
                    AppliedParagraphStyle="ParagraphStyle/$ID/[No paragraph style]"/>
            </RootObjectStyleGroup>
            <Color Self="Color/PANTONE 307 U" Model="Spot" Space="CMYK" ColorValue="100 16 0 27"
                ColorOverride="Normal" SpotInkAliasSpotColorReference="n" AlternateSpace="LAB"
                AlternateColorValue="43.529411764705884 -20 -38" Name="PANTONE 307 U"
                ColorEditable="true" ColorRemovable="false" Visible="true" SwatchCreatorID="31502"/>
            <Color Self="Color/Black" Model="Process" Space="CMYK" ColorValue="0 0 0 100"
                ColorOverride="Specialblack" AlternateSpace="NoAlternateColor"
                AlternateColorValue="" Name="Black" ColorEditable="false" ColorRemovable="false"
                Visible="true" SwatchCreatorID="7937"/>

            <!--SP create the index entries -->
            <Index Self="index">
                <xsl:for-each select="//indexterm[not(parent::indexterm)]">
                    <xsl:variable name="fixtext" select="translate(text()[1],$whitespace,'    ')"/>
                    <Topic Self="{generate-id()}" Name="{normalize-space($fixtext)}">
                        <xsl:apply-templates select="indexterm" mode="indexlist"/>
                    </Topic>
                </xsl:for-each>
            </Index>

            <!--JLC-SP throw processing into flashcard mode if FLASHCARD param is front or back. To activate flashcard processing,
            type -Dflashcard=front/back in the command line when running the transform-->
<!--            COMMENT THIS BACK IN TO RUN FLASHCARDS! USE FRONT AND BACK SCENARIO TO RUN IT         -->

                            <!--<xsl:choose>
                    <xsl:when test="$FLASHCARD='front'">
                        <xsl:call-template name="flashcardfront"/>
                    </xsl:when>
                    <xsl:when test="$FLASHCARD='back'">
                        <xsl:call-template name="flashcardback"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="story"/>
                    </xsl:otherwise>
                </xsl:choose>-->  

            <xsl:call-template name="story"/>

            <!--SP create the text flow; I've temporarily moved this into the choose above. Yank it out if it breaks things.-->



        </Document>
    </xsl:template>

    <xsl:template match="indexterm" mode="indexlist">
        <xsl:variable name="fixtext" select="translate(text()[1],$whitespace,'    ')"/>
        <Topic Self="{generate-id()}" Name="{normalize-space($fixtext)}">
            <xsl:apply-templates select="indexterm" mode="indexlist"/>
        </Topic>
    </xsl:template>

    <!--SP element matching -->

    <!--SP pass through topics and other container elements -->
    <xsl:template
        match="*[contains(@class,' map/map ')] | *[contains(@class,' topic/topic ')] | *[contains(@class,' topic/body ')] | *[contains(@class,' topic/ul ')] | *[contains(@class,' topic/ol ')] |  *[contains(@class,' topic/sl ')] | *[contains(@class,' topic/section ')] | *[contains(@class,' task/info ')]">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="*[contains(@class,' task/steps ')] | *[contains(@class,' task/step ')]"
        priority="10">
        <xsl:apply-templates/>
    </xsl:template>



    <!--SP delete the shortdesc, related topics, draft-comment-->
    <xsl:template
        match="shortdesc | related-links | data | pointValue | brand | series | author | legacyID | duration | completion | lmsCategory"/>

    <xsl:template match="draft-comment"/>

    <xsl:template
        match="*[contains(@class,' topic/prolog ')] | *[contains(@class,' topic/metadata ')] | *[contains(@class,' topic/keywords ')] | *[contains(@class,' topic/keyword ')]">
        <xsl:apply-templates/>
    </xsl:template>

    <!--SP process index entries -->
    <xsl:template match="indexterm">
        <PageReference Self="u{generate-id()}" PageReferenceType="CurrentPage"
            ReferencedTopic="{generate-id()}" Id="{count(preceding::indexterm)+1}"/>
        <xsl:apply-templates select="indexterm"/>
    </xsl:template>



    <!--SP this template processes block elements. Each block element passes a ditaname parameter, which contains a simplified version of the @class attribute.
       In the style configuration file, the @dita attribute is matched to the ditaname parameter to determine the InDesign style.-->
    <xsl:template name="processpara">
        <xsl:param name="ditaname"/>
        <xsl:param name="prefix"/>
        <xsl:param name="suffix"/>
        <xsl:param name="answer"/>
        <xsl:param name="suffix-last"/>
        <xsl:variable name="pstyle" select="$parastyles/ParagraphStyle[@dita = $ditaname]/@Self"/>
        <ParagraphStyleRange AppliedParagraphStyle="{$pstyle}">
            <xsl:if test="string-length($prefix) &gt; 0">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                    <Content>
                        <xsl:value-of select="$prefix"/>
                    </Content>
                </CharacterStyleRange>
            </xsl:if>
            <xsl:if test="string-length($answer) &gt; 0">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/bold">
                    <Content>
                        <xsl:value-of select="$answer"/>
<!--                        <xsl:value-of
                            select="normalize-space(*[contains(@class,' topic/p ')] | note | ul | ol | image | p | table | lq | dl | parml | sl | pre | codeblock | msgblock | screen | lines | fig | table | simpletable | itemgroup | sample)"
                        />-->
                    </Content>
                </CharacterStyleRange>
                <xsl:for-each select="*[contains(@class,' topic/p ')] | note | ul | ol | image | p | table | lq | dl | parml | sl | pre | codeblock | msgblock | screen | lines | fig | table | simpletable | itemgroup | sample">
                    <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                        <Content><xsl:value-of select="normalize-space(.)"/></Content>
                    </CharacterStyleRange>
                </xsl:for-each>
            </xsl:if>
            <xsl:apply-templates
                select="text() | *[contains(@class,' topic/ph ')] | *[contains(@class,' topic/term ')] | 
                                          *[contains(@class,' topic/xref ')] | *[contains(@class,' topic/cite ')] |
                                          *[contains(@class,' topic/q ')] | *[contains(@class,' topic/fn ')] | *[contains(@class,' topic/indextermref ')] | *[contains(@class,' topic/indexterm ')] | *[contains(@class,' topic/tm ')] | *[contains(@class,' topic/keyword ')]">
                <xsl:with-param name="suffix" select="$suffix"/>
                <xsl:with-param name="suffix-last" select="$suffix-last"/>
            </xsl:apply-templates>

            <!-- SP single paragraphs in tables do not get a line break -->

            <xsl:choose>
                <xsl:when test="ancestor-or-self::*[contains(@class,' topic/table ')]">
                    <xsl:if test="count(following-sibling::*[contains(@class,' topic/p ')]) = 0"/>
                    <xsl:if test="count(following-sibling::*[contains(@class,' topic/p ')]) &gt; 0">
                        <Br/>
                    </xsl:if>
                </xsl:when>

                <xsl:otherwise>
                    <Br/>
                </xsl:otherwise>
            </xsl:choose>
            <!--            <Br/>-->
        </ParagraphStyleRange>
        <xsl:if test="string-length($answer) = 0">
        <xsl:apply-templates
            select="*[contains(@class,' topic/p ')] | note | ul | ol | image | p | table | lq | dl | parml | sl | pre | codeblock | msgblock | screen | lines | fig | table | simpletable | itemgroup | sample"
        />
        </xsl:if>
    </xsl:template>


    <!--SP process front matter -->

    <xsl:template match="*[contains(@class,' bookmap/booktitle ')]" priority="3">
        <xsl:apply-templates/>
    </xsl:template>


    <!-- opentopic:map is a duplicate of the overall map, but we need some of its metadata -->
    <xsl:template match="opentopic:map">
        <xsl:apply-templates select="booktitle | bookmeta"/>
    </xsl:template>

    <xsl:template match="*[contains(@class,' bookmap/mainbooktitle ')]" priority="2">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'booktitle'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template
        match="*[contains(@class,' bookmap/bookmeta ')] | *[contains(@class,' bookmap/prodinfo ')] | *[contains(@class,' topic/vrmlist ')]"
        priority="3">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/prodname ')] ">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'copyright'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="*[contains(@class,' bookmap/bookid ')]">
        <xsl:apply-templates select="booknumber"/>
        <xsl:apply-templates select="bookpartno"/>
    </xsl:template>

    <xsl:template match="*[contains(@class,' bookmap/booknumber ')]">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/CR body">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                <Content>
                    <xsl:text>ISBN: </xsl:text>
                    <xsl:value-of select="normalize-space(.)"/>
                </Content>
            </CharacterStyleRange>
            <Br/>
        </ParagraphStyleRange>
    </xsl:template>

    <xsl:template match="subjectdef" priority="100"/>
    <xsl:template match="subjectScheme" priority="100"/>

    <xsl:template match="*[contains(@class,' bookmap/bookpartno ')]">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/CR body">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                <Content>
                    <xsl:text>PPN: </xsl:text>
                    <xsl:value-of select="normalize-space(.)"/>
                </Content>
            </CharacterStyleRange>
            <Br/>
        </ParagraphStyleRange>

        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/disclaimer_CR pg">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                <Content>
                    <xsl:text>If this book does not have the hologram with the Kaplan Schweser logo on the back cover, it was distributed without permission of Kaplan Schweser, a Division of Kaplan, Inc., and is in direct violation of global copyright laws. Your assistance in pursuing potential violators of this law is greatly appreciated.
  </xsl:text>
                </Content>
            </CharacterStyleRange>
            <Br/>
        </ParagraphStyleRange>

        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/disclaimer_CR pg">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                <Content>
                    <xsl:text>Required CFA Institute disclaimer: “CFA® and Chartered Financial Analyst® are trademarks owned by CFA Institute. CFA Institute (formerly the Association for Investment Management and Research) does not endorse, promote, review, or warrant the accuracy of the products or services offered by Kaplan Schweser.”</xsl:text>
                </Content>
            </CharacterStyleRange>
            <Br/>
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                <Content>
                    <xsl:text>Certain materials contained within this text are the copyrighted property of CFA Institute. The following is the copyright disclosure for these materials: “Copyright, 2013, CFA Institute. Reproduced and republished from 2014 Learning Outcome Statements, Level 1, 2, and 3 questions from CFA® Program Materials, CFA Institute Standards of Professional Conduct, and CFA Institute’s Global Investment Performance Standards with permission from CFA Institute. All Rights Reserved.”</xsl:text>
                </Content>
            </CharacterStyleRange>
            <Br/>
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                <Content>
                    <xsl:text>These materials may not be copied without written permission from the author. The unauthorized duplication of these notes is a violation of global copyright laws and the CFA Institute Code of Ethics. Your assistance in pursuing potential violators of this law is greatly appreciated.</xsl:text>
                </Content>
            </CharacterStyleRange>
            <Br/>
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                <Content>
                    <xsl:text>Disclaimer: The Schweser Notes should be used in conjunction with the original readings as set forth by CFA Institute in their 2014 CFA Level 1 Study Guide. The information contained in these Notes covers topics contained in the readings referenced by CFA Institute and is believed to be accurate. However, their accuracy cannot be guaranteed nor is any warranty conveyed as to your ultimate exam success. The authors of the referenced readings have not endorsed or sponsored these Notes.</xsl:text>
                </Content>
            </CharacterStyleRange>
            <Br/>
        </ParagraphStyleRange>


    </xsl:template>



    <xsl:template match="*[contains(@class,' topic/vrm ')]">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/CR body">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                <Content>
                    <xsl:text>©</xsl:text>
                    <xsl:value-of select="@version"/>
                    <xsl:text> Kaplan, Inc. All rights reserved.</xsl:text>
                </Content>
            </CharacterStyleRange>
            <Br/>
        </ParagraphStyleRange>
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/CR body">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                <Content>
                    <xsl:text>Published in </xsl:text>
                    <xsl:value-of select="@version"/>
                    <xsl:text> by Kaplan, Inc.</xsl:text>
                </Content>
            </CharacterStyleRange>
            <Br/>
        </ParagraphStyleRange>
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/CR body">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                <Content>
                    <xsl:text>Printed in the United States of America.</xsl:text>
                </Content>
            </CharacterStyleRange>
            <Br/>
        </ParagraphStyleRange>

    </xsl:template>

    <!-- SP must extract chapter titles from containing file because they are NOT In the merged file -->

    <xsl:template
        match="*[contains(@class,' bookmap/chapter ')] | *[contains(@class,' bookmap/appendix ')]"
        priority="10">
        <xsl:apply-templates select="topicmeta/shortdesc" mode="content"/>

        <xsl:variable name="pstyle" select="$parastyles/ParagraphStyle[@dita = 'parttitle']/@Self"/>
        <ParagraphStyleRange AppliedParagraphStyle="{$pstyle}">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                <Content>
                    <xsl:value-of select="document(@xtrf)/map/title"/>

                </Content>
            </CharacterStyleRange>
            <Br/>
        </ParagraphStyleRange>


        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/z_Header2">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                <Content>
                    <xsl:value-of select="ancestor::part/topicmeta/navtitle"/>
                </Content>
            </CharacterStyleRange>
        </ParagraphStyleRange>
        <Br/>

        <!--  <xsl:apply-templates/>-->

        <xsl:variable name="topicid" select="@id"/>
        <xsl:apply-templates select="//*[contains(@class, ' topic/topic ')][@id = $topicid]"/>
    </xsl:template>

    <xsl:template match="*[contains(@class,' bookmap/part ')]" priority="10">
        <xsl:apply-templates select="shortdesc" mode="content"/>

        <xsl:variable name="pstyle" select="$parastyles/ParagraphStyle[@dita = 'parttitle']/@Self"/>
        <ParagraphStyleRange AppliedParagraphStyle="{$pstyle}">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                <Content>
                    <xsl:value-of select="document(@xtrf)/map/title"/>
                    <!-- SP part title is processed here, but part title not appearing in merged content -->
                </Content>
            </CharacterStyleRange>
            <Br/>
        </ParagraphStyleRange>

        <xsl:variable name="topicid" select="@id"/>
        <xsl:apply-templates select="//*[contains(@class, ' topic/topic ')][@id = $topicid]"/>
    </xsl:template>





    <xsl:template match="*[contains(@class,' topic/fig ')]/*[contains(@class,' topic/title ')]"
        priority="5">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'figtitle'"/>
        </xsl:call-template>
    </xsl:template>

    <!-- SP images -->

    <xsl:template match="*[contains(@class,' topic/fig ')]">
        <xsl:apply-templates/>
    </xsl:template>
    <!--PSB EDIT TO REMOVE outputclass image processing 9/3/15-->
    <xsl:template match="*[contains(@class,' topic/image ')]">


        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/figure_inline">
            <Rectangle ContentType="GraphicType"
                HorizontalLayoutConstraints="FlexibleDimension FixedDimension FlexibleDimension"
                VerticalLayoutConstraints="FlexibleDimension FixedDimension FlexibleDimension"
                AppliedObjectStyle="ObjectStyle/$ID/[None]" Visible="true" Name="{generate-id()}">
                <Properties>
                    <PathGeometry>
                        <GeometryPathType PathOpen="false">
                            <PathPointArray>
                                <PathPointType Anchor="-36 -36" LeftDirection="-36 -36"
                                    RightDirection="-36 -36"/>
                                <PathPointType Anchor="-36 36" LeftDirection="-36 36"
                                    RightDirection="-36 36"/>
                                <PathPointType Anchor="504 36" LeftDirection="504 36"
                                    RightDirection="504 36"/>
                                <PathPointType Anchor="504 -36" LeftDirection="504 -36"
                                    RightDirection="504 -36"/>
                            </PathPointArray>
                        </GeometryPathType>
                    </PathGeometry>
                </Properties>
                <AnchoredObjectSetting AnchoredPosition="Anchored" AnchorPoint="TopLeftAnchor"
                    HorizontalReferencePoint="AnchorLocation" VerticalAlignment="TopAlign"/>
                <TextWrapPreference Inverse="false" ApplyToMasterPageOnly="false"
                    TextWrapSide="BothSides" TextWrapMode="JumpObjectTextWrap">
                    <Properties>
                        <TextWrapOffset Top="0" Left="0" Bottom="0" Right="0"/>
                    </Properties>
                    <ContourOption ContourType="SameAsClipping" IncludeInsideEdges="false"
                        ContourPathName="$ID/"/>
                </TextWrapPreference>
                <Link Self="{generate-id()}">
                    <xsl:attribute name="LinkResourceURI">
                        <xsl:value-of select="concat('file://',$OUTPUTDIR,$SEPARATOR,@href)"/>
                    </xsl:attribute>
                </Link>

            </Rectangle>
        </ParagraphStyleRange>
        <Br/>

    </xsl:template>





    <!--<xsl:template match="*[contains(@class,' topic/image ')]">
        <xsl:choose>
            <xsl:when test="@outputclass = 'digital'"/>
            <xsl:when test="@outputclass = 'print'">
                <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/figure_inline">
                    <Rectangle ContentType="GraphicType"
                        HorizontalLayoutConstraints="FlexibleDimension FixedDimension FlexibleDimension"
                        VerticalLayoutConstraints="FlexibleDimension FixedDimension FlexibleDimension"
                        AppliedObjectStyle="ObjectStyle/$ID/[None]" Visible="true"
                        Name="{generate-id()}">
                        <Properties>
                            <PathGeometry>
                                <GeometryPathType PathOpen="false">
                                    <PathPointArray>
                                        <PathPointType Anchor="-36 -36" LeftDirection="-36 -36"
                                            RightDirection="-36 -36"/>
                                        <PathPointType Anchor="-36 36" LeftDirection="-36 36"
                                            RightDirection="-36 36"/>
                                        <PathPointType Anchor="504 36" LeftDirection="504 36"
                                            RightDirection="504 36"/>
                                        <PathPointType Anchor="504 -36" LeftDirection="504 -36"
                                            RightDirection="504 -36"/>
                                    </PathPointArray>
                                </GeometryPathType>
                            </PathGeometry>
                        </Properties>
                        <AnchoredObjectSetting AnchoredPosition="Anchored"
                            AnchorPoint="TopLeftAnchor" HorizontalReferencePoint="AnchorLocation"
                            VerticalAlignment="TopAlign"/>
                        <TextWrapPreference Inverse="false" ApplyToMasterPageOnly="false"
                            TextWrapSide="BothSides" TextWrapMode="JumpObjectTextWrap">
                            <Properties>
                                <TextWrapOffset Top="0" Left="0" Bottom="0" Right="0"/>
                            </Properties>
                            <ContourOption ContourType="SameAsClipping" IncludeInsideEdges="false"
                                ContourPathName="$ID/"/>
                        </TextWrapPreference>
                        <Link Self="{generate-id()}">
                            <xsl:attribute name="LinkResourceURI">
                                <xsl:value-of select="concat('file://',$OUTPUTDIR,$SEPARATOR,@href)"
                                />
                            </xsl:attribute>
                        </Link>

                    </Rectangle>
                </ParagraphStyleRange>
                <Br/>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>-->




    <!-- SP question titles are empty, so throw them away to avoid empty paragraphs in output -->
    <xsl:template match="kpe-question/title" priority="3"/>

    <xsl:template match="*[contains(@class,' topic/section ')]/*[contains(@class,' topic/title ')]"
        priority="4">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'sectiontitle'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/title ')]">
        <xsl:variable name="titletype">
            <xsl:choose>
                <xsl:when test="parent::learningOverview">
                    <xsl:text>learningoverviewtitle</xsl:text>
                </xsl:when>
                <xsl:when test="contains(.,'Exam Focus')">
                    <xsl:text>topictitleef</xsl:text>
                </xsl:when>
                <xsl:when test="starts-with(.,'LOS')">
                    <xsl:text>topictitlelos</xsl:text>
                </xsl:when>
                <xsl:when test="contains(.,'Concept Checkers')">
                    <xsl:text>topictitleCC</xsl:text>
                    <!-- topictitleCC is processed into a table -->
                </xsl:when>
                <xsl:when test="contains(.,'Study Session')">
                    <xsl:text>studysession</xsl:text>
                </xsl:when>
                <xsl:when test="contains(.,'Key Concepts')">
                    <xsl:text>keyconcepts</xsl:text>
                </xsl:when>
                <xsl:when test="starts-with(.,'Case Study')">
                    <xsl:text>casestudy</xsl:text>
                </xsl:when>
                <xsl:when test="contains(.,'Formulas')">
                    <xsl:text>formulatitle</xsl:text>
                </xsl:when>
                <xsl:when test="contains(.,'Unit Exam')">
                    <xsl:text>unitexam</xsl:text>
                </xsl:when>

                <xsl:when test="parent::map">
                    <xsl:text>parttitle</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>topictitle</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$titletype = 'topictitleCC'">
                <xsl:call-template name="selftestheader">
                    <xsl:with-param name="heading">Concept Checkers</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$titletype = 'keyconcepts'">
                <xsl:call-template name="selftestheader">
                    <xsl:with-param name="heading">Key Concepts</xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$titletype = 'formulatitle'">
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="$titletype"/>
                </xsl:call-template>
                <xsl:call-template name="formulas"/>

            </xsl:when>

            <xsl:when test="$titletype = 'topictitlelos'">
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="$titletype"/>
                </xsl:call-template>

                <xsl:if test="following-sibling::prolog/metadata/data[@name = 'curriculumvolume']">
                    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/CFAI_ref">
                        <CharacterStyleRange
                            AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                            <Content>
                                <xsl:text>CFA® Program Curriculum, Volume </xsl:text>
                                <xsl:value-of
                                    select="following-sibling::prolog/metadata/data[@name = 'curriculumvolume']"/>
                                <xsl:text>, page </xsl:text>
                                <xsl:value-of
                                    select="following-sibling::prolog/metadata/data[@name = 'curriculumpage']"
                                />
                            </Content>
                        </CharacterStyleRange>
                    </ParagraphStyleRange>
                    <Br/>
                </xsl:if>

            </xsl:when>



            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="$titletype"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>



    <xsl:template match="*[contains(@class,' map/topicmeta ')]">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="*[contains(@class,' map/topicref ')]" priority="5"/>

    <xsl:template match="*[contains(@class,' topic/navtitle ')][starts-with(text()[1],'LOS')]"
        priority="5">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topictitlelos'"/>
        </xsl:call-template>
    </xsl:template>




    <!-- SP throw away navtitles -->
    <xsl:template match="*[contains(@class,' topic/navtitle ')]"/>


    <!-- SP linktext inside navtitle duplicates navtitle -->
    <xsl:template match="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' map/linktext ')]"/>

    <xsl:template match="shortdesc" mode="content">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'mapshortdesc'"/>
        </xsl:call-template>
    </xsl:template>

    <!--SP process block elements -->

    <xsl:template match="*[contains(@outputclass,'equation')]" priority="5">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'formula'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/p ')]">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicp'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="*[contains(@class,' task/info ')]/*[contains(@class,' topic/p ')]">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'taskinfotopicp'"/>
        </xsl:call-template>
    </xsl:template>

    <!-- SPJLC Added handling for <p> within <entry>  -->

    <xsl:template match="*[contains(@class,' topic/entry ')]/*[contains(@class,' topic/p ')]">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'tbody'"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template
        match="*[contains(@class,' learning2-d/lcQuestion2 ')]/*[contains(@class,' topic/p ')][1]"
        priority="6">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicp'"/>
        </xsl:call-template>
    </xsl:template>

    <!-- PSB 10/5/15 CHANGED paragraph style from lcanswercontent to lcquestioncont-->
    <xsl:template
        match="*[contains(@class,' learning2-d/lcQuestion2 ')]/*[contains(@class,' topic/p ')]"
        priority="5">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'lcquestioncont'"/>
            <!--    <xsl:with-param name="prefix" select="concat(' ',$tab)"/>-->
        </xsl:call-template>
    </xsl:template>


    <!-- LISTS-->
    <!-- PSB 10/2/15: I totally redid all the list processing. This provides processing for up to three levels of lists.   -->

    <!--  <xsl:template match="ol/li[1]">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'topiclinum1'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    -->


    <!--    <xsl:template match="ol/li[1]/p[1]">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'topiclinum1'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>-->


    <xsl:template match="ul/li">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicli'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ul/li/ul/li">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicli2'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/body ')]/ul/li/ul/li/ul/li">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicli3'"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="*[contains(@class,' topic/section ')]/ul/li/ul/li/ul/li">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicli3'"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="*[contains(@class,' topic/dd ')]/ul/li/ul/li/ul/li">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicli3'"/>
        </xsl:call-template>
    </xsl:template>
    <!--  ordered list - one level  -->
    <xsl:template match="ol/li">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topiclinum'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ol/li/p" priority="3">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'unnumli'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ol/li/p[1]" priority="4">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topiclinum'"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="ol/li/ol/li">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topiclinum2'"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="ol/li/ol/li/ol/li">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topiclinum3'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ol/li/ul/li" priority="3">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicli2'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ul/li/ol/li" priority="5">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topiclinum2'"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="ol/li/ul/li/ol/li" priority="5">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topiclinum3'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ul/li/ul/li/ol/li" priority="5">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topiclinum3'"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="ul/li/ol/li/ol/li" priority="5">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topiclinum3'"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="*[contains(@class,' topic/body ')]/ol/li/ul/li/ul/li">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicli3'"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="*[contains(@class,' topic/section ')]/ol/li/ul/li/ul/li">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicli3'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/dd ')]/ol/li/ul/li/ul/li">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicli3'"/>
        </xsl:call-template>
    </xsl:template>















    <!--    <xsl:template match="*[contains(@class,' topic/body ')]/ol/li/ol/li/ul/li" priority="5">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicli3'"/>
        </xsl:call-template>
    </xsl:template>-->
    <xsl:template match="*[contains(@class,' topic/section ')]/ol/li/ol/li/ul/li" priority="5">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicli3'"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="*[contains(@class,' topic/dd ')]/ol/li/ol/li/ul/li" priority="5">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicli3'"/>
        </xsl:call-template>
    </xsl:template>







    <xsl:template match="*[contains(@class,' topic/body ')]/ul/li/ol/li/ul/li" priority="5">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicli3'"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="*[contains(@class,' topic/section ')]/ul/li/ol/li/ul/li" priority="5">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicli3'"/>
        </xsl:call-template>
    </xsl:template>
    <xsl:template match="*[contains(@class,' topic/dd ')]/ul/li/ol/li/ul/li" priority="5">
        <xsl:apply-templates select="ancestor::*[not(name()='outputclass')]|node()" mode="identity"/>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicli3'"/>
        </xsl:call-template>
    </xsl:template>





    <!--  [@outputclass = 'ol_loweralpha']  -->



    <xsl:template match="ol[contains(@outputclass,'ol_loweralpha')]/li" priority="4">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'topiclinumloweralpha'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ol[contains(@outputclass,'ol_loweralpha')]/li/p[1]" priority="4">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topiclinumloweralpha'"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="ol[contains(@outputclass,'ol_loweralpha')]/li[1]/p[1]" priority="5">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'topiclinumloweralpha1'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ol[contains(@outputclass,'ol_loweralpha')]/li[1]" priority="5">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'topiclinumloweralpha1'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>









    <!--  [@outputclass = 'ol_upperalpha']  -->
    <xsl:template match="ol[contains(@outputclass,'ol_upperalpha')]/li" priority="4">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'topiclinumalpha'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ol[contains(@outputclass,'ol_upperalpha')]/li/p[1]" priority="4">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topiclinumalpha'"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="ol[contains(@outputclass,'ol_upperalpha')]/li[1]/p[1]" priority="5">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'topiclinumalpha1'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ol[contains(@outputclass,'ol_upperalpha')]/li[1]" priority="5">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'topiclinumalpha1'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--  [@outputclass = 'ol_lowerroman']  -->
    <xsl:template match="ol[contains(@outputclass,'ol_lowerroman')]/li" priority="4">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'topiclinumlowerroman'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ol[contains(@outputclass,'ol_lowerroman')]/li/p[1]" priority="4">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topiclinumlowerroman'"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="ol[contains(@outputclass,'ol_lowerroman')]/li[1]/p[1]" priority="5">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'topiclinumlowerroman1'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ol[contains(@outputclass,'ol_lowerroman')]/li[1]" priority="5">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'topiclinumlowerroman1'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--  [@outputclass = 'ol_upperroman']  -->
    <xsl:template match="ol[contains(@outputclass,'ol_upperroman')]/li" priority="4">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'topiclinumroman'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ol[contains(@outputclass,'ol_upperroman')]/li/p[1]" priority="4">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topiclinumroman'"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="ol[contains(@outputclass,'ol_upperroman')]/li[1]/p[1]" priority="5">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'topiclinumroman1'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ol[contains(@outputclass,'ol_upperroman')]/li[1]" priority="5">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'topiclinumroman1'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>





    <!--    <!-\- OUTLINE LISTS - 7 LEVELS   -\->
    
    <!-\-  [@outputclass = 'ol_outline']  -\->
<!-\-    Level 1 -\->-->
    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li" priority="4">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'outline1'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/p[1]" priority="4">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline1'"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li[1]/p[1]" priority="5">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'outline1'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/p" priority="3">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline1body'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ul/li" priority="4">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'outline1bullet'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ul/li/ul/li" priority="3">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline1bullet2'"/>
        </xsl:call-template>
    </xsl:template>






    <!--    Level 2 -->
    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ol/li" priority="4">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline2'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/p[1]" priority="4">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline2'"/>
        </xsl:call-template>
    </xsl:template>



    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/p" priority="3">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline2body'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ul/li" priority="4">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'outline2bullet'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ul/li/ul/li" priority="1">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline2bullet2'"/>
        </xsl:call-template>
    </xsl:template>


    <!--    Level 3 -->
    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li" priority="4">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline3'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/p[1]" priority="4">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline3'"/>
        </xsl:call-template>
    </xsl:template>



    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/p" priority="3">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline3body'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/ul/li" priority="4">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'outline3bullet'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/ul/li/ul/li"
        priority="1">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline3bullet2'"/>
        </xsl:call-template>
    </xsl:template>

    <!--    Level 4 -->
    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/ol/li" priority="4">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline4'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/ol/li/p[1]"
        priority="4">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline4'"/>
        </xsl:call-template>
    </xsl:template>



    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/ol/li/p"
        priority="3">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline4body'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/ol/li/ul/li"
        priority="4">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'outline4bullet'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/ol/li/ul/li/ul/li"
        priority="1">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline4bullet2'"/>
        </xsl:call-template>
    </xsl:template>



    <!--    Level 5 -->
    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/ol/li/ol/li"
        priority="4">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline5'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/ol/li/ol/li/p[1]"
        priority="4">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline5'"/>
        </xsl:call-template>
    </xsl:template>



    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/ol/li/ol/li/p"
        priority="3">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline5body'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/ol/li/ol/li/ul/li"
        priority="4">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'outline5bullet'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template
        match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/ol/li/ol/li/ul/li/ul/li"
        priority="1">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline5bullet2'"/>
        </xsl:call-template>
    </xsl:template>

    <!--    Level 6 -->
    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/ol/li/ol/li/ol/li"
        priority="4">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline6'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template
        match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/ol/li/ol/li/ol/li/p[1]"
        priority="4">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline6'"/>
        </xsl:call-template>
    </xsl:template>



    <xsl:template match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/ol/li/ol/li/ol/li/p"
        priority="3">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline6body'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template
        match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/ol/li/ol/li/ol/li/ul/li"
        priority="4">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline6bullet'"/>
        </xsl:call-template>

    </xsl:template>


    <xsl:template
        match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/ol/li/ol/li/ol/li/ul/li/ul/li"
        priority="1">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline6bullet2'"/>
        </xsl:call-template>
    </xsl:template>

    <!--    Level 7 -->
    <xsl:template
        match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/ol/li/ol/li/ol/li/ol/li"
        priority="4">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline7'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template
        match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/ol/li/ol/li/ol/li/ol/li/p[1]"
        priority="4">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline7'"/>
        </xsl:call-template>
    </xsl:template>



    <xsl:template
        match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/ol/li/ol/li/ol/li/ol/li/p"
        priority="3">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline7body'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template
        match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/ol/li/ol/li/ol/li/ol/li/ul/li"
        priority="4">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'outline7bullet'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template
        match="ol[contains(@outputclass,'ol_outline')]/li/ol/li/ol/li/ol/li/ol/li/ol/li/ol/li/ul/li/ul/li"
        priority="1">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'outline7bullet2'"/>
        </xsl:call-template>
    </xsl:template>





















    <xsl:template
        match="*[contains(@class,' task/info ')]/*[contains(@class,' topic/ul ')]/*[contains(@class,' topic/li ')]">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicli1'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/note ')]/*[contains(@class,' topic/p ')]"
        priority="5">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'notep'"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template match="*[contains(@class,' topic/note ')]">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'notep'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>


    <xsl:template match="*[contains(@class,' topic/note ')][contains(@othertype,'profnote')]">
        <Table Self="{generate-id}" HeaderRowCount="0" FooterRowCount="0" BodyRowCount="1"
            ColumnCount="2" AppliedTableStyle="TableStyle/ProfNote"
            TableDirection="LeftToRightDirection" SpaceBefore="14.666666666666666" SpaceAfter="-2">
            <Row Self="r{generate-id}" Name="0" SingleRowHeight="29.501000000000204"
                MinimumHeight="29.501000000000204"/>
            <Column Self="c{generate-id}" Name="0" SingleColumnWidth="41"/>
            <Column Self="c1{generate-id}" Name="1" SingleColumnWidth="354"/>
            <Cell Self="cell{generate-id}" Name="0:0" RowSpan="1" ColumnSpan="1"
                AppliedCellStyle="CellStyle/$ID/[None]" LeftInset="2" TopInset="2" RightInset="2"
                BottomInset="2" VerticalJustification="CenterAlign" LeftEdgeStrokeWeight="0"
                RightEdgeStrokeWeight="0" TopEdgeStrokeWeight="0" BottomEdgeStrokeWeight="0">
                <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/cell_head">
                    <CharacterStyleRange
                        AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                        <Rectangle Self="rect{generate-id}" ContentType="GraphicType"
                            StoryTitle="$ID/" AppliedObjectStyle="ObjectStyle/$ID/[None]"
                            Visible="true" Name="$ID/"
                            ItemTransform="1 0 0 1 18.280079999999998 -10.38992427246103">
                            <Properties>
                                <PathGeometry>
                                    <GeometryPathType PathOpen="false">
                                        <PathPointArray>
                                            <PathPointType
                                                Anchor="-18.280079999999998 -12.880079999999907"
                                                LeftDirection="-18.280079999999998 -12.880079999999907"
                                                RightDirection="-18.280079999999998 -12.880079999999907"/>
                                            <PathPointType
                                                Anchor="-18.280079999999998 10.38992427246103"
                                                LeftDirection="-18.280079999999998 10.38992427246103"
                                                RightDirection="-18.280079999999998 10.38992427246103"/>
                                            <PathPointType
                                                Anchor="16.279917558593752 10.38992427246103"
                                                LeftDirection="16.279917558593752 10.38992427246103"
                                                RightDirection="16.279917558593752 10.38992427246103"/>
                                            <PathPointType
                                                Anchor="16.279917558593752 -12.880079999999907"
                                                LeftDirection="16.279917558593752 -12.880079999999907"
                                                RightDirection="16.279917558593752 -12.880079999999907"
                                            />
                                        </PathPointArray>
                                    </GeometryPathType>
                                </PathGeometry>
                            </Properties>
                            <AnchoredObjectSetting PinPosition="false"/>
                            <TextWrapPreference Inverse="false" ApplyToMasterPageOnly="false"
                                TextWrapSide="BothSides" TextWrapMode="None">
                                <Properties>
                                    <TextWrapOffset Top="6" Left="6" Bottom="6" Right="6"/>
                                </Properties>
                                <ContourOption ContourType="SameAsClipping"
                                    IncludeInsideEdges="false" ContourPathName="$ID/"/>
                            </TextWrapPreference>
                            <PDF Self="u20cf" GrayVectorPolicy="IgnoreAll"
                                RGBVectorPolicy="HonorAllProfiles" CMYKVectorPolicy="IgnoreAll"
                                OverriddenPageItemProps="" LocalDisplaySetting="Default"
                                ImageTypeName="$ID/Adobe Portable Document Format (PDF)"
                                AppliedObjectStyle="ObjectStyle/$ID/[None]"
                                ItemTransform="1 0 0 1 -18.280079999999998 -12.880079999999907"
                                HorizontalLayoutConstraints="FlexibleDimension FixedDimension FlexibleDimension"
                                VerticalLayoutConstraints="FlexibleDimension FixedDimension FlexibleDimension"
                                Visible="true" Name="$ID/">
                                <Link Self="u3b8e" AssetURL="$ID/" AssetID="$ID/"
                                    LinkResourceFormat="$ID/Adobe Portable Document Format (PDF)"
                                    StoredState="Normal" LinkClassID="35906" LinkClientID="257">
                                    <xsl:attribute name="LinkResourceURI">
                                        <xsl:value-of
                                            select="concat('file://',$OUTPUTDIR,$SEPARATOR,'assets/2010icon.pdf')"
                                        />
                                    </xsl:attribute>
                                </Link>
                            </PDF>
                        </Rectangle>
                    </CharacterStyleRange>
                </ParagraphStyleRange>
            </Cell>
            <Cell Self="cell2{generate-id}" Name="1:0" RowSpan="1" ColumnSpan="1"
                AppliedCellStyle="CellStyle/$ID/[None]" LeftInset="2" TopInset="2" RightInset="2"
                BottomInset="2" LeftEdgeStrokeWeight="0" RightEdgeStrokeWeight="0"
                TopEdgeStrokeWeight="0" BottomEdgeStrokeWeight="0">
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'noteprof'"/>
                   <!-- <xsl:with-param name="prefix" select="concat('Professor’s Note:',$tab)"/>-->
                </xsl:call-template>
            </Cell>
        </Table>


    </xsl:template>


    <xsl:template match="sample[contains(@othertype,'example')]">
        <Table Self="{generate-id}" HeaderRowCount="0" FooterRowCount="0" BodyRowCount="1"
            ColumnCount="2" AppliedTableStyle="TableStyle/ProfNote"
            TableDirection="LeftToRightDirection" SpaceBefore="14.666666666666666" SpaceAfter="-2">
            <Row Self="r{generate-id}" Name="0" SingleRowHeight="29.501000000000204"
                MinimumHeight="29.501000000000204"/>
            <Column Self="c{generate-id}" Name="0" SingleColumnWidth="41"/>
            <Column Self="c1{generate-id}" Name="1" SingleColumnWidth="354"/>
            <Cell Self="cell{generate-id}" Name="0:0" RowSpan="1" ColumnSpan="1"
                AppliedCellStyle="CellStyle/$ID/[None]" LeftInset="2" TopInset="2" RightInset="2"
                BottomInset="2" VerticalJustification="CenterAlign" LeftEdgeStrokeWeight="0"
                RightEdgeStrokeWeight="0" TopEdgeStrokeWeight="0" BottomEdgeStrokeWeight="0">
                <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/cell_head">
                    <CharacterStyleRange
                        AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                        <Rectangle Self="rect{generate-id}" ContentType="GraphicType"
                            StoryTitle="$ID/" AppliedObjectStyle="ObjectStyle/$ID/[None]"
                            Visible="true" Name="$ID/"
                            ItemTransform="1 0 0 1 18.280079999999998 -25.12112427246103">
                            <Properties>
                                <PathGeometry>
                                    <GeometryPathType PathOpen="false">
                                        <PathPointArray>
                                            <PathPointType
                                                Anchor="-18.280079999999998 -12.880079999999907"
                                                LeftDirection="-18.280079999999998 -12.880079999999907"
                                                RightDirection="-18.280079999999998 -12.880079999999907"/>
                                            <PathPointType
                                                Anchor="-18.280079999999998 25.12112427246103"
                                                LeftDirection="-18.280079999999998 25.12112427246103"
                                                RightDirection="-18.280079999999998 25.12112427246103"/>
                                            <PathPointType
                                                Anchor="14.43671755859375 25.12112427246103"
                                                LeftDirection="14.43671755859375 25.12112427246103"
                                                RightDirection="14.43671755859375 25.12112427246103"/>
                                            <PathPointType
                                                Anchor="14.43671755859375 -12.880079999999907"
                                                LeftDirection="14.43671755859375 -12.880079999999907"
                                                RightDirection="14.43671755859375 -12.880079999999907"
                                            />
                                        </PathPointArray>
                                    </GeometryPathType>
                                </PathGeometry>
                            </Properties>
                            <AnchoredObjectSetting PinPosition="false"/>
                            <TextWrapPreference Inverse="false" ApplyToMasterPageOnly="false"
                                TextWrapSide="BothSides" TextWrapMode="None">
                                <Properties>
                                    <TextWrapOffset Top="6" Left="6" Bottom="6" Right="6"/>
                                </Properties>
                                <ContourOption ContourType="SameAsClipping"
                                    IncludeInsideEdges="false" ContourPathName="$ID/"/>
                            </TextWrapPreference>
                            <PDF Self="u20cf" GrayVectorPolicy="IgnoreAll"
                                RGBVectorPolicy="HonorAllProfiles" CMYKVectorPolicy="IgnoreAll"
                                OverriddenPageItemProps="" LocalDisplaySetting="Default"
                                ImageTypeName="$ID/Adobe Portable Document Format (PDF)"
                                AppliedObjectStyle="ObjectStyle/$ID/[None]"
                                ItemTransform="1 0 0 1 -18.280079999999998 -12.880079999999907"
                                HorizontalLayoutConstraints="FlexibleDimension FixedDimension FlexibleDimension"
                                VerticalLayoutConstraints="FlexibleDimension FixedDimension FlexibleDimension"
                                Visible="true" Name="$ID/">
                                <Link Self="u3b8e" AssetURL="$ID/" AssetID="$ID/"
                                    LinkResourceFormat="$ID/Adobe Portable Document Format (PDF)"
                                    StoredState="Normal" LinkClassID="35906" LinkClientID="257">
                                    <xsl:attribute name="LinkResourceURI">
                                        <xsl:value-of
                                            select="concat('file://',$OUTPUTDIR,$SEPARATOR,'assets/example_reduced.eps')"
                                        />
                                    </xsl:attribute>
                                </Link>
                            </PDF>
                        </Rectangle>
                    </CharacterStyleRange>
                </ParagraphStyleRange>
            </Cell>
            <Cell Self="cell2{generate-id}" Name="1:0" RowSpan="1" ColumnSpan="1"
                AppliedCellStyle="CellStyle/$ID/[None]" LeftInset="2" TopInset="2" RightInset="2"
                BottomInset="2" LeftEdgeStrokeWeight="0" RightEdgeStrokeWeight="0"
                TopEdgeStrokeWeight="0" BottomEdgeStrokeWeight="0">
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'noteprof'"/>
                    <!--<xsl:with-param name="prefix" select="concat('Professor’s Note:',$tab)"/>-->
                </xsl:call-template>
            </Cell>
        </Table>
        
        
    </xsl:template>



    <!-- in practice sample content -->
    
   <!-- <xsl:template match="sample" priority="50">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="label">
                    <xsl:value-of select="label"/>
                    <!-\- SP em space -\->
                    <xsl:text> </xsl:text>
                </xsl:variable>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'samplep1'"/>
                    <xsl:with-param name="prefix" select="concat($label, $tab)"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template match="sample/label" priority="50"/>
    
    <xsl:template match="sample/p[1]" priority="50">
        <xsl:variable name="label">
            <xsl:value-of select="../label"/>
            <!-\- SP em space -\->
            <xsl:text> </xsl:text>
        </xsl:variable>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'samplep1'"/>
            <xsl:with-param name="prefix" select="concat($label, $tab)"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template match="sample/p" priority="49">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'samplep'"/>
        </xsl:call-template>
    </xsl:template>-->

    <xsl:template match="sample/p[1]" priority="49">
        <xsl:choose>
            <xsl:when test="p[1]">
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'samplep1'"/>
                </xsl:call-template>
                
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'samplep'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>







































    <xsl:template
        match="*[contains(@class,' task/info ')]/*[contains(@class,' topic/note ')]/*[contains(@class,' topic/p ')]">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'notep1'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="info/note">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'notep1'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/lq ')]">
        <xsl:choose>
            <xsl:when test="p">
                <xsl:for-each select="p">
                    <xsl:call-template name="processpara">
                        <xsl:with-param name="ditaname" select="'lq'"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'lq'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" priority="-100">
        <xsl:message>Unmapped element...<xsl:value-of select="name()"/></xsl:message>
        <!--  <txsr prst="o_needsmap" crst="o_u4c7b">
            <pcnt>
                <xsl:text>c_</xsl:text>
                <xsl:apply-templates/>
            </pcnt>
        </txsr>-->
        <xsl:apply-templates/>
    </xsl:template>

    <!--SP text nodes -->

    <!-- process nodes inside character tags -->
    <xsl:template match="text()" mode="cstyleset">
        <xsl:param name="cstyle" select="'none'"/>
        <xsl:param name="suffix" select="''"/>
<!--        <xsl:variable name="appendspace">
            <xsl:call-template name="appendspace">
                <xsl:with-param name="nextitem"
                    select="following::node()[normalize-space() != ''][1]"/>
                <xsl:with-param name="nexttext"
                    select="following::text()[normalize-space() != ''][1]"/>
            </xsl:call-template>
        </xsl:variable>-->
        <xsl:variable name="appendspace">
            <xsl:call-template name="appendspace">
                <xsl:with-param name="nextitem" select="following::node()[1]" as="node()"/>
                <xsl:with-param name="nexttext"
                    select="following::text()[normalize-space() != ''][1]"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:if test="string-length(normalize-space()) &gt;= 1 ">
            <Content>
                <xsl:value-of select="normalize-space()"/>
                <xsl:value-of select="$suffix"/>
                <!-- need to make this conditional for certain character tags, especially subscript -->
                <xsl:if test="$appendspace = 'yes'">
                    <xsl:text> </xsl:text>
                </xsl:if>
            </Content>
        </xsl:if>
    </xsl:template>

    <xsl:template match="text()" mode="tm">
        <xsl:param name="cstyle" select="'none'"/>
        <xsl:param name="suffix" select="''"/>
        <xsl:variable name="appendspace">
            <xsl:call-template name="appendspace">
                <xsl:with-param name="nextitem"
                    select="following::node()[normalize-space() != ''][1]"/>
                <xsl:with-param name="nexttext"
                    select="following::text()[normalize-space() != ''][1]"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:if test="string-length(normalize-space()) &gt;= 1 ">
            <Content>
                <xsl:value-of select="normalize-space()"/>
            </Content>
        </xsl:if>
    </xsl:template>



    <xsl:template match="text()" mode="footnote">
        <xsl:if test="string-length(normalize-space()) &gt; 1">
            <Content>
                <xsl:processing-instruction name="ACE">4</xsl:processing-instruction>
                <xsl:text>.</xsl:text>
                <xsl:value-of select="$tab"/>
                <xsl:value-of select="normalize-space()"/>
            </Content>
        </xsl:if>
    </xsl:template>

    <!--SP if the text node is not just whitespace, process it.
    Strip out hair spaces (x200A)
   -->
    <!-- add in space at the end unless something drastic is next -->

    <xsl:template match="text()">
        <xsl:param name="suffix"/>
        <xsl:param name="suffix-last"/>
        <!-- select="''"-->

        <xsl:variable name="appendspace">
            <xsl:call-template name="appendspace">
                <xsl:with-param name="nextitem"
                    select="following::node()[normalize-space() != ''][1]"/>
                <xsl:with-param name="nexttext"
                    select="following::text()[normalize-space() != ''][1]"/>
            </xsl:call-template>
        </xsl:variable>


        <xsl:if test="string-length(normalize-space(translate(.,'&#x200A;',' '))) &gt; 0">

            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                <Content>
                    <xsl:value-of select="normalize-space()"/>
                    <xsl:if test="string-length($suffix) &gt; 0">
                        <xsl:value-of select="$suffix"/>
                    </xsl:if>
                    <xsl:if test="string-length($suffix-last) &gt; 0">
                        <xsl:value-of select="$suffix-last"/>
                    </xsl:if>
                    <xsl:if test="$appendspace = 'yes'">
                        <xsl:text> </xsl:text>
                    </xsl:if>
                </Content>
            </CharacterStyleRange>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/table ')]">
        <xsl:variable name="colcount" select="tgroup/@cols"/>
        <xsl:variable name="allcolwidths" select="tgroup/colspec/@colwidth"/>

        <Table TableDirection="LeftToRightDirection">
            <xsl:attribute name="Self" select="generate-id()"/>
            <xsl:attribute name="ColumnCount" select="$colcount"/>
            <xsl:attribute name="HeaderRowCount" select="count(tgroup/thead/row)"/>
            <xsl:attribute name="BodyRowCount" select="count(tgroup/tbody/row)"/>
            <xsl:attribute name="FooterRowCount" select="count(tgroup/tfoot/row)"/>
            <xsl:attribute name="AppliedTableStyle">TableStyle/ExampleTable</xsl:attribute>

            <xsl:variable name="tableid" select="generate-id()"/>

            <xsl:for-each select="tgroup/*/row">
                <xsl:variable name="rowcount" select="position() - 1"/>
                <Row Self="{$tableid}Row{$rowcount}" Name="{$rowcount}"/>
            </xsl:for-each>



            <xsl:call-template name="tablecols">
                <xsl:with-param name="colcount" select="$colcount"/>
                <xsl:with-param name="allcolwidths" select="$allcolwidths"/>
                <xsl:with-param name="colspec" select="$allcolwidths[$colcount+1]"/>
                <xsl:with-param name="defaultcolwidth" select="floor($pagewidth div $colcount)"/>
                <xsl:with-param name="tableid" select="$tableid"/>
            </xsl:call-template>

            <xsl:apply-templates/>
        </Table>
        <Br/>

    </xsl:template>

    <xsl:template name="tablecols">
        <xsl:param name="colcount"/>
        <xsl:param name="defaultcolwidth" as="xs:double"/>
        <xsl:param name="currentcol" select="0" as="xs:integer"/>
        <xsl:param name="colspec" select="0"/>
        <xsl:param name="allcolwidths"/>
        <xsl:param name="tableid"/>

        <Column Self="{$tableid}c{$currentcol}" Name="{$currentcol}">
            <xsl:attribute name="SingleColumnWidth">
                <xsl:choose>
                    <xsl:when test="string-length($allcolwidths[$currentcol]) &gt; 0">
                        <xsl:text>36</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$defaultcolwidth"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>

        </Column>

        <xsl:if test="$currentcol + 1 &lt; $colcount">
            <xsl:call-template name="tablecols">
                <xsl:with-param name="colcount" select="$colcount"/>
                <xsl:with-param name="defaultcolwidth" select="$defaultcolwidth "/>
                <xsl:with-param name="currentcol" select="$currentcol + 1" as="xs:integer"/>
                <xsl:with-param name="colspec" select="$allcolwidths[$currentcol + 1]"/>
                <xsl:with-param name="tableid" select="$tableid"/>
            </xsl:call-template>
        </xsl:if>

    </xsl:template>

    <!-- SP pass through table components that the weird InDesign table model doesn't need -->

    <xsl:template
        match="*[contains(@class,' topic/tbody ')] | *[contains(@class,' topic/thead ')] | *[contains(@class,' topic/tgroup ')] | *[contains(@class,' topic/row ')]">
        <xsl:apply-templates/>
    </xsl:template>

    <!-- SP The colspec could allow for setting the table width -->
    <xsl:template match="colspec"/>

    <xsl:template match="*[contains(@class,' topic/entry ')]">
        <Cell Self="{generate-id()}" RowSpan="1" ColumnSpan="1"
            AppliedCellStyle="CellStyle/$ID/[None]">
            <!-- SP this will probably fail if there is a footer -->
            <xsl:variable name="rowposition">
                <xsl:choose>
                    <xsl:when test="ancestor::thead">
                        <xsl:value-of select="count(../preceding-sibling::row)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of
                            select="count(../preceding-sibling::row) + count(../../../thead/row)"/>
                    </xsl:otherwise>
                </xsl:choose>

            </xsl:variable>

            <xsl:variable name="columnposition" select="count(preceding-sibling::entry)"/>
            <!-- specify row and column coordinates -->
            <xsl:attribute name="Name"><xsl:value-of select="$columnposition"/>:<xsl:value-of
                    select="$rowposition"/></xsl:attribute>
            <xsl:choose>

                <xsl:when test="ancestor-or-self::*[contains(@class,' topic/thead ')]">
                    <xsl:call-template name="processpara">
                        <xsl:with-param name="ditaname" select="'thead'"/>
                    </xsl:call-template>
                </xsl:when>

                <xsl:when test="child::p">
                    <xsl:apply-templates/>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:call-template name="processpara">
                        <xsl:with-param name="ditaname" select="'tbody'"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </Cell>
    </xsl:template>

    <!--PSB 9/10/15 Added list_unnumber_first and list_unnumber_next-->

    <xsl:template match="li/p[contains(@outputclass,'indent')]" priority="50">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'unnumli'"/>
        </xsl:call-template>
    </xsl:template>



    <xsl:template match="p[contains(@outputclass,'indent')]" priority="50">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'unnumli'"/>
        </xsl:call-template>
    </xsl:template>





    <!-- SP cmd is inline, but we need to pretend it's block -->
    <xsl:template match="steps/step[1]/cmd" priority="6">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicli1'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="steps/step/cmd" priority="5">
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'topicli'"/>
        </xsl:call-template>
    </xsl:template>

    <!--SP inline element processing -->

    <xsl:template match="*[contains(@class,' topic/ph ')]" priority="-50">
        <xsl:param name="suffix"/>
        <xsl:param name="suffix-last"/>
        <xsl:apply-templates>
            <xsl:with-param name="suffix" select="$suffix"/>
            <xsl:with-param name="suffix-last" select="$suffix-last"/>
        </xsl:apply-templates>

    </xsl:template>

    <xsl:template
        match="*[contains(@class,' hi-d/b ')] | *[contains(@class,' topic/term ')] | emphasisBold ">
        <xsl:param name="suffix"/>
        <xsl:choose>
            <xsl:when test="count(child::*) &gt; 0">
                <xsl:call-template name="handle_mixed_content">
                    <xsl:with-param name="suffix" select="$suffix"/>
                    <xsl:with-param name="cstyle" select="'b'"/>
                    <xsl:with-param name="appliedStyle" select="'CharacterStyle/bold'"/>
                </xsl:call-template>

            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="node()">
                    <xsl:choose>
                        <xsl:when test="ancestor::*[contains(@class,' learningBase/lcObjective ')]">
                            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/HEAD_c">
                                <xsl:apply-templates mode="cstyleset" select="self::text()">
                                    <xsl:with-param name="suffix" select="$suffix"/>
                                    <xsl:with-param name="cstyle" select="'b'"/>
                                </xsl:apply-templates>
                            </CharacterStyleRange>
                        </xsl:when>
                        <xsl:otherwise>
                            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/bold">
                                <xsl:apply-templates mode="cstyleset" select="self::text()">
                                    <xsl:with-param name="suffix" select="$suffix"/>
                                    <xsl:with-param name="cstyle" select="'b'"/>
                                </xsl:apply-templates>
                            </CharacterStyleRange>
                        </xsl:otherwise>
                    </xsl:choose>

                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        <!--        <xsl:choose>
            <xsl:when test="ancestor::callout">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                    <xsl:apply-templates mode="cstyleset" select="self::text()">
                        <xsl:with-param name="suffix" select="$suffix"/>
                        <xsl:with-param name="cstyle" select="'b'"/>
                    </xsl:apply-templates>
                </CharacterStyleRange>
            </xsl:when>
            <xsl:otherwise>
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/bold">
                    <xsl:apply-templates mode="cstyleset">
                        <xsl:with-param name="suffix" select="$suffix"/>
                        <xsl:with-param name="cstyle" select="'b'"/>
                    </xsl:apply-templates>
                </CharacterStyleRange>
            </xsl:otherwise>
        </xsl:choose>-->

        <!--        <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/bold">
            <xsl:apply-templates mode="cstyleset">
                <xsl:with-param name="suffix" select="$suffix"/>
                <xsl:with-param name="cstyle" select="'b'"/>
            </xsl:apply-templates>
        </CharacterStyleRange>-->

    </xsl:template>

    <xsl:template match=" table//b" priority="50">
        <!--callout/emphasisBold | callout/p/emphasisBold | callout/b | callout/p/b |-->
        <xsl:for-each select="node()">
            <xsl:choose>
                <xsl:when test="self::text()">
                    <CharacterStyleRange
                        AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                        <xsl:apply-templates mode="cstyleset" select="self::text()">
                            <xsl:with-param name="cstyle" select="'b'"/>
                        </xsl:apply-templates>
                    </CharacterStyleRange>
                </xsl:when>
                <xsl:when test="self::element()">
                    <xsl:apply-templates select="self::element()"/>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>

    </xsl:template>
    <!-- 7/24/2015 PSB: updated to include commandWord processing -->
    <xsl:template
        match="*[contains(@class,' hi-d/u ')] | *[contains(@class,' topic/sum ')] | commandWord">
        <xsl:choose>
            <xsl:when test="count(child::*) &gt; 0">

                <xsl:call-template name="handle_mixed_content">
                    <xsl:with-param name="cstyle" select="'u'"/>
                    <xsl:with-param name="appliedStyle" select="'underline'"/>
                </xsl:call-template>

            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="node()">

                    <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/underline">
                        <xsl:apply-templates mode="cstyleset">
                            <xsl:with-param name="cstyle" select="'u'"/>
                        </xsl:apply-templates>
                    </CharacterStyleRange>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        <!--        <xsl:choose>
            <xsl:when test="ancestor::callout">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                    <xsl:apply-templates mode="cstyleset" select="self::text()">
                        <xsl:with-param name="cstyle" select="'u'"/>
                    </xsl:apply-templates>
                </CharacterStyleRange>
            </xsl:when>
            <xsl:otherwise>
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/underline">
                    <xsl:apply-templates mode="cstyleset">
                        <xsl:with-param name="cstyle" select="'u'"/>
                    </xsl:apply-templates>
                </CharacterStyleRange>
            </xsl:otherwise>
        </xsl:choose>-->

        <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/underline">
            <xsl:apply-templates mode="cstyleset">
                <xsl:with-param name="cstyle" select="'u'"/>
            </xsl:apply-templates>
        </CharacterStyleRange>

    </xsl:template>

   






    <xsl:template match="*[contains(@class,' topic/total ')]">
        <!--        <xsl:choose>
            <xsl:when test="ancestor::callout">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                    <xsl:apply-templates mode="cstyleset" select="self::text()">
                        <xsl:with-param name="cstyle" select="'total'"/>
                    </xsl:apply-templates>
                </CharacterStyleRange>
            </xsl:when>
            <xsl:otherwise>
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/double_underline">
                    <xsl:apply-templates mode="cstyleset">
                        <xsl:with-param name="cstyle" select="'total'"/>
                    </xsl:apply-templates>
                </CharacterStyleRange>
            </xsl:otherwise>
        </xsl:choose>-->

        <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/double_underline">
            <xsl:apply-templates mode="cstyleset">
                <xsl:with-param name="cstyle" select="'total'"/>
            </xsl:apply-templates>
        </CharacterStyleRange>

    </xsl:template>

    <xsl:template match="*[contains(@class,' hi-d/sub ')]">
        <xsl:choose>
            <xsl:when test="count(child::*) &gt; 0">

                <xsl:call-template name="handle_mixed_content">
                    <xsl:with-param name="cstyle" select="'subscript'"/>
                    <xsl:with-param name="appliedStyle" select="'CharacterStyle/subscript'"/>
                </xsl:call-template>

            </xsl:when>
            <xsl:otherwise>

                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/subscript">
                    <xsl:apply-templates mode="cstyleset">
                        <xsl:with-param name="cstyle" select="'subscript'"/>
                    </xsl:apply-templates>
                </CharacterStyleRange>

            </xsl:otherwise>
        </xsl:choose>
        <!--        <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/Sub">
            <xsl:apply-templates mode="cstyleset">
                <xsl:with-param name="cstyle" select="'sub'"/>
            </xsl:apply-templates>
        </CharacterStyleRange>-->

    </xsl:template>

    <xsl:template match="*[contains(@class,' hi-d/sup ')]">
        <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/superscript">
            <xsl:apply-templates mode="cstyleset">
                <xsl:with-param name="cstyle" select="'superscript'"/>
            </xsl:apply-templates>
        </CharacterStyleRange>
    </xsl:template>

    <xsl:template
        match="*[contains(@class,' hi-d/i ')] | cite | legalCite | qualifier | emphasisItalics ">
        <xsl:choose>
            <xsl:when test="count(child::*) &gt; 0">

                <xsl:call-template name="handle_mixed_content">
                    <xsl:with-param name="cstyle" select="'i'"/>
                    <xsl:with-param name="appliedStyle" select="'CharacterStyle/italic'"/>
                </xsl:call-template>

            </xsl:when>
            <xsl:otherwise>

                <xsl:for-each select="node()">

                    <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/italic">
                        <xsl:apply-templates mode="cstyleset" select="self::text()">
                            <xsl:with-param name="cstyle" select="'i'"/>
                        </xsl:apply-templates>
                    </CharacterStyleRange>

                    <!-- JLCSP Commenting out sample_ital processing- this has been removed from the spec for IDv3 -->
                    <!--            <xsl:choose>
                <xsl:when test="ancestor::sample">
                    <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/sample_ital">
                        <xsl:apply-templates mode="cstyleset" select="self::text()">
                            <xsl:with-param name="cstyle" select="'i'"/>
                        </xsl:apply-templates>
                    </CharacterStyleRange>
                </xsl:when>
                <xsl:when test="self::text()">
                    <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/italic">
                        <xsl:apply-templates mode="cstyleset" select="self::text()">
                            <xsl:with-param name="cstyle" select="'i'"/>
                        </xsl:apply-templates>
                    </CharacterStyleRange>
                </xsl:when>
                <xsl:when test="self::element()">
                    <xsl:apply-templates select="self::element()"/>
                </xsl:when>
            </xsl:choose>-->
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>

    <!--    <xsl:template
        match="callout/i | callout/p/i | callout/emphasisItalics | callout/p/emphasisItalics | callout/term | callout/p/term | callout/cite |callout/p/cite | callout/legalCite | callout/p/legalCite | table//i | callout/qualifier | callout/p/qualifier "
        priority="50">
        <xsl:for-each select="node()">
            <xsl:choose>
                <xsl:when test="self::text()">
                    <CharacterStyleRange
                        AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                        <xsl:apply-templates mode="cstyleset" select="self::text()">
                            <xsl:with-param name="cstyle" select="'i'"/>
                        </xsl:apply-templates>
                    </CharacterStyleRange>
                </xsl:when>
                <xsl:when test="self::element()">
                    <xsl:apply-templates select="self::element()"/>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>

    </xsl:template>-->

    <!-- PSB added bold/italic and italic/bold-->
    <xsl:template match="i[.//b] | b[.//i]">
        <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/bold_italic">
            <xsl:apply-templates mode="cstyleset">
                <xsl:with-param name="cstyle" select="'bold_italic'"/>
            </xsl:apply-templates>
        </CharacterStyleRange>
    </xsl:template>

    <!-- PSB added underline/italic and italic/underline-->
    <xsl:template match="i[.//u] | u[.//i]">
        <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/italic_underline">
            <xsl:apply-templates mode="cstyleset">
                <xsl:with-param name="cstyle" select="'italic_underline'"/>
            </xsl:apply-templates>
        </CharacterStyleRange>
    </xsl:template>

    <!-- PSB added underline/bold and bold/underline-->
    <xsl:template match="b[.//*[contains(@class,' hi-d/u ')]] | *[contains(@class,' hi-d/u ')][.//b]">
        <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/bold_underline">
            <xsl:apply-templates mode="cstyleset">
                <xsl:with-param name="cstyle" select="'bold_underline'"/>
            </xsl:apply-templates>
        </CharacterStyleRange>
    </xsl:template>

<!--psb added outputclass="overline" -->
    <xsl:template match="ph[@outputclass = 'overline']">
        
        <xsl:choose>
            <xsl:when test="count(child::*) &gt; 0">
                
                <xsl:call-template name="handle_mixed_content">
                    <xsl:with-param name="cstyle" select="'overline'"/>
                    <xsl:with-param name="appliedStyle" select="'CharacterStyle/overline'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="node()">
                    <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/overline">
                        <xsl:apply-templates mode="cstyleset" select="self::text()">
                            <xsl:with-param name="cstyle" select="'overline'"/>
                        </xsl:apply-templates>
                    </CharacterStyleRange>
                    </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        <!--<CharacterStyleRange AppliedCharacterStyle="CharacterStyle/overline">
            <xsl:apply-templates mode="cstyleset">
                <xsl:with-param name="cstyle" select="'overline'"/>
            </xsl:apply-templates>
        </CharacterStyleRange>-->
    </xsl:template>

    <!--psb added outputclass="workbook" -->
    <xsl:template match="ph[@outputclass = 'workbook']">
        
        <xsl:choose>
            <xsl:when test="count(child::*) &gt; 0">
                
                <xsl:call-template name="handle_mixed_content">
                    <xsl:with-param name="cstyle" select="'instructor'"/>
                    <xsl:with-param name="appliedStyle" select="'CharacterStyle/instructor'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="node()">
                    <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/instructor">
                        <xsl:apply-templates mode="cstyleset" select="self::text()">
                            <xsl:with-param name="cstyle" select="'instructor'"/>
                        </xsl:apply-templates>
                    </CharacterStyleRange>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!--psb added outputclass="strike" -->
    <xsl:template match="ph[@outputclass = 'strike']">
        
        <xsl:choose>
            <xsl:when test="count(child::*) &gt; 0">
                
                <xsl:call-template name="handle_mixed_content">
                    <xsl:with-param name="cstyle" select="'strike'"/>
                    <xsl:with-param name="appliedStyle" select="'CharacterStyle/strike'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="node()">
                    <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/strike">
                        <xsl:apply-templates mode="cstyleset" select="self::text()">
                            <xsl:with-param name="cstyle" select="'strike'"/>
                        </xsl:apply-templates>
                    </CharacterStyleRange>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template name="appendspace">
        <xsl:param name="nextitem" select="''"/>
        <xsl:param name="nexttext" select="''"/>
        <xsl:choose>
            <xsl:when
                test="starts-with($nexttext,':') or starts-with($nexttext,',') or starts-with($nexttext,'.') or starts-with($nexttext,')') or starts-with($nexttext,'[') or starts-with($nexttext,']') or starts-with($nexttext,';') or starts-with($nexttext,'—') or starts-with($nexttext,'?') or starts-with($nexttext,'!')"
                >no</xsl:when>
            <xsl:when test="matches($nexttext, '[^ ]&lt;')"/>
            <xsl:when test="name($nextitem) = 'sub'">no</xsl:when>
            <xsl:when test="name($nextitem) = 'sup'">no</xsl:when>
                        <xsl:otherwise>yes</xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
    
    <p>This is a sentence with a word (<b>word</b> is bold).</p>
     <p>This is a sentence with a word (word is <b>bold</b>).</p>
    
    
    -->











    <!-- SP footnotes -->

    <xsl:template match="*[contains(@class,' topic/fn ')]">
        <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]"
            Position="Superscript">
            <Footnote>
                <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/footnote">
                    <CharacterStyleRange
                        AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                        <xsl:apply-templates mode="footnote"> </xsl:apply-templates>
                    </CharacterStyleRange>
                </ParagraphStyleRange>
            </Footnote>
        </CharacterStyleRange>
    </xsl:template>



    <!-- SP process xrefs- Commenting out the internals of the template since this is for print distribution -->
    <!-- SPJLC Adding a choose to add proper numbering to figure callouts -->

    <xsl:template match="xref">
        <xsl:choose>
            <xsl:when test="@type = 'fig'">
                <xsl:variable name="map" select="//opentopic:map"/>

                <!-- SPJLC Unit number variables for figure callouts -->

                <xsl:variable name="curunit"
                    select="ancestor::*[contains(@class,' kpe-concept/kpe-concept ') and @outputclass = 'topic_intro'][1]"/>
                <xsl:variable name="unitid" select="$curunit/@id"/>
                <xsl:variable name="unitloc" select="$map//*[$unitid = @id]"/>
                <xsl:variable name="unitnum"
                    select="count($unitloc/preceding-sibling::*[contains(@class,' bookmap/chapter ') and not(ancestor-or-self::*[contains(@class, ' bookmap/frontmatter ') or contains(@class, ' bookmap/backmatter ')])]) + 1"/>

                <!-- SPJLC Figure number variables for figure callouts -->
                <xsl:variable name="myhref" select="self::*/@href"/>
                <xsl:variable name="targetfig"
                    select="//*[contains(@class,' topic/fig ') and contains($myhref,@id)]"/>
                <xsl:variable name="fignum"
                    select="count($targetfig/preceding::*[contains(@class,' topic/fig ') and ancestor::*[@id = $unitid]]) + 1"/>

                <!-- Now build the figure label for the callout -->

                <xsl:variable name="figlabel" select="concat('Figure ',$unitnum,'.',$fignum,': ')"/>
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/Red">

                    <Content>
                        <xsl:value-of select="$figlabel"/>
                    </Content>

                </CharacterStyleRange>
                <xsl:apply-templates/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates/>
            </xsl:otherwise>
        </xsl:choose>

        <!--            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/Link">   
                <Content>
                <xsl:text> (</xsl:text>
        <xsl:value-of select="@href"/>
        <xsl:text>) </xsl:text>
                </Content>
            </CharacterStyleRange>  -->

    </xsl:template>

    <!--SP learning elements -->

    <xsl:template match="kpe-question" priority="20">
        <xsl:apply-templates/>
    </xsl:template>



    <xsl:template match="lcQuestion" priority="15">
        <xsl:variable name="prefix">

            <!-- SP need the preceding question in this assessment or question bank so as to count up the questions -->

            <xsl:number
                value="count(ancestor::*[contains(@class,' kpe-question/kpe-question ')][1]/preceding-sibling::*[contains(@class,' kpe-question/kpe-question ')]) + 1"
                format="1"/>
            <xsl:text>.</xsl:text>
        </xsl:variable>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'lcquestion'"/>
            <xsl:with-param name="prefix" select="concat($prefix,$tab)"/>
        </xsl:call-template>
    </xsl:template>


    <xsl:template
        match="learningAssessment 
                       | learningAssessmentBody
                       | lcInteraction
                       | lcAnswerOptionGroup
                       | lcAnswerOption
                       | lcSingleSelect
                       | lcSingleSelect2
                       | lcAnswerOptionGroup2
                       | lcAnswerOption2
                       "
        priority="20">
        <xsl:apply-templates/>
    </xsl:template>

    <!--SP Discard T/F answer section from True or False assessments-->

    <!--<xsl:template match="lcAnswerOptionGroup2[ancestor::kpe-assessmentOverview/title='True or False']" priority="50"/>-->

    <!--SP Build table for matching section-->
    <xsl:template match="lcInteraction/lcMatching2/lcMatchTable2" priority="50">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/$ID/[No paragraph style]">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                <Table Self="t{generate-id()}" HeaderRowCount="0" FooterRowCount="0"
                    BodyRowCount="1" ColumnCount="2"
                    AppliedTableStyle="TableStyle/$ID/[No table style]"
                    TableDirection="LeftToRightDirection">
                    <Row Self="t{generate-id()}row0" Name="0" MinimumHeight="3" AutoGrow="true"/>
                    <Column Self="t{generate-id()}Column0" Name="0" SingleColumnWidth="138"/>
                    <Column Self="t{generate-id()}Column1" Name="1" SingleColumnWidth="365"/>
                    <Cell Self="t{generate-id()}cell0" Name="0:0" RowSpan="1" ColumnSpan="1"
                        AppliedCellStyle="CellStyle/$ID/[None]" RightEdgeStrokeWeight="0.5"
                        TopEdgeStrokeWeight="0" BottomEdgeStrokeWeight="0" LeftEdgeStrokeWeight="0">
                        <xsl:apply-templates select="lcMatchingPair2/lcMatchingItem2">
                            <xsl:sort select="@id"/>
                        </xsl:apply-templates>
                    </Cell>
                    <Cell Self="t{generate-id()}cell1" Name="1:0" RowSpan="1" ColumnSpan="1"
                        AppliedCellStyle="CellStyle/$ID/[None]" AppliedCellStylePriority="0"
                        RightEdgeStrokeWeight="0" TopEdgeStrokeWeight="0" BottomEdgeStrokeWeight="0">
                        <xsl:apply-templates select="lcMatchingPair2/lcItem2"/>
                    </Cell>

                </Table>
            </CharacterStyleRange>
            <Br/>
        </ParagraphStyleRange>
    </xsl:template>

    <xsl:template match="lcMatchingItem2" priority="50">

        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'matchltr'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="lcItem2" priority="50">
        <xsl:choose>
            <xsl:when test="string-length()=0"/>
            <xsl:otherwise>
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'matchnum'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--SP Discard numbering for Matching section-->
<!--PSB Added numbering back in for lcQuestion2 in Matching -->
    <!--<xsl:template match="lcMatching2/lcQuestion2" priority="50"/>-->

    <!--SP discard answers in context -->
    <!-- PSB Added lcOpenAnswer2 7/28    -->
    <xsl:template
        match="lcFeedbackCorrect | lcFeedbackCorrect2 | lcCorrectResponse | lcCorrectResponse2 | lcOpenAnswer2"
        priority="20"/>






    <xsl:template name="selftestheader">
        <xsl:param name="heading"/>
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/KC_Header">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                <Table Self="u1d1i24aa" HeaderRowCount="0" FooterRowCount="0" BodyRowCount="1"
                    ColumnCount="1" AppliedTableStyle="TableStyle/$ID/[No table style]"
                    TableDirection="LeftToRightDirection" SpaceBefore="0" SpaceAfter="0"
                    StartRowFillColor="Color/PANTONE 307 U" EndRowFillColor="Color/PANTONE 307 U"
                    StartRowFillCount="2" EndRowFillCount="2" ColumnFillsPriority="false"
                    StartRowFillTint="100">
                    <Row Self="u1d1i24aaRow0" Name="0" SingleRowHeight="25.99992"
                        MinimumHeight="25.99992" AutoGrow="false"/>
                    <Column Self="u1d1i24aaColumn0" Name="0" SingleColumnWidth="530"/>
                    <Cell Self="u1d1i24aai0" Name="0:0" RowSpan="1" ColumnSpan="1"
                        AppliedCellStyle="CellStyle/$ID/[None]" AppliedCellStylePriority="0"
                        LeftInset="4" TopInset="6" RightInset="4" BottomInset="4"
                        FillColor="Color/PANTONE 307 U" FillTint="100" LeftEdgeStrokeWeight="0"
                        RightEdgeStrokeWeight="0" TopEdgeStrokeWeight="0" BottomEdgeStrokeWeight="0"
                        LeftEdgeStrokeColor="Swatch/None" TopEdgeStrokeColor="Swatch/None"
                        RightEdgeStrokeColor="Swatch/None" BottomEdgeStrokeColor="Swatch/None"
                        LeftEdgeStrokeType="StrokeStyle/$ID/ThinThin"
                        RightEdgeStrokeType="StrokeStyle/$ID/ThinThin"
                        TopEdgeStrokeType="StrokeStyle/$ID/ThinThin"
                        BottomEdgeStrokeType="StrokeStyle/$ID/ThinThin"
                        FirstBaselineOffset="CapHeight" VerticalJustification="CenterAlign"
                        LeftEdgeStrokePriority="5" RightEdgeStrokePriority="7"
                        TopEdgeStrokePriority="6" BottomEdgeStrokePriority="8">
                        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/KC_Header">
                            <CharacterStyleRange
                                AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                                <Content>
                                    <xsl:value-of select="$heading"/>
                                </Content>
                            </CharacterStyleRange>
                        </ParagraphStyleRange>
                    </Cell>
                </Table>
            </CharacterStyleRange>
            <Br/>
        </ParagraphStyleRange>
    </xsl:template>

    <!-- SP this template processes MathML equations. If there is no MathML element, just output the contents as text.-->
    <!--    PSB 9/9/15 COMMENTED OUT AND REPLACED WITH CODING BELOW-->
    <!--<xsl:template match="equation-block" priority="100">

        <xsl:choose>
            <xsl:when test="mathml">
                <xsl:if test="mathml/m:math/@altimg">
                    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/figure_inline">
                        <Rectangle ContentType="GraphicType"
                            HorizontalLayoutConstraints="FlexibleDimension FixedDimension FlexibleDimension"
                            VerticalLayoutConstraints="FlexibleDimension FixedDimension FlexibleDimension"
                            AppliedObjectStyle="ObjectStyle/$ID/[None]" Visible="true"
                            Name="{generate-id()}">
                            <Properties>
                                <PathGeometry>
                                    <GeometryPathType PathOpen="false">
                                        <PathPointArray>
                                            <PathPointType Anchor="-180 -36"
                                                LeftDirection="-180 -36" RightDirection="-180 -36"/>
                                            <PathPointType Anchor="-180 36" LeftDirection="-180 36"
                                                RightDirection="-180 36"/>
                                            <PathPointType Anchor="180 36" LeftDirection="180 36"
                                                RightDirection="180 36"/>
                                            <PathPointType Anchor="180 -36" LeftDirection="180 -36"
                                                RightDirection="180 -36"/>
                                        </PathPointArray>
                                    </GeometryPathType>
                                </PathGeometry>
                            </Properties>
                            <AnchoredObjectSetting AnchoredPosition="Anchored"
                                AnchorPoint="TopLeftAnchor"
                                HorizontalReferencePoint="AnchorLocation"
                                VerticalAlignment="TopAlign"/>
                            <TextWrapPreference Inverse="false" ApplyToMasterPageOnly="false"
                                TextWrapSide="BothSides" TextWrapMode="JumpObjectTextWrap">
                                <Properties>
                                    <TextWrapOffset Top="0" Left="0" Bottom="0" Right="0"/>
                                </Properties>
                                <ContourOption ContourType="SameAsClipping"
                                    IncludeInsideEdges="false" ContourPathName="$ID/"/>
                            </TextWrapPreference>

                            <Link Self="{generate-id()}">

                                <xsl:attribute name="LinkResourceURI">
                                    <xsl:value-of
                                        select="concat('file://',$OUTPUTDIR,$SEPARATOR,mathml/m:math/@altimg)"
                                    />
                                </xsl:attribute>
                            </Link>

                        </Rectangle>
                    </ParagraphStyleRange>
                    <Br/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="ancestor::sample">
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'example_formula'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>

                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'formula'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>


    </xsl:template>-->
    <!--PSB 9/4/15 Added this next whole section for equation-figure -->
    <xsl:template match="equation-block | equation-figure/equation-block" priority="100">

        <xsl:choose>
            <xsl:when test="mathml">
                <xsl:if test="mathml/m:math/@altimg">
                    <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/figure_inline">
                        <Rectangle ContentType="GraphicType"
                            HorizontalLayoutConstraints="FlexibleDimension FixedDimension FlexibleDimension"
                            VerticalLayoutConstraints="FlexibleDimension FixedDimension FlexibleDimension"
                            AppliedObjectStyle="ObjectStyle/$ID/[None]" Visible="true"
                            Name="{generate-id()}">
                            <Properties>
                                <PathGeometry>
                                    <GeometryPathType PathOpen="false">
                                        <PathPointArray>
                                            <PathPointType Anchor="-180 -36"
                                                LeftDirection="-180 -36" RightDirection="-180 -36"/>
                                            <PathPointType Anchor="-180 36" LeftDirection="-180 36"
                                                RightDirection="-180 36"/>
                                            <PathPointType Anchor="180 36" LeftDirection="180 36"
                                                RightDirection="180 36"/>
                                            <PathPointType Anchor="180 -36" LeftDirection="180 -36"
                                                RightDirection="180 -36"/>
                                        </PathPointArray>
                                    </GeometryPathType>
                                </PathGeometry>
                            </Properties>
                            <AnchoredObjectSetting AnchoredPosition="Anchored"
                                AnchorPoint="TopLeftAnchor"
                                HorizontalReferencePoint="AnchorLocation"
                                VerticalAlignment="TopAlign"/>
                            <TextWrapPreference Inverse="false" ApplyToMasterPageOnly="false"
                                TextWrapSide="BothSides" TextWrapMode="JumpObjectTextWrap">
                                <Properties>
                                    <TextWrapOffset Top="0" Left="0" Bottom="0" Right="0"/>
                                </Properties>
                                <ContourOption ContourType="SameAsClipping"
                                    IncludeInsideEdges="false" ContourPathName="$ID/"/>
                            </TextWrapPreference>

                            <Link Self="{generate-id()}">

                                <xsl:attribute name="LinkResourceURI">
                                    <xsl:value-of
                                        select="concat('file://',$OUTPUTDIR,$SEPARATOR,mathml/m:math/@altimg)"
                                    />
                                </xsl:attribute>
                            </Link>

                        </Rectangle>
                    </ParagraphStyleRange>
                    <Br/>
                </xsl:if>
            </xsl:when>
            <xsl:when test="ancestor::sample">
                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'example_formula'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>

                <xsl:call-template name="processpara">
                    <xsl:with-param name="ditaname" select="'formula'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>


    </xsl:template>




    <xsl:template match="equation-figure/p" priority="50">

        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'formula_where'"/>
        </xsl:call-template>
    </xsl:template>











    <xsl:template name="formulas">
        <xsl:for-each select="//*[@outputclass = 'equation']">
            <xsl:call-template name="processpara">
                <xsl:with-param name="ditaname" select="'formula'"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <!-- SP RE styles -->

    <xsl:template match="sli" priority="50">

        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="'sli'"/>
        </xsl:call-template>
    </xsl:template>


    <!--        <xsl:template match="glossentry" priority = "50">
        <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/glossary_term">
                <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/EM_gloss_term"> 
                    <Content>
                        <xsl:value-of select="glossterm/text()"/>
                        <xsl:text> </xsl:text>
                        <!-\- inserts an em space -\->
                    </Content>
                </CharacterStyleRange>
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]"> 
                <Content>
                    <xsl:value-of select="normalize-space(glossdef/text())"/>
                </Content>
            </CharacterStyleRange>
        <Br/>
        </ParagraphStyleRange>
    </xsl:template>-->

    <xsl:template match="lcOpenQuestion2">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="lcQuestion2" priority="20">
        <xsl:variable name="prefix">
            <xsl:number value="count(ancestor::lcInteraction/preceding-sibling::lcInteraction) + 1"
                format="1"/>
            <xsl:text>.</xsl:text>
        </xsl:variable>
        <xsl:variable name="ditaname">
            <xsl:choose>
                <xsl:when test="$prefix = '1.'">
                    <xsl:text>lcquestion21</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>lcquestion2</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:call-template name="processpara">
            <xsl:with-param name="ditaname" select="$ditaname"/>
            <!--   <xsl:with-param name="prefix" select="$prefix"/>-->
        </xsl:call-template>
    </xsl:template>


    <!--PSB DELETED 7/28/MOVED UP TO OTHER ANSWERS-->
    <!-- <xsl:template match="lcOpenAnswer2"/>-->


    <!-- SP trademark processing -->

    <xsl:template match="tm">
        <xsl:variable name="suffix">
            <xsl:choose>
                <xsl:when test="@tmtype = 'reg'">
                    <xsl:text>®</xsl:text>
                </xsl:when>
                <xsl:when test="@tmtype = 'service'">
                    <xsl:text>℠</xsl:text>
                </xsl:when>
                <xsl:when test="@tmtype = 'tm'">
                    <xsl:text>™</xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="appendspace">
            <xsl:call-template name="appendspace">
                <!--  PSB changed nextitem  was select="following::node()[1]" as="node()"             -->
                <xsl:with-param name="nextitem"
                    select="following::node()[normalize-space() != ''][1]"/>
                <xsl:with-param name="nexttext"
                    select="following::text()[normalize-space() != ''][1]"/>
            </xsl:call-template>
        </xsl:variable>
        <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
            <xsl:apply-templates mode="tm">
                <xsl:with-param name="suffix" select="$suffix"/>
            </xsl:apply-templates>
        </CharacterStyleRange>
        <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/superscript">
            <Content>
                <xsl:value-of select="$suffix"/>
            </Content>
        </CharacterStyleRange>
        <!-- need to make this conditional for certain character tags, especially subscript -->
        <xsl:if test="$appendspace = 'yes'">
            <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
                <Content>
                    <xsl:text> </xsl:text>
                </Content>

            </CharacterStyleRange>
        </xsl:if>

    </xsl:template>

    <!-- Working section for templates handling mixed content within character styles -->

    <xsl:template name="handle_mixed_content">
        <!-- MAIN ISSUE:
            Mixed content can contain three things:
            * text
            * inline elements
            * block mode elements
            Groups don't cut it because you can't create two different classes 
            of group and handle each as they come up.
            Best thing to do is gather the current set of nodes, then deal with them 
            in recursive routines that track inline or block mode.
            
        -->
        <xsl:param name="cstyle"/>
        <xsl:param name="appliedStyle"/>
        <xsl:param name="suffix"/>

        <xsl:variable name="nodes" select="node()"/>

        <xsl:variable name="node-map">
            <xsl:call-template name="build_node_map">
                <xsl:with-param name="nodes" select="$nodes"/>
            </xsl:call-template>
        </xsl:variable>

        <!--        <xsl:message>node-map is: <xsl:value-of select="$node-map"/>.</xsl:message>
        <xsl:message>starts with <xsl:value-of select="$nodes[1]"/>.</xsl:message>-->

        <xsl:call-template name="find_blocks_iterator">
            <xsl:with-param name="nodes" select="$nodes"/>
            <xsl:with-param name="node-map" select="$node-map"/>
            <xsl:with-param name="cstyle" select="$cstyle"/>
            <xsl:with-param name="appliedStyle" select="$appliedStyle"/>
            <xsl:with-param name="suffix" select="$suffix"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="build_node_map">
        <xsl:param name="nodes" as="node()*"/>

        <xsl:variable name="node" select="$nodes[1]"/>
        <xsl:choose>
            <xsl:when test="$node[self::text()]">
                <xsl:text>T</xsl:text>
            </xsl:when>
            <!-- This list is the total list of block mode elements that 
                 are legal in a topic/p, from the DITA 1.2 spec. -->
            <xsl:when
                test="
                $node[self::*[contains(@class,' topic/p ') 
                or contains(@class,' topic/dl ') 
                or contains(@class,' topic/fig ')
                or contains(@class,' topic/imagemap ')
                or (contains(@class,' topic/image ') and @placement='block' )
                or contains(@class,' topic/lines ')
                or contains(@class,' topic/lq ')
                or contains(@class,' topic/note ')
                or contains(@class,' topic/hazardstatement ')
                or contains(@class,' topic/object ') 
                or contains(@class,' topic/ol ')
                or contains(@class,' topic/pre ')
                or contains(@class,' topic/simpletable ')
                or contains(@class,' topic/sl ')
                or contains(@class,' topic/table ')
                or contains(@class,' topic/ul ')
                ]]">
                <xsl:text>B</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>I</xsl:text>
            </xsl:otherwise>
        </xsl:choose>


        <xsl:choose>
            <xsl:when test="count($nodes) &gt; 1">
                <xsl:call-template name="build_node_map">
                    <xsl:with-param name="nodes" select="$nodes[position() &gt; 1]"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>

    </xsl:template>

    <xsl:template name="find_blocks_iterator">
        <xsl:param name="nodes" as="node()*"/>
        <xsl:param name="node-map"/>
        <xsl:param name="cstyle"/>
        <xsl:param name="appliedStyle"/>
        <xsl:param name="suffix"/>

        <xsl:choose>
            <!-- End iteration on empty node-map. -->
            <xsl:when test="string-length($node-map) = 0">
                <!-- Just stop. -->
            </xsl:when>
            <!-- Found a text node, handle it and recurse -->
            <xsl:when test="starts-with($node-map,'T')">
                <CharacterStyleRange AppliedCharacterStyle="{$appliedStyle}">
                    <xsl:apply-templates mode="cstyleset" select="$nodes[1]">
                        <xsl:with-param name="cstyle" select="$cstyle"/>
                    </xsl:apply-templates>
                </CharacterStyleRange>
                <xsl:call-template name="find_blocks_iterator">
                    <xsl:with-param name="nodes" select="$nodes[position() &gt; 1]"/>
                    <xsl:with-param name="node-map" select="substring($node-map,2)"/>
                    <xsl:with-param name="cstyle" select="$cstyle"/>
                    <xsl:with-param name="appliedStyle" select="$appliedStyle"/>
                    <xsl:with-param name="suffix" select="$suffix"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="starts-with($node-map,'I')">
                <CharacterStyleRange AppliedCharacterStyle="{$appliedStyle}">
                    <xsl:apply-templates mode="cstyleset" select="$nodes[1]">
                        <xsl:with-param name="cstyle" select="$cstyle"/>
                    </xsl:apply-templates>
                </CharacterStyleRange>
                <xsl:call-template name="find_blocks_iterator">
                    <xsl:with-param name="nodes" select="$nodes[position() &gt; 1]"/>
                    <xsl:with-param name="node-map" select="substring($node-map,2)"/>
                    <xsl:with-param name="cstyle" select="$cstyle"/>
                    <xsl:with-param name="appliedStyle" select="$appliedStyle"/>
                    <xsl:with-param name="suffix" select="$suffix"/>
                </xsl:call-template>
            </xsl:when>
            <!-- Got a block mode element, handle it and recurse. -->
            <xsl:when test="starts-with($node-map,'B')">

                <CharacterStyleRange AppliedCharacterStyle="{$appliedStyle}">
                    <xsl:apply-templates mode="cstyleset" select="$nodes[1]">
                        <xsl:with-param name="cstyle" select="$cstyle"/>
                    </xsl:apply-templates>
                </CharacterStyleRange>
                <xsl:call-template name="find_blocks_iterator">
                    <xsl:with-param name="nodes" select="$nodes[position() &gt; 1]"/>
                    <xsl:with-param name="node-map" select="substring($node-map,2)"/>
                    <xsl:with-param name="cstyle" select="$cstyle"/>
                    <xsl:with-param name="appliedStyle" select="$appliedStyle"/>
                    <xsl:with-param name="suffix" select="$suffix"/>
                </xsl:call-template>
            </xsl:when>
            <!-- Handle inline elements... -->
            <xsl:otherwise>
                <!-- Get all nodes up to the next block-mode element 
                    (or the rest of the elements if there is no block-mode element).  -->
                <xsl:comment>In otherwise</xsl:comment>
                <xsl:variable name="before_b">
                    <xsl:choose>
                        <xsl:when test="contains($node-map,'B')">
                            <xsl:value-of select="substring-before($node-map,'B')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$node-map"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <!-- Get the number of nodes we're working with -->
                <xsl:variable name="inline_count" select="string-length($before_b)"/>

                <!-- Dereference the elements and process. -->

                <!-- Only important on elements that can contain mixed content. -->
                <!--                    <xsl:call-template name="get_style"/>-->

                <!-- The context is a node that can contain mixed content. -->
                <!--                    <xsl:apply-templates select="$nodes[position() &lt;= $inline_count]"
                        mode="handle_whitespace">
                        <xsl:with-param name="class" select="@class"/>
                        <xsl:with-param name="pos" select="position()"/>
                    </xsl:apply-templates>-->
                <xsl:apply-templates/>

                <!-- And iterate with the rest of the nodes. -->
                <xsl:call-template name="find_blocks_iterator">
                    <xsl:with-param name="nodes" select="$nodes[position() &gt; $inline_count]"/>
                    <xsl:with-param name="node-map" select="substring($node-map,$inline_count+1)"/>
                </xsl:call-template>

            </xsl:otherwise>

        </xsl:choose>

    </xsl:template>

    <!-- Set block-mode properties for w:p that contains mixed content. -->
    <!--   <xsl:template name="get_style">
        <xsl:choose>
            <xsl:when test="contains(parent::*/@class,' topic/ul ')">
                <w:pPr>
                    <xsl:choose>
                        <xsl:when
                            test="parent::*[ancestor::*[contains(@class,' topic/ul ')] and ancestor::*[contains(@class,' topic/table ')]]">
                            <w:pStyle w:val="TB2"> </w:pStyle>
                        </xsl:when>
                        <xsl:when test="ancestor::*[contains(@class,' topic/table ')]">
                            <w:pStyle w:val="TB1"> </w:pStyle>
                        </xsl:when>
                        <xsl:otherwise>
                            <w:pStyle w:val="B11"> </w:pStyle>
                        </xsl:otherwise>
                    </xsl:choose>
                </w:pPr>
            </xsl:when>
            <xsl:when test="contains(parent::*/@class,' topic/pre ')">
                <w:pPr>
                    <w:pStyle w:val="PL"/>
                    <w:keepNext/>
                    <w:rPr>
                        <w:b/>
                        <w:noProof w:val="0"/>
                    </w:rPr>
                </w:pPr>
            </xsl:when>
            <xsl:when test="ancestor::*[contains(@class,' topic/table ')]">
                <w:pPr>
                    <xsl:choose>
                        <xsl:when test="parent::*[contains(@class,' topic/table ')]">
                            <w:pStyle w:val="TH"/>
                        </xsl:when>
                        <xsl:when test="ancestor::*[contains(@class,' topic/thead ')]">
                            <w:pStyle w:val="TAH"/>
                        </xsl:when>
                        <xsl:when test="@align='left'">
                            <w:pStyle w:val="TAL"/>
                        </xsl:when>
                        <xsl:when test="@align='center'">
                            <w:pStyle w:val="TAC"/>
                        </xsl:when>
                        <xsl:when test="@align='right'">
                            <w:pStyle w:val="TAR"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <w:pStyle w:val="TAL"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </w:pPr>
                
            </xsl:when>
        </xsl:choose>
    </xsl:template>-->

</xsl:stylesheet>
