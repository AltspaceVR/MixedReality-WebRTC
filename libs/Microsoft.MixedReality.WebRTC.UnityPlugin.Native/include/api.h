// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

#pragma once

#include "include/export.h"
#include "include/video_frame.h"
#include "src/mrs_errors.h"

extern "C" {

using mrsResult = Microsoft::MixedReality::WebRTC::Result;

/// Opaque handle to a native PeerConnection C++ object.
using PeerConnectionHandle = void*;

//
// Native rendering
//

enum class VideoKind : int32_t {
  kNone = 0,
  kI420 = 1,
  kARGB = 2,
};

struct TextureDesc {
  void* texture{nullptr};
  int width{0};
  int height{0};
};

/// Signature of rendering method called by Unity.
typedef void(MRS_CALL* VideoRenderMethod)();

/// Create a native renderer and return a handle to it.
MRS_API mrsResult MRS_CALL
mrsNativeRenderer_Create(PeerConnectionHandle peerHandle) noexcept;

/// Destroy a native renderer.
MRS_API mrsResult MRS_CALL
mrsNativeRenderer_Destroy(PeerConnectionHandle peerHandle) noexcept;

//// Register textures for remote video and start rendering it.
MRS_API mrsResult MRS_CALL
mrsNativeRenderer_EnableRemoteVideo(PeerConnectionHandle peerHandle,
                                    VideoKind format,
                                    TextureDesc textures[],
                                    int textureCount) noexcept;

/// Clear remote textures and stop rendering remote video.
MRS_API mrsResult MRS_CALL
mrsNativeRenderer_DisableRemoteVideo(PeerConnectionHandle peerHandle) noexcept;

/// Returns the rendering method called by Unity.
MRS_API VideoRenderMethod MRS_CALL
mrsNativeRenderer_GetVideoUpdateMethod() noexcept;

//
// Utils
//

typedef void (*LogFunction)(const char*);

/// Pipe log entries to Unity's log.
MRS_API void MRS_CALL
mrsNativeRenderer_SetLoggingFunctions(LogFunction logDebugFunc,
                                      LogFunction logErrorFunc,
                                      LogFunction logWarningFunc);
}
