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

var Stats;

Stats = function() {
  var a, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t;
  l = Date.now();
  m = l;
  g = 0;
  n = Infinity;
  o = 0;
  h = 0;
  p = Infinity;
  q = 0;
  r = 0;
  s = 0;
  f = document.createElement("div");
  f.id = "stats";
  f.addEventListener("mousedown", (function(b) {
    b.preventDefault();
    return t(++s % 2);
  }), !1);
  f.style.cssText = "width:80px;opacity:0.9;cursor:pointer";
  a = document.createElement("div");
  a.id = "fps";
  a.style.cssText = "padding:0 0 3px 3px;text-align:left;background-color:#002";
  f.appendChild(a);
  i = document.createElement("div");
  i.id = "fpsText";
  i.style.cssText = "color:#0ff;font-family:Helvetica,Arial,sans-serif;font-size:9px;font-weight:bold;line-height:15px";
  i.innerHTML = "FPS";
  a.appendChild(i);
  c = document.createElement("div");
  c.id = "fpsGraph";
  c.style.cssText = "position:relative;width:74px;height:30px;background-color:#0ff";
  a.appendChild(c);
  while (74 > c.children.length) {
    j = document.createElement("span");
    j.style.cssText = "width:1px;height:30px;float:left;background-color:#113";
    c.appendChild(j);
  }
  d = document.createElement("div");
  d.id = "ms";
  d.style.cssText = "padding:0 0 3px 3px;text-align:left;background-color:#020;display:none";
  f.appendChild(d);
  k = document.createElement("div");
  k.id = "msText";
  k.style.cssText = "color:#0f0;font-family:Helvetica,Arial,sans-serif;font-size:9px;font-weight:bold;line-height:15px";
  k.innerHTML = "MS";
  d.appendChild(k);
  e = document.createElement("div");
  e.id = "msGraph";
  e.style.cssText = "position:relative;width:74px;height:30px;background-color:#0f0";
  d.appendChild(e);
  while (74 > e.children.length) {
    j = document.createElement("span");
    j.style.cssText = "width:1px;height:30px;float:left;background-color:#131";
    e.appendChild(j);
  }
  t = function(b) {
    s = b;
    switch (s) {
      case 0:
        a.style.display = "block";
        return d.style.display = "none";
      case 1:
        a.style.display = "none";
        return d.style.display = "block";
    }
  };
  return {
    REVISION: 11,
    domElement: f,
    setMode: t,
    begin: function() {
      return l = Date.now();
    },
    end: function() {
      var b;
      b = Date.now();
      g = b - l;
      n = Math.min(n, g);
      o = Math.max(o, g);
      k.textContent = g + " MS (" + n + "-" + o + ")";
      a = Math.min(30, 30 - 30 * (g / 200));
      e.appendChild(e.firstChild).style.height = a + "px";
      r++;
      b > m + 1e3 && (h = Math.round(1e3 * r / (b - m)), p = Math.min(p, h), q = Math.max(q, h), i.textContent = h + " FPS (" + p + "-" + q + ")", a = Math.min(30, 30 - 30 * (h / 100)), c.appendChild(c.firstChild).style.height = a + "px", m = b, r = 0);
      return b;
    },
    update: function() {
      return l = this.end();
    }
  };
};

var S3age;

