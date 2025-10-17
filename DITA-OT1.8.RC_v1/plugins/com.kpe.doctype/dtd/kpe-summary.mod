<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    KPE DITA Learning Summary Elements                -->
<!--  VERSION:   1.1                                               -->
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
PUBLIC "-//KPE//ELEMENTS DITA KPE Summary//EN"
      Delivered as file "kpe-summary.mod"                          -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    DITA Learning Summary topic elements              -->
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

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

<!ENTITY % kpe-summary "kpe-summary">
<!ENTITY % kpe-summaryBody "kpe-summaryBody">

<!-- ============================================================= -->
<!--                    SHARED ATTRIBUTE LISTS                     -->
<!-- ============================================================= -->

<!ENTITY % kpe-summary-info-types "no-topic-nesting">
<!ENTITY included-domains        "" >

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!--                    LONG NAME: KPE summary                     -->
<!ENTITY % kpe-summary.content
                        "((%title;),
                          (%titlealts;)?,
                          (%shortdesc; | 
                           %abstract;)?,
                          (%prolog;)?,
                          (%kpe-summaryBody;),
                          (%related-links;)?,
                          (%kpe-summary-info-types;)* )"
>
<!ENTITY % kpe-summary.attributes
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
<!ELEMENT kpe-summary    %kpe-summary.content;>
<!ATTLIST kpe-summary
              %kpe-summary.attributes;
              %arch-atts;
              domains 
                        CDATA
                                  "&included-domains;"
>

<!--                    LONG NAME: Summary Body                  -->
<!ENTITY % kpe-summaryBody.content
                        "(((%lcSummary;) |
                          (%lcObjectives;) |
                          (%lcReview;) |
                          (%lcNextSteps;) |
                          (%lcResources;) |
                          (%section;))*)"
>
<!ENTITY % kpe-summaryBody.attributes
             "%univ-atts;
              outputclass
                        CDATA
                                  #IMPLIED"
>
<!ELEMENT kpe-summaryBody     %kpe-summaryBody.content;>
<!ATTLIST kpe-summaryBody     %kpe-summaryBody.attributes;>

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST kpe-summary        %global-atts; 
    class CDATA "- topic/topic learningBase/learningBase learningSummary/learningSummary kpe-summary/kpe-summary ">
<!ATTLIST kpe-summaryBody    %global-atts; class CDATA "- topic/body  learningBase/learningBasebody learningSummary/learningSummarybody kpe-summary/kpe-summaryBody ">
