<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../tilesLayouts/commonPageLibrary.jsp" %>

<!-- BEGIN PAGE JAVASCRIPT -->
<script src="https://www.amcharts.com/lib/4/core.js"></script>
<script src="https://www.amcharts.com/lib/4/charts.js"></script>
<script src="https://www.amcharts.com/lib/4/themes/animated.js"></script>

<script type="text/javascript">

$(document).ready(function(){
	fnInitEvent();
	
	fnSetChart();
});

function fnInitEvent(){

}

function fnSetChart() {
	// Themes begin
	am4core.useTheme(am4themes_animated);
	// Themes end

	// Create chart instance
	var chart = am4core.create("chartdiv", am4charts.XYChart);

	chart.colors.step = 2;
	chart.maskBullets = false;

	// Add data
	chart.data = [{
	    "date": "2012-01-01",
	    "distance": 227,
	    "townName": "New York Area",
	    "townName2": "New York Area",
	    "townSize": 12,
	    "latitude": 40.71,
	    "duration": 408
	}, {
	    "date": "2012-01-02",
	    "distance": 371,
	    "townName": "Washington Area",
	    "townSize": 7,
	    "latitude": 38.89,
	    "duration": 482
	}, {
	    "date": "2012-01-03",
	    "distance": 433,
	    "townName": "Wilmington Area",
	    "townSize": 3,
	    "latitude": 34.22,
	    "duration": 562
	}, {
	    "date": "2012-01-04",
	    "distance": 345,
	    "townName": "Jacksonville Area",
	    "townSize": 3.5,
	    "latitude": 30.35,
	    "duration": 379
	}];

	// Create axes
	var dateAxis = chart.xAxes.push(new am4charts.DateAxis());
	dateAxis.renderer.grid.template.location = 0;
	dateAxis.renderer.minGridDistance = 50;
	dateAxis.renderer.grid.template.disabled = true;
	dateAxis.renderer.fullWidthTooltip = true;

	var distanceAxis = chart.yAxes.push(new am4charts.ValueAxis());
	distanceAxis.title.text = "Power (kW)";
	distanceAxis.renderer.grid.template.disabled = true;

	/* var durationAxis = chart.yAxes.push(new am4charts.DurationAxis());
	durationAxis.title.text = "Duration";
	durationAxis.baseUnit = "minute";
	durationAxis.renderer.grid.template.disabled = true;
	durationAxis.renderer.opposite = true;

	durationAxis.durationFormatter.durationFormat = "hh'h' mm'min'"; */

	var latitudeAxis = chart.yAxes.push(new am4charts.ValueAxis());
	latitudeAxis.renderer.grid.template.disabled = true;
	latitudeAxis.renderer.labels.template.disabled = true;

	// Create series
	var distanceSeries = chart.series.push(new am4charts.ColumnSeries());
	distanceSeries.dataFields.valueY = "distance";
	distanceSeries.dataFields.dateX = "date";
	distanceSeries.yAxis = distanceAxis;
	distanceSeries.tooltipText = "{valueY} miles";
	//distanceSeries.name = "Distance";
	distanceSeries.name = "Zone 01";
	distanceSeries.columns.template.fillOpacity = 0.7;
	distanceSeries.columns.template.propertyFields.strokeDasharray = "dashLength";
	distanceSeries.columns.template.propertyFields.fillOpacity = "alpha";

	var disatnceState = distanceSeries.columns.template.states.create("hover");
	disatnceState.properties.fillOpacity = 0.9;

	/* var durationSeries = chart.series.push(new am4charts.LineSeries());
	durationSeries.dataFields.valueY = "duration";
	durationSeries.dataFields.dateX = "date";
	durationSeries.yAxis = durationAxis;
	durationSeries.name = "Duration";
	durationSeries.strokeWidth = 2;
	durationSeries.propertyFields.strokeDasharray = "dashLength";
	durationSeries.tooltipText = "{valueY.formatDuration()}";

	var durationBullet = durationSeries.bullets.push(new am4charts.Bullet());
	var durationRectangle = durationBullet.createChild(am4core.Rectangle);
	durationBullet.horizontalCenter = "middle";
	durationBullet.verticalCenter = "middle";
	durationBullet.width = 7;
	durationBullet.height = 7;
	durationRectangle.width = 7;
	durationRectangle.height = 7;

	var durationState = durationBullet.states.create("hover");
	durationState.properties.scale = 1.2; */

	var latitudeSeries = chart.series.push(new am4charts.LineSeries());
	latitudeSeries.dataFields.valueY = "latitude";
	latitudeSeries.dataFields.dateX = "date";
	latitudeSeries.yAxis = latitudeAxis;
	//latitudeSeries.name = "Duration";
	latitudeSeries.name = "Zone 02";
	latitudeSeries.strokeWidth = 2;
	latitudeSeries.propertyFields.strokeDasharray = "dashLength";
	latitudeSeries.tooltipText = "Latitude: {valueY} ({townName})";

	var latitudeBullet = latitudeSeries.bullets.push(new am4charts.CircleBullet());
	latitudeBullet.circle.fill = am4core.color("#fff");
	latitudeBullet.circle.strokeWidth = 2;
	latitudeBullet.circle.propertyFields.radius = "townSize";

	var latitudeState = latitudeBullet.states.create("hover");
	latitudeState.properties.scale = 1.2;

	var latitudeLabel = latitudeSeries.bullets.push(new am4charts.LabelBullet());
	latitudeLabel.label.text = "{townName2}";
	latitudeLabel.label.horizontalCenter = "left";
	latitudeLabel.label.dx = 14;

	// Add legend
	chart.legend = new am4charts.Legend();

	// Add cursor
	chart.cursor = new am4charts.XYCursor();
	chart.cursor.fullWidthLineX = true;
	chart.cursor.xAxis = dateAxis;
	chart.cursor.lineX.strokeOpacity = 0;
	chart.cursor.lineX.fill = am4core.color("#000");
	chart.cursor.lineX.fillOpacity = 0.1;
}

