<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="TrọTốt - Tìm phòng trọ dễ dàng" scope="request" />
<c:set var="bodyClass" value="home-page" scope="request" />
<c:set var="mainClass" value="home-main" scope="request" />
<jsp:include page="common/header.jsp" />
<section class="hero">
    <h1>Tìm <span>phòng trọ</span> ưng ý<br>chỉ trong vài giây</h1>
    <p>Hàng nghìn phòng trọ, căn hộ mini tại Việt Nam - cập nhật mỗi ngày</p>
    <form action="/" method="get" class="search-box">
        <select name="province" id="sel-tinh">
            <option value="">📍 Tỉnh / Thành phố</option>
            <option value="Hà Nội" ${province == 'Hà Nội' ? 'selected' : ''}>Hà Nội</option>
            <option value="Hồ Chí Minh" ${province == 'Hồ Chí Minh' ? 'selected' : ''}>TP. Hồ Chí Minh</option>
            <option value="Đà Nẵng" ${province == 'Đà Nẵng' ? 'selected' : ''}>Đà Nẵng</option>
            <option value="Cần Thơ" ${province == 'Cần Thơ' ? 'selected' : ''}>Cần Thơ</option>
            <option value="Hải Phòng" ${province == 'Hải Phòng' ? 'selected' : ''}>Hải Phòng</option>
        </select>

        <select name="priceRange" id="sel-gia">
            <option value="">💰 Mức giá</option>
            <option value="1" ${priceRange == '1' ? 'selected' : ''}>Dưới 1 triệu</option>
            <option value="2" ${priceRange == '2' ? 'selected' : ''}>1 - 2 triệu</option>
            <option value="3" ${priceRange == '3' ? 'selected' : ''}>2 - 3 triệu</option>
            <option value="4" ${priceRange == '4' ? 'selected' : ''}>3 - 5 triệu</option>
            <option value="5" ${priceRange == '5' ? 'selected' : ''}>Trên 5 triệu</option>
        </select>

        <select name="category" id="sel-loai">
            <option value="">🏠 Loại phòng</option>
            <option value="MOTEL_ROOM" ${category == 'MOTEL_ROOM' ? 'selected' : ''}>Phòng trọ</option>
            <option value="MINI_APARTMENT" ${category == 'MINI_APARTMENT' ? 'selected' : ''}>Căn hộ mini</option>
            <option value="APARTMENT" ${category == 'APARTMENT' ? 'selected' : ''}>Chung cư</option>
            <option value="WHOLE_HOUSE" ${category == 'WHOLE_HOUSE' ? 'selected' : ''}>Nhà nguyên căn</option>
        </select>

        <button class="search-btn" type="submit">🔍 Tìm ngay</button>
    </form>
</section>

