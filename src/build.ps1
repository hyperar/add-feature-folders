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

if(Test-Path .\artifacts) { Remove-Item .\artifacts -Force -Recurse }

exec { dotnet tool install -g InheritDocTool }

exec { Invoke-WebRequest 'https://dot.net/v1/dotnet-install.ps1' -OutFile dotnet-install.ps1 }

exec { ./dotnet-install.ps1 -Channel 6.0 }

exec { & dotnet restore }

exec { & dotnet build .\src\Hyperar.AddFeatureFolders -c Release }

pushd .\src\Hyperar.AddFeatureFolders.Tests\
exec { & dotnet test -c Release }
popd

exec { & dotnet pack .\src\Hyperar.AddFeatureFolders -c Release -o ..\..\artifacts  }
