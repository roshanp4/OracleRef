//******************************************************************************************************************************************** 
//* Project          : LiveDocServer - Views
//* Form / Page Name : AttributeGroup.aspx.cs
//* Description      : This is the  Page for handling Attribute Group.
//* Version          : 1.0 
//* Creation Date    : 06-Oct-2015
//* Created By       : Jaseel AM
//* Company Name     : Petroinfotech
//******************************************************************************************************************************************** 
//*********************************************************************************** 
//* State Management Variables 
//***********************************************************************************
//  1.  Session["UserId"] :- To check the role of the logged user.
//  2.  ViewState["SortDirection"] :- To get sort direction of grid
//*********************************************************



using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.IO;
using LDS.AttributeService;
using LDS.UtilityClass;
using System.Reflection;

namespace LDS
{
    public partial class AttributeGroup : System.Web.UI.Page
    {
        #region Private Methods
        public void Clear()
        {
            MVAttribute.SetActiveView(VWAdd);
            BindAttributes(-2);
            txtGroupName.Text = string.Empty;
            chkbxStatus.Checked = true;
            ViewState["GroupId"] = null;
            //  lblMsgGroupName.Visible = false;
            txtGroupName.Focus();
        }
        public void SearchClear()
        {
            MVAttribute.SetActiveView(VWSearch);
            txtGroupName.Text = string.Empty;
            chkbxStatus.Checked = false;
            ViewState["GroupId"] = null;
            SearchGridFill();
        }

