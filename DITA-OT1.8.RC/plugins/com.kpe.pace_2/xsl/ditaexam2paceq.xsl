<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output encoding="UTF-8" method="xml" indent="yes"  
        />
    
    <xsl:template match="/">
        <xsl:apply-templates select="*[contains(@class, ' bookmap/bookmap ')]"/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' map/map ')]">
        <xsl:variable name="overview" select="document(*[contains(@class,' map/topicref ')][1]/@href)"        
        
        
        <question>
            <xsl:apply-templates select="*[contains(@class,' map/title ')]"/>
            <prolog>
                <metadata>
                    
                </metadata>
                
            </prolog>
            
            
            <xsl:attribute name="title">
                <xsl:value-of select="$series"/>
            </xsl:attribute>
            <xsl:attribute name="id">
                <xsl:apply-templates 
                    select="$bookmeta/*[contains(@class,' bookmap/bookid ')][1]/*[contains(@class,' bookmap/bookpartno ')][1]"/>
            </xsl:attribute>
            
            <!-- Handle the contents of the map. -->
            <!-- This value is either 1 or 0. The number is used to calculate the Unit number. -->
            <xsl:variable name="navtitle" select="*[contains(@class,' bookmap/chapter ')][1]/*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]" as="element()*"/>
            <xsl:variable name="has_intro" as="xs:integer">
                <xsl:choose>
                    <xsl:when test="contains(lower-case($navtitle/text()),'introduction')">
                       <xsl:value-of select="1"/>  
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="0"/>                          
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:apply-templates select="*[contains(@class,' bookmap/chapter ')]">
                <xsl:with-param name="has_intro" select="$has_intro"/>
                <xsl:with-param name="name_base" select="concat($brand,'_',$series)"/>
            </xsl:apply-templates>
        </question>        
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' map/title ')]">
        <title><xsl:value-of select="concat('Unit ',.)"/></title>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' bookmap/chapter ')]">
        <xsl:param name="has_intro" as="xs:integer"/>
        <xsl:param name="name_base"/>
        
        <xsl:variable name="unit_number" select="count(preceding-sibling::*[contains(@class,' bookmap/chapter ')])  + (1 - $has_intro)" />
        
        <xsl:choose>
            <xsl:when test="$has_intro = 1 and $unit_number = 0">
                <topichead navtitle="Introduction">
                    <xsl:call-template name="handle_chapter">
                        <xsl:with-param name="name_base" select="concat($name_base,'_I1')"/>
                    </xsl:call-template>
                </topichead>        
            </xsl:when>
            <xsl:otherwise>
                <topichead>
                    <xsl:attribute name="navtitle">
                        <xsl:value-of select="concat('Unit ',$unit_number)"/>
                    </xsl:attribute>
                    <xsl:call-template name="handle_chapter">
                        <xsl:with-param name="name_base" select="concat($name_base,'_U',$unit_number)"/>
                    </xsl:call-template>
                </topichead>
                
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    <!-- Context is chapter. This template eliminates the need for duplicating code in 
        both of the <topichead> paths in the previous template. -->
    <xsl:template name="handle_chapter">
        <xsl:param name="name_base"/>
        
        <xsl:choose>
            <xsl:when test="@href and contains(@href,'ditamap')">
                <xsl:apply-templates select="document(@href)" mode="sub_map">
                    <xsl:with-param name="name_base" select="$name_base"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates>
                    <xsl:with-param name="name_base" select="$name_base"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' map/map ')]" mode="sub_map">
        <xsl:param name="name_base"/>
        <xsl:apply-templates select="*[contains(@class,' map/topicref ') and (not(@processing-role) or @processing-role != 'resource-only')]"
            mode="sub_map">
            <xsl:with-param name="name_base" select="$name_base"/>
        </xsl:apply-templates>
        
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' map/topicref ')]" mode="sub_map">
        <xsl:param name="name_base"/>
        
        <xsl:variable name="topic_number" select="count(preceding-sibling::*[contains(@class,' map/topicref ') and (not(@processing-role) or @processing-role != 'resource-only')]) + 1" />
        <topicref>
            <xsl:attribute name="href">
                <xsl:value-of select="concat('topics/',$name_base,'_TOPIC',$topic_number,'.dita')"/>
            </xsl:attribute>
            <xsl:attribute name="oldhref">
                <xsl:value-of select="@href"/>
            </xsl:attribute>
        </topicref>
    </xsl:template>
    
</xsl:stylesheet>