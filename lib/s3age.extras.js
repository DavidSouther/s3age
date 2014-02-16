S3age.Extras = {};

S3age.Extras.Globe = function(radius) {
  this.radius = radius != null ? radius : 1;
  THREE.Object3D.apply(this, [].slice.call(arguments, 1));
  THREE.Object3D.prototype.add.call(this, this.tilted = new THREE.Object3D());
  this.rotation.z = Math.toRad(23.4);
  this.speed = {
    rotation: 0.001
  };
  this.markers = new THREE.Object3D();
  this.markers.updateable = [];
  this.add(this.markers);
  return this;
};

S3age.Extras.Globe.prototype = Object.create(THREE.Object3D.prototype);

S3age.Extras.Globe.prototype.update = function(clock) {
  var m, _i, _len, _ref, _results;
  _ref = this.markers.updateable;
  _results = [];
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    m = _ref[_i];
    _results.push(typeof m.update === "function" ? m.update(clock) : void 0);
  }
  return _results;
};

S3age.Extras.Globe.prototype.addMarker = function(marker, lat, lon) {
  var base, center;
  lat = Math.toRad(lon || marker.lat);
  lon = Math.toRad(lon || marker.lon);
  base = new THREE.Object3D();
  base.rotation.y = lon;
  base.rotation.z = lat;
  this.markers.add(base);
  center = new THREE.Object3D();
  center.position.x = this.radius * 1.001;
  center.rotation.y = Math.PI / 2;
  base.add(center);
  center.add(marker);
  this.markers.updateable.push(marker);
  return this;
};

S3age.Extras.Globe.prototype.add = function(object) {
  return this.tilted.add(object);
};

/*
Given three prameters in spherical coordinates, set this vector's
rectangular coordinates.

@param theta {float} angle in radians from local meridian.
@param phi {float} angle in radians between 0 and Pi, angle from
	north in the spherical coordinates.
@param r {float} distance from origin of sphere.
*/

THREE.Vector3.prototype.fromSpherical = function(theta, phi, r) {
  var cp, ct, sp, st;
  st = Math.sin(theta);
  ct = Math.cos(theta);
  sp = Math.sin(phi);
  cp = Math.cos(phi);
  this.x = r * sp * ct;
  this.z = r * sp * st;
  this.y = r * cp;
  return this;
};

/*
Geometric physical damper, along a single axis.
*/


window.Damper = function(position, friction) {
  this.position = position != null ? position : 0;
  this.friction = friction != null ? friction : 0.1;
  this.velocity = 0;
  return this;
};

Damper.prototype.step = function() {
  this.position += this.velocity;
  this.velocity *= 1 - this.friction;
  return this;
};

Damper.prototype.push = function(acceleration) {
  this.velocity += acceleration;
  return this;
};

/*
Geometric physical damper, along a boud axis.
*/


window.BoundDamper = function(min, max, position, friction) {
  this.min = min != null ? min : -1;
  this.max = max != null ? max : 1;
  this.position = position != null ? position : 0;
  this.friction = friction != null ? friction : 0.1;
  Damper.call(this);
  this.delta = (this.max - this.min) * 2;
  return this;
};

BoundDamper.prototype = Object.create(Damper.prototype);

BoundDamper.prototype.step = function() {
  Damper.prototype.step.call(this);
  this.position = this.position.clamp(this.min, this.max);
  return this;
};

BoundDamper.prototype.push = function(acceleration) {
  Damper.prototype.push.call(this, acceleration);
  this.velocity = this.velocity.clamp(-this.friction * this.delta, this.friction * this.delta);
  return this;
};

/*
Sigmoid damper.
*/


window.SigmoidDamper = function(friction) {
  this.friction = friction != null ? friction : 0.1;
  this.point = 0;
  BoundDamper.call(this, -6, 6);
  Object.defineProperty(this, 'position', {
    set: function(val) {
      return this.point = val;
    },
    get: function() {
      return Math.sigmoid(this.point);
    }
  });
  return this;
};

SigmoidDamper.prototype = Object.create(BoundDamper.prototype);

SigmoidDamper.prototype.step = function() {
  this.point += this.velocity;
  this.point = this.point.clamp(this.min, this.max);
  this.velocity *= 1 - this.friction;
  this.velocity = this.velocity.clamp(-this.friction * this.delta, this.friction * this.delta);
  return this;
};

/*
Extend the Number prototype to return this number, clamped between a and b.
*/


Number.prototype.clamp = Number.prototype.clamp || function(a, b) {
  return Math.min(b, Math.max(this, a));
};

/*
Return the value of evaluating the sigmoid function at x.
*/


Math.sigmoid = Math.sigmoid || function(x) {
  return 1 / (1 + Math.exp(-x));
};

/*
Project between linear number line segments.
*/


Math.lerp = function(v, a, b, x, y) {
  if (v === a) {
    return x;
  } else {
    return (v - a) * (y - x) / (b - a) + x;
  }
};

Math.toRad = function(deg) {
  return deg * Math.PI / 180;
};
