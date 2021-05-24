class ZEML_COUNTRY_SETTINGS_BO definition
  public
  final
  create public

  global friends ZEML_COUNTRY_SETTINGS_IF .

public section.

  interfaces ZEML_COUNTRY_SETTINGS_IF .

  class-methods CREATE_INSTANCE_BY_DATA
    importing
      !IS_COUNTRY_SETTINGS type ZEML_COUNTRY_SETTINGS_IF=>GTS_COUNTRY_SETTINGS
    returning
      value(RO_COUNTRY_SETTINGS_BO) type ref to ZEML_COUNTRY_SETTINGS_BO .
  class-methods CREATE_BY_COUNTRY_OR_USER
    importing
      !IV_COUNTRY_KEY type T005X-LAND
      !IV_USER_NAME type USR01-BNAME
    returning
      value(RO_COUNTRY_SETTINGS_BO) type ref to ZEML_COUNTRY_SETTINGS_BO
    raising
      ZCX_EML_RETURN3 .
  PROTECTED SECTION.

    DATA gs_country_settings TYPE zeml_country_settings_if=>gts_country_settings.

    METHODS read_descriptions
      CHANGING cs_settings TYPE zeml_country_settings_if=>gts_country_settings.

ENDCLASS.



CLASS ZEML_COUNTRY_SETTINGS_BO IMPLEMENTATION.


  METHOD create_by_country_or_user.

    ro_country_settings_bo = NEW #( ).

    IF iv_country_key IS NOT INITIAL.

      DATA(lo_country_bo) = zeml_country_bo_ft=>get_factory( )->get_country_bo_by_key( iv_country_key ).

      ro_country_settings_bo->gs_country_settings =
        lo_country_bo->zeml_country_settings_if~get_country_settings( ).

    ELSE.

      IF iv_user_name IS NOT INITIAL.

        DATA(lv_user_name) = iv_user_name.

      ELSE.

        lv_user_name = sy-uname.

      ENDIF.

      DATA(lo_user_bo) = zeml_user_bo_ft=>get_factory( )->get_user_bo_by_user_name( lv_user_name ).

      ro_country_settings_bo->gs_country_settings =
        lo_user_bo->zeml_country_settings_if~get_country_settings( ).

    ENDIF.

  ENDMETHOD.


  METHOD create_instance_by_data.

    ro_country_settings_bo = NEW #( ).

    ro_country_settings_bo->gs_country_settings = is_country_settings.

  ENDMETHOD.


  METHOD read_descriptions.

    DATA lo_domain_value TYPE REF TO zeml_domain_fixed_value_fld.
    DATA lv_string TYPE string.

    "Number format
    lo_domain_value = zeml_domain_fixed_value_fld=>create_by_domain_name( 'XUDCPFM' ).

    lv_string = gs_country_settings-number_format.
    cs_settings-number_format_description =
      lo_domain_value->get_description(
        lv_string ).

    "Date format
    lo_domain_value = zeml_domain_fixed_value_fld=>create_by_domain_name( 'XUDATFM' ).

    lv_string = gs_country_settings-date_format.
    cs_settings-date_format_description =
      lo_domain_value->get_description(
        lv_string ).

    "Time format
    lo_domain_value = zeml_domain_fixed_value_fld=>create_by_domain_name( 'XUTIMEFM' ).

    lv_string = gs_country_settings-time_format.
    cs_settings-time_format_description =
      lo_domain_value->get_description(
        lv_string ).

  ENDMETHOD.


  METHOD zeml_country_settings_if~get_country_settings.

    rs_country_settings = gs_country_settings.

    IF iv_read_descriptions_ind = abap_true.

      read_descriptions(
        CHANGING cs_settings = rs_country_settings ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
