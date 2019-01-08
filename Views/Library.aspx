<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Library.aspx.cs" Inherits="LDS.Views.Library" EnableEventValidation="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="asp" %>



<%@ Register Src="~/UserControls/Footer.ascx" TagPrefix="uc1" TagName="Footer" %>
<%@ Register Src="~/UserControls/Header.ascx" TagPrefix="uc1" TagName="Header" %>
<%@ Register Src="~/UserControls/LMenu.ascx" TagPrefix="uc1" TagName="LMenu" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>LDS:: Library Management</title>
</head>
<body>
    <form id="form1" runat="server">

        <div id="wrapper">
            <!-- Navigation -->
            <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
                <uc1:Header runat="server" ID="Header" />
                <!-- /.navbar-top-links -->
                <uc1:LMenu runat="server" ID="LMenu" />
                <!-- /.navbar-static-side -->
            </nav>
            <div id="page-wrapper">
                <div class="row">
                    <div class="col-lg-12">
                        <h3 class="page-header">Library Management</h3>
                    </div>
                    <!-- /.col-lg-12 -->
                </div>
                <!-- /.row -->


                <asp:MultiView ID="mvAdmin" runat="server">
                    <asp:View ID="VWAdd" runat="server">
                        <div class="row">
                            <div class="col-lg-12">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <asp:Button ID="btnSearch" runat="server" Text="Search" class="btn btn-primary" formnovalidate="formnovalidate" OnClick="btnSearch_Click" />
                                    </div>
                                    <div class="panel-body">
                                        <div class="row">
                                            <div class="col-lg-12">
                                                <asp:TabContainer ID="tbLibrary" runat="server" CssClass="MyTabStyle">
                                                    <asp:TabPanel ID="tbGeneral" runat="server" HeaderText="General">
                                                        <ContentTemplate>
                                                            <div class="panel-body">
                                                                <div class="row">
                                                                    <div class="col-lg-12">
                                                                        <div class="col-lg-6">
                                                                            <div class="form-group">
                                                                                <label>Library Name</label>
                                                                                <asp:TextBox ID="txtLibraryName" class="form-control" runat="server" placeholder="Library Name" required="required"></asp:TextBox>
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <label>Description</label>
                                                                                <asp:TextBox ID="txtDescription" class="form-control" runat="server" placeholder="Description" TextMode="MultiLine" Style="height: 37px;"></asp:TextBox>
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <label>Icon</label>
                                                                                <asp:FileUpload ID="fupIconImg" runat="server" CssClass="fileUpload" Width="52%" />
                                                                                <asp:RegularExpressionValidator ID="imgValidator" runat="server" ControlToValidate="fupIconImg" Text="*" ForeColor="Red"
                                                                                    ErrorMessage="*JPG/JPEG/GIF/PNG files only" ValidationExpression="^.+\.(([jJ][pP][eE]?[gG])|([gG][iI][fF])|([pP][nN][gG]))$" ValidationGroup="Submit"
                                                                                    ToolTip="Support only JPG/JPEG/GIF/PNG files" />
                                                                            </div>
                                                                            <div class="form-group" style="margin-left: 50%;">
                                                                                <asp:Button runat="server" ID="btnSave" class="btn btn-outline btn-success" Text="Submit"
                                                                                    OnClick="btnSave_Click" ValidationGroup="Save"></asp:Button>
                                                                                <asp:Button runat="server" ID="btnReset" class="btn btn-outline btn-warning" Text="Reset"
                                                                                    OnClick="btnReset_Click" formnovalidate="formnovalidate" CausesValidation="false"></asp:Button>
                                                                            </div>
                                                                        </div>
                                                                        <div class="col-lg-6">
                                                                            <div class="form-group">
                                                                                <label>Parent</label>
                                                                                <asp:DropDownList ID="ddlParrent" runat="server" class="form-control">
                                                                                </asp:DropDownList>
                                                                                <%--<asp:RequiredFieldValidator ID="rfvParnt" runat="server" ErrorMessage="Select parrent" ControlToValidate="ddlParrent"
                                                                                            ToolTip="Select Parrent" SetFocusOnError="true" ForeColor="#ff0000" Display="Dynamic" ValidationGroup="Save" InitialValue="0"
                                                                                            Text="*">
                                                                                        </asp:RequiredFieldValidator>--%>
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <div class="checkbox" style="margin-left: 50%;">
                                                                                    <label>
                                                                                        <asp:CheckBox ID="chkStatus" runat="server" class="" Text="Active ?" />
                                                                                    </label>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                        <div class="col-lg-6">
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </ContentTemplate>
                                                    </asp:TabPanel>
                                                    <asp:TabPanel ID="tbAttributeList" runat="server" HeaderText="Attribute List">
                                                        <ContentTemplate>
                                                            <div class="panel-body">
                                                                <div class="form-group">
                                                                    <div class="row">
                                                                        <div class="col-lg-6">
                                                                            <div class="form-group">
                                                                                <label>Default Attributes</label>
                                                                                <asp:Label ID="Label2" class="myLabel" runat="server" Text="Type"></asp:Label>
                                                                            </div>
                                                                            <hr />
                                                                            <div class="form-group">
                                                                                <label>Title</label>
                                                                                <asp:Label ID="TextBox4" class="myLabel" runat="server" Text="Single line of text"></asp:Label>
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <label>Created By</label>
                                                                                <asp:Label ID="TextBox5" class="myLabel" runat="server" Text="Person or group"></asp:Label>
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <label>Created Date</label>
                                                                                <asp:Label ID="TextBox2" class="myLabel" runat="server" Text="Date and Time"></asp:Label>
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <label>Modified By</label>
                                                                                <asp:Label ID="Label1" class="myLabel" runat="server" Text="Person or group"></asp:Label>
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <label>Modified Date</label>
                                                                                <asp:Label ID="TextBox3" class="myLabel" runat="server" Text="Date and Time"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <asp:LinkButton runat="server" ID="lnkBtnAddAttribute" Text="Add Attribute" Style="margin-left: 17px;"></asp:LinkButton>
                                                                    <asp:LinkButton runat="server" ID="lnkSelectSysAttr" Text="Add from System Attributes" Style="margin-left: 17px;"></asp:LinkButton>
                                                                    <%--------------------------------------Grid for available attributes Attribute Start here---------------------------------%>
                                                                    <div class="table-responsive" style="width: 100%;">
                                                                        <asp:GridView ID="grdLibAttributes" runat="server" AutoGenerateColumns="False"
                                                                            Width="100%"
                                                                            Style="font-family: Verdana; font-size: 12px"
                                                                            OnRowEditing="grdLibAttributes_RowEditing" OnRowDeleting="grdLibAttributes_RowDeleting"
                                                                            OnPageIndexChanging="grdLibAttributes_PageIndexChanging" AllowPaging="true"
                                                                            PageSize="10" OnSorting="grdLibAttributes_Sorting" AllowSorting="true"
                                                                            CssClass="mGrid"
                                                                            PagerStyle-CssClass="pgr"
                                                                            AlternatingRowStyle-CssClass="alt" EmptyDataText="No Data Found..">
                                                                            <Columns>
                                                                                <asp:TemplateField HeaderText="ID" SortExpression="AttributeId">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label ID="lblAttributeId" runat="server" Text='<%# Bind("AttributeId") %>'>></asp:Label>
                                                                                    </ItemTemplate>
                                                                                    <ControlStyle Width="20%" />
                                                                                </asp:TemplateField>
                                                                                <asp:TemplateField HeaderText="Attribute Name" SortExpression="AttributeName">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label ID="lblAttributeName" runat="server" Text='<%# Bind("AttributeName") %>'></asp:Label>
                                                                                    </ItemTemplate>

                                                                                    <ControlStyle Width="100%" />
                                                                                </asp:TemplateField>
                                                                                <asp:TemplateField HeaderText="Attribute Type" SortExpression="AttributeType">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label ID="txtAttributeType" runat="server" Text='<%# Bind("AttributeType") %>'></asp:Label>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateField>
                                                                                <asp:TemplateField HeaderText="Style" SortExpression="Style">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label ID="txtStyle" runat="server" Text='<%# Bind("Style") %>'></asp:Label>
                                                                                    </ItemTemplate>
                                                                                    <ControlStyle Width="100%" />
                                                                                </asp:TemplateField>
                                                                                <asp:TemplateField HeaderText="Active ?">

                                                                                    <ItemTemplate>
                                                                                        <asp:CheckBox ID="chkActive" runat="server" Enabled="false" Checked='<%# Bind("AttributeStatus") %>' />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateField>
                                                                                <asp:TemplateField HeaderText="Value Mandatory ?">

                                                                                    <ItemTemplate>
                                                                                        <asp:CheckBox ID="chkIsValueMandatory" runat="server" Enabled="false" Checked='<%# Bind("IsValueMandatory") %>' />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateField>
                                                                                <asp:TemplateField HeaderText="Inh Mandatory ?">

                                                                                    <ItemTemplate>
                                                                                        <asp:CheckBox ID="chkIsInhMandatory" runat="server" Enabled="false" Checked='<%# Bind("IsInhMandatory") %>' />
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateField>
                                                                                <asp:TemplateField HeaderText="Actions">
                                                                                    <ItemTemplate>
                                                                                        <asp:ImageButton ID="IbtnEdit" runat="server" CommandName="Edit" ImageUrl="~/images/edit.ico" ImageAlign="Middle" Height="15px" Width="15px" Style="margin-top: -13px;" />
                                                                                        &nbsp;&nbsp;&nbsp;&nbsp;
                                        <asp:ImageButton ID="imgbtnDelete" CommandArgument='<%# ((GridViewRow) Container).RowIndex %>' CommandName="Delete" OnClientClick="javascript:return confirm('Do you want to delete this Attribute?');" runat="server" CausesValidation="false" ImageUrl="~/Images/DeleteRed.png" ToolTip="Delete" Height="15px" Width="15px" />

                                                                                    </ItemTemplate>
                                                                                    <ItemStyle HorizontalAlign="Center" />
                                                                                </asp:TemplateField>
                                                                            </Columns>
                                                                        </asp:GridView>
                                                                    </div>
                                                                    <%-------------------------------------Grid for available attributes Attribute End here------------------------------------%>
                                                                </div>
                                                                <%-----------------------------------------Model Popup for Add New Attribute Start here----------------------------------------%>
                                                                <div class="row">
                                                                    <div>
                                                                        <!-- ModalPopupExtender -->
                                                                        <asp:ModalPopupExtender ID="mpAttribute" runat="server" PopupControlID="pnlAttribute" TargetControlID="lnkBtnAddAttribute"
                                                                            CancelControlID="imgClose" BackgroundCssClass="modalBackground">
                                                                        </asp:ModalPopupExtender>
                                                                        <asp:Panel ID="pnlAttribute" runat="server" CssClass="modalPopup" align="center" Style="display: none">

                                                                            <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                                                                                <ContentTemplate>
                                                                                    <div class="popupHeader">
                                                                                        <h5>Ctreate New Attribute</h5>
                                                                                    </div>
                                                                                    <div class="row">
                                                                                        <div class="col-lg-12">
                                                                                            <div class="panel panel-default">
                                                                                                <asp:ImageButton ID="imgClose" runat="server" ImageUrl="~/Images/Close.png" OnClick="imgClose_Click" formnovalidate="formnovalidate" Height="20" Width="20" Style="height: 25px; width: 25px; margin-left: -25px; float: right; margin-top: -28px;" />
                                                                                                <div class="panel-body">
                                                                                                    <div class="row">
                                                                                                        <div class="col-lg-6">
                                                                                                            <div class="form-group">
                                                                                                                <label>Attribute Name</label>
                                                                                                                <asp:TextBox ID="txtAttributeName" class="form-control" runat="server" placeholder="Attribute Name"></asp:TextBox>
                                                                                                                <asp:RequiredFieldValidator ID="rfvname" runat="server" ErrorMessage="Name required" ControlToValidate="txtAttributeName"
                                                                                                                    ForeColor="#ff0000" Text="*" Display="Dynamic" SetFocusOnError="true" ValidationGroup="attSave" ToolTip="Name required"></asp:RequiredFieldValidator>

                                                                                                            </div>
                                                                                                            <div class="form-group">
                                                                                                                <label for="disabledSelect">Attribute Type</label>
                                                                                                                <asp:DropDownList ID="ddlAttributeType" runat="server" class="form-control">
                                                                                                                    <asp:ListItem Value="String">String</asp:ListItem>
                                                                                                                    <asp:ListItem Value="Integer">Integer</asp:ListItem>
                                                                                                                    <asp:ListItem Value="Number">Number</asp:ListItem>
                                                                                                                    <asp:ListItem Value="Date">Date</asp:ListItem>
                                                                                                                </asp:DropDownList>
                                                                                                            </div>
                                                                                                            <div class="form-group">
                                                                                                                <label style="float: left; margin-left: 12%;">
                                                                                                                    Style</label>
                                                                                                                <asp:DropDownList ID="ddlStyle" runat="server" class="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlStyle_SelectedIndexChanged">
                                                                                                                </asp:DropDownList>
                                                                                                            </div>
                                                                                                            <div class="form-group" runat="server" id="listVal">
                                                                                                                <label>List Values</label>
                                                                                                                <asp:TextBox ID="txtListValues" class="form-control" runat="server" placeholder="List Values"
                                                                                                                    Style="height: 73px; margin-top: 8px;" TextMode="MultiLine"></asp:TextBox>
                                                                                                            </div>
                                                                                                        </div>
                                                                                                        <!-- /.col-lg-6 (nested) -->
                                                                                                        <div class="col-lg-6">

                                                                                                            <div class="form-group">
                                                                                                                <label for="disabledSelect" style="margin-left: 14%;">Description</label>
                                                                                                                <asp:TextBox ID="txtAttrDescription" class="form-control" runat="server" placeholder="Description"
                                                                                                                    TextMode="MultiLine" Style="height: 43px;" Width="52%"></asp:TextBox>
                                                                                                            </div>
                                                                                                            <div class="form-group" style="margin-top: 10%">
                                                                                                                <div class="checkbox" style="margin-left: -43px;">
                                                                                                                    <label>
                                                                                                                        <asp:CheckBox ID="chkDefault" runat="server" class="checkbox" Text="Is Default Values" AutoPostBack="true" OnCheckedChanged="chkDefault_CheckedChanged" />
                                                                                                                    </label>
                                                                                                                </div>
                                                                                                            </div>
                                                                                                            <div class="form-group" runat="server" id="DivdefaultVal">
                                                                                                                <label style="margin-left: 19%;">Default Value</label>
                                                                                                                <asp:TextBox ID="txtDefaultValue" class="form-control" runat="server" placeholder="Default Value"></asp:TextBox>
                                                                                                            </div>


                                                                                                            <div class="form-group">
                                                                                                                <div class="checkbox">
                                                                                                                    <label>
                                                                                                                        <asp:CheckBox ID="chkInhMand" runat="server" class="checkbox" Text="Inheritance Mandatory ?" />
                                                                                                                    </label>
                                                                                                                </div>
                                                                                                            </div>
                                                                                                            <div class="form-group">
                                                                                                                <div class="checkbox" style="margin-left: -29px;">
                                                                                                                    <label>
                                                                                                                        <asp:CheckBox ID="chkValMan" runat="server" class="checkbox" Text="Value Mandatory ?" />
                                                                                                                    </label>
                                                                                                                </div>
                                                                                                            </div>
                                                                                                            <div class="form-group">
                                                                                                                <div class="checkbox" style="margin-left: -86px;">
                                                                                                                    <label>
                                                                                                                        <asp:CheckBox ID="chkAttributeStatus" runat="server" class="checkbox" Text="Active ?" />
                                                                                                                    </label>
                                                                                                                </div>
                                                                                                            </div>

                                                                                                        </div>
                                                                                                        <!-- /.col-lg-6 (nested) -->
                                                                                                        <div class="col-lg-6">
                                                                                                            <div class="form-group" style="margin-right: 7%; float: right; margin-top: -8%;">
                                                                                                                <asp:Button runat="server" ID="btnAttrSave" class="btn btn-outline btn-success" Text="Submit"
                                                                                                                    OnClick="btnAttrSave_Click" formnovalidate="formnovalidate" ValidationGroup="attSave"></asp:Button>
                                                                                                                <asp:Button runat="server" ID="btnAttrReset" class="btn btn-outline btn-warning" Text="Reset"
                                                                                                                    formnovalidate="formnovalidate" OnClick="btnAttrReset_Click"></asp:Button>
                                                                                                            </div>
                                                                                                        </div>
                                                                                                    </div>
                                                                                                </div>
                                                                                            </div>
                                                                                            <!-- /.panel -->
                                                                                        </div>
                                                                                        <!-- /.col-lg-12 -->
                                                                                    </div>
                                                                                </ContentTemplate>
                                                                            </asp:UpdatePanel>
                                                                        </asp:Panel>
                                                                    </div>
                                                                </div>
                                                                <%-----------------------------------------Model Popup for Add New Attribute End here------------------------------------------%>
                                                                <%-----------------------------------------Model Popup for Select system Attribute Start here----------------------------------%>
                                                                <div class="row">
                                                                    <div>
                                                                        <!-- ModalPopupExtender -->
                                                                        <asp:ModalPopupExtender ID="mdpSelectAttr" runat="server" PopupControlID="pnlSelectAttr" TargetControlID="lnkSelectSysAttr"
                                                                            CancelControlID="imgSlctClose" BackgroundCssClass="modalBackground">
                                                                        </asp:ModalPopupExtender>
                                                                        <asp:Panel ID="pnlSelectAttr" runat="server" CssClass="modalPopup" align="center" Style="display: none">
                                                                            <%--<asp:UpdatePanel ID="udpSelectSysAttr" runat="server">
                                                                                <ContentTemplate>--%>
                                                                            <div class="popupHeader">
                                                                                <h5>Select System Attribute</h5>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="col-lg-12">
                                                                                    <asp:ImageButton ID="imgSlctClose" runat="server" ImageUrl="~/Images/Close.png" formnovalidate="formnovalidate" Height="20" Width="20" Style="height: 25px; width: 25px; margin-left: -25px; float: right; margin-top: -28px;" />

                                                                                    <div class="panel panel-default" style="overflow-y: scroll; height: 320px;">
                                                                                        <div class="panel-body">
                                                                                            <div class="row">
                                                                                                <div class="col-lg-9">
                                                                                                    <div class="form-group">
                                                                                                        <div class="checkbox">
                                                                                                            <asp:CheckBoxList ID="cblSystemAttributes"
                                                                                                                runat="server" CssClass="checkbox"
                                                                                                                Style="width: 250px; height: 150px; float: left; margin-left: 10px;">
                                                                                                            </asp:CheckBoxList>
                                                                                                        </div>

                                                                                                    </div>
                                                                                                </div>

                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                    <div class="col-lg-12">
                                                                                        <div style="float: left; margin-top: -16px;">
                                                                                            <asp:Button ID="btnSelectAttrSubmit" runat="server" Text="Submit" class="btn btn-success" OnClick="btnSelectAttrSubmit_Click" />
                                                                                            <asp:Button ID="btnSelectAttrReset" runat="server" Text="Reset" class="btn btn-warning" OnClick="btnSelectAttrReset_Click" formnovalidate="formnovalidate" />
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <%--</ContentTemplate>
                                                                            </asp:UpdatePanel>--%>
                                                                        </asp:Panel>
                                                                    </div>

                                                                </div>
                                                                <%------------------------------Model Popup for Select system Attribute End here-------------------------%>
                                                            </div>
                                                        </ContentTemplate>

                                                    </asp:TabPanel>

                                                    <asp:TabPanel ID="tbAttributeGroup" runat="server" HeaderText="Attribute Group">

                                                        <ContentTemplate>

                                                            <div class="panel-body">
                                                                <div class="form-group">

                                                                    <div class="row">
                                                                        <div class="col-lg-6">
                                                                            <div class="form-group">
                                                                                <label>Default Attribute Groups</label>
                                                                                <asp:Label ID="Label3" class="myLabel" runat="server" Text="Type"></asp:Label>
                                                                            </div>
                                                                            <hr />
                                                                            <div class="form-group">
                                                                                <label>Title</label>
                                                                                <asp:Label ID="Label6" class="myLabel" runat="server" Text="Single line of text"></asp:Label>
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <label>Created By</label>
                                                                                <asp:Label ID="Label7" class="myLabel" runat="server" Text="Person or group"></asp:Label>
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <label>Created Date</label>
                                                                                <asp:Label ID="Label4" class="myLabel" runat="server" Text="Date and Time"></asp:Label>
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <label>Modified By</label>
                                                                                <asp:Label ID="Label8" class="myLabel" runat="server" Text="Person or group"></asp:Label>
                                                                            </div>
                                                                            <div class="form-group">
                                                                                <label>Modified Date</label>
                                                                                <asp:Label ID="Label5" class="myLabel" runat="server" Text="Date and Time"></asp:Label>
                                                                            </div>
                                                                        </div>
                                                                    </div>

                                                                    <asp:LinkButton runat="server" ID="lnkbtnAttrGroupAdd" Text="Add Attribute Group" Style="margin-left: 17px;"></asp:LinkButton>
                                                                    <asp:LinkButton runat="server" ID="lnkBtnAttrgrpSelect" Text="Add from System Attributes Groups" Style="margin-left: 17px;"></asp:LinkButton>
                                                                    <%--------------------------------------Grid for available  Attribute Group Start here---------------------------------%>
                                                                    <div class="table-responsive" style="width: 100%;">
                                                                        <asp:GridView ID="grdLibAttributesGroups" runat="server" AutoGenerateColumns="False"
                                                                            Width="100%"
                                                                            Style="font-family: Verdana; font-size: 12px"
                                                                            OnRowEditing="grdLibAttributesGroups_RowEditing" OnRowDeleting="grdLibAttributesGroups_RowDeleting"
                                                                            OnPageIndexChanging="grdLibAttributesGroups_PageIndexChanging" AllowPaging="true"
                                                                            PageSize="10" OnSorting="grdLibAttributesGroups_Sorting" AllowSorting="true"
                                                                            CssClass="mGrid"
                                                                            PagerStyle-CssClass="pgr"
                                                                            AlternatingRowStyle-CssClass="alt">
                                                                            <Columns>
                                                                                <asp:TemplateField HeaderText="ID" SortExpression="GroupId">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label runat="server" ID="lblGroupId" CssClass="txtwidthgrid" Style="background-color: transparent;" Enabled="false" Text='<%#Eval("GroupId") %>'></asp:Label>
                                                                                    </ItemTemplate>
                                                                                    <ItemStyle HorizontalAlign="Center" />
                                                                                </asp:TemplateField>
                                                                                <asp:TemplateField HeaderText="Name" SortExpression="GroupName">
                                                                                    <ItemTemplate>
                                                                                        <asp:Label runat="server" Enabled="false" Style="background-color: transparent;" ID="lblGroupName" CssClass="txtwidthgrid" Text='<%#Eval("GroupName") %>'></asp:Label>
                                                                                    </ItemTemplate>
                                                                                </asp:TemplateField>
                                                                                <asp:TemplateField HeaderText="Active ?">
                                                                                    <ItemTemplate>
                                                                                        <asp:CheckBox ID="chkStatus" Enabled="false" Style="background-color: transparent;" runat="Server" Checked='<%# Eval("AttributeStatus") %>' />
                                                                                    </ItemTemplate>
                                                                                    <ControlStyle Width="30px" />

                                                                                </asp:TemplateField>

                                                                                <asp:TemplateField HeaderText="Action">
                                                                                    <ItemTemplate>
                                                                                        <asp:ImageButton ID="IbtnEdit" runat="server" CommandName="Edit" ImageUrl="~/images/edit.ico" ImageAlign="Middle" Height="15px" Width="15px"
                                                                                            Style="margin-top: -15px;" />
                                                                                        &nbsp;&nbsp;&nbsp;&nbsp;
                                        <asp:ImageButton ID="imgbtnDelete" CommandArgument='<%# ((GridViewRow) Container).RowIndex %>' CommandName="Delete" OnClientClick="javascript:return confirm('Do you want to delete this Attribute?');" runat="server" CausesValidation="false" ImageUrl="~/Images/DeleteRed.png" ToolTip="Delete" Height="15px" Width="15px" />


                                                                                    </ItemTemplate>
                                                                                    <ItemStyle HorizontalAlign="Center" />
                                                                                </asp:TemplateField>
                                                                            </Columns>
                                                                            <EmptyDataTemplate>
                                                                                <div class="grdEmptyHead" style="color: Red; font-size: 12px;">
                                                                                    No Data Available
                                                                                </div>
                                                                            </EmptyDataTemplate>
                                                                        </asp:GridView>
                                                                    </div>
                                                                </div>
                                                                <%-------------------------------------Grid for available Attribute  Group  End here------------------------------------%>
                                                                <%-----------------------------------------Model Popup for Add New Attribute Group Start here----------------------------------------%>
                                                                <div class="row">
                                                                    <div>
                                                                        <asp:ModalPopupExtender ID="mdpAttrGroup" runat="server" PopupControlID="pnlAttrGroup" TargetControlID="lnkbtnAttrGroupAdd"
                                                                            CancelControlID="imgBtnAttrGrpClose" BackgroundCssClass="modalBackground">
                                                                        </asp:ModalPopupExtender>
                                                                        <asp:Panel ID="pnlAttrGroup" runat="server" CssClass="modalPopup" align="center" Style="display: none">

                                                                            <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                                                                                <ContentTemplate>
                                                                                    <div class="popupHeader">
                                                                                        <h5>Create New Attribute Group</h5>
                                                                                    </div>
                                                                                    <div class="row">
                                                                                        <div class="col-lg-12">
                                                                                            <div class="panel panel-default">
                                                                                                <asp:ImageButton ID="imgBtnAttrGrpClose" runat="server" ImageUrl="~/Images/Close.png" OnClick="imgBtnAttrGrpClose_Click" formnovalidate="formnovalidate" Height="20" Width="20" Style="height: 25px; width: 25px; margin-left: -25px; float: right; margin-top: -28px;" />
                                                                                                <div class="panel-body">
                                                                                                    <div class="row">
                                                                                                        <div class="col-lg-12">
                                                                                                            <div class="form-group">
                                                                                                                <table>
                                                                                                                    <tr>
                                                                                                                        <td></td>
                                                                                                                        <td style="width: 78%;">
                                                                                                                            <label>Group Name</label>
                                                                                                                            <asp:TextBox ID="txtGroupName" class="form-control" runat="server" placeholder="Group Name"></asp:TextBox>
                                                                                                                            <asp:RequiredFieldValidator ID="rfvGroup" runat="server" ErrorMessage="Group Name required" ControlToValidate="txtGroupName"
                                                                                                                                ForeColor="#ff0000" Text="*" Display="Dynamic" SetFocusOnError="true" ValidationGroup="GrpSave" ToolTip="Name required"></asp:RequiredFieldValidator>
                                                                                                                        </td>
                                                                                                                        <td>
                                                                                                                            <asp:CheckBox ID="chkbxStatus" runat="server" class="checkbox" Text="Active ?" Style="margin-left: 40px; width: 81px;" />
                                                                                                                        </td>
                                                                                                                        <td></td>
                                                                                                                    </tr>
                                                                                                                </table>
                                                                                                            </div>

                                                                                                            <div class="form-group">
                                                                                                                <label>Available Attributes</label>
                                                                                                                <label style="padding-left: 163px">Selected Attributes</label>

                                                                                                                <br />
                                                                                                                <asp:ListBox runat="server" ID="lstAllAttribute" Width="37%"
                                                                                                                    DataTextField="RoleName" CssClass="lstbxstyle"
                                                                                                                    Height="180px"></asp:ListBox>
                                                                                                                <asp:ImageButton runat="server" ID="btntoRight" ImageUrl="~/Images/arrow-right.png" Style="margin-bottom: 14%;" formnovalidate="formnovalidate" OnClick="btntoRight_Click" />
                                                                                                                <asp:ImageButton runat="server" ID="btntoleft" ImageUrl="~/Images/arrow-left.png" Style="margin-bottom: 11%; margin-left: 0%;" formnovalidate="formnovalidate" OnClick="btntoleft_Click" />
                                                                                                                <asp:ListBox runat="server" ID="lstGroupAttribute" Width="37%"
                                                                                                                    DataTextField="RoleName" CssClass="lstbxstyle"
                                                                                                                    Height="180px"></asp:ListBox>

                                                                                                            </div>

                                                                                                            <div class="form-group">
                                                                                                                <asp:Button runat="server" ID="btnAttrGrpSave" class="btn btn-outline btn-success" Text="Submit"
                                                                                                                    OnClick="btnAttrGrpSave_Click" formnovalidate="formnovalidate" ValidationGroup="GrpSave" Style="float: left; margin-left: 9%;"></asp:Button>
                                                                                                                <asp:Button runat="server" ID="btnAttrGrpReset" class="btn btn-outline btn-warning" Text="Reset" Style="float: left; margin-left: 2px;"
                                                                                                                    formnovalidate="formnovalidate" OnClick="btnAttrGrpReset_Click"></asp:Button>
                                                                                                            </div>
                                                                                                        </div>
                                                                                                    </div>
                                                                                                </div>
                                                                                            </div>
                                                                                            <!-- /.panel -->
                                                                                        </div>
                                                                                        <!-- /.col-lg-12 -->
                                                                                    </div>
                                                                                </ContentTemplate>
                                                                            </asp:UpdatePanel>
                                                                        </asp:Panel>
                                                                    </div>
                                                                </div>
                                                                <%-----------------------------------------Model Popup for Select system Attribute Groups Start here----------------------------------%>
                                                                <div class="row">
                                                                    <div>
                                                                        <!-- ModalPopupExtender -->
                                                                        <asp:ModalPopupExtender ID="mdpGroupSelect" runat="server" PopupControlID="pnlGroupSelect" TargetControlID="lnkBtnAttrgrpSelect"
                                                                            CancelControlID="imgBtnGroupClose" BackgroundCssClass="modalBackground">
                                                                        </asp:ModalPopupExtender>
                                                                        <asp:Panel ID="pnlGroupSelect" runat="server" CssClass="modalPopup" align="center" Style="display: none">

                                                                            <%--<asp:UpdatePanel ID="UpdatePanel4" runat="server">
                                                                                <ContentTemplate>--%>
                                                                            <div class="popupHeader">
                                                                                <h5>System Attributes Groups</h5>
                                                                            </div>
                                                                            <div class="row">
                                                                                <div class="col-lg-12">
                                                                                    <asp:ImageButton ID="imgBtnGroupClose" runat="server" ImageUrl="~/Images/Close.png" formnovalidate="formnovalidate" Height="20" Width="20" Style="height: 25px; width: 25px; margin-left: -25px; float: right; margin-top: -28px;" />

                                                                                    <div class="panel panel-default" style="overflow-y: scroll; height: 320px;">
                                                                                        <div class="panel-body">
                                                                                            <div class="row">
                                                                                                <div class="col-lg-9">
                                                                                                    <div class="form-group">
                                                                                                        <div class="checkbox">
                                                                                                            <asp:CheckBoxList CssClass="checkbox" ID="cblGroup" runat="server"
                                                                                                                Style="width: 250px; height: 150px; float: left; margin-left: 10px;">
                                                                                                            </asp:CheckBoxList>
                                                                                                        </div>

                                                                                                    </div>
                                                                                                </div>

                                                                                            </div>
                                                                                        </div>
                                                                                    </div>
                                                                                    <div class="col-lg-12">
                                                                                        <div style="float: left; margin-top: -16px;">
                                                                                            <asp:Button ID="btnGroupSubmit" runat="server" Text="Submit" class="btn btn-success" OnClick="btnGroupSubmit_Click" />
                                                                                            <asp:Button ID="btnGroupReset" runat="server" Text="Reset" class="btn btn-warning" OnClick="btnGroupReset_Click" formnovalidate="formnovalidate" />
                                                                                        </div>
                                                                                    </div>
                                                                                </div>
                                                                            </div>
                                                                            <%--</ContentTemplate>
                                                                            </asp:UpdatePanel>--%>
                                                                        </asp:Panel>
                                                                    </div>

                                                                </div>
                                                                <%------------------------------Model Popup for Select system Attribute End here-------------------------%>
                                                            </div>
                                                            <%-----------------------------------------Model Popup for Add New Attribute group End here------------------------------------------%>
                                                        </ContentTemplate>
                                                    </asp:TabPanel>
                                                </asp:TabContainer>
                                            </div>
                                            <%--</ContentTemplate>
                                            </asp:UpdatePanel>--%>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </asp:View>

                    <asp:View ID="VWSearch" runat="server">






                        <div class="row">
                            <div class="col-lg-12">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <asp:Button ID="btnCreate" runat="server" Text="Create" class="btn btn-primary" OnClick="btnCreate_Click" />
                                    </div>
                                    <div class="panel-body">
                                        <div class="row">

                                            <%--<asp:UpdatePanel ID="UpdatePanel5" runat="server">
                                                <ContentTemplate>--%>
                                            <div class="col-lg-6">
                                                <div class="form-group">
                                                    <table>
                                                        <tr>
                                                            <td style="width: 83%;">
                                                                <asp:TextBox ID="txtSearch" class="" runat="server" CssClass="txtBoxSearch" placeholder="Search"></asp:TextBox></td>
                                                            <td>
                                                                <asp:ImageButton ID="imgbtnSearch" runat="server" ImageUrl="~/Images/Search.png" Width="30px"
                                                                    OnClick="btnSearchItems_Click" Style="margin-top: 8px;" /></td>
                                                            <td>
                                                                <asp:ImageButton ID="imgReset" runat="server" ImageUrl="~/Images/reset.png" Width="30px" OnClick="imgReset_Click"
                                                                    Style="margin-top: 8px;" />
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </div>
                                            </div>
                                            <div class="col-lg-6">
                                                <div class="form-group">
                                                    <br />
                                                    <label for="disabledSelect" style="margin-left: 70%; padding-top: 4px;">Page Size</label>
                                                    <asp:DropDownList ID="ddlPageSize" runat="server" class="pageSizeddl" OnSelectedIndexChanged="ddlPageSize_SelectedIndexChanged" AutoPostBack="true">
                                                        <asp:ListItem Value="10">10</asp:ListItem>
                                                        <asp:ListItem Value="20">20</asp:ListItem>
                                                        <asp:ListItem Value="30">30</asp:ListItem>
                                                        <asp:ListItem Value="50">50</asp:ListItem>
                                                        <asp:ListItem Value="100">100</asp:ListItem>
                                                    </asp:DropDownList>

                                                </div>
                                            </div>
                                            <div class="col-lg-12">
                                                <div class="table-responsive">
                                                    <asp:GridView ID="grdSearch" runat="server" AutoGenerateColumns="False"
                                                        Width="100%" AlternatingRowStyle-CssClass="alt"
                                                        CssClass="mGrid"
                                                        AllowPaging="true" PageSize="10"
                                                        PagerSettings-Position="Top" PagerStyle-HorizontalAlign="Right"
                                                        Style="font-family: Verdana; font-size: 11px;"
                                                        AllowSorting="true"
                                                        OnRowCancelingEdit="grdSearch_RowCancelingEdit"
                                                        OnRowCommand="grdSearch_RowCommand"
                                                        OnRowDeleting="grdSearch_RowDeleting"
                                                        OnRowEditing="grdSearch_RowEditing"
                                                        OnRowUpdating="grdSearch_RowUpdating"
                                                        OnPageIndexChanging="grdSearch_PageIndexChanging"
                                                        OnSorting="grdSearch_Sorting">
                                                        <Columns>
                                                            <asp:TemplateField HeaderText="ID" SortExpression="LibraryId">
                                                                <ItemTemplate>
                                                                    <asp:Label ID="lblLibraryId" runat="server" Text='<%# Bind("LibraryId") %>'></asp:Label>
                                                                    <asp:HiddenField runat="server" ID="hfParrentId" Value='<%#Eval("ParentId")%>'></asp:HiddenField>
                                                                </ItemTemplate>
                                                                <ControlStyle Width="50px" />
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Library Name" SortExpression="LibraryName">
                                                                <ItemTemplate>
                                                                    <asp:Label runat="server" ID="lblLibraryName" Text='<%# Bind("LibraryName") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <ControlStyle Width="200px" />
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Description" SortExpression="Description">
                                                                <ItemTemplate>
                                                                    <asp:Label runat="server" ID="lblDescription" Text='<%# Bind("Description") %>'></asp:Label>
                                                                </ItemTemplate>
                                                                <ControlStyle Width="240px" />
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Active ?">
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="chkStatus" Enabled="false" Style="background-color: transparent;" runat="server" Checked='<%#Eval("Status") %>' />
                                                                </ItemTemplate>
                                                                <ControlStyle Width="50px" />
                                                                <ItemStyle HorizontalAlign="Center" />
                                                            </asp:TemplateField>
                                                            <asp:TemplateField HeaderText="Actions">
                                                                <ItemTemplate>
                                                                    <asp:ImageButton ID="imgbtnEdit" CommandArgument='<%# ((GridViewRow) Container).RowIndex %>' CommandName="Edit" runat="server" CausesValidation="false" ImageUrl="~/images/edit.ico" ToolTip="Edit" Height="15px" Width="15px" />
                                                                    &nbsp;&nbsp;&nbsp;
                                        <asp:ImageButton ID="imgbtnDelete" CommandArgument='<%# ((GridViewRow) Container).RowIndex %>' CommandName="Delete" OnClientClick="javascript:return confirm('Do you want to delete this Attribute?');" runat="server" CausesValidation="false" ImageUrl="~/Images/DeleteRed.png" ToolTip="Delete" Height="15px" Width="15px" />
                                                                </ItemTemplate>
                                                                <ItemStyle HorizontalAlign="Center" />
                                                            </asp:TemplateField>
                                                        </Columns>
                                                        <EmptyDataTemplate>
                                                            <div style="width: 200px; margin-left: auto; margin-right: auto; color: Red;">
                                                                No Record Found
                                                            </div>
                                                        </EmptyDataTemplate>
                                                    </asp:GridView>
                                                </div>
                                            </div>


                                        </div>
                                    </div>

                                </div>
                                <!-- /.panel -->
                            </div>
                            <!-- /.col-lg-12 -->
                        </div>


                    </asp:View>

                </asp:MultiView>


            </div>
            <!-- /#page-wrapper -->
        </div>
        <!-- /#wrapper -->
        <uc1:Footer runat="server" ID="Footer" />
    </form>
    <link href="../Css/TabStyle.css" rel="stylesheet" />
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
            border-radius: 8px;
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
