<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================== -->
<!--                    HEADER                                      -->
<!-- ============================================================== -->
<!--  MODULE:    KPE DITA Glossary MOD                              -->
<!--  VERSION:   1.0                                                -->
<!--  CM VERSION 2.1                                                -->
<!--  DATE:      January 2014                                       -->
<!--                                                                -->
<!-- ============================================================== -->

<!-- ============================================================== -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION             -->
<!--                    TYPICAL INVOCATION                          -->
<!--                                                                -->
<!--  Refer to this file by the following public identifier or an 
      appropriate system identifier 
PUBLIC "-//KPE//ELEMENTS DITA KPE Glossary Entry//EN" 
      Delivered as file kpe-glossEntry.mod                          -->

<!-- ============================================================== -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)      -->
<!--                                                                -->
<!-- PURPOSE:    Define elements and specialization atttributes     -->
<!--             for KPE Glossary topics                            -->
<!--                                                                -->
<!-- ORIGINAL CREATION DATE:                                        -->
<!--             January 2014                                       -->
<!--                                                                -->
<!--             (C) Copyright Kaplan 2014.                         -->
<!--             All Rights Reserved.                               -->
<!--                                                                -->
<!--  UPDATES:                                                      -->
<!-- 2014.01.08 ARS: changed base element name to kpe-gloss*        -->
<!-- 2014.11.07 PSB: Added CM Version in header                     -->
<!--                                                                -->
<!-- ============================================================== -->

<!-- ============================================================== -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS          -->
<!-- ============================================================== -->


<!ENTITY % kpe-glossEntry-info-types 
  "no-topic-nesting"
>


<!-- ============================================================== -->
<!--                   ELEMENT NAME ENTITIES                        -->
<!-- ============================================================== -->

<!ENTITY % kpe-glossEntry            "kpe-glossEntry"             >
<!ENTITY % kpe-glossBody             "kpe-glossBody"              >
<!ENTITY % kpe-glossAlt              "kpe-glossAlt"               >

<!ENTITY % kpe-glossMnemonic         "kpe-glossMnemonic"          >
<!ENTITY % kpe-glossMnemonicWord     "kpe-glossMnemonicWord"      >

<!ENTITY % kpe-glossProlog           "kpe-glossProlog"            >
<!ENTITY % kpe-glossMetadata         "kpe-glossMetadata"          >
<!ENTITY % kpe-glossType             "kpe-glossType"              >

<!-- ============================================================== -->
<!--                    DOMAINS ATTRIBUTE OVERRIDE                  -->
<!-- ============================================================== -->

<!ENTITY included-domains 
  ""
>

<!-- ============================================================== -->
<!--                    ELEMENT DECLARATIONS                        -->
<!-- ============================================================== -->

<!ENTITY % kpe-glossEntry.content
                       "((%glossterm;), 
                         (%glossdef;)?, 
                         (%kpe-glossProlog;), 
                         (%kpe-glossBody;)?, 
                         (%related-links;)?,
                         (%kpe-glossEntry-info-types;)* )"
>
<!ENTITY % kpe-glossEntry.attributes
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
<!ELEMENT kpe-glossEntry    %kpe-glossEntry.content;>
<!ATTLIST kpe-glossEntry    
              %kpe-glossEntry.attributes;
              %arch-atts;
              domains 
                        CDATA 
                                  "&included-domains;"
>

<!ENTITY % kpe-glossBody.content
                       "((%glossStatus;)?,
                         (%glossProperty;)*,
                         (%glossSurfaceForm;)?,
                         (%glossUsage;)?,
                         (%glossScopeNote;)?,
                         (%glossSymbol;)*,
                         (%kpe-glossMnemonic;)?,
                         (%note;)*,
                         (%kpe-glossAlt;)*)"
>
<!ENTITY % kpe-glossBody.attributes
             "%id-atts;
              %localization-atts;
              base 
                        CDATA 
                                  #IMPLIED
              %base-attribute-extensions;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT kpe-glossBody    %kpe-glossBody.content;>
<!ATTLIST kpe-glossBody    %kpe-glossBody.attributes;>

<!ENTITY % kpe-glossAlt.content
                       "((%glossAbbreviation; |
                          %glossAcronym; |
                          %glossShortForm; |
                          %glossSynonym;)?,
                         (%glossStatus;)?,
                         (%glossProperty;)*,
                         (%glossUsage;)?,
                         (%note;)*,
                         (%glossAlternateFor;)*)

">
<!ENTITY % kpe-glossAlt.attributes
             "%univ-atts;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT kpe-glossAlt    %kpe-glossAlt.content;>
<!ATTLIST kpe-glossAlt    %kpe-glossAlt.attributes;>

<!--          LONG NAME: KPE Mnemonic                                   -->
<!ENTITY % kpe-glossMnemonic.content
        "((%kpe-glossMnemonicWord;),
         (%basic.block.nonote;|%data.elements.incl;|%foreign.unknown.incl;)*)"
