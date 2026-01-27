/*

Various JavaScript functions to drive HTML page behaviors.

NOTE NOTE NOTE NOTE
There are a number of localized strings in this file. These strings are
represented by Ant property references: ${like_this}.
These strings are defined in the language-specific strings files in
xsl/common (such as strings-en-us.xml).

The strings are replaced in the JavaScript files in the copy.resources
target, which is defined in build_scriptorium_xhtml.xml.

Do not modify this file in an output folder then copy the modified file back
to resources/js. Files in the output folder contain expanded strings, rather
than the Ant property references. Copying an output file back to the
resources/js folder will eliminate all of the Ant property references.

 */

function init() {
    make_cookie();
    get_current_link();
    check_nav();
    width_query();
}


function toggle_nav(span, event) {
    var myli = span.parentNode;
    var myid = myli.id;
    /* [SP] change item name for sub-levels
    var parentid = myli.parentNode.id;*/
    var parentid = 'ul-item';
    // Find the span's sibling ul.
    var myul = myli.getElementsByTagName('ul')[0];
    if (myul) {
        if (myul.style.display == "none") {
            if (event.shiftKey == 1) {
                // Turn on all sections.
                open_nav(parentid);
            } else {
                // Turn on this section
                myul.style.display = "block";
                myul.style.marginRight = "6px";
                
                //span.className = 'toc_branch';
                span.title = 'Click to collapse';
                span.alt = 'Click to collapse';
                
                // store id values in a cookie
                store_cookie(parentid, myid);
            }
        } else {
            if (event.shiftKey == 1) {
                // Turn off all sections.
                // Delete all stored keys
                //delete window.localStorage[parentid];
                // And redraw the nav TOC
                close_nav();
            } else {
                // Turn off this section
                myul.style.display = "none";
                
                //span.className = 'toc_branch';
                span.title = 'Click to expand';
                span.alt = 'Click to expand';
                delete_cookie(parentid, myid);
            }
        }
    }
}


function store_cookie(mykey, myid) {
    var var_cookies = read_cookies(mykey);
    if (var_cookies == null) {
        document.cookie = mykey + '=' + myid;
    } else {
        //empty the cookie
        document.cookie = '';
        add_cookies = var_cookies + ',' + myid;
        document.cookie = mykey + '=' + add_cookies + '; path=/;';
    }
}

function make_cookie() {
    var my_cookies = read_cookies('ul-item');
    if (document.cookie == '') {
        document.cookie = 'ul-item=startVal;path=/;';
    } else if (my_cookies == undefined) {
        //alert(my_cookies);
        document.cookie = 'ul-item=startVal;path=/;';         
        //alert('cookie has been set: ' + document.cookie);                
    }
}

function delete_cookie(mykey, myid) {
    var var_cookies = read_cookies(mykey);
    
    var split_cookies = var_cookies.split(',');
    for (i = 0; i < split_cookies.length; i++) {
        if (split_cookies[i] == myid) {
            split_cookies.splice(i, 1);
            
            document.cookie = '';
            document.cookie = mykey + '=' + split_cookies + '; path=/;';
        }
    }
}


function read_cookies(mykey) {
    var i, x, y, ARRcookies = document.cookie.split(";");
    for (i = 0; i < ARRcookies.length; i++) {
        x = ARRcookies[i].substr(0, ARRcookies[i].indexOf("="));
        y = ARRcookies[i].substr(ARRcookies[i].indexOf("=") + 1);
        x = x.replace(/^\s+|\s+$/g, "");
        if (x == mykey) {
            return unescape(y);
        }
    }
}

function check_nav() {
    var li;
    var li_ul;
    var li_span;
    var nav = document.getElementById('side_navigation');
    var navul = nav.getElementsByTagName('ul')[0];
    
    // Get the expanded items for this deliverable
    // cookies
    var stored_cookies = read_cookies('ul-item');
    var split_cookies = stored_cookies.split(',');
    var navlis = navul.getElementsByTagName('li');
    
    if (stored_cookies == null) {
        return 0;
    }
    
    for (i = 0; i < navlis.length; i++) {
        li = navlis[i];
        var found = -1;
        for (j = 0; j < split_cookies.length; j++) {
            if (split_cookies[j] == li.id) {
                found = j;
                li_ul = li.getElementsByTagName('ul')[0];
                li_ul.style.display = "block";
                li_span = li.getElementsByTagName('span')[0];
                li_span.title = 'Click to collapse';
                li_span.alt = 'Click to collapse';
                break;
            }
        }
    }
}

