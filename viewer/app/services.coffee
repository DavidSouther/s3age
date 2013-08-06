testing.factory "snapshot", ->
	Snap =
		disabled: true
		image:
			data: ""
		clear: ->
			# Transparent 1-px gif
			Snap.image.data = "data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw=="
			Snap.stage = null
			Snap.shots = []
		take: (imageData)->
			Snap.image.data = imageData
			Snap.shots?.push
				frame: Snap.stage?.frame
				image:
					data: imageData
	Snap.clear()
	Snap

testing.factory "testloader", ($http)->
	Loader =
		get: (list = "tests.json")->
			$http.get(list)
