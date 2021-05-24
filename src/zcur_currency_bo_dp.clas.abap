class ZCUR_CURRENCY_BO_DP definition
  public
  final
  create public .

public section.

  types:
    gtt_country_key_rng TYPE RANGE OF t005x-land .
  types:
    gtt_currency_key_rng TYPE RANGE OF tcurc-waers .
  types GTS_CURRENCY type ZCUR_CURRENCY_BO=>GTS_DATA .
  types:
    gtt_currency_list TYPE STANDARD TABLE OF gts_currency  WITH DEFAULT KEY .
  types:
    BEGIN OF gts_currency_1.
        INCLUDE TYPE gts_currency.
    TYPES country_name TYPE t005t-landx50.
    TYPES currency_text TYPE tcurt-ltext.
    TYPES END OF gts_currency_1 .
  types:
    gtt_currency_list_1 TYPE STANDARD TABLE OF gts_currency_1 WITH DEFAULT KEY .

  class-methods CLASS_CONSTRUCTOR .
  class-methods GET_CURRENCY_LIST_1
    importing
      !IT_COUNTRY_KEY_RNG type GTT_COUNTRY_KEY_RNG
      !IT_CURRENCY_KEY_RNG type GTT_CURRENCY_KEY_RNG
    returning
      value(RT_CURRENCY_LIST) type GTT_CURRENCY_LIST_1 .
  methods GET_CURRENCY
    importing
      !IV_COUNTRY_KEY type T005X-LAND
      !IV_CURRENCY_KEY type TCURC-WAERS
    returning
      value(RS_CURRENCY) type GTS_CURRENCY
    raising
      CX_BAPI_ERROR .
  PROTECTED SECTION.
    CLASS-DATA gt_currency_list TYPE gtt_currency_list .

ENDCLASS.



CLASS ZCUR_CURRENCY_BO_DP IMPLEMENTATION.


  METHOD class_constructor.


    gt_currency_list =
      VALUE #(

