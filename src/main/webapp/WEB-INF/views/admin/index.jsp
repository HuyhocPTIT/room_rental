<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../common/header.jsp" />

<div class="row justify-content-center">
    <div class="col-lg-8">
        <div class="card shadow-sm border-0">
            <div class="card-body p-4 p-lg-5">
                <span class="badge text-bg-danger mb-3">ADMIN</span>
                <h1 class="h3 mb-3">Trang quản trị</h1>
                <p class="text-muted mb-4">
                    Bạn đang đăng nhập bằng tài khoản quản trị:
                    <strong>${currentUser.username}</strong>
                </p>

                <div class="row g-3">
                    <div class="col-md-4">
                        <div class="border rounded p-3 h-100">
                            <h2 class="h6">Quản lý người dùng</h2>
                            <p class="mb-0 text-muted">Thêm, sửa hoặc khóa tài khoản người dùng.</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="border rounded p-3 h-100">
                            <h2 class="h6">Quản lý bài đăng</h2>
                            <p class="mb-0 text-muted">Kiểm duyệt các bài đăng phòng trọ trong hệ thống.</p>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="border rounded p-3 h-100">
                            <h2 class="h6">Thống kê</h2>
                            <p class="mb-0 text-muted">Theo dõi hoạt động và số liệu tổng quan của website.</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
