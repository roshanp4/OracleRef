//******************************************************************************************************************************************** 
//* Project          : LiveDocServer - Views
//* Form / Page Name : AttributeList.aspx.cs
//* Description      : This is the  Page for handling Attributes list.
//* Version          : 1.0 
//* Creation Date    : 5-10-2015
//* Created By       : Jaseel AM
//* Company Name     : Petroinfotech
//******************************************************************************************************************************************** 


using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using LDS.UtilityClass;
using LDS.AttributeService;
using System.Data;
using System.Text;
using System.IO;
using System.Web.UI.HtmlControls;


namespace LDS.Views
{
    public partial class AttributeList : System.Web.UI.Page
    {
        #region Varibales
        string AttrType;
        #endregion

        #region Methods
        private void Clear()
        {
            MVAttribute.SetActiveView(VWAdd);
            txtAttributeName.Text = string.Empty;
            txtDescription.Text = string.Empty;
            ddlAttributeType.SelectedIndex = 0;
            chkAttributeStatus.Checked = true;
            txtAttributeName.Focus();
            FillStyle();
            ddlStyle.SelectedIndex = 0;
            txtListValues.Text = string.Empty;
            txtDefaultValue.Text = string.Empty;
            listVal.Visible = false;
            chkInhMand.Checked = false;
            chkValMan.Checked = false;
            chkDefault.Checked = false;
            ViewState["LibraryId"] = 0;
            ViewState["AttributeId"] = null;
            chkDefault.Checked = false;
            DivdefaultVal.Visible = false;
        }
        public void FillStyle()
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
        private void SaveOrEdit()
        {
            string strMsg, NewAttrId;
            AttributeService.AttributeSettingsClient oClient = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            AttributeService.AttributeSettingsData oAttributeSettingsData = new AttributeSettingsData();
            oAttributeSettingsData.AttributeId = ViewState["AttributeId"] == null ? 0 : Convert.ToInt16(ViewState["AttributeId"].ToString());
            oAttributeSettingsData.AttributeName = txtAttributeName.Text;
            oAttributeSettingsData.Style = ddlStyle.SelectedValue;
            oAttributeSettingsData.Description = txtDescription.Text.Trim();
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
            // Library id set by default 0 here.
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
            SearchClear();


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
        private void SearchClear()
        {
            ViewState["SortDirection"] = "ASC";
            MVAttribute.SetActiveView(VWSearch);
            txtSearch.Text = string.Empty;
            SearchGridFill();
        }
        private void SearchGridFill()
        {
            AttributeSettingsClient oClient = new AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            grdAttribute.DataSource = oClient.GetFullAttributeList("A", txtSearch.Text.Trim());
            grdAttribute.DataBind();
        }
        //public void GetAttributeList(int CurrentIndex)
        //{
        //    if (grdAttribute.Rows.Count > 0)
        //    {
        //        Clear();
        //        GridViewRow row = grdAttribute.Rows[0];
        //        Label txtAttributeIdItem = (Label)grdAttribute.Rows[CurrentIndex].FindControl("lblAttributeId");
        //        Label txtAttributeNameItem = (Label)grdAttribute.Rows[CurrentIndex].FindControl("lblAttributeName");
        //        Label lblAttributeTypeItem = (Label)grdAttribute.Rows[CurrentIndex].FindControl("lblAttributeType");
        //        CheckBox chkAttributeStatusItem = (CheckBox)grdAttribute.Rows[CurrentIndex].FindControl("chkAttributeStatus");
        //        Label lblDescription = (Label)grdAttribute.Rows[CurrentIndex].FindControl("lblDescription");
        //        HiddenField hfStyle = (HiddenField)grdAttribute.Rows[CurrentIndex].FindControl("hfStyle");
        //        HiddenField hfDefaultVal = (HiddenField)grdAttribute.Rows[CurrentIndex].FindControl("hfDefaultVal");
        //        HiddenField hfDefaultValFlag = (HiddenField)grdAttribute.Rows[CurrentIndex].FindControl("hfDefaultValFlag");
        //        HiddenField hfValueMan = (HiddenField)grdAttribute.Rows[CurrentIndex].FindControl("hfIsValueMandatory");
        //        HiddenField hfInhMan = (HiddenField)grdAttribute.Rows[CurrentIndex].FindControl("hfIsInhMandatory");
        //        ViewState["AttributeId"] = txtAttributeIdItem.Text;
        //        txtAttributeName.Text = txtAttributeNameItem.Text;
        //        ddlAttributeType.SelectedItem.Text = lblAttributeTypeItem.Text;
        //        chkAttributeStatus.Checked = chkAttributeStatusItem.Checked;
        //        txtDescription.Text = lblDescription.Text;
        //        ddlStyle.SelectedValue = hfStyle.Value;
        //        if (hfDefaultValFlag.Value == "True")
        //        {
        //            chkDefault.Checked = true;
        //            txtDefaultValue.Text = hfDefaultVal.Value;
        //        }
        //        else
        //        {
        //            chkDefault.Checked = false;
        //            defaultVal.Visible = false;
        //        }
        //        if (hfValueMan.Value == "True")
        //        {
        //            chkValMan.Checked = true;
        //        }
        //        if (hfInhMan.Value == "True")
        //        {
        //            chkInhMand.Checked = true;
        //        }
        //        string a = string.Empty;
        //        AttributeService.AttributeSettingsClient oClient = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
        //        AttributeService.AttributeSettingsData oAttributeSettingsData = new AttributeSettingsData();
        //        List<AttributeSettingsData> AttributeSettingsDataTemp = new List<AttributeSettingsData>();
        //        AttributeSettingsDataTemp = oClient.GetAttributesListValues(ViewState["AttributeId"].ToString().ToInt());

        //        if (AttributeSettingsDataTemp.Count > 0)
        //        {
        //            string strText = string.Empty;
        //            for (int i = 0; i < AttributeSettingsDataTemp.Count; i++)
        //            {
        //                strText += AttributeSettingsDataTemp[i].ListVal + "\n";
        //            }
        //            txtListValues.Text = strText;
        //            listVal.Visible = true;
        //            txtListValues.Visible = true;
        //        }
        //    }
        //}
        private void FillDetails()
        {
            MVAttribute.SetActiveView(VWAdd);
            FillStyle();
            AttributeService.AttributeSettingsClient oClient = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            AttributeService.AttributeSettingsData oAttributeSettingsData = new AttributeSettingsData();
            List<AttributeSettingsData> AttributeSettingsDataTemp = new List<AttributeSettingsData>();
            AttributeSettingsDataTemp = oClient.GetAttributeListById(ViewState["AttributeId"].ToString());
            if (AttributeSettingsDataTemp.Count > 0)
            {
                ViewState["LibraryId"] = AttributeSettingsDataTemp[0].LibraryId;
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
                AttributeSettingsDataTempList = oClient.GetAttributesListValues(ViewState["AttributeId"].ToString().ToInt());
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
        #endregion

        #region Events

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                //if (Request.QueryString["Id"] != null && Request.QueryString["LibId"]!=null)
                //{                   
                //    Clear();
                //    ViewState["AttributeId"] = Request.QueryString["Id"];
                //    ViewState["LibraryId"] = Request.QueryString["LibId"];
                //    FillDetails();
                //}
                //else
                //{
                SearchClear();
                //}
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
            Clear();
        }
        protected void btnSearchItems_Click(object sender, EventArgs e)
        {
            SearchGridFill();
        }
        protected void grdAttribute_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            grdAttribute.EditIndex = -1;
            SearchGridFill();
        }
        protected void grdAttribute_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Edit")
            {
                int Index = Convert.ToInt32(e.CommandArgument);
                Label lblAttributeId = (Label)grdAttribute.Rows[Convert.ToInt32(e.CommandArgument)].FindControl("lblAttributeId");
                HiddenField hfLibraryId = (HiddenField)grdAttribute.Rows[Convert.ToInt32(e.CommandArgument)].FindControl("hfLibraryId");
                ViewState["AttributeId"] = lblAttributeId.Text.Trim();
                ViewState["LibraryId"] = hfLibraryId.Value;
                FillDetails();
            }
            if (e.CommandName == "Delete")
            {
                string strMsg;
                int index = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = grdAttribute.Rows[index];
                int AttributeId;
                Label lblAttributeIditem = (Label)grdAttribute.Rows[Convert.ToInt32(e.CommandArgument)].FindControl("lblAttributeId");
                AttributeId = Convert.ToInt16(lblAttributeIditem.Text);
                AttributeService.AttributeSettingsClient oClient = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
                AttributeService.AttributeSettingsData oData = new AttributeService.AttributeSettingsData();
                oData.AttributeId = AttributeId;
                strMsg = oClient.DeleteAttributeMaster(oData);
                SearchClear();
                Common.NotificationMessage(this, strMsg);
            }
        }
        protected void grdAttribute_RowEditing(object sender, GridViewEditEventArgs e)
        {
            grdAttribute.EditIndex = e.NewEditIndex;
            SearchGridFill();
        }
        protected void grdAttribute_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grdAttribute.PageIndex = e.NewPageIndex;
            SearchGridFill();
        }
        protected void grdAttribute_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {

        }
        protected void grdAttribute_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {

        }
        protected void grdAttribute_Sorting(object sender, GridViewSortEventArgs e)
        {
            AttributeSettingsClient oClient = new AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            List<AttributeService.AttributeSettingsData> oList = new List<AttributeSettingsData>();
            oList = oClient.GetFullAttributeList("A", "");
            DataTable dtSortTable = new DataTable();
            dtSortTable = Common.ToDataTable(oList);
            if (dtSortTable != null)
            {
                DataView dvSortedView = new DataView(dtSortTable);

                dvSortedView.Sort = e.SortExpression + " " + ViewState["SortDirection"].ToString();

                grdAttribute.DataSource = dvSortedView;
                grdAttribute.DataBind();

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
        protected void btnsubmit_Click(object sender, EventArgs e)
        {
            SaveOrEdit();
        }
        protected void btnReset_Click(object sender, EventArgs e)
        {
            Clear();
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
            }
            catch (Exception)
            {
                throw;
            }
        }
        protected void ddlStyle_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlStyle.SelectedValue == "DL" || ddlStyle.SelectedValue == "CL")
            {
                listVal.Visible = true;
                //defaultVal.Visible = false;
                //chkDefault.Checked = false;
                //chkDefault.Enabled = false;
            }
            else
            {
                //chkDefault.Checked = true;
                listVal.Visible = false;
                //defaultVal.Visible = true;
                //chkDefault.Enabled = true;
            }
        }
        protected void imgReset_Click(object sender, ImageClickEventArgs e)
        {
            SearchClear();
        }
        protected void ddlPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            grdAttribute.PageSize = Convert.ToInt16(ddlPageSize.SelectedValue);
            SearchGridFill();
        }
        protected void ddlAttributeType_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlAttributeType.SelectedIndex == 2 || ddlAttributeType.SelectedIndex == 1)
            {
                ddlStyle.SelectedIndex = 5;
            }
            else if (ddlAttributeType.SelectedIndex == 3)
            {
                ddlStyle.SelectedIndex = 4;
            }
            else 
            {
                ddlStyle.SelectedIndex = 0;
            }
        }    
        #endregion
    }
}