enum UserProfile {
  admin,
  quality,
  user,
}

extension UserProfileLabel on UserProfile {
  String get label {
    switch (this) {
      case UserProfile.admin:
        return 'Admin';

      case UserProfile.quality:
        return 'Qualidade';

      case UserProfile.user:
        return 'Usuário';
    }
  }
}

class TemporaryUser {
  const TemporaryUser({
    required this.id,
    required this.name,
    required this.username,
    required this.profile,
    required this.active,
  });

  final String id;
  final String name;
  final String username;
  final UserProfile profile;
  final bool active;

  TemporaryUser copyWith({
    String? id,
    String? name,
    String? username,
    UserProfile? profile,
    bool? active,
  }) {
    return TemporaryUser(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      profile: profile ?? this.profile,
      active: active ?? this.active,
    );
  }
}