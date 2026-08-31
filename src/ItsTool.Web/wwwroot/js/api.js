import { showToast } from './ui.js';

const API_BASE_URL = 'http://localhost:5246/api';

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
            ...options.headers
        };
        
        // Only default to JSON if we are not sending FormData
        if (!(options.body instanceof FormData) && !headers['Content-Type']) {
            headers['Content-Type'] = 'application/json';
        }

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

        if (response.status === 403) {
            const errorText = await response.text();
            console.error(`API Error 403:`, errorText);
            showToast('Yetkiniz yok veya oturum bilgileri güncel değil — yeniden giriş yapmayı deneyin (403)', 'error');
            throw new Error('Forbidden');
        }

        if (!response.ok) {
            const errorText = await response.text();
            console.error(`API Error ${response.status}:`, errorText);
            showToast(`İşlem başarısız (${response.status})`, 'error');
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
    async login(username, password) {
        const res = await this.request('/auth/login', {
            method: 'POST',
            body: JSON.stringify({ username, password })
        });
        this.setToken(res.token);
        return res;
    }

    async getMe() {
        return this.request('/auth/me');
    }

    // Dashboard
    async getDashboardOverview() {
        return this.request('/dashboard/overview');
    }
    
    async getDashboardDistributions() {
        return this.request('/dashboard/distributions');
    }

    async getDashboardSurveys() {
        return this.request('/dashboard/surveys');
    }

    // Lookup
    async getLookup() { return this.request('/lookup'); }

    // Tickets
    async searchTickets(filter = {}) {
        const queryParams = new URLSearchParams();
        for (const key in filter) {
            if (filter[key]) queryParams.append(key, filter[key]);
        }
        return this.request(`/ticket/search?${queryParams.toString()}`);
    }

    // Knowledge Base
    async getKbCategories() { return this.request('/kb/categories'); }
    async getKbArticles(search = '', categoryId = '') {
        const queryParams = new URLSearchParams();
        if (search) queryParams.append('search', search);
        if (categoryId) queryParams.append('category', categoryId);
        return this.request(`/kb/articles?${queryParams.toString()}`);
    }
    async createKbArticle(data) { return this.request('/kb/articles', { method: 'POST', body: JSON.stringify(data) }); }
    async updateKbArticle(id, data) { return this.request(`/kb/articles/${id}`, { method: 'PUT', body: JSON.stringify(data) }); }
    async deleteKbArticle(id) { return this.request(`/kb/articles/${id}`, { method: 'DELETE' }); }

    // Reports
    async exportTickets(filter = {}) {
        const queryParams = new URLSearchParams();
        for (const key in filter) {
            if (filter[key]) queryParams.append(key, filter[key]);
        }
        return this.request(`/reports/tickets/csv?${queryParams.toString()}`, { responseType: 'blob' });
    }
    // Dynamic Form
    async getFieldDefinitions() { return this.request('/DynamicForm/definitions'); }
    async getFieldOptions(defId) { return this.request(`/DynamicForm/definitions/${defId}/options`); }
    async getPlacements(projectId, categoryId, typeId) {
        const queryParams = new URLSearchParams();
        if (projectId) queryParams.append('projectId', projectId);
        if (categoryId) queryParams.append('categoryId', categoryId);
        if (typeId) queryParams.append('ticketTypeId', typeId);
        return this.request(`/DynamicForm/placements?${queryParams.toString()}`);
    }

    // Assignment Rules
    async getAssignmentRules() { return this.request('/rules/assignment'); }
    async createAssignmentRule(data) { return this.request('/rules/assignment', { method: 'POST', body: JSON.stringify(data) }); }
    async updateAssignmentRule(id, data) { return this.request(`/rules/assignment/${id}`, { method: 'PUT', body: JSON.stringify(data) }); }
    async toggleAssignmentRule(id) { return this.request(`/rules/assignment/${id}/toggle`, { method: 'PUT' }); }
    async deleteAssignmentRule(id) { return this.request(`/rules/assignment/${id}`, { method: 'DELETE' }); }

    // Saved Filters
    async getSavedFilters() { return this.request('/saved-filters'); }
    async createSavedFilter(data) { return this.request('/saved-filters', { method: 'POST', body: JSON.stringify(data) }); }
    async deleteSavedFilter(id) { return this.request(`/saved-filters/${id}`, { method: 'DELETE' }); }

    // Audit Log
    async getAuditLogs(filter = {}) {
        const queryParams = new URLSearchParams();
        for (const key in filter) {
            if (filter[key]) queryParams.append(key, filter[key]);
        }
        return this.request(`/audit-log?${queryParams.toString()}`);
    }
    // Organization & Admin
    async getProjects() { return this.request('/projects'); }
    async createProject(data) { return this.request('/projects', { method: 'POST', body: JSON.stringify(data) }); }
    async updateProject(id, data) { return this.request(`/projects/${id}`, { method: 'PUT', body: JSON.stringify(data) }); }
    async deleteProject(id) { return this.request(`/projects/${id}`, { method: 'DELETE' }); }

    async getDepartments() { return this.request('/departments'); }
    async createDepartment(data) { return this.request('/departments', { method: 'POST', body: JSON.stringify(data) }); }
    async updateDepartment(id, data) { return this.request(`/departments/${id}`, { method: 'PUT', body: JSON.stringify(data) }); }
    async deleteDepartment(id) { return this.request(`/departments/${id}`, { method: 'DELETE' }); }

    async getGroups() { return this.request('/groups'); }
    async createGroup(data) { return this.request('/groups', { method: 'POST', body: JSON.stringify(data) }); }
    async updateGroup(id, data) { return this.request(`/groups/${id}`, { method: 'PUT', body: JSON.stringify(data) }); }
    async deleteGroup(id) { return this.request(`/groups/${id}`, { method: 'DELETE' }); }
    async addGroupMember(groupId, userId) { return this.request(`/groups/${groupId}/members/${userId}`, { method: 'POST' }); }
    async removeGroupMember(groupId, userId) { return this.request(`/groups/${groupId}/members/${userId}`, { method: 'DELETE' }); }

    async getUsers() { return this.request('/users'); }
    async createUser(data) { return this.request('/users', { method: 'POST', body: JSON.stringify(data) }); }
    async updateUser(id, data) { return this.request(`/users/${id}`, { method: 'PUT', body: JSON.stringify(data) }); }
    async deleteUser(id) { return this.request(`/users/${id}`, { method: 'DELETE' }); }
    async assignRole(userId, roleId) { return this.request(`/users/${userId}/roles/${roleId}`, { method: 'POST' }); }
    async revokeRole(userId, roleId) { return this.request(`/users/${userId}/roles/${roleId}`, { method: 'DELETE' }); }
    async setPermissionOverride(userId, permId, isGranted) { return this.request(`/users/${userId}/permissions/${permId}?isGranted=${isGranted}`, { method: 'POST' }); }
    
    async getPermissions() { return this.request('/permissions'); }

    async getRoles() { return this.request('/roles'); }
    async createRole(data) { return this.request('/roles', { method: 'POST', body: JSON.stringify(data) }); }
    async updateRole(id, data) { return this.request(`/roles/${id}`, { method: 'PUT', body: JSON.stringify(data) }); }
    async deleteRole(id) { return this.request(`/roles/${id}`, { method: 'DELETE' }); }
    async assignPermission(roleId, permId) { return this.request(`/roles/${roleId}/permissions/${permId}`, { method: 'POST' }); }
    async revokePermission(roleId, permId) { return this.request(`/roles/${roleId}/permissions/${permId}`, { method: 'DELETE' }); }

    async getCategories(projectId = '') { 
        return this.request(`/catalog/categories${projectId ? '?projectId=' + projectId : ''}`); 
    }
    async createCategory(data) { return this.request('/catalog/categories', { method: 'POST', body: JSON.stringify(data) }); }
    async updateCategory(id, data) { return this.request(`/catalog/categories/${id}`, { method: 'PUT', body: JSON.stringify(data) }); }
    async deleteCategory(id) { return this.request(`/catalog/categories/${id}`, { method: 'DELETE' }); }
}

window.api = new ApiClient();
