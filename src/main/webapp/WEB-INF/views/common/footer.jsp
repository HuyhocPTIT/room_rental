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
</body>
</html>