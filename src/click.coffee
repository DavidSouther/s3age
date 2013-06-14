S3age.Click = (element, stage)->
	down = 0

	events =
		mousedown: ->
			down = Date.now()

		mouseup: (event)->
			event.preventDefault()
			# Use our own timer for what "Click" means.
			return if (Date.now() - down) > S3age.Click.CLICK_TIMEOUT
			down = 0

			# Get the raycaster from the scene
			vector = stage.raycast(event.clientX, event.clientY)

			# Find the list of intersections
			intersects = raycaster.intersectObjects stage.scene.children, yes

			# Let the stage handle the events
			stage.clicked intersects

	for event, handler of events
		element.addEventListener event, handler, false

S3age.Click.CLICK_TIMEOUT = 100
