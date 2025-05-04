// Gravitational Attraction (3D) 
// Daniel Shiffman <http://www.shiffman.net>

// A class for an attractive body in our world

class Sun {
  float mass;         // Mass, tied to size
  float rad;
  PVector position;   // position
  float G;            // Universal gravitational constant (arbitrary value)

  Sun() {
    this.position = new PVector(0, 0);
    this.mass = 80;
    this.rad = mass*2;
    this.G = 0.4;
  }


  PVector attract(Planet m) {
    PVector force = PVector.sub(position, m.position);    // Calculate direction of force
    float d = force.mag();                               // Distance between objects
    d = constrain(d, 5.0, 25.0);                           // Limiting the distance to eliminate "extreme" results for very close or very far objects
    float strength = (G * mass * m.mass) / (d * d);      // Calculate gravitional force magnitude
    force.setMag(strength);                              // Get force vector --> magnitude * direction
    return force;
  }

  // Draw Sun
  void display() {
    noStroke();
    fill(255,255,0);
    pushMatrix();
    translate(position.x, position.y, position.z);
    sphere(rad);
    popMatrix();
    
    textSize(80);
    fill(255, 255, 255, 204);
    text("SUN", position.x, position.y,position.z+this.rad);
  }
}
