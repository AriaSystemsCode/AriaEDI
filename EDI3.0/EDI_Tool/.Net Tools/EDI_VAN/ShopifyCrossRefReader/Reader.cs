using System;
using System.Collections.Generic;
using System.Xml;

namespace ShopifyCrossRefReader
{
    public class Reader
    {

        public static void  Do(string fileName)
        {
            XmlDocument xml = new XmlDocument();
            xml.Load(fileName);
            XmlNodeList nodes = xml.SelectNodes("variant");
            if (nodes.Count > 0)
            {
                //insert into ItemsRef

            }


        }
    }
}
