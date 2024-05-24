using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace UnitTestWindowsLog
{
    [TestClass]
    public class UnitTest_WriteLog
    {
        [TestMethod]
        public void TestWriteLog()
        {
            Assert.IsTrue(WindowsLog.WindowsLog.WriteLog("Application", "EDI Network Log string test 103", 103, 0));

        }
    }
}
