<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    Kaplan Professional Education DITA Learning Domain  -->
<!--  VERSION:   1.1                                               -->
<!--  CM VERSION 2.1                                               -->
<!--  DATE:      July 2013                                          -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identfier or an 
      appropriate system identifier 
PUBLIC "-//KPE//ELEMENTS DITA KPE Question Elements Domain//EN"
      Delivered as file "kpe-questionDomain.mod"                   -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the elements and specialization         -->
<!--             attributes for Question Domain                    -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             May 2013                                          -->
<!--                                                               -->
<!--             (C) Copyright Kaplan 2013                         -->
<!--             All Rights Reserved.                              -->
<!--  UPDATES:                                                     -->
<!-- 2014.11.07 PSB: Added CM Version in header                    -->
<!-- ============================================================= -->

 
<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->

<!ENTITY % qualifier             "qualifier">


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->
<!--                    LONG NAME: Qualifier      --> 
<!ENTITY % qualifier.content 
                       "(%ph.cnt; |
                         %text;)*" 
> 
<!ENTITY % qualifier.attributes 
             "keyref 
                        CDATA 
                                  #IMPLIED 
              %univ-atts-translate-no; 
              outputclass 
                        CDATA 
                                  #IMPLIED" 
> 
<!ELEMENT qualifier    %qualifier.content;> 
<!ATTLIST qualifier    %qualifier.attributes;> 

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   - CLASS ATTRIBUTES FOR ANCESTRY DECLARATION
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

<!ATTLIST qualifier   %global-atts;  
    class CDATA "+ topic/ph kpe-question-d/qualifier "    > 

<!-- End of declaration set -->
