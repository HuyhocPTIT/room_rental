<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="${roomDetail.title} - TrọTốt" scope="request"/>
<c:set var="bodyClass" value="room-detail-page" scope="request"/>
<c:set var="mainClass" value="room-detail-main" scope="request"/>
<c:set var="pageSpecificCss" value="/css/room-detail.css" scope="request"/>

<script src="https://cdn.jsdelivr.net/npm/sockjs-client@1/dist/sockjs.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/stompjs@2.3.3/lib/stomp.min.js"></script>

<jsp:include page="../common/header.jsp"/>

<div class="room-detail-container">
    <div class="room-detail-content">
        <!-- Room Images Section -->
        <section class="room-images-section">
            <div class="images-container">
                <c:choose>
                    <c:when test="${not empty roomDetail.roomImages}">
                        <div class="main-image-wrapper">
                            <img id="mainImage" src="${roomDetail.roomImages[0]}" alt="${roomDetail.title}"
                                 class="main-image">
                        </div>
                        <c:if test="${roomDetail.roomImages.size() > 1}">
                            <div class="thumbnails-wrapper">
                                <c:forEach var="image" items="${roomDetail.roomImages}" varStatus="status">
                                    <img src="${image}" alt="Hình ${status.index + 1}"
                                         class="thumbnail ${status.index == 0 ? 'active' : ''}"
                                         onclick="changeMainImage(this)">
                                </c:forEach>
                            </div>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        <div class="main-image-wrapper">
                            <div style="width: 100%; height: 500px; display: flex; align-items: center; justify-content: center; background-color: #f8f9fa; font-weight: bold; color: #adb5bd;">
                                KHÔNG CÓ HÌNH ẢNH
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <!-- Room Info Section -->
        <section class="room-info-section">
            <div class="room-header">
                <div class="room-title-group">
                    <h1 class="room-title">${roomDetail.title}</h1>
                    <div class="room-address">
                        📍 ${roomDetail.address}
                        <c:if test="${not empty roomDetail.ward}">
                            , ${roomDetail.ward}, ${roomDetail.district}, ${roomDetail.city}
                        </c:if>
                    </div>
                </div>
                <div class="room-actions">
                    <button class="action-btn favorite-btn${roomDetail.favorite ? ' favorited' : ''}"
                            onclick="toggleFavorite(event, ${roomDetail.id})">
                        <span class="heart-icon" id="favoriteIcon">
                            <c:choose>
                                <c:when test="${roomDetail.favorite}">❤️</c:when>
                                <c:otherwise>♡</c:otherwise>
                            </c:choose>
                        </span>
                        <span class="favorite-text" id="favoriteText">
                            <c:choose>
                                <c:when test="${roomDetail.favorite}">Đã lưu</c:when>
                                <c:otherwise>Lưu phòng</c:otherwise>
                            </c:choose>
                        </span>
                    </button>
                </div>
            </div>

            <div class="room-price-info">
                <div class="price-main">
                    <fmt:formatNumber value="${roomDetail.price}" type="number" groupingUsed="true"/> đ/tháng
                </div>
                <div class="room-specs">
                    <span class="spec-item">📐 ${roomDetail.area} m²</span>
