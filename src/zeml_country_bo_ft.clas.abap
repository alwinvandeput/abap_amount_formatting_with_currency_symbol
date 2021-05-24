class ZEML_COUNTRY_BO_FT definition
  public
  create public .

public section.

  class-methods GET_FACTORY
    returning
      value(RR_FACTORY) type ref to ZEML_COUNTRY_BO_FT .
  class-methods SET_FACTORY
    importing
      !IR_FACTORY type ref to ZEML_COUNTRY_BO_FT .
  methods GET_COUNTRY_BO_BY_KEY
    importing
      !IV_COUNTRY type T005X-LAND
    returning
      value(RO_COUNTRY_SETTINGS_BO) type ref to ZEML_COUNTRY_BO
    raising
      ZCX_EML_RETURN3 .
  PROTECTED SECTION.

    CLASS-DATA gr_factory TYPE REF TO zeml_country_bo_ft.

ENDCLASS.



CLASS ZEML_COUNTRY_BO_FT IMPLEMENTATION.


  METHOD GET_COUNTRY_BO_BY_KEY.

    IF iv_country IS INITIAL.

      "Country key is empty.
      RAISE EXCEPTION TYPE zcx_eml_return3
        MESSAGE e001.

    ENDIF.

    ro_country_settings_bo = NEW #( ).

    ro_country_settings_bo->gv_country_key = iv_country.

  ENDMETHOD.


  METHOD get_factory.

    IF gr_factory IS NOT INITIAL.

      rr_factory = gr_factory.

      RETURN.

    ENDIF.

    rr_factory = NEW #( ).

  ENDMETHOD.


  METHOD set_factory.

    gr_factory = ir_factory.

  ENDMETHOD.
ENDCLASS.
