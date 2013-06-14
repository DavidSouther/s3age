class S3age
	###
	Prepare a new THREE S3age.
	Insert the renderer's domElement as a child of the first element returned by selector,
	or directly under body if no selector is used.

	@param {selector} string css selector to append dom element. Default: "body"
	@param {autostart} boolean begin running the scene immediately. Othwerise, call S3age::start(). Default: false
	@param {inspector} boolean expose the scene and camera on the window, so Three.js inspector can find them. Default: false
	###
	constructor: (selector = "body", autostart = true, inspector = false)->
		# Return immediately if rendering is unavailable.
		if not Detector?.webgl then Detector.WebGLErrorMessage.add()

		# Public params
		@camera = @renderer = @scene = @controls = @stats = undefined
		@scene = new THREE.Scene()
		@clock = new THREE.Clock()
		@running = autostart
		@FPS = 100

		@_container = document.querySelector selector

		# Set up the render pipeline
		@camera = S3age.Camera @
		@renderer = S3age.Renderer @

		# attach the render-supplied DOM element
		@_container.appendChild @renderer.domElement

		# Possibly expose to the global scope
		if inspector then @expose()

		# Set up a window resize handler
		window.addEventListener 'resize', => @onResize()
		@onResize()

		@clicks()
		@update()

	###
	Play and pause the S3age
	###
	start: -> @running = yes
	stop: -> @running = no

	###
	Exposes the s3age to ThreejsInspector
	###
	expose: ->
		window.camera = @camera
		window.scene = @scene
		window.renderer = @renderer

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

	###
	The render loop and render clock.
	###
	update: ->
		if @running
			@stats?.begin()

			@controls?.update()
			child.update?(@clock) for child in @scene.children
			@renderer.render()

			@stats?.end()
		setTimeout (=>requestAnimationFrame =>@update()), 1000 / @FPS

	###
	Convert from <U,V> DOM coords to <X, Y, Z> screen coords.
	###
	clickPoint: (u, v)->
		vector = new THREE.Vector3(
			( u / @_container.clientWidth ) * 2 - 1,
			- ( v / @_container.clientHeight ) * 2 + 1,
			0.5
		)
		vector