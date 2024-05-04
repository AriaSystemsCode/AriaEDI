using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EDI_VAN
{
   public class NetworkProfilesViewModel
   {
       public ObservableCollection<EDI_VAN_LIB.NetworkProfiles> Networks { get; set; }

        public NetworkProfilesViewModel()
        {
            Networks = new ObservableCollection<EDI_VAN_LIB.NetworkProfiles>();
        }

      
    }
}
