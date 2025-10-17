<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns:xhtml="http://www.w3.org/1999/xhtml"
   xmlns:saxon="http://icl.com/saxon" extension-element-prefixes="saxon">
   <xsl:import href="../../../xsl/common/output-message.xsl"/>
   <xsl:import href="../../../xsl/common/dita-utilities.xsl"/>

   <xsl:output method="text" encoding="UTF-8" indent="yes"/>

   <xsl:param name="BASE_DIR"/>
   <xsl:param name="out_dir"/>
   <xsl:param name="file.separator"/>

    <xsl:variable name="newline" select="'&#10;'"/>

   <xsl:variable name="msgprefix" select="'SPS'"/>

   <xsl:variable name="alpha_uc" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
   <xsl:variable name="alpha_lc" select="'abcdefghijklmnopqrstuvwxyz'"/>

   <xsl:template match="/">
      <xsl:apply-templates/>
   </xsl:template>

   <xsl:template match="map">
      <xsl:message>BASE_DIR is <xsl:value-of select="$BASE_DIR"/>.</xsl:message>
      <xsl:value-of select="$newline"/>
      <xsl:apply-templates/>
   </xsl:template>
   
   <xsl:template match="topicref">
      <xsl:variable name="source_filename" select="concat('file:///',$out_dir,@src_href)"/>
      <xsl:variable name="source_file" select="document($source_filename)"/>
      
      <xsl:message>Generating output for: <xsl:value-of select="$source_filename"/>.</xsl:message>
      <xsl:variable name="target_filename" select="concat('file:///',$out_dir,@href)"/>
            
      <xsl:result-document method="xhtml" indent="yes" encoding="UTF-8" href="{$target_filename}" 
         omit-xml-declaration="yes" 
         doctype-public="-//W3C//DTD XHTML 1.1//EN" 
         doctype-system="http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
  <!--       <!DOCTYPE html
  PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
  -->
         <xsl:apply-templates select="$source_file" mode="identity"/>
      </xsl:result-document>   
   </xsl:template>
   
   <!-- Identity transform to replicate content. -->
   <xsl:template match="@xhtml:*|@*|node()" mode="identity">
      <xsl:copy copy-namespaces="yes">
         <xsl:apply-templates select="@xhtml:*|@*|node()" mode="identity"/>
      </xsl:copy>
   </xsl:template>
   

</xsl:stylesheet>
