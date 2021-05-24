CLASS zeml_text_labels_bo DEFINITION
  PUBLIC
  CREATE PUBLIC

  GLOBAL FRIENDS zeml_text_labels_bo_ft .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF gts_data,
        label_set_name TYPE thead-tdname,
        language_key   TYPE syst-langu,
      END OF gts_data .

    METHODS get_data
      RETURNING
        VALUE(rs_data) TYPE gts_data .

    METHODS get_labels
      RETURNING
        VALUE(ro_labels_data) TYPE REF TO data
      RAISING
        zcx_eml_return3 .

  PROTECTED SECTION.

    DATA gs_data TYPE gts_data.

    METHODS get_short_label
      IMPORTING iv_data_element_name  TYPE rollname
      RETURNING VALUE(rv_description) TYPE string
      RAISING   zcx_eml_return3.

    METHODS get_medium_label
      IMPORTING iv_data_element_name  TYPE rollname
      RETURNING VALUE(rv_description) TYPE string
      RAISING   zcx_eml_return3.

    METHODS get_long_label
      IMPORTING iv_data_element_name  TYPE rollname
      RETURNING VALUE(rv_description) TYPE string
      RAISING   zcx_eml_return3.

    METHODS get_report_label
      IMPORTING iv_data_element_name  TYPE rollname
      RETURNING VALUE(rv_description) TYPE string
      RAISING   zcx_eml_return3.

    METHODS get_ddic_field
      IMPORTING iv_data_element_name TYPE rollname
      RETURNING VALUE(rs_ddic_field) TYPE dfies
      RAISING   zcx_eml_return3.

ENDCLASS.



