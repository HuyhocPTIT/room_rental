<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:set var="pageTitle" value="TrọTốt - Quản lý bài đăng của tôi" scope="request" />
<c:set var="bodyClass" value="my-posts-page" scope="request" />
<c:set var="mainClass" value="my-posts-main" scope="request" />
<jsp:include page="../common/header.jsp"/>

<section class="featured-rooms" style="padding-top: 40px; min-height: 70vh;">
    <div class="container" style="max-width: 1200px; margin: 0 auto; padding: 0 20px;">

        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
            <div>
                <h2 style="margin: 0; font-size: 28px; color: #2c3e50; font-weight: 700;">Danh sách phòng trọ của tôi</h2>
                <p style="margin: 5px 0 0 0; color: #7f8c8d;">Quản lý và chỉnh sửa các bài đăng cho thuê phòng của bạn</p>
            </div>

            <button class="btn-create-post"
                    type="button"
                    onclick="openPostModal()"
                    style="border-radius: 8px; font-size: 15px; padding: 12px 24px; white-space: nowrap; cursor: pointer; background-color: #2ecc71; color: white; border: none; font-weight: 600; display: inline-flex; align-items: center; gap: 6px; box-shadow: 0 4px 6px rgba(46, 204, 113, 0.2); transition: all 0.2s;"
                    onmouseover="this.style.background='#27ae60'; this.style.transform='translateY(-1px)';"
                    onmouseout="this.style.background='#2ecc71'; this.style.transform='translateY(0)';">
                <span>➕</span> Đăng tin mới
            </button>
        </div>

        <div class="cards" id="cards" style="display: flex; flex-direction: column; gap: 5px;">
            <c:forEach var="room" items="${rooms}" varStatus="status">
                <c:set var="room" value="${room}" scope="request"/>

                <div style="width: 100%; position: relative; z-index: 1;">
                    <jsp:include page="../postmanage/my-post-item.jsp"/>
                </div>

                <c:if test="${!status.last}">
                    <div style="width: 100%; height: 1px; background-color: #e2e8f0; display: block; clear: both;"></div>
                </c:if>
            </c:forEach>
        </div>

        <c:if test="${empty rooms}">
            <div style="padding: 80px 0; text-align: center; color: #95a5a6;">
                <div style="font-size: 48px; margin-bottom: 15px;">📭</div>
                <p style="font-size: 16px;">Bạn chưa đăng bất kỳ bài viết phòng trọ nào.</p>
            </div>
        </c:if>
    </div>
</section>

