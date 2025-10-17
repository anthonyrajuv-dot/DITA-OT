<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    KPE DITA kpe-los Master                           -->
<!--  VERSION:   1.1                                               -->
<!--  CM VERSION 2.1                                               -->
<!--  DATE:      January 2014                                      -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identifier or an 
      appropriate system identifier 
PUBLIC "-//KPE//ELEMENTS DITA KPE kpe-los Master//EN"
      Delivered as file "kpe-los.mod"                              -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the elements and specialization         -->
<!--             attributes for kpe-los Master topics              -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             July 2013                                         -->
<!--                                                               -->
<!--             (C) Copyright Kaplan 2013.                        -->
<!--             All Rights Reserved.                              -->
<!-- UPDATED:                                                      -->
<!-- 2014.01.08 ARS: changed base element name to kpe-los          -->
<!-- 2014.11.07 PSB: Added CM Version in header                    -->
<!-- ============================================================= -->


<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->

<!ENTITY % kpe-los                 "kpe-los">
<!ENTITY % kpe-losBody             "kpe-losBody">


<!ENTITY % kpe-los-info-types "no-topic-nesting">
<!ENTITY included-domains 
                        "" >

<!ENTITY % kpe-los.content
                       "((%title;),
                         (%titlealts;)?,
                         (%shortdesc; |
                          %abstract;)?, 
                         (%prolog;)?,
                         (%kpe-losBody;), 
                         (%related-links;)?,
                         (%kpe-los-info-types;)* )"
>
<!ENTITY % kpe-los.attributes
             "id
                        ID 
                                  #REQUIRED
              %conref-atts;
              %select-atts;
              %localization-atts;
              outputclass
                        CDATA
                                  #IMPLIED"
>
<!ELEMENT kpe-los    %kpe-los.content;>
<!ATTLIST kpe-los    
              %kpe-los.attributes;
              %arch-atts;
              domains 
                        CDATA
                                  "&included-domains;"
>

<!ENTITY % kpe-losBody.content
                       "(%lcObjectives;) "
>
<!ENTITY % kpe-losBody.attributes
             "%univ-atts;
              outputclass
                        CDATA
                                  #IMPLIED"
>
<!ELEMENT kpe-losBody    %kpe-losBody.content;>
<!ATTLIST kpe-losBody    %kpe-losBody.attributes;>


<!--specialization attributes-->

<!ATTLIST kpe-los        %global-atts;
    class CDATA "- topic/topic learningBase/learningBase learningOverview/learningOverview kpe-los/kpe-los ">
<!ATTLIST kpe-losBody    %global-atts;
    class CDATA "- topic/body  learningBase/learningBasebody learningOverview/learningOverviewbody kpe-los/kpe-losBody ">
