using System;
using System.Runtime.InteropServices;
using Microsoft.MixedReality.WebRTC.Interop;

namespace Microsoft.MixedReality.WebRTC
{
    /// <summary>
    /// Request sent to an external video source via its registered callback to generate
    /// a new video frame for the track(s) connected to it.
    /// </summary>
    public ref struct FrameRequest
    {
        /// <summary>
        /// Interop handle to the native video track source this request is for.
        /// </summary>
        public IntPtr SourceHandle;

        /// <summary>
        /// Unique request identifier, for error checking.
        /// </summary>
        public uint RequestId;

        /// <summary>
        /// Complete the frame request by push the generated frame down the WebRTC pipeline.
        /// </summary>
        /// <param name="frame">The frame newly generated by the external video source.</param>
        public void Complete(I420VideoFrame frame)
        {
            ExternalVideoTrackSourceInterop.CompleteExternalI420VideoFrameRequest(SourceHandle, RequestId, frame);
        }
    }

    /// <summary>
    /// Callback invoked when the WebRTC pipeline needs an external video source to generate
    /// a new video frame for the track(s) it is connected to.
    /// </summary>
    /// <param name="request"></param>
    public delegate void I420VideoFrameRequestDelegate(FrameRequest request);

    /// <summary>
    /// Video source for WebRTC video tracks based on a custom source
    /// of video frames managed by the user and external to the WebRTC
    /// implementation.
    /// 
    /// This class is used to inject into the WebRTC engine a video track
    /// whose frames are produced by a user-managed source the WebRTC engine
    /// knows nothing about, like programmatically generated frames, including
    /// frames not strictly of video origin like a 3D rendered scene, or frames
    /// coming from a specific capture device not supported natively by WebRTC.
    /// This class serves as an adapter for such video frame sources.
    /// </summary>
    public class ExternalVideoTrackSource : IDisposable
    {
        /// <summary>
        /// Peer connection this video track source is part of.
        /// </summary>
        public PeerConnection PeerConnection { get; private set; }

        /// <summary>
        /// Handle to native peer connection C++ object.
        /// </summary>
        protected IntPtr _nativePeerHandle = IntPtr.Zero;

        /// <summary>
        /// Handle to native external video track source C++ object.
        /// </summary>
        protected IntPtr _nativeHandle = IntPtr.Zero;

        /// <summary>
        /// GC handle to frame request callback args keeping the delegate alive
        /// while the callback is registered with the native implementation.
        /// </summary>
        protected GCHandle _frameRequestCallbackArgsHandle;

        internal ExternalVideoTrackSource(PeerConnection peer, IntPtr nativePeerHandle, IntPtr nativeHandle,
            GCHandle frameRequestCallbackArgsHandle)
        {
            PeerConnection = peer;
            _nativePeerHandle = nativePeerHandle;
            _nativeHandle = nativeHandle;
            _frameRequestCallbackArgsHandle = frameRequestCallbackArgsHandle;
        }

        #region IDisposable support

        protected virtual void Dispose(bool disposing)
        {
            if (_nativeHandle == IntPtr.Zero)
            {
                return;
            }

            PeerConnectionInterop.PeerConnection_RemoveLocalVideoTracks(_nativePeerHandle, _nativeHandle);
            _frameRequestCallbackArgsHandle.Free();
            _nativeHandle = IntPtr.Zero;
            _nativePeerHandle = IntPtr.Zero;

            if (disposing)
            {
                PeerConnection = null;
            }
        }

        ~ExternalVideoTrackSource()
        {
            Dispose(false);
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        #endregion
    }
}
