class Node {
  /* initalize variables */
  float x, y, radius;
  float velocity_x, velocity_y, mass, friction; 

  /* constructor */
  Node(float x_, float y_) {
    x = x_;
    y = y_;
    radius = random(4, 16);
    velocity_x = random(-0.07, 0.07); 
    velocity_y = random(-0.07, 0.07); 
    mass = 4; 
    friction = 0.04;
  }

  /* displaying node function */
  void display() {
    fill(255); /* set fill color */
    ellipse(x, y, 2*radius, 2*radius); /* draw ellipse */
  }

  /* update node */
  void update() {
    /* move */
    x += velocity_x;
    y += velocity_y;
    
    /* screen border collission */
    if (x > width - radius) {
      x = width - radius;
      velocity_x = -velocity_x;
    }
    if (y > height - radius) {
      y = height - radius;
      velocity_y = -velocity_y;
    }
    if (x < radius) {
      x = radius;
      velocity_x = -velocity_x;
    }
    if (y < radius) {
      y = radius;
      velocity_y = -velocity_y;
    }
    
    /* calculate friction */
    velocity_x = lerp(velocity_x, 0, friction);  
    velocity_y = lerp(velocity_y, 0, friction);  
  }
}
