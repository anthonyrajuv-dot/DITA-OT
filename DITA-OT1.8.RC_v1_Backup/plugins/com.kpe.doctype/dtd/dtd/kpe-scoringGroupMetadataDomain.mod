<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    KPE DITA scoringGroup Metadata Domain               -->
<!--  VERSION:   1.0                                               -->
<!--  CM VERSION 2.1                                               -->
<!--  DATE:      August 2015                                       -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identifier or an 
      appropriate system identifier 
PUBLIC "-//KPE//ELEMENTS DITA KPE scoringGroup Metadata Domain//EN"
      Delivered as file "kpe-scoringGroupMetadataDomain.mod"         -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the elements and specialization         -->
<!--             attributes for KPE scoringGroup Metadata            -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             August 2024                                       -->
<!--                                                               -->
<!--             (C) Copyright Kaplan 2024          .              -->
<!--             All Rights Reserved.                              -->
<!--                                                               -->
<!-- UPDATED:                                                      -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->


<!ENTITY % scoringGroup                 "scoringGroup"                 >

<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!-- KPE scoringGroup                                                -->
<!-- doc:scoringGroup support                                        -->
<!ENTITY % scoringGroup.content
                       "(#PCDATA)*"
>
<!ENTITY % scoringGroup.attributes
           "keyref CDATA #IMPLIED
           %univ-atts;
           "
>


<!ELEMENT scoringGroup    %scoringGroup.content;>
<!ATTLIST scoringGroup    %scoringGroup.attributes;>


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST scoringGroup       %global-atts; 
    class CDATA "+ topic/data kpe-scoringGroupMeta-d/scoringGroup ">

   