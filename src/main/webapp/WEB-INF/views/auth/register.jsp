<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../common/header.jsp" />

<div class="row justify-content-center">
    <div class="col-lg-7">
        <div class="card shadow-sm border-0">
            <div class="card-body p-4 p-lg-5">
                <h1 class="h3 mb-3 text-center">Đăng ký tài khoản</h1>
                <p class="text-muted text-center mb-4">Tạo tài khoản mới để bắt đầu sử dụng hệ thống phòng trọ.</p>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        ${error}
                    </div>
                </c:if>

                <form action="<c:url value='/auth/register'/>" method="post" class="row g-3">
                    <div class="col-md-6">
                        <label for="username" class="form-label">Tên đăng nhập</label>
                        <input type="text"
                               class="form-control"
                               id="username"
                               name="username"
                               value="${registerRequest.username}"
                               placeholder="Nhập tên đăng nhập"
                               required>
                    </div>

                    <div class="col-md-6">
                        <label for="fullName" class="form-label">Họ và tên</label>
                        <input type="text"
                               class="form-control"
                               id="fullName"
                               name="fullName"
                               value="${registerRequest.fullName}"
                               placeholder="Nguyễn Văn A">
                    </div>

                    <div class="col-md-6">
                        <label for="email" class="form-label">Email</label>
                        <input type="email"
                               class="form-control"
                               id="email"
                               name="email"
                               value="${registerRequest.email}"
                               placeholder="ban@example.com">
                    </div>

                    <div class="col-md-6">
                        <label for="phoneNumber" class="form-label">Số điện thoại</label>
                        <input type="text"
                               class="form-control"
                               id="phoneNumber"
                               name="phoneNumber"
                               value="${registerRequest.phoneNumber}"
                               placeholder="09xxxxxxxx">
                    </div>

                    <div class="col-md-6">
                        <label for="password" class="form-label">Mật khẩu</label>
                        <input type="password"
                               class="form-control"
                               id="password"
                               name="password"
                               placeholder="Tối thiểu 6 ký tự"
                               required>
                    </div>

                    <div class="col-md-6">
                        <label for="confirmPassword" class="form-label">Xác nhận mật khẩu</label>
                        <input type="password"
                               class="form-control"
                               id="confirmPassword"
                               name="confirmPassword"
                               placeholder="Nhập lại mật khẩu"
                               required>
                    </div>

                    <div class="col-12">
                        <button type="submit" class="btn btn-primary w-100">Đăng ký</button>
                    </div>
                </form>

                <p class="text-center mt-4 mb-0">
                    Đã có tài khoản?
                    <a href="<c:url value='/auth/login'/>">Đăng nhập</a>
                </p>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
