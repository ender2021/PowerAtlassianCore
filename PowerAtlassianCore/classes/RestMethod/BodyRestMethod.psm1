using module ..\AtlassianContext.psm1
using module .\RestMethodQueryParams.psm1
using module .\RestMethod.psm1
using module .\RestMethodBody.psm1
using module .\RestMethodJsonBody.psm1

class BodyRestMethod : RestMethod {

    #####################
    # HIDDEN PROPERTIES #
    #####################
    
    #####################
    # PUBLIC PROPERTIES #
    #####################

    # Parameters to be supplied to the method in the body
    [RestMethodBody]
    $Body

    ################
    # CONSTRUCTORS #
    ################

    #body only
    BodyRestMethod(
        [string]$FunctionPath,
        [string]$HttpMethod,
        [RestMethodBody]$Body
    ) : base($FunctionPath,$HttpMethod) {
        $this.Body = $Body
    }

    #body + query
    BodyRestMethod(
        [string]$FunctionPath,
        [string]$HttpMethod,
        [RestMethodQueryParams]$Query,
        [RestMethodBody]$Body
    ) : base($FunctionPath,$HttpMethod,$Query) {
        $this.Body = $Body
    }

    ##################
    # HIDDEN METHODS #
    ##################

    

    ##################
    # PUBLIC METHODS #
    ##################

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
            Body = $this.Body.ToString()
        }
        return [RestMethod]::RootInvoke($invokeSplat)
    }
}