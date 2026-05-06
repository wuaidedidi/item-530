MERGE INTO sys_role (id, role_name, role_key, order_num, status, remark) KEY(id) VALUES
(1, '超级管理员', 'admin', 1, 1, '拥有系统所有权限'),
(2, '普通用户', 'user', 2, 1, '普通用户角色');

MERGE INTO sys_user (id, username, password, nickname, email, phone, status) KEY(id) VALUES
(1, 'admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iKtE/ETXmB5nNiHxqHnHfgVd5GK6', '超级管理员', 'admin@example.com', '13800138000', 1),
(2, 'test', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iKtE/ETXmB5nNiHxqHnHfgVd5GK6', '测试用户', 'test@example.com', '13800138001', 1);

MERGE INTO sys_user_role (user_id, role_id) KEY(user_id, role_id) VALUES
(1, 1),
(2, 2);

MERGE INTO sys_menu (id, menu_name, parent_id, order_num, path, component, perms, menu_type, visible, status, icon) KEY(id) VALUES
(1, '系统管理', 0, 1, '/system', NULL, NULL, 0, 1, 1, 'Setting'),
(2, '用户管理', 1, 1, '/system/user', 'system/User', 'system:user:list', 1, 1, 1, 'User'),
(3, '角色管理', 1, 2, '/system/role', 'system/Role', 'system:role:list', 1, 1, 1, 'Avatar'),
(4, '菜单管理', 1, 3, '/system/menu', 'system/Menu', 'system:menu:list', 1, 1, 1, 'Menu'),
(5, '数据权限', 1, 4, '/system/dataPerm', 'system/DataPermission', 'system:dataPerm:list', 1, 1, 1, 'Lock'),
(21, '用户查询', 2, 1, '', NULL, 'system:user:query', 2, 1, 1, NULL),
(22, '用户新增', 2, 2, '', NULL, 'system:user:add', 2, 1, 1, NULL),
(23, '用户修改', 2, 3, '', NULL, 'system:user:edit', 2, 1, 1, NULL),
(24, '用户删除', 2, 4, '', NULL, 'system:user:delete', 2, 1, 1, NULL),
(25, '重置密码', 2, 5, '', NULL, 'system:user:resetPwd', 2, 1, 1, NULL),
(31, '角色查询', 3, 1, '', NULL, 'system:role:query', 2, 1, 1, NULL),
(32, '角色新增', 3, 2, '', NULL, 'system:role:add', 2, 1, 1, NULL),
(33, '角色修改', 3, 3, '', NULL, 'system:role:edit', 2, 1, 1, NULL),
(34, '角色删除', 3, 4, '', NULL, 'system:role:delete', 2, 1, 1, NULL),
(41, '菜单查询', 4, 1, '', NULL, 'system:menu:query', 2, 1, 1, NULL),
(42, '菜单新增', 4, 2, '', NULL, 'system:menu:add', 2, 1, 1, NULL),
(43, '菜单修改', 4, 3, '', NULL, 'system:menu:edit', 2, 1, 1, NULL),
(44, '菜单删除', 4, 4, '', NULL, 'system:menu:delete', 2, 1, 1, NULL),
(51, '数据权限查询', 5, 1, '', NULL, 'system:dataPerm:query', 2, 1, 1, NULL),
(52, '数据权限编辑', 5, 2, '', NULL, 'system:dataPerm:edit', 2, 1, 1, NULL),
(53, '数据权限删除', 5, 3, '', NULL, 'system:dataPerm:delete', 2, 1, 1, NULL);

MERGE INTO sys_role_menu (role_id, menu_id) KEY(role_id, menu_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5),
(1, 21), (1, 22), (1, 23), (1, 24), (1, 25),
(1, 31), (1, 32), (1, 33), (1, 34),
(1, 41), (1, 42), (1, 43), (1, 44),
(1, 51), (1, 52), (1, 53),
(2, 1), (2, 2), (2, 3),
(2, 21), (2, 31);

MERGE INTO sys_data_permission (id, role_id, scope_type, custom_dept_ids) KEY(id) VALUES
(1, 1, 1, NULL),
(2, 2, 5, NULL);
