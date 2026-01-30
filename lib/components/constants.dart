enum UserCategory {
  itTeam,
  director,
  manager,
  adminDepartment,
  teacher,
  driver,
  parent,
}
extension UserCategoryExtension on UserCategory {
  String get value {
    switch (this) {
      case UserCategory.itTeam:
        return 'it_team';
      case UserCategory.director:
        return 'director';
      case UserCategory.manager:
        return 'manager';
      case UserCategory.adminDepartment:
        return 'admin_department';
      case UserCategory.teacher:
        return 'teacher';
      case UserCategory.driver:
        return 'driver';
      case UserCategory.parent:
        return 'parent';
    }
  }

  String get label {
    switch (this) {
      case UserCategory.itTeam:
        return 'IT Team';
      case UserCategory.director:
        return 'Director';
      case UserCategory.manager:
        return 'Manager';
      case UserCategory.adminDepartment:
        return 'Admin Department';
      case UserCategory.teacher:
        return 'Teacher';
      case UserCategory.driver:
        return 'Driver';
      case UserCategory.parent:
        return 'Parent';
    }
  }
}
