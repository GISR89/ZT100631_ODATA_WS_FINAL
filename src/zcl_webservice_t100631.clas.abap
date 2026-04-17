class ZCL_WEBSERVICE_T100631 definition
  public
  final
  create public .

public section.

  interfaces IF_HTTP_EXTENSION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_WEBSERVICE_T100631 IMPLEMENTATION.


  METHOD if_http_extension~handle_request.

    DATA lv_x_json TYPE xstring.

    SELECT FROM zmara_lg AS a
       JOIN zmarc_lg AS b
       ON a~matnr EQ b~matnr
       FIELDS a~matnr, b~werks, a~ersda, a~ernam, a~laeda, a~aenam, a~vpsta, a~pstat, a~lvorm, a~mtart,
            a~mbrsh, a~matkl, a~bismt, a~meins, a~bstme, a~zeinr, a~zeiar, b~dispr, b~ausme, b~ekgrp, b~dismm, b~dispo
      INTO TABLE @DATA(lt_materiales).

    DATA(lo_json_out) = cl_sxml_string_writer=>create( type = if_sxml=>co_xt_json ).

    CALL TRANSFORMATION id SOURCE lt_materiales = lt_materiales[]
                        RESULT XML lo_json_out.

    DATA(lv_json_response) = cl_abap_codepage=>convert_from( lo_json_out->get_output( ) ).

    CALL FUNCTION 'SCMS_STRING_TO_XSTRING'
      EXPORTING
        text   = lv_json_response
*       MIMETYPE       = ' '
*       ENCODING       =
      IMPORTING
        buffer = lv_x_json
      EXCEPTIONS
        failed = 1
        OTHERS = 2.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    server->response->set_header_field( name = 'Content-type' value = 'application/json' ).
    server->response->set_header_field( name = 'encoding' value = 'UTF-8' ).
    server->response->set_data( data = lv_x_json ).

  ENDMETHOD.
ENDCLASS.
