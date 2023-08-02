/**
 * 
 */

$(function() {

	$.post({
		url: "/map",
		dataType: "json"
	}).done(function(data) {
		let map = data.map;
		
		for (let i = 0; i < map.length; i++) {
			var gid = map[i].gid;
			var lat = map[i].lat;
			var lon = map[i].lon;
			var date = map[i].date;
			var time = map[i].time;
			var noise = map[i].noise;
			var vibration = map[i].vibration;
			var car_num = map[i].car_num;
			
		}
		
	}).fail(function() {
		alert("문제가 발생했습니다.");
	});
});