<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<c:set var="pageTitle" value="TrọTốt - Thông tin cá nhân" scope="request" />
<c:set var="bodyClass" value="profile-page" scope="request" />
<c:set var="mainClass" value="container my-4" scope="request" />
<jsp:include page="../common/header.jsp" />

<div class="row">
    <div class="col-md-8 offset-md-2">
        <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
        </c:if>

        <div class="card mb-3">
            <div class="card-body d-flex">
                <div style="width:100px; height:100px; margin-right:16px;">
                    <c:choose>
                        <c:when test="${not empty profile.avatar}">
                            <img src="${profile.avatar}" alt="Avatar" style="width:100%; height:100%; object-fit:cover; border-radius:50%;">
                        </c:when>
                        <c:otherwise>
                            <div style="width:100px; height:100px; border-radius:50%; background:#f1f1f1; display:flex; align-items:center; justify-content:center; font-weight:bold; font-size:28px;">
                                <c:out value="${fn:toUpperCase(fn:substring(user.username,0,1))}" />
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div style="flex:1;">
                    <h4>${user.username}</h4>
                    <p class="mb-1"><strong>Họ tên:</strong> <c:out value="${profile.name != null ? profile.name : ''}"/></p>
                    <p class="mb-1"><strong>Số điện thoại:</strong> <c:out value="${profile.phoneNumber != null ? profile.phoneNumber : ''}"/></p>
                    <p class="mb-1"><strong>Email:</strong> <c:out value="${profile.email != null ? profile.email : ''}"/></p>
                    <button id="editBtn" class="btn btn-primary btn-sm mt-2">Chỉnh sửa</button>
                </div>
            </div>
        </div>

        <div id="editForm" style="display:none;">
            <div class="card">
                <div class="card-body">
                    <h5>Chỉnh sửa thông tin</h5>
                    <form action="<c:url value='/profile/update'/>" method="post">
                        <div class="mb-3">
                            <label class="form-label">Họ tên</label>
                            <input type="text" name="name" class="form-control" value="${profile.name}" required />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số điện thoại</label>
                            <input type="text" name="phoneNumber" class="form-control" value="${profile.phoneNumber}" />
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-control" value="${profile.email}" />
                        </div>
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-success">Lưu</button>
                            <button type="button" id="cancelBtn" class="btn btn-secondary">Hủy</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    document.getElementById('editBtn').addEventListener('click', function(){
        document.getElementById('editForm').style.display = 'block';
        window.scrollTo({ top: document.getElementById('editForm').offsetTop - 80, behavior: 'smooth' });
    });
    document.getElementById('cancelBtn').addEventListener('click', function(){
        document.getElementById('editForm').style.display = 'none';
    });
</script>

<jsp:include page="../common/footer.jsp" />
