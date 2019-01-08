using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LDSFileService.HelperClass
{
    public static class Common
    {
        public static string GetBoolToStringStatus(bool FlagVal)
        {
            string RetVal = null;
            if (FlagVal)
            {
                RetVal = "A"; // For Active
            }
            else
            {
                RetVal = "D";// for deleted in feature
            }
            return RetVal;
        }
        public static string GetBoolToString(bool FlagVal)
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
        public static bool GetStringToBoolAttribute(string FlagVal)
        {
            bool RetVal;
            if (FlagVal == "Y")
            {
                RetVal = true;
            }
            else if (FlagVal == "A")
            {
                RetVal = true;
            }
            else
            {
                RetVal = false;
            }
            return RetVal;
        }
        public static bool GetStringToBool(string FlagVal)
        {
            bool RetVal;
            if (FlagVal == "A")
            {
                RetVal = true;
            }
            else
            {
                RetVal = false;
            }
            return RetVal;
        }
    }
}