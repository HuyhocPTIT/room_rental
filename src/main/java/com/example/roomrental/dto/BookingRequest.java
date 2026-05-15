package com.example.roomrental.dto;

import lombok.*;

import java.time.LocalDate;

@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
public class BookingRequest {
    private LocalDate checkInDate;
    private LocalDate checkOutDate;
    private String notes;
}
