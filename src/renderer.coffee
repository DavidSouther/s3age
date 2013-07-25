S3age.Renderer = (stage, defaults = {})->
	defaults.antialias = defaults.antialias || true
	renderer = new THREE.WebGLRenderer defaults

	# set any property values
	[
		"autoClear"
		"autoClearColor"
		"autoClearDepth"
		"autoClearStencil"
		"autoScaleCubemaps"
		"autoUpdateObjects"
		"gammaInput"
		"gammaOutput"
		"maxMorphNormals"
		"maxMorphTargets"
		"physicallyBasedShading"
		"renderPluginsPost"
		"renderPluginsPre"
		"shadowMapAutoUpdate"
		"shadowMapCascade"
		"shadowMapCullFace"
		"shadowMapCullFace"
		"shadowMapDebug"
		"shadowMapEnabled"
		"shadowMapPlugin"
		"shadowMapType"
		"sortObjects"
	].forEach (property)->
		if defaults[property]?
			renderer[property] = defaults[property]

	# Call any setter methods
	[
		"setClearColor"
		"setDepthTest"
		"setDepthWrite"
		"setBlending"
		"setClearColorHex"
	].forEach (method)->
		if defaults[method]?
			args = defaults[method]
			args = [args] unless args.length
			renderer[method].apply renderer, args

	renderer.resize = ->
		# start the renderer
		renderer.setSize stage.width, stage.height

	_render = renderer.render
	renderer.render = (scene = stage.scene, camera = stage.camera, buffer = undefined, clear = undefined)->
		_render.apply renderer, [scene, camera, buffer, clear]

	renderer
