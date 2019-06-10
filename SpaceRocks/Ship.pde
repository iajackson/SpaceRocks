/**************************************************************
 * Class: Ship
 * Desc: Contains ship stats and methods for displaying and moving a ship
 ***************************************************************/
class Ship {
  PVector location;        // Ship location, velocity, acceleration and heading 
  PVector velocity;
  PVector acceleration;
  float heading;
  boolean destroyed;           // Ship destroyed status

  PShape ship;             // Shapes for ship and thrusters
  PShape forwardThrusters;
  PShape reverseThrusters;

  /**************************************************************
   * Function: Ship()
   * Parameters: None
   * Returns: Void
   * Desc: Default constructor. Creates ship at centre of screen
   ***************************************************************/
  Ship() {
    heading = radians(270);
    location = new PVector(width / 2, height / 2);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
    destroyed = false;
    ship = loadShape("ship.svg");
    forwardThrusters = loadShape("forwardThrusters.svg");
    reverseThrusters = loadShape("reverseThrusters.svg");
  }

  /**************************************************************
   * Function: display()
   * Parameters: None
   * Returns: Void
   * Desc: Draws the ship object at location and heading using matrix
           transformations
   ***************************************************************/
  void display() {
    pushMatrix();   // Save matrix state prior to drawing ship

    translate(location.x, location.y);    // Matrix transformations
    rotate(heading);

    // Forward thruster
    if (shipUp) {
      shape(forwardThrusters);
    }
    // Reverse thrusters
    if (shipDown) {
      shape(reverseThrusters);
    }
    // Ship body
    shape(ship);

    popMatrix();  // Revert matrix state after drawing ship
  }

  /**************************************************************
   * Function: move()
   * Parameters: None
   * Returns: Void
   * Desc: Updates the ship position depending on what keys are pressed
   ***************************************************************/
  void move() {
    // Fire forward or reverse thrusters
    if (shipUp) {
      acceleration = new PVector(cos(heading), sin(heading));
    } else if (shipDown) {
      acceleration = new PVector(-cos(heading), -sin(heading));
    } else {
      acceleration.setMag(0);
    }

    // Change ship heading
    if (shipRight) {
      heading += radians(SHIP_TURN_SPEED);
    }
    if (shipLeft) {
      heading -= radians(SHIP_TURN_SPEED);
    }

    // Update ship movement parameters
    acceleration.limit(SHIP_MAX_ACCELERATION);
    velocity.add(acceleration);
    velocity.limit(SHIP_MAX_SPEED);
    location.add(velocity);

    // If the ship has left the window update it's location
    if (location.x > width) {
      location.x = 0;
    }
    if (location.x < 0) {
      location.x = width;
    }
    if (location.y > height) {
      location.y = 0;
    }
    if (location.y < 0) {
      location.y = height;
    }
  }
}