CLASS ZEML_TEXT_LABELS_BO IMPLEMENTATION.


  METHOD get_data.

    rs_data = gs_data.

  ENDMETHOD.


  METHOD get_ddic_field.

    DATA lr_type_descr TYPE REF TO cl_abap_typedescr.

    CALL METHOD cl_abap_elemdescr=>describe_by_name
      EXPORTING
        p_name         = iv_data_element_name
      RECEIVING
        p_descr_ref    = lr_type_descr
      EXCEPTIONS
        type_not_found = 1
        OTHERS         = 2.

    IF sy-subrc <> 0.

      "DDic data type &1 not found.
      MESSAGE e002
        WITH iv_data_element_name
        INTO DATA(lv_dummy).

      DATA(lx_return) = NEW zcx_eml_return3( ).

      lx_return->add_system_message( ).

      RAISE EXCEPTION lx_return.

    ENDIF.

    TRY.

        DATA(lr_element_descr) = CAST cl_abap_elemdescr( lr_type_descr ).

      CATCH cx_sy_move_cast_error INTO DATA(lx_move_cast_error).

        lx_return = NEW zcx_eml_return3( ).

        lx_return->add_exception_object( lx_move_cast_error ).

        RAISE EXCEPTION lx_return.

    ENDTRY.

    rs_ddic_field =
      lr_element_descr->get_ddic_field(
        p_langu = me->gs_data-language_key ).

  ENDMETHOD.


  METHOD get_labels.

    DATA lt_standard_text_lines TYPE STANDARD TABLE OF tline.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        id                      = 'ST'
        language                = me->gs_data-language_key
        name                    = me->gs_data-label_set_name
        object                  = 'TEXT'
      TABLES
        lines                   = lt_standard_text_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.

    IF sy-subrc <> 0.
      DATA(lx_return3) = NEW zcx_eml_return3( ).
      lx_return3->add_system_message( ).
      RAISE EXCEPTION lx_return3.
    ENDIF.

    "----------------------------------------------------
    "Convert SAPscript table to String table
    DATA lt_string_lines TYPE STANDARD TABLE OF string.

    LOOP AT lt_standard_text_lines
      ASSIGNING FIELD-SYMBOL(<ls_standard_text_line>).

      CASE <ls_standard_text_line>-tdformat.

        WHEN ''.

          IF sy-tabix = 1.

            APPEND INITIAL LINE TO lt_string_lines
              ASSIGNING FIELD-SYMBOL(<ls_string_line>).

            <ls_string_line> = <ls_standard_text_line>.

          ELSE.

            <ls_string_line> = <ls_string_line> && | | && <ls_standard_text_line>-tdline.

          ENDIF.

        WHEN OTHERS.

          APPEND INITIAL LINE TO lt_string_lines
            ASSIGNING <ls_string_line>.

          <ls_string_line> = <ls_standard_text_line>-tdline.

      ENDCASE.

    ENDLOOP.

    "----------------------------------------------------
    "Convert String table to Name / value table
    TYPES:
      BEGIN OF gts_label,
        name  TYPE string,
        value TYPE string,
      END OF gts_label.

    DATA lt_name_value_labels TYPE STANDARD TABLE OF gts_label WITH DEFAULT KEY.

    LOOP AT lt_string_lines
      ASSIGNING <ls_string_line>.

      DATA lv_name TYPE string.
      DATA lv_value TYPE string.

      CLEAR: lv_name, lv_value.

      SPLIT <ls_string_line>
        AT '='
        INTO
          lv_name
          lv_value.

      IF lv_name IS INITIAL.
        CONTINUE.
      ENDIF.

      APPEND INITIAL LINE TO lt_name_value_labels
        ASSIGNING FIELD-SYMBOL(<ls_name_value_label>).

      <ls_name_value_label>-name  = lv_name.
      <ls_name_value_label>-value = lv_value.

      SHIFT <ls_name_value_label>-name LEFT DELETING LEADING space.
      <ls_name_value_label>-name = to_upper( <ls_name_value_label>-name ).
      CONDENSE <ls_name_value_label>-name.

      SHIFT <ls_name_value_label>-value LEFT DELETING LEADING space.
      CONDENSE <ls_name_value_label>-value.

    ENDLOOP.

    "----------------------------------------------------
    "Create structure
    DATA lt_component_table TYPE cl_abap_structdescr=>component_table.

    LOOP AT lt_name_value_labels
      ASSIGNING <ls_name_value_label>.

      READ TABLE lt_component_table
        ASSIGNING FIELD-SYMBOL(<ls_component>)
        WITH KEY name = <ls_name_value_label>-name.

      IF sy-subrc = 0.

        "Standard text &1 &2 contains multiple variable name &3.
        RAISE EXCEPTION TYPE zcx_eml_return3
          MESSAGE e001
          WITH
          me->gs_data-language_key
          me->gs_data-label_set_name
          <ls_name_value_label>-name.

      ENDIF.

      APPEND INITIAL LINE TO lt_component_table
        ASSIGNING <ls_component>.

      <ls_component>-name = <ls_name_value_label>-name.
      <ls_component>-type ?= cl_abap_datadescr=>describe_by_name( 'STRING' ).

    ENDLOOP.

    DATA(lo_struct_descr)  = cl_abap_structdescr=>create( lt_component_table ).

    DATA lo_struct_data TYPE REF TO data.

    CREATE DATA ro_labels_data TYPE HANDLE lo_struct_descr.

    ASSIGN ro_labels_data->* TO FIELD-SYMBOL(<ls_labels>).

    "----------------------------------------------------
    "Fill structure
    LOOP AT lt_name_value_labels
      ASSIGNING <ls_name_value_label>.

      ASSIGN COMPONENT <ls_name_value_label>-name
        OF STRUCTURE <ls_labels>
        TO FIELD-SYMBOL(<lv_label_text>).

      DATA lv_first_value_part TYPE string.
      DATA lv_rest_value_part TYPE string.

      SPLIT <ls_name_value_label>-value
        AT space
        INTO
          lv_first_value_part
          lv_rest_value_part.

      lv_first_value_part = to_upper( lv_first_value_part ).

      CASE lv_first_value_part.

        WHEN 'GET_SHORT_LABEL'.

          <lv_label_text> = get_short_label( CONV #( lv_rest_value_part ) ).

        WHEN 'GET_MEDIUM_LABEL'.

          <lv_label_text> = get_medium_label( CONV #( lv_rest_value_part ) ).

        WHEN 'GET_LONG_LABEL'.

          <lv_label_text> = get_long_label( CONV #( lv_rest_value_part ) ).

        WHEN 'GET_REPORT_LABEL'.

          <lv_label_text> = get_report_label( CONV #( lv_rest_value_part ) ).

        WHEN 'GET_STANDARD_TEXT'.

          DATA(lo_standard_text_bo) =
            zeml_standard_text_bo_ft=>get_factory( )->get_standard_text_bo_by_key(
              CONV #( lv_rest_value_part ) ).

          <lv_label_text> = lo_standard_text_bo->get_text_string( me->gs_data-language_key ).

        WHEN OTHERS.

          <lv_label_text> = <ls_name_value_label>-value.

      ENDCASE.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_long_label.

    DATA(ls_ddic_field) = get_ddic_field( iv_data_element_name ).

    rv_description = ls_ddic_field-scrtext_l.

  ENDMETHOD.


  METHOD get_medium_label.

    DATA(ls_ddic_field) = get_ddic_field( iv_data_element_name ).

    rv_description = ls_ddic_field-scrtext_m.

  ENDMETHOD.


  METHOD get_report_label.

    DATA(ls_ddic_field) = get_ddic_field( iv_data_element_name ).

    rv_description = ls_ddic_field-reptext.

  ENDMETHOD.


  METHOD get_short_label.

    DATA(ls_ddic_field) = get_ddic_field( iv_data_element_name ).

    rv_description = ls_ddic_field-scrtext_s.

  ENDMETHOD.
ENDCLASS.
