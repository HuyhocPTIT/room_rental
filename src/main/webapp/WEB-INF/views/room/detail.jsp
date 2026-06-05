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
                            onclick="toggleFavorite(event, '${roomDetail.id}')">
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
                        <span class="contact-link">${roomDetail.phoneContact}</span>
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
                        <p class="owner-phone">📱 ${roomDetail.ownerPhone}</p>
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
                <button class="action-btn secondary-btn" onclick="copyToClipboard('${roomDetail.phoneContact}')">
                    📋 Copy số điện thoại
                </button>
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
        const endpoint = isFavorited ? '/room/' + roomId + '/favorite/remove' : '/room/' + roomId + '/favorite/add';
        
        fetch(endpoint, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                if (isFavorited) {
                    icon.textContent = '♡';
                    text.textContent = 'Lưu phòng';
                    btn.classList.remove('favorited');
                } else {
                    icon.textContent = '❤️';
                    text.textContent = 'Đã lưu';
                    btn.classList.add('favorited');
                }
            } else if (data.message === "Vui lòng đăng nhập") {
                Swal.fire({
                    title: 'Yêu cầu đăng nhập',
                    text: 'Bạn cần đăng nhập để lưu phòng này nhé!',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#ff385c',
                    cancelButtonColor: '#6c757d',
                    confirmButtonText: 'Đăng nhập ngay',
                    cancelButtonText: 'Hủy bỏ'
                }).then((result) => {
                    if (result.isConfirmed) {
                        window.location.href = '/auth/login';
                    }
                });
            } else {
                Swal.fire('Thông báo', data.message, 'info');
            }
        })
        .catch(err => {
            console.error(err);
            Swal.fire('Lỗi', 'Lỗi mạng, vui lòng thử lại.', 'error');
        });
    }

    function copyToClipboard(text) {
        navigator.clipboard.writeText(text).then(() => {
            alert('Đã copy số điện thoại');
        });
    }
</script>


<jsp:include page="../common/footer.jsp"/>
