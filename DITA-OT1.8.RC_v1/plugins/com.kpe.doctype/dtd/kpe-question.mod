<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    KPE DITA Question                                 -->
<!--  VERSION:   1.2                                               -->
<!--  CM VERSION: 2.1                                              -->
<!--  DATE:      January 2014                                      -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identfier or an 
      appropriate system identifier 
PUBLIC "-//KPE//ELEMENTS DITA KPE Question//EN"
      Delivered as file "kpe-question.mod                          -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the elements and specialization         -->
<!--             attributes for question topic                     -->
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

<!ENTITY % kpe-question     "kpe-question">
<!ENTITY % kpe-questionBody "kpe-questionBody">

<!-- ============================================================= -->
<!--                    SHARED ATTRIBUTE LISTS                     -->
<!-- ============================================================= -->

<!ENTITY % kpe-question-info-types "no-topic-nesting">
<!ENTITY included-domains 
  ""
>

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!--                    LONG NAME: Assessment             -->
<!ENTITY % kpe-question.content
                        "((%title;),
                          (%titlealts;)?,
                          (%shortdesc;)?,
                          (%prolog;)?,
                          (%kpe-questionBody;),
                          (%related-links;)?,
                          (%kpe-question-info-types;)* )"
>
<!ENTITY % kpe-question.attributes
             "id
                        ID 
                                  #REQUIRED
              %conref-atts;
              %select-atts;
              %localization-atts;
              questiontype CDATA #IMPLIED
              outputclass CDATA #IMPLIED"
>
<!ELEMENT kpe-question    %kpe-question.content;>
<!ATTLIST kpe-question
              %kpe-question.attributes;
              %arch-atts;
              domains 
                        CDATA
                                  "&included-domains;"
>

<!--                    LONG NAME: question Body        -->
<!ENTITY % kpe-questionBody.content
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
<!ENTITY % kpe-questionBody.attributes
             "%univ-atts;
              outputclass
                        CDATA
                                  #IMPLIED"
>
<!ELEMENT kpe-questionBody   %kpe-questionBody.content;>
<!ATTLIST kpe-questionBody   %kpe-questionBody.attributes;>

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->
 
<!ATTLIST kpe-question        %global-atts; 
    class CDATA "- topic/topic learningBase/learningBase learningAssessment/learningAssessment kpe-question/kpe-question ">
<!ATTLIST kpe-questionBody    %global-atts; 
    class CDATA "- topic/body  learningBase/learningBasebody learningAssessment/learningAssessmentbody kpe-question/kpe-questionBody ">




