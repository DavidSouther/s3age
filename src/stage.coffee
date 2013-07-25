class S3age
	###
	Prepare a new THREE S3age.
	Insert the renderer's domElement as a child of the first element returned by selector,
	or directly under body if no selector is used.

	@param {selector} string css selector to append dom element. Default: "body"
	@param {autostart} boolean begin running the scene immediately. Othwerise, call S3age::start(). Default: false
	@param {inspector} boolean expose the scene and camera on the window, so Three.js inspector can find them. Default: false
	###
	constructor: (selector = "body", defaults = {})->
		# Return immediately if rendering is unavailable.
		if not Detector?.webgl then Detector.WebGLErrorMessage.add()

		# Set default params
		@default defaults

		# Public params
		@camera = @renderer = @scene = @controls = @stats = undefined
		@scene = new THREE.Scene()
		@clock = new S3age.Clock()
		@FPS = 100

		@_container = document.querySelector selector

		# Set up the render pipeline
		@camera = S3age.Camera @, defaults.camera
		@renderer = S3age.Renderer @, defaults.renderer
		@dress defaults.scene if defaults.scene?
		@controls = defaults.controls

		# attach the render-supplied DOM element
		@_container.appendChild @renderer.domElement

		# Possibly expose to the global scope
		@expose() if defaults.inspector or defaults.exposed
		@showstats() if defaults.statistics

		# Set up a window resize handler
		window.addEventListener 'resize', => @onResize()
		@onResize()

		@clicks()
		@start() if defaults.autostart
		@update()

	default: (defaults)->
		defaults.autostart ?= true
		defaults.inspector ?= false
		defaults.statistics ?= defaults.stats  || true
		defaults.renderer ?= {}
		defaults.camera ?= {}
		@

	dress: (statics)->
		@scene.fog = statics.fog if statics.fog
		@scene.add light for light in statics.lights
		@scene.add child for child in statics.children

	###
	Play and pause the S3age
	###
	start: ->
		setTimeout (=>@clock.start()), 0 # Start on the next tick, so the first frame doesn't get poluted with more initialization.
		@running = yes
		@
	stop: ->
		@running = no
		@

	###
	Exposes the s3age to ThreejsInspector
	###
	expose: ->
		window.camera = @camera
		window.scene = @scene
		window.renderer = @renderer
		@

	###
	Create Stats div, attach to container.
	###
	showstats: ->
		@stats = new Stats();
		@stats.domElement.style.position = 'absolute';
		@stats.domElement.style.top = '0px';
		@_container.appendChild @stats.domElement
		@

	###
	Resize the s3age to the current container bounds
	###
	size: ->
		@width = @_container.clientWidth
		@height = @_container.clientHeight
		@aspect = @width / @height

	###
	Resize handler
	###
	onResize: ->
		@size()
		@camera.resize()
		@renderer.resize()
		@

	###
	Prepare click handlers
	###
	clicks: ->
		# Register a click handler that implicitly calls onclick of any clicked object.
		# That is, any object with an onclick function in the stage's scene graph is
		# "clickable" implicitly.
		@clicked = (intersects)->
			for intersect in intersects
				intersect.object.onclick? intersect
		S3age.Click @_container,  @
		@

	###
	The render loop and render clock.
	###
	update: ->
		if @running
			@stats?.begin()

			@clock.tick()
			@controls?.update(@clock)
			try child.update?(@clock) for child in @scene.children
			@renderer.render()

			@stats?.end()
		setTimeout (=>requestAnimationFrame =>@update()), 1000 / @FPS
		@

	###
	Return a racaster pointing from the camera into the scene, given a <u, v> coordinate
	on the plane of the canvas.
	###
	raycast: do ->
		projector = new THREE.Projector
		(u, v)->
			# Move from window coordinates to scene coordinates (TODO: move to stage class)
			vector = new THREE.Vector3(
				( u / @_container.clientWidth ) * 2 - 1,
				- ( v / @_container.clientHeight ) * 2 + 1,
				0.5
			)
			projector.unprojectVector( vector, @camera )
			# Then point it away from the camera
			vector.sub( @camera.position ).normalize()
			raycaster = new THREE.Raycaster @camera.position, vector
			raycaster
