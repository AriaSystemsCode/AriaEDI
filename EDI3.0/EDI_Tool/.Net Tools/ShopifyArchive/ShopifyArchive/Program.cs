using System;
using System.IO;

namespace ShopifyArchive
{
    class Program
    {
        static void Main(string[] args)
        {
            string OutGoingFileName = args[0].ToString();
            string EDIClientPath = args[1].ToString();
            
            //Console.WriteLine("OutGoingFileName =" + OutGoingFileName);
            //Console.WriteLine("EDIClientPath =" + EDIClientPath);
            
            //string OutGoingFileName = "SHPINV.json";
            //string EDIClientPath = @"X:\ARIA3EDI";

            // loop on api record file sketolen, in outgoing folder.
            string partialNewName = Path.GetFileNameWithoutExtension(OutGoingFileName);
            string partialNewExtension = Path.GetExtension(OutGoingFileName);

            string partialName = Path.GetFileNameWithoutExtension(OutGoingFileName);
            DirectoryInfo hdDirectoryInWhichToSearch = new DirectoryInfo(EDIClientPath + @"\EDI\OUTBOX\");
            FileInfo[] filesInDir = hdDirectoryInWhichToSearch.GetFiles(partialName + "*" + Path.GetExtension(OutGoingFileName));
            string newfilename = partialName;
            if (filesInDir.Length > 0)
            { foreach (var file in filesInDir)
                file.Delete();
            }

        }
    }
}
