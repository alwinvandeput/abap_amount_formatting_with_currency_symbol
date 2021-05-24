CLASS zcur_currency_bo_dp_ft DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS get_factory
      RETURNING
        VALUE(ro_factory) TYPE REF TO zcur_currency_bo_dp_ft .
    METHODS get_currency_bo_dp
      RETURNING
        VALUE(ro_currency_bo_dp) TYPE REF TO zcur_currency_bo_dp .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcur_currency_bo_dp_ft IMPLEMENTATION.


  METHOD get_currency_bo_dp.

    ro_currency_bo_dp = NEW #( ).

  ENDMETHOD.


  METHOD get_factory.

    ro_factory = NEW #( ).

  ENDMETHOD.
ENDCLASS.
