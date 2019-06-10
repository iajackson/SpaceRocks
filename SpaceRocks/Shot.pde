/**************************************************************
 * Class: Shot
 * Desc: Contains shot stats and methods for displaying and moving a shot
 ***************************************************************/
class Shot {  
  PVector location;   // Shot location and velocity
  PVector velocity;
  int timer;          // Timer for life of shot

  /**************************************************************
   * Function: Shot()
   * Parameters: None
   * Returns: Void
   * Desc: Default constructor. Creates shot at ship location with ship heading,
           inheriting the ship velocity
   ***************************************************************/
  Shot() {
    location = player.location.copy();
    velocity = new PVector(cos(player.heading), sin(player.heading));
    velocity.setMag(SHOT_VELOCITY);
    velocity.add(player.velocity);
    timer = SHOT_EXPIRES;
  }

  /**************************************************************
   * Function: display()
   * Parameters: None
   * Returns: Void
   * Desc: Draws the shot at location
   ***************************************************************/
  void display() {
    stroke(#950000);
    strokeWeight(0.2 * SHOT_SIZE);
    fill(#FF0000);
    circle(location.x, location.y, SHOT_SIZE);
  }

  /**************************************************************
   * Function: move()
   * Parameters: None
   * Returns: Void
   * Desc: Updates the shot position and decrements the timer
   ***************************************************************/
  void move() {
    location.add(velocity);
    timer--;
  }
}