package com.sweeper.car.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sweeper.car.dao.MapDAO;

@Service
public class MapService {
	private final MapDAO mapDAO;

    @Autowired
    public MapService(MapDAO mapDAO) {
        this.mapDAO = mapDAO;
    }
    
    public void createSqlView(String sqlQuery) {
    	mapDAO.createSqlView(sqlQuery);
    }

    public List<Map<String, Object>> getCoordinates(String date) {
    	List<Map<String, Object>> coordinates = mapDAO.getCoordinates(date);
        
    	return coordinates;
    }
    
    public List<Map<String, Object>> getPointsByDateAndCar(String date, String carNumber) {
        return mapDAO.getPointsByDateAndCar(date, carNumber);
    }
    
}