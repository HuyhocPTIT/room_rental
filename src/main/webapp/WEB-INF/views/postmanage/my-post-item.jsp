<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="card room-card room-item shadow-sm border-0 mb-3"
     style="border-radius: 14px; overflow: hidden; position: relative; cursor: pointer;">

    <div style="text-decoration:none; color:inherit; display:block;">
        <div class="d-flex align-items-center">

            <div style="width:140px; min-width:140px; height:170px; background:#f8f9fa; position:relative;">
                <c:choose>
                    <c:when test="${not empty room.roomImages}">
                        <img src="${room.roomImages[0].imageUrl}" style="width:100%; height:100%; object-fit:cover;">
                    </c:when>
                    <c:otherwise>
                        <div class="d-flex align-items-center justify-content-center h-100 text-muted fw-bold">
                            NO IMAGE
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="p-3 flex-grow-1" style="padding-right: 90px !important;">
                <div class="fw-bold mb-1" style="font-size:16px; color:#1f2937; line-height:1.3;">
                    <c:out value="${room.title}"/>
                </div>

                <div class="text-muted mb-2" style="font-size:13px;">
                    <c:out value="${room.address}"/>
                </div>

                <div class="d-flex justify-content-between align-items-center mb-2">
                    <span style="color:#e53935; font-weight:bold;">
                        <fmt:formatNumber value="${room.price}" type="number" groupingUsed="true"/>
                        đ/tháng
                    </span>
                </div>

                <div class="badge mb-2" style="background:#e0f2fe; color:#0369a1;">
                    <c:choose>
                        <c:when test="${room.category.name() == 'ROOM'}">Phòng trọ</c:when>
                        <c:when test="${room.category.name() == 'APARTMENT'}">Căn hộ mini</c:when>
                        <c:when test="${room.category.name() == 'HOUSE'}">Nhà nguyên căn</c:when>
                        <c:when test="${room.category.name() == 'VILLA'}">Biệt thự</c:when>
                        <c:otherwise>Khác</c:otherwise>
                    </c:choose>
                </div>

                <div>
                    <c:choose>
                        <c:when test="${room.status.name() == 'ACTIVE'}">
                            <span class="badge bg-success">Còn trống</span>
                        </c:when>
                        <c:when test="${room.status.name() == 'EXPIRE'}">
                            <span class="badge bg-danger">Hết hạn</span>
                        </c:when>
                        <c:when test="${room.status.name() == 'HIDDEN'}">
                            <span class="badge bg-secondary">Đang ẩn</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge bg-warning text-dark">Chờ duyệt</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <div style="position:absolute; top:10px; right:10px; display:flex; gap:6px; z-index: 10;">

        <c:set var="imageUrls" value="" />

        <c:forEach var="img" items="${room.roomImages}" varStatus="loop">
            <c:set var="imageUrls"
                   value="${imageUrls}${img.imageUrl}${!loop.last ? '|' : ''}" />
        </c:forEach>

        <button type="button"
                class="btn btn-light btn-sm shadow-sm btn-edit-trigger"
                style="border-radius:10px;"
                data-id="${room.id}"
                data-title="<c:out value='${room.title}'/>"
                data-address="<c:out value='${room.address}'/>"
                data-category="${room.category}"
                data-price="<c:out value='${room.price.longValue()}'/>"
                data-area="<c:out value='${room.area}'/>"
                data-phone="${room.phoneContact}"
                data-zalo="${room.zaloContact}"
                data-location="${room.location.id}"
                data-description="<c:out value='${room.description}'/>"
                data-images="
                <c:forEach var='img' items='${room.roomImages}' varStatus='s'>
                ${img.id}::${img.imageUrl}<c:if test='${!s.last}'>|</c:if>
                </c:forEach>
                ">
            ✏️
        </button>

        <button type="button"
                class="btn btn-light btn-sm shadow-sm text-danger"
                style="border-radius:10px;"
                onclick="event.stopPropagation(); confirmDelete('${room.id}', '<c:out value="${room.title}"/>')">
            🗑
        </button>
    </div>
</div>

<style>
    .room-item {
        border-radius: 14px;
        overflow: hidden;
        position: relative;
        cursor: pointer;
        transition: all 0.25s ease;
    }

    .room-item:hover {
        transform: translateY(-6px);
        box-shadow: 0 10px 25px rgba(0,0,0,0.12);
    }

    .room-item img {
        transition: transform 0.3s ease;
    }

    .room-item:hover img {
        transform: scale(1.05);
    }
</style>