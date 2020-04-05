REM UWP ARM build for device deploy
xcopy /F /Y ..\..\bin\AnyCPU\Debug\Microsoft.MixedReality.WebRTC.dll Assets\Plugins\WSA\ARM\
xcopy /F /Y ..\..\bin\AnyCPU\Debug\Microsoft.MixedReality.WebRTC.pdb Assets\Plugins\WSA\ARM\
xcopy /F /Y ..\..\bin\UWP\ARM\Debug\mrwebrtc.dll Assets\Plugins\WSA\ARM\
xcopy /F /Y ..\..\bin\UWP\ARM\Debug\mrwebrtc.pdb Assets\Plugins\WSA\ARM\

REM Win32 (Desktop) x86_64 build for editor
xcopy /F /Y ..\..\bin\AnyCPU\Debug\Microsoft.MixedReality.WebRTC.dll Assets\Plugins\Win32\x86_64\
xcopy /F /Y ..\..\bin\AnyCPU\Debug\Microsoft.MixedReality.WebRTC.pdb Assets\Plugins\Win32\x86_64\
xcopy /F /Y ..\..\bin\Win32\x64\Debug\mrwebrtc.dll Assets\Plugins\Win32\x86_64\
xcopy /F /Y ..\..\bin\Win32\x64\Debug\mrwebrtc.pdb Assets\Plugins\Win32\x86_64\

REM Android arm64_v8a
xcopy /F /Y ..\..\bin\Android\arm64_v8a\Debug\mrwebrtc.aar Assets\Plugins\Android\arm64_v8a\

REM UnityPlugin Managed Wrapper (supports all platforms)
xcopy /F /Y ..\..\bin\AnyCPU\Debug\Microsoft.MixedReality.WebRTC.UnityPlugin.dll Assets\Plugins\
xcopy /F /Y ..\..\bin\AnyCPU\Debug\Microsoft.MixedReality.WebRTC.UnityPlugin.pdb Assets\Plugins\

REM mrwebrtc-unityplugin for Win32 x86_64
xcopy /F /Y ..\..\bin\Win32\x64\Debug\mrwebrtc-unityplugin.dll Assets\Plugins\Win32\x86_64\
xcopy /F /Y ..\..\bin\Win32\x64\Debug\mrwebrtc-unityplugin.pdb Assets\Plugins\Win32\x86_64\

REM mrwebrtc-unityplugin for Android arm64_v8a
xcopy /F /Y ..\..\bin\Android\arm64_v8a\Debug\mrwebrtc-unityplugin.aar Assets\Plugins\Android\arm64_v8a\
