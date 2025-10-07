<?xml version="1.0" encoding="UTF-8"?>
<!--
    
Oxygen Webhelp plugin
Copyright (c) 1998-2015 Syncro Soft SRL, Romania.  All rights reserved.
Licensed under the terms stated in the license file EULA_Webhelp.txt 
available in the base directory of this Oxygen Webhelp plugin.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
          version="2.0">
  
  <!-- CSS that is set as Webhelp skin in the DITA Webhelp transform. -->
  <xsl:param name="WEBHELP_SKIN_CSS" select="''"/>
  
  <!-- Custom JavaScript code set by param webhelp.head.script -->
  <xsl:param name="WEBHELP_HEAD_SCRIPT" select="''"/>
    
  <!-- Custom JavaScript code set by param webhelp.body.script -->
  <xsl:param name="WEBHELP_BODY_SCRIPT" select="''"/>
    
  <xsl:param name="OUTEXT" select="'.html'"/>
    
  <!-- Oxygen version that created the WebHelp pages. -->
  <xsl:param name="WEBHELP_VERSION"/>
    
  <!-- Oxygen build number that created the WebHelp pages. -->
  <xsl:param name="WEBHELP_BUILD_NUMBER"/>
    
  <xsl:include href="../../feedback.xsl"/>
  
  <!-- 
    Generates the JS and CSS references in the head element of the HTML pages.            
  -->
  <xsl:template name="jsAndCSS">
    <xsl:param name="namespace" select="'http://www.w3.org/1999/xhtml'"/>
    
    <xsl:choose>
          <xsl:when test="contains($WEBHELP_VERSION, '$')">
              <xsl:comment>  Generated with Oxygen build number <xsl:value-of select="$WEBHELP_BUILD_NUMBER"/>.  </xsl:comment>
          </xsl:when>
          <xsl:otherwise>
              <xsl:comment>  Generated with Oxygen version <xsl:value-of select="$WEBHELP_VERSION"/>, build number <xsl:value-of select="$WEBHELP_BUILD_NUMBER"/>.  </xsl:comment>
          </xsl:otherwise>
    </xsl:choose>
      
    <xsl:element name="meta" namespace="{$namespace}">
      <xsl:attribute name="http-equiv">Content-Type</xsl:attribute>
      <xsl:attribute name="content">text/html; charset=utf-8</xsl:attribute>
    </xsl:element>

    <!-- CSS -->
    <xsl:element name="link" namespace="{$namespace}">
      <xsl:attribute name="rel">stylesheet</xsl:attribute>
      <xsl:attribute name="type">text/css</xsl:attribute>
      <xsl:attribute name="href">
        <xsl:value-of select="concat($PATH2PROJ, 'oxygen-webhelp/resources/css/webhelp_topic.css')"/>
      </xsl:attribute>
      <xsl:comment/>
    </xsl:element>
    <xsl:if test="string-length($WEBHELP_SKIN_CSS) > 0">
      <xsl:element name="link" namespace="{$namespace}">
        <xsl:attribute name="rel">stylesheet</xsl:attribute>
        <xsl:attribute name="type">text/css</xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="concat($PATH2PROJ, $WEBHELP_SKIN_CSS)"/>
        </xsl:attribute>
        <xsl:comment/>
      </xsl:element>
    </xsl:if>

    <xsl:if test="$IS_FEEDBACK_ENABLED">
      <xsl:element name="link" namespace="{$namespace}">
        <xsl:attribute name="rel">stylesheet</xsl:attribute>
        <xsl:attribute name="type">text/css</xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="concat($PATH2PROJ, 'oxygen-webhelp/resources/css/jquery.realperson.css')"/>
        </xsl:attribute>
        <xsl:comment/>
      </xsl:element>
      <xsl:element name="link" namespace="{$namespace}">
        <xsl:attribute name="rel">stylesheet</xsl:attribute>
        <xsl:attribute name="type">text/css</xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="concat($PATH2PROJ, 'oxygen-webhelp/resources/css/comments.css')"/>
        </xsl:attribute>
        <xsl:comment/>
      </xsl:element>
      <xsl:element name="link" namespace="{$namespace}">
        <xsl:attribute name="rel">stylesheet</xsl:attribute>
        <xsl:attribute name="type">text/css</xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="concat($PATH2PROJ, 'oxygen-webhelp/resources/css/jquery.cleditor.css')"/>
        </xsl:attribute>
        <xsl:comment/>
      </xsl:element>
      <xsl:element name="link" namespace="{$namespace}">
        <xsl:attribute name="rel">stylesheet</xsl:attribute>
        <xsl:attribute name="type">text/css</xsl:attribute>
        <xsl:attribute name="href">
          <xsl:value-of select="concat($PATH2PROJ, 'oxygen-webhelp/resources/css/admin.css')"/>
        </xsl:attribute>
        <xsl:comment/>
      </xsl:element>
    </xsl:if>

    <xsl:apply-templates 
      select="*[local-name() = 'link' 
      and @rel='stylesheet' 
      and not(contains(@href, 'commonltr.css'))
      and not(contains(@href, 'commonrtl.css'))]"
      mode="fixup_desktop"/>
    
    <!-- JS -->
    <!-- Generates the inline scripts. -->    
    <xsl:element name="script" namespace="{$namespace}">
      <xsl:attribute name="type">text/javascript</xsl:attribute>
      <xsl:comment>
        <xsl:text><![CDATA[
          
          var prefix = "]]></xsl:text>
        <xsl:value-of select="$PATH2PROJ"/>
        <xsl:text><![CDATA[index]]></xsl:text>
        <xsl:value-of select="$OUTEXT"/>
        <xsl:text><![CDATA[";
          
          ]]></xsl:text>
      </xsl:comment>
    </xsl:element>
    <!-- Generates the external script references. -->
    <xsl:element name="script" namespace="{$namespace}">
      <xsl:attribute name="type">text/javascript</xsl:attribute>
      <xsl:attribute name="src">
        <xsl:value-of select="concat($PATH2PROJ, 'oxygen-webhelp/resources/js/jquery-1.8.2.min.js')"/>
      </xsl:attribute>
      <xsl:comment/>
    </xsl:element>
    <xsl:element name="script" namespace="{$namespace}">
      <xsl:attribute name="type">text/javascript</xsl:attribute>
      <xsl:attribute name="src">
        <xsl:value-of select="concat($PATH2PROJ, 'oxygen-webhelp/resources/js/jquery.cookie.js')"/>
      </xsl:attribute>
      <xsl:comment/>
    </xsl:element>
    <xsl:element name="script" namespace="{$namespace}">
      <xsl:attribute name="type">text/javascript</xsl:attribute>
      <xsl:attribute name="src">
        <xsl:value-of select="concat($PATH2PROJ, 'oxygen-webhelp/resources/js/jquery-ui.custom.min.js')"/>
      </xsl:attribute>
      <xsl:comment/>
    </xsl:element>
    <xsl:element name="script" namespace="{$namespace}">
      <xsl:attribute name="type">text/javascript</xsl:attribute>
      <xsl:attribute name="src">
        <xsl:value-of select="concat($PATH2PROJ, 'oxygen-webhelp/resources/js/jquery.highlight-3.js')"/>
      </xsl:attribute>
      <xsl:comment/>
    </xsl:element>
    <xsl:if test="string-length($CUSTOM_RATE_PAGE_URL) > 0">
      <xsl:element name="script" namespace="{$namespace}">
        <xsl:attribute name="type">text/javascript</xsl:attribute>
        <xsl:attribute name="charset">utf-8</xsl:attribute>
        <xsl:attribute name="src">
          <xsl:value-of select="concat($PATH2PROJ, 'oxygen-webhelp/resources/js/rate_article.js')"/>
        </xsl:attribute>
        <xsl:comment/>
      </xsl:element>
    </xsl:if>
    <xsl:element name="script" namespace="{$namespace}">
      <xsl:attribute name="type">text/javascript</xsl:attribute>
      <xsl:attribute name="charset">utf-8</xsl:attribute>
      <xsl:attribute name="src">
        <xsl:value-of select="concat($PATH2PROJ, 'oxygen-webhelp/resources/js/webhelp_topic.js')"/>
      </xsl:attribute>
      <xsl:comment/>
    </xsl:element>
    <xsl:if test="$IS_FEEDBACK_ENABLED">      
      <xsl:element name="script" namespace="{$namespace}">
        <xsl:attribute name="type">text/javascript</xsl:attribute>
        <xsl:attribute name="charset">utf-8</xsl:attribute>
        <xsl:attribute name="src">
          <xsl:value-of select="concat($PATH2PROJ, 'oxygen-webhelp/resources/localization/strings.js')"/>
        </xsl:attribute>
        <xsl:comment/>
      </xsl:element>
      <xsl:element name="script" namespace="{$namespace}">
        <xsl:attribute name="type">text/javascript</xsl:attribute>
        <xsl:attribute name="charset">utf-8</xsl:attribute>
        <xsl:attribute name="src">
          <xsl:value-of select="concat($PATH2PROJ, 'oxygen-webhelp/resources/js/init.js')"/>
        </xsl:attribute>
        <xsl:comment/>
      </xsl:element>
      <xsl:element name="script" namespace="{$namespace}">
        <xsl:attribute name="type">text/javascript</xsl:attribute>
        <xsl:attribute name="charset">utf-8</xsl:attribute>
        <xsl:attribute name="src">
          <xsl:value-of select="concat($PATH2PROJ, 'oxygen-webhelp/resources/js/comments-functions.js')"/>
        </xsl:attribute>
        <xsl:comment/>
      </xsl:element>
    </xsl:if>
    <!-- Custom JavaScript code set by param webhelp.head.script -->
    <xsl:if test="string-length($WEBHELP_HEAD_SCRIPT) > 0" >
      <xsl:value-of select="unparsed-text($WEBHELP_HEAD_SCRIPT)" disable-output-escaping="yes"/>
    </xsl:if>
  </xsl:template>
    
  <xsl:template name="jsInBody">
    <!-- Custom JavaScript code set by param webhelp.body.script -->
      <xsl:if test="string-length($WEBHELP_BODY_SCRIPT) > 0">
        <xsl:value-of select="unparsed-text($WEBHELP_BODY_SCRIPT)" disable-output-escaping="yes"/>
      </xsl:if>
  </xsl:template>
</xsl:stylesheet>