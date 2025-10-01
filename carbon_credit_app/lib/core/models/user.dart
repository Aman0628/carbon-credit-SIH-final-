class User {
  final String id;
  final String email;
  final String? phone;
  final String name;
  final UserRole role;
  final String kycStatus; // 'pending', 'approved', 'rejected'
  final DateTime createdAt;
  final String? aadhaarNumber;
  final String? companyName;

  const User({
    required this.id,
    required this.email,
    this.phone,
    required this.name,
    required this.role,
    required this.kycStatus,
    required this.createdAt,
    this.aadhaarNumber,
    this.companyName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      name: json['name'] as String,
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
        orElse: () => UserRole.buyer,
      ),
      kycStatus: json['kyc_status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      aadhaarNumber: json['aadhaar_number'] as String?,
      companyName: json['company_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phone': phone,
      'name': name,
      'role': role.toString().split('.').last,
      'kyc_status': kycStatus,
      'created_at': createdAt.toIso8601String(),
      'aadhaar_number': aadhaarNumber,
      'company_name': companyName,
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? phone,
    String? name,
    UserRole? role,
    String? kycStatus,
    DateTime? createdAt,
    String? aadhaarNumber,
    String? companyName,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      role: role ?? this.role,
      kycStatus: kycStatus ?? this.kycStatus,
      createdAt: createdAt ?? this.createdAt,
      aadhaarNumber: aadhaarNumber ?? this.aadhaarNumber,
      companyName: companyName ?? this.companyName,
    );
  }
}

enum UserRole {
  buyer,
  seller,
  both,
}
