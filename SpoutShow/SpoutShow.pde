//
//             SpoutReceiver
//
//       Receive from a Spout sender
//
//             spout.zeal.co
//
//       http://spout.zeal.co/download-spout/
//

// IMPORT THE SPOUT LIBRARY
import spout.*;
import deadpixel.keystone.*;

Keystone ks;
CornerPinSurface surface;

PGraphics canvas; // Canvas to receive a texture

int OUTPUT_SCREEN = 2;

// DECLARE A SPOUT OBJECT
Spout spout;

PGraphics offscreen;

void setup() {
  
  // Initial window size
  fullScreen(P3D, OUTPUT_SCREEN);
  
  ks = new Keystone(this);
  surface = ks.createCornerPinSurface(width, height, 20);  
  
  // Needed for resizing the window to the sender size
  // Processing 3+ only
  //surface.setResizable(true);
   
  // Create a canvas or an image to receive the data.
  canvas = createGraphics(width, height, P2D);
  
  // Graphics and image objects can be created
  // at any size, but their dimensions are changed
  // to match the sender that the receiver connects to.
  
  // CREATE A NEW SPOUT OBJECT
  spout = new Spout(this);
  
  // OPTION : CREATE A NAMED SPOUT RECEIVER
  //
  // By default, the active sender will be detected
  // when receiveTexture is called. But you can specify
  // the name of the sender to initially connect to.
  // spout.createReceiver("Spout DX11 Sender");
 
 
  offscreen = createGraphics(width, height, P2D);
} 

void draw() {
  PVector surfaceMouse = surface.getTransformedMouse();
    
  // OPTION 2: Receive into PGraphics texture
  canvas = spout.receiveTexture(canvas);
  image(canvas, 0, 0, width, height);
    
  // Draw the scene, offscreen
  offscreen.beginDraw();
  if (canvas == null) {
    offscreen.background(255);
  } else {
    offscreen.image(canvas, 0, 0, offscreen.width, offscreen.height);
  }
  offscreen.endDraw();    
    
  background(0);
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
    // Bring up a dialog to select a sender.
    // Spout installation required  
    spout.selectSender();
    break;
  }
}