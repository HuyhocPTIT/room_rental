<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

</main>

<footer style="background-color: #004E89; color: white; padding: 40px 0 20px; margin-top: 60px;">
    <div class="container">
        <div class="row">
            <div class="col-md-4 mb-4">
                <h5 style="font-weight: 700;">🏠 RoomRental</h5>
                <p>Nền tảng tìm kiếm phòng trọ nhanh chóng, tin cậy và minh bạch cho sinh viên và người lao động.</p>
            </div>
            <div class="col-md-4 mb-4">
                <h5 style="font-weight: 700;">Danh Mục</h5>
                <ul style="list-style: none; padding: 0;">
                    <li><a href="<c:url value='/'/>" style="color: #FFA500; text-decoration: none;">Trang chủ</a></li>
                    <li><a href="<c:url value='/rooms'/>" style="color: #FFA500; text-decoration: none;">Danh sách phòng</a></li>
                    <li><a href="<c:url value='/auth/login'/>" style="color: #FFA500; text-decoration: none;">Đăng nhập</a></li>
                </ul>
            </div>
            <div class="col-md-4 mb-4">
                <h5 style="font-weight: 700;">Liên Hệ</h5>
                <p><i class="bi bi-telephone"></i> 1800-0000</p>
                <p><i class="bi bi-envelope"></i> support@roomrental.com</p>
            </div>
        </div>
        <hr style="border-color: rgba(255,255,255,0.3);">
        <div class="text-center">
            <p style="margin: 0;">&copy; 2026 RoomRental. All rights reserved.</p>
        </div>
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="<c:url value='/js/main.js'/>"></script>

</body>
</html>