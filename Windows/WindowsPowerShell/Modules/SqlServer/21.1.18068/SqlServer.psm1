#
# Script module for module 'SqlServer'
#
Set-StrictMode -Version Latest

# Set up some helper variables to make it easier to work with the module
$PSModule = $ExecutionContext.SessionState.Module
$PSModuleRoot = $PSModule.ModuleBase

# Import the appropriate nested binary module based on the current PowerShell version
$binaryModuleRoot = $PSModuleRoot

# Set FormatData and TypeData. This is being done explicitly because those attributes are not supported to be set in the manifest .psd1 file on linux/mac.
$formatFile = Join-Path -Path $PSModuleRoot -ChildPath "SQLProvider.Format.ps1xml"
Update-FormatData -AppendPath $formatFile
$typeFile = Join-Path -Path $PSModuleRoot -ChildPath "SQLProvider.Types.ps1xml"
Update-TypeData -PrependPath $typeFile

if (($PSVersionTable.Keys -contains "PSEdition") -and ($PSVersionTable.PSEdition -ne 'Desktop')) {
    # .Net Core DLLs are under the 'coreclr' folder
    $binaryModuleRoot = Join-Path -Path $PSModuleRoot -ChildPath 'coreclr'
}

$moduleDLLs = @('Microsoft.SqlServer.Management.PSSnapins.dll',
                'Microsoft.SqlServer.Management.PSProvider.dll',
                'Microsoft.AnalysisServices.PowerShell.Cmdlets.dll',
                'SqlServerPostScript.ps1')

$extraDLLS = @( 'Microsoft.SqlServer.Smo.dll',
                'Microsoft.SqlServer.Dmf.dll',
                'Microsoft.SqlServer.SqlWmiManagement.dll',
                'Microsoft.SqlServer.ConnectionInfo.dll',
                'Microsoft.SqlServer.ConnectionInfoExtended.dll',
                'Microsoft.SqlServer.SmoExtended.dll',
                'Microsoft.SqlServer.Management.RegisteredServers.dll',
                'Microsoft.SqlServer.Management.Sdk.Sfc.dll',
                'Microsoft.SqlServer.SqlEnum.dll',
                'Microsoft.SqlServer.RegSvrEnum.dll',
                'Microsoft.SqlServer.WmiEnum.dll',
                'Microsoft.SqlServer.ServiceBrokerEnum.dll',
                'Microsoft.SqlServer.Management.Collector.dll',
                'Microsoft.SqlServer.Management.CollectorEnum.dll',
                'Microsoft.SqlServer.Management.Utility.dll',
                'Microsoft.SqlServer.Management.UtilityEnum.dll',
                'Microsoft.SqlServer.Management.HadrDMF.dll' )

$importedModules = @()

$moduleDLLs | ForEach-Object {
    $binaryModulePath = Join-Path -Path $binaryModuleRoot -ChildPath "$_"
    if (Test-Path -Path $binaryModulePath) {
        $binaryModule = Import-Module -Name $binaryModulePath -PassThru
        [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification="This is a false positive. PSA cannot inspect downstream usage")]
        $importedModules += $binaryModule
    }
}

# Load misc assemblies (from the local folder)
$extraDLLS | ForEach-Object {
    $binaryPath = Join-Path -Path $binaryModuleRoot -ChildPath "$_"

    if (Test-Path -Path $binaryPath) {
        Add-Type -Path $binaryPath
    }
}

