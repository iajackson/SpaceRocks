/**************************************************************
 * File: SpaceRocks.pde
 * Group: Ian Jackson
 * Date: 09/06/2019
 * Desc: Space Rocks is a space themed multidirectional shooter arcade game.
 * Usage: Open and run a3.pde using the Processing IDE
 * Credits: Based on COSC101 Assignment 3 by Group 16
              Ian Jackson, Jeremy McDonall
            Artwork by Kenney Vleugels (www.kenney.nl) from Open Game Art
              https://opengameart.org/content/space-shooter-redux
              https://opengameart.org/content/space-shooter-extension-250
            Background music by joshuaempyre from freesound.org
              https://freesound.org/s/251461/
            Shot sound effect by Mattix from freesound.org
              https://freesound.org/s/414888/
            Asteroid explosion sound effect by Prof.Mudkip from freesound.org
              https://freesound.org/s/386862/
            Ship explosion sound effect by Mattix from freesound.org
              https://freesound.org/s/441497/
 **************************************************************/

//TODO: update asteroid radii implementation
//TODO: make asteroids spawn around edges of screen using equation
//TODO: add random powerups
//TODO: add player lives
//TODO: add high score system
import processing.sound.*;      // Required for music and sound effects

Ship player;                      // The player ship
ArrayList<Asteroid> asteroids;    // The list of asteroids
ArrayList<Shot> shots;            // The list of shots
boolean shipUp, shipDown, shipLeft, shipRight; // Ship direction flags
int score = 0;                    // Total score
int lastShot;                     // Time of last shot
int lastExplosion;                // Time of last explosion
float[] explosionLocation;        // Location of explosion
float explosionSize;              // Size of explosion

// Variable used to control what state the game is in
// 0 - Menu
// 1 - Gameplay
// 2 - Gameover
int gameState;

PImage background, explosion;     // Images used for background and explosions

// Sounds used for music and sound effects
SoundFile backgroundMusic, shotFired, asteroidExplosion, shipExplode;

final int SHIP_TURN_SPEED = 5;           // Ship turn speed
final float SHIP_MAX_ACCELERATION = 0.2; // Maximum ship acceleration
final int SHIP_MAX_SPEED = 6;            // Maximum ship speed

final int ASTEROID_NB = 10;               // Number of new asteroids to create
final int[] ASTEROID_RADII = { 16, 24, 32, 48 }; // Possible asteroid sizes
final int ASTEROID_MAX_SPEED = 2;        // Max asteroid speed

final int SHOT_SIZE = 10;         // Diameter of shots
final int SHOT_DELAY = 100;       // The delay(ms) between shots
final int SHOT_VELOCITY = 10;     // Speed of shots
final int SHOT_EXPIRES = 100;     // Number of frames the shot lasts

final int SCORE_X = 5;            // Score text position and size
final int SCORE_Y = 20;
final int SCORE_SIZE = 20;
final int GAMEOVER_X = 275;       // Game over text position and size
final int GAMEOVER_Y = 400;
final int GAMEOVER_SIZE = 40;

final int EXPLOSION_DURATION = 100; // Time(ms) explosion image stays onscreen

final int MAX_CHILD_ASTEROIDS = 3;  // Maximum number of child asteroids

final color WHITE = #FFFFFF;      // Colour constants
final color RED = #FF0000;

/**************************************************************
 * Function: settings()
 * Parameters: None
 * Returns: Void
 * Desc: Sets window dimensions
 ***************************************************************/
void settings() {
  final int WINDOW_WIDTH = 800;
  final int WINDOW_HEIGHT = 800;
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
}

/**************************************************************
 * Function: setup()
 * Parameters: None
 * Returns: Void
 * Desc: Initialises variables and loads assets
 ***************************************************************/
