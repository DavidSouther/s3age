S3age.Camera = (stage, defaults = {})->
	
	fov  = defaults.fov  or 45
	near = defaults.near or 1
	far  = defaults.far  or 1000

	camera = new THREE.PerspectiveCamera fov, stage.aspect, near, far

	camera.position = defaults.position if defaults.position instanceof THREE.Vector3
	camera.position.fromArray defaults.position if defaults.position instanceof Array

	camera.resize = ->
		# On resize, check the stage's updated aspect ratio, since the stage abstracts the screen.
		camera.aspect = stage.aspect
		camera.updateProjectionMatrix()

	# Each of these properties should trigger a matrix update
	['fov', 'near', 'far'].forEach (prop)->
		value = camera[prop]
		get = ->
			value
		set = (it)->
			value = it
			camera.updateProjectionMatrix()
			@
		Object.defineProperty camera, prop, {get, set}, true

	camera
