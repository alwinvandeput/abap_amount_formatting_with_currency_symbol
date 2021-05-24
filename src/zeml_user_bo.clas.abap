class ZEML_USER_BO definition
  public
  final
  create public

  global friends ZEML_USER_BO_FT .

public section.

  interfaces ZEML_COUNTRY_SETTINGS_IF .

  types:
    BEGIN OF gts_detail,
        logondata      TYPE bapilogond,
        defaults       TYPE bapidefaul,
        address        TYPE bapiaddr3,
        company        TYPE bapiuscomp,
        snc            TYPE bapisncu,
        ref_user       TYPE bapirefus,
        alias          TYPE bapialias,
        uclass         TYPE bapiuclass,
        lastmodified   TYPE bapimoddat,
        islocked       TYPE bapislockd,
        identity       TYPE bapiidentity,
        admindata      TYPE bapiuseradmin,
        description    TYPE bapiusdesc,
        tech_user      TYPE bapitechuser,
        parameter      TYPE STANDARD TABLE OF bapiparam WITH DEFAULT KEY,
        profiles       TYPE STANDARD TABLE OF bapiprof WITH DEFAULT KEY,
        activitygroups TYPE STANDARD TABLE OF bapiagr WITH DEFAULT KEY,
        addtel         TYPE STANDARD TABLE OF bapiadtel WITH DEFAULT KEY,
        addfax         TYPE STANDARD TABLE OF bapiadfax WITH DEFAULT KEY,
        addttx         TYPE STANDARD TABLE OF bapiadttx WITH DEFAULT KEY,
        addtlx         TYPE STANDARD TABLE OF bapiadtlx WITH DEFAULT KEY,
        addsmtp        TYPE STANDARD TABLE OF bapiadsmtp WITH DEFAULT KEY,
        addrml         TYPE STANDARD TABLE OF bapiadrml WITH DEFAULT KEY,
        addx400        TYPE STANDARD TABLE OF bapiadx400 WITH DEFAULT KEY,
        addrfc         TYPE STANDARD TABLE OF bapiadrfc WITH DEFAULT KEY,
        addprt         TYPE STANDARD TABLE OF bapiadprt WITH DEFAULT KEY,
        addssf         TYPE STANDARD TABLE OF bapiadssf WITH DEFAULT KEY,
        adduri         TYPE STANDARD TABLE OF bapiaduri WITH DEFAULT KEY,
        addpag         TYPE STANDARD TABLE OF bapiadpag WITH DEFAULT KEY,
        addcomrem      TYPE STANDARD TABLE OF bapicomrem WITH DEFAULT KEY,
        parameter1     TYPE STANDARD TABLE OF bapiparam1 WITH DEFAULT KEY,
        groups         TYPE STANDARD TABLE OF bapigroups WITH DEFAULT KEY,
        uclasssys      TYPE STANDARD TABLE OF bapiuclasssys WITH DEFAULT KEY,
        extidhead      TYPE STANDARD TABLE OF bapiusextidhead WITH DEFAULT KEY,
        extidpart      TYPE STANDARD TABLE OF bapiusextidpart WITH DEFAULT KEY,
        systems        TYPE STANDARD TABLE OF bapircvsys WITH DEFAULT KEY,
      END OF gts_detail .

  methods GET_LANGUAGE_KEY
    returning
      value(RV_LANGUAGE_ID) type SYST-LANGU .
  methods GET_COUNTRY_KEY
    returning
      value(RV_COUNTRY_KEY) type T005X-LAND
    raising
      ZCX_EML_RETURN3 .
  methods GET_DETAIL
    returning
      value(RS_DETAIL) type GTS_DETAIL
    raising
      ZCX_EML_RETURN3 .
  methods GET_CURRENCY_KEY
    returning
      value(RV_CURRENCY_KEY) type WAERS
    raising
      ZCX_EML_RETURN3 .
  PROTECTED SECTION.

    DATA gv_user_name TYPE usr01-bname .

ENDCLASS.



