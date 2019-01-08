using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.Data;
using System.Data.OracleClient;
using LDSFileService.ServiceClassLibrary;

namespace LDSFileService.ServiceLibrary
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "AppSettings" in code, svc and config file together.
    // NOTE: In order to launch WCF Test Client for testing this service, please select AppSettings.svc or AppSettings.svc.cs at the Solution Explorer and start debugging.
    public class AppSettings : IAppSettings
    {
        string connectionString = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["DbLDS"].ToString();

        /// <summary>
        /// THIS IS TO GET THE RIGHT SIDE PANE RELATED DATA COUNT & COLOR AGAINST EACH LINK/MODULE
        /// </summary>
        /// <returns></returns>
        /// 
        public int GetSessionId()
        {
            int SessionId = 0;
            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleParameter p_session_id = new OracleParameter("an_session_id", OracleType.Int32);
                OracleCommand objCmd = new OracleCommand("sw_pkg_user.p_get_session_id", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.Add(p_session_id).Direction = ParameterDirection.Output;
                objConn.Open();
                objCmd.ExecuteScalar();
                objConn.Close();
                SessionId = int.Parse(p_session_id.Value.ToString());
            }
            return SessionId;


        }
        public IList<AppSettingsData> GetRelatedDataCount(IList<AppSettingsData> oAppSettingParams)
        {

            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {

                OracleCommand objCmd = new OracleCommand("sw_sp_get_screen_desc_count", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.AddWithValue("as_uwbi", oAppSettingParams.ElementAt(0).uwbi);
                objCmd.Parameters.AddWithValue("as_level", oAppSettingParams.ElementAt(0).RowLevel);
                objCmd.Parameters.AddWithValue("as_module", oAppSettingParams.ElementAt(0).ScreenModule);
                objCmd.Parameters.AddWithValue("as_user", oAppSettingParams.ElementAt(0).UserName);
                objCmd.Parameters.Add("p_cur_screen_desc", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }
            AppSettingsData OutTemp = new AppSettingsData();
            List<AppSettingsData> AppSettingsTemp = new List<AppSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                OutTemp.uwbi = oAppSettingParams.ElementAt(0).uwbi;
                OutTemp.ScreenCode = dr["SCREEN_CODE"].ToString();
                OutTemp.ScreenName = dr["SCREEN_NAME"].ToString();
                OutTemp.RowLevel = oAppSettingParams.ElementAt(0).RowLevel;
                OutTemp.ColorCode = dr["MENU_COLOR"].ToString();
                AppSettingsTemp.Add(OutTemp);
                OutTemp = new AppSettingsData();
            }

            AppSettingsTemp.Cast<AppSettingsData>().ToList();
            return AppSettingsTemp;

        }
        public IList<AppSettingsData> GetCodeGroup()
        {
            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("ld_pkg_system_setting.p_get_code_group", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.Add("p_cur_groups", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }
            AppSettingsData OutTemp = new AppSettingsData();
            List<AppSettingsData> CodesTemp = new List<AppSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                OutTemp.GroupName = Convert.ToString(dr["GROUP_NAME"]);
                CodesTemp.Add(OutTemp);
                OutTemp = new AppSettingsData();
            }

            CodesTemp.Cast<AppSettingsData>().ToList();
            return CodesTemp;
        }
        public IList<AppSettingsData> GetParentList(string GroupName)
        {
            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("ld_pkg_system_setting.p_get_parent_code_list", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.Add("as_group_name", OracleType.VarChar).Value = GroupName;
                objCmd.Parameters.Add("p_cur_codes", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }
            AppSettingsData OutTemp = new AppSettingsData();
            List<AppSettingsData> CodesTemp = new List<AppSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                OutTemp.CodesCode = Convert.ToString(dr["code"]);
                OutTemp.CodeDescription = Convert.ToString(dr["description"]);
                CodesTemp.Add(OutTemp);
                OutTemp = new AppSettingsData();
            }

            CodesTemp.Cast<AppSettingsData>().ToList();
            return CodesTemp;
        }
        public IList<AppSettingsData> GetCodeList(string GroupName)
        {
            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("ld_pkg_system_setting.p_get_code_list", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.Add("as_group_name", OracleType.VarChar).Value = GroupName;
                objCmd.Parameters.Add("p_cur_codes", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }
            AppSettingsData OutTemp = new AppSettingsData();
            List<AppSettingsData> CodesTemp = new List<AppSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                OutTemp.Parent_Flag = Convert.ToString(dr["parent_flag"]);
                OutTemp.GroupName = Convert.ToString(dr["GROUP_NAME"]);
                OutTemp.CodesCode = dr["code"].ToString();
                OutTemp.CodeActive = dr["code_active"].ToString().Equals("Y");
                OutTemp.CodeDescription = dr["description"].ToString();
                OutTemp.DisplaySeq = Convert.ToInt16(dr["display_seq"].ToString());
                OutTemp.Parent_Code = dr["parent_code"].ToString();
                CodesTemp.Add(OutTemp);
                OutTemp = new AppSettingsData();
            }

            CodesTemp.Cast<AppSettingsData>().ToList();
            return CodesTemp;
        }
        public IList<AppSettingsData> GetCodes(string GroupName, string parent)
        {
            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("ld_pkg_system_setting.p_get_drop_down_list", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.AddWithValue("as_group_name", Convert.ToString(GroupName));
                objCmd.Parameters.AddWithValue("as_parent", Convert.ToString(parent));
                objCmd.Parameters.Add("p_cur_codes", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }
            AppSettingsData OutTemp = new AppSettingsData();
            List<AppSettingsData> CodesTemp = new List<AppSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                OutTemp.CodesCode = Convert.ToString(dr["CODE"]);
                OutTemp.CodeDescription = Convert.ToString(dr["DESCRIPTION"]);
                OutTemp.GroupName = Convert.ToString(dr["GROUP_NAME"]);
                OutTemp.CodeActive = Convert.ToString(dr["CODE_ACTIVE"]).Equals("Y");
                OutTemp.DisplaySeq = Convert.ToInt16(dr["DISPLAY_SEQ"].ToString());

                CodesTemp.Add(OutTemp);
                OutTemp = new AppSettingsData();
            }

            CodesTemp.Cast<AppSettingsData>().ToList();
            return CodesTemp;
        }
        public IList<AppSettingsData> GetFields(string CountryCode)
        {
            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("sw_sp_Get_Fields", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.Add("p_CountryCode", OracleType.VarChar).Value = CountryCode;
                objCmd.Parameters.Add("p_cur_Fields", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }
            AppSettingsData OutTemp = new AppSettingsData();
            List<AppSettingsData> FieldsTemp = new List<AppSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                OutTemp.FieldCode = dr["FIELD_CODE"].ToString();
                OutTemp.FieldName = dr["FIELD_NAME"].ToString();
                OutTemp.FieldShortName = dr["FIELD_SHORT_NAME"].ToString();
                OutTemp.UpdateBy = dr["UPDATE_BY"].ToString();
                OutTemp.UpdateDate = dr["UPDATE_DATE"].ToString();
                // OutTemp.IsDataChecked = true;

                FieldsTemp.Add(OutTemp);
                OutTemp = new AppSettingsData();
            }

            FieldsTemp.Cast<AppSettingsData>().ToList();
            return FieldsTemp;

        }
        public IList<AppSettingsData> GetRoles()
        {
            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("sw_pkg_user.p_get_role", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.Add("p_cur_role", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }
            AppSettingsData OutTemp = new AppSettingsData();
            List<AppSettingsData> CodesTemp = new List<AppSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                OutTemp.RoleId = Convert.ToString(dr["ROLE_ID"]);
                OutTemp.RoleName = Convert.ToString(dr["ROLE_NAME"]);
                OutTemp.AccessFlag = false;
                CodesTemp.Add(OutTemp);
                OutTemp = new AppSettingsData();
            }

            CodesTemp.Cast<AppSettingsData>().ToList();
            return CodesTemp;
        }
        /// <summary>
        /// THIS IS TO PULL THE ALL SCREEN NAMES FOR GIVEN MODULE DC/DV.
        /// </summary>
        /// <param name="ScreenModule"></param>
        /// <returns></returns>
        public IList<AppSettingsData> GetScreenList(string ScreenModule)
        {
            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("sw_pkg_user.p_get_screen_list", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.AddWithValue("as_module", ScreenModule);
                objCmd.Parameters.Add("p_cur_screen", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }
            AppSettingsData OutTemp = new AppSettingsData();
            List<AppSettingsData> CodesTemp = new List<AppSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                OutTemp.ScreenModule = ScreenModule;///this is used while saving screen data from user profile data
                OutTemp.ScreenCode = Convert.ToString(dr["SCREEN_CODE"]);
                OutTemp.ScreenName = Convert.ToString(dr["SCREEN_NAME"]);
                CodesTemp.Add(OutTemp);
                OutTemp = new AppSettingsData();
            }

            CodesTemp.Cast<AppSettingsData>().ToList();
            return CodesTemp;
        }
        /// <summary>
        /// THIS IS TO PULL ALL SCREENS RELATED TO A PARTICULAR ROLE
        /// </summary>
        /// <param name="RoleId"></param>
        /// <param name="ScreenModule"></param>
        /// <returns></returns>
        public IList<AppSettingsData> GetRoleScreens(string RoleId, string ScreenModule)
        {
            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("sw_pkg_user.p_get_role_right", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.AddWithValue("an_role_id", RoleId);
                objCmd.Parameters.AddWithValue("as_module", ScreenModule);
                objCmd.Parameters.Add("p_cur_role_screen", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }
            AppSettingsData OutTemp = new AppSettingsData();
            List<AppSettingsData> CodesTemp = new List<AppSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                OutTemp.RoleId = RoleId;
                OutTemp.ScreenCode = Convert.ToString(dr["SCREEN_CODE"]);
                OutTemp.ModuleName = ScreenModule;
                CodesTemp.Add(OutTemp);
                OutTemp = new AppSettingsData();
            }

            CodesTemp.Cast<AppSettingsData>().ToList();
            return CodesTemp;
        }
        public IList<AppSettingsData> GetUserRight(string UserId, string ScreenModule)
        {
            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("sw_pkg_user.p_get_user_right", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.AddWithValue("an_user_id", UserId);
                objCmd.Parameters.AddWithValue("as_module", ScreenModule);
                objCmd.Parameters.Add("p_user_right", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }
            AppSettingsData OutTemp = new AppSettingsData();
            List<AppSettingsData> CodesTemp = new List<AppSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                OutTemp.ScreenCode = Convert.ToString(dr["SCREEN_CODE"]);
                CodesTemp.Add(OutTemp);
                OutTemp = new AppSettingsData();
            }

            CodesTemp.Cast<AppSettingsData>().ToList();
            return CodesTemp;
        }
        public IList<AppSettingsData> GetAuditTrailData(AppSettingsData oAuditTrial)
        {
            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("sw_pkg_user.p_get_audit_trail", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.AddWithValue("as_user", oAuditTrial.UserId);
                objCmd.Parameters.AddWithValue("adt_from", oAuditTrial.AuditTrailFrom);
                objCmd.Parameters.AddWithValue("adt_to", oAuditTrial.AuditTrailTo);
                objCmd.Parameters.Add("p_cur_audit", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }
            AppSettingsData OutTemp = new AppSettingsData();
            List<AppSettingsData> CodesTemp = new List<AppSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                OutTemp.UserId = Convert.ToString(dr["USER_ID"]);
                OutTemp.uwbi = Convert.ToString(dr["UWBI"]);
                OutTemp.TableName = Convert.ToString(dr["TABLE_NAME"]);
                OutTemp.ColumnName = Convert.ToString(dr["COL_NAME"]);
                //OutTemp.TablePKey = Convert.ToString(dr["TABLE_PKEY"]);
                //OutTemp.TablePKeyValue = Convert.ToString(dr["TABLE_PKEY_VALUE"]);
                OutTemp.TransDate = Convert.ToString(dr["TRANS_DATE"]);
                OutTemp.OperationType = Convert.ToString(dr["OPR_TYPE"]);
                OutTemp.OldValue = Convert.ToString(dr["OLD_VALUE"]);
                OutTemp.NewValue = Convert.ToString(dr["NEW_VALUE"]);
                CodesTemp.Add(OutTemp);
                OutTemp = new AppSettingsData();
            }

            CodesTemp.Cast<AppSettingsData>().ToList();
            return CodesTemp;
        }
        public IList<AppSettingsData> GetResUnitCode(int FiledCode)
        {
            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("sw_pkg_system_setting.p_get_reservoir_unit_code", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.AddWithValue("an_field_code", FiledCode);
                objCmd.Parameters.Add("p_cur_codes", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }
            AppSettingsData OutTemp = new AppSettingsData();
            List<AppSettingsData> CodesTemp = new List<AppSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                OutTemp.PickCode = Convert.ToString(dr["PICK_CODE"]);
                OutTemp.PickName = Convert.ToString(dr["PICK_NAME"]);
                OutTemp.ResUnitCode = Convert.ToString(dr["RES_UNIT_CODE"]);
                OutTemp.ResUnitName = Convert.ToString(dr["RES_UNIT_NAME"]);
                OutTemp.UpdateBy = Convert.ToString(dr["UPDATE_BY"]);
                OutTemp.UpdateDate = Convert.ToString(dr["UPDATE_DATE"]);
                CodesTemp.Add(OutTemp);
                OutTemp = new AppSettingsData();
            }

            CodesTemp.Cast<AppSettingsData>().ToList();
            return CodesTemp;
        }
        public IList<AppSettingsData> GetSystemParm()
        {
            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("sw_pkg_system_setting.p_get_system_parm", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.Add("p_cur_parm", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }
            AppSettingsData OutTemp = new AppSettingsData();
            List<AppSettingsData> CodesTemp = new List<AppSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                OutTemp.ParmType = Convert.ToString(dr["PARM_TYPE"]);
                OutTemp.ParmDesc = Convert.ToString(dr["PARM_DESC"]);
                OutTemp.ParmValue = Convert.ToString(dr["PARM_VALUE"]);
                OutTemp.UpdateBy = Convert.ToString(dr["UPDATE_BY"]);
                OutTemp.UpdateDate = Convert.ToString(dr["UPDATE_DATE"]);

                CodesTemp.Add(OutTemp);
                OutTemp = new AppSettingsData();
            }

            CodesTemp.Cast<AppSettingsData>().ToList();
            return CodesTemp;
        }
        /// <summary>
        /// THIS IS TO LIST WELL RIG DATA FROM SW-DB 
        /// </summary>
        /// <returns></returns>
        public IList<AppSettingsData> GetRigDetails()
        {
            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("sw_pkg_system_setting.p_get_rig_details", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.Add("p_cur_rig_details", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }
            AppSettingsData OutTemp = new AppSettingsData();
            List<AppSettingsData> RigDetailsTemp = new List<AppSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                OutTemp.RigId = dr["RIG_ID"].ToString();
                OutTemp.RigNum = dr["RIG_NUM"].ToString();
                OutTemp.RigName = dr["RIG_NAME"].ToString();
                OutTemp.AirGap = Convert.ToDecimal(dr["AIRGAP"].ToString());
                OutTemp.EffectiveFrom = dr["EFFECTIVE_FROM"].ToString();
                OutTemp.EffectiveTo = dr["EFFECTIVE_TO"].ToString();
                OutTemp.Company = dr["COMPANY"].ToString();
                OutTemp.InsertBy = dr["INSERT_BY"].ToString();
                OutTemp.InsertDate = dr["INSERT_DATE"].ToString();
                //,,,COMPANY,, ,
                RigDetailsTemp.Add(OutTemp);
                OutTemp = new AppSettingsData();
            }

            RigDetailsTemp.Cast<AppSettingsData>().ToList();
            return RigDetailsTemp;
        }
        public string SaveUserSession(AppSettingsData oSessionData)
        {
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                objConn.Open();

                if (oSessionData != null)
                {
                    // in number, as_user_id in varchar2,   in varchar2,  
                    OracleCommand objCmd = new OracleCommand("sw_pkg_user.p_insupd_user_session", objConn);
                    objCmd.CommandType = CommandType.StoredProcedure;
                    objCmd.Parameters.AddWithValue("as_user_id", oSessionData.UserName);
                    objCmd.Parameters.AddWithValue("an_session_id", oSessionData.SessionId);
                    objCmd.Parameters.AddWithValue("as_module", oSessionData.ModuleName);
                    objCmd.Parameters.AddWithValue("as_mversion", oSessionData.VersionNumber);
                    objCmd.ExecuteNonQuery();
                }

                objConn.Close();
            }
            return "";
        }
        public string DeleteRefernceData(IList<AppSettingsData> oReferenceData)
        {
            object result = new object();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {

                objConn.Open();
                foreach (AppSettingsData oDataItem in oReferenceData)
                {
                    OracleCommand objCmd = new OracleCommand("ld_pkg_system_setting.sp_delete_code", objConn);
                    objCmd.CommandType = CommandType.StoredProcedure;
                    OracleParameter p_RetMsg = new OracleParameter("p_msg", OracleType.VarChar, 1000);
                    p_RetMsg.Direction = ParameterDirection.Output;

                    objCmd.Parameters.AddWithValue("as_group_name", Convert.ToString(oDataItem.GroupName));
                    objCmd.Parameters.AddWithValue("as_code", oDataItem.CodesCode);
                    objCmd.Parameters.Add(p_RetMsg);
                    objCmd.ExecuteNonQuery();
                    result = p_RetMsg.Value;
                }
                objConn.Close();
            }
            return result.ToString();
        }
        public string SaveRefernceData(IList<AppSettingsData> oReferenceData)
        {
            object result = new object();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {

                objConn.Open();
                foreach (AppSettingsData oDataItem in oReferenceData)
                {
                    OracleCommand objCmd = new OracleCommand("ld_pkg_system_setting.sp_insertorupdate_code", objConn);
                    objCmd.CommandType = CommandType.StoredProcedure;
                    OracleParameter p_RetMsg = new OracleParameter("p_msg", OracleType.VarChar, 1000);
                    p_RetMsg.Direction = ParameterDirection.Output;

                    objCmd.Parameters.AddWithValue("as_group_name", Convert.ToString(oDataItem.GroupName));
                    objCmd.Parameters.AddWithValue("as_code", oDataItem.CodesCode);
                    objCmd.Parameters.AddWithValue("as_description", Convert.ToString(oDataItem.CodeDescription));
                    objCmd.Parameters.AddWithValue("as_code_active", GetBoolToString(oDataItem.CodeActive));
                    objCmd.Parameters.AddWithValue("an_display_seq", Convert.ToString(oDataItem.DisplaySeq));
                    objCmd.Parameters.AddWithValue("as_parent_code", (object)oDataItem.Parent_Code ?? (object)DBNull.Value);
                    objCmd.Parameters.Add(p_RetMsg);
                    objCmd.ExecuteNonQuery();
                    result = p_RetMsg.Value;
                }

                objConn.Close();

            }
            return result.ToString();
        }
        public string SaveRole(string RoleId, string RoleName)
        {
            object result = new object();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                objConn.Open();

                OracleCommand objCmd = new OracleCommand("sw_pkg_user.p_insupd_role", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                OracleParameter p_NewRoleId = new OracleParameter("an_new_role_id", OracleType.Number);
                p_NewRoleId.Direction = ParameterDirection.Output;
                if (!string.IsNullOrEmpty(RoleId))
                {
                    objCmd.Parameters.AddWithValue("an_role_id", Convert.ToString(RoleId));
                }
                else
                {
                    objCmd.Parameters.AddWithValue("an_role_id", DBNull.Value);
                }
                objCmd.Parameters.AddWithValue("as_role_name", RoleName);
                objCmd.Parameters.Add(p_NewRoleId);
                objCmd.ExecuteNonQuery();
                result = p_NewRoleId.Value;
                objConn.Close();
            }
            return result.ToString();

        }
        public string SaveRoleRight(IList<AppSettingsData> oRoleData, string RoleId)
        {

            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                objConn.Open();
                foreach (AppSettingsData oDataItem in oRoleData)
                {
                    OracleCommand objCmd = new OracleCommand("sw_pkg_user.p_insupd_role_right", objConn);
                    objCmd.CommandType = CommandType.StoredProcedure;
                    objCmd.Parameters.AddWithValue("as_role_id", RoleId);
                    objCmd.Parameters.AddWithValue("as_module", oDataItem.ScreenModule);
                    objCmd.Parameters.AddWithValue("as_screen_code", Convert.ToString(oDataItem.ScreenCode));
                    objCmd.Parameters.AddWithValue("as_flag", GetBoolToString(oDataItem.AccessFlag));
                    objCmd.ExecuteNonQuery();
                }

                objConn.Close();

            }
            return "Role rights has been updated successfully!!!";

        }

        public List<AppSettingsData> GetSystemSettings()
        {
            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("ld_pkg_system_setting.p_get_system_parm", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.Add("p_cur_parm", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }

            AppSettingsData outTemp = new AppSettingsData();
            List<AppSettingsData> SystemDataTemp = new List<AppSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {

                outTemp.ParmType = Convert.ToString(dr["PARM_TYPE"]);
                outTemp.ParmDesc = Convert.ToString(dr["PARM_DESC"]);
                outTemp.ParmValue = Convert.ToString(dr["PARM_VALUE"]);
                outTemp.UpdateBy = Convert.ToString(dr["UPDATE_BY"]);
                outTemp.UpdateDate = Convert.ToString(dr["UPDATE_DATE"]);
                SystemDataTemp.Add(outTemp);
                outTemp = new AppSettingsData();
            }

            return SystemDataTemp.ToList();
        }

        public string SaveSystemSettings(string parm_code, string parm_value, string updated_by, DateTime updated_Date)
        {
            object result = new object();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {

                OracleCommand objCmd = new OracleCommand("ld_pkg_system_setting.p_save_system_parm", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                OracleParameter p_RetMsg = new OracleParameter("p_msg", OracleType.VarChar, 1000);
                p_RetMsg.Direction = ParameterDirection.Output;
                objCmd.Parameters.AddWithValue("as_parm_type", parm_code);
                objCmd.Parameters.AddWithValue("as_parm_value", parm_value);
                objCmd.Parameters.AddWithValue("as_update_by", updated_by);
                objCmd.Parameters.AddWithValue("as_updated_date", updated_Date);
                objCmd.Parameters.Add(p_RetMsg);
                objConn.Open();
                objCmd.ExecuteNonQuery();
                result = p_RetMsg.Value;
                objConn.Close();
            }
            return result.ToString();
        }

        #region Local Method
        /// <summary>
        /// if flag=true then return "Y" else "N"
        /// </summary>
        /// <param name="FlagVal"></param>
        /// <returns></returns>
        private string GetBoolToString(bool FlagVal)
        {
            string RetVal = null;
            if (FlagVal)
            {
                RetVal = "Y";
            }
            else
            {
                RetVal = "N";
            }
            return RetVal;
        }
        /// <summary>
        #endregion
    }
}
