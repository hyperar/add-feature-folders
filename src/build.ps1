function Exec
{
    [CmdletBinding()] param(
        [Parameter(Position=0,Mandatory=1)][scriptblock]$cmd,
        [Parameter(Position=1,Mandatory=0)][string]$errorMessage = ($msgs.error_bad_command -f $cmd)
    )
    & $cmd
    if ($lastexitcode -ne 0) {
        throw ("Exec: " + $errorMessage)
    }
}

Invoke-WebRequest -Uri 'https://dot.net/v1/dotnet-install.ps1' -UseBasicParsing -OutFile "$env:temp\dotnet-install.ps1"
& $env:temp\dotnet-install.ps1 -Architecture x64 -Version '6.0' -InstallDir "$env:ProgramFiles\dotnet"

if(Test-Path .\artifacts) { Remove-Item .\artifacts -Force -Recurse }

exec { & dotnet restore }

exec { & dotnet build .\src\Hyperar.AddFeatureFolders -c Release }

pushd .\src\Hyperar.AddFeatureFolders.Tests\
exec { & dotnet test -c Release }
popd

exec { & dotnet pack .\src\Hyperar.AddFeatureFolders -c Release -o ..\..\artifacts  }
