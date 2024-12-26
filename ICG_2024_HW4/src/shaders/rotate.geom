#version 330 core
layout(triangles) in;
layout(triangle_strip, max_vertices = 3) out;

in VS_OUT {
    vec2 TexCoord;
    vec3 normal;
} gs_in[];

out vec2 TexCoords;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;
uniform float time;

float speed = -3;
float accelerationValue = 10;
float floorY = -0.5;
float exploSpeed = 0.4;

vec3 GetNormal(){
   vec3 a = vec3(gl_in[0].gl_Position) - vec3(gl_in[1].gl_Position);
   vec3 b = vec3(gl_in[2].gl_Position) - vec3(gl_in[1].gl_Position);
   return normalize(cross(a, b));
} 

vec4 transformPosition(vec4 position, vec3 normal, float timeOffset, bool isBounce) {
    vec3 offset = normal * (exploSpeed * timeOffset);
    vec3 worldPos = vec3(position) + offset;
    worldPos.y -= speed * timeOffset + 0.5 * accelerationValue * pow(timeOffset, 2.0);

    if (worldPos.y < floorY && isBounce) {
        worldPos.y = floorY;
    }

    return vec4(worldPos, 1.0);
}

void main() {
    vec3 normal = GetNormal();
    float realTime = 5.0;
    vec3 centroid = (gl_in[0].gl_Position.xyz + gl_in[1].gl_Position.xyz + gl_in[2].gl_Position.xyz) / 3.0;

    for(int i = 0; i < 3; i++){
        TexCoords = gs_in[i].TexCoord;
        vec4 newPos = transformPosition(gl_in[i].gl_Position, normal, realTime, true);
        gl_Position = projection * view * model * newPos;
        EmitVertex();
    }
    EndPrimitive();
}
https://zh.wikipedia.org/zh-tw/%E5%87%A0%E4%BD%95%E5%A4%84%E7%90%86