<template>
  <div class="dashboard-container">
    <el-row :gutter="20">
      <!-- 欢迎卡片 -->
      <el-col :span="24">
        <el-card class="welcome-card">
          <div class="welcome-content">
            <div class="welcome-text">
              <h2>欢迎回来，{{ userStore.user?.nickname || '用户' }}！</h2>
              <p>今天是 {{ currentDate }}，祝您工作愉快！</p>
            </div>
            <div class="welcome-avatar">
              <el-avatar :size="80" :src="userStore.user?.avatar">
                {{ userStore.user?.nickname?.charAt(0) || 'U' }}
              </el-avatar>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
    
    <el-row :gutter="20" class="stat-row">
      <!-- 统计卡片 -->
      <el-col :xs="12" :sm="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%)">
              <el-icon :size="28"><User /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.userCount }}</div>
              <div class="stat-label">用户总数</div>
            </div>
          </div>
        </el-card>
      </el-col>
      
      <el-col :xs="12" :sm="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%)">
              <el-icon :size="28"><Avatar /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.roleCount }}</div>
              <div class="stat-label">角色总数</div>
            </div>
          </div>
        </el-card>
      </el-col>
      
      <el-col :xs="12" :sm="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)">
              <el-icon :size="28"><Menu /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.menuCount }}</div>
              <div class="stat-label">菜单总数</div>
            </div>
          </div>
        </el-card>
      </el-col>
      
      <el-col :xs="12" :sm="6">
        <el-card class="stat-card" shadow="hover">
          <div class="stat-content">
            <div class="stat-icon" style="background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)">
              <el-icon :size="28"><Lock /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.permCount }}</div>
              <div class="stat-label">权限数量</div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
    
    <el-row :gutter="20">
      <!-- 快捷入口 -->
      <el-col :span="24">
        <el-card class="quick-access-card">
          <template #header>
            <span>快捷入口</span>
          </template>
          <div class="quick-access-grid">
            <div class="quick-item" @click="$router.push('/system/user')" v-if="hasPermission('system:user:list')">
              <el-icon :size="32" color="#667eea"><User /></el-icon>
              <span>用户管理</span>
            </div>
            <div class="quick-item" @click="$router.push('/system/role')" v-if="hasPermission('system:role:list')">
              <el-icon :size="32" color="#f5576c"><Avatar /></el-icon>
              <span>角色管理</span>
            </div>
            <div class="quick-item" @click="$router.push('/system/menu')" v-if="hasPermission('system:menu:list')">
              <el-icon :size="32" color="#4facfe"><Menu /></el-icon>
              <span>菜单管理</span>
            </div>
            <div class="quick-item" @click="$router.push('/profile')">
              <el-icon :size="32" color="#43e97b"><Setting /></el-icon>
              <span>个人中心</span>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useUserStore } from '@/stores/user'
import { User, Avatar, Menu, Lock, Setting } from '@element-plus/icons-vue'

const userStore = useUserStore()

const stats = ref({
  userCount: 0,
  roleCount: 0,
  menuCount: 0,
  permCount: 0
})

const currentDate = computed(() => {
  const date = new Date()
  const options = { year: 'numeric', month: 'long', day: 'numeric', weekday: 'long' }
  return date.toLocaleDateString('zh-CN', options)
})

const hasPermission = (permission) => {
  return userStore.hasPermission(permission)
}

onMounted(() => {
  // 模拟加载统计数据
  stats.value = {
    userCount: 12,
    roleCount: 5,
    menuCount: 18,
    permCount: 36
  }
})
</script>

<style scoped>
.dashboard-container {
  padding: 10px;
}

.welcome-card {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: #fff;
  border: none;
  border-radius: 12px;
  margin-bottom: 20px;
}

.welcome-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px;
}

.welcome-text h2 {
  margin: 0 0 10px 0;
  font-size: 24px;
}

.welcome-text p {
  margin: 0;
  opacity: 0.9;
}

.stat-row {
  margin-bottom: 20px;
}

.stat-card {
  border-radius: 12px;
  border: none;
  transition: transform 0.3s;
}

.stat-card:hover {
  transform: translateY(-5px);
}

.stat-content {
  display: flex;
  align-items: center;
  gap: 15px;
  padding: 10px;
}

.stat-icon {
  width: 60px;
  height: 60px;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: #fff;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 28px;
  font-weight: 700;
  color: #2d3748;
}

.stat-label {
  font-size: 14px;
  color: #718096;
}

.quick-access-card {
  border-radius: 12px;
  border: none;
}

.quick-access-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(120px, 1fr));
  gap: 20px;
}

.quick-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 10px;
  padding: 20px;
  background: #f7fafc;
  border-radius: 12px;
  cursor: pointer;
  transition: all 0.3s;
}

.quick-item:hover {
  background: #edf2f7;
  transform: translateY(-3px);
}

.quick-item span {
  font-size: 14px;
  color: #4a5568;
}
</style>