void setup() {
  // Initialise variables
  player = new Ship();
  asteroids = new ArrayList<Asteroid>();
  shots = new ArrayList<Shot>();
  shipUp = shipDown = shipRight = shipLeft = false;
  lastShot = -SHOT_DELAY;
  lastExplosion = -EXPLOSION_DURATION;
  explosionLocation = new float[2];

  // Load images
  background = loadImage("background.png");
  explosion = loadImage("explosion.png");

  // Load sound files
  backgroundMusic = new SoundFile(this, "backgroundMusic.wav");
  shotFired = new SoundFile(this, "shotFired.wav");
  asteroidExplosion = new SoundFile(this, "asteroidExplosion.wav");
  shipExplode = new SoundFile(this, "shipExplode.wav");

  // Set game to start at the main menu
  gameState = 0;
  // Initialise asteroids
  createAsteroids();
  // Start background music
  backgroundMusic.loop();
}

/**************************************************************
 * Function: draw()
 * Parameters: None
 * Returns: Void
 * Desc: Updates variables and draws assets
 ***************************************************************/
void draw() {
  switch(gameState) {
    case 0:   // Main Menu
      background(background);
      fill(WHITE);
      textSize(40);
      text("SPACE ROCKS", width / 2, height / 2);
      break;
    case 1:   // Gameplay
      background(background);
      // Spawn new asteroids if all are destroyed
      if (asteroids.size() == 0) {
        createAsteroids();
      }
      // Draw the asteroids regardless of if the player is alive
      drawAsteroids();
      // If the player is alive, continue the game
      if (!player.destroyed) {
        drawShots();
        player.move();
        player.display();
        collisionDetection();
      } else {
        gameState = 2;
      }
      // Draw the explosion and score regardless of if the player is alive
      drawExplosions();
      drawScore();
      break;
    case 2:   // Game Over
      background(background);
      // Draw the asteroids regardless of if the player is alive
      drawAsteroids();
      // Draw the game over text
      fill(RED);
      textSize(GAMEOVER_SIZE);
      text("GAME OVER!", GAMEOVER_X, GAMEOVER_Y);
      // Draw the explosion and score regardless of if the player is alive
      drawExplosions();
      drawScore();
      break;
  }
      
}

/**************************************************************
 * Function: createAsteroids()
 * Parameters: None
 * Returns: Void
 * Desc: Creates a new set of asteroids
 ***************************************************************/
void createAsteroids() {
  for (int i = 0; i < ASTEROID_NB; i++) {
    asteroids.add(new Asteroid());
  }
}

/**************************************************************
 * Function: drawScore()
 * Parameters: None
 * Returns: Void
 * Desc: Draws the score on screen
 ***************************************************************/
void drawScore() {
  fill(WHITE);
  textSize(SCORE_SIZE);
  text("Score: " + score, SCORE_X, SCORE_Y);
}

/**************************************************************
 * Function: drawExplosions()
 * Parameters: None
 * Returns: Void
 * Desc: Draws the explosions on screen
 ***************************************************************/
void drawExplosions() {
  if (millis() - lastExplosion < EXPLOSION_DURATION) {
    image(explosion, explosionLocation[0], explosionLocation[1], 
          explosionSize, explosionSize);
  }
}

/**************************************************************
 * Function: keyPressed()
 * Parameters: None
 * Returns: Void
 * Desc: Updates ship heading based on key being pressed. 
         Fires a shot if spacebar pressed
 ***************************************************************/
void keyPressed() {
  // Move ship
  if (key == CODED) {
    if (keyCode == UP) {
      shipUp = true;
    }
    if (keyCode == DOWN) {
      shipDown = true;
    } 
    if (keyCode == RIGHT) {
      shipRight = true;
    }
    if (keyCode == LEFT) {
      shipLeft = true;
    }
  }
  // Start a new game if on the main menu or end game screen and S is pressed
  if ((key == 's' || key == 'S') && (gameState == 0 || gameState == 2)) {
    gameState = 1;
    score = 0;
    player = new Ship();
    asteroids = new ArrayList<Asteroid>();
    shots = new ArrayList<Shot>();
    createAsteroids();
  }
  // Fire a shot if enough time has passed since the last shot
  if (key == ' ' && !player.destroyed && (millis() - lastShot > SHOT_DELAY)) {
    shotFired.play();
    shots.add(new Shot());
    lastShot = millis();
  }
}