<style>
    @keyframes customFadeIn {
        from { opacity: 0; transform: scale(0.96); }
        to { opacity: 1; transform: scale(1); }
    }
    .f-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; }
    .f-group { display: flex; flex-direction: column; gap: 6px; }
    .f-full { grid-column: span 2; }
    .f-group label { font-weight: 600; color: #4a5568; font-size: 14px; text-align: left; }
    .f-group input, .f-group select, .f-group textarea {
        padding: 10px 14px; border: 1px solid #cbd5e0; border-radius: 6px; font-size: 14px; outline: none; box-sizing: border-box; width: 100%; background: #fff !important; color: #000 !important;
    }
    .f-group input:focus, .f-group select:focus, .f-group textarea:focus { border-color: #38a169; box-shadow: 0 0 0 3px rgba(56, 161, 105, 0.15); }

    .image-preview-container { display: flex; gap: 16px; align-items: flex-start; margin-top: 10px; }
    #mainPreview { flex: 1; height: 320px; background: #f7fafc; border: 2px dashed #cbd5e0; border-radius: 8px; display: flex; align-items: center; justify-content: center; overflow: hidden; position: relative; }
    #thumbList {
        width:160px;
        display:flex;
        flex-direction:column;
        gap:10px;
        padding-right:6px;
    }

    .thumb-wrapper { position: relative; width: 100%; height: 75px; flex-shrink: 0; }
    .thumb-wrapper img { width: 100%; height: 100%; object-fit: cover; border: 1px solid #cbd5e0; border-radius: 6px; cursor: pointer; transition: all 0.15s ease; }
    .thumb-wrapper img:hover { border-color: #38a169; transform: scale(1.02); }

    .btn-remove-thumb {
        position: absolute; top: -5px; right: -5px; width: 18px; height: 18px; background: rgba(239, 68, 68, 0.9); color: white; border: none; border-radius: 50%; font-size: 12px; font-weight: bold; line-height: 16px; text-align: center; cursor: pointer; display: flex; align-items: center; justify-content: center; z-index: 10; box-shadow: 0 2px 4px rgba(0,0,0,0.2); transition: background 0.2s;
    }
    .btn-remove-thumb:hover { background: rgba(220, 38, 38, 1); }
</style>

<div id="createPostModal"
     style="
        display:none;
        position:fixed;
        inset:0;
        z-index:99999;
        background:rgba(0,0,0,0.5);
        justify-content:center;
        align-items:center;
        padding:20px;
        box-sizing:border-box;
">

    <div style="
        background:#fff;
        width:90%;
        max-width:780px;
        max-height:92vh;
        overflow-y:auto;
        border-radius:12px;
        position:relative;
        padding:24px;
        box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04);
    ">

        <button type="button"
                onclick="closePostModal()"
                style="
                    position:absolute;
                    top:12px;
                    right:15px;
                    border:none;
                    background:none;
                    font-size:28px;
                    cursor:pointer;
                    color: #718096;
                ">
            &times;
        </button>

        <h2 style="margin-top: 0; margin-bottom: 20px; font-size: 22px; color: #1a202c; font-weight: 700;">📝 Đăng tin cho thuê phòng</h2>

        <form id="uploadForm" action="/post-room"
              method="post"
              enctype="multipart/form-data">

            <div class="f-grid">

                <div class="f-group f-full" style="border-bottom: 1px solid #edf2f7; padding-bottom: 18px; margin-bottom: 8px;">
                    <label style="color: #2d3748; font-weight: 700;">Hình ảnh phòng trọ (Chọn nhiều ảnh)</label>
                    <input type="file" id="imageInput" name="images" accept="image/*" multiple style="margin-bottom: 4px;" required>

                    <div class="image-preview-container">
                        <div id="mainPreview">
                            <span style="color:#a0aec0;font-size:14px;">Chưa chọn ảnh phòng</span>
                        </div>
                        <div id="thumbList"></div>
                    </div>
                </div>

                <div class="f-group f-full">
                    <label for="roomTitle">Tiêu đề bài đăng</label>
                    <input type="text" id="roomTitle" name="title" placeholder="Ví dụ: Căn hộ mini khép kín, gần ĐH Quốc Gia..." required>
                </div>

                <div class="f-group">
                    <label for="roomCategory">Loại phòng</label>
                    <select id="roomCategory" name="category" required>
                        <option value="" disabled selected>-- Chọn loại phòng --</option>
                        <option value="MOTEL_ROOM">Phòng trọ</option>
                        <option value="MINI_APARTMENT">Căn hộ mini</option>
                        <option value="APARTMENT">Chung cư</option>
                        <option value="WHOLE_HOUSE">Nhà nguyên căn</option>
                    </select>
                </div>

                <div class="f-group">
                    <label for="roomLocation">Khu vực (Phường, Quận, Tỉnh)</label>
                    <select id="roomLocation" name="locationId" required>
                        <option value="" disabled selected>-- Chọn khu vực --</option>
                        <c:forEach var="loc" items="${locations}">
                            <option value="${loc.id}">
                                    ${loc.ward}, ${loc.district} (${loc.city})
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="f-group f-full">
                    <label for="roomAddress">Địa chỉ chi tiết (Số nhà, ngõ/ngách, tên đường)</label>
                    <input type="text" id="roomAddress" name="address" placeholder="Ví dụ: Số 45, ngõ 123, đường Xuân Thủy" required>
                </div>

                <div class="f-group">
                    <label for="roomPrice">Giá cho thuê (VND/tháng)</label>
                    <input type="number" id="roomPrice" name="price" placeholder="Ví dụ: 3000000" min="0" required>
                </div>

                <div class="f-group">
                    <label for="roomArea">Diện tích (m²)</label>
                    <input type="number" id="roomArea" name="area" placeholder="Ví dụ: 25" min="1" required>
                </div>

                <div class="f-group">
                    <label for="roomPhone">Số điện thoại liên hệ</label>
                    <input type="tel" id="roomPhone" name="phone" placeholder="Ví dụ: 0987654321" required>
                </div>

                <div class="f-group">
                    <label for="roomZalo">Liên hệ qua Zalo (SĐT Zalo)</label>
                    <input type="tel" id="roomZalo" name="zalo" placeholder="Nhập số điện thoại Zalo...">
                </div>

                <div class="f-group f-full">
                    <label for="roomDescription">Mô tả chi tiết phòng</label>
                    <textarea id="roomDescription" name="description" rows="4" placeholder="Nhập mô tả về phòng trọ (Ví dụ: điện nước tính thế nào, giờ giấc tự do, có chỗ để xe không...)" required></textarea>
                </div>
            </div>

            <div style="margin-top: 24px; display: flex; justify-content: flex-end; gap: 12px; border-top: 1px solid #edf2f7; padding-top: 16px;">
                <button type="button" onclick="closePostModal()" style="padding: 10px 20px; background: #e2e8f0; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; color: #4a5568;">Hủy</button>
                <button type="submit" style="padding: 10px 20px; background: #2ecc71; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: 600;">Đăng tin</button>
            </div>
        </form>

    </div>
</div>

<script>
    let selectedFiles = [];

    function openPostModal() {
        document.getElementById("createPostModal").style.display = "flex";
    }

    function closePostModal() {
        document.getElementById("createPostModal").style.display = "none";
        resetForm();
    }

    function resetForm() {
        const form = document.querySelector("#createPostModal form");
        if (form) {
            form.reset();
        }
        selectedFiles = [];
        renderImages();
    }

    document.addEventListener("DOMContentLoaded", () => {
        const imageInput = document.getElementById("imageInput");
        const form = document.getElementById("uploadForm");

        if (!imageInput) return;

        imageInput.addEventListener("change", function () {
            const files = Array.from(this.files);
            console.log(
                files.map(f => ({
                    name: f.name,
                    sizeMB: (f.size / 1024 / 1024).toFixed(2)
                }))
            );

            if (files.length > 0) {
                selectedFiles = files;
                renderImages();
            }
        });

        form.addEventListener("submit", function (e) {
            if (selectedFiles.length === 0) {
                alert("Vui lòng chọn ít nhất một hình ảnh cho phòng trọ!");
                e.preventDefault();
                return;
            }

            const dataTransfer = new DataTransfer();
            selectedFiles.forEach(file => {
                dataTransfer.items.add(file);
            });
            imageInput.files = dataTransfer.files;
        });
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('action') === 'create') {
            openPostModal();
        }
    });

    function renderImages() {
        const thumbList = document.getElementById("thumbList");
        const mainPreview = document.getElementById("mainPreview");

        if (!thumbList || !mainPreview) return;

        thumbList.innerHTML = "";

        if (selectedFiles.length === 0) {
            mainPreview.innerHTML = '<span style="color:#a0aec0;font-size:14px;">Chưa chọn ảnh phòng</span>';
            document.getElementById("imageInput").value = "";
            return;
        }

        showMainImage(selectedFiles[0]);

        selectedFiles.forEach((file, index) => {
            const url = URL.createObjectURL(file);
            const wrapper = document.createElement("div");
            wrapper.className = "thumb-wrapper";

            const img = document.createElement("img");
            img.src = url;
            img.onclick = () => showMainImage(file);

            const removeBtn = document.createElement("button");
            removeBtn.type = "button";
            removeBtn.className = "btn-remove-thumb";
            removeBtn.innerHTML = "&times;";
            removeBtn.onclick = (e) => {
                e.stopPropagation();
                removeImage(index);
            };

            wrapper.appendChild(img);
            wrapper.appendChild(removeBtn);
            thumbList.appendChild(wrapper);
        });
    }

    function removeImage(index) {
        selectedFiles.splice(index, 1);
        renderImages();
    }

    function showMainImage(file) {
        const mainPreview = document.getElementById("mainPreview");
        const url = URL.createObjectURL(file);
        mainPreview.innerHTML = '<img src="' + url + '" style="width:100%;height:100%;object-fit:cover;">';
    }

    document.addEventListener("keydown", function(e) {
        if (e.key === "Escape") {
            closePostModal();
        }
    });
</script>

<div class="modal fade" id="customDeleteModal" tabindex="-1" aria-hidden="true" style="z-index: 999999;">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 400px;">
        <div class="modal-content" style="border-radius: 16px; border: none; overflow: hidden; background: #fff;">

            <div class="modal-header border-0 pt-4 px-4 pb-2 d-flex justify-content-between align-items-center">
                <h5 class="modal-title fw-bold text-dark" style="font-size: 18px; margin: 0;">Xác nhận xóa bài</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body px-4 py-2">
                <p class="text-secondary mb-1" style="font-size: 14px; text-align: left;">Bạn có chắc chắn muốn xóa bài đăng:</p>
                <p id="deleteRoomTitle" class="fw-bold text-dark mb-2" style="font-size: 15px; word-break: break-word; text-align: left;"></p>
                <small class="text-danger-emphasis d-block bg-danger-subtle p-2 rounded" style="font-size: 12px; border-left: 3px solid #dc3545; text-align: left;">
                    ⚠️ Hành động này không thể hoàn tác và sẽ xóa toàn bộ hình ảnh đi kèm.
                </small>
            </div>

            <div class="modal-footer border-0 pb-4 px-4 pt-2 d-flex gap-2">
                <button type="button" class="btn btn-light flex-grow-1 py-2 fw-medium" data-bs-dismiss="modal" style="border-radius: 10px; font-size: 14px;">
                    Hủy bỏ
                </button>
                <a id="btnConfirmDeleteUrl" href="#" class="btn btn-danger flex-grow-1 py-2 fw-medium" style="border-radius: 10px; font-size: 14px;">
                    Đồng ý xóa
                </a>
            </div>

        </div>
    </div>
</div>

<script>
    function confirmDelete(roomId, roomTitle) {
        document.getElementById('deleteRoomTitle').innerText = '"' + roomTitle + '"';
        document.getElementById('btnConfirmDeleteUrl').setAttribute('href', '/delete-post/' + roomId);

        var myModal = new bootstrap.Modal(document.getElementById('customDeleteModal'));
        myModal.show();
    }
</script>

<div class="modal fade" id="editPostModal" tabindex="-1" aria-hidden="true" style="z-index: 999999;">
    <div class="modal-dialog modal-dialog-centered" style="max-width: 780px;">
        <div class="modal-content" style="border-radius: 16px; border: none; overflow: hidden; background: #fff;">

            <div class="modal-header border-0 pt-4 px-4 pb-2 d-flex justify-content-between align-items-center">
                <h5 class="modal-title fw-bold text-dark" style="font-size: 20px; margin: 0;">✏️ Chỉnh sửa bài đăng</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <form id="editForm" action="/update-post" method="post" enctype="multipart/form-data">
                <div class="modal-body px-4 py-2">
                    <input type="hidden" id="editRoomId" name="id">

                    <div class="f-grid">
                        <div class="f-group f-full">
                            <label for="editImageInput" style="color: #2d3748; font-weight: 700;">Cập nhật lại hình ảnh mới (Nếu muốn thay đổi)</label>
                            <input type="file" id="editImageInput" name="images" accept="image/*" multiple>
                            <div class="image-preview-container" style="margin-top:12px;">
                                <div id="editMainPreview"
                                     style="
                                    flex:1;
                                    height:320px;
                                    background:#f7fafc;
                                    border:2px dashed #cbd5e0;
                                    border-radius:8px;
                                    overflow:hidden;
                                    display:flex;
                                    align-items:center;
                                    justify-content:center;
                                 ">
                                <span style="color:#a0aec0;font-size:14px;">
                                    Chưa có ảnh
                                </span>
                                </div>

                                <div id="editThumbList"
                                     style="
                                            width:160px;
                                            display:flex;
                                            flex-direction:column;
                                            gap:10px;
                                         ">
                                </div>
                            </div>
                            <small class="text-muted">* Để trống nếu bạn muốn giữ nguyên danh sách ảnh cũ.</small>
                        </div>
                        <div class="f-group f-full">
                            <label for="editRoomTitle">Tiêu đề bài đăng</label>
                            <input type="text" id="editRoomTitle" name="title" required>
                        </div>

                        <div class="f-group">
                            <label for="editRoomCategory">Loại phòng</label>
                            <select id="editRoomCategory" name="category" required>
                                <option value="MOTEL_ROOM">Phòng trọ</option>
                                <option value="MINI_APARTMENT">Chung cư mini</option>
                                <option value="APARTMENT">Chung cư</option>
                                <option value="WHOLE_HOUSE">Nhà nguyên căn</option>
                            </select>
                        </div>

                        <div class="f-group">
                            <label for="editRoomLocation">Khu vực (Phường, Quận, Tỉnh)</label>
                            <select id="editRoomLocation" name="locationId" required>
                                <c:forEach var="loc" items="${locations}">
                                    <option value="${loc.id}">
                                            ${loc.ward}, ${loc.district} (${loc.city})
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="f-group f-full">
                            <label for="editRoomAddress">Địa chỉ chi tiết</label>
                            <input type="text" id="editRoomAddress" name="address" required>
                        </div>

                        <div class="f-group">
                            <label for="editRoomPrice">Giá cho thuê (VND/tháng)</label>
                            <input type="number" id="editRoomPrice" name="price" min="0" required>
                        </div>

                        <div class="f-group">
                            <label for="editRoomArea">Diện tích (m²)</label>
                            <input type="number" id="editRoomArea" name="area" min="1" required>
                        </div>

                        <div class="f-group">
                            <label for="editRoomPhone">Số điện thoại liên hệ</label>
                            <input type="tel" id="editRoomPhone" name="phone" required>
                        </div>

                        <div class="f-group">
                            <label for="editRoomZalo">Liên hệ qua Zalo</label>
                            <input type="tel" id="editRoomZalo" name="zalo">
                        </div>

                        <div class="f-group f-full">
                            <label for="editRoomDescription">Mô tả chi tiết phòng</label>
                            <textarea id="editRoomDescription" name="description" rows="4" required></textarea>
                        </div>
                    </div>
                </div>

                <div class="modal-footer border-0 pb-4 px-4 pt-2 d-flex justify-content-end gap-2">
                    <button type="button" class="btn btn-light py-2 fw-medium" data-bs-dismiss="modal" style="border-radius: 8px; width: 100px;">
                        Hủy
                    </button>
                    <button type="submit" class="btn btn-success py-2 fw-medium" style="border-radius: 8px; width: 140px;">
                        Lưu thay đổi
                    </button>
                </div>
            </form>

        </div>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        document.addEventListener('click', function(event) {
            const editButton = event.target.closest('.btn-edit-trigger');

            if (editButton) {

                event.preventDefault();
                event.stopPropagation();

                const editInput = document.getElementById("editImageInput");

                if (editInput) {
                    editInput.value = "";
                }

                const roomId = editButton.getAttribute('data-id');
                const roomTitle = editButton.getAttribute('data-title');
                const roomCategory = editButton.getAttribute('data-category');
                const roomAddress = editButton.getAttribute('data-address');
                const roomPrice = editButton.getAttribute('data-price');
                const roomArea = editButton.getAttribute('data-area');
                const roomPhone = editButton.getAttribute('data-phone');
                const roomZalo = editButton.getAttribute('data-zalo');
                const roomLocationId = editButton.getAttribute('data-location');
                const roomDescription = editButton.getAttribute('data-description');
                const roomImages = editButton.getAttribute('data-images');
                console.log(roomImages);

                if (document.getElementById('editRoomId')) document.getElementById('editRoomId').value = roomId;
                if (document.getElementById('editRoomTitle')) document.getElementById('editRoomTitle').value = roomTitle;
                if (document.getElementById('editRoomCategory')) document.getElementById('editRoomCategory').value = roomCategory;
                if (document.getElementById('editRoomAddress')) document.getElementById('editRoomAddress').value = roomAddress;
                if (document.getElementById('editRoomPrice')) document.getElementById('editRoomPrice').value = roomPrice;
                if (document.getElementById('editRoomArea')) document.getElementById('editRoomArea').value = roomArea || '';
                if (document.getElementById('editRoomPhone')) document.getElementById('editRoomPhone').value = roomPhone || '';
                if (document.getElementById('editRoomZalo')) document.getElementById('editRoomZalo').value = roomZalo || '';
                if (document.getElementById('editRoomDescription')) document.getElementById('editRoomDescription').value = roomDescription;

                const locationSelect = document.getElementById('editRoomLocation');
                if (locationSelect && roomLocationId) {
                    locationSelect.value = roomLocationId;
                }
                renderEditImages(roomImages);

                const modalElement = document.getElementById('editPostModal');
                if (modalElement) {
                    const bootstrapEditModal = new bootstrap.Modal(modalElement);
                    bootstrapEditModal.show();
                }
            }
        });
    });

    const editModal = document.getElementById('editPostModal');

    if (editModal) {
        editModal.addEventListener('hidden.bs.modal', function () {

            const input = document.getElementById("editImageInput");

            if (input) {
                input.value = "";
            }

            document.getElementById("editThumbList").innerHTML = "";

            document.getElementById("editMainPreview").innerHTML = `
            <span style="color:#a0aec0;font-size:14px;">
                Chưa có ảnh
            </span>
        `;
        });
    }

    function renderEditImages(imagesString) {
        const mainPreview = document.getElementById("editMainPreview");
        const thumbList = document.getElementById("editThumbList");

        if (!mainPreview || !thumbList) return;

        thumbList.innerHTML = "";

        if (!imagesString || imagesString.trim() === "") {
            mainPreview.innerHTML = `
            <span style="color:#a0aec0;font-size:14px;">
                Chưa có ảnh
            </span>
        `;
            return;
        }

        const images = imagesString
            .split("|")
            .map(item => {
                const parts = item.split("::");
                return {
                    id: parts[0],
                    url: parts[1]
                };
            })
            .filter(item => item.url);

        if (images.length === 0) return;

        mainPreview.innerHTML =
            '<img src="' + images[0].url + '" ' +
            'style="width:100%;height:100%;object-fit:cover;">';

        images.forEach((image, index) => {
            const wrapper = document.createElement("div");
            wrapper.className = "thumb-wrapper";

            const img = document.createElement("img");
            img.src = image.url;
            img.onclick = () => {
                mainPreview.innerHTML =
                    '<img src="' + image.url + '" ' +
                    'style="width:100%;height:100%;object-fit:cover;">';
            };

            const removeBtn = document.createElement("button");
            removeBtn.type = "button";
            removeBtn.className = "btn-remove-thumb";
            removeBtn.innerHTML = "&times;";

            removeBtn.onclick = async (e) => {
                e.stopPropagation();

                if (!confirm("Bạn có chắc muốn xóa ảnh này?")) {
                    return;
                }

                try {
                    const response = await fetch('/delete-room-image/' + image.id, {
                        method: 'DELETE'
                    });

                    if (!response.ok) {
                        throw new Error("Delete failed");
                    }

                    wrapper.remove();
                    const currentMainImg = mainPreview.querySelector("img");

                    if (currentMainImg && currentMainImg.src === img.src) {
                        const remainingImages = thumbList.querySelectorAll("img");

                        if (remainingImages.length > 1) {
                            const nextImg = Array.from(remainingImages)
                                .find(item => item.src !== img.src);

                            if (nextImg) {
                                mainPreview.innerHTML =
                                    '<img src="' + nextImg.src + '" ' +
                                    'style="width:100%;height:100%;object-fit:cover;">';
                            }
                        } else {
                            mainPreview.innerHTML = `
                    <span style="color:#a0aec0;font-size:14px;">
                        Chưa có ảnh
                    </span>
                `;
                        }
                    }
                } catch (err) {
                    console.error(err);
                    alert("Xóa ảnh thất bại!");
                }
            };

            wrapper.appendChild(img);
            wrapper.appendChild(removeBtn);
            thumbList.appendChild(wrapper);
        });
    }
</script>
<jsp:include page="../common/footer.jsp"/>