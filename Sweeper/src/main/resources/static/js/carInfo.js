/**
 * 
 */



$(function(){
	const date = new Date();
	const year = date.getFullYear();
	const month = ('0' + (date.getMonth() + 1)).slice(-2);
	const day = ('0' + (date.getDate())).slice(-2);
	const today = `${year}-${month}-${day}`;
	
	
	$(".carnumbtn").click(function(){
		var car_num = $(this).attr("value");
		$("#carnum").html(car_num);
		$("#timediff").empty();
		$("#ratio").empty();
		$("#dateInput").val(today);
		$("#Info").prop("hidden", false);
	});
	
	$("#delbtn").click(function(){
		$("#Info").prop("hidden", true);
		$("#dateInput").val(today);
	});
	
	$("#btn1").click(function(){
		$("#timediff").empty();
		$("#ratio").empty();
		var searchDate = $("#dateInput").val();
		var car_num = $("#carnum").html();
		
			$.post({
				url : "/carInfo",
				data : {
					'date': searchDate,
					'car_num' :car_num
				},
				dataType : "json"

			}).done(function(data) {
				var info = data.carinfo;		
				if(info.time != undefined || info.ratio != undefined){
					$("#calc").prop("hidden", false);
					$("#empty").prop("hidden", true);
					$("#timediff").append(info.time);
					$("#ratio").append(info.ratio+"%");
				} else{
					$("#calc").prop("hidden", true);
					$("#empty").prop("hidden", false);
				}
			}).fail(function() {
				alert("문제가 발생했습니다.");
			});



	})
});