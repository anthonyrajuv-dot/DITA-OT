<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    KPE DITA Common Metadata Domain                   -->
<!--  VERSION:   1.3                                               -->
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
PUBLIC "-//KPE//ELEMENTS DITA KPE Common Metadata Domain//EN"
      Delivered as file "kpe-commonMetadataDomain.mod"             -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the elements and specialization         -->
<!--             attributes for KPE Common Metadata                -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             May 2013                                          -->
<!--                                                               -->
<!--             (C) Copyright Kaplan 2013                         -->
<!--             All Rights Reserved.                              -->
<!--                                                               -->
<!-- UPDATED:                                                      -->
<!-- UPDATED:                                                      -->
<!-- ARS: removed KPE prefix from all elements                     -->
<!-- ARS: moved KPEDuration to duration domain                     -->
<!-- ARS: moved KPECompletion to completion domain                 -->
<!-- ARS: moved KPEPointValue to question metadata domain          -->
<!-- ARS: moved KPETaskCategory to task domain                     -->
<!-- ARS: removed <KPEmeta>                                        -->
<!-- 2013.08.23 ARS: added <duration>                              -->
<!-- 2014.11.07 PSB: Added CM Version in header, added lmsCategory,
     added royalty                                                 -->
<!-- 2018.09.12 PSB: Added test_flashcards to lmsCategory          -->     
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->

<!ENTITY % subject                          "subject"                >
<!ENTITY % modality                         "modality"               >
<!ENTITY % legacyID                         "legacyID"               >
<!ENTITY % duration                         "duration"               >
<!ENTITY % lmsCategory                      "lmsCategory"            >
<!ENTITY % royalty                           "royalty"               >

<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!-- KPE Subject                                                   -->
<!-- doc:Subject for topic.                                        -->

<!ENTITY % subject.content
                       "(#PCDATA)*"
>
<!ENTITY % subject.attributes
              "%univ-atts;"
>

<!ELEMENT subject    %subject.content;>
<!ATTLIST subject    %subject.attributes;>

<!-- KPE Modality                                                 -->
<!-- doc:Modality for topic.                                      -->

<!ENTITY % modality.content
                       "(#PCDATA)*"
>
<!ENTITY % modality.attributes
              "%univ-atts;"
>

<!ELEMENT modality    %modality.content;>
<!ATTLIST modality    %modality.attributes;>

<!-- KPE Legacy ID                                             -->
<!-- doc:identifier from previous system.                      -->

<!ENTITY % legacyID.content
                       "EMPTY"
>
<!ENTITY % legacyID.attributes
           "name
                        CDATA
                                  'LegacyID'
              %univ-atts;
              value
                        CDATA
                                  #REQUIRED"
>
<!ELEMENT legacyID    %legacyID.content;>
<!ATTLIST legacyID    %legacyID.attributes;>

<!-- KPE Duration                                                 -->
<!-- doc:Duration in minutes for topic.                           -->
<!ENTITY % duration.content
                       "EMPTY"
>
<!ENTITY % duration.attributes
             "%univ-atts;
              value
                        CDATA
                                  #REQUIRED"
>
<!ELEMENT duration    %duration.content;>
<!ATTLIST duration    %duration.attributes;>

<!--                    LONG NAME: lms category                     -->
<!ENTITY % lmsCategory.content
                       "(#PCDATA)*"
>
<!ENTITY % lmsCategory.attributes
              "name
                        CDATA
                                  'lmsCategory'
              %univ-atts;
              value
                        (activity
                         | default
                         | presentation
                         | reading
                         | video_activity
                         | test_exam_primary
                         | test_exam_secondary
                         | test_flashcards
                         | test_quiz 
                         | test_practice
                         | test_qbank
                         | test_assignment
                         | test_topic_practice
                         | -dita-use-conref-target)
                                  #REQUIRED
"
>

<!ELEMENT lmsCategory    %lmsCategory.content;>
<!ATTLIST lmsCategory    %lmsCategory.attributes;>

<!--                    LONG NAME: royalty content                     -->
<!ENTITY % royalty.content
                       "(#PCDATA)*"
>
<!ENTITY % royalty.attributes
              "name
                        CDATA
                                  'royalty'
              %univ-atts;
              value
                        (yes
                         | no)
                                  #REQUIRED
"
>

<!ELEMENT royalty    %royalty.content;>
<!ATTLIST royalty    %royalty.attributes;>


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->


<!ATTLIST subject         %global-atts; 
    class CDATA "+ topic/data kpe-commonMeta-d/subject ">

<!ATTLIST modality         %global-atts; 
    class CDATA "+ topic/data kpe-commonMeta-d/modality ">

<!ATTLIST legacyID         %global-atts; 
    class CDATA "+ topic/data kpe-commonMeta-d/legacyID ">

<!ATTLIST duration        %global-atts; 
    class CDATA "+ topic/data kpe-commonMeta-d/duration ">

<!ATTLIST lmsCategory %global-atts;
    class CDATA "+ topic/data kpe-commonMeta-d/lmsCategory ">
    
<!ATTLIST royalty %global-atts;
    class CDATA "+ topic/data kpe-commonMeta-d/royalty ">