/*
 @author DavidSouther / http://davidsouther.com/
 @author alteredq / http://alteredqualia.com/
 @author mr.doob / http://mrdoob.com/
*/

(function() {
  var Detector;
  window.Detector = Detector = {
    canvas: !!window.CanvasRenderingContext2D,
    workers: !!window.Worker,
    fileapi: window.File && window.FileReader && window.FileList && window.Blob,
    webgl: (function() {
      var e;
      try {
        return !!window.WebGLRenderingContext && !!document.createElement('canvas').getContext('experimental-webgl');
      } catch (_error) {
        e = _error;
        return false;
      }
    })(),
    WebGLErrorMessage: {
      get: function() {},
      add: function() {}
    },
    errorClass: 'webgl-error-message',
    errorId: 'detector',
    style: {
      color: '#000',
      background: '#fff',
      fontFamily: 'normal 13px/15px monospace',
      textAlign: 'center',
      width: '400px',
      padding: '1.5em',
      margin: '5em auto 0'
    },
    unsupported: {
      browser: "Your browser does not seem to support <a href='http://khronos.org/webgl/wiki/Getting_a_WebGL_Implementation' style='color:#000'>WebGL</a>.<br/>					  Find out how to get it <a href='http://get.webgl.org/' style='color:#000'>here</a>.",
      graphics: "Your graphics card does not seem to support <a href='http://khronos.org/webgl/wiki/Getting_a_WebGL_Implementation' style='color:#000'>WebGL</a>.<br />					   Find out how to get it <a href='http://get.webgl.org/' style='color:#000'>here</a>."
    }
  };
  if (!Detector.webgl) {
    return Detector.WebGLErrorMessage = {
      get: function(clas) {
        var element, error, property, value, _ref;
        if (clas == null) {
          clas = Detector.errorClass;
        }
        element = document.createElement('div');
        element.classList.add(clas);
        _ref = Detector.style;
        for (property in _ref) {
          value = _ref[property];
          element.style[property] = value;
        }
        error = window.WebGLRenderingContext ? "graphics" : "browser";
        element.innerHTML = Detector.unsupported[error];
        return element;
      },
      add: function(parent, id) {
        var element;
        if (parent == null) {
          parent = document.body;
        }
        if (id == null) {
          id = Detector.errorId;
        }
        element = Detector.WebGLErrorMessage.get(id);
        parent.appendChild(element);
        return element;
      }
    };
  }
})();

var S3age;

S3age = (function() {
  /*
  	Prepare a new THREE S3age.
  	Insert the renderer's domElement as a child of the first element returned by selector,
  	or directly under body if no selector is used.
  
  	@param {selector} string css selector to append dom element. Default: "body"
  	@param {autostart} boolean begin running the scene immediately. Othwerise, call S3age::start(). Default: false
  	@param {inspector} boolean expose the scene and camera on the window, so Three.js inspector can find them. Default: false
  */

  function S3age(selector, autostart, inspector) {
    var _this = this;
    if (selector == null) {
      selector = "body";
    }
    if (autostart == null) {
      autostart = true;
    }
    if (inspector == null) {
      inspector = false;
    }
    if (!(typeof Detector !== "undefined" && Detector !== null ? Detector.webgl : void 0)) {
      Detector.WebGLErrorMessage.add();
    }
    this.camera = this.renderer = this.scene = this.controls = this.stats = void 0;
    this.scene = new THREE.Scene();
    this.clock = new THREE.Clock();
    this.running = autostart;
    this.FPS = 100;
    this._container = document.querySelector(selector);
    this.camera = S3age.Camera(this);
    this.renderer = S3age.Renderer(this);
    this._container.appendChild(this.renderer.domElement);
    if (inspector) {
      this.expose();
    }
    window.addEventListener('resize', function() {
      return _this.onResize();
    });
    this.onResize();
    this.clicks();
    this.update();
  }

  /*
  	Play and pause the S3age
  */


  S3age.prototype.start = function() {
    return this.running = true;
  };

  S3age.prototype.stop = function() {
    return this.running = false;
  };

  /*
  	Exposes the s3age to ThreejsInspector
  */


  S3age.prototype.expose = function() {
    window.camera = this.camera;
    window.scene = this.scene;
    return window.renderer = this.renderer;
  };

  /*
  	Resize the s3age to the current container bounds
  */


  S3age.prototype.size = function() {
    this.width = this._container.clientWidth;
    this.height = this._container.clientHeight;
    return this.aspect = this.width / this.height;
  };

  /*
  	Resize handler
  */


  S3age.prototype.onResize = function() {
    this.size();
    this.camera.resize();
    return this.renderer.resize();
  };

  /*
  	Prepare click handlers
  */


  S3age.prototype.clicks = function() {
    this.clicked = function(intersects) {
      var intersect, _base, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = intersects.length; _i < _len; _i++) {
        intersect = intersects[_i];
        _results.push(typeof (_base = intersect.object).onclick === "function" ? _base.onclick(intersect) : void 0);
      }
      return _results;
    };
    return S3age.Click(this._container, this);
  };

  /*
  	The render loop and render clock.
  */


  S3age.prototype.update = function() {
    var child, _i, _len, _ref, _ref1, _ref2, _ref3,
      _this = this;
    if (this.running) {
      if ((_ref = this.stats) != null) {
        _ref.begin();
      }
      if ((_ref1 = this.controls) != null) {
        _ref1.update();
      }
      _ref2 = this.scene.children;
      for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
        child = _ref2[_i];
        if (typeof child.update === "function") {
          child.update(this.clock);
        }
      }
      this.renderer.render();
      if ((_ref3 = this.stats) != null) {
        _ref3.end();
      }
    }
    return setTimeout((function() {
      return requestAnimationFrame(function() {
        return _this.update();
      });
    }), 1000 / this.FPS);
  };

  /*
  	Convert from <U,V> DOM coords to <X, Y, Z> screen coords.
  */


  S3age.prototype.clickPoint = function(u, v) {
    var vector;
    vector = new THREE.Vector3((u / this._container.clientWidth) * 2 - 1, -(v / this._container.clientHeight) * 2 + 1, 0.5);
    return vector;
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
        vector = stage.clickPoint(event.clientX, event.clientY);
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
