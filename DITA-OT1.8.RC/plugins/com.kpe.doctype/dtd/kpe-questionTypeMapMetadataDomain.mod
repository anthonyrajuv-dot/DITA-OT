<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    KPE DITA questionType Map Metadata Domain         -->
<!--  VERSION:   1.0                                               -->
<!--  CM VERSION 2.1                                               -->
<!--  DATE:      April 2020                                        -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identifier or an 
      appropriate system identifier 
PUBLIC "-//KPE//ELEMENTS DITA KPE questionType Map Metadata Domain//EN"
      Delivered as file "kpe-questionTypeMapMetadataDomain.mod"    -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the elements and specialization         -->
<!--             attributes for KPE questionType Map Metadata      -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--            April 2020                                         -->
<!--                                                               -->
<!--             (C) Copyright Kaplan 2020          .              -->
<!--             All Rights Reserved.                              -->
<!--                                                               -->
<!-- UPDATED:                                                      -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->


<!ENTITY % questionType                 "questionType"               >

<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!-- KPE questionType                                              -->
<!-- doc:support questionType on maps                              -->
<!ENTITY % questionType.content
                       "(#PCDATA)*"
>
<!ENTITY % questionType.attributes
              "name
                        CDATA
                       'questionType'
              %univ-atts;
              value
                        (fundamental
                        | applied)
                                  #REQUIRED
"
>


<!ELEMENT questionType    %questionType.content;>
<!ATTLIST questionType    %questionType.attributes;>


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST questionType       %global-atts; 
    class CDATA "+ topic/data kpe-questionTypeMapMeta-d/questionTypeMap ">

   