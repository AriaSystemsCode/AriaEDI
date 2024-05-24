using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace Shopify_Converter
{
  class Converter
        {
            #region class fields
            static string logWriteFlag;
            static string ediArchivePath;
            static string outBoxFolder;
            static string inBoxFolder;
            static string productFileName;
            static string networkOutGoingFileName;
            static string locationFileName;
            static int filesInDirOutlength;
            static bool jsonheader;

            static XmlNodeList xmlnodelist;
            static XmlNode xmlnode;
            #endregion

            static void Main(string[] args)
            {

                #region Parameteres&log
                //X:\ARIA3EDI\ShopifyFileConverter.exe "SHPINV.json" "ARCHIVE" "X:\ARIA3EDI\EDI\OUTBOX\SHPOUT.XML" "inventory_adjustment" "Y" "true" "SHPIT.XML" "SHPIV.JSON"
                //string OutGoingFileName = "SHPSH.json";
                string OutGoingFileName = "SHPINV.json";
                string EDIArchivePath = "Archive";
                string EDIOutgoingFolder = @"X:\ARIA3EDI\EDI\OUTBOX\SHPOUT.XML";
               // string EDIOutgoingFolder = @"\\172.16.95.130\ARIA3EDI\EDI\OUTBOX\SHPOUT.XML";

                if (args.Length > 0)
                    OutGoingFileName = args[0].ToString();

                if (args.Length > 1)
                    EDIArchivePath = args[1].ToString();

                if (args.Length > 2)
                    EDIOutgoingFolder = args[2].ToString();

                Converter.outBoxFolder = Path.GetDirectoryName(EDIOutgoingFolder) + Path.DirectorySeparatorChar;

                Converter.networkOutGoingFileName = "inventory_adjustment";
                if (args.Length > 2)
                    Converter.networkOutGoingFileName = args[3].ToString();

                Converter.logWriteFlag = "N";
                if (args.Length > 3)
                    Converter.logWriteFlag = args[4].ToString();

                Converter.jsonheader = false;
                if (args.Length > 4)
                    Converter.jsonheader = args[5].ToString() == "true" ? true : false;

                Converter.productFileName = "SHPIT.XML";
                if (args.Length > 5)
                    Converter.productFileName = args[6].ToString();

                Converter.locationFileName = "SHPIV.JSON";
                if (args.Length > 6)
                    Converter.locationFileName = args[7].ToString();

                Converter.WriteLog("OutGoingFileName =" + OutGoingFileName);
                Converter.WriteLog("EDIArchivePath =" + EDIArchivePath);
                Converter.WriteLog("EDIOutgoingFolder =" + EDIOutgoingFolder);


                Converter.WriteLog("Converter.networkOutGoingFileName =" + Converter.networkOutGoingFileName);
                Converter.WriteLog("Converter.logWriteFlag =" + Converter.logWriteFlag);
                Converter.WriteLog("Converter.jsonheader =" + Converter.jsonheader);
                Converter.WriteLog("Converter.productFileName =" + Converter.productFileName);
                Converter.WriteLog("Converter.locationFileName =" + Converter.locationFileName);


                #endregion Parameteres&log

                #region loop on api record file sketolen, in outgoing folder.
                Converter.outBoxFolder = Path.GetDirectoryName(EDIOutgoingFolder) + Path.DirectorySeparatorChar;
                Converter.inBoxFolder = Converter.outBoxFolder.ToUpper().Replace("OUTBOX", "INBOX");
                Converter.ediArchivePath = EDIArchivePath;
                string partialNewName = Path.GetFileNameWithoutExtension(OutGoingFileName);
                string partialNewExtension = Path.GetExtension(OutGoingFileName);
                string partialName = Path.GetFileNameWithoutExtension(EDIOutgoingFolder);

                FileInfo[] filesInDirOut = Converter.GetFiles(Converter.outBoxFolder, OutGoingFileName);
                Converter.filesInDirOutlength = filesInDirOut.Length;
                FileInfo[] filesInDir = Converter.GetFilesByExt(Converter.outBoxFolder, partialName, Path.GetExtension(EDIOutgoingFolder));

                if (filesInDir.Length > 0)
                {
                    foreach (FileInfo fileInfo in filesInDir)
                    {
                        XmlDataDocument xmldoc = new XmlDataDocument();
                        string xmlstring = System.IO.File.ReadAllText(fileInfo.FullName);
                        if (xmlstring.IndexOf("<?xml version=\"1.0\" standalone=\"yes\"?>") > -1)
                        { xmlstring = xmlstring.Remove(0, 40); }
                        xmldoc.LoadXml(xmlstring);
                        Converter.xmlnodelist = xmldoc.GetElementsByTagName(Converter.networkOutGoingFileName);
                        if (Converter.xmlnodelist.Count > 0)
                        {
                            Converter.WriteJson(Converter.outBoxFolder + partialNewName, partialNewExtension);
                            fileInfo.CopyTo(Converter.outBoxFolder + Converter.ediArchivePath + Path.DirectorySeparatorChar + fileInfo.Name, true);
                            fileInfo.Delete();
                        }
                    }
                }
                #endregion loop on api record file sketolen, in outgoing folder.
            }

            static void WriteLog(string logString)
            {
                string path = Converter.outBoxFolder + "Shopify_Converter_log.txt";
                if (Converter.logWriteFlag == "Y")
                {
                    if (!File.Exists(path))
                    { System.IO.File.WriteAllText(path, logString + System.Environment.NewLine); }
                    else
                    { System.IO.File.AppendAllText(path, logString + System.Environment.NewLine); }
                }
            }

            static void GetInventoryItemID()
            {
                try
                {
                    FileInfo[] filesInDir = Converter.GetFiles(Converter.inBoxFolder, Converter.productFileName);
                    if (filesInDir.Length > 0)
                    {
                        string tempProductFileName = Converter.inBoxFolder + filesInDir[filesInDir.Length - 1].Name;


                        String SKU = Converter.xmlnode.SelectSingleNode("inventory_item_id").InnerText.Trim();
                        if (String.IsNullOrEmpty(SKU) == false)
                        {
                            XmlDataDocument xmldoc = new XmlDataDocument();
                            string xmlstring = System.IO.File.ReadAllText(tempProductFileName);
                            if (xmlstring.IndexOf("<?xml version=\"1.0\" standalone=\"yes\"?>") > -1)
                            { xmlstring = xmlstring.Remove(0, 40); }
                            xmldoc.LoadXml(xmlstring);
                            XmlNodeList xmlnodelist = xmldoc.GetElementsByTagName("variant");
                            if (xmlnodelist.Count > 0)
                            {
                                for (int i = 0; i <= xmlnodelist.Count - 1; i++)
                                {
                                    if (xmlnodelist[i].SelectSingleNode("sku").InnerText.Trim() == SKU)
                                    {
                                        Converter.xmlnode.SelectSingleNode("inventory_item_id").InnerText = xmlnodelist[i].SelectSingleNode("inventory-item-id").InnerText.Trim();
                                        break;
                                    }
                                }
                            }
                        }
                        else
                        {
                            Converter.WriteLog("Missing SKU");
                        }
                    }
                    else
                    {
                        Converter.WriteLog("Missing Products File");
                    }

                }
                catch (Exception ex) { Converter.WriteLog(ex.Message); }
            }

            static void GetLocationID()
            {
                try
                {
                    FileInfo[] filesInDir = Converter.GetFiles(Converter.inBoxFolder, Converter.locationFileName);
                    if (filesInDir.Length > 0)
                    {
                        string tempLocationFileName = Converter.inBoxFolder + filesInDir[filesInDir.Length - 1].Name;
                        string locationName = Converter.xmlnode.SelectSingleNode("location_id").InnerText.Trim().ToUpper();
                        if (String.IsNullOrEmpty(locationName) == false)
                        {
                            string jsonString = System.IO.File.ReadAllText(tempLocationFileName);
                            var contentJson = JsonConvert.DeserializeObject(jsonString);
                            var jsonLocations = ((Newtonsoft.Json.Linq.JContainer)contentJson)["locations"];
                            for (Int32 iCounter = 0; iCounter < ((Newtonsoft.Json.Linq.JContainer)jsonLocations).Count; iCounter++)
                            {
                                if (((Newtonsoft.Json.Linq.JContainer)jsonLocations)[iCounter]["name"].ToString().Trim().ToUpper() == locationName)
                                {
                                    Converter.xmlnode.SelectSingleNode("location_id").InnerText = ((Newtonsoft.Json.Linq.JContainer)jsonLocations)[iCounter]["id"].ToString();
                                    break;
                                }
                            }
                        }
                        else
                        {
                            Converter.WriteLog("Missing Location Name");
                        }
                    }
                    else
                    { Converter.WriteLog("Missing Locations File"); }

                }
                catch (Exception ex) { Converter.WriteLog(ex.Message); }
            }

            static void WriteJson(string fileName, string extenstion)
            {
                foreach (XmlNode xmlnode in Converter.xmlnodelist)
                {
                    Converter.filesInDirOutlength += 1;
                    Converter.xmlnode = xmlnode;
                    if (Converter.networkOutGoingFileName == "inventory_adjustment")
                    {
                        Converter.GetInventoryItemID();
                    }
                    Converter.GetLocationID();
                    string contentString = "";
                    if (Converter.networkOutGoingFileName == "inventory_adjustment")
                    { contentString = JsonConvert.SerializeXmlNode(Converter.xmlnode, Newtonsoft.Json.Formatting.Indented, Converter.jsonheader); }
                    else
                    { contentString = JsonConvert.SerializeXmlNode(Converter.xmlnode.ParentNode, Newtonsoft.Json.Formatting.Indented, Converter.jsonheader); }
                    string fullFileName = fileName + "_" + Converter.filesInDirOutlength.ToString().PadLeft(3, '0') + extenstion;
                    Converter.WriteLog("Write File:" + contentString);
                    System.IO.File.WriteAllText(fullFileName, contentString);
                    Converter.WriteLog("Write File:" + fullFileName);
                }
            }


            static FileInfo[] GetFiles(string folder, string FileName)
            {
                // FileName = "SHPOUT.XML";
                string partialFileName = Path.GetFileNameWithoutExtension(FileName);
                string partialExtension = Path.GetExtension(FileName);
                return GetFilesByExt(folder, partialFileName, partialExtension);
            }
            static FileInfo[] GetFilesByExt(string folder, string partialFileName, string partialExtension)
            {
                DirectoryInfo hdDirectoryInWhichToSearch = new DirectoryInfo(folder);

                FileInfo[] filesInDirOut = hdDirectoryInWhichToSearch.GetFiles(partialFileName + "*" + partialExtension);
                //FileInfo[] filesInDirOut2 = hdDirectoryInWhichToSearch.GetFiles();
            return filesInDirOut;
            }

        }
    }
