class UserProfile {
  final String uid;
  final String email;
  final OnboardingData? onboarding;
  final MacroTargets? targets;

  const UserProfile({
    required this.uid,
    required this.email,
    this.onboarding,
    this.targets,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'] as String? ?? '',
      email: json['email'] as String? ?? '',
      onboarding: json['onboarding'] != null
          ? OnboardingData.fromJson(json['onboarding'] as Map<String, dynamic>)
          : null,
      targets: json['targets'] != null
          ? MacroTargets.fromJson(json['targets'] as Map<String, dynamic>)
          : null,
    );
  }
}

class OnboardingData {
  final String name;
  final String bio;
  final String biologicalSex;
  final int age;
  final double heightCm;
  final double weightKg;
  final double targetWeightKg;
  final String activityLevel;
  final int bmr;

  const OnboardingData({
    required this.name,
    required this.bio,
    required this.biologicalSex,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.targetWeightKg,
    required this.activityLevel,
    required this.bmr,
  });

  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(
      name: json['name'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      biologicalSex: json['biologicalSex'] as String? ?? 'Male',
      age: (json['age'] as num?)?.toInt() ?? 0,
      heightCm: (json['heightCm'] as num?)?.toDouble() ?? 0,
      weightKg: (json['weightKg'] as num?)?.toDouble() ?? 0,
      targetWeightKg: (json['targetWeightKg'] as num?)?.toDouble() ?? 0,
      activityLevel: json['activityLevel'] as String? ?? 'Active',
      bmr: (json['bmr'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'bio': bio,
        'biologicalSex': biologicalSex,
        'age': age,
        'heightCm': heightCm,
        'weightKg': weightKg,
        'targetWeightKg': targetWeightKg,
        'activityLevel': activityLevel,
      };
}

class MacroTargets {
  final int calories;
  final int protein;
  final int carbs;
  final int fat;

  const MacroTargets({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory MacroTargets.fromJson(Map<String, dynamic> json) {
    return MacroTargets(
      calories: (json['calories'] as num?)?.toInt() ?? 2000,
      protein: (json['protein'] as num?)?.toInt() ?? 150,
      carbs: (json['carbs'] as num?)?.toInt() ?? 200,
      fat: (json['fat'] as num?)?.toInt() ?? 65,
    );
  }
}
