# S3age

A stage container for THREEjs. Streamlines attaching a scene graph to a webgl context, so developers can `scene.add` after one line.

## Examples

Check out the example branch and open the HTML pages in `src/examples`. For later textured examples, a server will be needed (eg `python -m SimpleHTTPServer`).

### 01 Cube / Blender Factory

Adds a cube, adds a light, and moves the camera. Similar to hitting "Render" with a factory reset in Blender. The minimum possible custom scene.

### 02  Trees

Similar to the [Trackball Controlls](http://threejs.org/examples/misc_controls_trackball.html) example, but drastically cleaned code and green trees. Heavily commented (probably overcommented).

### 03 Forest

Introduction to Scene graph. Organize code by extending Object3D with custom Domain classes. Convulve meshes.

### 04 Physics

Extend Forest classes. Adds physics simulations.

