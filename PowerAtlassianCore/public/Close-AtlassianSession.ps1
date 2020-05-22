function Close-AtlassianSession() {
    process {
        $Global:PowerAtlassian.CloseSession()
    }
}