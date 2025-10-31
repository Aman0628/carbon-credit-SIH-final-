import axios from 'axios';

// Base API URL - change this to match your backend
const API_BASE_URL =
  process.env.NEXT_PUBLIC_API_URL || 'http://localhost:4000/api/v1';

// Create axios instance with default config
export const apiClient = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
  withCredentials: true, // Important: Send cookies with requests
  timeout: 10000, // 10 seconds
});

// Remove auth token interceptor (we're using httpOnly cookies now)
// No need for Authorization header since we use cookies

// Response interceptor for handling errors
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      // Unauthorized - redirect to login
      if (typeof window !== 'undefined') {
        window.location.href = '/';
      }
    }
    return Promise.reject(error);
  }
);

// Admin API endpoints
export const adminApi = {
  signup: (data: {
    name: string;
    email: string;
    password: string;
    admin_key: string;
  }) => apiClient.post('/admin/signup', data),

  login: (data: { email: string; password: string }) =>
    apiClient.post('/admin/login', data),

  logout: () => apiClient.post('/admin/logout'),

  getDashboard: () => apiClient.get('/admin/dashboard'),

  getUsers: () => apiClient.get('/admin/users'),

  verifyUser: (data: { user_id: string; user_type: 'buyer' | 'seller' }) =>
    apiClient.post('/admin/verify-user', data),

  getProfile: () => apiClient.get('/admin/profile'),

  updateProfile: (data: { name?: string; email?: string }) =>
    apiClient.put('/admin/profile', data),

  changePassword: (data: { currentPassword: string; newPassword: string }) =>
    apiClient.post('/admin/profile/change-password', data),
};

// Buyer API endpoints
export const buyerApi = {
  signup: (data: {
    organization_type: string;
    organization_email: string;
    organization_name: string;
    phone_no: string;
    password: string;
  }) => apiClient.post('/buyer/signup', data),

  sendOtp: (data: { email: string }) => apiClient.post('/buyer/send-otp', data),

  verifyOtp: (data: { email: string; otp: string }) =>
    apiClient.post('/buyer/verify-otp', data),

  login: (data: { email: string; password: string }) =>
    apiClient.post('/buyer/login', data),

  logout: () => apiClient.post('/buyer/logout'),

  getDashboard: () => apiClient.get('/buyer/dashboard'),

  getProfile: () => apiClient.get('/buyer/profile'),

  updateProfile: (data: {
    organization_name?: string;
    organization_email?: string;
    organization_type?: string;
    phone_no?: string;
    pan_no?: string;
    aadhar_no?: number;
    gst_no?: string;
    registration_no?: string;
    address?: string;
  }) => apiClient.put('/buyer/profile', data),

  changePassword: (data: { currentPassword: string; newPassword: string }) =>
    apiClient.post('/buyer/profile/change-password', data),

  // Cart
  getCart: () => apiClient.get('/buyer/cart'),

  addToCart: (data: { project_id: string; quantity: number }) =>
    apiClient.post('/buyer/cart', data),

  updateCartItem: (cart_item_id: string, data: { quantity: number }) =>
    apiClient.put(`/buyer/cart/${cart_item_id}`, data),

  removeCartItem: (cart_item_id: string) =>
    apiClient.delete(`/buyer/cart/${cart_item_id}`),

  clearCart: () => apiClient.delete('/buyer/cart'),

  // Orders
  createOrder: (data: { payment_method?: string }) =>
    apiClient.post('/buyer/orders', data),

  getOrders: () => apiClient.get('/buyer/orders'),

  getOrderById: (order_id: string) =>
    apiClient.get(`/buyer/orders/${order_id}`),
};

// Seller API endpoints
export const sellerApi = {
  signup: (data: {
    organization_email: string;
    organization_name: string;
    phone_no: string;
    password: string;
  }) => apiClient.post('/seller/signup', data),

  sendOtp: (data: { email: string }) =>
    apiClient.post('/seller/send-otp', data),

  verifyOtp: (data: { email: string; otp: string }) =>
    apiClient.post('/seller/verify-otp', data),

  login: (data: { email: string; password: string }) =>
    apiClient.post('/seller/login', data),

  logout: () => apiClient.post('/seller/logout'),

  getDashboard: () => apiClient.get('/seller/dashboard'),

  getProfile: () => apiClient.get('/seller/profile'),

  updateProfile: (data: {
    organization_name?: string;
    organization_email?: string;
    phone_no?: string;
    pan_no?: string;
    aadhar_no?: number;
    certificate_standard?: string;
    address?: string;
  }) => apiClient.put('/seller/profile', data),

  changePassword: (data: { currentPassword: string; newPassword: string }) =>
    apiClient.post('/seller/profile/change-password', data),
};

// Project API endpoints
export const projectApi = {
  create: (data: {
    project_name: string;
    project_description: string;
    project_location: string;
    carbon_credits_available: number;
    price_per_credit: number;
    image_url?: string;
    project_status?: string;
  }) => apiClient.post('/projects', data),

  getAll: (params?: { seller_id?: string; search?: string }) =>
    apiClient.get('/projects', { params }),

  getById: (id: string) => apiClient.get(`/projects/${id}`),

  update: (
    id: string,
    data: Partial<{
      project_name: string;
      project_description: string;
      project_location: string;
      carbon_credits_available: number;
      price_per_credit: number;
      image_url: string;
      project_status: string;
    }>
  ) => apiClient.put(`/projects/${id}`, data),

  delete: (id: string) => apiClient.delete(`/projects/${id}`),

  getMyProjects: () => apiClient.get('/projects/my-projects'),
};

// Error handler helper
export const handleApiError = (error: unknown): string => {
  if (axios.isAxiosError(error)) {
    return (
      error.response?.data?.message ||
      error.response?.data ||
      error.message ||
      'An error occurred'
    );
  }
  return 'An unexpected error occurred';
};
