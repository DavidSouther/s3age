testing.factory "snapshot", ->
	Snap =
		disabled: true
		image:
			data: ""
		clear: ->
			# Transparent 1-px gif
			Snap.image.data = "data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=="
			Snap.shots = []
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
			if expected = Snap.stage.testPlan?[Snap.stage.frame]
				Snap.snap()
				console.log expected
				console.log Snap.image.data
				match = if expected is Snap.image.data then "correct" else "mismatched"
				console.log "Images at #{Snap.stage.frame} are #{match}."

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
