using module .\AtlassianContext.psm1

class PowerAtlassianGlobal {

    #####################
    # HIDDEN PROPERTIES #
    #####################

    

    #####################
    # PUBLIC PROPERTIES #
    #####################

    [AtlassianContext]
    $Context

    #####################
    # CONSTRUCTORS      #
    #####################

    

    #####################
    # HIDDEN METHODS    #
    #####################

    

    #####################
    # PUBLIC METHODS    #
    #####################

    [void]
    OpenSession(
        [AtlassianContext]$AtlassianContext
    ){
        $this.Context = $AtlassianContext
    }

    [void]
    CloseSession(){
        $this.Context = $null
    }

}