S3age.Loader = (loader, path)->
	THREE.Object3D.apply @, [].slice.call arguments, 2
	(new loader()).load path, (geometry, materials)=>
		this.add new THREE.Mesh geometry, new THREE.MeshFaceMaterial materials

S3age.Loader:: = Object.create(THREE.Object3D::)