S3age = (function() {
  /*
  	Prepare a new THREE S3age.
  	Insert the renderer's domElement as a child of the first element returned by selector,
  	or directly under body if no selector is used.
  
  	@param {selector} string css selector to append dom element. Default: "body"
  */

  function S3age(selector, defaults) {
    var _this = this;
    if (selector == null) {
      selector = "body";
    }
    this.defaults = defaults != null ? defaults : {};
    if (!(typeof Detector !== "undefined" && Detector !== null ? Detector.webgl : void 0)) {
      Detector.WebGLErrorMessage.add();
    }
    this["default"](this.defaults);
    this.camera = this.renderer = this.scene = this.controls = this.stats = void 0;
    this.FPS = 100;
    this.frame = 0;
    this.scene = new THREE.Scene();
    this.clock = new S3age.Clock();
    this.camera = S3age.Camera(this, this.defaults.camera);
    this.renderer = S3age.Renderer(this, this.defaults.renderer);
    this.effects(this.defaults.effects);
    if (this.defaults.scene != null) {
      this.dress(this.defaults.scene);
    }
    this.controls = this.defaults.controls;
    this._container = document.querySelector(selector);
    this._container.appendChild(this.renderer.domElement);
    window.addEventListener('resize', function() {
      return _this.onResize();
    });
    this.onResize();
    this.clicks();
    if (defaults.debug) {
      this.debug = S3age.Debug(this, defaults.statistics, defaults.inspector);
      this.testPlan = defaults.testPlan;
    }
    this.update();
    if (this.defaults.autostart) {
      this.start();
    }
  }

  S3age.prototype["default"] = function(defaults) {
    var _base, _base1;
    if (defaults.autostart == null) {
      defaults.autostart = true;
    }
    if (defaults.renderer == null) {
      defaults.renderer = {};
    }
    if (defaults.camera == null) {
      defaults.camera = {};
    }
    if (defaults.effects == null) {
      defaults.effects = [];
    }
    if (defaults.scene == null) {
      defaults.scene = {};
    }
    if ((_base = defaults.scene).lights == null) {
      _base.lights = [];
    }
    if ((_base1 = defaults.scene).children == null) {
      _base1.children = [];
    }
    if (defaults.inspector == null) {
      defaults.inspector = defaults.expose || false;
    }
    if (defaults.statistics == null) {
      defaults.statistics = defaults.stats || true;
    }
    if (defaults.debug == null) {
      defaults.debug = defaults.testing || window.TESTING || false;
    }
    return this;
  };

  S3age.prototype.dress = function(statics) {
    var child, light, _i, _j, _len, _len1, _ref, _ref1, _results;
    if (statics.fog) {
      this.scene.fog = statics.fog;
    }
    _ref = statics.lights;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      light = _ref[_i];
      this.scene.add(light);
    }
    _ref1 = statics.children;
    _results = [];
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      child = _ref1[_j];
      _results.push(this.scene.add(child));
    }
    return _results;
  };

  /*
  	Play and pause the S3age
  */


  S3age.prototype.start = function() {
    var _this = this;
    setTimeout((function() {
      return _this.clock.start();
    }), 0);
    this.running = true;
    return this;
  };

  S3age.prototype.stop = function() {
    this.running = false;
    return this;
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
    var child, pass, _i, _j, _len, _len1, _ref, _ref1;
    this.size();
    this.camera.resize();
    this.renderer.resize();
    _ref = this.scene.children;
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      child = _ref[_i];
      if (typeof child.resize === "function") {
        child.resize(this.width, this.height);
      }
    }
    _ref1 = this.defaults.effects;
    for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
      pass = _ref1[_j];
      if (typeof pass.resize === "function") {
        pass.resize(this.width, this.height);
      }
    }
    return this;
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
    S3age.Click(this._container, this);
    return this;
  };

  /*
  	Prepare an effects loop.
  */


  S3age.prototype.effects = function(passes) {
    var pass, _i, _j, _len, _len1, _results;
    if (!THREE.EffectComposer) {
      if (passes.length) {
        console.warn("Processing pipeline requested, but no EffectComposer available.");
      }
      return;
    }
    passes.unshift(new THREE.RenderPass(this.scene, this.camera));
    passes.push(new THREE.ShaderPass(THREE.CopyShader));
    for (_i = 0, _len = passes.length; _i < _len; _i++) {
      pass = passes[_i];
      pass.renderToScreen = false;
    }
    passes[passes.length - 1].renderToScreen = true;
    this.composer = new THREE.EffectComposer(this.renderer);
    _results = [];
    for (_j = 0, _len1 = passes.length; _j < _len1; _j++) {
      pass = passes[_j];
      _results.push(this.composer.addPass(pass));
    }
    return _results;
  };

  /*
  	Render the scene as it currently is.
  */


  S3age.prototype.render = function() {
    (THREE.EffectComposer ? this.composer : this.renderer).render();
    return typeof this.debug === "function" ? this.debug() : void 0;
  };

  /*
  	The render loop and render clock.
  */


  S3age.prototype.update = function() {
    var child, _i, _len, _ref, _ref1, _ref2, _ref3,
      _this = this;
    if (this.running) {
      this.frame++;
      if ((_ref = this.stats) != null) {
        _ref.begin();
      }
      if ((_ref1 = this.controls) != null) {
        _ref1.update(this.clock);
      }
      try {
        _ref2 = this.scene.children;
        for (_i = 0, _len = _ref2.length; _i < _len; _i++) {
          child = _ref2[_i];
          if (typeof child.update === "function") {
            child.update(this.clock);
          }
        }
      } catch (_error) {}
      this.render();
      if ((_ref3 = this.stats) != null) {
        _ref3.end();
      }
    }
    setTimeout((function() {
      return requestAnimationFrame(function() {
        return _this.update();
      });
    }), 1000 / this.FPS);
    return this;
  };

  /*
  	Return a racaster pointing from the camera into the scene, given a <u, v> coordinate
  	on the plane of the canvas.
  */


  S3age.prototype.raycast = (function() {
    var projector;
    projector = new THREE.Projector;
    return function(u, v) {
      var raycaster, vector;
      vector = new THREE.Vector3((u / this._container.clientWidth) * 2 - 1, -(v / this._container.clientHeight) * 2 + 1, 0.5);
      projector.unprojectVector(vector, this.camera);
      vector.sub(this.camera.position).normalize();
      raycaster = new THREE.Raycaster(this.camera.position, vector);
      return raycaster;
    };
  })();

  return S3age;

})();

