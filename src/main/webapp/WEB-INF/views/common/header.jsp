<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${empty pageTitle ? 'RoomRental - Tìm phòng trọ dễ dàng' : pageTitle}" /></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<c:url value='/css/style.css'/>" rel="stylesheet">
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
    <div class="site-nav-actions" style="display: flex; align-items: center; gap: 12px;">
        <a href="<c:url value='/favorites'/>" style="text-decoration: none; font-weight: 500; color: #333;">
            ❤️ Phòng đã lưu
        </a>
        <c:choose>
            <c:when test="${not empty sessionScope.currentUser}">
                <span class="site-user">Xin chào, <strong>${sessionScope.currentUser.username}</strong></span>
                <form action="<c:url value='/auth/logout'/>" method="post" class="m-0">
                    <button type="submit" class="site-btn site-btn-outline">Đăng xuất</button>
                </form>
            </c:when>
            <c:otherwise>
                <a class="site-btn site-btn-outline" href="<c:url value='/auth/login'/>">Đăng nhập</a>
                <a class="site-btn" href="<c:url value='/auth/register'/>">Đăng ký</a>
            </c:otherwise>
        </c:choose>
        <a class="site-btn" href="<c:url value='/post-room'/>" style="background-color: #ff385c; border-color: #ff385c; color: white;">Đăng tin</a>
    </div>
</nav>
<main class="${empty mainClass ? 'container my-4' : mainClass}">