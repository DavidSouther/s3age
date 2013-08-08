testing.controller "testing", ($scope, testloader, $timeout, $location)->
	flat = {}
	ordered = []
	order = (tests)->
		# A bunch of underscoreing to move the tree structure into easy-to-use flat lists
		recur = (tests)->
			flat[test.path] = test for name, test of tests.tests
			paths = (test.path for name, test of tests.tests)
			ordered = ordered.concat _(paths).sort()
			groups = _(tests.children).chain().keys().sort().value()
			recur tests.children[group] for group in groups
		recur tests

	$scope.Test = Test =
		tests:
			tests: {}
			children: {}
		current:
			name: ''
			path: ''

		find:
			test: (path = "")->
				# Remove the posible leading /, sometimes added by the $location service
				path = path.replace /^\//, ""
				flat[path] ||
					name: "unknown"
					path: ""

		move: (i = 1)->
			index = ordered.indexOf(Test.current.path)
			if index + i < 0 then index += ordered.length
			next = ordered[(index + i) % ordered.length]
			next = Test.find.test next
			$location.path next.path

		previous: ->
			Test.move -1
		next: ->
			return Test.first() if Test.current.path is ''
			Test.move()
		first: ->
			$location.path Test.find.test ordered[0]

		set: (p, f)->
			Test.current.pass = p
			Test.current.fail = f
			Test.next()
		pass: ->
			Test.set true, false
		fail: ->
			Test.set false, true

	$scope.$watch (->$location.path()), (->load())
	load = ->
		# May or may not be triggered during the lifecycle.
		$timeout -> $scope.$apply ->
			Test.current = Test.find.test $location.path()

	testloader.get("tests_s3age.json")
	.success (data)->
		$scope.tests = data
		order $scope.tests if $scope.tests
		load()

