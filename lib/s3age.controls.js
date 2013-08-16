S3age.Controls = {};

S3age.Controls.Sphere = function(scene, stage) {
  var DAMPING, ZERO, camera, r, spin, zoom;
  ZERO = new THREE.Vector3(0, 0, 0);
  DAMPING = {
    ZOOM: {
      FOV: 250,
      TRUCK: 7500
    },
    SPIN: {
      UP: 2500,
      LEFT: 15000
    }
  };
  zoom = new BoundDamper(35, 70);
  r = new BoundDamper(2, 7.5);
  r.position = 3;
  spin = {
    up: new SigmoidDamper(),
    left: new Damper()
  };
  stage.renderer.domElement.addEventListener("mousewheel", function(e) {
    if (e.altKey === true) {
      zoom.push(e.wheelDeltaX / DAMPING.ZOOM.FOV);
      return r.push(-e.wheelDeltaY / DAMPING.ZOOM.TRUCK);
    } else {
      spin.up.push(-e.wheelDeltaY / DAMPING.SPIN.UP);
      return spin.left.push(e.wheelDeltaX / DAMPING.SPIN.LEFT);
    }
  });
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
