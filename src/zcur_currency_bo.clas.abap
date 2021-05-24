class ZCUR_CURRENCY_BO definition
  public
  create public

  global friends ZCUR_CURRENCY_BO_FT .

public section.

  types:
    BEGIN OF gts_data,
        country_key   TYPE t005x-land,
        currency_key  TYPE tcurc-waers,
        iso_code      TYPE tcurc-isocd,
        decimal_count TYPE tcurx-currdec,
        symbol        TYPE string,
        left_symbol   TYPE string,
        right_symbol  TYPE string,
      END OF gts_data .

  methods GET_ISO_3_CURRENCY_CODE .
  methods FORMAT_AMOUNT
    importing
      !IV_AMOUNT type ANY
    returning
      value(RV_RESULT) type STRING .
  methods GET_SYMBOL .
  methods GET_LEFT_SYMBOL .
  methods GET_RIGHT_SYMBOL .
  methods CHECK_HAS_SYMBOL .
  methods CHECK_HAS_LEFT_OR_RIGHT_SYMBOL
    returning
      value(RV_RESULT_IND) type ABAP_BOOL .
  PROTECTED SECTION.

    DATA gs_data TYPE gts_data .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCUR_CURRENCY_BO IMPLEMENTATION.


  METHOD check_has_left_or_right_symbol.

    IF me->gs_data-left_symbol IS NOT INITIAL OR
      me->gs_data-right_symbol IS NOT INITIAL.

      rv_result_ind = abap_true.

    ENDIF.

  ENDMETHOD.


  METHOD check_has_symbol.
  ENDMETHOD.


  METHOD format_amount.

    "Set amount
    SET COUNTRY me->gs_data-country_key.

    DATA lv_result TYPE c LENGTH 40.

    WRITE iv_amount DECIMALS me->gs_data-decimal_count TO lv_result LEFT-JUSTIFIED.

    DATA lv_country TYPE t005x-land.
    SET COUNTRY lv_country.

    "Set currency iso code
    IF me->check_has_left_or_right_symbol( ) = abap_false.
      DATA(lv_iso_code) = | { me->gs_data-iso_code }|.
    ENDIF.

    rv_result =
      me->gs_data-left_symbol &&
      lv_result &&
      me->gs_data-right_symbol &&
      lv_iso_code.

  ENDMETHOD.


  METHOD get_iso_3_currency_code.
  ENDMETHOD.


  METHOD get_left_symbol.
  ENDMETHOD.


  METHOD get_right_symbol.
  ENDMETHOD.


  METHOD get_symbol.
  ENDMETHOD.
ENDCLASS.
