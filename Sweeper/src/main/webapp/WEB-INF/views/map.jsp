<%@ page contentType="text/html;charset=UTF-8" language="java"%>
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

.datePicker {
	
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

#dateInput {
    margin: 10px;
}

</style>
</head>

<body>
	<div id="sidebar">
		<div id="title">
			<img src="/images/yongin.png" alt="용인시 심볼">
			<h5>용인시 청소차 관제 시스템</h5>
		</div>
		<hr class="hr-divider">
		
		<div class="centered">
			<div class="rounded-box">
				<h5>차량 목록</h5>
				<hr class="hr-divider">
				<div id="title"> 
					<img src="/images/sweeper_car.png" alt="청소차 아이콘">
					<button type="button" class="btn">12가 1234</button> 
				</div>
				<div id="title"> 
					<img src="/images/sweeper_car.png" alt="청소차 아이콘">
					<button type="button" class="btn">34나 3456</button> 
				</div>
				<div id="title"> 
					<img src="/images/sweeper_car.png" alt="청소차 아이콘">
					<button type="button" class="btn">56다 5678</button> 
				</div>
				<div id="title"> 
					<img src="/images/sweeper_car.png" alt="청소차 아이콘">
					<button type="button" class="btn">78라 7890</button> 
				</div>
			</div>
			
			<div class="rounded-box">
				<div id="title"> 
					<div id="datePicker">
						<label for="dateInput" id="dateLabel">날짜 선택: </label> 
						<input type="date" id="dateInput">
					</div>
					<button type="button" class="btn btn-outline-primary" id="btn1">확인</button>
				</div>
				<hr class="hr-divider">
				<p>운행 시간: </p>
				<p>청소 비율: </p>
			</div>
			
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
		</div>
	</div>

	<div id="map"></div>

	<script>

		var longitude = 127.211335;
		var latitude = 37.230504;
		var map;
		var selectedDate;

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
	        zIndex: 99,
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
	        zIndex: 99,
	        source: new ol.source.TileWMS({
	            url: 'http://192.168.0.12:8090/geoserver/sweeper/wms',
	            params: {
	                'LAYERS': 'sweeper:line_view',
	                'FORMAT': 'image/png',
	                'VERSION': '1.1.1',
	                'TILED': true,
	                'VIEWPARAMS': viewParam
	            },
	            serverType: 'geoserver',
	            crossOrigin: 'anonymous'
	        }),
	        layerId : 'line_view',
	    });
	    
	    var line0710Layer = new ol.layer.Tile({
	        zIndex: 99,
	        visible: false,
	        source: new ol.source.TileWMS({
	            url: 'http://localhost:8090/geoserver/sweeper/wms',
	            params: {
	                'LAYERS': 'sweeper:line_0710',
	                'FORMAT': 'image/png',
	                'VERSION': '1.1.1',
	                'TILED': true
	            },
	            serverType: 'geoserver',
	            crossOrigin: 'anonymous'
	        })
	    });
	    
	    var line0725Layer = new ol.layer.Tile({
	        zIndex: 99,
	        visible: false,
	        source: new ol.source.TileWMS({
	            url: 'http://localhost:8090/geoserver/sweeper/wms',
	            params: {
	                'LAYERS': 'sweeper:line_0725',
	                'FORMAT': 'image/png',
	                'VERSION': '1.1.1',
	                'TILED': true
	            },
	            serverType: 'geoserver',
	            crossOrigin: 'anonymous'
	        })
	    });
	    
	    function renderMap() {
	        map = new ol.Map({
	            target: 'map',
	            layers: [
	                boundaryLayer, // 경계 레이어
	                lineViewLayer, // 라인 뷰 레이어
	                line0710Layer, 
	                line0725Layer, 
	                SatelliteLayer, // 위성 지도 레이어
	                HybridLayer, // 하이브리드 레이어
	                BaseLayer // 기본 지도 레이어
	            ],
	            view: new ol.View({
	                center: ol.proj.fromLonLat([longitude, latitude]),
	                zoom: 11.7
	            })
	        });
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
	        boundaryLayer.setVisible(true);
	        layer.setVisible(true); // 선택한 레이어만 보이도록 설정
	    }
	    
	    // datePicker 요소에 접근
	    const datePicker = document.getElementById("dateInput");

	    // datePicker의 값을 가져오기
	    datePicker.addEventListener("change", (event) => {
	        selectedDate = event.target.value;
	    });
	    
	 	// 확인 버튼을 누르면 line_view 레이어를 업데이트하는 함수 호출
	    $(document).on("click", "#btn1", function () {
	        updateLineViewLayer();
	        updateLayerBasedOnDate();
	    });

	    // line_view 레이어를 업데이트하는 함수
	    function updateLineViewLayer() {

	    	// 선택한 날짜를 viewParam에 설정
	        viewParam = "date:" + selectedDate;
	        console.log("* viewParam :", viewParam);

	        var params = lineViewLayer.getSource().getParams();
	        params.VIEWPARAMS = viewParam;
	        
	        // lineViewLayer의 파라미터 업데이트
	        lineViewLayer.getSource().updateParams(params);
	    }
	    
	    
	    
	    function updateLayerBasedOnDate() {
	        if (selectedDate === '2023-07-10') {
	            line0710Layer.setVisible(true);
	            line0725Layer.setVisible(false);
	        } else if (selectedDate === '2023-07-25') {
	            line0710Layer.setVisible(false);
	            line0725Layer.setVisible(true);
	        } else {
	            line0710Layer.setVisible(false);
	            line0725Layer.setVisible(false);
	        }
	    }
	    
	    renderMap();
	    
	</script>
</body>
</html>
