/*
 * UserContext class is a model class that contains the user information to unify data across the app
*/
class UserContext {
  final String userId;
  final String userName;
  final String userRole;
  final String? userEmail;
  final String? userPhone;

  const UserContext({
    required this.userId,
    required this.userName,
    required this.userRole,
    this.userEmail,
    this.userPhone,
  });

  Map<String, Object> toParameters() {
    final params = <String, Object>{
      'user_id': userId,
      'user_name': userName,
      'user_role': userRole,
    };
    // special case to my app as user_phone and user_email are not required 
    if (userEmail != null) params['user_email'] = userEmail!;
    if (userPhone != null) params['user_phone'] = userPhone!;

    return params;
  }
}

/*
 * AnalyticsEvent class && ScreenViewEvent are model classes for analytics to unify the events data 
*/
class AnalyticsEvent {
  final String name;
  final Map<String, Object>? parameters;
  final bool includeUserContext;

  const AnalyticsEvent({
    required this.name,
    this.parameters,
    this.includeUserContext = true,
  });
}

class ScreenViewEvent {
  final String screenName;
  final String? screenClass;
  final Map<String, Object>? parameters;

  const ScreenViewEvent({
    required this.screenName,
    this.screenClass,
    this.parameters,
  });
}
