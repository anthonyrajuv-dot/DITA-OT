<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="xs" version="2.0">

    <xsl:template match="/">
        <xsl:apply-templates select="bookmap"/>
    </xsl:template>

    <xsl:template match="bookmap">
        <xsl:message>You're in dita2index</xsl:message>
        <xsl:result-document href="shared/launchpage.html" method="html" standalone="yes">
            <xsl:text>&#10;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"></xsl:text>
            <xsl:text disable-output-escaping="yes"><![CDATA[<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Course Launch Page</title>
    <script src="scormfunctions.js" type="text/javascript"></script>
    <script type="text/javascript">
    
    /*************************************/
    //functions for sizing the iFrame
    /*************************************/
    function setIframeHeight(id, navWidth) {
        if ( document.getElementById ) {
            var theIframe = document.getElementById(id);
            if (theIframe) {
                var height = getWindowHeight();
                theIframe.style.height = Math.round( height ) - navWidth + "px";
                theIframe.style.marginTop = Math.round( ((height - navWidth) - parseInt(theIframe.style.height) )/2 ) + "px";
            }
        }
    }

    function getWindowHeight() {
        var height = 0;
        if (window.innerHeight){
            height = window.innerHeight - 18;
        }
        else if (document.documentElement && document.documentElement.clientHeight){
            height = document.documentElement.clientHeight;
        }
        else if (document.body && document.body.clientHeight) {
            height = document.body.clientHeight;
        }
        return height;
    }
    
    function SetupIFrame(){
        //set our iFrame for the content to take up the full screen except for our navigation
        var navWidth = 40;
        setIframeHeight("contentFrame", navWidth);
        setIframeHeight("tocFrame", navWidth);

        //need this in a setTimeout to avoid a timing error in IE6
        window.setTimeout('window.onresize = function() { setIframeHeight("contentFrame", ' + navWidth + 
                                                      '); setIframeHeight("tocFrame", '     + navWidth + '); }', 1000);
    }
    /*************************************/
    //content definition
    /*************************************/]]></xsl:text>
            <xsl:variable name="array_size"
                select="count(//topicref[not(contains(@class, ' bookmap/chapter ')) and contains(@type, 'kpe-assessmentOverview') or contains(@type, 'kpe-concept') or contains(@type, 'kpe-task')])"/>
            <xsl:message>Value of array_size is <xsl:value-of select="$array_size"/></xsl:message>
            var pageArray = new Array(<xsl:value-of select="$array_size"/>); 
            <xsl:apply-templates
                select="//topicref[not(contains(@class, ' bookmap/chapter ')) and contains(@type, 'kpe-assessmentOverview') or contains(@type, 'kpe-concept') or contains(@type, 'kpe-task')]" mode="create_index"/>
            <xsl:text disable-output-escaping="yes"><![CDATA[/*************************************/
    //navigation functions
    /*************************************/
    
    var currentPage = null;
    var maxProgress = null;
    var currentURL = null;
    var startTimeStamp = null;
    var processedUnload = false;
    var reachedEnd = false;
    
    function doStart(){
        
        //get the iFrame sized correctly and set up
        SetupIFrame();
        
        //record the time that the learner started the SCO so that we can report the total time
        startTimeStamp = new Date();
        
        //initialize communication with the LMS
        ScormProcessInitialize();
        
        //it's a best practice to set the lesson status to incomplete when
        //first launching the course (if the course is not already completed)
        var completionStatus = ScormProcessGetValue("cmi.core.lesson_status");
        if (completionStatus == "not attempted"){
            ScormProcessSetValue("cmi.core.lesson_status", "incomplete");
        }
        
        //see if the user stored a bookmark previously (don't check for errors
        //because cmi.core.lesson_location may not be initialized
        var bookmark = ScormProcessGetValue("cmi.core.lesson_location");
        
        //if there isn't a stored bookmark, start the user at the first page
        if (bookmark == ""){
            maxProgress = 0;
        }
        else{
            //if there is a stored bookmark, prompt the user to resume from the previous location
            if (confirm("Would you like to resume from where you previously left off?")){

                maxProgress = parseInt(bookmark, 10);
                if (isNaN(maxProgress)) {
                   maxProgress = 0;
                }
            }
            else{
        
            maxProgress = 0;
            }
        }
        
        // Set current page from high-water mark.
        currentPage = maxProgress;
        
        // Make links unavailable if we haven't reached them.
        initTOC();
        
        goToPage();
    }
    
    function initTOC() {
        var this_li;
        var this_a;
        var toc_frame = document.getElementById('tocFrame');
        
        // make links beyond max progress unavailable. 
        for (i = maxProgress + 1; i < pageArray.length ;i++) {
            this_li = toc_frame.contentWindow.document.getElementById('page_'+i);
            this_a = this_li.firstChild;
            this_a.className = "toc_unavailable";
        }
        
    }
    
    function newPage(new_page) {
       currentPage = new_page;
       goToPage();
    }
        
    function goToPage(){
    
        var theIframe = document.getElementById("contentFrame");
        var prevButton = document.getElementById("butPrevious");
        var nextButton = document.getElementById("butNext");
        
        //navigate the iFrame to the content
        theIframe.src = "../" + pageArray[currentPage];
        
        //disable the prev/next buttons if we are on the first or last page.
        if (currentPage == 0){
            nextButton.disabled = false;
            prevButton.disabled = true;
        }
        else if (currentPage == (pageArray.length - 1)){
            nextButton.disabled = true;
            prevButton.disabled = false;       
        }
        else{
            nextButton.disabled = false;
            prevButton.disabled = false;
        }
        
        //save the current location as the bookmark
        if (currentPage > maxProgress) {
           maxProgress = currentPage;
           ScormProcessSetValue("cmi.core.lesson_location", currentPage);

           // Update style on links 
           var toc_frame = document.getElementById('tocFrame');
           var this_li = toc_frame.contentWindow.document.getElementById('page_'+currentPage);
           var this_a = this_li.firstChild;
           this_a.className = "toc";

        }
        
        	// make links beyond max progress unavailable. 
	for (i = 0; i < pageArray.length; i++) {
		var toc_frame = document.getElementById('tocFrame');
		var this_li = toc_frame.contentWindow.document.getElementById('page_' + i);
		var this_a = this_li.firstChild;
		
		if (i == currentPage) {
			this_a.style.fontWeight = "bold";
		} else {
			this_a.style.fontWeight = "normal";
		}
	}
     
        //in this sample course, the course is considered complete when the last page is reached
        currentURL = pageArray[currentPage]
        
        if (currentPage == (pageArray.length - 1)){
        if (!currentURL.includes("test_exam_")){
            completeCourse()
            }
        }
    }
    
    
    function completeCourse(){
        reachedEnd = true;
        ScormProcessSetValue("cmi.core.lesson_status", "completed");
    }
    
    function doUnload(pressedExit){
        
        //don't call this function twice
        if (processedUnload == true){return;}
        
        processedUnload = true;
        
        //record the session time
        var endTimeStamp = new Date();
        var totalMilliseconds = (endTimeStamp.getTime() - startTimeStamp.getTime());
        var scormTime = ConvertMilliSecondsToSCORMTime(totalMilliseconds, false);
        
        ScormProcessSetValue("cmi.core.session_time", scormTime);
        
        //if the user just closes the browser, we will default to saving 
        //their progress data. If the user presses exit, he is prompted.
        //If the user reached the end, the exit normall to submit results.
        if (pressedExit == false && reachedEnd == false){
            ScormProcessSetValue("cmi.core.exit", "suspend");
        }
        
        ScormProcessFinish();
    }
    
function doPrevious(){
	if (currentPage > 0) {
		currentPage--;
		goToPage();
	}
}
    
function doNext(){
	if (currentPage < (pageArray.length - 1)) {
		currentPage++;
		goToPage();
	}
}
    
    window.addEventListener("keyup", arrowNavigation, false);
    
    function arrowNavigation(e) {
	
	switch(e.keyCode) {
		case 37:
			doPrevious();
			break;
		case 38:
			// up key pressed
			break;
		case 39:
			doNext();
			break;
		case 40:
			// down key pressed
			break;  
	}
}
    
    function doExit(){

        //note use of short-circuit AND. If the user reached the end, don't prompt.
        //just exit normally and submit the results.
        if (reachedEnd == false && confirm("Would you like to save your progress to resume later?")){
            //set exit to suspend
            ScormProcessSetValue("cmi.core.exit", "suspend");
        }
        else{
            //set exit to normal
            ScormProcessSetValue("cmi.core.exit", "");
        }
        
        //process the unload handler to close out the session.
        //the presense of an adl.nav.request will cause the LMS to 
        //take the content away from the user.
        doUnload(true);
        
    }
    //called from the assessmenttemplate.html page to record the results of a test
    //passes in score as a percentage
    function RecordTest(score,passRate){
        ScormProcessSetValue("cmi.core.score.raw", score);
        ScormProcessSetValue("cmi.core.score.min", "0");
        ScormProcessSetValue("cmi.core.score.max", "100");
        
        //if we get a test result, set the lesson status to passed/failed instead of completed
        //use the value of minimumPassScore to determine pass rate
        if (score >= passRate){
            ScormProcessSetValue("cmi.core.lesson_status", "passed");
        }
        else{
            ScormProcessSetValue("cmi.core.lesson_status", "failed");
        }
    }
    
    //SCORM requires time to be formatted in a specific way
    function ConvertMilliSecondsToSCORMTime(intTotalMilliseconds, blnIncludeFraction){
	
	    var intHours;
	    var intintMinutes;
	    var intSeconds;
	    var intMilliseconds;
	    var intHundredths;
	    var strCMITimeSpan;
    	
	    if (blnIncludeFraction == null || blnIncludeFraction == undefined){
		    blnIncludeFraction = true;
	    }
    	
	    //extract time parts
	    intMilliseconds = intTotalMilliseconds % 1000;

	    intSeconds = ((intTotalMilliseconds - intMilliseconds) / 1000) % 60;

	    intMinutes = ((intTotalMilliseconds - intMilliseconds - (intSeconds * 1000)) / 60000) % 60;

	    intHours = (intTotalMilliseconds - intMilliseconds - (intSeconds * 1000) - (intMinutes * 60000)) / 3600000;

	    /*
	    deal with exceptional case when content used a huge amount of time and interpreted CMITimstamp 
	    to allow a number of intMinutes and seconds greater than 60 i.e. 9999:99:99.99 instead of 9999:60:60:99
	    note - this case is permissable under SCORM, but will be exceptionally rare
	    */

	    if (intHours == 10000) 
	    {	
		    intHours = 9999;

		    intMinutes = (intTotalMilliseconds - (intHours * 3600000)) / 60000;
		    if (intMinutes == 100) 
		    {
			    intMinutes = 99;
		    }
		    intMinutes = Math.floor(intMinutes);
    		
		    intSeconds = (intTotalMilliseconds - (intHours * 3600000) - (intMinutes * 60000)) / 1000;
		    if (intSeconds == 100) 
		    {
			    intSeconds = 99;
		    }
		    intSeconds = Math.floor(intSeconds);
    		
		    intMilliseconds = (intTotalMilliseconds - (intHours * 3600000) - (intMinutes * 60000) - (intSeconds * 1000));
	    }

	    //drop the extra precision from the milliseconds
	    intHundredths = Math.floor(intMilliseconds / 10);

	    //put in padding 0's and concatinate to get the proper format
	    strCMITimeSpan = ZeroPad(intHours, 4) + ":" + ZeroPad(intMinutes, 2) + ":" + ZeroPad(intSeconds, 2);
    	
	    if (blnIncludeFraction){
		    strCMITimeSpan += "." + intHundredths;
	    }

	    //check for case where total milliseconds is greater than max supported by strCMITimeSpan
	    if (intHours > 9999) 
	    {
		    strCMITimeSpan = "9999:99:99";
    		
		    if (blnIncludeFraction){
			    strCMITimeSpan += ".99";
		    }
	    }

	    return strCMITimeSpan;
    	
    }

    function ZeroPad(intNum, intNumDigits){
 
	    var strTemp;
	    var intLen;
	    var i;
    	
	    strTemp = new String(intNum);
	    intLen = strTemp.length;
    	
	    if (intLen > intNumDigits){
		    strTemp = strTemp.substr(0,intNumDigits);
	    }
	    else{
		    for (i=intLen; i<intNumDigits; i++){
			    strTemp = "0" + strTemp;
		    }
	    }
    	
	    return strTemp;
    }
    </script>

</head>
<body onload="doStart(false);" onbeforeunload="doUnload(false);" onunload="doUnload();">
   	<iframe width="19%" name="tocFrame" id="tocFrame" src="toc.html" style="float:left" ></iframe>
	<iframe width="80%" name="contentFrame" id="contentFrame" src="" style="float:right" allowfullscreen="true"
webkitallowfullscreen="true" mozallowfullscreen="true"></iframe>
    
    <div id="navDiv">
        <input type="button" value="<- Previous" id="butPrevious" onclick="doPrevious();"/>
        <input type="button" value="Next ->" id="butNext" onclick="doNext();"/>
    </div>

</body>
</html>]]></xsl:text>
        </xsl:result-document>
    </xsl:template>
    
    <!-- [SP-JLC] Removed the following button from navDiv above. -->
    <!-- <input type="button" value="Exit" id="butExit" onclick="doExit();"/> -->

    <xsl:template match="//topicref[not(contains(@class, ' bookmap/chapter ')) and contains(@type, 'kpe-assessmentOverview') or contains(@type, 'kpe-concept') or contains(@type, 'kpe-task')]" mode="create_index">
        
        <xsl:variable name="ancestor_loc" select="count(ancestor::topicref[not(contains(@class, ' bookmap/chapter ')) and contains(@type, 'kpe-assessmentOverview') or contains(@type, 'kpe-concept') or contains(@type, 'kpe-task')])"/>
        
        <xsl:variable name="preceding_loc"
            select="count(preceding::topicref[not(contains(@class, ' bookmap/chapter ')) and contains(@type, 'kpe-assessmentOverview') or contains(@type, 'kpe-concept') or contains(@type, 'kpe-task')])"/>
        
        <xsl:variable name="index_loc" select="$ancestor_loc + $preceding_loc"/>
        
        <xsl:variable name="ohref_loc">
            <xsl:variable name="dita_base" select="replace(@ohref,'.dita','.html')"/>    
            <xsl:message>dita_base is <xsl:value-of select="$dita_base"/></xsl:message>
            
            
            <xsl:choose>
