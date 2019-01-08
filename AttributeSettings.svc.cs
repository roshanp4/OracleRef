using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.ServiceModel;
using System.Text;
using System.Data;
using System.Data.OracleClient;
using LDSFileService.ServiceClassLibrary;
using LDSFileService.HelperClass;

namespace LDSFileService.ServiceLibrary
{
    // NOTE: You can use the "Rename" command on the "Refactor" menu to change the class name "AttributeSettings" in code, svc and config file together.
    // NOTE: In order to launch WCF Test Client for testing this service, please select AttributeSettings.svc or AttributeSettings.svc.cs at the Solution Explorer and start debugging.
    public class AttributeSettings : IAttributeSettings
    {
        string connectionString = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["DbLDS"].ToString();

        public string SaveAttribute(AttributeSettingsData oliveDoc, out string AttrIdOut)
        {
            object result = new object();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                objConn.Open();
                OracleCommand objCmd = new OracleCommand("p_save_attr", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                OracleParameter p_msg = new OracleParameter("p_msg", OracleType.VarChar, 1000);
                p_msg.Direction = ParameterDirection.Output;
                OracleParameter AttributeId = new OracleParameter("AttributeId", OracleType.VarChar, 1000);
                AttributeId.Direction = ParameterDirection.Output;
                objCmd.Parameters.AddWithValue("an_attr_id", (object)oliveDoc.AttributeId ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_attr_name", Convert.ToString(oliveDoc.AttributeName));
                objCmd.Parameters.AddWithValue("as_data_type", (object)oliveDoc.AttributeType ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_status", (object)Common.GetBoolToStringStatus(oliveDoc.AttributeStatus) ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_user", (object)oliveDoc.User ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_style", (object)oliveDoc.Style ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_description", (object)oliveDoc.Description ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_default_val_flag", (object)Common.GetBoolToString(oliveDoc.DefaultValFlag) ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_default_val", (object)oliveDoc.DefaultVal ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_library_id", (object)oliveDoc.LibraryId ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_val_man", (object)Common.GetBoolToString(oliveDoc.IsValueMandatory) ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_inh_man", (object)Common.GetBoolToString(oliveDoc.IsInhMandatory) ?? (object)DBNull.Value);
                objCmd.Parameters.Add(p_msg);
                objCmd.Parameters.Add(AttributeId);
                objCmd.ExecuteNonQuery();
                result = p_msg.Value;
                AttrIdOut = AttributeId.Value.ToString();
                objConn.Close();
            }
            return result.ToString();
        }


        public List<AttributeSettingsData> GetFullAttributeList(string Status, string Search_Param)
        {

            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("P_SEARCH_ATTR_LIST", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.Add("as_status", OracleType.VarChar).Value = Status;
                objCmd.Parameters.Add("as_attr_name", OracleType.VarChar).Value = Search_Param;
                objCmd.Parameters.Add("p_cur_attr", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }

            AttributeSettingsData outTemp = new AttributeSettingsData();
            List<AttributeSettingsData> AttributeSettingsDataTemp = new List<AttributeSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                outTemp.AttributeId = Convert.ToInt32(dr["attr_id"]);
                outTemp.AttributeName = Convert.ToString(dr["attr_name"]);
                outTemp.AttributeType = Convert.ToString(dr["Data_Type"]);
                outTemp.AttributeStatus = Common.GetStringToBoolAttribute(Convert.ToString(dr["status"]));
                outTemp.Description = Convert.ToString(dr["Description"]);
                outTemp.Style = Convert.ToString(dr["Style"]);
                outTemp.StyleVal = Convert.ToString(dr["StyleSml"]);
                outTemp.DefaultValFlag = Common.GetStringToBoolAttribute(Convert.ToString(dr["default_val_flag"]));
                outTemp.DefaultVal = Convert.ToString(dr["default_val"]);

                outTemp.IsValueMandatory = Common.GetStringToBoolAttribute(Convert.ToString(dr["VAL_MAND"]));
                outTemp.IsInhMandatory = Common.GetStringToBoolAttribute(Convert.ToString(dr["INHERIT_MAND"]));
                outTemp.LibraryId = Convert.ToInt32(dr["LIBRARY_ID"]);
                outTemp.LibraryName = Convert.ToString(dr["Library_Name"]);
                outTemp.CreatedBy = Convert.ToString(dr["Insert_By"]);
                outTemp.CreatedDate = TypeConvert.Convert2DateTime(dr["Insert_Date"]);
                outTemp.Updatedby = Convert.ToString(dr["update_by"]);
                outTemp.UpdatedDate = TypeConvert.Convert2DateTime(dr["update_date"]);
                AttributeSettingsDataTemp.Add(outTemp);
                outTemp = new AttributeSettingsData();
            }

            return AttributeSettingsDataTemp.ToList();
        }



        public List<AttributeSettingsData> GetAttributeByLibrary(int LibraryId, bool Status)
        {

            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("p_get_library_attr_list", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.Add("an_library_id", OracleType.Int32).Value = LibraryId;
                objCmd.Parameters.Add("as_is_system_attr", OracleType.VarChar).Value = Common.GetBoolToString(Status);
                objCmd.Parameters.Add("p_cur_attr", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }

            AttributeSettingsData outTemp = new AttributeSettingsData();
            List<AttributeSettingsData> AttributeSettingsDataTemp = new List<AttributeSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                outTemp.AttributeId = Convert.ToInt32(dr["attr_id"]);
                outTemp.AttributeName = Convert.ToString(dr["attr_name"]);
                outTemp.AttributeType = Convert.ToString(dr["Data_Type"]);
                outTemp.AttributeStatus = Common.GetStringToBoolAttribute(Convert.ToString(dr["status"]));
                outTemp.Description = Convert.ToString(dr["Description"]);
                outTemp.Style = Convert.ToString(dr["Style"]);
                outTemp.StyleVal = Convert.ToString(dr["StyleSml"]);
                outTemp.DefaultValFlag = Common.GetStringToBoolAttribute(Convert.ToString(dr["default_val_flag"]));
                outTemp.DefaultVal = Convert.ToString(dr["default_val"]);
                outTemp.IsValueMandatory = Common.GetStringToBoolAttribute(Convert.ToString(dr["VAL_MAND"]));
                outTemp.IsInhMandatory = Common.GetStringToBoolAttribute(Convert.ToString(dr["INHERIT_MAND"]));
                outTemp.LibraryId = Convert.ToInt32(dr["LIBRARY_ID"]);
                AttributeSettingsDataTemp.Add(outTemp);
                outTemp = new AttributeSettingsData();
            }

            return AttributeSettingsDataTemp.ToList();
        }


        public List<AttributeSettingsData> GetSysAttributeGroupByLibraryId(int LibraryId, bool Status)
        {
            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("P_GET_LIBRARY_ATTR_GROUP_LIST", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.Add("an_library_id", OracleType.Int32).Value = LibraryId;
                objCmd.Parameters.Add("as_is_system_attr", OracleType.VarChar).Value = Common.GetBoolToString(Status);
                objCmd.Parameters.Add("p_cur_group", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }
            AttributeSettingsData outTemp = new AttributeSettingsData();
            List<AttributeSettingsData> AttributeSettingsDataTemp = new List<AttributeSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                outTemp.GroupId = Convert.ToInt32(dr["group_id"]);
                outTemp.GroupName = Convert.ToString(dr["group_name"]);
                AttributeSettingsDataTemp.Add(outTemp);
                outTemp = new AttributeSettingsData();
            }
            return AttributeSettingsDataTemp.ToList();
        }

        public List<AttributeSettingsData> GetAttributeListById(string AttributeId)
        {

            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("P_get_attr_List_byid", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.Add("as_attr_id", OracleType.VarChar).Value = AttributeId;
                objCmd.Parameters.Add("p_cur_attr", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }

            AttributeSettingsData outTemp = new AttributeSettingsData();
            List<AttributeSettingsData> AttributeSettingsDataTemp = new List<AttributeSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                outTemp.AttributeId = Convert.ToInt32(dr["attr_id"]);
                outTemp.AttributeName = Convert.ToString(dr["attr_name"]);
                outTemp.AttributeType = Convert.ToString(dr["Data_Type"]);
                outTemp.AttributeStatus = Common.GetStringToBoolAttribute(Convert.ToString(dr["status"]));
                outTemp.Description = Convert.ToString(dr["Description"]);
                outTemp.Style = Convert.ToString(dr["Style"]);
                outTemp.StyleVal = Convert.ToString(dr["StyleSml"]);
                outTemp.DefaultValFlag = Common.GetStringToBoolAttribute(Convert.ToString(dr["default_val_flag"]));
                outTemp.DefaultVal = Convert.ToString(dr["default_val"]);
                outTemp.IsValueMandatory = Common.GetStringToBoolAttribute(Convert.ToString(dr["VAL_MAND"]));
                outTemp.IsInhMandatory = Common.GetStringToBoolAttribute(Convert.ToString(dr["INHERIT_MAND"]));
                outTemp.LibraryId = Convert.ToInt32(dr["LIBRARY_ID"]);
                outTemp.CreatedBy = Convert.ToString(dr["Insert_By"]);
                outTemp.CreatedDate = TypeConvert.Convert2DateTime(dr["Insert_Date"]);
                outTemp.Updatedby = Convert.ToString(dr["update_by"]);
                outTemp.UpdatedDate = TypeConvert.Convert2DateTime(dr["update_date"]);
                AttributeSettingsDataTemp.Add(outTemp);
                outTemp = new AttributeSettingsData();
            }

            return AttributeSettingsDataTemp.ToList();
        }


        public string DeleteAttributeMaster(AttributeSettingsData oliveDoc)
        {
            object result = new object();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                objConn.Open();
                OracleCommand objCmd = new OracleCommand("p_delete_attribute_master", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                OracleParameter p_msg = new OracleParameter("p_msg", OracleType.VarChar, 1000);
                p_msg.Direction = ParameterDirection.Output;
                objCmd.Parameters.AddWithValue("an_attr_id", (object)oliveDoc.AttributeId ?? (object)DBNull.Value);
                objCmd.Parameters.Add(p_msg);
                objCmd.ExecuteNonQuery();
                result = p_msg.Value;
                objConn.Close();
            }
            return result.ToString();
        }

        public void DeleteAttributeListVal(AttributeSettingsData oliveDoc)
        {
            object result = new object();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                objConn.Open();
                OracleCommand objCmd = new OracleCommand("p_delete_attr_list_val", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.AddWithValue("an_Attribute_id", (object)oliveDoc.AttributeId ?? (object)DBNull.Value);
                objCmd.ExecuteNonQuery();
                objConn.Close();
            }
        }

        // For Attributes fill in Attributes group
        public List<AttributeSettingsData> GetAttributeGroupList(string strSearch)
        {

            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("p_get_attr_group_list", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.Add("as_group_name", OracleType.VarChar).Value = strSearch;
                objCmd.Parameters.Add("p_cur_group", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }

            AttributeSettingsData outTemp = new AttributeSettingsData();
            List<AttributeSettingsData> AttributeSettingsDataTemp = new List<AttributeSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                outTemp.GroupId = Convert.ToInt32(dr["group_id"]);
                outTemp.GroupName = Convert.ToString(dr["group_name"]);
                outTemp.LibraryName = Convert.ToString(dr["Library_Name"]);
                outTemp.AttributeStatus = Common.GetStringToBoolAttribute(Convert.ToString(dr["status"]));
                outTemp.Updatedby = Convert.ToString(dr["update_by"]);
                outTemp.UpdatedDate = TypeConvert.Convert2DateTime(dr["update_date"]);

                AttributeSettingsDataTemp.Add(outTemp);
                outTemp = new AttributeSettingsData();
            }

            return AttributeSettingsDataTemp.ToList();
        }
        public List<AttributeSettingsData> GetGroupAttributes(int GroupId,int LibraryId, string GroupFlag)
        {

            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("p_get_group_attr", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.Add("an_group_id", OracleType.VarChar).Value = GroupId;
                objCmd.Parameters.Add("an_library_id", OracleType.Int32).Value = LibraryId;
                objCmd.Parameters.Add("as_group_flag", OracleType.VarChar).Value = GroupFlag;
                objCmd.Parameters.Add("p_cur_attr", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }

            AttributeSettingsData outTemp = new AttributeSettingsData();
            List<AttributeSettingsData> AttributeSettingsDataTemp = new List<AttributeSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                outTemp.GroupId = Convert.ToInt32(dr["group_id"]);
                outTemp.AttributeId = Convert.ToInt32(dr["attr_id"]);
                outTemp.AttributeName = Convert.ToString(dr["attr_name"]);
                outTemp.AttributeType = Convert.ToString(dr["DATA_TYPE"]);
                outTemp.AttributeStatus = Common.GetStringToBool(Convert.ToString(dr["status"]));
                outTemp.CreatedBy = Convert.ToString(dr["Insert_By"]);
                outTemp.CreatedDate = TypeConvert.Convert2DateTime(dr["Insert_Date"]);
                outTemp.Updatedby = Convert.ToString(dr["update_by"]);
                outTemp.UpdatedDate = TypeConvert.Convert2DateTime(dr["update_date"]);
                AttributeSettingsDataTemp.Add(outTemp);
                outTemp = new AttributeSettingsData();
            }

            return AttributeSettingsDataTemp.ToList();
        }
        /// <summary>
        /// Its for adding or saving Group
        /// </summary>
        /// <param name="oliveDoc"></param>
        public void SaveAttributeGroup(AttributeSettingsData oliveDoc)
        {
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                objConn.Open();
                OracleCommand objCmd = new OracleCommand("p_save_attr_group", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.AddWithValue("an_group_id", (object)oliveDoc.GroupId ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_attr_id", (object)oliveDoc.AttributeId ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_delete_flag", (object)oliveDoc.DeleteFlag ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_user", (object)oliveDoc.User ?? (object)DBNull.Value);
                objCmd.ExecuteNonQuery();
                objConn.Close();
            }
        }
        public string SaveAttributeGroupMaster(AttributeSettingsData oliveDoc, out string GroupIdOut)
        {
            object result = new object();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                objConn.Open();
                OracleCommand objCmd = new OracleCommand("p_save_attr_group_master", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                OracleParameter p_msg = new OracleParameter("p_msg", OracleType.VarChar, 1000);
                p_msg.Direction = ParameterDirection.Output;
                OracleParameter GroupId = new OracleParameter("GroupId", OracleType.VarChar, 1000);
                GroupId.Direction = ParameterDirection.Output;
                objCmd.Parameters.AddWithValue("an_group_id", (object)oliveDoc.GroupId ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_group_name", (object)oliveDoc.GroupName ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_library_id", (object)oliveDoc.LibraryId ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_status", Common.GetBoolToStringStatus(oliveDoc.AttributeStatus));
                objCmd.Parameters.AddWithValue("as_user", (object)oliveDoc.User ?? (object)DBNull.Value);
                objCmd.Parameters.Add(p_msg);
                objCmd.Parameters.Add(GroupId);
                objCmd.ExecuteNonQuery();
                result = p_msg.Value;
                GroupIdOut = GroupId.Value.ToString();
                objConn.Close();
            }
            return result.ToString();
        }
        public string DeleteAttributeGroupMaster(AttributeSettingsData oliveDoc)
        {
            object result = new object();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                objConn.Open();
                OracleCommand objCmd = new OracleCommand("p_delete_attr_group_master", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                OracleParameter p_msg = new OracleParameter("p_msg", OracleType.VarChar, 1000);
                p_msg.Direction = ParameterDirection.Output;
                objCmd.Parameters.AddWithValue("an_group_id", (object)oliveDoc.GroupId ?? (object)DBNull.Value);
                objCmd.Parameters.Add(p_msg);
                objCmd.ExecuteNonQuery();
                result = p_msg.Value;
                objConn.Close();
            }
            return result.ToString();
        }
        /// <summary>
        /// Its for adding or saving Group
        /// </summary>
        /// <param name="oliveDoc"></param>
        public void SaveAttributeListVal(AttributeSettingsData oliveDoc)
        {
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                objConn.Open();
                OracleCommand objCmd = new OracleCommand("p_save_attr_list_val", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.AddWithValue("an_attr_id", Convert.ToInt32((object)oliveDoc.AttributeId ?? (object)DBNull.Value));
                objCmd.Parameters.AddWithValue("as_val", (object)oliveDoc.ListVal ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_user", (object)oliveDoc.Updatedby ?? (object)DBNull.Value);
                objCmd.ExecuteNonQuery();
                objConn.Close();
            }
        }
        public List<AttributeSettingsData> GetAttributesListValues(int AttributeId)
        {

            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("p_get_attribute_list_val", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.Add("an_attr_id", OracleType.Int32).Value = AttributeId;
                objCmd.Parameters.Add("p_cur_group", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }
            AttributeSettingsData outTemp = new AttributeSettingsData();
            List<AttributeSettingsData> AttributeSettingsDataTemp = new List<AttributeSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                outTemp.ListVal = Convert.ToString(dr["val"]);
                AttributeSettingsDataTemp.Add(outTemp);
                outTemp = new AttributeSettingsData();
            }
            return AttributeSettingsDataTemp.ToList();
        }
        /// <summary>
        /// Its for adding or saving system Attribute list from library
        /// </summary>
        /// <param name="oliveDoc"></param>
        public string CopyAttributesToNew(AttributeSettingsData oliveDoc)
        {
            object result = new object();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                objConn.Open();
                OracleCommand objCmd = new OracleCommand("p_copy_attr", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                OracleParameter p_msg = new OracleParameter("p_msg", OracleType.VarChar, 1000);
                p_msg.Direction = ParameterDirection.Output;
                objCmd.Parameters.AddWithValue("an_attr_id", Convert.ToInt32((object)oliveDoc.AttributeId ?? (object)DBNull.Value));
                objCmd.Parameters.AddWithValue("an_new_library_id", (object)oliveDoc.LibraryId ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_user", (object)oliveDoc.CreatedBy ?? (object)DBNull.Value);
                objCmd.Parameters.Add(p_msg);
                objCmd.ExecuteNonQuery();
                result = p_msg.Value;
                objConn.Close();
            }
            return result.ToString();
        }
        // For Attributes fill in Attributes group
        public List<AttributeSettingsData> GetAttributeGroupByLibraryId(int LibraryId)
        {
            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("p_get_attr_group_master", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.Add("an_library_id", OracleType.VarChar).Value = LibraryId;
                objCmd.Parameters.Add("p_cur_group", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }
            AttributeSettingsData outTemp = new AttributeSettingsData();
            List<AttributeSettingsData> AttributeSettingsDataTemp = new List<AttributeSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                outTemp.GroupId = Convert.ToInt32(dr["group_id"]);
                outTemp.GroupName = Convert.ToString(dr["group_name"]);
                outTemp.AttributeStatus = Common.GetStringToBoolAttribute(Convert.ToString(dr["status"]));
                outTemp.LibraryId = Convert.ToInt32(dr["library_id"]);
                AttributeSettingsDataTemp.Add(outTemp);
                outTemp = new AttributeSettingsData();
            }
            return AttributeSettingsDataTemp.ToList();
        }
        // For Attributes fill in Attributes group by group id
        public List<AttributeSettingsData> GetAttributeGroupById(int GroupId)
        {
            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("p_get_attr_group_byId", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.Add("an_group_id", OracleType.VarChar).Value = GroupId;
                objCmd.Parameters.Add("p_cur_group", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }
            AttributeSettingsData outTemp = new AttributeSettingsData();
            List<AttributeSettingsData> AttributeSettingsDataTemp = new List<AttributeSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                outTemp.GroupId = Convert.ToInt32(dr["group_id"]);
                outTemp.GroupName = Convert.ToString(dr["group_name"]);
                outTemp.AttributeStatus = Common.GetStringToBoolAttribute(Convert.ToString(dr["status"]));
                outTemp.LibraryId = Convert.ToInt32(dr["library_id"]);
                AttributeSettingsDataTemp.Add(outTemp);
                outTemp = new AttributeSettingsData();
            }
            return AttributeSettingsDataTemp.ToList();
        }
        /// <summary>
        /// Its for adding or saving system Attribute groups from library
        /// </summary>
        /// <param name="oliveDoc"></param>
        public string CopyGroupsToNew(AttributeSettingsData oliveDoc)
        {
            object result = new object();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                objConn.Open();
                OracleCommand objCmd = new OracleCommand("P_COPY_GROUP_MASTER", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                OracleParameter p_msg = new OracleParameter("p_msg", OracleType.VarChar, 1000);
                p_msg.Direction = ParameterDirection.Output;
                objCmd.Parameters.AddWithValue("an_group_id", Convert.ToInt32((object)oliveDoc.GroupId ?? (object)DBNull.Value));
                objCmd.Parameters.AddWithValue("an_new_library_id", (object)oliveDoc.LibraryId ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_user", (object)oliveDoc.CreatedBy ?? (object)DBNull.Value);
                objCmd.Parameters.Add(p_msg);
                objCmd.ExecuteNonQuery();
                result = p_msg.Value;
                objConn.Close();
            }
            return result.ToString();
        }

        public List<AttributeSettingsData> GetObjectAttributeList(int ObjectId)
        {
            DataTable dtList = new DataTable();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                OracleCommand objCmd = new OracleCommand("p_get_object_attr_list", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.Add("an_object_id", OracleType.VarChar).Value = ObjectId;
                objCmd.Parameters.Add("p_cur_attr", OracleType.Cursor).Direction = ParameterDirection.Output;
                objConn.Open();
                dtList.Load(objCmd.ExecuteReader());
                objConn.Close();
            }

            AttributeSettingsData outTemp = new AttributeSettingsData();
            List<AttributeSettingsData> AttributeSettingsDataTemp = new List<AttributeSettingsData>();
            foreach (DataRow dr in dtList.Rows)
            {
                outTemp.GroupId = Convert.ToInt32(dr["group_id"]);
                outTemp.GroupName = Convert.ToString(dr["group_name"]);
                outTemp.AttributeId = Convert.ToInt32(dr["attr_id"]);
                outTemp.AttributeName = Convert.ToString(dr["attr_name"]);
                outTemp.AttributeType = Convert.ToString(dr["data_type"]);
                outTemp.AttributeValue = Convert.ToString(dr["attr_val"]);
                outTemp.CurrentVersion = Convert.ToInt32(dr["version_number"]);

                AttributeSettingsDataTemp.Add(outTemp);
                outTemp = new AttributeSettingsData();
            }

            return AttributeSettingsDataTemp.ToList();
        }

        public string DeleteObjectAttribute(AttributeSettingsData oliveDoc)
        {
            object result = new object();
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                objConn.Open();
                OracleCommand objCmd = new OracleCommand("p_delete_object_attr", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                OracleParameter p_msg = new OracleParameter("p_msg", OracleType.VarChar, 1000);
                p_msg.Direction = ParameterDirection.Output;
                objCmd.Parameters.AddWithValue("an_object_id", (object)oliveDoc.ObjectId ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("an_version_number", (object)oliveDoc.CurrentVersion ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("an_attr_id", (object)oliveDoc.AttributeId ?? (object)DBNull.Value);
                objCmd.Parameters.Add(p_msg);
                objCmd.ExecuteNonQuery();
                objConn.Close();
                result = p_msg.Value;
            }
            return result.ToString();
        }
        /// <summary>
        /// Its for adding group directly against the folder or document
        /// </summary>
        /// <param name="oliveDoc"></param>
        public void SaveObjectAttributeGroup(AttributeSettingsData oliveDoc)
        {
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                objConn.Open();
                OracleCommand objCmd = new OracleCommand("p_save_object_attr_group", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;
                objCmd.Parameters.AddWithValue("an_object_id", (object)oliveDoc.ObjectId ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("an_group_id", (object)oliveDoc.GroupId ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("an_version_number", (object)oliveDoc.CurrentVersion ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_user", (object)oliveDoc.User ?? (object)DBNull.Value);
                objCmd.ExecuteNonQuery();
                objConn.Close();
            }
        }
        /// <summary>
        /// Used for saving all the attribute value against the attribute.
        /// </summary>
        /// <param name="oliveDoc"></param>
        public void SaveObjectAttribute(AttributeSettingsData oliveDoc)
        {
            using (OracleConnection objConn = new OracleConnection(connectionString))
            {
                objConn.Open();
                OracleCommand objCmd = new OracleCommand("p_save_object_attr", objConn);
                objCmd.CommandType = CommandType.StoredProcedure;

                objCmd.Parameters.AddWithValue("an_object_id", (object)oliveDoc.ObjectId ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("an_version_number", (object)oliveDoc.CurrentVersion ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("an_attr_id", (object)oliveDoc.AttributeId ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_attr_val", (object)oliveDoc.AttributeValue ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_val_mand", (object)oliveDoc.ValMand ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_inherit_mand", (object)oliveDoc.InheritMand ?? (object)DBNull.Value);
                objCmd.Parameters.AddWithValue("as_user", (object)oliveDoc.User ?? (object)DBNull.Value);
                objCmd.ExecuteNonQuery();
                objConn.Close();
            }
        }
    }
}
