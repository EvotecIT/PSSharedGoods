function Get-PSRegistryDictionaries {
    [cmdletBinding()]
    param(

    )
    if ($Script:Dictionary) {
        return
    }
    $Script:Dictionary = @{
        # Those don't really exists, but we want to allow targetting all users or default users
        'HKUAD:'  = 'HKEY_ALL_USERS_DEFAULT' # All users in HKEY_USERS including .DEFAULT
        'HKUA:'   = 'HKEY_ALL_USERS' # All users in HKEY_USERS excluding .DEFAULT
        'HKUD:'   = 'HKEY_DEFAULT_USER' # DEFAULT user in HKEY_USERS
        'HKUDUD:' = 'HKEY_ALL_DOMAIN_USERS_DEFAULT'
        'HKUDU:'  = 'HKEY_ALL_DOMAIN_USERS'
        # order matters
        'HKCR:'   = 'HKEY_CLASSES_ROOT'
        'HKCU:'   = 'HKEY_CURRENT_USER'
        'HKLM:'   = 'HKEY_LOCAL_MACHINE'
        'HKU:'    = 'HKEY_USERS'
        'HKCC:'   = 'HKEY_CURRENT_CONFIG'
        'HKDD:'   = 'HKEY_DYN_DATA'
        'HKPD:'   = 'HKEY_PERFORMANCE_DATA'
    }

    $Script:HiveDictionary = [ordered] @{
        # Those don't really exists, but we want to allow targetting all users or default users
        # The order matters
        'HKEY_ALL_USERS_DEFAULT'        = 'All+Default'
        'HKUAD'                         = 'All+Default'
        'HKEY_ALL_USERS'                = 'All'
        'HKUA'                          = 'All'
        'HKEY_ALL_DOMAIN_USERS_DEFAULT' = 'AllDomain+Default'
        'HKUDUD'                        = 'AllDomain+Default'
        'HKEY_ALL_DOMAIN_USERS'         = 'AllDomain'
        'HKUDU'                         = 'AllDomain'
        'HKEY_DEFAULT_USER'             = 'Default'
        'HKUD'                          = 'Default'
        # Those exists
        'HKEY_CLASSES_ROOT'             = 'ClassesRoot'
        'HKCR'                          = 'ClassesRoot'
        'ClassesRoot'                   = 'ClassesRoot'
        'HKCU'                          = 'CurrentUser'
        'HKEY_CURRENT_USER'             = 'CurrentUser'
        'CurrentUser'                   = 'CurrentUser'
        'HKLM'                          = 'LocalMachine'
        'HKEY_LOCAL_MACHINE'            = 'LocalMachine'
        'LocalMachine'                  = 'LocalMachine'
        'HKU'                           = 'Users'
        'HKEY_USERS'                    = 'Users'
        'Users'                         = 'Users'
        'HKCC'                          = 'CurrentConfig'
        'HKEY_CURRENT_CONFIG'           = 'CurrentConfig'
        'CurrentConfig'                 = 'CurrentConfig'
        'HKDD'                          = 'DynData'
        'HKEY_DYN_DATA'                 = 'DynData'
        'DynData'                       = 'DynData'
        'HKPD'                          = 'PerformanceData'
        'HKEY_PERFORMANCE_DATA '        = 'PerformanceData'
        'PerformanceData'               = 'PerformanceData'

    }

    $Script:ReverseTypesDictionary = [ordered] @{
        'REG_SZ'        = 'string'
        'REG_EXPAND_SZ' = 'expandstring'
        'REG_BINARY'    = 'binary'
        'REG_DWORD'     = 'dword'
        'REG_MULTI_SZ'  = 'multistring'
        'REG_QWORD'     = 'qword'
        'string'        = 'string'
        'expandstring'  = 'expandstring'
        'binary'        = 'binary'
        'dword'         = 'dword'
        'multistring'   = 'multistring'
        'qword'         = 'qword'
    }
}