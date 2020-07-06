class Spring {
  /* initialize variables */
  /* constants */
  final float spring_constant, damping, rest_position, mass;
  /* simulation variables */
  Node n1;
  Node n2;
  float position, velocity, acceleration, force;
  
   /* constructor */
  Spring(Node n1_, Node n2_) {
    /* constants */
    spring_constant = 2; 
    damping = 0.92;
    rest_position = 15;
    mass = 20;
    
    /* simulation variables */
    if ((n1_.y >= n2_.y) || (n1_.x >= n2_.x)) {
      n1 = n2_;
      n2 = n1_;
    } else {
      n1 = n1_;
      n2 = n2_;
    }
    position = rest_position;
    velocity = 0.0;
    acceleration = 0;
    force = 0;
  }
  
  /* draw spring */
  void display() {
    fill(0);
    line(n1.x, n1.y, n2.x, n2.y);
  }
  
  /* update spring */
  void update() {
    /* update spring position */
    force = -spring_constant * (position - rest_position);      /* force = -ky */
    acceleration = force / mass;                                /* set the acceleration f=ma == a=f/m */
    velocity = damping * (velocity + acceleration);             /* set the velocity */
    position = (sqrt(abs((n2.x - n1.x)*2 + (n2.y - n1.y)*2)));    /* set position to distance between the two nodes */
    
    /* update position */
    if (position >= 0){
      position = position + velocity;
    } else {
      position = position - velocity;
    }
    
    /* make adjust nodes to position via position variables after adding velocity */
    n1.x = -((pow(position, 2) - (2 * n2.x) - (2 * n2.y) + (2 * n1.y))/2);
    n1.y = -((pow(position, 2) - (2 * n2.x) + (2 * n1.x) - (2 * n2.y))/2);
    n2.x = ((pow(position, 2) + (2 * n1.x) - (2 * n2.y) + (2 * n1.y))/2);
    n2.y = ((pow(position, 2) - (2 * n2.x) + (2 * n1.x) + (2 * n1.y))/2);

    /* set velocity to 0 when its below 0.1 */
    if(abs(velocity) < 0.05) { 
      velocity = 0.0;
    }
    
    
    
    
  }
}
