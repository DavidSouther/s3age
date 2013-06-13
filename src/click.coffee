do ->
	projector = new THREE.Projector()

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

				# Get the projection vector for the raycast
				# Move from window coordinates to scene coordinates (TODO: move to stage class)
				vector = new THREE.Vector3( ( event.clientX / window.innerWidth ) * 2 - 1, - ( event.clientY / window.innerHeight ) * 2 + 1, 0.5 )
				projector.unprojectVector( vector, stage.camera )
				# Then point it away from the camera
				vector.sub( stage.camera.position ).normalize()

				# The ray starts at the camera position and points towards the click point on the viewing plane
				raycaster = new THREE.Raycaster stage.camera.position, vector

				# Find the list of intersections
				intersects = raycaster.intersectObjects stage.scene.children, yes

				# Let the stage handle the events
				stage.clicked intersects

		for event, handler of events
			element.addEventListener event, handler, false

	S3age.Click.CLICK_TIMEOUT = 100
