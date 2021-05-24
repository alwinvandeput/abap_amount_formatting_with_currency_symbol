CLASS ltd_text_labels_bo DEFINITION FOR TESTING
  INHERITING FROM zeml_text_labels_bo.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF gts_sales_order_labels,
        order_no    TYPE string,
        items       TYPE string,
        description TYPE string,
        unit        TYPE string,
        date        TYPE string,
        item_no     TYPE string,
        quantity    TYPE string,
        nett_amount TYPE string,
        total       TYPE string,
        footer      TYPE string,
      END OF gts_sales_order_labels.

    METHODS get_labels REDEFINITION.

ENDCLASS.

CLASS ltd_text_labels_bo IMPLEMENTATION.

  METHOD get_labels.

    CASE me->gs_data-language_key.

      WHEN 'E'.

        DATA(ls_labels) = VALUE gts_sales_order_labels(
          order_no    = get_long_label('VBELN_VA')
          items       = 'Items'
          description = get_long_label('MAKTX')
          unit        = 'Unit'
          date        = 'Date'
          item_no     = get_short_label('POSNR_VA')
          quantity    = get_long_label('DZMENG')
          nett_amount = get_long_label('NETWR_AK')
          total       = 'Total'
          footer      = 'Thank you for buying at <b><i>myCompany</i></b>.<br>Till next time...'
        ).

      WHEN 'N'.

        ls_labels = VALUE gts_sales_order_labels(
          order_no    = get_long_label('VBELN_VA')
          items       = 'Posities'
          description = get_long_label('MAKTX')
          unit        = 'Eenheid'
          date        = 'Datum'
          item_no     = get_short_label('POSNR_VA')
          quantity    = get_long_label('DZMENG')
          nett_amount = get_long_label('NETWR_AK')
          total       = 'Totaal'
          footer      = 'Bedankt dat u koopt bij <b><i>myCompany</i></b>.'
        ).

      WHEN 'F'.

        ls_labels = VALUE gts_sales_order_labels(
          order_no    = get_long_label('VBELN_VA')
          items       = 'Articles'
          description = get_long_label('MAKTX')
          unit        = get_short_label('DZIEME')
          date        = get_long_label('SYST_DATUM')
          item_no     = get_short_label('POSNR_VA')
          quantity    = get_long_label('DZMENG')
          nett_amount = get_long_label('NETWR_AK')
          total       = 'Le total'
          footer      = |Merci d'avoir acheté chez <b><i>myCompany</i></b>.|
        ).

      WHEN 'D'.

        ls_labels = VALUE gts_sales_order_labels(
          order_no    = get_long_label('VBELN_VA')
          items       = 'Material'
          description = get_medium_label('MAKTX')
          unit        = 'Einheit'
          date        = 'Datum'
          item_no     = get_short_label('POSNR_VA')
          quantity    = get_long_label('DZMENG')
          nett_amount = get_long_label('NETWR_AK')
          total       = 'Gesamt'
          footer      = |Vielen Dank für den Kauf bei <b><i>myCompany</i></b>.<br>Auf wiedersehen...|
        ).

    ENDCASE.

    CREATE DATA ro_labels_data TYPE gts_sales_order_labels.

    ASSIGN ro_labels_data->* TO FIELD-SYMBOL(<ls_labels>).

    <ls_labels> = ls_labels.

  ENDMETHOD.

ENDCLASS.

CLASS ltd_text_labels_bo_ft DEFINITION FOR TESTING
  INHERITING FROM zeml_text_labels_bo_ft.

  PUBLIC SECTION.
    METHODS create_ca_text_labels_bo REDEFINITION.

ENDCLASS.

CLASS ltd_text_labels_bo_ft IMPLEMENTATION.

  METHOD create_ca_text_labels_bo.

    ro_ca_text_labels_bo = NEW ltd_text_labels_bo( ).

    ro_ca_text_labels_bo->gs_data = is_data.

  ENDMETHOD.

ENDCLASS.

