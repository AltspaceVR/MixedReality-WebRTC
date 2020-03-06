// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

#pragma once

#include <map>
#include <mutex>
#include <set>

#include "render_api.h"

using mrsI420AVideoFrame = Microsoft::MixedReality::WebRTC::I420AVideoFrame;
using mrsArgb32VideoFrame = Microsoft::MixedReality::WebRTC::Argb32VideoFrame;

struct I420VideoFrame {
  int width{0};
  int height{0};
  int ystride{0};
  int ustride{0};
  int vstride{0};
  std::vector<uint8_t> ybuffer;
  std::vector<uint8_t> ubuffer;
  std::vector<uint8_t> vbuffer;

  void CopyFrame(const mrsI420AVideoFrame& frame);

  const std::vector<uint8_t>& GetBuffer(int i) {
    switch (i) {
      case 0:
        return ybuffer;
      case 1:
        return ubuffer;
      case 2:
        return vbuffer;
      default:
        // TODO: Fix.
        throw "aaah!";
    }
  }
};

struct ArgbVideoFrame {
    // TODO
};

class NativeRenderer {
 public:
  static void Create(PeerConnectionHandle peerHandle);
  static void Destroy(PeerConnectionHandle peerHandle);
  static std::shared_ptr<NativeRenderer> Get(PeerConnectionHandle peerHandle);

  NativeRenderer(PeerConnectionHandle peerHandle);
  ~NativeRenderer();

  PeerConnectionHandle Handle() const { return m_handle; }

  void EnableLocalVideo(VideoKind format,
                        TextureDesc textureDescs[],
                        int textureDescCount);
  void DisableLocalVideo();
  void EnableRemoteVideo(VideoKind format,
                         TextureDesc textureDescs[],
                         int textureDescCount);
  void DisableRemoteVideo();

  static void MRS_CALL DoVideoUpdate();
  static void OnGraphicsDeviceEvent(UnityGfxDeviceEventType eventType,
                                    UnityGfxRenderer deviceType,
                                    IUnityInterfaces* unityInterfaces);

 private:
  static std::map<PeerConnectionHandle, std::shared_ptr<NativeRenderer>>
      g_renderers;

  static void DestroyUnsafe(PeerConnectionHandle peerHandle);
  static std::shared_ptr<NativeRenderer> GetUnsafe(
      PeerConnectionHandle peerHandle);
  static std::vector<std::shared_ptr<NativeRenderer>> MultiGetUnsafe(
      const std::set<PeerConnectionHandle>& peerHandles);

  PeerConnectionHandle m_handle{nullptr};
  std::mutex m_lock;
  std::vector<TextureDesc> m_remoteTextures;
  std::vector<TextureDesc> m_localTextures;
  VideoKind m_remoteVideoFormat{VideoKind::kNone};
  VideoKind m_localVideoFormat{VideoKind::kNone};
  std::shared_ptr<I420VideoFrame> m_nextI420RemoteVideoFrame;
  std::shared_ptr<ArgbVideoFrame> m_nextArgbRemoteVideoFrame;

  void Shutdown();

  static void MRS_CALL
  I420ARemoteVideoFrameCallback(void* user_data,
                                const mrsI420AVideoFrame& frame);
  static void MRS_CALL
  ArgbRemotevideoFrameCallback(void* user_data,
                               const mrsArgb32VideoFrame& frame);
};