function close_nav() {
    var li;
    var li_ul;
    var li_span;
    var li_img
    var nav = document.getElementById('side_navigation');
    var navul = nav.getElementsByTagName('ul')[0];
    
    // Get the li's under navul
    var navlis = navul.getElementsByTagName('li');
    
    for (i = 0; i < navlis.length; i++) {
        // dereference the li
        li = navlis[i];
        // Hide the subordinate ul.
        li_ul = li.getElementsByTagName('ul')[0];
        if (li_ul != null) {
            li_ul.style.display = "none";
            // Change the image
            li_span = li.getElementsByTagName('span')[0];
            //li_img = li_span.getElementsByTagName('img')[0];
            
            // Change the tooltips
            //li_span.className = 'toc_branch';
            li_span.title = 'Click to expand';
            li_span.alt = 'Click to expand';
        }
    }
}

function open_nav(mykey) {
    var li;
    var li_ul;
    var li_span;
    var li_img
    var nav = document.getElementById('side_navigation');
    var navul = nav.getElementsByTagName('ul')[0];
    var mylist = {
    };
    
    // Get the li's under navul
    var navlis = navul.getElementsByTagName('li');
    
    for (i = 0; i < navlis.length; i++) {
        // dereference the li
        li = navlis[i];
        // Hide the subordinate ul.
        li_ul = li.getElementsByTagName('ul')[0];
        if (li_ul != null) {
            li_ul.style.display = "block";
            // Change the image
            li_span = li.getElementsByTagName('span')[0];
            
            // Change the tooltips
            //li_span.className = 'toc_branch';
            li_span.title = 'Click to collapse';
            li_span.alt = 'Click to collapse';
            // and add the id of the li to the array
            mylist[li.id] = "1";
        }
    }
    // Now save the list of ids.
    //var mystring = JSON.stringify(mylist);
    //window.localStorage.setItem(mykey, mystring);
}


function toggle_units() {
    var spans = document.getElementsByTagName('span');
    // toggle the class name between uhide and ushow.
    for (var i = spans.length; i--;) {
        var units = spans[i];
        var uname = units.className;
        if (uname.match(/ushow/)) {
            units.className = uname.replace(/ushow/, 'uhide');
        } else if (uname.match(/uhide/)) {
            units.className = uname.replace(/uhide/, 'ushow');
        }
    }
    
    // Change the button lable to reflect the new units.
    var button = document.getElementById('unit_button');
    var text = button.firstChild.data;
    if (text.match(/Display US Customary Units/)) {
        button.firstChild.data = text.replace(/Display US Customary Units/, 'Display SI Units');
    } else {
        button.firstChild.data = text.replace(/Display SI Units/, 'Display US Customary Units');
    }
}


/* sidebar slide function */

function menu_toggle() {
    
    
    var sidebar = document.getElementById('sidebar_box');
    var sb_ul = sidebar.getElementsByTagName('ul')[0];
    var sb_divs = sidebar.getElementsByTagName('div');
    
    sidebar.className == 'box open' ? sidebar_close(sidebar, sb_ul, sb_divs): sidebar_open(sidebar, sb_ul, sb_divs);
    
    
    /* nav handle title */
    var nav_handle = document.getElementById('nav_handle');
    nav_handle.title == 'Click to hide' ? nav_handle.title = 'Click to show': nav_handle.title = 'Click to hide';
}

function sidebar_close(sidebar, sb_ul, sb_divs) {
    
    sidebar.className = 'box closed';
    sidebar_container = document.getElementById('sidebar');
    sidebar_container.style.width = '12px';
}

function sidebar_open(sidebar, sb_ul, sb_divs) {
    
    sidebar.className = 'box open';
    sidebar_container = document.getElementById('sidebar');
    sidebar_container.style.width = '195px';
}

/* table and fig pop-outs */

function expand_table(div) {
    var table = div.parentNode;
    disp_window = window.open();
    disp_window.document.write("<html><head><title>expanded table</title><link rel='stylesheet' type='text/css' href='../css/scriptorium_style.css' /></head><body><div id='table_exp' class='table_exp'></div></body></html>");
    disp_window.document.getElementById('table_exp').innerHTML = table.innerHTML;
    var expand_div = disp_window.document.getElementById('expand');
    expand_div.style.display = 'none';
    disp_window.document.close();
}

