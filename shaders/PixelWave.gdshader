shader_type canvas_item;

void vertex() {
	//float percent = VERTEX.g / 128.0;
	//float sine_move = sin(2.0 *(TIME + VERTEX.r * 600.0)) * 5.0;
	//float move = mix(sine_move, 0.0, percent); 
	//VERTEX.g += sine_move;
}

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform float shake_amount;
uniform float frequency;

void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 uv_old = SCREEN_UV;
	
	uv.y += sin( frequency * (TIME + uv.x)) * shake_amount - 0.01;
	//uv.y = mix(uv.y, uv_old.y, uv_old.y);
	COLOR = texture(SCREEN_TEXTURE, uv);
	
	if (uv.y <= 0.0) {
		COLOR.a = 0.0;
	}
	if(uv.y  >= 1.0){
		COLOR.a = 0.0;
	}
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
