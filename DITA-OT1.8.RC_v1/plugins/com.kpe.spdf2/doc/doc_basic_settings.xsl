<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">
    
    <xsl:output method="xml" indent="yes" doctype-public="-//OASIS//DTD DITA Topic//EN" />
    
    <xsl:key 
        name  = "kPrecedingComment" 
        match = "comment()" 
        use   = "generate-id(following-sibling::*[1])" 
    />
    
    <xsl:template match="/">
        <xsl:call-template name="insert-doctype"/>
        <topic id="basic_settings">
            <title>Basic Settings Variables</title>
            <xsl:apply-templates select="xsl:stylesheet"/>
        </topic>
    </xsl:template>

    <xsl:template match="xsl:stylesheet">
        <body>
        <table colsep="1" rowsep="1">
            <tgroup cols="4">
                <colspec colnum="1" colname="c1" colwidth="1*"/>
                <colspec colnum="2" colname="c2" colwidth="2*"/>
                <colspec colnum="3" colname="c3" colwidth="3*"/>
                <colspec colnum="4" colname="c4" colwidth="3*"/>
                <thead>
                    <row>
                        <entry></entry>
                        <entry>Variable name</entry>
                        <entry>Current value</entry>
                        <entry>Your value</entry>
                    </row>
                </thead>
                <tbody>
                    <xsl:apply-templates select="processing-instruction()|xsl:variable"/>
                </tbody>
            </tgroup>
        </table>
        </body>
    </xsl:template>
    
    <xsl:template match="xsl:variable">
        <xsl:variable name="preceding_comment_1" select="key('kPrecedingComment', generate-id())[1]"/>
        <xsl:variable name="preceding_comment" select="preceding-sibling::comment()[generate-id(following-sibling::*[1]) = generate-id(current())][1]"/>
        <xsl:variable name="preceding_pi" select="preceding-sibling::processing-instruction()[generate-id(following-sibling::*[1]) = generate-id(current())][1]"/>

        <xsl:choose>
            <xsl:when test="name($preceding_pi) = 'sp_doc'">
                <row>
                    <entry></entry>
                    <entry><xsl:value-of select="@name"/></entry>
                    <entry>
                        <xsl:choose>
                            <xsl:when test="@select">
                                <xsl:value-of select="@select"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </entry>
                    <entry></entry>
                </row>
                
            </xsl:when>
            <xsl:when test="name(preceding-sibling::*[1]) = 'xsl:variable' and name(preceding-sibling::processing-instruction()[1]) != 'sp_nodoc'">
                <row>
                    <entry></entry>
                    <entry><xsl:value-of select="@name"/></entry>
                    <entry>
                        <xsl:choose>
                            <xsl:when test="@select">
                                <xsl:value-of select="@select"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </entry>
                    <entry></entry>
                </row>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="processing-instruction()">
        <xsl:choose>
            <xsl:when test="name() = 'sp_doc'">
                <row>
                    <entry namest="c1" nameend="c4">
                        <xsl:value-of select="." disable-output-escaping="yes"/>
                    </entry>
                </row>
            </xsl:when>
            <xsl:when test="name() = 'sp_head'">
                <row>
                    <entry namest="c1" nameend="c4">
                        <b><xsl:value-of select="." disable-output-escaping="yes"/></b>
                    </entry>
                </row>
            </xsl:when>
        </xsl:choose>
        
    </xsl:template>
    
    <xsl:template name="insert-doctype">
        <xsl:variable name="quote">"</xsl:variable>
        <xsl:variable name="public" select="concat($quote,'-//OASIS//DTD DITA Topic//EN',$quote)"/>
        <xsl:variable name="system" select="concat($quote,'topic.dtd',$quote)"/>
        <xsl:value-of select="concat('&#10;&lt;!DOCTYPE topic PUBLIC ',$public,' ',$system,' &gt;&#10;')" disable-output-escaping="yes"/>
    </xsl:template>
    
</xsl:stylesheet>