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
    <title>Main Sub Transactions Report</title>
    <meta http-equiv="Content-type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">


    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/buttons/1.4.2/css/buttons.dataTables.min.css">
    <link href="https://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.min.css" rel="stylesheet" type="text/css" />
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet" type="text/css" />
    <link href="public/bootstrap-datepicker3.min.css" rel="stylesheet" type="text/css" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap3-dialog/1.34.7/css/bootstrap-dialog.min.css" rel="stylesheet" type="text/css" />

    <script src="https://code.jquery.com/jquery-2.1.4.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
    <script type="text/javascript" language="javascript" src="https://cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
    <script type="text/javascript" language="javascript" src="https://cdn.datatables.net/fixedcolumns/3.2.3/js/dataTables.fixedColumns.min.js"></script>
    <script type="text/javascript" language="javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/dataTables.buttons.min.js"></script>
    <script type="text/javascript" language="javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.colVis.min.js"></script>
    <script type="text/javascript" language="javascript" src="https://cdn.datatables.net/buttons/1.4.2/js/buttons.html5.min.js"></script>
    <script type="text/javascript" language="javascript" src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
    <script type="text/javascript" language="javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap3-dialog/1.34.7/js/bootstrap-dialog.min.js"></script>
    <script src="./public/rowsGroup.js"></script>
    <script src="./public/bootstrap-datepicker.min.js"></script>


    <style>
        .dataTables_wrapper {
            margin-top: 80px;
        }

        div.ColVis {
            float: left;
        }
        .form-group.required .control-label:after {
            content:"*";
            color:red;
        }
    </style>

</head>

<body>



<div id="loader" class="modal fade" tabindex="-1" role="dialog" data-keyboard="false"
     data-backdrop="static">
    <div class="modal-dialog">
        <div class="modal-content">

            <div class="modal-body text-center" >
                <i class="fa fa-spinner fa-spin" style="font-size:60px"></i>
            </div>
            <div class="modal-footer" style="text-align: center"></div>
        </div>
    </div>
</div>


<nav class="navbar navbar-default navbar-fixed-top">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">Main Sub Report</a>
        </div>
        <ul class="nav navbar-nav">

            <li><a href="#" id="menu-search">Search</a></li>

        </ul>
    </div>
</nav>


<div id="advancedsearch" class="modal fade" role="dialog">
    <div class="modal-dialog modal-lg">

        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal">&times;</button>
                <h4 class="modal-title">Search</h4>
            </div>
            <div class="modal-body">

                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="control-label col-sm-3" for="mainTransaction">Main Transaction:</label>
                        <div class="col-sm-9">
                            <select class="ui search dropdown" id="mainTransaction">
                                <option value=""></option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="control-label col-sm-3" for="mainTransaction">Sub Transaction:</label>
                        <div class="col-sm-9">
                            <select class="ui search dropdown" id="subTransaction">
                                <option value=""></option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group required">
                        <label class="control-label col-sm-3" for="mainTransaction">Posting Date Range</label>
                        <div class="col-sm-9">
                            <div class="input-daterange" id="dateRange">
                                <input type="text" class="input-small" name="startDate" id="startDate" />
                                <span class="add-on">to</span>
                                <input type="text" class="input-small" name="endDate" id="endDate" />
                            </div>

                        </div>
                    </div>


                    <div class="form-group">
                        <label class="control-label col-sm-3" for="feeCategory">Fee Category</label>
                        <div class="col-sm-9">
                            <select class="ui search dropdown" id="feeCategory">
                                <option value=""></option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="control-label col-sm-3" for="feeCategory">Contract Object Type</label>
                        <div class="col-sm-9">
                            <select class="ui search dropdown" id="contractOjectType">
                                <option value=""></option>
                            </select>
                        </div>
                    </div>

                </form>


            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button> &nbsp;&nbsp;
                <button type="button" class="btn btn-default" data-dismiss="modal" id="start-search">Search</button>
            </div>
        </div>

    </div>
</div>


<div style="margin:5px;">

    <table id="dataTable" class="display nowrap cell-border	" width="95%">
        <thead>
        </thead>

    </table>
</div>

