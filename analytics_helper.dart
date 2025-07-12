class AnalyticsHelper {
  final PrefManager _prefManager = getIt<PrefManager>();

  Future<UserContext?> getUserContext() async {
    try {
      return UserContext(
        userId: _prefManager.getUserId(),
        userName: _prefManager.getUserName().toString(),
        userEmail: _prefManager.getUserEmail().toString(),
        userPhone: _prefManager.getUserPhone().toString(),
        userRole: _prefManager.getRole().toString(),
      );
    } catch (e) {
      CrashlyticsLogger.logMessage('Error getting user context: $e');
      return null;
    }
  }

  AnalyticsEvent createLoginEvent({String? method}) {
    CrashlyticsLogger.logMessage('createLoginEvent');
    final event = AnalyticsEvent(
      name: 'user_login_custom',
      parameters: {
        if (method != null) 'method': method,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
    return event;
  }
  
  AnalyticsEvent createLogOutEvent({String? method}) {
    CrashlyticsLogger.logMessage('createLogOitEvent');
    final event = AnalyticsEvent(
      name: 'user_logout_custom',
      parameters: {
        if (method != null) 'method': method,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
    return event;
  }

  AnalyticsEvent createSignUpEvent({String? method}) {
    return AnalyticsEvent(
      name: 'user_sign_up_custom',
      parameters: {
        if (method != null) 'method': method,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // for any other event
  AnalyticsEvent createCustomEvent({
    required String eventName,
    Map<String, Object>? parameters,
    bool includeUserContext = true,
  }) {
    return AnalyticsEvent(
      name: eventName,
      parameters: {
        ...?parameters,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      includeUserContext: includeUserContext,
    );
  }

  // for screen view events
  ScreenViewEvent createScreenViewEvent({
    required String screenName,
    String? screenClass,
    Map<String, Object>? parameters,
  }) {
    return ScreenViewEvent(
      screenName: screenName,
      screenClass: screenClass,
      parameters: {
        ...?parameters,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }
}
