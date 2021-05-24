CLASS zeml_domain_fixed_value_fld DEFINITION
  PUBLIC
  FINAL
  CREATE PROTECTED .

  PUBLIC SECTION.

    CLASS-METHODS create_by_domain_name
      IMPORTING
        !iv_domain_name    TYPE dd07l-domname
      RETURNING
        VALUE(rr_instance) TYPE REF TO zeml_domain_fixed_value_fld.

    METHODS get_description
      IMPORTING
        !iv_value             TYPE string
      RETURNING
        VALUE(rv_description) TYPE dd07v-ddtext.

  PROTECTED SECTION.

    TYPES:
      BEGIN OF gts_buffer,
        domain_name TYPE dd07l-domname,
        instance    TYPE REF TO zeml_domain_fixed_value_fld,
      END OF gts_buffer,
      gtt_buffer TYPE STANDARD TABLE OF gts_buffer WITH DEFAULT KEY.

    CLASS-DATA gt_buffer TYPE gtt_buffer.

    DATA gt_fixed_value_text TYPE STANDARD TABLE OF dd07v.
    DATA gv_domain_name TYPE dd07l-domname.
    DATA gv_values_buffered_ind TYPE abap_bool.

    METHODS read_domain_values .

ENDCLASS.

CLASS zeml_domain_fixed_value_fld IMPLEMENTATION.

  METHOD create_by_domain_name.

    "Read buffer
    FIELD-SYMBOLS <ls_buffer> LIKE LINE OF gt_buffer.

    READ TABLE gt_buffer
      ASSIGNING <ls_buffer>
        WITH KEY
        domain_name = iv_domain_name
      BINARY SEARCH.

    IF sy-subrc = 0.
      rr_instance = <ls_buffer>-instance.
      RETURN.
    ENDIF.

    "Create
    CREATE OBJECT rr_instance.
    rr_instance->gv_domain_name = iv_domain_name.

    "Add to buffer
    "Add to buffer
    APPEND INITIAL LINE TO gt_buffer
      ASSIGNING <ls_buffer>.

    <ls_buffer>-domain_name = iv_domain_name.
    <ls_buffer>-instance = rr_instance.

    SORT gt_buffer
    BY domain_name.

  ENDMETHOD.

  METHOD get_description.

    read_domain_values( ).

    FIELD-SYMBOLS:
    <ls_fixed_value_text> TYPE dd07v.

    READ TABLE gt_fixed_value_text
      WITH KEY domvalue_l = iv_value
      ASSIGNING <ls_fixed_value_text>
      BINARY SEARCH.

    IF sy-subrc <> 0.
      RETURN.
    ENDIF.

    rv_description = <ls_fixed_value_text>-ddtext.

  ENDMETHOD.

  METHOD read_domain_values.

    IF gv_values_buffered_ind = abap_false.

      CALL FUNCTION 'GET_DOMAIN_VALUES'
        EXPORTING
          domname         = gv_domain_name
          text            = 'X'
          fill_dd07l_tab  = ' '
        TABLES
          values_tab      = gt_fixed_value_text
        EXCEPTIONS
          no_values_found = 1
          OTHERS          = 2.

      IF sy-subrc <> 0.
        MESSAGE
          ID sy-msgid
          TYPE sy-msgty
          NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

      SORT gt_fixed_value_text
      BY domvalue_l.

      gv_values_buffered_ind = abap_true.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
