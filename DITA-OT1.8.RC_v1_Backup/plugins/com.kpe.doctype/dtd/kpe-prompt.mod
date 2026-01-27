<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    KPE DITA Prompt                                 -->
<!--  VERSION:   1.1                                               -->
<!--  CM VERSION: 1.1                                              -->
<!--  DATE:      March 2025                                      -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identfier or an 
      appropriate system identifier 
PUBLIC "-//KPE//ELEMENTS DITA KPE Prompt//EN"
      Delivered as file "kpe-prompt.mod                          -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the elements and specialization         -->
<!--             attributes for prompt topic                     -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             July 2013                                         -->
<!--                                                               -->
<!--             (C) Copyright Kaplan 2013          .              -->
<!--             All Rights Reserved.                              -->
<!--                                                               -->
<!-- UPDATED:                                                      -->
<!-- 01.08.2014 ARS: changed "body" to "Body"                      -->
<!-- 11.17.2014 PSB: Added CM version to header                    -->
<!-- ============================================================= -->


<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

<!ENTITY % kpe-prompt     "kpe-prompt">
<!ENTITY % kpe-promptBody "kpe-promptBody">

<!-- ============================================================= -->
<!--                    SHARED ATTRIBUTE LISTS                     -->
<!-- ============================================================= -->

<!ENTITY % kpe-prompt-info-types "no-topic-nesting">
<!ENTITY included-domains 
  ""
>

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!--                    LONG NAME: Assessment             -->
<!ENTITY % kpe-prompt.content
                        "((%title;),
                          (%titlealts;)?,
                          (%shortdesc;)?,
                          (%prolog;)?,
                          (%kpe-promptBody;),
                          (%related-links;)?,
                          (%kpe-prompt-info-types;)* )"
>
<!ENTITY % kpe-prompt.attributes
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
<!ELEMENT kpe-prompt    %kpe-prompt.content;>
<!ATTLIST kpe-prompt
              %kpe-prompt.attributes;
              %arch-atts;
              domains 
                        CDATA
                                  "&included-domains;"
>

<!--                    LONG NAME: prompt Body        -->
<!ENTITY % kpe-promptBody.content
                        "((%lcIntro;)?,
                          (%lcObjectives;)?,
                          (%lcDuration;)?,
                          (%lcInteraction;)*,
                          (%section;)*,
                          (%lcSummary;)?,
                          (%issue;)?,
                          (%rules;)?,
                          (%analysis;)?,
                          (%conclusion;)?)"
>
<!ENTITY % kpe-promptBody.attributes
             "%univ-atts;
              outputclass
                        CDATA
                                  #IMPLIED"
>
<!ELEMENT kpe-promptBody   %kpe-promptBody.content;>
<!ATTLIST kpe-promptBody   %kpe-promptBody.attributes;>

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->
 
<!ATTLIST kpe-prompt        %global-atts; 
    class CDATA "- topic/topic learningBase/learningBase learningAssessment/learningAssessment kpe-prompt/kpe-prompt ">
<!ATTLIST kpe-promptBody    %global-atts; 
    class CDATA "- topic/body  learningBase/learningBasebody learningAssessment/learningAssessmentbody kpe-prompt/kpe-promptBody ">




