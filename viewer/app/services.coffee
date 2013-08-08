testing.factory "snapshot", ($rootScope)->
	difference = do ->
		image = [
			document.createElement("img"),
			document.createElement("img")
		]
		image[0].height = image[0].width = image[1].height = image[1].width = 500
		canvas = [
			document.createElement("canvas")
			document.createElement("canvas")
		]
		canvas[0].height = canvas[0].width = canvas[1].height = canvas[1].width = 500
		context = [
			canvas[0].getContext("2d"),
			canvas[1].getContext("2d")
		]
		(A, B)->
			context[0].clearRect 0, 0, 500, 500
			image[0].src = A
			image[1].src = B
			context[0].drawImage image[0], 0, 0
			context[1].drawImage image[1], 0, 0
			context[0].blendOnto context[1], 'difference'
			canvas[1].toDataURL()

	Snap =
		autoAdvance: true
		missed: 0
		disabled: true
		image:
			data: ""
		clear: ->
			# Transparent 1-px gif
			Snap.image.data = Snap.image.reference = Snap.image.delta = "data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=="
			Snap.shots = []
			Snap.missed = 0
		snap: (reference)->
			return if Snap.disabled
			imageData = Snap.stage.debug.image().toDataURL()
			Snap.image =
				frame: Snap.stage?.frame
				data: imageData
				reference: reference
				delta: difference imageData, reference
			Snap.shots.push {image: Snap.image}

		tick: ->
			return if Snap.disabled
			if Snap.stage.frame is Snap.stage.testPlan?.lastFrame and Snap.autoAdvance
				message = if Snap.missed > 0 then "test plan failed" else "test plan passed"
				$rootScope.$broadcast message
				return
			if (expected = Snap.stage.testPlan?[Snap.stage.frame])
				if typeof expected is "function"
					expected()
				else
					Snap.snap(expected)
					if expected isnt Snap.image.data
						Snap.missed++

	Object.defineProperty Snap, 'testPlan',
		get: ->
			plan = {}
			plan[test.frame] = test.image.data for test in Snap.shots
			plan

	Object.defineProperty Snap, 'stage', do ->
		_stage = null
		get: -> _stage
		set: (stage)->
			this.clear()
			this.disabled = not stage?.debug?.image
			_stage = stage

	Snap.clear()
	Snap

testing.factory "testloader", ($http)->
	Loader =
		get: (list = "tests.json")->
			$http.get(list)
