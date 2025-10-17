<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:date="http://exslt.org/dates-and-times">
    <!-- Scriptorium added xmlns:date="http://exslt.org/dates-and-times" to use date/time functions. -->
    <!--
    This file copyright by Suite Solutions, released under the same licenses as 
    the rest of the DITA Open Toolkit project hosted on Sourceforge.net.
    See the accompanying license.txt file for applicable licenses.
    
    This file is a collection of basic settings for the FO plugin.  There are many
    more settings available in other files in the toolkit.  Please see the file
    README.txt in the main plugin directory for more information.
-->
    <!-- %%%%%%%%%%%%%%%%% Initial Params %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->
    <!-- Values are COLLAPSED or EXPANDED. If a value is passed in from Ant, use that value. -->
    <xsl:param name="bookmarkStyle">
        <xsl:choose>
            <xsl:when test="$antArgsBookmarkStyle!=''">
                <xsl:value-of select="$antArgsBookmarkStyle"/>
            </xsl:when>
            <xsl:otherwise>COLLAPSED</xsl:otherwise>
        </xsl:choose>
    </xsl:param>
    
    <!-- Determine how to style topics referenced by <chapter>, <part>, etc. Values are:
         MINITOC: render with a MiniToc on left, content indented on right.
         BASIC: render the same way as any topic. -->
    <xsl:param name="chapterLayout">
        <xsl:choose>
            <xsl:when test="$antArgsChapterLayout!=''">
                <xsl:value-of select="$antArgsChapterLayout"/>
            </xsl:when>
            <!--      <xsl:otherwise>MINITOC</xsl:otherwise>-->
            <xsl:otherwise>BASIC</xsl:otherwise>
        </xsl:choose>
    </xsl:param>
    <xsl:param name="appendixLayout" select="$chapterLayout"/>
    <xsl:param name="partLayout" select="$chapterLayout"/>
    <xsl:param name="noticesLayout" select="$chapterLayout"/>
    
    
    <!-- %%%%%%%%%%%%%%%%% Proper variable definitions. %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% -->

    <!-- Scriptorium modified this setting to use US standard units for clarity in maintenance. -->
    
    <?sp_head Specify the basic page setup.?>
    <?sp_doc Physical page dimensions. ?>
    <xsl:variable name="page-width">8.5in</xsl:variable>
    <xsl:variable name="page-height">11in</xsl:variable>

    <?sp_doc Default margin (allows you to specify single, common value). You can set the margins individually below.   ?>
    <xsl:variable name="page-margins">0.5in</xsl:variable>

    <?sp_doc Specific margin values. Change these if your page has different margins on different sides. ?>
    <xsl:variable name="page-margin-inside">1in</xsl:variable>
    <xsl:variable name="page-margin-outside">0.5in</xsl:variable>
    <xsl:variable name="page-margin-top">0.75in</xsl:variable>
    <xsl:variable name="page-margin-bottom">0.75in</xsl:variable>
    
    <?sp_nodoc?>
    <!-- These are only here as legacy variables. They are not used, but it would be too 
        complex to try to remove them from transforms. -->
    <!-- Set to empty values, so they don't cause any problems. -->
    <xsl:variable name="page-margin-left"/>
    <xsl:variable name="page-margin-right"/>
    
    <?sp_doc Amount of extra vertical space to put at the beginning of a new chapter.  ?>
    <xsl:variable name="first-margin-top">0.75in</xsl:variable>
    
    <?sp_doc Specify behavior on last pages. Use the value 'blank' for last pages in the body to be blank.  ?>
    <xsl:variable name="last-page"></xsl:variable>
    
    <?sp_doc Display shortdesc at the beginning of topics. Set the value to 'no' to hide shortdescs.  ?>
    <xsl:variable name="show-shortdesc">no</xsl:variable>
    
    
