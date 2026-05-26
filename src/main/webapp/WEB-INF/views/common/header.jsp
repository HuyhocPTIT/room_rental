<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${empty pageTitle ? 'RoomRental - Tìm phòng trọ dễ dàng' : pageTitle}" /></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<c:url value='/css/style.css'/>" rel="stylesheet">
    <c:if test="${not empty pageSpecificCss}">
        <link href="<c:url value='${pageSpecificCss}'/>" rel="stylesheet">
    </c:if>
</head>
<body class="${empty bodyClass ? '' : bodyClass}">
<nav class="site-nav">
    <a class="site-logo" href="<c:url value='/'/>">Trọ<span>Tốt</span></a>
    <ul class="site-nav-links">
        <li><a href="<c:url value='/'/>">Tìm phòng</a></li>
        <li><a href="<c:url value='/'/>#featured-rooms">Phòng nổi bật</a></li>
        <li><a href="<c:url value='/'/>#features">Tiện ích</a></li>
        <li><a href="<c:url value='/'/>#contact">Liên hệ</a></li>
    </ul>
    <div class="site-nav-actions">
        <c:choose>
            <c:when test="${not empty sessionScope.currentUser}">
                <%-- User dropdown --%>
                <div class="user-dropdown" id="userDropdown">
                    <button class="user-dropdown-toggle" onclick="toggleUserDropdown(event)" aria-haspopup="true" aria-expanded="false">
                        <span class="user-avatar">${fn:toUpperCase(fn:substring(sessionScope.currentUser.username, 0, 1))}</span>
                        <span class="user-dropdown-name">Xin chào, <strong>${sessionScope.currentUser.username}</strong></span>
                        <svg class="user-dropdown-caret" width="12" height="12" viewBox="0 0 12 12" fill="none">
                            <path d="M2 4l4 4 4-4" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                    </button>
                    <div class="user-dropdown-menu" id="userDropdownMenu">
                        <a class="user-dropdown-item" href="<c:url value='/profile'/>">
                            <span class="user-dropdown-icon">👤</span> Thông tin cá nhân
                        </a>
                        <a class="user-dropdown-item" href="<c:url value='/favorites'/>">
                            <span class="user-dropdown-icon">❤️</span> Phòng đã lưu
                        </a>
                        <a class="user-dropdown-item" href="<c:url value='/post-management'/>">
                            <span class="user-dropdown-icon">📋</span> Quản lý tin đăng
                        </a>
                        <div class="user-dropdown-divider"></div>
                        <form action="<c:url value='/auth/logout'/>" method="post" class="m-0">
                            <button type="submit" class="user-dropdown-item user-dropdown-logout">
                                <span class="user-dropdown-icon">🚪</span> Đăng xuất
                            </button>
                        </form>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <a class="site-btn site-btn-outline" href="<c:url value='/auth/login'/>">Đăng nhập</a>
                <a class="site-btn" href="<c:url value='/auth/register'/>">Đăng ký</a>
            </c:otherwise>
        </c:choose>
        <a class="site-btn site-btn-pink" href="<c:url value='/post-management?action=create'/>">Đăng tin</a>
    </div>

    <script>
        function toggleUserDropdown(e) {
            e.stopPropagation();
            var menu = document.getElementById('userDropdownMenu');
            var btn = e.currentTarget;
            var isOpen = menu.classList.toggle('open');
            btn.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
        }
        document.addEventListener('click', function() {
            var menu = document.getElementById('userDropdownMenu');
            if (menu) {
                menu.classList.remove('open');
                var btn = document.querySelector('.user-dropdown-toggle');
                if (btn) btn.setAttribute('aria-expanded', 'false');
            }
        });
    </script>
</nav>
<main class="${empty mainClass ? 'container my-4' : mainClass}">