CLASS zcur_alv_grid_vw DEFINITION
  PUBLIC
  FINAL
  CREATE PROTECTED.

  PUBLIC SECTION.

    TYPES gtv_save_layout TYPE c LENGTH 1.

    CONSTANTS:
      BEGIN OF gcs_save_layout,
        all_users     TYPE gtv_save_layout VALUE 'X',
        user_specific TYPE gtv_save_layout VALUE 'U',
        both          TYPE gtv_save_layout VALUE 'A',
      END OF gcs_save_layout.

    TYPES:
      BEGIN OF gts_data,
        "All parameters of FM REUSE_ALV_GRID_DISPLAY
        interface_check           TYPE abap_bool,
        bypassing_buffer          TYPE char01,
        buffer_active             TYPE abap_bool,

        callback_program_name     TYPE syrepid,
        callback_pf_status_set    TYPE slis_formname,
        callback_user_command     TYPE slis_formname,
        callback_top_of_page      TYPE slis_formname,
        callback_html_top_of_page TYPE slis_formname,
        callback_html_end_of_list TYPE slis_formname,

        structure_name            TYPE dd02l-tabname,

*"     REFERENCE(I_BACKGROUND_ID) TYPE  SDYDO_KEY DEFAULT SPACE

        grid_title                TYPE lvc_title,
        grid_settings             TYPE lvc_s_glay,

        layout                    TYPE slis_layout_alv,
        field_catalog             TYPE slis_t_fieldcat_alv,
        excluding                 TYPE slis_t_extab,
        special_groups            TYPE  slis_t_sp_group_alv,
        sort                      TYPE  slis_t_sortinfo_alv,
        filter                    TYPE  slis_t_filter_alv,
        sel_hide                  TYPE  slis_sel_hide_alv,

        "
        layout_allow_default      TYPE abap_bool,
        layout_allow_save         TYPE gtv_save_layout,
        variant                   TYPE disvariant,
        events                    TYPE slis_t_event,
        event_exit                TYPE slis_t_event_exit,
        print                     TYPE slis_print_alv,

        "
*"     REFERENCE(IS_REPREP_ID) TYPE  SLIS_REPREP_ID OPTIONAL
*"     REFERENCE(I_SCREEN_START_COLUMN) DEFAULT 0
*"     REFERENCE(I_SCREEN_START_LINE) DEFAULT 0
*"     REFERENCE(I_SCREEN_END_COLUMN) DEFAULT 0
*"     REFERENCE(I_SCREEN_END_LINE) DEFAULT 0
*"     REFERENCE(I_HTML_HEIGHT_TOP) TYPE  I DEFAULT 0
*"     REFERENCE(I_HTML_HEIGHT_END) TYPE  I DEFAULT 0
*"     REFERENCE(IT_ALV_GRAPHICS) TYPE  DTC_T_TC OPTIONAL
*"     REFERENCE(IT_HYPERLINK) TYPE  LVC_T_HYPE OPTIONAL
*"     REFERENCE(IT_ADD_FIELDCAT) TYPE  SLIS_T_ADD_FIELDCAT OPTIONAL
*"     REFERENCE(IT_EXCEPT_QINFO) TYPE  SLIS_T_QINFO_ALV OPTIONAL
*"     REFERENCE(IR_SALV_FULLSCREEN_ADAPTER) TYPE REF TO CL_SALV_FULLSCREEN_ADAPTER OPTIONAL
*"     REFERENCE(O_PREVIOUS_SRAL_HANDLER) TYPE REF TO IF_SALV_GUI_SRAL_HANDLER OPTIONAL

      END OF gts_data.

    CLASS-METHODS get_instance_by_struc_name
      IMPORTING iv_structure_name        TYPE dd02l-tabname
      RETURNING VALUE(rr_alv_reuse_grid) TYPE REF TO zcur_alv_grid_vw.

    CLASS-METHODS get_instance_by_output_table
      IMPORTING ir_output_table          TYPE REF TO data
      RETURNING VALUE(rr_alv_reuse_grid) TYPE REF TO zcur_alv_grid_vw.

    METHODS get_data
      RETURNING VALUE(rs_data) TYPE gts_data.

    METHODS set_data
      IMPORTING is_data TYPE gts_data.

    METHODS set_output_table
      IMPORTING ir_output_table TYPE REF TO data.

    METHODS display.

  PROTECTED SECTION.

    DATA:
      gs_data         TYPE gts_data,
      gr_output_table TYPE REF TO data.

    CLASS-METHODS get_field_cat_by_struc
      IMPORTING iv_structure_name       TYPE dd02l-tabname
      RETURNING VALUE(rt_field_catalog) TYPE slis_t_fieldcat_alv.

    CLASS-METHODS get_field_cat_by_output_table
      IMPORTING ir_output_table         TYPE REF TO data
      RETURNING VALUE(rt_field_catalog) TYPE slis_t_fieldcat_alv.

    CLASS-METHODS get_field_cat_by_type_descr
      IMPORTING iv_name          TYPE string

                ir_data_descr    TYPE REF TO cl_abap_datadescr
      CHANGING  cv_index         TYPE i
                ct_field_catalog TYPE slis_t_fieldcat_alv.

    CLASS-METHODS set_element_to_alv_cat_field
      IMPORTING iv_name                 TYPE string
                iv_index                TYPE syst-tabix
                ir_abap_elem_descr      TYPE REF TO cl_abap_elemdescr
      RETURNING VALUE(rs_catalog_field) TYPE slis_fieldcat_alv.

    METHODS set_data_defaults.

