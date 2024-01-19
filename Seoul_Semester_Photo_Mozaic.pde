/*
I created this collage for the creative algorithms assignement.
The goal is to have a collage that represents my semester in Seoul and uses the
photos I took during the semester.
A way to make this code better would be to implement :
- lazy loading for the images 
so that the images don't take as long to load when not all the tiles are visible.
- It would also be good to see how I can make the code able to use thousands of photos
without running into memory issues.
*/


PImage seoulImage;
PImage[] photos; // Array to store my photos
int tileSize = 40; // Size of each tile in pixels
float zoomLevel = 0.8; // Initial zoom level
int borderSize = 2; // Size of the border between tiles

void setup() {
  size(1800, 1200);
  seoulImage = loadImage("National-Animal-Of-South-Korea.jpg");
  seoulImage.resize(width, height); // Resize the image to the size of the canvas
  loadPhotos(); // Load my photos
  noLoop(); // Disable looping of draw()
}

void draw() {
  background(200); 
  scale(zoomLevel); // Apply the current zoom level
  
  int numTilesX = getNumTilesX();
  int numTilesY = getNumTilesY();
  
  for (int y = 0; y < numTilesY; y++) {
    for (int x = 0; x < numTilesX; x++) {
      
      color avgColor = getAverageColor(x * tileSize, y * tileSize, tileSize, tileSize);
      
      drawTiles(x, y);
     
     addPhotos(avgColor, x, y);
      
    }
  }
}

int getNumTilesX(){
  int numTilesX = int(width / (tileSize * zoomLevel));
  return numTilesX;
}

int getNumTilesY(){
  int numTilesY = int(height / (tileSize * zoomLevel));
  return numTilesY;
}


color getAverageColor(int x, int y, int w, int h) {
  float r = 0;
  float g = 0;
  float b = 0;
  
  for (int i = x; i < x + w; i++) {
    for (int j = y; j < y + h; j++) {
      color c = seoulImage.get(i, j);
      r += red(c);
      g += green(c);
      b += blue(c);
    }
  }
  
  int numPixels = w * h;
  r /= numPixels;
  g /= numPixels;
  b /= numPixels;
  
  return color(r, g, b);
}


void drawTiles(int x, int y){
   fill(0);
   noStroke();
   rect(x * tileSize - borderSize, y * tileSize - borderSize, tileSize + borderSize * 2, tileSize + borderSize * 2);
}

void addPhotos(color avgColor, int x, int y){
  
  PImage randomPhoto = photos[int(random(photos.length))];
     
  // apply a tint to the images using the avg color of the tile
  tint(avgColor, 200);
  image(randomPhoto, x * tileSize, y * tileSize, tileSize, tileSize);
}


void loadPhotos() {
  int numPhotos = 45; // Adjust to desired number of photos
  photos = new PImage[numPhotos];
  for (int i = 0; i < numPhotos; i++) {
    photos[i] = loadImage("Seoul/photo- (" + (i + 1) + ").jpg"); 
  }
}

void mouseWheel(MouseEvent event) {
  float zoomChange = event.getCount() > 0 ? 0.1 : -0.1; // Positive count is zoom in, negative count is zoom out
  zoomLevel = constrain(zoomLevel + zoomChange, 0.1, 5.0); // Limit zoom range
  redraw(); // Redraw the canvas to apply the new zoom level
}
