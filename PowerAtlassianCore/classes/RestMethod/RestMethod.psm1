using module ..\AtlassianContext.psm1
using module .\RestMethodQueryParams.psm1

class RestMethod {

    #####################
    # HIDDEN PROPERTIES #
    #####################
    
    #####################
    # PUBLIC PROPERTIES #
    #####################

    # The URI path of function to invoke (do not include host name)
    [ValidateNotNullOrEmpty()]
    [string]
    $FunctionPath

    # The HTTP method to use for the request
    [ValidateSet("GET","POST","PUT","PATCH","DELETE")]
    [string]
    $HttpMethod

    # Additional headers to be added to the request (Auth and Content Type are included automatically)
    [hashtable]
    $Headers=@{}

    # The default content type
    [string]
    $ContentType = 'application/json'

    # Parameters to be supplied to the method in the query string
    [RestMethodQueryParams]
    $Query

    ################
    # CONSTRUCTORS #
    ################

    #no params
    RestMethod(
        [string]$FunctionPath,
        [string]$HttpMethod
    ){
        $this.Init($FunctionPath,$HttpMethod)
    }

    #query params only
    RestMethod(
        [string]$FunctionPath,
        [string]$HttpMethod,
        [RestMethodQueryParams]$Query
    ){
        $this.Init($FunctionPath,$HttpMethod)
        $this.Query = $Query
    }

    ##################
    # HIDDEN METHODS #
    ##################

    hidden
    [void]
    Init(
        [string]$FunctionPath,
        [string]$HttpMethod
    ){
        $this.FunctionPath = if ($FunctionPath.StartsWith("/")) {$FunctionPath.Substring(1)} else {$FunctionPath}
        $this.HttpMethod = $HttpMethod
    }

    hidden
    static
    [AtlassianContext]
    FillContext(
        [AtlassianContext]$AtlassianContext
    ){
        if ($null -eq $AtlassianContext) {
            $toReturn = $Global:PowerAtlassian.Context
            if ($null -eq $toReturn) {
                throw "`$AtlassianContext was not provided when invoking a REST method"
            } else {
                return $toReturn
            }
        } else {
            return $AtlassianContext
        }
    }

    hidden
    static
    [object]
    RootInvoke(
        [hashtable]$splat
    ){
        $failCount = 0
        $callSuccess = $false
        $result = $null
        $maxRetries = $splat.MaximumRetryCount
        $retryDelay = $splat.RetryIntervalSec
        $splat.Remove("MaximumRetryCount")
        $splat.Remove("RetryIntervalSec")
        do {
            try {
                $result = Invoke-RestMethod @splat -ErrorAction "Stop"
                $callSuccess = $true
            } catch [System.Net.Http.HttpRequestException] {
                $failCount++
                if ($failCount -le $maxRetries) {
                    Write-Verbose "Error while invoking REST method; sleeping for $retryDelay seconds before re-attempting"
                    Start-Sleep -Seconds $retryDelay
                } else {
                    throw $_
                }
            }
        } while (!$callSuccess)
        return $result
    }

    ##################
    # PUBLIC METHODS #
    ##################

    [string]
    Uri(
        [AtlassianContext]$AtlassianContext
    ){
        $uri = $AtlassianContext.HostName + "/" + $this.FunctionPath
        if ($this.Query -and $this.Query.Params -and $this.Query.Params.Count -gt 0) {
            $uri += $this.Query.ToString()
        }
        return $uri
    }

    [hashtable]
    HeadersToSend(
        [AtlassianContext]$AtlassianContext
    ){
        #compile headers object
        $sendHeaders = @{}
        $sendHeaders += $AtlassianContext.AuthHeader
        $sendHeaders += $this.Headers
        return $sendHeaders
    }

    [object]
    Invoke(){
        return $this.Invoke($Global:PowerAtlassian.Context)
    }

    [object]
    Invoke(
        [AtlassianContext]$AtlassianContext
    ){
        $AtlassianContext = [RestMethod]::FillContext($AtlassianContext)
        $invokeSplat = @{
            Uri = $this.Uri($AtlassianContext)
            Method = $this.HttpMethod
            ContentType = $this.ContentType 
            Headers = $this.HeadersToSend($AtlassianContext) 
            MaximumRetryCount = $AtlassianContext.Retries
            RetryIntervalSec = $AtlassianContext.RetryDelay
        }
        return [RestMethod]::RootInvoke($invokeSplat)
    }
}