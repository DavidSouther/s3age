S3age.Renderer = (stage, defaults)->
	renderer = new THREE.WebGLRenderer defaults
	renderer.resize = ->
		# start the renderer
		renderer.setSize stage.width, stage.height

	_render = renderer.render
	renderer.render = ->
		_render.call renderer, stage.scene, stage.camera

	renderer
