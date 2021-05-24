class ZEML_EMAIL_BO definition
  public
  final
  create public

  global friends ZEML_EMAIL_BO_FT .

public section.

  types GTV_CONTENT_TYPE type STRING .
  types:
    BEGIN OF gts_sender,
        name  TYPE adr6-smtp_addr, "Optional
        email TYPE adr6-smtp_addr,
      END OF gts_sender .
  types:
    BEGIN OF gts_receiver,
        name  TYPE adr6-smtp_addr, "Optional
        email TYPE adr6-smtp_addr,
      END OF gts_receiver .
  types:
    BEGIN OF gts_attachment,
        attachment_type     TYPE soodk-objtp,
        attachment_subject  TYPE sood-objdes,
        attachment_size     TYPE sood-objlen,
        attachment_language TYPE sood-objla,
        att_content_text    TYPE soli_tab,
        att_content_hex     TYPE solix_tab,
        attachment_header   TYPE soli_tab,
        vsi_profile         TYPE vscan_profile,
      END OF gts_attachment .
  types:
    gtt_attachments TYPE STANDARD TABLE OF gts_attachment WITH DEFAULT KEY .
  types:
    BEGIN OF gts_data,
        content_type   TYPE gtv_content_type,
        template_name  TYPE tdobname,
        label_set_name TYPE string,

        country_key    TYPE t005x-land,
        currency_key   TYPE tcurx-currkey,
        language_key    TYPE tdspras,
        user_name      TYPE usr01-bname,

        importance     TYPE bcs_docimp,
        sensitivity    TYPE so_obj_sns,

        sender         TYPE gts_sender,
        receivers      TYPE STANDARD TABLE OF gts_receiver WITH DEFAULT KEY,
        email_data     TYPE REF TO data,
        attachments    TYPE gtt_attachments,
      END OF gts_data .
  types:
    BEGIN OF gts_settings,
        country_key            TYPE t005x-land,
        language_key            TYPE syst-langu,
        currency_key           TYPE tcurc-waers,
        currency_decimal_count TYPE tcurx-currdec,

        number_format          TYPE t005x-xdezp,
        date_format            TYPE t005x-datfm,
        time_format            TYPE t005x-timefm,
        user_name              TYPE syst-uname,

        input_country_key      TYPE t005x-land,
        input_language_key      TYPE syst-langu,
        input_user_name        TYPE syst-uname,
        system_user_name       TYPE syst-uname,
      END OF gts_settings .

  constants:
    BEGIN OF gcs_content_type,
        html       TYPE gtv_content_type VALUE 'HTML',
        plain_text TYPE gtv_content_type VALUE 'PLAIN_TEXT',
      END  OF gcs_content_type .

  methods GET_SETTINGS
    returning
      value(RS_SETTINGS) type GTS_SETTINGS
    raising
      ZCX_EML_RETURN3 .
  methods SET_DATA
    importing
      !IS_DATA type GTS_DATA .
  methods SEND
    raising
      CX_BCS
      CX_XSLT_RUNTIME_ERROR
      ZCX_EML_RETURN3 .
  PROTECTED SECTION.

    DATA gs_data TYPE gts_data .

    METHODS convert_input_to_output
      IMPORTING
        !iv_field_name TYPE string
        !io_type_descr TYPE REF TO cl_abap_typedescr
      CHANGING
        !ca_data       TYPE any .
    METHODS get_content_by_xslt
      EXPORTING
        !ev_subject       TYPE so_obj_des
        !et_body_soli_tab TYPE soli_tab
      RAISING
        cx_xslt_runtime_error
        zcx_eml_return3 .
    METHODS execute_conversion_routines
      RETURNING
        VALUE(ro_copy_content_data) TYPE REF TO data .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZEML_EMAIL_BO IMPLEMENTATION.


  METHOD convert_input_to_output.

    CASE io_type_descr->kind.


      WHEN cl_abap_typedescr=>kind_table.

        DATA(lo_table_descr) = CAST cl_abap_tabledescr( io_type_descr ).

        DATA(lo_line_descr) = lo_table_descr->get_table_line_type( ).

        FIELD-SYMBOLS <lt_table> TYPE ANY TABLE.

        ASSIGN ca_data TO <lt_table>.

        DATA(lv_table_count) = lines( <lt_table> ).

        LOOP AT <lt_table>
          ASSIGNING FIELD-SYMBOL(<ls_record>).

          convert_input_to_output(
            EXPORTING
              iv_field_name  = iv_field_name
              io_type_descr  = lo_line_descr
            CHANGING
              ca_data        = <ls_record> ).

        ENDLOOP.

      WHEN cl_abap_typedescr=>kind_struct.

        DATA(lo_struct_descr) = CAST cl_abap_structdescr( io_type_descr ).

        DATA(lt_components) = lo_struct_descr->get_components( ).

        LOOP AT lt_components
          ASSIGNING FIELD-SYMBOL(<ls_component>).

          ASSIGN COMPONENT <ls_component>-name
            OF STRUCTURE ca_data
            TO FIELD-SYMBOL(<la_component>).

          "Assign the field
          DATA(lv_separator) = COND char1( WHEN iv_field_name IS NOT INITIAL THEN |-| ).

          convert_input_to_output(
            EXPORTING
              iv_field_name =
                iv_field_name && lv_separator && to_lower( <ls_component>-name )
              io_type_descr  = <ls_component>-type
            CHANGING
              ca_data        = <la_component> ).

        ENDLOOP.

      WHEN cl_abap_typedescr=>kind_elem.

        DATA(lo_element_descr) = CAST cl_abap_elemdescr( io_type_descr ).

        CASE lo_element_descr->type_kind.

          WHEN cl_abap_elemdescr=>typekind_char.

            IF lo_element_descr->is_ddic_type( ) = abap_true.

              DATA(ls_ddic) = lo_element_descr->get_ddic_field( ).

              IF ls_ddic-convexit IS NOT INITIAL.

                WRITE ca_data TO ca_data.

              ENDIF.

            ENDIF.

        ENDCASE.

    ENDCASE.

  ENDMETHOD.


  METHOD execute_conversion_routines.

    "Set language
    DATA(lv_current_user_language_key) = sy-langu.

    SET LOCALE LANGUAGE me->gs_data-language_key.

    "Create a copy structure variable
    DATA(lo_type_descr) = cl_abap_typedescr=>describe_by_data_ref( me->gs_data-email_data ).

    DATA(lo_data_descr) = CAST cl_abap_datadescr( lo_type_descr ).

    CREATE DATA ro_copy_content_data TYPE HANDLE lo_data_descr.

    ASSIGN ro_copy_content_data->* TO FIELD-SYMBOL(<la_copy_content_data>).

    "Copy the content
    ASSIGN me->gs_data-email_data->* TO FIELD-SYMBOL(<la_content_data>).

    <la_copy_content_data> = <la_content_data>.

    "Execute conversion routines
    convert_input_to_output(
      EXPORTING
        iv_field_name  = ''
        io_type_descr  = lo_type_descr
      CHANGING
        ca_data        = <la_copy_content_data> ).

    SET LOCALE LANGUAGE lv_current_user_language_key.

  ENDMETHOD.


  METHOD get_content_by_xslt.

    "------------------------------------------------------------
    "Get settings
    "------------------------------------------------------------
    DATA(ls_settings) = get_settings( ).

    "----------------------------------------------------------
    "Get labels
    "----------------------------------------------------------
    DATA(lo_text_labels_bo) =
      zeml_text_labels_bo_ft=>get_factory( )->create_ca_text_labels_bo(
        VALUE #(
          label_set_name = gs_data-label_set_name
          language_key   = ls_settings-language_key ) ).

    DATA(lo_text_labels_data) = lo_text_labels_bo->get_labels( ).

    ASSIGN lo_text_labels_data->* TO FIELD-SYMBOL(<ls_labels>).

    "----------------------------------------------------------
    "Execute conversion routines
    "----------------------------------------------------------
    DATA(lo_content_data) = execute_conversion_routines( ).

    ASSIGN lo_content_data->* TO FIELD-SYMBOL(<la_content>).

    "----------------------------------------------------------------
    "XSLT transformation
    "----------------------------------------------------------------
    DATA lv_content_string TYPE string.

    TRY.

        CALL TRANSFORMATION (me->gs_data-template_name)
          SOURCE content  = <la_content>
                 label    = <ls_labels>
                 settings = ls_settings
                 syst    = sy
          RESULT XML lv_content_string.

        "For developers to show the XML in the debugger
        DATA(lv_get_source_xml_ind) = abap_false.

        IF lv_get_source_xml_ind = abap_true.

          DATA lv_source_xml TYPE string.

          CALL TRANSFORMATION id
            SOURCE root     = <la_content>
                   label    = <ls_labels>
                   settings = ls_settings
                   syst     = sy
            RESULT XML lv_source_xml.

        ENDIF.

