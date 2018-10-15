$BuildOptions = @{
    ModuleName      = 'samplemodule'
    PSGalleryApiKey = 'abc-def'
    ModuleFiles     = @(
        # Another folder to copy to release
        "source\Folder"
    )
    # Markdown files to convert to HTML
    MDConvert       = @(
        'README.md',
        'CHANGELOG.md'
    )
    PSSASeverity           = 'Error', 'Warning'
    CodeCoverageThreshold  = 0.8

    ModuleHeader    = "Set-StrictMode -Version Latest`n"
}

$ManifestOptions = @{
    RootModule        = "$($BuildOptions.ModuleName).psm1"
    FunctionsToExport = (Get-ChildItem (Join-Path -Path (Join-Path -Path $BuildRoot -ChildPath 'source') `
                            -ChildPath "public\*.ps1") -Recurse).BaseName
}

Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/pauby/ps-build-script/master/build.ps1' -OutFile 'build.ps1'

. .\build.ps1

task . InstallDependencies, Clean, Build, ValidateTestResults