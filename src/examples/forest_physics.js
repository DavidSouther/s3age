(function(){
	var base = Forest;
	Forest = function(stage){
		this.UPS = 100;
		this.speed = 0.2;
		this.saplings = [];
		base.call(this, stage);
		this.physics();
		this.biology();
	};

	Forest.prototype = Object.create(base.prototype);

	Forest.prototype.plantSapling = function(u, v){
		base.prototype.plantSapling.call(this, u, v);
		// Add the most recently added child to the trees array.
		var last = this.children[this.children.length - 1];
		if(last instanceof Tree){
			this.saplings.push(last);
		}
	}

	Forest.prototype.biology = function(){
		var self = this;
		var URLs = {
			grass: "imgs/grass.jpg", // http://www.mayang.com/textures/Plants/images/Repetitive%20Plants%20Textures/uneven_grass_030199.JPG
			bark: "imgs/bark.jpg" // http://www.sharecg.com/images/medium/3005.jpg
		};
		var grass = THREE.ImageUtils.loadTexture(URLs.grass);
		this.ground.material.map = grass;
		var bark = THREE.ImageUtils.loadTexture(URLs.bark);
		for(var i=0; i<this.saplings.length; i++){
			this.saplings[i].biology(bark);
		}
	};

	Forest.prototype.physics = function(){
		var self = this;
		var clock = new THREE.Clock();
		(function spinor(){
			self.rotation.set(0, clock.getElapsedTime() * self.speed, 0);
			setTimeout(spinor, 1000 / self.UPS);
		}());
	};

	Tree.prototype.biology = function(bark){
		var self = this;
		var growth = 0;
		this.trunk.material.map = bark;
		this.UPS = Math.floor(Math.random() * 5000) + 2000;
		(function grower(){
			self.scale.add(new THREE.Vector3(
				Math.random()/(10 + growth + growth), // Grow width up to a tenth a meter
				Math.random()/(5 + growth), // Gro up to a fifth a meter in height
				Math.random()/(10 + growth + growth)
			));
			growth += 1;
			setTimeout(grower, self.UPS)
		}());
	};

}).call(window);