S3age.Controls.Sphere = (scene, stage)->
	element = stage?._container || document
	# element = document
	bind = (e, f, t = false) -> element.addEventListener e, f, t
	unbind = (e, f, t = false) -> element.removeEventListener e, f, t

	ZERO = new THREE.Vector3 0, 0, 0
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
				when 87 then spin.up.push -DAMPING.KEY.SPIN.UP
				when 83 then spin.up.push  DAMPING.KEY.SPIN.UP
				when 65 then spin.left.push -DAMPING.KEY.SPIN.LEFT
				when 68 then spin.left.push  DAMPING.KEY.SPIN.LEFT
				# QE
				when 69 then zoom.push  DAMPING.KEY.ZOOM.TRUCK
				when 81 then zoom.push -DAMPING.KEY.ZOOM.TRUCK

	camera = stage.camera
	@target = ZERO
	@update = ->
		d.step() for d in [spin.left, spin.up, r, zoom]
		camera.fov = zoom.position
		phi = spin.up.position * Math.PI
		theta = spin.left.position * Math.PI
		camera.position.fromSpherical theta, phi, r.position
		camera.position.add @.target
		camera.lookAt @target
	@
