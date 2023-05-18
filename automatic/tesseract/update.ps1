﻿$ErrorActionPreference = 'Stop'
import-module au

function global:au_BeforeUpdate { Get-RemoteFiles -NoSuffix -Purge }

function global:au_GetLatest {
    $releases = 'https://github.com/UB-Mannheim/tesseract/wiki'    
    $regex64  = 'tesseract-ocr-w64-setup-v?(?<Version>[\d\.]+(-alpha|-rc)?([\d\.]+)?).exe'    

    $download_page = Invoke-WebRequest -Uri $releases -UseBasicParsing	
    $url64         = $download_page.links | ? href -match $regex64
    $version       = $matches.Version -Replace "([\d\.]+)(-alpha)([\d\.]+)", '$1$3$2'
    $version       = $matches.Version -Replace "([\d\.]+)(-rc)([\d\.]+)", '$1$3'

    return @{
        Version = $version        
        URL64   = $url64.href
    }
}

function global:au_SearchReplace {
    @{
       "legal\VERIFICATION.txt"  = @{                        
            "(?i)(x64: ).*"             = "`${1}$($Latest.URL64)"            
            "(?i)(checksum type:\s+).*" = "`${1}$($Latest.ChecksumType64)"            
            "(?i)(checksum64:).*"       = "`${1} $($Latest.Checksum64)"
        }

        "tools\chocolateyinstall.ps1" = @{          
          "(?i)(^\s*file64\s*=\s*`"[$]toolsDir\\)(.*)`"" = "`$1$($Latest.FileName64)`""
        }
    }
}

update -ChecksumFor None