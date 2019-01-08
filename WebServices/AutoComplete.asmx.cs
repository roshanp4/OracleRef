using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Data;
using System.Globalization;
using System.Reflection;
using LDS.UtilityClass;

namespace LDS.WebServices
{
    /// <summary>
    /// Summary description for AutoComplete
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [System.ComponentModel.ToolboxItem(false)]
    // To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line. 
    [System.Web.Script.Services.ScriptService]
    public class AutoComplete : System.Web.Services.WebService
    {

        [WebMethod]
        public string[] getAutoList(string prefixText, int count, string contextKey)
        {
            DataTable dtUsers = null;
            count = 100;
            List<string> autoList = new List<string>(count);
            if (!prefixText.StartsWith("%"))
            {
                dtUsers = GetUserList(prefixText.ToString().Trim()); //SampleData().Tables[0];// 
                using (dtUsers)
                {
                    for (int i = 0; i <= dtUsers.Rows.Count - 1; i++)
                    {
                        autoList.Add(AjaxControlToolkit.AutoCompleteExtender.CreateAutoCompleteItem(Convert.ToString(dtUsers.Rows[i]["UserId"]), Convert.ToString(dtUsers.Rows[i]["UserId"])));
                        if (i > count)
                            break; // TODO: might not be correct. Was : Exit For
                    }
                }
            }
            return autoList.ToArray();
        }
        DataTable GetUserList(string prefixText)
        {
            DataTable dtset = new DataTable();
            LDS.UserProfiles.UserProfilesClient oUser = new LDS.UserProfiles.UserProfilesClient(ServiceConfig.UserProfilesDataEndPoint(), ServiceConfig.UserProfilesDataUri());
            List<LDS.UserProfiles.UserProfilesData> oUserList = new List<LDS.UserProfiles.UserProfilesData>();
            oUserList = oUser.GetUsersFromDirectory(prefixText);
            var oUserListTemp = from p in oUserList where p.UserId.ToString().ToUpper().StartsWith(prefixText.ToUpper()) || p.EmployeeName.ToString().ToUpper().StartsWith(prefixText.ToUpper()) select p;
            dtset = Common.ToDataTable(oUserListTemp.ToList());
            return dtset;
        }
    }
}
