<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.1">

    <xsl:output method="xml" indent="yes"/>

    <xsl:variable name="alpha_uc" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
    <xsl:variable name="alpha_lc" select="'abcdefghijklmnopqrstuvwxyz'"/>


    <xsl:template match="/">
        <xsl:apply-templates select="sps_index"/>
    </xsl:template>

    <xsl:template match="sps_index">
        <group_index>
            <!--<xsl:variable name="terms" select="indexterm"/>
            <xsl:call-template name="filter_terms">
                <xsl:with-param name="terms" select="$terms"/>
            </xsl:call-template>-->
            <xsl:apply-templates select="indexterm"/>
        </group_index>

    </xsl:template>

    <xsl:template name="filter_terms">
        <xsl:param name="terms"/>

        <xsl:variable name="this_text" select="text"/>

        <!--<xsl:message>Sibling count: <xsl:value-of select="count(parent::*/indexterm)"/></xsl:message>-->

        <!-- First do not continue if this term has preceding siblings with the same text -->
        <!-- Make sure we haven't used this one already -->
        <xsl:if test="count(preceding-sibling::indexterm[text=$this_text]) = 0">
            <group>
                <xsl:attribute name="sortstring">
                    <xsl:value-of select="@sortstring"/>
                </xsl:attribute>
                <text>
                    <xsl:value-of select="$this_text"/>
                </text>

                <!-- See if there are siblings with the same text string -->
                <xsl:variable name="same_text" select="parent::*/indexterm[text=$this_text]"/>

                <!--                <xsl:message>same_text has <xsl:value-of select="count($same_text)"/> members</xsl:message>
                <xsl:message><xsl:copy-of select="$same_text"/></xsl:message>
                
-->
                <xsl:choose>
                    <!-- There is only one item with this text, create an entry. -->
                    <xsl:when test="count($same_text) = 1">
                        <entry>
                            <xsl:call-template name="copy-sortstring"/>
                            <xsl:call-template name="copy-title"/>
                            <xsl:if test="@href">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="@href"/>
                                </xsl:attribute>
                            </xsl:if>
                        </entry>

                    </xsl:when>
                    <xsl:otherwise>
                        <!-- repeat the processs for subentries -->
                        <!-- Create a new set of indexterms -->
                        <xsl:variable name="new_set"
                            select="parent::*/indexterm[text=$this_text]/indexterm"/>
                        <!--                        <xsl:message>new_set has <xsl:value-of select="count($new_set)"/> members</xsl:message>
-->
                        <xsl:apply-templates select="$new_set"/>

                    </xsl:otherwise>
                </xsl:choose>

            </group>
        </xsl:if>

    </xsl:template>

    <xsl:template match="indexterm">

        <xsl:variable name="this_text" select="text"/>

        <!--        <xsl:message>Sibling count: <xsl:value-of select="count(parent::*/indexterm)"/></xsl:message>
-->
        <!-- First do not continue if this term has preceding siblings with the same text -->
        <!-- Make sure we haven't used this one already -->
        <xsl:if test="count(preceding-sibling::indexterm[text=$this_text]) = 0">
            <group>
                <xsl:attribute name="sortstring">
                    <xsl:value-of select="@sortstring"/>
                </xsl:attribute>
                <text>
                    <xsl:value-of select="$this_text"/>
                </text>

                <!-- See if there are siblings with the same text string -->
                <xsl:variable name="same_text" select="parent::*/indexterm[text=$this_text]"/>

                <!--                <xsl:message>same_text has <xsl:value-of select="count($same_text)"/> members</xsl:message>
                <xsl:message><xsl:copy-of select="$same_text"/></xsl:message>
-->

                <xsl:choose>
                    <!-- There is only one item with this text, create an entry. -->
                    <xsl:when test="count($same_text) = 1 and $same_text[not(indexterm)]">
                        <entry>
                            <xsl:call-template name="copy-sortstring"/>
                            <xsl:call-template name="copy-title"/>
                            <xsl:if test="@index-see">
                                <xsl:call-template name="copy-index-see"/>
                            </xsl:if>
                            <xsl:if test="@index-see-also">
                                <xsl:call-template name="copy-index-see-also"/>
                            </xsl:if>
                            <xsl:if test="@href">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="@href"/>
                                </xsl:attribute>
                            </xsl:if>
                        </entry>

                    </xsl:when>
                    <xsl:otherwise>
                        <!-- repeat the processs for subentries -->
                        <!-- Create a new set of indexterms -->
                        <xsl:variable name="new_set"
                            select="parent::*/indexterm[text=$this_text]/indexterm"/>
                        <!--<xsl:message>new_set has <xsl:value-of select="count($new_set)"/> members</xsl:message>-->

                        <xsl:if test="count($new_set) != 0">
                            <xsl:call-template name="handle_siblings">
                                <xsl:with-param name="set" select="$new_set"/>
                            </xsl:call-template>
                        </xsl:if>
                        <xsl:for-each select="parent::*/indexterm[text=$this_text][not(indexterm)]">
                            <entry>
                                <xsl:call-template name="copy-sortstring"/>
                                <xsl:call-template name="copy-title"/>
                                <xsl:if test="@index-see">
                                    <xsl:call-template name="copy-index-see"/>
                                </xsl:if>
                                <xsl:if test="@index-see-also">
                                    <xsl:call-template name="copy-index-see-also"/>
                                </xsl:if>
                                <xsl:if test="@href">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="@href"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </entry>

                        </xsl:for-each>

                    </xsl:otherwise>
                </xsl:choose>

            </group>
        </xsl:if>

    </xsl:template>

    <xsl:template name="handle_siblings">
        <xsl:param name="set"/>

        <!--        <xsl:message>Subsibling count: <xsl:value-of select="count($set)"/></xsl:message>
