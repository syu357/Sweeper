package com.sweeper.car.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

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
    
//    @GetMapping("/map")
//    public String showMap() {
//        return "map";
//    }
    
    @GetMapping("/map")

    public ModelAndView showMap() {
    	ModelAndView mv = new ModelAndView("map");
    	
    	List<Map<String, Object>> carlist = mapService.carlist();
    	Date now = new Date();
    	SimpleDateFormat nowdate = new SimpleDateFormat("yyyy-MM-dd");
    	String date = nowdate.format(now);
    	mv.addObject("carlist", carlist);
    	mv.addObject("now", date);
    	
    	
    	return mv;
    }
    
//    @GetMapping("/map")
//    public String mapPage(@RequestParam(name = "selectedDate", defaultValue = "2023-07-10") String selectedDate,
//                          @RequestParam(name = "selectedCarNumber", defaultValue = "12가1234") String selectedCarNumber,
//                          Model model) {
//
//        List<Map<String, Object>> points = mapService.getPointsByDateAndCar(selectedDate, selectedCarNumber);
//        model.addAttribute("points", points);
//        model.addAttribute("selectedDate", selectedDate);
//        model.addAttribute("selectedCarNumber", selectedCarNumber);
//
//        return "map"; // map.jsp로 매핑
//    }
    
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
    
	@ResponseBody
    @PostMapping(value="/carInfo", produces = "application/json;charset=UTF-8")
    public String carInfo(@RequestParam Map<String, Object> map) {
    	JSONObject json = new JSONObject();
		Map<String, Object> info = mapService.searchcar(map);
		json.put("carinfo", info);
		System.err.println(json.toString());
		return json.toString();
    }
  
}
