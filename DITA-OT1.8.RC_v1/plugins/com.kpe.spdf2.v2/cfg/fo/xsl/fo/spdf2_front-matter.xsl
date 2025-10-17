<?xml version='1.0'?>

<!--
Copyright © 2012 by Scriptorium Publishing Services. All rights reserved.

   Some parts of this file were derived from the Idiom pdf2 plugin. 

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:opentopic="http://www.idiominc.com/opentopic"
    exclude-result-prefixes="opentopic" version="2.0">

    <!-- [SP] Override to eliminate trademarklist topic from processing. -->
    <xsl:template
        match="*[contains(@class, ' map/topicmeta ')][parent::*[contains(@class,' bookmap/trademarklist ')]]">
        <!-- Do nothing. -->
    </xsl:template>

    <!-- Override to eliminate topicmeta from willy-nilly processing. -->
    <xsl:template match="*[contains(@class, ' map/topicmeta ')]">
        <!-- Do nothing. -->
    </xsl:template>


<!--    <xsl:template name="createFrontMatter_old">
        <xsl:choose>
            <xsl:when test="$ditaVersion &gt;= 1.1">
                <xsl:call-template name="createFrontMatter_1.0"/>
            </xsl:when>
            <!-\- DITA 1.0 -\->
            <xsl:otherwise>
                <fo:page-sequence master-reference="front-matter"
                    xsl:use-attribute-sets="__force__page__count">
                    <xsl:call-template name="insertFrontMatterStaticContents"/>
                    <fo:flow flow-name="xsl-region-body">
                        <fo:block xsl:use-attribute-sets="__frontmatter">
                            <!-\- set the title -\->
                            <fo:block xsl:use-attribute-sets="__frontmatter__title">
                                <xsl:choose>
                                    <xsl:when test="//*[contains(@class,' bkinfo/bkinfo ')][1]">
                                        <xsl:apply-templates
                                            select="//*[contains(@class,' bkinfo/bkinfo ')][1]/*[contains(@class,' topic/title ')]/node()"
                                        />
                                    </xsl:when>
                                    <xsl:when test="//*[contains(@class, ' map/map ')]/@title">
                                        <xsl:value-of
                                            select="//*[contains(@class, ' map/map ')]/@title"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of
                                            select="/descendant::*[contains(@class, ' topic/topic ')][1]/*[contains(@class, ' topic/title ')]"
                                        />
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>

                            <!-\- set the subtitle -\->
                            <xsl:apply-templates
                                select="//*[contains(@class,' bkinfo/bkinfo ')][1]/*[contains(@class,' bkinfo/bktitlealts ')]/*[contains(@class,' bkinfo/bksubtitle ')]"/>

                            <fo:block xsl:use-attribute-sets="__frontmatter__owner">
                                <xsl:choose>
                                    <xsl:when test="//*[contains(@class,' bkinfo/bkowner ')]">
                                        <xsl:apply-templates
                                            select="//*[contains(@class,' bkinfo/bkowner ')]"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:apply-templates
                                            select="$map/*[contains(@class, ' map/topicmeta ')]"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:block>

                        </fo:block>

                        <!-\-<xsl:call-template name="createPreface"/>-\->

                    </fo:flow>
                </fo:page-sequence>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
