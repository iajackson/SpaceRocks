/**************************************************************
 * Class: Asteroid
 * Desc: Contains asteroid stats and methods for displaying and moving an 
         asteroid
 ***************************************************************/
class Asteroid extends Drifter {

  /**************************************************************
   * Function: Asteroid()
   * Parameters: None
   * Returns: Void
   * Desc: Default constructor
   ***************************************************************/
  Asteroid() {
    // Load asteroid image
    img = loadImage("asteroidImage.png");

    // Pick random radius
    radius = ASTEROID_RADII[int(random(ASTEROID_RADII.length))];

    // Pick starting position on one of the 4 edges
    int asteroidSpawn = int(random(4));
    float tempX = 0, tempY = 0;
    switch (asteroidSpawn) {
      case 0:
        tempX = random(0, 0.1 * width);
        tempY = random(height);
        break;
      case 1:
        tempX = random(0.9 * width, width);
        tempY = random(height);
        break;
      case 2:
        tempX = random(width);
        tempY = random(0, 0.1 * height);
        break;
      case 3:
        tempX = random(width);
        tempY = random(0.9 * height, height);
        break;
    }

    // Set starting position and speed
    location = new PVector(tempX, tempY);
    velocity = new PVector(random(-ASTEROID_MAX_SPEED, ASTEROID_MAX_SPEED),
                           random(-ASTEROID_MAX_SPEED, ASTEROID_MAX_SPEED));
  }

  /**************************************************************
   * Function: Asteroid()
   * Parameters: None
   * Returns: Void
   * Desc: Overloaded constructor for creating child asteroids
   ***************************************************************/
  Asteroid(Asteroid parent) {
    // Load asteroid image
    img = loadImage("asteroidImage.png");

    radius = parent.radius / 2;
    location = parent.location.copy();
    velocity = new PVector(random(-ASTEROID_MAX_SPEED, ASTEROID_MAX_SPEED),
                           random(-ASTEROID_MAX_SPEED, ASTEROID_MAX_SPEED));
  }

  /**************************************************************
   * Function: display()
   * Parameters: None
   * Returns: Void
   * Desc: Draws the asteroid at location
   ***************************************************************/
  void display() {
    imageMode(CENTER);
    image(img, location.x, location.y, radius * 2, radius * 2);
  }
}