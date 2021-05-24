CLASS zeml_standard_text_bo_ft DEFINITION
  PUBLIC
  FINAL
  CREATE PROTECTED.

  PUBLIC SECTION.

    CLASS-METHODS get_factory
      RETURNING
        VALUE(rr_factory) TYPE REF TO zeml_standard_text_bo_ft.

    CLASS-METHODS set_factory
      IMPORTING ir_factory TYPE REF TO zeml_standard_text_bo_ft.

    METHODS get_standard_text_bo_by_key
      IMPORTING
        !iv_object_name            TYPE thead-tdobject DEFAULT 'TEXT'
        !iv_id                     TYPE thead-tdid DEFAULT 'ST'
        !iv_name                   TYPE thead-tdname
      RETURNING
        VALUE(ro_standard_text_bo) TYPE REF TO zeml_standard_text_bo.

  PROTECTED SECTION.

    CLASS-DATA gr_factory TYPE REF TO zeml_standard_text_bo_ft .

  PRIVATE SECTION.

ENDCLASS.



CLASS ZEML_STANDARD_TEXT_BO_FT IMPLEMENTATION.


  METHOD get_factory.

    IF gr_factory IS NOT INITIAL.

      rr_factory = gr_factory.

      RETURN.

    ENDIF.

    rr_factory = NEW #( ).

  ENDMETHOD.


  METHOD get_standard_text_bo_by_key.

    ro_standard_text_bo = NEW #( ).

    ro_standard_text_bo->gs_key =
      VALUE #(
        object_name = iv_object_name
        id          = iv_id
        name        = iv_name ).

  ENDMETHOD.


  METHOD set_factory.

    gr_factory = ir_factory.

  ENDMETHOD.
ENDCLASS.
