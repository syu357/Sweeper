package com.sweeper.car.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface MapDAO {
	
	void createSqlView(@Param("sqlQuery") String sqlQuery);
	
	//List<Map<String, Object>> findByDateOrderByTime(String date);
	//List<Map<String, Object>> getMapAjax(Map<String, Object> map);
	
	List<Map<String, Object>> getCoordinates(@Param("date") String date);

	//List<Map<String, Object>> getPointsWithNoiseAndFreq();

	List<Map<String, Object>> getPointsByDateAndCar(@Param("date") String date, @Param("carNumber") String carNumber);
	
}

