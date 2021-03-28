import 'dart:developer';

class MyRoles {
  Map<String, String> _roleLabelsMap = {
    'workyard_admin': '项目管理员',
    'super_admin': '超级管理员',
    'guard': '巡逻员',
    'worker': '维修工程师',
    'company_admin': '企业管理员',
    'gate_approval': '出门条审核人',
    'gate_guard': '出门条门卫保安',
  };

  /// 获取role's label
  String getLabel(String? roleName) {
    if (roleName == null) return '';
    return _roleLabelsMap[roleName] ?? '-';
  }

  /// 是否是项目相关角色
  bool isWorkyardRole(String roleName) {
    return ['workyard_admin', 'partrol_guard'].contains(roleName);
  }

  /// 是否是公司相关角色
  bool isCompanyRole(String roleName) {
    return ['company_admin', 'worker'].contains(roleName);
  }

  /// 获取所有项目角色信息
  List<Map> getWorkyardRoles(List rolesAll) {
    List<Map> roles = [];
    try {
      rolesAll.forEach((roleItem) {
        if (isWorkyardRole(roleItem['role'])) {
          roles.add(roleItem);
        }
      });
    } catch (e) {
      log('发生错误', error: e);
    }

    return roles;
  }

  /// 获取所有公司角色信息
  List<Map> getCompanyRoles(List rolesAll) {
    List<Map> roles = [];
    try {
      rolesAll.forEach((roleItem) {
        if (isCompanyRole(roleItem['role'])) {
          roles.add(roleItem);
        }
      });
    } catch (e) {
      log('发送错误', error: e);
    }

    return roles;
  }
}
