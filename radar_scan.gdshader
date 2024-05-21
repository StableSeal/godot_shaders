shader_type canvas_item;
uniform sampler2D rendered_texture: hint_screen_texture;
uniform int effect_on;
uniform float time;

//void vertex() {
//	
//}

vec4 tween_colors_opaque(vec4 first, vec4 second, float amount) //
{
	float first_amount = 1.0f - amount;
	
	return vec4( first_amount*first.x + amount * second.x ,first_amount*first.y + amount * second.y ,first_amount*first.z + amount * second.z ,1);
}

float modulusFloats(float operand, float operator) //this is the worst thing ive ever written
{
	return float(int(operand*1000.0f)%int(operator*1000.0f))/1000.0f;
}

void fragment() {
	if(effect_on == 2 || effect_on == 1 || effect_on == 3){
		vec2 res = 1.0f/SCREEN_PIXEL_SIZE;
		float line_width = .90f;
		float boxes_amount_vertical = 15.0f;
		float pixels_per_box = res.y/boxes_amount_vertical;
		float boxes_amount_horizontal = res.x/pixels_per_box;
		float box_height = 1.0f / boxes_amount_vertical;
		float box_width = 1.0f / boxes_amount_horizontal;
		float square_y = modulusFloats(UV.y+(box_height * 200.0f *2.0f*(time/100.0f)), box_height); // min is 0 max is 1
		float square_x = modulusFloats(UV.x+(box_width * 200.0f *1.0f*(time/100.0f)), box_width);
		float y_clamped = clamp(ceil((square_y*boxes_amount_vertical)-line_width),0,1);
		float x_clamped = clamp(ceil((square_x*boxes_amount_horizontal)-line_width),0,1);
		float full_square = clamp(y_clamped+x_clamped, 0, 1);
		vec4 freaky = vec4(0,.25f,0,1) + tween_colors_opaque(texture(rendered_texture, UV),  vec4(0,0,0,1), full_square/6.0f)/1.5f *(abs(sin(time*5.0f)*.5f)+.5f);
		if(effect_on == 1){
			float is_pixel_on = clamp(ceil((UV.y)-time*4.0f),0,1);
			COLOR = tween_colors_opaque(freaky, texture(rendered_texture,UV), is_pixel_on);
		}else if(effect_on == 3)
		{
			float is_pixel_on = clamp(ceil((UV.y)-time*4.0f),0,1);;
			COLOR = tween_colors_opaque(texture(rendered_texture,UV), freaky, is_pixel_on);
		}else
		{
			COLOR = freaky;
		 }
	}else if(effect_on == 0){
		COLOR = texture(rendered_texture, UV);
	}else if(effect_on == 4)
	{
		float is_pixel_on = clamp(ceil((UV.y)-time*4.0f),0,1);
		COLOR = tween_colors_opaque(vec4(0,0,0,1), texture(rendered_texture,UV), is_pixel_on);
	}else if(effect_on == 5)
	{
		float is_pixel_on = clamp(ceil((UV.y)-time*4.0f),0,1);
		COLOR = tween_colors_opaque(texture(rendered_texture,UV), vec4(0,0,0,1), is_pixel_on);
	}
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
