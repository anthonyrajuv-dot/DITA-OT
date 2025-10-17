LMS TOC Transform v 5.3


Release Notes:
Version 3.0 added 1/6/2016
Works with Oxygen 17.0.

Version 3.1 added 2/1/2016
Added processing for <p> around pointValue. Now accomodates either with or without <p>.

Version 3.2 added 4/19/2016
Added processing for CDATA for tables/html from LMS. 

Version 3.3 added 5/4/2016
Added processing for:
<p outputclass="center">
<ph outputclass="strike">
<ph outputclass="overline">

Version 3.4 added 6/23/2016
Added extended table processing for valign, table width, column width, row and column space, and border options.

Version 3.5 added 7/12/2016
Added QTI support for open questions, vignettes (both MC and open), and shared stim mc.

Version 3.6 added 8/23/2016
<tm type="x"> will now pass through as superscript.

Version 3.7 added 11/9/2016
Difficulty metadata passes through in maps

Version 3.8 added 1/13/2017
Added sortOrder to maps

Version 3.9 added 2/23/2017
Updated <learningOverviewbody> to <learningOverviewBody> per LMS team request

Version 4.0 added 3/1/2017
Updated to include answers for single open questions

Version 4.1 added 5/25/2017
Updated to support <sample>, <equation-block>, and <equation-figure> in questions.

Version 4.2 added 6/5/2017
Updated to support container elements in lcOpenAnswer2 in single open essay questions, pointValue in single open essay questions, and to fix overview IDs for duplicated overviews.

Version 4.3 added 6/19/2017
Updated to support <p outputclass="indent">, <sum>, and <total>; increased cell padding from 3 to 5; and changed default table headers from left to center aligned.

Version 4.4 added 12/13/2017
Updated to add support for line breaks. The correct code is <ph outputclass="line_break">. This returns the code of <br/> in DITKA.

Version 4.5 added 2/20/2018
Updated to add support for MathML in vignettes. 
Updated table processing for vignettes and for more accurate row separation.

Version 4.6 added 3/21/2018
Updated to add font size of 16 on fractions in mathml.

Version 4.7 added 5/15/2018
Updated to add fix for pulling in glossary files.

Version 4.8 added 5/29/2018
Updated to add a space when <ph outputclass="los"> is used for more than one LOS in a title.

Version 4.9 added 8/29/2018
Updated to include sup/sub to work in table headers.

Version 5.0 added 10/19/2018
Updated to fix multiple issues in table headers:
- mathml
- paragraphs
- line breaks
- overline/other outputclasses

Version 5.1 added 12/18/2018
Updated to fix the following issues:
- remove id metadata on <p> and <ph>s that are conreffed in
- add ability to have unique identifiers on vignette parts.

Version 5.2 added 2/18/2019
Added outputclass="indent_2" for greater indent. Use after outputclass="indent"

Version 5.3 added 6/5/2019
Updated to add/fix:
- bloomsMap values for questions
- BloomsTaxonomy now passes through on LOS files
- <lq> without <p> now formatted correctly
- ucms ids in vignette questions now fixed
- outputclass="shade" processing to table entries

Version 5.4 added 4/7/2020
Updated to add
- questionType metadata element for Agile Qbank

Version 5.5 added 9/14/2020
Updated to fix
- xrefs not passing from lcIntro correctly

Version 5.6 added 3/26/2021
Updated to add
- functionality to add titles across pages that are broken out/nested
- D heads now tied to <sectiondiv><p outputclass="sub_section_head">