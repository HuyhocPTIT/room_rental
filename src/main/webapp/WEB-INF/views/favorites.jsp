<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<c:set var="pageTitle" value="TrọTốt - Phòng đã lưu" scope="request" />
<c:set var="bodyClass" value="favorites-page" scope="request" />
<c:set var="mainClass" value="container my-4" scope="request" />
<jsp:include page="common/header.jsp" />

<section class="page-header">
    <div class="page-head-content">
        <h1>Phòng đã lưu</h1>
        <p>Danh sách các phòng bạn đã lưu để xem lại sau.</p>
    </div>
</section>

<section class="favorites-list">
    <c:choose>
        <c:when test="${not empty errorMessage}">
            <div class="info-box">
                <p>${errorMessage}</p>
            </div>
        </c:when>
        <c:when test="${empty roomPosts}">
            <div class="info-box">
                <p>Bạn chưa lưu phòng nào. Hãy ghé trang chủ để tìm và lưu phòng yêu thích.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="cards" id="cards">
                <c:forEach var="post" items="${roomPosts}">
                    <c:choose>
                        <c:when test="${post.category == 'APARTMENT'}"><c:set var="catCode" value="chungcu" /></c:when>
                        <c:when test="${post.category == 'HOUSE'}"><c:set var="catCode" value="nguyen" /></c:when>
                        <c:when test="${post.category == 'VILLA'}"><c:set var="catCode" value="nguyen" /></c:when>
                        <c:otherwise><c:set var="catCode" value="phongtro" /></c:otherwise>
                    </c:choose>

                    <div class="card room-card" data-category="${catCode}" onclick="location.href='/room/${post.id}'" style="cursor: pointer;">
                        <div class="card-img" style="position: relative; overflow: hidden; background-color: #f8f9fa;">
                        <button class="save-btn saved" type="button" onclick="toggleSave(event, ${post.id})" title="Bỏ lưu phòng">
                            <svg viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg" style="display:block;height:24px;width:24px;stroke-width:2;overflow:visible;"><path d="m16 28c7-4.733 14-10 14-17 0-1.792-.683-3.583-2.05-4.95-1.367-1.366-3.158-2.05-4.95-2.05-1.791 0-3.583.684-4.949 2.05l-2.051 2.051-2.05-2.051c-1.367-1.366-3.158-2.05-4.95-2.05-1.791 0-3.583.684-4.949 2.05-1.367 1.367-2.051 3.158-2.051 4.95 0 7 7 12.267 14 17z"></path></svg>
                        </button>
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
                                        <c:when test="${post.category == 'HOUSE'}">Nguyên căn</c:when>
                                        <c:when test="${post.category == 'VILLA'}">Biệt thự</c:when>
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
        </c:otherwise>
    </c:choose>
</section>

<script>
    function toggleSave(event, postId) {
        event.stopPropagation();
        const btn = event.currentTarget;
        const isSaved = btn.classList.contains('saved');
        const action = isSaved ? 'remove' : 'add';

        fetch('/room/' + postId + '/favorite/' + action, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                btn.classList.toggle('saved');
                btn.title = isSaved ? 'Lưu phòng' : 'Bỏ lưu phòng';
                if (action === 'remove') {
                    const card = btn.closest('.card');
                    if (card) {
                        card.remove();
                    }
                }
            } else {
                alert(data.message || 'Lỗi khi cập nhật trạng thái yêu thích');
            }
        })
        .catch(() => {
            alert('Lỗi mạng, vui lòng thử lại.');
        });
    }
</script>
<jsp:include page="common/footer.jsp" />