class ZEML_USER_BO_FT definition
  public
  create public .

public section.

  class-methods GET_FACTORY
    returning
      value(RR_FACTORY) type ref to ZEML_USER_BO_FT .
  class-methods SET_FACTORY
    importing
      !IR_FACTORY type ref to ZEML_USER_BO_FT .
  methods GET_USER_BO_BY_USER_NAME
    importing
      !IV_USER_NAME type USR01-BNAME
    returning
      value(RO_USER_BO) type ref to ZEML_USER_BO
    raising
      ZCX_EML_RETURN3 .
  PROTECTED SECTION.

    CLASS-DATA gr_factory TYPE REF TO zeml_user_bo_ft .

ENDCLASS.



CLASS ZEML_USER_BO_FT IMPLEMENTATION.


  METHOD get_factory.

    IF gr_factory IS NOT INITIAL.

      rr_factory = gr_factory.

      RETURN.

    ENDIF.

    rr_factory = NEW #( ).

  ENDMETHOD.


  METHOD get_user_bo_by_user_name.

    SELECT SINGLE
        bname
      FROM usr01
      WHERE
        bname = @iv_user_name
      INTO @DATA(ls_usr01).

    IF sy-subrc <> 0.

      "User name &1 does not exist.
      RAISE EXCEPTION TYPE zcx_eml_return3
        MESSAGE e001
        WITH iv_user_name.

    ENDIF.

    ro_user_bo = NEW #( ).

    ro_user_bo->gv_user_name = iv_user_name.

  ENDMETHOD.


  METHOD set_factory.

    gr_factory = ir_factory.

  ENDMETHOD.
ENDCLASS.
