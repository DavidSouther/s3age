###
S3age wraps the underlying WebGLRenderer with a variety of conveniences.
Automatically handles dom node resizing and a wide variety of defaults.

@param stage {S3age} to get dimensions from.
@param defaults {Object} with default values for WebGLRenderer, either
	using properties or setters.
###
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
			args = [args]  unless args.length

			switch args.length # Performance Reasons
				when 1 then renderer[method](args[0])
				when 2 then renderer[method](args[0], args[1])
				when 3 then renderer[method](args[0], args[1], args[2])
				when 4 then renderer[method](args[0], args[1], args[2], args[3])

	#TODO expose rest of Renderer methods

	renderer.resize = ->
		renderer.setSize stage.width, stage.height

	_render = renderer.render
	renderer.render = (scene = stage.scene, camera = stage.camera, buffer = undefined, clear = undefined)->
		_render.apply renderer, [scene, camera, buffer, clear]

	renderer