<section id="featured-rooms">
    <h2>Phòng nổi bật <span class="tag-moi">Mới</span></h2>
    <p class="subtitle">Được cập nhật và xác minh bởi đội ngũ TrọTốt</p>
    <div class="cats" id="cats">
        <c:set var="baseQuery" value="" />
        <c:if test="${not empty province}">
            <c:set var="baseQuery" value="${baseQuery}&province=${province}" />
        </c:if>
        <c:if test="${not empty priceRange}">
            <c:set var="baseQuery" value="${baseQuery}&priceRange=${priceRange}" />
        </c:if>
        
        <a href="/?${not empty baseQuery ? baseQuery.substring(1) : ''}" style="text-decoration: none" class="cat ${empty category ? 'active' : ''}">Tất cả</a>
        <a href="/?category=MOTEL_ROOM${baseQuery}" style="text-decoration: none" class="cat ${category == 'MOTEL_ROOM' ? 'active' : ''}">Phòng trọ</a>
        <a href="/?category=MINI_APARTMENT${baseQuery}" style="text-decoration: none" class="cat ${category == 'MINI_APARTMENT' ? 'active' : ''}">Căn hộ mini</a>
        <a href="/?category=APARTMENT${baseQuery}" style="text-decoration: none" class="cat ${category == 'APARTMENT' ? 'active' : ''}">Chung cư</a>
        <a href="/?category=WHOLE_HOUSE${baseQuery}" style="text-decoration: none" class="cat ${category == 'WHOLE_HOUSE' ? 'active' : ''}">Nhà nguyên căn</a>
    </div>
    <div class="cards" id="cards">
        <c:forEach var="post" items="${roomPosts}">

            <c:choose>
                <c:when test="${post.category == 'APARTMENT'}"><c:set var="catCode" value="chungcu" /></c:when>
                <c:when test="${post.category == 'MINI_APARTMENT'}"><c:set var="catCode" value="mini" /></c:when>
                <c:when test="${post.category == 'WHOLE_HOUSE'}"><c:set var="catCode" value="nguyen" /></c:when>
                <c:otherwise><c:set var="catCode" value="phongtro" /></c:otherwise>
            </c:choose>

            <div class="card room-card" data-category="${catCode}" onclick="location.href='/room/${post.id}'" style="cursor: pointer;">

                <div class="card-img" style="position: relative; overflow: hidden; background-color: #f8f9fa;">
                    <c:choose>
                        <c:when test="${not empty post.roomImages}">
                            <img src="${post.roomImages[0].imageUrl}" alt="${post.title}" style="width: 100%; height: 100%; object-fit: cover;">
                        </c:when>
                        <c:otherwise>
                            <div style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; font-weight: bold; color: #adb5bd;">
                                NO IMAGE
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <button class="save-btn ${savedPostIds.contains(post.id) ? 'saved' : ''}" type="button" onclick="toggleSave(event, '${post.id}')" title="Lưu phòng">
                        <svg viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg" style="display:block;height:24px;width:24px;stroke-width:2;overflow:visible;"><path d="m16 28c7-4.733 14-10 14-17 0-1.792-.683-3.583-2.05-4.95-1.367-1.366-3.158-2.05-4.95-2.05-1.791 0-3.583.684-4.949 2.05l-2.051 2.051-2.05-2.051c-1.367-1.366-3.158-2.05-4.95-2.05-1.791 0-3.583.684-4.949 2.05-1.367 1.367-2.051 3.158-2.051 4.95 0 7 7 12.267 14 17z"></path></svg>
                    </button>
                </div>

                <div class="card-body">
                    <div class="card-title">${post.title}</div>

                    <div class="card-addr">${post.address}</div>

                    <div class="card-row">
                        <div class="card-price">
                            <fmt:formatNumber value="${post.price}" type="number" groupingUsed="true"/> đ/tháng
                        </div>
                        <div class="card-tag">
                            <c:choose>
                                <c:when test="${post.category == 'APARTMENT'}">Chung cư</c:when>
                                <c:when test="${post.category == 'MINI_APARTMENT'}">Căn hộ mini</c:when>
                                <c:when test="${post.category == 'WHOLE_HOUSE'}">Nguyên căn</c:when>
                                <c:otherwise>Phòng trọ</c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="card-meta">
                        <span class="badge">📐 ${post.area} m²</span>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <c:if test="${totalPages > 1}">
        <div class="pagination" style="display: flex; justify-content: center; gap: 8px; margin-top: 40px;">
            <c:set var="fullQuery" value="${baseQuery}" />
            <c:if test="${not empty category}">
                <c:set var="fullQuery" value="${fullQuery}&category=${category}" />
            </c:if>
            <c:if test="${currentPage > 0}">
                <a href="?page=${currentPage - 1}${fullQuery}" class="site-btn site-btn-outline" style="padding: 8px 16px;">&laquo; Trước</a>
            </c:if>
            
            <c:forEach begin="0" end="${totalPages - 1}" var="i">
                <a href="?page=${i}${fullQuery}" class="site-btn ${currentPage == i ? '' : 'site-btn-outline'}" style="padding: 8px 16px;">${i + 1}</a>
            </c:forEach>
            
            <c:if test="${currentPage < totalPages - 1}">
                <a href="?page=${currentPage + 1}${fullQuery}" class="site-btn site-btn-outline" style="padding: 8px 16px;">Sau &raquo;</a>
            </c:if>
        </div>
    </c:if>
</section>
<section class="features" id="features">
    <h2>Tại sao chọn TrọTốt?</h2>
    <p class="subtitle">Nền tảng tìm phòng trọ số 1 Việt Nam</p>
    <div class="feat-grid">
        <div class="feat"><div class="feat-icon">🔍</div><h3>Tìm kiếm thông minh</h3><p>Lọc theo giá, diện tích, tiện ích chỉ trong vài giây</p></div>
        <div class="feat"><div class="feat-icon">✅</div><h3>Tin đăng xác thực</h3><p>Mọi tin đăng được kiểm duyệt thủ công trước khi hiển thị</p></div>
        <div class="feat"><div class="feat-icon">📞</div><h3>Liên hệ trực tiếp</h3><p>Kết nối ngay với chủ trọ, không qua trung gian</p></div>
        <div class="feat"><div class="feat-icon">🗺️</div><h3>Xem bản đồ</h3><p>Tìm phòng quanh khu vực bạn mong muốn dễ dàng</p></div>
        <div class="feat"><div class="feat-icon">🔔</div><h3>Thông báo mới</h3><p>Nhận ngay khi có phòng mới phù hợp tiêu chí của bạn</p></div>
    </div>
</section>
<div class="cta-banner" id="post-room">
    <h2>Bạn có phòng muốn cho thuê?</h2>
    <p>Đăng tin miễn phí, tiếp cận hàng chục nghìn người thuê tiềm năng mỗi ngày</p>
    <button type="button" onclick="location.href='<c:url value='/post-room'/>'">Đăng tin ngay - Miễn phí</button>
</div>
<script>
    function toggleSave(event, postId) {
        event.stopPropagation(); // Ngăn click nhầm vào card chuyển sang trang chi tiết
        var btn = event.currentTarget;

        // Gọi API lên server
        fetch('/favorites/toggle?postId=' + postId, {
            method: 'POST'
        })
            .then(response => {
                if (response.ok) {
                    btn.classList.toggle('saved');
                } else if (response.status === 401 || response.status === 403) {
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
                    Swal.fire('Lỗi', 'Có lỗi xảy ra khi lưu phòng, vui lòng thử lại.', 'error');
                }
            })
            .catch(error => {
                console.error('Lỗi khi lưu phòng:', error);
                Swal.fire('Lỗi', 'Không thể kết nối đến máy chủ.', 'error');
            });
    }
</script>

<jsp:include page="common/footer.jsp" />