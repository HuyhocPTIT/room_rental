package com.example.roomrental.service;

import com.example.roomrental.constant.BookingStatus;
import com.example.roomrental.dto.BookingRequest;
import com.example.roomrental.entity.Booking;
import com.example.roomrental.entity.RoomPost;
import com.example.roomrental.entity.User;
import com.example.roomrental.repository.BookingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BookingService {
    @Autowired
    private BookingRepository bookingRepository;

    public Booking createBooking(Long roomPostId, User user, BookingRequest request, RoomPost roomPost) {
        Booking booking = new Booking();
        booking.setCheckInDate(request.getCheckInDate());
        booking.setCheckOutDate(request.getCheckOutDate());
        booking.setNotes(request.getNotes());
        booking.setStatus(BookingStatus.PENDING);
        booking.setUser(user);
        booking.setRoomPost(roomPost);
        return bookingRepository.save(booking);
    }

    public List<Booking> getBookingsByRoomPost(Long roomPostId) {
        return bookingRepository.findByRoomPostId(roomPostId);
    }

    public List<Booking> getBookingsByUser(Long userId) {
        return bookingRepository.findByUserId(userId);
    }

    public List<Booking> getConfirmedBookings(Long roomPostId) {
        return bookingRepository.findByRoomPostIdAndStatus(roomPostId, BookingStatus.CONFIRMED);
    }

    public Booking confirmBooking(Long bookingId) {
        Booking booking = bookingRepository.findById(bookingId).orElse(null);
        if (booking != null) {
            booking.setStatus(BookingStatus.CONFIRMED);
            return bookingRepository.save(booking);
        }
        return null;
    }

    public Booking cancelBooking(Long bookingId) {
        Booking booking = bookingRepository.findById(bookingId).orElse(null);
        if (booking != null) {
            booking.setStatus(BookingStatus.CANCELLED);
            return bookingRepository.save(booking);
        }
        return null;
    }
}
