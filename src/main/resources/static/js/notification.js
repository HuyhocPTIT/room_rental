let loadedNotification = false;

function handleBellClick(event) {
    event.preventDefault();
    loadNotifications();

    const bellBtn = event.currentTarget;
    if (typeof bootstrap === 'undefined') {
        console.error("Lỗi: Thư viện Bootstrap chưa được tải!");
        return;
    }

    let dropdownInstance = bootstrap.Dropdown.getInstance(bellBtn);
    if (!dropdownInstance) {
        dropdownInstance = new bootstrap.Dropdown(bellBtn);
    }
    dropdownInstance.toggle();
}

function loadNotifications() {
    if (loadedNotification) return;

    const itemsContainer = document.getElementById("notification-items");
    if (!itemsContainer) return;

    itemsContainer.innerHTML = '<li><span class="dropdown-item-text small text-muted">Đang tải...</span></li>';

    fetch(CONFIG.apiNotifications)
        .then(res => {
            if (!res.ok) throw new Error("Lỗi HTTP Status: " + res.status);
            return res.json();
        })
        .then(data => {
            const hasUnread = data.some(item => !item.read);
            if (hasUnread) showNotificationDot(); else hideNotificationDot();

            let html = '';

            if (data.length === 0) {
                html = '<li><span class="dropdown-item-text small text-muted">Không có thông báo nào</span></li>';
            } else {
                data.forEach(item => {
                    let content = item.content;
                    if (item.type === "CHAT") content = item.senderName + " đã gửi cho bạn tin nhắn";
                    if (item.type === "UPGRADE_TO_LANDLORD") {
                        content = (CONFIG.currentUserRole === 'ADMIN') ? item.content : "Tài khoản của bạn đã được nâng cấp thành chủ thuê";
                    }
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
        })
        .catch(err => {
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
    fetch(CONFIG.apiReadNotification + notificationId, { method: 'POST' });

    element.classList.remove('fw-bold', 'bg-light');
    const dot = document.getElementById('unread-dot-' + notificationId);
    if (dot) dot.remove();

    const remainingDots = document.querySelectorAll('[id^="unread-dot-"]');
    if (remainingDots.length === 0) hideNotificationDot();
    if (callback) callback();
}

document.addEventListener("DOMContentLoaded", function () {
    connectNotificationSocket();
    checkInitialUnreadNotifications();
});

let notificationStompClient = null;

function connectNotificationSocket() {
    if (!CONFIG.currentUserId || CONFIG.currentUserId === "null" || CONFIG.currentUserId === "") return;

    const socket = new SockJS(CONFIG.wsUrl);
    notificationStompClient = Stomp.over(socket);
    notificationStompClient.debug = null;

    notificationStompClient.connect({}, function () {
        notificationStompClient.subscribe('/user/queue/notifications', function (message) {
            loadedNotification = false; 
            receiveRealtimeNotification(JSON.parse(message.body));
        });

        notificationStompClient.subscribe('/topic/notifications/' + CONFIG.currentUserId, function (message) {
            loadedNotification = false;
            receiveRealtimeNotification(JSON.parse(message.body));
        });

        notificationStompClient.subscribe('/topic/messages/' + CONFIG.currentUserId, function (messageOutput) {
            const msg = JSON.parse(messageOutput.body);
            showNotificationDot();
            const chatBox = document.getElementById('chat-box');
            const activeChatId = chatBox ? chatBox.getAttribute('data-receiver-id') : null;

            if (chatBox && chatBox.style.display === 'flex' && String(msg.senderId) === String(activeChatId)) {
                if (typeof appendRealtimeMessage === 'function') {
                    appendRealtimeMessage(msg);
                }
            }
        });
    });
}

function receiveRealtimeNotification(item) {
    showNotificationDot();
    const itemsContainer = document.getElementById("notification-items");
    if (!itemsContainer) return;

    if (document.getElementById('unread-dot-' + item.id)) return;
    if (itemsContainer.innerHTML.includes("text-muted") || itemsContainer.innerHTML.includes("Không có thông báo")) {
        itemsContainer.innerHTML = '';
    }

    let content = item.content;
    if (item.type === "CHAT") content = item.senderName + " đã gửi cho bạn tin nhắn";
    if (item.type === "UPGRADE_TO_LANDLORD") {
        content = (CONFIG.currentUserRole === 'ADMIN') ? item.content : "Tài khoản của bạn đã được nâng cấp thành chủ thuê";
    }
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
    if (!CONFIG.currentUserId || CONFIG.currentUserId === "null" || CONFIG.currentUserId === "") return;

    fetch(CONFIG.apiNotifications)
        .then(res => res.json())
        .then(data => {
            const hasUnread = data.some(item => item.read === false);
            if (hasUnread) showNotificationDot(); else hideNotificationDot();
        })
        .catch(err => console.error(err));
}

let chatContactsOffset = 0;
const chatContactsLimit = 5;
let isFetchingChatContacts = false;
let hasMoreChatContacts = true;
let chatDropdownOpened = false;

function handleChatDropdownClick(e) {
    e.preventDefault();
    const btn = e.currentTarget;
    let dropdownInstance = bootstrap.Dropdown.getInstance(btn);
    if (!dropdownInstance) {
        dropdownInstance = new bootstrap.Dropdown(btn);
    }
    dropdownInstance.toggle();
    
    if (!chatDropdownOpened) {
        chatDropdownOpened = true;
        const ul = document.getElementById('chat-contact-items');
        ul.innerHTML = '<li><span class="dropdown-item-text small text-muted text-center d-block">Đang tải...</span></li>';
        chatContactsOffset = 0;
        hasMoreChatContacts = true;
        
        ul.addEventListener('scroll', handleChatDropdownScroll);
        
        fetchChatContacts(false);
    }
}

window.refreshChatContacts = function() {
    chatContactsOffset = 0;
    hasMoreChatContacts = true;
    const ul = document.getElementById('chat-contact-items');
    if(ul) ul.innerHTML = '<li><span class="dropdown-item-text small text-muted text-center d-block">Đang tải...</span></li>';
    fetchChatContacts(false);
};

function fetchChatContacts(append = false) {
    if (isFetchingChatContacts || !hasMoreChatContacts) return;
    isFetchingChatContacts = true;

    fetch(CONFIG.apiChatContacts + "?offset=" + chatContactsOffset + "&limit=" + chatContactsLimit)
        .then(res => res.json())
        .then(data => {
            const ul = document.getElementById('chat-contact-items');
            
            if (!append) {
                ul.innerHTML = '';
            }

            if (data.length === 0) {
                hasMoreChatContacts = false;
                if (!append) {
                    ul.innerHTML = '<li><span class="dropdown-item-text small text-muted text-center d-block">Không có tin nhắn nào</span></li>';
                }
            } else {
                data.forEach(contact => {
                    const initial = contact.contactName ? contact.contactName.charAt(0).toUpperCase() : 'U';
                    const avatarHtml = contact.contactAvatar 
                        ? '<img src="' + contact.contactAvatar + '" style="width:40px;height:40px;border-radius:50%;object-fit:cover;margin-right:12px;">' 
                        : '<div style="width:40px;height:40px;border-radius:50%;background:#ccc;display:flex;align-items:center;justify-content:center;color:#fff;font-weight:bold;margin-right:12px;">' + initial + '</div>';
                    
                    const timeStr = contact.lastMessageTime ? new Date(contact.lastMessageTime).toLocaleTimeString([], {hour: '2-digit', minute:'2-digit'}) : '';
                    const unreadDot = contact.hasUnread ? '<span style="width:8px;height:8px;background:#0d6efd;border-radius:50%;display:inline-block;margin-left:10px;flex-shrink:0;"></span>' : '';
                    const msgWeight = contact.hasUnread ? 'fw-bold text-dark' : 'text-muted';
                    
                    const li = document.createElement('li');
                    li.innerHTML = 
                        '<button type="button" class="dropdown-item d-flex align-items-center border-bottom p-3" ' +
                        'onclick="openChatFromDropdown(' + contact.contactId + ', \'' + (contact.contactName || 'Người dùng').replace(/'/g, "\\'") + '\')">' +
                        avatarHtml +
                        '<div class="flex-grow-1" style="min-width:0;">' +
                        '   <div class="d-flex justify-content-between align-items-baseline">' +
                        '       <span class="fw-semibold text-truncate d-inline-block" style="max-width: 150px;">' + (contact.contactName || 'Người dùng') + '</span>' +
                        '       <span style="font-size:11px;color:#adb5bd;">' + timeStr + '</span>' +
                        '   </div>' +
                        '   <div class="d-flex justify-content-between align-items-center">' +
                        '       <span class="small ' + msgWeight + ' text-truncate d-inline-block" style="max-width: 200px;">' + (contact.lastMessage || '...') + '</span>' +
                               unreadDot +
                        '   </div>' +
                        '</div>' +
                        '</button>';
                    ul.appendChild(li);
                });
                chatContactsOffset += data.length;
                if (data.length < chatContactsLimit) {
                    hasMoreChatContacts = false;
                }
            }
            isFetchingChatContacts = false;
        })
        .catch(err => {
            const ul = document.getElementById('chat-contact-items');
            ul.innerHTML = '<li><span class="dropdown-item-text text-danger small text-center d-block">Lỗi tải dữ liệu.</span></li>';
            isFetchingChatContacts = false;
        });
}

function handleChatDropdownScroll(e) {
    const el = e.target;
    if (el.scrollHeight - el.scrollTop - el.clientHeight < 50) {
        fetchChatContacts(true);
    }
}

function openChatFromDropdown(id, name) {
    const btn = document.querySelector('a[title="Tin nhắn"]');
    if (btn) {
        const drop = bootstrap.Dropdown.getInstance(btn);
        if (drop) drop.hide();
    }
    if (typeof openChat === 'function') {
        openChat(id, name);
    }
}
