// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.
// This is a precompiled header, it must be on its own, followed by a blank
// line, to prevent clang-format from reordering it with other headers.
#include "pch.h"

#include "../include/api.h"
#include "./Unity/IUnityGraphics.h"
#include "./Unity/IUnityInterface.h"
#include "log_helpers.h"
#include "native_renderer.h"

//
// Unity
//

static IUnityInterfaces* s_UnityInterfaces = nullptr;
static IUnityGraphics* s_Graphics = nullptr;

extern "C" void UNITY_INTERFACE_EXPORT UNITY_INTERFACE_API
OnGraphicsDeviceEvent(UnityGfxDeviceEventType eventType) {
  NativeRenderer::OnGraphicsDeviceEvent(eventType, s_Graphics->GetRenderer(),
                                        s_UnityInterfaces);
}

extern "C" void UNITY_INTERFACE_EXPORT UNITY_INTERFACE_API
UnityPluginLoad(IUnityInterfaces* unityInterfaces) {
  s_UnityInterfaces = unityInterfaces;
  s_Graphics = s_UnityInterfaces->Get<IUnityGraphics>();
  s_Graphics->RegisterDeviceEventCallback(OnGraphicsDeviceEvent);
  OnGraphicsDeviceEvent(kUnityGfxDeviceEventInitialize);
}

extern "C" void UNITY_INTERFACE_EXPORT UNITY_INTERFACE_API UnityPluginUnload() {
  s_Graphics->UnregisterDeviceEventCallback(OnGraphicsDeviceEvent);
}

void MRS_CALL
mrsNativeRenderer_SetLoggingFunctions(LogFunction logDebugFunc,
                                      LogFunction logErrorFunc,
                                      LogFunction logWarningFunc) {
  UnityLogger::SetLoggingFunctions(logDebugFunc, logErrorFunc, logWarningFunc);
}

//
// NativeRenderer API
//

using namespace Microsoft::MixedReality::WebRTC;

mrsResult MRS_CALL
mrsNativeRenderer_Create(PeerConnectionHandle peerHandle) noexcept {
  NativeRenderer::Create(peerHandle);
  return Result::kSuccess;
}

mrsResult MRS_CALL
mrsNativeRenderer_Destroy(PeerConnectionHandle peerHandle) noexcept {
  NativeRenderer::Destroy(peerHandle);
  return Result::kSuccess;
}

mrsResult MRS_CALL
mrsNativeRenderer_EnableLocalVideo(PeerConnectionHandle peerHandle,
                                   VideoKind format,
                                   TextureDesc textures[],
                                   int textureCount) noexcept {
  if (auto renderer = NativeRenderer::Get(peerHandle)) {
    renderer->EnableLocalVideo(format, textures, textureCount);
  }
  return Result::kSuccess;
}

mrsResult MRS_CALL
mrsNativeRenderer_DisableLocalVideo(PeerConnectionHandle peerHandle) noexcept {
  if (auto renderer = NativeRenderer::Get(peerHandle)) {
    renderer->DisableLocalVideo();
  }
  return Result::kSuccess;
}

mrsResult MRS_CALL
mrsNativeRenderer_EnableRemoteVideo(PeerConnectionHandle peerHandle,
                                    VideoKind format,
                                    TextureDesc textures[],
                                    int textureCount) noexcept {
  if (auto renderer = NativeRenderer::Get(peerHandle)) {
    renderer->EnableRemoteVideo(format, textures, textureCount);
  }
  return Result::kSuccess;
}

mrsResult MRS_CALL
mrsNativeRenderer_DisableRemoteVideo(PeerConnectionHandle peerHandle) noexcept {
  if (auto renderer = NativeRenderer::Get(peerHandle)) {
    renderer->DisableRemoteVideo();
  }
  return Result::kSuccess;
}

VideoRenderMethod MRS_CALL mrsNativeRenderer_GetVideoUpdateMethod() noexcept {
  return NativeRenderer::DoVideoUpdate;
}
