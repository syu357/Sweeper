<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<title>용인시 청소차 관제시스템</title>
<link rel = "icon" href="/images/yongin.png">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
<link rel="stylesheet" href="https://openlayers.org/en/v6.5.0/css/ol.css" type="text/css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://openlayers.org/en/v6.5.0/build/ol.js"></script>
<script src="resources/js/plugin/datepicker/bootstrap-datepicker.ko.min.js"></script>
<!-- jQuery UI CSS 파일 -->
<link rel="stylesheet" href="https://code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<!-- jQuery와 jQuery UI 스크립트 파일 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
<script src="js/carInfo.js"></script>

<style>
body, html {
	margin: 0;
	padding: 0;
	height: 100%;
}

#map {
	width: 80%;
	height: 100%;
	float: right;
}

#sidebar {
	width: 20%;
	height: 100%;
	position: fixed;
	background-color: #f1f1f1;
	padding: 20px;
	justify-content: center;
	align-items: center;
}

.centered {
	align-items: center;
	justify-content: center;
	margin-top: 30px;
}

.rounded-box {
	width: 100%;
	background-color: #ffffff;
	border-radius: 20px;
	padding: 20px;
	box-sizing: border-box; /* padding이 너비에 포함되도록 설정 */
	flex-direction: column;
	align-items: left;
	justify-content: center;
	margin-bottom: 30px;
}

.hr-divider {
	border: 1px solid #ddd; /* 경계선 색 */
}

#sidebar img {
	display: block;
	width: 15%;
	height: 8%;
	margin: 10px;
	position: relative;
	float: left;
}

#title {
	display: flex;
    align-items: center;
}

</style>
</head>

