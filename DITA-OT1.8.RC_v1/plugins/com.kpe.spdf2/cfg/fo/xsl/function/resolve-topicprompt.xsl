<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:utils="urn:utils"
  exclude-result-prefixes="xs utils">


  <xsl:param name="map" as="node()"/>

  <xsl:function name="utils:get-all-topicrefs" as="element(topicref)*">
    <xsl:param name="map" as="node()"/>
    <xsl:variable name="directTopicrefs" select="$map//topicref[not(@format = 'ditamap')]"/>
    <xsl:variable name="submaps" as="document-node()*">
      <xsl:for-each select="$map//(topicref | mapref)[@format = 'ditamap']">
        <xsl:variable name="href" select="@href"/>
        <xsl:if test="unparsed-text-available($href)">
          <xsl:sequence select="document($href)"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <xsl:variable name="nestedTopicrefs" as="element(topicref)*">
      <xsl:for-each select="$submaps">
        <xsl:sequence select="utils:get-all-topicrefs(.)"/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:sequence select="$directTopicrefs, $nestedTopicrefs"/>
  </xsl:function>


</xsl:stylesheet>
