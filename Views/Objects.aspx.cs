using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using LDS.ObjectSettings;
using LDS.UtilityClass;
using LDS.AttributeService;
using System.Configuration;
using System.Drawing;
using AjaxControlToolkit;
using System.Data;
using System.Collections;

// coded By Jaseel AM
// ON 31-10-2015
// Completed save functions/ wanna start from edit mode. and Group values (accordion controll wanna save . as well as its in editmode)
// stoped on 3-11-2015
namespace LDS.Views
{
    public partial class Objects : System.Web.UI.Page
    {
        #region Variables
        string ServerName = System.Web.Configuration.WebConfigurationManager.AppSettings["ServerName"].ToString();
        string NamespaceName = System.Web.Configuration.WebConfigurationManager.AppSettings["NamespaceName"].ToString();
        string SharedFolderName = System.Web.Configuration.WebConfigurationManager.AppSettings["SharedFolderName"].ToString();
        int flag_initial = 0;
        #endregion

        #region Functions
        private void Clear()
        {
            if (Request.QueryString["Id"] != null)
            {
                //  rptrs.Visible = false;
                imgBtnPaste.Visible = false;
                ViewState["LibraryId"] = Request.QueryString["Id"].ToString();
                Session["FilePath"] = GetParentFilePath(ViewState["LibraryId"].ToString().ToInt());
                ViewState["ObjectID"] = "0";
                mvObject.SetActiveView(vwNewObjects);
                chkStatus.Checked = true;
                if (Request.QueryString["Name"] != null)
                {
                    lblFormName.Text = Request.QueryString["Name"].ToString();
                }
                imgFile.ImageUrl = "~/Images/fileDef.png";
            }
            else
            {
                Response.Redirect("~/Views/Dashboard.aspx");
            }
        }
        private void SearchClear()
        {
            if (Request.QueryString["Name"] != null)
            {
                lblFormName.Text = Request.QueryString["Name"].ToString();
            }
            ContensedRepeaterFill();
            mvObject.SetActiveView(vwContensed);
            ViewState["SortDirection"] = "ASC";
        }
        private string FileUpload()
        {
            string strFileName = string.Empty;
            if (fupFile.HasFile)
            {
                strFileName = fupFile.FileName;
                if (strFileName != "")
                {
                    string strTick = DateTime.Now.Ticks.ToString();
                    string str = strFileName;
                    string[] tokens = str.Split('.');
                    string last = tokens[tokens.Length - 1];
                    string Extension = str.Substring(str.LastIndexOf('.') + 1);
                    string pathImages = Session["FilePath"].ToString();
                    string FileName = tokens[0];
                    fupFile.PostedFile.SaveAs(pathImages + "\\" + FileName + strTick + "." + Extension);
                    strFileName = FileName + strTick + "." + Extension;
                }
            }
            return strFileName;
        }
        /// <summary>
        /// Its for getting File path from parentID
        /// </summary>
        /// <param name="ParentID"></param>
        /// <returns></returns>
        private string GetParentFilePath(int ParentID)
        {
            ObjectSettings.ObjectSettingsClient oClient = new ObjectSettingsClient(ServiceConfig.ObjectSettingsEndPoint(), ServiceConfig.ObjectSettingsUri());
            ObjectSettings.ObjectSettingsData oApplicationData = new ObjectSettings.ObjectSettingsData();
            List<ObjectSettings.ObjectSettingsData> olist = new List<ObjectSettingsData>();
            olist = oClient.GetObjectDetails(Convert.ToInt16(ViewState["LibraryId"]));
            if (olist.Count > 0)
            {
                txtVersion.Text = Convert.ToString(olist[0].CurrentVersion);
                Session["FilePath"] = olist[0].FilePath;
                return Session["FilePath"].ToString();

            }
            else if (olist.Count == 0 /*&& ParentID == 0*/)
            {
                txtVersion.Text = "1";
                return "\\\\" + ConfigurationManager.AppSettings["ServerName"].ToString() + "\\" + ConfigurationManager.AppSettings["NamespaceName"].ToString() + "\\" + ConfigurationManager.AppSettings["SharedFolderName"].ToString();
            }
            else
            {
                return Session["FilePath"].ToString();
            }
        }

