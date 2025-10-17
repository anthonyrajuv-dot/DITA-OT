<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:functx="http://www.functx.com"
    xmlns:ditaarch="http://dita.oasis-open.org/architecture/2005/"    
    exclude-result-prefixes="xs functx ditaarch" version="2.0">
    
<!-- #### NEW TOPIC ###################################################################### -->
    <xsl:template match="/" mode="new_topic">
        <xsl:apply-templates select="*[contains(@class,' topic/topic ')]" mode="new_topic"/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' topic/topic ')]" mode="new_topic">
        <topic>
            <xsl:attribute name="id">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
            <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="new_tt_common"/>
            <prolog>
                <metadata>
                    <category><xsl:value-of select="descendant::taskCategory[1]"/></category>
                    <othermeta name="duration">
                        <xsl:attribute name="content">
                            <xsl:value-of select="descendant::duration[1]/@value"/>
                        </xsl:attribute>
                        
                    </othermeta>
                </metadata>
            </prolog>
            <body>
                <xsl:apply-templates 
                    select="*[contains(@class,' topic/body ')]/*[contains(@class,' topic/section ')]/node()" 
                    mode="identity"/>
            </body>
            
        </topic>
    </xsl:template>
    

<!-- #### NEW TASK ###################################################################### -->
    <xsl:template match="/" mode="new_task">
        <xsl:apply-templates select="*[contains(@class,' topic/topic ')]" mode="new_task"/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' topic/topic ')]" mode="new_task">
        <task>
            <xsl:attribute name="id">
                <xsl:value-of select="@id"/>
            </xsl:attribute>
            <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="new_tt_common"/>
            
        </task>
    </xsl:template>

    
    <!-- #### COMMON ###################################################################### -->
    <xsl:template match="*[contains(@class,' topic/title ')]" mode="new_tt_common">
        <title><xsl:apply-templates/></title>
    </xsl:template>
    
    <!-- Identity transform. -->
    <xsl:template match="@*|node()" mode="identity">
        <xsl:copy exclude-result-prefixes="#all">
            <xsl:apply-templates select="@*|node()" mode="identity"/>
        </xsl:copy>        
    </xsl:template>
    
    <!-- Deep six the bad attributes. -->
    <xsl:template match="@xtrf|@xtrc" mode="identity"/>
    <xsl:template match="@class" mode="identity"/>
    <xsl:template match="@ditaarch:DITAArchVersion"/>
<!--    <xsl:template match="namespace::*" mode="identity"/>-->
    
    
</xsl:stylesheet>