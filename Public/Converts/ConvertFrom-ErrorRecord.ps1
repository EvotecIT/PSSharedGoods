#
# https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/making-error-records-more-readable

function ConvertFrom-ErrorRecord
{
  param
  (
    # we receive either a legit error record...
    [Management.Automation.ErrorRecord[]]
    [Parameter(
        Mandatory,ValueFromPipeline,
        ParameterSetName='ErrorRecord')]
    $ErrorRecord,

    # ...or a special stop exception which is raised by
    # cmdlets with -ErrorAction Stop
    [Management.Automation.ActionPreferenceStopException[]]
    [Parameter(
        Mandatory,ValueFromPipeline,
        ParameterSetName='StopException')]
    $Exception
  )



  process
  {
    # if we received a stop exception in $Exception,
    # the error record is to be found inside of it
    # in all other cases, $ErrorRecord was received
    # directly
    if ($PSCmdlet.ParameterSetName -eq 'StopException')
    {
      $ErrorRecord = $Exception.ErrorRecord
    }

    # compose a new object out of the interesting properties
    # found in the error record object
    $ErrorRecord | ForEach-Object { [PSCustomObject]@{
        Exception = $_.Exception.Message
        Reason    = $_.CategoryInfo.Reason
        Target    = $_.CategoryInfo.TargetName
        Script    = $_.InvocationInfo.ScriptName
        Line      = $_.InvocationInfo.ScriptLineNumber
        Column    = $_.InvocationInfo.OffsetInLine
      }
    }
  }
}