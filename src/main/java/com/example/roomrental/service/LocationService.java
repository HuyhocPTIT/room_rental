package com.example.roomrental.service;

import com.example.roomrental.entity.Location;
import com.example.roomrental.repository.LocationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LocationService {
    @Autowired
    private LocationRepository locationRepository;

    public List<Location> getLocations(){
        return locationRepository.findAll();
    }

    public Location findById(long id){
        return locationRepository.findById(id)
                .orElseThrow();
    }
}
