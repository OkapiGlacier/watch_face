import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Sensor;
import Toybox.SensorHistory;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.WatchUi;
import Toybox.Weather;
//import Toybox;

var weatherNames as Array<String> = [
    "Clear",
    "Partly cloudy",
    "Mostly cloudy",
    "Rain",
    "Snow",
    "Windy",
    "Thunderstorms",
    "Wintry mix",
    "Fog",
    "Hazy",
    "Hail",
    "Scattered showers",
    "Scattered thunderstorms",
    "Unknown precipitation",
    "Light rain",
    "Heavy rain",
    "Light snow",
    "Heavy snow",
    "Light rain snow",
    "Heavy rain snow",
    "Cloudy",
    "Rain snow",
    "Partly clear",
    "Mostly clear",
    "Light showers",
    "Showers",
    "Heavy showers",
    "Chance of showers",
    "Chance of thunderstorms",
    "Mist",
    "Dust",
    "Drizzle",
    "Tornado",
    "Smoke",
    "Ice",
    "Sand",
    "Squall",
    "Sandstorm",
    "Volcanic ash",
    "Haze",
    "Fair",
    "Hurricane",
    "Tropical storm",
    "Chance of snow",
    "Chance of rain snow",
    "Cloudy chance of rain",
    "Cloudy chance of snow",
    "Cloudy chance of rain snow",
    "Flurries",
    "Freezing rain",
    "Sleet",
    "Ice snow",
    "Thin clouds",
    "Unknown"
];

class watchFaceView extends WatchUi.WatchFace {
    var background_bitmap;

    function initialize() {
        WatchFace.initialize();
        background_bitmap=WatchUi.loadResource(Rez.Drawables.Watch_Background);  //load the bitmap using your id in place of id_pic
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Get and show the current time
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var view = View.findDrawableById("TimeLabel") as Text;
        view.setText(timeString);
        
        var utcTime = Time.now();
        var utcTimeInfo = Gregorian.utcInfo(utcTime, Time.FORMAT_MEDIUM);
        var utcTimeLabel = View.findDrawableById("UTCTimeLabel") as Text;
        var utcTimeString = Lang.format("$1$:$2$", [utcTimeInfo.hour, utcTimeInfo.min.format("%02d")]);
        utcTimeLabel.setText(utcTimeString);

        var dateLabel = View.findDrawableById("DateLabel") as Text;
        dateLabel.setText(getDate());

        var heartRateLabel = View.findDrawableById("HeartRateLabel") as Text;
        heartRateLabel.setText(getHeartRateString()); 

        var bodyBatteryLabel = View.findDrawableById("BodyBatteryLabel") as Text;
        bodyBatteryLabel.setText(getBodyBatteryString());

        var stepsLabel = View.findDrawableById("StepsLabel") as Text;
        stepsLabel.setText(getStepsString() + "/");

        var stepgoalLabel = View.findDrawableById("StepGoalLabel") as Text;
        stepgoalLabel.setText(getStepGoalString());

        var batteryLabel = View.findDrawableById("BatteryLabel") as Text;
        batteryLabel.setText(getBatteryString());  

        var baroLabel = View.findDrawableById("BaroLabel") as Text;
        baroLabel.setText(getBaroString());

        var altitudeLabel = View.findDrawableById("AltitudeLabel") as Text;
        altitudeLabel.setText(getAltitudeString());

        var caloriesLabel = View.findDrawableById("CaloriesLabel") as Text;
        caloriesLabel.setText(getCaloriesString());

        var solarLabel = View.findDrawableById("SolarLabel") as Text;
        solarLabel.setText(getSolarString());

        var battDaysLabel = View.findDrawableById("BattDaysLabel") as Text;
        battDaysLabel.setText(getBattTimeString());

        var WeatherLabel = View.findDrawableById("WeatherLabel") as Text;
        WeatherLabel.setText(getWeatherString());

        //var WeatherLocationLabel = View.findDrawableById("WeatherLocationLabel") as Text;
        //WeatherLocationLabel.setText(getWeatherLocationString());

        var WeatherTimeLabel = View.findDrawableById("WeatherTimeLabel") as Text;
        WeatherTimeLabel.setText(getWeatherTimeString());

        var HiLoTempLabel = View.findDrawableById("HiLoTempLabel") as Text;
        HiLoTempLabel.setText(getHiLoTempString());

        var CurrentTempLabel = View.findDrawableById("CurrentTempLabel") as Text;
        CurrentTempLabel.setText(getCurrentTempString());

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);

