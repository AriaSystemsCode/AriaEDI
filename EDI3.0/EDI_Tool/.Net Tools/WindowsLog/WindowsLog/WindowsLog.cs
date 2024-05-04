using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Runtime.InteropServices.WindowsRuntime;
using System.Text;
using System.Threading.Tasks;

namespace WindowsLog
{
    public class WindowsLog
    {
        public static bool WriteLog(string source, string logString, int eventID, short category)
        {
            using (EventLog eventLog = new EventLog(source))
            {
                eventLog.Source = source;
                eventLog.WriteEntry(logString, EventLogEntryType.Information, eventID, category);
                return eventLog.Entries[eventLog.Entries.Count - 1].Message.ToString().Contains(logString);
            }

        }
    }
}
