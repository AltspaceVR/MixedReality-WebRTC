param (
    # Filter parameter for projects to build. Only things that imatch the given regex will be built.
    [Parameter()]
    [string] $ProjectName = "",

    # Build flavor. Can be Release or Debug.
    [Parameter()]
    [string] $Flavor = "Release",

    # Build the uwp-webrtc-sdk project as well.
    [Parameter()]
    [switch] $IncludeWebRtcUwp,

    # Builds everything from scratch, rather than only building diffs.
    [Parameter()]
    [switch] $Rebuild,

    # Altspace doesn't support UWP at present.
    [Parameter()]
    [switch] $BuildUWP,

    # Location of the altspace plugin for MRWebRTC.
    [Parameter()]
    [string] $pluginpath = "./UnityClient/assets/Plugins/Microsoft.MixedReality.WebRTC",

    # Directory of the MRWebRTC repository.
    [Parameter()]
    [string] $MRWebRTCDir = "./MixedReality-WebRTC",

    # One off command to remove the libs we definitely do not want to link against from the nuget packages.
    [Parameter()]
    [switch] $ProtectAgainstNuget,

    # Skips the copy-to-pluginpath step.
    [Parameter()]
    [switch] $SkipCopy
)

$ErrorActionPreference = "Stop"

$python3Path = "$env:HOME\AppData\Local\Microsoft\WindowsApps"
if ($env:PATH.Contains($python3Path))
{
    Write-Warning "Found a possible python3 directory in your path. Removing it."
    $env:PATH = $env:PATH.Replace("$python3Path;","")
    $env:PATH = $env:PATH.Replace("$python3Path","")
}

if (-not (Test-Path $pluginpath))
{
    mkdir $pluginpath
}

$pluginpath = (resolve-path $pluginpath).Path
$MRWebRTCDir = (resolve-path $MRWebRTCDir).Path
Write-Host "Found MixedReality-WebRTC path: $MRWebRTCDir"

if ($ProtectAgainstNuget)
{
    Push-Location "$MRWebRTCDir/packages"
    Get-ChildItem -r -n | Select-String Org.WebRtc.WrapperGlue.lib$ | ForEach-Object { Remove-Item $_ }
    Get-ChildItem -r -n | Select-String WebRtc.lib$ | ForEach-Object { Remove-Item $_ }
    Pop-Location
}

if (-not ($env:VCToolsVersion -match "14\.1"))
{
    write-error "You must run this script from a VS2017 developer command prompt."
    return
}

function Build-VSProject($dir, $solution, $srcdir, $destdir, $binaries, $platforms, $config, $vsversion)
{
    if ($projectName -and -not ($dir -imatch $projectName)) {
        Write-Host "Skipping '$dir'. Doesn't match '$projectName'"
        return
    }
    
    try {
        Push-Location $dir
        $platforms | ForEach-Object {
            $arch = $_
            $srcarchdir = $arch
            $dstarchdir = $arch

            if ($arch -eq "AnyCpu")
            {
                $srcarchdir = ""
            }

            # Altspace layout stuff....
            if (($arch -eq "AnyCpu") -or ($arch -eq "x64"))
            {
                $dstarchdir = "x86_64"
            }

            $vars = ""
            if ($arch -eq "ARM")
            {
                $vars = "amd64_arm"
            }
            if ($arch -eq "x64")
            {
                $vars = "64"
            }

            $extraArgs = ""
            if ($Rebuild)
            {
                $extraArgs = "/t:rebuild"
            }
            
            # For reasons I can't explain, the toolchain version and platform version are ignored in
            # favor of the command line enviornment, while other values are actually taken from the
            # project file. To work around this... update the enviornment using vcvars.
            Write-Host "`"C:\Program Files (x86)\Microsoft Visual Studio\$vsversion\Enterprise\VC\Auxiliary\Build\vcvars$vars.bat`" 10.0.17763.0 -vcvars_ver=14.16 & msbuild.exe $solution /p:Configuration=`"$config`" /p:Platform=$arch $extraArgs -m"
            cmd.exe /c "`"C:\Program Files (x86)\Microsoft Visual Studio\$vsversion\Enterprise\VC\Auxiliary\Build\vcvars$vars.bat`" 10.0.17763.0 -vcvars_ver=14.16 & msbuild.exe $solution /p:Configuration=`"$config`" /p:Platform=$arch $extraArgs -m "
            if(-not $?)
            {
                throw "Failed building $dir\$solution for $arch";
            }
 
            if (-not $SkipCopy)
            {
                $binaries | ForEach-Object {
                    $targetdir = "$pluginpath\$destdir\$dstarchdir\"
                    if (-not (Test-Path $targetdir))
                    {
                        mkdir $targetdir
                    }

                    Copy-Item "$srcdir\$srcarchdir\$config\$_" "$targetdir"
                    if(-not $?) { throw "Failed copy: $_"; }
                }
            }
        }
    }
    catch { throw }
    finally { Pop-Location }
}

