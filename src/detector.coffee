###
 @author DavidSouther / http://davidsouther.com/
 @author alteredq / http://alteredqualia.com/
 @author mr.doob / http://mrdoob.com/
###
do ->
	# Expose the detector
	window.Detector = Detector =
		# Check for various APIs
		canvas: !! window.CanvasRenderingContext2D
		workers: !! window.Worker
		fileapi: window.File and window.FileReader and window.FileList and window.Blob
		webgl:
			do ->
				try
					# Easiest way to check if WebGL is available is to try creating a context
					return !! window.WebGLRenderingContext !! document.createElement( 'canvas' ).getContext( 'experimental-webgl' )
				catch e
					return false

		# Assume we will get a context.
		WebGLErrorMessage:
			get: ->
			add: ->

		# User-overridable properties.
		errorClass: 'webgl-error-message'
		errorId: 'detector'
		style:
			color:      '#000'
			background: '#fff'
			fontFamily: 'normal 13px/15px monospace'
			textAlign:  'center'
			width:      '400px'
			padding:    '1.5em'
			margin:     '5em auto 0'
		unsupported:
			# Error messages for difference error stages.
			browser: "Your browser does not seem to support <a href='http://khronos.org/webgl/wiki/Getting_a_WebGL_Implementation' style='color:#000'>WebGL</a>.<br/>
					  Find out how to get it <a href='http://get.webgl.org/' style='color:#000'>here</a>."
			graphics: "Your graphics card does not seem to support <a href='http://khronos.org/webgl/wiki/Getting_a_WebGL_Implementation' style='color:#000'>WebGL</a>.<br />
					   Find out how to get it <a href='http://get.webgl.org/' style='color:#000'>here</a>."

	# If webgl is unabailable, expose the error methods.
	if not Detector.webgl
		Detector.WebGLErrorMessage =
			# Return a dom node with an error message
			get: (clas = Detector.errorClass)->
				element = document.createElement( 'div' )
				element.classList.add clas

				# Add the styles.
				element.style[property] = value for property, value of Detector.style

				# If the context is available on the window, then it must be the graphics card that failed to create a context.
				error = if window.WebGLRenderingContext then "graphics" else "browser"
				element.innerHTML = Detector.unsupported[error]

				element

			# Add an error node to the dom
			add: ( parent = document.body, id = Detector.errorId )->
				element = Detector.WebGLErrorMessage.get(id)
				parent.appendChild( element )
				element