<script>

    var contractObjecTypeOptions = [];
    var mainTransactionOptions = [];
    var subTransactionOptions = [];
    var feeCategoryOptions = [];
    var startDate= null;
    var endDate = null;


    var lineItems = [];
    var table = null;

    var MAIN_SUB_COLUMNS = [
        {data: 'STUDENTNUMBER', name: 'STUDENTNUMBER', title: 'Business Partner', visible: true},
        {data: 'STUDENTNAME', name: 'STUDENTNAME', title: 'Student Name', visible: true, "defaultContent": ""},
        {data: 'PERSL', name: 'PERSL', title: 'Period', visible: true},

        {data: 'HVORGT', name: 'HVORGT', title: 'Main Transaction', visible: true, "defaultContent": ""},

        {data: 'TVORGT', name: 'TVORGT', title: 'Sub Transaction', visible: true, "defaultContent": ""},

        {data: 'STFEECAT', name: 'STFEECAT', title: 'Fee Category', visible: true, "defaultContent": ""},
        {data: 'BUDAT', name: '', title: 'Posting Date', visible: true},

        {data: 'FAEDN', name: '', title: 'Due Date', visible: true},

        {data: 'CONTRACTOBJECTNAME', name: 'CONTRACTOBJECTNAME', title: 'Contract Object Type', visible: false, "defaultContent": ""},
        {data: 'PSGRANT', name: 'PSGRANT', title: 'Grant', visible: false, "defaultContent": ""},
        {data: 'GRANTNAME', name: 'GRANTNAME', title: 'Grant Name', visible: false, "defaultContent": ""},


        {data: 'GSBER', name: '', title: 'Business Area', visible: false},
        {data: 'AUGDT', name: '', title: 'Clearing Date', visible: false,  "defaultContent": ""},
        {data: 'AUGBL', name: '', title: 'Clearing Document', visible: false, "defaultContent": ""},

        {data: 'BLART', name: '', title: 'Document Type', visible: false, "defaultContent": ""},
        {data: 'AUGRD', name: '', title: 'Clearing Reason', visible: false, "defaultContent": ""},
        {data: 'AUGRS', name: '', title: 'Clearing Restriction', visible: false, "defaultContent": ""},
        {data: 'AUGVD', name: '', title: 'Value Date', visible: true, "defaultContent": ""},
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


        startDate = $('#startDate').val();
        endDate = $('#endDate').val();

        if(startDate === null || startDate === '' || endDate === null) {
            BootstrapDialog.show({
                type: BootstrapDialog.TYPE_DANGER,
                title: 'Parameter missing',
                message: 'Posting Date Range is required',
                buttons: [{
                    label: 'OK',
                    action: function(dialogItself){
                        dialogItself.close();
                    }
                }]
            });

            return;
        }
        if(startDate !== '' && endDate === ''){
            endDate = startDate; //single day
        }


        $("#loader").modal('show');

        if(table){
            table.destroy();
            $('#dataTable').empty();
        }
        lineItems = [];

        var query = {};
        query.IV_HVORG = $('#mainTransaction').val();
        query.IV_TVORG = $('#subTransaction').val();
        query.IV_FEE_CATEGORY = $('#feeCategory').val();
        query.IV_CONTRACT_OBJ_TYPE = $('#contractOjectType').val();

        query.IV_BEGDA = startDate.split('/')[2] + startDate.split('/')[0] + startDate.split('/')[1];
        query.IV_ENDDA = endDate.split('/')[2] + endDate.split('/')[0] + endDate.split('/')[1];
        query.IV_REQUEST = 'SEARCH';
        query.IV_USER = '<%=user%>';

        console.log(query);

        $.ajax({
            type: 'POST',
            url: WS_SERVER_BASE_URL + '/search',
            dataType: 'json',
            data: {parameters: JSON.stringify(query)},
            headers: {user: '<%=user%>'}
        })
            .done(function(data){

                if(data.EV_RESULTS === null || data.EV_RESULTS === undefined || data.EV_RESULTS === ''){

                        BootstrapDialog.show({
                            type: BootstrapDialog.TYPE_DANGER,
                            title: 'No record was found',
                            message: 'No record was found',
                            buttons: [{
                                label: 'OK',
                                action: function(dialogItself){
                                    dialogItself.close();
                                }
                            }]
                        });

                        return;
                }

                lineItems = JSON.parse(data.EV_RESULTS.replace(/\\\"/g, ''));

                table = $('#dataTable').DataTable({
                    dom:    "Bfrtip",
                    data: lineItems,
                    columns: MAIN_SUB_COLUMNS,
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

                    BootstrapDialog.show({
                        type: BootstrapDialog.TYPE_DANGER,
                        title: 'No record was found',
                        message: 'No record was found',
                        buttons: [{
                            label: 'OK',
                            action: function(dialogItself){
                                dialogItself.close();
                            }
                        }]
                    });

                    return;
                }

            })
            .fail(function(err){

                BootstrapDialog.show({
                    type: BootstrapDialog.TYPE_DANGER,
                    title: 'Unexpected error ',
                    message: err.statusText,
                    buttons: [{
                        label: 'OK',
                        action: function(dialogItself){
                            dialogItself.close();
                        }
                    }]
                });

            })
            .always(function(){
                $("#loader").modal('hide');
            });
    });




    $( document ).ready(function() {

        $.ajax({
            type: "GET",
            url: WS_SERVER_BASE_URL + '/init',
            dataType: 'json',
            async: true,
            headers: {user: '<%=user%>'}

        })
            .done(function(data) {

                var returnMessage = data.EV_MESSAGE;
                if(returnMessage !== null && returnMessage.MESSAGE !== null && returnMessage.TYPE === 'E'){

                    BootstrapDialog.show({
                        type: BootstrapDialog.TYPE_DANGER,
                        title: 'Unexpected error ',
                        message: returnMessage.MESSAGE,
                        buttons: [{
                            label: 'OK',
                            action: function(dialogItself){
                                dialogItself.close();
                            }
                        }]
                    });

                    return;
                }

                contractObjecTypeOptions = JSON.parse(data.EV_PSOBTYP.replace(/""/g, '"'));
                mainTransactionOptions = JSON.parse(data.EV_HVORG.replace(/\\\"/g, ''));
                subTransactionOptions = JSON.parse(data.EV_TVORG.replace(/\\\"/g, ''));
                feeCategoryOptions = JSON.parse(data.EV_FEECAT.replace(/\\\"/g, ''));

                for (index in contractObjecTypeOptions) {
                    $('#contractOjectType').append($('<option>').text(contractObjecTypeOptions[index].PSOBTYPT).attr('value', contractObjecTypeOptions[index].PSOBTYP));
                }

                for (index in mainTransactionOptions) {
                    $('#mainTransaction').append($('<option>').text(mainTransactionOptions[index].TXT30).attr('value', mainTransactionOptions[index].HVORG));
                }

                for (index in feeCategoryOptions) {
                    $('#feeCategory').append($('<option>').text(feeCategoryOptions[index].TEXT).attr('value', feeCategoryOptions[index].STFEECAT));
                }

                /*
                for (index in subTransactionOptions) {
                    $('#mainTransaction').append($('<option>').text(subTransactionOptions[index].TXT30).attr('value', subTransactionOptions[index].TVORG));
                }
                */
                $('#advancedsearch').modal('show');


            })
            .fail(function (jqXHR, textStatus, errorThrown) {
                BootstrapDialog.show({
                    type: BootstrapDialog.TYPE_DANGER,
                    title: 'Unexpected error ',
                    message: jqXHR.statusText,
                    buttons: [{
                        label: 'OK',
                        action: function(dialogItself){
                            dialogItself.close();
                        }
                    }]
                });

            })
            .always(function(){
                $("#loader").modal('hide');
            });


            $('#mainTransaction').click(function(){

                var mainTransaction = $('#mainTransaction').val();
                if(mainTransaction === null || mainTransaction === ''){
                    $('#subTransaction').find('option').remove();
                    $('#subTransaction').val('');
                }
                else{
                    $('#subTransaction').find('option').remove();
                    for (index in subTransactionOptions) {
                        if(subTransactionOptions[index].HVORG === mainTransaction) {
                            $('#subTransaction').append($('<option>').text(subTransactionOptions[index].TXT30).attr('value', subTransactionOptions[index].TVORG));
                        }
                    }
                }

            });

        $('.input-daterange').datepicker({
            format: 'mm/dd/yyyy',
            autoclose: true
        });


    });


</script>


</body>
</html>
