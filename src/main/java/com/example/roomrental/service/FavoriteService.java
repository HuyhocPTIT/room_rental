package com.example.roomrental.service;

import com.example.roomrental.entity.Favorite;
import com.example.roomrental.entity.RoomPost;
import com.example.roomrental.entity.User;
import com.example.roomrental.repository.FavoriteRepository;
import com.example.roomrental.repository.RoomPostRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class FavoriteService {
    @Autowired
    private FavoriteRepository favoriteRepository;

    @Autowired
    private RoomPostRepository roomPostRepository;

    @Transactional
    public boolean toggleFavorite(User user, Long postId) {
        // Tim bai dang
        RoomPost roomPost = roomPostRepository.findById(postId)
                .orElseThrow(() -> new RuntimeException("Bài đăng không tồn tại"));

        // Kiem tra xem luu chua
        Optional<Favorite> existingFavorite = favoriteRepository.findByUserAndRoomPost(user, roomPost);
        if (existingFavorite.isPresent()){
            favoriteRepository.delete(existingFavorite.get());
            return false;
        } else {
            Favorite favorite = new Favorite();
            favorite.setUser(user);
            favorite.setRoomPost(roomPost);
            favoriteRepository.save(favorite);
            return true;
        }
    }

    public List<Long> getSavedPostIdsByUser(User currentUser){
        List<Favorite> favorites = favoriteRepository.findByUser(currentUser);

        return favorites.stream()
                .map(favorite -> favorite.getRoomPost().getId())
                .collect(Collectors.toList());
    }

    public List<Favorite> findAllByUserIdOrderByCreatedAtDesc(Long userId){
        return favoriteRepository.findAllByUserIdOrderByCreatedAtDesc(userId);
    }
}
