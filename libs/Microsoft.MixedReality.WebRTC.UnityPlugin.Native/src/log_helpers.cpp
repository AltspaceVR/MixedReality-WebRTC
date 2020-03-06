// Copyright (c) Microsoft Corporation.
// Licensed under the MIT License.

#include "pch.h"

#include "../include/api.h"
#include "log_helpers.h"

LogFunction UnityLogger::LogDebugFunc = nullptr;
LogFunction UnityLogger::LogErrorFunc = nullptr;
LogFunction UnityLogger::LogWarningFunc = nullptr;

void UnityLogger::LogDebug(const char* str) {
  if (LogDebugFunc != nullptr) {
    LogDebugFunc(str);
  }
}

void UnityLogger::LogError(const char* str) {
  if (LogErrorFunc != nullptr) {
    LogErrorFunc(str);
  }
}

void UnityLogger::LogWarning(const char* str) {
  if (LogWarningFunc != nullptr) {
    LogWarningFunc(str);
  }
}

bool UnityLogger::LoggersSet() {
  return LogDebugFunc != nullptr && LogWarningFunc != nullptr && LogErrorFunc != nullptr;
}

void UnityLogger::SetLoggingFunctions(LogFunction logDebug,
                                      LogFunction logError,
                                      LogFunction logWarning) {
  LogDebugFunc = logDebug;
  LogErrorFunc = logError;
  LogWarningFunc = logWarning;
}
