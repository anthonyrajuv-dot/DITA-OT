<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    DITA Prompt Scheme Map                           -->
<!--  VERSION:   1.2                                               -->
<!--  DATE:      November 2009                                     -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identifier or an 
      appropriate system identifier 
PUBLIC "-//OASIS//ELEMENTS DITA Prompt Scheme Map//EN"
      Delivered as file "promptScheme.mod"                        -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the elements and specialization         -->
<!--             attributes for DITA Prompt Scheme Maps           -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             February 2008                                     -->
<!--                                                               -->
<!--             (C) Copyright OASIS Open 2008, 2009.              -->
<!--             (C) Copyright IBM Corporation 2005, 2007.         -->
<!--             All Rights Reserved.                              -->
<!--                                                               -->
<!--  UPDATES:                                                     -->
<!--    2008.02.13 RDA: Created file based upon prototype from IBM -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

<!ENTITY % promptScheme     "promptScheme">
<!ENTITY % schemeref         "schemeref">
<!ENTITY % hasNarrower       "hasNarrower">
<!ENTITY % hasKind           "hasKind">
<!ENTITY % hasPart           "hasPart">
<!ENTITY % hasInstance       "hasInstance">
<!ENTITY % hasRelated        "hasRelated">
<!ENTITY % promptdef        "promptdef">
<!ENTITY % promptHead       "promptHead">
<!ENTITY % promptHeadMeta   "promptHeadMeta">
<!ENTITY % enumerationdef    "enumerationdef">
<!ENTITY % elementdef        "elementdef">
<!ENTITY % attributedef      "attributedef">
<!ENTITY % defaultPrompt    "defaultPrompt">
<!ENTITY % relatedPrompts   "relatedPrompts">
<!ENTITY % promptRelTable   "promptRelTable">
<!ENTITY % promptRelHeader  "promptRelHeader">
<!ENTITY % promptRel        "promptRel">
<!ENTITY % promptRole       "promptRole">

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!-- This differs from topicref-atts-no-toc only by providing a
     default for @processing-role                                  -->
<!ENTITY % topicref-atts-for-promptScheme 
             'collection-type 
                        (choice | 
                         family | 
                         sequence | 
                         unordered |
                         -dita-use-conref-target) 
                                  #IMPLIED
              type 
                        CDATA 
                                  #IMPLIED
              processing-role
                        (normal |
                         resource-only |
                         -dita-use-conref-target)
                                  "resource-only"
              scope 
                        (external | 
                         local | 
                         peer | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              locktitle 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              format 
                        CDATA 
                                  #IMPLIED
              linking 
                        (none | 
                         normal | 
                         sourceonly | 
                         targetonly |
                         -dita-use-conref-target) 
                                  #IMPLIED
              toc 
                        (no | 
                         yes | 
                         -dita-use-conref-target)
                                  "no"
              print 
                        (no | 
                         printonly | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              search 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              chunk 
                        CDATA 
                                  #IMPLIED
  '
>

<!--                    LONG NAME: Prompt Scheme Map              -->
<!ENTITY % promptScheme.content
                       "((%title;)?,
                         (%topicmeta;)?,
                         ((%anchor; |
                           %data.elements.incl; |
                           %enumerationdef; |
                           %hasInstance; |
                           %hasKind; |
                           %hasNarrower; |
                           %hasPart; |
                           %hasRelated; |
                           %navref; |
                           %relatedPrompts; |
                           %reltable; |
                           %schemeref; |
                           %promptdef; |
                           %promptHead; |
                           %promptRelTable; |
                           %topicref;)*))
">
<!ENTITY % promptScheme.attributes
             "id 
                        ID 
                                  #IMPLIED
              %conref-atts;
              anchorref 
                        CDATA 
                                  #IMPLIED
              outputclass 
                        CDATA 
                                  #IMPLIED
              %localization-atts;
              %topicref-atts-for-promptScheme;
              %select-atts;"
>
<!ELEMENT promptScheme    %promptScheme.content;>
<!ATTLIST promptScheme    
              %promptScheme.attributes;
              %arch-atts;
              domains 
                        CDATA 
                                  "&included-domains;" 
>

<!--                    LONG NAME: Scheme reference                -->
<!ENTITY % schemeref.content
                       "((%topicmeta;)?,
                         (%data.elements.incl;)*)