/**************************************************************
 * Function: keyReleased()
 * Parameters: None
 * Returns: Void
 * Desc: Updates ship heading based on key being released. 
 ***************************************************************/
void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) {
      shipUp = false;
    }
    if (keyCode == DOWN) {
      shipDown = false;
    } 
    if (keyCode == RIGHT) {
      shipRight = false;
    }
    if (keyCode == LEFT) {
      shipLeft = false;
    }
  }
}

/**************************************************************
 * Function: drawShots()
 * Parameters: None
 * Returns: Void
 * Desc: Displays and moves shots. Removes expired shots
 ***************************************************************/
void drawShots() {
  // Iterate through ArrayList of shots
  for(int i = 0; i < shots.size(); i++) {
    // Draw each shot
    shots.get(i).display();
    // Update each shot location
    shots.get(i).move();
    // If shot timer hits zero, remove the shot
    if (shots.get(i).timer <= 0) {
      shots.remove(i);
    }
  }
}

/**************************************************************
 * Function: drawAsteroids()
 * Parameters: None
 * Returns: Void
 * Desc: Draws asteroids and updates locations
 ***************************************************************/
void drawAsteroids() {
  for (int i = 0; i < asteroids.size(); i++) {
    // Compute the new asteroid position
    asteroids.get(i).move();
    // And display it
    asteroids.get(i).display();
  }
}

/**************************************************************
 * Function: collisionDetection()
 * Parameters: None
 * Returns: Void
 * Desc: Checks for collisions between shots/asteroids and asteroids/ship
 ***************************************************************/
void collisionDetection() {
  // Check if any shots have collided with asteroids
  for(int i = 0; i < shots.size(); i++) {
    for (int j = 0; j < asteroids.size(); j++) {
      // If a shot hits an asteroid
      if ((abs(shots.get(i).location.x - asteroids.get(j).location.x) 
              < (asteroids.get(j).radius + SHOT_SIZE / 2))
          && (abs(shots.get(i).location.y - asteroids.get(j).location.y) 
              < (asteroids.get(j).radius + SHOT_SIZE / 2))) {
        asteroidExplosion.play();
        // Increase the score and save explosion position, size and time
        score++;
        if (asteroids.get(j).radius > ASTEROID_RADII[0]) {
          for (int k=0; k < random(MAX_CHILD_ASTEROIDS); k++) {
            asteroids.add(new Asteroid(asteroids.get(j)));
          }
        }
        explosionLocation[0] = asteroids.get(j).location.x;
        explosionLocation[1] = asteroids.get(j).location.y;
        explosionSize = asteroids.get(j).radius * 2;
        lastExplosion = millis();
        // Then remove the shot and asteroid
        shots.remove(i);
        asteroids.remove(j);
        // Then break out of the asteroid for loop to prevent checking further
        // asteroids against the now non-existant shot
        break;
      }
    }
  } 

  // Check if any asteroids have collided with the ship
  for (int i = 0; i < asteroids.size(); i++) {
    if ((abs(player.location.x - asteroids.get(i).location.x) 
            < (asteroids.get(i).radius + player.ship.width / 2)) 
        && (abs(player.location.y - asteroids.get(i).location.y) 
            < (asteroids.get(i).radius + player.ship.width / 2))) {
      shipExplode.play();
      // Save explosion position, size and time
      explosionLocation[0] = player.location.x;
      explosionLocation[1] = player.location.y;
      explosionSize = player.ship.width;
      lastExplosion = millis();
      // Then destroy the ship
      player.destroyed = true;
    }
  }
}