CLASS ltd_sales_order_dp DEFINITION FOR TESTING.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF gts_customer,
        language_id TYPE syst-langu,
      END OF gts_customer,

      BEGIN OF gts_schedule_line,
        quantity     TYPE vbep-wmeng,
        arrival_date TYPE vbep-edatu,
        arrival_time TYPE vbep-ezeit,
      END  OF gts_schedule_line,

      BEGIN OF gts_sales_order_item,
        item_no     TYPE vbap-posnr,
        description TYPE makt-maktx,
        quantity    TYPE vbap-zmeng,
        unit        TYPE vbap-meins,
        nett_amount TYPE vbap-netwr,
      END OF gts_sales_order_item,

      BEGIN OF gts_sales_order,
        order_no     TYPE vbak-vbeln,
        nett_amount  TYPE vbak-netwr,
        currency_key TYPE vbak-waerk,
        country_key  TYPE t005x-land,
        customer     TYPE gts_customer,
        items        TYPE STANDARD TABLE OF gts_sales_order_item WITH DEFAULT KEY,
      END OF gts_sales_order.

    METHODS get_sales_order
      IMPORTING iv_country_key        TYPE t005x-land
                iv_currency_key       TYPE vbak-waerk
                iv_language_id        TYPE syst-langu
      RETURNING VALUE(rs_sales_order) TYPE gts_sales_order.

ENDCLASS.

CLASS ltd_sales_order_dp IMPLEMENTATION.

  METHOD get_sales_order.

    rs_sales_order =
      VALUE #(
        order_no      = '3'
*            sold_to_party TYPE gts_address,
*            ship_to_party TYPE gts_address,
        nett_amount   = '1700.99'
        currency_key  = iv_currency_key
        country_key   = iv_country_key
        customer = VALUE #(
          language_id   = iv_language_id
        )
        items = VALUE #(
          (
            item_no     = '0010'
            description = COND string(
              WHEN iv_language_id = 'E' THEN 'SIM card'
              WHEN iv_language_id = 'F' THEN 'Carte SIM'
              WHEN iv_language_id = 'D' THEN 'SIM Karte'
              WHEN iv_language_id = 'N' THEN 'SIMkaart' )
            quantity    = '4'
            unit        = 'ST'
            nett_amount = '200.00'
          )
          (
            item_no     = '0020'
            description = COND string(
              WHEN iv_language_id = 'E' THEN 'Mobile phone'
              WHEN iv_language_id = 'F' THEN 'Téléphone mobile'
              WHEN iv_language_id = 'D' THEN 'Mobiltelefon'
              WHEN iv_language_id = 'N' THEN 'Mobiele telefoon' )
            quantity    = '1'
            unit        = 'ST'
            nett_amount = '1500.99'
          )
        )
      ).

  ENDMETHOD.

ENDCLASS.

CLASS unit_test DEFINITION
  FOR TESTING
  RISK LEVEL HARMLESS
  DURATION LONG.

  PUBLIC SECTION.

    METHODS create_email FOR TESTING.

ENDCLASS.


