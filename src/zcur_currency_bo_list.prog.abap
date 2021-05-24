*&---------------------------------------------------------------------*
*& Report ZCUR_CURRENCY_LIST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcur_currency_bo_list.

TABLES:
  t005x,
  tcurc.

SELECT-OPTIONS s_cntry FOR t005x-land.
SELECT-OPTIONS s_curr FOR tcurc-waers.

START-OF-SELECTION.

  TYPES:
    BEGIN OF gts_alv_line,
      country_key    TYPE zcur_currency_bo=>gts_data-country_key,
      currency_key   TYPE zcur_currency_bo=>gts_data-currency_key,
      amount         TYPE string,
      symbol         TYPE zcur_currency_bo=>gts_data-symbol,
      left_symbol    TYPE zcur_currency_bo=>gts_data-left_symbol,
      right_symbol   TYPE zcur_currency_bo=>gts_data-right_symbol,
      iso_code       TYPE zcur_currency_bo=>gts_data-iso_code,
      decimal_count  TYPE zcur_currency_bo=>gts_data-decimal_count,
      left_right_ind TYPE abap_bool,
      country_name   TYPE zcur_currency_bo_dp=>gts_currency_1-country_name,
      currency_text  TYPE zcur_currency_bo_dp=>gts_currency_1-currency_text,
    END OF gts_alv_line,
    gtt_alv_list TYPE STANDARD TABLE OF gts_alv_line.

  DATA lt_alv_list TYPE gtt_alv_list.

  DATA(lt_list) =
    zcur_currency_bo_dp_ft=>get_factory(
      )->get_currency_bo_dp(
        )->get_currency_list_1(
          it_country_key_rng   = s_cntry[]
          it_currency_key_rng  = s_curr[] ).

*  WRITE : / 'CT  CUR   Symbol     Left sb    Right sb   Iso Dec Amount          Country                                            Currency'.

  LOOP AT lt_list
    ASSIGNING FIELD-SYMBOL(<ls_currency>).

    DATA(lo_currency_bo) =
      zcur_currency_bo_ft=>get_factory( )->get_currency_bo(
        iv_country_key = <ls_currency>-country_key
        iv_currency_key = <ls_currency>-currency_key ).

    DATA lv_amount TYPE p DECIMALS 5.
    lv_amount = '1234.56789'.

    APPEND INITIAL LINE TO lt_alv_list
      ASSIGNING FIELD-SYMBOL(<ls_alv_line>).

    <ls_alv_line> =
      VALUE #(
        country_key   = <ls_currency>-country_key
        currency_key  = <ls_currency>-currency_key
        symbol        = <ls_currency>-symbol
        left_symbol   = |.{ <ls_currency>-left_symbol }.|
        right_symbol  = |.{ <ls_currency>-right_symbol }.|
        iso_code      = <ls_currency>-iso_code
        decimal_count = <ls_currency>-decimal_count
        amount        = lo_currency_bo->format_amount( lv_amount )
        left_right_ind = lo_currency_bo->check_has_left_or_right_symbol( )
        country_name  = <ls_currency>-country_name
        currency_text = <ls_currency>-currency_text
      ).

  ENDLOOP.

  "Instantiate by output table
  DATA(lo_alv_reuse_alv_grid) = zcur_alv_grid_vw=>get_instance_by_output_table( REF #( lt_alv_list ) ).

  DATA(ls_data) = lo_alv_reuse_alv_grid->get_data( ).

  ls_data-layout-colwidth_optimize = abap_false.

  LOOP AT ls_data-field_catalog
    ASSIGNING FIELD-SYMBOL(<ls_catalog_field>).

    CASE <ls_catalog_field>-fieldname.

      WHEN 'COUNTRY_KEY'.
        <ls_catalog_field>-outputlen = 9.

      WHEN 'CURRENCY_KEY'.
        <ls_catalog_field>-outputlen = 9.

      WHEN 'SYMBOL'.

        IF sy-langu = 'E'.
          <ls_catalog_field>-seltext_s      = 'Symbol'.
          <ls_catalog_field>-seltext_m      = <ls_catalog_field>-seltext_s.
          <ls_catalog_field>-seltext_l      = <ls_catalog_field>-seltext_s.
          <ls_catalog_field>-reptext_ddic   = <ls_catalog_field>-seltext_s.
        ENDIF.

      WHEN 'LEFT_SYMBOL'.
        <ls_catalog_field>-outputlen = 11.

        IF sy-langu = 'E'.
          <ls_catalog_field>-seltext_s      = 'Left sb.'.
          <ls_catalog_field>-seltext_m      = 'Left symbol'.
          <ls_catalog_field>-seltext_l      = <ls_catalog_field>-seltext_m.
          <ls_catalog_field>-reptext_ddic   = <ls_catalog_field>-seltext_m.
        ENDIF.

      WHEN 'RIGHT_SYMBOL'.
        <ls_catalog_field>-outputlen = 11.

        IF sy-langu = 'E'.
          <ls_catalog_field>-seltext_s      = 'Right sb.'.
          <ls_catalog_field>-seltext_m      = 'Right symbol'.
          <ls_catalog_field>-seltext_l      = <ls_catalog_field>-seltext_m.
          <ls_catalog_field>-reptext_ddic   = <ls_catalog_field>-seltext_m.
        ENDIF.

      WHEN 'ISO_CODE'.

      WHEN 'DECIMAL_COUNT'.
        <ls_catalog_field>-outputlen = 4.

      WHEN 'AMOUNT'.
        <ls_catalog_field>-outputlen = 12.

        IF sy-langu = 'E'.
          <ls_catalog_field>-seltext_s      = 'Ex. amount'.
          <ls_catalog_field>-seltext_m      = 'Example amount'.
          <ls_catalog_field>-seltext_l      = <ls_catalog_field>-seltext_m.
          <ls_catalog_field>-reptext_ddic   = <ls_catalog_field>-seltext_m.
        ENDIF.


      WHEN 'LEFT_RIGHT_IND'.
        <ls_catalog_field>-outputlen = 3.
        <ls_catalog_field>-checkbox  = abap_true.

        IF sy-langu = 'E'.
          <ls_catalog_field>-seltext_s      = 'L/R sb.'.
          <ls_catalog_field>-seltext_m      = 'Left right symbol ind.'.
          <ls_catalog_field>-seltext_l      = 'Left right symbol indicator'.
          <ls_catalog_field>-reptext_ddic   = <ls_catalog_field>-seltext_l.
        ENDIF.

      WHEN 'COUNTRY_NAME'.
        <ls_catalog_field>-outputlen = 25.

      WHEN 'CURRENCY_TEXT'.
        <ls_catalog_field>-outputlen = 30.

        IF sy-langu = 'E'.
          <ls_catalog_field>-seltext_s      = 'Currency'.
          <ls_catalog_field>-seltext_m      = 'Currency text'.
          <ls_catalog_field>-seltext_l      = 'Currency text'.
          <ls_catalog_field>-reptext_ddic   = 'Currency'.
        ENDIF.

    ENDCASE.

  ENDLOOP.

  lo_alv_reuse_alv_grid->set_data( ls_data ).

  "Display
  lo_alv_reuse_alv_grid->set_output_table( REF #( lt_alv_list ) ).

  lo_alv_reuse_alv_grid->display( ).
