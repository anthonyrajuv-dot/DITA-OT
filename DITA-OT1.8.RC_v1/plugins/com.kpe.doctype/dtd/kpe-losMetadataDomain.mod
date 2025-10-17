<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    KPE DITA LOS Metadata Domain                     -->
<!--  VERSION:   1.0                                               -->
<!--  CM VERSION 2.1                                               -->
<!--  DATE:      July 2013                                         -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identifier or an 
      appropriate system identifier 
PUBLIC "-//KPE//ELEMENTS DITA KPE LOS Metadata Domain//EN"
      Delivered as file "kpe-losMetadataDomain.mod"                -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the elements and specialization         -->
<!--             attributes for KPE LOS Metadata                   -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             July 2013                                         -->
<!--                                                               -->
<!--             (C) Copyright Kaplan 2013                         -->
<!--             All Rights Reserved.                              -->
<!--                                                               -->
<!-- UPDATED:                                                      -->
<!-- 2014.11.07 PSB: Added CM Version in header                    -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->

<!ENTITY % BloomsTaxonomy                   "BloomsTaxonomy"         >


<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!-- KPE Blooms Taxonomy                                           -->
<!-- doc:taxonomy value for LOS                                    -->                                 
<!ENTITY % BloomsTaxonomy.content
                       "(#PCDATA)*"
>
<!ENTITY % BloomsTaxonomy.attributes
              "name
                        CDATA
                                  'BloomsTaxonomy'
              %univ-atts;
              value
                        (creating
                         | evaluating
                         | analyzing
                         | applying
                         | understanding
                         | remembering
                         | -dita-use-conref-target)
                                  #REQUIRED
"
>

<!ELEMENT BloomsTaxonomy    %BloomsTaxonomy.content;>
<!ATTLIST BloomsTaxonomy    %BloomsTaxonomy.attributes;>

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST BloomsTaxonomy   %global-atts; 
    class CDATA "+ topic/data kpe-losMeta-d/BloomsTaxonomy ">
    

   