// Adapted from Dan Orban's program written in R
import java.util.Arrays;

void setup() {
  size(1520, 460);
  background(255);
  
  // Load in data
  Table data = loadTable("city_temps.csv", "header");
  
  float minTemp = 9999.0, maxTemp = -9999.0;
  for (TableRow row : data.rows()) {
    // Shorten Months to 3 characters
    row.setString(0, row.getString(0).substring(0, 3));
    
    // Determine min and max temp
    minTemp = min(minTemp, row.getFloat(2));
    maxTemp = max(maxTemp, row.getFloat(2));
  }

  ArrayList<String> months = new ArrayList<>(Arrays.asList("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"));
  ArrayList<String> cities = new ArrayList<>(Arrays.asList("Chicago", "San Diego", "Houston", "Death Valley"));
  
  // Tile variables
  float x, y;
  float tileArea = 100; // everything is sized relative to a tile
  println(int(tileArea * 15.2) + ", " + int(tileArea * 4.6));
  float padding = tileArea / 40;
  float w = tileArea - padding * 2;
  println(padding, w);
  noStroke();
  
  // Heatmap
  rectMode(CORNER);
  for (TableRow row : data.rows()) {
    x = padding + (1.15 + float(months.indexOf(row.getString(0)))) * tileArea;
    y = padding + float(cities.indexOf(row.getString(1))) * tileArea;
    fill(viridis_c(row.getFloat(2), minTemp, maxTemp));
    rect(x, y, w, w);
  }
  
  fill(0);
  textSize(tileArea / 5);
  
  // Y-axis
  textAlign(RIGHT, CENTER);
  for (String city : cities) {
    x = 1.1 * tileArea;
    y = float(cities.indexOf(city)) * tileArea + tileArea / 2 - padding;
    text(city, x, y);
  }
  
  // X-axis
  textAlign(CENTER, TOP);
  for (String month : months) {
    x = (1.65 + float(months.indexOf(month))) * tileArea;
    y = 4.05 * tileArea;
    text(month, x, y);
  }
  
  textSize(tileArea / 4);
  
  // X-axis title
  x = 7.15 * tileArea;
  y = 4.3 * tileArea;
  text("Month", x, y);
  
  // Color Scale title
  textAlign(LEFT, CENTER);
  x = 13.4 * tileArea;
  y = 0.95 * tileArea;
  text("temperature (°F)", x, y);
  
  rectMode(CORNERS);
  
  // Color Scale y-axis location range
  float from = int(1.15 * tileArea);
  float to = int(3.15 * tileArea);
  
  // Color Scale swatches
  x = 13.4 * tileArea;
  float scale_width = 0.4 * tileArea;
  for (y = from; y < to; y++) {
    fill(viridis_c(y, to, from));
    rect(x, y, x + scale_width, y + 1);
  }
  
  // Color Scale markers
  textSize(tileArea / 5);
  int[] markers = {40, 60, 80, 100};
  float notchWidth = 0.05 * tileArea;
  for (int marker : markers) {
    fill(255);
    x = 13.4 * tileArea;
    rect(x, y, x + notchWidth, y + 1);
    x = 13.8 * tileArea;
    y = map(marker, minTemp, maxTemp, to, from);
    rect(x - notchWidth, y, x + notchWidth, y + 1);
    fill(0);
    text(marker, x + 1.5 * notchWidth, y);
  }
}

color viridis_c(float value, float from, float to) {
  // https://waldyrious.net/viridis-palette-generator/
  int[] colors = {
    color(74, 12, 107), // dark
    color(120, 28, 109),
    color(165, 44, 96),
    color(207, 68, 70),
    color(237, 105, 37),
    color(251, 155, 6),
    color(247, 209, 61),
    color(252, 255, 164) // light
  };
  int colorIndex = floor(map(value, from, to, 0, colors.length - 1));
  colorIndex = colorIndex == colors.length - 1 ? colors.length - 2 : colorIndex;
  float transitionStep = (to - from) / float(colors.length - 1);
  return lerpColor(
          colors[colorIndex], 
          colors[colorIndex + 1], 
          map(value - from, transitionStep * colorIndex, transitionStep * (colorIndex + 1), 0, 1));
}
