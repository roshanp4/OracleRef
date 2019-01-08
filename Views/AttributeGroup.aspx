<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AttributeGroup.aspx.cs" Inherits="LDS.AttributeGroup" EnableEventValidation="false" %>

<%@ Register Src="~/UserControls/Footer.ascx" TagPrefix="uc1" TagName="Footer" %>
<%@ Register Src="~/UserControls/Header.ascx" TagPrefix="uc1" TagName="Header" %>
<%@ Register Src="~/UserControls/LMenu.ascx" TagPrefix="uc1" TagName="LMenu" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>LDS:: Attribute Group</title>
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
                        <h3 class="page-header">Attribute Group</h3>
                    </div>
                    <!-- /.col-lg-12 -->
                </div>
                <!-- /.row -->
                <asp:UpdatePanel ID="udpMain" runat="server">
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
                                                    <div class="col-lg-12">
                                                        <div class="col-lg-6">
                                                            <div class="form-group">
                                                                <div class="form-group">

                                                                    <table>
                                                                        <tr>
                                                                            <td></td>
                                                                            <td style="width: 86%;">
                                                                                <label>Group Name</label>
                                                                                <asp:TextBox ID="txtGroupName" class="form-control" runat="server" placeholder="Group Name" required="required"></asp:TextBox>
                                                                            </td>
                                                                            <td>
                                                                                <asp:CheckBox ID="chkbxStatus" runat="server" class="checkbox" Text="Active ?" Style="margin-left: 40px; width: 71px;" />
                                                                            </td>
                                                                            <td></td>
                                                                        </tr>
                                                                    </table>
                                                                </div>
                                                                <%--<div class="form-group">
                                                                    <div class="checkbox">
                                                                        <label style="margin-left: -19px;"></label>
                                                                        <label>                                                                            
                                                                        </label>
                                                                    </div>
                                                                </div>--%>
                                                            </div>
                                                        </div>
                                                        <div class="col-lg-12">
                                                            <div class="form-group">
                                                                <label>Available Attributes</label>
                                                                <label style="padding-left: 163px">Selected Attributes</label>
                                                                <%--<asp:Label ID="lblMsgGroupName" runat="server" Style="padding-left: 163px" Text="Selected Attributes"></asp:Label>--%>
                                                                <br />
                                                                <asp:ListBox runat="server" ID="lstAllAttribute" Width="25%"
                                                                    DataTextField="RoleName" CssClass="lstbxstyle"
                                                                    Height="180px"></asp:ListBox>
                                                                <asp:ImageButton runat="server" ID="btntoRight" ImageUrl="~/Images/arrow-right.png" Style="margin-bottom: 8%;" formnovalidate="formnovalidate" OnClick="btntoRight_Click" />
                                                                <asp:ImageButton runat="server" ID="btntoleft" ImageUrl="~/Images/arrow-left.png" Style="margin-bottom: 6%; margin-left: -1%;" formnovalidate="formnovalidate" OnClick="btntoleft_Click" />
                                                                <asp:ListBox runat="server" ID="lstGroupAttribute" Width="25%"
                                                                    DataTextField="RoleName" CssClass="lstbxstyle"
                                                                    Height="180px"></asp:ListBox>
                                                                <div class="form-group">
                                                                    <asp:Button ID="btnSubmit" class="btn btn-outline btn-success" runat="server" Text="Submit" OnClick="btnSubmit_Click" />
                                                                    <asp:Button ID="btnReset" class="btn btn-outline btn-warning" runat="server" Text="Reset" formnovalidate="formnovalidate" OnClick="btnReset_Click" />
                                                                </div>
                                                            </div>
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
                                                        <div class="form-group">
                                                            <table>
                                                                <tr>
                                                                    <td style="width: 83%;">
                                                                        <asp:TextBox ID="txtSearch" class="" runat="server" CssClass="txtBoxSearch" placeholder="Search"></asp:TextBox></td>
                                                                    <td>
                                                                        <asp:ImageButton ID="imgbtnSearch" runat="server" ImageUrl="~/Images/Search.png" Width="30px"
                                                                            Style="margin-top: 8px;" OnClick="btnSearchItems_Click" /></td>
                                                                    <td>
                                                                        <asp:ImageButton ID="imgReset" runat="server" ImageUrl="~/Images/reset.png" Width="30px"
                                                                            Style="margin-top: 8px;" OnClick="imgReset_Click" />
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
                                                            <asp:GridView ID="grdGroup" runat="server" AutoGenerateColumns="False"
                                                                ShowFooter="false" Width="100%"
                                                                AlternatingRowStyle-CssClass="alt"
                                                                CssClass="mGrid"
                                                                AllowPaging="true" PageSize="10"
                                                                PagerSettings-Position="Top" PagerStyle-HorizontalAlign="Right"
                                                                Style="font-family: Verdana; font-size: 11px;" AllowSorting="true"
                                                                OnRowCommand="grdGroup_RowCommand" DataKeyNames="GroupId,GroupName"
                                                                OnRowCancelingEdit="grdGroup_RowCancelingEdit"
                                                                OnRowDeleting="grdGroup_RowDeleting" OnRowEditing="grdGroup_RowEditing"
                                                                OnRowUpdating="grdGroup_RowUpdating"
                                                                OnPageIndexChanging="grdGroup_PageIndexChanging" OnSorting="grdGroup_Sorting">
                                                                <Columns>
                                                                    <asp:TemplateField HeaderText="ID" SortExpression="GroupId">
                                                                        <ItemTemplate>
                                                                            <asp:Label runat="server" ID="lblGroupId" CssClass="txtwidthgrid" Style="background-color: transparent;" Enabled="false" Text='<%#Eval("GroupId") %>'></asp:Label>
                                                                            <asp:HiddenField runat="server" ID="hfLibraryId" Value='<%#Eval("LibraryId")%>'></asp:HiddenField>
                                                                        </ItemTemplate>
                                                                        <ItemStyle HorizontalAlign="lEFT" />
                                                                        <ControlStyle Width="1%" />
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField HeaderText="Name" SortExpression="GroupName">
                                                                        <ItemTemplate>
                                                                            <asp:Label runat="server" Enabled="false" Style="background-color: transparent;" ID="lblGroupName" CssClass="txtwidthgrid" Text='<%#Eval("GroupName") %>'></asp:Label>
                                                                        </ItemTemplate>
                                                                        <ControlStyle Width="50%" />
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField HeaderText="LibraryName" SortExpression="LibraryName">
                                                                        <ItemTemplate>
                                                                            <asp:Label runat="server" Enabled="false" Style="background-color: transparent;" ID="lblLibraryName" CssClass="txtwidthgrid" Text='<%#Eval("LibraryName") %>' Width="200px"></asp:Label>
                                                                        </ItemTemplate>
                                                                        <ControlStyle Width="100px" />
                                                                        <ItemStyle HorizontalAlign="Left" />
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField HeaderText="Active ?">
                                                                        <ItemTemplate>
                                                                            <asp:CheckBox ID="chkStatus" Enabled="false" Style="background-color: transparent;" runat="Server" Checked='<%# Eval("AttributeStatus") %>' />
                                                                        </ItemTemplate>
                                                                        <ControlStyle Width="30px" />
                                                                        <ItemStyle HorizontalAlign="Left" />
                                                                    </asp:TemplateField>
                                                                    <asp:TemplateField HeaderText="Action">
                                                                        <ItemTemplate>
                                                                            <asp:ImageButton ID="linkbtnselect" CommandArgument='<%# DataBinder.Eval(Container, "RowIndex") %>' runat="server" ImageUrl="~/images/edit.ico" Height="15px" Width="15px" CommandName="select_one" Font-Size="15px" ToolTip="Edit" />
                                                                            &nbsp;&nbsp;&nbsp;
                            <asp:ImageButton ID="imgbtnDelete" CommandName="Delete" runat="server" CausesValidation="false" OnClientClick="javascript:return confirm('Do you want to delete this Group?');" CommandArgument='<%# ((GridViewRow) Container).RowIndex %>' ImageUrl="~/Images/DeleteRed.png" ToolTip="Delete" Height="15px" Width="15px" />
                                                                        </ItemTemplate>
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
                                                </div>
                                            </div>

                                        </div>
                                        <!-- /.panel -->
                                    </div>
                                    <!-- /.col-lg-12 -->
                                </div>
                                <!-- /.row -->

                            </asp:View>
                        </asp:MultiView>

                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>
            <!-- /#page-wrapper -->
        </div>
        <!-- /#wrapper -->
        <uc1:Footer runat="server" ID="Footer" />
    </form>
</body>
</html>
