# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

cmake_minimum_required(VERSION 3.10.2)

string(TOLOWER ${CMAKE_BUILD_TYPE} lower_cmake_build_type)

#---------------------------------------------------------------------
# Import Microsoft.MixedReality.WebRTC.Native.so shared library.
#

# Declare and configure the library.
add_library(
        Microsoft.MixedReality.WebRTC.Native
        SHARED IMPORTED
)
set_target_properties(
        Microsoft.MixedReality.WebRTC.Native
        PROPERTIES
        IMPORTED_LOCATION ../../../../../webrtc-native/build/intermediates/cmake/${lower_cmake_build_type}/obj/${ANDROID_ABI}/libMicrosoft.MixedReality.WebRTC.Native.so
)

#---------------------------------------------------------------------
# Configure Microsoft.MixedReality.WebRTC.UnityPlugin.Native.so build.
#

# Base path to Microsoft.MixedReality.WebRTC.Native project.
set(mr-webrtc-native-dir ../../../../../../../libs/Microsoft.MixedReality.WebRTC.Native)
# Base path to Microsoft.MixedReality.WebRTC.UnityPlugin.Native project.
set(mr-unityplugin-native-dir ../../../../../../../libs/Microsoft.MixedReality.WebRTC.UnityPlugin.Native)

# List of source files to compile.
add_library(
        Microsoft.MixedReality.WebRTC.UnityPlugin.Native
        SHARED
        ${mr-unityplugin-native-dir}/src/api.cpp
        ${mr-unityplugin-native-dir}/src/log_helpers.cpp
        ${mr-unityplugin-native-dir}/src/native_renderer.cpp
        ${mr-unityplugin-native-dir}/src/pch.cpp
        ${mr-unityplugin-native-dir}/src/render_api.cpp
        ${mr-unityplugin-native-dir}/src/render_api_OpenGLCoreES.cpp
)

# List of include directories.
target_include_directories(
        Microsoft.MixedReality.WebRTC.UnityPlugin.Native
        PRIVATE
        ${mr-webrtc-native-dir}
        ${mr-unityplugin-native-dir}
        ${mr-unityplugin-native-dir}/src
)

# Build and link Microsoft.MixedReality.WebRTC.Native.so.
target_link_libraries(
        Microsoft.MixedReality.WebRTC.UnityPlugin.Native
        log
        android
        dl
        OpenSLES
        Microsoft.MixedReality.WebRTC.Native
)
