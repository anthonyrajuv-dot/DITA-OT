<?xml version="1.0" encoding="UTF-8"?>
<!-- ============================================================= -->
<!--                    HEADER                                     -->
<!-- ============================================================= -->
<!--  MODULE:    KPE DITA Task                                     -->
<!--  VERSION:   1.1                                               -->
<!--  CM VERSION 2.1                                               -->
<!--  DATE:      January 2014                                      -->
<!--                                                               -->
<!-- ============================================================= -->

<!-- ============================================================= -->
<!--                    PUBLIC DOCUMENT TYPE DEFINITION            -->
<!--                    TYPICAL INVOCATION                         -->
<!--                                                               -->
<!--  Refer to this file by the following public identfier or an 
      appropriate system identifier 
PUBLIC "-//KPE//ELEMENTS DITA KPE Task//EN"
      Delivered as file "kpe-task.mod                          -->

<!-- ============================================================= -->
<!-- SYSTEM:     Darwin Information Typing Architecture (DITA)     -->
<!--                                                               -->
<!-- PURPOSE:    Declaring the elements and specialization         -->
<!--             attributes for KPE task topic                     -->
<!--                                                               -->
<!-- ORIGINAL CREATION DATE:                                       -->
<!--             January 2014                                      -->
<!--                                                               -->
<!--             (C) Copyright Kaplan 2014                         -->
<!--             All Rights Reserved.                              -->
<!--                                                               -->
<!-- UPDATED:                                                      -->
<!-- 2014.11.07 PSB: Added CM Version in header                    -->
<!-- ============================================================= -->


<!-- ============================================================= -->
<!--                   SPECIALIZATION OF DECLARED ELEMENTS         -->
<!-- ============================================================= -->

<!ENTITY % kpe-task-info-types "no-topic-nesting">

<!-- ============================================================= -->
<!--                   ELEMENT NAME ENTITIES                       -->
<!-- ============================================================= -->

<!ENTITY % kpe-task                   "kpe-task">
<!ENTITY % kpe-taskBody               "kpe-taskBody">

<!-- ============================================================= -->
<!--                    SHARED ATTRIBUTE LISTS                     -->
<!-- ============================================================= -->


<!ENTITY included-domains 
  ""
>

<!-- ============================================================= -->
<!--                    ELEMENT DECLARATIONS                       -->
<!-- ============================================================= -->

<!--                    LONG NAME: Learning Task                   -->
<!ENTITY % kpe-task.content
                        "((%title;),
                          (%titlealts;)?,
                          (%abstract; | 
                          %shortdesc;)?, 
                          (%prolog;)?,
                          (%kpe-taskBody;),
                          (%related-links;)?,
                          (%kpe-task-info-types;)* )"
>
<!ENTITY % kpe-task.attributes
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
<!ELEMENT kpe-task    %kpe-task.content;>
<!ATTLIST kpe-task
              %kpe-task.attributes;
              %arch-atts;
              domains 
                        CDATA
                                  "&included-domains;"
>

<!--                    LONG NAME: Task Body                  -->
<!ENTITY % kpe-taskBody.content
                        "(((%prereq;) | 
                          (%context;) |
                          (%section;))*,
                         ((%steps; | 
                           %steps-unordered; |
                           %steps-informal;))?, 
                         (%result;)?, 
                         (%example;)*, 
                         (%postreq;)*)"
>
<!ENTITY % kpe-taskBody.attributes
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
<!ELEMENT kpe-taskBody   %kpe-taskBody.content;>
<!ATTLIST kpe-taskBody   %kpe-taskBody.attributes;>

<!-- ============================================================= -->
<!--                    SPECIALIZATION ATTRIBUTE DECLARATIONS      -->
<!-- ============================================================= -->

<!ATTLIST kpe-task        %global-atts;  
    class  CDATA "- topic/topic task/task kpe-task/kpe-task "        >

<!ATTLIST kpe-taskBody    %global-atts;  
    class  CDATA "- topic/body task/taskbody kpe-task/kpe-taskBody " >




