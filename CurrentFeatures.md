# Current Features #
The feature list is growing all the time, and we welcome any ideas and suggestions you may have.

## Audio ##
  * **Game Sound Handler**
    * OpenAL based engine for cross-platform support
    * Controls for individual Music and SFX volumes, with seperate Master volume control
    * Dynamically changes volume of all playing sounds when volume settings are changed
    * Allocates a specified number of audio channels, these channels are then used/reused when required
    * Priority based allocation of audio channels for sounds

## Debug ##
  * **Console**
    * Configurable debug console screen
    * Easily assign commands to the console for manipulating your game at runtime
  * **Profiler**
    * Simple to use profiler to find out where all your CPU time is being spent

## Graphics ##
  * **Drivers**
    * DirectX 9 driver in addition to BlitzMax's default OpenGL and DirectX 7 drivers.
  * **Colour Oscillator**
    * Customisable oscillator to smoothly cycle RGBA values
  * **Scale Oscialltor**
    * Customisable oscillator to smoothly scale sprites/text/etc
  * **Graphics Service**
    * Set/Reset graphics modes on the fly from within your game
  * **Projection Matrix**
    * Optionally scale your game screen to fit any resolution display
  * **Sprites**
    * Image and Polygon based sprites
  * **Sprite Animation**
    * Very powerful and extensible sprite animation system, create complex animations from simple building blocks
  * **Screenshots**
    * Take screenshots of your game at any time
  * **Colour Helpers**
    * Helper classes for manipulating RGB and HSV colours and converting between them
  * **Render States**
    * Stack based method for saving/restoring render states

## Input ##
  * **Input Manager**
    * Extensible message based input manager
    * Support for Keyboard, Joystick and Mouse input
    * Any object can subscribe to the MSG\_INPUT message channel and receive input events
    * Virtual Gamepads.  Create as many virtual gamepads as you need, with as many controls as you want for your games.  These controls can be easily programmed/mapped to any of the devices managed by the Input Manager.
  * **Menus**
    * Free form game menus
    * Built-in Graphics menu

## Maths ##
  * **Polygons**
    * Draw/Transform polygons
  * **Polygon Collisions**
    * Collision detection for:
      * Polygon/Polygon
      * Circle/Polygon
      * Line/Polygon
      * Point/Polygon
      * Line/Circle
    * Line Intersection detection
  * **RC4 Encryption**
    * Encrypt data using the RC4 encryption algorithm
  * **Vector2D Class**

## Messages ##
  * **Message Service**
    * Simple and effective method of sending/receiving messages
    * Send custom messages to/from objects
    * Broadcast messages on custom channels
    * Objects can register with channels and receive all messages sent to those channels
    * Used by the Input Manager

## Misc ##
  * **Clone Objects**
    * Reflection based method for deep cloning objects
  * **Logging**
    * Flexible logging with multiple categories of message, built-in support for outputting log messages to files, console and syslog servers. Users can create their own log output methods.
  * **Command Stack**
    * [Command Pattern](http://en.wikipedia.org/wiki/Command_pattern) implementation
    * Makes it easy to add Undo/Redo features to game editors, etc.
  * **Stack**
    * Simple stack class

## Physics ##
  * **Physics Manager**
    * Optionally use the [Chipmunk Physics](http://wiki.slembcke.net/main/published/Chipmunk) library for 2D Physics simulation

## Resources ##
  * **Resource Manager**
    * Manages common game resources such as images, sounds, fonts, etc.
    * Avoids duplication of resources in memory and allows the sharing of resources between objects without resorting to Global variables.
  * **Registry**
    * Store any object in the registry to easily share objects between different parts of your game without a mass of Global variables.

## Scoring ##
  * **Score Service**
    * Manage player scores
    * Support for multipliers
    * Records total playing time (for interesting stats)
  * **High Score Tables**
    * Saveable high score tables
    * Optional RC4 encryption on saved file
    * Configurable amount of entries
    * Saves total played time along with table (for more interesting stats)

## Settings ##
  * **Game Settings**
    * Common game settings are loaded/saved to an INI file
    * Easily add your own settings you wish stored in this way
  * **INI File Handler**
    * Create and Use INI files for storing variables, etc.

## States ##
  * **Game State Manager**
    * Flexible way of organising differnt states (or screens) of your game
    * Cycle through states in the order they were added, or specify the state you wish to run

## Timing ##
  * FPS calculation and configurable display
  * Precision counter for enhanced timing (Win32 only currently)
  * Fixed timestep logic loop with configurable update frequency and render tweening

