using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace LDSFileService.HelperClass
{
    public class TypeConvert
    {
        //Signed
        public static short? Convert2Short(object pVal) //-32768 to 32767
        {
            short? retVal = null;
            if (DBNull.Value != pVal)
            {
                retVal = Convert.ToInt16(pVal);
            }
            return retVal;
        }
        public static int? Convert2Int(object pVal) //-2147483648 to 2147483647
        {
            int? retVal = null;
            if (DBNull.Value != pVal && !string.IsNullOrEmpty(pVal.ToString()))
            {
                retVal = Convert.ToInt32(pVal);
            }
            return retVal;
        }
        public static long? Convert2Long(object pVal) //-9223372036854775808 to 9223372036854775807
        {
            long? retVal = null;
            if (DBNull.Value != pVal)
            {
                retVal = Convert.ToInt64(pVal);
            }
            return retVal;
        }

        //Unsigned
        public static ushort? Convert2UShort(object pVal) //65535
        {
            ushort? retVal = null;
            if (DBNull.Value != pVal)
            {
                retVal = Convert.ToUInt16(pVal);
            }
            return retVal;
        }
        public static uint? Convert2UInt(object pVal) //4294967295
        {

            uint? retVal = null;
            if (DBNull.Value != pVal && !string.IsNullOrEmpty(pVal.ToString()))
            {
                retVal = Convert.ToUInt32(pVal);
            }
            return retVal;
        }
        public static ulong? Convert2ULong(object pVal) //18446744073709551615
        {
            ulong? retVal = null;
            if (DBNull.Value != pVal)
            {
                retVal = Convert.ToUInt64(pVal);
            }
            return retVal;
        }
        //Float
        public static float? Convert2Float(object pVal) //Bytes - 4; Approximately ±1.5 x 10-45 to ±3.4 x 1038 with 7 significant figures
        {
            float? retVal = null;
            if (DBNull.Value != pVal)
            {
                retVal = Convert.ToSingle(pVal);
            }
            return retVal;
        }

        //double
        public static double? Convert2Double(object pVal) //Bytes - 8; Approximately ±5.0 x 10-324 to ±1.7 x 10308 with 15 or 16 significant figures
        {
            double? retVal = null;
            if (DBNull.Value != pVal)
            {
                retVal = Convert.ToDouble(pVal);
            }
            return retVal;
        }
        //Decimal
        public static decimal? Convert2Decimal(object pVal) //Bytes - 16; Approximately ±1.0 x 10-28 to ±7.9 x 1028 with 28 or 29 significant figures
        {
            decimal? retVal = null;
            if (DBNull.Value != pVal && !string.IsNullOrEmpty(pVal.ToString()))
            {
                retVal = Convert.ToDecimal(pVal);
            }
            return retVal;
        }
        //Date
        public static DateTime? Convert2DateTime(object pVal)
        {
            DateTime? retVal = null;
            if (DBNull.Value != pVal && !string.IsNullOrEmpty(pVal.ToString()))
            {
                retVal = Convert.ToDateTime(pVal);
            }
            return retVal;
        }
        public static object ConvertValue(object pVal)
        {
            object retVal = DBNull.Value;
            if (Convert.ToString(pVal).Length > 0)
            {
                retVal = pVal;
            }
            return retVal;
        }
        public static object DbNullCheck(object pVal)
        {
            object retVal = null;
            if (DBNull.Value != pVal)
            {
                retVal = pVal;
            }
            return retVal;
        }

    }
}