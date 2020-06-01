class AtlassianContext {
    #####################
    # HIDDEN PROPERTIES #
    #####################
    
    #####################
    # PUBLIC PROPERTIES #
    #####################

    [hashtable]
    $AuthHeader

    [string]
    $HostName

    [ValidateRange(1,10)]
    [int32]
    $Retries
    
    [ValidateRange(1, 60)]
    [int32]
    $RetryDelay

    ################
    # CONSTRUCTORS #
    ################

    AtlassianContext(
        [string]$UserName,
        [string]$ApiKey,
        [string]$HostName
    ){
        $this.Init($UserName,$ApiKey,$HostName,1,1)
    }

    AtlassianContext(
        [string]$UserName,
        [string]$ApiKey,
        [string]$HostName,
        [int32]$Retries,
        [int32]$RetryDelay
    ){
        $this.Init($UserName,$ApiKey,$HostName,$Retries,$RetryDelay)
    }

    ##################
    # HIDDEN METHODS #
    ##################

    hidden
    [void]
    Init(
        [string]$UserName,
        [string]$ApiKey,
        [string]$HostName,
        [int32]$Retries,
        [int32]$RetryDelay
    ){
        # create the unencoded string
        $credentialsText = "$UserName`:$ApiKey"

        # encode the string in base64
        $credentialsBytes = [System.Text.Encoding]::UTF8.GetBytes($credentialsText)
        $encodedCredentials = [Convert]::ToBase64String($credentialsBytes)

        # format the host name
        $formattedHost = (&{If($HostName.EndsWith("/")) {$HostName.Substring(0,$HostName.Length-1)} else {$HostName}})

        # set the object properties
        $this.AuthHeader = @{Authorization="Basic $encodedCredentials"}
        $this.HostName = $formattedHost
        $this.Retries = $Retries
        $this.RetryDelay = $RetryDelay
    }

    ##################
    # PUBLIC METHODS #
    ##################

    
}