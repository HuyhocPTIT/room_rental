<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="common/header.jsp" />

<div class="jumbotron text-center bg-light p-5 rounded">
    <h1 class="display-4">Tìm phòng trọ sinh viên nhanh chóng!</h1>
    <p class="lead">Hàng ngàn phòng trọ, căn hộ, chung cư mini đang chờ bạn.</p>

    <div id="search-section" class="card mt-4 shadow-sm">
        <div class="card-body">
            <form action="<c:url value='/rooms/search'/>" method="GET" class="row g-3">
                <div class="col-md-4">
                    <input type="text" name="keyword" class="form-control" placeholder="Nhập tên đường, quận, phường...">
                </div>
                <div class="col-md-3">
                    <select name="priceRange" class="form-select">
                        <option value="">Chọn mức giá</option>
                        <option value="0-2">Dưới 2 triệu</option>
                        <option value="2-4">Từ 2 - 4 triệu</option>
                        <option value="4+">Trên 4 triệu</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <select name="category" class="form-select">
                        <option value="">Loại phòng</option>
                        <option value="APARTMENT">Chung cư mini</option>
                        <option value="HOUSE">Nhà nguyên căn</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-success w-100">Tìm kiếm</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp" />