<?sp_nodoc?>
    <!-- The column width in points (for calculations, so do not include units in value).  -->
    <!-- Calculation is page width, minus margins, times 72 points per inch. -->
    <xsl:variable name="page-width-no-units" select="substring-before($page-width,'in')"/>
    <xsl:variable name="page-margin-inside-no-units" select="substring-before($page-margin-inside,'in')"/>
    <xsl:variable name="page-margin-outside-no-units" select="substring-before($page-margin-outside,'in')"/>
    <xsl:variable name="column-width" select="($page-width-no-units - $page-margin-inside-no-units - $page-margin-outside-no-units) * 72"/> 
    
    <?sp_head Common font sizes ?>
    <?sp_doc Default font size. Used in most body elements.  ?>
    <xsl:variable name="default-font-size">11pt</xsl:variable>
    <xsl:variable name="default-line-height">13pt</xsl:variable>

    <?sp_doc Second-level font size. Used in tables, footnotes, etc.  ?>
    <xsl:variable name="secondary-font-size">10pt</xsl:variable>
    <xsl:variable name="secondary-line-height">12pt</xsl:variable>

    <?sp_doc Monospace font size. Needed because monospace fonts typically have larger x-heights than body fonts.  ?>
    <xsl:variable name="monospace-font-size">9pt</xsl:variable>
    <xsl:variable name="monospace-line-height">11pt</xsl:variable>
    
    <?sp_doc Copyright and trademark page font size. The trademark attribution statements are often dense legalese.  ?>
    <xsl:variable name="copyright-font-size">10pt</xsl:variable>
    <xsl:variable name="copyright-line-height">12pt</xsl:variable>

    <?sp_doc Common colors.  If you have common corporate colors that are used in text or rules, define them here. 
         (The two values given here are just for examples.)  ?>
    <xsl:variable name="purple">#604479</xsl:variable>
    <xsl:variable name="green">#3FC200</xsl:variable>
    
    
    <?sp_head Fonts for titles on front cover ?>    
    <?sp_doc Cover level-1 font aspects.  ?>    
    <xsl:variable name="cover-level-1-family">Sans</xsl:variable>
    <xsl:variable name="cover-level-1-size">22pt</xsl:variable>
    <xsl:variable name="cover-level-1-line-height">24pt</xsl:variable>
    <xsl:variable name="cover-level-1-weight">normal</xsl:variable>
    <xsl:variable name="cover-level-1-style">normal</xsl:variable>
    <xsl:variable name="cover-level-1-color">black</xsl:variable>

    <?sp_doc Cover level-2 font aspects.  ?>    
    <xsl:variable name="cover-level-2-family">Sans</xsl:variable>
    <xsl:variable name="cover-level-2-size">18pt</xsl:variable>
    <xsl:variable name="cover-level-2-line-height">20pt</xsl:variable>
    <xsl:variable name="cover-level-2-weight">normal</xsl:variable>
    <xsl:variable name="cover-level-2-style">normal</xsl:variable>
    <xsl:variable name="cover-level-2-color">black</xsl:variable>

    <?sp_doc Cover level-3 font aspects.  ?>    
    <xsl:variable name="cover-level-3-family">Sans</xsl:variable>
    <xsl:variable name="cover-level-3-size">14pt</xsl:variable>
    <xsl:variable name="cover-level-3-weight">normal</xsl:variable>
    <xsl:variable name="cover-level-3-style">normal</xsl:variable>
    <xsl:variable name="cover-level-3-color">black</xsl:variable>
    
    <?sp_doc Author information font aspects (optional).  ?>    
    <xsl:variable name="author-family">Sans</xsl:variable>
    <xsl:variable name="author-size">13pt</xsl:variable>
    <xsl:variable name="author-weight">normal</xsl:variable>
    <xsl:variable name="author-style">normal</xsl:variable>
    <xsl:variable name="author-color">black</xsl:variable>

    <?sp_doc Copyright statement font aspects.  ?>        
    <xsl:variable name="copyright-family">Sans</xsl:variable>
    <xsl:variable name="copyright-size">10pt</xsl:variable>
    <xsl:variable name="copyright-weight">normal</xsl:variable>
    <xsl:variable name="copyright-style">normal</xsl:variable>
    <xsl:variable name="copyright-color">black</xsl:variable>
    
    <?sp_doc Trademark statement font aspects.  ?>        
    <xsl:variable name="trademark-family">Sans</xsl:variable>
    <xsl:variable name="trademark-size">10pt</xsl:variable> 
    <xsl:variable name="trademark-weight">normal</xsl:variable>
    <xsl:variable name="trademark-style">normal</xsl:variable>
    <xsl:variable name="trademark-color">black</xsl:variable>
    <xsl:variable name="trademark-line-height">12pt</xsl:variable> 
    
    <?sp_head Describe the organization of the copyright and trademark page.  ?>
    <!-- The valid tokens are:
        
            Title - The title of the book
            Copyright - The copyright dates
            Edition - The edition information
            Trademarks - The trademark list.
            Address - The publisher address information
            ISBN - The book's ISBN
            RevisionHistory - The revision history (table)
            ProductVersion - The product and version
            Partno - The part number
            Date - The date

        All of these items are optional.   
        
        There must be a semi-colon after each token. 
        -->
    
    
    <?sp_doc Order of content on p.ii.  ?>
    <xsl:variable name="copyright-trademark-order">
        Partno;
        ProductVersion;
        Date;
        Copyright;
        Trademarks;
    </xsl:variable>
    
    <?sp_head Body column treadment (side-bar or not). ?>
    <!--Use this if you want a side bar down the left edge of the page.
        This value is used to calculate side-col-width and static-toc-indent. 
        The value, as used, is in points.
     -->
    
    <?sp_doc Side bar width (indent on left edge of body). If you don't want a side bar, specify 0.  ?>
    <xsl:variable name="side-bar-width">0</xsl:variable>

    <?sp_doc Specifies space between the right edge of a side head and the left edge of body (must have side bar).   ?>
    <xsl:variable name="side-bar-alley">0</xsl:variable>
    <!--The side column width is the amount the body text is indented relative to the margin.
      Measurements must be in POINTS (pt) -->
    <?sp_nodoc ?>
    <xsl:variable name="side-col-width" select="concat($side-bar-width,'pt')"/>

    <!-- Compute the right edge of the side-heads. -->
    <xsl:variable name="head-right-margin" select="concat($column-width - $side-bar-width + $side-bar-alley,'pt')"/>
    
    <?sp_doc  Specify the head styles for various level heads.  Use "block" for block-mode heads that have vertical
        space before and after. Use "run-in" for heads that are side-by-side with their first paragraph. ?>
    <xsl:variable name="level-1-head-style">block</xsl:variable>
    <xsl:variable name="level-2-head-style">block</xsl:variable>
    <xsl:variable name="level-3-head-style">block</xsl:variable>
    <xsl:variable name="level-4-head-style">block</xsl:variable>
    <xsl:variable name="level-5-head-style">block</xsl:variable>
    <xsl:variable name="level-6-head-style">block</xsl:variable>
    
    
    <?sp_doc Page layout for two-sided printing.  Set to true() for two-sided or false() for single-sided.  ?>
    <xsl:variable name="mirror-page-margins" select="false()"/>
    <!--    <xsl:variable name="mirror-page-margins" select="false()"/>-->
    

    <!-- Determine which links are included in the output. Added with RFE 2976463.
         none:     no links are included. This is the default, to match previous settings.
         all:      all links are included. If the original parameter $disableRelatedLinks 
                   is customized to "no", this is the default, to match previous settings.
         nofamily: excludes links with @role = parent, child, next, previous, ancestor, descendant, sibling, cousin.
    -->


    <!-- [SP] 05-Aug-2013: New in 1.8. -->
    <xsl:param name="includeRelatedLinkRoles" select="concat(' ', normalize-space($include.rellinks), ' ')"/>
    
    <!-- [SP] 05-Aug-2013: Removed for 1.8; causes crashes because antArgsIncludeRelatedLinks isn't defined. -->
    <!--<xsl:param name="includeRelatedLinks">
    <xsl:choose>
      <xsl:when test="$antArgsIncludeRelatedLinks!=''">
        <xsl:value-of select="$antArgsIncludeRelatedLinks"/>
      </xsl:when>
      <xsl:when test="$disableRelatedLinks='no'">all</xsl:when>
      <xsl:otherwise>none</xsl:otherwise>
    </xsl:choose>
  </xsl:param>-->

    <?sp_head Header and footer format controls ?>
    <!-- For no rule, change "solid" to "none". Other supported values are those for the border-style 
       attribute for XSL-FO. -->
    <!-- These are general controls, more specific values follow. -->
    <?sp_doc General values for running headers and footers.  ?>
    <xsl:variable name="headfoot-font-size">9pt</xsl:variable>
    <xsl:variable name="headfoot-font-family">Sans</xsl:variable>
    <xsl:variable name="headfoot-font-weight">normal</xsl:variable>
    <xsl:variable name="headfoot-font-style">normal</xsl:variable>
    
    <?sp_doc Specific values for running headers.  ?>
    <xsl:variable name="header-font-family">Sans</xsl:variable> 
    <xsl:variable name="header-font-size">10pt</xsl:variable> 
    <xsl:variable name="header-font-weight">bold</xsl:variable> 
    <xsl:variable name="header-font-style">normal</xsl:variable>
    <xsl:variable name="header-font-color">black</xsl:variable>
    <xsl:variable name="header-margin-top">0.5in</xsl:variable>
    <xsl:variable name="header-margin-left">0pt</xsl:variable>
    <xsl:variable name="header-text-to-rule">0pt</xsl:variable>
    <xsl:variable name="header-rule-to-body">0pt</xsl:variable>
    <xsl:variable name="header-rule-thickness">0.19pt</xsl:variable>
    <xsl:variable name="header-rule-style">solid</xsl:variable>
    <xsl:variable name="header-rule-color">black</xsl:variable>

    <?sp_doc Specific values for running footers.  ?>
    <xsl:variable name="footer-font-size">10pt</xsl:variable>
    <xsl:variable name="footer-font-family">Sans</xsl:variable>
    <xsl:variable name="footer-font-weight">normal</xsl:variable> 
    <xsl:variable name="footer-font-style">normal</xsl:variable> 
    <xsl:variable name="footer-font-color">#000000</xsl:variable>
    <xsl:variable name="footer-margin-left">0pt</xsl:variable>
    <xsl:variable name="footer-body-to-rule">0pt</xsl:variable>
    <xsl:variable name="footer-rule-to-text">9pt</xsl:variable>
    <xsl:variable name="footer-rule-thickness">1pt</xsl:variable>
    <xsl:variable name="footer-rule-style">solid</xsl:variable>
    <xsl:variable name="footer-rule-color">black</xsl:variable>

    <?sp_doc Location of header/footer icons. Leave empty if there is no icon. ?>
    <xsl:variable name="header-icon">
        <!--       <xsl:text>Customization/OpenTopic/common/artwork/header_artwork.png</xsl:text>-->
    </xsl:variable>
    <xsl:variable name="footer-icon">
        <!--       <xsl:text>Customization/OpenTopic/common/artwork/footer_artwork.png</xsl:text>-->
    </xsl:variable>
    
    <!-- Scriptorium added controls for whether the current system date and time appear in the footers.  
    Any value but yes for these variables will prevent the date or time from appearing in the footers.
  -->
    <?sp_doc Date and time in footers. Must specify 'yes' or 'no'. ?>
    <xsl:variable name="date-in-footers">no</xsl:variable>    
    <xsl:variable name="time-in-footers">no</xsl:variable>
    
    <!-- Setting folio-in-headers to anything but yes will prevent the 
       "Chapter #" or "Appendix #" label from appearing in the headers. -->

    <?sp_nodoc ?>
    <xsl:variable name="folio-in-headers">yes</xsl:variable>
    
    <!-- Scriptorium added variables to control Table of Contents fonts and indents. -->

    <!-- Override maximum TOC level.  This is set as a param in topic2fo.xsl. -->
    <?sp_doc Maximum depth of TOC. ?>
    <xsl:variable name="tocMaximumLevel">2</xsl:variable>

    <!-- The indent level of TOC entries is the sum of two values (measured in points).  
        One is the static-toc-indent, which is an amount that all entries get.
        The other component is the incremental-toc-indent, which is a value that is 
        multiplied by the heading level of the index entry.  

       For example, if a heading is at level 2, the total indent would be the static-toc-indent value plus two times the incremental-toc-indent.  
       Using the default values, below, of 18pt and 24pt, respectively, the total indent would be 18 + (24 X 2), or 66pt.  
       Note that chapter-level headings have a level of 0.  -->

    <?sp_nodoc ?>
    <xsl:variable name="static-toc-indent" select="$side-bar-width"/>
    <?sp_head Table of Contents ?>

    <?sp_doc Part entry in TOC. ?>
    
    <xsl:variable name="toc-part-space-above">3.6pt</xsl:variable>
    <xsl:variable name="toc-part-size">11pt</xsl:variable>
    <xsl:variable name="toc-part-color">black</xsl:variable>
    <xsl:variable name="toc-part-style">normal</xsl:variable>
    <xsl:variable name="toc-part-weight">normal</xsl:variable>
    
    <?sp_doc Chapter/Appendix entry in TOC. ?>
    <xsl:variable name="toc-chapter-space-above">6pt</xsl:variable>
    <xsl:variable name="toc-chapter-size">11.5pt</xsl:variable>
    <xsl:variable name="toc-chapter-style">normal</xsl:variable>
    <xsl:variable name="toc-chapter-weight">normal</xsl:variable>
    <xsl:variable name="toc-chapter-color">black</xsl:variable>

    <?sp_doc Level-1 entry in TOC. ?>
    <xsl:variable name="toc-level-1-space-above">0pt</xsl:variable>
    <xsl:variable name="toc-level-1-size">11.5pt</xsl:variable>
    <xsl:variable name="toc-level-1-weight">normal</xsl:variable>
    <xsl:variable name="toc-level-1-style">normal</xsl:variable>
    <xsl:variable name="toc-level-1-color">black</xsl:variable>
    
    <?sp_doc Level-2 entry in TOC. ?>
    <xsl:variable name="toc-level-2-space-above">0pt</xsl:variable>
    <xsl:variable name="toc-level-2-size">11.5pt</xsl:variable>
    <xsl:variable name="toc-level-2-weight">normal</xsl:variable>
    <xsl:variable name="toc-level-2-style">normal</xsl:variable>
    <xsl:variable name="toc-level-2-color">black</xsl:variable>
    
    <?sp_doc Amount of indent for subordinate TOC levels.  ?>
    

    <xsl:variable name="incremental-toc-indent">11</xsl:variable>
    <?sp_doc Length of the leader to the page number.  ?>
    <xsl:variable name="toc-leader-length">6pt</xsl:variable>

    <!-- Scriptorium: The value of the level-one-weight variable is restricted to the XSL-FO-standard values for the font-weight attribute:
       normal | bold | bolder | lighter | 100 | 200 | 300 | 400 | 500 | 600 | 700 | 800 | 900 | inherit
   
       Note that FOP does not currently (January 2011) support relative font weights.
  
       Reference http://www.w3.org/TR/xsl/ and http://xmlgraphics.apache.org/fop/compliance.html#fo-property-font-weight
  -->