>
<!ENTITY % kpe-glossMnemonic.attributes
             "type 
                        (attention|
                         caution | 
                         danger | 
                         fastpath | 
                         important | 
                         note |
                         notice |
                         other | 
                         remember | 
                         restriction |
                         tip |
                         warning |
                         -dita-use-conref-target) 
                                  #IMPLIED 
              spectitle 
                        CDATA 
                                  #IMPLIED
              othertype 
                        CDATA 
                                  #IMPLIED
              %univ-atts;
              outputclass
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT kpe-glossMnemonic  %kpe-glossMnemonic.content;>
<!ATTLIST kpe-glossMnemonic  %kpe-glossMnemonic.attributes;>

<!--          LONG NAME: KPE Mnemonic Word                             -->
<!ENTITY % kpe-glossMnemonicWord.content
                       "(%ph.cnt; |
                         %text;)*"
>
<!ENTITY % kpe-glossMnemonicWord.attributes
             "keyref 
                        CDATA 
                                  #IMPLIED
              %univ-atts;
              outputclass 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT kpe-glossMnemonicWord    %kpe-glossMnemonicWord.content;>
<!ATTLIST kpe-glossMnemonicWord    %kpe-glossMnemonicWord.attributes;>

<!--            LONG NAME: KPE Glossary Prolog                          -->
<!ENTITY % kpe-glossProlog.content
                       "(%kpe-glossMetadata;,
                         (%author;)*, 
                         (%source;)?, 
                         (%publisher;)?,
                         (%copyright;)*, 
                         (%critdates;)?,
                         (%permissions;)?,  
                         (%resourceid;)*)"
>
<!ENTITY % kpe-glossProlog.attributes
             "%univ-atts;"
>

<!ELEMENT kpe-glossProlog    %kpe-glossProlog.content;>
<!ATTLIST kpe-glossProlog    %kpe-glossProlog.attributes;>


<!--            LONG NAME: KPE Glossary Metadata                        -->
<!ENTITY % kpe-glossMetadata.content
                       "(%kpe-glossType;,
                         (%audience;)*, 
                         (%category;)*, 
                         (%keywords;)*,
                         (%prodinfo;)*, 
                         (%othermeta;)*, 
                         (%data.elements.incl;)*)"
>
<!ENTITY % kpe-glossMetadata.attributes
             "%univ-atts; 
              mapkeyref 
                        CDATA 
                                  #IMPLIED"
>
<!ELEMENT kpe-glossMetadata    %kpe-glossMetadata.content;>
<!ATTLIST kpe-glossMetadata    %kpe-glossMetadata.attributes;>

<!--            LONG NAME: KPE Glossary Type                          -->
<!ENTITY % kpe-glossType.content
                       "EMPTY"
>
<!ENTITY % kpe-glossType.attributes
              "value
                        (Glossary
                         | Mnemonic
                         | other
                         | -dita-use-conref-target)
                                  #REQUIRED
              %univ-atts;"

>

<!ELEMENT kpe-glossType    %kpe-glossType.content;>
<!ATTLIST kpe-glossType    %kpe-glossType.attributes;>

<!-- ============================================================== -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS       -->
<!-- ============================================================== -->
 <!-- KPE specialization attribute declaration                      -->
<!ATTLIST kpe-glossEntry  %global-atts;
        class CDATA "- topic/topic concept/concept glossentry/glossentry kpe-glossEntry/kpe-glossEntry ">
        
<!ATTLIST kpe-glossBody   %global-atts;
        class CDATA "- topic/body concept/conbody glossentry/glossBody kpe-glossEntry/kpe-glossBody ">

<!ATTLIST kpe-glossAlt    %global-atts;
        class CDATA "- topic/section concept/section glossentry/glossAlt kpe-glossEntry/kpe-glossAlt ">
        
<!ATTLIST kpe-glossMnemonic %global-atts;
        class CDATA "- topic/note concept/note glossentry/note kpe-glossEntry/kpe-glossMnemonic ">
        
<!ATTLIST kpe-glossMnemonicWord %global-atts;
        class CDATA "- topic/ph concept/ph glossentry/ph kpe-glossEntry/kpe-glossMnemonicWord ">

<!ATTLIST kpe-glossProlog       %global-atts;  
    class CDATA "- topic/prolog kpe-glossEntry/kpe-glossProlog "    >

<!ATTLIST kpe-glossMetadata     %global-atts;  
    class CDATA "- topic/metadata kpe-glossEntry/kpe-glossMetadata ">

<!ATTLIST kpe-glossType         %global-atts; 
    class CDATA "+ topic/data kpe-glossEntry/kpe-glossType "        >
    
           
<!-- ================== End KPE DITA Glossary ======================== -->