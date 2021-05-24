CLASS zeml_text_labels_bo_ft DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    CLASS-METHODS get_factory
      RETURNING
        VALUE(rr_factory) TYPE REF TO zeml_text_labels_bo_ft .

    CLASS-METHODS set_factory
      IMPORTING
        !ir_factory TYPE REF TO zeml_text_labels_bo_ft .

    METHODS create_ca_text_labels_bo
      IMPORTING
        !is_data                    TYPE zeml_text_labels_bo=>gts_data
      RETURNING
        VALUE(ro_ca_text_labels_bo) TYPE REF TO zeml_text_labels_bo .

  PROTECTED SECTION.

    CLASS-DATA gr_factory TYPE REF TO zeml_text_labels_bo_ft.

ENDCLASS.

CLASS zeml_text_labels_bo_ft IMPLEMENTATION.


  METHOD create_ca_text_labels_bo.

    ro_ca_text_labels_bo = NEW #( ).

    ro_ca_text_labels_bo->gs_data = is_data.

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