<body>
	<div id="sidebar">
		<div id="title">
			<img src="/images/yongin.png" alt="용인시 심볼">
			<h5><b>용인시 청소차 관제 시스템</b></h5>

		</div>
		<hr class="hr-divider">
		
		<div class="centered">
			<div class="rounded-box"> 
				<div id="title"> 
					<img src="/images/map_icon.png" alt="지도 아이콘">
					<div class="btn-group" role="group" aria-label="Basic radio toggle button group">
            			<input type="radio" class="btn-check" name="btnradio" id="btnradio1" autocomplete="off" checked>
            			<label class="btn btn-outline-primary" for="btnradio1">기본</label>
            			<input type="radio" class="btn-check" name="btnradio" id="btnradio2" autocomplete="off">
            			<label class="btn btn-outline-primary" for="btnradio2">위성</label>
            			<input type="radio" class="btn-check" name="btnradio" id="btnradio3" autocomplete="off">
            			<label class="btn btn-outline-primary" for="btnradio3">하이브리드</label>
       				</div>
				</div>		
			</div>
			
			<div class="rounded-box">
				<h5 class="text-center fw-bold">차량 목록</h5>
				<hr class="hr-divider">
				<c:forEach items="${carlist }" var="ci"> 
					<div id="title"> 
						<img src="/images/sweeper_car.png" alt="청소차 아이콘">
						<button type="button" class="btn carnumbtn" value="${ci.car_num }">${ci.car_num }</button> 
					</div>
				</c:forEach>
			</div>
			
			<div class="rounded-box" id ="Info" hidden>
				<h5 class="text-center fw-bold" id="carnum"></h5>
				<hr class="hr-divider">
				<div> 
					<div id="datePicker">
						<label for="dateInput" id="dateLabel" style="margin-bottom: 10px;">&nbsp;날짜 선택 : </label> 
						<div class="row">
							<div class="col-md-9">
								<input type="date" class="form-control" id="dateInput" value="${now }">
							</div>
							<div class="col-md-3">
								<button type="button" class="btn btn-outline-primary" id="btn1">확인</button>
							</div>
						</div>
					</div>
				</div>
				<hr class="hr-divider">
				<div id="calc">
					<label>운행 시간 : <b id="timediff"></b></label><br>
					<label>청소 비율 : <b id="ratio"></b></label>
				</div>
				<div id="empty" hidden>
					<p class='text-center'>데이터가 없습니다.</p>
				</div>
				<hr class="hr-divider">
				<div class="row">
			        <div class="col-12" style="text-align: right;"><input type="button" id="delbtn" class="btn btn-sm" value="접기"></div>
			    </div>
			</div>
		</div>
	</div>

	<div id="map"></div>

	<script>

		var longitude = 127.211335;
		var latitude = 37.230504;
		var map;
		var selectedDate;
		var currentLayer = null;

		var dateParam = '<%= request.getParameter("date") %>';
	    var date = dateParam; // JSP 코드를 사용하여 JavaScript 변수에 할당      
	    
	    console.log("* date:", date);
	    console.log("* dateParam:", dateParam);
	        
	    var coordinatesData;
	        
	    $.ajax({
	        url: '/coordinates',
	        data: {
	            'date': date
	        },
	        dataType: 'json',
	        success: function(data) {
	            coordinatesData = data;
	            console.log(coordinatesData);
	            updateLineViewLayer();
	        },
	        error: function(xhr, status, error) { // error 핸들러
	            console.error(error);
	        }
	    });
	    
	 	// 원하는 viewparams 설정
	    var viewParam = "date:" + date;

	 	// 배경지도 레이어를 미리 생성
	    var BaseLayer = new ol.layer.Tile({
	    	visible: true,
	        source: new ol.source.XYZ({
	            url: 'http://api.vworld.kr/req/wmts/1.0.0/027A2176-1F16-387D-8843-709D812E95A3/Base/{z}/{y}/{x}.png',
	            attributions: '© <a href="http://www.vworld.kr">VWorld</a>',
	            maxZoom: 18
	        })
	    });
	    
	    var SatelliteLayer = new ol.layer.Tile({
	        source: new ol.source.XYZ({
	            url: 'http://api.vworld.kr/req/wmts/1.0.0/027A2176-1F16-387D-8843-709D812E95A3/Satellite/{z}/{y}/{x}.jpeg',
	            attributions: '© <a href="http://www.vworld.kr">VWorld</a>',
	            maxZoom: 18
	        })
	    });
	    
	    var HybridLayer = new ol.layer.Tile({
	        source: new ol.source.XYZ({
	            url: 'http://api.vworld.kr/req/wmts/1.0.0/027A2176-1F16-387D-8843-709D812E95A3/Hybrid/{z}/{y}/{x}.png',
	            attributions: '© <a href="http://www.vworld.kr">VWorld</a>',
	            maxZoom: 18
	        })
	    });
	    
	    var boundaryLayer = new ol.layer.Tile({
	        opacity: 0.2,
	        visible: true,
	        zIndex: 100,
	        source: new ol.source.TileWMS({
	            url: 'http://192.168.0.12:8090/geoserver/sweeper/wms',
	            params: {
	                'LAYERS': 'sweeper:boundary',
	                'FORMAT': 'image/png',
	                'VERSION': '1.1.1',
	                'TILED': true
	            },
	            serverType: 'geoserver',
	            crossOrigin: 'anonymous'
	        })
	    });

	    var lineViewLayer = new ol.layer.Tile({
	        zIndex: 100,
	        source: new ol.source.TileWMS({
	            url: 'http://192.168.0.12:8090/geoserver/sweeper/wms',
	            params: {
	                'LAYERS': 'sweeper:Clean_route',
	                'FORMAT': 'image/png',
	                'VERSION': '1.1.0',
	                'VIEWPARAMS': 'date:' + date
	            },
	            serverType: 'geoserver',
	            crossOrigin: 'anonymous'
	        }),
	        layerId : 'line_view',
	    });
	    
	 	// 시작과 끝 마커 이미지 설정
        var startMarkerStyle = new ol.style.Style({
        	zIndex: 101,
            image: new ol.style.Icon({
                anchor: [0.5, 1],
                src: '/images/black_marker.png',
                scale: 0.075 // 마커의 크기 조절
            })
        });

        var endMarkerStyle = new ol.style.Style({
        	zIndex: 101,
            image: new ol.style.Icon({
                anchor: [0.5, 0.5],
                src: '/images/sweeper_car.png',
                scale: 0.3
            })
        });

        // 시작과 끝 마커 레이어 생성
        var startMarkerLayer = new ol.layer.Vector({
        	zIndex: 101,
            source: new ol.source.Vector(),
            style: startMarkerStyle
        });

        var endMarkerLayer = new ol.layer.Vector({
        	zIndex: 101,
            source: new ol.source.Vector(),
            style: endMarkerStyle
        });
	    
	    function renderMap() {
	        map = new ol.Map({
	            target: 'map',
	            layers: [
	            	startMarkerLayer,
		            endMarkerLayer,
	                boundaryLayer, // 경계 레이어
	                lineViewLayer, // 경로 레이어
	                SatelliteLayer, // 위성 지도 레이어
	                HybridLayer, // 하이브리드 레이어
	                BaseLayer // 기본 지도 레이어
	            ],
	            view: new ol.View({
	                center: ol.proj.fromLonLat([longitude, latitude]),
	                zoom: 11.7,
	                projection : 'EPSG:3857',
	            })
	        });
	        lineViewLayer.setVisible(false);
	        startMarkerLayer.setVisible(false);
	        endMarkerLayer.setVisible(false);
	    }

	    $(document).on("click", "#btnradio1", function() {
	        changeMapType(BaseLayer);
	    });

	    $(document).on("click", "#btnradio2", function() {
	        changeMapType(SatelliteLayer);
	    });

	    $(document).on("click", "#btnradio3", function() {
	        changeMapType(HybridLayer);
	    });

	    function changeMapType(layer) {
	    	BaseLayer.setVisible(true);
	    	
	        // 선택한 레이어를 현재 지도에 추가
	        map.getLayers().forEach(function (existingLayer) {
	            existingLayer.setVisible(false); // 모든 레이어를 숨김 처리
	        });
	        
	        startMarkerLayer.setVisible(true);
	        endMarkerLayer.setVisible(true);
	        boundaryLayer.setVisible(true);
	        lineViewLayer.setVisible(true);
	        
	        layer.setVisible(true); // 선택한 레이어만 보이도록 설정
	    }
	    
	    // datePicker 요소에 접근
	    const datePicker = document.getElementById("dateInput");

	    // datePicker의 값을 가져오기
	    datePicker.addEventListener("change", (event) => {
	        selectedDate = event.target.value;
	    });
	    
	    // line_view 레이어를 업데이트하는 함수
	    function updateLineViewLayer() {

	    	// 선택한 날짜를 viewParam에 설정
	        viewParam = 'date:' + selectedDate;
	        console.log("* viewParam :", viewParam);

	        var params = lineViewLayer.getSource().getParams();
	        params.VIEWPARAMS = viewParam;
	        console.log("* params :", params);
	        
	        // 선택한 날짜에 해당하는 레이어로 업데이트
	        lineViewLayer.getSource().updateParams(params);

	        // 업데이트된 레이어를 보이기
	        lineViewLayer.setVisible(true);
	        
	        startMarkerLayer.getSource().clear();
	        endMarkerLayer.getSource().clear();

	        // 마커 레이어들 업데이트 및 보이기
	        fetchStartAndEndCoordinates();
	        
	        // currentLayer 변수 업데이트
	        currentLayer = lineViewLayer;
	    }
	    
	    function addMarker(lon, lat, name){
	    	// 마커 feature 설정
	        var markerFeature = new ol.Feature({
	            geometry: new ol.geom.Point(ol.proj.fromLonLat([lon, lat])), //경도 위도에 포인트 설정
	            name: name
	        });
	    	
	     	// 마커에 적절한 스타일 설정
	        var markerStyle = name === "start" ? startMarkerStyle : endMarkerStyle;
	        markerFeature.setStyle(markerStyle);

	        // 해당하는 벡터 레이어에 마커 Feature 추가
	        if (name === "start") {
	            startMarkerLayer.getSource().addFeature(markerFeature);
	        } else if (name === "end") {
	            endMarkerLayer.getSource().addFeature(markerFeature);
	        }
	    }
	    
	    async function fetchStartAndEndCoordinates() {
	        try {
	            const searchDate = $("#dateInput").val();
	            const carNum = $("#carnum").html();

	            // 시작마커와 종료마커의 좌표를 가져오는 AJAX 요청
	            const markerData = await $.post({
	                url: "/markerInfo",
	                data: {
	                    date: searchDate,
	                    car_num: carNum,
	                },
	                dataType: "json",
	            });

	            const startInfo = markerData.markerinfo; // 시작 마커 정보
	            const endInfo = markerData.endinfo; // 종료 마커 정보

	            const startLon = startInfo.lon; // 시작 마커의 경도
	            const startLat = startInfo.lat; // 시작 마커의 위도
	            const endLon = endInfo.lon; // 종료 마커의 경도
	            const endLat = endInfo.lat; // 종료 마커의 위도

	            addMarker(startLon, startLat, "start");
	            addMarker(endLon, endLat, "end");
	            
	         	// 마커를 추가한 뒤에 보여지도록 설정
	            startMarkerLayer.setVisible(true);
	            endMarkerLayer.setVisible(true);
	        } catch (error) {
	            console.error("Error fetching marker data:", error);
	        }
	    }
	    
	    $("#btn1").click(function(){ // =  $(document).on("click", "#btn1", function ()
	        $("#timediff").empty();
	        $("#ratio").empty();

	        lineViewLayer.setVisible(false);
	        startMarkerLayer.setVisible(false);
	        endMarkerLayer.setVisible(false);

	        const searchDate = $("#dateInput").val();
	        const carNum = $("#carnum").html();

	        $.post({
	          url: "/carInfo",
	          data: {
	            date: searchDate,
	            car_num: carNum,
	          },
	          dataType: "json",
	        })
	          .done(function (data) {
	            const info = data.carinfo;

	            if (info.time != undefined || info.ratio != undefined) {
	              $("#calc").prop("hidden", false);
	              $("#empty").prop("hidden", true);
	              $("#timediff").append(info.time);
	              $("#ratio").append(info.ratio + "%");

	              updateLineViewLayer();

	              // 시작마커와 종료마커의 좌표를 가져와서 마커 추가
	              fetchStartAndEndCoordinates();
	              
	            } else {
	              $("#calc").prop("hidden", true);
	              $("#empty").prop("hidden", false);
	            }
	          })
	          .fail(function () {
	            alert("문제가 발생했습니다.");
	          });
	      });	
	 	
	    renderMap();
	</script>
</body>
</html>
