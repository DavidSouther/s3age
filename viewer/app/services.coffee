testing.factory "snapshot", ->
	Snap =
		disabled: true
		URL: ""

testing.factory "testloader", ($http)->
	Loader =
		get: (list = "tests.json")->
			$http.get(list)
