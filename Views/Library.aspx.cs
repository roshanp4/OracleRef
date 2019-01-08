//******************************************************************************************************************************************** 
//* Project          : LiveDocServer - Views
//* Form / Page Name : Library.aspx.cs
//* Description      : This is the  Page for handling Library's.
//* Version          : 1.0 
//* Creation Date    : 20-10-2015
//* Created By       : Jaseel AM
//* Company Name     : Petroinfotech
//******************************************************************************************************************************************** 


using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Reflection;
using LDS.UtilityClass;
using System.IO;
using LDS.LibrarySettings;
using LDS.AttributeService;

namespace LDS.Views
{
    public partial class Library : System.Web.UI.Page
    {
        #region Private Methods

        private void Clear()
        {
            grdLibAttributes.DataSource = null;
            grdLibAttributes.DataBind();
            grdLibAttributesGroups.DataSource = null;
            grdLibAttributesGroups.DataBind();

            txtLibraryName.Focus();
            ViewState["LibraryId"] = null;
            txtLibraryName.Text = string.Empty;
            txtDescription.Text = string.Empty;
            ParrentFill();
            ddlParrent.SelectedIndex = 0;
            chkStatus.Checked = true;
            FillStyle(ddlStyle);
            AttributeClear();

            /*----- From Group-----*/
            AttributeGroupClear();
            mvAdmin.SetActiveView(VWAdd);
            chkDefault.Checked = false;
        }
        private void ParrentFill()
        {
            LibrarySettings.LibrarySettingsClient oLibSett = new LibrarySettings.LibrarySettingsClient(ServiceConfig.LibraryDataEndPoint(), ServiceConfig.LibraryDataUri());
            List<LibrarySettings.LibraryData> oData = new List<LibrarySettings.LibraryData>();
            oData = oLibSett.GetLibraryAll();
            ddlParrent.DataSource = oData;
            ddlParrent.DataTextField = "LibraryName";
            ddlParrent.DataValueField = "LibraryId";
            ddlParrent.DataBind();
            ddlParrent.Items.Insert(0, new ListItem("---select---", "0"));

        }
        private string IconUpload()
        {
            string strFileName = string.Empty;
            if (fupIconImg.FileName != "")
            {
                string strTick = DateTime.Now.Ticks.ToString();
                string str = fupIconImg.FileName;
                string[] tokens = str.Split('.');
                string last = tokens[tokens.Length - 1];
                string Extension = str.Substring(str.LastIndexOf('.') + 1);
                string pathImages = Server.MapPath(@"~\UploadedImages\IconImages");
                string FileName = tokens[0];
                if (!Directory.Exists(pathImages))
                {
                    Directory.CreateDirectory(pathImages);
                }
                fupIconImg.PostedFile.SaveAs(pathImages + "\\" + FileName + strTick + "." + Extension);
                strFileName = FileName + strTick + "." + Extension;
            }
            return strFileName;
        }
        private void SearchClear()
        {
            txtSearch.Text = string.Empty;
            ViewState["SortDirection"] = "ASC";
            mvAdmin.SetActiveView(VWSearch);
            txtSearch.Focus();
            SearchGridFill();
        }
        private void SearchGridFill()
        {
            LibrarySettingsClient oClient = new LibrarySettingsClient(ServiceConfig.LibraryDataEndPoint(), ServiceConfig.LibraryDataUri());
            grdSearch.DataSource = oClient.GetLibrarySearch(txtSearch.Text.Trim());
            grdSearch.DataBind();
        }
        private void SaveOrEdit()
        {
            string strMessage = string.Empty, NewLibraryId;
            LibrarySettingsClient oLibraryMaster = new LibrarySettingsClient(ServiceConfig.LibraryDataEndPoint(), ServiceConfig.LibraryDataUri());
            LibrarySettings.LibraryData insertLibrary = new LibrarySettings.LibraryData();
            insertLibrary.Description = txtDescription.Text.Trim();
            insertLibrary.IconName = IconUpload();
            insertLibrary.InsertBy = Session["LoggedUser"].ToString();
            insertLibrary.LibraryName = txtLibraryName.Text.Trim();
            insertLibrary.Owner = Session["LoggedUser"].ToString();
            insertLibrary.ParentId = ddlParrent.SelectedValue.ToInt();
            insertLibrary.Status = chkStatus.Checked ? true : false;
            insertLibrary.User = Session["LoggedUser"].ToString();
            if (ViewState["LibraryId"] != null)
            {
                insertLibrary.LibraryId = ViewState["LibraryId"].ToString().ToInt();
            }
            strMessage = oLibraryMaster.SaveLibrary(insertLibrary, out NewLibraryId);
            ViewState["LibraryId"] = NewLibraryId;
            Common.SavedMessage(this, strMessage);
            FillLibraryAttributes();
            // Call the user controll Library fill function here to add new Librarys into the tree
            UserControls.LMenu control = (UserControls.LMenu)FindControl("LMenu");
            control.PopulateMenuDataTable();
            AttributeClear();
            AttributeGroupClear();
        }
        public void RetrieveLibraryDetails(int CurrentIndex)
        {
            if (grdSearch.Rows.Count > 0)
            {
                ParrentFill();
                mvAdmin.SetActiveView(VWAdd);
                GridViewRow row = grdSearch.Rows[0];
                Label lblLibraryId = (Label)grdSearch.Rows[CurrentIndex].FindControl("lblLibraryId");
                Label lblLibraryName = (Label)grdSearch.Rows[CurrentIndex].FindControl("lblLibraryName");
                Label lblDescription = (Label)grdSearch.Rows[CurrentIndex].FindControl("lblDescription");
                CheckBox chkStatusgrd = (CheckBox)grdSearch.Rows[CurrentIndex].FindControl("chkStatus");
                HiddenField hfParrentId = (HiddenField)grdSearch.Rows[CurrentIndex].FindControl("hfParrentId");
                ViewState["LibraryId"] = lblLibraryId.Text;
                txtLibraryName.Text = lblLibraryName.Text;
                txtDescription.Text = lblDescription.Text;
                chkStatus.Checked = chkStatusgrd.Checked ? true : false;
                ddlParrent.SelectedValue = hfParrentId.Value;
                AttributeClear();
                AttributeGroupClear();

            }
        }
        #endregion

