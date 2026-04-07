<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:if test="${room.id != null}">Sửa</c:if><c:if test="${room.id == null}">Đăng</c:if> Bài - RoomRental</title>
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
        
        .form-container {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .form-title {
            font-size: 1.8rem;
            font-weight: 700;
            color: var(--secondary-color);
            margin-bottom: 30px;
        }
        
        .form-section {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }
        
        .form-section:last-child {
            border-bottom: none;
        }
        
        .form-section h5 {
            color: var(--primary-color);
            font-weight: 700;
            margin-bottom: 15px;
        }
        
        .form-label {
            font-weight: 600;
            color: var(--secondary-color);
            margin-bottom: 8px;
        }
        
        .form-control, .form-select {
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 12px;
            font-size: 0.95rem;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 0.2rem rgba(255, 107, 53, 0.25);
        }
        
        .btn-submit {
            background-color: var(--primary-color);
            color: white;
            padding: 12px 40px;
            border-radius: 4px;
            border: none;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            margin-right: 10px;
        }
        
        .btn-submit:hover {
            background-color: #E55A2B;
        }
        
        .btn-cancel {
            background-color: #f0f0f0;
            color: #333;
            padding: 12px 40px;
            border-radius: 4px;
            border: 1px solid #ddd;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }
        
        .btn-cancel:hover {
            background-color: #e0e0e0;
        }
        
        .info-text {
            color: #999;
            font-size: 0.85rem;
            margin-top: 5px;
        }
    </style>
</head>
<body>
<jsp:include page="common/header.jsp" />

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="form-container">
                <h1 class="form-title">
                    <c:if test="${room.id != null}">
                        <i class="bi bi-pencil-square"></i> Sửa Bài Đăng
                    </c:if>
                    <c:if test="${room.id == null}">
                        <i class="bi bi-plus-circle"></i> Đăng Bài Cho Thuê Phòng
                    </c:if>
                </h1>

                <form method="post" action="${room.id != null ? '/rooms/' + room.id : '/rooms'}">
                    
                    <!-- Thông tin cơ bản -->
                    <div class="form-section">
                        <h5><i class="bi bi-info-circle"></i> Thông Tin Cơ Bản</h5>
                        
                        <div class="mb-3">
                            <label class="form-label">Tiêu đề <span style="color: red;">*</span></label>
                            <input type="text" class="form-control" name="title" value="${room.title}" 
                                   placeholder="Ví dụ: Phòng 25m² gần trường đại học" required>
                            <div class="info-text">Tiêu đề rõ ràng sẽ thu hút hơn người tìm kiếm</div>
                        </div>
                        
                        <div class="mb-3">
                            <label class="form-label">Mô tả chi tiết <span style="color: red;">*</span></label>
                            <textarea class="form-control" name="description" rows="5" 
                                      placeholder="Mô tả chi tiết về phòng, điều kiện, tiện ích..." required>${room.description}</textarea>
                            <div class="info-text">Mô tả càng chi tiết, độ tin cậy càng cao</div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Loại phòng <span style="color: red;">*</span></label>
                                <select class="form-select" name="category" required>
                                    <option value="">-- Chọn loại --</option>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat}" <c:if test="${cat == room.category}">selected</c:if>>${cat}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Địa chỉ cụ thể <span style="color: red;">*</span></label>
                                <input type="text" class="form-control" name="address" value="${room.address}" 
                                       placeholder="Ví dụ: 45 Ngõ Trung Liệt, Hai Bà Trưng, Hà Nội" required>
                            </div>
                        </div>
                    </div>

                    <!-- Thông tin chi tiết -->
                    <div class="form-section">
                        <h5><i class="bi bi-house"></i> Thông Tin Phòng</h5>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Diện tích (m²) <span style="color: red;">*</span></label>
                                <input type="number" class="form-control" name="area" value="${room.area}" 
                                       placeholder="Ví dụ: 25" step="0.1" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Giá cho thuê (đ/tháng) <span style="color: red;">*</span></label>
                                <input type="number" class="form-control" name="price" value="${room.price}" 
                                       placeholder="Ví dụ: 3500000" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Số phòng ngủ <span style="color: red;">*</span></label>
                                <input type="number" class="form-control" name="bedrooms" value="${room.bedrooms}" 
                                       placeholder="1" min="1" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Số phòng tắm <span style="color: red;">*</span></label>
                                <input type="number" class="form-control" name="bathrooms" value="${room.bathrooms}" 
                                       placeholder="1" min="1" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Tiện ích</label>
                            <input type="text" class="form-control" name="utilities" value="${room.utilities}" 
                                   placeholder="Ví dụ: WiFi, Điều hòa, Tủ lạnh, Máy giặt">
                            <div class="info-text">Liệt kê các tiện ích phòng có (cách nhau bằng dấu phẩy)</div>
                        </div>
                    </div>

                    <!-- Thông tin liên hệ -->
                    <div class="form-section">
                        <h5><i class="bi bi-telephone"></i> Thông Tin Liên Hệ</h5>
                        
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Số điện thoại <span style="color: red;">*</span></label>
                                <input type="tel" class="form-control" name="phoneContact" value="${room.phoneContact}" 
                                       placeholder="0901234567" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label">Zalo (tùy chọn)</label>
                                <input type="tel" class="form-control" name="zaloContact" value="${room.zaloContact}" 
                                       placeholder="0901234567">
                            </div>
                        </div>
                    </div>

                    <!-- Buttons -->
                    <div class="mt-4 d-flex gap-2">
                        <button type="submit" class="btn-submit">
                            <i class="bi bi-check-circle"></i> 
                            <c:if test="${room.id != null}">Cập nhật</c:if>
                            <c:if test="${room.id == null}">Đăng bài</c:if>
                        </button>
                        <a href="/rooms" class="btn-cancel">
                            <i class="bi bi-x-circle"></i> Hủy
                        </a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp" />

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
