class S3age
	constructor: (selector)->
		# Public params
		@camera = @renderer = @scene = undefined
		@scene = new THREE.Scene()
		@running = no
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
