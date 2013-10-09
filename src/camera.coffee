###
Extension around a Three perspective camera. Rebinds underlying properties to
automatically update the camera's projection matrix whenever set.

@param stage {S3age} to get pertinant sizing information at runtime.
@param defaults {Object} with default values:
	fov: {float} field of view, defaults to 45
	near: {float} near clipping plane, defaults to 1
	far: {float} far clipping plane, defaults to 1000
	position: {Vector3|Array[3]} starting position, defaults to <0, 0, 0>
	lookAt: {Array[3]} initial camera target, defaults along [0, 0, 1]
###
S3age.Camera = (stage, defaults = {})->
	
	fov  = defaults.fov  or 45
	near = defaults.near or 1
	far  = defaults.far  or 1000

	camera = new THREE.PerspectiveCamera fov, stage.aspect, near, far

	camera.position = defaults.position if defaults.position instanceof THREE.Vector3
	camera.position.fromArray defaults.position if defaults.position instanceof Array
	camera.lookAt((new THREE.Vector3).fromArray(defaults.lookAt)) if defaults.lookAt

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
