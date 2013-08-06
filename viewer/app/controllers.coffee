testing.controller "testing", ($scope, testloader, $timeout, $location)->
	ordered = []
	order = (tests)->
		recur = (tests)->
			paths = (test.path for name, test of tests.tests)
			ordered = ordered.concat _(paths).sort()
			groups = _(tests.children).chain().keys().sort().value()
			recur tests.children[group] for group in groups
		recur tests

	Test = $scope.Test =
		tests:
			tests: {}
			children: {}
		current:
			name: ''
			path: ''

		find:
			test: (path)->
				# Remove the posible ./ or /./ when looking up tests
				path = path.replace /^\/?\.\//, ""
				path = path.split "/"
				test = path.pop()
				base = $scope.tests
				try
					while part = path.shift()
						base = base.children[part]
					base.tests[test]
				catch
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

	load = ->
		$timeout -> $scope.$apply ->
			Test.current = Test.find.test $location.path()
			$scope.$broadcast "test loaded"

	testloader.get("tests_s3age.json")
	.success (data)->
		$scope.tests = data
		order $scope.tests if $scope.tests
		load()

	$scope.location = $location
	$scope.$watch "location.path()", load

	$scope.$on "take snapshot", ->
		$scope.$broadcast "trigger snapshot"

testing.controller "menu", ($scope, $http)->

testing.controller "controls", ($scope, snapshot)->
	$scope.Snapshot = snapshot
	$scope.snap = ->
		$scope.$emit "take snapshot"
