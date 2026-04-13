<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="../common/header.jsp" />

<div class="row justify-content-center">
    <div class="col-md-6 col-lg-5">
        <div class="card shadow-sm border-0">
            <div class="card-body p-4">
                <h1 class="h3 mb-3 text-center">Đăng nhập</h1>
                <p class="text-muted text-center mb-4">Truy cập tài khoản để quản lý phòng trọ và danh sách yêu thích của bạn.</p>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger" role="alert">
                        ${error}
                    </div>
                </c:if>

                <form action="<c:url value='/auth/login'/>" method="post">
                    <div class="mb-3">
                        <label for="username" class="form-label">Tên đăng nhập</label>
                        <input type="text"
                               class="form-control"
                               id="username"
                               name="username"
                               value="${loginRequest.username}"
                               placeholder="Nhập tên đăng nhập"
                               required>
                    </div>

                    <div class="mb-4">
                        <label for="password" class="form-label">Mật khẩu</label>
                        <input type="password"
                               class="form-control"
                               id="password"
                               name="password"
                               placeholder="Nhập mật khẩu"
                               required>
                    </div>

                    <button type="submit" class="btn btn-primary w-100">Đăng nhập</button>
                </form>

                <p class="text-center mt-4 mb-0">
                    Chưa có tài khoản?
                    <a href="<c:url value='/auth/register'/>">Đăng ký ngay</a>
                </p>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
