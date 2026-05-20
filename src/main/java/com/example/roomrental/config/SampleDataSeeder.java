package com.example.roomrental.config;

import com.example.roomrental.constant.PostStatus;
import com.example.roomrental.constant.RoomCategory;
import com.example.roomrental.constant.UserRole;
import com.example.roomrental.entity.Favorite;
import com.example.roomrental.entity.Location;
import com.example.roomrental.entity.Profile;
import com.example.roomrental.entity.RoomImage;
import com.example.roomrental.entity.RoomPost;
import com.example.roomrental.entity.User;
import com.example.roomrental.repository.FavoriteRepository;
import com.example.roomrental.repository.LocationRepository;
import com.example.roomrental.repository.RoomImageRepository;
import com.example.roomrental.repository.RoomPostRepository;
import com.example.roomrental.repository.UserRepository;
import java.util.List;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
@ConditionalOnProperty(name = "app.sample-data.enabled", havingValue = "true", matchIfMissing = true)
public class SampleDataSeeder implements CommandLineRunner {

    private static final String DEFAULT_IMAGE_URL = "/images/picture.jpg";

    private final UserRepository userRepository;
    private final LocationRepository locationRepository;
    private final RoomPostRepository roomPostRepository;
    private final RoomImageRepository roomImageRepository;
    private final FavoriteRepository favoriteRepository;

    public SampleDataSeeder(UserRepository userRepository,
                            LocationRepository locationRepository,
                            RoomPostRepository roomPostRepository,
                            RoomImageRepository roomImageRepository,
                            FavoriteRepository favoriteRepository) {
        this.userRepository = userRepository;
        this.locationRepository = locationRepository;
        this.roomPostRepository = roomPostRepository;
        this.roomImageRepository = roomImageRepository;
        this.favoriteRepository = favoriteRepository;
    }

    @Override
    @Transactional
    public void run(String... args) {
        if (roomPostRepository.count() > 0) {
            return;
        }

        User admin = createUser("admin", "123456", UserRole.ADMIN,
                "Quản trị viên", "admin@roomrental.com", "0900000000", DEFAULT_IMAGE_URL);
        User landlordOne = createUser("chutro_hanoi", "123456", UserRole.LANDLORD,
                "Nguyễn Văn Minh", "minh.chutro@example.com", "0912345678", DEFAULT_IMAGE_URL);
        User landlordTwo = createUser("chutro_hcm", "123456", UserRole.LANDLORD,
                "Trần Thị Hạnh", "hanh.chutro@example.com", "0987654321", DEFAULT_IMAGE_URL);
        User tenant = createUser("nguoithue01", "123456", UserRole.TENANT,
                "Lê Hoàng Nam", "nam.nguoithue@example.com", "0933333333", DEFAULT_IMAGE_URL);

        Location dongDa = createLocation("Hà Nội", "Đống Đa", "Láng Hạ");
        Location cauGiay = createLocation("Hà Nội", "Cầu Giấy", "Dịch Vọng");
        Location binhThanh = createLocation("TP. Hồ Chí Minh", "Bình Thạnh", "Phường 25");
        Location thuDuc = createLocation("TP. Hồ Chí Minh", "Thủ Đức", "Linh Trung");
        Location haiChau = createLocation("Đà Nẵng", "Hải Châu", "Hải Châu I");

        RoomPost postOne = createRoomPost(
                landlordOne,
                dongDa,
                "Phòng trọ sạch sẽ, đủ nội thất gần Láng Hạ",
                "Phòng có giường, tủ, điều hòa, máy giặt chung. Khu dân cư yên tĩnh, gần chợ và trạm xe buýt.",
                2500000,
                20.0f,
                "Số 12 ngõ 85 Láng Hạ, Đống Đa, Hà Nội",
                "0912345678",
                "0912345678",
                PostStatus.ACTIVE,
                RoomCategory.MOTEL_ROOM
        );
        addImages(postOne, DEFAULT_IMAGE_URL, DEFAULT_IMAGE_URL);

        RoomPost postTwo = createRoomPost(
                landlordOne,
                cauGiay,
                "Căn hộ mini có ban công gần Đại học Quốc Gia",
                "Căn hộ khép kín, có bếp nhỏ, ban công thoáng, phù hợp sinh viên hoặc người đi làm.",
                4200000,
                35.0f,
                "Ngõ 165 Xuân Thủy, Cầu Giấy, Hà Nội",
                "0912345678",
                "0912345678",
                PostStatus.ACTIVE,
                RoomCategory.MINI_APARTMENT
        );
        addImages(postTwo, DEFAULT_IMAGE_URL, DEFAULT_IMAGE_URL);

        RoomPost postThree = createRoomPost(
                landlordTwo,
                binhThanh,
                "Studio full nội thất gần Hàng Xanh",
                "Studio mới xây, có thang máy, bảo vệ 24/7, nội thất cơ bản và chỗ để xe rộng.",
                4800000,
                40.0f,
                "Đường D2, Bình Thạnh, TP. Hồ Chí Minh",
                "0987654321",
                "0987654321",
                PostStatus.ACTIVE,
                RoomCategory.MINI_APARTMENT
        );
        addImages(postThree, DEFAULT_IMAGE_URL, DEFAULT_IMAGE_URL);

        RoomPost postFour = createRoomPost(
                landlordTwo,
                thuDuc,
                "Phòng trọ tiện nghi gần khu công nghệ cao",
                "Phòng rộng, có cửa sổ, nhà vệ sinh riêng, giờ giấc tự do, gần bến xe buýt.",
                2200000,
                25.0f,
                "Linh Trung, Thủ Đức, TP. Hồ Chí Minh",
                "0987654321",
                "0987654321",
                PostStatus.ACTIVE,
                RoomCategory.MOTEL_ROOM
        );
        addImages(postFour, DEFAULT_IMAGE_URL);

        RoomPost postFive = createRoomPost(
                landlordTwo,
                haiChau,
                "Nhà nguyên căn trung tâm Hải Châu",
                "Nhà nguyên căn 2 tầng, phù hợp nhóm bạn hoặc gia đình nhỏ, gần trung tâm và chợ.",
                6500000,
                60.0f,
                "Hải Châu I, Hải Châu, Đà Nẵng",
                "0987654321",
                "0987654321",
                PostStatus.ACTIVE,
                RoomCategory.WHOLE_HOUSE
        );
        addImages(postFive, DEFAULT_IMAGE_URL);

        // Tạo thêm 20 phòng mẫu để test phân trang
        for (int i = 1; i <= 20; i++) {
            RoomPost dummyPost = createRoomPost(
                    (i % 2 == 0) ? landlordOne : landlordTwo,
                    (i % 2 == 0) ? dongDa : cauGiay,
                    "Phòng trọ số " + i,
                    "Phòng trọ sạch đẹp",
                    2000000 + (i * 50000),
                    20.0f + i,
                    "Ngõ " + i + " đường Láng, Hà Nội",
                    "0900000000",
                    "0900000000",
                    PostStatus.ACTIVE,
                    (i % 3 == 0) ? RoomCategory.MINI_APARTMENT : RoomCategory.MOTEL_ROOM
            );
            addImages(dummyPost, DEFAULT_IMAGE_URL);
        }

        addFavorite(tenant, postOne);
        addFavorite(tenant, postThree);

        userRepository.save(admin);
    }

