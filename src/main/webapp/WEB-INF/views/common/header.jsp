<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${empty pageTitle ? 'RoomRental - Tìm phòng trọ dễ dàng' : pageTitle}"/></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="<c:url value='/css/style.css'/>" rel="stylesheet">
    <c:if test="${not empty pageSpecificCss}">
        <link href="<c:url value='${pageSpecificCss}'/>" rel="stylesheet">
    </c:if>

    <style>
        /* CSS Nút chuông viền tròn xám */
        .notification-bell-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 40px;
            height: 40px;
            border: 2px solid #e0e0e0;
            border-radius: 50%;
            color: #495057;
            position: relative;
            transition: all 0.2s ease;
            background: none;
            padding: 0;
        }

        .notification-bell-btn:hover, .notification-bell-btn:focus {
            background-color: #f8f9fa;
            border-color: #cccccc;
            color: #212529;
        }

        .notification-bell-btn svg {
            width: 22px;
            height: 22px;
        }

        /* Chấm đỏ định vị theo cấu trúc mới */
        #notify-dot {
            position: absolute;
            top: 4px;
            right: 4px;
            width: 9px;
            height: 9px;
            background-color: #dc3545;
            border-radius: 50%;
            border: 1px solid #ffffff;
            display: none;
        }

        /* Tùy chỉnh danh sách thông báo */
        .dropdown-menu-end {
            right: 0;
            left: auto;
        }

        #notification-items {
            max-height: 360px;
            overflow-y: auto;
            padding-left: 0; /* Xóa khoảng trống thụt lề mặc định của ul */
        }

        #notification-items .dropdown-item {
            white-space: normal;
            border-bottom: 1px solid #f1f1f1;
            padding: 10px 15px;
            text-align: left;
        }

        #notification-items li:last-child .dropdown-item {
            border-bottom: none;
        }
    </style>
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
                    <button class="user-dropdown-toggle" onclick="toggleUserDropdown(event)" aria-haspopup="true"
                            aria-expanded="false">
                        <span class="user-avatar">${fn:toUpperCase(fn:substring(sessionScope.currentUser.username, 0, 1))}</span>
                        <span class="user-dropdown-name">Xin chào, <strong>${sessionScope.currentUser.profile.name}</strong></span>
                        <svg class="user-dropdown-caret" width="12" height="12" viewBox="0 0 12 12" fill="none">
                            <path d="M2 4l4 4 4-4" stroke="currentColor" stroke-width="1.8" stroke-linecap="round"
                                  stroke-linejoin="round"/>
                        </svg>
                    </button>
                    <div class="user-dropdown-menu" id="userDropdownMenu">
                        <a class="user-dropdown-item" href="<c:url value='/profile'/>">
                            <span class="user-dropdown-icon">👤</span> Thông tin cá nhân
                        </a>
                        <a class="user-dropdown-item" href="<c:url value='/favorites'/>">
                            <span class="user-dropdown-icon">❤️</span> Phòng đã lưu
                        </a>
                        <c:if test="${sessionScope.currentUser.role == 'LANDLORD'}">
                            <a class="user-dropdown-item" href="<c:url value='/post-management'/>">
                                <span class="user-dropdown-icon">📋</span> Quản lý tin đăng
                            </a>
                        </c:if>
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

        <%-- DROPDOWN CHUÔNG THÔNG BÁO VÀ TIN NHẮN --%>
        <c:if test="${not empty sessionScope.currentUser}">
            <div class="d-flex align-items-center gap-2">
            
            <%-- DROPDOWN TIN NHẮN --%>
            <div class="dropdown">
                <a class="notification-bell-btn"
                   href="#"
                   role="button"
                   data-bs-toggle="dropdown"
                   aria-expanded="false"
                   title="Tin nhắn"
                   onclick="handleChatDropdownClick(event)">
                    <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" class="bi bi-chat-dots" viewBox="0 0 16 16">
                      <path d="M5 8a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm4 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm3 1a1 1 0 1 0 0-2 1 1 0 0 0 0 2z"/>
                      <path d="m2.165 15.803.02-.004c1.83-.363 2.948-.842 3.468-1.105A9.06 9.06 0 0 0 8 15c4.418 0 8-3.134 8-7s-3.582-7-8-7-8 3.134-8 7c0 1.76.743 3.37 1.97 4.6a10.437 10.437 0 0 1-.524 2.318l-.003.011a10.722 10.722 0 0 1-.244.637c-.079.186.074.394.273.362a21.673 21.673 0 0 0 .693-.125zm.8-3.108a1 1 0 0 0-.287-.801C1.618 10.83 1 9.468 1 8c0-3.192 3.004-6 7-6s7 2.808 7 6-3.004 6-7 6a8.06 8.06 0 0 1-2.088-.272 1 1 0 0 0-.711.074c-.387.196-1.24.57-2.634.893a10.97 10.97 0 0 0 .398-2z"/>
                    </svg>
                </a>
                <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2" style="min-width: 320px; width: 350px;" id="chat-dropdown-list">
                    <li><h6 class="dropdown-header">Tin nhắn</h6></li>
                    <li class="p-0">
                        <ul id="chat-contact-items" class="list-unstyled mb-0" style="max-height: 400px; overflow-y: auto;">
                            <li><span class="dropdown-item-text small text-muted">Đang tải...</span></li>
                        </ul>
                    </li>
                </ul>
            </div>
            
            <%-- DROPDOWN CHUÔNG THÔNG BÁO --%>
            <div class="dropdown">
                <a class="notification-bell-btn"
                   href="#"
                   role="button"
                   data-bs-toggle="dropdown"
                   aria-expanded="false"
                   title="Thông báo"
                   onclick="handleBellClick(event)"> <%-- CHỈ tải dữ liệu khi người dùng bấm vào --%>
                    <svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" class="bi bi-bell" viewBox="0 0 16 16">
                        <path d="M8 16a2 2 0 0 0 2-2H6a2 2 0 0 0 2 2M8 1.918l-.797.161A4 4 0 0 0 4 6c0 .628-.134 2.197-.459 3.742-.16.767-.376 1.566-.663 2.258h10.244c-.287-.692-.502-1.49-.663-2.258C12.134 8.197 12 6.628 12 6a4 4 0 0 0-3.203-3.92zM14.22 12c.223.447.481.801.78 1H1c.299-.199.557-.553.78-1C2.68 10.2 3 6.88 3 6c0-2.42 1.72-4.44 4.005-4.901a1 1 0 1 1 1.99 0A5 5 0 0 1 13 6c0 .88.32 4.2 1.22 6"/>
                    </svg>
                    <span id="notify-dot"></span>
                </a>

                <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2" style="min-width: 320px;"
                    id="notification-list">
                    <li><h6 class="dropdown-header">Thông báo</h6></li>
                    <li class="p-0">
                        <ul id="notification-items" class="list-unstyled mb-0">
                            <li>
                                <span class="dropdown-item-text small text-muted">Nhấn để tải thông báo</span>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
            </div>
        </c:if>

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

        document.addEventListener('click', function () {
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.5.1/sockjs.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>

    <c:if test="${not empty sessionScope.currentUser}">
        <script>
            const CONFIG = {
                currentUserId: "${sessionScope.currentUser.id}",
                currentUserRole: "${sessionScope.currentUser.role}",
                apiNotifications: "<c:url value='/notifications/api'/>",
                apiReadNotification: "<c:url value='/notifications/read/'/>",
                wsUrl: "<c:url value='/ws'/>",
                apiChatContacts: "<c:url value='/api/chat/contacts'/>"
            };
        </script>
        <script src="<c:url value='/js/notification.js'/>"></script>
    </c:if>