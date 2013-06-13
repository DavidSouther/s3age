function Forest(stage){
	// Ensure it's a forest, attach it to Object3D
	if(!this instanceof Forest){return new Forest(stage);}
	THREE.Object3D.call(this);

	this.stage = stage;
	stage.scene.add(this);

	this.acres = 1000;
	this.prominence = 50;
	this.parcels = 10;
	this.trees = 200;

	this.bindControls();
	this.addLights();
	this.layGround();
	this.plantTrees();
}

// Subclassing
Forest.prototype = Object.create(THREE.Object3D.prototype);

Forest.prototype.bindControls = function(){
	this.stage.camera.position.set(0, 100, this.acres / 2);
	this.stage.controls = new THREE.TrackballControls(this.stage.camera, this.stage.renderer.domElement);
	this.stage.camera.far = this.acres * 2;
};

Forest.prototype.layGround = function() {
	var geometry = new THREE.PlaneGeometry( this.acres, this.acres, this.parcels, this.parcels);
	var material = new THREE.MeshLambertMaterial({ color: 0xEEFF88 });
	var mesh = new THREE.Mesh( geometry, material );
	// Starts off as a vertical plane
	mesh.rotation.set(-Math.PI / 2, 0, 0);
	this.add(this.ground = mesh);

	var vertex;
	for(var u = 0; u < (this.parcels + 1); u++){
		for(var v = 0; v < (this.parcels + 1); v++){
			vertex = this.uvVertex(u, v);
			vertex.z = Math.random() * this.prominence;
		}
	}
};

Forest.prototype.plantTrees = function() {
	var acreage = this.acres;
	var grid = function() { return (Math.random() - 0.5) * acreage; };

	for ( var i = 0; i < this.trees; i ++ ) {
		this.plantSapling(grid(), grid());
	}
};

Forest.prototype.plantSapling = function(u, v) {
	var tree = new Tree();
	tree.position.set(u, 0, v);
	tree.y = this.height(u, v);
	this.add( tree );
};

Forest.prototype.addLights = function() {
	this.stage.scene.fog = new THREE.FogExp2( 0x333333, 0.001 );

	var light;
	light = new THREE.DirectionalLight( 0xffffff );
	light.position.set( 1, 1, 1 );
	this.add( light );

	light = new THREE.AmbientLight( 0x111A33 );
	this.add( light );
};

/**
 * Return the height of the forest floor at a given (u, v) in the world.
 */
Forest.prototype.height = (function() {
	// Closure for reused raycasting variables.
	var vertices, face;
	var caster = new THREE.Raycaster();
	caster.ray.direction.set(0, 0, -1);
	return function(u, v) {
		var height = 0;
		caster.ray.origin.set(u, -v, this.prominence);
		intersection = caster.intersectObject(this.ground);
		if(intersection.length){
			height = intersection[0].point.z;
			face = intersection[0].face;
			vertices = intersection[0].object.geometry.vertices;
			// Calc this better!
			height = Math.min(vertices[face.a].z, vertices[face.b].z, vertices[face.c].z, vertices[face.d].z);
		}
		return height;
	};
}());

/**
 * Find the vertex on the geometry grid. USES PARCEL SIZES, not world sizes.
 */
Forest.prototype.uvVertex = function(u, v){
	return this.ground.geometry.vertices[(v * this.parcels) + u];
};


/**
 * A tree, to put somewhere
 */
var qPI = Math.PI/4;
function Tree(height){
	if(!this instanceof Tree){return new Tree(height);}
	THREE.Object3D.call(this);

	height = height || (Math.random() * 60) + 40;

	var geometry = new THREE.CylinderGeometry( 0, 10, height, 4, 1 );
	var material =  new THREE.MeshPhongMaterial({ color: 0x33EE33 });
	this.trunk = new THREE.Mesh( geometry, material );
	this.trunk.position.y = height / 2;
	this.add(this.trunk);
};

Tree.prototype = Object.create(THREE.Object3D.prototype);
