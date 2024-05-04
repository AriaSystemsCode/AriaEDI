using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Threading.Tasks;
using System.Windows;

namespace EDI_VAN
{
    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        void App_Startup(object sender, StartupEventArgs e)
        {
            MainWindow mainWindow = new MainWindow(e.Args);
            if (mainWindow.successfulFlag)
            { 
            MainWindow.Show();
            }
            else
            {
                //MainWindow.Show();
              Application.Current.Shutdown();
            }
        }
    }
}
