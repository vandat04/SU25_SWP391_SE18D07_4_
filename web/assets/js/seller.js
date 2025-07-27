/**
 * SELLER DASHBOARD & MANAGEMENT JAVASCRIPT
 * Custom JavaScript for Seller-specific functionality
 */

class SellerDashboard {
    constructor() {
        this.init();
    }

    init() {
        this.initSidebar();
        this.initModals();
        this.initForms();
        this.initTables();
        this.initProductManagement();
        this.initFilters();
        this.initNotifications();
        this.bindEvents();
    }

    // ========== SIDEBAR FUNCTIONALITY ==========
    initSidebar() {
        const sidebarToggle = document.querySelector('.seller-toggle-sidebar');
        const sidebar = document.querySelector('.seller-sidebar');
        const content = document.querySelector('.seller-content');

        if (sidebarToggle && sidebar) {
            sidebarToggle.addEventListener('click', () => {
                sidebar.classList.toggle('active');
                if (content) {
                    content.classList.toggle('expanded');
                }
            });
        }

        // Auto-collapse sidebar on mobile
        if (window.innerWidth <= 1024) {
            sidebar?.classList.remove('active');
            content?.classList.add('expanded');
        }

        // Set active menu item
        this.setActiveMenuItem();
    }

    setActiveMenuItem() {
        const currentPath = window.location.pathname;
        const menuLinks = document.querySelectorAll('.seller-sidebar-nav a');
        
        menuLinks.forEach(link => {
            link.classList.remove('active');
            if (link.getAttribute('href') && currentPath.includes(link.getAttribute('href'))) {
                link.classList.add('active');
            }
        });
    }