">
<!ENTITY % schemeref.attributes
             "navtitle 
                        CDATA 
                                  #IMPLIED
              href 
                        CDATA 
                                  #IMPLIED
              keyref 
                        CDATA 
                                  #IMPLIED
              keys 
                        CDATA 
                                  #IMPLIED
              query 
                        CDATA 
                                  #IMPLIED
              processing-role
                        (normal |
                         resource-only |
                         -dita-use-conref-target)
                                  #IMPLIED
              type 
                        CDATA 
                                  'scheme'
              format 
                        CDATA 
                                  'ditamap'
              scope 
                        (external |
                         local |
                         peer |
                         -dita-use-conref-target) 
                                  #IMPLIED
              %univ-atts;"
>
<!ELEMENT schemeref    %schemeref.content;>
<!ATTLIST schemeref    %schemeref.attributes;>


<!--                    LONG NAME: Has Narrower Relationship       -->
<!ENTITY % hasNarrower.content
                       "((%topicmeta;)?,
                         (%data.elements.incl; |
                          %promptdef; |
                          %promptHead; |
                          %topicref;)*)
">
<!ENTITY % hasNarrower.attributes
             "navtitle 
                        CDATA 
                                  #IMPLIED
              href 
                        CDATA 
                                  #IMPLIED
              keyref 
                        CDATA 
                                  #IMPLIED
              keys 
                        CDATA 
                                  #IMPLIED
              scope 
                        (external |
                         local |
                         peer |
                         -dita-use-conref-target) 
                                  #IMPLIED
              processing-role
                        (normal |
                         resource-only |
                         -dita-use-conref-target)
                                  #IMPLIED
              format 
                        CDATA 
                                  #IMPLIED
              type 
                        CDATA 
                                  #IMPLIED
              %univ-atts;"
>
<!ELEMENT hasNarrower    %hasNarrower.content;>
<!ATTLIST hasNarrower    %hasNarrower.attributes;>


<!--                    LONG NAME: Has Kind Relationship           -->
<!ENTITY % hasKind.content
                       "((%topicmeta;)?,
                         (%data.elements.incl; |
                          %promptdef; |
                          %promptHead; |
                          %topicref;)*)
">
<!ENTITY % hasKind.attributes
             "navtitle 
                        CDATA 
                                  #IMPLIED
              href 
                        CDATA 
                                  #IMPLIED
              keyref 
                        CDATA 
                                  #IMPLIED
              keys 
                        CDATA 
                                  #IMPLIED
              scope 
                        (external |
                         local |
                         peer |
                         -dita-use-conref-target) 
                                  #IMPLIED
              processing-role
                        (normal |
                         resource-only |
                         -dita-use-conref-target)
                                  #IMPLIED
              format 
                        CDATA 
                                  #IMPLIED
              type 
                        CDATA 
                                  #IMPLIED
              %univ-atts;"
>
<!ELEMENT hasKind    %hasKind.content;>
<!ATTLIST hasKind    %hasKind.attributes;>


<!--                    LONG NAME: Has Part Relationship           -->
<!ENTITY % hasPart.content
                       "((%topicmeta;)?,
                         (%data.elements.incl; |
                          %promptdef; |
                          %promptHead; |
                          %topicref;)*)
">
<!ENTITY % hasPart.attributes
             "navtitle 
                        CDATA 
                                  #IMPLIED
              href 
                        CDATA 
                                  #IMPLIED
              keyref 
                        CDATA 
                                  #IMPLIED
              keys 
                        CDATA 
                                  #IMPLIED
              scope 
                        (external |
                         local |
                         peer |
                         -dita-use-conref-target) 
                                  #IMPLIED
              processing-role
                        (normal |
                         resource-only |
                         -dita-use-conref-target)
                                  #IMPLIED
              format 
                        CDATA 
                                  #IMPLIED
              type 
                        CDATA 
                                  #IMPLIED
              %univ-atts;"
>
<!ELEMENT hasPart    %hasPart.content;>
<!ATTLIST hasPart    %hasPart.attributes;>


<!--                    LONG NAME: Has Instance Relationship       -->
<!ENTITY % hasInstance.content
                       "((%topicmeta;)?,
                         (%data.elements.incl; |
                          %promptdef; |
                          %promptHead; |
                          %topicref;)*)
">
<!ENTITY % hasInstance.attributes
             "navtitle 
                        CDATA 
                                  #IMPLIED
              href 
                        CDATA 
                                  #IMPLIED
              keyref 
                        CDATA 
                                  #IMPLIED
              keys 
                        CDATA 
                                  #IMPLIED
              scope 
                        (external |
                         local |
                         peer |
                         -dita-use-conref-target) 
                                  #IMPLIED
              processing-role
                        (normal |
                         resource-only |
                         -dita-use-conref-target)
                                  #IMPLIED
              format 
                        CDATA 
                                  #IMPLIED
              type 
                        CDATA 
                                  #IMPLIED
              %univ-atts;"