        /// <summary>
        /// Its for binding all group details to grid view
        /// </summary>
        protected void SearchGridFill()
        {
            AttributeService.AttributeSettingsClient oClient = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            grdGroup.DataSource = oClient.GetAttributeGroupList(txtSearch.Text.Trim());
            grdGroup.DataBind();
        }
        /// <summary>
        /// Its for binding the listboxes initially and Bindling grid first row to the feilds
        /// </summary>
        protected void BindAttributes(int CurrentIndex)
        {
            int GroupId = 0;
            AttributeService.AttributeSettingsClient oClient = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            //divlistset.Visible = true;
            btnSubmit.Visible = true;
            if (grdGroup.Rows.Count > 0)
            {
                if (CurrentIndex != -2)
                {
                    GroupId = (int)this.grdGroup.DataKeys[CurrentIndex]["GroupId"];
                    string GroupName = (string)this.grdGroup.DataKeys[CurrentIndex]["GroupName"];
                    Label lblGroupIdItem = (Label)grdGroup.Rows[CurrentIndex].FindControl("lblGroupId");
                    Label lblGroupNameItem = (Label)grdGroup.Rows[CurrentIndex].FindControl("lblGroupName");
                    CheckBox chkStatusItem = (CheckBox)grdGroup.Rows[CurrentIndex].FindControl("chkStatus");
                    ViewState["GroupId"] = lblGroupIdItem.Text;
                    txtGroupName.Text = lblGroupNameItem.Text;
                    chkbxStatus.Checked = chkStatusItem.Checked;
                }
            }
            ViewState["GroupIdPublic"] = GroupId;
            lstAllAttribute.DataSource = oClient.GetGroupAttributes(GroupId,0, "A");
            lstAllAttribute.DataTextField = "AttributeName";
            lstAllAttribute.DataValueField = "AttributeId";
            lstAllAttribute.DataBind();

            for (int i = 0; i < lstAllAttribute.Items.Count; i++)
            {
                if (i % 2 == 0)
                {
                    lstAllAttribute.Items[i].Attributes.Add("style", "color:Black;background-color:#f2f2f2;");
                }
                else
                {
                    //lstAllAttribute.Items[i].Attributes.Add("style", "color:Black;background-color:seagreen;");
                }
            }
            lstGroupAttribute.DataSource = oClient.GetGroupAttributes(GroupId,0, "Y");
            lstGroupAttribute.DataTextField = "AttributeName";
            lstGroupAttribute.DataValueField = "AttributeId";
            lstGroupAttribute.DataBind();

            for (int i = 0; i < lstGroupAttribute.Items.Count; i++)
            {
                if (i % 2 == 0)
                {
                    lstGroupAttribute.Items[i].Attributes.Add("style", "color:Black;background-color:#f2f2f2;");
                }
                else
                {
                    //lstGroupAttribute.Items[i].Attributes.Add("style", "color:Black;background-color:seagreen;");
                }
            }
            //  lblMsgGroupName.Visible = true;
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
            objData.LibraryId = ViewState["LibraryId"] == null ? 0 : Convert.ToInt16(ViewState["LibraryId"].ToString());
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
            SearchClear();
            Common.SavedMessage(this, strMsg);
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
        private void FillDetails()
        {
            AttributeService.AttributeSettingsClient oClient = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            int GroupId = ViewState["GroupId"].ToString().ToInt();
            lstAllAttribute.DataSource = oClient.GetGroupAttributes(GroupId,0, "A");
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
            lstGroupAttribute.DataSource = oClient.GetGroupAttributes(GroupId,0, "Y");
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
        #endregion
        #region Events
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                MVAttribute.SetActiveView(VWSearch);
                if (!IsPostBack)
                {
                    ViewState["SortDirection"] = "DESC";
                    SearchGridFill();
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
        /// <summary>
        /// Next 2 event is the two buttons placed b/w the 2 listboxes(RightArrow,LeftArrow)
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
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
        }
        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            SaveAttributeGroup();
        }
        protected void btnReset_Click(object sender, EventArgs e)
        {
            Clear();
        }

        protected void grdGroup_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName.Equals("select_one"))
            {
                Clear();
                int RowIndex;
                RowIndex = int.Parse(e.CommandArgument.ToString());
                BindAttributes(RowIndex);
                HiddenField hfLibraryId = (HiddenField)grdGroup.Rows[Convert.ToInt32(e.CommandArgument)].FindControl("hfLibraryId");
                ViewState["LibraryId"] = hfLibraryId.Value;
            }
            if (e.CommandName.Equals("Delete"))
            {
                string strMsg;
                int RowIndex, GroupId;
                RowIndex = int.Parse(e.CommandArgument.ToString());
                GroupId = (int)this.grdGroup.DataKeys[RowIndex]["GroupId"];

                AttributeService.AttributeSettingsClient oClient = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
                AttributeService.AttributeSettingsData oData = new AttributeSettingsData();
                oData.GroupId = GroupId;
                strMsg = oClient.DeleteAttributeGroupMaster(oData);
                SearchGridFill();
                Common.ErrorMessage(this, strMsg);
            }

        }
        protected void grdGroup_RowDeleting(object sender, GridViewDeleteEventArgs e)
        {
        }
        protected void grdGroup_RowEditing(object sender, GridViewEditEventArgs e)
        {
        }
        protected void grdGroup_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {

        }
        protected void grdGroup_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
        }
        protected void grdGroup_PageIndexChanging(object sender, GridViewPageEventArgs e)
        {
            grdGroup.PageIndex = e.NewPageIndex;
            SearchGridFill();
        }
        protected void grdGroup_Sorting(object sender, GridViewSortEventArgs e)
        {
            AttributeService.AttributeSettingsClient oClient = new AttributeService.AttributeSettingsClient(ServiceConfig.AttributeSettingsDataEndPoint(), ServiceConfig.AttributeSettingsDataUri());
            List<AttributeService.AttributeSettingsData> oList = new List<AttributeSettingsData>();
            oList = oClient.GetAttributeGroupList(txtSearch.Text.Trim());
            DataTable dtSortTable = new DataTable();
            dtSortTable = Common.ToDataTable(oList);
            if (dtSortTable != null)
            {
                DataView dvSortedView = new DataView(dtSortTable);

                dvSortedView.Sort = e.SortExpression + " " + ViewState["SortDirection"].ToString();

                grdGroup.DataSource = dvSortedView;
                grdGroup.DataBind();

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
            grdGroup.PageSize = Convert.ToInt16(ddlPageSize.SelectedValue);
            SearchGridFill();
        }
        #endregion
    }
}