<%--                    <span class="spec-item">🏷️ ${roomDetail.category}</span>--%>
                    <span class="spec-item">🏷️
                        <c:choose>
                            <c:when test="${roomDetail.category == 'APARTMENT'}">Chung cư</c:when>
                            <c:when test="${roomDetail.category == 'MINI_APARTMENT'}">Căn hộ mini</c:when>
                            <c:when test="${roomDetail.category == 'WHOLE_HOUSE'}">Nguyên căn</c:when>
                            <c:otherwise>Phòng trọ</c:otherwise>
                        </c:choose>
                    </span>

                </div>
            </div>

            <!-- Room Description -->
            <div class="room-description">
                <h2>Mô tả chi tiết</h2>
                <p>${roomDetail.description}</p>
            </div>

            <c:set var="fullLocation" value="${roomDetail.address}, ${roomDetail.ward}, ${roomDetail.district}, ${roomDetail.city}" />
            <c:set var="mapQuery" value="${fn:replace(fullLocation, ' ', '+')}" />

            <div class="location-section">
                <h2>Vị trí & bản đồ</h2>
                <div class="location-summary">
                    <div class="location-text">
                        <span class="location-label">Địa chỉ:</span>
                        <span class="location-address">📍 ${roomDetail.address}
                            <c:if test="${not empty roomDetail.ward}">, ${roomDetail.ward}</c:if>
                            <c:if test="${not empty roomDetail.district}">, ${roomDetail.district}</c:if>
                            <c:if test="${not empty roomDetail.city}">, ${roomDetail.city}</c:if>
                        </span>
                    </div>
                    <a class="map-link" href="https://maps.google.com/maps?q=${mapQuery}" target="_blank" rel="noopener">Xem bản đồ lớn</a>
                </div>
                <div class="map-frame">
                    <iframe
                            src="https://maps.google.com/maps?q=${mapQuery}&t=&z=15&ie=UTF8&iwloc=&output=embed"
                            allowfullscreen=""
                            loading="lazy"></iframe>
                </div>
            </div>

            <!-- Contact Info -->
            <div class="contact-info">
                <h2>Thông tin liên hệ</h2>
                <div class="contact-section">
                    <div class="contact-item">
                        <label>Điện thoại:</label>
                        <span><a href="tel:${roomDetail.phoneContact}"
                                 class="contact-link">${roomDetail.phoneContact}</a></span>
                    </div>
                    <div class="contact-item">
                        <label>Zalo:</label>
                        <span>
                            <c:choose>
                                <c:when test="${not empty roomDetail.zaloContact}">
                                    <a href="https://zalo.me/${roomDetail.zaloContact}" target="_blank"
                                       class="contact-link">${roomDetail.zaloContact}</a>
                                </c:when>
                                <c:otherwise>
                                    Không có
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
            </div>

            <!-- Owner Info -->
            <div class="owner-info-section">
                <h2>Thông tin chủ trọ</h2>
                <div class="owner-card">
                    <div class="owner-avatar">
                        <c:choose>
                            <c:when test="${not empty roomDetail.ownerAvatar}">
                                <img src="${roomDetail.ownerAvatar}" alt="${roomDetail.ownerName}">
                            </c:when>
                            <c:otherwise>
                                <div class="avatar-placeholder">👤</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="owner-details">
                        <h3 class="owner-name">${roomDetail.ownerName}</h3>
                        <p class="owner-email">📧 ${roomDetail.ownerEmail}</p>
                        <p class="owner-phone">📱 <a href="tel:${roomDetail.ownerPhone}"
                                                    class="contact-link">${roomDetail.ownerPhone}</a></p>
                    </div>
                </div>
            </div>

        </section>
    </div>

    <!-- Sidebar -->
    <aside class="room-sidebar">
        <div class="sidebar-sticky">
            <div class="sidebar-card">
                <div class="card-title">Thông tin nhanh</div>
                <div class="card-content">
                    <div class="info-row">
                        <span class="label">Giá:</span>
                        <span class="value"><fmt:formatNumber value="${roomDetail.price}" type="number"
                                                              groupingUsed="true"/> đ/tháng</span>
                    </div>
                    <div class="info-row">
                        <span class="label">Diện tích:</span>
                        <span class="value">${roomDetail.area} m²</span>
                    </div>
                    <div class="info-row">
                        <span class="label">Loại phòng:</span>
                        <span class="value">
                            <c:choose>
                                <c:when test="${roomDetail.category == 'APARTMENT'}">Chung cư</c:when>
                                <c:when test="${roomDetail.category == 'MINI_APARTMENT'}">Căn hộ mini</c:when>
                                <c:when test="${roomDetail.category == 'WHOLE_HOUSE'}">Nguyên căn</c:when>
                                <c:otherwise>Phòng trọ</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="info-row">
                        <span class="label">Đăng lúc:</span>
                        <span class="value">${roomDetail.createdAt}</span>
                    </div>
                </div>
            </div>

            <div class="sidebar-actions">
                <button class="action-btn primary-btn" onclick="window.location.href='tel:${roomDetail.phoneContact}'">
                    📞 Gọi chủ trọ
                </button>
                <button class="action-btn secondary-btn" onclick="copyToClipboard('${roomDetail.phoneContact}')">
                    📋 Copy số điện thoại
                </button>
                <c:if test="${not empty roomDetail.zaloContact}">
                    <a href="https://zalo.me/${roomDetail.zaloContact}" target="_blank"
                       class="action-btn secondary-btn">
                        💬 Chat Zalo
                    </a>
                </c:if>
                <button class="action-btn secondary-btn"
                        onclick="openChat('${roomDetail.ownerId}', '${roomDetail.ownerName}')">
                    💬 Nhắn tin
                </button>
            </div>
        </div>
    </aside>