>
<!ELEMENT hasInstance    %hasInstance.content;>
<!ATTLIST hasInstance    %hasInstance.attributes;>


<!--                    LONG NAME: Has Related Relationship        -->
<!ENTITY % hasRelated.content
                       "((%topicmeta;)?,
                         (%data.elements.incl; |
                          %promptdef; |
                          %promptHead; |
                          %topicref;)*)
">
<!ENTITY % hasRelated.attributes
             "navtitle 
                        CDATA 
                                  #IMPLIED
              href 
                        CDATA 
                                  #IMPLIED
              keyref 
                        CDATA 
                                  #IMPLIED
              keys 
                        CDATA 
                                  #IMPLIED
              collection-type 
                        (choice |
                         sequence |
                         unordered |
                         -dita-use-conref-target) 
                                  'choice'
              processing-role
                        (normal |
                         resource-only |
                         -dita-use-conref-target)
                                  #IMPLIED
              scope 
                        (external |
                         local |
                         peer |
                         -dita-use-conref-target) 
                                  #IMPLIED
              format 
                        CDATA 
                                  #IMPLIED
              type 
                        CDATA 
                                  #IMPLIED
              %univ-atts;"
>
<!ELEMENT hasRelated    %hasRelated.content;>
<!ATTLIST hasRelated    %hasRelated.attributes;>


<!--                    LONG NAME: Prompt definition              -->
<!ENTITY % promptdef.content
                       "((%topicmeta;)?,
                         (%data.elements.incl; |
                          %hasInstance; |
                          %hasKind; |
                          %hasNarrower; |
                          %hasPart; |
                          %hasRelated; |
                          %promptdef; |
                          %promptHead; |
                          %topicref;)*)"
>
<!ENTITY % promptdef.attributes
             "navtitle 
                        CDATA 
                                  #IMPLIED
              href 
                        CDATA 
                                  #IMPLIED
              keyref 
                        CDATA 
                                  #IMPLIED
              keys 
                        CDATA 
                                  #IMPLIED
              query 
                        CDATA 
                                  #IMPLIED
              copy-to 
                        CDATA 
                                  #IMPLIED
              outputclass 
                        CDATA 
                                  #IMPLIED
              collection-type 
                        (choice | 
                         family | 
                         sequence | 
                         unordered |
                         -dita-use-conref-target) 
                                  #IMPLIED
              processing-role
                        (normal |
                         resource-only |
                         -dita-use-conref-target)
                                  #IMPLIED
              type 
                        CDATA 
                                  #IMPLIED
              scope 
                        (external | 
                         local |
                         peer | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              locktitle 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              format 
                        CDATA 
                                  #IMPLIED
              linking 
                        (none | 
                         normal | 
                         sourceonly | 
                         targetonly |
                         -dita-use-conref-target) 
                                  #IMPLIED
              toc 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              %univ-atts;"
>
<!ELEMENT promptdef    %promptdef.content;>
<!ATTLIST promptdef    %promptdef.attributes;>


<!--                    LONG NAME: Prompt Heading                 -->
<!-- SKOS equivalent: concept collection -->
<!ENTITY % promptHead.content
                       "((%promptHeadMeta;)?,
                         (%data.elements.incl; |
                          %promptdef; |
                          %promptHead; |
                          %topicref;)*)"
>
<!ENTITY % promptHead.attributes
             "navtitle 
                        CDATA 
                                  #IMPLIED
              collection-type 
                        (sequence | 
                         unordered |
                         -dita-use-conref-target) 
                                  #IMPLIED
              processing-role
                        (normal |
                         resource-only |
                         -dita-use-conref-target)
                                  #IMPLIED
              linking 
                        (normal) 
                                  'normal'
              toc 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              %univ-atts;"
>
<!ELEMENT promptHead    %promptHead.content;>
<!ATTLIST promptHead    %promptHead.attributes;>

<!--                    LONG NAME: Prompt Heading Metadata        -->
<!ENTITY % promptHeadMeta.content
                       "((%navtitle;)?,
                         (%shortdesc;)?)"
>
<!ENTITY % promptHeadMeta.attributes
             "lockmeta 
                       (no | 
                        yes | 
                        -dita-use-conref-target) 
                                  #IMPLIED
              %univ-atts;"
>
<!ELEMENT promptHeadMeta    %promptHeadMeta.content;>
<!ATTLIST promptHeadMeta    %promptHeadMeta.attributes;>

<!--                    LONG NAME: Enumeration definition          -->
<!ENTITY % enumerationdef.content
                       "((%elementdef;)?,
                         (%attributedef;),
                         (%promptdef;)+,
                         (%defaultPrompt;)?,
                         (%data.elements.incl;)*)
