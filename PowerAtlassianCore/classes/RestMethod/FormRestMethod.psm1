using module ..\AtlassianContext.psm1
using module .\RestMethodQueryParams.psm1
using module .\RestMethod.psm1

class FormRestMethod : RestMethod {

    #####################
    # HIDDEN PROPERTIES #
    #####################
    
    #####################
    # PUBLIC PROPERTIES #
    #####################

    # Form values for a multipart request
    [hashtable]
    $Form

    ################
    # CONSTRUCTORS #
    ################

    #form only
    FormRestMethod(
        [string]$FunctionPath,
        [string]$HttpMethod,
        [hashtable]$Form
    ) : base($FunctionPath,$HttpMethod) {
        $this.FormInit($Form)
    }

    #form + query
    FormRestMethod(
        [string]$FunctionPath,
        [string]$HttpMethod,
        [RestMethodQueryParams]$Query,
        [hashtable]$Form
    ) : base($FunctionPath,$HttpMethod,$Query) {
        $this.FormInit($Form)
    }

    ##################
    # HIDDEN METHODS #
    ##################

    hidden
    [void]
    FormInit([hashtable]$Form){
        $this.Form = $Form
        if(!$this.Headers.ContainsKey("X-Atlassian-Token")) {
            $this.Headers.Add("X-Atlassian-Token","no-check")
        }
    }

    hidden
    [string]
    BodyLines([string]$Boundary) {
        $fileName = $this.Form.file.Name
        $fileBytes = [System.IO.File]::ReadAllBytes($this.Form.file);
        $fileEnc = [System.Text.Encoding]::GetEncoding('ISO-8859-1').GetString($fileBytes);
        $LF = "`r`n";

        return ( 
            "--$Boundary",
            "Content-Disposition: form-data; name=`"file`"; filename=`"$fileName`"",
            "Content-Type: application/octet-stream$LF",
            $fileEnc,
            "--$Boundary--$LF" 
        ) -join $LF
    }

    ##################
    # PUBLIC METHODS #
    ##################

    [object]
    Invoke(
        [AtlassianContext]$AtlassianContext
    ){
        $AtlassianContext = [RestMethod]::FillContext($AtlassianContext)
        $boundary = [System.Guid]::NewGuid().ToString()
        $bodyLines = $this.BodyLines($boundary)
        $invokeSplat = @{
            Uri = $this.Uri($AtlassianContext)
            Method = $this.HttpMethod
            Headers = $this.HeadersToSend($AtlassianContext) 
            MaximumRetryCount = $AtlassianContext.Retries
            RetryIntervalSec = $AtlassianContext.RetryDelay
            ContentType = "multipart/form-data; boundary=`"$boundary`""
            Body = $bodyLines
        }
        return [RestMethod]::RootInvoke($invokeSplat)
    }
}