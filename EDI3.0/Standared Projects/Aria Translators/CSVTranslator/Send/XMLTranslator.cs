using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml;
using System.Xml.Xsl;

namespace CSVTranslator.Send
{
    public class XMLTranslator
    {
        public void SendXML(string ariaXMLFile, string OutgoingFile, string Transaction, string MapSet)
        {
             
            string inputXmlPath = ariaXMLFile; // Input XML file
            //string xsltPath = "D:\\SHARED\\ARIA4XP\\DLLS\\transform"+ Transaction+"_"+MapSet + ".xsl"; // XSLT file
            
            //Aria.Environment.AriaEnviromentVariables AriaConnection = new Aria.Environment.AriaEnviromentVariables();
            //string xsltPath = @AriaConnection.Aria40SharedPath+"DLLS\\transform" + Transaction + "_" + MapSet + ".xsl"; // XSLT file

            string dllLocation = Path.GetDirectoryName(GetType().Assembly.Location);
            string xsltPath = dllLocation + "\\" + "transform" + Transaction + "_" + MapSet + ".xsl"; // XSLT file

            if (MapSet == "PTG") {
                string originalPath = OutgoingFile;
                string directory = Path.GetDirectoryName(originalPath); // Get the directory path
                string fileName = Path.GetFileName(originalPath); // Get the file name
                string newFileName = Transaction + "_" + fileName; // Prefix the file name with "940_"
                OutgoingFile = Path.Combine(directory, newFileName); // Combine directory and new file name

            }
            string outputXmlPath = OutgoingFile;
            string errorOutputPath = OutgoingFile.Replace(".","_ERROR."); // Error log
                                                                                 

           
            try
            {
                // 1. Transform XML using XSLT
                TransformXml(inputXmlPath, xsltPath, outputXmlPath);

                // 2. Extract errors from the generated output file
                ExtractErrorsFromOutput(outputXmlPath, errorOutputPath);

                Console.WriteLine("\n✅ Transformation completed successfully.");

                if (File.Exists(errorOutputPath) && new FileInfo(errorOutputPath).Length > 0)
                {
                    Console.WriteLine("\n🔴 Errors and Warnings Found! Check ERROR_LOG.XML");
                }
                else
                {
                    Console.WriteLine("\n✅ No errors found.");
                    File.Delete(errorOutputPath); // Delete empty error file
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("\n❌ Error: " + ex.Message);
            }

        }

        public void TransformXml(string inputXml, string xsltPath, string outputXml)
        {
            System.Xml.Xsl.XslCompiledTransform xslt = new System.Xml.Xsl.XslCompiledTransform();
            xslt.Load(xsltPath);
            var settings = new XmlWriterSettings
            {
                Encoding = new UTF8Encoding(encoderShouldEmitUTF8Identifier: false), // 👈 No BOM
                Indent = xslt.OutputSettings.Indent,
                OmitXmlDeclaration = xslt.OutputSettings.OmitXmlDeclaration
            };

            using (XmlReader reader = XmlReader.Create(inputXml))
            using (XmlWriter writer = XmlWriter.Create(outputXml, settings))
            {
                xslt.Transform(reader, null, writer);
            }
            //using (XmlWriter writer = XmlWriter.Create(outputXml, xslt.OutputSettings))
            //{
            //    xslt.Transform(reader, null, writer);
            //}
        }

        public void ExtractErrorsFromOutput(string outputXml, string errorOutput)
        {
            XmlDocument doc = new XmlDocument();
            doc.Load(outputXml);

            XmlDocument errorDoc = new XmlDocument();
            XmlNode root = errorDoc.CreateElement("ERRORS");
            errorDoc.AppendChild(root);

            // Find all error or warning nodes dynamically in the transformed output
            XmlNodeList errorNodes = doc.SelectNodes("//ERRORS | //WARNINGS");

            foreach (XmlNode node in errorNodes[0].ChildNodes)
            {
                XmlNode importedNode = errorDoc.ImportNode(node, true);
                root.AppendChild(importedNode);
            }

            // Remove the errors from the original output file
            foreach (XmlNode node in errorNodes)
            {
                node.ParentNode.RemoveChild(node);
            }

            // Save the cleaned output file
            //doc.Save(outputXml);
            using (var writer = new StreamWriter(outputXml, false, new UTF8Encoding(false))) // false = no BOM
            {
                doc.Save(writer);
            }


            // Save errors to a separate error file if there are any
            if (root.HasChildNodes)
            {
                errorDoc.Save(errorOutput);
            }
        }

        public void ReceiveXML(string InComingFile, string AriaXML, string Transaction, string MappingCode)
        { 
            string inputXmlPath = InComingFile; // Input XML file
            //string xsltPath = "D:\\SHARED\\ARIA4XP\\DLLS\\transform"+ Transaction+"_"+ MappingCode + ".xsl"; // XSLT file
            //Aria.Environment.AriaEnviromentVariables AriaConnection = new Aria.Environment.AriaEnviromentVariables();
            //string xsltPath = @AriaConnection.Aria40SharedPath + "DLLS\\transform" + Transaction + "_" + MappingCode + ".xsl"; // XSLT file


            string dllLocation = Path.GetDirectoryName(GetType().Assembly.Location);
            string xsltPath = dllLocation + "\\" + "transform" + Transaction + "_" + MappingCode + ".xsl"; // XSLT file

            string validOutputPath = AriaXML; // Valid output
            string errorOutputPath = AriaXML.Replace(".", "_ERROR."); // Error log
            try
            {
                // Load the XSLT
                XslCompiledTransform xslt = new XslCompiledTransform();
                xslt.Load(xsltPath);

                // Load input XML
                using (XmlReader reader = XmlReader.Create(inputXmlPath))
                {
                    // Apply transformation to generate valid data file
                    using (XmlWriter validWriter = XmlWriter.Create(validOutputPath, xslt.OutputSettings))
                    {
                        xslt.Transform(reader, null, validWriter);
                    }
                }

                // Display error file if it exists
                if (File.Exists(errorOutputPath))
                {
                    Console.WriteLine("\n🔴 Errors and Warnings Found:");
                    Console.WriteLine("--------------------------------");
                    string errors = File.ReadAllText(errorOutputPath);
                    Console.WriteLine(errors);
                }
                else
                {
                    Console.WriteLine("\n✅ Transformation completed successfully. No errors or warnings found.");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("\n❌ Error: " + ex.Message);
            }

             
        }

    }
}
