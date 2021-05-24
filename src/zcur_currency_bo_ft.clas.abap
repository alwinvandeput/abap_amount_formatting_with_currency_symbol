CLASS zcur_currency_bo_ft DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS get_factory
      RETURNING
        VALUE(ro_factory) TYPE REF TO zcur_currency_bo_ft .
    METHODS get_currency_bo
      IMPORTING
        !iv_country_key       TYPE t005x-land
        !iv_currency_key      TYPE tcurc-waers
      RETURNING
        VALUE(ro_currency_bo) TYPE REF TO zcur_currency_bo
      RAISING
        cx_bapi_error .
  PROTECTED SECTION.

    CLASS-DATA go_factory TYPE REF TO zcur_currency_bo_ft .

  PRIVATE SECTION.
ENDCLASS.



CLASS zcur_currency_bo_ft IMPLEMENTATION.


  METHOD get_currency_bo.

    DATA(ls_currency) =
      zcur_currency_bo_dp_ft=>get_factory(
        )->get_currency_bo_dp(
          )->get_currency(
            iv_country_key  = iv_country_key
            iv_currency_key = iv_currency_key ).

    ro_currency_bo = NEW #( ).

    ro_currency_bo->gs_data = ls_currency.

  ENDMETHOD.


  METHOD get_factory.

    IF go_factory IS NOT INITIAL.

      ro_factory = go_factory.

      RETURN.

    ENDIF.

    ro_factory = NEW #( ).

  ENDMETHOD.
ENDCLASS.
