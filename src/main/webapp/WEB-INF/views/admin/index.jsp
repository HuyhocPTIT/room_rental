<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - RoomRental</title>
    <link href="<c:url value='/css/style.css'/>" rel="stylesheet">
    <link href="<c:url value='/css/admin.css'/>" rel="stylesheet">
</head>
<body>
<div class="admin-wrap">

    <!-- ══ SIDEBAR ══ -->
    <aside class="admin-sidebar">
        <div class="sb-logo">Room<span>Rental</span></div>

        <nav class="sb-nav">
            <div class="sb-section">Tổng quan</div>
            <a href="#stats" class="sb-link">Thống kê</a>

            <div class="sb-section">Quản lý</div>
            <a href="#users" class="sb-link">Người dùng</a>
            <a href="#landlord-requests" class="sb-link">
                Duyệt Landlord
                <c:if test="${stats.pendingLandlordRequests > 0}">
                    <span class="sb-badge">${stats.pendingLandlordRequests}</span>
                </c:if>
            </a>
            <a href="#post-moderation" class="sb-link">
                Duyệt bài đăng
                <c:if test="${stats.pendingPosts > 0}">
                    <span class="sb-badge">${stats.pendingPosts}</span>
                </c:if>
            </a>
            <a href="#top-posts" class="sb-link">Top bài đăng</a>

            <div class="sb-section">Khác</div>
            <a href="<c:url value='/'/>" class="sb-link">Trang chủ</a>
        </nav>

        <div class="sb-bottom">
            <form action="<c:url value='/auth/logout'/>" method="post" class="logout-form">
                <button type="submit" class="adm-btn btn-ghost btn-full">Đăng xuất</button>
            </form>
        </div>
    </aside>

    <!-- ══ MAIN ══ -->
    <main class="admin-main">

        <!-- Header -->
        <div class="page-hd">
            <div>
                <h1>Bảng điều khiển Admin</h1>
                <p>Xin chào, <strong>${currentUser.username}</strong> — Quản trị viên hệ thống</p>
            </div>
        </div>

        <!-- Alerts -->
        <c:if test="${not empty success}">
            <div class="adm-alert adm-alert-ok">✓ ${success}</div>
        </c:if>
        <c:if test="${not empty error}">
            <div class="adm-alert adm-alert-err">✗ ${error}</div>
        </c:if>

        <!-- ══ THỐNG KÊ ══ -->
        <section id="stats" style="margin-bottom: 24px;">
            <div class="sec-title">Thống kê hệ thống</div>

            <div class="stats-row">
                <div class="stat-box">
                    <div><div class="stat-val">${stats.totalUsers}</div><div class="stat-lbl">Tổng người dùng</div></div>
                </div>
                <div class="stat-box">
                    <div><div class="stat-val">${stats.totalLandlords}</div><div class="stat-lbl">Người cho thuê</div></div>
                </div>
                <div class="stat-box">
                    <div><div class="stat-val">${stats.totalTenants}</div><div class="stat-lbl">Người thuê</div></div>
                </div>
                <div class="stat-box">
                    <div><div class="stat-val">${stats.totalAdmins}</div><div class="stat-lbl">Quản trị viên</div></div>
                </div>
                <div class="stat-box">
                    <div><div class="stat-val">${stats.totalPosts}</div><div class="stat-lbl">Tổng bài đăng</div></div>
                </div>
                <div class="stat-box">
                    <div><div class="stat-val">${stats.activePosts}</div><div class="stat-lbl">Bài đang hoạt động</div></div>
                </div>
                <div class="stat-box">
                    <div><div class="stat-val">${stats.totalFavorites}</div><div class="stat-lbl">Lượt yêu thích</div></div>
                </div>
                <div class="stat-box">
                    <div><div class="stat-val">${stats.totalMessages}</div><div class="stat-lbl">Tin nhắn</div></div>
                </div>
            </div>

            <div class="hl-row">
                <div class="hl-box orange">
                    <div><div class="hl-val">${stats.pendingLandlordRequests}</div><div class="hl-lbl">Yêu cầu Landlord chờ duyệt</div></div>
                </div>
                <div class="hl-box indigo">
                    <div><div class="hl-val">${stats.pendingPosts}</div><div class="hl-lbl">Bài đăng chờ duyệt</div></div>
                </div>
            </div>
        </section>

        <!-- ══ DUYỆT BÀI ĐĂNG ══ -->
        <section id="post-moderation" style="margin-bottom: 24px;">
            <div class="sec-title">Bài đăng chờ duyệt</div>
            <div class="adm-card">
                <div class="adm-card-head">
                    <h2>Danh sách bài cần duyệt</h2>
                    <span class="bdg bdg-pending">${stats.pendingPosts} chờ duyệt</span>
                </div>
                <c:choose>
                    <c:when test="${empty pendingPosts}">
                        <div class="empty-row">✓ Không có bài đăng nào đang chờ duyệt.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="tbl-wrap">
                            <table>
                                <thead>
                                <tr>
                                    <th>Tiêu đề</th>
                                    <th>Người đăng</th>
                                    <th>Địa chỉ</th>
                                    <th>Giá (VNĐ/tháng)</th>
                                    <th>Loại phòng</th>
                                    <th>Ngày tạo</th>
                                    <th>Thao tác</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="post" items="${pendingPosts}">
                                    <tr>
                                        <td>
                                            <div style="font-weight:600;">${post.title}</div>
                                            <div class="td-sub">ID #${post.id}</div>
                                        </td>
                                        <td>${post.user.username}</td>
                                        <td>${post.address}</td>
                                        <td><fmt:formatNumber value="${post.price}" type="number" groupingUsed="true"/> đ</td>
                                        <td>
                                            <span class="bdg bdg-neutral">
                                                <c:choose>
                                                    <c:when test="${post.category == 'MOTEL_ROOM'}">Phòng trọ</c:when>
                                                    <c:when test="${post.category == 'MINI_APARTMENT'}">Căn hộ mini</c:when>
                                                    <c:when test="${post.category == 'APARTMENT'}">Chung cư</c:when>
                                                    <c:when test="${post.category == 'WHOLE_HOUSE'}">Nguyên căn</c:when>
                                                    <c:otherwise>${post.category}</c:otherwise>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td class="td-sub">${post.createdAt}</td>
                                        <td>
                                            <div class="act-row">
                                                <form action="<c:url value='/admin/posts/${post.id}/approve'/>" method="post">
                                                    <button type="submit" class="adm-btn btn-success">✓ Duyệt</button>
                                                </form>
                                                <form action="<c:url value='/admin/posts/${post.id}/reject'/>" method="post"
                                                      onsubmit="return confirm('Từ chối bài đăng này?');">
                                                    <button type="submit" class="adm-btn btn-danger" style="background-color: #f59e0b;">✗ Từ chối</button>
                                                </form>
                                                <form action="<c:url value='/admin/posts/${post.id}/delete'/>" method="post"
                                                      onsubmit="return confirm('Bạn có chắc chắn muốn XÓA VĨNH VIỄN bài đăng này không?');">
                                                    <button type="submit" class="adm-btn btn-danger">🗑 Xóa</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <!-- ══ THÊM NGƯỜI DÙNG ══ -->
        <section id="users" style="margin-bottom: 24px;">
            <div class="sec-title">Thêm người dùng mới</div>
            <div class="adm-card">
                <div class="adm-card-body">
                    <form action="<c:url value='/admin/users/create'/>" method="post" class="f-grid">
                        <div class="f-group">
                            <label class="f-label">Tên đăng nhập *</label>
                            <input type="text" name="username" class="f-input" placeholder="Nhập tên đăng nhập" required>
                        </div>
                        <div class="f-group">
                            <label class="f-label">Mật khẩu *</label>
                            <input type="password" name="password" class="f-input" placeholder="Nhập mật khẩu" required>
                        </div>
                        <div class="f-group">
                            <label class="f-label">Vai trò *</label>
                            <select name="role" class="f-select" required>
                                <c:forEach var="role" items="${roles}">
                                    <option value="${role}">${role}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="f-group">
                            <label class="f-label">Họ và tên</label>
                            <input type="text" name="name" class="f-input" placeholder="Nhập họ tên">
                        </div>
                        <div class="f-group">
                            <label class="f-label">Số điện thoại</label>
                            <input type="text" name="phoneNumber" class="f-input" placeholder="0xxxxxxxxx">
                        </div>
                        <div class="f-group">
                            <label class="f-label">Email</label>
                            <input type="email" name="email" class="f-input" placeholder="example@email.com">
                        </div>
                        <div class="f-group f-full">
                            <button type="submit" class="adm-btn btn-primary">Tạo tài khoản</button>
                        </div>
                    </form>
                </div>
            </div>
        </section>

        <!-- ══ DANH SÁCH NGƯỜI DÙNG ══ -->
        <section style="margin-bottom: 24px;">
            <div class="sec-title" style="display:flex; justify-content:space-between; align-items:center;">
                <span>Danh sách người dùng</span>
                <input type="text" id="userSearch" class="tbl-search" placeholder="Tìm theo tên đăng nhập...">
            </div>
            <div class="adm-card">
                <div class="adm-card-head">
                    <h2>Tất cả tài khoản</h2>
                    <span class="bdg bdg-neutral">${stats.totalUsers} tài khoản</span>
                </div>
                <div class="tbl-wrap">
                    <table id="usersTable">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Tên đăng nhập</th>
                            <th>Họ tên / Email / SĐT</th>
                            <th>Vai trò</th>
                            <th>Trạng thái YC</th>
                            <th>Số bài đăng</th>
                            <th>Ngày tạo</th>
                            <th>Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="user" items="${users}">
                            <tr>
                                <td style="color:#94a3b8;">#${user.id}</td>
                                <td>
                                    <div style="font-weight:600;">${user.username}</div>
                                    <details>
                                        <summary>Sửa thông tin</summary>
                                        <div class="edit-box">
                                            <form action="<c:url value='/admin/users/${user.id}/update'/>" method="post" class="f-grid">
                                                <div class="f-group">
                                                    <label class="f-label">Tên đăng nhập</label>
                                                    <input type="text" name="username" class="f-input" value="${user.username}" required>
                                                </div>
                                                <div class="f-group">
                                                    <label class="f-label">Mật khẩu mới</label>
                                                    <input type="password" name="password" class="f-input" placeholder="Để trống nếu không đổi">
                                                </div>
                                                <div class="f-group">
                                                    <label class="f-label">Vai trò</label>
                                                    <select name="role" class="f-select">
                                                        <c:forEach var="role" items="${roles}">
                                                            <option value="${role}" ${user.role == role ? 'selected' : ''}>${role}</option>
                                                        </c:forEach>
                                                    </select>
                                                </div>
                                                <div class="f-group">
                                                    <label class="f-label">Họ tên</label>
                                                    <input type="text" name="name" class="f-input" value="${user.profile != null ? user.profile.name : ''}">
                                                </div>
                                                <div class="f-group">
                                                    <label class="f-label">Số điện thoại</label>
                                                    <input type="text" name="phoneNumber" class="f-input" value="${user.profile != null ? user.profile.phoneNumber : ''}">
                                                </div>
                                                <div class="f-group">
                                                    <label class="f-label">Email</label>
                                                    <input type="email" name="email" class="f-input" value="${user.profile != null ? user.profile.email : ''}">
                                                </div>
                                                <div class="f-group f-full">
                                                    <button type="submit" class="adm-btn btn-primary">Lưu thay đổi</button>
                                                </div>
                                            </form>
                                        </div>
                                    </details>
                                </td>
                                <td>
                                    <div>${user.profile != null ? user.profile.name : '—'}</div>
                                    <div class="td-sub">${user.profile != null ? user.profile.email : ''}</div>
                                    <div class="td-sub">${user.profile != null ? user.profile.phoneNumber : ''}</div>
                                </td>
                                <td>
                                    <span class="bdg ${user.role == 'ADMIN' ? 'bdg-admin' : user.role == 'LANDLORD' ? 'bdg-landlord' : 'bdg-tenant'}">
                                        ${user.role}
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.landlordRequestStatus == 'PENDING'}">
                                            <span class="bdg bdg-pending">PENDING</span>
                                        </c:when>
                                        <c:when test="${user.landlordRequestStatus == 'APPROVED'}">
                                            <span class="bdg bdg-active">APPROVED</span>
                                        </c:when>
                                        <c:when test="${user.landlordRequestStatus == 'REJECTED'}">
                                            <span class="bdg bdg-hidden">REJECTED</span>
                                        </c:when>
                                        <c:otherwise><span style="color:#cbd5e1;">—</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <strong>${user.roomPosts != null ? user.roomPosts.size() : 0}</strong> bài
                                </td>
                                <td class="td-sub">${user.createdAt}</td>
                                <td>
                                    <div class="act-row">
                                        <c:if test="${user.landlordRequestStatus == 'PENDING'}">
                                            <form action="<c:url value='/admin/users/${user.id}/approve-landlord'/>" method="post">
                                                <button type="submit" class="adm-btn btn-success">✓ Duyệt</button>
                                            </form>
                                        </c:if>
                                        <form action="<c:url value='/admin/users/${user.id}/delete'/>" method="post"
                                              onsubmit="return confirm('Xóa người dùng ${user.username}?');">
                                            <button type="submit" class="adm-btn btn-danger">Xóa</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </section>

        <!-- ══ DUYỆT LANDLORD ══ -->
        <section id="landlord-requests" style="margin-bottom: 24px;">
            <div class="sec-title">Yêu cầu trở thành Landlord</div>
            <div class="adm-card">
                <div class="adm-card-head">
                    <h2>Danh sách chờ duyệt</h2>
                    <span class="bdg bdg-pending">${stats.pendingLandlordRequests} chờ</span>
                </div>
                <c:choose>
                    <c:when test="${empty pendingLandlordRequests}">
                        <div class="empty-row">✓ Không có yêu cầu nào đang chờ duyệt.</div>
                    </c:when>
                    <c:otherwise>
                        <div class="tbl-wrap">
                            <table>
                                <thead>
                                <tr>
                                    <th>Tên đăng nhập</th>
                                    <th>Họ tên</th>
                                    <th>Email</th>
                                    <th>Số điện thoại</th>
                                    <th>Vai trò hiện tại</th>
                                    <th>Thao tác</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="ru" items="${pendingLandlordRequests}">
                                    <tr>
                                        <td><strong>${ru.username}</strong></td>
                                        <td>${ru.profile != null ? ru.profile.name : '—'}</td>
                                        <td class="td-sub">${ru.profile != null ? ru.profile.email : '—'}</td>
                                        <td class="td-sub">${ru.profile != null ? ru.profile.phoneNumber : '—'}</td>
                                        <td><span class="bdg bdg-tenant">${ru.role}</span></td>
                                        <td>
                                            <div class="act-row">
                                                <form action="<c:url value='/admin/users/${ru.id}/approve-landlord'/>" method="post">
                                                    <button type="submit" class="adm-btn btn-success">✓ Duyệt</button>
                                                </form>
                                                <form action="<c:url value='/admin/users/${ru.id}/reject-landlord'/>" method="post">
                                                    <button type="submit" class="adm-btn btn-danger">✗ Từ chối</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>

        <!-- ══ TOP BÀI ĐĂNG ══ -->
        <c:if test="${not empty topFavoritedPosts}">
            <section id="top-posts" style="margin-bottom: 24px;">
                <div class="sec-title">Bài đăng được yêu thích nhất</div>
                <div class="adm-card">
                    <c:forEach var="post" items="${topFavoritedPosts}" varStatus="st">
                        <div class="post-row">
                            <div class="post-rank ${st.index == 0 ? 'r1' : st.index == 1 ? 'r2' : st.index == 2 ? 'r3' : ''}">#${st.index + 1}</div>
                            <div class="post-info">
                                <div class="post-ttl">${post.title}</div>
                                <div class="post-meta">${post.user.username} · ${post.address}</div>
                            </div>
                            <div class="post-metric">
                                <div class="metric-val">${post.favorites.size()}</div>
                                <div class="metric-lbl">Yêu thích</div>
                            </div>
                            <div class="post-metric">
                                <div class="metric-val" style="color:#16a34a;">
                                    <fmt:formatNumber value="${post.price}" type="number" groupingUsed="true"/> đ
                                </div>
                                <div class="metric-lbl">Tháng</div>
                            </div>
                            <div class="post-metric" style="min-width: 80px; text-align: right;">
                                <form action="<c:url value='/admin/posts/${post.id}/delete'/>" method="post"
                                      onsubmit="return confirm('Bạn có chắc chắn muốn XÓA VĨNH VIỄN bài đăng này không?');">
                                    <button type="submit" class="adm-btn btn-danger">Xóa</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </section>
        </c:if>

        <c:if test="${not empty recentPosts}">
            <section style="margin-bottom: 24px;">
                <div class="sec-title">Bài đăng mới nhất</div>
                <div class="adm-card">
                    <c:forEach var="post" items="${recentPosts}" varStatus="st">
                        <div class="post-row">
                            <div class="post-rank">#${st.index + 1}</div>
                            <div class="post-info">
                                <div class="post-ttl">${post.title}</div>
                                <div class="post-meta">${post.user.username} · ${post.address} · ${post.createdAt}</div>
                            </div>
                            <div class="post-metric">
                                <div class="metric-val">${post.favorites.size()}</div>
                                <div class="metric-lbl">Yêu thích</div>
                            </div>
                            <div class="post-metric" style="min-width: 80px; text-align: right;">
                                <form action="<c:url value='/admin/posts/${post.id}/delete'/>" method="post"
                                      onsubmit="return confirm('Bạn có chắc chắn muốn XÓA VĨNH VIỄN bài đăng này không?');">
                                    <button type="submit" class="adm-btn btn-danger">Xóa</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </section>
        </c:if>

    </main>
</div>

<script>
    // Tìm kiếm user phía client
    document.getElementById('userSearch').addEventListener('input', function () {
        var q = this.value.toLowerCase();
        document.querySelectorAll('#usersTable tbody tr').forEach(function(row) {
            var name = row.querySelector('td:nth-child(2)').textContent.toLowerCase();
            row.style.display = name.includes(q) ? '' : 'none';
        });
    });

    // Tự ẩn alert sau 4 giây
    setTimeout(function() {
        document.querySelectorAll('.adm-alert').forEach(function(el) {
            el.style.transition = 'opacity 0.4s';
            el.style.opacity = '0';
            setTimeout(function() { el.remove(); }, 400);
        });
    }, 4000);
</script>
</body>
</html>
