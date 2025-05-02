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
        debugPrint('ConnectivityService: Timeout checking initial connectivity');
        return [ConnectivityResult.none];
      });
      debugPrint('ConnectivityService: Initial connectivity result: $result');
      _lastConnectivityResult = result;
      if (context.mounted) {
        onFetchCats();
      } else {
        debugPrint('ConnectivityService: Context not mounted, skipping onFetchCats');
      }
    } catch (e) {
      debugPrint('ConnectivityService: Error checking initial connectivity: $e');
      _lastConnectivityResult = [ConnectivityResult.none];
      if (context.mounted) {
        onFetchCats();
      }
    }

    final scaffoldMessenger = ScaffoldMessenger.of(context);
    _subscription = Connectivity().onConnectivityChanged.listen((result) {
      final isOffline = result.every((r) => r == ConnectivityResult.none);
      final wasOffline =
          _lastConnectivityResult?.every((r) => r == ConnectivityResult.none) ??
              false;

      debugPrint('ConnectivityService: Connectivity changed: $result, isOffline: $isOffline, wasOffline: $wasOffline');

      if (isOffline && !wasOffline && context.mounted) {
        debugPrint('ConnectivityService: Showing "No internet connection" snackbar');
        scaffoldMessenger.clearSnackBars();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: const Text('No internet connection.'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 3),
          ),
        );
        _lastConnectivityResult = result;
        onFetchCats();
      } else if (wasOffline && !isOffline && context.mounted) {
        debugPrint('ConnectivityService: Showing "Internet connection restored" snackbar');
        scaffoldMessenger.clearSnackBars();
        scaffoldMessenger.showSnackBar(
          SnackBar(
            content: const Text('Internet connection restored.'),
            backgroundColor: Theme.of(context).colorScheme.secondary,
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
    final offline = _lastConnectivityResult?.every((r) => r == ConnectivityResult.none) ?? true;
    debugPrint('ConnectivityService: isOffline: $offline');
    return offline;
  }
}