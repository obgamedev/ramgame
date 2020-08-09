shader_type canvas_item;

void vertex() {
	VERTEX.x += cos(TIME + VERTEX.x + VERTEX.y) * 0.7;
	VERTEX.y += cos(TIME + VERTEX.y + VERTEX.x) * 0.7;
}
//float noise = tex(noiseTex, UV * vec2(TIME,0)).r;

//vec2 offset = noise * vec2(0.02,0);
//COLOR = tex(TEXTURE, UV + offset);