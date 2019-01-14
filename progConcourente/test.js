let points;

let current;
let percent = 0.5;
let previous;

function PointColor(point, color) {
	this.point = point;
	this.color = color;
}

function setup() {
	createCanvas(windowWidth, windowHeight);
	colorMode("HSB", TWO_PI, 1,1);
	points = [];
	const n = 5;
	const inc = TWO_PI / n

	for (let i = 0; i < n; i++) {
		const angle = i * inc;
		const c = color(angle, 1, 1)
		const p = p5.Vector.fromAngle(angle);
		p.mult(width / 2);
		p.add(width / 2, height / 2);
		const pc = new PointColor(p, c);
		points.push(pc);
	}

	reset();
}

function reset() {
	current = createVector(points[0].point.x, points[0].point.y);
	background(0);
	stroke(255);
	strokeWeight(8);
	for (let p of points) {
		point(p.x, p.y);
	}


}

function draw() {

	if (frameCount % 100 == 0) {
		//reset();
	}

	strokeWeight(1);
	for (let i = 0; i < 1000; i++) {
		const next = random(points);
		if (next !== previous) {
			current.x = lerp(current.x, next.point.x, percent);
			current.y = lerp(current.y, next.point.y, percent);
			stroke(next.color);
			point(current.x, current.y);
		}

		previous = next;
	}



}
