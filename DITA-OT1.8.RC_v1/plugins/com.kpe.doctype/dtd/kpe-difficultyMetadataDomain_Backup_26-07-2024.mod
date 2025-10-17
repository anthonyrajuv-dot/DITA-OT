<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    KPE DITA Difficulty Metadata Domain               -->
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
PUBLIC "-//KPE//ELEMENTS DITA KPE Difficulty Metadata Domain//EN"
      Delivered as file "kpe-difficultyMetadataDomain.mod"         -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the elements and specialization         -->
<!--             attributes for KPE Difficulty Metadata            -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             August 2015                                       -->
<!--                                                               -->
<!--             (C) Copyright Kaplan 2015          .              -->
<!--             All Rights Reserved.                              -->
<!--                                                               -->
<!-- UPDATED:                                                      -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->


<!ENTITY % difficulty                 "difficulty"                 >

<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!-- KPE Difficulty                                                -->
<!-- doc:Difficulty support                                        -->
<!ENTITY % difficulty.content
                       "(#PCDATA)*"
>
<!ENTITY % difficulty.attributes
              "name
                        CDATA
                                  'difficulty'
              %univ-atts;
              value
                        (basic
                        | intermediate
                        | advanced)
                                  #REQUIRED
"
>


<!ELEMENT difficulty    %difficulty.content;>
<!ATTLIST difficulty    %difficulty.attributes;>


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST difficulty       %global-atts; 
    class CDATA "+ topic/data kpe-difficultyMeta-d/difficulty ">

   