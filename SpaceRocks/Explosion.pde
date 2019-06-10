/**************************************************************
 * Class: Explosion
 * Desc: Contains explosion stats and methods for displaying explosion
 ***************************************************************/
class Explosion {
    PVector location;   // Location of explosion
    int timer;          // Timer used for period explosion is displayed
    int radius;         // Size of the explosion

    /**************************************************************
    * Function: Explosion()
    * Parameters: PVector(loc) - The location of the explosion
                  int(rad) - The size of the explosion
    * Returns: Void
    * Desc: Default constructor
    ***************************************************************/
    Explosion(PVector loc, int rad) {
        location = loc.copy();
        radius = rad;
        timer = 10;
    }

    /**************************************************************
    * Function: display()
    * Parameters: None
    * Returns: Void
    * Desc: Draws the explosion at location
    ***************************************************************/
    void display() {
        image(explosion, location.x, location.y, radius * 2, radius * 2);
        timer--;
    }
}