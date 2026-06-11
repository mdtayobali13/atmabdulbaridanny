import 'dart:developer';

import 'package:flutter/material.dart';

class AppCustomRoutesObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _appLog('➡️ NAVIGATED TO: ${route.settings.name} (Args: ${route.settings.arguments})');
    if (previousRoute != null) {
      _appLog('⬅️ LEFT BEHIND: ${previousRoute.settings.name}');
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _appLog('⏪ POPPED OFF: ${route.settings.name}');
    if (previousRoute != null) {
      _appLog('↩️ RETURNED TO: ${previousRoute.settings.name}');
    }
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _appLog('❌ REMOVED: ${route.settings.name}');
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _appLog('🔄 REPLACED: ${oldRoute?.settings.name} WITH ${newRoute?.settings.name}');
  }
}

void _appLog(String message) {
  try {
    // Log to console and Flutter debug console
    log('🔜🔜🔜🔜🔜🔜 >>>>>>>>>>>>> $message  <<<<<<<<<<<<< 🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚🔚');
  } catch (_) {
    // Silently ignore logging errors to avoid crashing
  }
}
