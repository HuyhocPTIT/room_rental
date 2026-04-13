<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hệ thống quản lý phòng trọ sinh viên</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<c:url value='/css/style.css'/>" rel="stylesheet">
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light bg-light shadow-sm">
    <div class="container">
        <a class="navbar-brand fw-bold text-primary" href="<c:url value='/'/>">RoomRental</a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav"
                aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto">
                <li class="nav-item">
                    <a class="nav-link active" href="<c:url value='/'/>">Trang chủ</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="<c:url value='/rooms'/>">Phòng mới đăng</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#search-section">Tìm kiếm</a>
                </li>
            </ul>

            <c:choose>
                <c:when test="${not empty sessionScope.currentUser}">
                    <div class="d-flex align-items-center gap-3">
                        <span class="text-secondary">
                            Xin chào, <strong>${sessionScope.currentUser.username}</strong>
                        </span>
                        <form action="<c:url value='/auth/logout'/>" method="post" class="mb-0">
                            <button type="submit" class="btn btn-outline-danger">Đăng xuất</button>
                        </form>
                    </div>
                </c:when>
                <c:otherwise>
                    <ul class="navbar-nav">
                        <li class="nav-item me-2">
                            <a class="btn btn-outline-primary" href="<c:url value='/auth/login'/>">Đăng nhập</a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-primary" href="<c:url value='/auth/register'/>">Đăng ký</a>
                        </li>
                    </ul>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</nav>

<main class="container my-4">