S3age.Debug = function(s3age, stats, expose) {
  var debug;
  if (stats == null) {
    stats = false;
  }
  if (expose == null) {
    expose = false;
  }
  (function() {
    /*
    		Create Stats div, attach to container.
    */

    var inspector, showstats;
    showstats = function() {
      s3age.stats = new Stats();
      s3age.stats.domElement.style.position = 'absolute';
      s3age.stats.domElement.style.top = '0px';
      return s3age._container.appendChild(s3age.stats.domElement);
    };
    /*
    		Exposes the s3age to ThreejsInspector
    */

    inspector = function() {
      window.camera = s3age.camera;
      window.scene = s3age.scene;
      return window.renderer = s3age.renderer;
    };
    if (stats) {
      showstats();
    }
    if (expose) {
      return inspector();
    }
  })();
  debug = void 0;
  (function() {
    var canvas, twoctx;
    canvas = document.createElement("canvas");
    twoctx = canvas.getContext("2d");
    debug = function() {
      canvas.width = s3age.width;
      canvas.height = s3age.height;
      return twoctx.drawImage(s3age.renderer.domElement, 0, 0);
    };
    return debug.image = function() {
      return canvas;
    };
  })();
  return debug;
};

S3age.Clock = (function() {
  function Clock(performance, autoStart) {
    var old, running, started, tick,
      _this = this;
    if (performance == null) {
      performance = Date.now;
    }
    if (autoStart == null) {
      autoStart = false;
    }
    started = old = this.elapsed = this.delta = 0;
    running = !!autoStart;
    tick = function() {
      if (running) {
        old = _this.elapsed;
        _this.now = performance();
        _this.elapsed = _this.now - started;
        return _this.delta = _this.elapsed - old;
      }
    };
    this.start = function() {
      running = true;
      started = performance();
      tick();
      return this;
    };
    if (running) {
      this.start();
    }
  }

  return Clock;

})();

S3age.Camera = function(stage, defaults) {
  var camera, far, fov, near;
  if (defaults == null) {
    defaults = {};
  }
  fov = defaults.fov || 45;
  near = defaults.near || 1;
  far = defaults.far || 1000;
  camera = new THREE.PerspectiveCamera(fov, stage.aspect, near, far);
  if (defaults.position instanceof THREE.Vector3) {
    camera.position = defaults.position;
  }
  if (defaults.position instanceof Array) {
    camera.position.fromArray(defaults.position);
  }
  if (defaults.lookAt) {
    camera.lookAt((new THREE.Vector3).fromArray(defaults.lookAt));
  }
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

S3age.Renderer = function(stage, defaults) {
  var renderer, _render;
  if (defaults == null) {
    defaults = {};
  }
  defaults.antialias = defaults.antialias || true;
  renderer = new THREE.WebGLRenderer(defaults);
  ["autoClear", "autoClearColor", "autoClearDepth", "autoClearStencil", "autoScaleCubemaps", "autoUpdateObjects", "gammaInput", "gammaOutput", "maxMorphNormals", "maxMorphTargets", "physicallyBasedShading", "renderPluginsPost", "renderPluginsPre", "shadowMapAutoUpdate", "shadowMapCascade", "shadowMapCullFace", "shadowMapCullFace", "shadowMapDebug", "shadowMapEnabled", "shadowMapPlugin", "shadowMapType", "sortObjects"].forEach(function(property) {
    if (defaults[property] != null) {
      return renderer[property] = defaults[property];
    }
  });
  ["setClearColor", "setDepthTest", "setDepthWrite", "setBlending", "setClearColorHex"].forEach(function(method) {
    var args;
    if (defaults[method] != null) {
      args = defaults[method];
      if (!args.length) {
        args = [args];
      }
      return renderer[method].apply(renderer, args);
    }
  });
  renderer.resize = function() {
    return renderer.setSize(stage.width, stage.height);
  };
  _render = renderer.render;
  renderer.render = function(scene, camera, buffer, clear) {
    if (scene == null) {
      scene = stage.scene;
    }
    if (camera == null) {
      camera = stage.camera;
    }
    if (buffer == null) {
      buffer = void 0;
    }
    if (clear == null) {
      clear = void 0;
    }
    return _render.apply(renderer, [scene, camera, buffer, clear]);
  };
  return renderer;
};

S3age.Click = function(element, stage) {
  var down, event, events, handler, _results;
  down = 0;
  events = {
    mousedown: function() {
      return down = Date.now();
    },
    mouseup: function(event) {
      var intersects, raycaster;
      event.preventDefault();
      if ((Date.now() - down) > S3age.Click.CLICK_TIMEOUT) {
        return;
      }
      down = 0;
      raycaster = stage.raycast(event.clientX, event.clientY);
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

S3age.Click.CLICK_TIMEOUT = 100;

S3age.Loader = function(loader, path) {
  var _this = this;
  THREE.Object3D.apply(this, [].slice.call(arguments, 2));
  return (new loader()).load(path, function(geometry, materials) {
    return _this.add(new THREE.Mesh(geometry, new THREE.MeshFaceMaterial(materials)));
  });
};

S3age.Loader.prototype = Object.create(THREE.Object3D.prototype);
