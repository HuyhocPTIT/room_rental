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
                        <span class="user-dropdown-name">Xin chào, <strong>${sessionScope.currentUser.username}</strong></span>
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

        <%-- DROPDOWN CHUÔNG THÔNG BÁO --%>
        <c:if test="${not empty sessionScope.currentUser}">
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

    <script>
        var currentUserId = "${sessionScope.currentUser.id}";
        let loadedNotification = false;

        // ==========================================
        // 1. HÀM KIỂM TRA SỰ KIỆN CLICK CHUÔNG
        // ==========================================
        function handleBellClick(event) {
            event.preventDefault();
            console.log("%c[1. CLICK] -> Người dùng vừa click vào chuông thông báo!", "color: #007bff; font-weight: bold;");

            // Gọi hàm load dữ liệu
            loadNotifications();

            const bellBtn = event.currentTarget;

            // Kiểm tra thư viện Bootstrap
            if (typeof bootstrap === 'undefined') {
                console.error("[LỖI NGHIÊM TRỌNG] -> Thư viện Bootstrap chưa được tải. Không thể mở Dropdown!");
                alert("Lỗi: Thư viện Bootstrap chưa được tải!");
                return;
            }
            console.log("[2. BOOTSTRAP] -> Thư viện Bootstrap OK. Tiến hành kiểm tra cấu trúc đối tượng...");

            // Khởi tạo/Lấy Dropdown Instance bằng API Javascript của Bootstrap
            let dropdownInstance = bootstrap.Dropdown.getInstance(bellBtn);
            if (!dropdownInstance) {
                console.log("[3. INSTANCE] -> Chưa có instance Dropdown cũ, tiến hành khởi tạo thủ công.");
                dropdownInstance = new bootstrap.Dropdown(bellBtn);
            } else {
                console.log("[3. INSTANCE] -> Tìm thấy đối tượng Dropdown cũ đang tồn tại.");
            }

            // Ép dropdown bật/tắt công khai
            console.log("[4. TOGGLE] -> Thực hiện lệnh ép Dropdown hiển thị (dropdownInstance.toggle()).");
            dropdownInstance.toggle();
        }

        // ==========================================
        // 2. HÀM TẢI DỮ LIỆU THÔNG BÁO (AJAX)
        // ==========================================
        function loadNotifications() {
            console.log("[5. LOAD DATA] -> Bắt đầu hàm loadNotifications(). Trạng thái loadedNotification = " + loadedNotification);

            if (loadedNotification) {
                console.log("[-> THÔNG BÁO] -> Dữ liệu đã load trước đó rồi, không gọi API nữa.");
                return;
            }

            const itemsContainer = document.getElementById("notification-items");
            if (!itemsContainer) {
                console.error("[LỖI THIẾT KẾ] -> Không tìm thấy thẻ HTML có id='notification-items'!");
                return;
            }

            itemsContainer.innerHTML = '<li><span class="dropdown-item-text small text-muted">Đang tải...</span></li>';
            console.log("[6. FETCH API] -> Đang gửi request lên: <c:url value='/notifications/api'/>");

            fetch("<c:url value='/notifications/api'/>")
                .then(res => {
                    console.log("[7. RESPONSE] -> Trạng thái HTTP từ API trả về: " + res.status);
                    if (!res.ok) throw new Error("Lỗi HTTP Status: " + res.status);
                    return res.json();
                })
                .then(data => {
                    console.log("[8. DATA RECEIVED] -> Dữ liệu mảng JSON nhận từ API:", data);

                    const hasUnread = data.some(item => !item.read);
                    console.log("[9. CHECK DOT] -> Có thông báo chưa đọc không? -> " + hasUnread);
                    if (hasUnread) showNotificationDot(); else hideNotificationDot();

                    let html = '';

                    if (data.length === 0) {
                        html = '<li><span class="dropdown-item-text small text-muted">Không có thông báo nào</span></li>';
                    } else {
                        data.forEach(item => {
                            let content = item.content;
                            if (item.type === "CHAT") content = item.senderName + " đã gửi cho bạn tin nhắn";
                            if (item.type === "UPGRADE_TO_LANDLORD") content = "Tài khoản của bạn đã được nâng cấp thành chủ thuê";
                            if (item.type === "POST_APPROVED") content = "Bài đăng của bạn đã được duyệt";

                            html += '<li>' +
                                '  <button type="button" class="dropdown-item small text-wrap d-flex justify-content-between align-items-center ' + (!item.read ? 'fw-bold bg-light' : '') + '" ' +
                                '  onclick="handleNotificationClick(' + item.id + ', this' + (item.type === "CHAT" ? ', function(){ if(typeof openChat === \'function\'){ openChat(' + item.senderId + ', \'' + item.senderName + '\'); } }' : '') + ')">' +
                                '    <span>' + content + '</span>' +
                                (!item.read ? '<span id="unread-dot-' + item.id + '" class="ms-2 rounded-circle bg-primary" style="width:7px;height:7px;display:inline-block;flex-shrink:0;"></span>' : '') +
                                '</button>' +
                                '</li>';
                        });
                    }

                    itemsContainer.innerHTML = html;
                    loadedNotification = true;
                    console.log("[10. RENDER DONE] -> Đã render xong giao diện thông báo và khóa cờ loadedNotification = true.");
                })
                .catch(err => {
                    console.error("[LỖI FETCH] -> Không thể lấy dữ liệu từ API thông báo:", err);
                    itemsContainer.innerHTML = '<li><span class="dropdown-item-text text-danger small">Không tải được thông báo</span></li>';
                });
        }

        function showNotificationDot() {
            const dot = document.getElementById("notify-dot");
            if (dot) dot.style.display = "block";
        }

        function hideNotificationDot() {
            const dot = document.getElementById("notify-dot");
            if (dot) dot.style.display = "none";
        }

        function handleNotificationClick(notificationId, element, callback = null) {
            console.log("[CLICK ITEM] -> Người dùng click đọc thông báo ID: " + notificationId);
            fetch("<c:url value='/notifications/read/'/>" + notificationId, { method: 'POST' });

            element.classList.remove('fw-bold', 'bg-light');
            const dot = document.getElementById('unread-dot-' + notificationId);
            if (dot) dot.remove();

            const remainingDots = document.querySelectorAll('[id^="unread-dot-"]');
            if (remainingDots.length === 0) hideNotificationDot();
            if (callback) callback();
        }

        // ==========================================
        // 3. KHỞI TẠO BAN ĐẦU KHI LOAD TRANG
        // ==========================================
        document.addEventListener("DOMContentLoaded", function () {
            console.log("%c[START] -> Trang đã tải xong (DOMContentLoaded). Tiến hành chạy ngầm...", "color: green; font-weight: bold;");
            connectNotificationSocket();
            checkInitialUnreadNotifications();
        });

        let notificationStompClient = null;

        function connectNotificationSocket() {
            if (!currentUserId || currentUserId === "null" || currentUserId === "") {
                console.warn("[WEBSOCKET] -> Không tìm thấy userId hợp lệ. Hủy kết nối Socket.");
                return;
            }

            const socket = new SockJS("<c:url value='/ws'/>");
            notificationStompClient = Stomp.over(socket);
            notificationStompClient.debug = null;

            notificationStompClient.connect({}, function () {
                console.log("[WEBSOCKET] -> Đã kết nối thành công tới máy chủ Realtime!");

                // KÊNH 1: Kênh tập trung nhận TẤT CẢ các loại thông báo hiển thị lên chuông (Bao gồm cả thông báo CHAT)
                notificationStompClient.subscribe('/user/queue/notifications', function (message) {
                    console.log("[WEBSOCKET] -> Nhận thông báo hệ thống chính thức:", message.body);
                    loadedNotification = false; // Reset cờ để tải lại khi click chuông
                    receiveRealtimeNotification(JSON.parse(message.body));
                });

                // KÊNH 2: Chỉ phục vụ cập nhật UI bên trong hộp thoại Chat
                notificationStompClient.subscribe('/topic/messages/' + currentUserId, function (messageOutput) {
                    const msg = JSON.parse(messageOutput.body);

                    showNotificationDot();

                    // Kiểm tra xem người dùng hiện tại có đang mở khung chat với ĐÚNG người gửi này không
                    const chatBox = document.getElementById('chat-box');
                    const activeChatId = chatBox ? chatBox.getAttribute('data-receiver-id') : null;

                    if (chatBox && chatBox.style.display === 'flex' && String(msg.senderId) === String(activeChatId)) {
                        console.log("[WEBSOCKET] -> Người dùng đang mở khung chat. Đóng góp tin nhắn trực tiếp vào UI chat.");
                        // LƯU Ý: Nếu trang của bạn có hàm render tin nhắn trực tiếp vào hộp thoại (ví dụ: appendMessageToChatBox), hãy gọi nó ở đây.
                        if (typeof appendRealtimeMessage === 'function') {
                            appendRealtimeMessage(msg);
                        }
                    } else {
                        // BỎ HOÀN TOÀN: Không gọi hàm receiveRealtimeNotification ở đây nữa!
                        // Vì Server đã tự động bắn 1 bản ghi Notification sang Kênh 1 (/user/queue/notifications) ở trên rồi.
                        console.log("[WEBSOCKET] -> Khung chat đang đóng hoặc chat với người khác. Bỏ qua, đợi kênh notification xử lý để tránh nhân đôi.");
                    }
                });
            });
        }

        function receiveRealtimeNotification(item) {
            console.log("[WEBSOCKET] -> Nhận được 1 thông báo mới trong thời gian thực:", item);
            showNotificationDot();
            const itemsContainer = document.getElementById("notification-items");
            if (!itemsContainer) return;

            if (document.getElementById('unread-dot-' + item.id)) return;
            if (itemsContainer.innerHTML.includes("text-muted") || itemsContainer.innerHTML.includes("Không có thông báo")) {
                itemsContainer.innerHTML = '';
            }

            let content = item.content;
            if (item.type === "CHAT") content = item.senderName + " đã gửi cho bạn tin nhắn";
            if (item.type === "UPGRADE_TO_LANDLORD") content = "Tài khoản của bạn đã được nâng cấp thành chủ thuê";
            if (item.type === "POST_APPROVED") content = "Bài đăng của bạn đã được duyệt";

            let html = '<li>' +
                '  <button type="button" class="dropdown-item small text-wrap d-flex justify-content-between align-items-center fw-bold bg-light" ' +
                '  onclick="handleNotificationClick(' + item.id + ', this' + (item.type === "CHAT" ? ', function(){ if(typeof openChat === \'function\'){ openChat(' + item.senderId + ', \'' + item.senderName + '\'); } }' : '') + ')">' +
                '    <span>' + content + '</span>' +
                '    <span id="unread-dot-' + item.id + '" class="ms-2 rounded-circle bg-primary" style="width:7px;height:7px;display:inline-block;flex-shrink:0;"></span>' +
                '</button>' +
                '</li>';

            itemsContainer.insertAdjacentHTML('afterbegin', html);
        }

        function checkInitialUnreadNotifications() {
            if (!currentUserId || currentUserId === "null" || currentUserId === "") return;
            console.log("[INIT CHECK] -> Đang kiểm tra ngầm trạng thái chấm đỏ từ DB...");

            fetch("<c:url value='/notifications/api'/>")
                .then(res => res.json())
                .then(data => {
                    const hasUnread = data.some(item => item.read === false);
                    console.log("[INIT CHECK RESULT] -> Kết quả check chấm đỏ: " + hasUnread);
                    if (hasUnread) showNotificationDot(); else hideNotificationDot();
                })
                .catch(err => console.error("[INIT CHECK ERROR] -> Lỗi check chấm đỏ:", err));
        }
    </script>
</main>