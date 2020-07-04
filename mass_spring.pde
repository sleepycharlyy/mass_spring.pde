/* global variables */
ArrayList<Node> nodes = new ArrayList<Node>();


/* setup function runs at start once */
void setup() {
  /* window size */
  size(640, 480);
}

/* draw function (runs every frame) */
void draw() {
  background(255); /* set background color white */
  
  /* draw and move all nodes */
  for(int i = 0; i < nodes.size(); i++) {
    nodes.get(i).display();
    nodes.get(i).move();
  }
  
  /* check collision on all nodes with all other nodes */
  for(int i = 0; i < nodes.size() - 1; i++) {
    for(int j = i + 1; j < nodes.size(); j++) {
      if (node_collision_state_get(nodes.get(i), nodes.get(j))) { /* when two nodes collide */
        node_collision_collide(nodes.get(i), nodes.get(j)); /* execute collision physics */
      }
    }
  }
}

/* mouse press event */
void mousePressed() {
  if (mouseButton == LEFT) {
    float x = mouseX;
    float y = mouseY;
    Node hovering_over = node_find(x, y);
    
    if (hovering_over == null) { 
      nodes.add(new Node(x, y));  /* create new node */
    } else {
      nodes.remove(hovering_over);
    }
  }
}


/* find node with x and y */
Node node_find(float x,float y) {
  for(int i = 0; i < nodes.size(); i++) {
    float node_x = nodes.get(i).x;
    float node_y = nodes.get(i).y;
    float r = nodes.get(i).radius;
    
    float dx = abs(x-node_x);
    float dy = abs(y-node_y);
    
    /* check if point (x,y) is in node */
    if (dx > r) continue;
    if (dy >  r) continue;
    if (dx+dy <= r) return nodes.get(i);
  }
  
  /* if no node where point (x,y) lies in, is found return null */
  return null;
}

/* get collision state between two nodes. true = colliding, false = not touching */
boolean node_collision_state_get(Node n1, Node n2) {
  float dx = n2.x - n1.x;
  float dy = n2.y - n1.y;
  float dist = sqrt(dx*dx+dy*dy);
  
  if (dist < n1.radius + n2.radius) return true;  /* return 1 because they collided */
  
  return false; /* return 0 because they didnt touch */
}


/* calculates the physics and let two nodes collide */
void node_collision_collide(Node n1, Node n2){
    float dx = n2.x - n1.x;
    float dy = n2.y - n1.y; 
    float angle = atan2(dy,dx);
    float sin = sin(angle), cos = cos(angle);
    
    float x1 = 0, y1 = 0;
    float x2 = dx*cos+dy*sin;
    float y2 = dy*cos-dx*sin;
    
    /* rotate velocity */
    float velocity_x1 = n1.velocity_x*cos+n1.velocity_y*sin;
    float velocity_y1 = n1.velocity_y*cos-n1.velocity_x*sin;
    float velocity_x2 = n2.velocity_x*cos+n2.velocity_y*sin;
    float velocity_y2 = n2.velocity_y*cos-n2.velocity_x*sin;
    
    /* resolve the 1D case */
    float velocity_x1final = ((n1.mass-n2.mass)*velocity_x1+2*n2.mass*velocity_x2)/(n1.mass+n2.mass);
    float velocity_x2final = ((n2.mass-n1.mass)*velocity_x2+2*n1.mass*velocity_x1)/(n1.mass+n2.mass);
    
    velocity_x1 = velocity_x1final;
    velocity_x2 = velocity_x2final;

    float absV = abs(velocity_x1)+abs(velocity_x2);
    float overlap = (n1.radius+n2.radius)-abs(x1-x2);
    x1 += velocity_x1/absV*overlap;
    x2 += velocity_x2/absV*overlap;

    /* rotate the relative positions back */
    float x1final = x1*cos-y1*sin;
    float y1final = y1*cos+x1*sin;
    float x2final = x2*cos-y2*sin;
    float y2final = y2*cos+x2*sin;
    
    /* finally compute the new absolute positions */
    n2.x = n1.x + x2final;
    n2.y = n1.y + y2final;
    
    n1.x = n1.x + x1final;
    n1.y = n1.y + y1final;
    
    /* rotate vel back */
    n1.velocity_x = velocity_x1*cos-velocity_y1*sin;
    n1.velocity_y = velocity_y1*cos+velocity_x1*sin;
    n2.velocity_x = velocity_x2*cos-velocity_y2*sin;
    n2.velocity_y = velocity_y2*cos+velocity_x2*sin;
}
  
