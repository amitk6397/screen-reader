export const seedData = {
  users: [
    { id: 1, username: 'John', email: 'john@gmail.com', is_active: true, is_superuser: false },
    { id: 2, username: 'Priya', email: 'priya@gmail.com', is_active: true, is_superuser: false },
    { id: 3, username: 'Blocked User', email: 'blocked@gmail.com', is_active: false, is_superuser: false },
  ],
  books: [
    { id: 'bk-1', title: 'FastAPI Handbook', author: 'A. Kumar', description: 'Backend patterns for modern APIs.', category: 'Technology', language: 'English', pdf_url: '/uploads/fastapi.pdf', image_url: '/uploads/fastapi.png', is_active: true, created_at: '2026-06-01', isWeek: true },
    { id: 'bk-2', title: 'Product Notes', author: 'Admin Team', description: 'Short practical product guide.', category: 'Business', language: 'Hindi', pdf_url: '/uploads/product.pdf', image_url: '/uploads/product.png', is_active: true, created_at: '2026-06-04', isWeek: false },
    { id: 'bk-3', title: 'Learning React', author: 'Frontend Team', description: 'React admin UI foundations.', category: 'Education', language: 'English', pdf_url: '/uploads/react.pdf', image_url: '/uploads/react.png', is_active: false, created_at: '2026-06-10', isWeek: false },
  ],
  onboarding: [
    { id: 1, title: 'Welcome', description: 'Introduce the app value.', image_url: '/uploads/welcome.png', sort_order: 1, is_active: true },
    { id: 2, title: 'Read Books', description: 'Explain library access.', image_url: '/uploads/books.png', sort_order: 2, is_active: true },
    { id: 3, title: 'Track Progress', description: 'Show user progress.', image_url: '/uploads/progress.png', sort_order: 3, is_active: false },
  ],
  policies: [
    { id: 'policy-1', title: 'Privacy Policy', description: 'How user data is handled.', is_active: true },
    { id: 'policy-2', title: 'Terms of Use', description: 'Rules for using the application.', is_active: true },
    { id: 'policy-3', title: 'Refund Policy', description: 'Payment and refund information.', is_active: false },
  ],
  activities: [
    { title: 'John account activated', module: 'Users', time: '10 min ago' },
    { title: 'FastAPI Handbook marked weekly', module: 'Books', time: '36 min ago' },
    { title: 'Privacy Policy updated', module: 'Policies', time: '1 hr ago' },
    { title: 'Welcome onboarding reordered', module: 'Onboarding', time: 'Yesterday' },
  ],
}