-->
    <!-- [SP] Build the title page and trademark/copyright page. -->
    <xsl:template name="createFrontMatter">
        <fo:page-sequence master-reference="front-matter"
            xsl:use-attribute-sets="__force__page__count">
            <xsl:call-template name="insertFrontMatterStaticContents"/>

            <!-- [SP] Find the book metadata and prodinfo once. -->
            <xsl:variable name="bookmeta" select="//*[contains(@class,' bookmap/bookmeta ')][1]"/>

            <xsl:variable name="prodinfo"
                select="$bookmeta/*[contains(@class, ' topic/prodinfo ')][1]"/>

            <xsl:variable name="bookmeta" select="//*[contains(@class,' bookmap/bookmeta ')]"/>

            <fo:flow flow-name="xsl-region-body">
                <fo:block xsl:use-attribute-sets="__frontmatter">

                    <!-- set the title -->
                    <fo:block xsl:use-attribute-sets="__frontmatter__title">

                        <xsl:choose>
                            <xsl:when test="$map/*[contains(@class,' topic/title ')][1]">
                                <xsl:apply-templates
                                    select="$map/*[contains(@class,' topic/title ')][1]"/>
                            </xsl:when>
                            <xsl:when test="$map//*[contains(@class,' bookmap/mainbooktitle ')][1]">
                                <xsl:apply-templates
                                    select="$map//*[contains(@class,' bookmap/mainbooktitle ')][1]"
                                />
                            </xsl:when>
                            <xsl:when test="//*[contains(@class, ' map/map ')]/@title">
                                <xsl:value-of select="//*[contains(@class, ' map/map ')]/@title"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of
                                    select="/descendant::*[contains(@class, ' topic/topic ')][1]/*[contains(@class, ' topic/title ')]"
                                />
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:block>
                    <!-- Family (optional)-->
                    <xsl:variable name="family"
                        select="$prodinfo/*[contains(@class,' topic/component ')]"/>
                    <xsl:if test="$family != ''">
                        <fo:block xsl:use-attribute-sets="__frontmatter__title">
                            <xsl:value-of select="$family"/>
                        </fo:block>
                    </xsl:if>

                    <!-- Classification (optional)-->
                    <xsl:variable name="classification"
                        select="$prodinfo/*[contains(@class,' topic/series ')]"/>
                    <xsl:if test="$classification != ''">
                        <fo:block xsl:use-attribute-sets="__frontmatter__title">
                            <xsl:value-of select="$classification"/>
                        </fo:block>
                    </xsl:if>

                    <!-- Short description (optional)-->
                    <xsl:variable name="shortdesc"
                        select="$prodinfo/*[contains(@class,' topic/brand ')]"/>
                    <xsl:if test="$shortdesc != ''">
                        <fo:block xsl:use-attribute-sets="__frontmatter__title">
                            <xsl:value-of select="$shortdesc"/>
                        </fo:block>
                    </xsl:if>

                    <!-- Document type -->
                    <xsl:variable name="doctype"
                        select="//*[contains(@class,' bookmap/booktitle ')]/*[contains(@class,' bookmap/booklibrary ')]"/>
                    <xsl:if test="$doctype != ''">
                        <fo:block xsl:use-attribute-sets="__frontmatter__doctype">
                            <xsl:value-of select="$doctype"/>
                        </fo:block>
                    </xsl:if>


                    <!-- set the subtitle -->
                    <xsl:apply-templates select="$map//*[contains(@class,' bookmap/booktitlealt ')]"/>

                    <fo:block xsl:use-attribute-sets="__frontmatter__owner">
                        <xsl:apply-templates select="$map//*[contains(@class,' bookmap/bookmeta ')]"
                        />
                    </fo:block>

                    <!-- [SP] Use if there is a cover image. -->
                    <!--<xsl:call-template name="show-cover-image">
                        <xsl:with-param name="bookmeta" select="$bookmeta"/>
                    </xsl:call-template>-->
                </fo:block>

                <!--<xsl:call-template name="createCopyright"/>-->

                <!--<xsl:call-template name="createPreface"/>-->

            </fo:flow>
        </fo:page-sequence>
        <xsl:if test="not($retain-bookmap-order)">
            <xsl:call-template name="createNotices"/>
        </xsl:if>

    </xsl:template>

    <xsl:template name="show-cover-image">
        <xsl:param name="bookmeta"/>
        <xsl:variable name="cover_image"
            select="$bookmeta/*[contains(@class,' topic/data ')][@outputclass = 'cover_image']/*[contains(@class,' topic/image ')]/@href"/>
        <!-- If no cover image is defined, there's no need to insert it. -->
        <xsl:if test="$cover_image != ''">
            <xsl:variable name="cover_image_path" select="concat($input.dir.url, $cover_image)"/>
            <fo:float>
                <fo:block xsl:use-attribute-sets="cover_image">
                    <fo:external-graphic src="url({$cover_image_path})"
                        xsl:use-attribute-sets="image" content-width="250%"/>

                </fo:block>
            </fo:float>
        </xsl:if>
    </xsl:template>

    <!-- [SP] Scriptorium additions to create the copyright and trademark info on the second page. 
         The templates are modularized to make it easier to reorganize based on customer needs. -->

