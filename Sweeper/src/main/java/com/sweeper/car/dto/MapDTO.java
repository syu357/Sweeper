package com.sweeper.car.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;

import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor 
public class MapDTO {
	private int gid;
	private BigDecimal lat;
	private BigDecimal lon;
	private LocalDateTime date;
	private String time;
	private int noise;
	private int vibration;
	private String car_num;
}
