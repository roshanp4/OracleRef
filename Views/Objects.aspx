<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Objects.aspx.cs" Inherits="LDS.Views.Objects" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>
<%@ Register Src="~/UserControls/Header.ascx" TagPrefix="uc1" TagName="Header" %>
<%@ Register Src="~/UserControls/LMenu.ascx" TagPrefix="uc1" TagName="LMenu" %>
<%@ Register Src="~/UserControls/Footer.ascx" TagPrefix="uc1" TagName="Footer" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="../Css/morris.css" rel="stylesheet" />
    <title>LDS::Objects</title>
    <script src="../js/messageBox.js"></script>
</head>
<body>
    <form id="frmObjects" runat="server">
        <div id="wrapper">
            <!-- Navigation -->
            <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
                <uc1:Header runat="server" ID="Header" />
                <uc1:LMenu runat="server" ID="LMenu" />
                <!-- /.navbar-static-side -->
            </nav>
            <div id="page-wrapper">
                <ol class="breadcrumb">
                    <li>
                        <i class="fa fa-dashboard"></i><a href="Dashboard.aspx">Dashboard</a>
                    </li>
                    <li class="active">
                        <i class="fa fa-desktop"></i>
                        <asp:Label ID="lblFormName" runat="server" Text="Bootstrap Elements"></asp:Label>
                    </li>
                </ol>
                <br />
                <div class="row">
                    <div class="col-lg-12">
                        <div class="panel panel-default">
                            <div class="panel-heading" style="padding: 1px 9px;">

                                <asp:ImageButton ID="imgBtnNew" runat="server" Text="Back" ImageUrl="~/Images/Upload.png" Height="27px" ToolTip="Add New Document" OnClick="imgBtnNew_Click" />
                                <asp:ImageButton ID="imgBtnSelect" runat="server" Text="Back" ImageUrl="~/Images/listItems.png" Height="28px" ToolTip="Select File" OnClick="imgBtnSelect_Click" />
                                <asp:ImageButton ID="imgBtndelete" runat="server" Text="Back" ImageUrl="~/Images/Delete.png" Height="30px" ToolTip="Delete Items" OnClick="imgBtndelete_Click" />
                                <asp:ImageButton ID="imgbtnCopy" runat="server" Text="Copy" ImageUrl="~/Images/Copy_Icon.png" Height="24px" ToolTip="Copy Items" OnClick="imgbtnCopy_Click" />
                                <asp:ImageButton ID="imgbtnMove" runat="server" Text="Paste" ImageUrl="~/Images/move-icon.png" Height="28px" ToolTip="Move Items" OnClick="imgbtnMove_Click" />
                                <asp:ImageButton ID="imgBtnPaste" runat="server" Text="Paste" ImageUrl="~/Images/paste_Icon.png" Height="24px" ToolTip="Paste Items" Visible="false" OnClick="imgBtnPaste_Click" />
                                <asp:ImageButton ID="imgBtnEmail" runat="server" Text="Back" ImageUrl="~/Images/emailIco.png" Height="30px" ToolTip="Compress and Email" OnClick="imgBtnEmail_Click" />
                                <asp:ImageButton ID="imgBtnDetaildView" runat="server" Text="Copy" ImageUrl="~/Images/listView.png" Height="24px" ToolTip="Contensed View" Style="float: right; margin-right: 6px;" OnClick="imgBtnDetaildView_Click" />
                                <asp:ImageButton ID="imgbtnContensView" runat="server" Text="Paste" ImageUrl="~/Images/contensed.png" Height="24px" ToolTip="List View" Style="float: right; margin-right: 6px;" OnClick="imgbtnContensView_Click" />

                            </div>



                            <asp:MultiView ID="mvObject" runat="server">
                                <asp:View ID="vwNewObjects" runat="server">
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="panel-body">
                                                <div class="row">
                                                    <div class="col-lg-6">
                                                        <div class="form-group">
                                                            <asp:Image ID="imgFile" runat="server" Height="60" Width="75" Style="margin-left: 50%;" />
                                                        </div>
                                                        <div class="form-group">
                                                            <asp:UpdatePanel ID="udpMaster" runat="server">
                                                                <ContentTemplate>
                                                                    <label>File</label>
                                                                    <asp:FileUpload ID="fupFile" runat="server" CssClass="fileUpload" Style="margin-top: 0%;"
                                                                        onchange="GetFileName(this)" />
                                                                    <asp:RequiredFieldValidator ID="rfvFileupload" ValidationGroup="Submit" runat="server" Display="Dynamic"
                                                                        ErrorMessage="* required" ToolTip="* required" ForeColor="#ff0000" ControlToValidate="fupFile"></asp:RequiredFieldValidator>
                                                                </ContentTemplate>
                                                            </asp:UpdatePanel>
                                                        </div>
                                                        <div class="form-group">
                                                            <label>Object Name</label>
                                                            <asp:TextBox ID="txtObjectName" class="form-control" runat="server" placeholder="Object Name"></asp:TextBox>
                                                            <asp:RequiredFieldValidator ID="rfvObj" runat="server" ErrorMessage="Object name Should not empty" ToolTip="Object name Should not empty"
                                                                SetFocusOnError="true" Display="Dynamic" ControlToValidate="txtObjectName" ForeColor="#cc0000" ValidationGroup="Submit">

                                                            </asp:RequiredFieldValidator>
                                                        </div>
                                                        <div class="form-group">
                                                            <label>Version</label>
                                                            <asp:TextBox ID="txtVersion" class="form-control" runat="server" placeholder="Version" ReadOnly="true"></asp:TextBox>
                                                        </div>
                                                        <div class="form-group">
                                                            <div class="checkbox" style="margin-left: 50%;">
                                                                <label>
                                                                    <asp:CheckBox ID="chkStatus" runat="server" class="" Text="Active ?" />
                                                                </label>
                                                            </div>
                                                        </div>
                                                        <div class="form-group">
                                                            <label>Description</label>
                                                            <asp:TextBox ID="txtDescription" class="form-control" runat="server" placeholder="Description" TextMode="MultiLine"></asp:TextBox>
                                                        </div>
                                                    </div>
                                                    <br />
                                                    <div class="col-lg-8">
                                                        <div class="form-group" style="margin-top: 8px;">
                                                            <asp:Button runat="server" ID="btnSubmitObject" class="btn btn-outline btn-success" Text="Add Objects" ValidationGroup="Submit" OnClick="btnSubmitObject_Click"></asp:Button>
                                                            <asp:Button runat="server" ID="btnResetObject" class="btn btn-outline btn-warning" Text="Reset" OnClick="btnResetObject_Click"></asp:Button>

                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </asp:View>
                                <asp:View ID="vwObjectAttr" runat="server">

                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="panel-body">
                                                <div class="row">
                                                    <div class="col-lg-10">
                                                        <div class="form-group">
                                                            <div class="table-responsive">
                                                                <link href="../Css/Style.css" rel="stylesheet" />
                                                                <asp:Accordion
                                                                    ID="AccordionGroupDocument"
                                                                    runat="Server"
                                                                    CssClass="accordion"
                                                                    SelectedIndex="0"
                                                                    HeaderCssClass="accordionHeader"
                                                                    ContentCssClass="accordionContent"
                                                                    HeaderSelectedCssClass="accordionHeaderSelected"
                                                                    AutoSize="None"
                                                                    FadeTransitions="true"
                                                                    TransitionDuration="250"
                                                                    FramesPerSecond="40"
                                                                    RequireOpenedPane="true"
                                                                    SuppressHeaderPostbacks="true" EnableViewState="true"
                                                                    ClientIDMode="Static">
                                                                </asp:Accordion>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-lg-6">
                                                    <div class="form-group">
                                                        <asp:Button runat="server" ID="btnSaveAttr" class="btn btn-outline btn-success" Text="Submit" ValidationGroup="AttrVal" OnClick="btnSaveAttr_Click"></asp:Button>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                </asp:View>
                                <asp:View ID="vwContensed" runat="server">
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="panel-body">
                                                <div class="row">

                                                    <div class="col-lg-12">

                                                        <div class="form-group">

                                                            <div class="table-responsive">
                                                                <div class="col-lg-12" style="border: dotted; border-color: #06B7F9; height: 52px; width: 76%; margin-left: 4%;">
                                                                    <div class="form-group"
                                                                        id="open_btn">
                                                                        <label style="padding-top: 2%; padding-left: 36%;">
                                                                            Click Here to Upload Files</label>
                                                                        <asp:ImageButton ID="btnHiddenSubmit" runat="server" Text="Button" Style="display: none" OnClick="imgBtnSelect_Click" />
                                                                    </div>
                                                                </div>
                                                                <div class="clearfix"></div>
                                                                <asp:DataList ID="rptrSearch" runat="server" RepeatColumns="9" RepeatDirection="Horizontal"
                                                                    OnItemCommand="rptrSearch_ItemCommand" OnItemDataBound="rptrSearch_ItemDataBound">
                                                                    <ItemTemplate>
                                                                        <div class="navlist">
                                                                            <ul>
                                                                                <li>
                                                                                    <asp:ImageButton ID="imgPhoto" runat="server" Height="70" Width="70" CommandArgument='<%# Eval("FilePath") %>' ImageUrl='<%#Eval("FilePath")%>' OnClick="DownloadFile" />
                                                                                </li>
                                                                                <li>
                                                                                    <label><%#Eval("ObjectName")%></label>
                                                                                    <asp:HiddenField ID="hfObjectId" runat="server" Value='<%#Eval("ObjectId")%>' />
                                                                                    <asp:HiddenField ID="hfPath" runat="server" Value='<%#Eval("FilePath")%>' />
                                                                                </li>
                                                                                <li>
                                                                                    <asp:LinkButton ID="lnkBtnEdit" runat="server" CommandArgument='<%#Eval("ObjectId")%>' CommandName="Edit">Edit</asp:LinkButton>
                                                                                    <asp:LinkButton ID="lnkBtnDelete" runat="server" CommandName="Delete" CommandArgument='<%#Eval("ObjectId")%>' OnClientClick="javascript:return confirm('Do you want to delete this Objects?');">Delete</asp:LinkButton>
                                                                                </li>
                                                                                <li>
                                                                                    <asp:ImageButton ID="imgBtnFav" runat="server" ImageUrl="~/Images/FavIcon.png" Height="20" Width="20" ToolTip="Add To Favorite" />

                                                                                    <asp:ImageButton ID="imgbtnCompressnDownload" runat="server" ImageUrl="~/Images/CompAndDowld.png" Height="20" Width="20" ToolTip="Compress and download" CommandName="CandD" CommandArgument='<%#Eval("FilePath")%>' />
                                                                                </li>
                                                                                <li>
                                                                                    <asp:CheckBox ID="chkSelect" runat="server" Text="Select" />
                                                                                </li>
                                                                            </ul>
                                                                        </div>
                                                                    </ItemTemplate>
                                                                    <HeaderTemplate>
                                                                        <ul>
                                                                            <li style="list-style: none; margin-top: 3%; margin-left: -1%;">
                                                                                <asp:CheckBox ID="chkSelectAll" runat="server" Text="Select All" onchange="CheckOrUncheck();" />
                                                                                <asp:Button runat="server" ID="btnDeleteSelected" class="btn btn-sm btn-danger" Text="Delete" CommandName="DeleteAll" OnClientClick="javascript:return confirm('Do you want to delete this Selected objects?');"></asp:Button>
                                                                                <asp:Button runat="server" ID="btnCopySelected" class="btn btn-sm btn-info" Text="Copy Objects" CommandName="Copy"></asp:Button>
                                                                                <asp:Button runat="server" ID="btnMailSelected" class="btn btn-sm btn-info" Text="Compose Mail" CommandName="Mail"></asp:Button>
                                                                                <asp:Button runat="server" ID="btnMoveSelected" class="btn btn-sm btn-info" Text="Move Objects" CommandName="Move"></asp:Button>
                                                                            </li>
                                                                        </ul>
                                                                    </HeaderTemplate>
                                                                </asp:DataList>
                                                            </div>
                                                        </div>
                                                    </div>




                                                </div>
                                            </div>
                                        </div>
                                    </div>


                                    <asp:Button runat="server" ID="btnPopupMailing" Style="display: none;" />
                                    <asp:ModalPopupExtender ID="MPEMailingDocuments" runat="server" TargetControlID="btnPopupMailing"
                                        PopupControlID="PanelMailingDocuments" PopupDragHandleControlID="PopupHeader" Drag="True"
                                        BackgroundCssClass="modalBackground" Enabled="True" CancelControlID="imgClose">
                                    </asp:ModalPopupExtender>
                                    <asp:Panel ID="PanelMailingDocuments" CssClass="modalPopup" align="center" Style="display: none; width: 700px;"
                                        runat="server">
                                        <div class="popupHeader">
                                            <h5>Document Mailing</h5>
                                        </div>
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <div class="panel panel-default">
                                                    <asp:ImageButton ID="imgClose" runat="server" ImageUrl="~/Images/Close.png" formnovalidate="formnovalidate" Height="20" Width="20" Style="height: 25px; width: 25px; margin-left: -25px; float: right; margin-top: -28px;" />
                                                    <div class="panel-body">
                                                        <div class="row" style="margin-top: -4px;">
                                                            <div class="col-lg-12">
                                                                <div class="form-group">
                                                                    <label>From</label>
                                                                    <asp:TextBox runat="server" ID="txtFromAddress" class="form-control" Width="89%"></asp:TextBox>
                                                                </div>
                                                                <div class="form-group">
                                                                    <label>To</label>
                                                                    <asp:TextBox runat="server" ID="txtToAddress" class="form-control" Width="89%"></asp:TextBox>
                                                                    <asp:RequiredFieldValidator ID="rfvTo" runat="server" ErrorMessage="Enter to address" ToolTip="Enter to address"
                                                                        Text="*" ForeColor="#ff0000" Display="Dynamic" SetFocusOnError="true" ControlToValidate="txtToAddress" ValidationGroup="SendMail"></asp:RequiredFieldValidator>
                                                                </div>
                                                                <div class="form-group">
                                                                    <label>CC</label>
                                                                    <asp:TextBox runat="server" ID="txtccAddress" class="form-control" Width="89%"></asp:TextBox>
                                                                </div>
                                                                <div class="form-group">
                                                                    <label>Mail Subject</label>
                                                                    <asp:TextBox runat="server" ID="txtMailSubject" class="form-control" Width="89%"></asp:TextBox>
                                                                </div>
                                                                <div class="form-group" style="text-align: left;">
                                                                    <label>Mail Body</label>
                                                                </div>
                                                                <div class="form-group" style="text-align: left;">
                                                                    <asp:TextBox runat="server" ID="txtMailBody" class="form-control" Width="100%"
                                                                        TextMode="MultiLine" Height="200px" Style="text-align: left;"></asp:TextBox>
                                                                    <asp:HtmlEditorExtender ID="HtmlEditorExtender1"
                                                                        TargetControlID="txtMailBody" EnableSanitization="false" DisplaySourceTab="true"
                                                                        runat="server">
                                                                    </asp:HtmlEditorExtender>
                                                                </div>
                                                                <div class="form-group" style="text-align: left;">
                                                                    <asp:Button runat="server" ID="btnSendDocuments" Text="Send" CssClass="btn btn-sm btn-success"
                                                                        OnClick="btnSendDocuments_Click" ValidationGroup="SendMail" />
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <!-- /.panel -->
                                            </div>
                                        </div>
                                    </asp:Panel>





                                </asp:View>

                                <asp:View ID="vwDetailed" runat="server">
                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="panel-body">
                                                <div class="row">
                                                    <div class="col-lg-12" style="border: dotted; border-color: #06B7F9; height: 52px; width: 76%; margin-left: 4%;">
                                                        <div class="form-group"
                                                            id="open_btn">
                                                            <label style="padding-top: 2%; padding-left: 36%;">
                                                                Click Here to Upload Files</label>
                                                            <asp:ImageButton ID="imgBtnHiddenSubmit" runat="server" Text="Button" Style="display: none" OnClick="imgBtnHiddenSubmit_Click" />
                                                        </div>
                                                    </div>
                                                    <div class="col-lg-12">

                                                        <div class="form-group">

                                                            <div class="table-responsive">
                                                                <asp:GridView ID="grdDetaild" runat="server" AutoGenerateColumns="False" ShowFooter="false"
                                                                    Width="100%"
                                                                    AlternatingRowStyle-CssClass="alt"
                                                                    CssClass="mGrid"
                                                                    AllowPaging="true" PageSize="15"
                                                                    PagerSettings-Position="Top" PagerStyle-HorizontalAlign="Right"
                                                                    AllowSorting="true"
                                                                    OnRowCommand="grdDetaild_RowCommand"
                                                                    OnRowDeleting="grdDetaild_RowDeleting"
                                                                    OnRowEditing="grdDetaild_RowEditing"
                                                                    OnPageIndexChanging="grdDetaild_PageIndexChanging"
                                                                    OnSorting="grdDetaild_Sorting">
                                                                    <Columns>
                                                                        <asp:TemplateField HeaderText="ID" SortExpression="ObjectId">
                                                                            <ItemTemplate>
                                                                                <asp:Label runat="server" ID="lblAttributeId" CssClass="txtwidthgrid" Style="background-color: transparent;" Enabled="false" Text='<%#Eval("ObjectId") %>'></asp:Label>
                                                                                <asp:HiddenField ID="hfPath" runat="server" Value='<%#Eval("FilePath")%>' />
                                                                            </ItemTemplate>
                                                                            <ItemStyle HorizontalAlign="Left" />
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField HeaderText="Object Name" SortExpression="ObjectName">
                                                                            <ItemTemplate>
                                                                                <asp:Label runat="server" Enabled="false" Style="background-color: transparent;" ID="lblObjectName" CssClass="txtwidthgrid" Text='<%#Eval("ObjectName") %>' Width="200px"></asp:Label>
                                                                            </ItemTemplate>
                                                                            <ControlStyle Width="150px" />
                                                                            <ItemStyle HorizontalAlign="Left" />
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField HeaderText="Current Version" SortExpression="CurrentVersion">
                                                                            <ItemTemplate>
                                                                                <asp:Label runat="server" Enabled="false" Style="background-color: transparent;" ID="lblVersion" CssClass="txtwidthgrid" Text='<%#Eval("CurrentVersion") %>' Width="200px"></asp:Label>
                                                                            </ItemTemplate>
                                                                            <ControlStyle Width="30px" />
                                                                            <ItemStyle HorizontalAlign="Left" />
                                                                        </asp:TemplateField>

                                                                        <asp:TemplateField HeaderText="Description" SortExpression="Description">
                                                                            <ItemTemplate>
                                                                                <asp:Label runat="server" Enabled="false" CssClass="txtwidthgrid" Style="background-color: transparent;" ID="lblDescription" Text='<%#Eval("Description")%>'></asp:Label>
                                                                            </ItemTemplate>
                                                                            <ItemStyle HorizontalAlign="Left" />
                                                                            <ControlStyle Width="180px" />
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField HeaderText="Active ?">
                                                                            <ItemTemplate>
                                                                                <asp:CheckBox ID="chkAttributeStatus" Enabled="false" Style="background-color: transparent;" runat="server" Checked='<%#Eval("Status") %>' />
                                                                            </ItemTemplate>
                                                                            <ControlStyle Width="30px" />
                                                                            <ItemStyle HorizontalAlign="Center" />
                                                                        </asp:TemplateField>
                                                                        <asp:TemplateField HeaderText="Actions">
                                                                            <ItemTemplate>
                                                                                <asp:ImageButton ID="imgbtnEdit" CommandArgument='<%#Eval("ObjectId")%>' CommandName="Edit" runat="server" CausesValidation="false"
                                                                                    ImageUrl="~/images/edit.png" ToolTip="Edit" Height="15px" Width="15px" />
                                                                                &nbsp;&nbsp;
                                                                                    <asp:ImageButton ID="imgbtnDelete" CommandName="Delete" CommandArgument='<%#Eval("ObjectId")%>' OnClientClick="javascript:return confirm('Do you want to delete this Attribute?');"
                                                                                        runat="server" CausesValidation="false" ImageUrl="~/Images/DeleteRed.png" ToolTip="Delete" Height="15px" Width="15px" />
                                                                                &nbsp;&nbsp;
                                                                                 <asp:ImageButton ID="imgBtnDownload" CommandArgument='<%# Eval("FilePath") %>' CommandName="Download" runat="server"
                                                                                     CausesValidation="false" ImageUrl="~/Images/Download.png" ToolTip="Delete" Height="15px" Width="15px" OnClick="DownloadFile" />
                                                                            </ItemTemplate>
                                                                            <ItemStyle HorizontalAlign="Center" />
                                                                        </asp:TemplateField>
                                                                    </Columns>
                                                                    <EmptyDataTemplate>
                                                                        <div class="grdEmptyContents" style="color: Red; font-size: 12px; text-align: center; margin-top: 10px; border: none;">No Data's Available</div>
                                                                    </EmptyDataTemplate>
                                                                </asp:GridView>

                                                            </div>
                                                        </div>
                                                    </div>

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- /.panel -->
                                </asp:View>
                            </asp:MultiView>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /#page-wrapper -->
        </div>
        <!-- /#wrapper -->
        <uc1:Footer runat="server" ID="Footer" />
    </form>

    <script>
        // To Get File Name into text box while uploading manually..
        function GetFileName(oFile) {
            try {
                var fileName = oFile.value;
                var RtFileName = extractFilename(fileName);
                var res = RtFileName.split(".");
                document.getElementById("txtObjectName").value = res[0];
            } catch (e) {
                alert(e);
            }
        }
        function extractFilename(path) {
            if (path.substr(0, 12) == "C:\\fakepath\\")
                return path.substr(12); // modern browser
            var x;
            x = path.lastIndexOf('/');
            if (x >= 0) // Unix-based path
                return path.substr(x + 1);
            x = path.lastIndexOf('\\');
            if (x >= 0) // Windows-based path
                return path.substr(x + 1);
            return path; // just the filename
        }
    </script>

    <script src="../js/bootstrap.fd.js"></script>
    <link href="../Css/bootstrap.fd.css" rel="stylesheet" />


    <script>
        $(document).ready(function () {
            $("#open_btn").click(function () {
                var LibraryId = "<%= ViewState["LibraryId"]%>"; // to pass library id into object saving handler
                var UserName = "<%=Session["LoggedUser"]%>";// to pass Created Username into object saving handler
                if (LibraryId != '' || LibraryId != null) {
                    $.FileDialog({ multiple: true }).on('files.bs.filedialog', function (ev) {
                        var files = ev.files;

                        var data = new FormData();
                        for (var i = 0; i < files.length; i++) {
                            data.append(files[i].name, files[i]);
                        }
                        $.ajax({
                            url: "../Handlers/FileUploadHandler.ashx?LibId=" + LibraryId + "&LoggedUser=" + UserName,
                            type: "POST",
                            data: data,
                            contentType: false,
                            processData: false,
                            success: function (result) {
                                // alert($('#grdDetaild tr').length);
                                if ($('#grdDetaild tr').length > 0) {
                                    document.getElementById('imgBtnHiddenSubmit').click(); // To Fill all uploaded items to datalist
                                }
                                else {
                                    document.getElementById('btnHiddenSubmit').click(); // To Fill all uploaded items to datalist
                                }
                                alertify.success('Saved Successfully');
                            },
                            error: function (err) {
                                alert(err.statusText)
                            }
                        });
                    }).on('cancel.bs.filedialog', function (ev) {
                        // alert("Cancelled!");
                        alertify.error('Cancelled..');
                    });
                }
                else {
                    //alert("Select library..!");
                    alertify.error('Select library..');
                }
            });
        });

        function CheckOrUncheck() {

            if ($("[id*=rptrSearch_chkSelectAll]").is(':checked')) {
                $("#<%= rptrSearch.ClientID %> input:checkbox").prop('checked', true);
            }
            else {
                $("#<%= rptrSearch.ClientID %> input:checkbox").prop('checked', false);
            }

        }

    </script>
    <script type="text/javascript">

    </script>
    <style type="text/css">
        .navlist ul {
            display: inline;
            padding-right: 4px;
        }

            .navlist ul li {
                list-style-type: none;
            }

        .table-responsive tbody tr td {
            padding-left: 8px;
        }

        #rptrSearch td {
            width: 12%;
        }
    </style>
    <style type="text/css">
        .modalBackground {
            background-color: Black;
            filter: alpha(opacity=90);
            opacity: 0.8;
        }

        .modalPopup {
            background-color: #FFFFFF;
            border-width: 1px;
            border-style: solid;
            border-color: #4AA5EA;
            padding-top: 22px;
            padding-left: 0px;
            width: auto;
            height: auto;
            border-radius: 5px;
        }

        .modalPopupSelect {
            background-color: #FFFFFF;
            border-width: 3px;
            border-style: solid;
            border-color: #4AA5EA;
            padding-top: 22px;
            padding-left: 0px;
            width: auto;
            height: 350px;
            overflow-y: auto;
            overflow-x: hidden;
        }

        .popupHeader {
            width: 100%;
            background-color: #06B7F9;
            /*border-bottom-left-radius: 8px;
            border-bottom-right-radius: 8px;*/
            margin-top: -31px;
            height: 28px;
        }

            .popupHeader h5 {
                color: #fff;
                padding-top: 6px;
            }
    </style>
</body>
</html>