<!--                <xsl:when test="@type='kpe-concept'">
                    <xsl:value-of select="$dita_base"/>
                </xsl:when>-->
                <xsl:when test="@type='kpe-assessmentOverview'">
                    <xsl:variable name="assessment_count" select="count(preceding::*[contains(@type,'kpe-assessmentOverview')])+1"/>
                    <xsl:variable name="assessment_loc" select="concat('questions',$assessment_count,'.js')"/>
                    <xsl:variable name="assessment_id" select="@id"/>
                    <xsl:variable name="real_assessment" select="//kpe-assessmentOverview[@id = $assessment_id]"/>
                    <xsl:variable name="amp" select="'&#x026;'"/>
                    <xsl:variable name="minimumPassScore">
                        <xsl:choose>
                            <xsl:when test="$real_assessment/prolog/metadata/minimumPassScore/@value != ''">
                                <xsl:value-of select="$real_assessment/prolog/metadata/minimumPassScore/@value"/>
                            </xsl:when>
                            <!-- Default to pass rate of 70 if no pass rate is set -->
                            <xsl:otherwise>70</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:variable name="assessment_type" select="$real_assessment/prolog/metadata/lmsCategory/@value"/>
                    <xsl:message>minimumPassScore is <xsl:value-of select="$minimumPassScore"/></xsl:message>
                    <xsl:text>shared/assessmenttemplate.html?questions=</xsl:text><xsl:value-of select="$assessment_count"/>&amp;passrate=<xsl:value-of select="$minimumPassScore"/>&amp;assessmenttype=<xsl:value-of select="$assessment_type"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$dita_base"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:variable name="ohref_norm" select="normalize-space(replace($ohref_loc,'&#xa;',''))"></xsl:variable>
        
<!--        <xsl:message>Value of index_loc is <xsl:value-of select="$index_loc"/></xsl:message>
        <xsl:message>ohref is <xsl:value-of select="@ohref"/></xsl:message>
        <xsl:message>type is <xsl:value-of select="@type"/></xsl:message>-->
        
        <!--        Create array entry index, starting at 0-->
        <xsl:text>pageArray[</xsl:text>
        <xsl:value-of select="$index_loc"/>
        <xsl:text>] = "</xsl:text>
        <xsl:value-of disable-output-escaping="yes" select="$ohref_norm"/>
        <xsl:text>";</xsl:text>
        <xsl:value-of select="'&#x0A;'"/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class,' map/topicmeta ')]" mode="create_index"/>

</xsl:stylesheet>
