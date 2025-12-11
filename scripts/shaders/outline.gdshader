// https://godotshaders.com/shader/the-simplest-outline-shader-via-material/

shader_type spatial;
render_mode cull_front, unshaded;

uniform vec3 color : source_color = vec3(1,1,1);
uniform float size : hint_range(1.0, 1.5, 0.01) = 1.05;

void vertex() {
	VERTEX *= size;
}

void fragment() {
	ALBEDO = color.rgb;
}