<!-- [SP] Commenting out all processing for p.ii 
          (copyright, trademark, etc.) -->

    <xsl:template name="createCopyright">
        <!-- Add a break to the flow to start on p.ii -->
        <fo:block break-after="page"/>

        <fo:block margin-top="1in">
            <!-- Use the templates or use the copyright-trademark-order variable. -->
            <!--
            <xsl:call-template name="showTitle"/>
            <xsl:call-template name="showCopyright"/>
            <xsl:call-template name="showEdition"/>
            <xsl:call-template name="showTrademarks"/>
            <xsl:call-template name="showAddress"/>
            <xsl:call-template name="showISBN"/>
            <xsl:call-template name="showRevisionHistory"/>
            -->
            <xsl:call-template name="display-copyright-trademark">
                <xsl:with-param name="copyright-trademark-order"
                    select="normalize-space($copyright-trademark-order)"/>
            </xsl:call-template>

            <!-- If you need to force something to the bottom of the page, put it in a footnote. -->
            <!-- <fo:footnote>
                <fo:inline/>
                <fo:footnote-body>
                    <xsl:call-template name="showPartNo"/>
                    <xsl:call-template name="showDate"/>
                </fo:footnote-body>
            </fo:footnote>-->
        </fo:block>
    </xsl:template>

    <!-- [SP] display the contents of the copyright/trademark page in the order specified
        by the copyright-trademark-order variable, specified in spdf2_basic-settings.xsl. -->
    <xsl:template name="display-copyright-trademark">
        <xsl:param name="copyright-trademark-order"/>
        <xsl:variable name="component" select="substring-before($copyright-trademark-order,';')"/>
        <xsl:variable name="component_norm" select="normalize-space($component)"/>

        <xsl:choose>
            <xsl:when test="$component_norm = 'Title'">
                <xsl:call-template name="showTitle"/>
            </xsl:when>
            <xsl:when test="$component_norm = 'Copyright'">
                <xsl:call-template name="showCopyright"/>
            </xsl:when>
            <xsl:when test="$component_norm = 'Edition'">
                <xsl:call-template name="showEdition"/>
            </xsl:when>
            <xsl:when test="$component_norm = 'Trademarks'">
                <xsl:call-template name="showTrademarks"/>
            </xsl:when>
            <xsl:when test="$component_norm = 'Address'">
                <xsl:call-template name="showAddress"/>
            </xsl:when>
            <xsl:when test="$component_norm = 'ISBN'">
                <xsl:call-template name="showISBN"/>
            </xsl:when>
            <xsl:when test="$component_norm = 'RevisionHistory'">
                <xsl:call-template name="showRevisionHistory"/>
            </xsl:when>
        </xsl:choose>
        <!-- Now recurse, as necessary. -->
        <xsl:choose>
            <xsl:when test="contains($copyright-trademark-order,';')">
                <xsl:call-template name="display-copyright-trademark">
                    <xsl:with-param name="copyright-trademark-order"
                        select="substring-after($copyright-trademark-order,';')"/>
                </xsl:call-template>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- Display the address from information in the bookmap metadata. -->
    <xsl:template name="showAddress">
        <!-- Get the organization info. The starting point for address info. -->
        <!-- 
            /bookmap//bookmeta[1]/authorinformation[1]/organizationinfo[1]/addressdetails[1]/administrativearea[1]
        /bookmap/*[namespace-uri()='http://www.idiominc.com/opentopic' and local-name()='map'][1]/bookmeta[1]/authorinformation[1]/organizationinfo[1]/addressdetails[1]/administrativearea[1]
        /bookmap/*[namespace-uri()='http://www.idiominc.com/opentopic' and local-name()='map'][1]/frontmatter[1]/booklists[1]/trademarklist[1]/topicmeta[1]/authorinformation[1]/organizationinfo[1]/addressdetails[1]/administrativearea[1]
        -->
        <xsl:variable name="org"
            select="$map/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' xnal-d/authorinformation ')]/*[contains(@class,' xnal-d/organizationinfo ')]"/>

        <xsl:if test="$org">
            <xsl:variable name="name" select="$org//*[contains(@class,' xnal-d/organizationname ')]"/>
            <!-- Get the address details component.-->
            <xsl:variable name="address"
                select="$org//*[contains(@class,' xnal-d/addressdetails ')]"/>
            <xsl:variable name="street"
                select="$address//*[contains(@class,' xnal-d/thoroughfare ')]"/>
            <xsl:variable name="locality" select="$address//*[contains(@class,' xnal-d/locality ')]"/>
            <xsl:variable name="city"
                select="$locality//*[contains(@class,' xnal-d/localityname ')]"/>
            <xsl:variable name="postcode"
                select="$locality//*[contains(@class,' xnal-d/postalcode ')]"/>
            <xsl:variable name="state"
                select="$address//*[contains(@class,' xnal-d/administrativearea ')]"/>
            <xsl:variable name="country" select="$address//*[contains(@class,' xnal-d/country ')]"/>
            <xsl:variable name="attn"
                select="$address//*[contains(@class,' topic/data ')][@name = 'attn']"/>

            <xsl:variable name="emailaddresses"
                select="$org/*[contains(@class,' xnal-d/emailaddresses ')]/*[contains(@class,' xnal-d/emailaddress ')]"/>
            <xsl:variable name="urls"
                select="$org/*[contains(@class,' xnal-d/urls ')]/*[contains(@class,' xnal-d/url ')]"/>

            <fo:block xsl:use-attribute-sets="pii_block">
                <fo:block xsl:use-attribute-sets="pii_para">
                    <xsl:call-template name="insertVariable">
                        <xsl:with-param name="theVariableID" select="'Contact intro'"/>
                    </xsl:call-template>
                </fo:block>
                <fo:block xsl:use-attribute-sets="pii_para">
                    <xsl:value-of select="$name"/>
                </fo:block>
                <fo:block xsl:use-attribute-sets="pii_para">
                    <xsl:value-of select="$street"/>
                </fo:block>
                <fo:block xsl:use-attribute-sets="pii_para">
                    <xsl:value-of select="$city"/>
                    <xsl:text>, </xsl:text>
                    <xsl:value-of select="$state"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$postcode"/>
                </fo:block>
                <fo:block xsl:use-attribute-sets="pii_para">
                    <xsl:value-of select="$country"/>
                </fo:block>
                <xsl:if test="$attn != ''">
                    <fo:block xsl:use-attribute-sets="pii_para"> Attn: <xsl:value-of select="$attn"
                        />
                    </fo:block>
                </xsl:if>
            </fo:block>
            <!-- Some subtlety: if there is a URL or e-mail address or both, put them 
                in a single block, but only 6pt below the address. -->
            <xsl:if test="count($emailaddresses) + count($urls) &gt; 0">
                <fo:block xsl:use-attribute-sets="pii_block" space-before="6pt">
                    <xsl:if test="count($emailaddresses) &gt; 0">
                        <xsl:apply-templates select="$emailaddresses" mode="copyright"/>
                    </xsl:if>
                    <xsl:if test="count($urls) &gt; 0">
                        <xsl:apply-templates select="$urls" mode="copyright"/>
                    </xsl:if>
                </fo:block>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*[contains(@class,' xnal-d/emailaddress ')]" mode="copyright">
        <xsl:variable name="email" select="."/>
        <!-- Cheat a little and add two points to the space before. -->
        <fo:block xsl:use-attribute-sets="pii_para">
            <fo:basic-link external-destination="url('{concat('mailto:',$email)}')">
                <xsl:value-of select="$email"/>
            </fo:basic-link>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class,' xnal-d/url ')]" mode="copyright">
        <xsl:variable name="url" select="."/>
        <xsl:variable name="url_with_protocol">
            <xsl:choose>
                <xsl:when test="starts-with($url,'http://')">
                    <xsl:value-of select="$url"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('http://',$url)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <fo:block xsl:use-attribute-sets="pii_para">
            <fo:basic-link external-destination="url('{$url_with_protocol}')">
                <xsl:value-of select="$url"/>
            </fo:basic-link>
        </fo:block>
    </xsl:template>

    <xsl:template name="showCopyright">
        <!-- Get the bookrights info. The starting point for copyright info. -->
        <xsl:variable name="rights" select="//*[contains(@class,' bookmap/bookrights ')]"/>
        <xsl:variable name="first_year"
            select="$rights//*[contains(@class,' bookmap/copyrfirst ')]/*[contains(@class,' bookmap/year ')]"/>
        <xsl:variable name="last_year"
            select="$rights//*[contains(@class,' bookmap/copyrlast ')]/*[contains(@class,' bookmap/year ')]"/>
        <xsl:variable name="owner"
            select="$rights//*[contains(@class,' bookmap/bookowner ')]/*[contains(@class,' bookmap/organization ')]"/>
        <xsl:variable name="em-dash">&#x2014;</xsl:variable>

        <xsl:variable name="year_set">
            <xsl:choose>
                <xsl:when test="$first_year = $last_year">
                    <xsl:value-of select="$first_year"/>
                </xsl:when>
                <xsl:when test="$last_year != ''">
                    <xsl:value-of select="concat($first_year,$em-dash,$last_year)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$first_year"/>
                </xsl:otherwise>
            </xsl:choose>

        </xsl:variable>

        <fo:block xsl:use-attribute-sets="pii_block">
            <fo:block xsl:use-attribute-sets="pii_para">
                <xsl:call-template name="insertVariable">
                    <xsl:with-param name="theVariableID" select="'Copyright statement'"/>
                    <xsl:with-param name="theParameters">
                        <year-set>
                            <xsl:value-of select="$year_set"/>
                        </year-set>
                        <owner>
                            <xsl:value-of select="$owner"/>
                        </owner>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:block>
    </xsl:template>

    <xsl:template name="showTitle">
        <xsl:variable name="booktitle" select="//*[contains(@class,' bookmap/booktitle ')][1]"/>
        <xsl:variable name="main" select="$booktitle//*[contains(@class,' bookmap/mainbooktitle ')]"/>
        <xsl:variable name="alt" select="$booktitle//*[contains(@class,' bookmap/booktitlealt ')]"/>

        <fo:block xsl:use-attribute-sets="pii_block">
            <fo:block xsl:use-attribute-sets="pii_para">
                <xsl:value-of select="concat($main,': ',$alt)"/>
            </fo:block>
        </fo:block>
    </xsl:template>

    <xsl:template name="showISBN">
        <xsl:variable name="bookid" select="//*[contains(@class,' bookmap/bookid ')]"/>
        <xsl:variable name="isbn" select="$bookid//*[contains(@class,' bookmap/isbn ')]"/>
        <xsl:if test="$isbn != ''">
        <fo:block xsl:use-attribute-sets="pii_block">
            <fo:block xsl:use-attribute-sets="pii_para">
                <xsl:value-of select="concat('ISBN: ',$isbn)"/>
            </fo:block>
        </fo:block>
        </xsl:if>
    </xsl:template>

    <xsl:template name="showEdition">
        <xsl:variable name="bookid" select="//*[contains(@class,' bookmap/bookid ')]"/>
        <xsl:variable name="edition" select="$bookid//*[contains(@class,' bookmap/edition ')]"/>

        <fo:block xsl:use-attribute-sets="pii_block">
            <fo:block xsl:use-attribute-sets="pii_para">
                <xsl:value-of select="$edition"/>
            </fo:block>
        </fo:block>
    </xsl:template>

    <xsl:template name="showTrademarks">
        <!-- [SP] Must get the ID of the trademark list topic from the bookmap in the merged file. -->
        <!-- [SP] Use the ID to locate the appropriate topic in the merged file. 
                  (We can't use the XSL id() function to locate the topic because the merged file doesn't have a DOCTYPE.)
        -->
        <xsl:variable name="trademarks_topic_id"
            select="//*[contains(@class,' bookmap/trademarklist ')][1]/@id"/>

        <xsl:variable name="trademarks_topic"
            select="//*[contains(@class,' topic/topic ') and @id=$trademarks_topic_id]"/>
        <fo:block xsl:use-attribute-sets="trademark_block" keep-together.within-column="always">
            <xsl:apply-templates
                select="$trademarks_topic/*[contains(@class,' topic/body ')]/*[contains(@class,' topic/p ')]"
                mode="trademarks"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/p ')]" mode="trademarks">
        <xsl:comment>Trademark para...</xsl:comment>
        <fo:block xsl:use-attribute-sets="trademark_para">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <!-- [SP] Insert a list-block containing the title for the revision history and a table containing the history. -->
    <xsl:template name="showRevisionHistory">
        <xsl:variable name="bookmeta" select="//*[contains(@class,' bookmap/bookmeta ')]"/>

        <xsl:variable name="vrmlist" select="$bookmeta//*[contains(@class,' topic/vrmlist ')]"/>

        <xsl:comment>Revision history...</xsl:comment>
        <fo:list-block>
            <fo:list-item space-before="{$level-1-space-before}">
                <fo:list-item-label>
                    <fo:block xsl:use-attribute-sets="topic.topic.title">
                        <fo:block xsl:use-attribute-sets="topic.topic.title__content"/>
                        <xsl:call-template name="insertVariable">
                            <xsl:with-param name="theVariableID" select="'revision_history_title'"/>
                        </xsl:call-template>
                    </fo:block>

                </fo:list-item-label>
                <fo:list-item-body keep-together.within-page="always">
                    <fo:block xsl:use-attribute-sets="pii_block">
                        <fo:block xsl:use-attribute-sets="pii_para">
                            <fo:block xsl:use-attribute-sets="table.title">
                                <xsl:call-template name="insertVariable">
                                    <xsl:with-param name="theVariableID"
                                        select="'revision_history_table'"/>
                                </xsl:call-template>

                            </fo:block>

                            <fo:table xsl:use-attribute-sets="table.tgroup">
                                <fo:table-column column-number="1"/>
                                <fo:table-column column-number="2"/>
                                <fo:table-column column-number="3"/>
                                <fo:table-column column-number="4"/>
                                <fo:table-header xsl:use-attribute-sets="tgroup.thead">
                                    <fo:table-row xsl:use-attribute-sets="thead.row">
                                        <fo:table-cell
                                            xsl:use-attribute-sets="table__tableframe__all">
                                            <fo:block-container>
                                                <fo:block xsl:use-attribute-sets="thead.row.entry">
                                                  <fo:block
                                                  xsl:use-attribute-sets="thead.row.entry__content">
                                                  <xsl:call-template name="insertVariable">
                                                  <xsl:with-param name="theVariableID"
                                                  select="'revision_history_date'"/>
                                                  </xsl:call-template>
                                                  </fo:block>
                                                </fo:block>
                                            </fo:block-container>
                                        </fo:table-cell>
                                        <fo:table-cell
                                            xsl:use-attribute-sets="table__tableframe__all">
                                            <fo:block-container>
                                                <fo:block xsl:use-attribute-sets="thead.row.entry">
                                                  <fo:block
                                                  xsl:use-attribute-sets="thead.row.entry__content">
                                                  <xsl:call-template name="insertVariable">
                                                  <xsl:with-param name="theVariableID"
                                                  select="'revision_history_page'"/>
                                                  </xsl:call-template>
                                                  </fo:block>
                                                </fo:block>
                                            </fo:block-container>
                                        </fo:table-cell>
                                        <fo:table-cell
                                            xsl:use-attribute-sets="table__tableframe__all">
                                            <fo:block-container>
                                                <fo:block xsl:use-attribute-sets="thead.row.entry">
                                                  <fo:block
                                                  xsl:use-attribute-sets="thead.row.entry__content">
                                                  <xsl:call-template name="insertVariable">
                                                  <xsl:with-param name="theVariableID"
                                                  select="'revision_history_changed'"/>
                                                  </xsl:call-template>
                                                  </fo:block>
                                                </fo:block>
                                            </fo:block-container>
                                        </fo:table-cell>
                                        <fo:table-cell
                                            xsl:use-attribute-sets="table__tableframe__all">
                                            <fo:block-container>
                                                <fo:block xsl:use-attribute-sets="thead.row.entry">
                                                  <fo:block
                                                  xsl:use-attribute-sets="thead.row.entry__content">
                                                  <xsl:call-template name="insertVariable">
                                                  <xsl:with-param name="theVariableID"
                                                  select="'revision_history_rev'"/>
                                                  </xsl:call-template>
                                                  </fo:block>
                                                </fo:block>
                                            </fo:block-container>
                                        </fo:table-cell>
                                    </fo:table-row>
                                </fo:table-header>
                                <fo:table-body xsl:use-attribute-sets="tgroup.tbody">
                                    <xsl:apply-templates
                                        select="$vrmlist/*[contains(@class,' topic/vrm')]"/>
                                </fo:table-body>
                            </fo:table>
                        </fo:block>
                    </fo:block>
                </fo:list-item-body>
            </fo:list-item>
        </fo:list-block>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/vrm ')]">
        <fo:table-row xsl:use-attribute-sets="tbody.row">
            <fo:table-cell xsl:use-attribute-sets="table__tableframe__all">
                <fo:block xsl:use-attribute-sets="tbody.row.entry">
                    <fo:block xsl:use-attribute-sets="tbody.row.entry__content">
                        <xsl:value-of select="@release"/>
                    </fo:block>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="table__tableframe__all">
                <fo:block xsl:use-attribute-sets="tbody.row.entry">
                    <fo:block xsl:use-attribute-sets="tbody.row.entry__content">
                        <xsl:choose>
                            <xsl:when test="@otherprops and @otherprops != ''">
                                <xsl:value-of select="@otherprops"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>—</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:block>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="table__tableframe__all">
                <fo:block xsl:use-attribute-sets="tbody.row.entry">
                    <fo:block xsl:use-attribute-sets="tbody.row.entry__content">
                        <xsl:value-of select="@modification"/>
                    </fo:block>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell xsl:use-attribute-sets="table__tableframe__all">
                <fo:block xsl:use-attribute-sets="tbody.row.entry">
                    <fo:block xsl:use-attribute-sets="tbody.row.entry__content">
                        <xsl:value-of select="@version"/>
                    </fo:block>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>


    </xsl:template>

    <xsl:template name="showPartNo">
        <xsl:variable name="bookmeta" select="//*[contains(@class,' bookmap/bookmeta ')]"/>
        <fo:block xsl:use-attribute-sets="pii_block">
            <fo:block xsl:use-attribute-sets="pii_para">
                <xsl:value-of select="$bookmeta//*[contains(@class,' bookmap/bookpartno ')]"/>
                <xsl:text> Rev </xsl:text>
                <xsl:value-of
                    select="$bookmeta//*[contains(@class,' topic/prodinfo ')]/*[contains(@class,' topic/vrmlist ')]/*[contains(@class,' topic/vrm ')][1]/@version"
                />
            </fo:block>
        </fo:block>
    </xsl:template>

    <xsl:template name="showDate">
        <xsl:variable name="bookmeta" select="//*[contains(@class,' bookmap/bookmeta ')]"/>
        <fo:block xsl:use-attribute-sets="pii_block">
            <fo:block xsl:use-attribute-sets="pii_para">
                <xsl:value-of
                    select="$bookmeta//*[contains(@class,' topic/prodinfo ')]/*[contains(@class,' topic/vrmlist ')]/*[contains(@class,' topic/vrm ')][1]/@release"
                />
            </fo:block>
        </fo:block>
    </xsl:template>


</xsl:stylesheet>
