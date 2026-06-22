import { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import './App.css'
import { apiClient } from './core/api/apiClient'
import {
  authRepository,
  bookRepository,
  onboardingRepository,
  policyRepository,
  userRepository,
} from './core/services/repositories'
import { seedData } from './core/services/mockData'

/* ─────────────────────────────────────────────────────────── Routes */
const routes = {
  login: '/login',
  dashboard: '/dashboard',
  users: '/users',
  books: '/books',
  addBook: '/books/add',
  onboarding: '/onboarding',
  addOnboarding: '/onboarding/add',
  policies: '/policies',
  addPolicy: '/policies/add',
  settings: '/settings',
}

const breadcrumbs = {
  '/dashboard': ['Admin', 'Dashboard'],
  '/users': ['Admin', 'Users'],
  '/books': ['Admin', 'Books'],
  '/books/add': ['Admin', 'Books', 'Add New'],
  '/books/edit': ['Admin', 'Books', 'Edit'],
  '/books/view': ['Admin', 'Books', 'Details'],
  '/onboarding': ['Admin', 'Onboarding'],
  '/onboarding/add': ['Admin', 'Onboarding', 'Add New'],
  '/onboarding/edit': ['Admin', 'Onboarding', 'Edit'],
  '/policies': ['Admin', 'Policies'],
  '/policies/add': ['Admin', 'Policies', 'Add New'],
  '/policies/edit': ['Admin', 'Policies', 'Edit'],
  '/policies/view': ['Admin', 'Policies', 'Details'],
  '/settings': ['Admin', 'Settings'],
}

const emptyBook = { title: '', author: '', description: '', category: '', language: '', is_active: true, isWeek: false }
const emptyOnboarding = { title: '', description: '', image_url: '', sort_order: 0, is_active: true }
const emptyPolicy = { title: '', description: '', is_active: true, policy_type: 'privacy_policy' }

/* ─────────────────────────────────────────────────────────── SVG Icons */
const Svg = ({ children, ...rest }) => (
  <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" {...rest}>{children}</svg>
)

const Icon = {
  dashboard: <Svg><rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/></Svg>,
  users: <Svg><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M23 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></Svg>,
  books: <Svg><path d="M4 19.5A2.5 2.5 0 0 1 6.5 17H20"/><path d="M6.5 2H20v20H6.5A2.5 2.5 0 0 1 4 19.5v-15A2.5 2.5 0 0 1 6.5 2z"/></Svg>,
  onboarding: <Svg><rect x="5" y="2" width="14" height="20" rx="2"/><line x1="9" y1="7" x2="15" y2="7"/><line x1="9" y1="11" x2="15" y2="11"/><line x1="9" y1="15" x2="13" y2="15"/></Svg>,
  policy: <Svg><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/></Svg>,
  settings: <Svg><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83-2.83l.06-.06A1.65 1.65 0 0 0 4.68 15a1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 2.83-2.83l.06.06A1.65 1.65 0 0 0 9 4.68a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 2.83l-.06.06A1.65 1.65 0 0 0 19.4 9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1z"/></Svg>,
  logout: <Svg><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></Svg>,
  sun: <Svg><circle cx="12" cy="12" r="5"/><line x1="12" y1="1" x2="12" y2="3"/><line x1="12" y1="21" x2="12" y2="23"/><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"/><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"/><line x1="1" y1="12" x2="3" y2="12"/><line x1="21" y1="12" x2="23" y2="12"/><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"/><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"/></Svg>,
  moon: <Svg><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"/></Svg>,
  menu: <Svg><line x1="3" y1="6" x2="21" y2="6"/><line x1="3" y1="12" x2="21" y2="12"/><line x1="3" y1="18" x2="21" y2="18"/></Svg>,
  plus: <Svg><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></Svg>,
  refresh: <Svg><polyline points="23 4 23 10 17 10"/><polyline points="1 20 1 14 7 14"/><path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"/></Svg>,
  search: <Svg><circle cx="11" cy="11" r="8"/><line x1="21" y1="21" x2="16.65" y2="16.65"/></Svg>,
  bell: <Svg><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/></Svg>,
  upload: <Svg><polyline points="16 16 12 12 8 16"/><line x1="12" y1="12" x2="12" y2="21"/><path d="M20.39 18.39A5 5 0 0 0 18 9h-1.26A8 8 0 1 0 3 16.3"/></Svg>,
  pdf: <Svg><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/></Svg>,
  image: <Svg><rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></Svg>,
  check: <Svg><polyline points="20 6 9 17 4 12"/></Svg>,
  xmark: <Svg><line x1="18" y1="6" x2="6" y2="18"/><line x1="6" y1="6" x2="18" y2="18"/></Svg>,
  trash: <Svg><polyline points="3 6 5 6 21 6"/><path d="M19 6l-1 14a2 2 0 0 1-2 2H8a2 2 0 0 1-2-2L5 6"/><path d="M10 11v6"/><path d="M14 11v6"/><path d="M9 6V4h6v2"/></Svg>,
  alert: <Svg><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></Svg>,
  info: <Svg><circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/></Svg>,
}

const navItems = [
  { label: 'Dashboard', path: routes.dashboard, icon: Icon.dashboard },
  { label: 'Users', path: routes.users, icon: Icon.users, badge: null },
  { label: 'Books', path: routes.books, icon: Icon.books },
  { label: 'Onboarding', path: routes.onboarding, icon: Icon.onboarding },
  { label: 'Policies', path: routes.policies, icon: Icon.policy },
  { label: 'Settings', path: routes.settings, icon: Icon.settings },
]

/* ─────────────────────────────────────────────────────────── Toast Manager */
let _addToast = null
export function toast(message, type = 'info') {
  _addToast?.({ id: Date.now(), message, type })
}

function ToastContainer() {
  const [toasts, setToasts] = useState([])
  useEffect(() => {
    _addToast = (t) => setToasts((prev) => [...prev, t])
    return () => { _addToast = null }
  }, [])

  const remove = useCallback((id) => {
    setToasts((prev) => prev.filter((t) => t.id !== id))
  }, [])

  useEffect(() => {
    toasts.forEach((t) => {
      const timer = setTimeout(() => remove(t.id), 3800)
      return () => clearTimeout(timer)
    })
  }, [toasts, remove])

  const typeIcon = { success: Icon.check, error: Icon.xmark, warning: Icon.alert, info: Icon.info }

  return (
    <div className="toast-container">
      {toasts.map((t) => (
        <div key={t.id} className={`toast ${t.type}`}>
          <span className="toast-icon">{typeIcon[t.type] || Icon.info}</span>
          <span className="toast-message">{t.message}</span>
          <button className="toast-close" onClick={() => remove(t.id)}>{Icon.xmark}</button>
        </div>
      ))}
    </div>
  )
}

/* ─────────────────────────────────────────────────────────── Confirm Dialog */
function ConfirmDialog({ message, onConfirm, onCancel }) {
  return (
    <div className="dialog-overlay" onClick={onCancel}>
      <div className="dialog" onClick={(e) => e.stopPropagation()}>
        <div className="dialog-header">
          <div className="dialog-icon danger">{Icon.trash}</div>
          <div>
            <div className="dialog-title">Confirm Delete</div>
            <div className="dialog-body">{message}</div>
          </div>
        </div>
        <div className="dialog-footer">
          <button className="btn-secondary" onClick={onCancel}>Cancel</button>
          <button className="btn-danger" onClick={onConfirm}>Delete</button>
        </div>
      </div>
    </div>
  )
}

/* ─────────────────────────────────────────────────────────── App Root */
function App() {
  const hasStoredToken = Boolean(apiClient.token)
  const [isLoggedIn, setIsLoggedIn] = useState(hasStoredToken)
  const [path, setPath] = useState(hasStoredToken ? routes.dashboard : routes.login)
  const [darkMode, setDarkMode] = useState(() => localStorage.getItem('admin_dark') === '1')
  const [collapsed, setCollapsed] = useState(false)
  const [sidebarOpen, setSidebarOpen] = useState(false)
  const [data, setData] = useState(seedData)
  const [query, setQuery] = useState('')
  const [selected, setSelected] = useState(null)
  const [loading, setLoading] = useState(false)
  const [admin, setAdmin] = useState({ id: 1, name: 'Admin', email: 'admin@gmail.com', is_superuser: true, is_active: true })
  const [confirmDialog, setConfirmDialog] = useState(null)

  useEffect(() => {
    localStorage.setItem('admin_dark', darkMode ? '1' : '0')
  }, [darkMode])

  const loadData = useCallback(async () => {
    setLoading(true)
    try {
      const [users, books, onboarding, policies] = await Promise.all([
        userRepository.list(),
        bookRepository.list(),
        onboardingRepository.list(),
        policyRepository.list(),
      ])
      setData((prev) => ({
        ...prev,
        users: users.data || [],
        books: books.data || [],
        onboarding: onboarding.data || [],
        policies: Array.isArray(policies) ? policies : policies.data || [],
      }))
    } catch (error) {
      toast(error.message || 'Failed to load data', 'error')
    } finally {
      setLoading(false)
    }
  }, [])

  useEffect(() => {
    if (!isLoggedIn) return
    const timer = window.setTimeout(loadData, 0)
    return () => window.clearTimeout(timer)
  }, [isLoggedIn, loadData])

  const navigate = useCallback((nextPath, item = null) => {
    setQuery('')
    setSelected(item)
    setPath(nextPath)
    window.scrollTo(0, 0)
  }, [])

  const handleLogout = async () => {
    await authRepository.logout()
    setIsLoggedIn(false)
    setPath(routes.login)
    toast('Logged out successfully', 'info')
  }

  const confirmDelete = (message, onConfirm) => {
    setConfirmDialog({ message, onConfirm })
  }

  const shellProps = { path, query, setQuery, data, setData, selected, navigate, loadData, confirmDelete }

  if (!isLoggedIn || path === routes.login) {
    return (
      <>
        <ToastContainer />
        <LoginPage darkMode={darkMode} setDarkMode={setDarkMode} setAdmin={setAdmin} onLogin={() => { setIsLoggedIn(true); navigate(routes.dashboard) }} />
      </>
    )
  }

  const crumbKey =
    path.startsWith('/books/edit') ? '/books/edit' :
    path.startsWith('/books/view') ? '/books/view' :
    path.startsWith('/onboarding/edit') ? '/onboarding/edit' :
    path.startsWith('/policies/edit') ? '/policies/edit' :
    path.startsWith('/policies/view') ? '/policies/view' : path

  return (
    <div className={darkMode ? 'app dark' : 'app'}>
      <ToastContainer />
      {confirmDialog && (
        <ConfirmDialog
          message={confirmDialog.message}
          onConfirm={() => { confirmDialog.onConfirm(); setConfirmDialog(null) }}
          onCancel={() => setConfirmDialog(null)}
        />
      )}
      {/* Mobile overlay backdrop */}
      {sidebarOpen && <div className="sidebar-overlay" onClick={() => setSidebarOpen(false)} />}
      <Sidebar collapsed={collapsed} sidebarOpen={sidebarOpen} setSidebarOpen={setSidebarOpen} navItems={navItems} path={path} navigate={(p) => { navigate(p); setSidebarOpen(false) }} data={data} />
      <div className="workspace">
        <Topbar admin={admin} breadcrumbs={breadcrumbs[crumbKey] || ['Admin']} collapsed={collapsed} setCollapsed={setCollapsed} sidebarOpen={sidebarOpen} setSidebarOpen={setSidebarOpen} darkMode={darkMode} setDarkMode={setDarkMode} onLogout={handleLogout} loading={loading} onRefresh={loadData} />
        <main className="page">
          {renderRoute(path, shellProps)}
        </main>
      </div>
    </div>
  )
}

function renderRoute(path, props) {
  if (path === routes.dashboard) return <DashboardPage {...props} />
  if (path === routes.users) return <UsersPage {...props} />
  if (path === routes.books) return <BooksPage {...props} />
  if (path === routes.addBook || path.startsWith('/books/edit')) return <BookFormPage {...props} />
  if (path.startsWith('/books/view')) return <BookDetailsPage {...props} />
  if (path === routes.onboarding) return <OnboardingPage {...props} />
  if (path === routes.addOnboarding || path.startsWith('/onboarding/edit')) return <OnboardingFormPage {...props} />
  if (path === routes.policies) return <PoliciesPage {...props} />
  if (path === routes.addPolicy || path.startsWith('/policies/edit')) return <PolicyFormPage {...props} />
  if (path.startsWith('/policies/view')) return <PolicyDetailsPage {...props} />
  if (path === routes.settings) return <SettingsPage />
  return <DashboardPage {...props} />
}

/* ─────────────────────────────────────────────────────────── Login */
function LoginPage({ darkMode, setDarkMode, onLogin, setAdmin }) {
  const [email, setEmail] = useState('admin@gmail.com')
  const [password, setPassword] = useState('745497')
  const [error, setError] = useState('')
  const [hint, setHint] = useState('')
  const [busy, setBusy] = useState(false)

  const submit = async (event) => {
    event.preventDefault()
    setBusy(true)
    setError('')
    setHint('')
    try {
      const response = await authRepository.login({ email, password })
      if (!response.success) throw new Error(response.message || 'Login failed')
      setAdmin(response.data || { name: 'Admin', email })
      toast('Welcome back, Admin!', 'success')
      onLogin()
    } catch (loginError) {
      setError(loginError.message)
    } finally {
      setBusy(false)
    }
  }

  const forgotCredentials = async () => {
    setBusy(true)
    setError('')
    setHint('')
    try {
      const response = await authRepository.forgotCredentials({ email })
      if (!response.success) throw new Error(response.message || 'Credentials not found')
      setEmail(response.data.email)
      setPassword(response.data.password)
      setHint(`Email: ${response.data.email} | Password: ${response.data.password}`)
    } catch (forgotError) {
      setError(forgotError.message)
    } finally {
      setBusy(false)
    }
  }

  return (
    <div className={`login-page ${darkMode ? 'app dark' : ''}`}>
      <button className="theme-toggle" type="button" onClick={() => setDarkMode(!darkMode)}>
        {darkMode ? Icon.sun : Icon.moon} {darkMode ? ' Light Mode' : ' Dark Mode'}
      </button>
      <div className="login-panel">
        <div className="login-logo">
          <img src="/app-icon.png" alt="Screen Reader" />
        </div>
        <p className="login-eyebrow">Screen Reader Admin</p>
        <h1 className="login-title">Welcome back</h1>
        <p className="login-subtitle">Manage users, books, onboarding and policies from your backend.</p>
        <form className="login-form" onSubmit={submit}>
          <div className="login-field">
            <label className="login-label" htmlFor="login-email">Email Address</label>
            <input id="login-email" className="login-input" type="email" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="admin@example.com" />
          </div>
          <div className="login-field">
            <label className="login-label" htmlFor="login-password">Password</label>
            <input id="login-password" className="login-input" type="password" value={password} onChange={(e) => setPassword(e.target.value)} placeholder="••••••••" />
          </div>
          {error && <div className="login-error">{error}</div>}
          {hint && <div className="login-hint">{hint}</div>}
          <div className="login-actions">
            <span />
            <button className="login-forgot" type="button" onClick={forgotCredentials} disabled={busy}>Forgot credentials?</button>
          </div>
          <button className="login-submit" disabled={busy}>{busy ? 'Signing in…' : 'Sign In'}</button>
        </form>
        <div className="login-api-info">🔗 API: http://127.0.0.1:8000</div>
      </div>
    </div>
  )
}

/* ─────────────────────────────────────────────────────────── Sidebar */
function Sidebar({ collapsed, sidebarOpen, navItems, path, navigate, data }) {
  const userCount = (data.users || []).filter((u) => !u.is_active).length

  return (
    <aside className={`sidebar${collapsed ? ' collapsed' : ''}${sidebarOpen ? ' mobile-open' : ''}`}>
      <div className="brand">
        <div className="brand-logo">
          <img src="/app-icon.png" alt="Screen Reader" />
        </div>
        <span className="brand-name">ScreenAdmin</span>
      </div>

      <nav>
        {navItems.map((item) => {
          const base = '/' + item.path.split('/')[1]
          const active = path === item.path || (item.path !== routes.dashboard && path.startsWith(base))
          const badge = item.label === 'Users' && userCount > 0 ? userCount : null
          return (
            <button
              key={item.path}
              className={`sidebar-btn ${active ? 'active' : ''}`}
              onClick={() => navigate(item.path)}
              title={item.label}
            >
              <span className="sidebar-icon">{item.icon}</span>
              <span className="sidebar-label">{item.label}</span>
              {badge && <span className="sidebar-badge">{badge}</span>}
            </button>
          )
        })}
      </nav>

      <div className="sidebar-footer">
        <div style={{ fontSize: 11, color: 'var(--sidebar-muted)', textAlign: 'center', whiteSpace: 'nowrap', overflow: 'hidden' }}>
          {collapsed ? '●' : '● Live API Connected'}
        </div>
      </div>
    </aside>
  )
}

/* ─────────────────────────────────────────────────────────── Topbar */
function Topbar({ admin, breadcrumbs, collapsed, setCollapsed, sidebarOpen, setSidebarOpen, darkMode, setDarkMode, onLogout, loading, onRefresh }) {
  return (
    <header className="topbar">
      <div className="top-left">
        <button className="topbar-toggle desktop-only" onClick={() => setCollapsed(!collapsed)} title="Toggle sidebar">
          {Icon.menu}
        </button>
        <button className="topbar-toggle mobile-only" onClick={() => setSidebarOpen(!sidebarOpen)} title="Open menu">
          {Icon.menu}
        </button>
        <nav className="breadcrumb" aria-label="breadcrumb">
          {breadcrumbs.map((crumb, idx) => (
            <span key={idx}>
              {idx > 0 && <span className="breadcrumb-sep"> / </span>}
              {idx === breadcrumbs.length - 1 ? <strong>{crumb}</strong> : <span>{crumb}</span>}
            </span>
          ))}
        </nav>
        {loading && (
          <div className="sync-indicator">
            <span className="sync-dot" />
            Syncing
          </div>
        )}
      </div>
      <div className="top-actions">
        <button className="icon-btn" onClick={onRefresh} title="Refresh data">{Icon.refresh}</button>
        <button className="icon-btn" title="Notifications">{Icon.bell}</button>
        <button className="icon-btn" onClick={() => setDarkMode(!darkMode)} title="Toggle theme">
          {darkMode ? Icon.sun : Icon.moon}
        </button>
        <div className="topbar-profile">
          <div className="profile-avatar">{admin.name?.[0]?.toUpperCase() || 'A'}</div>
          <div className="profile-info">
            <div className="profile-name">{admin.name}</div>
            <div className="profile-role">Administrator</div>
          </div>
        </div>
        <button className="logout-btn" onClick={onLogout}>{Icon.logout}</button>
      </div>
    </header>
  )
}

/* ─────────────────────────────────────────────────────────── Dashboard */
function DashboardPage({ data, navigate }) {
  const cards = [
    { label: 'Total Users', value: data.users.length, tone: 'users', trend: '+12%' },
    { label: 'Active Users', value: data.users.filter((u) => u.is_active).length, tone: 'active', trend: '+8%' },
    { label: 'Blocked Users', value: data.users.filter((u) => !u.is_active).length, tone: 'blocked', trend: null },
    { label: 'Total Books', value: data.books.length, tone: 'books', trend: '+5%' },
    { label: 'Active Books', value: data.books.filter((b) => b.is_active).length, tone: 'library', trend: null },
    { label: 'Featured Books', value: data.books.filter((b) => b.isWeek).length, tone: 'featured', trend: null },
    { label: 'Policies', value: data.policies.length, tone: 'policy', trend: null },
    { label: 'Onboarding', value: data.onboarding.length, tone: 'flow', trend: null },
  ]

  const statIcons = {
    users: Icon.users, active: Icon.check, blocked: Icon.xmark, books: Icon.books,
    library: Icon.books, featured: Icon.bell, policy: Icon.policy, flow: Icon.onboarding,
  }

  const activities = [
    { text: 'New user registered — review pending', time: '2 min ago', color: 'var(--success)' },
    { text: 'Book "Atomic Habits" featured this week', time: '15 min ago', color: 'var(--gold)' },
    { text: 'Policy updated: Terms of Service v2.1', time: '1 hr ago', color: 'var(--primary)' },
    { text: 'Onboarding slide #3 activated', time: '3 hrs ago', color: 'var(--teal)' },
    { text: 'User blocked: repeated violations', time: '5 hrs ago', color: 'var(--danger)' },
  ]

  return (
    <>
      <div className="page-header">
        <div>
          <h1>Dashboard</h1>
          <p>Live overview from your Screen Reader backend API.</p>
        </div>
        <div className="header-actions">
          <button className="btn-secondary" onClick={() => navigate(routes.addBook)}>
            {Icon.plus} Add Book
          </button>
          <button className="btn-primary" onClick={() => navigate(routes.users)}>
            {Icon.users} View Users
          </button>
        </div>
      </div>

      {/* Stats Grid */}
      <section className="stats-grid">
        {cards.map(({ label, value, tone, trend }) => (
          <article key={label} className={`stat-card ${tone}`}>
            <div className={`stat-icon-bg`}>{statIcons[tone]}</div>
            <div className="stat-value">{value}</div>
            <div className="stat-label">{label}</div>
            {trend && <span className="stat-trend up">↑ {trend}</span>}
            <div className="stat-glow" />
          </article>
        ))}
      </section>

      {/* Charts & Activity */}
      <section className="content-grid">
        <div className="card">
          <div className="card-header">
            <div>
              <div className="card-title">User Statistics</div>
              <div className="card-subtitle">Total / Active / Blocked comparison</div>
            </div>
          </div>
          <div className="card-body">
            <BarChart
              groups={[
                { label: 'Total', value: data.users.length },
                { label: 'Active', value: data.users.filter((u) => u.is_active).length },
                { label: 'Blocked', value: data.users.filter((u) => !u.is_active).length },
                { label: 'Today', value: Math.floor(Math.random() * 6) + 2 },
                { label: 'Week', value: Math.floor(Math.random() * 12) + 5 },
                { label: 'Month', value: Math.floor(Math.random() * 30) + 12 },
              ]}
            />
          </div>
        </div>

        <div className="card">
          <div className="card-header">
            <div>
              <div className="card-title">Book Library Stats</div>
              <div className="card-subtitle">Total / Active / Featured overview</div>
            </div>
          </div>
          <div className="card-body">
            <BarChart
              tone="green"
              groups={[
                { label: 'Total', value: data.books.length },
                { label: 'Active', value: data.books.filter((b) => b.is_active).length },
                { label: 'Week', value: data.books.filter((b) => b.isWeek).length },
                { label: 'New', value: Math.floor(Math.random() * 8) + 1 },
                { label: 'Views', value: Math.floor(Math.random() * 20) + 5 },
                { label: 'Reads', value: Math.floor(Math.random() * 15) + 3 },
              ]}
            />
          </div>
        </div>

        <div className="card">
          <div className="card-header">
            <div>
              <div className="card-title">Monthly Activity</div>
              <div className="card-subtitle">User engagement over 6 months</div>
            </div>
          </div>
          <div className="card-body">
            <LineChart />
          </div>
        </div>

        <div className="card">
          <div className="card-header">
            <div className="card-title">Quick Actions</div>
          </div>
          <div className="card-body">
            <div className="quick-actions">
              <button className="quick-action-btn" onClick={() => navigate(routes.addBook)}>{Icon.plus} Add Book</button>
              <button className="quick-action-btn" onClick={() => navigate(routes.addOnboarding)}>{Icon.plus} Onboarding</button>
              <button className="quick-action-btn" onClick={() => navigate(routes.addPolicy)}>{Icon.policy} Add Policy</button>
              <button className="quick-action-btn" onClick={() => navigate(routes.users)}>{Icon.users} Users</button>
            </div>
            <div style={{ marginTop: 20, fontWeight: 700, color: 'var(--text)', marginBottom: 10 }}>Platform Health</div>
            <ul className="feature-list">
              <li>Backend API live on port 8000</li>
              <li>JWT authentication active</li>
              <li>File uploads enabled (PDF + Images)</li>
              <li>Real-time data sync every refresh</li>
            </ul>
          </div>
        </div>
      </section>

      {/* Recent Activities */}
      <div className="card">
        <div className="card-header">
          <div>
            <div className="card-title">Recent Activity</div>
            <div className="card-subtitle">Latest events across the platform</div>
          </div>
        </div>
        <div className="card-body">
          {activities.map((a, i) => (
            <div key={i} className="activity-item">
              <span className="activity-dot" style={{ background: a.color }} />
              <span className="activity-text">{a.text}</span>
              <span className="activity-time">{a.time}</span>
            </div>
          ))}
        </div>
      </div>
    </>
  )
}

/* ─────────────────────────────────────────────────────────── Users */
function UsersPage({ data, query, setQuery, navigate, loadData, confirmDelete }) {
  const rows = useFilteredRows(data.users, query, ['username', 'name', 'email'])

  const run = async (action, successMsg) => {
    try {
      await action()
      await loadData()
      toast(successMsg, 'success')
    } catch (error) {
      toast(error.message, 'error')
    }
  }

  return (
    <>
      <div className="page-header">
        <div><h1>User Management</h1><p>Search, review, block and delete user accounts.</p></div>
      </div>
      <div className="card">
        <div className="card-header">
          <div className="toolbar">
            <div className="search">
              <span>{Icon.search}</span>
              <input value={query} onChange={(e) => setQuery(e.target.value)} placeholder="Search by name or email…" />
            </div>
          </div>
          <span style={{ fontSize: 13, color: 'var(--muted)' }}>{rows.length} users</span>
        </div>
        <div className="table-wrap">
          <table>
            <thead>
              <tr>
                <th>ID</th><th>Name / Email</th><th>Status</th><th>Admin</th><th>Actions</th>
              </tr>
            </thead>
            <tbody>
              {rows.length ? rows.map((user) => (
                <tr key={user.id}>
                  <td style={{ color: 'var(--muted)', fontSize: 12 }}>#{user.id}</td>
                  <td>
                    <div style={{ fontWeight: 600 }}>{user.username || user.name || '—'}</div>
                    <div style={{ fontSize: 12, color: 'var(--muted)' }}>{user.email}</div>
                  </td>
                  <td><StatusBadge active={user.is_active} /></td>
                  <td style={{ fontSize: 12, color: 'var(--muted)' }}>{user.is_superuser ? '✓ Yes' : '—'}</td>
                  <td>
                    <div className="row-actions">
                      <button onClick={() => run(() => userRepository.toggleStatus(user.id), user.is_active ? 'User blocked' : 'User unblocked')}>
                        {user.is_active ? 'Block' : 'Unblock'}
                      </button>
                      <button className="danger" onClick={() => confirmDelete(`Delete user "${user.email}"? This cannot be undone.`, () => run(() => userRepository.delete(user.id), 'User deleted'))}>
                        Delete
                      </button>
                    </div>
                  </td>
                </tr>
              )) : (
                <tr><td colSpan={5} style={{ textAlign: 'center', color: 'var(--muted)', padding: 32 }}>No users found.</td></tr>
              )}
            </tbody>
          </table>
        </div>
        <div style={{ padding: '12px 20px' }}><Pagination total={rows.length} /></div>
      </div>
    </>
  )
}

/* ─────────────────────────────────────────────────────────── Books */
function BooksPage({ data, query, setQuery, navigate, loadData, confirmDelete }) {
  const [catFilter, setCatFilter] = useState('')
  const rows = useFilteredRows(data.books, query, ['title', 'author', 'category', 'language'])
  const filtered = catFilter ? rows.filter((b) => (b.category || '').toLowerCase().includes(catFilter.toLowerCase())) : rows

  const run = async (action, msg) => {
    try { await action(); await loadData(); toast(msg, 'success') }
    catch (e) { toast(e.message, 'error') }
  }

  return (
    <>
      <div className="page-header">
        <div><h1>Books Management</h1><p>Upload, update, feature and manage library books with PDF and cover images.</p></div>
        <div className="header-actions">
          <button className="btn-primary" onClick={() => navigate(routes.addBook)}>{Icon.plus} Add Book</button>
        </div>
      </div>
      <div className="card">
        <div className="card-header">
          <div className="toolbar">
            <div className="search">
              <span>{Icon.search}</span>
              <input value={query} onChange={(e) => setQuery(e.target.value)} placeholder="Search books, authors, categories…" />
            </div>
            <select value={catFilter} onChange={(e) => setCatFilter(e.target.value)}>
              <option value="">All Categories</option>
              {[...new Set(data.books.map((b) => b.category).filter(Boolean))].map((c) => (
                <option key={c} value={c}>{c}</option>
              ))}
            </select>
          </div>
          <span style={{ fontSize: 13, color: 'var(--muted)' }}>{filtered.length} books</span>
        </div>
        <div className="table-wrap">
          <table>
            <thead>
              <tr><th>Cover</th><th>Title / Author</th><th>Category</th><th>Status</th><th>Week</th><th>Actions</th></tr>
            </thead>
            <tbody>
              {filtered.length ? filtered.map((book) => (
                <tr key={book.id}>
                  <td>
                    {book.image_url
                      ? <img className="book-thumb" src={apiClient.fileURL(book.image_url)} alt={book.title} />
                      : <div className="book-thumb" style={{ display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--muted)' }}>{Icon.image}</div>}
                  </td>
                  <td>
                    <div style={{ fontWeight: 600 }}>{book.title}</div>
                    <div style={{ fontSize: 12, color: 'var(--muted)' }}>{book.author}</div>
                  </td>
                  <td style={{ fontSize: 12, color: 'var(--muted)' }}>{book.category || '—'}</td>
                  <td><StatusBadge active={book.is_active} /></td>
                  <td>
                    <span style={{ fontSize: 12, fontWeight: 600, color: book.isWeek ? 'var(--gold)' : 'var(--muted)' }}>
                      {book.isWeek ? '⭐ Yes' : '—'}
                    </span>
                  </td>
                  <td>
                    <div className="row-actions">
                      <button onClick={() => navigate(`/books/view/${book.id}`, book)}>View</button>
                      <button onClick={() => navigate(`/books/edit/${book.id}`, book)}>Edit</button>
                      <button onClick={() => run(() => bookRepository.update(book.id, { isWeek: !book.isWeek }), book.isWeek ? 'Unfeatured' : 'Featured this week!')}>
                        {book.isWeek ? 'Unfeature' : 'Feature'}
                      </button>
                      <button onClick={() => run(() => bookRepository.update(book.id, { is_active: !book.is_active }), book.is_active ? 'Book disabled' : 'Book enabled')}>
                        {book.is_active ? 'Disable' : 'Enable'}
                      </button>
                      <button className="danger" onClick={() => confirmDelete(`Delete "${book.title}"? This also removes the PDF and cover image.`, () => run(() => bookRepository.delete(book.id), 'Book deleted'))}>
                        Delete
                      </button>
                    </div>
                  </td>
                </tr>
              )) : (
                <tr><td colSpan={6} style={{ textAlign: 'center', color: 'var(--muted)', padding: 32 }}>No books found.</td></tr>
              )}
            </tbody>
          </table>
        </div>
        <div style={{ padding: '12px 20px' }}><Pagination total={filtered.length} /></div>
      </div>
    </>
  )
}

/* ─────────────────────────────────────────────────────────── Book Form */
function BookFormPage({ selected, navigate, loadData }) {
  const [form, setForm] = useState(selected || emptyBook)
  const [bookPdf, setBookPdf] = useState(null)
  const [pdfPreview, setPdfPreview] = useState(null)
  const [image, setImage] = useState(null)
  const [imagePreview, setImagePreview] = useState(selected?.image_url ? apiClient.fileURL(selected.image_url) : null)
  const [busy, setBusy] = useState(false)
  const editing = Boolean(selected?.id)

  const handleImageChange = (file) => {
    if (!file) return
    setImage(file)
    setImagePreview(URL.createObjectURL(file))
  }

  const handlePdfChange = (file) => {
    if (!file) return
    setBookPdf(file)
    setPdfPreview(file.name)
  }

  const submit = async (event) => {
    event.preventDefault()
    setBusy(true)
    try {
      if (editing) {
        const payload = new FormData()
        Object.entries(form).forEach(([k, v]) => payload.append(k, v ?? ''))
        if (image) payload.append('image', image)
        if (bookPdf) payload.append('book_pdf', bookPdf)
        await bookRepository.update(selected.id, payload)
      } else {
        if (!bookPdf || !image) { toast('Please select both a PDF and a cover image', 'error'); setBusy(false); return }
        const payload = new FormData()
        Object.entries(form).forEach(([k, v]) => payload.append(k, v ?? ''))
        payload.append('book_pdf', bookPdf)
        payload.append('image', image)
        await bookRepository.save(payload)
      }
      await loadData()
      toast(editing ? 'Book updated!' : 'Book added!', 'success')
      navigate(routes.books)
    } catch (error) {
      toast(error.message, 'error')
    } finally {
      setBusy(false)
    }
  }

  return (
    <>
      <div className="page-header">
        <div><h1>{editing ? 'Edit Book' : 'Add New Book'}</h1><p>Fill in all fields, upload a cover image and PDF file.</p></div>
        <div className="header-actions">
          <button className="btn-secondary" onClick={() => navigate(routes.books)}>Cancel</button>
        </div>
      </div>
      <div className="card">
        <form className="entity-form" style={{ padding: 20 }} onSubmit={submit}>
          <FormField label="Title" field="title" form={form} setForm={setForm} required />
          <FormField label="Author" field="author" form={form} setForm={setForm} required />
          <FormField label="Category" field="category" form={form} setForm={setForm} />
          <FormField label="Language" field="language" form={form} setForm={setForm} />
          <FormField label="Description" field="description" form={form} setForm={setForm} textarea wide />

          {/* Cover Image Upload */}
          <div className="form-field wide">
            <label className="form-label">Cover Image</label>
            <DropZone
              icon={Icon.image}
              title="Drop cover image here or click to browse"
              hint="JPG, PNG, WEBP — max 5 MB"
              accept="image/*"
              preview={imagePreview}
              previewType="image"
              filename={image?.name}
              onFile={handleImageChange}
              onClear={() => { setImage(null); setImagePreview(null) }}
            />
          </div>

          {/* PDF Upload */}
          <div className="form-field wide">
            <label className="form-label">Book PDF</label>
            <DropZone
              icon={Icon.pdf}
              title="Drop PDF file here or click to browse"
              hint="PDF format only — max 50 MB"
              accept="application/pdf"
              preview={null}
              previewType="pdf"
              filename={pdfPreview || (editing && selected?.pdf_url ? 'Existing PDF on server' : null)}
              onFile={handlePdfChange}
              onClear={() => { setBookPdf(null); setPdfPreview(null) }}
            />
          </div>

          {/* Toggles */}
          <div className="form-field">
            <label className="form-label">Status</label>
            <label className="form-check">
              <input type="checkbox" checked={Boolean(form.is_active)} onChange={() => setForm((f) => ({ ...f, is_active: !f.is_active }))} />
              <label>Active (visible to users)</label>
            </label>
          </div>
          <div className="form-field">
            <label className="form-label">Featured</label>
            <label className="form-check">
              <input type="checkbox" checked={Boolean(form.isWeek)} onChange={() => setForm((f) => ({ ...f, isWeek: !f.isWeek }))} />
              <label>⭐ Book of the Week</label>
            </label>
          </div>

          <div className="form-actions">
            <button className="btn-secondary" type="button" onClick={() => navigate(routes.books)}>Cancel</button>
            <button className="btn-primary" disabled={busy}>{busy ? 'Saving…' : editing ? 'Update Book' : 'Add Book'}</button>
          </div>
        </form>
      </div>
    </>
  )
}

/* ─────────────────────────────────────────────────────────── Book Details */
function BookDetailsPage({ selected, data }) {
  const book = selected || data.books[0] || emptyBook
  return (
    <>
      <PageHeader title="Book Details" subtitle="Read-only view of the selected book." />
      <div className="card card-body">
        {book.image_url && (
          <div style={{ marginBottom: 20 }}>
            <img src={apiClient.fileURL(book.image_url)} alt={book.title} style={{ height: 200, borderRadius: 12, objectFit: 'cover' }} />
          </div>
        )}
        <dl className="details">
          {[['Title', book.title], ['Author', book.author], ['Category', book.category || '—'], ['Language', book.language || '—'],
            ['Active', book.is_active ? '✓ Yes' : 'No'], ['Book of Week', book.isWeek ? '⭐ Yes' : 'No']].map(([k, v]) => (
              <div key={k}><dt>{k}</dt><dd>{v}</dd></div>
          ))}
        </dl>
        {book.description && <div style={{ marginTop: 16, color: 'var(--text-2)' }}>{book.description}</div>}
        {book.pdf_url && <div style={{ marginTop: 16 }}><a href={apiClient.fileURL(book.pdf_url)} target="_blank" rel="noreferrer" style={{ color: 'var(--primary)', fontWeight: 600 }}>📄 Open PDF</a></div>}
      </div>
    </>
  )
}

/* ─────────────────────────────────────────────────────────── Onboarding */
function OnboardingPage({ data, query, setQuery, navigate, loadData, confirmDelete }) {
  const rows = useFilteredRows(data.onboarding, query, ['title', 'description'])
  const run = async (action, msg) => {
    try { await action(); await loadData(); toast(msg, 'success') }
    catch (e) { toast(e.message, 'error') }
  }

  return (
    <>
      <div className="page-header">
        <div><h1>Onboarding Management</h1><p>Create and order app onboarding screens shown to new users.</p></div>
        <div className="header-actions">
          <button className="btn-primary" onClick={() => navigate(routes.addOnboarding)}>{Icon.plus} Create Onboarding</button>
        </div>
      </div>
      <div className="card">
        <div className="card-header">
          <div className="search">
            <span>{Icon.search}</span>
            <input value={query} onChange={(e) => setQuery(e.target.value)} placeholder="Search onboarding items…" />
          </div>
        </div>
        <div className="table-wrap">
          <table>
            <thead><tr><th>Order</th><th>Preview</th><th>Title</th><th>Description</th><th>Status</th><th>Actions</th></tr></thead>
            <tbody>
              {rows.length ? rows.map((item) => (
                <tr key={item.id}>
                  <td style={{ fontWeight: 700, fontSize: 18, color: 'var(--muted)' }}>#{item.sort_order}</td>
                  <td>
                    {item.image_url
                      ? <img src={apiClient.fileURL(item.image_url)} alt={item.title} style={{ height: 50, width: 50, objectFit: 'cover', borderRadius: 8 }} />
                      : <div style={{ width: 50, height: 50, borderRadius: 8, background: 'var(--surface-3)', display: 'flex', alignItems: 'center', justifyContent: 'center', color: 'var(--muted)' }}>{Icon.image}</div>}
                  </td>
                  <td style={{ fontWeight: 600 }}>{item.title}</td>
                  <td style={{ color: 'var(--muted)', fontSize: 13, maxWidth: 240 }}>{item.description}</td>
                  <td><StatusBadge active={item.is_active} /></td>
                  <td>
                    <div className="row-actions">
                      <button onClick={() => navigate(`/onboarding/edit/${item.id}`, item)}>Edit</button>
                      <button onClick={() => run(() => onboardingRepository.update(item.id, { is_active: !item.is_active }), item.is_active ? 'Disabled' : 'Enabled')}>
                        {item.is_active ? 'Disable' : 'Enable'}
                      </button>
                      <button className="danger" onClick={() => confirmDelete(`Delete onboarding "${item.title}"?`, () => run(() => onboardingRepository.delete(item.id), 'Deleted'))}>
                        Delete
                      </button>
                    </div>
                  </td>
                </tr>
              )) : (
                <tr><td colSpan={6} style={{ textAlign: 'center', color: 'var(--muted)', padding: 32 }}>No onboarding items yet.</td></tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
    </>
  )
}

/* ─────────────────────────────────────────────────────────── Onboarding Form */
function OnboardingFormPage({ selected, navigate, loadData }) {
  const [form, setForm] = useState(selected || emptyOnboarding)
  const [image, setImage] = useState(null)
  const [imagePreview, setImagePreview] = useState(selected?.image_url ? apiClient.fileURL(selected.image_url) : null)
  const [busy, setBusy] = useState(false)
  const editing = Boolean(selected?.id)

  const handleImageChange = (file) => {
    if (!file) return
    setImage(file)
    setImagePreview(URL.createObjectURL(file))
  }

  const submit = async (event) => {
    event.preventDefault()
    setBusy(true)
    try {
      // Always use FormData — backend requires multipart/form-data for image support
      const payload = new FormData()
      payload.append('title', form.title ?? '')
      payload.append('description', form.description ?? '')
      payload.append('sort_order', String(form.sort_order ?? 0))
      payload.append('is_active', form.is_active ? '1' : '0')
      if (form.image_url) payload.append('image_url', form.image_url)
      if (image) payload.append('image', image)

      if (editing) await onboardingRepository.update(selected.id, payload)
      else await onboardingRepository.save(payload)

      await loadData()
      toast(editing ? 'Onboarding updated!' : 'Onboarding created!', 'success')
      navigate(routes.onboarding)
    } catch (error) {
      toast(error.message, 'error')
    } finally {
      setBusy(false)
    }
  }

  return (
    <>
      <div className="page-header">
        <div><h1>{editing ? 'Edit Onboarding' : 'Create Onboarding'}</h1></div>
        <div className="header-actions">
          <button className="btn-secondary" onClick={() => navigate(routes.onboarding)}>Cancel</button>
        </div>
      </div>
      <div className="card">
        <form className="entity-form" style={{ padding: 20 }} onSubmit={submit}>
          <FormField label="Title" field="title" form={form} setForm={setForm} required />
          <FormField label="Sort Order" field="sort_order" form={form} setForm={setForm} type="number" />
          <FormField label="Description" field="description" form={form} setForm={setForm} textarea wide />

          {/* Image Upload with Preview */}
          <div className="form-field wide">
            <label className="form-label">Slide Image</label>
            <DropZone
              icon={Icon.image}
              title="Drop onboarding image here or click to browse"
              hint="JPG, PNG, WEBP — max 10 MB"
              accept="image/*"
              preview={imagePreview}
              previewType="image"
              filename={image?.name}
              onFile={handleImageChange}
              onClear={() => { setImage(null); setImagePreview(null) }}
            />
          </div>

          {/* Fallback URL field */}
          <FormField label="Image URL (optional fallback)" field="image_url" form={form} setForm={setForm} wide />

          <div className="form-field">
            <label className="form-check">
              <input type="checkbox" checked={Boolean(form.is_active)} onChange={() => setForm((f) => ({ ...f, is_active: !f.is_active }))} />
              <label>Active</label>
            </label>
          </div>

          <div className="form-actions">
            <button className="btn-secondary" type="button" onClick={() => navigate(routes.onboarding)}>Cancel</button>
            <button className="btn-primary" disabled={busy}>{busy ? 'Saving…' : editing ? 'Update' : 'Create'}</button>
          </div>
        </form>
      </div>
    </>
  )
}

/* ─────────────────────────────────────────────────────────── Policies */
function PoliciesPage({ data, query, setQuery, navigate, loadData, confirmDelete }) {
  const rows = useFilteredRows(data.policies, query, ['title', 'description'])
  const run = async (action, msg) => {
    try { await action(); await loadData(); toast(msg, 'success') }
    catch (e) { toast(e.message, 'error') }
  }

  return (
    <>
      <div className="page-header">
        <div><h1>Policy Management</h1><p>Maintain privacy, terms and legal policy content for the app.</p></div>
        <div className="header-actions">
          <button className="btn-primary" onClick={() => navigate(routes.addPolicy)}>{Icon.plus} Add Policy</button>
        </div>
      </div>
      <div className="card">
        <div className="card-header">
          <div className="search">
            <span>{Icon.search}</span>
            <input value={query} onChange={(e) => setQuery(e.target.value)} placeholder="Search policies…" />
          </div>
        </div>
        <div className="table-wrap">
          <table>
            <thead><tr><th>Type</th><th>Title</th><th>Description</th><th>Status</th><th>Actions</th></tr></thead>
            <tbody>
              {rows.length ? rows.map((policy) => (
                <tr key={policy.id}>
                  <td>
                    <span className={`policy-type-badge ${policy.policy_type === 'privacy_policy' ? 'privacy' : 'terms'}`}>
                      {policy.policy_type === 'privacy_policy' ? '🔒 Privacy' : '📋 Terms'}
                    </span>
                  </td>
                  <td style={{ fontWeight: 600 }}>{policy.title}</td>
                  <td style={{ color: 'var(--muted)', fontSize: 13, maxWidth: 300 }}>{policy.description?.slice(0, 80)}…</td>
                  <td><StatusBadge active={policy.is_active} /></td>
                  <td>
                    <div className="row-actions">
                      <button onClick={() => navigate(`/policies/view/${policy.id}`, policy)}>View</button>
                      <button onClick={() => navigate(`/policies/edit/${policy.id}`, policy)}>Edit</button>
                      <button onClick={() => run(() => policyRepository.update(policy.id, { is_active: !policy.is_active }), policy.is_active ? 'Policy disabled' : 'Policy enabled')}>
                        {policy.is_active ? 'Disable' : 'Enable'}
                      </button>
                      <button className="danger" onClick={() => confirmDelete(`Delete policy "${policy.title}"?`, () => run(() => policyRepository.delete(policy.id), 'Policy deleted'))}>
                        Delete
                      </button>
                    </div>
                  </td>
                </tr>
              )) : (
                <tr><td colSpan={5} style={{ textAlign: 'center', color: 'var(--muted)', padding: 32 }}>No policies yet.</td></tr>
              )}
            </tbody>
          </table>
        </div>
      </div>
    </>
  )
}

/* ─────────────────────────────────────────────────────────── Policy Form */
function PolicyFormPage({ selected, navigate, loadData }) {
  const [form, setForm] = useState(selected || emptyPolicy)
  const [busy, setBusy] = useState(false)
  const editing = Boolean(selected?.id)

  const submit = async (event) => {
    event.preventDefault()
    setBusy(true)
    try {
      if (editing) await policyRepository.update(selected.id, form)
      else await policyRepository.save(form)
      await loadData()
      toast(editing ? 'Policy updated!' : 'Policy created!', 'success')
      navigate(routes.policies)
    } catch (error) {
      toast(error.message, 'error')
    } finally {
      setBusy(false)
    }
  }

  return (
    <>
      <div className="page-header">
        <div><h1>{editing ? 'Edit Policy' : 'Add Policy'}</h1></div>
        <div className="header-actions">
          <button className="btn-secondary" onClick={() => navigate(routes.policies)}>Cancel</button>
        </div>
      </div>
      <div className="card">
        <form className="entity-form compact" style={{ padding: 20 }} onSubmit={submit}>
          {/* Policy Type Selector */}
          <div className="form-field">
            <label className="form-label">Policy Type</label>
            <div className="policy-type-selector">
              <label className={`policy-type-option ${form.policy_type === 'privacy_policy' ? 'selected' : ''}`}>
                <input type="radio" name="policy_type" value="privacy_policy"
                  checked={form.policy_type === 'privacy_policy'}
                  onChange={() => setForm(f => ({ ...f, policy_type: 'privacy_policy' }))} />
                🔒 Privacy Policy
              </label>
              <label className={`policy-type-option ${form.policy_type === 'terms_and_conditions' ? 'selected' : ''}`}>
                <input type="radio" name="policy_type" value="terms_and_conditions"
                  checked={form.policy_type === 'terms_and_conditions'}
                  onChange={() => setForm(f => ({ ...f, policy_type: 'terms_and_conditions' }))} />
                📋 Terms & Conditions
              </label>
            </div>
          </div>
          <FormField label="Title" field="title" form={form} setForm={setForm} required />
          <FormField label="Description / Content" field="description" form={form} setForm={setForm} textarea />
          {editing && (
            <div className="form-field">
              <label className="form-check">
                <input type="checkbox" checked={Boolean(form.is_active)} onChange={() => setForm((f) => ({ ...f, is_active: !f.is_active }))} />
                <label>Active</label>
              </label>
            </div>
          )}
          <div className="form-actions">
            <button className="btn-secondary" type="button" onClick={() => navigate(routes.policies)}>Cancel</button>
            <button className="btn-primary" disabled={busy}>{busy ? 'Saving…' : editing ? 'Update Policy' : 'Add Policy'}</button>
          </div>
        </form>
      </div>
    </>
  )
}

/* ─────────────────────────────────────────────────────────── Policy Details */
function PolicyDetailsPage({ selected, data }) {
  const policy = selected || data.policies[0] || emptyPolicy
  return (
    <>
      <PageHeader title="Policy Details" subtitle="Read-only view." />
      <div className="card card-body">
        <dl className="details">
          <div><dt>Title</dt><dd style={{ fontWeight: 600 }}>{policy.title}</dd></div>
          <div><dt>Active</dt><dd>{policy.is_active ? '✓ Active' : 'Inactive'}</dd></div>
        </dl>
        <div style={{ marginTop: 20, color: 'var(--text-2)', lineHeight: 1.8 }}>{policy.description}</div>
      </div>
    </>
  )
}

/* ─────────────────────────────────────────────────────────── Settings */
function SettingsPage() {
  return (
    <>
      <PageHeader title="Settings" subtitle="Admin profile and application preferences." />
      <section className="settings-grid">
        <div className="card">
          <div className="card-header"><div className="card-title">Admin Profile</div></div>
          <div className="card-body">
            <div className="entity-form compact" style={{ display: 'flex', flexDirection: 'column', gap: 16 }}>
              <div className="form-field">
                <label className="form-label">Admin Name</label>
                <input className="form-input" defaultValue="Admin" />
              </div>
              <div className="form-field">
                <label className="form-label">Admin Email</label>
                <input className="form-input" defaultValue="admin@gmail.com" />
              </div>
              <div><button className="btn-primary" onClick={() => toast('Profile saved', 'success')}>Save Changes</button></div>
            </div>
          </div>
        </div>
        <div className="card">
          <div className="card-header"><div className="card-title">System Info</div></div>
          <div className="card-body">
            <ul className="feature-list">
              <li>Backend API: http://127.0.0.1:8000</li>
              <li>JWT Token Auth enabled</li>
              <li>PDF + Image upload enabled</li>
              <li>User management with block/unblock</li>
              <li>Book of the Week feature</li>
              <li>User-facing Policy & Onboarding APIs</li>
              <li>User Profile GET/PUT with Bearer token</li>
            </ul>
          </div>
        </div>
      </section>
    </>
  )
}

/* ─────────────────────────────────────────────────────────── Shared Components */
function PageHeader({ title, subtitle, actions }) {
  return (
    <div className="page-header">
      <div><h1>{title}</h1>{subtitle && <p>{subtitle}</p>}</div>
      {actions && <div className="header-actions">{actions}</div>}
    </div>
  )
}

function StatusBadge({ active }) {
  return <span className={`badge ${active ? 'active' : 'blocked'}`}>{active ? 'Active' : 'Inactive'}</span>
}

function Pagination({ total }) {
  return (
    <div className="pagination">
      <span>{total} records</span>
      <button>‹ Prev</button>
      <button className="active-page">1</button>
      <button>Next ›</button>
    </div>
  )
}

function FormField({ label, field, form, setForm, textarea = false, wide = false, required = false, type = 'text' }) {
  const value = form[field] ?? ''
  const update = (e) => setForm((f) => ({ ...f, [field]: field === 'sort_order' ? Number(e.target.value) : e.target.value }))
  return (
    <div className={`form-field ${wide ? 'wide' : ''}`}>
      <label className="form-label" htmlFor={`field-${field}`}>{label}</label>
      {textarea
        ? <textarea id={`field-${field}`} className="form-textarea" value={value} onChange={update} rows="5" required={required} />
        : <input id={`field-${field}`} className="form-input" value={value} onChange={update} type={type} required={required} />}
    </div>
  )
}

/* ─────────────────────────────────────────────────────────── Drop Zone */
function DropZone({ icon, title, hint, accept, preview, previewType, filename, onFile, onClear }) {
  const [isDragOver, setIsDragOver] = useState(false)
  const inputRef = useRef(null)

  const handleDrop = (e) => {
    e.preventDefault()
    setIsDragOver(false)
    const file = e.dataTransfer.files?.[0]
    if (file) onFile(file)
  }

  return (
    <div>
      <div
        className={`upload-zone ${isDragOver ? 'dragover' : ''}`}
        onDragOver={(e) => { e.preventDefault(); setIsDragOver(true) }}
        onDragLeave={() => setIsDragOver(false)}
        onDrop={handleDrop}
        onClick={() => inputRef.current?.click()}
      >
        <input ref={inputRef} type="file" accept={accept} onChange={(e) => onFile(e.target.files?.[0])} />
        <div className="upload-zone-icon">{icon}</div>
        <div className="upload-zone-title">{title}</div>
        <div className="upload-zone-hint">{hint}</div>
      </div>
      {previewType === 'image' && preview && (
        <div className="upload-preview">
          <img src={preview} alt="preview" />
          <button className="upload-preview-clear" type="button" onClick={onClear}>×</button>
        </div>
      )}
      {previewType === 'pdf' && filename && (
        <div style={{ marginTop: 10 }}>
          <div className="upload-preview-filename">
            {Icon.pdf} {filename}
          </div>
        </div>
      )}
    </div>
  )
}

/* ─────────────────────────────────────────────────────────── Charts */
function BarChart({ groups = [], tone = 'blue' }) {
  const max = Math.max(...groups.map((g) => g.value), 1)
  return (
    <div className={`bar-chart ${tone === 'green' ? 'green' : ''}`}>
      {groups.map(({ label, value }, i) => (
        <div key={i} className="bar-group">
          <div className="bar-value">{value}</div>
          <div className="bar" style={{ height: `${Math.max((value / max) * 160, 4)}px`, animationDelay: `${i * 80}ms` }} />
          <div className="bar-label">{label}</div>
        </div>
      ))}
    </div>
  )
}

function LineChart() {
  const points = [38, 55, 44, 72, 60, 85, 78, 92, 68, 95, 82, 100]
  const w = 320; const h = 120; const pad = 10
  const maxV = Math.max(...points)
  const coords = points.map((v, i) => {
    const x = pad + (i / (points.length - 1)) * (w - pad * 2)
    const y = h - pad - ((v / maxV) * (h - pad * 2))
    return `${x},${y}`
  })
  const polyline = coords.join(' ')
  const area = `${pad},${h - pad} ${polyline} ${w - pad},${h - pad}`

  return (
    <div className="line-chart">
      <svg viewBox={`0 0 ${w} ${h}`} role="img" aria-label="Monthly activity">
        <defs>
          <linearGradient id="lineGradient" x1="0" y1="0" x2="0" y2="1">
            <stop offset="0%" stopColor="var(--primary)" stopOpacity="0.3" />
            <stop offset="100%" stopColor="var(--primary)" stopOpacity="0.02" />
          </linearGradient>
        </defs>
        <polygon points={area} className="line-area" />
        <polyline points={polyline} className="line-stroke" />
        {coords.map((c, i) => {
          const [x, y] = c.split(',')
          return <circle key={i} cx={x} cy={y} r="4" className="dot" />
        })}
      </svg>
    </div>
  )
}

/* ─────────────────────────────────────────────────────────── Hook */
function useFilteredRows(rows, query, keys) {
  return useMemo(() => {
    const q = query.trim().toLowerCase()
    if (!q) return rows
    return rows.filter((row) => keys.some((k) => String(row[k] || '').toLowerCase().includes(q)))
  }, [rows, query, keys])
}

export default App
