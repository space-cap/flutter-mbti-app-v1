import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PerformanceHelper {
  static final Map<String, DateTime> _timers = {};
  static final List<String> _memoryLeakWatchlist = [];
  
  /// Start measuring performance of an operation
  static void startTimer(String operationName) {
    if (kDebugMode) {
      _timers[operationName] = DateTime.now();
      developer.log('⏱️ Started: $operationName', name: 'Performance');
    }
  }
  
  /// End measuring performance and log the duration
  static void endTimer(String operationName) {
    if (kDebugMode && _timers.containsKey(operationName)) {
      final duration = DateTime.now().difference(_timers[operationName]!);
      developer.log('✅ Completed: $operationName in ${duration.inMilliseconds}ms', name: 'Performance');
      _timers.remove(operationName);
    }
  }
  
  /// Monitor memory usage and detect potential leaks
  static void watchForMemoryLeaks(String identifier) {
    if (kDebugMode) {
      _memoryLeakWatchlist.add(identifier);
      developer.log('👀 Watching for memory leaks: $identifier', name: 'Memory');
    }
  }
  
  /// Stop monitoring for memory leaks
  static void stopWatchingMemoryLeaks(String identifier) {
    if (kDebugMode) {
      _memoryLeakWatchlist.remove(identifier);
      developer.log('✅ Stopped watching: $identifier', name: 'Memory');
    }
  }
  
  /// Force garbage collection (debug mode only)
  static void forceGC() {
    if (kDebugMode) {
      developer.log('🗑️ Forcing garbage collection', name: 'Memory');
      // This is a hint to the VM, not a guarantee
      SystemChannels.platform.invokeMethod('System.gc');
    }
  }
  
  /// Debounce function calls to prevent excessive executions
  static Timer? _debounceTimer;
  
  static void debounce(VoidCallback callback, {Duration delay = const Duration(milliseconds: 300)}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(delay, callback);
  }
  
  /// Throttle function calls to limit execution frequency
  static DateTime? _lastThrottleExecution;
  
  static void throttle(VoidCallback callback, {Duration interval = const Duration(milliseconds: 100)}) {
    final now = DateTime.now();
    if (_lastThrottleExecution == null || 
        now.difference(_lastThrottleExecution!) >= interval) {
      _lastThrottleExecution = now;
      callback();
    }
  }
  
  /// Cache for expensive calculations
  static final Map<String, CacheEntry> _cache = {};
  
  static T? getCached<T>(String key) {
    final entry = _cache[key];
    if (entry != null && !entry.isExpired) {
      if (kDebugMode) {
        developer.log('📦 Cache hit: $key', name: 'Cache');
      }
      return entry.value as T?;
    }
    return null;
  }
  
  static void setCached<T>(String key, T value, {Duration? expiry}) {
    _cache[key] = CacheEntry(value, expiry);
    if (kDebugMode) {
      developer.log('💾 Cached: $key', name: 'Cache');
    }
  }
  
  static void clearCache() {
    _cache.clear();
    if (kDebugMode) {
      developer.log('🗑️ Cache cleared', name: 'Cache');
    }
  }
  
  /// Batch operations to reduce UI rebuilds
  static void batchOperation(List<VoidCallback> operations) {
    if (kDebugMode) {
      startTimer('BatchOperation');
    }
    
    for (final operation in operations) {
      operation();
    }
    
    if (kDebugMode) {
      endTimer('BatchOperation');
    }
  }
  
  /// Preload resources to improve user experience
  static final Set<String> _preloadedResources = {};
  
  static Future<void> preloadAsset(String assetPath) async {
    if (_preloadedResources.contains(assetPath)) return;
    
    try {
      startTimer('PreloadAsset-$assetPath');
      await rootBundle.load(assetPath);
      _preloadedResources.add(assetPath);
      endTimer('PreloadAsset-$assetPath');
    } catch (e) {
      if (kDebugMode) {
        developer.log('❌ Failed to preload: $assetPath - $e', name: 'Performance');
      }
    }
  }
  
  /// Memory-efficient list operations
  static List<T> efficientSlice<T>(List<T> list, int start, int end) {
    if (start < 0) start = 0;
    if (end > list.length) end = list.length;
    if (start >= end) return [];
    
    // Use sublist for memory efficiency
    return list.sublist(start, end);
  }
  
  /// Get performance statistics
  static Map<String, dynamic> getPerformanceStats() {
    return {
      'activeTimers': _timers.keys.toList(),
      'memoryWatchlist': _memoryLeakWatchlist,
      'cacheSize': _cache.length,
      'preloadedResources': _preloadedResources.length,
    };
  }
}

class CacheEntry {
  final dynamic value;
  final DateTime createdAt;
  final Duration? expiry;
  
  CacheEntry(this.value, this.expiry) : createdAt = DateTime.now();
  
  bool get isExpired {
    if (expiry == null) return false;
    return DateTime.now().difference(createdAt) > expiry!;
  }
}

/// Mixin for widgets to easily track performance
mixin PerformanceTrackingMixin {
  void trackPerformance(String operation, VoidCallback callback) {
    PerformanceHelper.startTimer(operation);
    try {
      callback();
    } finally {
      PerformanceHelper.endTimer(operation);
    }
  }
  
  void trackAsyncPerformance(String operation, Future<void> Function() callback) async {
    PerformanceHelper.startTimer(operation);
    try {
      await callback();
    } finally {
      PerformanceHelper.endTimer(operation);
    }
  }
}