ENDCLASS.



CLASS ZCUR_ALV_GRID_VW IMPLEMENTATION.


  METHOD display.

    FIELD-SYMBOLS <lt_output_table> TYPE STANDARD TABLE.

    ASSERT CONDITION gr_output_table IS NOT INITIAL.

    ASSIGN gr_output_table->* TO <lt_output_table>.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_interface_check           = gs_data-interface_check
        i_bypassing_buffer          = gs_data-bypassing_buffer
        i_buffer_active             = gs_data-buffer_active
        "
        i_callback_program          = gs_data-callback_program_name
        i_callback_pf_status_set    = gs_data-callback_pf_status_set
        i_callback_user_command     = gs_data-callback_user_command
        i_callback_top_of_page      = gs_data-callback_top_of_page
        i_callback_html_top_of_page = gs_data-callback_html_top_of_page
        i_callback_html_end_of_list = gs_data-callback_html_end_of_list
        "
        i_grid_title                = gs_data-grid_title
        i_grid_settings             = gs_data-grid_settings
        "
        is_layout                   = gs_data-layout
        it_fieldcat                 = gs_data-field_catalog
        it_excluding                = gs_data-excluding
        it_special_groups           = gs_data-special_groups
        it_sort                     = gs_data-sort
        it_filter                   = gs_data-filter
        is_sel_hide                 = gs_data-sel_hide
        "
        i_default                   = gs_data-layout_allow_default
        i_save                      = gs_data-layout_allow_save
        is_variant                  = gs_data-variant
        it_events                   = gs_data-events
        it_event_exit               = gs_data-event_exit
        is_print                    = gs_data-print
        "
*    IS_REPREP_ID
*    I_SCREEN_START_COLUMN
*    I_SCREEN_START_LINE
*    I_SCREEN_END_COLUMN
*    I_SCREEN_END_LINE
*    IR_SALV_LIST_ADAPTER
*    IT_EXCEPT_QINFO
*    I_SUPPRESS_EMPTY_DATA
      TABLES
        t_outtab                    = <lt_output_table>.

  ENDMETHOD.


  METHOD get_data.
    rs_data = gs_data.
  ENDMETHOD.


  METHOD get_field_cat_by_output_table.

    "Table
    DATA(lr_output_table_descr) = cl_abap_tabledescr=>describe_by_data_ref( ir_output_table ).

    ASSERT CONDITION lr_output_table_descr->kind = cl_abap_typedescr=>kind_table.

    DATA(lr_table_descr) = CAST cl_abap_tabledescr( lr_output_table_descr  ).

    "Line
    DATA(lr_table_line_descr) = lr_table_descr->get_table_line_type( ).

    ASSERT CONDITION lr_table_line_descr->kind = cl_abap_typedescr=>kind_struct.

    DATA(lr_struct_descr) = CAST cl_abap_structdescr( lr_table_line_descr ).

    DATA lv_index TYPE i VALUE 0.

    get_field_cat_by_type_descr(
      EXPORTING
        iv_name       = ''
        ir_data_descr = lr_struct_descr
      CHANGING
        cv_index         =  lv_index
        ct_field_catalog = rt_field_catalog ).

  ENDMETHOD.


  METHOD get_field_cat_by_struc.

    "Genereer veldcatalogus
    CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
      EXPORTING
