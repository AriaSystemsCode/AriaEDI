using Microsoft.TeamFoundation.Client;
using Microsoft.TeamFoundation.VersionControl.Client;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;

namespace EDISOURCESAFE
{
    public class SourceSafe
    {
        public string TfsConnection
        {
            get;
            set;
        }
        public string UserName
        {
            get;
            set;
        }
        public string password
        {
            get;
            set;
        }
        public string domain
        {
            get;
            set;
        }
        public string WorkSapceName
        {
            get;
            set;
        }
        public string tfsMappingPathValue
        {
            get;
            set;
        }
        public string LocalTfsWorkSpacePath
        {
            get;
            set;
        }
        public int Init(string tfsconn, string username, string password, string domain, string workspacename, string MappingPathValue, string LocalTfsPath)
        {
            this.TfsConnection = tfsconn;
            this.UserName = username;
            this.password = password;
            this.domain = domain;
            this.WorkSapceName = workspacename;
            this.tfsMappingPathValue = MappingPathValue;
            this.LocalTfsWorkSpacePath = LocalTfsPath;
            return 1;
        }
        public SourceSafe() { }
        public bool GetlatestVersion()
        {
            Workspace workspace = CreateNewWorkSpace();
            var LatestRequest = new GetRequest(new ItemSpec(tfsMappingPathValue, RecursionType.Full), VersionSpec.Latest);
            var results = workspace.Get(LatestRequest, GetOptions.GetAll | GetOptions.Overwrite);

            return results.NumFiles > 0 ? true : false;
        }
        public bool GetlatestVersionFile(string FilePath)
        {
            Workspace workspace = CreateNewWorkSpace();
            var LatestRequest = new GetRequest(new ItemSpec(FilePath, RecursionType.None), VersionSpec.Latest);
            var results = workspace.Get(LatestRequest, GetOptions.GetAll | GetOptions.Overwrite);

            return results.NumFiles > 0 ? true : false;
        }
        public Workspace CreateNewWorkSpace()
        {
            Uri TfsUri = new Uri(TfsConnection);
            NetworkCredential credential = new NetworkCredential(UserName, password, domain);
            //TeamFoundationServer tfs = new TeamFoundationServer(TfsConnection, credential);
            TeamFoundationServer tfs = new TeamFoundationServer(TfsConnection, credential);
            VersionControlServer vcs = tfs.GetService(typeof(VersionControlServer)) as VersionControlServer;
            //Workspace wrk = vcs.TryGetWorkspace(WorkSapceName);
            try
            {
                vcs.DeleteWorkspace(WorkSapceName, UserName);
            }
            catch (Exception e) { }
            vcs.CreateWorkspace(WorkSapceName, UserName);

            Workspace WorkSpac = vcs.GetWorkspace(WorkSapceName, UserName);
            WorkSpac.Map(tfsMappingPathValue, LocalTfsWorkSpacePath);

            return WorkSpac;
        }
        public bool  CheckIn(string NewfilePath, string DestinationTfsPath, string CheckInComment)
        {
                if (!string.IsNullOrEmpty(NewfilePath) && File.Exists(NewfilePath) && !string.IsNullOrEmpty(DestinationTfsPath))
                {
                    Workspace NeWworkSpace = CreateNewWorkSpace();
                    string fullDestinationPath = Path.Combine(NeWworkSpace.Folders[0].LocalItem, DestinationTfsPath);
                    if (!Directory.Exists(fullDestinationPath))
                    {
                        Directory.CreateDirectory(fullDestinationPath);
                    }
                    if (File.Exists(Path.Combine(fullDestinationPath, Path.GetFileName(NewfilePath))))
                    File.SetAttributes(Path.Combine(fullDestinationPath, Path.GetFileName(NewfilePath)), FileAttributes.Normal);

                    File.Copy(NewfilePath, Path.Combine(fullDestinationPath , Path.GetFileName(NewfilePath)),true);
                    NeWworkSpace.PendAdd(Path.Combine(fullDestinationPath, Path.GetFileName(NewfilePath)));
                    PendingChange[] pendingChanges = NeWworkSpace.GetPendingChanges();
                    if (pendingChanges.Length <= 0)
                        return false;

                    int changesetNumber = NeWworkSpace.CheckIn(pendingChanges, CheckInComment);
                    return changesetNumber > 0 ?  true : false;
                    //return fullDestinationPath;
                }
                else
                {
                    return false;
                }
        }

    }
            

}

