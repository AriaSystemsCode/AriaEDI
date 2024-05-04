using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace X12Translator.Recieve
{
   static class HelperClass
    {
       /// <summary>
       /// Example : 
       /// </summary>
        /// <param name="Value">String value to be splitted to find spcific occurrence</param>
        /// <param name="Splitter">Splitter string </param>
        /// <param name="occurrence">occurrence need to be returned.</param>
        /// <returns>Return the data found on that spcified occurrence.</returns>
       public static string LFGetOccurrence(string Value, string Splitter, int occurrence)
       {
           string result = null;
           if (string.IsNullOrEmpty(Value) && string.IsNullOrEmpty(Splitter) && occurrence <= 0)
           {

               return null;
           }
               string[] arrValues = Value.Split(new string[] { Splitter }, StringSplitOptions.None);
               
               if (arrValues.Count() > 0 && arrValues.Count() >= occurrence)
               {
                   result = arrValues[occurrence - 1];
               }
           
           return result;
       }
       //public static string SplitFunction(string RawFileValue, string exp)
       //{
       //    string result = null;
       //    exp =exp.ToUpper().Trim();
       //    if (exp.StartsWith("LFGETOCCURRENCE("))
       //    {
       //        string tempExp = "";
       //        tempExp=exp.Replace("LFGETOCCURRENCE(","");
       //        tempExp = tempExp.Remove(tempExp.Length - 1);

       //         string[] arrParam = tempExp.Split(new string[] { "," }, StringSplitOptions.None);
       //         result= X12Translator.Recieve.HelperClass.LFGetOccurrence(RawFileValue, arrParam[0], int.Parse(arrParam[1]));
       //    }
       //    return result;
       //}
    }
}
