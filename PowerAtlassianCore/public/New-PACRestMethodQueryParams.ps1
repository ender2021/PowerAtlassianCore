function New-PACRestMethodQueryParams {
    [CmdletBinding()]
    param (
        # Function Path
        [Parameter(Position=0)]
        [object]
        $Params
    )
    begin {}
    
    process {
        if ($Params) {
            New-Object RestMethodQueryParams @($Params)
        } else {
            New-Object RestMethodQueryParams @()
        }
    }
    
    end {}
}