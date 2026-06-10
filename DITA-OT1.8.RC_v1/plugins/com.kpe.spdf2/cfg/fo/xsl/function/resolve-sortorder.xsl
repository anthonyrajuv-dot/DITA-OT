<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:utils="urn:utils"
  exclude-result-prefixes="xs utils">


  <xsl:param name="map" as="node()"/>

  <xsl:function name="utils:get-question-topicref" as="element()?">
    <xsl:param name="question" as="element()"/>

    <xsl:variable name="questionId" select="string($question/@id)"/>

    <xsl:sequence select="$map//*[contains(@class, ' map/topicref ')
      and @type = 'kpe-question' and (@id = $questionId or @href = concat('#', $questionId))][1]"/>
  </xsl:function>
  
  

  <xsl:function name="utils:get-question-sort-order" as="xs:integer">
    <xsl:param name="question" as="element()"/>

    <xsl:variable name="question-topicref" select="utils:get-question-topicref($question)"/>

    <xsl:variable name="sortOrder" select="normalize-space($question-topicref/*[local-name() = 'sortOrder'][1])"/>

    <xsl:sequence select="if ($sortOrder castable as xs:integer) then xs:integer($sortOrder)
      else 999999" />
  </xsl:function>


</xsl:stylesheet>