</div>

<script>
    function changeMainImage(thumbnail) {
        const mainImage = document.getElementById('mainImage');
        mainImage.src = thumbnail.src;

        document.querySelectorAll('.thumbnail').forEach(thumb => {
            thumb.classList.remove('active');
        });
        thumbnail.classList.add('active');
    }

    function toggleFavorite(event, roomId) {
        const btn = event.currentTarget;
        const icon = document.getElementById('favoriteIcon');
        const text = document.getElementById('favoriteText');
        const isFavorited = btn.classList.contains('favorited');

        if (!isFavorited) {
            fetch('/room/' + roomId + '/favorite/add', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        icon.textContent = '❤️';
                        text.textContent = 'Đã lưu';
                        btn.classList.add('favorited');
                    }
                    alert(data.message);
                })
                .catch(err => {
                    console.error(err);
                    alert('Lỗi mạng, vui lòng thử lại.');
                });
        } else {
            fetch('/room/' + roomId + '/favorite/remove', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                }
            })
                .then(res => res.json())
                .then(data => {
                    if (data.success) {
                        icon.textContent = '♡';
                        text.textContent = 'Lưu phòng';
                        btn.classList.remove('favorited');
                    }
                    alert(data.message);
                })
                .catch(err => {
                    console.error(err);
                    alert('Lỗi mạng, vui lòng thử lại.');
                });
        }
    }

    function copyToClipboard(text) {
        navigator.clipboard.writeText(text).then(() => {
            alert('Đã copy số điện thoại');
        });
    }
</script>

