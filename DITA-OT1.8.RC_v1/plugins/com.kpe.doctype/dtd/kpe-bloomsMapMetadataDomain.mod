<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    KPE DITA Bloooms Map Metadata Domain               -->
<!--  VERSION:   1.0                                               -->
<!--  CM VERSION 2.1                                               -->
<!--  DATE:      May 2019                                          -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identifier or an 
      appropriate system identifier 
PUBLIC "-//KPE//ELEMENTS DITA KPE Blooms Map Metadata Domain//EN"
      Delivered as file "kpe-bloomsMapMetadataDomain.mod"          -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the elements and specialization         -->
<!--             attributes for KPE Blooms Map Metadata            -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             May 2019                                          -->
<!--                                                               -->
<!--             (C) Copyright Kaplan 2019          .              -->
<!--             All Rights Reserved.                              -->
<!--                                                               -->
<!-- UPDATED:                                                      -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->


<!ENTITY % bloomsMap                 "bloomsMap"                     >

<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!-- KPE bloomsMap                                                 -->
<!-- doc:support Blooms Taxonomy on maps                           -->
<!ENTITY % bloomsMap.content
                       "(#PCDATA)*"
>
<!ENTITY % bloomsMap.attributes
              "name
                        CDATA
                                  'bloomsMap'
              %univ-atts;
              value
                        (Creating
                        | Evaluating
                        | Analyzing
                        | Applying
                        | Understanding
                        | Identifying
                        | Remembering)
                                  #REQUIRED
"
>


<!ELEMENT bloomsMap    %bloomsMap.content;>
<!ATTLIST bloomsMap    %bloomsMap.attributes;>


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST bloomsMap       %global-atts; 
    class CDATA "+ topic/data kpe-bloomsMapMeta-d/bloomsMap ">

   