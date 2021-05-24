CLASS zeml_standard_text_bo DEFINITION
  PUBLIC
  CREATE PUBLIC
  GLOBAL FRIENDS zeml_standard_text_bo_ft .

  PUBLIC SECTION.

    TYPES:
      BEGIN OF gts_key,
        object_name TYPE thead-tdobject,
        id          TYPE thead-tdid,
        name        TYPE thead-tdname,
      END OF gts_key .


    METHODS get_text_lines
      IMPORTING iv_language_id  TYPE thead-tdspras DEFAULT sy-langu
      RETURNING VALUE(rt_lines) TYPE tlinet
      RAISING   zcx_eml_return3.

    METHODS get_text_string
      IMPORTING iv_language_id  TYPE thead-tdspras DEFAULT sy-langu
      RETURNING VALUE(rv_text_string) TYPE string
      RAISING   zcx_eml_return3.

  PROTECTED SECTION.

    DATA gs_key TYPE gts_key .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZEML_STANDARD_TEXT_BO IMPLEMENTATION.


  METHOD get_text_lines.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
*       CLIENT                  = SY-MANDT
        id                      = me->gs_key-id
        language                = iv_language_id
        name                    = me->gs_key-name
        object                  = me->gs_key-object_name
*       ARCHIVE_HANDLE          = 0
*       LOCAL_CAT               = ' '
*     IMPORTING
*       HEADER                  =
*       OLD_LINE_COUNTER        =
      TABLES
        lines                   = rt_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.

    IF sy-subrc <> 0.

      DATA(lx_return) = NEW zcx_eml_return3( ).

      lx_return->add_system_message( ).

      RAISE EXCEPTION lx_return.

    ENDIF.

  ENDMETHOD.


  METHOD get_text_string.

    DATA(lt_lines) =
      get_text_lines(
        iv_language_id = iv_language_id ).

    LOOP AT lt_lines
      ASSIGNING FIELD-SYMBOL(<ls_lines>).

      IF sy-tabix = 1.

        rv_text_string = <ls_lines>-tdline.

      ELSE.

        CASE <ls_lines>-tdformat.

          WHEN ''.

            rv_text_string = rv_text_string && <ls_lines>-tdline.

          WHEN OTHERS.

            rv_text_string = rv_text_string && cl_abap_char_utilities=>cr_lf && <ls_lines>-tdline.

        ENDCASE.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