    private User createUser(String username,
                            String password,
                            UserRole role,
                            String fullName,
                            String email,
                            String phoneNumber,
                            String avatar) {
        return userRepository.findByUsername(username)
                .orElseGet(() -> {
                    Profile profile = new Profile();
                    profile.setName(fullName);
                    profile.setEmail(email);
                    profile.setPhoneNumber(phoneNumber);
                    profile.setAvatar(avatar);

                    User user = new User();
                    user.setUsername(username);
                    user.setPassword(password);
                    user.setRole(role);
                    user.setProfile(profile);

                    return userRepository.save(user);
                });
    }

    private Location createLocation(String city, String district, String ward) {
        Location location = new Location();
        location.setCity(city);
        location.setDistrict(district);
        location.setWard(ward);
        return locationRepository.save(location);
    }

    private RoomPost createRoomPost(User user,
                                    Location location,
                                    String title,
                                    String description,
                                    float price,
                                    float area,
                                    String address,
                                    String phoneContact,
                                    String zaloContact,
                                    PostStatus status,
                                    RoomCategory category) {
        RoomPost roomPost = new RoomPost();
        roomPost.setUser(user);
        roomPost.setLocation(location);
        roomPost.setTitle(title);
        roomPost.setDescription(description);
        roomPost.setPrice(price);
        roomPost.setArea(area);
        roomPost.setAddress(address);
        roomPost.setPhoneContact(phoneContact);
        roomPost.setZaloContact(zaloContact);
        roomPost.setStatus(status);
        roomPost.setCategory(category);
        return roomPostRepository.save(roomPost);
    }

    private void addImages(RoomPost roomPost, String... imageUrls) {
        List<RoomImage> roomImages = List.of(imageUrls).stream()
                .map(imageUrl -> {
                    RoomImage roomImage = new RoomImage();
                    roomImage.setRoomPost(roomPost);
                    roomImage.setImageUrl(imageUrl);
                    return roomImage;
                })
                .toList();
        roomImageRepository.saveAll(roomImages);
    }

    private void addFavorite(User user, RoomPost roomPost) {
        Favorite favorite = new Favorite();
        favorite.setUser(user);
        favorite.setRoomPost(roomPost);
        favoriteRepository.save(favorite);
    }
}
