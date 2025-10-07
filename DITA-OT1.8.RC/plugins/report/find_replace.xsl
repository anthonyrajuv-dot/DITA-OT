<?xml version="1.0" encoding="UTF-8"?>
<!-- 
    Copyright 2001-2015 Syncro Soft SRL. All rights reserved.
    This is licensed under Oxygen XML Editor EULA (http://www.oxygenxml.com/eula.html).
    Redistribution and use outside Oxygen XML Editor is forbidden without express 
    written permission (contact e-mail address support@oxygenxml.com).
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:oxyd="http://www.oxygenxml.com/ns/dita">
    
    <!--    find xtrc and delete-->
    <xsl:template match="@xtrc" />
    <!--identity template copies everything forward by default-->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
