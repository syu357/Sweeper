package com.sweeper.car.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.sweeper.car.service.MapService;

@Controller
public class MapController {
	private final MapService mapService;

    @Autowired
    public MapController(MapService mapService) {
        this.mapService = mapService;
    }

    @GetMapping("/create-sql-view")
    public void createSqlView(@RequestParam("sqlQuery") String sqlQuery) {
        mapService.createSqlView(sqlQuery);
    }

    @GetMapping("/coordinates")
    @ResponseBody
    public String getCoordinates(@RequestParam("date") String date, Model model) {
    	List<Map<String, Object>> coordinates = mapService.getCoordinates(date);
        return toJson(coordinates);
    }
    
    @GetMapping("/map")
    public String showMap() {
        return "map";
    }
    
    // List<Map<String, Object>>를 JSON 형태로 변환하는 메소드
    private String toJson(List<Map<String, Object>> data) {
        try {
            com.fasterxml.jackson.databind.ObjectMapper mapper = new com.fasterxml.jackson.databind.ObjectMapper();
            return mapper.writeValueAsString(data);
        } catch (Exception e) {
            e.printStackTrace();
            return "[]";
        }
    }
}
