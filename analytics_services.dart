abstract class IAnalyticsService {
  Future<void> logEvent(AnalyticsEvent event);
  Future<void> logScreenView(ScreenViewEvent event);
  Future<void> setUserId(String? userId);
  Future<void> setUserProperty({required String name, required String value});
  Future<void> setUserContext(UserContext context);
  Future<void> resetAnalytics();
  FirebaseAnalyticsObserver get observer;
}

class FirebaseAnalyticsService implements IAnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final AnalyticsHelper _helper = getIt<AnalyticsHelper>();

  UserContext? _currentUserContext;

  @override
  FirebaseAnalyticsObserver get observer =>
      FirebaseAnalyticsObserver(analytics: _analytics);

  @override
  Future<void> logEvent(AnalyticsEvent event) async {
    try {
      final parameters = <String, Object>{};
      if (event.parameters != null) {
        parameters.addAll(event.parameters!);
      }
      if (event.includeUserContext) {
        final userContext = await _helper.getUserContext();
        final userParams = userContext!.toParameters();
        parameters.addAll(userParams);
      }
      await _analytics.logEvent(
        name: event.name,
        parameters: parameters.isNotEmpty ? parameters : null,
      );
    } catch (e) {
      // ignore this and implement your catch error module as you need (this is a specific case for my project)
      CrashlyticsLogger.logMessage('Analytics error: $e');
    }
  }

  @override
  Future<void> logScreenView(ScreenViewEvent event) async {
    try {
      await _analytics.logScreenView(
        screenName: event.screenName,
        screenClass: event.screenClass,
      );

      await logEvent(AnalyticsEvent(
        name: 'screen_view_${event.screenName}',
        parameters: {
          'screen_name': event.screenName,
          if (event.screenClass != null) 'screen_class': event.screenClass!,
          ...?event.parameters,
        },
      ));
    } catch (e) {
      // ignore this and implement your catch error module as you need (this is a specific case for my project)
      CrashlyticsLogger.logMessage('Screen view analytics error: $e');
    }
  }

  @override
  Future<void> setUserId(String? userId) async {
    try {
      await _analytics.setUserId(id: userId);
      _currentUserContext = await _helper.getUserContext();
    } catch (e) {
      // ignore this and implement your catch error module as you need (this is a specific case for my project)
      CrashlyticsLogger.logMessage('Set user ID error: $e');
    }
  }

  @override
  Future<void> setUserProperty(
      {required String name, required String value}) async {
    try {
      await _analytics.setUserProperty(name: name, value: value);
    } catch (e) {
      // ignore this and implement your catch error module as you need (this is a specific case for my project)
      CrashlyticsLogger.logMessage('Set user property error: $e');
    }
  }

  @override
  Future<void> setUserContext(UserContext context) async {
    try {
      _currentUserContext = context;

      await _analytics.setUserId(id: context.userId);

      final properties = {
        'user_name': context.userName,
        'user_email': context.userEmail,
        'user_phone': context.userPhone,
        'user_role': context.userRole,
      };

      for (final entry in properties.entries) {
        await _analytics.setUserProperty(
          name: entry.key,
          value: entry.value,
        );
      }
    } catch (e) {
      // ignore this and implement your catch error module as you need (this is a specific case for my project)
      CrashlyticsLogger.logMessage('Set user context error: $e');
    }
  }

  @override
  Future<void> resetAnalytics() async {
    try {
      await _analytics.resetAnalyticsData();
      _currentUserContext = null;
    } catch (e) {
      // ignore this and implement your catch error module as you need (this is a specific case for my project)
      CrashlyticsLogger.logMessage('Reset analytics error: $e');
    }
  }
}
