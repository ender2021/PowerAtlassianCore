using module ..\..\PowerAtlassianCore\classes\AtlassianContext.psm1
using module ..\..\PowerAtlassianCore\classes\PowerAtlassianGlobal.psm1

Describe "PowerAtlassianGlobal (Class)" {
    Context "Constructors" {
        
    }
    Context "Session Methods" {
        $jiraContext = New-Object JiraContext @("1","2","3")
        $pjg = New-Object PowerAtlassianGlobal

        It "OpenSession sets the passed AtlassianContext object to the Context property" {
            $pjg.OpenSession($jiraContext)
            $pjg.Context | Should -Be $jiraContext
        }
        It "CloseSession sets the Context property to null" {
            $pjg.Context = $jiraContext
            $pjg.CloseSession()
            $pjg.Context | Should -BeNullOrEmpty
        }
    }
}