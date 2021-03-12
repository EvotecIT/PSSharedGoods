#import-module 'C:\Support\GitHub\PSWriteHTML\PSWriteHTML.psd1' -force
Import-Module .\PSSharedGoods.psd1 -Force

$DataTable3 = @(
    [PSCustomObject] @{
        #'Tree Parent?'                                      = 'Testing Tree ?'
        #'Other Tree (Rigth)'                                = 'Ok You mean Me (Test)'
        #'Hierarchy Table Recaluculation interval (minutes)' = "\\*\NETLOGON"
        #"Test"                                              = "\\Ooops\C$\Windows\System32\config\netlogon.dns"
        #"\\*\SYSVOL"                                        = 'Test me \\*\SYSVOL and \\*\NETLOGON shares.'
        #"\\*\NETLOGON"                                      = 'Test me \\*\SYSVOL and \\*\NETLOGON shares.'
        #'Test^'                                             = 'Oops1'
        #"Hello+Motto"                                       = 'Oops2'
        #'Hello|Motto'                                       = 'Oops3'
        #'Hello{Value}'                                      = 'Oops4'
        #'Hello$Value'                                       = 'Oops5'
        #'Hello.Value'                                       = 'Oops6'
        #'Hello Value' = 'Oops7.Test $_'
        #'mmm'         = '$ test'
        'mm $_ eh'    = @(
            'Test', 'oops'
        )
    }
)
$DataTable3 | ConvertTo-JsonLiteral -ArrayJoin -ArrayJoinString ','
$DataTable3 | Out-HtmlView -DataStore JavaScript -FilePath $PSScriptRoot\Example7_10_DataStoreJava.html -Online