// Gravitational Attraction (3D) 
// Daniel Shiffman <http://www.shiffman.net>

// A class for an orbiting Planet

class Planet {

  // Basic physics model (position, velocity, acceleration, mass)
  int id;
  PVector position, velocity, acceleration;
  float mass, rad;

  boolean collides, collides_last;
  
  color col;
  
  ArrayList<PVector> trajectory = new ArrayList<PVector>();
  
  Planet(int id, float m, float x, float y, float z, float rad) {
   this.id = id;
   this. mass = m;
   this.position = new PVector(x, y, Z);
   this.velocity = new PVector(random(-10,10), random(-10,10), O);   // Arbitrary starting velocity
   this.acceleration = new PVector(0, 0,0);
   this.rad = rad;
   this.collides = false;
   this.collides_last = false;
   this.col = color(random(0,255),random(0,255),random(0,255));
  }

  // Newton's 2nd Law (F = M*A) applied
  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  // Our motion algorithm (aka Euler Integration)
  void update(boolean newTrajectory) {
    velocity.add(acceleration); // Velocity changes according to acceleration
    position.add(velocity);     // position changes according to velocity
    acceleration.mult(0);
    
    if (newTrajectory) {
      trajectory.add(new PVector(position.x,position.y, position.z));
      
      if (trajectory.size() > 25) {
         trajectory.remove(0); 
      }
    }
  }

  boolean detectCollision(Planet p) {
    boolean c =  dist(this.position.x + this.velocity.x, 
                      this.position.y + this.velocity.y, 
                      this.position.z + this.velocity.z, 
                      p.position.x, 
                      p.position.y, 
                      p.position.z) <= this.rad + p.rad + EPSILON_DIST;
    
    if (c) {
      this.bounce(p.position);
      p.bounce(this.position);
    }
    
    this.collides_last = this.collides;
    this.collides |= c;
    
    p.collides_last = p.collides;
    p.collides |= c;
    
    return c;
  }

  void bounce(PVector position) {
    //https://stackoverflow.com/questions/573084/how-to-calculate-bounce-angle
    
    PVector normal = PVector.sub(this.position, position);
    
    PVector uv = PVector.mult(normal, PVector.dot(this.velocity,normal) / PVector.dot(normal,normal));
    
    this.velocity = PVector.sub(this.velocity, uv.mult(2));
    this.acceleration.set(0,0,0); 
    
    /*
    print("Normal (");
    print(normal.x);
    print(", ");
    print(normal.y);
    print(", ");
    print(normal.z);
    println(")");*/
    /*
    print("Vel (");
    print(velocity.x);
    print(", ");
    print(velocity.y);
    print(", ");
    print(velocity.z);
    println(")");*/
  }

  // Draw the Planet
  void display() {
    
    
    color c = this.collides ? color(255, 0, 0): this.col;
    
    noStroke();
    pushMatrix();
    fill(c);
    translate(position.x, position.y, position.z);
    sphere(rad);
    popMatrix();
    
    textSize(60);
    fill(255, 255, 255, 204);
    text(str(id), position.x, position.y,position.z+this.rad);
    
    if (trajectory.size() <2) return;
    
    for (int i = 1; i < trajectory.size(); i++) {

      PVector p1 = trajectory.get(i);
      PVector p2 = trajectory.get(i-1);
      
      /*
      pushMatrix();
      fill(col);
      translate(p1.x, p1.y, p1.z);
      sphere(rad);
      popMatrix();*/
      strokeWeight(4);
      stroke(c);
      line(p1.x,p1.y,p1.z,p2.x,p2.y,p2.z);
      
    }
    
  }
}
