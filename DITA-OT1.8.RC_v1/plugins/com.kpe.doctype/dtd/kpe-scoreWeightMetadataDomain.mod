<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    KPE DITA scoreWeight Metadata Domain               -->
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
PUBLIC "-//KPE//ELEMENTS DITA KPE scoreWeight Metadata Domain//EN"
      Delivered as file "kpe-scoreWeightMetadataDomain.mod"         -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the elements and specialization         -->
<!--             attributes for KPE scoreWeight Metadata            -->
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


<!ENTITY % scoreWeight                 "scoreWeight"                 >

<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!-- KPE scoreWeight                                                -->
<!-- doc:scoreWeight support                                        -->
<!ENTITY % scoreWeight.content
                       "(#PCDATA)*"
>
<!ENTITY % scoreWeight.attributes
           "keyref CDATA #IMPLIED
            code CDATA #IMPLIED
            %univ-atts;"
>


<!ELEMENT scoreWeight    %scoreWeight.content;>
<!ATTLIST scoreWeight    %scoreWeight.attributes;>


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST scoreWeight       %global-atts; 
    class CDATA "+ topic/data kpe-scoreWeightMeta-d/scoreWeight ">

   