shader_type canvas_item;

uniform float frequency;
uniform float amount;

void vertex() {
	float percent = VERTEX.g / 128.0;
	float sine_move = sin(frequency *(TIME + VERTEX.r)) * amount;
	float move = mix(sine_move, 0.0, percent);
	VERTEX.g += sine_move;
}

void fragment() {
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
