const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:5000';

interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  message?: string;
}

const getAuthHeader = (): HeadersInit => {
  const token = localStorage.getItem('auth_token');
  return token ? { Authorization: `Bearer ${token}` } : {};
};

const apiRequest = async <T = any>(
  endpoint: string,
  options: RequestInit = {}
): Promise<T> => {
  const response = await fetch(`${API_URL}/api${endpoint}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...getAuthHeader(),
      ...options.headers,
    },
  });

  const data: ApiResponse<T> = await response.json();

  if (!response.ok || !data.success) {
    throw new Error(data.message || 'Request failed');
  }

  return data.data as T;
};

export const api = {
  get: <T = any>(endpoint: string) => apiRequest<T>(endpoint, { method: 'GET' }),
  post: <T = any>(endpoint: string, body?: any) =>
    apiRequest<T>(endpoint, { method: 'POST', body: JSON.stringify(body) }),
  put: <T = any>(endpoint: string, body?: any) =>
    apiRequest<T>(endpoint, { method: 'PUT', body: JSON.stringify(body) }),
  patch: <T = any>(endpoint: string, body?: any) =>
    apiRequest<T>(endpoint, { method: 'PATCH', body: JSON.stringify(body) }),
  delete: <T = any>(endpoint: string) =>
    apiRequest<T>(endpoint, { method: 'DELETE' }),
};

export default api;
