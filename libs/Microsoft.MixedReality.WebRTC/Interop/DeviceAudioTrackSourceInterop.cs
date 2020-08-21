// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

using System.Runtime.InteropServices;

namespace Microsoft.MixedReality.WebRTC.Interop
{
    /// <summary>
    /// Handle to a native device audio track source object.
    /// </summary>
    internal sealed class DeviceAudioTrackSourceHandle : AudioTrackSourceHandle { }

    internal class DeviceAudioTrackSourceInterop
    {
        /// <summary>
        /// Marshaling struct for initializing settings when opening a local audio device.
        /// </summary>
        [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
        internal ref struct LocalAudioDeviceMarshalInitConfig
        {
            public mrsOptBool AutoGainControl;
            public mrsOptBool NoiseSuppression;
            public mrsOptBool HighpassFilter;
            public mrsOptBool StereoSwapping;
            public mrsOptBool EchoCancellation;

            /// <summary>
            /// Constructor for creating a local audio device initialization settings marshaling struct.
            /// </summary>
            /// <param name="settings">The settings to initialize the newly created marshaling struct.</param>
            /// <seealso cref="DeviceAudioTrackSource.CreateAsync(LocalAudioDeviceInitConfig)"/>
            public LocalAudioDeviceMarshalInitConfig(LocalAudioDeviceInitConfig settings)
            {
                AutoGainControl = (mrsOptBool)settings?.AutoGainControl;
                NoiseSuppression = (mrsOptBool)settings?.NoiseSuppression;
                HighpassFilter = (mrsOptBool)settings?.HighpassFilter;
                StereoSwapping = (mrsOptBool)settings?.StereoSwapping;
                EchoCancellation = (mrsOptBool)settings?.EchoCancellation;
            }
        }

        #region P/Invoke static functions

        [DllImport(Utils.dllPath, CallingConvention = CallingConvention.StdCall, CharSet = CharSet.Ansi,
            EntryPoint = "mrsDeviceAudioTrackSourceCreate")]
        public static unsafe extern uint DeviceAudioTrackSource_Create(
            in LocalAudioDeviceMarshalInitConfig config, out DeviceAudioTrackSourceHandle sourceHandle);

        #endregion
    }
}
