# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

cmake_minimum_required(VERSION 3.10.2)

#---------------------------------------------------------------------
# Import libwebrtc.a static library
# See ../libwebrtc/README.md for instructions on building libwebrtc.a.
#

# Import CMake settings for libwebrtc.a. This file is generated during
# the libwebrtc build.
include(../../../../../libwebrtc/.libwebrtc.cmake)

# Declare and configure the library.
add_library(
        libwebrtc
        STATIC IMPORTED
)
set_target_properties(
        libwebrtc
        PROPERTIES
        IMPORTED_LOCATION ${libwebrtc-out-dir}/obj/libwebrtc.a
)

#---------------------------------------------------------------------
# Configure libmrwebrtc.so build.
#

# Base path to mrwebrtc project.
set(mrwebrtc-dir ../../../../../../../libs/Microsoft.MixedReality.WebRTC.Native)

# List of source files to compile.
add_library(
        mrwebrtc
        SHARED
        ${mrwebrtc-dir}/src/interop/external_video_track_source_interop.cpp
        ${mrwebrtc-dir}/src/interop/global_factory.cpp
        ${mrwebrtc-dir}/src/interop/interop_api.cpp
        ${mrwebrtc-dir}/src/interop/local_video_track_interop.cpp
        ${mrwebrtc-dir}/src/interop/peer_connection_interop.cpp
        ${mrwebrtc-dir}/src/media/external_video_track_source.cpp
        ${mrwebrtc-dir}/src/media/local_video_track.cpp
        ${mrwebrtc-dir}/src/audio_frame_observer.cpp
        ${mrwebrtc-dir}/src/data_channel.cpp
        ${mrwebrtc-dir}/src/mrs_errors.cpp
        ${mrwebrtc-dir}/src/pch.cpp
        ${mrwebrtc-dir}/src/peer_connection.cpp
        ${mrwebrtc-dir}/src/sdp_utils.cpp
        ${mrwebrtc-dir}/src/str.cpp
        ${mrwebrtc-dir}/src/tracked_object.cpp
        ${mrwebrtc-dir}/src/video_frame_observer.cpp
        ./jni_onload.cpp
)

# List of include directories.
target_include_directories(
        mrwebrtc
        PRIVATE
        ${mrwebrtc-dir}/include
        ${mrwebrtc-dir}/src
        ${libwebrtc-src-dir}/webrtc/src/
        ${libwebrtc-src-dir}/webrtc/src/third_party/abseil-cpp
        ${libwebrtc-src-dir}/webrtc/src/third_party/libyuv/include
)

# Build and link libmrwebrtc.so.
target_link_libraries(
        mrwebrtc
        log
        android
        dl
        OpenSLES
        libwebrtc
)
