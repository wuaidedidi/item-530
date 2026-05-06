import axios from 'axios'
import { ElMessage, ElMessageBox } from 'element-plus'

// 创建axios实例
const request = axios.create({
  baseURL: '/api',
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json'
  }
})

// 请求拦截器
request.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token')
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => {
    return Promise.reject(error)
  }
)

// 响应拦截器
request.interceptors.response.use(
  (response) => {
    return response.data
  },
  (error) => {
    let message = '请求失败'
    
    if (error.response) {
      const { status, data } = error.response
      
      switch (status) {
        case 401:
          message = '登录已过期，请重新登录'
          localStorage.removeItem('token')
          ElMessageBox.confirm(message, '提示', {
            confirmButtonText: '重新登录',
            cancelButtonText: '取消',
            type: 'warning'
          }).then(() => {
            window.location.href = '/login'
          }).catch(() => {})
          break
        case 403:
          message = '没有权限访问该资源'
          break
        case 404:
          message = '请求的资源不存在'
          break
        case 500:
          message = data?.message || '服务器内部错误'
          break
        default:
          message = data?.message || `请求失败: ${status}`
      }
    } else if (error.request) {
      message = '网络连接失败，请检查网络'
    }
    
    ElMessage.error(message)
    return Promise.reject(error)
  }
)

// API模块
const api = {
  // 认证相关
  auth: {
    login: (data) => request.post('/auth/login', data),
    register: (data) => request.post('/auth/register', data),
    getUserInfo: () => request.get('/auth/info'),
    logout: () => request.post('/auth/logout')
  },
  
  // 用户管理
  user: {
    list: (params) => request.get('/system/user/list', { params }),
    getById: (id) => request.get(`/system/user/${id}`),
    add: (data) => request.post('/system/user', data),
    update: (data) => request.put('/system/user', data),
    delete: (id) => request.delete(`/system/user/${id}`),
    updateStatus: (data) => request.put('/system/user/status', data),
    resetPassword: (data) => request.put('/system/user/resetPwd', data),
    changePassword: (data) => request.put('/system/user/profile/password', data),
    updateProfile: (data) => request.put('/system/user/profile', data)
  },
  
  // 角色管理
  role: {
    list: (params) => request.get('/system/role/list', { params }),
    listAll: () => request.get('/system/role/listAll'),
    getById: (id) => request.get(`/system/role/${id}`),
    add: (data) => request.post('/system/role', data),
    update: (data) => request.put('/system/role', data),
    delete: (id) => request.delete(`/system/role/${id}`),
    updateStatus: (data) => request.put('/system/role/status', data)
  },
  
  // 菜单管理
  menu: {
    tree: () => request.get('/system/menu/tree'),
    list: () => request.get('/system/menu/list'),
    selectTree: () => request.get('/system/menu/selectTree'),
    getById: (id) => request.get(`/system/menu/${id}`),
    add: (data) => request.post('/system/menu', data),
    update: (data) => request.put('/system/menu', data),
    delete: (id) => request.delete(`/system/menu/${id}`)
  },
  
  // 数据权限
  dataPerm: {
    list: (params) => request.get('/system/dataPermission/list', { params }),
    listAll: () => request.get('/system/dataPermission/all'),
    getByRoleId: (roleId) => request.get(`/system/dataPermission/role/${roleId}`),
    save: (data) => request.post('/system/dataPermission', data),
    deleteByRoleId: (roleId) => request.delete(`/system/dataPermission/role/${roleId}`),
    getScopeTypes: () => request.get('/system/dataPermission/scopeTypes')
  }
}

export default api
