testing.factory "testloader", ($http)->
	Loader =
		get: (list = "tests.json")->
			$http.get(list)