( country_key = 'AD' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = || )
( country_key = 'AE' currency_key = 'AED' symbol = || left_symbol = || right_symbol = || )
( country_key = 'AF' currency_key = 'AFN' symbol = |؋| left_symbol = || right_symbol = || )
( country_key = 'AG' currency_key = 'XCD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'AI' currency_key = 'XCD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'AL' currency_key = 'ALL' symbol = |Lek| left_symbol = || right_symbol = || )
( country_key = 'AM' currency_key = 'AMD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'AO' currency_key = 'AOA' symbol = || left_symbol = || right_symbol = || )
( country_key = 'AQ' currency_key = '' symbol = || left_symbol = || right_symbol = || )
( country_key = 'AR' currency_key = 'ARS' symbol = |$| left_symbol = || right_symbol = || )
( country_key = 'AS' currency_key = 'USD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'AT' currency_key = 'EUR' symbol = |€| left_symbol = |€ | right_symbol = || )
( country_key = 'AU' currency_key = 'AUD' symbol = |$| left_symbol = || right_symbol = || )
( country_key = 'AW' currency_key = 'AWG' symbol = |ƒ| left_symbol = || right_symbol = || )
( country_key = 'AX' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = || )
( country_key = 'AZ' currency_key = 'AZN' symbol = |₼| left_symbol = || right_symbol = || )
( country_key = 'BA' currency_key = 'BAM' symbol = |KM| left_symbol = || right_symbol = || )
( country_key = 'BB' currency_key = 'BBD' symbol = |$| left_symbol = || right_symbol = || )
( country_key = 'BD' currency_key = 'BDT' symbol = || left_symbol = || right_symbol = || )
( country_key = 'BE' currency_key = 'EUR' symbol = |€| left_symbol = |€| right_symbol = || )
( country_key = 'BF' currency_key = 'XOF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'BG' currency_key = 'BGN' symbol = |лв| left_symbol = || right_symbol = || )
( country_key = 'BH' currency_key = 'BHD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'BI' currency_key = 'BIF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'BJ' currency_key = 'XOF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'BL' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = || )
( country_key = 'BM' currency_key = 'BMD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'BN' currency_key = 'BND' symbol = |$| left_symbol = || right_symbol = || )
( country_key = 'BO' currency_key = 'BOB' symbol = |$b| left_symbol = || right_symbol = || )
( country_key = 'BQ' currency_key = 'USD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'BR' currency_key = 'BRL' symbol = |R$| left_symbol = || right_symbol = || )
( country_key = 'BS' currency_key = 'BSD' symbol = |$| left_symbol = || right_symbol = || )
( country_key = 'BT' currency_key = 'BTN' symbol = || left_symbol = || right_symbol = || )
( country_key = 'BV' currency_key = 'NOK' symbol = || left_symbol = || right_symbol = || )
( country_key = 'BW' currency_key = 'BWP' symbol = |P| left_symbol = || right_symbol = || )
( country_key = 'BY' currency_key = 'BYR' symbol = |Br| left_symbol = || right_symbol = || )
( country_key = 'BZ' currency_key = 'BZD' symbol = |$| left_symbol = || right_symbol = || )
( country_key = 'CA' currency_key = 'CAD' symbol = |$| left_symbol = || right_symbol = || )
( country_key = 'CC' currency_key = 'AUD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'CD' currency_key = 'CDF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'CF' currency_key = 'XAF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'CG' currency_key = 'XAF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'CH' currency_key = 'CHF' symbol = |CHF| left_symbol = || right_symbol = || )
( country_key = 'CI' currency_key = 'XOF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'CK' currency_key = 'NZD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'CL' currency_key = 'CLP' symbol = |$| left_symbol = || right_symbol = || )
( country_key = 'CM' currency_key = 'XAF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'CN' currency_key = 'CNY' symbol = |¥| left_symbol = || right_symbol = || )
( country_key = 'CO' currency_key = 'COP' symbol = |$| left_symbol = || right_symbol = || )
( country_key = 'CR' currency_key = 'CRC' symbol = |₡| left_symbol = || right_symbol = || )
( country_key = 'CU' currency_key = 'CUP' symbol = |₱| left_symbol = || right_symbol = || )
( country_key = 'CV' currency_key = 'CVE' symbol = || left_symbol = || right_symbol = || )
( country_key = 'CW' currency_key = 'ANG' symbol = || left_symbol = || right_symbol = || )
( country_key = 'CX' currency_key = 'AUD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'CY' currency_key = 'EUR' symbol = |€| left_symbol = |€| right_symbol = || )
( country_key = 'CZ' currency_key = 'CZK' symbol = |Kč| left_symbol = || right_symbol = || )
( country_key = 'DE' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = | €| )
( country_key = 'DJ' currency_key = 'DJF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'DK' currency_key = 'DKK' symbol = |kr| left_symbol = || right_symbol = || )
( country_key = 'DM' currency_key = 'XCD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'DO' currency_key = 'DOP' symbol = |RD$| left_symbol = || right_symbol = || )
( country_key = 'DZ' currency_key = 'DZD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'EC' currency_key = 'USD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'EE' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = || )
( country_key = 'EG' currency_key = 'EGP' symbol = |£| left_symbol = || right_symbol = || )
( country_key = 'EH' currency_key = 'MAD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'ER' currency_key = 'ERN' symbol = || left_symbol = || right_symbol = || )
( country_key = 'ES' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = | €| )
( country_key = 'ET' currency_key = 'ETB' symbol = || left_symbol = || right_symbol = || )
( country_key = 'EU' currency_key = '' symbol = || left_symbol = || right_symbol = || )
( country_key = 'FI' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = | €| )
( country_key = 'FJ' currency_key = 'FJD' symbol = |$| left_symbol = || right_symbol = || )
( country_key = 'FK' currency_key = 'FKP' symbol = |£| left_symbol = || right_symbol = || )
( country_key = 'FM' currency_key = 'USD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'FO' currency_key = 'DKK' symbol = || left_symbol = || right_symbol = || )
( country_key = 'FR' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = | €| )
( country_key = 'GA' currency_key = 'XAF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'GB' currency_key = 'GBP' symbol = || left_symbol = || right_symbol = || )
( country_key = 'GD' currency_key = 'XCD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'GE' currency_key = 'GEL' symbol = || left_symbol = || right_symbol = || )
( country_key = 'GF' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = || )
( country_key = 'GG' currency_key = 'GBP' symbol = |£| left_symbol = || right_symbol = || )
( country_key = 'GH' currency_key = 'GHS' symbol = |¢| left_symbol = || right_symbol = || )
( country_key = 'GI' currency_key = 'GIP' symbol = |£| left_symbol = || right_symbol = || )
( country_key = 'GL' currency_key = 'DKK' symbol = || left_symbol = || right_symbol = || )
( country_key = 'GM' currency_key = 'GMD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'GN' currency_key = 'GNF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'GP' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = || )
( country_key = 'GQ' currency_key = 'XAF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'GR' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = | €| )
( country_key = 'GS' currency_key = 'GBP' symbol = || left_symbol = || right_symbol = || )
( country_key = 'GT' currency_key = 'GTQ' symbol = |Q| left_symbol = || right_symbol = || )
( country_key = 'GU' currency_key = 'USD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'GW' currency_key = 'XOF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'GY' currency_key = 'GYD' symbol = |$| left_symbol = || right_symbol = || )
( country_key = 'HK' currency_key = 'HKD' symbol = |$| left_symbol = || right_symbol = || )
( country_key = 'HM' currency_key = 'AUD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'HN' currency_key = 'HNL' symbol = |L| left_symbol = || right_symbol = || )
( country_key = 'HR' currency_key = 'HRK' symbol = |kn| left_symbol = || right_symbol = || )
( country_key = 'HT' currency_key = 'HTG' symbol = || left_symbol = || right_symbol = || )
( country_key = 'HU' currency_key = 'HUF' symbol = |Ft| left_symbol = || right_symbol = || )
( country_key = 'ID' currency_key = 'IDR' symbol = |Rp| left_symbol = || right_symbol = || )
( country_key = 'IE' currency_key = 'EUR' symbol = |€| left_symbol = |€| right_symbol = || )
( country_key = 'IL' currency_key = 'ILS' symbol = |₪| left_symbol = || right_symbol = || )
( country_key = 'IM' currency_key = 'GBP' symbol = |£| left_symbol = || right_symbol = || )
( country_key = 'IN' currency_key = 'INR' symbol = || left_symbol = || right_symbol = || )
( country_key = 'IO' currency_key = 'USD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'IQ' currency_key = 'IQD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'IR' currency_key = 'IRR' symbol = |﷼| left_symbol = || right_symbol = || )
( country_key = 'IS' currency_key = 'ISK' symbol = |kr| left_symbol = || right_symbol = || )
( country_key = 'IT' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = | €| )
( country_key = 'JE' currency_key = 'GBP' symbol = |£| left_symbol = || right_symbol = || )
( country_key = 'JM' currency_key = 'JMD' symbol = |J$| left_symbol = || right_symbol = || )
( country_key = 'JO' currency_key = 'JOD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'JP' currency_key = 'JPY' symbol = |¥| left_symbol = || right_symbol = || )
( country_key = 'KE' currency_key = 'KES' symbol = || left_symbol = || right_symbol = || )
( country_key = 'KG' currency_key = 'KGS' symbol = |лв| left_symbol = || right_symbol = || )
( country_key = 'KH' currency_key = 'KHR' symbol = |៛| left_symbol = || right_symbol = || )
( country_key = 'KI' currency_key = 'AUD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'KM' currency_key = 'KMF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'KN' currency_key = 'XCD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'KP' currency_key = 'KPW' symbol = || left_symbol = || right_symbol = || )
( country_key = 'KR' currency_key = 'KRW' symbol = || left_symbol = || right_symbol = || )
( country_key = 'KW' currency_key = 'KWD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'KY' currency_key = 'KYD' symbol = |$| left_symbol = || right_symbol = || )
( country_key = 'KZ' currency_key = 'KZT' symbol = |лв| left_symbol = || right_symbol = || )
( country_key = 'LA' currency_key = 'LAK' symbol = |₭| left_symbol = || right_symbol = || )
( country_key = 'LB' currency_key = 'LBP' symbol = |£| left_symbol = || right_symbol = || )
( country_key = 'LC' currency_key = 'XCD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'LI' currency_key = 'CHF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'LK' currency_key = 'LKR' symbol = |₨| left_symbol = || right_symbol = || )
( country_key = 'LR' currency_key = 'LRD' symbol = |$| left_symbol = || right_symbol = || )
( country_key = 'LS' currency_key = 'LSL' symbol = || left_symbol = || right_symbol = || )
( country_key = 'LT' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = | €| )
( country_key = 'LU' currency_key = 'EUR' symbol = |€| left_symbol = |€| right_symbol = || )
( country_key = 'LV' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = | €| )
( country_key = 'LY' currency_key = 'LYD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'MA' currency_key = 'MAD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'MC' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = || )
( country_key = 'MD' currency_key = 'MDL' symbol = || left_symbol = || right_symbol = || )
( country_key = 'ME' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = || )
( country_key = 'MF' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = || )
( country_key = 'MG' currency_key = 'MGA' symbol = || left_symbol = || right_symbol = || )
( country_key = 'MH' currency_key = 'USD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'MK' currency_key = 'MKD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'ML' currency_key = 'XOF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'MM' currency_key = 'MMK' symbol = || left_symbol = || right_symbol = || )
( country_key = 'MN' currency_key = 'MNT' symbol = |₮| left_symbol = || right_symbol = || )
( country_key = 'MO' currency_key = 'MOP' symbol = || left_symbol = || right_symbol = || )
( country_key = 'MP' currency_key = 'USD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'MQ' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = || )
( country_key = 'MR' currency_key = 'MRO' symbol = || left_symbol = || right_symbol = || )
( country_key = 'MS' currency_key = 'XCD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'MT' currency_key = 'EUR' symbol = |€| left_symbol = |€| right_symbol = || )
( country_key = 'MU' currency_key = 'MUR' symbol = |₨| left_symbol = || right_symbol = || )
( country_key = 'MV' currency_key = 'MVR' symbol = || left_symbol = || right_symbol = || )
( country_key = 'MW' currency_key = 'MWK' symbol = || left_symbol = || right_symbol = || )
( country_key = 'MX' currency_key = 'MXN' symbol = |$| left_symbol = || right_symbol = || )
( country_key = 'MY' currency_key = 'MYR' symbol = |RM| left_symbol = || right_symbol = || )
( country_key = 'MZ' currency_key = 'MZN' symbol = |MT| left_symbol = || right_symbol = || )
( country_key = 'NA' currency_key = 'NAD' symbol = |$| left_symbol = || right_symbol = || )
( country_key = 'NC' currency_key = 'XPF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'NE' currency_key = 'XOF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'NF' currency_key = 'AUD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'NG' currency_key = 'NGN' symbol = |₦| left_symbol = || right_symbol = || )
( country_key = 'NI' currency_key = 'NIO' symbol = |C$| left_symbol = || right_symbol = || )
( country_key = 'NL' currency_key = 'EUR' symbol = |€| left_symbol = |€ | right_symbol = || )
( country_key = 'NO' currency_key = 'NOK' symbol = |kr| left_symbol = || right_symbol = || )
( country_key = 'NP' currency_key = 'NPR' symbol = |₨| left_symbol = || right_symbol = || )
( country_key = 'NR' currency_key = 'AUD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'NT' currency_key = '' symbol = || left_symbol = || right_symbol = || )
( country_key = 'NU' currency_key = 'NZD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'NZ' currency_key = 'NZD' symbol = |$| left_symbol = || right_symbol = || )
( country_key = 'OM' currency_key = 'OMR' symbol = |﷼| left_symbol = || right_symbol = || )
( country_key = 'OR' currency_key = '' symbol = || left_symbol = || right_symbol = || )
( country_key = 'PA' currency_key = 'PAB' symbol = |B/.| left_symbol = || right_symbol = || )
( country_key = 'PE' currency_key = 'PEN' symbol = |S/.| left_symbol = || right_symbol = || )
( country_key = 'PF' currency_key = 'XPF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'PG' currency_key = 'PGK' symbol = || left_symbol = || right_symbol = || )
( country_key = 'PH' currency_key = 'PHP' symbol = |₱| left_symbol = || right_symbol = || )
( country_key = 'PK' currency_key = 'PKR' symbol = |₨| left_symbol = || right_symbol = || )
( country_key = 'PL' currency_key = 'PLN' symbol = |zł| left_symbol = || right_symbol = || )
( country_key = 'PM' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = || )
( country_key = 'PN' currency_key = 'NZD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'PR' currency_key = 'USD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'PS' currency_key = '' symbol = || left_symbol = || right_symbol = || )
( country_key = 'PT' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = | €| )
( country_key = 'PW' currency_key = 'USD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'PY' currency_key = 'PYG' symbol = |Gs| left_symbol = || right_symbol = || )
( country_key = 'QA' currency_key = 'QAR' symbol = |﷼| left_symbol = || right_symbol = || )
( country_key = 'RE' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = || )
( country_key = 'RO' currency_key = 'RON' symbol = |lei| left_symbol = || right_symbol = || )
( country_key = 'RS' currency_key = 'RSD' symbol = |Дин.| left_symbol = || right_symbol = || )
( country_key = 'RU' currency_key = 'RUB' symbol = |₽| left_symbol = || right_symbol = || )
( country_key = 'RW' currency_key = 'RWF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'SA' currency_key = 'SAR' symbol = |﷼| left_symbol = || right_symbol = || )
( country_key = 'SB' currency_key = 'SBD' symbol = |$| left_symbol = || right_symbol = || )
( country_key = 'SC' currency_key = 'SCR' symbol = |₨| left_symbol = || right_symbol = || )
( country_key = 'SD' currency_key = 'SDG' symbol = || left_symbol = || right_symbol = || )
( country_key = 'SE' currency_key = 'SEK' symbol = |kr| left_symbol = || right_symbol = || )
( country_key = 'SG' currency_key = 'SGD' symbol = |$| left_symbol = || right_symbol = || )
( country_key = 'SH' currency_key = 'SHP' symbol = |£| left_symbol = || right_symbol = || )
( country_key = 'SI' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = | €| )
( country_key = 'SJ' currency_key = 'NOK' symbol = || left_symbol = || right_symbol = || )
( country_key = 'SK' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = | €| )
( country_key = 'SL' currency_key = 'SLL' symbol = || left_symbol = || right_symbol = || )
( country_key = 'SM' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = || )
( country_key = 'SN' currency_key = 'XOF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'SO' currency_key = 'SOS' symbol = |S| left_symbol = || right_symbol = || )
( country_key = 'SR' currency_key = 'SRD' symbol = |$| left_symbol = || right_symbol = || )
( country_key = 'SS' currency_key = 'SSP' symbol = || left_symbol = || right_symbol = || )
( country_key = 'ST' currency_key = 'STN' symbol = || left_symbol = || right_symbol = || )
( country_key = 'SV' currency_key = 'SVC' symbol = |$| left_symbol = || right_symbol = || )
( country_key = 'SX' currency_key = 'ANG' symbol = || left_symbol = || right_symbol = || )
( country_key = 'SY' currency_key = 'SYP' symbol = |£| left_symbol = || right_symbol = || )
( country_key = 'SZ' currency_key = 'SZL' symbol = || left_symbol = || right_symbol = || )
( country_key = 'TC' currency_key = 'USD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'TD' currency_key = 'XAF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'TF' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = || )
( country_key = 'TG' currency_key = 'XOF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'TH' currency_key = 'THB' symbol = |฿| left_symbol = || right_symbol = || )
( country_key = 'TJ' currency_key = 'TJS' symbol = || left_symbol = || right_symbol = || )
( country_key = 'TK' currency_key = 'NZD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'TL' currency_key = 'USD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'TM' currency_key = 'TMT' symbol = || left_symbol = || right_symbol = || )
( country_key = 'TN' currency_key = 'TND' symbol = || left_symbol = || right_symbol = || )
( country_key = 'TO' currency_key = 'TOP' symbol = || left_symbol = || right_symbol = || )
( country_key = 'TR' currency_key = 'TRY' symbol = || left_symbol = || right_symbol = || )
( country_key = 'TT' currency_key = 'TTD' symbol = |TT$| left_symbol = || right_symbol = || )
( country_key = 'TV' currency_key = 'AUD' symbol = |$| left_symbol = || right_symbol = || )
( country_key = 'TW' currency_key = 'TWD' symbol = |NT$| left_symbol = || right_symbol = || )
( country_key = 'TZ' currency_key = 'TZS' symbol = || left_symbol = || right_symbol = || )
( country_key = 'UA' currency_key = 'UAH' symbol = |₴| left_symbol = || right_symbol = || )
( country_key = 'UG' currency_key = 'UGX' symbol = || left_symbol = || right_symbol = || )
( country_key = 'UM' currency_key = 'USD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'UN' currency_key = '' symbol = || left_symbol = || right_symbol = || )
( country_key = 'US' currency_key = 'USD' symbol = || left_symbol = |$| right_symbol = || )
( country_key = 'UY' currency_key = 'UYU' symbol = || left_symbol = || right_symbol = || )
( country_key = 'UZ' currency_key = 'UZS' symbol = |лв| left_symbol = || right_symbol = || )
( country_key = 'VA' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = || )
( country_key = 'VC' currency_key = 'XCD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'VE' currency_key = 'VES' symbol = |Bs| left_symbol = || right_symbol = || )
( country_key = 'VG' currency_key = 'USD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'VI' currency_key = 'USD' symbol = || left_symbol = || right_symbol = || )
( country_key = 'VN' currency_key = 'VND' symbol = |₫| left_symbol = || right_symbol = || )
( country_key = 'VU' currency_key = 'VUV' symbol = || left_symbol = || right_symbol = || )
( country_key = 'WF' currency_key = 'XPF' symbol = || left_symbol = || right_symbol = || )
( country_key = 'WS' currency_key = 'WST' symbol = || left_symbol = || right_symbol = || )
( country_key = 'YE' currency_key = 'YER' symbol = |﷼| left_symbol = || right_symbol = || )
( country_key = 'YT' currency_key = 'EUR' symbol = |€| left_symbol = || right_symbol = || )
( country_key = 'ZA' currency_key = 'ZAR' symbol = |R| left_symbol = || right_symbol = || )
( country_key = 'ZM' currency_key = 'ZMW' symbol = || left_symbol = || right_symbol = || )
( country_key = 'ZW' currency_key = 'USD' symbol = |Z$| left_symbol = || right_symbol = || )

      ).

    SORT gt_currency_list
      BY
        country_key
        currency_key.

    SELECT
        waers AS currency_key,
        isocd AS iso_code,

        tcurx~currdec AS decimal_count

      FROM tcurc

      LEFT JOIN tcurx
        ON tcurx~currkey = tcurc~waers

      FOR ALL ENTRIES IN @gt_currency_list

      WHERE
        waers = @gt_currency_list-currency_key

      INTO TABLE @DATA(lt_tcurc).

    SORT lt_tcurc
      BY currency_key.

    LOOP AT gt_currency_list
      ASSIGNING FIELD-SYMBOL(<ls_currency>).

      READ TABLE lt_tcurc
        WITH KEY
          currency_key = <ls_currency>-currency_key
        BINARY SEARCH
        ASSIGNING FIELD-SYMBOL(<ls_tcurc>).

      IF sy-subrc = 0.

        <ls_currency>-iso_code = <ls_tcurc>-iso_code.

        IF <ls_tcurc>-decimal_count IS INITIAL.
          <ls_currency>-decimal_count = 2.
        ELSE.
          <ls_currency>-decimal_count = <ls_tcurc>-decimal_count.
        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD get_currency.

    READ TABLE gt_currency_list
      WITH KEY
        country_key  = iv_country_key
        currency_key = iv_currency_key
      BINARY SEARCH
      INTO rs_currency.

    IF sy-subrc <> 0.
      "Currency with country &1 currency &2 does not exist.
      MESSAGE e001
        WITH
          iv_country_key
          iv_currency_key
        INTO DATA(lv_dummy).

      RAISE EXCEPTION TYPE cx_bapi_error
        EXPORTING
          t100_msgid = sy-msgid
          t100_msgno = sy-msgno
          t100_msgv1 = sy-msgv1
          t100_msgv2 = sy-msgv2
          t100_msgv3 = sy-msgv3
          t100_msgv4 = sy-msgv4.
    ENDIF.

  ENDMETHOD.


  METHOD get_currency_list_1.

    "Read land texts
    IF gt_currency_list[] IS NOT INITIAL.

      SELECT
          land1 AS country_key,
          landx50 AS country_name
        FROM t005t
        FOR ALL ENTRIES IN @gt_currency_list
        WHERE
          land1 = @gt_currency_list-country_key AND
          spras = @sy-langu
        INTO TABLE @DATA(lt_t005t).

      SORT lt_t005t
        BY country_key.

    ENDIF.

    "Read currency texts
    IF gt_currency_list[] IS NOT INITIAL.

      SELECT
          waers AS currency_key,
          ltext AS currency_text
        FROM tcurt
        FOR ALL ENTRIES IN @gt_currency_list
        WHERE
          waers = @gt_currency_list-currency_key AND
          spras = @sy-langu
        INTO TABLE @DATA(lt_tcurt).

      SORT lt_tcurt
        BY currency_key.

    ENDIF.


    LOOP AT gt_currency_list
      ASSIGNING FIELD-SYMBOL(<ls_currency>)
      WHERE
        country_key  IN it_country_key_rng AND
        currency_key IN it_currency_key_rng.

      APPEND INITIAL LINE TO rt_currency_list
        ASSIGNING FIELD-SYMBOL(<ls_currency_1>).

      MOVE-CORRESPONDING <ls_currency> TO <ls_currency_1>.

      "Country name
      READ TABLE lt_t005t
        WITH KEY
          country_key = <ls_currency>-country_key
        BINARY SEARCH
        ASSIGNING FIELD-SYMBOL(<ls_t005t>).

      IF sy-subrc = 0.

        <ls_currency_1>-country_name = <ls_t005t>-country_name.

      ENDIF.

      "Currency text
      READ TABLE lt_tcurt
        WITH KEY
          currency_key = <ls_currency>-currency_key
        BINARY SEARCH
        ASSIGNING FIELD-SYMBOL(<ls_tcurt>).

      IF sy-subrc = 0.

        <ls_currency_1>-currency_text = <ls_tcurt>-currency_text.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
