<%@ page language="java"  %>
<%@ page session ="true"%>
<%@ page import="com.mysap.sso.SSO_Authenticate" %>

<%
SSO_Authenticate auth = new SSO_Authenticate();
if (!auth.authenticate(request)) {
out.write("Session expired. Please log on to <a href=\"http://myu.umc.edu\">MyU Portal</a> again.");
return;
}

String user = (String) auth.getUserID();

%>

<!doctype html>
<html lang="en">

<head>
    <title>Contract Object Report</title>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8"/>
    <link rel="stylesheet" type="text/css" href="./public/semantic.min.css">
    <link rel='stylesheet prefetch' href='https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.1.8/components/icon.min.css'>

    <script
            src="https://code.jquery.com/jquery-3.1.1.min.js"
            integrity="sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8="
            crossorigin="anonymous"></script>
    <script src="./public/semantic.min.js"></script>

    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/buttons/1.4.2/css/buttons.dataTables.min.css">
    <script type="text/javascript" language="javascript" src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" language="javascript" src="https://cdn.datatables.net/fixedcolumns/3.2.3/js/dataTables.fixedColumns.min.js"></script>
    \
    <script type="text/javascript" language="javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>

    <script type="text/javascript" language="javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>

    <script type="text/javascript" language="javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
    <script type="text/javascript" language="javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
    <script src="./public/rowsGroup.js"></script>


    <style>
        .dataTables_wrapper {
            margin-top: 80px;
        }

        div.ColVis {
            float: left;
        }

        lable.required :after {
            content:"*";
            color:red;
        }


    </style>

</head>

<body>

<div class="ui dimmer" id="loader">
    <div class="ui large text loader">Loading</div>
</div>

<div class="ui modal" id="messageBox">

    <div class="image content">
        <div class="description">
            <div class="ui warning message">

                <div class="header" id="errorMessageHeader">

                </div>

            </div>
        </div>
    </div>
    <div class="actions">
        <div class="ui deny button">
            OK
        </div>
    </div>
</div>



<div class="ui fixed icon menu" >

        <a href="#" class="header item">
            <h4 class="ui header"> Contract Object Report</h4>
        </a>

        <a class="item" id="menu-search">
            <i class="search icon"></i>
            Search
        </a>

</div>



<div class="ui modal" id="advancedsearch">
    <div class="header">Search</div>
    <div class="scrolling content">
        <div class="ui form">

            <div class="inline field">
                <label class="required">Academic Year</label>
                <select class="ui search dropdown" id="academicYear">
                </select>
            </div>

            <div class="inline field">
                <label class="required">Academic Session</label>
                <select class="ui search dropdown" id="academicSession">
                    <option value="005">Summer</option>
                    <option value="010">Fall Semester</option>
                    <option value="020">Spring Semester</option>
                </select>
            </div>

            <div class="inline field">
                <label>Contract Object Type</label>
                <select class="ui search dropdown" id="contractOjectType">
                    <option value=""></option>
                </select>
            </div>

            <div class="inline field">
                <label>Grant</label>
                <select class="ui search dropdown" id="grant">
                    <option value=""></option>
                </select>
            </div>

        </div>
    </div>

    <div class="actions">
        <div class="ui approve button" id="start-search">Search</div>
        <div class="ui cancel button">Cancel</div>
    </div>
</div>


<div class="ui modal" id="fieldselect">

    <div class="ui content huge divided relaxed horizontal list" id="fieldList">

    </div>


    <div class="actions">
        <div class="ui cancel button">Close</div>
    </div>
</div>

<div style="margin:5px;">

    <table id="dataTable" class="display nowrap cell-border	" width="95%">
        <thead>
        </thead>

    </table>
</div>

