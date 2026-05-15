<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="${roomDetail.title} - TrọTốt" scope="request" />
<c:set var="bodyClass" value="room-detail-page" scope="request" />
<c:set var="mainClass" value="room-detail-main" scope="request" />
<jsp:include page="common/header.jsp" />

<div class="room-detail-container">
    <div class="room-detail-content">
        <!-- Room Images Section -->
        <section class="room-images-section">
            <div class="images-container">
                <c:choose>
                    <c:when test="${not empty roomDetail.roomImages}">
                        <div class="main-image-wrapper">
                            <img id="mainImage" src="${roomDetail.roomImages[0]}" alt="${roomDetail.title}" class="main-image">
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
                    <button class="action-btn favorite-btn" onclick="toggleFavorite(${roomDetail.id})">
                        <span class="heart-icon" id="favoriteIcon">
                            <c:choose>
                                <c:when test="${roomDetail.favorite}">❤️</c:when>
                                <c:otherwise>🤍</c:otherwise>
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
                    <span class="spec-item">🏷️ ${roomDetail.category}</span>
                </div>
            </div>

            <!-- Room Description -->
            <div class="room-description">
                <h2>Mô tả chi tiết</h2>
                <p>${roomDetail.description}</p>
            </div>

            <!-- Contact Info -->
            <div class="contact-info">
                <h2>Thông tin liên hệ</h2>
                <div class="contact-section">
                    <div class="contact-item">
                        <label>Điện thoại:</label>
                        <span><a href="tel:${roomDetail.phoneContact}" class="contact-link">${roomDetail.phoneContact}</a></span>
                    </div>
                    <div class="contact-item">
                        <label>Zalo:</label>
                        <span>
                            <c:choose>
                                <c:when test="${not empty roomDetail.zaloContact}">
                                    <a href="https://zalo.me/${roomDetail.zaloContact}" target="_blank" class="contact-link">${roomDetail.zaloContact}</a>
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
                        <p class="owner-phone">📱 <a href="tel:${roomDetail.ownerPhone}" class="contact-link">${roomDetail.ownerPhone}</a></p>
                    </div>
                </div>
            </div>

            <!-- Booking Section -->
            <c:if test="${isLoggedIn}">
                <div class="booking-section">
                    <h2>Đặt phòng</h2>
                    <form id="bookingForm" class="booking-form">
                        <div class="form-group">
                            <label for="checkInDate">Ngày nhận phòng:</label>
                            <input type="date" id="checkInDate" name="checkInDate" required>
                        </div>
                        <div class="form-group">
                            <label for="checkOutDate">Ngày trả phòng (dự kiến):</label>
                            <input type="date" id="checkOutDate" name="checkOutDate">
                        </div>
                        <div class="form-group">
                            <label for="notes">Ghi chú:</label>
                            <textarea id="notes" name="notes" rows="3" placeholder="Viết ghi chú của bạn..."></textarea>
                        </div>
                        <button type="button" class="booking-btn" onclick="submitBooking(${roomDetail.id})">Gửi yêu cầu đặt phòng</button>
                    </form>
                </div>
            </c:if>

            <!-- Reviews Section -->
            <div class="reviews-section">
                <h2>Đánh giá & Bình luận</h2>
                
                <div class="rating-summary">
                    <div class="avg-rating">
                        <span class="rating-number"><fmt:formatNumber value="${roomDetail.averageRating}" maxFractionDigits="1"/></span>
                        <div class="rating-stars">
                            <c:forEach begin="1" end="5" var="i">
                                <span class="star ${i <= roomDetail.averageRating ? 'filled' : ''}" >⭐</span>
                            </c:forEach>
                        </div>
                        <span class="rating-count">${roomDetail.totalReviews} đánh giá</span>
                    </div>
                </div>

                <c:if test="${isLoggedIn}">
                    <div class="add-review-form">
                        <h3>Chia sẻ đánh giá của bạn</h3>
                        <form id="reviewForm" class="review-form">
                            <div class="form-group">
                                <label for="rating">Đánh giá:</label>
                                <div class="star-rating" id="starRating">
                                    <span class="star" onclick="setRating(1)" data-value="1">⭐</span>
                                    <span class="star" onclick="setRating(2)" data-value="2">⭐</span>
                                    <span class="star" onclick="setRating(3)" data-value="3">⭐</span>
                                    <span class="star" onclick="setRating(4)" data-value="4">⭐</span>
                                    <span class="star" onclick="setRating(5)" data-value="5">⭐</span>
                                </div>
                                <input type="hidden" id="rating" name="rating" value="0">
                            </div>
                            <div class="form-group">
                                <label for="comment">Bình luận:</label>
                                <textarea id="comment" name="comment" rows="4" placeholder="Chia sẻ trải nghiệm của bạn..."></textarea>
                            </div>
                            <button type="button" class="submit-review-btn" onclick="submitReview(${roomDetail.id})">Gửi đánh giá</button>
                        </form>
                    </div>
                </c:if>

                <div class="reviews-list">
                    <c:choose>
                        <c:when test="${not empty roomDetail.reviews}">
                            <c:forEach var="review" items="${roomDetail.reviews}">
                                <div class="review-item">
                                    <div class="review-header">
                                        <div class="reviewer-info">
                                            <div class="reviewer-avatar">
                                                <c:choose>
                                                    <c:when test="${not empty review.userAvatar}">
                                                        <img src="${review.userAvatar}" alt="${review.userName}">
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="avatar-placeholder">👤</div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div>
                                                <h4 class="reviewer-name">${review.userName}</h4>
                                                <p class="review-date">${review.createdAt}</p>
                                            </div>
                                        </div>
                                        <div class="review-rating">
                                            <c:forEach begin="1" end="${review.rating}" var="i">
                                                <span class="star filled">⭐</span>
                                            </c:forEach>
                                            <c:forEach begin="${review.rating + 1}" end="5" var="i">
                                                <span class="star">⭐</span>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <p class="review-comment">${review.comment}</p>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <p class="no-reviews">Chưa có đánh giá. Hãy là người đầu tiên đánh giá phòng này!</p>
                        </c:otherwise>
                    </c:choose>
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
                        <span class="value"><fmt:formatNumber value="${roomDetail.price}" type="number" groupingUsed="true"/> đ/tháng</span>
                    </div>
                    <div class="info-row">
                        <span class="label">Diện tích:</span>
                        <span class="value">${roomDetail.area} m²</span>
                    </div>
                    <div class="info-row">
                        <span class="label">Loại phòng:</span>
                        <span class="value">${roomDetail.category}</span>
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
                    <a href="https://zalo.me/${roomDetail.zaloContact}" target="_blank" class="action-btn secondary-btn">
                        💬 Chat Zalo
                    </a>
                </c:if>
            </div>
        </div>
    </aside>
