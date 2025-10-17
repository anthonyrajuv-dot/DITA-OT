<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- [SP] Discard the initial map passed in to kick off the transform -->    
    <xsl:template match="*"/>
    
    <xsl:template match="/">
        <!-- [TODO] Add calls to templates to crawl bookmap for additional metadata -->
        <lom xmlns="http://ltsc.ieee.org/xsd/LOM"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <general>
                <identifier>
                    <catalog>TBD</catalog>
                    <entry>TBD</entry>
                </identifier>
                <title>
                    <string language="en-US">ACCA F1 FAB Tests</string>
                </title>
                <language>en</language>
                <description>
                    <string language="en-US">ACCA F1 FAB Tests</string>
                </description>
                <keyword>
                    <string language="en-US">accaf1fabts</string>
                </keyword>
            </general>
            <lifeCycle>
                <version>
                    <string language="en-US">1.0</string>
                </version>
                <status>
                    <source>LOMv1.0</source>
                    <value>final</value>
                </status>
            </lifeCycle>
            <metaMetadata>
                <identifier>
                    <catalog>TBD</catalog>
                    <entry>TBD</entry>
                </identifier>
                <metadataSchema>LOMv1.0</metadataSchema>
                <metadataSchema>ADLv1.0</metadataSchema>
                <language>en</language>
            </metaMetadata>
            <technical>
                <!-- [SP] Add handling here to flesh out existing MIME types -->
                <format>image/gif</format>
                <format>image/jpg</format>
                <format>application/x-shockwave-flash</format>
                <format>text/html</format>
                <location>./</location>
            </technical>
            <rights>
                <cost>
                    <source>LOMv1.0</source>
                    <value>no</value>
                </cost>
                <copyrightAndOtherRestrictions>
                    <source>LOMv1.0</source>
                    <value>yes</value>
                </copyrightAndOtherRestrictions>
                <description>
                    <string language="en-US">Kaplan, Inc. All rights reserved.</string>
                </description>
            </rights>
            <classification>
                <purpose>
                    <source>LOMv1.0</source>
                    <value>educational objective</value>
                </purpose>
                <description>
                    <string language="en-US">Learning Content</string>
                </description>
                <keyword>
                    <string language="en-US">accaf1fabts</string>
                </keyword>
            </classification>
        </lom>
    </xsl:template>
</xsl:stylesheet>