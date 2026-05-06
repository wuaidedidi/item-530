-- 设置字符集
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- 创建数据库
CREATE DATABASE IF NOT EXISTS permission_system CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE permission_system;

-- =============================================
-- 用户表
-- =============================================
CREATE TABLE IF NOT EXISTS sys_user (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '用户ID',
    username VARCHAR(50) NOT NULL UNIQUE COMMENT '用户名',
    password VARCHAR(200) NOT NULL COMMENT '密码',
    nickname VARCHAR(50) COMMENT '昵称',
    email VARCHAR(100) COMMENT '邮箱',
    phone VARCHAR(20) COMMENT '手机号',
    avatar VARCHAR(500) COMMENT '头像URL',
    status TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    INDEX idx_username (username),
    INDEX idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户表';

-- =============================================
-- 角色表
-- =============================================
CREATE TABLE IF NOT EXISTS sys_role (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '角色ID',
    role_name VARCHAR(50) NOT NULL COMMENT '角色名称',
    role_key VARCHAR(50) NOT NULL COMMENT '角色标识',
    order_num INT DEFAULT 0 COMMENT '显示顺序',
    status TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    remark VARCHAR(500) COMMENT '备注',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    deleted TINYINT DEFAULT 0 COMMENT '逻辑删除：0-未删除，1-已删除',
    UNIQUE INDEX idx_role_name (role_name),
    UNIQUE INDEX idx_role_key (role_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色表';

-- =============================================
-- 菜单表
-- =============================================
CREATE TABLE IF NOT EXISTS sys_menu (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT '菜单ID',
    menu_name VARCHAR(50) NOT NULL COMMENT '菜单名称',
    parent_id BIGINT DEFAULT 0 COMMENT '父菜单ID',
    order_num INT DEFAULT 0 COMMENT '显示顺序',
    path VARCHAR(200) COMMENT '路由地址',
    component VARCHAR(200) COMMENT '组件路径',
    perms VARCHAR(100) COMMENT '权限标识',
    menu_type TINYINT DEFAULT 1 COMMENT '菜单类型：0-目录，1-菜单，2-按钮',
    visible TINYINT DEFAULT 1 COMMENT '是否显示：0-隐藏，1-显示',
    status TINYINT DEFAULT 1 COMMENT '状态：0-禁用，1-启用',
    icon VARCHAR(100) COMMENT '菜单图标',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    INDEX idx_parent_id (parent_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='菜单表';

-- =============================================
-- 用户角色关联表
-- =============================================
CREATE TABLE IF NOT EXISTS sys_user_role (
    user_id BIGINT NOT NULL COMMENT '用户ID',
    role_id BIGINT NOT NULL COMMENT '角色ID',
    PRIMARY KEY (user_id, role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户角色关联表';

-- =============================================
-- 角色菜单关联表
-- =============================================
CREATE TABLE IF NOT EXISTS sys_role_menu (
    role_id BIGINT NOT NULL COMMENT '角色ID',
    menu_id BIGINT NOT NULL COMMENT '菜单ID',
    PRIMARY KEY (role_id, menu_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色菜单关联表';

-- =============================================
-- 数据权限表
-- =============================================
CREATE TABLE IF NOT EXISTS sys_data_permission (
    id BIGINT AUTO_INCREMENT PRIMARY KEY COMMENT 'ID',
    role_id BIGINT NOT NULL COMMENT '角色ID',
    scope_type TINYINT DEFAULT 1 COMMENT '权限范围：1-全部，2-自定义，3-本部门，4-本部门及以下，5-仅本人',
    custom_dept_ids VARCHAR(500) COMMENT '自定义部门ID（逗号分隔）',
    create_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    update_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    UNIQUE INDEX idx_role_id (role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='数据权限表';

-- =============================================
-- 初始化数据
-- =============================================

-- 初始化角色
INSERT INTO sys_role (id, role_name, role_key, order_num, status, remark) VALUES
(1, '超级管理员', 'admin', 1, 1, '拥有系统所有权限'),
(2, '普通用户', 'user', 2, 1, '普通用户角色');

-- 初始化用户（密码: 123456，BCrypt加密）
-- 注意：实际密码会在应用启动时由DataInitializer重新加密
INSERT INTO sys_user (id, username, password, nickname, email, phone, status) VALUES
(1, 'admin', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iKtE/ETXmB5nNiHxqHnHfgVd5GK6', '超级管理员', 'admin@example.com', '13800138000', 1),
(2, 'test', '$2a$10$N.zmdr9k7uOCQb376NoUnuTJ8iKtE/ETXmB5nNiHxqHnHfgVd5GK6', '测试用户', 'test@example.com', '13800138001', 1);

-- 用户角色关联
INSERT INTO sys_user_role (user_id, role_id) VALUES
(1, 1),
(2, 2);

-- 初始化菜单
-- 一级菜单：系统管理
INSERT INTO sys_menu (id, menu_name, parent_id, order_num, path, component, perms, menu_type, visible, status, icon) VALUES
(1, '系统管理', 0, 1, '/system', NULL, NULL, 0, 1, 1, 'Setting'),
(2, '用户管理', 1, 1, '/system/user', 'system/User', 'system:user:list', 1, 1, 1, 'User'),
(3, '角色管理', 1, 2, '/system/role', 'system/Role', 'system:role:list', 1, 1, 1, 'Avatar'),
(4, '菜单管理', 1, 3, '/system/menu', 'system/Menu', 'system:menu:list', 1, 1, 1, 'Menu'),
(5, '数据权限', 1, 4, '/system/dataPerm', 'system/DataPermission', 'system:dataPerm:list', 1, 1, 1, 'Lock');

-- 用户管理按钮权限
INSERT INTO sys_menu (id, menu_name, parent_id, order_num, path, component, perms, menu_type, visible, status, icon) VALUES
(21, '用户查询', 2, 1, '', NULL, 'system:user:query', 2, 1, 1, NULL),
(22, '用户新增', 2, 2, '', NULL, 'system:user:add', 2, 1, 1, NULL),
(23, '用户修改', 2, 3, '', NULL, 'system:user:edit', 2, 1, 1, NULL),
(24, '用户删除', 2, 4, '', NULL, 'system:user:delete', 2, 1, 1, NULL),
(25, '重置密码', 2, 5, '', NULL, 'system:user:resetPwd', 2, 1, 1, NULL);

-- 角色管理按钮权限
INSERT INTO sys_menu (id, menu_name, parent_id, order_num, path, component, perms, menu_type, visible, status, icon) VALUES
(31, '角色查询', 3, 1, '', NULL, 'system:role:query', 2, 1, 1, NULL),
(32, '角色新增', 3, 2, '', NULL, 'system:role:add', 2, 1, 1, NULL),
(33, '角色修改', 3, 3, '', NULL, 'system:role:edit', 2, 1, 1, NULL),
(34, '角色删除', 3, 4, '', NULL, 'system:role:delete', 2, 1, 1, NULL);

-- 菜单管理按钮权限
INSERT INTO sys_menu (id, menu_name, parent_id, order_num, path, component, perms, menu_type, visible, status, icon) VALUES
(41, '菜单查询', 4, 1, '', NULL, 'system:menu:query', 2, 1, 1, NULL),
(42, '菜单新增', 4, 2, '', NULL, 'system:menu:add', 2, 1, 1, NULL),
(43, '菜单修改', 4, 3, '', NULL, 'system:menu:edit', 2, 1, 1, NULL),
(44, '菜单删除', 4, 4, '', NULL, 'system:menu:delete', 2, 1, 1, NULL);

-- 数据权限按钮权限
INSERT INTO sys_menu (id, menu_name, parent_id, order_num, path, component, perms, menu_type, visible, status, icon) VALUES
(51, '数据权限查询', 5, 1, '', NULL, 'system:dataPerm:query', 2, 1, 1, NULL),
(52, '数据权限编辑', 5, 2, '', NULL, 'system:dataPerm:edit', 2, 1, 1, NULL),
(53, '数据权限删除', 5, 3, '', NULL, 'system:dataPerm:delete', 2, 1, 1, NULL);

-- 超级管理员角色拥有所有菜单权限
INSERT INTO sys_role_menu (role_id, menu_id) VALUES
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5),
(1, 21), (1, 22), (1, 23), (1, 24), (1, 25),
(1, 31), (1, 32), (1, 33), (1, 34),
(1, 41), (1, 42), (1, 43), (1, 44),
(1, 51), (1, 52), (1, 53);

-- 普通用户只有查看权限
INSERT INTO sys_role_menu (role_id, menu_id) VALUES
(2, 1), (2, 2), (2, 3),
(2, 21), (2, 31);

-- 数据权限初始化
INSERT INTO sys_data_permission (role_id, scope_type, custom_dept_ids) VALUES
(1, 1, NULL),
(2, 5, NULL);
