testing.directive "testingViewports", testingViewports = ->
	scope:
		test: '=currentTest'
	restrict: 'AE'
	template: "
		<div class='well'>
			<label class='title margin-reset'>Viewport</label>
			<div class='scroll'>
				<div class='center-502'>
					<iframe id='viewer'
						ng-src='../../examples/{{test.path}}'
					></iframe>
				</div>
			</div>
		</div>

		<div class='well'>
			<label class='title margin-reset'>Snapshot</label>
			<div class='scroll'>
				<div class='center-502'>
					<img id='snapshot'
						ng-src='{{Snapshot.image.data}}'
						ng-style='{ \"background-color\": Snapshot.backgroundColor }'
					/>
				</div>
			</div>
		</div>"
	link: ($scope, $elem)->
		$scope.iframe = $elem.find "iframe"
		$scope.iframe.bind "load", ->
			wind = $scope.iframe[0].contentWindow
			$scope.stage = wind.stage
			# Disabled when the image function of the stage's debug is unavailable
			disabled = not ($scope.stage?.debug?.image)
			bgcolor = wind.document.body.style.backgroundColor
			$scope.$apply ->
				snapshot = $scope.Snapshot
				snapshot.backgroundColor = bgcolor
				snapshot.image.data = ""
				snapshot.disabled = disabled

	controller: ($scope, snapshot)->
		$scope.stage = null
		$scope.Snapshot = snapshot
		$scope.$on "trigger snapshot", ->
			return if snapshot.disabled
			snapshot.image.data = $scope.stage.debug.image().toDataURL()
