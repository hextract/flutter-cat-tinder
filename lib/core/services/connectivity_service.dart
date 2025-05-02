import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter/material.dart';

class ConnectivityService {
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  List<ConnectivityResult>? _lastConnectivityResult;
  bool _isInitialized = false;

  Future<void> initialize({
    required BuildContext context,
    required VoidCallback onFetchCats,
  }) async {
    if (_isInitialized) {
      debugPrint('ConnectivityService: Already initialized, skipping');
      return;
    }
    _isInitialized = true;
    debugPrint('ConnectivityService: Initializing...');

    // Store ScaffoldMessenger and theme colors before async operations
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final errorColor = Theme.of(context).colorScheme.error;
    final secondaryColor = Theme.of(context).colorScheme.secondary;

    if (kIsWeb) {
      debugPrint('ConnectivityService: Running on web, assuming wifi');
      _lastConnectivityResult = [ConnectivityResult.wifi];
      onFetchCats();
      return;
    }

    try {
      final result = await Connectivity()
          .checkConnectivity()
          .timeout(const Duration(seconds: 5), onTimeout: () {
        debugPrint(
            'ConnectivityService: Timeout checking initial connectivity');
        return [ConnectivityResult.none];
      });
      debugPrint('ConnectivityService: Initial connectivity result: $result');
      _lastConnectivityResult = result;
      onFetchCats();
    } catch (e) {
      debugPrint(
          'ConnectivityService: Error checking initial connectivity: $e');
      _lastConnectivityResult = [ConnectivityResult.none];
      onFetchCats();
    }

    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      final isOffline = result.every((r) => r == ConnectivityResult.none);
      final wasOffline =
          _lastConnectivityResult?.every((r) => r == ConnectivityResult.none) ??
              false;

      debugPrint(
          'ConnectivityService: Connectivity changed: $result, isOffline: $isOffline, wasOffline: $wasOffline');

      if (isOffline && !wasOffline) {
        debugPrint(
            'ConnectivityService: Showing "No internet connection" snackbar');
        scaffoldMessenger.clearSnackBars();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: const Text('No internet connection.'),
            backgroundColor: errorColor,
            duration: const Duration(seconds: 3),
          ),
        );
        _lastConnectivityResult = result;
        onFetchCats();
      } else if (wasOffline && !isOffline) {
        debugPrint(
            'ConnectivityService: Showing "Internet connection restored" snackbar');
        scaffoldMessenger.clearSnackBars();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: const Text('Internet connection restored.'),
            backgroundColor: secondaryColor,
            duration: const Duration(seconds: 3),
          ),
        );
        _lastConnectivityResult = result;
        onFetchCats();
      } else {
        _lastConnectivityResult = result;
      }
    });
  }

  void dispose() {
    debugPrint('ConnectivityService: Disposing subscription');
    _subscription?.cancel();
    _isInitialized = false;
  }

  bool isOffline() {
    final offline =
        _lastConnectivityResult?.every((r) => r == ConnectivityResult.none) ??
            true;
    debugPrint('ConnectivityService: isOffline: $offline');
    return offline;
  }
}