</div>

<style>
    /* Room Detail Container */
    .room-detail-container {
        display: grid;
        grid-template-columns: 1fr 350px;
        gap: 30px;
        padding: 20px;
        max-width: 1200px;
        margin: 20px auto;
    }

    .room-detail-content {
        background: white;
        border-radius: 8px;
        overflow: hidden;
    }

    /* Images Section */
    .room-images-section {
        background: #f8f9fa;
    }

    .images-container {
        width: 100%;
    }

    .main-image-wrapper {
        width: 100%;
        height: 500px;
        display: flex;
        align-items: center;
        justify-content: center;
        background: white;
    }

    .main-image {
        width: 100%;
        height: 100%;
        object-fit: cover;
    }

    .thumbnails-wrapper {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(80px, 1fr));
        gap: 8px;
        padding: 12px;
        background: #f8f9fa;
    }

    .thumbnail {
        width: 80px;
        height: 80px;
        object-fit: cover;
        border: 2px solid transparent;
        border-radius: 4px;
        cursor: pointer;
        transition: all 0.3s ease;
    }

    .thumbnail:hover,
    .thumbnail.active {
        border-color: #007bff;
        box-shadow: 0 0 8px rgba(0, 123, 255, 0.2);
    }

    /* Room Info Section */
    .room-info-section {
        padding: 30px;
    }

    .room-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 20px;
        border-bottom: 1px solid #eee;
        padding-bottom: 20px;
    }

    .room-title-group {
        flex: 1;
    }

    .room-title {
        font-size: 28px;
        font-weight: bold;
        margin: 0 0 10px 0;
        color: #333;
    }

    .room-address {
        font-size: 14px;
        color: #666;
        margin-bottom: 10px;
    }

    .room-actions {
        display: flex;
        gap: 10px;
    }

    .action-btn {
        padding: 10px 16px;
        border: 1px solid #ddd;
        border-radius: 6px;
        background: white;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 14px;
        transition: all 0.3s ease;
    }

    .action-btn:hover {
        background: #f8f9fa;
        border-color: #007bff;
    }

    .favorite-btn {
        background: white;
        border: 1px solid #ddd;
    }

    .favorite-btn.favorited {
        background: #fff3cd;
        border-color: #ffc107;
    }

    .heart-icon {
        font-size: 18px;
    }

    /* Price Info */
    .room-price-info {
        margin-bottom: 30px;
    }

    .price-main {
        font-size: 32px;
        font-weight: bold;
        color: #dc3545;
        margin-bottom: 10px;
    }

    .room-specs {
        display: flex;
        gap: 20px;
        font-size: 14px;
        color: #666;
    }

    .spec-item {
        display: flex;
        align-items: center;
        gap: 5px;
    }

    /* Description */
    .room-description {
        margin-bottom: 30px;
    }

    .room-description h2,
    .contact-info h2,
    .owner-info-section h2,
    .booking-section h2,
    .reviews-section h2 {
        font-size: 18px;
        font-weight: bold;
        margin-bottom: 15px;
        color: #333;
    }

    .room-description p {
        line-height: 1.6;
        color: #555;
        white-space: pre-wrap;
    }

    /* Contact Info */
    .contact-info {
        margin-bottom: 30px;
        padding: 20px;
        background: #f8f9fa;
        border-radius: 8px;
    }

    .contact-section {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 15px;
    }

    .contact-item {
        display: flex;
        flex-direction: column;
    }

    .contact-item label {
        font-weight: 600;
        margin-bottom: 5px;
        color: #333;
    }

    .contact-link {
        color: #007bff;
        text-decoration: none;
    }

    .contact-link:hover {
        text-decoration: underline;
    }

    /* Owner Info */
    .owner-info-section {
        margin-bottom: 30px;
    }

    .owner-card {
        display: flex;
        align-items: center;
        gap: 20px;
        padding: 20px;
        background: #f8f9fa;
        border-radius: 8px;
        border-left: 4px solid #007bff;
    }

    .owner-avatar {
        flex-shrink: 0;
    }

    .owner-avatar img,
    .avatar-placeholder {
        width: 80px;
        height: 80px;
        border-radius: 50%;
        object-fit: cover;
        background: white;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 40px;
    }

    .owner-details {
        flex: 1;
    }

    .owner-name {
        margin: 0 0 8px 0;
        font-size: 16px;
        font-weight: bold;
        color: #333;
    }

    .owner-email,
    .owner-phone {
        margin: 0;
        font-size: 13px;
        color: #666;
        margin-bottom: 5px;
    }

    /* Booking Section */
    .booking-section {
        margin-bottom: 30px;
        padding: 20px;
        background: #e7f3ff;
        border-radius: 8px;
        border: 1px solid #b3d9ff;
    }

    .booking-form {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 15px;
        margin-top: 15px;
    }

    .form-group {
        display: flex;
        flex-direction: column;
    }

    .form-group label {
        font-weight: 600;
        margin-bottom: 8px;
        color: #333;
        font-size: 14px;
    }

    .form-group input,
    .form-group textarea {
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 6px;
        font-size: 14px;
        font-family: inherit;
    }

    .form-group input:focus,
    .form-group textarea:focus {
        outline: none;
        border-color: #007bff;
        box-shadow: 0 0 8px rgba(0, 123, 255, 0.2);
    }

    .booking-btn {
        padding: 12px 24px;
        background: #28a745;
        color: white;
        border: none;
        border-radius: 6px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        align-self: flex-end;
    }

    .booking-btn:hover {
        background: #218838;
    }

    /* Reviews Section */
    .reviews-section {
        margin-top: 30px;
    }

    .rating-summary {
        background: #f8f9fa;
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 20px;
    }

    .avg-rating {
        display: flex;
        flex-direction: column;
        align-items: center;
        gap: 10px;
    }

    .rating-number {
        font-size: 48px;
        font-weight: bold;
        color: #ffc107;
    }

    .rating-stars {
        display: flex;
        gap: 5px;
        font-size: 18px;
    }

    .star {
        cursor: pointer;
        opacity: 0.3;
        transition: all 0.2s ease;
    }

    .star.filled {
        opacity: 1;
    }

    .rating-count {
        font-size: 14px;
        color: #666;
    }

    /* Add Review Form */
    .add-review-form {
        background: #f8f9fa;
        padding: 20px;
        border-radius: 8px;
        margin-bottom: 20px;
    }

    .add-review-form h3 {
        margin: 0 0 15px 0;
        font-size: 16px;
        color: #333;
    }

    .review-form {
        display: flex;
        flex-direction: column;
        gap: 15px;
    }

    .star-rating {
        display: flex;
        gap: 10px;
        font-size: 24px;
    }

    .star-rating .star {
        cursor: pointer;
        opacity: 0.3;
        transition: all 0.2s ease;
    }

    .star-rating .star:hover,
    .star-rating .star.selected {
        opacity: 1;
        transform: scale(1.2);
    }

    .submit-review-btn {
        padding: 12px 24px;
        background: #007bff;
        color: white;
        border: none;
        border-radius: 6px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        align-self: flex-start;
    }

    .submit-review-btn:hover {
        background: #0056b3;
    }

    /* Reviews List */
    .reviews-list {
        display: flex;
        flex-direction: column;
        gap: 15px;
    }

    .no-reviews {
        text-align: center;
        color: #999;
        padding: 20px;
        background: #f8f9fa;
        border-radius: 8px;
    }

    .review-item {
        padding: 15px;
        background: #f8f9fa;
        border-radius: 8px;
        border-left: 3px solid #007bff;
    }

    .review-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 10px;
        gap: 15px;
    }

    .reviewer-info {
        display: flex;
        gap: 10px;
        flex: 1;
    }

    .reviewer-avatar {
        flex-shrink: 0;
    }

    .reviewer-avatar img,
    .avatar-placeholder {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        object-fit: cover;
        background: white;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 20px;
    }

    .reviewer-name {
        margin: 0;
        font-weight: 600;
        font-size: 14px;
        color: #333;
    }

    .review-date {
        margin: 5px 0 0 0;
        font-size: 12px;
        color: #999;
    }

    .review-rating {
        display: flex;
        gap: 3px;
        font-size: 14px;
    }

    .review-comment {
        margin: 10px 0 0 0;
        line-height: 1.5;
        color: #555;
    }

    /* Sidebar */
    .room-sidebar {
        position: relative;
    }

    .sidebar-sticky {
        position: sticky;
        top: 20px;
        display: flex;
        flex-direction: column;
        gap: 20px;
    }

    .sidebar-card {
        background: white;
        border-radius: 8px;
        padding: 20px;
        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
    }

    .sidebar-card .card-title {
        font-weight: bold;
        font-size: 16px;
        margin-bottom: 15px;
        color: #333;
    }

    .sidebar-card .card-content {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .info-row {
        display: flex;
        justify-content: space-between;
        font-size: 13px;
        color: #555;
    }

    .info-row .label {
        font-weight: 600;
        color: #333;
    }

    .info-row .value {
        text-align: right;
    }

    .sidebar-actions {
        display: flex;
        flex-direction: column;
        gap: 10px;
    }

    .primary-btn {
        background: #dc3545;
        color: white;
        font-weight: 600;
        padding: 12px;
        border: none;
        text-align: center;
        text-decoration: none;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .primary-btn:hover {
        background: #c82333;
    }

    .secondary-btn {
        background: white;
        color: #007bff;
        font-weight: 600;
        padding: 12px;
        border: 1px solid #007bff;
        text-align: center;
        text-decoration: none;
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .secondary-btn:hover {
        background: #f8f9fa;
    }

    /* Responsive */
    @media (max-width: 768px) {
        .room-detail-container {
            grid-template-columns: 1fr;
        }

        .room-header {
            flex-direction: column;
        }

        .room-title {
            font-size: 24px;
        }

        .price-main {
            font-size: 24px;
        }

        .main-image-wrapper {
            height: 300px;
        }

        .review-header {
            flex-direction: column;
        }

        .sidebar-sticky {
            position: static;
        }
    }
</style>

<script>
    function changeMainImage(thumbnail) {
        const mainImage = document.getElementById('mainImage');
        mainImage.src = thumbnail.src;
        
        document.querySelectorAll('.thumbnail').forEach(thumb => {
            thumb.classList.remove('active');
        });
        thumbnail.classList.add('active');
    }

    function toggleFavorite(roomId) {
        const btn = event.target.closest('.favorite-btn');
        const icon = document.getElementById('favoriteIcon');
        const text = document.getElementById('favoriteText');
        
        if (icon.textContent === '🤍') {
            fetch('/room/' + roomId + '/favorite/add', {
                method: 'POST'
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
            .catch(err => console.error(err));
        } else {
            fetch('/room/' + roomId + '/favorite/remove', {
                method: 'POST'
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    icon.textContent = '🤍';
                    text.textContent = 'Lưu phòng';
                    btn.classList.remove('favorited');
                }
                alert(data.message);
            })
            .catch(err => console.error(err));
        }
    }

    function setRating(value) {
        document.getElementById('rating').value = value;
        
        document.querySelectorAll('#starRating .star').forEach((star, index) => {
            if (index < value) {
                star.classList.add('selected');
            } else {
                star.classList.remove('selected');
            }
        });
    }

    function submitReview(roomId) {
        const rating = document.getElementById('rating').value;
        const comment = document.getElementById('comment').value;

        if (!rating || rating == 0) {
            alert('Vui lòng chọn đánh giá sao');
            return;
        }

        if (!comment.trim()) {
            alert('Vui lòng nhập bình luận');
            return;
        }

        fetch('/room/' + roomId + '/review', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                rating: parseInt(rating),
                comment: comment
            })
        })
        .then(res => res.json())
        .then(data => {
            alert(data.message);
            if (data.success) {
                document.getElementById('reviewForm').reset();
                document.getElementById('rating').value = 0;
                document.querySelectorAll('#starRating .star').forEach(star => {
                    star.classList.remove('selected');
                });
                setTimeout(() => location.reload(), 1500);
            }
        })
        .catch(err => {
            console.error(err);
            alert('Lỗi khi gửi đánh giá');
        });
    }

    function submitBooking(roomId) {
        const checkInDate = document.getElementById('checkInDate').value;
        const checkOutDate = document.getElementById('checkOutDate').value;
        const notes = document.getElementById('notes').value;

        if (!checkInDate) {
            alert('Vui lòng chọn ngày nhận phòng');
            return;
        }

        fetch('/room/' + roomId + '/booking', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                checkInDate: checkInDate,
                checkOutDate: checkOutDate || null,
                notes: notes
            })
        })
        .then(res => res.json())
        .then(data => {
            alert(data.message);
            if (data.success) {
                document.getElementById('bookingForm').reset();
            }
        })
        .catch(err => {
            console.error(err);
            alert('Lỗi khi đặt phòng');
        });
    }

    function copyToClipboard(text) {
        navigator.clipboard.writeText(text).then(() => {
            alert('Đã copy số điện thoại');
        });
    }
</script>

<jsp:include page="common/footer.jsp" />
