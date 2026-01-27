<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    KPE DITA sortOrder  Metadata Domain               -->
<!--  VERSION:   1.0                                               -->
<!--  CM VERSION 2.1                                               -->
<!--  DATE:      December 2016                                     -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identifier or an 
      appropriate system identifier 
PUBLIC "-//KPE//ELEMENTS DITA KPE sortOrder Metadata Domain//EN"
      Delivered as file "kpe-sortOrderMetadataDomain.mod"         -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the elements and specialization         -->
<!--             attributes for KPE sortOrder Metadata             -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             December 2016                                     -->
<!--                                                               -->
<!--             (C) Copyright Kaplan 2016          .              -->
<!--             All Rights Reserved.                              -->
<!--                                                               -->
<!-- UPDATED:                                                      -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->


<!ENTITY % sortOrder                 "sortOrder"                     >

<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!-- KPE sortOrder                                                 -->
<!-- doc:sortOrder support                                        -->
<!ENTITY % sortOrder.content
                       "(#PCDATA)*"
>
<!ENTITY % sortOrder.attributes
              "%univ-atts;"
>


<!ELEMENT sortOrder    %sortOrder.content;>
<!ATTLIST sortOrder    %sortOrder.attributes;>


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST sortOrder       %global-atts; 
    class CDATA "+ topic/data kpe-sortOrderMeta-d/sortOrder ">

   