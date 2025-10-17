<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    KPE DITA Concept Elements                         -->
<!--  VERSION:   1.0                                               -->
<!--  CM VERSION 2.1                                               -->
<!--  DATE:      January 2014                                      -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identifier or an 
      appropriate system identifier 
PUBLIC "-//KPE//ELEMENTS DITA KPE Concept//EN"
      Delivered as file "kpe-concept.mod"                          -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the elements and specialization         -->
<!--             attributes for KPE concept topic                  -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             January 2014                                      -->
<!--                                                               -->
<!--             (C) Copyright Kaplan 2014                         -->
<!--             All Rights Reserved.                              -->
<!--                                                               -->
<!-- UPDATED:                                                      -->
<!-- 2014.11.07 PSB: Added CM Version in header                    -->
<!-- ============================================================= -->


<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->

<!ENTITY % kpe-concept-info-types 
  "no-topic-nesting"
>
<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

<!ENTITY % kpe-concept                   "kpe-concept">
<!ENTITY % kpe-conceptBody               "kpe-conceptBody">

<!-- ============================================================= -->
<!--                    SHARED ATTRIBUTE LISTS                     -->
<!-- ============================================================= -->


<!ENTITY included-domains 
  ""
>

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!--                    LONG NAME: Learning Concept                -->
<!ENTITY % kpe-concept.content
                        "((%title;),
                          (%titlealts;)?,
                          (%abstract; | 
                          %shortdesc;)?, 
                          (%prolog;)?,
                          (%kpe-conceptBody;),
                          (%related-links;)?,
                          (%kpe-concept-info-types;)* )"
>
<!ENTITY % kpe-concept.attributes
             "id
                        ID 
                                  #REQUIRED
              %conref-atts;
              %select-atts;
              %localization-atts;
              outputclass
                        CDATA
                                  #IMPLIED"
>
<!ELEMENT kpe-concept    %kpe-concept.content;>
<!ATTLIST kpe-concept
              %kpe-concept.attributes;
              %arch-atts;
              domains 
                        CDATA
                                  "&included-domains;"
>

<!--                    LONG NAME: Concept Body                  -->
<!ENTITY % kpe-conceptBody.content
                        "((%body.cnt;)*, 
                         (%section; |
                          %example; |
                          %conbodydiv;)* )"
>
<!ENTITY % kpe-conceptBody.attributes
             "%id-atts;
              %localization-atts;
              base 
                        CDATA 
                                  #IMPLIED
              %base-attribute-extensions;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT kpe-conceptBody   %kpe-conceptBody.content;>
<!ATTLIST kpe-conceptBody   %kpe-conceptBody.attributes;>

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST kpe-concept        %global-atts;  
    class  CDATA "- topic/topic concept/concept kpe-concept/kpe-concept "        >

<!ATTLIST kpe-conceptBody    %global-atts;  
    class  CDATA "- topic/body concept/conbody kpe-concept/kpe-conceptBody " >




