class UserModel {
  final String id;
  final String username;
  final String email;
  final String? profilePicture;
  final String firstName;
  final String lastName;
  final String category;
  final String school;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.profilePicture,
    required this.firstName,
    required this.lastName,
    required this.category,
    required this.school,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      profilePicture: json['profile_picture'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      category: json['category'],
      school: json['school'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'profile_picture': profilePicture,
      'first_name': firstName,
      'last_name': lastName,
      'category': category,
      'school': school,
    };
  }
}
class ProfileModel {
  final String id;
  final UserModel user;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String attendenceId;
  final String phoneNumber;
  final String? secondaryPhoneNumber;
  final String currentAddress;
  final String permanentAddress;
  final String? suppotiveName;
  final String? occupation;

  final String? subjectSpecialization;
  final String? qualification;
  final String? licenseNumber;
  final String? vehicleNumber;
  final String? createdBy;

  ProfileModel({
    required this.id,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
    required this.attendenceId,
    required this.phoneNumber,
    this.secondaryPhoneNumber,
    required this.currentAddress,
    required this.permanentAddress,
    this.suppotiveName,
    this.occupation,
    this.subjectSpecialization,
    this.qualification,
    this.licenseNumber,
    this.vehicleNumber,
    this.createdBy,
  });

  /// JSON → Object
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      user: UserModel.fromJson(json['user']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      attendenceId: json['attendence_id'],
      phoneNumber: json['phone_number'],
      secondaryPhoneNumber: json['secondary_phone_number'],
      currentAddress: json['current_address'],
      permanentAddress: json['permanent_address'],
      suppotiveName: json['suppotive_name'],
      occupation: json['occupation'],
      subjectSpecialization: json['subject_specialization'],
      qualification: json['qaulification'],
      licenseNumber: json['license_number'],
      vehicleNumber: json['vehicle_number'],
      createdBy: json['created_by'],
    );
  }

  /// Object → Map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'attendence_id': attendenceId,
      'phone_number': phoneNumber,
      'secondary_phone_number': secondaryPhoneNumber,
      'current_address': currentAddress,
      'permanent_address': permanentAddress,
      'suppotive_name': suppotiveName,
      'occupation': occupation,
      'subject_specialization': subjectSpecialization,
      'qaulification': qualification,
      'license_number': licenseNumber,
      'vehicle_number': vehicleNumber,
      'created_by': createdBy,
    };
  }
}
