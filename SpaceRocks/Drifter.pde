/**************************************************************
 * Class: Drifter
 * Desc: Abstract class used for objects drifting around the screen
 ***************************************************************/
abstract class Drifter {

    // Location and velocity of object
    PVector location;
    PVector velocity;

    // Size of object
    int radius;

    // Image for displaying object
    PImage img;

    /**************************************************************
     * Function: display()
     * Parameters: None
     * Returns: Void
     * Desc: Displays the object on screen
     ***************************************************************/
    abstract void display();

    /**************************************************************
     * Function: move()
     * Parameters: None
     * Returns: Void
     * Desc: Updates the object position
     ***************************************************************/
    void move() {
        location.add(velocity);
        // Check the horizontal position against the bounds of the sketch
        if (location.x < -radius) {
        location.x = width + radius;
        } else if (location.x > (width + radius)) {
        location.x = -radius;
        }
        
        // Check the vertical position against the bounds of the sketch
        if (location.y < -radius) {
        location.y = height + radius;
        } else if (location.y > (height + radius)) {
        location.y = -radius;
        }
    }
}