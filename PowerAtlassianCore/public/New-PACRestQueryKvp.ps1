function New-PACRestQueryKvp {
    [CmdletBinding()]
    param (
        # Function Path
        [Parameter(Mandatory,Position=0)]
        [string]
        $Key,

        # HTTP Method
        [Parameter(Mandatory,Position=1)]
        [object]
        $Value
    )
    begin {}
    
    process {
        New-Object RestQueryKvp @($Key,$Value)
    }
    
    end {}
}