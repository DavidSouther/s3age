testing.factory "snapshot", ($rootScope)->
	Snap =
		missed: 0
		disabled: true
		image:
			data: ""
		clear: ->
			# Transparent 1-px gif
			Snap.image.data = "data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=="
			Snap.shots = []
			Snap.missed = 0
		snap: (imageData)->
			return if Snap.disabled
			imageData = Snap.stage.debug.image().toDataURL()
			Snap.image.data = imageData
			Snap.shots.push
				frame: Snap.stage?.frame
				image:
					data: imageData
		tick: ->
			return if Snap.disabled
			if Snap.stage.frame is Snap.stage.testPlan?.lastFrame
				message = if Snap.missed > 0 then "test plan failed" else "test plan passed"
				$rootScope.$broadcast message
				return
			if (expected = Snap.stage.testPlan?[Snap.stage.frame])
				if typeof expected is "function"
					expected()
				else
					Snap.snap()
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