*       I_PROGRAM_NAME         =
*       I_INTERNAL_TABNAME     =
        i_structure_name       = iv_structure_name
*       I_CLIENT_NEVER_DISPLAY = 'X'
*       I_INCLNAME             =
*       I_BYPASSING_BUFFER     =
*       I_BUFFER_ACTIVE        =
      CHANGING
        ct_fieldcat            = rt_field_catalog
      EXCEPTIONS
        inconsistent_interface = 1
        program_error          = 2
        OTHERS                 = 3.

    ASSERT CONDITION sy-subrc = 0.

  ENDMETHOD.


  METHOD get_field_cat_by_type_descr.

    CASE ir_data_descr->kind.

      WHEN cl_abap_typedescr=>kind_elem.

        cv_index = cv_index + 1.

        DATA(ls_catalog_field) =
          set_element_to_alv_cat_field(
            iv_name = iv_name
            iv_index = cv_index
            ir_abap_elem_descr = CAST cl_abap_elemdescr( ir_data_descr ) ).

        APPEND ls_catalog_field TO ct_field_catalog.

      WHEN cl_abap_typedescr=>kind_struct.

        DATA(lr_struct_descr) = CAST cl_abap_structdescr( ir_data_descr ).

        DATA(lt_components) = lr_struct_descr->get_components( ).

        "Components
        LOOP AT lt_components
          ASSIGNING FIELD-SYMBOL(<ls_component>).

          get_field_cat_by_type_descr(
            EXPORTING
              iv_name       = <ls_component>-name
              ir_data_descr = <ls_component>-type
            CHANGING
              ct_field_catalog = ct_field_catalog
              cv_index         = cv_index ).

        ENDLOOP.

      WHEN cl_abap_typedescr=>kind_table.

        ASSERT ir_data_descr->kind <> cl_abap_typedescr=>kind_table.

      WHEN OTHERS.

        ASSERT 1 = 2.

    ENDCASE.

  ENDMETHOD.


  METHOD get_instance_by_output_table.

    rr_alv_reuse_grid = NEW #( ).

    rr_alv_reuse_grid->gr_output_table = ir_output_table.

    rr_alv_reuse_grid->gs_data-field_catalog = get_field_cat_by_output_table( ir_output_table ).

    rr_alv_reuse_grid->set_data_defaults( ).

  ENDMETHOD.


  METHOD get_instance_by_struc_name.

    rr_alv_reuse_grid = NEW #( ).

    rr_alv_reuse_grid->gs_data-structure_name = iv_structure_name.

    rr_alv_reuse_grid->gs_data-field_catalog = get_field_cat_by_struc( iv_structure_name ).

    rr_alv_reuse_grid->set_data_defaults( ).

  ENDMETHOD.


  METHOD set_data.
    gs_data = is_data.
  ENDMETHOD.


  METHOD set_data_defaults.

    gs_data-callback_program_name = sy-repid.

    gs_data-layout-colwidth_optimize = abap_true.

    gs_data-layout_allow_save = gcs_save_layout-both.

    gs_data-layout_allow_default = abap_true.

  ENDMETHOD.


  METHOD set_element_to_alv_cat_field.

    DATA(lr_element_descr) = CAST cl_abap_elemdescr( ir_abap_elem_descr ).

    "DDIC information
    DATA(ls_ddic_field) = VALUE dfies( ).

    IF lr_element_descr->is_ddic_type( ) = abap_true.
      ls_ddic_field = lr_element_descr->get_ddic_field( ).
    ENDIF.

    rs_catalog_field-fieldname = iv_name.
    rs_catalog_field-col_pos = iv_index.

    IF lr_element_descr->is_ddic_type( ) = abap_true.

      rs_catalog_field-key            = ls_ddic_field-keyflag.

      rs_catalog_field-seltext_l      = ls_ddic_field-scrtext_l.
      rs_catalog_field-seltext_m      = ls_ddic_field-scrtext_m.
      rs_catalog_field-seltext_s      = ls_ddic_field-scrtext_s.
      rs_catalog_field-reptext_ddic   = ls_ddic_field-reptext.

      rs_catalog_field-datatype       = ls_ddic_field-datatype.
      rs_catalog_field-inttype        = ls_ddic_field-inttype.
      rs_catalog_field-intlen         = ls_ddic_field-intlen.
      rs_catalog_field-ref_tabname    = ls_ddic_field-reftable.

      rs_catalog_field-ddic_outputlen = ls_ddic_field-outputlen.
      rs_catalog_field-decimals_out   = ls_ddic_field-decimals.

    ELSE.

      rs_catalog_field-seltext_l    = iv_name.
      rs_catalog_field-seltext_m    = iv_name.
      rs_catalog_field-seltext_s    = iv_name.
      rs_catalog_field-reptext_ddic = iv_name.

      CASE lr_element_descr->type_kind.