*      CATCH cx_xslt_runtime_error INTO DATA(lr_xslt_error).

*        RAISE EXCEPTION lr_xslt_error.

      CATCH cx_xslt_runtime_error INTO DATA(lr_xslt_error).

        DATA(lv_error_text) = lr_xslt_error->get_text( ).

        DATA:
          BEGIN OF ls_xslt_error,
            main_prog_name TYPE string,
            prog_name      TYPE string,
            prog_line      TYPE i,
            block_type     TYPE i,
            block_name     TYPE string,
            valid          TYPE abap_bool,
          END OF ls_xslt_error.

        lr_xslt_error->get_xslt_source_position(
          IMPORTING
            main_prog_name = ls_xslt_error-main_prog_name
            prog_name      = ls_xslt_error-prog_name
            prog_line      = ls_xslt_error-prog_line
            block_type     = ls_xslt_error-block_type
            block_name     = ls_xslt_error-block_name
            valid          = ls_xslt_error-valid ).

        "XSLT: &1 &2
        MESSAGE e001
          WITH
            |Program: { ls_xslt_error-prog_name }, | &&
              |Line: { ls_xslt_error-prog_line }|
              "|Block type: { ls_xslt_error-block_type }, | &&
              "|Block name: { ls_xslt_error-block_name }, | &&
              "|Valid: { ls_xslt_error-valid }| )
            lv_error_text
        INTO DATA(lv_dummy).

        DATA(lx_return3) = NEW zcx_eml_return3( ).

        lx_return3->add_system_message( ).

        RAISE EXCEPTION lx_return3.

    ENDTRY.

    "--------------------------------------------------------
    "Get subject
    "--------------------------------------------------------
    FIND '<title>'
      IN lv_content_string
      IN CHARACTER MODE
      MATCH OFFSET DATA(lv_start_offset)
      MATCH LENGTH DATA(lv_start_length).

    IF sy-subrc = 0.

      FIND '</title>'
        IN lv_content_string
        IN CHARACTER MODE
        MATCH OFFSET DATA(lv_end_offset)
        MATCH LENGTH DATA(lv_end_length).

      IF sy-subrc = 0 AND
         lv_end_offset > lv_start_offset.

        DATA(lv_start_pos) = lv_start_offset + lv_start_length.
        DATA(lv_length) = lv_end_offset - lv_start_pos.

        ev_subject =
          substring(
            val = lv_content_string
            off = lv_start_pos
            len = lv_length ).

        DATA(lv_before_html) =
         substring(
           val = lv_content_string
           off = 0
           len = lv_start_offset ).

        DATA(lv_after_html) =
         substring(
           val = lv_content_string
           off = lv_end_offset + lv_end_length ).

        lv_content_string = lv_before_html && lv_after_html.

      ENDIF.

    ENDIF.

    "--------------------------------------------------------
    "Convert Text string to Soli tab
    "--------------------------------------------------------
    CASE me->gs_data-content_type.

      WHEN gcs_content_type-html.

        CALL FUNCTION 'CONVERT_STRING_TO_TABLE'
          EXPORTING
            i_string         = lv_content_string
            i_tabline_length = 255
          TABLES
            et_table         = et_body_soli_tab.

      WHEN gcs_content_type-plain_text.

        CALL FUNCTION 'CONVERT_STRING_TO_TABLE'
          EXPORTING
            i_string         = lv_content_string
            i_tabline_length = 255
          TABLES
            et_table         = et_body_soli_tab.

    ENDCASE.

  ENDMETHOD.


  METHOD get_settings.

    "------------------------------------------------------------
    "Set user
    IF gs_data-user_name IS NOT INITIAL.
      DATA(lv_user_name) = gs_data-user_name.
    ELSE.
      lv_user_name = sy-uname.
    ENDIF.

    DATA(lo_user_bo) = zeml_user_bo_ft=>get_factory( )->get_user_bo_by_user_name( lv_user_name ).

    "------------------------------------------------------------
    "Set language id
    IF gs_data-language_key IS NOT INITIAL.
      DATA(lv_language_key) = gs_data-language_key.
    ELSE.
      lv_language_key = lo_user_bo->get_language_key( ).
    ENDIF.

    "------------------------------------------------------------
    "Get country settings
    "- If gs_data-country_key is initial, than country settings will be retrieved from
    "  the user.
    DATA(lo_country_settings_bo) =
      zeml_country_settings_bo=>create_by_country_or_user(
        iv_country_key = gs_data-country_key
        iv_user_name   = lv_user_name ).

    DATA(ls_country_settings) =
      lo_country_settings_bo->zeml_country_settings_if~get_country_settings( ).

    "------------------------------------------------------------
    "Country key
    IF gs_data-country_key IS NOT INITIAL.
      DATA(lv_country_key) = gs_data-country_key.
    ELSE.
      "Country key is needed for currency symbol placement (left or right)
      lv_country_key = lo_user_bo->get_country_key( ).
    ENDIF.

    "------------------------------------------------------------
    "Currency key for currency symbol
    IF gs_data-country_key IS NOT INITIAL.
      DATA(lv_currency_key) = gs_data-currency_key.
    ELSE.
      "We need a currency code for the currency symbol
      lv_currency_key = lo_user_bo->get_currency_key( ).
    ENDIF.

    "------------------------------------------------------------
    "Currency decimal count
    DATA lv_currency_decimal_count LIKE rs_settings-currency_decimal_count.
    IF gs_data-currency_key IS INITIAL.

      lv_currency_decimal_count = 2.

    ELSE.

      SELECT SINGLE
          currkey,
          currdec
        FROM tcurx
        WHERE currkey = @gs_data-currency_key
        INTO @DATA(ls_tcurx).

      IF sy-subrc = 0.

        lv_currency_decimal_count = ls_tcurx-currdec.

      ELSE.

        lv_currency_decimal_count = 2.

      ENDIF.

    ENDIF.

    "------------------------------------------------------------
    "Set setting values

    rs_settings-country_key             = lv_country_key.
    rs_settings-language_key            = lv_language_key.
    rs_settings-number_format           = ls_country_settings-number_format.
    rs_settings-currency_key            = lv_currency_key.
    rs_settings-currency_decimal_count  = lv_currency_decimal_count.

    rs_settings-date_format             = ls_country_settings-date_format.
    rs_settings-time_format             = ls_country_settings-time_format.
    rs_settings-user_name               = lv_user_name.

    "Extra data added for XSLT to show the input values of the calling program
    rs_settings-input_country_key       = gs_data-country_key.
    rs_settings-input_language_key      = gs_data-language_key.
    rs_settings-input_user_name         = gs_data-user_name.
    rs_settings-system_user_name        = sy-uname.

  ENDMETHOD.


  METHOD send.

    TRY.

        "------------------------------------------------------------
        "Get subject and body text
        get_content_by_xslt(
          IMPORTING
            ev_subject       = DATA(lv_subject)
            et_body_soli_tab = DATA(lt_soli_tab) ).

        "------------------------------------------------------------
        "Create send request
        DATA(lo_send_request) = cl_bcs=>create_persistent( ).

        "Create document
        CASE me->gs_data-content_type.

          WHEN gcs_content_type-html.

            DATA(lv_type) = CONV so_obj_tp( 'HTM' ) ##operator[so_obj_tp].

          WHEN gcs_content_type-plain_text.

            lv_type = 'TXT'.

        ENDCASE.

        DATA(lo_bcs_document) =
          cl_document_bcs=>create_document(
            i_type       = lv_type

            "value(I_LANGUAGE) type SO_OBJ_LA default SPACE
            i_importance   = me->gs_data-importance
            i_sensitivity  = me->gs_data-sensitivity

            i_text         = lt_soli_tab
            i_subject      = lv_subject ).

        lo_send_request->set_document( lo_bcs_document ).

        "Set sender
        DATA(lo_sender_address) =
          cl_cam_address_bcs=>create_internet_address(
            i_address_string = gs_data-sender-email
            i_address_name   = gs_data-sender-name ).

        lo_send_request->set_sender(
          i_sender = lo_sender_address ).

        "Add receivers
        LOOP AT gs_data-receivers
          ASSIGNING FIELD-SYMBOL(<ls_receiver>).

          DATA(lo_recipient) = cl_cam_address_bcs=>create_internet_address(
            i_address_string = <ls_receiver>-email
            i_address_name   = <ls_receiver>-name ).

          lo_send_request->add_recipient(
            EXPORTING
              i_recipient = lo_recipient
              i_express   = abap_true ).

        ENDLOOP .

        "Add attachments
        LOOP AT gs_data-attachments
          ASSIGNING FIELD-SYMBOL(<ls_attachment>).

          lo_bcs_document->add_attachment(
              i_attachment_type      = <ls_attachment>-attachment_type
              i_attachment_subject   = <ls_attachment>-attachment_subject
              i_attachment_size      = <ls_attachment>-attachment_size
              i_attachment_language  = <ls_attachment>-attachment_language
              i_att_content_text     = <ls_attachment>-att_content_text
              i_att_content_hex      = <ls_attachment>-att_content_hex
              i_attachment_header    = <ls_attachment>-attachment_header
              iv_vsi_profile         = <ls_attachment>-vsi_profile ).

        ENDLOOP.

        "------------------------------------------------------------
        "Send
        lo_send_request->set_send_immediately( abap_true ).

        DATA(lv_sent_to_all) = lo_send_request->send( ).

        COMMIT WORK.

      CATCH cx_bcs INTO DATA(lo_exception).

        RAISE EXCEPTION lo_exception.

    ENDTRY.

  ENDMETHOD.


  METHOD set_data.

    gs_data = is_data.

  ENDMETHOD.
ENDCLASS.
