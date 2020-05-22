function New-PACRestMethodBody {
    [CmdletBinding()]
    param (
        # body value
        [Parameter(Position=0)]
        [string]
        $BodyString
    )
    begin {}
    
    process {
        if ($BodyString) {
            New-Object RestMethodBody @($BodyString)
        } else {
            New-Object RestMethodBody @()
        }
    }
    
    end {}
}