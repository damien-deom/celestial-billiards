import peasy.*;

/**
 * Gravitational Attraction (3D) 
 * by Daniel Shiffman.  
 * 
 * Simulating gravitational attraction 
 * G ---> universal gravitational constant
 * m1 --> mass of object #1
 * m2 --> mass of object #2
 * d ---> distance between objects
 * F = (G*m1*m2)/(d*d)
 *
 * For the basics of working with PVector, see
 * http://processing.org/learning/pvector/
 * as well as examples in Topics/Vectors/
 * 
 */


PeasyCam cam;

final int NB_PLANETS = 3;

// A bunch of planets
//Planet[] planets = new Planet[9];
ArrayList<Planet> planets = new ArrayList<Planet>();

// One sun (note sun is not attracted to planets (violation of Newton's 3rd Law)
Sun s;

int lastTick = 0;
boolean isPaused = false;

final float EPSILON_DIST = 0.01;

void setup() {
  
  //size(1024, 768, P3D);
  fullScreen(P3D);
  //background(0);
  cam = new PeasyCam(this,1400);

  // A single sun
  s = new Sun();
  
  newSim();
}

void newSim() {
  
  //for (int i = 0; i < planets.size(); i++) {
    planets.clear();
  //}
   // Some random planets
  for (int i = 1; i <= NB_PLANETS; i++) {
    addPlanet(i);
  } 
}

void pauseSim() {
  isPaused =  !isPaused;
}

void addPlanet(int id) {
  
  planets.add (new Planet(id,  
                          random(0.1, 2),          // mass
                          random(-width, width),   // x
                          random(-height, height), // y
                          0,                       // z
                          random(20, 80)));         // radius
}

void keyPressed() {
  
  switch (keyCode) {
  case 32: // SPACE
    newSim();
    break;
  case 10: // ENTER
    pauseSim();
    break;
  case 139: // +
    addPlanet(planets.size()+1);
    break;
  case 140: // -
    break;
  }
    
  //println (keyCode);
}

void draw() {
  
  //background(starfield);
  background(0);
  // Setup the scene
  sphereDetail(8);
  lights();
  
  if (!isPaused) {
  
    boolean newTrajectory = false;
    int tick = (millis() / 250);
    
    if (tick != lastTick) {
       //println (tick); 
       lastTick = tick;
       newTrajectory = true;
    }
    
    // reset collisions
    for (Planet p : planets) {
      p.collides = false;
      p.collides_last = false;
    }

    // calcul des forces et collisions
    for (Planet planet : planets) {
      
      //if (planet.collides) continue;
      
      // Sun attracts Planets
      PVector force = s.attract(planet);
      planet.applyForce(force);
      // Update and draw Planets
      planet.update(newTrajectory);
      
      // calcul collision avec le soleil
      if (dist( planet.position.x+ planet.velocity.x, 
                planet.position.y + planet.velocity.y, 
                planet.position.z + planet.velocity.z, 
                s.position.x, 
                s.position.y, 
                s.position.z) <= planet.rad + s.rad + EPSILON_DIST) {
                  
             planet.bounce(s.position);
  
            planet.collides_last = planet.collides;
            planet.collides = true; 
      }
        
      // calcul collision avec les autres planetes
      for (Planet p : planets) {
        if (p.id != planet.id) {
          planet.detectCollision(p);
        }
      }
        
    }
  
  } // pause condition
  
  // Display the Sun
  s.display();
  
  // affichage des planetes
  for (Planet planet : planets) {
    planet.display();
  }

  cam.beginHUD();
  fill(255);
  textSize(20); 
  text("SIMULATION : " + (isPaused ? "PAUSED" : "RUNNING") + " (Press Enter switch, Enter to Reset)" , 10,18);
  text("FRAME RATE : " + nfc(frameRate, 2) + " FPS", 10, 58);
  text("PLANETS       : " + planets.size() + " (Press +/-)", 10, 38);
  cam.endHUD();  

}