CLASS ZEML_USER_BO IMPLEMENTATION.


  METHOD get_country_key.

    DATA(ls_detail) =
      me->get_detail( ).

    "User country
    IF ls_detail-address-country IS NOT INITIAL.

      rv_country_key = ls_detail-address-country.
      RETURN.

    ENDIF.

    IF ls_detail-company-company IS NOT INITIAL.

      "User companies
      SELECT SINGLE
          company,
          addrnumber
        FROM uscompany
        WHERE company = @ls_detail-company-company
        INTO @DATA(ls_user_company).

      IF sy-subrc = 0 AND ls_user_company-addrnumber IS NOT INITIAL.

        "Address ADDRNUMBER  0000023447
        DATA ls_address_selection TYPE addr1_sel.
        DATA ls_sadr TYPE sadr.

        CALL FUNCTION 'ADDR_GET'
          EXPORTING
            address_selection = ls_address_selection
*           ADDRESS_GROUP     =
*           READ_SADR_ONLY    = ' '
*           READ_TEXTS        = ' '
*           IV_CURRENT_COMM_DATA          = ' '
*           BLK_EXCPT         =
          IMPORTING
*           ADDRESS_VALUE     =
*           ADDRESS_ADDITIONAL_INFO       =
*           RETURNCODE        =
*           ADDRESS_TEXT      =
            sadr              = ls_sadr
*         TABLES
*           ADDRESS_GROUPS    =
*           ERROR_TABLE       =
*           VERSIONS          =
          EXCEPTIONS
            parameter_error   = 1
            address_not_exist = 2
            version_not_exist = 3
            internal_error    = 4
            address_blocked   = 5
            OTHERS            = 6.

        IF ls_sadr-land1 IS NOT INITIAL.

          rv_country_key = ls_sadr-land1.
          RETURN.

        ENDIF.

      ENDIF.

    ENDIF.

*    "User &1 has nog country key
*    MESSAGE e003
*      WITH me->gv_user_name
*      INTO DATA(lv_dummy).
*
*    DATA(lx_return3) = NEW zcx_eml_return3( ).
*
*    lx_return3->add_system_message( ).
*
*    RAISE EXCEPTION lx_return3.

    "I'm sorry... I hard coded this :)
    rv_country_key = 'DE'.

  ENDMETHOD.


  METHOD get_currency_key.

    DATA(ls_detail) =
      me->get_detail( ).

    "User country
    IF ls_detail-address-country IS NOT INITIAL.

      SELECT SINGLE
          land1,
          waers
        FROM t005
        WHERE
          land1 = @ls_detail-address-country
        INTO @DATA(ls_t005).

      IF sy-subrc = 0 AND ls_t005-waers IS NOT INITIAL.
        rv_currency_key = ls_t005-waers.
        RETURN.
      ENDIF.

    ENDIF.

    IF ls_detail-company-company IS NOT INITIAL.

      "User companies
      SELECT SINGLE
          company,
          addrnumber
        FROM uscompany
        WHERE company = @ls_detail-company-company
        INTO @DATA(ls_user_company).

      IF sy-subrc = 0 AND ls_user_company-addrnumber IS NOT INITIAL.

        "Address ADDRNUMBER  0000023447
        DATA ls_address_selection TYPE addr1_sel.
        DATA ls_sadr TYPE sadr.

        CALL FUNCTION 'ADDR_GET'
          EXPORTING
            address_selection = ls_address_selection
*           ADDRESS_GROUP     =
*           READ_SADR_ONLY    = ' '
*           READ_TEXTS        = ' '
*           IV_CURRENT_COMM_DATA          = ' '
*           BLK_EXCPT         =
          IMPORTING
*           ADDRESS_VALUE     =
*           ADDRESS_ADDITIONAL_INFO       =
*           RETURNCODE        =
*           ADDRESS_TEXT      =
            sadr              = ls_sadr
*         TABLES
*           ADDRESS_GROUPS    =
*           ERROR_TABLE       =
*           VERSIONS          =
          EXCEPTIONS
            parameter_error   = 1
            address_not_exist = 2
            version_not_exist = 3
            internal_error    = 4
            address_blocked   = 5
            OTHERS            = 6.

        IF ls_sadr-land1 IS NOT INITIAL.

          CLEAR ls_t005.

          SELECT SINGLE
              land1,
              waers
            FROM t005
            WHERE
              land1 = @ls_sadr-land1
            INTO @ls_t005.

          IF sy-subrc = 0 AND ls_t005-waers IS NOT INITIAL.
            rv_currency_key = ls_t005-waers.
            RETURN.
          ENDIF.

        ENDIF.

      ENDIF.

    ENDIF.

