<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Details.aspx.cs" Inherits="LDS.Details" EnableEventValidation="false" %>

<%@ Register Src="~/UserControls/Footer.ascx" TagPrefix="uc1" TagName="Footer" %>
<%@ Register Src="~/UserControls/Header.ascx" TagPrefix="uc1" TagName="Header" %>
<%@ Register Src="~/UserControls/LMenu.ascx" TagPrefix="uc1" TagName="LMenu" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>LDS:: Details</title>
    <link href="Css/Style.css" rel="stylesheet" />
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
                        <h1 class="page-header">Favorite!</h1>
                    </div>
                    <!-- /.col-lg-12 -->
                </div>
                <!-- /.row -->
                <div class="row">
                    <div class="col-lg-12">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <a href="#folder">New Folder</a>
                                <a href="#Import">Import New</a>
                            </div>
                            <div class="panel-body">
                                <div class="row">
                                </div>
                            </div>

                        </div>
                        <!-- /.panel -->
                    </div>
                    <div id="folder" class="modalDialogDefault">
                        <div>
                            <a href="#close" title="Close" class="close">X</a>
                            <h3>Create New Folder</h3>
                            <div class="form-group">
                                <asp:TextBox ID="TextBox1" class="form-control" runat="server" placeholder="Folder Name"></asp:TextBox>
                            </div>
                            <div class="col-lg-6">
                                <button type="submit" class="btn btn-success">Create</button>
                            </div>
                        </div>
                    </div>
                    <div id="Import" class="modalDialogDefault">
                        <div>
                            <a href="#close" title="Close" class="close">X</a>
                            <h3>Upload File</h3>
                            <div class="form-group">
                                <asp:FileUpload ID="FileUpload1" runat="server" />
                            </div>
                            <div class="col-lg-6">
                                <button type="submit" class="btn btn-success">Submit</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /#page-wrapper -->
        </div>
        <!-- /#wrapper -->
        <uc1:Footer runat="server" ID="Footer" />
    </form>
</body>
</html>