<?sp_head Body page treatment. ?>
    <!-- Scriptorium added variables to specify the formatting of chapter/appendix titles and first-, second-, and third-level heads. -->

    <!-- Specify none or solid for rule. If you specify solid, rule displayed will have point size specified in next variable.-->
    <?sp_doc Border on chapter and appendix titles. ?>
    <xsl:variable name="chap-appx-border-style">solid</xsl:variable>
    <xsl:variable name="chap-appx-border-width">0.25pt</xsl:variable>
    <xsl:variable name="chap-appx-border-color">black</xsl:variable>

    <?sp_doc Border on part titles. ?>
    <xsl:variable name="part-border-style">none</xsl:variable>
    <xsl:variable name="part-border-width">0pt</xsl:variable>
    <xsl:variable name="part-border-color">white</xsl:variable>

    <?sp_doc Part word and number treatment. ?>
    <xsl:variable name="part-number-family">Sans</xsl:variable>
    <xsl:variable name="part-number-size">24pt</xsl:variable>
    <xsl:variable name="part-number-line-height">20pt</xsl:variable>
    <xsl:variable name="part-number-weight">normal</xsl:variable>
    <xsl:variable name="part-number-style">normal</xsl:variable>
    <xsl:variable name="part-number-color">Black</xsl:variable>
    
    <?sp_doc Formatting for the part title. ?>
    <xsl:variable name="part-title-family">Sans</xsl:variable>
    <xsl:variable name="part-title-size">24pt</xsl:variable>
    <xsl:variable name="part-title-line-height">20pt</xsl:variable>
    <xsl:variable name="part-title-weight">normal</xsl:variable>
    <xsl:variable name="part-title-style">normal</xsl:variable>
    <xsl:variable name="part-title-color">Black</xsl:variable>
    
    <?sp_doc Formatting for the chapter number. ?>
    <xsl:variable name="chap-appx-number-family">Sans</xsl:variable>
    <xsl:variable name="chap-appx-number-size">22pt</xsl:variable>
    <xsl:variable name="chap-appx-number-line-height">20pt</xsl:variable>
    <xsl:variable name="chap-appx-number-weight">normal</xsl:variable>
    <xsl:variable name="chap-appx-number-style">normal</xsl:variable>

    <?sp_doc Formatting for the word "Chapter" or "Appendix". ?>
    <xsl:variable name="chap-appx-family">Sans</xsl:variable>
    <xsl:variable name="chap-appx-size">22pt</xsl:variable>
    <xsl:variable name="chap-appx-line-height">20pt</xsl:variable>
    <xsl:variable name="chap-appx-weight">normal</xsl:variable>
    <xsl:variable name="chap-appx-style">normal</xsl:variable>
    <xsl:variable name="chap-appx-color">Black</xsl:variable>
    
    <?sp_doc Formatting for the chapter title. ?>
    <xsl:variable name="chap-appx-title-family">Sans</xsl:variable>
    <xsl:variable name="chap-appx-title-size">22pt</xsl:variable>
    <xsl:variable name="chap-appx-title-line-height">20pt</xsl:variable>
    <xsl:variable name="chap-appx-title-weight">normal</xsl:variable>
    <xsl:variable name="chap-appx-title-style">normal</xsl:variable>
    <xsl:variable name="chap-appx-title-color">Black</xsl:variable>
    
    <?sp_doc Formatting for first-level heads. ?>
    <xsl:variable name="level-1-family">Sans</xsl:variable>
    <xsl:variable name="level-1-size">22pt</xsl:variable>
    <xsl:variable name="level-1-line-height">24pt</xsl:variable>
    <xsl:variable name="level-1-weight">bold</xsl:variable>
    <xsl:variable name="level-1-style">normal</xsl:variable>
    <xsl:variable name="level-1-indent">0pt</xsl:variable>
    <xsl:variable name="level-1-color">#000000</xsl:variable>
    <xsl:variable name="level-1-space-before">20pt</xsl:variable>
    <xsl:variable name="level-1-space-after">6pt</xsl:variable>
    
    <?sp_doc Formatting for second-level heads. ?>
    <xsl:variable name="level-2-family">Sans</xsl:variable>
    <xsl:variable name="level-2-size">18pt</xsl:variable>
    <xsl:variable name="level-2-line-height">20pt</xsl:variable>
    <xsl:variable name="level-2-weight">bold</xsl:variable>
    <xsl:variable name="level-2-style">normal</xsl:variable>
    <xsl:variable name="level-2-indent">0pt</xsl:variable>
    <xsl:variable name="level-2-color">#000000</xsl:variable>
    <xsl:variable name="level-2-space-before">12pt</xsl:variable>
    <xsl:variable name="level-2-space-after">4pt</xsl:variable>
    
    <?sp_doc Formatting for third-level heads. ?>
    <xsl:variable name="level-3-family">Sans</xsl:variable>
    <xsl:variable name="level-3-size">14pt</xsl:variable>
    <xsl:variable name="level-3-line-height">16pt</xsl:variable>
    <xsl:variable name="level-3-weight">bold</xsl:variable>
    <xsl:variable name="level-3-style">normal</xsl:variable>
    <xsl:variable name="level-3-indent">0pt</xsl:variable>
    <xsl:variable name="level-3-color">#000000</xsl:variable>
    <xsl:variable name="level-3-space-before">12pt</xsl:variable>
    <xsl:variable name="level-3-space-after">4pt</xsl:variable>
    
    <?sp_doc Formatting for fourth-level heads. ?>
    <xsl:variable name="level-4-family">Sans</xsl:variable>
    <xsl:variable name="level-4-size">12pt</xsl:variable>
    <xsl:variable name="level-4-line-height">14pt</xsl:variable>
    <xsl:variable name="level-4-weight">bold</xsl:variable>
    <xsl:variable name="level-4-style">normal</xsl:variable>
    <xsl:variable name="level-4-indent">0pt</xsl:variable>
    <xsl:variable name="level-4-color">#000000</xsl:variable>
    <!-- xxxxx -->
    <?sp_doc Formatting for fifth-level heads. (Are you sure?) ?>
