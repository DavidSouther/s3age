/*
Controls namespace.
*/

S3age.Controls = {};

S3age.Controls.Sphere = function(scene, stage) {
  var DAMPING, ZERO, bind, camera, element, r, spin, unbind, zoom;
  element = (stage != null ? stage._container : void 0) || document;
  bind = function(e, f, t) {
    if (t == null) {
      t = false;
    }
    return element.addEventListener(e, f, t);
  };
  unbind = function(e, f, t) {
    if (t == null) {
      t = false;
    }
    return element.removeEventListener(e, f, t);
  };
  ZERO = new THREE.Vector3(0, 0, 0);
  DAMPING = {
    MOUSE: {
      ZOOM: {
        FOV: 250,
        TRUCK: 7500
      },
      SPIN: {
        UP: 2500,
        LEFT: 15000
      }
    },
    KEY: {
      SPIN: {
        UP: 0.02,
        LEFT: 0.005
      },
      ZOOM: {
        TRUCK: 0.16,
        FOV: 0.48
      }
    }
  };
  zoom = new BoundDamper(35, 70, 65);
  r = new BoundDamper(2, 7.5, 6);
  spin = {
    up: new SigmoidDamper(),
    left: new Damper(0, 0.05)
  };
  /*
  	Mouse wheel handles zooming.
  	Up/Down is truck in out
  	Left/Right is FOV narrow/wide
  */

  (function() {
    var mousewheel;
    mousewheel = function(e) {
      zoom.push(e.wheelDeltaX / DAMPING.MOUSE.ZOOM.FOV);
      return r.push(-e.wheelDeltaY / DAMPING.MOUSE.ZOOM.TRUCK);
    };
    bind("mousewheel", mousewheel);
    return bind("DOMMouseScroll", mousewheel);
  })();
  /*
  	Keyboard controls
  	WASD - Up/Down/Left/Right around center
  	QE - Truck in/out
  */

  (function() {
    return bind("keydown", function(e) {
      switch (e.keyCode) {
        case 87:
          return spin.up.push(-DAMPING.KEY.SPIN.UP);
        case 83:
          return spin.up.push(DAMPING.KEY.SPIN.UP);
        case 65:
          return spin.left.push(-DAMPING.KEY.SPIN.LEFT);
        case 68:
          return spin.left.push(DAMPING.KEY.SPIN.LEFT);
        case 69:
          return zoom.push(DAMPING.KEY.ZOOM.TRUCK);
        case 81:
          return zoom.push(-DAMPING.KEY.ZOOM.TRUCK);
      }
    });
  })();
  camera = stage.camera;
  this.target = ZERO;
  this.update = function() {
    var d, phi, theta, _i, _len, _ref;
    _ref = [spin.left, spin.up, r, zoom];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      d = _ref[_i];
      d.step();
    }
    camera.fov = zoom.position;
    phi = spin.up.position * Math.PI;
    theta = spin.left.position * Math.PI;
    camera.position.fromSpherical(theta, phi, r.position);
    camera.position.add(this.target);
    return camera.lookAt(this.target);
  };
  return this;
};
