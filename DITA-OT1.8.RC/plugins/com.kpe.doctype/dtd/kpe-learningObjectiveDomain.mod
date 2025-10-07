<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    KPE DITA Learning Objective Element               -->
<!--  VERSION:   1.0                                               -->
<!--  CM VERSION 2.1                                               -->
<!--  DATE:      November 2014                                     -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identifier or an 
      appropriate system identifier 
PUBLIC "-//KPE//ELEMENTS DITA KPE Common Elements Domain//EN"
      Delivered as file "kpe-commonDomain.mod"                     -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the elements and specialization         -->
<!--             attributes for content elements used in both      -->
<!--             topics and maps.                                  -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             May 2013                                          -->
<!--                                                               -->
<!--             (C) Copyright Kaplan 2013                         -->
<!--             All Rights Reserved.                              -->
<!--                                                               -->
<!-- UPDATED:                                                      -->
<!-- ARS: removed KPE prefix from all elements                     -->
<!-- ARS: changed KPEForeign to foreignWord                        -->
<!-- ARS: added emphasisBold and emphasisItalics                   -->
<!-- 2014.01.03 PSB: added legalCite                               -->
<!-- 2014.11.07 PSB: Added CM Version in header                    -->
<!-- 2015.07.23 PSB: Added commandWord                             -->
<!-- ============================================================= -->


<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->

<!ENTITY % callout                         "callout">
<!ENTITY % sample                          "sample">
<!ENTITY % label                           "label">

<!ENTITY % foreignWord                     "foreignWord">
<!ENTITY % emphasisBold                    "emphasisBold">
<!ENTITY % emphasisItalics                 "emphasisItalics">
<!ENTITY % commandWord                     "commandWord">

<!ENTITY % legalCite                       "legalCite">

<!--                    LONG NAME: callout                        -->
<!ENTITY % callout.content
    "(%note.cnt;|%label;)*"
>
<!ENTITY % callout.attributes
             "type 
                        (other) 
                                  'other' 
              spectitle 
                        CDATA 
                                  #IMPLIED
              othertype 
                        CDATA 
                                  'callout'
              %univ-atts;
              outputclass
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT callout    %callout.content;>
<!ATTLIST callout    %callout.attributes;>


<!--                    LONG NAME: KPE sample                -->
<!ENTITY % sample.content
    "(%note.cnt;|%label;)*"
>
<!ENTITY % sample.attributes
             "type 
                        (other) 
                                  'other' 
              spectitle 
                        CDATA 
                                  #IMPLIED
              othertype 
                        CDATA 
                                  'sample'
              %univ-atts;
              outputclass
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT sample             %sample.content;>
<!ATTLIST sample             %sample.attributes;>

<!--                  LONG NAME: KPE label                -->
<!ENTITY % label.content
                       "(%para.cnt;)*"
>
<!ENTITY % label.attributes
             "%univ-atts;
              outputclass
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT label    %label.content;>
<!ATTLIST label    %label.attributes;>


<!--                 LONG NAME: foreign word or phrase                    -->
<!ENTITY % foreignWord.content
                       "(%ph.cnt; |
                         %text;)*"
>
<!ENTITY % foreignWord.attributes
             "keyref 
                        CDATA 
                                  #IMPLIED
              %univ-atts;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT foreignWord    %foreignWord.content;>
<!ATTLIST foreignWord    %foreignWord.attributes;>

<!--                    LONG NAME: emphasis Bold                    -->
<!ENTITY % emphasisBold.content
                       "(%ph.cnt; |
                         %text;)*"
>
<!ENTITY % emphasisBold.attributes
             "keyref 
                        CDATA 
                                  #IMPLIED
              %univ-atts;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT emphasisBold    %emphasisBold.content;>
<!ATTLIST emphasisBold    %emphasisBold.attributes;>

<!--                    LONG NAME: emphasis Italics                    -->
<!ENTITY % emphasisItalics.content
                       "(%ph.cnt; |
                         %text;)*"
>
<!ENTITY % emphasisItalics.attributes
             "keyref 
                        CDATA 
                                  #IMPLIED
              %univ-atts;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT emphasisItalics    %emphasisItalics.content;>
<!ATTLIST emphasisItalics    %emphasisItalics.attributes;>

<!--                    LONG NAME: command word                    -->
<!ENTITY % commandWord.content
                       "(%ph.cnt; |
                         %text;)*"
>
<!ENTITY % commandWord.attributes
             "keyref 
                        CDATA 
                                  #IMPLIED
              %univ-atts;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT commandWord    %commandWord.content;>
<!ATTLIST commandWord    %commandWord.attributes;>

<!--                    LONG NAME: legal citation                     -->
<!ENTITY % legalCite.content
                       "(%xrefph.cnt;)*"
>
<!ENTITY % legalCite.attributes
             "keyref 
                        CDATA 
                                  #IMPLIED
              %univ-atts;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT legalCite    %legalCite.content;>
<!ATTLIST legalCite    %legalCite.attributes;>




<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   - CLASS ATTRIBUTES FOR ANCESTRY DECLARATION
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
 
<!ATTLIST callout  %global-atts;
    class CDATA "+ topic/note  kpe-common-d/callout ">
<!ATTLIST sample  %global-atts;
    class CDATA "+ topic/note  kpe-common-d/sample ">
<!ATTLIST label %global-atts;
    class CDATA "+ topic/p  kpe-common-d/label ">

<!ATTLIST foreignWord %global-atts;
    class CDATA "+ topic/ph kpe-common-d/foreignWord ">
<!ATTLIST emphasisBold %global-atts;
    class CDATA "+ topic/ph kpe-common-d/emphasisBold ">
<!ATTLIST emphasisItalics %global-atts;
    class CDATA "+ topic/ph kpe-common-d/emphasisItalics ">
 <!ATTLIST commandWord %global-atts;
    class CDATA "+ topic/ph kpe-common-d/commandWord ">
    
<!ATTLIST legalCite %global-atts;
    class CDATA "+ topic/cite kpe-common-d/legalCite ">


    