">
<!ENTITY % enumerationdef.attributes
             "%id-atts;
              outputclass 
                        CDATA 
                                  #IMPLIED
              status 
                        (changed | 
                         deleted | 
                         new | 
                         unchanged | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              base 
                         CDATA 
                                  #IMPLIED
              %base-attribute-extensions;"
>
<!ELEMENT enumerationdef    %enumerationdef.content;>
<!ATTLIST enumerationdef    %enumerationdef.attributes;>


<!--                    LONG NAME: Element definition              -->
<!ENTITY % elementdef.content
                       "((%data.elements.incl;)*)"
>
<!ENTITY % elementdef.attributes
             "%id-atts;
              name
                        CDATA
                                  #REQUIRED
              outputclass 
                        CDATA 
                                  #IMPLIED
              status 
                        (changed | 
                         deleted | 
                         new | 
                         unchanged | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              translate 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  'no'
              base 
                         CDATA 
                                  #IMPLIED
              %base-attribute-extensions;"
>
<!ELEMENT elementdef    %elementdef.content;>
<!ATTLIST elementdef    %elementdef.attributes;>


<!--                    LONG NAME: Attribute definition            -->
<!ENTITY % attributedef.content
                       "((%data.elements.incl;)*)"
>
<!ENTITY % attributedef.attributes
             "%id-atts;
              name
                        CDATA
                                  #REQUIRED
              outputclass 
                        CDATA 
                                  #IMPLIED
              status 
                        (changed | 
                         deleted | 
                         new | 
                         unchanged | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              translate 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  'no'
              base 
                         CDATA 
                                  #IMPLIED
              %base-attribute-extensions;"
>
<!ELEMENT attributedef    %attributedef.content;>
<!ATTLIST attributedef    %attributedef.attributes;>


<!--                    LONG NAME: Default Prompt                 -->
<!ENTITY % defaultPrompt.content
                       "((%data.elements.incl;)*)"
>
<!ENTITY % defaultPrompt.attributes
             "navtitle 
                        CDATA 
                                  #IMPLIED
              href 
                        CDATA 
                                  #IMPLIED
              keyref 
                        CDATA 
                                  #IMPLIED
              keys 
                        CDATA 
                                  #IMPLIED
              query 
                        CDATA 
                                  #IMPLIED
              copy-to 
                        CDATA 
                                  #IMPLIED
              outputclass 
                        CDATA 
                                  #IMPLIED
              type 
                        CDATA 
                                  #IMPLIED
              scope 
                        (external | 
                         local | 
                         peer |
                         -dita-use-conref-target) 
                                  #IMPLIED
              processing-role
                        (normal |
                         resource-only |
                         -dita-use-conref-target)
                                  #IMPLIED
              locktitle 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              format 
                        CDATA 
                                  #IMPLIED
              linking 
                        (none | 
                         normal | 
                         sourceonly | 
                         targetonly |
                         -dita-use-conref-target) 
                                  #IMPLIED
              toc 
                        (no | 
                         yes | 
                         -dita-use-conref-target) 
                                  #IMPLIED
              %univ-atts;"
>
<!ELEMENT defaultPrompt    %defaultPrompt.content;>
<!ATTLIST defaultPrompt    %defaultPrompt.attributes;>


<!--                    LONG NAME: Related Prompts                -->
<!-- To define roles within a relationship, you can specialize
     the relatedPrompts container and its contained promptdef elements,
     possibly setting the linking attribute to targetonly or sourceonly.
     For instance, a dependency relationship could contain depended-on
     and dependent prompts.
     -->
<!ENTITY % relatedPrompts.content
                       "((%data.elements.incl; | 
                          %promptdef; | 
                          %topicref;)*)
">
<!ENTITY % relatedPrompts.attributes
             "navtitle 
                        CDATA 
                                  #IMPLIED
              href 
                        CDATA 
                                  #IMPLIED
              keyref 
                        CDATA 
                                  #IMPLIED
              keys 
                        CDATA 
                                  #IMPLIED
              query 
                        CDATA 
                                  #IMPLIED
              collection-type 
                        (choice | 
                         family | 
                         sequence | 
                         unordered |
                         -dita-use-conref-target) 
                                  'family'
              processing-role
                        (normal |
                         resource-only |
                         -dita-use-conref-target)
                                  #IMPLIED
              type 
                        CDATA 
                                  #IMPLIED
              scope 
                        (external | 
                         local | 
                         peer |
                         -dita-use-conref-target) 
                                  #IMPLIED
              format 
                        CDATA 
                                  #IMPLIED
              linking 
                        (none | 
                         normal | 
                         sourceonly | 
                         targetonly |
                         -dita-use-conref-target) 
                                  'normal'
              %univ-atts;
">
<!ELEMENT relatedPrompts    %relatedPrompts.content;>
<!ATTLIST relatedPrompts    %relatedPrompts.attributes;>


<!--                    LONG NAME: Prompt Relationship Table      -->
<!-- Where there are many instances of a prompt relationship in which
     different prompts have defined roles within the relationship,
     you can use or specialize the promptRelTable.
     Note that each row matrixes relationships across columns such that
     a prompt receives relationships to every prompt in other columns
     within the same row. -->
<!ENTITY % promptRelTable.content
                       "((%title;)?,
                         (%topicmeta;)?,
                         (%promptRelHeader;)?,
                         (%promptRel;)+)