</script>
<style>
#chartdiv {
  width: 100%;
  height: 500px;
}

</style>
<input type="text" id="dashboardPageVal" value="1">

<div class="row_merchantname">
	FOM Daily Data
</div>
<div class="row_slidemerchant" id="row_slidemerchant_id">
	<ul id="slide_merchant" class="content-slider" style="height: 500px;">
		<li id="dashArea01">
			<div class="boxmerchant">
				<p class="title_merchant">14/02/2019 Today Power Value</p>
				<div class="infomerchant">
					<div class="prizemerchant">2,000,000 kW</div>
				</div>
			</div>
		</li>
		<li id="dashArea02">
			<center>
				<div id="chartdiv"></div>
			</center>
			<!-- <div class="boxmerchant">
				<p class="title_merchant">1 Week Power Value Chart</p>
				<div class="infomerchant">
					<div class="chart-wrapper">
						<div class="blueberryChart demo1"></div>
					</div>
					<p class="linedes"><span>All Power Value</span></p>
				</div>
			</div> -->
		</li>
	</ul>
</div>
<div class="row_today">
	<ul class="listtoday">
		<li>
			<a href="transaction.html" class="boxtoday">
				<p>Today Average Power
					<span>(Power)</span>
				</p>
				<h3 class="pricetoday">100 kW</h3>
			</a>
		</li>
		<li>
			<a href="transaction.htm" class="boxtoday">
				<p>Today Average Voltage
					<span>(volt)</span>
				</p>
				<h3 class="pricetoday">20 V</h3>
			</a>
		</li>
		<li>
			<a href="transaction.htm" class="boxtoday">
				<p>Today Average Current
					<span>(Current)</span>
				</p>
				<h3 class="pricetoday">2,500 A</h3>
			</a>
		</li>
	</ul>
</div>
<ul class="sett_tracs">
	<li><a href="settlement1.html">Temperature Value<br />history</a></li>
	<li><a href="transaction.html">Power Value<br />history</a></li>
</ul>
<div class="row_support" id="row_support_id">
	<span class="titlesupport">Customer support</span>
	<ul class="listsupport">
		<li>
			<a href="#0"><span class="icon-notice"></span>Notice</a>
		</li>
		<li>
			<a href="#0"><span class="icon-faq"></span>FAQ</a>
		</li>
		<li>
			<a href="#0"><span class="icon-phone"></span>0123456789</a>
		</li>
	</ul>
</div>
