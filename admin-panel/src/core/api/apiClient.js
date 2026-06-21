export const apiClient = {
  baseURL: import.meta.env.VITE_API_BASE_URL || 'http://127.0.0.1:8000',
  token: localStorage.getItem('admin_token'),
  setToken(token) {
    this.token = token
    if (token) localStorage.setItem('admin_token', token)
    else localStorage.removeItem('admin_token')
  },
  fileURL(path) {
    if (!path) return ''
    if (path.startsWith('http')) return path
    return `${this.baseURL}${path}`
  },
  async request(endpoint, options = {}) {
    const { payload, headers, ...rest } = options
    const isFormData = payload instanceof FormData
    const response = await fetch(`${this.baseURL}${endpoint}`, {
      ...rest,
      headers: {
        ...(isFormData ? {} : { 'Content-Type': 'application/json' }),
        ...(this.token ? { Authorization: `Bearer ${this.token}` } : {}),
        ...headers,
      },
      body: payload ? (isFormData ? payload : JSON.stringify(payload)) : undefined,
    })

    const contentType = response.headers.get('content-type') || ''
    const data = contentType.includes('application/json') ? await response.json() : await response.text()

    if (!response.ok) {
      const message = typeof data === 'string' ? data : data.detail || data.message || 'Request failed'
      throw new Error(message)
    }

    return data
  },
}