        /// <summary>
        /// Its for Dynamically creating accordian panal and its Attributes list and all
        /// </summary>
        private void createGroupControlsForDocument()
        {
            if (ViewState["ObjectID"] != null)
            {
                AttributeService.AttributeSettingsClient oClient = new AttributeSettingsClient();
                List<AttributeService.AttributeSettingsData> oGetVal = new List<AttributeSettingsData>();
                // oGetVal = oClient.GetObjectAttributeList(1354).ToList();
                oGetVal = oClient.GetObjectAttributeList(Convert.ToInt16(ViewState["ObjectID"])).ToList();
                var AttribGrouplist = (from AttributeService.AttributeSettingsData AttribItem in oGetVal
                                       select (AttribItem.GroupName).ToString()).Distinct().ToList();
                int i = 0;
                foreach (string dr in AttribGrouplist)
                {
                    flag_initial = 0;
                    AccordionPane obj = new AccordionPane();
                    LiteralControl lctl = new LiteralControl();
                    Table otblcontainer = new Table();
                    otblcontainer.ID = "table_" + i.ToString();
                    lctl.Text = Convert.ToString(dr);
                    obj.HeaderContainer.ID = i.ToString() + "hdr";
                    obj.HeaderContainer.Controls.Add(lctl);
                    obj.HeaderContainer.Style.Add("color", "White");
                    obj.HeaderContainer.Style.Add("font-family", "Verdana");
                    obj.HeaderContainer.Style.Add("color", "White");
                    obj.HeaderContainer.Style.Add("font-size", "12px");
                    var foundRows = from p in oGetVal where p.GroupName == dr select p;
                    int j = 0;
                    foreach (AttributeService.AttributeSettingsData oItem in foundRows)
                    {
                        RegularExpressionValidator regExp = new RegularExpressionValidator();
                        TableRow tableRow = new TableRow();
                        TableCell labelboxCell = new TableCell();
                        TableCell textboxCell = new TableCell();
                        TableCell ImgbtnCell = new TableCell();
                        TableCell validatorCell = new TableCell();
                        TableCell RegulValidatorCell = new TableCell();
                        TableCell ImageCell = new TableCell();
                        TextBox textBox = new TextBox();
                        textBox.CssClass = "form-control";
                        textBox.Width = 260;
                        textBox.Attributes.Add("required", "required");
                        Label labelBox = new Label();
                        labelBox.CssClass = "lblNormalStyle";
                        labelBox.Width = 150;
                        if (Convert.ToString(oItem.AttributeType).Equals("D"))
                        {
                            ImageButton oimgbtn = new ImageButton();
                            oimgbtn.ID = "imgbtn_" + i.ToString() + j.ToString();
                            oimgbtn.ImageUrl = "~/Images/calendarIcon.gif";
                            AjaxControlToolkit.CalendarExtender ocalendar = new CalendarExtender();
                            ocalendar.ID = "ce_" + i.ToString() + j.ToString();
                            ocalendar.TargetControlID = "txt_" + oItem.GroupId + "_" + oItem.AttributeId;
                            ocalendar.PopupButtonID = "imgbtn_" + i.ToString() + j.ToString();
                            ocalendar.Format = "dd-MMM-yyyy";
                            ImageCell.Controls.Add(oimgbtn);
                            ImageCell.Controls.Add(ocalendar);
                        }
                        textBox.ID = "txt_" + oItem.GroupId + "_" + oItem.AttributeId;
                        if (Request.QueryString["mode"] != "AddNewDoc")
                        {
                            for (int k = 0; k < oGetVal.Count; k++)
                            {
                                if (oGetVal[k].AttributeId == oItem.AttributeId)
                                {
                                    if (oItem.AttributeType == "D" && oGetVal[k].AttributeValue != "")
                                        textBox.Text = Extension.Convert2DateTime(oGetVal[k].AttributeValue).Value.ToString("dd-MMM-yyyy");
                                    else
                                        textBox.Text = oGetVal[k].AttributeValue;
                                }
                            }
                        }
                        labelBox.Text = Convert.ToString(oItem.AttributeName);// +": ";
                        string Datatype;
                        regExp.ID = "regExp_" + i.ToString() + j.ToString();
                        regExp.ControlToValidate = "txt_" + oItem.GroupId + "_" + oItem.AttributeId;
                        regExp.EnableClientScript = true;
                        regExp.Display = ValidatorDisplay.Dynamic;
                        regExp.ForeColor = Color.Red;
                        regExp.ValidationGroup = "AttrVal";
                        Datatype = Convert.ToString(oItem.AttributeType);
                        if (Datatype == "N")
                        {
                            regExp.ValidationExpression = @"^\d+$";
                            regExp.ErrorMessage = oItem.AttributeName + " should be a number";
                            regExp.Text = "*";
                            regExp.ToolTip = oItem.AttributeName + " should be a number";
                        }
                        else if (Datatype == "I")
                        {
                            regExp.ValidationExpression = @"^\d+$";
                            regExp.ErrorMessage = oItem.AttributeName + " should be a intiger";
                            regExp.Text = "*";
                            regExp.ToolTip = oItem.AttributeName + " should be a intiger";
                        }
                        else if (Datatype == "D")
                        {
                            regExp.ValidationExpression = @"^(0?[1-9]|[12][0-9]|3[01])-(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)-(19|20)\d\d$";
                            regExp.ErrorMessage = oItem.AttributeName + " should be a Date [Format:dd-MMM-yyy]";
                            regExp.Text = "*";
                            regExp.ToolTip = oItem.AttributeName + " should be a Date [Format:dd-MMM-yyy]";
                        }
                        labelboxCell.Controls.Add(labelBox);
                        textboxCell.Controls.Add(textBox);
                        // validatorCell.Controls.Add(reqfld);
                        RegulValidatorCell.Controls.Add(regExp);
                        tableRow.Cells.Add(labelboxCell);
                        tableRow.Cells.Add(textboxCell);
                        tableRow.Cells.Add(ImageCell);
                        tableRow.Cells.Add(ImgbtnCell);
                        tableRow.Cells.Add(validatorCell);
                        if (regExp.ValidationExpression != "")
                            tableRow.Cells.Add(RegulValidatorCell);
                        otblcontainer.Rows.Add(tableRow);
                        otblcontainer.Rows.Add(tableRow);
                        j += 1;
                    }
                    obj.ContentContainer.Controls.Add(otblcontainer);
                    obj.ContentContainer.ID = i.ToString() + "content";
                    obj.ID = "acdnFilepane_" + i.ToString();
                    obj.ClientIDMode = ClientIDMode.AutoID;
                    AccordionGroupDocument.Panes.Add(obj);
                    i += 1;
                }
                Session["AccordionData"] = AccordionGroupDocument;
            }
        }
        private void DoneDocumentFirstLevel()
        {
            string strMessage = string.Empty, NewObjectId;
            if (ViewState["ObjectID"] != null)
            {
                ObjectSettingsClient oObjectMaster = new ObjectSettingsClient(ServiceConfig.ObjectSettingsEndPoint(), ServiceConfig.ObjectSettingsUri());
                ObjectSettings.ObjectSettingsData insertObject = new ObjectSettings.ObjectSettingsData();
                insertObject.ObjectId = Convert.ToInt16(ViewState["ObjectID"].ToString());
                insertObject.ObjectName = txtObjectName.Text;
                // To Get Vault id and its path
                ObjectSettingsClient oClient = new ObjectSettingsClient(ServiceConfig.ObjectSettingsEndPoint(), ServiceConfig.ObjectSettingsUri());
                List<ObjectSettings.ObjectSettingsData> oList = new List<ObjectSettingsData>();
                int VaultId = 0; string VaultPath = string.Empty;
                oClient.GetVaultId(ViewState["LibraryId"].ToString().ToInt(), out VaultId, out VaultPath);
                string firsrpath = VaultPath;
                string exension = ""; // Wanna change here extension
                insertObject.FilePath = firsrpath;
                insertObject.CurrentVersion = Convert.ToInt16(txtVersion.Text);
                oObjectMaster.SaveObjects(insertObject, out NewObjectId);
                insertObject.ObjectName = txtObjectName.Text;
                insertObject.ObjectType = "D";
                string NewPath = firsrpath.Replace(firsrpath.Substring(firsrpath.LastIndexOf("\\") + 1), txtObjectName.Text + "." + exension);
                if (@firsrpath != @NewPath)
                {
                    Directory.Move(@firsrpath, @NewPath);
                    insertObject.ObjectName = txtObjectName.Text;
                    insertObject.FilePath = NewPath;
                }
                insertObject.CurrentVersion = Convert.ToInt16(txtVersion.Text);
                oObjectMaster.SaveObjects(insertObject, out NewObjectId);
                insertObject.CurrentVersion = Convert.ToInt16(txtVersion.Text);
                ViewState["CurrentVersion"] = Convert.ToInt16(txtVersion.Text);
                ViewState["ObjectIdNew"] = ViewState["ObjectID"].ToString();
                SaveOrEditGroupValues();
            }
        }
        private void SaveOrEditObjects()
        {
            string strMessage = string.Empty, NewObjectId;
            string path = string.Empty; string UploadedFileName = string.Empty; string last = string.Empty;
            ObjectSettingsClient oObjectMaster = new ObjectSettingsClient(ServiceConfig.ObjectSettingsEndPoint(), ServiceConfig.ObjectSettingsUri());
            ObjectSettings.ObjectSettingsData insertObject = new ObjectSettings.ObjectSettingsData();
            if (fupFile.FileName != "" || ViewState["ObjectID"].ToString() != "0")
            {
                // To Get Vault id and its path
                ObjectSettingsClient oClient = new ObjectSettingsClient(ServiceConfig.ObjectSettingsEndPoint(), ServiceConfig.ObjectSettingsUri());
                List<ObjectSettings.ObjectSettingsData> oList = new List<ObjectSettingsData>();
                int VaultId = 0; string VaultPath = string.Empty;
                oClient.GetVaultId(ViewState["LibraryId"].ToString().ToInt(), out VaultId, out VaultPath);
                if (VaultPath != string.Empty)
                {
                    Session["FilePath"] = VaultPath;
                }
                insertObject.VaultId = VaultId;
                insertObject.CurrentVersion = txtVersion.Text.Trim().ToInt();
                insertObject.Description = txtDescription.Text.Trim();
                if (fupFile.FileName != "")
                {
                    string str = fupFile.FileName;
                    string[] tokens = str.Split('.');
                    last = tokens[tokens.Length - 1];
                    string last1 = str.Substring(str.LastIndexOf('.') + 1);
                    path = Session["FilePath"].ToString();
                    if (!Directory.Exists(path))
                    {
                        Directory.CreateDirectory(path);
                    }
                    UploadedFileName = FileUpload();
                }

                string FullFilePath;
                FullFilePath = path + "\\" + UploadedFileName;
                insertObject.FilePath = FullFilePath != "\\" ? FullFilePath : ViewState["FilePath"].ToString();
                insertObject.FileSize = fupFile.FileName != "" ? fupFile.PostedFile.ContentLength.ToString().ToInt() : ViewState["FileSize"].ToString().ToInt();
                insertObject.FileType = last != "" ? last : ViewState["FileType"].ToString();
                insertObject.Owner = Session["LoggedUser"].ToString();
                insertObject.Status = chkStatus.Checked ? true : false;
                insertObject.User = Session["LoggedUser"].ToString();
                insertObject.LibraryId = ViewState["LibraryId"].ToString().ToInt();
                if (ViewState["ObjectID"] != null)
                {
                    insertObject.ObjectId = ViewState["ObjectID"].ToString().ToInt();
                }
                insertObject.ObjectName = txtObjectName.Text.Trim();
                insertObject.ObjectType = "D";
                oObjectMaster.SaveObjects(insertObject, out NewObjectId);
                ViewState["ObjectID"] = NewObjectId != "" ? NewObjectId : ViewState["ObjectID"].ToString();
                mvObject.SetActiveView(vwObjectAttr);
                createGroupControlsForDocument();
                if (NewObjectId == string.Empty)
                {
                    Common.SavedMessage(this, "Object updated successfully..!");
                }
                else
                {
                    Common.SavedMessage(this, "Object created successfully..!");
                }

            }
        }
        private void SaveOrEditGroupValues()
        {
            Accordion AccordionData = new Accordion();
            AccordionData = (Accordion)Session["AccordionData"];
            foreach (AccordionPane oItem in AccordionData.Panes)
            {
                foreach (TableRow trow in (oItem.ContentContainer.Controls[0] as Table).Rows)
                {
                    AttributeService.AttributeSettingsClient oClient = new AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
                    TextBox tbox = trow.Cells[1].Controls[0] as TextBox;
                    string ID = tbox.ID.ToString();
                    string[] array = ID.Split('_');
                    int GroupId = Convert.ToInt16(array[1]);
                    int AttributeId = Convert.ToInt16(array[2]);
                    string AttributeValue = Request.Form[tbox.UniqueID];
                    AttributeService.AttributeSettingsData oDataGroup = new AttributeSettingsData();
                    oDataGroup.ObjectId = Convert.ToInt16(ViewState["ObjectID"].ToString()); //should be new object Id
                    oDataGroup.GroupId = GroupId;
                    oDataGroup.CurrentVersion = txtVersion.Text.ToInt();
                    oDataGroup.User = Session["UserId"].ToString();
                    // oClient.SaveObjectAttributeGroup(oDataGroup);
                    AttributeService.AttributeSettingsData oDataAttribute = new AttributeSettingsData();
                    oDataAttribute.ObjectId = Convert.ToInt16(ViewState["ObjectID"].ToString()); //should be new object Id
                    oDataAttribute.CurrentVersion = txtVersion.Text.ToInt();
                    oDataAttribute.AttributeId = AttributeId;
                    oDataAttribute.AttributeValue = AttributeValue;
                    oDataAttribute.ValMand = "";
                    oDataAttribute.InheritMand = "";
                    oDataAttribute.User = Session["UserId"].ToString();
                    //  oClient.SaveObjectAttribute(oDataAttribute);
                }
            }
            Common.SavedMessage(this, "Saved successfully..!");
            mvObject.SetActiveView(vwContensed);
        }
        private void ContensedRepeaterFill()
        {
            ShoHideControlls("Contensed");
            mvObject.SetActiveView(vwContensed);
            if (Request.QueryString["Id"] != null)
            {
                ViewState["LibraryId"] = Request.QueryString["Id"].ToString();
                ObjectSettingsClient oClient = new ObjectSettingsClient(ServiceConfig.ObjectSettingsEndPoint(), ServiceConfig.ObjectSettingsUri());
                rptrSearch.DataSource = oClient.FillObjectsByLibrary(ViewState["LibraryId"].ToString().ToInt());
                rptrSearch.DataBind();
            }
        }
        private void DetaildGridFill()
        {
            ShoHideControlls("List");
            mvObject.SetActiveView(vwDetailed);
            if (Request.QueryString["Id"] != null)
            {
                ViewState["LibraryId"] = Request.QueryString["Id"].ToString();
                ObjectSettingsClient oClient = new ObjectSettingsClient(ServiceConfig.ObjectSettingsEndPoint(), ServiceConfig.ObjectSettingsUri());
                grdDetaild.DataSource = oClient.FillObjectsByLibrary(ViewState["LibraryId"].ToString().ToInt());
                grdDetaild.DataBind();
            }
        }
        private void FillDetails(int inObjectId)
        {
            mvObject.SetActiveView(vwNewObjects);
            ObjectSettingsClient oClient = new ObjectSettingsClient(ServiceConfig.ObjectSettingsEndPoint(), ServiceConfig.ObjectSettingsUri());
            List<ObjectSettings.ObjectSettingsData> oList = new List<ObjectSettingsData>();
            oList = oClient.GetObjectDetails(inObjectId);
            if (oList.Count > 0)
            {
                txtDescription.Text = oList[0].Description;
                txtObjectName.Text = oList[0].ObjectName;
                txtVersion.Text = oList[0].CurrentVersion.ToString();
                if (oList[0].Status)
                {
                    chkStatus.Checked = true;
                }
                // oList[0].Status ? chkStatus.Checked=true : chkStatus.Checked = false;
                ViewState["FilePath"] = oList[0].FilePath;
                ViewState["FileSize"] = oList[0].FileSize;
                ViewState["FileType"] = oList[0].FileType;
                string strExtension = Path.GetExtension(oList[0].FilePath).ToLower();

                if (strExtension == ".jpeg" || strExtension == ".jpg" || strExtension == ".png" || strExtension == ".gif" || strExtension == ".tiff" || strExtension == ".bmp" || strExtension == ".tif")
                {
                    imgFile.ImageUrl = "~/Images/image.png";
                }
                else if (strExtension == ".xls" || strExtension == ".xlsx" || strExtension == ".xlsm" || strExtension == ".xltx" || strExtension == ".xlt" || strExtension == ".xlm")
                {
                    imgFile.ImageUrl = "~/Images/Excel_Icon.png";
                }
                else if (strExtension == ".doc" || strExtension == ".docx" || strExtension == ".docm" || strExtension == ".dotx" || strExtension == ".dotm" || strExtension == ".docb")
                {
                    imgFile.ImageUrl = "~/Images/word_Icon.png";
                }
                else if (strExtension == ".pdf")
                {
                    imgFile.ImageUrl = "~/Images/Pdf_Icon.png";
                }
                else if (strExtension == ".ppt" || strExtension == ".pptx" || strExtension == ".pot" || strExtension == ".pps" || strExtension == ".pptx" || strExtension == ".pptm" || strExtension == ".potx")
                {
                    imgFile.ImageUrl = "~/Images/Ppt_Icon.png";
                }
                else
                {
                    imgFile.ImageUrl = "~/Images/fileDef.png";
                }
                btnSubmitObject.Text = "Update Objects";
                rfvFileupload.Enabled = false;
            }
        }
        protected void DownloadFile(object sender, EventArgs e)
        {
            string filePath = (sender as ImageButton).CommandArgument;
            Response.ContentType = ContentType;
            Response.AppendHeader("Content-Disposition", "attachment; filename=" + Path.GetFileName(filePath));
            Response.WriteFile(filePath);
            Response.End();
        }
        #endregion