">
<!ENTITY % promptRelTable.attributes
             "%topicref-atts-no-toc;
              %univ-atts;
">
<!ELEMENT promptRelTable    %promptRelTable.content;>
<!ATTLIST promptRelTable    %promptRelTable.attributes;>


<!--                    LONG NAME: Prompt Table Header            -->
<!-- The header defines the role of prompts in each column
     The role definition can be an informal navtitle or 
         a formal reference -->
<!ENTITY % promptRelHeader.content
                       "((%promptRole;)+)
">
<!ENTITY % promptRelHeader.attributes
             "%univ-atts;
">
<!ELEMENT promptRelHeader    %promptRelHeader.content;>
<!ATTLIST promptRelHeader    %promptRelHeader.attributes;>


<!--                    LONG NAME: Prompt Table Row               -->
<!ENTITY % promptRel.content
                       "((%promptRole;)+)
">
<!ENTITY % promptRel.attributes
             "%univ-atts;
">
<!ELEMENT promptRel    %promptRel.content;>
<!ATTLIST promptRel    %promptRel.attributes;>


<!--                    LONG NAME: Prompt Role                    -->
<!ENTITY % promptRole.content
                       "((%data.elements.incl; |
                          %promptdef;|
                          %topicref;)*)
">
<!ENTITY % promptRole.attributes
             "%topicref-atts;
              %univ-atts;
">
<!ELEMENT promptRole    %promptRole.content;>
<!ATTLIST promptRole    %promptRole.attributes;>


<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST promptScheme %global-atts;
    class CDATA "- map/map promptScheme/promptScheme ">
<!ATTLIST schemeref %global-atts;
    class CDATA "- map/topicref promptScheme/schemeref ">
<!ATTLIST hasNarrower %global-atts;
    class CDATA "- map/topicref promptScheme/hasNarrower ">
<!ATTLIST hasKind %global-atts;
    class CDATA "- map/topicref promptScheme/hasKind ">
<!ATTLIST hasPart %global-atts;
    class CDATA "- map/topicref promptScheme/hasPart ">
<!ATTLIST hasInstance %global-atts;
    class CDATA "- map/topicref promptScheme/hasInstance ">
<!ATTLIST hasRelated %global-atts;
    class CDATA "- map/topicref promptScheme/hasRelated ">
<!ATTLIST enumerationdef %global-atts;
    class CDATA "- map/topicref promptScheme/enumerationdef ">
<!ATTLIST elementdef %global-atts;
    class CDATA "- topic/data promptScheme/elementdef ">
<!ATTLIST attributedef %global-atts;
    class CDATA "- topic/data promptScheme/attributedef ">
<!ATTLIST defaultPrompt %global-atts;
    class CDATA "- map/topicref promptScheme/defaultPrompt ">
<!ATTLIST promptHead %global-atts;
    class CDATA "- map/topicref promptScheme/promptHead ">
<!ATTLIST promptHeadMeta %global-atts;
    class CDATA "- map/topicmeta promptScheme/promptHeadMeta ">
<!ATTLIST promptdef %global-atts;
    class CDATA "- map/topicref promptScheme/promptdef ">
<!ATTLIST relatedPrompts %global-atts;
    class CDATA "- map/topicref promptScheme/relatedPrompts ">
<!ATTLIST promptRelTable %global-atts;
    class CDATA "- map/reltable promptScheme/promptRelTable ">
<!ATTLIST promptRelHeader %global-atts;
    class CDATA "- map/relrow promptScheme/promptRelHeader ">
<!ATTLIST promptRel %global-atts;
    class CDATA "- map/relrow promptScheme/promptRel ">
<!ATTLIST promptRole %global-atts;
    class CDATA "- map/relcell promptScheme/promptRole ">

<!-- ================== End DITA Prompt Scheme Map ============== -->
