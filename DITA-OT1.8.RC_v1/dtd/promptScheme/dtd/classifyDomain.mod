<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    DITA Prompt Classification Domain                -->
<!--  VERSION:   1.1                                               -->
<!--  DATE:      March 2025                                     -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identifier or an 
      appropriate system identifier 
PUBLIC "-//OASIS//ELEMENTS DITA Map Prompt Classification Domain//EN"
      Delivered as file "classifyDomain.mod"                       -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Define elements and specialization attributes     -->
<!--             for Map Prompt Classification Domain             -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             March 2025                                     -->
<!--                                                               -->
<!--             (C) Copyright OASIS Open 2008, 2009.              -->
<!--             (C) Copyright IBM Corporation 2005, 2007.         -->
<!--             All Rights Reserved.                              -->
<!--                                                               -->
<!--  UPDATES:                                                     -->
<!--    2008.02.13 RDA: Created file based upon prototype from IBM -->
<!--    2010.01.21 RDA: Update promptCell content to remove       -->
<!--                    duplicate element inclusion                -->
<!-- ============================================================= -->


<!-- ============================================================= -->
<!--                    ELEMENT NAME ENTITIES                      -->
<!-- ============================================================= -->

<!ENTITY % topicprompt        "topicprompt">
<!ENTITY % topicapply          "topicapply"><!--New-->
<!ENTITY % promptref          "promptref">
<!ENTITY % topicPromptTable   "topicPromptTable">
<!ENTITY % topicPromptHeader  "topicPromptHeader">
<!ENTITY % topicPromptRow     "topicPromptRow">
<!ENTITY % topicCell           "topicCell">
<!ENTITY % promptCell         "promptCell">

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!--                    LONG NAME: Topic Prompt                   -->
<!-- SKOS equivalent:  primary if href or keyref are specified     -->
<!ENTITY % topicprompt.content
                       "((%topicmeta;)?,
                         (%data.elements.incl; |
                          %promptref;|
                          %topicref;)*)"
>
<!ENTITY % topicprompt.attributes
             "navtitle 
                        CDATA 
                                  #IMPLIED
              href 
                        CDATA 
                                  #IMPLIED
              keyref 
                        CDATA 
                                  #IMPLIED
              keys 
                        CDATA 
                                  #IMPLIED
              query 
                        CDATA 
                                  #IMPLIED
              type 
                        CDATA 
                                  #IMPLIED
              processing-role
                        (normal |
                         resource-only |
                         -dita-use-conref-target)
                                  'resource-only'
              scope 
                        (external | 
                         local | 
                         peer | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              format 
                        CDATA 
                                  #IMPLIED
              toc 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  'no'
              %univ-atts;"
>
<!ELEMENT topicprompt    %topicprompt.content;>
<!ATTLIST topicprompt    %topicprompt.attributes;>


<!--                    LONG NAME: Topic Apply                     -->
<!ENTITY % topicapply.content
                       "((%topicmeta;)?,
                         (%data.elements.incl; |
                          %promptref; |
                          %topicref;)*)"
>
<!ENTITY % topicapply.attributes
             "navtitle 
                        CDATA 
                                  #IMPLIED
              href 
                        CDATA 
                                  #IMPLIED
              keyref 
                        CDATA 
                                  #IMPLIED
              keys 
                        CDATA 
                                  #IMPLIED
              query 
                        CDATA 
                                  #IMPLIED
              collection-type 
                        (choice | 
                         family | 
                         sequence | 
                         unordered |
                         -dita-use-conref-target) 
                                  #IMPLIED
              type 
                        CDATA 
                                  #IMPLIED
              processing-role
                        (normal |
                         resource-only |
                         -dita-use-conref-target)
                                  'resource-only'
              scope 
                        (external | 
                         local | 
                         peer | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              format 
                        CDATA 
                                  #IMPLIED
              linking 
                        (none | 
                         normal | 
                         sourceonly | 
                         targetonly |
                         -dita-use-conref-target) 
                                  #IMPLIED
              toc 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  'no'
              %univ-atts;"
>
<!ELEMENT topicapply    %topicapply.content;>
<!ATTLIST topicapply    %topicapply.attributes;>


<!--                    LONG NAME: Prompt Reference               -->
<!ENTITY % promptref.content
                       "((%topicmeta;)?,
                         (%data.elements.incl;)*)"
