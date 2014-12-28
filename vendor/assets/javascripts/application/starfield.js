/*
	Starfield lets you take a div and turn it into a starfield.
	Snagged from https://github.com/dwmkerr/starfield
*/

//	Define the starfield class.
function Starfield() {
	this.fps = 30;
	this.canvas = null;
	this.width = 0;
	this.width = 0;
	this.minVelocity = 0.1;
	this.maxVelocity = 3;
	this.stars = 80;
	this.intervalId = 0;
}

//	The main function - initializes the starfield.
Starfield.prototype.initialize = function(div) {
	var self = this;

	//	Store the div.
	this.containerDiv = div;
	self.width = window.innerWidth;
	self.height = window.innerHeight;

	window.onresize = function(event) {
		self.width = window.innerWidth;
		self.height = window.innerHeight;
		self.canvas.width = self.width;
		self.canvas.height = self.height;
		self.draw();
	}

	//	Create the canvas.
	var canvas = document.createElement('canvas');
	div.appendChild(canvas);
	this.canvas = canvas;
	this.canvas.width = this.width;
	this.canvas.height = this.height;
};

Starfield.prototype.start = function() {

	//	Create the stars.
	var stars = [];
	for(var i=0; i<this.stars; i++) {
		stars[i] = new Star(
			Math.random() * this.width,
			Math.random() * this.height,
			Math.random() * 3 + 1,
			(Math.random() * (this.maxVelocity - this.minVelocity)) + this.minVelocity
		);
	}
	this.stars = stars;

	var self = this;
	//	Start the timer.
	this.intervalId = setInterval(function() {
		self.update();
		self.draw();
	}, 1000 / this.fps);
};

Starfield.prototype.stop = function() {
	clearInterval(this.intervalId);
};

Starfield.prototype.update = function() {
	var dt = 1 / this.fps;

	for(var i=0; i<this.stars.length; i++) {
		var star = this.stars[i];
		star.y += dt * star.velocity;
		//	If the star has moved from the bottom of the screen, spawn it at the top.
		if(star.y > this.height) {
			this.stars[i] = new Star(
				Math.random() * this.width,
				0,
				Math.random() * 3 + 1,
				(Math.random() * (this.maxVelocity - this.minVelocity)) + this.minVelocity
			);
		}
	}
};

Starfield.prototype.updateStarVelocities = function() {
	for(var i=0; i<this.stars.length; i++) {
		var star = this.stars[i];
		star.velocity = (Math.random() * (this.maxVelocity - this.minVelocity)) + this.minVelocity
	}
}

Starfield.prototype.draw = function() {

	//	Get the drawing context.
	var ctx = this.canvas.getContext("2d");

	//	Draw the background.
 	ctx.fillStyle = '#000000';
	ctx.fillRect(0, 0, this.width, this.height);

	//	Draw stars.
	for(var i=0; i<this.stars.length;i++) {
		var star = this.stars[i];
		ctx.fillStyle = star.color;
		ctx.beginPath()
		ctx.arc(star.x, star.y, star.size / 2, 0, Math.PI * 2, false)
		ctx.fill()
		// ctx.fillRect(star.x, star.y, star.size, star.size);
	}
};

function rndColor() {
	function rn(multiplier) {
		return ~~(Math.random() * multiplier);
	}

	return 'rgba(' + rn(128) + ',' + rn(128) + ',' + rn(128) + ',0.' + rn(10) + ')';
}

function Star(x, y, size, velocity) {
	this.x = x;
	this.y = y;
	this.size = size;
	this.velocity = velocity;
	this.color = 'rgba(255, 255, 255, 0.4)';
}