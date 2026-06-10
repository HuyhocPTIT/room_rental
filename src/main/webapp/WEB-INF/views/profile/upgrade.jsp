<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="pageTitle" value="Nâng cấp tài khoản Chủ trọ" scope="request" />
<c:set var="bodyClass" value="profile-page" scope="request" />
<c:set var="mainClass" value="container my-5" scope="request" />
<jsp:include page="../common/header.jsp" />

<style>
    .upgrade-wrapper {
        display: flex;
        justify-content: center;
        align-items: flex-start;
        padding: 20px 0 60px;
    }

    .upgrade-card {
        width: 100%;
        max-width: 520px;
        background: #fff;
        border-radius: 20px;
        box-shadow: 0 4px 32px rgba(0, 0, 0, 0.08);
        overflow: hidden;
        animation: upgradeSlideIn 0.5s ease;
    }

    @keyframes upgradeSlideIn {
        from { opacity: 0; transform: translateY(20px); }
        to   { opacity: 1; transform: translateY(0); }
    }

    /* ── Header gradient ── */
    .upgrade-header {
        position: relative;
        padding: 40px 32px 48px;
        background: linear-gradient(135deg, #e35d2b 0%, #ff385c 50%, #f7883a 100%);
        text-align: center;
        overflow: hidden;
    }

    .upgrade-header::before {
        content: '';
        position: absolute;
        top: -60px;
        right: -60px;
        width: 180px;
        height: 180px;
        background: rgba(255,255,255,0.08);
        border-radius: 50%;
    }

    .upgrade-header::after {
        content: '';
        position: absolute;
        bottom: -40px;
        left: -30px;
        width: 120px;
        height: 120px;
        background: rgba(255,255,255,0.06);
        border-radius: 50%;
    }

    .upgrade-icon-wrap {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        width: 80px;
        height: 80px;
        background: rgba(255, 255, 255, 0.18);
        backdrop-filter: blur(8px);
        border-radius: 50%;
        margin-bottom: 16px;
        font-size: 38px;
        animation: upgradeIconPulse 2.5s ease-in-out infinite;
        position: relative;
        z-index: 1;
    }

    @keyframes upgradeIconPulse {
        0%, 100% { transform: scale(1); }
        50%      { transform: scale(1.08); }
    }

    .upgrade-header h2 {
        margin: 0 0 6px;
        color: #fff;
        font-size: 24px;
        font-weight: 800;
        position: relative;
        z-index: 1;
    }

    .upgrade-header p {
        margin: 0;
        color: rgba(255,255,255,0.85);
        font-size: 14px;
        position: relative;
        z-index: 1;
    }

    /* ── Badge ribbon ── */
    .upgrade-badge {
        display: flex;
        justify-content: center;
        margin-top: -18px;
        position: relative;
        z-index: 2;
    }

    .upgrade-badge span {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 8px 20px;
        background: linear-gradient(135deg, #ffa726, #ff7043);
        color: #fff;
        font-size: 12px;
        font-weight: 700;
        letter-spacing: 0.5px;
        border-radius: 20px;
        box-shadow: 0 4px 14px rgba(255, 112, 67, 0.35);
        text-transform: uppercase;
    }

    /* ── Body ── */
    .upgrade-body {
        padding: 32px 32px 28px;
    }

    .upgrade-desc {
        color: #555;
        font-size: 14.5px;
        line-height: 1.7;
        text-align: center;
        margin: 0 0 28px;
    }

    /* ── Feature list ── */
    .upgrade-features {
        list-style: none;
        padding: 0;
        margin: 0 0 28px;
        display: flex;
        flex-direction: column;
        gap: 12px;
    }

    .upgrade-features li {
        display: flex;
        align-items: center;
        gap: 14px;
        padding: 14px 16px;
        background: #fef7f4;
        border: 1px solid #fde8e0;
        border-radius: 12px;
        transition: transform 0.2s, box-shadow 0.2s;
    }

    .upgrade-features li:hover {
        transform: translateX(4px);
        box-shadow: 0 2px 12px rgba(227, 93, 43, 0.08);
    }

    .upgrade-feat-icon {
        display: flex;
        align-items: center;
        justify-content: center;
        width: 40px;
        height: 40px;
        background: linear-gradient(135deg, #e35d2b, #ff385c);
        border-radius: 10px;
        font-size: 18px;
        flex-shrink: 0;
    }

    .upgrade-feat-text {
        flex: 1;
    }

    .upgrade-feat-text strong {
        display: block;
        color: #1a1a1a;
        font-size: 14px;
        font-weight: 700;
        margin-bottom: 2px;
    }

    .upgrade-feat-text span {
        color: #888;
        font-size: 12.5px;
    }

    /* ── CTA button ── */
    .upgrade-cta {
        display: block;
        width: 100%;
        padding: 14px;
        border: none;
        border-radius: 12px;
        background: linear-gradient(135deg, #e35d2b, #ff385c);
        color: #fff;
        font-size: 16px;
        font-weight: 700;
        cursor: pointer;
        transition: transform 0.2s, box-shadow 0.2s;
        position: relative;
        overflow: hidden;
    }

    .upgrade-cta::before {
        content: '';
        position: absolute;
        top: 0;
        left: -100%;
        width: 100%;
        height: 100%;
        background: linear-gradient(90deg, transparent, rgba(255,255,255,0.15), transparent);
        transition: left 0.5s;
    }

    .upgrade-cta:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(227, 93, 43, 0.35);
    }

    .upgrade-cta:hover::before {
        left: 100%;
    }

    .upgrade-cta:active {
        transform: translateY(0);
    }

    /* ── Footer link ── */
    .upgrade-footer {
        text-align: center;
        padding: 0 32px 28px;
    }

    .upgrade-footer a {
        color: #999;
        font-size: 13px;
        text-decoration: none;
        transition: color 0.2s;
    }

    .upgrade-footer a:hover {
        color: #e35d2b;
    }

    /* ── Responsive ── */
    @media (max-width: 576px) {
        .upgrade-card {
            border-radius: 14px;
        }
        .upgrade-header {
            padding: 32px 20px 40px;
        }
        .upgrade-body {
            padding: 24px 20px 20px;
        }
        .upgrade-footer {
            padding: 0 20px 20px;
        }
    }
</style>

<div class="upgrade-wrapper">
    <div class="upgrade-card">
        <%-- Header --%>
        <div class="upgrade-header">
            <div class="upgrade-icon-wrap">🏠</div>
            <h2>Trở thành Chủ trọ</h2>
            <p>Mở rộng cơ hội kinh doanh cho thuê của bạn</p>
        </div>

        <%-- Badge --%>
        <div class="upgrade-badge">
            <span>⭐ Miễn phí đăng ký</span>
        </div>

        <%-- Body --%>
        <div class="upgrade-body">
            <p class="upgrade-desc">
                Nâng cấp tài khoản để đăng tin cho thuê phòng trọ, căn hộ, nhà nguyên căn 
                và tiếp cận hàng nghìn người thuê tiềm năng mỗi ngày.
            </p>

            <ul class="upgrade-features">
                <li>
                    <div class="upgrade-feat-icon">📝</div>
                    <div class="upgrade-feat-text">
                        <strong>Đăng tin không giới hạn</strong>
                        <span>Tạo và quản lý nhiều bài đăng cùng lúc</span>
                    </div>
                </li>
                <li>
                    <div class="upgrade-feat-icon">👥</div>
                    <div class="upgrade-feat-text">
                        <strong>Tiếp cận khách hàng nhanh</strong>
                        <span>Hàng nghìn người thuê tìm kiếm mỗi ngày</span>
                    </div>
                </li>
                <li>
                    <div class="upgrade-feat-icon">📊</div>
                    <div class="upgrade-feat-text">
                        <strong>Công cụ quản lý tiện lợi</strong>
                        <span>Theo dõi tin đăng, nhận phản hồi trực tiếp</span>
                    </div>
                </li>
                <li>
                    <div class="upgrade-feat-icon">💬</div>
                    <div class="upgrade-feat-text">
                        <strong>Chat trực tiếp với khách</strong>
                        <span>Trao đổi nhanh chóng qua hệ thống nhắn tin</span>
                    </div>
                </li>
            </ul>

            <form action="<c:url value='/profile/upgrade-landlord'/>" method="post">
                <button type="submit" class="upgrade-cta">
                    🚀 Gửi yêu cầu nâng cấp
                </button>
            </form>
        </div>

        <div class="upgrade-footer">
            <a href="<c:url value='/'/>">← Quay lại trang chủ</a>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />
