// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

using System.Threading.Tasks;
using Microsoft.MixedReality.WebRTC.Interop;
using Microsoft.MixedReality.WebRTC.Tracing;

namespace Microsoft.MixedReality.WebRTC
{
    /// <summary>
    /// Configuration to initialize capture on a local audio device (microphone).
    /// </summary>
    public class LocalAudioDeviceInitConfig
    {
        /// <summary>
        /// Enable automated gain control (AGC) on the audio device capture pipeline.
        /// </summary>
        public bool? AutoGainControl = null;

        /// <summary>
        /// Audio processing to filter out background noise.
        /// </summary>
        public bool? NoiseSuppression = null;

        /// <summary>
        /// Audio processing to remove background noise of lower frequencies.
        /// </summary>
        public bool? HighpassFilter = null;

        /// <summary>
        /// Audio processing to swap the left and right channels.
        /// </summary>
        public bool? StereoSwapping = null;

        /// <summary>
        /// Enable echo cancellation (AEC). Audio processing that attempts to filter away the output signal from later inbound pickup. Also breaks recording entirely.
        /// </summary>
        public bool? EchoCancellation = null;

        /// <summary>
        /// The name of the device to capture audio from. 
        /// </summary>
        public bool? Loopback = null;

        /// <summary>
        /// The name of the device to capture audio from. 
        /// </summary>
        public string DeviceId = null;
    }

    /// <summary>
    /// Implementation of an audio track source producing frames captured from an audio capture device (microphone).
    /// </summary>
    /// <seealso cref="LocalAudioTrack"/>
    public class DeviceAudioTrackSource : AudioTrackSource
    {
        /// <summary>
        /// Create an audio track source using a local audio capture device (microphone).
        /// </summary>
        /// <param name="initConfig">Optional configuration to initialize the audio capture on the device.</param>
        /// <returns>The newly create audio track source.</returns>
        /// <seealso cref="LocalAudioTrack.CreateFromSource(AudioTrackSource, LocalAudioTrackInitConfig)"/>
        public static Task<DeviceAudioTrackSource> CreateAsync(LocalAudioDeviceInitConfig initConfig = null)
        {
            // Ensure the logging system is ready before using PInvoke.
            MainEventSource.Log.Initialize();

            return Task.Run(() =>
            {
                // On UWP this cannot be called from the main UI thread, so always call it from
                // a background worker thread.

                var config = new DeviceAudioTrackSourceInterop.LocalAudioDeviceMarshalInitConfig(initConfig);
                uint ret = DeviceAudioTrackSourceInterop.DeviceAudioTrackSource_Create(in config, out DeviceAudioTrackSourceHandle handle);
                Utils.ThrowOnErrorCode(ret);
                return new DeviceAudioTrackSource(handle);
            });
        }

        internal DeviceAudioTrackSource(AudioTrackSourceHandle nativeHandle) : base(nativeHandle)
        {
        }

        /// <inheritdoc/>
        public override string ToString()
        {
            return $"(DeviceAudioTrackSource)\"{Name}\"";
        }
    }
}
