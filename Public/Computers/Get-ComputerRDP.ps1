function Get-ComputerRDP {
    [alias('Get-RDPSecurity')]
    [cmdletbinding()]
    param(
        [string[]] $ComputerName
    )
    <#
    Caption                                :
    Description                            :
    InstallDate                            :
    Name                                   :
    Status                                 :
    TerminalName                           : RDP-Tcp
    CertificateName                        :
    Certificates                           : {0, 0, 0, 0...}
    Comment                                :
    MinEncryptionLevel                     : 2
    PolicySourceMinEncryptionLevel         : 0
    PolicySourceSecurityLayer              : 0
    PolicySourceUserAuthenticationRequired : 0
    SecurityLayer                          : 2
    SSLCertificateSHA1Hash                 : 696F767CD537FA3A172D11EF949C44779030464C
    SSLCertificateSHA1HashType             : 1
    TerminalProtocol                       : Microsoft RDP 8.0
    Transport                              : tcp
    UserAuthenticationRequired             : 1
    WindowsAuthentication                  : 0
    PSComputerName                         : AD2
    #>
    # https://docs.microsoft.com/en-us/windows/win32/termserv/win32-tsgeneralsetting
    $Output = Get-CimData -class 'Win32_TSGeneralSetting' -NameSpace 'root\cimv2\terminalservices' -ComputerName $ComputerName
    foreach ($_ in $Output) {


        #Low level of encryption. Only data sent from the client to the server is encrypted using 56-bit encryption. Be aware that data sent from the server to the client is not encrypted.
        #Client compatible level of encryption. All data sent from client to server and from server to client is encrypted at the maximum key strength supported by the client.
        #High level of encryption. All data sent from client to server and from server to client is encrypted using strong 128-bit encryption. Clients that do not support this level of encryption cannot connect.
        #FIPS compliant encryption. All data sent from client to server and from server to client is encrypted and decrypted with the Federal Information Processing Standard (FIPS) encryption algorithms using the Microsoft cryptographic modules. FIPS is a standard entitled "Security Requirements for Cryptographic Modules". FIPS 140-1 (1994) and FIPS 140-2 (2001) describe government requirements for hardware and software cryptographic modules used within the U.S. government.

        $EncryptionLevels = @{
            '1' = 'Low'
            '2' = 'Medium / Client Compatible'
            '3' = 'High'
            '4' = 'FIPS Compliant'
        }

        $PolicyConfiguredBy = @{
            '0' = 'Server'
            '1' = 'Group policy'
            '2' = 'Default'
        }

        #Qualifiers: RDPSecurityLayer ("RDP Security Layer: Communication between the serverand the client will use native RDP encryption."),
        #Negotiate ("The most secure layer that is supported by the client will be used.If supported, TLS 1.0 will be used."),
        #SSL ("SSL (TLS 1.0) will be used for server authentication as well as forencrypting all data transferred between the server and the client.This setting requires the server to have an SSL compatible certificate."),
        #NEWTBD ("A NEW SECURITY LAYER in LONGHORN.")
        #Specifies the security layer used between the client and server.

        $SecurityLayers = @{
            '1' = 'RDP Security Layer' # Communication between the server and the client uses native RDP encryption.
            '2' = 'Negotiate' # The most secure layer that is supported by the client is used. If supported, SSL (TLS 1.0) is used.
            '3' = 'SSL' # SSL (TLS 1.0) is used for server authentication and for encrypting all data transferred between the server and the client. This setting requires the server to have an SSL-compatible certificate. This setting is not compatible with a MinEncryptionLevel value of 1.
            '4' = 'NEWTBD' # A new security layer.
        }

        $HashType = @{
            '0' = 'Not valid'
            '1' = 'Self-signed'
            '2' = 'Custom'
        }

        $Connectivity = Test-ComputerPort -ComputerName $_.PSComputerName -PortTCP 3389 -WarningAction SilentlyContinue

        [PSCustomObject] @{
            ComputerName                           = $_.PSComputerName
            Name                                   = $_.TerminalName
            Connectivity                           = $Connectivity.Status
            ConnectivitySummary                    = $Connectivity.Summary
            SecurityLayer                          = $SecurityLayers["$($_.SecurityLayer)"]
            MinimalEncryptionLevel                 = $EncryptionLevels["$($_.MinEncryptionLevel)"]
            MinimalEncryptionLevelValue            = $_.MinEncryptionLevel
            PolicySourceUserAuthenticationRequired = $PolicyConfiguredBy["$($_.PolicySourceUserAuthenticationRequired)"]
            PolicySourceMinimalEncryptionLevel     = $PolicyConfiguredBy["$($_.PolicySourceMinEncryptionLevel)"]
            PolicySourceSecurityLayer              = $PolicyConfiguredBy["$($_.PolicySourceSecurityLayer)"]
            CertificateName                        = $_.CertificateName
            CertificateThumbprint                  = $_.SSLCertificateSHA1Hash
            CertificateType                        = $HashType["$($_.SSLCertificateSHA1HashType)"]
            Transport                              = $_.Transport
            Protocol                               = $_.TerminalProtocol
            # Specifies the type of user authentication used for remote connections
            UserAuthenticationRequired             = [bool] $_.UserAuthenticationRequired
            # Specifies whether the connection defaults to the standard Windows authentication process or to another authentication package that has been installed on the system.
            WindowsAuthentication                  = [bool] $_.WindowsAuthentication
        }
    }
}

#
#Get-RDPSecurity -ComputerName AD1 #, AD2
