function Asteroids(positions){
	var object = new THREE.Object3D();
	var geometry = new THREE.SphereGeometry( 1, 4, 4 );
	var material = new THREE.MeshPhongMaterial( { color: 0xffffff, shading: THREE.FlatShading } );
	positions = positions || [];

	while(positions.length < 100){
		positions.push([
			[Math.random() - 0.5, Math.random() - 0.5, Math.random() - 0.5],
			Math.random() * 400,
			[Math.random() * 2, Math.random() * 2, Math.random() * 2],
			Math.random() * 50
		]);
	}

	// Scatter asteroids about
	for ( var i = 0; i < 100; i ++ ) {
		var mesh = new THREE.Mesh( geometry, material );
		var p = positions[i];
		mesh.position.fromArray( p[0] ).normalize();
		mesh.position.multiplyScalar( p[1] );
		mesh.rotation.fromArray( p[2] );
		mesh.scale.x = mesh.scale.y = mesh.scale.z = p[3];
		object.add( mesh );
	}

	object.update = function(){
		object.rotation.x += 0.005;
		object.rotation.y += 0.01;
	};

	return {
		fog: new THREE.Fog( 0x000000, 1, 1000 ),
		lights: [
			new THREE.AmbientLight( 0x222222 ),
			(function(){
				var light = new THREE.DirectionalLight( 0xffffff );
				light.position.set( 1, 1, 1 ).normalize();
				return light;
			}())
		],
		children: [
			object
		]
	};
}
