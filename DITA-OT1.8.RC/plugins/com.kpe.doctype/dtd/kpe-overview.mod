<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    KPE DITA Learning Overview Elements               -->
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
PUBLIC "-//KPE//ELEMENTS DITA KPE Overview//EN"
      Delivered as file "kpe-overview.mod"                         -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    DITA Learning Overview topic elements             -->
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

<!ENTITY % kpe-overview "kpe-overview">
<!ENTITY % kpe-overviewBody "kpe-overviewBody">

<!-- ============================================================= -->
<!--                    SHARED ATTRIBUTE LISTS                     -->
<!-- ============================================================= -->

<!ENTITY % kpe-overview-info-types "no-topic-nesting">
<!ENTITY included-domains        "" >

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!--                    LONG NAME: KPE overview                     -->
<!ENTITY % kpe-overview.content
                        "((%title;),
                          (%titlealts;)?,
                          (%shortdesc; | 
                           %abstract;)?,
                          (%prolog;)?,
                          (%kpe-overviewBody;),
                          (%related-links;)?,
                          (%kpe-overview-info-types;)* )"
>
<!ENTITY % kpe-overview.attributes
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
<!ELEMENT kpe-overview    %kpe-overview.content;>
<!ATTLIST kpe-overview
              %kpe-overview.attributes;
              %arch-atts;
              domains 
                        CDATA
                                  "&included-domains;"
>

<!--                    LONG NAME: Overview Body                  -->
<!ENTITY % kpe-overviewBody.content
                        "((%lcIntro;)?,
                         (%lcAudience;)*,
                         (%lcDuration;)?,
                         (%lcPrereqs;)?,
                         (%lcObjectives;)?,
                         (%lcResources;)?,
                         (%section;)*)  "
>
<!ENTITY % kpe-overviewBody.attributes
             "%univ-atts;
              outputclass
                        CDATA
                                  #IMPLIED"
>
<!ELEMENT kpe-overviewBody     %kpe-overviewBody.content;>
<!ATTLIST kpe-overviewBody     %kpe-overviewBody.attributes;>

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST kpe-overview        %global-atts; 
    class CDATA "- topic/topic learningBase/learningBase learningOverview/learningOverview kpe-overview/kpe-overview ">
<!ATTLIST kpe-overviewBody    %global-atts; class CDATA "- topic/body  learningBase/learningBasebody learningOverview/learningOverviewbody kpe-overview/kpe-overviewBody ">
