interface ZEML_COUNTRY_SETTINGS_IF
  public .


  types:
    BEGIN OF gts_country_settings,
      number_format             TYPE t005x-xdezp,
      date_format               TYPE t005x-datfm,
      time_format               TYPE t005x-timefm,
      number_format_description TYPE dd07d-ddtext,
      date_format_description   TYPE dd07d-ddtext,
      time_format_description   TYPE dd07d-ddtext,
    END OF gts_country_settings .

  methods GET_COUNTRY_SETTINGS
    importing
      !IV_READ_DESCRIPTIONS_IND type ABAP_BOOL default ABAP_FALSE
    returning
      value(RS_COUNTRY_SETTINGS) type GTS_COUNTRY_SETTINGS
    raising
      ZCX_EML_RETURN3 .
endinterface.
