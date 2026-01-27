LMS Calendar Transform v 4.5

Release Notes:
Version 3.0 added 1/6/2016
Works with Oxygen 17.0.
Included added support for <b> and <i>.

Version 3.1 added 2/1/2016
Updated to fix issue with topic titles.
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

Version 3.5 added 8/24/2016
Added <sub> around registered trademark.

Version 3.6 added 9/12/2016
Added processing for tasks with topics and assessments. See F4M105 for example.

Version 3.7 added 11/10/2016
Added processing for:
Fix assessments inside of tasks that have topics--use <lmsCategory value="test_topic_practice"/> for these. Transform will correct to <category>test_practice</category>
Difficulty in assessment maps
Multi-part questions

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

Version 4.5 added 6/5/2019
Updated to add correct processing for <lq> without <p>. Added outputclass="shade" processing to table entries.

