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
		# Public params
		@camera = @renderer = @scene = @controls = undefined
		@scene = new THREE.Scene()
		@running = autostart
		@FPS = 60

		container = document.querySelector selector

		# Resize the stage to the current container bounds
		do size = =>
			@width = container.clientWidth
			@height = container.clientHeight
			@aspect = @width / @height

		# Set up the render pipeline
		@camera = S3age.Camera @
		@renderer = S3age.Renderer @
		# attach the render-supplied DOM element
		container.appendChild @renderer.domElement

		# Possibly expose to the global scope
		if inspector
			window.camera = @camera
			window.scene = @scene
			window.renderer = @renderer

		# Set up a window resize handler
		window.addEventListener 'resize', resize = =>
			size()
			@camera.resize()
			@renderer.resize()
		resize()

		# Register a click handler that implicitly calls onclick of any clicked object.
		# That is, any object with an onclick function in the stage's scene graph is
		# "clickable" implicitly.
		@clicked = (intersects)->
			for intersect in intersects
				intersect.object.onclick? intersect
		S3age.Click container,  @

		# The render loop and render clock
		do update = =>
			if @running
				stats?.begin()

				@controls?.update()
				@renderer.render()

				stats?.end()
			setTimeout (->requestAnimationFrame update), 1000 / @FPS

	start: -> @running = yes
	stop: -> @running = no
