<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE xsl:stylesheet [

  <!ENTITY gt            "&gt;">
  <!ENTITY lt            "&lt;">
  <!ENTITY rbl           " ">
  <!ENTITY nbsp          "&#xA0;">    <!-- &#160; -->
  <!ENTITY quot          "&#34;">
  <!ENTITY copyr         "&#169;">  
]>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" use-character-maps="repl_chars"/>
    
    <xsl:character-map name="repl_chars">
        <!-- [SP] map registered char '®' to the appropriate HTML entity '&reg;' -->
        <xsl:output-character character="®" string="&#38;reg;"/>
    </xsl:character-map>
    
    <!-- [SP] match text() to make use of repl_chars -->
    <xsl:template match="text()">
        <xsl:value-of select="."/>        
    </xsl:template>
    
    
</xsl:stylesheet>