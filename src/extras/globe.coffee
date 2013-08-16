S3age.Extras.Globe = (@radius = 1)->
	THREE.Object3D.apply @, [].slice.call arguments, 1
	THREE.Object3D::add.call @, @tilted = new THREE.Object3D()
	@tilted.rotation = 
	@rotation.z = Math.toRad 23.4

	@speed = rotation: 0.001
	@markers = new THREE.Object3D()
	@markers.updateable = []
	@add @markers
	@

S3age.Extras.Globe:: = Object.create THREE.Object3D::

S3age.Extras.Globe::update = (clock)->
	@tilted.rotation.y += @speed.rotation
	m.update? clock for m in @markers.updateable

S3age.Extras.Globe::addMarker = (marker, lat, lon)->
	lat = Math.toRad lon || marker.lat
	lon = Math.toRad lon || marker.lon

	base = new THREE.Object3D()
	base.rotation.y = lon
	base.rotation.z = lat
	@markers.add base

	center = new THREE.Object3D()
	center.position.x = @radius * 1.001
	center.rotation.y = Math.PI / 2
	base.add center

	center.add marker
	@markers.updateable.push marker
	@

S3age.Extras.Globe::add = (object)->
	@tilted.add object
