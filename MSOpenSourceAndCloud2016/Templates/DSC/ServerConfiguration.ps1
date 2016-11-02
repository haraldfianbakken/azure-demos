Configuration ServerConfiguration {

    Import-DscResource -ModuleName PSDesiredStateConfiguration;
    Import-DscResource -ModuleName XPSDesiredStateConfiguration;

    Node $AllNodes.NodeName {
        
        File EnsureTemp {
            DestinationPath = 'c:\tmp'
            Type = 'Directory'
            Ensure = 'Present'             
        }
        
        xRemoteFile DownloadLogo {
            DependsOn = '[File]EnsureTemp'
            DestinationPath = 'C:\Tmp'
            Uri = 'http://lorempixel.com/400/200/'
        }                

    }
    
}


ServerConfiguration -ConfigurationData (Import-powershelldatafile .\ConfigData.psd1) 