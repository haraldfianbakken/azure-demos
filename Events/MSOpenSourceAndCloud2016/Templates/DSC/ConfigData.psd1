@{

    AllNodes = @(    
        @{        
            NodeName = "*"
            PSDSCAllowPlainTextPassword=$true;
        }
        @{
            NodeName = 'localhost'
        }
        @{
            NodeName = 'ServerConfiguration'
        }
    )
}