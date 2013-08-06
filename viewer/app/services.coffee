testing.factory "snapshot", ->
	Snap =
		disabled: true
		image:
			data: ""

testing.factory "testloader", ($http)->
	Loader =
		get: (list = "tests.json")->
			$http.get(list)
