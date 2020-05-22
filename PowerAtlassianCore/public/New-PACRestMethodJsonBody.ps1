function New-PACRestMethodJsonBody {
    [CmdletBinding()]
    param (
        # body values
        [Parameter(Position=0)]
        [hashtable]
        $Values
    )
    begin {}
    
    process {
        if ($Values) {
            New-Object RestMethodJsonBody @($Values)
        } else {
            New-Object RestMethodJsonBody @()
        }
    }
    
    end {}
}