    // ========== MODAL FUNCTIONALITY ==========
    initModals() {
        // Modal triggers
        document.addEventListener('click', (e) => {
            if (e.target.matches('[data-modal-trigger]')) {
                e.preventDefault();
                const modalId = e.target.getAttribute('data-modal-trigger');
                this.openModal(modalId);
            }

            if (e.target.matches('[data-modal-close]') || e.target.closest('[data-modal-close]')) {
                this.closeActiveModal();
            }
        });

        // Close modal on backdrop click
        document.addEventListener('click', (e) => {
            if (e.target.matches('.seller-modal')) {
                this.closeActiveModal();
            }
        });

        // Close modal on escape key
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape') {
                this.closeActiveModal();
            }
        });
    }

    openModal(modalId) {
        const modal = document.getElementById(modalId);
        if (modal) {
            modal.classList.add('active');
            document.body.style.overflow = 'hidden';
        }
    }

    closeActiveModal() {
        const activeModal = document.querySelector('.seller-modal.active');
        if (activeModal) {
            activeModal.classList.remove('active');
            document.body.style.overflow = '';
        }
    }

    // ========== FORM FUNCTIONALITY ==========
    initForms() {
        // Form validation
        const forms = document.querySelectorAll('form[data-validate]');
        forms.forEach(form => {
            form.addEventListener('submit', (e) => {
                if (!this.validateForm(form)) {
                    e.preventDefault();
                }
            });

            // Real-time validation
            const inputs = form.querySelectorAll('input, textarea, select');
            inputs.forEach(input => {
                input.addEventListener('blur', () => {
                    this.validateField(input);
                });
            });
        });

        // Auto-save drafts
        this.initAutoSave();
    }

    validateForm(form) {
        let isValid = true;
        const inputs = form.querySelectorAll('input[required], textarea[required], select[required]');
        
        inputs.forEach(input => {
            if (!this.validateField(input)) {
                isValid = false;
            }
        });

        return isValid;
    }

    validateField(field) {
        const value = field.value.trim();
        const isRequired = field.hasAttribute('required');
        let isValid = true;
        let errorMessage = '';

        // Remove existing error
        this.clearFieldError(field);

        // Required validation
        if (isRequired && !value) {
            isValid = false;
            errorMessage = 'Trường này là bắt buộc';
        }

        // Type-specific validation
        if (value && field.type === 'email') {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(value)) {
                isValid = false;
                errorMessage = 'Email không hợp lệ';
            }
        }

        if (value && field.type === 'number') {
            const min = field.getAttribute('min');
            const max = field.getAttribute('max');
            const numValue = parseFloat(value);

            if (isNaN(numValue)) {
                isValid = false;
                errorMessage = 'Vui lòng nhập số hợp lệ';
            } else {
                if (min !== null && numValue < parseFloat(min)) {
                    isValid = false;
                    errorMessage = `Giá trị tối thiểu là ${min}`;
                }
                if (max !== null && numValue > parseFloat(max)) {
                    isValid = false;
                    errorMessage = `Giá trị tối đa là ${max}`;
                }
            }
        }

        // Custom validation
        const customValidator = field.getAttribute('data-validator');
        if (customValidator && value) {
            const validatorResult = this.runCustomValidator(customValidator, value);
            if (!validatorResult.isValid) {
                isValid = false;
                errorMessage = validatorResult.message;
            }
        }

        if (!isValid) {
            this.showFieldError(field, errorMessage);
        }

        return isValid;
    }

    showFieldError(field, message) {
        field.classList.add('error');
        
        let errorElement = field.nextElementSibling;
        if (!errorElement || !errorElement.classList.contains('seller-form-error')) {
            errorElement = document.createElement('div');
            errorElement.classList.add('seller-form-error');
            field.parentNode.insertBefore(errorElement, field.nextSibling);
        }
        
        errorElement.textContent = message;
    }

    clearFieldError(field) {
        field.classList.remove('error');
        const errorElement = field.nextElementSibling;
        if (errorElement && errorElement.classList.contains('seller-form-error')) {
            errorElement.remove();
        }
    }

    runCustomValidator(validator, value) {
        switch (validator) {
            case 'sku':
                // SKU should be alphanumeric and unique
                const skuRegex = /^[A-Z0-9\-_]+$/i;
                return {
                    isValid: skuRegex.test(value),
                    message: 'SKU chỉ được chứa chữ cái, số, dấu gạch ngang và gạch dưới'
                };
            
            case 'price':
                const price = parseFloat(value);
                return {
                    isValid: price > 0,
                    message: 'Giá phải lớn hơn 0'
                };
            
            case 'stock':
                const stock = parseInt(value);
                return {
                    isValid: stock >= 0,
                    message: 'Số lượng kho không được âm'
                };
            
            default:
                return { isValid: true, message: '' };
        }
    }

    initAutoSave() {
        const forms = document.querySelectorAll('form[data-autosave]');
        forms.forEach(form => {
            const inputs = form.querySelectorAll('input, textarea, select');
            let saveTimeout;

            inputs.forEach(input => {
                input.addEventListener('input', () => {
                    clearTimeout(saveTimeout);
                    saveTimeout = setTimeout(() => {
                        this.autoSaveForm(form);
                    }, 2000);
                });
            });
        });
    }

    autoSaveForm(form) {
        const formData = new FormData(form);
        const data = Object.fromEntries(formData.entries());
        
        // Save to localStorage
        const saveKey = `seller_draft_${form.id || Date.now()}`;
        localStorage.setItem(saveKey, JSON.stringify(data));
        
        // Show save indicator
        this.showNotification('Đã lưu nháp tự động', 'info', 2000);
    }

    // ========== TABLE FUNCTIONALITY ==========
    initTables() {
        // Sortable tables
        const sortableHeaders = document.querySelectorAll('[data-sort]');
        sortableHeaders.forEach(header => {
            header.addEventListener('click', () => {
                const column = header.getAttribute('data-sort');
                const table = header.closest('table');
                this.sortTable(table, column);
            });
        });

        // Row selection
        const selectAllCheckbox = document.querySelector('[data-select-all]');
        if (selectAllCheckbox) {
            selectAllCheckbox.addEventListener('change', (e) => {
                const checkboxes = document.querySelectorAll('[data-select-row]');
                checkboxes.forEach(cb => cb.checked = e.target.checked);
                this.updateBulkActions();
            });
        }

        const rowCheckboxes = document.querySelectorAll('[data-select-row]');
        rowCheckboxes.forEach(checkbox => {
            checkbox.addEventListener('change', () => {
                this.updateBulkActions();
            });
        });
    }

    sortTable(table, column) {
        const tbody = table.querySelector('tbody');
        const rows = Array.from(tbody.querySelectorAll('tr'));
        
        const currentSort = table.getAttribute('data-sort-column');
        const currentOrder = table.getAttribute('data-sort-order') || 'asc';
        
        let newOrder = 'asc';
        if (currentSort === column && currentOrder === 'asc') {
            newOrder = 'desc';
        }
        
        rows.sort((a, b) => {
            const aVal = this.getCellValue(a, column);
            const bVal = this.getCellValue(b, column);
            
            if (aVal < bVal) return newOrder === 'asc' ? -1 : 1;
            if (aVal > bVal) return newOrder === 'asc' ? 1 : -1;
            return 0;
        });
        
        rows.forEach(row => tbody.appendChild(row));
        
        table.setAttribute('data-sort-column', column);
        table.setAttribute('data-sort-order', newOrder);
        
        // Update header indicators
        const headers = table.querySelectorAll('[data-sort]');
        headers.forEach(h => h.classList.remove('sort-asc', 'sort-desc'));
        
        const activeHeader = table.querySelector(`[data-sort="${column}"]`);
        if (activeHeader) {
            activeHeader.classList.add(`sort-${newOrder}`);
        }
    }

    getCellValue(row, column) {
        const cell = row.querySelector(`[data-column="${column}"]`);
        if (!cell) return '';
        
        const value = cell.textContent.trim();
        
        // Try to parse as number
        const numValue = parseFloat(value.replace(/[^\d.-]/g, ''));
        if (!isNaN(numValue)) return numValue;
        
        // Try to parse as date
        const dateValue = new Date(value);
        if (!isNaN(dateValue.getTime())) return dateValue.getTime();
        
        return value.toLowerCase();
    }

    updateBulkActions() {
        const checkedBoxes = document.querySelectorAll('[data-select-row]:checked');
        const bulkActions = document.querySelector('.bulk-actions');
        
        if (bulkActions) {
            if (checkedBoxes.length > 0) {
                bulkActions.style.display = 'block';
                const countElement = bulkActions.querySelector('.selected-count');
                if (countElement) {
                    countElement.textContent = checkedBoxes.length;
                }
            } else {
                bulkActions.style.display = 'none';
            }
        }
    }

    // ========== PRODUCT MANAGEMENT ==========
    initProductManagement() {
        // Image upload preview
        this.initImageUpload();
        
        // Product status management
        this.initStatusManagement();
        
        // Stock management
        this.initStockManagement();
        
        // Bulk operations
        this.initBulkOperations();
    }

    initImageUpload() {
        const imageInputs = document.querySelectorAll('input[type="file"][accept*="image"]');
        
        imageInputs.forEach(input => {
            input.addEventListener('change', (e) => {
                const file = e.target.files[0];
                if (file) {
                    this.previewImage(file, input);
                }
            });
        });

        // Drag and drop
        const dropZones = document.querySelectorAll('[data-drop-zone]');
        dropZones.forEach(zone => {
            zone.addEventListener('dragover', (e) => {
                e.preventDefault();
                zone.classList.add('drag-over');
            });
            
            zone.addEventListener('dragleave', () => {
                zone.classList.remove('drag-over');
            });
            
            zone.addEventListener('drop', (e) => {
                e.preventDefault();
                zone.classList.remove('drag-over');
                
                const files = e.dataTransfer.files;
                if (files.length > 0) {
                    const input = zone.querySelector('input[type="file"]');
                    if (input) {
                        input.files = files;
                        this.previewImage(files[0], input);
                    }
                }
            });
        });
    }

    previewImage(file, input) {
        if (!file.type.startsWith('image/')) {
            this.showNotification('Vui lòng chọn file hình ảnh', 'error');
            return;
        }

        if (file.size > 5 * 1024 * 1024) { // 5MB
            this.showNotification('Kích thước file không được vượt quá 5MB', 'error');
            return;
        }

        const reader = new FileReader();
        reader.onload = (e) => {
            const previewContainer = input.closest('.image-upload')?.querySelector('.image-preview');
            if (previewContainer) {
                previewContainer.innerHTML = `
                    <img src="${e.target.result}" alt="Preview" style="max-width: 200px; max-height: 200px; object-fit: cover; border-radius: 4px;">
                    <button type="button" class="remove-image seller-btn seller-btn-sm seller-btn-danger" style="margin-top: 8px;">Xóa ảnh</button>
                `;
                
                const removeBtn = previewContainer.querySelector('.remove-image');
                removeBtn.addEventListener('click', () => {
                    input.value = '';
                    previewContainer.innerHTML = '';
                });
            }
        };
        reader.readAsDataURL(file);
    }

    initStatusManagement() {
        const statusButtons = document.querySelectorAll('[data-action="change-status"]');
        statusButtons.forEach(button => {
            button.addEventListener('click', (e) => {
                e.preventDefault();
                const productId = button.getAttribute('data-product-id');
                const newStatus = button.getAttribute('data-status');
                this.changeProductStatus(productId, newStatus);
            });
        });
    }

    changeProductStatus(productId, status) {
        if (!confirm('Bạn có chắc chắn muốn thay đổi trạng thái sản phẩm?')) {
            return;
        }

        this.showLoading();

        fetch('/seller-product-management', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `action=updateStatus&id=${productId}&status=${status}`
        })
        .then(response => response.text())
        .then(data => {
            this.hideLoading();
            this.showNotification('Cập nhật trạng thái thành công', 'success');
            // Reload page or update UI
            setTimeout(() => window.location.reload(), 1500);
        })
        .catch(error => {
            this.hideLoading();
            this.showNotification('Có lỗi xảy ra khi cập nhật trạng thái', 'error');
            console.error('Error:', error);
        });
    }

    initStockManagement() {
        const stockInputs = document.querySelectorAll('[data-stock-input]');
        stockInputs.forEach(input => {
            const updateBtn = input.nextElementSibling;
            if (updateBtn && updateBtn.hasAttribute('data-update-stock')) {
                updateBtn.addEventListener('click', () => {
                    const productId = updateBtn.getAttribute('data-product-id');
                    const newStock = parseInt(input.value);
                    this.updateProductStock(productId, newStock);
                });
            }
        });
    }

    updateProductStock(productId, stock) {
        if (stock < 0) {
            this.showNotification('Số lượng kho không được âm', 'error');
            return;
        }

        this.showLoading();

        fetch('/seller-product-management', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `action=updateStock&id=${productId}&stock=${stock}`
        })
        .then(response => response.text())
        .then(data => {
            this.hideLoading();
            this.showNotification('Cập nhật số lượng kho thành công', 'success');
        })
        .catch(error => {
            this.hideLoading();
            this.showNotification('Có lỗi xảy ra khi cập nhật kho', 'error');
            console.error('Error:', error);
        });
    }

    initBulkOperations() {
        const bulkButtons = document.querySelectorAll('[data-bulk-action]');
        bulkButtons.forEach(button => {
            button.addEventListener('click', () => {
                const action = button.getAttribute('data-bulk-action');
                const selectedIds = this.getSelectedRowIds();
                
                if (selectedIds.length === 0) {
                    this.showNotification('Vui lòng chọn ít nhất một sản phẩm', 'warning');
                    return;
                }
                
                this.performBulkAction(action, selectedIds);
            });
        });
    }

    getSelectedRowIds() {
        const checkedBoxes = document.querySelectorAll('[data-select-row]:checked');
        return Array.from(checkedBoxes).map(cb => cb.value);
    }

    performBulkAction(action, ids) {
        let confirmMessage = '';
        switch (action) {
            case 'delete':
                confirmMessage = `Bạn có chắc chắn muốn xóa ${ids.length} sản phẩm đã chọn?`;
                break;
            case 'activate':
                confirmMessage = `Bạn có chắc chắn muốn kích hoạt ${ids.length} sản phẩm đã chọn?`;
                break;
            case 'deactivate':
                confirmMessage = `Bạn có chắc chắn muốn tạm ẩn ${ids.length} sản phẩm đã chọn?`;
                break;
            default:
                confirmMessage = `Bạn có chắc chắn muốn thực hiện thao tác này với ${ids.length} sản phẩm?`;
        }

        if (!confirm(confirmMessage)) {
            return;
        }

        this.showLoading();

        fetch('/seller-product-management', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `action=bulk&bulkAction=${action}&ids=${ids.join(',')}`
        })
        .then(response => response.text())
        .then(data => {
            this.hideLoading();
            this.showNotification('Thực hiện thao tác thành công', 'success');
            setTimeout(() => window.location.reload(), 1500);
        })
        .catch(error => {
            this.hideLoading();
            this.showNotification('Có lỗi xảy ra khi thực hiện thao tác', 'error');
            console.error('Error:', error);
        });
    }

    // ========== FILTERS ==========
    initFilters() {
        const filterForm = document.querySelector('.seller-filters form');
        if (filterForm) {
            // Auto-submit on filter change
            const filterInputs = filterForm.querySelectorAll('select, input[type="search"]');
            filterInputs.forEach(input => {
                input.addEventListener('change', () => {
                    filterForm.submit();
                });
            });

            // Reset filters
            const resetBtn = filterForm.querySelector('[data-reset-filters]');
            if (resetBtn) {
                resetBtn.addEventListener('click', (e) => {
                    e.preventDefault();
                    filterInputs.forEach(input => {
                        if (input.type === 'search' || input.type === 'text') {
                            input.value = '';
                        } else {
                            input.selectedIndex = 0;
                        }
                    });
                    filterForm.submit();
                });
            }
        }

        // Search functionality
        const searchInput = document.querySelector('[data-search]');
        if (searchInput) {
            let searchTimeout;
            searchInput.addEventListener('input', () => {
                clearTimeout(searchTimeout);
                searchTimeout = setTimeout(() => {
                    if (searchInput.form) {
                        searchInput.form.submit();
                    }
                }, 500);
            });
        }
    }

    // ========== NOTIFICATIONS ==========
    initNotifications() {
        // Auto-hide existing notifications
        const notifications = document.querySelectorAll('.seller-alert');
        notifications.forEach(notification => {
            setTimeout(() => {
                this.fadeOut(notification);
            }, 5000);
        });
    }

    showNotification(message, type = 'info', duration = 5000) {
        // Remove existing notifications
        const existingNotifications = document.querySelectorAll('.seller-notification');
        existingNotifications.forEach(n => n.remove());

        // Create notification
        const notification = document.createElement('div');
        notification.className = `seller-notification seller-alert seller-alert-${type}`;
        notification.style.cssText = `
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 10000;
            max-width: 400px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            animation: slideInRight 0.3s ease;
        `;
        notification.textContent = message;

        document.body.appendChild(notification);

        // Auto-hide
        setTimeout(() => {
            this.fadeOut(notification);
        }, duration);
    }

    fadeOut(element) {
        element.style.transition = 'opacity 0.3s ease';
        element.style.opacity = '0';
        setTimeout(() => {
            element.remove();
        }, 300);
    }

    // ========== LOADING ==========
    showLoading() {
        let loading = document.querySelector('.seller-loading');
        if (!loading) {
            loading = document.createElement('div');
            loading.className = 'seller-loading';
            loading.innerHTML = '<div class="seller-spinner"></div>';
            document.body.appendChild(loading);
        }
        loading.classList.add('active');
    }

    hideLoading() {
        const loading = document.querySelector('.seller-loading');
        if (loading) {
            loading.classList.remove('active');
        }
    }

    // ========== EVENT BINDING ==========
    bindEvents() {
        // Confirm actions
        document.addEventListener('click', (e) => {
            if (e.target.matches('[data-confirm]')) {
                const message = e.target.getAttribute('data-confirm');
                if (!confirm(message)) {
                    e.preventDefault();
                }
            }
        });

        // Toggle elements
        document.addEventListener('click', (e) => {
            if (e.target.matches('[data-toggle]')) {
                e.preventDefault();
                const targetSelector = e.target.getAttribute('data-toggle');
                const target = document.querySelector(targetSelector);
                if (target) {
                    target.style.display = target.style.display === 'none' ? '' : 'none';
                }
            }
        });

        // Copy to clipboard
        document.addEventListener('click', (e) => {
            if (e.target.matches('[data-copy]')) {
                e.preventDefault();
                const text = e.target.getAttribute('data-copy') || e.target.textContent;
                navigator.clipboard.writeText(text).then(() => {
                    this.showNotification('Đã sao chép vào clipboard', 'success', 2000);
                });
            }
        });

        // Responsive table scroll
        const tables = document.querySelectorAll('.seller-table-container');
        tables.forEach(container => {
            if (container.scrollWidth > container.clientWidth) {
                container.style.overflowX = 'auto';
            }
        });

        // Window resize handler
        let resizeTimeout;
        window.addEventListener('resize', () => {
            clearTimeout(resizeTimeout);
            resizeTimeout = setTimeout(() => {
                this.handleResize();
            }, 250);
        });
    }

    handleResize() {
        const sidebar = document.querySelector('.seller-sidebar');
        const content = document.querySelector('.seller-content');
        
        if (window.innerWidth <= 1024) {
            sidebar?.classList.remove('active');
            content?.classList.add('expanded');
        } else {
            sidebar?.classList.add('active');
            content?.classList.remove('expanded');
        }
    }
}

