<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Phòng - RoomRental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #FF6B35;
            --secondary-color: #004E89;
        }
        
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f8f9fa;
        }
        
        .filter-sidebar {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            height: fit-content;
            position: sticky;
            top: 20px;
        }
        
        .filter-title {
            font-weight: 700;
            color: var(--secondary-color);
            margin-bottom: 15px;
            font-size: 1rem;
        }
        
        .filter-group {
            margin-bottom: 20px;
        }
        
        .filter-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 0.9rem;
            color: #333;
        }
        
        .filter-group input,
        .filter-group select {
            width: 100%;
            padding: 8px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 0.9rem;
        }
        
        .btn-reset {
            width: 100%;
            background-color: #f0f0f0;
            border: 1px solid #ddd;
            color: #333;
            padding: 10px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: 600;
            display: inline-block;
            text-align: center;
            margin-bottom: 10px;
        }
        
        .btn-reset:hover {
            background-color: #e0e0e0;
        }
        
        .btn-apply {
            width: 100%;
            background-color: var(--primary-color);
            color: white;
            padding: 10px;
            border-radius: 4px;
            border: none;
            font-weight: 600;
            cursor: pointer;
        }
        
        .btn-apply:hover {
            background-color: #E55A2B;
        }
        
        .page-title {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--secondary-color);
            margin-bottom: 30px;
        }
        
        .room-card {
            border: 1px solid #e0e0e0;
            border-radius: 8px;
            overflow: hidden;
            transition: all 0.3s ease;
            background: white;
            display: flex;
            margin-bottom: 20px;
        }
        
        .room-card:hover {
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        
        .room-card-img {
            width: 250px;
            height: 200px;
            object-fit: cover;
            flex-shrink: 0;
        }
        
        .room-card-content {
            padding: 20px;
            flex-grow: 1;
            display: flex;
            flex-direction: column;
        }
        
        .room-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: var(--secondary-color);
            margin-bottom: 10px;
        }
        
        .room-price {
            font-size: 1.4rem;
            font-weight: 700;
            color: var(--primary-color);
            margin-bottom: 10px;
        }
        
        .room-info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 15px;
            font-size: 0.9rem;
            color: #666;
        }
        
        .room-info-item {
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .room-description {
            color: #666;
            font-size: 0.95rem;
            margin-bottom: 15px;
            flex-grow: 1;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .room-footer {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .room-location {
            color: #999;
            font-size: 0.85rem;
            margin-right: auto;
        }
        
        .btn-view {
            background-color: var(--primary-color);
            color: white;
            padding: 10px 20px;
            border-radius: 4px;
            text-decoration: none;
            font-weight: 600;
            border: none;
            cursor: pointer;
        }
        
        .btn-view:hover {
            background-color: #E55A2B;
            text-decoration: none;
            color: white;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
        }
        
        .empty-state h3 {
            color: var(--secondary-color);
            margin-bottom: 15px;
        }
        
        @media (max-width: 768px) {
            .room-card {
                flex-direction: column;
            }
            
            .room-card-img {
                width: 100%;
                height: 200px;
            }
        }
    </style>
</head>
<body>
<jsp:include page="common/header.jsp" />

<div class="container my-5">
    <div class="row">
        <div class="col-md-3">
            <div class="filter-sidebar">
                <h5 class="filter-title"><i class="bi bi-funnel"></i> Lọc Kết Quả</h5>
                <form method="get" action="<c:url value='/rooms'/>">
                    <div class="filter-group">
                        <label>Từ khóa</label>
                        <input type="text" name="keyword" class="form-control" placeholder="Tên phòng, mô tả..." value="${keyword}">
                    </div>
                    
                    <div class="filter-group">
                        <label>Giá từ (đ)</label>
                        <input type="number" name="minPrice" placeholder="Giá tối thiểu" value="${minPrice}">
                    </div>
                    
                    <div class="filter-group">
                        <label>Giá đến (đ)</label>
                        <input type="number" name="maxPrice" placeholder="Giá tối đa" value="${maxPrice}">
                    </div>
                    
                    <div class="filter-group">
                        <label>Loại phòng</label>
                        <select name="category">
                            <option value="">-- Tất cả --</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat}" <c:if test="${cat == category}">selected</c:if>>${cat}</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="filter-group">
                        <label>Số phòng ngủ tối thiểu</label>
                        <input type="number" name="minBedrooms" placeholder="Số phòng" value="${minBedrooms}">
                    </div>
                    
                    <button type="submit" class="btn-apply"><i class="bi bi-search"></i> Áp dụng bộ lọc</button>
                    <a href="<c:url value='/rooms'/>" class="btn-reset">Xóa bộ lọc</a>
                </form>
            </div>
        </div>
        
        <div class="col-md-9">
            <h1 class="page-title"><i class="bi bi-houses"></i> Danh Sách Phòng</h1>
            
            <c:if test="${not empty rooms}">
                <p class="text-muted mb-4">Tìm thấy ${rooms.size()} phòng</p>
                
                <c:forEach var="room" items="${rooms}">
                    <div class="room-card">
                        <img src="https://via.placeholder.com/250x200?text=Room+${room.id}" alt="${room.title}" class="room-card-img">
                        <div class="room-card-content">
                            <h4 class="room-title">${room.title}</h4>
                            <div class="room-price">
                                <fmt:formatNumber value="${room.price}" type="currency" pattern="### ###" /> đ/tháng
                            </div>
                            
                            <div class="room-info-grid">
                                <div class="room-info-item">
                                    <i class="bi bi-rulers text-primary"></i> Diện tích: ${room.area} m²
                                </div>
                                <div class="room-info-item">
                                    <i class="bi bi-door-closed text-primary"></i> Phòng ngủ: ${room.bedrooms}
                                </div>
                                <div class="room-info-item">
                                    <i class="bi bi-droplet text-primary"></i> Phòng tắm: ${room.bathrooms}
                                </div>
                                <c:if test="${not empty room.category}">
                                    <div class="room-info-item">
                                        <i class="bi bi-tag text-primary"></i> Loại: ${room.category}
                                    </div>
                                </c:if>
                            </div>
                            
                            <p class="room-description">${room.description}</p>
                            
                            <div class="room-footer">
                                <div class="room-location">
                                    <i class="bi bi-geo-alt"></i>
                                    <c:if test="${room.location != null}">
                                        ${room.location.ward}, ${room.location.district}, ${room.location.city}
                                    </c:if>
                                </div>
                                <a href="<c:url value='/rooms/${room.id}'/>" class="btn-view">Xem chi tiết</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:if>
            
            <c:if test="${empty rooms}">
                <div class="empty-state">
                    <h3><i class="bi bi-inbox" style="font-size: 2rem;"></i></h3>
                    <h3>Không tìm thấy phòng nào</h3>
                    <p>Vui lòng thử thay đổi bộ lọc hoặc quay lại sau</p>
                </div>
            </c:if>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
