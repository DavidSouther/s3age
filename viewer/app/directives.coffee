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
						ng-src='{{test.path}}'
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

			if not wind.stage
				console.error "Couldn't load #{$scope.test.path} correctly."
				return

			$scope.Snapshot.stage = $scope.stage = wind.stage

			watcher = new wind.THREE.Object3D()
			watcher.update = ->
				$scope.Snapshot.tick()
				$scope.$apply()
			$scope.stage.scene.add watcher
			$scope.$apply()

	controller: ($scope, snapshot)->
		$scope.stage = null
		$scope.Snapshot = snapshot

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
						<label>Frame</label><input value="{{shot.frame}}" auto-select />:<br />
						<img ng-src="{{shot.image.data}}" /><br />
						<label>Base64</label><textarea rows="1" auto-select>{{shot.image.data}}</textarea>
					</li>
				</ul>
			</div>
		</div>
	'
	controller: ($scope, snapshot)->
		$scope.Snapshot = snapshot
		$scope.printTestPlan = ->
			console.log snapshot.testPlan

testing.directive "autoSelect", autoSelect = ->
	link: ($scope, $elem)->
		$elem.bind "focus", ->
			$elem[0].select()
		$elem.bind "mouseup", (e)->
			# Prevent mouse selection of a chunk.
			# Also fixes the immediately-unselected behavior.
			e.preventDefault()