>
<!ENTITY % promptref.attributes
             "navtitle 
                        CDATA 
                                  #IMPLIED
              href 
                        CDATA 
                                  #IMPLIED
              keyref 
                        CDATA 
                                  #IMPLIED
              keys 
                        CDATA 
                                  #IMPLIED
              query 
                        CDATA 
                                  #IMPLIED
              collection-type 
                        (choice | 
                         family | 
                         sequence | 
                         unordered |
                         -dita-use-conref-target) 
                                  #IMPLIED
              type 
                        CDATA 
                                  #IMPLIED
              processing-role
                        (normal |
                         resource-only |
                         -dita-use-conref-target)
                                  'resource-only'
              scope 
                        (external | 
                         local | 
                         peer | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              format 
                        CDATA 
                                  #IMPLIED
              linking 
                        (none | 
                         normal | 
                         sourceonly | 
                         targetonly |
                         -dita-use-conref-target) 
                                  #IMPLIED
              toc 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  'no'
              %univ-atts;"
>
<!ELEMENT promptref    %promptref.content;>
<!ATTLIST promptref    %promptref.attributes;>


<!--                   LONG NAME: Topic Prompt Relationship Table -->
<!ENTITY % topicPromptTable.content
                       "((%title;),
                         (%topicmeta;)?,
                         (%topicPromptHeader;)?,
                         (%topicPromptRow;)+)"
>
<!ENTITY % topicPromptTable.attributes
             "%topicref-atts-no-toc;
              %univ-atts;"
>
<!ELEMENT topicPromptTable    %topicPromptTable.content;>
<!ATTLIST topicPromptTable    %topicPromptTable.attributes;>


<!--                    LONG NAME: Topic Prompt Table Header      -->
<!-- The header defines the set of prompts for each column.
     By default, the prompt in the header cell must be a broader ancestor
         within a scheme available during processing for the prompts
         in the same column of other rows
     In the header, the topicCell serves primarily as a placeholder
         for the topic column but could also provide some constraints
         or metadata for the topics -->
<!ENTITY % topicPromptHeader.content
                       "((%topicCell;),
                         (%promptCell;)+)"
>
<!ENTITY % topicPromptHeader.attributes
             "%univ-atts;"
>
<!ELEMENT topicPromptHeader    %topicPromptHeader.content;>
<!ATTLIST topicPromptHeader    %topicPromptHeader.attributes;>


<!--                    LONG NAME: Topic Prompt Table Row         -->
<!ENTITY % topicPromptRow.content
                       "((%topicCell;),
                         (%promptCell;)+)"
>
<!ENTITY % topicPromptRow.attributes
             "%univ-atts;"
>
<!ELEMENT topicPromptRow    %topicPromptRow.content;>
<!ATTLIST topicPromptRow    %topicPromptRow.attributes;>


<!--                    LONG NAME: Topic Prompt Table Cell        -->
<!ENTITY % topicCell.content
                       "((%data.elements.incl; |
                          %topicref;)+)"
>
<!ENTITY % topicCell.attributes
             "%univ-atts;
              %topicref-atts;"
>
<!ELEMENT topicCell    %topicCell.content;>
<!ATTLIST topicCell    %topicCell.attributes;>


<!--                    LONG NAME: Topic Prompt Cell              -->
<!ENTITY % promptCell.content
                       "((%data.elements.incl; |
                          %promptref; |
                          %topicref;)*)"
>
<!ENTITY % promptCell.attributes
             "%univ-atts;
              %topicref-atts;"
>
<!ELEMENT promptCell    %promptCell.content;>
<!ATTLIST promptCell    %promptCell.attributes;>


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST topicprompt %global-atts;
    class CDATA "+ map/topicref classify-d/topicprompt ">
<!ATTLIST topicapply %global-atts;
    class CDATA "+ map/topicref classify-d/topicapply ">
<!ATTLIST promptref %global-atts;
    class CDATA "+ map/topicref classify-d/promptref ">
<!ATTLIST topicPromptTable %global-atts;
    class CDATA "+ map/reltable classify-d/topicPromptTable ">
<!ATTLIST topicPromptHeader %global-atts;
    class CDATA "+ map/relrow classify-d/topicPromptHeader ">
<!ATTLIST topicPromptRow %global-atts;
    class CDATA "+ map/relrow classify-d/topicPromptRow ">
<!ATTLIST topicCell %global-atts;
    class CDATA "+ map/relcell classify-d/topicCell ">
<!ATTLIST promptCell %global-atts;
    class CDATA "+ map/relcell classify-d/promptCell ">

<!-- ================== DITA Prompt Classification Domain  ====== -->
