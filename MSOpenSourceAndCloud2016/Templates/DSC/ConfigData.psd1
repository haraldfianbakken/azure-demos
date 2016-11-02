@{

    AllNodes = @(    
        @{        
            NodeName = "*"
            PSDSCAllowPlainTextPassword=$true;
        }
        @{
            NodeName = 'localhost'
        }
    )
}