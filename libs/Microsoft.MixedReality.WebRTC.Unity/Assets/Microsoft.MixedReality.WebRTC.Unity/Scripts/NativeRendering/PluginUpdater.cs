using System.Collections;
using Microsoft.MixedReality.WebRTC.UnityPlugin;
using UnityEngine;

namespace Microsoft.MixedReality.WebRTC.Unity
{
    /// <summary>
    /// Helper class that makes sure the native plugin is called once per frame if there are
    /// any active native renderers. It has to be a mono behavior so that it can start the
    /// co-routine that triggers the native plugin to render between frames.
    /// </summary>
    public class PluginUpdate : MonoBehaviour
    {
        private static int _refCount;
        private static bool _pluginInitialized;
        private static GameObject _owner;

        public static void AddRef()
        {
            if (_refCount == 0)
            {
                // Only need to initialize the plugin once.
                if (!_pluginInitialized)
                {
                    // Set logging functions, allowing the native plugin to write to the Unity log.
                    _pluginInitialized = true;
                    NativeRenderer.SetLoggingFunctions(
                        LogDebugCallback,
                        LogErrorCallback,
                        LogWarningCallback);
                }
                // Add a GameObject to run the Coroutine below.
                _owner = new GameObject("Microsoft.MixedReality.WebRTC.UnityPlugin");
                _owner.AddComponent<PluginUpdate>();
            }
            _refCount += 1;
        }

        public static void DecRef()
        {
            if (_refCount > 0)
            {
                _refCount -= 1;
                if (_refCount == 0)
                {
                    Destroy(_owner);
                    _owner = null;
                }
            }
        }

        IEnumerator Start()
        {
            yield return StartCoroutine("CallPluginAtEndOfFrames");
        }

        /// <summary>
        /// This co-routine tells the native plugin to render at the appropriate time.
        /// </summary>
        IEnumerator CallPluginAtEndOfFrames()
        {
            while (true)
            {
                // Wait until all frame rendering is done.
                yield return new WaitForEndOfFrame();

                // Render video to textures.
                GL.IssuePluginEvent(NativeRenderer.GetVideoUpdateMethod(), 0);
            }
        }

        [AOT.MonoPInvokeCallback(typeof(LogCallback))]
        private static void LogDebugCallback(string str)
        {
            Debug.Log(str);
        }

        [AOT.MonoPInvokeCallback(typeof(LogCallback))]
        private static void LogWarningCallback(string str)
        {
            Debug.LogWarning(str);
        }

        [AOT.MonoPInvokeCallback(typeof(LogCallback))]
        private static void LogErrorCallback(string str)
        {
            Debug.LogError(str);
        }

    }
}