<!--    <xsl:variable name="level-5-family">SansLight</xsl:variable>
    <xsl:variable name="level-5-size">10pt</xsl:variable>
    <xsl:variable name="level-5-line-height">12pt</xsl:variable>
    <xsl:variable name="level-5-weight">normal</xsl:variable>
    <xsl:variable name="level-5-style">italic</xsl:variable>
    <xsl:variable name="level-5-indent">0pt</xsl:variable>
    <xsl:variable name="level-5-color">#000000</xsl:variable>-->
    <xsl:variable name="level-5-family">Sans</xsl:variable>
    <xsl:variable name="level-5-size">12pt</xsl:variable>
    <xsl:variable name="level-5-line-height">14pt</xsl:variable>
    <xsl:variable name="level-5-weight">bold</xsl:variable>
    <xsl:variable name="level-5-style">normal</xsl:variable>
    <xsl:variable name="level-5-indent">0pt</xsl:variable>
    <xsl:variable name="level-5-color">#000000</xsl:variable>
    <!-- xxxxx -->
    <?sp_doc Formatting for sixth-level heads. (You gotta be crazy.) ?>
    <xsl:variable name="level-6-family">Sans</xsl:variable>
    <xsl:variable name="level-6-size">9pt</xsl:variable>
    <xsl:variable name="level-6-line-height">11pt</xsl:variable>
    <xsl:variable name="level-6-weight">bolx</xsl:variable>
    <xsl:variable name="level-6-style">normal</xsl:variable>
    <xsl:variable name="level-6-indent">0pt</xsl:variable>
    <xsl:variable name="level-6-color">#000000</xsl:variable>
