testing.directive "testingViewports", testingViewports = ->
	scope:
		test: '=currentTest'
	restrict: 'AE'
	template: "
		<div class='well flush'>
			<label class='title absolute'>Viewport</label>
			<div class='scroll'>
				<div class='center-502'>
					<iframe id='viewer'
						ng-src='../../examples/{{test.path}}'
					></iframe>
				</div>
			</div>
		</div>

		<div class='well flush'>
			<label class='title absolute'>Snapshot</label>
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
			if not wind.stage?
				console.error "Couldn't load #{$scope.test.path} correctly."
				return
			$scope.stage = wind.stage
			# Disabled when the image function of the stage's debug is unavailable
			disabled = not ($scope.stage?.debug?.image)
			bgcolor = wind.document.body.style.backgroundColor
			$scope.$apply ->
				$scope.Snapshot.clear()
				$scope.Snapshot.backgroundColor = bgcolor
				$scope.Snapshot.disabled = disabled
			watcher = new wind.THREE.Object3D()
			watcher.update = -> $scope.$apply ->
				$scope.Snapshot.stage = $scope.stage
			$scope.stage.scene.add watcher

	controller: ($scope, snapshot)->
		$scope.stage = null
		$scope.Snapshot = snapshot
		$scope.$on "trigger snapshot", ->
			return if snapshot.disabled
			$scope.Snapshot.take $scope.stage.debug.image().toDataURL()

testing.directive "stage", stage = ->
	restrict: 'AE'
	scope:
		stage: "=stage"
	template: '
			<label class="title absolute">Stage</label>
			<label class="title title-right pull-right">
				Frame: {{stage.frame}}
			</label>
			<div class="clear-label">
				<div class="scroll">
					<ul class="snapshot-list">
						<li ng-repeat="shot in Snapshot.shots" class="snapshot-thumb">
							Frame&nbsp;{{shot.frame}}: <img ng-src="{{shot.image.data}}" />
						</li>
					</ul>
				</div>
			</div>
		</div>
	'
	controller: ($scope, snapshot)->
		$scope.Snapshot = snapshot
