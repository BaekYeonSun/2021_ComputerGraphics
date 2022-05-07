#version 120                  // GLSL 1.20

uniform sampler2D u_diffuse_texture;

uniform mat4 u_model_matrix;
uniform mat3 u_normal_matrix;

uniform vec3 u_light_position;
uniform vec3 u_light_ambient;
uniform vec3 u_light_diffuse;
uniform vec3 u_light_specular;

uniform vec3 u_material_ambient;
uniform vec3 u_material_diffuse;
uniform vec3 u_material_specular;
uniform float u_material_shininess;

varying vec3 v_position;
varying vec3 v_normal;
varying vec2 v_texcoord;

uniform vec3 u_camera_position;
uniform mat4 u_view_matrix;

vec4 calc_color()
{
	vec3 color = vec3(0.0f);

	vec3 position_wc = (u_model_matrix * vec4(v_position, 1.0f)).xyz;
  	vec3 normal_wc   = normalize(u_normal_matrix * v_normal);

	vec3 light_dir = normalize(u_light_position);

	// ambient
  	color += (u_light_ambient * u_material_ambient);
	// color += (u_light_ambient * vec3(texture2D(u_diffuse_texture, v_texcoord)));
	
	// diffuse
	float ndotl = max(dot(normal_wc, light_dir), 0.0);
  	// color += (ndotl * u_light_diffuse * vec3(texture2D(u_diffuse_texture, v_texcoord)) * u_material_diffuse);
	color += (ndotl * u_light_diffuse * vec3(texture2D(u_diffuse_texture, v_texcoord)));
	
	// specular
	vec3 view_dir = normalize(u_camera_position - position_wc);
  	vec3 reflect_dir = reflect(-light_dir, normal_wc); 

	float rdotv = max(dot(view_dir, reflect_dir), 0.0);
  	color += (pow(rdotv, u_material_shininess) * u_light_specular * u_material_specular);

	return vec4(color, 1.0f); 
}

void main()
{
	gl_FragColor = calc_color();
	// gl_FragColor = calc_color() * vec4(texture2D(u_diffuse_texture, v_texcoord));	
}
