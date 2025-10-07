<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    KPE DITA Assessment Overview                      -->
<!--  VERSION:   1.1                                               -->
<!--  CM VERSION 2.1                                               -->
<!--  DATE:      July 2014                                         -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identfier or an 
      appropriate system identifier 
PUBLIC "-//KPE//ELEMENTS DITA KPE Assessment Overview//EN"
      Delivered as file "kpe-assessmentOverview.mod                -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the elements and specialization         -->
<!--             attributes for Assessment Overview topic          -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             July 2013                                         -->
<!--                                                               -->
<!--             (C) Copyright Kaplan 2013                         -->
<!--             All Rights Reserved.                              -->
<!--                                                               -->
<!-- UPDATED:                                                      -->
<!-- 2014.01.08 ARS: changed "body" to "Body"                      -->
<!-- 2014.11.07 PSB: Added CM Version in header                    -->
<!-- ============================================================= -->


<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

<!ENTITY % kpe-assessmentOverview     "kpe-assessmentOverview">
<!ENTITY % kpe-assessmentOverviewBody "kpe-assessmentOverviewBody">

<!-- ============================================================= -->
<!--                    SHARED ATTRIBUTE LISTS                     -->
<!-- ============================================================= -->

<!ENTITY % kpe-assessmentOverview-info-types "no-topic-nesting">
<!ENTITY included-domains 
  ""
>

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!--                    LONG NAME: Assessment             -->
<!ENTITY % kpe-assessmentOverview.content
                        "((%title;),
                          (%titlealts;)?,
                          (%shortdesc;)?,
                          (%prolog;)?,
                          (%kpe-assessmentOverviewBody;),
                          (%related-links;)?,
                          (%kpe-assessmentOverview-info-types;)* )"
>
<!ENTITY % kpe-assessmentOverview.attributes
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
<!ELEMENT kpe-assessmentOverview    %kpe-assessmentOverview.content;>
<!ATTLIST kpe-assessmentOverview
              %kpe-assessmentOverview.attributes;
              %arch-atts;
              domains 
                        CDATA
                                  "&included-domains;"
>

<!--                    LONG NAME: Assessment Body        -->
<!ENTITY % kpe-assessmentOverviewBody.content
                        "(%section;)*"
>
<!ENTITY % kpe-assessmentOverviewBody.attributes
             "%univ-atts;
              outputclass
                        CDATA
                                  #IMPLIED"
>
<!ELEMENT kpe-assessmentOverviewBody   %kpe-assessmentOverviewBody.content;>
<!ATTLIST kpe-assessmentOverviewBody   %kpe-assessmentOverviewBody.attributes;>

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->
 
<!ATTLIST kpe-assessmentOverview        %global-atts; 
    class CDATA "- topic/topic   kpe-assessmentOverview/kpe-assessmentOverview ">
<!ATTLIST kpe-assessmentOverviewBody    %global-atts; 
    class CDATA "- topic/body   kpe-assessmentOverview/kpe-assessmentOverviewBody ">