<!--    <xsl:variable name="level-6-family">SansLight</xsl:variable>
    <xsl:variable name="level-6-size">10pt</xsl:variable>
    <xsl:variable name="level-6-line-height">12pt</xsl:variable>
    <xsl:variable name="level-6-weight">normal</xsl:variable>
    <xsl:variable name="level-6-style">italic</xsl:variable>
    <xsl:variable name="level-6-indent">0pt</xsl:variable>
    <xsl:variable name="level-6-color">#000000</xsl:variable>-->
    
    <?sp_doc Formatting for body text. ?>
    <xsl:variable name="body-family">Sans</xsl:variable>
    <xsl:variable name="body-size">11pt</xsl:variable>
    <xsl:variable name="body-weight">normal</xsl:variable>
    
    <xsl:variable name="body-space-before">7pt</xsl:variable>
    <xsl:variable name="body-space-after">7pt</xsl:variable>
    
    <?sp_head Table and table title treatment. ?>
    <?sp_doc Overall space before and after. ?>
    <xsl:variable name="table-space-before">7pt</xsl:variable>
    <xsl:variable name="table-space-after">7pt</xsl:variable>

    <?sp_doc Table outside borders. ?>
    <xsl:variable name="table-border-top-style">solid</xsl:variable>
    <xsl:variable name="table-border-top-width">0.5pt</xsl:variable>
    <xsl:variable name="table-border-top-color">Black</xsl:variable>

    <xsl:variable name="table-border-bottom-style">solid</xsl:variable>
    <xsl:variable name="table-border-bottom-width">0.5pt</xsl:variable>
    <xsl:variable name="table-border-bottom-color">Black</xsl:variable>

    <xsl:variable name="table-border-left-style">solid</xsl:variable>
    <xsl:variable name="table-border-left-width">0.5pt</xsl:variable>
    <xsl:variable name="table-border-left-color">Black</xsl:variable>
    
    <xsl:variable name="table-border-right-style">solid</xsl:variable>
    <xsl:variable name="table-border-right-width">0.5pt</xsl:variable>
    <xsl:variable name="table-border-right-color">Black</xsl:variable>

    <xsl:variable name="table-head-bottom-style">solid</xsl:variable>
    <xsl:variable name="table-head-bottom-width">0.5pt</xsl:variable>
    <xsl:variable name="table-head-bottom-color">Black</xsl:variable>
    

    <?sp_doc Formatting for the table title. ?>
    <xsl:variable name="table-title-family">Sans</xsl:variable>
    <xsl:variable name="table-title-size">11pt</xsl:variable>
    <xsl:variable name="table-title-line-height">13pt</xsl:variable>
    <xsl:variable name="table-title-weight">bold</xsl:variable>
    <xsl:variable name="table-title-style">normal</xsl:variable>
    <xsl:variable name="table-title-color">Black</xsl:variable>
    
    <xsl:variable name="table-title-indent">0pt</xsl:variable>
    <xsl:variable name="table-title-space-before">4pt</xsl:variable>
    <xsl:variable name="table-title-space-after">0pt</xsl:variable>

    <?sp_doc Formatting for table column heads. ?>
    <xsl:variable name="table-head-family">Sans</xsl:variable>
    <!-- Slightly smaller than body. -->
    <xsl:variable name="table-head-size">11pt</xsl:variable> 
    <xsl:variable name="table-head-weight">bold</xsl:variable>
    <xsl:variable name="table-head-style">normal</xsl:variable>
    <xsl:variable name="table-head-color">#000000</xsl:variable>
    <xsl:variable name="table-head-tbmargins">4pt</xsl:variable>
    <xsl:variable name="table-head-lrmargins">4pt</xsl:variable>
    <xsl:variable name="table-head-bgcolor">White</xsl:variable>
    <xsl:variable name="table-head-line-height">13pt</xsl:variable>
    
    <?sp_doc Formatting for table body. ?>
    <xsl:variable name="table-body-family">Sans</xsl:variable>
    <!-- Slightly smaller than body. -->
    <xsl:variable name="table-body-size">11pt</xsl:variable> 
    <xsl:variable name="table-body-weight">normal</xsl:variable>
    <xsl:variable name="table-body-style">normal</xsl:variable>
    <xsl:variable name="table-body-color">#000000</xsl:variable>
    <!-- 1pt of lead. -->
    <xsl:variable name="table-body-line-height">13pt</xsl:variable>
    
    <xsl:variable name="table-body-tbmargins">4pt</xsl:variable>
    <xsl:variable name="table-body-lrmargins">4pt</xsl:variable>


    <?sp_head Figure and figure title treatment. ?>
    <?sp_doc Space before and after figure. ?>
    <xsl:variable name="figure-space-before">7pt</xsl:variable>
    <xsl:variable name="figure-space-after">7pt</xsl:variable>

    <?sp_doc Formatting for the figure title. ?>
    <xsl:variable name="figure-title-family">Sans</xsl:variable>
    <xsl:variable name="figure-title-size">11pt</xsl:variable>
    <xsl:variable name="figure-title-line-height">13pt</xsl:variable>
    <xsl:variable name="figure-title-weight">bold</xsl:variable>
    <xsl:variable name="figure-title-style">normal</xsl:variable>
    <xsl:variable name="figure-title-color">black</xsl:variable>
    <xsl:variable name="figure-title-space-before">4pt</xsl:variable>
    <xsl:variable name="figure-title-space-after">0pt</xsl:variable>

    <?sp_head Example treatment. ?>
    <?sp_doc Formatting for the example title. ?>
    <xsl:variable name="example-title-family">Sans</xsl:variable>
    <xsl:variable name="example-title-size">11pt</xsl:variable> 
    <xsl:variable name="example-title-weight">bold</xsl:variable>
    <xsl:variable name="example-title-style">normal</xsl:variable>
    <xsl:variable name="example-title-color">black</xsl:variable>
    
    <!-- Quote (lq) treatment. -->
    <xsl:variable name="quote-family">Serif</xsl:variable>
    <xsl:variable name="quote-size" select="$secondary-font-size"/>
    <xsl:variable name="quote-weight">normal</xsl:variable>
    <xsl:variable name="quote-style">normal</xsl:variable>
    <xsl:variable name="quote-color">#000000</xsl:variable>
    <xsl:variable name="quote-text-align">left</xsl:variable>
    
    <xsl:variable name="quote-start-indent" select="concat($side-bar-width + 18,'pt')"/>
    <xsl:variable name="quote-end-indent">18pt</xsl:variable>
    <xsl:variable name="quote-space-before">10pt</xsl:variable>
    
    <xsl:variable name="quote-border-top-style">solid</xsl:variable>
    <xsl:variable name="quote-border-top-width">0.5pt</xsl:variable>
    <xsl:variable name="quote-border-top-color">#000000</xsl:variable>
    <xsl:variable name="quote-border-top-padding">3pt</xsl:variable>
    
    <xsl:variable name="quote-border-bottom-style">solid</xsl:variable>
    <xsl:variable name="quote-border-bottom-width">0.5pt</xsl:variable>
    <xsl:variable name="quote-border-bottom-color">#000000</xsl:variable>
    <xsl:variable name="quote-border-bottom-padding">3pt</xsl:variable>
    
    <xsl:variable name="quote-border-left-style">solid</xsl:variable>
    <xsl:variable name="quote-border-left-width">0.5pt</xsl:variable>
    <xsl:variable name="quote-border-left-color">#000000</xsl:variable>
    <xsl:variable name="quote-border-left-padding">3pt</xsl:variable>
    
    <xsl:variable name="quote-border-right-style">solid</xsl:variable>
    <xsl:variable name="quote-border-right-width">0.5pt</xsl:variable>
    <xsl:variable name="quote-border-right-color">#000000</xsl:variable>
    <xsl:variable name="quote-border-right-padding">3pt</xsl:variable>
    
    <!-- Unordered list treatment. -->
    <xsl:variable name="ul-indent">18pt</xsl:variable>
    <xsl:variable name="ul-indent-2">36pt</xsl:variable>
    <xsl:variable name="ul-li-space-before">6pt</xsl:variable>
    <xsl:variable name="ul-li-space-after">6pt</xsl:variable>
    
    <!-- Ordered list treatment. -->
    <xsl:variable name="ol-indent">18pt</xsl:variable>
    <xsl:variable name="ol-indent-2">36pt</xsl:variable>
    <xsl:variable name="ol-li-space-before">6pt</xsl:variable>
    <xsl:variable name="ol-li-space-after">6pt</xsl:variable>
    
    <!-- Simple list treatment. -->
    <xsl:variable name="sl-indent">18pt</xsl:variable>
    <xsl:variable name="sl-indent-2">36pt</xsl:variable>
    <xsl:variable name="sl-sli-space-before">2pt</xsl:variable>
    <xsl:variable name="sl-sli-space-after">2pt</xsl:variable>
    
    <?sp_head Block-style dl treatment. ?>
    <?sp_doc Formatting for the dt and dd elements. ?>
    <xsl:variable name="dl.block-family">Sans</xsl:variable>
    <xsl:variable name="dl.block-size">11pt</xsl:variable> <!-- [SP] Font size reduced from 11.5 to be consistent with body text. -->
    <xsl:variable name="dl.block-weight">normal</xsl:variable>
    <xsl:variable name="dl.block-style">normal</xsl:variable>
    <xsl:variable name="dl.block-space-before">6pt</xsl:variable>
    <xsl:variable name="dl.block-space-after">6pt</xsl:variable>
    
    <?sp_doc Change font weight for dt. ?>
    <xsl:variable name="dl.block-dt-weight">bold</xsl:variable>
    
    <?sp_doc Indent for block-mode dt. ?>
    <xsl:variable name="dl.block-dd-start-indent">18pt</xsl:variable>
       

    <!-- Scriptorium added variables to control how figures and tables are numbered. 
       If the variables are set to yes, figures and tables are numbered with folios (e.g., Figure 2-1 for the first figure in Chapter 2). 
       Note that the variables can be set independently for figures and tables.  -->
    <!-- Scriptorium TODO: Add style controls for these. -->
    <?sp_nodoc ?>
    <xsl:variable name="chapter-prefix-figures">yes</xsl:variable>
    <xsl:variable name="chapter-prefix-tables">yes</xsl:variable>

    <!-- Scriptorium added the cell-frames variable to control the presence of cell borders when frame="all" is
       specified for a table.  Previously, frame="all" only enabled the exterior borders of a table.  When cell-frames="1" and a table
       has frame="all", all cells receive a border.  When cell-frames="0" and a table has frame="all", the cells do not get a border.  -->
    <xsl:variable name="cell-frames-row">0</xsl:variable>
    <xsl:variable name="cell-frames-column">0</xsl:variable>

    <?sp_head Miscellaneous settings. ?>
    <?sp_doc Default image alignment. Possible values are left, right, and center.  ?>
    <xsl:variable name="image-align">center</xsl:variable>

    <?sp_doc Do not show TOC entries for Notices. The value must be set to 'yes' to suppress TOC entries for notices. The default is 'no'. ?>
    <xsl:variable name="suppress-notices-in-toc">no</xsl:variable>

    <?sp_head Link styles. ?>
    <?sp_doc Normally a link is shown in the same size as it's containing font. ?> 
    <xsl:variable name="link-font-family">Sans</xsl:variable>
    <!--   
        If you need to set a specific size, do it either in the common.link attribute set,
        or in the template that processes the link. -->
     <!--
         <xsl:variable name="link-font-size">
         </xsl:variable>
     -->
    <xsl:variable name="link-font-weight">normal</xsl:variable>
    <xsl:variable name="link-font-style">normal</xsl:variable>
    <xsl:variable name="link-font-color">black</xsl:variable>
    <xsl:variable name="link-underscore-style">none</xsl:variable>
    <xsl:variable name="link-underscore-width">0pt</xsl:variable>
    <xsl:variable name="link-underscore-color">white</xsl:variable>


    <?sp_head Indexing treatment. ?>
    <!-- Scriptorium added suppress-index variable to suppress indexing, regardless of FO processor type. 
         The default value of "no" means that an index will be processed if index entries are 
         present in the book. -->
    <!-- Set to yes on 21-Dec-11 -->
    <!-- TODO: awaiting re-implementation of spdf (FOP) index functions. -->
    <?sp_nodoc ?>
    <xsl:variable name="suppress-index">yes</xsl:variable>

    <!-- Scriptorium added variables to control the index indent and index left margin.  
       The indent is the amount that wrapped text is indented.  
       The left margin is the amount that secondary entries are indented beneath the primary entry. -->
    <?sp_doc Index page layout. ?>
    <xsl:variable name="index-columns">2</xsl:variable>
    <xsl:variable name="index-gap">14pt</xsl:variable>
    
    
    <xsl:variable name="index-indent">12pt</xsl:variable>
    <xsl:variable name="index-left-margin">12pt</xsl:variable>

    <?sp_doc Index group letter formatting. ?>
    <xsl:variable name="index-letter-group-size">16pt</xsl:variable>
    <xsl:variable name="index-letter-group-family">Sans</xsl:variable>
    <xsl:variable name="index-letter-group-style">normal</xsl:variable>
    <xsl:variable name="index-letter-group-weight">bold</xsl:variable>
    <xsl:variable name="index-letter-group-color" select="$purple"/>
    <xsl:variable name="index-letter-group-space-after">7pt</xsl:variable>
    
    <!-- Scriptorium added font size variables for the index entry text and for the index's alphabetic labels ("letter group").  
    The unit for the number is points; however, the unit should not be added to the value here. -->
    <?sp_doc Index entry formatting. ?>
    <xsl:variable name="index-entry-family">Sans</xsl:variable>
    <xsl:variable name="index-entry-size">9pt</xsl:variable>
    <xsl:variable name="index-entry-weight">normal</xsl:variable>
    <xsl:variable name="index-entry-style">normal</xsl:variable>
    <xsl:variable name="index-entry-color">black</xsl:variable>
    <xsl:variable name="index-entry-line-height">11pt</xsl:variable>
        
    <?sp_doc Index link formatting. ?>
    <xsl:variable name="index-link-family">Sans</xsl:variable>
    <xsl:variable name="index-link-size">9pt</xsl:variable>
    <xsl:variable name="index-link-weight">normal</xsl:variable>
    <xsl:variable name="index-link-style">normal</xsl:variable>
    <xsl:variable name="index-link-color">black</xsl:variable>
    

    <?sp_nodoc ?>
    <!-- %%%%%%%%%%%%%%%% UTILITY TEMPLATES AND FUNCTIONS %%%%%%%%%%%%%%%%%% -->

    <!-- Scriptorium added methods to derive current time and date for general usage, if needed.  
  Often this information is a desirable part of headers and/or footers in drafts. -->
    <xsl:variable name="date">
        <xsl:call-template name="gen-current-date"/>
    </xsl:variable>

    <xsl:variable name="time">
        <xsl:call-template name="gen-current-time"/>
    </xsl:variable>

    <xsl:variable name="current.date" select="date:date()"/>

    <!-- generate the current date and transform into the format month, date, year-->
    <xsl:template name="gen-current-date">
        <xsl:choose>
            <xsl:when test="function-available('date:date')">
                <xsl:value-of
                    select="concat(date:month-name($current.date), ' ', date:day-in-month($current.date), ', ', date:year($current.date))"
                />
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>

    <!-- generate only the year-->
    <xsl:template name="gen-current-year">
        <xsl:choose>
            <xsl:when test="function-available('date:date')">
                <xsl:value-of select="date:year($current.date)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>WARNING: date:date function not available.</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="gen-current-month">
        <xsl:choose>
            <xsl:when test="function-available('date:date')">
                <xsl:value-of select="date:month-name($current.date)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>WARNING: date:date function not available.</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="gen-current-time">
        <xsl:choose>
            <xsl:when test="function-available('date:date')">
                <xsl:value-of
                    select="concat(date:hour-in-day(),':',date:minute-in-hour(),':',date:second-in-minute())"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>WARNING: date:date function not available.</xsl:message>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>


</xsl:stylesheet>