CLASS unit_test IMPLEMENTATION.

  METHOD create_email.

    TRY.

        "---------------------------------------------------------
        "HTML or Text email
        "- HTML: zeml_email_bo=>gcs_content_type-html
        "- Plain text: zeml_email_bo=>gcs_content_type-plain_text
        DATA(lv_test_content_type) = zeml_email_bo=>gcs_content_type-html.

        CASE lv_test_content_type.
          WHEN zeml_email_bo=>gcs_content_type-html.
            DATA(lv_test_template_name) = CONV zeml_email_bo=>gts_data-template_name( 'ZEML_EXAMPLE_SO_HTML_EMAIL' ).

          WHEN zeml_email_bo=>gcs_content_type-plain_text.
            lv_test_template_name = CONV zeml_email_bo=>gts_data-template_name( 'ZEML_EXAMPLE_SO_TEXT_EMAIL' ).

        ENDCASE.

        "---------------------------------------------------------
        "Set test country
        DATA(lv_test_country_key) = 'US'. "US, NL, FR, DE

        CASE lv_test_country_key.

          WHEN 'US'.

            DATA(lv_country_key)  = CONV t005x-land( 'US' ).  "Dec.: point, Date: mm/dd/yyyy, Time: 12:05:10 PM
            DATA(lv_currency_key) = CONV tcurx-currkey( 'USD' ).     "2 decimals
            "DATA(lv_currency_key) = CONV tcurx-currkey( 'USDN' ).    "5 decimals
            DATA(lv_language_id)  = 'E'.

          WHEN 'NL'.

            lv_country_key  = CONV t005x-land( 'NL' ). "dec.: comma, date: dd.mm.yyyy, time: 14:05:10
            lv_currency_key = CONV tcurx-currkey( 'EUR' ).
            lv_language_id  = CONV syst-langu( 'N' )    ##operator[langu].

          WHEN 'FR'.

            lv_country_key  = CONV t005x-land( 'FR' ). "dec.: comma, date: dd.mm.yyyy, time: 14:05:10, currency symbol to the right
            lv_currency_key = CONV tcurx-currkey( 'EUR' ).
            lv_language_id  = CONV syst-langu( 'F' )    ##operator[langu].

          WHEN 'DE'.

            lv_country_key  = CONV t005x-land( 'DE' ). "dec.: comma, date: dd.mm.yyyy, time: 14:05:10
            lv_currency_key = CONV tcurx-currkey( 'EUR' ).
            lv_language_id  = CONV syst-langu( 'D' )    ##operator[langu].

        ENDCASE.

        "---------------------------------------------------------
        "---------------------------------------------------------

        "---------------------------------------------------------
        "Get sales order data
        DATA(lo_sales_order_dp) = NEW ltd_sales_order_dp( ).
        DATA(ls_sales_order) =
          lo_sales_order_dp->get_sales_order(
            iv_country_key  = lv_country_key
            iv_currency_key = lv_currency_key
            iv_language_id  = lv_language_id ).
        DATA(lo_email_data) = REF #( ls_sales_order ).

        "---------------------------------------------------------
        "Set Text label test double - so no SO10 text is needed
        DATA(lo_text_labels_bo_ft) = NEW ltd_text_labels_bo_ft( ).
        zeml_text_labels_bo_ft=>set_factory( lo_text_labels_bo_ft ).

        "Set Email data
        DATA(ls_email_data) =
          VALUE zeml_email_bo=>gts_data(
            content_type       = lv_test_content_type
            template_name      = lv_test_template_name
            label_set_name     = 'ZEML_EXAMPLE_SO_EMAIL_LABELS'

            country_key        = ls_sales_order-country_key
            currency_key       = ls_sales_order-currency_key
            language_key       = ls_sales_order-customer-language_id

            importance         = '5'
            sensitivity        = ''

            sender =
              VALUE #(
                name  = 'myCompany - noreply'
                email = 'noreply@mycompany.nl'
              )

            receivers =
              VALUE #(
                (
                  name  = 'Alwin van de Put'
                  email = 'alwin.vandeput@mycompany.com'
                )
              )

            email_data = lo_email_data
            attachments = VALUE #( )
          ).

        "Send email
        DATA(lo_email_bo) =
          zeml_email_bo_ft=>get_factory( )->create_email(
            ls_email_data ).

        lo_email_bo->send( ).

      CATCH zcx_eml_return3 INTO DATA(lr_return3).

        DATA(ls_bapiret2) = lr_return3->get_bapiret2_struc( ).

        cl_abap_unit_assert=>fail(
          msg    = |ZCX_EML_RETURN3 - ID: { ls_bapiret2-id }, Number { ls_bapiret2-number }|
          detail = |Error message: { lr_return3->get_text( ) }|  ).

      CATCH cx_bcs INTO DATA(lx_bcs).

        cl_abap_unit_assert=>fail( |BCS: | && lx_bcs->get_text( ) ).

    ENDTRY.

  ENDMETHOD.

ENDCLASS.