<div id="chat-box"
     style="display:none;
     position:fixed;
     bottom:20px;
     right:20px;
     width:340px;
     height:460px;
     z-index:2000;
     font-family: system-ui;
     border-radius:14px;
     overflow:hidden;
     box-shadow: 0 8px 24px rgba(0,0,0,0.2);
     flex-direction:column;
     background:#fff;">

    <div style="
    background: linear-gradient(135deg,#198754,#20c997);
    color:white;
    padding:10px 12px;
    display:flex;
    justify-content:space-between;
    align-items:center;">
        <h6 id="chat-title" style="margin:0;font-weight:600;">💬 Chat</h6>
        <button onclick="closeChat()"
                style="background:transparent;border:none;color:white;font-size:18px;cursor:pointer;">
            ✕
        </button>
    </div>

    <div id="message-container"
         style="
     flex:1;
     overflow-y:auto;
     padding:12px;
     background:#f6f7fb;">
    </div>

    <div style="padding:8px;border-top:1px solid #eee;background:#fff;">
        <div style="display:flex;gap:6px;">
            <input type="text" id="chat-input"
                   style="
                   flex:1;
                   border:1px solid #d1e7dd;
                   border-radius:18px;
                   padding:7px 10px;
                   font-size:13px;
                   outline:none;"
                   placeholder="Nhập tin nhắn...">

            <button onclick="sendMessage()"
                    style="
                background:#198754;
                color:white;
                border:none;
                width:34px;
                height:34px;
                border-radius:50%;
                font-size:20px;">
                ➤
            </button>
        </div>
    </div>

</div>

<script>
    var stompClient = null;
    var currentUserId = "${not empty sessionScope.currentUser ? sessionScope.currentUser.id : ''}";

    window.onload = function () {
        if (currentUserId) connectWebSocket();
    };

    function connectWebSocket() {
        var socket = new SockJS('/ws');
        stompClient = Stomp.over(socket);
        stompClient.debug = null;

        stompClient.connect({}, function () {
            stompClient.subscribe('/topic/messages/' + currentUserId, function (msgOutput) {
                const msg = JSON.parse(msgOutput.body);

                const chatBox = document.getElementById('chat-box');
                const receiverId = chatBox.getAttribute('data-receiver-id');

                const isFromCurrentChat =
                    String(msg.senderId) === String(receiverId);

                if (chatBox.style.display === 'flex' && isFromCurrentChat) {
                    appendMessage(msg, 'receiver');
                }
            });
        });
    }

    function openChat(receiverId, receiverName) {

        if (!currentUserId) {
            alert("Bạn cần đăng nhập!");
            return;
        }

        if (String(currentUserId) === String(receiverId)) return;

        const chatBox = document.getElementById('chat-box');
        chatBox.style.display = 'flex';
        chatBox.setAttribute('data-receiver-id', receiverId);

        document.getElementById('chat-title').innerText =
            "Chat với " + receiverName;

        document.getElementById('message-container').innerHTML =
            '<div class="text-muted text-center">Đang tải...</div>';

        fetch('/api/chat/history?senderId=' + currentUserId + '&receiverId=' + receiverId)
            .then(async res => {
                if (!res.ok) {
                    throw new Error("HTTP " + res.status);
                }
                return await res.json();
            })
            .then(data => {
                const container = document.getElementById('message-container');
                container.innerHTML = '';

                data.forEach(msg => {
                    const isSender = String(msg.senderId) === String(currentUserId);
                    appendMessage(msg, isSender ? 'sender' : 'receiver');
                });
            })
            .catch(err => {
                console.error("CHAT HISTORY ERROR:", err);

                document.getElementById('message-container').innerHTML =
                    '<div style="text-align:center;color:red;">Không tải được tin nhắn</div>';
            });
    }

    function sendMessage() {
        const input = document.getElementById('chat-input');
        const chatBox = document.getElementById('chat-box');
        const receiverId = chatBox.getAttribute('data-receiver-id');

        if (!input.value.trim()) return;

        const msg = {
            senderId: Number(currentUserId),
            receiverId: Number(receiverId),
            content: input.value,
            isRead: false
        };

        stompClient.send("/app/send-message", {}, JSON.stringify(msg));
        appendMessage(msg, 'sender');
        input.value = '';
    }

    function appendMessage(msg, type) {
        const container = document.getElementById('message-container');

        const wrap = document.createElement('div');
        wrap.style.display = "flex";
        wrap.style.marginBottom = "8px";
        wrap.style.justifyContent = type === 'sender' ? 'flex-end' : 'flex-start';

        const bubble = document.createElement('div');

        bubble.style.maxWidth = "75%";
        bubble.style.padding = "10px 12px";
        bubble.style.borderRadius = "16px";
        bubble.style.fontSize = "14px";
        bubble.style.lineHeight = "1.4";
        bubble.style.wordBreak = "break-word";

        if (type === 'sender') {
            bubble.style.background = "#198754";
            bubble.style.color = "white";
            bubble.style.borderBottomRightRadius = "4px";
        } else {
            bubble.style.background = "white";
            bubble.style.border = "1px solid #e5e5e5";
            bubble.style.borderBottomLeftRadius = "4px";
        }

        bubble.textContent = msg.content;

        wrap.appendChild(bubble);
        container.appendChild(wrap);

        container.scrollTop = container.scrollHeight;
    }

    function closeChat() {
        document.getElementById('chat-box').style.display = 'none';
    }

    document.getElementById('chat-input')?.addEventListener("keypress", function (e) {
        if (e.key === "Enter") sendMessage();
    });
</script>

<jsp:include page="../common/footer.jsp"/>
