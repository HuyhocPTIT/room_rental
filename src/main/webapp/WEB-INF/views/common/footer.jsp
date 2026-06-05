<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
</main>
<footer class="site-footer" id="contact">
    <div class="site-footer-brand">
        <div class="site-logo footer-logo">Trọ<span>Tốt</span></div>
        <p>Nền tảng cho thuê phòng trọ uy tín, dễ dàng và nhanh chóng tại Việt Nam.</p>
    </div>
    <div class="site-footer-col">
        <h4>Cho người thuê</h4>
        <ul>
            <li><a href="<c:url value='/'/>">Tìm phòng trọ</a></li>
            <li><a href="<c:url value='/'/>#featured-rooms">Căn hộ mini</a></li>
            <li><a href="<c:url value='/'/>#featured-rooms">Chung cư giá rẻ</a></li>
            <li><a href="<c:url value='/'/>#featured-rooms">Lưu tin yêu thích</a></li>
        </ul>
    </div>
    <div class="site-footer-col">
        <h4>Cho chủ nhà</h4>
        <ul>
            <li><a href="<c:url value='/'/>#post-room">Đăng tin miễn phí</a></li>
            <li><a href="<c:url value='/admin'/>">Quản lý tin đăng</a></li>
            <li><a href="<c:url value='/'/>#featured-rooms">Gói nổi bật</a></li>
        </ul>
    </div>
    <div class="site-footer-col">
        <h4>Hỗ trợ</h4>
        <ul>
            <li><a href="#">Trung tâm trợ giúp</a></li>
            <li><a href="#">Điều khoản sử dụng</a></li>
            <li><a href="#">Chính sách bảo mật</a></li>
            <li><a href="<c:url value='/'/>#contact">Liên hệ</a></li>
        </ul>
    </div>
</footer>
<div class="site-footer-bottom">© 2026 TrọTốt - Tìm phòng trọ dễ dàng. Mọi quyền được bảo lưu.</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<!-- CHAT WIDGET GLOBAL -->
<c:if test="${not empty sessionScope.currentUser}">
<div id="chat-box"
     style="display:none;
     position:fixed;
     bottom:20px;
     right:20px;
     width:calc(100% - 40px);
     max-width:340px;
     height:460px;
     max-height:80vh;
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
    var chatStompClient = null;
    var chatCurrentUserId = "${sessionScope.currentUser.id}";

    document.addEventListener("DOMContentLoaded", function () {
        if (chatCurrentUserId) {
            connectChatWebSocket();
        }
    });

    function connectChatWebSocket() {
        var socket = new SockJS('/ws');
        chatStompClient = Stomp.over(socket);
        chatStompClient.debug = null;

        chatStompClient.connect({}, function () {
            chatStompClient.subscribe('/topic/messages/' + chatCurrentUserId, function (msgOutput) {
                const msg = JSON.parse(msgOutput.body);

                const chatBox = document.getElementById('chat-box');
                const receiverId = chatBox.getAttribute('data-receiver-id');

                const isFromCurrentChat = String(msg.senderId) === String(receiverId);

                if (chatBox.style.display === 'flex' && isFromCurrentChat) {
                    appendMessage(msg, 'receiver');
                } else {
                    Swal.fire({
                        toast: true,
                        position: 'bottom-end',
                        icon: 'info',
                        title: 'Tin nhắn mới từ ' + (msg.senderName || 'khách'),
                        showConfirmButton: false,
                        timer: 3000,
                        timerProgressBar: true,
                        didOpen: (toast) => {
                            toast.addEventListener('mouseenter', Swal.stopTimer)
                            toast.addEventListener('mouseleave', Swal.resumeTimer)
                        }
                    });
                    // Refresh dropdown if it exists
                    if (typeof refreshChatContacts === 'function') {
                        refreshChatContacts(); // reset and reload
                    }
                }
            });
        });
    }

    function openChat(receiverId, receiverName) {
        if (!chatCurrentUserId) {
            alert("Bạn cần đăng nhập!");
            return;
        }

        if (String(chatCurrentUserId) === String(receiverId)) return;

        const chatBox = document.getElementById('chat-box');
        chatBox.style.display = 'flex';
        chatBox.setAttribute('data-receiver-id', receiverId);

        document.getElementById('chat-title').innerText = "Chat với " + receiverName;
        document.getElementById('message-container').innerHTML = '<div class="text-muted text-center">Đang tải...</div>';

        fetch('/api/chat/history?receiverId=' + receiverId)
            .then(async res => {
                if (!res.ok) throw new Error("HTTP " + res.status);
                return await res.json();
            })
            .then(data => {
                const container = document.getElementById('message-container');
                container.innerHTML = '';

                data.forEach(msg => {
                    const isSender = String(msg.senderId) === String(chatCurrentUserId);
                    appendMessage(msg, isSender ? 'sender' : 'receiver');
                });

                fetch('/api/chat/mark-read?senderId=' + receiverId, { method: 'POST' })
                    .catch(e => console.error("Could not mark as read", e));
                    
                // Refresh dropdown to clear unread dot
                if (typeof refreshChatContacts === 'function') {
                    setTimeout(() => refreshChatContacts(), 500);
                }
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
            senderId: Number(chatCurrentUserId),
            receiverId: Number(receiverId),
            content: input.value,
            isRead: false
        };

        chatStompClient.send("/app/send-message", {}, JSON.stringify(msg));
        appendMessage(msg, 'sender');
        input.value = '';
        
        if (typeof refreshChatContacts === 'function') {
            setTimeout(() => refreshChatContacts(), 500);
        }
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
</c:if>
</body>
</html>