class S3age
	###
	Prepare a new THREE S3age.
	Insert the renderer's domElement as a child of the first element returned by selector,
	or directly under body if no selector is used.

	@param selector {string} css selector to append dom element. Default: "body"
	@param defaults {Object} containing variety of default parameters
		renderer: {Object} options to be passed to the S3age.renderer
		camera: {Object} options to be passed to the S3age.camera
		scene: {Object} with the initial scene description
			children: {Array} of THREE.Object3D to add to the scene
			lights: {Array} of THREE.*Light to add to the scene
		controls: {Object} hook for attaching scene controls. If it has an update function, the
			update function will get called every frame with the clock. If the passed controls
			is a function, it will be treated as a constructor, and passed the scene and the
			dom element instantiation. The returned instance should have an `update()` function.
		effects: {Array} of THREE EffectsComposer passes. Requires EffectsComposer to be loaded.
			Forces the S3age into effects mode, which always runs the given effects between an
			initial RenderPass and final CopyShader that renders to screen.
		inspector: {boolean} whether to expose the S3age for Three.js inspector, default: false
		statistics: {boolean} to create and attach statistics graph, default: true
		debug: {boolean} to start in debug mode, capturing every frame to a stored back buffer.
			Default: false || window.TESTING
		autostart: {boolean} whether to immediately begin render loop. When false, the S3age will
			not begin rendering until calling `s3age.start()`. Default: true
	###
	constructor: (selector = "body", @defaults = {})->
		# Return immediately if rendering is unavailable.
		if not Detector?.webgl then return Detector.WebGLErrorMessage.add()

		# Set default params
		@default @defaults

		# Public params
		@camera = @renderer = @scene = @controls = @stats = undefined
		@FPS = 100
		@frame = 0

		@scene = new THREE.Scene()
		@clock = new S3age.Clock()
		# Set up the render pipeline
		@camera = S3age.Camera @, @defaults.camera
		@renderer = S3age.Renderer @, @defaults.renderer
		@effects @defaults.effects # Todo move to a helper composer class.
		@dress @defaults.scene if @defaults.scene?

		# TODO This needs further consideration for alt library interops. 
		@controls = @defaults.controls
		if typeof @controls is "function" then @controls = new @controls @scene, @_container

		# attach the render-supplied DOM element
		@_container = document.querySelector selector
		@_container.appendChild @renderer.domElement
		@_container.focus()

		# Set up a window resize handler
		window.addEventListener 'resize', => @onResize()
		@onResize()
		@clicks()

		if @defaults.debug
			@debug = S3age.Debug @, defaults.statistics, defaults.inspector
			@testPlan = defaults.testPlan

		@update()
		@start() if @defaults.autostart

	default: (defaults)->
		defaults.autostart ?= true

		defaults.renderer ?= {}
		defaults.camera ?= {}
		defaults.effects ?= []

		defaults.scene ?= {}
		defaults.scene.lights ?= []
		defaults.scene.children ?= []

		defaults.inspector ?= defaults.expose || false
		defaults.statistics ?= defaults.stats  || true
		defaults.debug ?= defaults.testing || window.TESTING || false

		@

	dress: (statics)->
		@scene.fog = statics.fog if statics.fog
		@scene.add light for light in statics.lights
		@scene.add child for child in statics.children

	###
	Play and pause the S3age
	###
	start: ->
		# Start the clock on the next tick, so the first frame doesn't get poluted with more initialization.
		setTimeout (=>@clock.start()), 0 
		@running = yes
		@
	stop: ->
		@running = no
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
		child.resize? @width, @height for child in @scene.children
		pass.resize? @width, @height for pass in @defaults.effects
		@

	###
	Prepare click handlers. The click handler finds any object that would intersect the click
	ray, and if it has an `onclick` event, calls that event with the click information.
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
	Prepare an effects loop. The page will need to have included the effects composer
	scritps, and the RenderPass and ShaderPass scripts.

	@param passes {array} instantiated Effects passes, which will be run in order.
		Implicitly, the first step is a RenderPass, which gets the scene and the camera.
		The last step is a CopyShader ShaderPass, moving the final image to the screen.
		Any other passes will be run with the output from the previous pass, in order.
	###
	effects: (passes)->
		if not THREE.EffectComposer
			if passes.length
				console.warn "Processing pipeline requested, but no EffectComposer available."
			return
		passes.unshift new THREE.RenderPass @scene, @camera
		passes.push new THREE.ShaderPass THREE.CopyShader
		pass.renderToScreen = false for pass in passes
		passes[passes.length-1].renderToScreen = true
		@composer = new THREE.EffectComposer @renderer
		@composer.addPass pass for pass in passes

	###
	Render the scene as it currently is.
	###
	render: ->
		(if THREE.EffectComposer then @composer else @renderer).render()
		# Save the framebuffer
		@debug?()

	###
	The render loop and render clock.
	###
	update: ->
		if @running
			@frame++
			@stats?.begin()

			@controls?.update(@clock)
			try child.update?(@clock) for child in @scene.children
			@render()

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
