# S3age

A stage container for THREEjs. Streamlines attaching a scene graph to a webgl context, so developers can `scene.add` after one line.

## Examples

Check out the example branch and open the HTML pages in `src/examples`. For later textured examples, a server will be needed (eg `python -m SimpleHTTPServer`).

### [01 Cube / Blender Factory](http://s3age.souther.co/src/examples/01_blender_factory.html)

Adds a cube, adds a light, and moves the camera. Similar to hitting "Render" with a factory reset in Blender. The minimum possible custom scene.

https://github.com/DavidSouther/s3age/blob/examples/src/examples/01_blender_factory.html

### [02  Trees](http://s3age.souther.co/src/examples/02_trees.html)

Similar to the [Trackball Controlls](http://threejs.org/examples/misc_controls_trackball.html) example, but drastically cleaned code and green trees. Heavily commented (probably overcommented).

https://github.com/DavidSouther/s3age/blob/examples/src/examples/02_trees.html

### [03 Forest](http://s3age.souther.co/src/examples/03_forest.html)

Introduction to Scene graph. Organize code by extending Object3D with custom Domain classes. Convulve meshes.

https://github.com/DavidSouther/s3age/blob/examples/src/examples/forest.js

### [04 Physics](http://s3age.souther.co/src/examples/04_forest_spinning.html)

Extend Forest classes. Adds physics simulations.

https://github.com/DavidSouther/s3age/blob/examples/src/examples/forest_physics.js

## [Practical Three.js](https://docs.google.com/presentation/d/16Xt-lu9mWL4te1fi9MXA--nqTzdGYTAVXG5OlVcU5Dw/view)

Presentation and overview of WebGL, Three.js, and these examples, originally prepared for an internal New York Times technology group.
