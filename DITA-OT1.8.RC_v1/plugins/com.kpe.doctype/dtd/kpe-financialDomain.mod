<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    KPE DITA Financial Elements                       -->
<!--  VERSION:   1.0                                               -->
<!--  CM VERSION 2.1                                               -->
<!--  DATE:      July 2013                                         -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identifier or an 
      appropriate system identifier 
PUBLIC "-//KPE//ELEMENTS DITA KPE Financial Elements Domain//EN"
      Delivered as file "kpe-financialDomain.mod"                  -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the elements and specialization         -->
<!--             attributes for financial content elements used in -->
<!--             topics.                                           -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             July 2013                                         -->
<!--                                                               -->
<!--             (C) Copyright Kaplan 2013                         -->
<!--             All Rights Reserved.                              -->
<!--                                                               -->
<!-- UPDATED:                                                      -->
<!-- 2014.11.07 PSB: Added CM Version in header                    -->
<!-- ============================================================= -->


<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->

<!ENTITY % sum                             "sum">
<!ENTITY % total                           "total">


<!--                    LONG NAME: sum of values                    -->
<!ENTITY % sum.content
                       "(%ph.cnt; |
                         %text;)*"
>
<!ENTITY % sum.attributes
             "keyref 
                        CDATA 
                                  #IMPLIED
              %univ-atts;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT sum    %sum.content;>
<!ATTLIST sum    %sum.attributes;>


<!--                    LONG NAME: total of values                    -->
<!ENTITY % total.content
                       "(%ph.cnt; |
                         %text;)*"
>
<!ENTITY % total.attributes
             "keyref 
                        CDATA 
                                  #IMPLIED
              %univ-atts;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT total    %total.content;>
<!ATTLIST total    %total.attributes;>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
   - CLASS ATTRIBUTES FOR ANCESTRY DECLARATION
   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


<!ATTLIST sum          %global-atts;
    class CDATA "+ topic/ph kpe-financial-d/sum ">

<!ATTLIST total          %global-atts;
    class CDATA "+ topic/ph kpe-financial-d/total ">

    