# 多重权限管理系统

## 项目简介

基于 **Spring Boot + MyBatis-Flex + Vue + JWT + MySQL** 的企业级多重权限管理系统，实现用户、角色、菜单权限、授权、数据权限的精细化管理。

> [!NOTE]
> **技术说明**: 原始需求中的 "mybatis-flux" 为笔误，实际采用的是 **MyBatis-Flex** 技术栈。MyBatis-Flex 是一个优雅的 MyBatis 增强框架，提供了更简洁的 API 和更好的性能。

## 技术栈

### 后端
- **框架**: Spring Boot 2.7.x
- **ORM**: MyBatis-Flex 1.7.x（原需求 mybatis-flux 为笔误）
- **数据库**: MySQL 8.0
- **安全**: Spring Security + JWT
- **连接池**: HikariCP

### 前端
- **框架**: Vue 3
- **构建工具**: Vite
- **UI 组件**: Element Plus
- **路由**: Vue Router

## 快速开始

> [!TIP]
> 使用单个 Dockerfile 一键启动，无需本地安装 Java、Node.js 等环境

### 环境变量配置

| 变量名 | 说明 | 默认值 |
|--------|------|--------|
| `JWT_SECRET` | JWT 签名密钥（**必须设置**，至少32字符） | 无（占位值，启动时校验） |
| `CORS_ALLOWED_ORIGINS` | 允许的跨域来源（逗号分隔） | `http://localhost:3000` |

> [!IMPORTANT]
> 生产部署前 **必须** 通过环境变量设置 `JWT_SECRET`，否则后端将拒绝启动。
> 可在项目根目录创建 `.env` 文件供容器启动时读取：
> ```env
> JWT_SECRET=YourSuperSecretKeyAtLeast32Characters!!
> CORS_ALLOWED_ORIGINS=https://your-domain.com
> ```

### Docker 部署（推荐）

```bash
# 构建镜像
docker build -t permission-system-530 .

# 启动容器
docker run --rm -p 3000:80 -p 3001:8000 --name permission-system-530 permission-system-530
```

### 服务访问

| 服务 | 地址 | 说明 |
|------|------|------|
| 前端 | http://localhost:3000 | Vue 3 + Nginx |
| 后端 | http://localhost:3001 | Spring Boot API |

### 测试账号

| 用户名 | 密码 | 角色 |
|--------|------|------|
| admin | 123456 | 超级管理员 |
| test | 123456 | 普通用户 |

## 功能模块

- ✅ **用户管理** - 用户增删改查、状态切换、密码重置
- ✅ **角色管理** - 角色配置、权限分配
- ✅ **菜单权限** - 菜单树维护、权限标识配置
- ✅ **授权管理** - 基于 RBAC 的权限控制
- ✅ **数据权限** - 基于角色的数据访问控制
- ✅ **JWT 认证** - 无状态 Token 认证机制

## 项目结构

```
├── backend/          # 后端 Spring Boot 项目
│   ├── src/main/java/com/example/permission/
│   │   ├── config/      # 配置类
│   │   ├── controller/  # 控制器
│   │   ├── entity/      # 实体类 (含 TableDef)
│   │   ├── mapper/      # MyBatis-Flex Mapper
│   │   ├── service/     # 服务层
│   │   ├── security/    # JWT 安全配置
│   │   └── common/      # 公共类
│   └── pom.xml
├── frontend/         # 前端 Vue 3 项目
│   ├── src/
│   │   ├── views/       # 页面组件
│   │   ├── router/      # 路由配置
│   │   └── stores/      # 状态管理
│   └── package.json
├── db/               # 数据库脚本
│   └── init.sql      # 初始化脚本
└── Dockerfile        # 单文件启动入口
```

## 常用命令

```bash
# 构建并启动
docker build -t permission-system-530 .
docker run --rm -p 3000:80 --name permission-system-530 permission-system-530
```

## 本地开发

### 环境要求
- JDK 17+
- Node.js 18+
- MySQL 8.0+

### 后端启动
```bash
cd backend
mvn spring-boot:run
```

### 前端启动
```bash
cd frontend
npm install
npm run dev
```

## 许可证

MIT License