        #region Events
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["Id"] != null)
                {
                    ViewState["LibraryId"] = Request.QueryString["Id"].ToString();
                    Session["LibraryId"] = ViewState["LibraryId"];
                    SearchClear();
                    if (Session["IsCopied"] != null || Session["IsMoving"] != null)
                    {
                        imgBtnPaste.Visible = true;
                    }
                }
            }
        }
        protected void imgBtnNew_Click(object sender, ImageClickEventArgs e)
        {
            imgBtnPaste.Visible = false;
            Clear();
        }
        protected void imgBtnSelect_Click(object sender, ImageClickEventArgs e)
        {
            ViewState["isDelete"] = null;
            ViewState["isMail"] = null;
            ViewState["isCopy"] = null;
            imgBtnPaste.Visible = false;
            SearchClear();
        }
        protected void imgBtndelete_Click(object sender, ImageClickEventArgs e)
        {
            ViewState["isDelete"] = true;
            ViewState["isCopy"] = null;
            ViewState["isMail"] = null;
            imgBtnPaste.Visible = false;
            SearchClear();
        }
        protected void btnSubmitObject_Click(object sender, EventArgs e)
        {
            string Extension = string.Empty;
            string Ext = string.Empty;
            if (ViewState["FileType"] == null)
            {
                Extension = Path.GetExtension(fupFile.PostedFile.FileName);
                string[] tokens = Extension.Split('.');
                string last = tokens[tokens.Length - 1];
                Ext = Extension.Substring(Extension.LastIndexOf('.') + 1);
            }
            else
            {
                Ext = ViewState["FileType"].ToString();
            }
            if (Common.CheckFileToUpload(Ext))
            {
                SaveOrEditObjects();
            }
            else
            {
                Common.ErrorMessage(this, "The file will not support..!");
            }

        }
        protected void btnResetObject_Click(object sender, EventArgs e)
        {
            Clear();
        }

        //protected void AccordionGroupDocument_ItemCommand(object sender, CommandEventArgs e)
        //{
        //    if (e.CommandName.Equals("DeletebtnPressed"))
        //    {
        //        int GroupID, AttributeID, ObjectId, Version;
        //        string strMsg;
        //        GroupID = Convert.ToInt16(e.CommandArgument.ToString().Split('_')[0]);
        //        AttributeID = Convert.ToInt16(e.CommandArgument.ToString().Split('_')[1]);
        //        Version = Convert.ToInt16(e.CommandArgument.ToString().Split('_')[2]);
        //        ObjectId = Convert.ToInt16(ViewState["ObjectID"].ToString());
        //        AttributeService.AttributeSettingsClient oClient = new AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
        //        AttributeService.AttributeSettingsData oData = new AttributeSettingsData();
        //        oData.AttributeId = AttributeID;
        //        oData.ObjectId = ObjectId;
        //        oData.CurrentVersion = Version;
        //        strMsg = oClient.DeleteObjectAttribute(oData);
        //        ClientScript.RegisterStartupScript(this.GetType(), "modelmsg", "ShowMessage('" + strMsg + "',false,'');", true);
        //        ScriptManager.RegisterStartupScript(this, this.GetType(), "abc", "SubmitPage();", true);
        //    }
        //    if (e.CommandName.Equals("DeleteGroupbtnPressed"))
        //    {
        //        int GroupID, AttributeID, ObjectId, Version;
        //        string strMsg;
        //        GroupID = Convert.ToInt16(e.CommandArgument.ToString().Split('_')[0]);
        //        AttributeID = Convert.ToInt16(e.CommandArgument.ToString().Split('_')[1]);
        //        Version = Convert.ToInt16(e.CommandArgument.ToString().Split('_')[2]);
        //        ObjectId = Convert.ToInt16(ViewState["ObjectID"].ToString());
        //    }
        //}
        protected void btnSaveAttr_Click(object sender, EventArgs e)
        {
            SaveOrEditGroupValues();
        }
        ArrayList CopiedFiles = new ArrayList();
        ArrayList FilesToMail = new ArrayList();
        protected void rptrSearch_ItemCommand(object source, DataListCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "Edit")
                {
                    ViewState["ObjectID"] = e.CommandArgument.ToString().ToInt();
                    FillDetails(ViewState["ObjectID"].ToString().ToInt());
                }
                else if (e.CommandName == "DeleteAll")
                {
                    bool isCount = false;
                    for (int i = 0; i < rptrSearch.Items.Count; i++)
                    {
                        CheckBox chkSelect = (CheckBox)rptrSearch.Items[i].FindControl("chkSelect");
                        if (chkSelect.Checked)
                        {
                            HiddenField hfObjectId = (HiddenField)rptrSearch.Items[i].FindControl("hfObjectId");
                            ObjectSettings.ObjectSettingsClient oClient = new ObjectSettings.ObjectSettingsClient(ServiceConfig.ObjectSettingsEndPoint(), ServiceConfig.ObjectSettingsUri());
                            oClient.DeleteObject(hfObjectId.Value.ToInt());
                            HiddenField hfPath = (HiddenField)rptrSearch.Items[i].FindControl("hfPath");
                            File.Delete(hfPath.Value);
                            isCount = true;
                        }
                    }
                    if (isCount)
                    {
                        Common.SavedMessage(this, "Objects deleted successfully..!");
                        ContensedRepeaterFill();
                    }
                    else
                    {
                        Common.ErrorMessage(this, "Select atleast one object to delete..!");
                    }
                }
                else if (e.CommandName == "Delete")
                {
                    ObjectSettings.ObjectSettingsClient oClient = new ObjectSettings.ObjectSettingsClient(ServiceConfig.ObjectSettingsEndPoint(), ServiceConfig.ObjectSettingsUri());
                    oClient.DeleteObject(e.CommandArgument.ToString().ToInt());
                    HiddenField hfPath = (HiddenField)e.Item.FindControl("hfPath");
                    File.Delete(hfPath.Value);
                    Common.SavedMessage(this, "Deleted successfully..!");
                    ContensedRepeaterFill();
                }
                else if (e.CommandName == "Copy")
                {
                    bool isCount = false;
                    for (int i = 0; i < rptrSearch.Items.Count; i++)
                    {
                        CheckBox chkSelect = (CheckBox)rptrSearch.Items[i].FindControl("chkSelect");
                        if (chkSelect.Checked)
                        {
                            //HiddenField hfObjectId = (HiddenField)rptrSearch.Items[i].FindControl("hfObjectId");
                            HiddenField hfPath = (HiddenField)rptrSearch.Items[i].FindControl("hfPath");
                            isCount = true;
                            CopiedFiles.Add(hfPath.Value);
                        }
                    }
                    Session["CopiedFiles"] = CopiedFiles;
                    if (isCount)
                    {
                        Session["IsCopied"] = true;
                        Common.SavedMessage(this, "Objects copied successfully, Find a location to paste..!");
                        ContensedRepeaterFill();
                        imgBtnPaste.Visible = true;
                    }
                    else
                    {
                        Common.ErrorMessage(this, "Select atleast one object to Copy..!");
                    }
                }
                else if (e.CommandName == "CandD")
                {
                    string strTempFileName = Path.GetFileName(e.CommandArgument.ToString());
                    // To Get Exact File Name Here
                    int idx = strTempFileName.LastIndexOf('.');
                    int inEnd = idx - 18;
                    Session["strExtFileName"] = strTempFileName.Substring(0, inEnd);
                    List<string> filesToCompress = new List<string>();
                    filesToCompress.Add(e.CommandArgument.ToString());
                    if (filesToCompress.Count > 0)
                    {
                        //Creating Object of class to compress and download as a zip
                        CompressionArchive CompressSelectedFiles = new CompressionArchive();
                        // Compress to a zip file
                        CompressSelectedFiles.CompressToZipArchive(filesToCompress);
                        // Sends the Zip over HTTP
                        CompressSelectedFiles.DownloadFile();
                    }
                }
                else if (e.CommandName == "Mail")
                {
                    bool isCount = false;
                    for (int i = 0; i < rptrSearch.Items.Count; i++)
                    {
                        CheckBox chkSelect = (CheckBox)rptrSearch.Items[i].FindControl("chkSelect");
                        if (chkSelect.Checked)
                        {
                            HiddenField hfPath = (HiddenField)rptrSearch.Items[i].FindControl("hfPath");
                            isCount = true;
                            FilesToMail.Add(hfPath.Value);
                        }
                    }
                    if (isCount)
                    {
                        Session["CopiedFiles"] = FilesToMail;
                        MPEMailingDocuments.Show();
                        if (Session["LoggedEmail"] != null)
                        {
                            txtFromAddress.Text = Session["LoggedEmail"].ToString();
                            txtccAddress.Text = Session["LoggedEmail"].ToString();
                        }
                        txtMailSubject.Text = "Document Mailing";
                        txtMailBody.Text = "Please find the attachments";
                        txtToAddress.Focus();
                    }
                    else
                    {
                        Common.ErrorMessage(this, "Select atleast one Object to Send as Mail..!");
                    }
                }
                else if (e.CommandName == "Move")
                {
                    bool isCount = false;
                    DataTable dtbl = new DataTable();
                    dtbl.Columns.Add("ObjectId");
                    dtbl.Columns.Add("FilePath");

                    for (int i = 0; i < rptrSearch.Items.Count; i++)
                    {
                        CheckBox chkSelect = (CheckBox)rptrSearch.Items[i].FindControl("chkSelect");
                        if (chkSelect.Checked)
                        {
                            HiddenField hfPath = (HiddenField)rptrSearch.Items[i].FindControl("hfPath");
                            HiddenField hfObjectId = (HiddenField)rptrSearch.Items[i].FindControl("hfObjectId");
                            isCount = true;
                            dtbl.Rows.Add();
                            dtbl.Rows[i]["ObjectId"] = hfObjectId.Value;
                            dtbl.Rows[i]["FilePath"] = hfPath.Value;
                        }
                    }
                    Session["MovingFiles"] = dtbl;
                    if (isCount)
                    {
                        Session["IsMoving"] = true;
                        Common.SavedMessage(this, "Now Select Target Folder");
                        ContensedRepeaterFill();
                        imgBtnPaste.Visible = true;
                    }
                    else
                    {
                        Common.ErrorMessage(this, "Select atleast one object to Copy..!");
                    }
                }
            }
            catch (Exception ex)
            {
                Common.ErrorMessage(this, ex.ToString());
            }
        }
        protected void rptrSearch_ItemDataBound(object sender, DataListItemEventArgs e)
        {
            try
            {
                if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
                {
                    System.Web.UI.WebControls.Image imgPhoto = (System.Web.UI.WebControls.Image)e.Item.FindControl("imgPhoto");
                    string strExtension = Path.GetExtension(imgPhoto.ImageUrl);
                    if (strExtension == ".jpeg" || strExtension == ".jpg" || strExtension == ".png" || strExtension == ".gif" || strExtension == ".tiff" || strExtension == ".bmp" || strExtension == ".tif")
                    {
                        imgPhoto.ImageUrl = "~/Images/image.png";
                    }
                    else if (strExtension == ".xls" || strExtension == ".xlsx" || strExtension == ".xlsm" || strExtension == ".xltx" || strExtension == ".xlt" || strExtension == ".xlm")
                    {
                        imgPhoto.ImageUrl = "~/Images/Excel_Icon.png";
                    }
                    else if (strExtension == ".doc" || strExtension == ".docx" || strExtension == ".docm" || strExtension == ".dotx" || strExtension == ".dotm" || strExtension == ".docb")
                    {
                        imgPhoto.ImageUrl = "~/Images/word_Icon.png";
                    }
                    else if (strExtension == ".pdf")
                    {
                        imgPhoto.ImageUrl = "~/Images/Pdf_Icon.png";
                    }
                    else if (strExtension == ".ppt" || strExtension == ".pptx" || strExtension == ".pot" || strExtension == ".pps" || strExtension == ".pptx" || strExtension == ".pptm" || strExtension == ".potx")
                    {
                        imgPhoto.ImageUrl = "~/Images/Ppt_Icon.png";
                    }
                    else
                    {
                        imgPhoto.ImageUrl = "~/Images/fileDef.png";
                    }
                    if (ViewState["isDelete"] == null && ViewState["isCopy"] == null && ViewState["isMail"] == null && ViewState["isMove"] == null)
                    {
                        CheckBox chkSelect = (CheckBox)e.Item.FindControl("chkSelect");
                        chkSelect.Visible = false;
                    }
                }
                if (e.Item.ItemType == ListItemType.Header)
                {
                    if (ViewState["isDelete"] == null && ViewState["isCopy"] == null && ViewState["isMail"] == null && ViewState["isMove"] == null)
                    {
                        CheckBox chkSelectAll = (CheckBox)e.Item.FindControl("chkSelectAll");
                        chkSelectAll.Visible = false;
                        Button btnDeleteSelected = (Button)e.Item.FindControl("btnDeleteSelected");
                        btnDeleteSelected.Visible = false;
                        Button btnCopySelected = (Button)e.Item.FindControl("btnCopySelected");
                        btnCopySelected.Visible = false;
                        Button btnMailSelected = (Button)e.Item.FindControl("btnMailSelected");
                        btnMailSelected.Visible = false;
                        Button btnMoveSelected = (Button)e.Item.FindControl("btnMoveSelected");
                        btnMoveSelected.Visible = false;
                    }
                    else if (ViewState["isCopy"] == null && ViewState["isDelete"] != null)
                    {
                        Button btnDeleteSelected = (Button)e.Item.FindControl("btnDeleteSelected");
                        btnDeleteSelected.Visible = true;
                        CheckBox chkSelectAll = (CheckBox)e.Item.FindControl("chkSelectAll");
                        chkSelectAll.Visible = true;
                        Button btnCopySelected = (Button)e.Item.FindControl("btnCopySelected");
                        btnCopySelected.Visible = false;
                        Button btnMailSelected = (Button)e.Item.FindControl("btnMailSelected");
                        btnMailSelected.Visible = false;
                        Button btnMoveSelected = (Button)e.Item.FindControl("btnMoveSelected");
                        btnMoveSelected.Visible = false;
                    }
                    else if (ViewState["isCopy"] != null && ViewState["isDelete"] == null)
                    {
                        Button btnDeleteSelected = (Button)e.Item.FindControl("btnDeleteSelected");
                        btnDeleteSelected.Visible = false;
                        CheckBox chkSelectAll = (CheckBox)e.Item.FindControl("chkSelectAll");
                        chkSelectAll.Visible = true;
                        Button btnCopySelected = (Button)e.Item.FindControl("btnCopySelected");
                        btnCopySelected.Visible = true;
                        Button btnMailSelected = (Button)e.Item.FindControl("btnMailSelected");
                        btnMailSelected.Visible = false;
                        Button btnMoveSelected = (Button)e.Item.FindControl("btnMoveSelected");
                        btnMoveSelected.Visible = false;
                    }
                    else if (ViewState["isMail"] != null && ViewState["isDelete"] == null)
                    {
                        Button btnDeleteSelected = (Button)e.Item.FindControl("btnDeleteSelected");
                        btnDeleteSelected.Visible = false;
                        Button btnCopySelected = (Button)e.Item.FindControl("btnCopySelected");
                        btnCopySelected.Visible = false;
                        Button btnMoveSelected = (Button)e.Item.FindControl("btnMoveSelected");
                        btnMoveSelected.Visible = false;
                        CheckBox chkSelectAll = (CheckBox)e.Item.FindControl("chkSelectAll");
                        chkSelectAll.Visible = true;
                        Button btnMailSelected = (Button)e.Item.FindControl("btnMailSelected");
                        btnMailSelected.Visible = true;

                    }
                    else if (ViewState["isMove"] != null && ViewState["isDelete"] == null)
                    {
                        Button btnDeleteSelected = (Button)e.Item.FindControl("btnDeleteSelected");
                        btnDeleteSelected.Visible = false;
                        Button btnCopySelected = (Button)e.Item.FindControl("btnCopySelected");
                        btnCopySelected.Visible = false;
                        CheckBox chkSelectAll = (CheckBox)e.Item.FindControl("chkSelectAll");
                        chkSelectAll.Visible = true;
                        Button btnMailSelected = (Button)e.Item.FindControl("btnMailSelected");
                        btnMailSelected.Visible = false;
                        Button btnMoveSelected = (Button)e.Item.FindControl("btnMoveSelected");
                        btnMoveSelected.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                Common.ErrorMessage(this, ex.ToString());
            }
        }
        protected void imgbtnCopy_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                ViewState["isCopy"] = true;
                ViewState["isDelete"] = null;
                //imgBtnPaste.Visible = true;
                SearchClear();
            }
            catch (Exception ex)
            {
                Common.ErrorMessage(this, ex.ToString());
            }
        }
        protected void imgBtnPaste_Click(object sender, ImageClickEventArgs e)
        {
            try
            {

                if (Session["CopiedFiles"] != null)
                {
                    bool isSameDir = false;
                    ArrayList CopiedFilesToSave = (ArrayList)Session["CopiedFiles"];
                    if (CopiedFilesToSave != null)
                    {

                        foreach (var strFromPath in CopiedFilesToSave)
                        {
                            ObjectSettingsClient oObjectMaster = new ObjectSettingsClient(ServiceConfig.ObjectSettingsEndPoint(), ServiceConfig.ObjectSettingsUri());
                            ObjectSettings.ObjectSettingsData insertObject = new ObjectSettings.ObjectSettingsData();
                            List<ObjectSettings.ObjectSettingsData> oList = new List<ObjectSettingsData>();
                            int VaultId = 0; string VaultPath = string.Empty;
                            oObjectMaster.GetVaultId(ViewState["LibraryId"].ToString().ToInt(), out VaultId, out VaultPath);
                            if (VaultPath != string.Empty)
                            {
                                Session["FilePath"] = VaultPath;
                            }
                            insertObject.VaultId = VaultId;
                            insertObject.CurrentVersion = 1;
                            insertObject.Description = string.Empty;
                            string strSourcePath = strFromPath.ToString();
                            string strTempFileName = Path.GetFileName(strSourcePath);
                            // To Get Exact File Name Here
                            int idx = strTempFileName.LastIndexOf('.');
                            int inEnd = idx - 18;
                            string strExtFileName = strTempFileName.Substring(0, inEnd);
                            string fileType = Path.GetExtension(strSourcePath);
                            string strFileType = fileType.Replace(".", string.Empty);
                            insertObject.FileType = strFileType;
                            string strDestinationPath = VaultPath + "\\" + strTempFileName;
                            if (strSourcePath != strDestinationPath)
                            {
                                if (!Directory.Exists(VaultPath))
                                {
                                    Directory.CreateDirectory(VaultPath);
                                }
                                File.Copy(strSourcePath, strDestinationPath, true);
                                insertObject.FilePath = strDestinationPath;
                                insertObject.FileSize = Convert.ToInt32(new System.IO.FileInfo(strDestinationPath).Length);
                                insertObject.Owner = Session["LoggedUser"].ToString();
                                insertObject.Status = chkStatus.Checked ? true : false;
                                insertObject.User = Session["LoggedUser"].ToString();
                                insertObject.LibraryId = ViewState["LibraryId"].ToString().ToInt();
                                if (ViewState["ObjectID"] != null)
                                {
                                    insertObject.ObjectId = ViewState["ObjectID"].ToString().ToInt();
                                }
                                insertObject.ObjectName = strExtFileName;
                                insertObject.ObjectType = "D";
                                string NewObjectId = string.Empty;
                                oObjectMaster.SaveObjects(insertObject, out NewObjectId);
                                isSameDir = true;
                            }
                        }
                    }
                    if (isSameDir)
                    {
                        Session["CopiedFiles"] = null;
                        Session["IsCopied"] = null;
                        imgBtnPaste.Visible = false;
                        ContensedRepeaterFill();
                        Common.SavedMessage(this, "Files copied successfully..!");
                    }
                    else
                    {
                        Common.ErrorMessage(this, "Select a different library to paste..!");
                    }
                }
                if (Session["MovingFiles"] != null)
                {
                    DataTable dtbl = (DataTable)Session["MovingFiles"];

                    if (dtbl != null)
                    {
                        for (int i = 0; i < dtbl.Rows.Count; i++)
                        {
                            ObjectSettingsClient oObjectMaster = new ObjectSettingsClient(ServiceConfig.ObjectSettingsEndPoint(), ServiceConfig.ObjectSettingsUri());
                            ObjectSettings.ObjectSettingsData insertObject = new ObjectSettings.ObjectSettingsData();
                            List<ObjectSettings.ObjectSettingsData> oList = new List<ObjectSettingsData>();
                            int VaultId = 0; string VaultPath = string.Empty;
                            oObjectMaster.GetVaultId(ViewState["LibraryId"].ToString().ToInt(), out VaultId, out VaultPath);
                            if (VaultPath != string.Empty)
                            {
                                Session["FilePath"] = VaultPath;
                            }
                            insertObject.VaultId = VaultId;
                            insertObject.CurrentVersion = 1;
                            insertObject.Description = string.Empty;
                            string strSourcePath = dtbl.Rows[i]["FilePath"].ToString();
                            string strTempFileName = Path.GetFileName(strSourcePath);
                            // To Get Exact File Name Here
                            int idx = strTempFileName.LastIndexOf('.');
                            int inEnd = idx - 18;
                            string strExtFileName = strTempFileName.Substring(0, inEnd);
                            string fileType = Path.GetExtension(strSourcePath);
                            string strFileType = fileType.Replace(".", string.Empty);
                            insertObject.FileType = strFileType;
                            string strDestinationPath = VaultPath + "\\" + strTempFileName;

                            if (!Directory.Exists(VaultPath))
                            {
                                Directory.CreateDirectory(VaultPath);
                            }
                            File.Move(strSourcePath, strDestinationPath);
                            insertObject.FilePath = strDestinationPath;
                            insertObject.FileSize = Convert.ToInt32(new System.IO.FileInfo(strDestinationPath).Length);
                            insertObject.Owner = Session["LoggedUser"].ToString();
                            insertObject.Status = chkStatus.Checked ? true : false;
                            insertObject.User = Session["LoggedUser"].ToString();
                            insertObject.LibraryId = ViewState["LibraryId"].ToString().ToInt();
                            insertObject.ObjectId = dtbl.Rows[i]["ObjectId"].ToString().ToInt();
                            insertObject.ObjectName = strExtFileName;
                            insertObject.ObjectType = "D";
                            string NewObjectId = string.Empty;
                            oObjectMaster.SaveObjects(insertObject, out NewObjectId);
                        }
                    }
                    Session["MovingFiles"] = null;
                    Session["IsMoving"] = null;
                    imgBtnPaste.Visible = false;
                    ContensedRepeaterFill();
                    Common.SavedMessage(this, "Files Moved successfully..!");
                }
            }
            catch (Exception ex)
            {
                Common.ErrorMessage(this, ex.ToString());
            }
        }
        private void ShoHideControlls(string mode)
        {
            if (mode == "Contensed")
            {
                imgBtndelete.Visible = true;
                imgbtnCopy.Visible = true;
                imgbtnMove.Visible = true;
                imgBtnEmail.Visible = true;
                imgBtnSelect.Visible = true;
            }
            else if (mode == "List")
            {
                imgBtndelete.Visible = false;
                imgbtnCopy.Visible = false;
                imgbtnMove.Visible = false;
                imgBtnEmail.Visible = false;
                imgBtnSelect.Visible = false;
            }
        }
        protected void imgbtnContensView_Click(object sender, ImageClickEventArgs e)
        {
            ContensedRepeaterFill();

        }
        protected void imgBtnDetaildView_Click(object sender, ImageClickEventArgs e)
        {
            DetaildGridFill();

        }
        protected void imgBtnHiddenSubmit_Click(object sender, ImageClickEventArgs e)
        {
            DetaildGridFill();
        }
        #endregion

        protected void grdDetaild_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Edit")
            {
                ViewState["ObjectID"] = e.CommandArgument.ToString().ToInt();
                FillDetails(ViewState["ObjectID"].ToString().ToInt());
            }
            else if (e.CommandName == "Delete")
            {
                ObjectSettings.ObjectSettingsClient oClient = new ObjectSettings.ObjectSettingsClient(ServiceConfig.ObjectSettingsEndPoint(), ServiceConfig.ObjectSettingsUri());
                oClient.DeleteObject(e.CommandArgument.ToString().ToInt());
                GridViewRow gvr = (GridViewRow)(((ImageButton)e.CommandSource).NamingContainer);
                int RowIndex = gvr.RowIndex;
                HiddenField hfPath = (HiddenField)grdDetaild.Rows[RowIndex].FindControl("hfPath");
                File.Delete(hfPath.Value);
                Common.SavedMessage(this, "Deleted successfully..!");
                DetaildGridFill();
            }
            else if (e.CommandName == "Download")
            {

            }
        }

        protected void grdDetaild_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {

        }

        protected void grdDetaild_RowEditing(object sender, GridViewEditEventArgs e)
        {
            //grdDetaild.EditIndex = e.NewEditIndex;
            //DetaildGridFill();
        }
        protected void grdDetaild_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grdDetaild.PageIndex = e.NewPageIndex;
            DetaildGridFill();
        }
        protected void grdDetaild_Sorting(object sender, GridViewSortEventArgs e)
        {
            if (Request.QueryString["Id"] != null)
            {
                ViewState["LibraryId"] = Request.QueryString["Id"].ToString();
                ObjectSettingsClient oClient = new ObjectSettingsClient(ServiceConfig.ObjectSettingsEndPoint(), ServiceConfig.ObjectSettingsUri());
                List<ObjectSettings.ObjectSettingsData> oList = new List<ObjectSettingsData>();
                oList = oClient.FillObjectsByLibrary(ViewState["LibraryId"].ToString().ToInt());
                DataTable dtSortTable = new DataTable();
                dtSortTable = Common.ToDataTable(oList);
                if (dtSortTable != null)
                {
                    DataView dvSortedView = new DataView(dtSortTable);
                    dvSortedView.Sort = e.SortExpression + " " + ViewState["SortDirection"].ToString();
                    grdDetaild.DataSource = dvSortedView;
                    grdDetaild.DataBind();

                    if (ViewState["SortDirection"] != null)
                    {
                        if (ViewState["SortDirection"].ToString() == "DESC")
                        {
                            ViewState["SortDirection"] = "ASC";
                        }
                        else
                        {
                            ViewState["SortDirection"] = "DESC";
                        }
                    }
                }
            }

        }
        protected void imgBtnEmail_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                ViewState["isCopy"] = null;
                ViewState["isDelete"] = null;
                ViewState["isMail"] = true;
                SearchClear();
            }
            catch (Exception ex)
            {
                Common.ErrorMessage(this, ex.ToString());
            }

        }
        protected void btnSendDocuments_Click(object sender, EventArgs e)
        {
            try
            {
                if (txtToAddress.Text != string.Empty)
                {
                    string[] Attachments = new string[10];
                    int k = 0;

                    for (int i = 0; i < rptrSearch.Items.Count; i++)
                    {
                        CheckBox chkSelect = (CheckBox)rptrSearch.Items[i].FindControl("chkSelect");
                        if (chkSelect.Checked && k <= 9)
                        {
                            HiddenField hfPath = (HiddenField)rptrSearch.Items[i].FindControl("hfPath");
                            Attachments[k] = hfPath.Value;
                            k++;
                        }
                        else
                        {
                            break;
                        }
                    }
                    SendDocuments(Attachments);
                }
                else
                {
                    Common.ErrorMessage(this, "To address should not be empty..");
                    txtToAddress.Focus();
                    MPEMailingDocuments.Show();
                }
            }
            catch (Exception ex)
            {
                Common.ErrorMessage(this, ex.ToString());
            }

        }
        private void SendDocuments(string[] Attachments)
        {
            UserProfiles.UserProfilesClient oClientUser = new UserProfiles.UserProfilesClient(ServiceConfig.UserProfilesDataEndPoint(), ServiceConfig.UserProfilesDataUri());
            string[] ToEmailIds = new string[1];
            string[] ccEmailIds = new string[1];
            string[] bccEmailIds = new string[1];
            ToEmailIds[0] = txtToAddress.Text;
            ccEmailIds[0] = txtccAddress.Text;
            bccEmailIds[0] = txtccAddress.Text;
            try
            {
                string SendMsg = oClientUser.SendMail(txtFromAddress.Text, ToEmailIds.ToList(), ccEmailIds.ToList(), bccEmailIds.ToList(), txtMailSubject.Text, txtMailBody.Text, Attachments.ToList());
                Common.SavedMessage(this, SendMsg);
            }
            catch (Exception ex)
            {
                Common.SavedMessage(this, "Mail delivery failure," + ex.Message + " Please try again..");
            }
        }

        protected void imgbtnMove_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                ViewState["isCopy"] = null;
                ViewState["isDelete"] = null;
                ViewState["isMail"] = null;
                ViewState["isMove"] = false;
                SearchClear();
            }
            catch (Exception ex)
            {
                Common.ErrorMessage(this, ex.ToString());
            }
        }

    }
}