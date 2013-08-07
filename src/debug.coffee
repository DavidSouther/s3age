S3age.Debug = (s3age, stats = false, expose = false)->
	do ->
		###
		Create Stats div, attach to container.
		###
		showstats = ->
			s3age.stats = new Stats();
			s3age.stats.domElement.style.position = 'absolute';
			s3age.stats.domElement.style.top = '0px';
			s3age._container.appendChild s3age.stats.domElement

		###
		Exposes the s3age to ThreejsInspector
		###
		inspector = ->
			window.camera = s3age.camera
			window.scene = s3age.scene
			window.renderer = s3age.renderer

		showstats() if stats
		inspector() if expose

	debug = undefined
	do ->
		canvas = document.createElement "canvas"
		twoctx = canvas.getContext "2d"

		debug = ->
			canvas.width = s3age.width
			canvas.height = s3age.height
			twoctx.drawImage s3age.renderer.domElement, 0, 0

		debug.image = ->
			canvas

	debug