# When the module is unloaded, remove the nested binary module that was loaded with it
$PSModule.OnRemove = {
    Remove-Module -ModuleInfo $importedModules
}
# SIG # Begin signature block
# MIIkdwYJKoZIhvcNAQcCoIIkaDCCJGQCAQExDzANBglghkgBZQMEAgEFADB5Bgor
# BgEEAYI3AgEEoGswaTA0BgorBgEEAYI3AgEeMCYCAwEAAAQQH8w7YFlLCE63JNLG
# KX7zUQIBAAIBAAIBAAIBAAIBADAxMA0GCWCGSAFlAwQCAQUABCAOexaNdmiR7H1F
# jee8ClY0KL/mIeG+bZ9jVUYKdro+waCCDYEwggX/MIID56ADAgECAhMzAAABA14l
# HJkfox64AAAAAAEDMA0GCSqGSIb3DQEBCwUAMH4xCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMTH01pY3Jvc29mdCBDb2RlIFNpZ25p
# bmcgUENBIDIwMTEwHhcNMTgwNzEyMjAwODQ4WhcNMTkwNzI2MjAwODQ4WjB0MQsw
# CQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9u
# ZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMR4wHAYDVQQDExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIB
# AQDRlHY25oarNv5p+UZ8i4hQy5Bwf7BVqSQdfjnnBZ8PrHuXss5zCvvUmyRcFrU5
# 3Rt+M2wR/Dsm85iqXVNrqsPsE7jS789Xf8xly69NLjKxVitONAeJ/mkhvT5E+94S
# nYW/fHaGfXKxdpth5opkTEbOttU6jHeTd2chnLZaBl5HhvU80QnKDT3NsumhUHjR
# hIjiATwi/K+WCMxdmcDt66VamJL1yEBOanOv3uN0etNfRpe84mcod5mswQ4xFo8A
# DwH+S15UD8rEZT8K46NG2/YsAzoZvmgFFpzmfzS/p4eNZTkmyWPU78XdvSX+/Sj0
# NIZ5rCrVXzCRO+QUauuxygQjAgMBAAGjggF+MIIBejAfBgNVHSUEGDAWBgorBgEE
# AYI3TAgBBggrBgEFBQcDAzAdBgNVHQ4EFgQUR77Ay+GmP/1l1jjyA123r3f3QP8w
# UAYDVR0RBEkwR6RFMEMxKTAnBgNVBAsTIE1pY3Jvc29mdCBPcGVyYXRpb25zIFB1
# ZXJ0byBSaWNvMRYwFAYDVQQFEw0yMzAwMTIrNDM3OTY1MB8GA1UdIwQYMBaAFEhu
# ZOVQBdOCqhc3NyK1bajKdQKVMFQGA1UdHwRNMEswSaBHoEWGQ2h0dHA6Ly93d3cu
# bWljcm9zb2Z0LmNvbS9wa2lvcHMvY3JsL01pY0NvZFNpZ1BDQTIwMTFfMjAxMS0w
# Ny0wOC5jcmwwYQYIKwYBBQUHAQEEVTBTMFEGCCsGAQUFBzAChkVodHRwOi8vd3d3
# Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2NlcnRzL01pY0NvZFNpZ1BDQTIwMTFfMjAx
# MS0wNy0wOC5jcnQwDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQsFAAOCAgEAn/XJ
# Uw0/DSbsokTYDdGfY5YGSz8eXMUzo6TDbK8fwAG662XsnjMQD6esW9S9kGEX5zHn
# wya0rPUn00iThoj+EjWRZCLRay07qCwVlCnSN5bmNf8MzsgGFhaeJLHiOfluDnjY
# DBu2KWAndjQkm925l3XLATutghIWIoCJFYS7mFAgsBcmhkmvzn1FFUM0ls+BXBgs
# 1JPyZ6vic8g9o838Mh5gHOmwGzD7LLsHLpaEk0UoVFzNlv2g24HYtjDKQ7HzSMCy
# RhxdXnYqWJ/U7vL0+khMtWGLsIxB6aq4nZD0/2pCD7k+6Q7slPyNgLt44yOneFuy
# bR/5WcF9ttE5yXnggxxgCto9sNHtNr9FB+kbNm7lPTsFA6fUpyUSj+Z2oxOzRVpD
# MYLa2ISuubAfdfX2HX1RETcn6LU1hHH3V6qu+olxyZjSnlpkdr6Mw30VapHxFPTy
# 2TUxuNty+rR1yIibar+YRcdmstf/zpKQdeTr5obSyBvbJ8BblW9Jb1hdaSreU0v4
# 6Mp79mwV+QMZDxGFqk+av6pX3WDG9XEg9FGomsrp0es0Rz11+iLsVT9qGTlrEOla
# P470I3gwsvKmOMs1jaqYWSRAuDpnpAdfoP7YO0kT+wzh7Qttg1DO8H8+4NkI6Iwh
# SkHC3uuOW+4Dwx1ubuZUNWZncnwa6lL2IsRyP64wggd6MIIFYqADAgECAgphDpDS
# AAAAAAADMA0GCSqGSIb3DQEBCwUAMIGIMQswCQYDVQQGEwJVUzETMBEGA1UECBMK
# V2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0
# IENvcnBvcmF0aW9uMTIwMAYDVQQDEylNaWNyb3NvZnQgUm9vdCBDZXJ0aWZpY2F0
# ZSBBdXRob3JpdHkgMjAxMTAeFw0xMTA3MDgyMDU5MDlaFw0yNjA3MDgyMTA5MDla
# MH4xCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xKDAmBgNVBAMT
# H01pY3Jvc29mdCBDb2RlIFNpZ25pbmcgUENBIDIwMTEwggIiMA0GCSqGSIb3DQEB
# AQUAA4ICDwAwggIKAoICAQCr8PpyEBwurdhuqoIQTTS68rZYIZ9CGypr6VpQqrgG
# OBoESbp/wwwe3TdrxhLYC/A4wpkGsMg51QEUMULTiQ15ZId+lGAkbK+eSZzpaF7S
# 35tTsgosw6/ZqSuuegmv15ZZymAaBelmdugyUiYSL+erCFDPs0S3XdjELgN1q2jz
# y23zOlyhFvRGuuA4ZKxuZDV4pqBjDy3TQJP4494HDdVceaVJKecNvqATd76UPe/7
# 4ytaEB9NViiienLgEjq3SV7Y7e1DkYPZe7J7hhvZPrGMXeiJT4Qa8qEvWeSQOy2u
# M1jFtz7+MtOzAz2xsq+SOH7SnYAs9U5WkSE1JcM5bmR/U7qcD60ZI4TL9LoDho33
# X/DQUr+MlIe8wCF0JV8YKLbMJyg4JZg5SjbPfLGSrhwjp6lm7GEfauEoSZ1fiOIl
# XdMhSz5SxLVXPyQD8NF6Wy/VI+NwXQ9RRnez+ADhvKwCgl/bwBWzvRvUVUvnOaEP
# 6SNJvBi4RHxF5MHDcnrgcuck379GmcXvwhxX24ON7E1JMKerjt/sW5+v/N2wZuLB
# l4F77dbtS+dJKacTKKanfWeA5opieF+yL4TXV5xcv3coKPHtbcMojyyPQDdPweGF
# RInECUzF1KVDL3SV9274eCBYLBNdYJWaPk8zhNqwiBfenk70lrC8RqBsmNLg1oiM
# CwIDAQABo4IB7TCCAekwEAYJKwYBBAGCNxUBBAMCAQAwHQYDVR0OBBYEFEhuZOVQ
# BdOCqhc3NyK1bajKdQKVMBkGCSsGAQQBgjcUAgQMHgoAUwB1AGIAQwBBMAsGA1Ud
# DwQEAwIBhjAPBgNVHRMBAf8EBTADAQH/MB8GA1UdIwQYMBaAFHItOgIxkEO5FAVO
# 4eqnxzHRI4k0MFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwubWljcm9zb2Z0
# LmNvbS9wa2kvY3JsL3Byb2R1Y3RzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcmwwXgYIKwYBBQUHAQEEUjBQME4GCCsGAQUFBzAChkJodHRwOi8vd3d3Lm1p
# Y3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dDIwMTFfMjAxMV8wM18y
# Mi5jcnQwgZ8GA1UdIASBlzCBlDCBkQYJKwYBBAGCNy4DMIGDMD8GCCsGAQUFBwIB
# FjNodHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpb3BzL2RvY3MvcHJpbWFyeWNw
# cy5odG0wQAYIKwYBBQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AcABvAGwAaQBjAHkA
# XwBzAHQAYQB0AGUAbQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIBAGfyhqWY
# 4FR5Gi7T2HRnIpsLlhHhY5KZQpZ90nkMkMFlXy4sPvjDctFtg/6+P+gKyju/R6mj
# 82nbY78iNaWXXWWEkH2LRlBV2AySfNIaSxzzPEKLUtCw/WvjPgcuKZvmPRul1LUd
# d5Q54ulkyUQ9eHoj8xN9ppB0g430yyYCRirCihC7pKkFDJvtaPpoLpWgKj8qa1hJ
# Yx8JaW5amJbkg/TAj/NGK978O9C9Ne9uJa7lryft0N3zDq+ZKJeYTQ49C/IIidYf
# wzIY4vDFLc5bnrRJOQrGCsLGra7lstnbFYhRRVg4MnEnGn+x9Cf43iw6IGmYslmJ
# aG5vp7d0w0AFBqYBKig+gj8TTWYLwLNN9eGPfxxvFX1Fp3blQCplo8NdUmKGwx1j
# NpeG39rz+PIWoZon4c2ll9DuXWNB41sHnIc+BncG0QaxdR8UvmFhtfDcxhsEvt9B
# xw4o7t5lL+yX9qFcltgA1qFGvVnzl6UJS0gQmYAf0AApxbGbpT9Fdx41xtKiop96
# eiL6SJUfq/tHI4D1nvi/a7dLl+LrdXga7Oo3mXkYS//WsyNodeav+vyL6wuA6mk7
# r/ww7QRMjt/fdW1jkT3RnVZOT7+AVyKheBEyIXrvQQqxP/uozKRdwaGIm1dxVk5I
# RcBCyZt2WwqASGv9eZ/BvW1taslScxMNelDNMYIWTDCCFkgCAQEwgZUwfjELMAkG
# A1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1vbmQx
# HjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEoMCYGA1UEAxMfTWljcm9z
# b2Z0IENvZGUgU2lnbmluZyBQQ0EgMjAxMQITMwAAAQNeJRyZH6MeuAAAAAABAzAN
# BglghkgBZQMEAgEFAKCB2jAZBgkqhkiG9w0BCQMxDAYKKwYBBAGCNwIBBDAcBgor
# BgEEAYI3AgELMQ4wDAYKKwYBBAGCNwIBFTAvBgkqhkiG9w0BCQQxIgQgKGf7Jynu
# ayN4odHPFhTgOCIp9sYK/j3jZrRjjDS2pgMwbgYKKwYBBAGCNwIBDDFgMF6gOoA4
# AFMAUQBMACAAUwBlAHIAdgBlAHIAIABNAGEAbgBhAGcAZQBtAGUAbgB0ACAAUwB0
# AHUAZABpAG+hIIAeaHR0cDovL3d3dy5taWNyb3NvZnQuY29tL3NxbC8gMA0GCSqG
# SIb3DQEBAQUABIIBAM8jEETAmGaXinYWFzrh5qAU5HiwFOsNmQEETaRhuFmIdd9J
# HkS0J3FIyILRf+66G6TqFtAaSYdOpqethxWUmp94biSePyFrkbh+aB9Bnq9acdHS
# LHlDZYP9gaau8/oGrXiEzkEO3j8caC54c/kxO0jpIL7oeszKP4Xy9JDnWWMcINFb
# G9O2HRfo+apR2Y1HClcKJ0opP1S8KBBvRPk+KtIHl//X7xSPIzTpJxW2OMC0iIBR
# PeRIBIeUa0uERRfG9Usj/Fb7njIohTF1Q6OEFV1JlXZwEzPOlxqJCtmk+EsliRSe
# aNlKPqitlIbgmXhzPO0gWKBMmdp/pM/p63xLn4qhghOqMIITpgYKKwYBBAGCNwMD
# ATGCE5YwghOSBgkqhkiG9w0BBwKgghODMIITfwIBAzEPMA0GCWCGSAFlAwQCAQUA
# MIIBVAYLKoZIhvcNAQkQAQSgggFDBIIBPzCCATsCAQEGCisGAQQBhFkKAwEwMTAN
# BglghkgBZQMEAgEFAAQgxl+/Gbxsbt8B5p+AzFIoLYUMCeqwfDUV0xNIkTUCZooC
# BlvbsrDAvRgTMjAxODExMTMwNjUyNTYuNTQ3WjAHAgEBgAIB9KCB0KSBzTCByjEL
# MAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNVBAcTB1JlZG1v
# bmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjElMCMGA1UECxMcTWlj
# cm9zb2Z0IEFtZXJpY2EgT3BlcmF0aW9uczEmMCQGA1UECxMdVGhhbGVzIFRTUyBF
# U046RDIzNi0zN0RBLTk3NjExJTAjBgNVBAMTHE1pY3Jvc29mdCBUaW1lLVN0YW1w
# IFNlcnZpY2Wggg8WMIIGcTCCBFmgAwIBAgIKYQmBKgAAAAAAAjANBgkqhkiG9w0B
# AQsFADCBiDELMAkGA1UEBhMCVVMxEzARBgNVBAgTCldhc2hpbmd0b24xEDAOBgNV
# BAcTB1JlZG1vbmQxHjAcBgNVBAoTFU1pY3Jvc29mdCBDb3Jwb3JhdGlvbjEyMDAG
# A1UEAxMpTWljcm9zb2Z0IFJvb3QgQ2VydGlmaWNhdGUgQXV0aG9yaXR5IDIwMTAw
# HhcNMTAwNzAxMjEzNjU1WhcNMjUwNzAxMjE0NjU1WjB8MQswCQYDVQQGEwJVUzET
# MBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMV
# TWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1T
# dGFtcCBQQ0EgMjAxMDCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAKkd
# Dbx3EYo6IOz8E5f1+n9plGt0VBDVpQoAgoX77XxoSyxfxcPlYcJ2tz5mK1vwFVMn
# BDEfQRsalR3OCROOfGEwWbEwRA/xYIiEVEMM1024OAizQt2TrNZzMFcmgqNFDdDq
# 9UeBzb8kYDJYYEbyWEeGMoQedGFnkV+BVLHPk0ySwcSmXdFhE24oxhr5hoC732H8
# RsEnHSRnEnIaIYqvS2SJUGKxXf13Hz3wV3WsvYpCTUBR0Q+cBj5nf/VmwAOWRH7v
# 0Ev9buWayrGo8noqCjHw2k4GkbaICDXoeByw6ZnNPOcvRLqn9NxkvaQBwSAJk3jN
# /LzAyURdXhacAQVPIk0CAwEAAaOCAeYwggHiMBAGCSsGAQQBgjcVAQQDAgEAMB0G
# A1UdDgQWBBTVYzpcijGQ80N7fEYbxTNoWoVtVTAZBgkrBgEEAYI3FAIEDB4KAFMA
# dQBiAEMAQTALBgNVHQ8EBAMCAYYwDwYDVR0TAQH/BAUwAwEB/zAfBgNVHSMEGDAW
# gBTV9lbLj+iiXGJo0T2UkFvXzpoYxDBWBgNVHR8ETzBNMEugSaBHhkVodHRwOi8v
# Y3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9wcm9kdWN0cy9NaWNSb29DZXJBdXRf
# MjAxMC0wNi0yMy5jcmwwWgYIKwYBBQUHAQEETjBMMEoGCCsGAQUFBzAChj5odHRw
# Oi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2NlcnRzL01pY1Jvb0NlckF1dF8yMDEw
# LTA2LTIzLmNydDCBoAYDVR0gAQH/BIGVMIGSMIGPBgkrBgEEAYI3LgMwgYEwPQYI
# KwYBBQUHAgEWMWh0dHA6Ly93d3cubWljcm9zb2Z0LmNvbS9QS0kvZG9jcy9DUFMv
# ZGVmYXVsdC5odG0wQAYIKwYBBQUHAgIwNB4yIB0ATABlAGcAYQBsAF8AUABvAGwA
# aQBjAHkAXwBTAHQAYQB0AGUAbQBlAG4AdAAuIB0wDQYJKoZIhvcNAQELBQADggIB
# AAfmiFEN4sbgmD+BcQM9naOhIW+z66bM9TG+zwXiqf76V20ZMLPCxWbJat/15/B4
# vceoniXj+bzta1RXCCtRgkQS+7lTjMz0YBKKdsxAQEGb3FwX/1z5Xhc1mCRWS3Tv
# QhDIr79/xn/yN31aPxzymXlKkVIArzgPF/UveYFl2am1a+THzvbKegBvSzBEJCI8
# z+0DpZaPWSm8tv0E4XCfMkon/VWvL/625Y4zu2JfmttXQOnxzplmkIz/amJ/3cVK
# C5Em4jnsGUpxY517IW3DnKOiPPp/fZZqkHimbdLhnPkd/DjYlPTGpQqWhqS9nhqu
# BEKDuLWAmyI4ILUl5WTs9/S/fmNZJQ96LjlXdqJxqgaKD4kWumGnEcua2A5HmoDF
# 0M2n0O99g/DhO3EJ3110mCIIYdqwUB5vvfHhAN/nMQekkzr3ZUd46PioSKv33nJ+
# YWtvd6mBy6cJrDm77MbL2IK0cs0d9LiFAR6A+xuJKlQ5slvayA1VmXqHczsI5pgt
# 6o3gMy4SKfXAL1QnIffIrE7aKLixqduWsqdCosnPGUFN4Ib5KpqjEWYw07t0Mkvf
# Y3v1mYovG8chr1m1rtxEPJdQcdeh0sVV42neV8HR3jDA/czmTfsNv11P6Z0eGTgv
# vM9YBS7vDaBQNdrvCScc1bN+NR4Iuto229Nfj950iEkSMIIE8TCCA9mgAwIBAgIT
# MwAAAMlK1n6YThTUewAAAAAAyTANBgkqhkiG9w0BAQsFADB8MQswCQYDVQQGEwJV
# UzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UE
# ChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGlt
# ZS1TdGFtcCBQQ0EgMjAxMDAeFw0xODA4MjMyMDI2MTNaFw0xOTExMjMyMDI2MTNa
# MIHKMQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMH
# UmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQL
# ExxNaWNyb3NvZnQgQW1lcmljYSBPcGVyYXRpb25zMSYwJAYDVQQLEx1UaGFsZXMg
# VFNTIEVTTjpEMjM2LTM3REEtOTc2MTElMCMGA1UEAxMcTWljcm9zb2Z0IFRpbWUt
# U3RhbXAgU2VydmljZTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANYj
# aoQ2UEPBUNTS4UPpL11PaEO/UFNLuogXBRIhEBMP0ZudXHR08PQyWlZwZSrdggcB
# 4/gEppzEUCZxyAOUpZLSqj75rxCViSABt0leuhOAHeX8MHDv6GobJL59GNHnZj2S
# byXZEyYK++w1oEKJKVv2F2bmpuLSyX0SiYP36urUtPwQdm3rrtZ2aGa9alTK/Tl+
# pEiKDVcV2dKbVT3CJlSvlBhzjp214IHBzwJX7YACFIdXlQvuI9pCUaGLre96b8k1
# KFVveMWAx16HkfYt+XvCQpWGX6tkRHwmupbW56f4XOaelvCgJ5LnUpGXT8OsnvXU
# 8EC5o9zp1sLjgdjnmBkCAwEAAaOCARswggEXMB0GA1UdDgQWBBQrhuMJAPMlE8c1
# b2VwuH4gDpp7JzAfBgNVHSMEGDAWgBTVYzpcijGQ80N7fEYbxTNoWoVtVTBWBgNV
# HR8ETzBNMEugSaBHhkVodHRwOi8vY3JsLm1pY3Jvc29mdC5jb20vcGtpL2NybC9w
# cm9kdWN0cy9NaWNUaW1TdGFQQ0FfMjAxMC0wNy0wMS5jcmwwWgYIKwYBBQUHAQEE
# TjBMMEoGCCsGAQUFBzAChj5odHRwOi8vd3d3Lm1pY3Jvc29mdC5jb20vcGtpL2Nl
# cnRzL01pY1RpbVN0YVBDQV8yMDEwLTA3LTAxLmNydDAMBgNVHRMBAf8EAjAAMBMG
# A1UdJQQMMAoGCCsGAQUFBwMIMA0GCSqGSIb3DQEBCwUAA4IBAQAD1vATn1fy5B2l
# HrKdpjK5mmCz4itQCTdCJC/bpW8vEm4jdnW818H08sQwt2GMnYIxq3T/usrLrDW7
# uaYrx16l9DyXeEis41mfEsEpVpCjqqaT0shx4hmdD5JRgGCmG3La/HqlKtgoV+d6
# twPgBV52NgupSK5vKH6ni6M5rVphyYbaSR1a/DxAn5SyE2TpSg1XglyBBVPuQegA
# y7dI/1aLPZ4m92hS2j8HbEMzjlIDpaPVgxl4Xlxfc5csR4Ckr6ui3B35fDNrlyAy
# 8uShmwkFveu+g8/uc6hG2UZy97jAdcFPqofbWyFDhjjiSSMUGg1/EkUBpM/Y18iv
# uDB2UW9soYIDqDCCApACAQEwgfqhgdCkgc0wgcoxCzAJBgNVBAYTAlVTMRMwEQYD
# VQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdSZWRtb25kMR4wHAYDVQQKExVNaWNy
# b3NvZnQgQ29ycG9yYXRpb24xJTAjBgNVBAsTHE1pY3Jvc29mdCBBbWVyaWNhIE9w
# ZXJhdGlvbnMxJjAkBgNVBAsTHVRoYWxlcyBUU1MgRVNOOkQyMzYtMzdEQS05NzYx
# MSUwIwYDVQQDExxNaWNyb3NvZnQgVGltZS1TdGFtcCBTZXJ2aWNloiUKAQEwCQYF
# Kw4DAhoFAAMVAGSC4KoXbHiKw909SsGSry/oPEgXoIHaMIHXpIHUMIHRMQswCQYD
# VQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3RvbjEQMA4GA1UEBxMHUmVkbW9uZDEe
# MBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0aW9uMSUwIwYDVQQLExxNaWNyb3Nv
# ZnQgQW1lcmljYSBPcGVyYXRpb25zMScwJQYDVQQLEx5uQ2lwaGVyIE5UUyBFU046
# MjY2NS00QzNGLUM1REUxKzApBgNVBAMTIk1pY3Jvc29mdCBUaW1lIFNvdXJjZSBN
# YXN0ZXIgQ2xvY2swDQYJKoZIhvcNAQEFBQACBQDfk8idMCIYDzIwMTgxMTEyMDkz
# ODM3WhgPMjAxODExMTMwOTM4MzdaMHcwPQYKKwYBBAGEWQoEATEvMC0wCgIFAN+T
# yJ0CAQAwCgIBAAICAMoCAf8wBwIBAAICGbIwCgIFAN+VGh0CAQAwNgYKKwYBBAGE
# WQoEAjEoMCYwDAYKKwYBBAGEWQoDAaAKMAgCAQACAxbjYKEKMAgCAQACAx6EgDAN
# BgkqhkiG9w0BAQUFAAOCAQEAFdQ9E0P9jrXUNzkfEXBCGfGMG4ZEicCV/2g0r83B
# pJI2DTUAsV/JCKfabstuzYbMF6WqLxZrSQ5uDcsOjSCoMUdo3N7XV+ENzK3GUR0q
# Oy0fmjcOb2pPwMR8qHF8KKTzNHmx1o/a32w5JT5dWBLFE9etzaGoEXWewIYdImkd
# gX7oveJLK2ouKQWJcDbIXRSlhQkK1pBtGst6aCG98z3nrPUBFHVtxwvzwAoHqYWF
# 1O/aaJpkYCTiucRDVj0x7ZDZ6HScvt65DuQfnUAV/u+j1yhgWhS766ce5LopWJgL
# A7PdBlDNuUS6T62r4sHqL32oKYWScCrwGNgPyKiDeHlb5DGCAvUwggLxAgEBMIGT
# MHwxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpXYXNoaW5ndG9uMRAwDgYDVQQHEwdS
# ZWRtb25kMR4wHAYDVQQKExVNaWNyb3NvZnQgQ29ycG9yYXRpb24xJjAkBgNVBAMT
# HU1pY3Jvc29mdCBUaW1lLVN0YW1wIFBDQSAyMDEwAhMzAAAAyUrWfphOFNR7AAAA
# AADJMA0GCWCGSAFlAwQCAQUAoIIBMjAaBgkqhkiG9w0BCQMxDQYLKoZIhvcNAQkQ
# AQQwLwYJKoZIhvcNAQkEMSIEIBoQPCi3SPJCeLv5SReiMjYrgqTt67LQ1hg/XrKw
# Ag76MIHiBgsqhkiG9w0BCRACDDGB0jCBzzCBzDCBsQQUZILgqhdseIrD3T1KwZKv
# L+g8SBcwgZgwgYCkfjB8MQswCQYDVQQGEwJVUzETMBEGA1UECBMKV2FzaGluZ3Rv
# bjEQMA4GA1UEBxMHUmVkbW9uZDEeMBwGA1UEChMVTWljcm9zb2Z0IENvcnBvcmF0
# aW9uMSYwJAYDVQQDEx1NaWNyb3NvZnQgVGltZS1TdGFtcCBQQ0EgMjAxMAITMwAA
# AMlK1n6YThTUewAAAAAAyTAWBBR/mUjcQyyAbqs/aChPn/LH3hip0zANBgkqhkiG
# 9w0BAQsFAASCAQAnAACmR7qpUgwHzPJ2ZTLwjQDHpnlkgH3DMrzvgOltp8K5w0Ct
# rF9ROH37pmqePfUFxl1uBtETtWXkZLjyJsU7mBPNONzTXC69H+dnqCgFRRmGovAE
# dPnDmLxI0tkwdaZ9hmeBqKIPbmR5DAbP4qziFpSzq6NmWjKBjqKoQbh0UOI2L+YE
# ByGhK6ZSoaAsawzYSRdp0f9r/aBq8cVdY634vLXw3j6Io6UAIh8JlPz2l8udsSCc
# Gp5jjq/y6Md9SLpDDepaFP3it2lEh7jgY/q1PIHw/Z8lPEAxhvOt2gPvkDBqwwTE
# lxb9Jqp7L92U9noT+YCoxj9cP0WyhF3Ze+6W
# SIG # End signature block