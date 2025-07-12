import '../../../di.dart';
import 'analytics_helper.dart';
import 'analytics_services.dart';

extension AnalyticsServiceExtensions on IAnalyticsService {
  // log login event
  Future<void> logLogin({String? method}) async {
    final helper = getIt<AnalyticsHelper>();
    await logEvent(helper.createLoginEvent(method: method));
  }

  // log custom event
  Future<void> logUpdateProfile({Map<String, Object>? parameters}) async {
    final helper = getIt<AnalyticsHelper>();
    await logEvent(
      helper.createCustomEvent(
        eventName: 'user_update_profile',
        parameters: parameters,
      ),
    );
  }

  // log screen view
  Future<void> radarAROpenView({
    String? screenClass,
    Map<String, Object>? parameters,
  }) async {
    final helper = getIt<AnalyticsHelper>();
    await logScreenView(
      helper.createScreenViewEvent(
        screenName: 'Radar',
        screenClass: screenClass,
        parameters: parameters,
      ),
    );
  }
  
  // you could add any event here and call it directly in ui without implementation
}
