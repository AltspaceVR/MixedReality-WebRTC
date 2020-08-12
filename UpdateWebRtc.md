Fixes:
* Fix an issue where rendering and recording behaviors were flipped for UWP.
* Fix an issue where CoreAudio would not be used if *any* device wasn't supported, causing an assertion failure and a crash later.

# Getting started
1. Clone the repo to the parent directory (so it is side by side with Santos)
        git clone --recurse-submodules -j8 https://github.com/AltspaceVR/MixedReality-WebRTC.git

2. Install prerequisites
    1. Install Python 2.7.15: https://www.python.org/downloads/release/python-2715/
    2. Install perl: http://strawberryperl.com/
    3. Install visual studio 2017. Include all standard UWP and C++ projects. Get the 17763 and 17134 SDKs.
    4. Install the windows debuggers. You can get them from the WDK (https://docs.microsoft.com/en-us/windows-hardware/drivers/download-the-wdk) or from http://debuggers on corpnet. I feel like you should be able to get them from the VS installer, but I didn't see them.
    5. Install C++/winrt for VS2017: https://marketplace.visualstudio.com/items?itemName=CppWinRTTeam.cppwinrt101804264

# Building and updating the project
Once you're done, build the Microsoft.MixedReality.WebRTC project. To update Microsoft.MixedReality.WebRTC do:
    # Launch a 2017 command prompt.
    cmd /k "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\Tools\VsDevCmd.bat"

    # Go to the Santos directory
    cd c:\code\Santos

    # Move to powershell
    powershell

    # Build
    .\UpdateWebRTC.ps1

# Manually building webrtc-uwp-sdk
Doing this has been tricky:
1. Launch Visual Studio 2017.
2. Open MixedReality-WebRTC\external\webrtc-uwp-sdk\webrtc\windows\solutions\WebRtc.Win32.sln
3. Build WebRtc.Win32.Native.Builder Release|x64
4. Open MixedReality-WebRTC\external\webrtc-uwp-sdk\webrtc\windows\solutions\WebRtc.Universal.sln
5. Build the 3 required projects
    1. Build WebRtc.UWP.Native.Builder Release|ARM and Release|x64
    2. Build Org.WebRtc.WrapperGlue Release|ARM and Release|x64
    3. Build Org.WebRtc Release|ARM and Release|x64 

Some things to keep in mind:
* The repo can get into a really bad state. Reset everything using:
        git submodule foreach --recursive git clean -xfd
* If anything complains about C:\Microsoft.Cpp.Default.props, try restarting VS to make sure your env is up to date.
* I've found myself having to do a lot of cleaning, restarting, and rebuilding. Sometimes things will fail, then suddenly work.

