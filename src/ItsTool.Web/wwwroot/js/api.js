const API_BASE_URL = 'https://localhost:7204/api';

class ApiClient {
    constructor() {
        this.token = localStorage.getItem('jwt_token');
    }

    setToken(token) {
        this.token = token;
        localStorage.setItem('jwt_token', token);
    }

    clearToken() {
        this.token = null;
        localStorage.removeItem('jwt_token');
    }

    async request(endpoint, options = {}) {
        const headers = {
            'Content-Type': 'application/json',
            ...(options.headers || {})
        };

        if (this.token) {
            headers['Authorization'] = `Bearer ${this.token}`;
        }

        const config = {
            ...options,
            headers
        };

        const response = await fetch(`${API_BASE_URL}${endpoint}`, config);

        if (response.status === 401) {
            this.clearToken();
            window.location.href = '/login.html';
            throw new Error('Unauthorized');
        }

        if (!response.ok) {
            const errorText = await response.text();
            throw new Error(errorText || 'API Error');
        }

        // Return empty for 204 No Content
        if (response.status === 204) return null;

        // Handle blob/csv
        if (config.responseType === 'blob') {
            return await response.blob();
        }

        return await response.json();
    }

    // Auth
    async login(email, password) {
        const res = await this.request('/auth/login', {
            method: 'POST',
            body: JSON.stringify({ email, password })
        });
        this.setToken(res.token);
        return res;
    }

    // Dashboard
    async getDashboardOverview() {
        return this.request('/dashboard/overview');
    }
    
    async getDashboardDistributions() {
        return this.request('/dashboard/distributions');
    }

    // Tickets
    async searchTickets(filter = {}) {
        const queryParams = new URLSearchParams();
        for (const key in filter) {
            if (filter[key]) queryParams.append(key, filter[key]);
        }
        return this.request(`/ticket/search?${queryParams.toString()}`);
    }

    // Knowledge Base
    async getKbArticles(search = '', categoryId = '') {
        const queryParams = new URLSearchParams();
        if (search) queryParams.append('search', search);
        if (categoryId) queryParams.append('category', categoryId);
        return this.request(`/kb/articles?${queryParams.toString()}`);
    }

    // Reports
    async exportTickets(filter = {}) {
        const queryParams = new URLSearchParams();
        for (const key in filter) {
            if (filter[key]) queryParams.append(key, filter[key]);
        }
        return this.request(`/reports/tickets/csv?${queryParams.toString()}`, { responseType: 'blob' });
    }
}

window.api = new ApiClient();
