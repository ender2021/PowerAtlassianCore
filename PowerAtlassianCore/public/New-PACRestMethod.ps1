function New-PACRestMethod {
    [CmdletBinding(DefaultParameterSetName="Default")]
    param (
        # Function Path
        [Parameter(Mandatory,Position=0)]
        [string]
        $FunctionPath,

        # HTTP Method
        [Parameter(Mandatory,Position=1)]
        [string]
        $HttpMethod,

        # Query Params
        [Parameter(Position=2)]
        [AllowNull()]
        [RestMethodQueryParams]
        $QueryParams,

        # Form
        [Parameter(Mandatory,Position=3,ParameterSetName="Form")]
        [hashtable]
        $Form,

        # Filepath
        [Parameter(Mandatory,Position=3,ParameterSetName="File")]
        [string]
        $FilePath,

        # Body
        [Parameter(Mandatory,Position=3,ParameterSetName="Body")]
        [RestMethodBody]
        $Body
    )
    begin {}
    
    process {
        #maybe a better way to check if query params were supplied?
        #idea is to allow supply null so that positional params can still be used
        #for the form/file/body options if the call doesn't need query params
        if ($QueryParams -and $null -ne $QueryParams) {
            switch ($PSCmdlet.ParameterSetName) {
                "Form" { New-Object FormRestMethod @($FunctionPath,$HttpMethod,$QueryParams,$Form) }
                "File" { New-Object FileRestMethod @($FunctionPath,$HttpMethod,$QueryParams,$FilePath) }
                "Body" { New-Object BodyRestMethod @($FunctionPath,$HttpMethod,$QueryParams,$Body) }
                Default { New-Object RestMethod @($FunctionPath,$HttpMethod,$QueryParams) }
            }
        } else {
            switch ($PSCmdlet.ParameterSetName) {
                "Form" { New-Object FormRestMethod @($FunctionPath,$HttpMethod,$Form) }
                "File" { New-Object FileRestMethod @($FunctionPath,$HttpMethod,$FilePath) }
                "Body" { New-Object BodyRestMethod @($FunctionPath,$HttpMethod,$Body) }
                Default { New-Object RestMethod @($FunctionPath,$HttpMethod) }
            }
        }
    }
    
    end {}
}