<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    KPE DITA topicprompt Metadata Domain               -->
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
PUBLIC "-//KPE//ELEMENTS DITA KPE topicprompt Metadata Domain//EN"
      Delivered as file "kpe-topicpromptMetadataDomain.mod"         -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the elements and specialization         -->
<!--             attributes for KPE topicprompt Metadata            -->
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


<!ENTITY % topicprompt                 "topicprompt"                 >

<!-- ============================================================= -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                 -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!-- KPE topicprompt                                                -->
<!-- doc:topicprompt support                                        -->
<!ENTITY % topicprompt.content
                       "(#PCDATA)*"
>
<!ENTITY % topicprompt.attributes
           "keyref CDATA #IMPLIED
           %univ-atts;
           "
>


<!ELEMENT topicprompt    %topicprompt.content;>
<!ATTLIST topicprompt    %topicprompt.attributes;>


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST topicprompt       %global-atts; 
    class CDATA "+ topic/data kpe-topicpromptMeta-d/topicprompt ">

   