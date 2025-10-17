<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    KPE DITA Kaplan Way Metadata Domain               -->
<!--  VERSION:   1.0                                               -->
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
PUBLIC "-//KPE//ELEMENTS DITA KPE Kaplan Way Metadata Domain//EN"
      Delivered as file "kpe-KaplanWayMetadataDomain.mod"         -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the elements and specialization         -->
<!--             attributes for KPE Kaplan Way Metadata            -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             November 2014                                     -->
<!--                                                               -->
<!--             (C) Copyright Kaplan 2014          .              -->
<!--             All Rights Reserved.                              -->
<!--                                                               -->
<!-- UPDATED:                                                      -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->


<!ENTITY % KaplanWay                 "KaplanWay"                     >

<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!-- KPE Kaplan Way                                                -->
<!-- doc:Kaplan Way support                                        -->
<!ENTITY % KaplanWay.content
                       "(#PCDATA)*"
>
<!ENTITY % KaplanWay.attributes
              "name
                        CDATA
                                  'KaplanWay'
              %univ-atts;
              value
                        (prepare
                         | practice
                         | perform
                         | review)
                                  #REQUIRED
"
>

<!ELEMENT KaplanWay    %KaplanWay.content;>
<!ATTLIST KaplanWay    %KaplanWay.attributes;>


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST KaplanWay       %global-atts; 
    class CDATA "+ topic/data kpe-KaplanWayMeta-d/KaplanWay ">

   