function expand_figure(div) {
    var figure = div.parentNode;
    disp_window = window.open();
    disp_window.document.write("<html><head><title>expanded figure</title><link rel='stylesheet' type='text/css' href='../css/scriptorium_style.css' /></head><body><div id='figure_exp' class='figure_exp'></div></body></html>");
    disp_window.document.getElementById('figure_exp').innerHTML = figure.innerHTML;
    var expand_div = disp_window.document.getElementById('expand');
    expand_div.style.display = 'none';
    disp_window.document.close();
}


function get_current_link() {
    var li;
    var nav = document.getElementById('side_navigation');
    var navul = nav.getElementsByTagName('ul')[0];
    var navlis = navul.getElementsByTagName('li');    
    var curr_loc = document.location;
    
    for (var i = 0; i < navlis.length; i++) {
        navlis_link = navlis[i].getElementsByTagName('a')[0].href;
        li = navlis[i];        
        if (navlis_link == curr_loc) {            
            li.getElementsByTagName('a')[0].style.fontWeight = 'bold';
            //expand parent levels if collapsed
            nl_anc = navlis[i];
            // parent:: ul
            for (var l = 0; l < 7; l++) {
                if (nl_anc.id == navul.id) break;
                var nl_anc = nl_anc.parentNode;
                if (nl_anc.style.display == 'none') {
                    nl_anc.style.display = 'block';
                }
                if (nl_anc.tagName == 'LI') {
                    nl_anc.getElementsByTagName('span')[0].title = 'Click to collapse';
                }
            }
        }
    } 
    var bcrumbs = document.getElementById('bcrumbs');
    var first_bcrumb = bcrumbs.getElementsByTagName('p')[0].getElementsByTagName('a')[0];
    // only if current page is first page of book
    if (curr_loc == first_bcrumb.href) {
        first_bcrumb.style.fontWeight = 'bold';
    }
   
    
}

function email_this(subject) {
    var subject = subject;
    var link = window.location;
    var emailSubject = "" + subject;
    var emailAddress = prompt("Please enter the recipient's email address", "");
    //var emailconf = confirm;
    //window.location = "mailto:" + emailAddress + "?Subject=" + emailSubject + "&body=" + link;

    if(emailAddress != null){          
      parent.location.href = "mailto:" + emailAddress + "?Subject=" + emailSubject + "&body=" + link;      
    }

}


function width_query() {
    var width_query = window.innerWidth;
    if (width_query < '560') {
        var sidebar = document.getElementById('sidebar_box');
        var sidebar_container = document.getElementById('sidebar');
        sidebar.className = 'box closed';
        sidebar_container.style.width = '12px';
        
        //var doc_head = document.getElementsByTagName('head')[0];
        //var vp_meta = document.createElement("META");
        //vp_meta.name = 'viewport';
        //vp_meta.content = 'width=device-width; initial-scale=1.0';
        //doc_head.appendChild(vp_meta);
    }
}




//***********************************************************************
// debug 
 
 /*function get_current_link() {
    var li;
    var nav = document.getElementById('side_navigation');
    var navul = nav.getElementsByTagName('ul')[0];
    var navlis = navul.getElementsByTagName('li');
    var curr_loc = document.location.toString();
    var curr_loc_split = curr_loc.split('/');
    var curr_loc_split_length = curr_loc_split.length;
    
    // check against filename and parent dir, as some filenames 
    // are repeated in multiple dirs
    for (var i = 0; i < curr_loc_split.length; i++) {
        if (i + 1 == curr_loc_split.length) {
            for (var j = 0; j < navlis.length; j++) {
                navlis_link = navlis[j].getElementsByTagName('a')[0].href;
                li = navlis[j];
                navlis_link_split = navlis_link.split('/');
                if (navlis_link_split[i] == curr_loc_split[i]) {
                    if (navlis_link_split[i - 1] == curr_loc_split[i - 1]) {
                        for (var q = 0; q < navlis.length; q++) {
                            if (navlis[q].id == li.id) {
                                navlis[q].getElementsByTagName('a')[0].style.textDecoration = 'underline';
                                navlis[q].getElementsByTagName('a')[0].style.fontWeight = 'bold';
                                
                                //expand parent levels if collapsed
                                nl_anc = navlis[q];
                                // parent:: ul
                                for (var l = 0; l < 7; l++) {
                                    if (nl_anc.id == navul.id) break;
                                    var nl_anc = nl_anc.parentNode;
                                    if (nl_anc.style.display == 'none') {
                                        nl_anc.style.display = 'block';
                                    }
                                    if (nl_anc.tagName == 'LI') {
                                        nl_anc.getElementsByTagName('span')[0].title = 'Click to collapse';
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}*/