// ========== UTILITY FUNCTIONS ==========

// Format currency
function formatCurrency(amount, currency = 'VND') {
    return new Intl.NumberFormat('vi-VN', {
        style: 'currency',
        currency: currency
    }).format(amount);
}

// Format date
function formatDate(date, format = 'dd/MM/yyyy') {
    const d = new Date(date);
    const day = String(d.getDate()).padStart(2, '0');
    const month = String(d.getMonth() + 1).padStart(2, '0');
    const year = d.getFullYear();
    
    return format
        .replace('dd', day)
        .replace('MM', month)
        .replace('yyyy', year);
}

// Debounce function
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Throttle function
function throttle(func, limit) {
    let inThrottle;
    return function() {
        const args = arguments;
        const context = this;
        if (!inThrottle) {
            func.apply(context, args);
            inThrottle = true;
            setTimeout(() => inThrottle = false, limit);
        }
    }
}

// ========== ANIMATIONS ==========
const animationStyles = `
@keyframes slideInRight {
    from {
        transform: translateX(100%);
        opacity: 0;
    }
    to {
        transform: translateX(0);
        opacity: 1;
    }
}

@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}

@keyframes slideDown {
    from {
        transform: translateY(-10px);
        opacity: 0;
    }
    to {
        transform: translateY(0);
        opacity: 1;
    }
}
`;

// Inject animation styles
if (!document.querySelector('#seller-animations')) {
    const style = document.createElement('style');
    style.id = 'seller-animations';
    style.textContent = animationStyles;
    document.head.appendChild(style);
}

// ========== INITIALIZATION ==========
document.addEventListener('DOMContentLoaded', () => {
    window.sellerDashboard = new SellerDashboard();
    
    // Show loading for form submissions
    document.querySelectorAll('form').forEach(form => {
        form.addEventListener('submit', () => {
            window.sellerDashboard.showLoading();
        });
    });
    
    // Show loading for navigation
    document.querySelectorAll('a:not([href^="#"]):not([href^="javascript"]):not([target="_blank"])').forEach(link => {
        link.addEventListener('click', () => {
            if (!link.hasAttribute('data-no-loading')) {
                window.sellerDashboard.showLoading();
            }
        });
    });
});

// ========== EXPORT FOR GLOBAL ACCESS ==========
window.SellerUtils = {
    formatCurrency,
    formatDate,
    debounce,
    throttle
};