        #region Events

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["Mode"] != null)
                {
                    string strMode = Request.QueryString["Mode"].ToString();
                    if (strMode == "S")
                    {
                        SearchClear();
                    }
                    else
                    {
                        Clear();
                    }
                }
            }
        }
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            try
            {
                SearchClear();
            }
            catch (Exception)
            {

                throw;
            }
        }

        protected void btnCreate_Click(object sender, EventArgs e)
        {
            try
            {
                Clear();
            }
            catch (Exception)
            {

                throw;
            }
        }
        protected void grdSearch_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            grdSearch.EditIndex = -1;
            SearchGridFill();
        }
        protected void grdSearch_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Edit")
            {
                int Index = Convert.ToInt32(e.CommandArgument);
                RetrieveLibraryDetails(Index);
            }
            if (e.CommandName.Equals("Delete"))
            {
                string strMsg;
                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = grdSearch.Rows[index];
                Label lblLibraryId = (Label)grdSearch.Rows[Convert.ToInt32(e.CommandArgument)].FindControl("lblLibraryId");
                LibrarySettingsClient oLibMaster = new LibrarySettingsClient(ServiceConfig.LibraryDataEndPoint(), ServiceConfig.LibraryDataUri());
                LibrarySettings.LibraryData oDeleteLibrary = new LibrarySettings.LibraryData();
                oDeleteLibrary.LibraryId = lblLibraryId.Text.ToInt();
                strMsg = oLibMaster.DeleteLibraryMaster(oDeleteLibrary);
                SearchClear();
                Common.NotificationMessage(this, strMsg);
            }
        }

        protected void grdSearch_RowEditing(object sender, GridViewEditEventArgs e)
        {
            grdSearch.EditIndex = e.NewEditIndex;
            SearchGridFill();
        }
        protected void grdSearch_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grdSearch.PageIndex = e.NewPageIndex;
            SearchGridFill();
        }
        protected void grdSearch_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {

        }
        protected void grdSearch_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {

        }
        protected void grdSearch_Sorting(object sender, GridViewSortEventArgs e)
        {
            LibrarySettingsClient oClient = new LibrarySettingsClient(ServiceConfig.LibraryDataEndPoint(), ServiceConfig.LibraryDataUri());
            List<LibrarySettings.LibraryData> oList = new List<LibraryData>();
            oList = oClient.GetLibrarySearch(txtSearch.Text.Trim());
            DataTable dtSortTable = new DataTable();
            dtSortTable = Common.ToDataTable(oList);
            if (dtSortTable != null)
            {
                DataView dvSortedView = new DataView(dtSortTable);
                dvSortedView.Sort = e.SortExpression + " " + ViewState["SortDirection"].ToString();
                grdSearch.DataSource = dvSortedView;
                grdSearch.DataBind();

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
        protected void btnReset_Click(object sender, EventArgs e)
        {
            Clear();
        }
        protected void btnSave_Click(object sender, EventArgs e)
        {

            if (Common.CheckImageExtension(Common.GetExtension(fupIconImg.FileName)))
            {
                SaveOrEdit();
            }
            else
            {
                Common.ErrorMessage(this, "Invalied file format. support only image files");
            }

        }
        protected void btnSearchItems_Click(object sender, EventArgs e)
        {
            SearchGridFill();
        }
        protected void imgReset_Click(object sender, ImageClickEventArgs e)
        {
            SearchClear();
        }
        protected void ddlPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            grdSearch.PageSize = Convert.ToInt16(ddlPageSize.SelectedValue);
            SearchGridFill();
        }
        #endregion

        #region Attribute List Tab
        string AttrType;
        private void AttributeClear()
        {
            ViewState["AttributeId"] = null;
            txtAttributeName.Text = string.Empty;
            txtDescription.Text = string.Empty;
            ddlAttributeType.SelectedIndex = 0;
            chkAttributeStatus.Checked = true;
            txtAttributeName.Focus();
            FillStyle(ddlStyle);
            ddlStyle.SelectedIndex = 0;
            txtListValues.Text = string.Empty;
            txtDefaultValue.Text = string.Empty;
            listVal.Visible = false;
            chkInhMand.Checked = false;
            chkValMan.Checked = false;
            chkDefault.Checked = false;
            DivdefaultVal.Visible = false;
            FillSystemAttributes();
            FillLibraryAttributes();
        }
        public void FillStyle(DropDownList ddlStyle)
        {
            DataTable dtbl = new DataTable();
            dtbl.Columns.Add("Value");
            dtbl.Columns.Add("Text");
            dtbl.Rows.Add();
            dtbl.Rows[0]["Value"] = "TB";
            dtbl.Rows[0]["Text"] = "Text Box";
            dtbl.Rows.Add();
            dtbl.Rows[1]["Value"] = "CB";
            dtbl.Rows[1]["Text"] = "Check box";
            dtbl.Rows.Add();
            dtbl.Rows[2]["Value"] = "DL";
            dtbl.Rows[2]["Text"] = "Dropdown List";
            dtbl.Rows.Add();
            dtbl.Rows[3]["Value"] = "CL";
            dtbl.Rows[3]["Text"] = "Checkbox List";
            dtbl.Rows.Add();
            dtbl.Rows[4]["Value"] = "DT";
            dtbl.Rows[4]["Text"] = "DateTime Picker";
            dtbl.Rows.Add();
            dtbl.Rows[5]["Value"] = "NB";
            dtbl.Rows[5]["Text"] = "Number";
            dtbl.Rows.Add();
            dtbl.Rows[6]["Value"] = "RB";
            dtbl.Rows[6]["Text"] = "Radio Button";
            dtbl.Rows.Add();
            dtbl.Rows[7]["Value"] = "HL";
            dtbl.Rows[7]["Text"] = "Hyper Link";
            ddlStyle.DataSource = dtbl;
            ddlStyle.DataTextField = "Text";
            ddlStyle.DataValueField = "Value";
            ddlStyle.DataBind();

        }
        private void AttributeSaveOrEdit()
        {
            string strMsg, NewAttrId;
            AttributeService.AttributeSettingsClient oClient = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            AttributeService.AttributeSettingsData oAttributeSettingsData = new AttributeSettingsData();
            oAttributeSettingsData.AttributeId = ViewState["AttributeId"] == null ? 0 : Convert.ToInt16(ViewState["AttributeId"].ToString());
            oAttributeSettingsData.AttributeName = txtAttributeName.Text;
            oAttributeSettingsData.Style = ddlStyle.SelectedValue;
            oAttributeSettingsData.Description = txtAttrDescription.Text.Trim();
            string strTest = ddlAttributeType.SelectedItem.Text;
            string[] saTest = strTest.Split(' ');
            foreach (string strWord in saTest)
            {
                AttrType = (strWord.Substring(0, 1));
            }
            oAttributeSettingsData.AttributeType = AttrType;
            if (chkAttributeStatus.Checked == true)
                oAttributeSettingsData.AttributeStatus = true;
            else
                oAttributeSettingsData.AttributeStatus = false;
            if (chkDefault.Checked)
            {
                oAttributeSettingsData.DefaultValFlag = true;
                oAttributeSettingsData.DefaultVal = txtDefaultValue.Text.Trim();
                if (txtDefaultValue.Text == string.Empty)
                {
                    string txt = txtListValues.Text;
                    string[] lst = txt.Split(new Char[] { '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries);
                    if (lst.Length > 0)
                    {
                        oAttributeSettingsData.DefaultVal = lst[0];
                    }
                }
            }
            else
            {
                oAttributeSettingsData.DefaultValFlag = false;
                oAttributeSettingsData.DefaultVal = string.Empty;
            }

            if (chkInhMand.Checked)
                oAttributeSettingsData.IsInhMandatory = true;
            else
                oAttributeSettingsData.IsInhMandatory = false;

            if (chkValMan.Checked)
                oAttributeSettingsData.IsValueMandatory = true;
            else
                oAttributeSettingsData.IsValueMandatory = false;
            oAttributeSettingsData.LibraryId = ViewState["LibraryId"].ToString().ToInt();
            oAttributeSettingsData.CreatedBy = Session["LoggedUser"].ToString();
            oAttributeSettingsData.CreatedDate = System.DateTime.Now;
            oAttributeSettingsData.Updatedby = Session["LoggedUser"].ToString();
            oAttributeSettingsData.UpdatedDate = System.DateTime.Now;
            oAttributeSettingsData.User = Session["LoggedUser"].ToString();
            strMsg = oClient.SaveAttribute(oAttributeSettingsData, out NewAttrId);
            if (listVal.Visible)
            {
                SaveListDetails(NewAttrId);
            }
            Common.SavedMessage(this, strMsg);
            FillLibraryAttributes();
        }
        private void SaveListDetails(string inId)
        {
            AttributeService.AttributeSettingsClient oClient = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            AttributeService.AttributeSettingsData oAttributeSettingsData = new AttributeSettingsData();
            oAttributeSettingsData.AttributeId = inId.ToInt();
            oClient.DeleteAttributeListVal(oAttributeSettingsData);
            string txt = txtListValues.Text;
            string[] lst = txt.Split(new Char[] { '\n', '\r' }, StringSplitOptions.RemoveEmptyEntries);
            if (lst.Length > 0)
            {
                for (int i = 0; i < lst.Length - 1; i++)
                {
                    oAttributeSettingsData.ListVal = lst[i];
                    oAttributeSettingsData.Updatedby = Session["LoggedUser"].ToString();
                    oClient.SaveAttributeListVal(oAttributeSettingsData);
                }
            }
        }
        private void FillLibraryAttributes()
        {
            if (ViewState["LibraryId"] != null)
            {
                if (ViewState["LibraryId"].ToString().ToInt() != 0)
                {
                    AttributeSettingsClient oClient = new AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
                    grdLibAttributes.DataSource = oClient.GetAttributeByLibrary(ViewState["LibraryId"].ToString().ToInt(), false);
                    grdLibAttributes.DataBind();
                }
            }
        }
        private void FillSystemAttributes()
        {
            AttributeService.AttributeSettingsClient oClient = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            AttributeService.AttributeSettingsData oAttributeSettingsData = new AttributeSettingsData();
            List<AttributeSettingsData> AttributeSettingsDataTemp = new List<AttributeSettingsData>();
            AttributeSettingsDataTemp = oClient.GetAttributeByLibrary(ViewState["LibraryId"] == null ? 0 : ViewState["LibraryId"].ToString().ToInt(), true);
            cblSystemAttributes.DataSource = AttributeSettingsDataTemp;
            cblSystemAttributes.DataTextField = "AttributeName";
            cblSystemAttributes.DataValueField = "AttributeId";
            cblSystemAttributes.DataBind();
        }
        private void CopySystemAttributes()
        {
            AttributeService.AttributeSettingsClient oClient = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            AttributeService.AttributeSettingsData oAttributeSettingsData = new AttributeSettingsData();
            oAttributeSettingsData.LibraryId = ViewState["LibraryId"].ToString().ToInt();
            for (int i = 0; i < cblSystemAttributes.Items.Count; i++)
            {
                if (cblSystemAttributes.Items[i].Selected)
                {
                    var itemValue = cblSystemAttributes.Items[i].Value;
                    oAttributeSettingsData.AttributeId = cblSystemAttributes.Items[i].Value.ToInt();
                    oAttributeSettingsData.CreatedBy = Session["LoggedUser"].ToString();
                    oAttributeSettingsData.CreatedDate = System.DateTime.Now;
                    oClient.CopyAttributesToNew(oAttributeSettingsData);
                }
            }
            FillLibraryAttributes();
        }
        private void FillAttributesForEdit(string AttributeId)
        {
            FillStyle(ddlStyle);
            AttributeService.AttributeSettingsClient oClient = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            AttributeService.AttributeSettingsData oAttributeSettingsData = new AttributeSettingsData();
            List<AttributeSettingsData> AttributeSettingsDataTemp = new List<AttributeSettingsData>();
            AttributeSettingsDataTemp = oClient.GetAttributeListById(AttributeId);
            if (AttributeSettingsDataTemp.Count > 0)
            {
                txtAttributeName.Text = AttributeSettingsDataTemp[0].AttributeName;
                ddlAttributeType.SelectedItem.Text = AttributeSettingsDataTemp[0].AttributeType;
                chkAttributeStatus.Checked = AttributeSettingsDataTemp[0].AttributeStatus;
                txtDescription.Text = AttributeSettingsDataTemp[0].Description;
                ddlStyle.SelectedValue = AttributeSettingsDataTemp[0].StyleVal;
                if (AttributeSettingsDataTemp[0].DefaultValFlag)
                {
                    chkDefault.Checked = true;
                    txtDefaultValue.Text = AttributeSettingsDataTemp[0].DefaultVal;
                }
                else
                {
                    chkDefault.Checked = false;
                    DivdefaultVal.Visible = false;
                }
                if (AttributeSettingsDataTemp[0].IsValueMandatory)
                {
                    chkValMan.Checked = true;
                }
                if (AttributeSettingsDataTemp[0].IsInhMandatory)
                {
                    chkInhMand.Checked = true;
                }
                string a = string.Empty;
                AttributeService.AttributeSettingsClient oClientd = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
                AttributeService.AttributeSettingsData oAttributeSettingsDatad = new AttributeSettingsData();
                List<AttributeSettingsData> AttributeSettingsDataTempList = new List<AttributeSettingsData>();
                AttributeSettingsDataTempList = oClient.GetAttributesListValues(AttributeId.ToInt());
                if (AttributeSettingsDataTempList.Count > 0)
                {
                    string strText = string.Empty;
                    for (int i = 0; i < AttributeSettingsDataTempList.Count; i++)
                    {
                        strText += AttributeSettingsDataTempList[i].ListVal + "\n";
                    }
                    txtListValues.Text = strText;
                    listVal.Visible = true;
                    txtListValues.Visible = true;
                }
            }
        }

        protected void ddlStyle_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlStyle.SelectedValue == "DL" || ddlStyle.SelectedValue == "CL")
            {
                listVal.Visible = true;
            }
            else
            {
                listVal.Visible = false;
            }
            mpAttribute.Show();
        }
        protected void chkDefault_CheckedChanged(object sender, EventArgs e)
        {
            try
            {
                if (chkDefault.Checked)
                {
                    DivdefaultVal.Visible = true;

                }
                else
                {
                    DivdefaultVal.Visible = false;
                }
                mpAttribute.Show();
            }
            catch (Exception)
            {
                throw;
            }
        }
        protected void btnAttrSave_Click(object sender, EventArgs e)
        {
            if (ViewState["LibraryId"] != null)
            {
                AttributeSaveOrEdit();
                mpAttribute.Hide();
                Common.SavedMessage(this, "Attribute inserted successfully..");
            }
            else
            {
                mpAttribute.Hide();
                Common.ErrorMessage(this, "Create a library and add attributes..");
            }
        }
        protected void btnAttrReset_Click(object sender, EventArgs e)
        {
            AttributeClear();
            mpAttribute.Show();
        }
        protected void imgClose_Click(object sender, ImageClickEventArgs e)
        {
            AttributeClear();
            mpAttribute.Hide();
        }

        protected void grdLibAttributes_RowEditing(object sender, GridViewEditEventArgs e)
        {
            grdLibAttributes.EditIndex = e.NewEditIndex;
            FillLibraryAttributes();
            Label lblAttributeId = (Label)grdLibAttributes.Rows[e.NewEditIndex].FindControl("lblAttributeId");
            string AttributeId = lblAttributeId.Text.Trim();
            mpAttribute.Show();
            ViewState["AttributeId"] = AttributeId;
            FillAttributesForEdit(AttributeId);

        }
        protected void grdLibAttributes_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            string strMsg;
            int index = Convert.ToInt32(e.RowIndex);
            GridViewRow row = grdSearch.Rows[index];
            Label lblAttributeId = (Label)grdLibAttributes.Rows[Convert.ToInt32(e.RowIndex)].FindControl("lblAttributeId");
            AttributeService.AttributeSettingsClient oClient = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            AttributeService.AttributeSettingsData oData = new AttributeService.AttributeSettingsData();
            oData.AttributeId = lblAttributeId.Text.Trim().ToInt();
            strMsg = oClient.DeleteAttributeMaster(oData);
            Common.ErrorMessage(this, strMsg);
            FillLibraryAttributes();

        }
        protected void grdLibAttributes_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grdLibAttributes.PageIndex = e.NewPageIndex;
            FillLibraryAttributes();
        }
        protected void grdLibAttributes_Sorting(object sender, GridViewSortEventArgs e)
        {
            AttributeSettingsClient oClient = new AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            List<AttributeService.AttributeSettingsData> oList = new List<AttributeSettingsData>();
            oList = oClient.GetAttributeByLibrary(ViewState["LibraryId"].ToString().ToInt(), false);
            DataTable dtSortTable = new DataTable();
            dtSortTable = Common.ToDataTable(oList);
            if (dtSortTable != null)
            {
                DataView dvSortedView = new DataView(dtSortTable);
                dvSortedView.Sort = e.SortExpression + " " + ViewState["SortDirection"].ToString();
                grdLibAttributes.DataSource = dvSortedView;
                grdLibAttributes.DataBind();

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

        protected void btnSelectAttrReset_Click(object sender, EventArgs e)
        {
            for (int items = 0; items < cblSystemAttributes.Items.Count; items++)
            {
                cblSystemAttributes.ClearSelection();
            }
            mdpSelectAttr.Show();
        }
        protected void btnSelectAttrSubmit_Click(object sender, EventArgs e)
        {

            if (ViewState["LibraryId"] != null)
            {
                CopySystemAttributes();
            }
            else
            {
                Common.ErrorMessage(this, "Select an library first..!");
            }
        }
        #endregion

        #region Attribute Group Tab
        public void AttributeGroupClear()
        {
            chkbxStatus.Checked = true;
            txtGroupName.Text = string.Empty;
            lstGroupAttribute.Items.Clear();
            BindAttributes();
            FillLibraryAttributesGroups();
            FillSystemGroups();
            ViewState["GroupId"] = null;
        }
        private void FillLibraryAttributesGroups()
        {
            if (ViewState["LibraryId"] != null)
            {
                AttributeSettingsClient oClient = new AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
                grdLibAttributesGroups.DataSource = oClient.GetAttributeGroupByLibraryId(ViewState["LibraryId"].ToString().ToInt());
                grdLibAttributesGroups.DataBind();
            }
        }
        private void BindAttributes()
        {

            AttributeService.AttributeSettingsClient oClient = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            lstAllAttribute.DataSource = oClient.GetGroupAttributes(0,ViewState["LibraryId"] == null ? 0 : Convert.ToInt32(ViewState["LibraryId"].ToString().ToInt()), "A");
            lstAllAttribute.DataTextField = "AttributeName";
            lstAllAttribute.DataValueField = "AttributeId";
            lstAllAttribute.DataBind();
        }
        /// <summary>
        /// Its for Saving groups to GroupMaster and save its attrubutes to perticular
        /// </summary>
        protected void SaveAttributeGroup()
        {
            //First to add group ID to the Group Master tables
            string strMsg, NewGroupId;
            AttributeService.AttributeSettingsData objData = new AttributeSettingsData();
            objData.GroupId = ViewState["GroupId"] == null ? 0 : Convert.ToInt16(ViewState["GroupId"].ToString());
            objData.GroupName = txtGroupName.Text;
            // By default library id saving as 0
            objData.LibraryId = ViewState["LibraryId"].ToString().ToInt();
            if (chkbxStatus.Checked == true)
                objData.AttributeStatus = true;
            else
                objData.AttributeStatus = false;
            objData.User = Session["UserId"].ToString();
            AttributeService.AttributeSettingsClient objSave = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            strMsg = objSave.SaveAttributeGroupMaster(objData, out NewGroupId);
            //if the new Group ID is invalid / Having any validations error it should  return from here. 
            if (NewGroupId == "0")
            {
                Common.ErrorMessage(this, strMsg);
                return;
            }
            //second to Add perticular attributes to group
            AttributeService.AttributeSettingsClient objClient = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            string DeleteFlag = "Y";
            objData.GroupId = ViewState["GroupId"] == null ? 0 : Convert.ToInt16(ViewState["GroupId"].ToString());
            objData.AttributeId = 0;
            objData.DeleteFlag = DeleteFlag;
            objClient.SaveAttributeGroup(objData);
            foreach (ListItem itm in lstGroupAttribute.Items)
            {
                int AttributeId = Convert.ToInt16(itm.Value);
                int GroupId = Convert.ToInt16(NewGroupId);
                objData.GroupId = GroupId;
                objData.AttributeId = AttributeId;
                objData.DeleteFlag = DeleteFlag;

                if (DeleteFlag == "Y")
                {
                    DeleteFlag = "F";
                }
                objClient.SaveAttributeGroup(objData);
            }
        }
        protected void imgBtnAttrGrpClose_Click(object sender, ImageClickEventArgs e)
        {
            AttributeGroupClear();
            mdpAttrGroup.Hide();
        }
        /// <summary>
        /// Its for getting alternative backround colors for the list boxes
        /// </summary>
        private void GetAlternativeBackroundColorToListBox()
        {
            for (int i = 0; i < lstAllAttribute.Items.Count; i++)
            {
                if (i % 2 == 0)
                {
                    lstAllAttribute.Items[i].Attributes.Add("style", "color:Black;background-color:#f2f2f2;");
                }
            }
            for (int i = 0; i < lstGroupAttribute.Items.Count; i++)
            {
                if (i % 2 == 0)
                {
                    lstGroupAttribute.Items[i].Attributes.Add("style", "color:Black;background-color:#f2f2f2;");
                }
            }
        }
        private void FillSystemGroups()
        {
            AttributeService.AttributeSettingsClient oClient = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            AttributeService.AttributeSettingsData oAttributeSettingsData = new AttributeSettingsData();
            List<AttributeSettingsData> AttributeSettingsDataTemp = new List<AttributeSettingsData>();
            AttributeSettingsDataTemp = oClient.GetSysAttributeGroupByLibraryId(ViewState["LibraryId"] == null ? 0 : ViewState["LibraryId"].ToString().ToInt(), true);
            cblGroup.DataSource = AttributeSettingsDataTemp;
            cblGroup.DataTextField = "GroupName";
            cblGroup.DataValueField = "GroupId";
            cblGroup.DataBind();
        }
        private void CopySystemGroups()
        {
            AttributeService.AttributeSettingsClient oClient = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            AttributeService.AttributeSettingsData oAttributeSettingsData = new AttributeSettingsData();
            oAttributeSettingsData.LibraryId = ViewState["LibraryId"].ToString().ToInt();
            for (int i = 0; i < cblGroup.Items.Count; i++)
            {
                if (cblGroup.Items[i].Selected)
                {
                    var itemValue = cblGroup.Items[i].Value;
                    oAttributeSettingsData.GroupId = cblGroup.Items[i].Value.ToInt();
                    oAttributeSettingsData.CreatedBy = Session["LoggedUser"].ToString();
                    oAttributeSettingsData.CreatedDate = System.DateTime.Now;
                    oClient.CopyGroupsToNew(oAttributeSettingsData);
                }
            }
            FillLibraryAttributesGroups();
        }
        private void FillAttributesGroupForEdit()
        {
            AttributeService.AttributeSettingsClient oClient = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            int GroupId = ViewState["GroupId"].ToString().ToInt();
            lstAllAttribute.DataSource = oClient.GetGroupAttributes(GroupId, ViewState["LibraryId"] == null ? 0 : Convert.ToInt32(ViewState["LibraryId"].ToString().ToInt()), "A");
            lstAllAttribute.DataTextField = "AttributeName";
            lstAllAttribute.DataValueField = "AttributeId";
            lstAllAttribute.DataBind();
            for (int i = 0; i < lstAllAttribute.Items.Count; i++)
            {
                if (i % 2 == 0)
                {
                    lstAllAttribute.Items[i].Attributes.Add("style", "color:Black;background-color:#f2f2f2;");
                }
            }
            lstGroupAttribute.DataSource = oClient.GetGroupAttributes(GroupId, ViewState["LibraryId"] == null ? 0 : Convert.ToInt32(ViewState["LibraryId"].ToString().ToInt()), "Y");
            lstGroupAttribute.DataTextField = "AttributeName";
            lstGroupAttribute.DataValueField = "AttributeId";
            lstGroupAttribute.DataBind();

            AttributeService.AttributeSettingsData oAttributeSettingsData = new AttributeSettingsData();
            List<AttributeSettingsData> AttributeSettingsDataTemp = new List<AttributeSettingsData>();
            AttributeSettingsDataTemp = oClient.GetAttributeGroupById(ViewState["GroupId"].ToString().ToInt());
            if (AttributeSettingsDataTemp.Count > 0)
            {
                txtGroupName.Text = AttributeSettingsDataTemp[0].GroupName;
            }
            if (AttributeSettingsDataTemp[0].AttributeStatus)
            {
                chkbxStatus.Checked = true;
            }
        }
        protected void btntoRight_Click(object sender, EventArgs e)
        {
            GetAlternativeBackroundColorToListBox();
            if (lstGroupAttribute.Items.Contains(lstAllAttribute.SelectedItem))
            {
                //Error Msg
            }
            else
            {
                if (lstAllAttribute.SelectedValue != "")
                {
                    lstGroupAttribute.Items.Add(new ListItem(lstAllAttribute.SelectedItem.Text, lstAllAttribute.SelectedItem.Value));
                    lstAllAttribute.Items.Remove(new ListItem(lstAllAttribute.SelectedItem.Text, lstAllAttribute.SelectedItem.Value));
                }
            }
            mdpAttrGroup.Show();
        }
        protected void btntoleft_Click(object sender, EventArgs e)
        {
            GetAlternativeBackroundColorToListBox();
            if (lstAllAttribute.Items.Contains(lstGroupAttribute.SelectedItem))
            {
                //Error Msg
            }
            else
            {
                if (lstGroupAttribute.SelectedValue != "")
                {
                    lstAllAttribute.Items.Add(new ListItem(lstGroupAttribute.SelectedItem.Text, lstGroupAttribute.SelectedItem.Value));
                    lstGroupAttribute.Items.Remove(new ListItem(lstGroupAttribute.SelectedItem.Text, lstGroupAttribute.SelectedItem.Value));
                }
            }
            mdpAttrGroup.Show();
        }


        protected void btnAttrGrpSave_Click(object sender, EventArgs e)
        {
            if (ViewState["LibraryId"] != null)
            {
                SaveAttributeGroup();
                FillLibraryAttributesGroups();
            }
            else
            {
                Common.ErrorMessage(this, "Select a library first..!");
            }
        }
        protected void btnAttrGrpReset_Click(object sender, EventArgs e)
        {
            AttributeGroupClear();
            mdpAttrGroup.Show();
        }
        protected void grdLibAttributesGroups_RowEditing(object sender, GridViewEditEventArgs e)
        {
            grdLibAttributesGroups.EditIndex = e.NewEditIndex;
            FillLibraryAttributesGroups();
            Label lblGroupId = (Label)grdLibAttributesGroups.Rows[e.NewEditIndex].FindControl("lblGroupId");
            string GroupId = lblGroupId.Text.Trim();
            mdpAttrGroup.Show();
            ViewState["GroupId"] = GroupId;
            FillAttributesGroupForEdit();
            //ViewState["AttributeId"] = AttributeId;
            //FillAttributesForEdit(AttributeId);
            //Response.Redirect("~/Views/AttributeGroup.aspx?Id=" + GroupId + "&LibId=" + ViewState["LibraryId"]);
        }
        protected void grdLibAttributesGroups_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
            string strMsg;
            int index = Convert.ToInt32(e.RowIndex);
            GridViewRow row = grdSearch.Rows[index];
            Label lblGroupId = (Label)grdLibAttributesGroups.Rows[Convert.ToInt32(e.RowIndex)].FindControl("lblGroupId");
            AttributeService.AttributeSettingsClient oClient = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            AttributeService.AttributeSettingsData oData = new AttributeService.AttributeSettingsData();
            oData.GroupId = lblGroupId.Text.Trim().ToInt();
            strMsg = oClient.DeleteAttributeGroupMaster(oData);
            Common.ErrorMessage(this, strMsg);
            FillLibraryAttributesGroups();

        }
        protected void grdLibAttributesGroups_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grdLibAttributesGroups.PageIndex = e.NewPageIndex;
            FillLibraryAttributesGroups();
        }
        protected void grdLibAttributesGroups_Sorting(object sender, GridViewSortEventArgs e)
        {
            AttributeSettingsClient oClient = new AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            List<AttributeService.AttributeSettingsData> oList = new List<AttributeSettingsData>();
            oList = oClient.GetAttributeGroupByLibraryId(ViewState["LibraryId"].ToString().ToInt());
            DataTable dtSortTable = new DataTable();
            dtSortTable = Common.ToDataTable(oList);
            if (dtSortTable != null)
            {
                DataView dvSortedView = new DataView(dtSortTable);
                dvSortedView.Sort = e.SortExpression + " " + ViewState["SortDirection"].ToString();
                grdLibAttributesGroups.DataSource = dvSortedView;
                grdLibAttributesGroups.DataBind();

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
        protected void btnGroupSubmit_Click(object sender, EventArgs e)
        {
            if (ViewState["LibraryId"] != null)
            {
                CopySystemGroups();
            }
            else
            {
                Common.ErrorMessage(this, "Select an library first..!");
                AttributeGroupClear();
            }
        }
        protected void btnGroupReset_Click(object sender, EventArgs e)
        {
            for (int items = 0; items < cblSystemAttributes.Items.Count; items++)
            {
                cblGroup.ClearSelection();
            }
            mdpGroupSelect.Show();

        }
        #endregion
    }
}