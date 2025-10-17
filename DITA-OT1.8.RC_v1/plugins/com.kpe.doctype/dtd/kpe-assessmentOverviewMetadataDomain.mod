<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    KPE DITA Assessment Overview Metadata Domain      -->
<!--  VERSION:   1.2                                               -->
<!--  CM VERSION 2.0                                               -->
<!--  DATE:      July 2013                                         -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identifier or an 
      appropriate system identifier 
PUBLIC "-//KPE//ELEMENTS DITA KPE Assessment Overview Metadata Domain//EN"
      Delivered as file "kpe-assessmentOverviewMetadataDomain.mod" -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the elements and specialization         -->
<!--             attributes for KPE Assessment Overview Metadata   -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             July 2013                                         -->
<!--                                                               -->
<!--             (C) Copyright Kaplan 2013                         -->
<!--             All Rights Reserved.                              -->
<!--                                                               -->
<!-- UPDATED:                                                      -->
<!-- 2014.11.07 PSB: Added CM Version in header, removed assessmentType-->
<!-- 2016.04.29 Scriptorium: Added minimumPassScore for scorm output-->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->

<!ENTITY % questionRandomize                "questionRandomize">
<!ENTITY % distractorRandomize              "distractorRandomize">
<!ENTITY % minimumPassScore              "minimumPassScore">

<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->


<!-- KPE Question Randomize                                       -->
<!-- doc:Indicates if the questions should be randomized.         -->
<!ENTITY % questionRandomize.content
                       "EMPTY"
>
<!ENTITY % questionRandomize.attributes
          "name
                        CDATA
                                  'QuestionRandomize'
           %univ-atts;
              value
                        (yes
                         | no)
                                  #REQUIRED"
>
<!ELEMENT questionRandomize    %questionRandomize.content;>
<!ATTLIST questionRandomize    %questionRandomize.attributes;>

<!-- KPE Distractor Randomize                                     -->
<!-- doc:Indicates if the distractors should be randomized.       -->
<!ENTITY % distractorRandomize.content
                       "EMPTY"
>
<!ENTITY % distractorRandomize.attributes
          "name
                        CDATA
                                  'DistractorRandomize'
           %univ-atts;
              value
                        (yes
                         | no)
                                  #REQUIRED"
>
<!ELEMENT distractorRandomize    %distractorRandomize.content;>
<!ATTLIST distractorRandomize    %distractorRandomize.attributes;>

<!-- KPE Minimum Pass Score                                       -->
<!-- doc:Value determines the minimum score needed to pass an assessment.         -->
<!ENTITY % minimumPassScore.content
                       "EMPTY"
>
<!ENTITY % minimumPassScore.attributes
          "name
                        CDATA
                                  'minimumPassScore'
           %univ-atts;
              value
                        CDATA
                                  #IMPLIED"
>
<!ELEMENT minimumPassScore    %minimumPassScore.content;>
<!ATTLIST minimumPassScore    %minimumPassScore.attributes;>


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->
 

<!ATTLIST questionRandomize        %global-atts; 
    class CDATA "+ topic/data kpe-assessmentOverviewMeta-d/questionRandomize ">
<!ATTLIST distractorRandomize         %global-atts; 
    class CDATA "+ topic/data kpe-assessmentOverviewMeta-d/distractorRandomize ">
<!ATTLIST minimumPassScore         %global-atts; 
    class CDATA "+ topic/data kpe-assessmentOverviewMeta-d/minimumPassScore ">

   