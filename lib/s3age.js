var S3age;

S3age = (function() {
  function S3age(selector) {
    var container, resize, size, update,
      _this = this;
    this.camera = this.renderer = this.scene = void 0;
    this.scene = new THREE.Scene();
    this.running = false;
    this.FPS = 60;
    container = document.querySelector(selector);
    (size = function() {
      _this.width = container.clientWidth;
      _this.height = container.clientHeight;
      return _this.aspect = _this.width / _this.height;
    })();
    this.camera = S3age.Camera(this);
    this.renderer = S3age.Renderer(this);
    container.appendChild(this.renderer.domElement);
    window.addEventListener('resize', resize = function() {
      size();
      _this.camera.resize();
      return _this.renderer.resize();
    });
    resize();
    this.clicked = function(intersects) {
      var intersect, _base, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = intersects.length; _i < _len; _i++) {
        intersect = intersects[_i];
        _results.push(typeof (_base = intersect.object).onclick === "function" ? _base.onclick(intersect) : void 0);
      }
      return _results;
    };
    S3age.Click(container, this);
    (update = function() {
      var _ref;
      if (_this.running) {
        if (typeof stats !== "undefined" && stats !== null) {
          stats.begin();
        }
        if ((_ref = _this.controls) != null) {
          _ref.update();
        }
        _this.renderer.render();
        if (typeof stats !== "undefined" && stats !== null) {
          stats.end();
        }
      }
      return setTimeout((function() {
        return requestAnimationFrame(update);
      }), 1000 / _this.FPS);
    })();
  }

  S3age.prototype.start = function() {
    return this.running = true;
  };

  S3age.prototype.stop = function() {
    return this.running = false;
  };

  return S3age;

})();

S3age.Camera = function(stage, fov, near, far) {
  var camera;
  if (fov == null) {
    fov = 45;
  }
  if (near == null) {
    near = 1;
  }
  if (far == null) {
    far = 1000;
  }
  camera = new THREE.PerspectiveCamera(fov, stage.aspect, near, far);
  camera.resize = function() {
    camera.aspect = stage.aspect;
    return camera.updateProjectionMatrix();
  };
  ['fov', 'near', 'far'].forEach(function(prop) {
    var get, set, value;
    value = camera[prop];
    get = function() {
      return value;
    };
    set = function(it) {
      value = it;
      camera.updateProjectionMatrix();
      return this;
    };
    return Object.defineProperty(camera, prop, {
      get: get,
      set: set
    }, true);
  });
  return camera;
};

S3age.Renderer = function(stage) {
  var renderer, _render;
  renderer = new THREE.WebGLRenderer();
  renderer.resize = function() {
    return renderer.setSize(stage.width, stage.height);
  };
  _render = renderer.render;
  renderer.render = function() {
    return _render.call(renderer, stage.scene, stage.camera);
  };
  return renderer;
};

(function() {
  var projector;
  projector = new THREE.Projector();
  S3age.Click = function(element, stage) {
    var down, event, events, handler, _results;
    down = 0;
    events = {
      mousedown: function() {
        return down = Date.now();
      },
      mouseup: function(event) {
        var intersects, raycaster, vector;
        event.preventDefault();
        if ((Date.now() - down) > S3age.Click.CLICK_TIMEOUT) {
          return;
        }
        down = 0;
        vector = vec((event.clientX / window.innerWidth) * 2 - 1, -(event.clientY / window.innerHeight) * 2 + 1, 0.5);
        projector.unprojectVector(vector, stage.camera);
        vector.sub(stage.camera.position).normalize();
        raycaster = new THREE.Raycaster(stage.camera.position, vector);
        intersects = raycaster.intersectObjects(stage.scene.children, true);
        return stage.clicked(intersects);
      }
    };
    _results = [];
    for (event in events) {
      handler = events[event];
      _results.push(element.addEventListener(event, handler, false));
    }
    return _results;
  };
  return S3age.Click.CLICK_TIMEOUT = 100;
})();
