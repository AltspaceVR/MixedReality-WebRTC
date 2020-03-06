
REM UWP ARM build for device deploy
xcopy /F /Y ..\..\bin\AnyCPU\Release\Microsoft.MixedReality.WebRTC.dll Assets\Plugins\WSA\ARM\
xcopy /F /Y ..\..\bin\AnyCPU\Release\Microsoft.MixedReality.WebRTC.pdb Assets\Plugins\WSA\ARM\
xcopy /F /Y ..\..\bin\UWP\ARM\Release\Microsoft.MixedReality.WebRTC.Native.dll Assets\Plugins\WSA\ARM\
xcopy /F /Y ..\..\bin\UWP\ARM\Release\Microsoft.MixedReality.WebRTC.Native.pdb Assets\Plugins\WSA\ARM\

REM Win32 (Desktop) x86_64 build for editor
xcopy /F /Y ..\..\bin\AnyCPU\Release\Microsoft.MixedReality.WebRTC.dll Assets\Plugins\Win32\x86_64\
xcopy /F /Y ..\..\bin\AnyCPU\Release\Microsoft.MixedReality.WebRTC.pdb Assets\Plugins\Win32\x86_64\
xcopy /F /Y ..\..\bin\Win32\x64\Release\Microsoft.MixedReality.WebRTC.Native.dll Assets\Plugins\Win32\x86_64\
xcopy /F /Y ..\..\bin\Win32\x64\Release\Microsoft.MixedReality.WebRTC.Native.pdb Assets\Plugins\Win32\x86_64\

REM UnityPlugin Managed Wrapper (supports all platforms)
xcopy /F /Y ..\..\bin\AnyCPU\Release\Microsoft.MixedReality.WebRTC.UnityPlugin.dll Assets\Plugins\MR-WebRTC\
xcopy /F /Y ..\..\bin\AnyCPU\Release\Microsoft.MixedReality.WebRTC.UnityPlugin.pdb Assets\Plugins\MR-WebRTC\

REM UnityPlugin.Native for Win32 x86_64
xcopy /F /Y ..\..\bin\Win32\x64\Release\Microsoft.MixedReality.WebRTC.UnityPlugin.Native.dll Assets\Plugins\MR-WebRTC\x86_64\
xcopy /F /Y ..\..\bin\Win32\x64\Release\Microsoft.MixedReality.WebRTC.UnityPlugin.Native.pdb Assets\Plugins\MR-WebRTC\x86_64\

REM UnityPlugin.Native for Android arm64_v8a
xcopy /F /Y ..\..\bin\Android\arm64_v8a\Release\Microsoft.MixedReality.WebRTC.UnityPlugin.Native.dll Assets\Plugins\MR-WebRTC\arm64_v8a\
xcopy /F /Y ..\..\bin\Android\arm64_v8a\Release\Microsoft.MixedReality.WebRTC.UnityPlugin.Native.pdb Assets\Plugins\MR-WebRTC\arm64_v8a\
