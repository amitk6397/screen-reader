import { apiClient } from '../api/apiClient'
import { seedData } from './mockData'

const unwrapList = (response) => response?.data || response || []

export const authRepository = {
  login: async (payload) => {
    const response = await apiClient.request('/admin/auth/login', { method: 'POST', payload })
    if (response?.data?.token) apiClient.setToken(response.data.token)
    return response
  },
  forgotCredentials: async (payload) => apiClient.request('/admin/auth/forgot-credentials', { method: 'POST', payload }),
  logout: async () => {
    apiClient.setToken(null)
    return { success: true }
  },
}

export const userRepository = {
  list: async () => apiClient.request('/admin/users'),
  details: async (id) => ({ success: true, data: seedData.users.find((user) => user.id === Number(id)) }),
  toggleStatus: async (id) => apiClient.request(`/admin/users/block-unblock/${id}`, { method: 'PUT' }),
  delete: async (id) => apiClient.request(`/admin/users/${id}`, { method: 'DELETE' }),
}

export const bookRepository = {
  list: async () => apiClient.request('/admin/books'),
  /** Create new book — always multipart (PDF + image required) */
  save: async (payload) => apiClient.request('/admin/books', { method: 'POST', payload }),
  /** Update book — accepts FormData (with optional new files) or plain object */
  update: async (id, payload) => {
    if (payload instanceof FormData) {
      return apiClient.request(`/admin/books/${id}`, { method: 'PUT', payload })
    }
    return apiClient.request(`/admin/books/${id}`, { method: 'PUT', payload })
  },
  delete: async (id) => apiClient.request(`/admin/books/${id}`, { method: 'DELETE' }),
  normalize: unwrapList,
}

export const onboardingRepository = {
  list: async () => apiClient.request('/admin/onboarding'),
  /** Create — multipart if FormData, JSON otherwise */
  save: async (payload) => apiClient.request('/admin/onboarding', { method: 'POST', payload }),
  /** Update — multipart if FormData, JSON otherwise */
  update: async (id, payload) => apiClient.request(`/admin/onboarding/${id}`, { method: 'PUT', payload }),
  delete: async (id) => apiClient.request(`/admin/onboarding/${id}`, { method: 'DELETE' }),
}

export const policyRepository = {
  list: async () => apiClient.request('/admin/policy'),
  save: async (payload) => apiClient.request('/admin/policy', { method: 'POST', payload }),
  update: async (id, payload) => apiClient.request(`/admin/policy/${id}`, { method: 'PUT', payload }),
  delete: async (id) => apiClient.request(`/admin/policy/${id}`, { method: 'DELETE' }),
}