*    "User &1 has no currency key
*    MESSAGE e004
*      WITH me->gv_user_name
*      INTO DATA(lv_dummy).
*
*    DATA(lx_return3) = NEW zcx_eml_return3( ).
*
*    lx_return3->add_system_message( ).
*
*    RAISE EXCEPTION lx_return3.

    "I'm sorry... I hard coded this :)
    rv_currency_key = 'EUR'.

  ENDMETHOD.


  METHOD get_detail.

    DATA lt_return TYPE bapiret2_t.

    CALL FUNCTION 'BAPI_USER_GET_DETAIL'
      EXPORTING
        username       = me->gv_user_name
        cache_results  = 'X'
      IMPORTING
        logondata      = rs_detail-logondata
        defaults       = rs_detail-defaults
        address        = rs_detail-address
        company        = rs_detail-company
        snc            = rs_detail-snc
        ref_user       = rs_detail-ref_user
        alias          = rs_detail-alias
        uclass         = rs_detail-uclass
        lastmodified   = rs_detail-lastmodified
        islocked       = rs_detail-islocked
        identity       = rs_detail-identity
        admindata      = rs_detail-admindata
        description    = rs_detail-description
        tech_user      = rs_detail-tech_user
      TABLES
        parameter      = rs_detail-parameter
        profiles       = rs_detail-profiles
        activitygroups = rs_detail-activitygroups
        return         = lt_return
        addtel         = rs_detail-addtel
        addfax         = rs_detail-addfax
        addttx         = rs_detail-addttx
        addtlx         = rs_detail-addtlx
        addsmtp        = rs_detail-addsmtp
        addrml         = rs_detail-addrml
        addx400        = rs_detail-addx400
        addrfc         = rs_detail-addrfc
        addprt         = rs_detail-addprt
        addssf         = rs_detail-addssf
        adduri         = rs_detail-adduri
        addpag         = rs_detail-addpag
        addcomrem      = rs_detail-addcomrem
        parameter1     = rs_detail-parameter1
        groups         = rs_detail-groups
        uclasssys      = rs_detail-uclasssys
        extidhead      = rs_detail-extidhead
        extidpart      = rs_detail-extidpart
        systems        = rs_detail-systems.

    "Error handling
    DATA(lx_return) = NEW zcx_eml_return3( ).

    lx_return->add_bapiret2_table( lt_return ).

    IF lx_return->has_messages( ) = abap_true.
      RAISE EXCEPTION lx_return.

    ENDIF.

  ENDMETHOD.


  METHOD GET_LANGUAGE_KEY.

*    "----------------------------------------------
*    "If current user, set system language
*    IF sy-uname = me->gv_user_name.
*      rv_language_id = sy-langu.
*      RETURN.
*    ENDIF.

    "----------------------------------------------
    "Read user language
    DATA ls_address TYPE bapiaddr3.
    DATA lt_return TYPE STANDARD TABLE OF bapiret2.

    CALL FUNCTION 'BAPI_USER_GET_DETAIL'
      EXPORTING
        username = CONV bapibname-bapibname( me->gv_user_name ) ##OPERATOR[BAPIBNAME]
      IMPORTING
        address  = ls_address
      TABLES
        return   = lt_return.

    IF ls_address-langu_p IS NOT INITIAL.

      rv_language_id = ls_address-langu_p.
      RETURN.

    ENDIF.

    "----------------------------------------------
    "Read default language
    DATA lv_parameter_name TYPE c LENGTH 60.
    DATA lv_parameter_value TYPE c LENGTH 60.

    lv_parameter_name = 'zcsa/system_language'.

    CALL 'C_SAPGPARAM' ID 'NAME'  FIELD lv_parameter_name
                       ID 'VALUE' FIELD lv_parameter_value.
    IF sy-subrc = 0.

      rv_language_id = lv_parameter_value.
      RETURN.

    ENDIF.

  ENDMETHOD.


  METHOD zeml_country_settings_if~get_country_settings.

    SELECT SINGLE
        dcpfm AS number_format
        datfm AS date_format
        timefm AS time_format
      FROM usr01
      INTO rs_country_settings
      WHERE bname = gv_user_name.

    IF sy-subrc <> 0.

      "User name &1 has no user master record (USR01).
      RAISE EXCEPTION TYPE zcx_eml_return3
        MESSAGE e002
        WITH gv_user_name.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
