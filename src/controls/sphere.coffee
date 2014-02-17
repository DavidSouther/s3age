ZERO = {position: new THREE.Vector3(0, 0, 0)}
S3age.Controls.Sphere = (stage, @target = ZERO)->
	element = stage._container

	bind = (e, f, t = false) -> document.addEventListener e, f, t
	unbind = (e, f, t = false) -> document.removeEventListener e, f, t

	DAMPING =
		MOUSE:
			ZOOM:
				FOV: 250
				TRUCK: 7500
			SPIN:
				UP: 2500
				LEFT: 15000
		KEY:
			SPIN:
				UP: 0.02
				LEFT: 0.005
			ZOOM:
				TRUCK: 0.16
				FOV: 0.48

	zoom = new BoundDamper 35, 70, 65
	r = new BoundDamper 2, 7.5, 6
	spin =
		up: new SigmoidDamper()
		left: new Damper 0, 0.05

	###
	Mouse wheel handles zooming.
	Up/Down is truck in out
	Left/Right is FOV narrow/wide
	###
	do ->
		mousewheel = (e)->
			zoom.push e.wheelDeltaX / DAMPING.MOUSE.ZOOM.FOV
			r.push -e.wheelDeltaY / DAMPING.MOUSE.ZOOM.TRUCK

		bind "mousewheel", mousewheel
		bind "DOMMouseScroll", mousewheel

	###
	Keyboard controls
	WASD - Up/Down/Left/Right around center
	QE - Truck in/out
	###
	do ->
		bind "keydown", (e)->
			switch e.keyCode
				#WSAD
				when 38, 87 then spin.up.push -DAMPING.KEY.SPIN.UP
				when 40, 83 then spin.up.push  DAMPING.KEY.SPIN.UP
				when 37, 65 then spin.left.push  DAMPING.KEY.SPIN.LEFT
				when 39, 68 then spin.left.push -DAMPING.KEY.SPIN.LEFT
				# QE
				when 69 then zoom.push  DAMPING.KEY.ZOOM.TRUCK
				when 81 then zoom.push -DAMPING.KEY.ZOOM.TRUCK

	camera = stage.camera
	frame = 0
	@update = =>
		d.step() for d in [spin.left, spin.up, r, zoom]
		# camera.fov = zoom.position
		phi = spin.up.position * Math.PI
		theta = spin.left.position * Math.PI
		boundingRadius = @target.boundingSphere?.radius || 1
		camera.position.fromSpherical theta, phi, r.position * boundingRadius
		camera.position.add @target.position
		camera.lookAt @target.position

		diff = camera.position.clone().sub(@target.position)

		mod = frame++ % (60 * 10)
		if mod is 60 or mod is 61
			console.log camera.rotation, camera.rotation.length(), camera.position, @target.position
	@