        //drawReferenceLines(dc);
        //drawWatchTicks(dc);
        dc.drawBitmap(0, 0, background_bitmap);

    }

    function drawReferenceLines(dc as Dc) as Void {
        var WIDTH = dc.getWidth();
        var HEIGHT = dc.getHeight();

        dc.setPenWidth(1);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(0.2 * WIDTH, 0.1 * HEIGHT, 0.6 * WIDTH, 0.8 * HEIGHT);
        dc.drawRectangle(0.15 * WIDTH, 0.15 * HEIGHT, 0.7 * WIDTH, 0.7 * HEIGHT);
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(0.1 * WIDTH, 0.2 * HEIGHT, 0.8 * WIDTH, 0.6 * HEIGHT);
        dc.drawRectangle(0.05 * WIDTH, 0.3 * HEIGHT, 0.9 * WIDTH, 0.4 * HEIGHT);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0, 0.25 * HEIGHT, WIDTH, 1);
        dc.fillRectangle(0, 0.5 * HEIGHT, WIDTH, 1);
        dc.fillRectangle(0, 0.75 * HEIGHT, WIDTH, 1);
        dc.fillRectangle(0.25 * WIDTH, 0, 1, HEIGHT);

        dc.fillRectangle(0.1 * WIDTH, 0, 1, HEIGHT);
        dc.fillRectangle(0.9 * WIDTH, 0, 1, HEIGHT);

        dc.fillRectangle(0.5 * WIDTH, 0, 1, HEIGHT);
        dc.fillRectangle(0.75 * WIDTH, 0, 1, HEIGHT);

        dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(0.3333 * WIDTH, 0, 1, HEIGHT);
        dc.fillRectangle(0.6666 * WIDTH, 0, 1, HEIGHT);
    }

    function drawWatchTicks(dc as Dc) as Void {
        var WIDTH = dc.getWidth();
        var HEIGHT = dc.getHeight();
        //var RADIUS = Math.sqrt(WIDTH*WIDTH+HEIGHT*HEIGHT);

        dc.setPenWidth(1);

        dc.setColor(Graphics.COLOR_YELLOW, Graphics.COLOR_TRANSPARENT);
        //dc.fillRectangle(WIDTH/2-1, 0, 3, 10);

        dc.setPenWidth(20);

        dc.drawArc(WIDTH/2, HEIGHT/2, WIDTH/2 -20, Graphics.ARC_CLOCKWISE, 3, -3);
    }
    

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

    // Date
    function getDate() as String {
        var now = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var dateString = Lang.format("$1$ $2$ \n$3$", [
            now.day_of_week,
            now.day,
            now.month,
        ]
        );
        return dateString;
    }

    // Heart rate
    function getHeartRate() as Number {
        var heartrateIterator = Toybox.ActivityMonitor.getHeartRateHistory(1, true);
        return heartrateIterator.next().heartRate;
    }

    function getHeartRateString() as String {
        return "HR " + getHeartRate().format("%d");
    }

    // Body battery
    function getBodyBatteryIterator() {
        if ((Toybox has: SensorHistory) && (Toybox.SensorHistory has: getBodyBatteryHistory)) {
            return Toybox.SensorHistory.getBodyBatteryHistory({: period => 1,
                : order => Toybox.SensorHistory.ORDER_NEWEST_FIRST
            });
        }
        return null;
    }

    function getBodyBattery() as Number or Null {
        var bbIterator = getBodyBatteryIterator();
        var sample = bbIterator.next();

        while (sample != null) {
            if (sample.data != null) {
                return sample.data;
            }
            sample = bbIterator.next();
        }

        return null;
    }

    function getBodyBatteryString() as String {
        var bodyBattery = getBodyBattery();
        if (bodyBattery == null) {
            return "-";
        }
        return bodyBattery.format("%d") + "%";
    }

    // Steps
    function getSteps() as Number or Null {
        return Toybox.ActivityMonitor.getInfo().steps;
    }

    function getStepsString() as String {
        var steps = getSteps();
        if (steps == null) {
            return "-";
        }
        return getSteps().format("%d");
    }

    function getStepGoal() as Number or Null {
        return Toybox.ActivityMonitor.getInfo().stepGoal;
    }

    function getStepGoalString() as String {
        var steps = getStepGoal();
        if (steps == null) {
            return "-";
        }
        return steps.format("%d");
    }

    // Watch battery
    function getBattery() as Float {
        return Toybox.System.getSystemStats().battery;
    }

    function getBatteryString() as String {
        return getBattery().format("%d") + "%";
    }

    // watch battery by days
    function getBattTime() as Float {
        return Toybox.System.getSystemStats().batteryInDays;
    }

    function getBattTimeString() as String {
        var battTime = getBattTime();
        var battDays = battTime.toNumber();
        var battHours = ((battTime*1000).toNumber() % 1000)*24.0/1000.0;

        return battDays.format("%d") + "d" + battHours.format("%d") + "h"; 
    }

    // barometric pressure
    function getBaroIterator() {
        // Check device for SensorHistory compatibility
        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getPressureHistory)) {
            return Toybox.SensorHistory.getPressureHistory({});
        }
        return null;
    }
    
    function getBaro() as Float {
        var pressureItr = getBaroIterator();
        //var pressure = Toybox.Sensor.getInfo().pressure;
        if (pressureItr != null) {
            return pressureItr.next().data/100;
        } else {
            return 0.0;
        }
    }

    function getBaroString() as String {
        return getBaro().format("%d");
    }

    // altitude
    function getAltitudeIterator() {
    // Check device for SensorHistory compatibility
        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getElevationHistory)) {
            return Toybox.SensorHistory.getElevationHistory({});
        }
        return null;
    }

    function getAltitude() as Float or Null {
        var altitudeItr = getAltitudeIterator();
        if (altitudeItr != null) {
            return altitudeItr.next().data * 3.28084;
        } else {
            return null;
        }
    }

    function getAltitudeString() as String {
        var altitude = getAltitude();
        if (altitude != null) {
            return altitude.format("%d") + "'";
        } else {
            return "null'";
        }
    }

    // calories
    function getCalories() as Float or Null {
        return Toybox.ActivityMonitor.getInfo().calories;
    }

    function getCaloriesString() as String {
        var calories = getCalories();
        if (calories != null) {
            if (calories >= 10000) {
                var cal_chop = calories/1000.0;
                return cal_chop.format("%.1f") + "k";
            } else { 
                return calories.format("%d");
            }
        } else {
            return "null";
        }
    }

    // solar
    function getSolar() as Float or Null {
        return Toybox.System.getSystemStats().solarIntensity; 
    }

    function getSolarString() as String {
        var solar = getSolar();
        if (solar != null) {
            return solar.format("%d") + "%";
        } else {
            return "null";
        }
    }

    // weather
    function getWeatherCondition() as Number {
        return Toybox.Weather.getCurrentConditions().condition;
    }

    function getWeatherString() as String {
        var condition = getWeatherCondition();
        if (condition >=0 && condition <= 53) {
            return weatherNames[condition];
        }
        return "unkown thing: " + condition.format("%d");
    }

    function getWeatherLocationString() as String {
        // text based location is deprecated :[
        //var weatherLocation = Toybox.Weather.getCurrentConditions().observationLocationName;
        var weatherLocation = Toybox.Weather.getCurrentConditions().observationLocationPosition;

        var gps_loc_str = "-";

        if (weatherLocation == null) {
            gps_loc_str = "[unknown]";
        } else {
            var gps_loc_deg = weatherLocation.toDegrees();
            gps_loc_str = "[" + gps_loc_deg[0].toString() + ", " + gps_loc_deg[1].toString() + "]";
        }



        return gps_loc_str;
    }

    function getWeatherTimeString() as String {
        var weatherTime = Toybox.Weather.getCurrentConditions().observationTime;
        var weather_time_str = "-";

        if (weatherTime == null) {
            weather_time_str = "--:--";
        } else {
            var time_info = Gregorian.info(weatherTime, Time.FORMAT_MEDIUM);
            weather_time_str = Lang.format("$1$:$2$", [time_info.hour, time_info.min.format("%02d")]);
        }

        return "at: " + weather_time_str;

    }

    function getHiLoTempString() as String {
        var tempHi = Toybox.Weather.getCurrentConditions().highTemperature;
        var tempLo = Toybox.Weather.getCurrentConditions().lowTemperature;

        var tempHiString = "--";
        var tempLoString = "--";
        //var tempHiLoString = "--/--";

        if (tempHi != null) {
            tempHi = tempHi * 9.0/5.0 + 32.0;
            tempHiString = tempHi.format("%i");
        }

        if (tempLo != null) {
            tempLo = tempLo * 9.0/5.0 + 32.0;
            tempLoString = tempLo.format("%i");
        }

        return tempHiString + "/" + tempLoString;
        //return tempHiLoString;
    }

    function getCurrentTempString() as String {
        var temp = Toybox.Weather.getCurrentConditions().temperature;
        var tempFeels = Toybox.Weather.getCurrentConditions().feelsLikeTemperature;

        var tempString = "--";
        var tempFeelsString = "--";

        if (temp != null) {
            temp = temp * 9.0/5.0 + 32.0;
            tempString = temp.format("%i");
        }

        if (tempFeels != null) {
            tempFeels = tempFeels * 9.0/5.0 + 32.0;
            tempFeelsString = tempFeels.format("%i");
        }

        return tempString + "/" + tempFeelsString;    }
}
