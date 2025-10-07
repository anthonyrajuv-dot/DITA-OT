<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    KPE DITA Question Metadata Domain                 -->
<!--  VERSION:   1.1                                               -->
<!--  CM VERSION 2.1                                               -->
<!--  DATE:      August 2013                                       -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identifier or an 
      appropriate system identifier 
PUBLIC "-//KPE//ELEMENTS DITA KPE Point Value Metadata Domain//EN"
      Delivered as file "kpe-pointValueMetadataDomain.mod"           -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the elements and specialization         -->
<!--             attributes for KPE question Metadata              -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             July 2013                                         -->
<!--                                                               -->
<!--             (C) Copyright Kaplan 2013                         -->
<!--             All Rights Reserved.                              -->
<!--                                                               -->
<!-- UPDATED:                                                      -->
<!-- 2013.08.14 ARS: changed file names to be more applicable      -->
<!-- 2014.11.07 PSB: Added CM Version in header                    -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->

<!ENTITY % pointValue                   "pointValue"         >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!-- KPE point value                                           -->
<!-- doc:point value for question -->                                 
<!ENTITY % pointValue.content
                       "(#PCDATA)*"
>
<!ENTITY % pointValue.attributes
              "name
                        CDATA
                                  'PointValue'
              %univ-atts;
              value
                        CDATA
                                  #REQUIRED"
>


<!ELEMENT pointValue    %pointValue.content;>
<!ATTLIST pointValue    %pointValue.attributes;>

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST pointValue   %global-atts; 
    class CDATA "+ topic/data kpe-pointValueMeta-d/pointValue ">
    

   