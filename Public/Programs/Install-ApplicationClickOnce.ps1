function Install-ApplicationClickOnce {
    [CmdletBinding()]
    Param(
        [string] $Manifest,
        [switch] $ElevatePermissions
    )
    Try {

        Add-Type -AssemblyName System.Deployment

        Write-Verbose "Install-ApplicationClickOnce - Start installation of ClickOnce Application $Manifest"

        $RemoteURI = [URI]::New( $Manifest , [UriKind]::Absolute)
        if (-not $Manifest) {
            Write-Warning "Invalid Manifest (URL) parameter $RemoteURI"
            return
        }

        $HostingManager = New-Object System.Deployment.Application.InPlaceHostingManager -ArgumentList $RemoteURI , $False

        #register an event to trigger custom event (yep, its a hack)
        $null = Register-ObjectEvent -InputObject $HostingManager -EventName GetManifestCompleted -Action {
            new-event -SourceIdentifier "ManifestDownloadComplete"
        }
        #register an event to trigger custom event (yep, its a hack)
        $null = Register-ObjectEvent -InputObject $HostingManager -EventName DownloadApplicationCompleted -Action {
            new-event -SourceIdentifier "DownloadApplicationCompleted"
        }

        #get the Manifest
        $HostingManager.GetManifestAsync()

        #Waitfor up to 5s for our custom event
        $event = Wait-Event -SourceIdentifier "ManifestDownloadComplete" -Timeout 5
        if ($event ) {
            $event | Remove-Event
            Write-Verbose "Install-ApplicationClickOnce - ClickOnce Manifest Download Completed"

            $HostingManager.AssertApplicationRequirements($ElevatePermissions)
            #todo :: can this fail ?

            #Download Application
            $HostingManager.DownloadApplicationAsync()
            #register and wait for completion event
            # $HostingManager.DownloadApplicationCompleted
            $event = Wait-Event -SourceIdentifier "DownloadApplicationCompleted" -Timeout 15
            if ($event ) {
                $event | Remove-Event
                Write-Verbose "Install-ApplicationClickOnce - ClickOnce Application Download Completed"
            } else {
                Write-Error "Install-ApplicationClickOnce - ClickOnce Application Download did not complete in time (15s)"
            }
        } else {
            Write-Error "Install-ApplicationClickOnce - ClickOnce Manifest Download did not complete in time (5s)"
        }

        #Clean Up
    } finally {
        #get rid of our eventhandlers
        Get-EventSubscriber| Where-Object {$_.SourceObject.ToString() -eq 'System.Deployment.Application.InPlaceHostingManager'} | Unregister-Event
    }
}