-->
        <!-- Create new group, all subsiblings have the same text and sortstring. -->
        <group>
            <xsl:attribute name="sortstring">
                <xsl:value-of select="$set[1]/@sortstring"/>
            </xsl:attribute>
            <!--<text><xsl:value-of select="$set[1]/text"/></text>-->

            <xsl:for-each select="$set">
                <xsl:variable name="this_text" select="text"/>
                <text>
                    <xsl:value-of select="$this_text"/>
                </text>
                <!-- look for nodes in the set -->
                <xsl:variable name="current" select="position()"/>
                <xsl:variable name="same_text"
                    select="$set[position()&gt;=$current][text=$this_text]"/>
                <xsl:variable name="prev_text"
                    select="$set[position()&lt;$current][text=$this_text]"/>

                <!--                <xsl:message>sub_same_text has <xsl:value-of select="count($same_text)"/> members</xsl:message>
                <xsl:message>text is <xsl:value-of select="$this_text"/></xsl:message>
                <xsl:message><xsl:copy-of select="$same_text"/></xsl:message>
                
-->
                <xsl:choose>
                    <xsl:when test="$same_text[not(indexterm)] and count($prev_text) = 0">
                        <entry>
                            <xsl:call-template name="copy-sortstring"/>
                            <xsl:call-template name="copy-title"/>
                            <xsl:if test="@index-see">
                                <xsl:call-template name="copy-index-see"/>
                            </xsl:if>
                            <xsl:if test="@index-see-also">
                                <xsl:call-template name="copy-index-see-also"/>
                            </xsl:if>
                            <xsl:if test="@href">
                                <xsl:attribute name="href">
                                    <xsl:value-of select="@href"/>
                                </xsl:attribute>
                            </xsl:if>
                        </entry>

                    </xsl:when>
                    <xsl:when test="$same_text/indexterm and count($prev_text) = 0">
                        <!-- repeat the processs for subentries -->
                        <!-- Create a new set of indexterms -->
                        <xsl:variable name="has_subs" select="$same_text/indexterm"/>

                        <xsl:if test="count($has_subs) != 0">
                            <xsl:call-template name="handle_siblings">
                                <xsl:with-param name="set" select="$has_subs"/>
                            </xsl:call-template>
                        </xsl:if>
                        <xsl:for-each select="$same_text[not(indexterm)]">
                            <entry>
                                <xsl:call-template name="copy-sortstring"/>
                                <xsl:call-template name="copy-title"/>
                                <xsl:if test="@index-see">
                                    <xsl:call-template name="copy-index-see"/>
                                </xsl:if>
                                <xsl:if test="@index-see-also">
                                    <xsl:call-template name="copy-index-see-also"/>
                                </xsl:if>
                                <xsl:if test="@href">
                                    <xsl:attribute name="href">
                                        <xsl:value-of select="@href"/>
                                    </xsl:attribute>
                                </xsl:if>
                            </entry>

                        </xsl:for-each>


                    </xsl:when>
                    <xsl:otherwise> </xsl:otherwise>
                </xsl:choose>

            </xsl:for-each>
        </group>



    </xsl:template>

    <xsl:template name="copy-sortstring">
        <xsl:attribute name="sortstring">
            <xsl:value-of select="@sortstring"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="copy-title">
        <xsl:attribute name="title">
            <xsl:value-of select="@title"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="copy-index-see">
        <xsl:attribute name="index-see">
            <xsl:value-of select="@index-see"/>
        </xsl:attribute>
    </xsl:template>
    <xsl:template name="copy-index-see-also">
        <xsl:attribute name="index-see-also">
            <xsl:value-of select="@index-see-also"/>
        </xsl:attribute>
    </xsl:template>


</xsl:stylesheet>
