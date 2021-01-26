// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

#pragma once

#include "interop_api.h"

extern "C" {

/// Configuration for opening a local audio capture device (microphone) as an
/// audio track source.
struct mrsLocalAudioDeviceInitConfig {
  /// Enable auto gain control (AGC).
  mrsOptBool auto_gain_control_{mrsOptBool::kUnset};
  mrsOptBool noise_suppression_{mrsOptBool::kUnset};
  mrsOptBool highpass_filter_{mrsOptBool::kUnset};
  mrsOptBool stereo_swapping_{mrsOptBool::kUnset};
  mrsOptBool echo_cancellation_{mrsOptBool::kUnset};
  mrsOptBool loopback_{mrsOptBool::kUnset};
  const char* deviceId_{nullptr};
};

/// Create an audio track source by opening a local audio capture device
/// (microphone).
MRS_API mrsResult MRS_CALL mrsDeviceAudioTrackSourceCreate(
    const mrsLocalAudioDeviceInitConfig* init_config,
    mrsDeviceAudioTrackSourceHandle* source_handle_out) noexcept;

}  // extern "C"
