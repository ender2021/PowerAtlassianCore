using module ..\..\PowerJira\classes\AtlassianContext.psm1
using module ..\..\PowerJira\classes\PowerAtlassianGlobal.psm1

Describe "PowerJiraGlobal (Class)" {
    Context "Constructors" {
        
    }
    Context "Session Methods" {
        $jiraContext = New-Object JiraContext @("1","2","3")
        $pjg = New-Object PowerJiraGlobal

        It "OpenSession sets the passed JiraContext object to the Context property" {
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