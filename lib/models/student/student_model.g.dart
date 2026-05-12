// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudentModel _$StudentModelFromJson(
  Map<String, dynamic> json,
) => _StudentModel(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  dob: json['dob'] as String,
  profileImage: json['profileImage'] as String? ?? '',
  subscriptionPlan: json['subscriptionPlan'] as String? ?? '',
  totalClassesCompleted: (json['totalClassesCompleted'] as num?)?.toInt() ?? 0,
  upcomingClassesCount: (json['upcomingClassesCount'] as num?)?.toInt() ?? 0,
  isSubscribed: json['isSubscribed'] as bool? ?? false,
);

Map<String, dynamic> _$StudentModelToJson(_StudentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'dob': instance.dob,
      'profileImage': instance.profileImage,
      'subscriptionPlan': instance.subscriptionPlan,
      'totalClassesCompleted': instance.totalClassesCompleted,
      'upcomingClassesCount': instance.upcomingClassesCount,
      'isSubscribed': instance.isSubscribed,
    };

_TeacherListModel _$TeacherListModelFromJson(Map<String, dynamic> json) =>
    _TeacherListModel(
      id: json['id'] as String,
      name: json['name'] as String,
      experience: json['experience'] as String,
      languages: (json['languages'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      rating: (json['rating'] as num).toDouble(),
      totalStudents: (json['totalStudents'] as num).toInt(),
      profileImage: json['profileImage'] as String? ?? '',
      isAvailable: json['isAvailable'] as bool? ?? true,
      country: json['country'] as String? ?? '',
      timezone: json['timezone'] as String? ?? '',
      availability:
          json['availability'] as Map<String, dynamic>? ??
          const <String, dynamic>{},
    );

Map<String, dynamic> _$TeacherListModelToJson(_TeacherListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'experience': instance.experience,
      'languages': instance.languages,
      'rating': instance.rating,
      'totalStudents': instance.totalStudents,
      'profileImage': instance.profileImage,
      'isAvailable': instance.isAvailable,
      'country': instance.country,
      'timezone': instance.timezone,
      'availability': instance.availability,
    };

_StudentUpcomingClassModel _$StudentUpcomingClassModelFromJson(
  Map<String, dynamic> json,
) => _StudentUpcomingClassModel(
  id: json['id'] as String,
  teacherName: json['teacherName'] as String,
  teacherImage: json['teacherImage'] as String,
  time: json['time'] as String,
  date: json['date'] as String,
  status: json['status'] as String? ?? 'upcoming',
  teacherId: json['teacherId'] as String?,
  studentId: json['studentId'] as String?,
  scheduledAt: json['scheduledAt'] == null
      ? null
      : DateTime.parse(json['scheduledAt'] as String),
  durationMinutes: (json['durationMinutes'] as num?)?.toInt(),
);

Map<String, dynamic> _$StudentUpcomingClassModelToJson(
  _StudentUpcomingClassModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'teacherName': instance.teacherName,
  'teacherImage': instance.teacherImage,
  'time': instance.time,
  'date': instance.date,
  'status': instance.status,
  'teacherId': instance.teacherId,
  'studentId': instance.studentId,
  'scheduledAt': instance.scheduledAt?.toIso8601String(),
  'durationMinutes': instance.durationMinutes,
};

_StudentProgressModel _$StudentProgressModelFromJson(
  Map<String, dynamic> json,
) => _StudentProgressModel(
  id: json['id'] as String,
  teacherName: json['teacherName'] as String,
  date: json['date'] as String,
  progressNote: json['progressNote'] as String,
  whatWasCovered: json['whatWasCovered'] as String,
  homework: json['homework'] as String,
  rating: json['rating'] as String,
);

Map<String, dynamic> _$StudentProgressModelToJson(
  _StudentProgressModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'teacherName': instance.teacherName,
  'date': instance.date,
  'progressNote': instance.progressNote,
  'whatWasCovered': instance.whatWasCovered,
  'homework': instance.homework,
  'rating': instance.rating,
};

_SubscriptionPlanModel _$SubscriptionPlanModelFromJson(
  Map<String, dynamic> json,
) => _SubscriptionPlanModel(
  id: json['id'] as String,
  title: json['title'] as String,
  price: (json['price'] as num).toDouble(),
  classesPerWeek: (json['classesPerWeek'] as num).toInt(),
  studentsAllowed: (json['studentsAllowed'] as num).toInt(),
  features: (json['features'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  isPopular: json['isPopular'] as bool? ?? false,
);

Map<String, dynamic> _$SubscriptionPlanModelToJson(
  _SubscriptionPlanModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'price': instance.price,
  'classesPerWeek': instance.classesPerWeek,
  'studentsAllowed': instance.studentsAllowed,
  'features': instance.features,
  'isPopular': instance.isPopular,
};

_SlotModel _$SlotModelFromJson(Map<String, dynamic> json) => _SlotModel(
  id: json['id'] as String,
  time: json['time'] as String,
  teacherTime: json['teacherTime'] as String? ?? '',
  isSelected: json['isSelected'] as bool? ?? false,
  isAvailable: json['isAvailable'] as bool? ?? true,
);

Map<String, dynamic> _$SlotModelToJson(_SlotModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'time': instance.time,
      'teacherTime': instance.teacherTime,
      'isSelected': instance.isSelected,
      'isAvailable': instance.isAvailable,
    };