<script>

    var academicYearOptions = [];
    var sessionOptionss = {'005': 'Summer', '010': 'Fall Semester', '020': 'Spring Semester'};
    var contractObjecTypeOptions = [];
    var grantOptions = [];
    var lineItems = [];
    var table = null;

    var COLUMNS = [
        {data: 'STUDENTNUMBER', name: 'STUDENTNUMBER', title: 'Business Partner', visible: true},
        {data: 'STUDENTNAME', name: 'STUDENTNAME', title: 'Student Name', visible: true, "defaultContent": ""},
        {data: 'PERSL', name: 'PERSL', title: 'Period', visible: true},
        {data: 'CONTRACTOBJECTNAME', name: 'CONTRACTOBJECTNAME', title: 'Contract Object Type', visible: true, "defaultContent": ""},
        {data: 'PSGRANT', name: 'PSGRANT', title: 'Grant', visible: true, "defaultContent": ""},
        {data: 'GRANTNAME', name: 'GRANTNAME', title: 'Grant Name', visible: true, "defaultContent": ""},

        {data: 'BUDAT', name: '', title: 'Posting Date', visible: false},
        {data: 'FAEDN', name: '', title: 'Due Date', visible: false},
        {data: 'GSBER', name: '', title: 'Business Area', visible: false},
        {data: 'AUGDT', name: '', title: 'Clearing Date', visible: false,  "defaultContent": ""},
        {data: 'AUGBL', name: '', title: 'Clearing Document', visible: false, "defaultContent": ""},

        {data: 'BLART', name: '', title: 'Document Type', visible: false, "defaultContent": ""},
        {data: 'AUGRD', name: '', title: 'Clearing Reason', visible: false, "defaultContent": ""},
        {data: 'AUGRS', name: '', title: 'Clearing Restriction', visible: false, "defaultContent": ""},
        {data: 'AUGVD', name: '', title: 'Value Date', visible: false, "defaultContent": ""},
        {data: 'INKPS', name: '', title: 'Collection Item', visible: false, "defaultContent": ""},

        {data: 'FIPEX', name: '', title: 'Commitment Item', visible: false, "defaultContent": ""},
        {data: 'VKONT', name: '', title: 'Contract Account Number', visible: false, "defaultContent": ""},
        {data: 'VKTYP_PS', name: '', title: 'Contract Account Category', visible: false, "defaultContent": ""},


        {data: 'BLDAT', name: '', title: 'Document Date', visible: false, "defaultContent": ""},
        {data: 'OPBEL', name: '', title: 'Number of Contract Accts', visible: false, "defaultContent": ""},


        {data: 'FONDS', name: '', title: 'Fund', visible: false, "defaultContent": ""},
        {data: 'FTSTL', name: '', title: 'Funds Center', visible: false, "defaultContent": ""},
        {data: 'HKONT', name: '', title: 'G/L Account', visible: false, "defaultContent": ""},


        {data: 'PSGRP', name: '', title: 'Grouping Key', visible: false, "defaultContent": ""},
        {data: 'PYMET', name: '', title: 'Payment Method', visible: false, "defaultContent": ""},


        {data: 'XRAGL', name: '', title: 'Clearing Posting Reversed', visible: false, "defaultContent": ""},
        {data: 'FIKEY', name: '', title: 'Reconcilliation Key', visible: false, "defaultContent": ""},



        {data: 'ABGRD', name: '', title: 'Posting Reason', visible: false, "defaultContent": ""},

        {data: 'OBJID', name: '', title: 'Student ObjID', visible: false, "defaultContent": ""},

        {data: 'STFEECAT', name: '', title: 'Fee Category', visible: false, "defaultContent": ""},
        {data: 'GRANT_TYPE', name: '', title: 'Grant Type', visible: false, "defaultContent": ""},

        {data: 'BETRH', name: '', title: 'Amount', visible: true, "defaultContent": ""}


    ];


    var WS_SERVER_BASE_URL = './api';


    $('#menu-search').click( function(e) {

        e.preventDefault();

        $('#advancedsearch').modal('show');

        return false;
    });

    $('#menu-fields').click( function(e) {

        e.preventDefault();

        $('#fieldselect').modal('show');

        return false;
    });

    $('#start-search').click( function(){


        $("#loader").addClass('active');
        if(table){
            table.destroy();
            $('#dataTable').empty();
        }
        lineItems = [];

        var query = {};
        query.IV_YEAR = $('#academicYear').val();
        query.IV_SESSION = $('#academicSession').val();
        query.IV_CONTRACT_OBJ_TYPE = $('#contractOjectType').val();
        query.IV_GRANT = $('#grant').val();
        query.IV_REQUEST = 'SEARCH';
        query.IV_USER = '<%=user%>';

        $.ajax({
            type: 'POST',
            url: WS_SERVER_BASE_URL + '/search',
            dataType: 'json',
            data: {parameters: JSON.stringify(query)},
            headers: {user: '<%=user%>'}
        })
            .done(function(data){
                lineItems = JSON.parse(data.EV_RESULTS.replace(/\\\"/g, ''));

                table = $('#dataTable').DataTable({
                    dom:    "Bfrtip",
                    data: lineItems,
                    columns: COLUMNS,
                    "paging": true,
                    "pageLength": 10,
                    "scrollX": true,
                    buttons:  [
                        {extend: 'colvis'},
                        {
                            extend: 'excelHtml5',
                            customize: function (xlsx) {
                                var sheet = xlsx.xl.worksheets['contractobjectreport.xml'];

                                $('row c[r^="C"]', sheet).attr('s', '2');
                            }
                        }
                    ],

                    rowsGroup: [// Always the array (!) of the column-selectors in specified order to which rows groupping is applied
                        // (column-selector could be any of specified in https://datatables.net/reference/type/column-selector)
                        'STUDENTNUMBER:name',
                        'STUDENTNAME:name'
                    ]

                } );

                table.order([ 0, 'asc' ] ).draw();


                var numberResult = lineItems.length;
                if(numberResult < 1){
                    $('#errorMessageHeader').text('No record was found');
                    $('#messageBox').modal('show');
                    return;
                }

            })
            .fail(function(err){

                $('#errorMessageHeader').text(err.statusText);
                $('#messageBox').modal('show');

            })
            .always(function(){
                $("#loader").removeClass('active');
            });


    });




    $( document ).ready(function() {

        for(var i=0; i<COLUMNS.length; i++){
            var singleColumn = COLUMNS[i];
            if(singleColumn.visible === true) {
                var checkBox = '<div class="item"> <input type="checkbox" class="fieldselectionch" name="CB_'
                                + singleColumn.name + '" value="' + singleColumn.name + '" checked> <label>"' +
                                + singleColumn.title + '</label> </div>';


                $('#fieldList').append(checkBox);
            }

        }

        $('.fieldselectionch').change(function(){
            var column = table.column( this.name.replace('CB_','') +':name');
            column.visible( ! column.visible() );
        })


        $('#messageBox').modal('hide');
        //$("#loader").addClass('active');


        var currentYear = new Date().getFullYear();
        for(var i=currentYear-5; i<=currentYear+5; i++){
            var yearOption = {key: i, value: (i-1) +'-'+i };
            academicYearOptions.push(yearOption);
        }

        for (index in academicYearOptions) {
            $('#academicYear').append($('<option>').text(academicYearOptions[index].value).attr('value', academicYearOptions[index].key));

        }
/*
        var testingData = [{"MANDT":"120","PERSL":"1205","GPART":"3375025001","HVORG":"GIBI","TVORG":"0001","BUDAT":"2012-07-17","FAEDN":"2012-07-17","GSBER":"10","BLART":"YP","FIPEX":"11600","VKONT":"003375025001","VKTYP_PS":"SP","BLDAT":"2012-07-17","OPBEL":"005200000348","FONDS":"3375025001","FISTL":"19007","HKONT":"0000011484","PSGRANT":"AS03","PSGRP":"0002","BETRH":0.77,"FIKEY":"P3-120717-02","GRANT_TYPE":"GI"},{"MANDT":"120","PERSL":"1205","GPART":"0030000303","HVORG":"GIBI","TVORG":"0001","BUDAT":"2012-07-17","FAEDN":"2012-07-17","GSBER":"10","BLART":"YP","FIPEX":"11600","VKONT":"000010000103","VKTYP_PS":"ST","PSOBTYP":"FAID","BLDAT":"2012-07-17","OPBEL":"005200000347","FONDS":"3375025001","FISTL":"19007","HKONT":"0000011480","PSGRANT":"AS03","PSGRP":"0001","BETRH":-0.77,"FIKEY":"P3-120717-02","GRANT_TYPE":"GI"}];
        table = $('#dataTable').DataTable({
            dom:    "Bfrtip",
            data: testingData,
            columns: COLUMNS,
            "paging": true,
            "pageLength": 100,
            "scrollX": true,
            buttons:  [
                {extend: 'colvis'},
                {
                    extend: 'excelHtml5',
                    customize: function (xlsx) {
                        var sheet = xlsx.xl.worksheets['sheet1.xml'];

                        $('row c[r^="C"]', sheet).attr('s', '2');
                    }
                }
            ],

            fixedColumns:   {
                leftColumns: 1,
                rightColumns: 1
            }


        } );

        return;

*/



        $.ajax({
            type: "GET",
            url: WS_SERVER_BASE_URL + '/init',
            dataType: 'json',
            async: true,
            headers: {user: '<%=user%>'}

        })
            .done(function (data) {

                var returnMessage = data.EV_MESSAGE;
                if(returnMessage !== null && returnMessage.MESSAGE !== null && returnMessage.TYPE === 'E'){
                    $('#errorMessageHeader').text(returnMessage.MESSAGE);
                    $('#messageBox').modal('show');
                    return;
                }

                contractObjecTypeOptions = JSON.parse(data.EV_PSOBTYP.replace(/""/g, '"'));

                grantOptions = JSON.parse(data.EV_GRANT.replace(/\\\"/g, ''));


                for (index in contractObjecTypeOptions) {
                    $('#contractOjectType').append($('<option>').text(contractObjecTypeOptions[index].PSOBTYPT).attr('value', contractObjecTypeOptions[index].PSOBTYP));

                }

                for (index in grantOptions) {
                    $('#grant').append($('<option>').text(grantOptions[index].DESCRIPTION).attr('value', grantOptions[index].GRANT_NBR));
                }

                $('#advancedsearch').modal('show');


            })
            .fail(function (jqXHR, textStatus, errorThrown) {
                $('#errorMessageHeader').text(jqXHR.statusText);
                $('#messageBox').modal('show');
            })
            .always(function(){
                $("#loader").removeClass('active');
            });

    });


</script>


</body>
</html>
