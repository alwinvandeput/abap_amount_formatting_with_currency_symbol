class ZEML_EMAIL_BO_FT definition
  public
  final
  create public .

public section.

  class-methods GET_FACTORY
    returning
      value(RR_FACTORY) type ref to ZEML_EMAIL_BO_FT .
  class-methods SET_FACTORY
    importing
      !IR_FACTORY type ref to ZEML_EMAIL_BO_FT .
  methods CREATE_EMAIL
    importing
      !IS_EMAIL_DATA type ZEML_EMAIL_BO=>GTS_DATA
    returning
      value(RR_EMAIL_BO) type ref to ZEML_EMAIL_BO
    raising
      ZCX_EML_RETURN3 .
  PROTECTED SECTION.

    CLASS-DATA gr_factory TYPE REF TO zeml_email_bo_ft .

  PRIVATE SECTION.

ENDCLASS.



CLASS ZEML_EMAIL_BO_FT IMPLEMENTATION.


  METHOD create_email.

    rr_email_bo = NEW #( ).

    rr_email_bo->gs_data = is_email_data.

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