*TYPEKIND_ANY

        WHEN cl_abap_elemdescr=>typekind_char.

          rs_catalog_field-datatype       = 'CHAR'.
          rs_catalog_field-inttype        = 'C'.

*TYPEKIND_CLASS
*TYPEKIND_CLIKE
*TYPEKIND_CSEQUENCE
*TYPEKIND_DATA
        WHEN cl_abap_elemdescr=>typekind_date.
          rs_catalog_field-datatype       = 'DATS'.
          rs_catalog_field-inttype        = 'D'.

*TYPEKIND_DECFLOAT
*TYPEKIND_DECFLOAT16
*TYPEKIND_DECFLOAT34
*TYPEKIND_DREF
*TYPEKIND_FLOAT
*TYPEKIND_HEX

        WHEN cl_abap_elemdescr=>typekind_int.

          rs_catalog_field-datatype       = 'INT8'.
          rs_catalog_field-inttype        = 'I'.

        WHEN cl_abap_elemdescr=>typekind_int1.
          rs_catalog_field-datatype       = 'INT1'.
          rs_catalog_field-inttype        = 'I'.

        WHEN cl_abap_elemdescr=>typekind_int8.
          rs_catalog_field-datatype       = 'INT8'.
          rs_catalog_field-inttype        = 'I'.

        WHEN cl_abap_elemdescr=>typekind_int2.
          rs_catalog_field-datatype       = 'INT2'.
          rs_catalog_field-inttype        = 'I'.

*TYPEKIND_INTF
*TYPEKIND_IREF

        WHEN cl_abap_elemdescr=>typekind_num.
          rs_catalog_field-datatype       = 'NUMC'.
          rs_catalog_field-inttype        = 'N'.

*TYPEKIND_NUMERIC
*TYPEKIND_OREF

        WHEN cl_abap_elemdescr=>typekind_packed.
          rs_catalog_field-datatype       = 'DEC'.
          rs_catalog_field-inttype        = 'P'.

*TYPEKIND_SIMPLE

        WHEN cl_abap_elemdescr=>typekind_string.
          rs_catalog_field-datatype       = 'STRING'.
          rs_catalog_field-inttype        = 'STRING'.
          rs_catalog_field-just           = 'L'.

*TYPEKIND_STRUCT1
*TYPEKIND_STRUCT2
*TYPEKIND_TABLE
        WHEN cl_abap_elemdescr=>typekind_time.
          rs_catalog_field-datatype       = 'TIMS'.
          rs_catalog_field-inttype        = 'T'.

*TYPEKIND_W
*TYPEKIND_XSEQUENCE

        WHEN cl_abap_elemdescr=>typekind_xstring.
          rs_catalog_field-datatype       = 'RAW'.
          rs_catalog_field-inttype        = 'XSTRING'.

*TYPEKIND_BREF
*TYPEKIND_ENUM
*TYPEPROPKIND_DBMAXLEN
*TYPEPROPKIND_HASCLIENT

        WHEN OTHERS.
          ASSERT 1 = 2.

      ENDCASE.

      rs_catalog_field-intlen         = lr_element_descr->length.
      rs_catalog_field-ddic_outputlen = lr_element_descr->length.
      rs_catalog_field-decimals_out   = lr_element_descr->decimals.

    ENDIF.

  ENDMETHOD.


  METHOD set_output_table.

    gr_output_table = ir_output_table.

  ENDMETHOD.
ENDCLASS.
