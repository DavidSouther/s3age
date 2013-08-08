testing.directive "testingViewports", testingViewports = ->
	scope:
		test: '=currentTest'
	restrict: 'AE'
	template: "
		<div class='well flush'>
			<label class='title absolute'>Viewport</label>
			<div class='alert alert-{{message.alert}}' ng-show='message.text'>
				{{message.text}}
			</div>
			<iframe id='viewer'
				ng-src='{{test.path}}'
			></iframe>
		</div>"
	link: ($scope, $elem)->
		$scope.iframe = $elem.find "iframe"
		$scope.iframe.bind "load", ->
			wind = null
			try
				wind = $scope.iframe[0].contentWindow

			if not wind
				$scope.error "Couldn't load #{$scope.test.path} correctly."
				return
			if not wind.stage
				$scope.warn "Couldn't load #{$scope.test.path} with stage."
				return

	controller: ($scope, $timeout)->
		$scope.Alert = (text = "", alert="info")->
			$timeout -> $scope.$apply -> $scope.message = {text, alert}
			$timeout (->$scope.Alert()), 5000
		$scope.error = (error)->
			$scope.Alert error, "danger"
		$scope.warn = (warning)->
			$scope.Alert warning, "warning"
		$scope.Alert()