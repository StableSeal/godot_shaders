shader_type canvas_item;
uniform sampler2D pix_shader: filter_nearest;
uniform sampler2D rendered_texture: hint_screen_texture, filter_nearest,repeat_disable;
uniform sampler2D sky_texture: repeat_enable;
uniform float resolution_divide;


void fragment() {
	// Place fragment code here.
	//get screen size
	vec2 res = 1./SCREEN_PIXEL_SIZE/resolution_divide;
	
	//get current pixel coordinate
	ivec2 this_pixel_pos = ivec2(SCREEN_UV*res);
	
	//get darkness and redness of the screen tex, store dark in x and red in y
	
	vec4 screen_as_pixels = texture(rendered_texture, vec2(float(this_pixel_pos.x)/res.x, float(this_pixel_pos.y)/res.y));// texture(rendered_texture, vec2(float(this_pixel_pos.x)/res.x);
	int offset = int(clamp(screen_as_pixels.r*4.-1.,0.,1.)*6.)*8;//there are eight pixels in each section
	float red = clamp((screen_as_pixels.r-screen_as_pixels.g)*20.-5.,0.,1.);//fix this, red should only appear on white pixels
	float blue = clamp((screen_as_pixels.b-screen_as_pixels.g)*20.-5.,0.,1.);//fix this, red should only appear on white pixels
	//modulo that by image size
	ivec2 image_pixel = ivec2(this_pixel_pos.x%8+offset, this_pixel_pos.y%8);
	
	vec2 pixel_as_float = vec2(float(image_pixel.x)/64., float(image_pixel.y)/8.);
	
	vec4 i = texture(pix_shader,pixel_as_float,0);
	
	COLOR = vec4(1.*i.g,(1.-red)*i.g,(1.-red)*i.g,1);//vec4(1.,1.-red,1.-red,1)*i.g; ////vec4(i.g,i.g-red,i.g-red,1);
	COLOR += texture(sky_texture, vec2(SCREEN_UV.x*1.5,SCREEN_UV.y)*2.)*blue;
}
