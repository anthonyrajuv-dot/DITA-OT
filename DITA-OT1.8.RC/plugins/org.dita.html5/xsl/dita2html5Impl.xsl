<?xml version="1.0" encoding="utf-8"?><!--
This file is part of the DITA Open Toolkit project.

Copyright 2016 Jarno Elovirta

See the accompanying LICENSE file for applicable license.
--><xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

  <xsl:import href="plugin:org.dita.base:xsl/common/output-message.xsl"></xsl:import>
  <xsl:import href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"></xsl:import>
  <xsl:import href="plugin:org.dita.base:xsl/common/related-links.xsl"></xsl:import>
  <xsl:import href="plugin:org.dita.base:xsl/common/dita-textonly.xsl"></xsl:import>
  
  <xsl:import href="topic.xsl"></xsl:import>
  <xsl:import href="concept.xsl"></xsl:import>
  <xsl:import href="task.xsl"></xsl:import>
  <xsl:import href="reference.xsl"></xsl:import>  
  <xsl:import href="ut-d.xsl"></xsl:import>
  <xsl:import href="sw-d.xsl"></xsl:import>
  <xsl:import href="pr-d.xsl"></xsl:import>
  <xsl:import href="ui-d.xsl"></xsl:import>
  <xsl:import href="hi-d.xsl"></xsl:import>
  <xsl:import href="abbrev-d.xsl"></xsl:import>
  <xsl:import href="markup-d.xsl"></xsl:import>
  <xsl:import href="xml-d.xsl"></xsl:import>
  
  <xsl:import href="nav.xsl"></xsl:import>
  
  <xsl:import href="htmlflag.xsl"></xsl:import>
    
  

  <!-- root rule -->
  <xsl:template match="/">
    <xsl:apply-templates></xsl:apply-templates>
  </xsl:template>
  
</xsl:stylesheet>