<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AttributeList.aspx.cs" Inherits="LDS.Views.AttributeList" EnableEventValidation="false" %>

<%@ Register Src="~/UserControls/Footer.ascx" TagPrefix="uc1" TagName="Footer" %>
<%@ Register Src="~/UserControls/Header.ascx" TagPrefix="uc1" TagName="Header" %>
<%@ Register Src="~/UserControls/LMenu.ascx" TagPrefix="uc1" TagName="LMenu" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>LDS:: Attribute List</title>
    <link href="../Css/bootstrap.min.css" rel="stylesheet" />
    <link href="../Css/font-awesome.min.css" rel="stylesheet" />
    <link href="../Css/timeline.css" rel="stylesheet" />
    <link href="../Css/sb-admin-2.css" rel="stylesheet" />
    <link href="../Css/Style.css" rel="stylesheet" />
    <link href="../Css/alertify.core.css" rel="stylesheet" />
    <link href="../Css/alertify.default.css" rel="stylesheet" />
</head>
<body>
    <form id="frmAttribute" runat="server">
        <div id="wrapper">
            <div id="UlHeader" runat="server" name="UlHeader">
                <!-- Navigation -->
                <nav class="navbar navbar-default navbar-static-top" role="navigation" style="margin-bottom: 0">
                    <uc1:Header runat="server" ID="Header" />
                    <!-- /.navbar-top-links -->
                    <uc1:LMenu runat="server" ID="LMenu" />
                    <!-- /.navbar-static-side -->
                </nav>
            </div>
            <div id="fulWraper" runat="server">
                <div id="page-wrapper">
                    <div class="row">
                        <div class="col-lg-12">
                            <h3 class="page-header">Attribute List</h3>
                        </div>
                        <!-- /.col-lg-12 -->
                    </div>
                    <!-- /.row -->
                    <asp:UpdatePanel ID="udpAdmin" runat="server">
                        <ContentTemplate>
                            <asp:MultiView ID="MVAttribute" runat="server">
                                <asp:View ID="VWAdd" runat="server">

                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="panel panel-default">
                                                <div class="panel-heading">
                                                    <asp:Button ID="btnSearch" runat="server" Text="Back" class="btn btn-primary" formnovalidate="formnovalidate" OnClick="btnSearch_Click" />
                                                </div>
                                                <div class="panel-body">
                                                    <div class="row">
                                                        <div class="col-lg-6">
                                                            <div class="form-group">
                                                                <label>Attribute Name</label>
                                                                <asp:TextBox ID="txtAttributeName" class="form-control" runat="server" placeholder="Attribute Name" required="required"></asp:TextBox>
                                                            </div>
                                                            <div class="form-group">
                                                                <label for="disabledSelect">Attribute Type</label>
                                                                <asp:DropDownList ID="ddlAttributeType" runat="server" class="form-control"
                                                                    OnSelectedIndexChanged="ddlAttributeType_SelectedIndexChanged" AutoPostBack="true">
                                                                    <asp:ListItem Value="String">String</asp:ListItem>
                                                                    <asp:ListItem Value="Integer">Integer</asp:ListItem>
                                                                    <asp:ListItem Value="Number">Number</asp:ListItem>
                                                                    <asp:ListItem Value="Date">Date</asp:ListItem>
                                                                </asp:DropDownList>
                                                            </div>
                                                            <div class="form-group">
                                                                <label>Style</label>
                                                                <asp:DropDownList ID="ddlStyle" runat="server" class="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlStyle_SelectedIndexChanged">
                                                                </asp:DropDownList>
                                                            </div>
                                                            <div class="form-group" runat="server" id="listVal">
                                                                <label>List Values</label>
                                                                <asp:TextBox ID="txtListValues" class="form-control" runat="server" placeholder="List Values"
                                                                    Style="height: 73px;" TextMode="MultiLine"></asp:TextBox>
                                                            </div>
                                                        </div>
                                                        <!-- /.col-lg-6 (nested) -->
                                                        <div class="col-lg-6">

                                                            <div class="form-group">
                                                                <label for="disabledSelect">Description</label>
                                                                <asp:TextBox ID="txtDescription" class="form-control" runat="server" placeholder="Description"
                                                                    TextMode="MultiLine" Style="height: 73px;"></asp:TextBox>
                                                            </div>

                                                            <div class="form-group" style="margin-top: 10%">
                                                                <div class="checkbox">
                                                                    <label>
                                                                        <asp:CheckBox ID="chkDefault" runat="server" class="checkbox" Text="Is Default Values" AutoPostBack="true" OnCheckedChanged="chkDefault_CheckedChanged" />
                                                                    </label>
                                                                </div>
                                                            </div>
                                                            <div class="form-group" runat="server" id="DivdefaultVal">
                                                                <label>Default Value</label>
                                                                <asp:TextBox ID="txtDefaultValue" class="form-control" runat="server" placeholder="Default Value"></asp:TextBox>
                                                            </div>


                                                            <div class="form-group">
                                                                <div class="checkbox">
                                                                    <%--<label style="margin-left: -19px;">Inheritance Mandatory ?</label>--%>
                                                                    <label>
                                                                        <asp:CheckBox ID="chkInhMand" runat="server" class="checkbox" Text="Inheritance Mandatory ?" />
                                                                    </label>
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <div class="checkbox">
                                                                    <%--<label style="margin-left: -19px;">Value Mandatory ?</label>--%>
                                                                    <label>
                                                                        <asp:CheckBox ID="chkValMan" runat="server" class="checkbox" Text="Value Mandatory ?" />
                                                                    </label>
                                                                </div>
                                                            </div>
                                                            <div class="form-group">
                                                                <div class="checkbox">
                                                                    <%--<label style="margin-left: -19px;">Active ?</label>--%>
                                                                    <label>
                                                                        <asp:CheckBox ID="chkAttributeStatus" runat="server" class="checkbox" Text="Active ?" />
                                                                    </label>
                                                                </div>
                                                            </div>

                                                        </div>
                                                        <!-- /.col-lg-6 (nested) -->
                                                        <div class="col-lg-6">
                                                            <div class="form-group" style="margin-right: 22%; float: right; margin-top: -8%;">
                                                                <asp:Button runat="server" ID="btnsubmit" class="btn btn-outline btn-success" Text="Submit" ValidationGroup="Submit"
                                                                    OnClick="btnsubmit_Click"></asp:Button>
                                                                <asp:Button runat="server" ID="btnReset" class="btn btn-outline btn-warning" Text="Reset"
                                                                    formnovalidate="formnovalidate" OnClick="btnReset_Click"></asp:Button>
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
                                <asp:View ID="VWSearch" runat="server">

                                    <div class="row">
                                        <div class="col-lg-12">
                                            <div class="panel panel-default">
                                                <div class="panel-heading">
                                                    <asp:Button ID="btnCreate" runat="server" Text="Create" class="btn btn-primary" OnClick="btnCreate_Click" />
                                                </div>
                                                <div class="panel-body">
                                                    <div class="row">
                                                        <div class="col-lg-6">
                                                            <%-- <div class="form-group">
                                                            <label>Attribute Name</label>
                                                            <asp:TextBox ID="txtSearch" class="txtBoxSearch" runat="server" placeholder="Attribute Name"></asp:TextBox>
                                                        </div>
                                                        <div class="form-group">
                                                            <asp:Button ID="btnSearchItems" runat="server" Text="Search" class="btn btn-success" OnClick="btnSearchItems_Click" />
                                                        </div>--%>
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
                                                            <div class="form-group">
                                                                <div class="table-responsive">
                                                                    <asp:GridView ID="grdAttribute" runat="server" AutoGenerateColumns="False" ShowFooter="false"
                                                                        Width="100%"
                                                                        AlternatingRowStyle-CssClass="alt"
                                                                        CssClass="mGrid"
                                                                        AllowPaging="true" PageSize="10"
                                                                        PagerSettings-Position="Top" PagerStyle-HorizontalAlign="Right"
                                                                        AllowSorting="true"
                                                                        OnRowCancelingEdit="grdAttribute_RowCancelingEdit"
                                                                        OnRowCommand="grdAttribute_RowCommand"
                                                                        OnRowDeleting="grdAttribute_RowDeleting"
                                                                        OnRowEditing="grdAttribute_RowEditing"
                                                                        OnRowUpdating="grdAttribute_RowUpdating"
                                                                        OnPageIndexChanging="grdAttribute_PageIndexChanging"
                                                                        OnSorting="grdAttribute_Sorting">
                                                                        <Columns>
                                                                            <asp:TemplateField HeaderText="ID" SortExpression="AttributeId">
                                                                                <ItemTemplate>
                                                                                    <asp:Label runat="server" ID="lblAttributeId" CssClass="txtwidthgrid" Style="background-color: transparent;" Enabled="false" Text='<%#Eval("AttributeId") %>'></asp:Label>
                                                                                </ItemTemplate>
                                                                                <ItemStyle HorizontalAlign="Center" />
                                                                            </asp:TemplateField>

                                                                            <asp:TemplateField HeaderText="Attribute Name" SortExpression="AttributeName">
                                                                                <ItemTemplate>
                                                                                    <asp:Label runat="server" Enabled="false" Style="background-color: transparent;" ID="lblAttributeName" CssClass="txtwidthgrid" Text='<%#Eval("AttributeName") %>' Width="200px"></asp:Label>
                                                                                </ItemTemplate>
                                                                                <ControlStyle Width="150px" />
                                                                                <ItemStyle HorizontalAlign="Left" />
                                                                            </asp:TemplateField>
                                                                            <asp:TemplateField HeaderText="LibraryName" SortExpression="LibraryName">
                                                                                <ItemTemplate>
                                                                                    <asp:Label runat="server" Enabled="false" Style="background-color: transparent;" ID="lblLibraryName" CssClass="txtwidthgrid" Text='<%#Eval("LibraryName") %>' Width="200px"></asp:Label>
                                                                                </ItemTemplate>
                                                                                <ControlStyle Width="100px" />
                                                                                <ItemStyle HorizontalAlign="Left" />
                                                                            </asp:TemplateField>
                                                                            

                                                                            <asp:TemplateField HeaderText="Type" SortExpression="AttributeType">
                                                                                <ItemTemplate>
                                                                                    <asp:Label runat="server" Enabled="false" CssClass="txtwidthgrid" Style="background-color: transparent;" ID="lblAttributeType" Text='<%#Eval("AttributeType")%>'></asp:Label>
                                                                                </ItemTemplate>
                                                                                <ItemStyle HorizontalAlign="Left" />

                                                                            </asp:TemplateField>

                                                                            <asp:TemplateField HeaderText="Description" SortExpression="Description">
                                                                                <ItemTemplate>
                                                                                    <asp:Label runat="server" Enabled="false" CssClass="txtwidthgrid" Style="background-color: transparent;" ID="lblDescription" Text='<%#Eval("Description")%>'></asp:Label>
                                                                                </ItemTemplate>
                                                                                <ItemStyle HorizontalAlign="Left" />
                                                                                <ControlStyle Width="160px" />
                                                                            </asp:TemplateField>

                                                                            <asp:TemplateField HeaderText="Style" SortExpression="Style">
                                                                                <ItemTemplate>
                                                                                    <asp:Label runat="server" Enabled="false" CssClass="txtwidthgrid" Style="background-color: transparent;" ID="lblStyle" Text='<%#Eval("Style")%>'></asp:Label>
                                                                                    <asp:HiddenField runat="server" ID="hfStyle" Value='<%#Eval("StyleVal")%>'></asp:HiddenField>
                                                                                    <asp:HiddenField runat="server" ID="hfDefaultVal" Value='<%#Eval("DefaultVal")%>'></asp:HiddenField>
                                                                                    <asp:HiddenField runat="server" ID="hfDefaultValFlag" Value='<%#Eval("DefaultValFlag")%>'></asp:HiddenField>
                                                                                    <asp:HiddenField runat="server" ID="hfIsValueMandatory" Value='<%#Eval("IsValueMandatory")%>'></asp:HiddenField>
                                                                                    <asp:HiddenField runat="server" ID="hfIsInhMandatory" Value='<%#Eval("IsInhMandatory")%>'></asp:HiddenField>
                                                                                    <asp:HiddenField runat="server" ID="hfLibraryId" Value='<%#Eval("LibraryId")%>'></asp:HiddenField>
                                                                                </ItemTemplate>
                                                                                <ItemStyle HorizontalAlign="Left" />
                                                                                <ControlStyle Width="90px" />
                                                                            </asp:TemplateField>


                                                                            <asp:TemplateField HeaderText="Active ?">

                                                                                <ItemTemplate>
                                                                                    <asp:CheckBox ID="chkAttributeStatus" Enabled="false" Style="background-color: transparent;" runat="server" Checked='<%#Eval("AttributeStatus") %>' />
                                                                                </ItemTemplate>
                                                                                <ControlStyle Width="30px" />
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

                                    </div>
                                    <!-- /.panel -->

                                    <%--                                <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.9/angular.min.js"></script>
                                <script type="text/javascript">
                                    var app = angular.module('MyApp', [])
                                    app.controller('MyController', function ($scope) {
                                        //This will hide the DIV by default.
                                        $scope.IsVisible = false;
                                        $scope.ShowHide = function () {
                                            //If DIV is visible it will be hidden and vice versa.
                                            $scope.IsVisible = $scope.ShowPassport;
                                        }
                                    });
                                </script>
                                <div ng-app="MyApp" ng-controller="MyController">
                                    <label for="chkPassport">
                                        <input type="checkbox" id="chkPassport" ng-model="ShowPassport" ng-change="ShowHide()" />
                                        Do you have Passport?
                                    </label>
                                    <hr />
                                    <div ng-show="IsVisible">
                                        Passport Number:
                                                         <asp:TextBox ID="txtDefaultValue" class="form-control" runat="server" placeholder="Attribute Name" required="required"></asp:TextBox>
                                    </div>
                                </div>--%>
                                </asp:View>
                            </asp:MultiView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
                <!-- /.col-lg-12 -->
            </div>
        </div>
        <!-- /.row -->
        <!-- /#wrapper -->

        <uc1:Footer runat="server" ID="Footer" />


    </form>
    <%--    <script>
        function CloseWindow() {
            window.close();
        }
    </script>--%>
</body>
</html>
