shader_type canvas_item;

uniform sampler2D mask_texture;

void fragment() {
	vec4 tex = texture(TEXTURE, UV);
	float mask = 1.0 - texture(mask_texture, UV).r;
	
	COLOR = vec4(tex.rgb, tex.a * mask);
}