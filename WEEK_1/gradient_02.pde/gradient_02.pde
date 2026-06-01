void setup() { 

  size(400, 300); 

  pixelDensity(1);  

} 


void draw() { 

  loadPixels(); 

   

  for (int x = 0; x < width; x++) { 

    for (int y = 0; y < height; y++) { 

       

      float normalizedY = map(y, 0, height - 1, 0, 1);  

       

   
      int red = int(map(normalizedY, 0, 1, 255, 40));    

      int green = int(map(normalizedY, 0, 1, 0, 10));    

      int blue = int(map(normalizedY, 0, 1, 150, 120));  

       

      color c = color(red, green, blue); 

      pixels[x + y * width] = c;  

    } 

  } 

updatePixels(); 

} 