if ($IncludeWebRtcUwp)
{
    # Build the webrtc sdk. Note that we treat this strictly as a dependency for the mixedreality-webrtc build and copy nothing over.
    Build-VSProject `
        "$MRWebRTCDir\external\webrtc-uwp-sdk\webrtc\windows\projects\msvc\WebRtc.Win32.Native.Builder" `
        "WebRtc.Win32.Native.Builder.vcxproj" `
        "" "" @() `
        ("x64") `
        $flavor `
        "2017"

    # Force the pdbs into the same directory as the lib.
    Copy-Item "$MRWebRTCDir\external\webrtc-uwp-sdk\webrtc\xplatform\webrtc\OUTPUT\webrtc\win\x64\$flavor\pdbs\*.pdb" "$MRWebRTCDir\external\webrtc-uwp-sdk\webrtc\xplatform\webrtc\OUTPUT\webrtc\win\x64\$flavor\"

    # Build-VSProject `
    #     "$MRWebRTCDir\external\webrtc-uwp-sdk\webrtc\windows\projects\msvc\Org.WebRtc.WrapperGlue.Win32" `
    #     "Org.WebRtc.WrapperGlue.vcxproj" `
    #     "" "" @() `
    #     ("x64") `
    #     $flavor `
    #     "2017"

    # Build-VSProject `
    #     "$MRWebRTCDir\external\webrtc-uwp-sdk\webrtc\windows\projects\msvc\Org.WebRtc.WrapperC.Win32" `
    #     "Org.WebRtc.WrapperC.vcxproj" `
    #     "" "" @() `
    #     ("x64") `
    #     $flavor `
    #     "2017"

    if ($BuildUWP)
    {
        Build-VSProject `
            "$MRWebRTCDir\external\webrtc-uwp-sdk\webrtc\windows\projects\msvc\WebRtc.UWP.Native.Builder" `
            "WebRtc.UWP.Native.Builder.vcxproj" `
            "" "" @() `
            ("x64", "ARM") `
            $flavor `
            "2017"
        
        # Force the pdbs into the same directory as the lib.
        Copy-Item "$MRWebRTCDir\external\webrtc-uwp-sdk\webrtc\xplatform\webrtc\OUTPUT\webrtc\winuwp\x64\$flavor\pdbs\*.pdb" "$MRWebRTCDir\external\webrtc-uwp-sdk\webrtc\xplatform\webrtc\OUTPUT\webrtc\winuwp\x64\$flavor\"
        Copy-Item "$MRWebRTCDir\external\webrtc-uwp-sdk\webrtc\xplatform\webrtc\OUTPUT\webrtc\winuwp\ARM\$flavor\pdbs\*.pdb" "$MRWebRTCDir\external\webrtc-uwp-sdk\webrtc\xplatform\webrtc\OUTPUT\webrtc\winuwp\ARM\$flavor\"

        Build-VSProject `
            "$MRWebRTCDir\external\webrtc-uwp-sdk\webrtc\windows\projects\msvc\Org.WebRtc.WrapperGlue.Universal" `
            "Org.WebRtc.WrapperGlue.vcxproj" `
            "" "" @() `
            ("x64", "ARM") `
            $flavor `
            "2017"

        # Needed?
        Build-VSProject `
            "$MRWebRTCDir\external\webrtc-uwp-sdk\webrtc\windows\projects\msvc\Org.WebRtc.Universal" `
            "Org.WebRtc.vcxproj" `
            "" "" @() `
            ("x64", "ARM") `
            $flavor `
            "2017"
    }
}

# Build the webrtc sdk, which we actually take a dependency on.
Build-VSProject `
    "$MRWebRTCDir\tools\build\mrwebrtc\win32" `
    "mrwebrtc-win32.vcxproj" `
    "$MRWebRTCDir\bin\Win32" `
    "" `
    ("mrwebrtc.dll", "mrwebrtc.pdb") `
    ("x64") `
    $flavor `
    "2017"

Build-VSProject `
    "$MRWebRTCDir\tools\build\mrwebrtc-unityplugin\win32" `
    "mrwebrtc-unityplugin-win32.vcxproj" `
    "$MRWebRTCDir\bin\Win32" `
    "" `
    ("mrwebrtc-unityplugin.dll", "mrwebrtc-unityplugin.pdb") `
    ("x64") `
    $flavor `
    "2017"
    
if ($BuildUWP)
{
    Build-VSProject `
        "$MRWebRTCDir\tools\build\mrwebrtc\uwp" `
        "mrwebrtc-uwp.vcxproj" `
        "$MRWebRTCDir\bin\UWP" `
        "UWP" `
        ("mrwebrtc.dll", "mrwebrtc.pdb") `
        ("x64", "ARM") `
        $flavor `
        "2017"

    Build-VSProject `
        "$MRWebRTCDir\tools\build\mrwebrtc-unityplugin\uwp" `
        "mrwebrtc-unityplugin-uwp.vcxproj" `
        "$MRWebRTCDir\bin\UWP" `
        "UWP" `
        ("mrwebrtc-unityplugin.dll", "mrwebrtc-unityplugin.pdb") `
        ("x64", "ARM")  `
        $flavor `
        "2017"
}

Build-VSProject `
    "$MRWebRTCDir\libs\Microsoft.MixedReality.WebRTC" `
    "Microsoft.MixedReality.WebRTC.csproj" `
    "$MRWebRTCDir\bin\netstandard2.0" `
    "" `
    ("Microsoft.MixedReality.WebRTC.dll", "Microsoft.MixedReality.WebRTC.pdb") `
    ("AnyCPU") `
    $flavor `
    "2017"
