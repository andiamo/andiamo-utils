import codeanticode.syphon.*;
import deadpixel.keystone.*;

PGraphics canvas;
SyphonClient client;

int OUTPUT_SCREEN = 2;
Keystone ks;
CornerPinSurface surface;

PGraphics offscreen;

public void setup() {
  fullScreen(P3D, OUTPUT_SCREEN);
  
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(width, height, 20);  
  
  println("Available Syphon servers:");
  println(SyphonClient.listServers());
    
  // Create syhpon client to receive frames 
  // from the first available running server: 
  client = new SyphonClient(this);

  // A Syphon server can be specified by the name of the application that it contains it,
  // its name, or both:
  
  // Only application name.
  //client = new SyphonClient(this, "SendFrames");
    
  // Both application and server names
  //client = new SyphonClient(this, "SendFrames", "Processing Syphon");
  
  // Only server name
  //client = new SyphonClient(this, "", "Processing Syphon");
    
  // An application can have several servers:
  //client = new SyphonClient(this, "Quartz Composer", "Raw Image");
  //client = new SyphonClient(this, "Quartz Composer", "Scene");
  
  // We need an offscreen buffer to draw the surface we
  // want projected
  // note that we're matching the resolution of the
  // CornerPinSurface.
  // (The offscreen buffer can be P2D or P3D)
  offscreen = createGraphics(width, height, P2D);
}

public void draw() {
  // Convert the mouse coordinate into surface coordinates
  // this will allow you to use mouse events inside the 
  // surface from your screen. 
  PVector surfaceMouse = surface.getTransformedMouse();
  
  if (client.newFrame()) {
    canvas = client.getGraphics(canvas);
    
  }

  // Draw the scene, offscreen
  offscreen.beginDraw();
  if (canvas == null) {
    offscreen.background(0);
  } else {
    offscreen.image(canvas, 0, 0, offscreen.width, offscreen.height); 
  }
  offscreen.endDraw();

  // most likely, you'll want a black background to minimize
  // bleeding around your projection area
  background(0);
 
  // render the scene, transformed using the corner pin surface
  surface.render(offscreen);  
}

void keyPressed() {
  switch(key) {
  case 'c':
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    ks.toggleCalibration();
    break;

  case 'l':
    // loads the saved layout
    ks.load();
    break;

  case 's':
    // saves the layout
    ks.save();
    break;
    
  case ' ':
    // Stops the client
    client.stop();  
    break;
    
  case 'd':  
    println(client.getServerName());
  }
}