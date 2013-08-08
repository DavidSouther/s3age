testing.directive "imageCompare", imageCompare = ->
	restrict: 'AE'
	scope:
		image: "=image"
	template: '
		<div class="image-compare">
			<ul class="nav nav-tabs" style="margin-bottom: 20px">
				<li
					ng-class="{
						active: view == \'image\'
					}"
				><a ng-click="view = \'image\'">Image</a></li>
				<li
					ng-class="{
						active: view == \'reference\'
					}"
				><a ng-click="view = \'reference\'">Reference</a></li>
				<li
					ng-class="{
						active: view == \'compare\'
					}"
				><a ng-click="view = \'compare\'">Compare</a></li>
				<li
					ng-class="{
						active: view == \'diff\'
					}"
				><a ng-click="view = \'diff\'">Difference</a></li>

			</ul>
			<div ng-show="view == \'image\'">
				<img ng-src="{{image.data}}" />
			</div>
			<div ng-show="view == \'reference\'">
				<img ng-src="{{image.reference}}" />
			</div>
			<div ng-show="view == \'diff\'">
				<img ng-src="{{image.delta}}" />
			</div>
			<div class="compare" ng-show="view == \'compare\'">
				<div class="under">
					<img ng-src="{{image.data}}"/>
				</div>
				<div class="slider"
				 	style="
						width: {{percent}}%;
						overflow: hidden;
						margin-top: -500px;
						border-right: 1px solid #428bca;
					"
				>
					<img ng-src="{{image.reference}}" />
				</div>
			</div>
		</div>
	'
	link: ($scope, $elem)->
		slider = angular.element $elem[0].querySelector ".compare"
		Slide = (e)->
			e.preventDefault()
			$scope.$apply ->
				percent = 100 * e.offsetX / slider[0].clientWidth
				$scope.percent = percent
		slider.bind "mousedown", Slide
		slider.bind "mousemove", (e)-> Slide e if button

		# Silly hacks
		button = false
		angular.element(document).bind 'mousedown', -> button = true
		angular.element(document).bind 'mouseup', -> button = false

	controller: ($scope)->
		$scope.view = "image"
		$scope.percent = 65

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
			<div class='clear-label'>
				<div class='scroll'>
					<image-compare image='Snapshot.image'></image-compare>
				</div>
			</div>
		</div>"
	link: ($scope, $elem)->
		$scope.iframe = $elem.find "iframe"
		$scope.iframe.bind "load", ->
			wind = $scope.iframe[0].contentWindow

			if not wind
				console.error "Couldn't load #{$scope.test.path} correctly."
				return
			if not wind.stage
				console.warn "Couldn't load #{$scope.test.path} with stage."
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
						<div
							ng-class="{
								\'alert-danger\': shot.image.reference != shot.image.data,
								\'alert-success\': shot.image.reference == shot.image.data
							}"
						>
							<img ng-src="{{shot.image.data}}" />
							<img ng-src="{{shot.image.reference}}" ng-show="shot.image.reference" />
							<img ng-src="{{shot.image.delta}}" ng-show="shot.image.delta" />
						</div>
						<br />
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
