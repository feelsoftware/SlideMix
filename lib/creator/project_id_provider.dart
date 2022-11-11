import 'package:shared_preferences/shared_preferences.dart';

abstract class ProjectIdProvider {
  Future<int> provideProjectId();
}

const _projectIdKey = 'projectId';

class ProjectIdProviderImpl extends ProjectIdProvider {
  final SharedPreferences sharedPreferences;

  ProjectIdProviderImpl({
    required this.sharedPreferences,
  });

  @override
  Future<int> provideProjectId() async {
    final oldProjectId = sharedPreferences.getInt(_projectIdKey) ?? 0;
    final projectId = oldProjectId + 1;
    await sharedPreferences.setInt(_projectIdKey, projectId);
    return projectId;
  }
}
