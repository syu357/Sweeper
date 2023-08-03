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
	
});