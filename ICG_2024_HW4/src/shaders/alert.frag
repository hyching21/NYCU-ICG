#version 330 core
out vec4 FragColor;

in vec2 TexCoord; 
in vec3 FragPos;

uniform sampler2D ourTexture;
uniform float time;

vec3 baseColor1 = vec3(1.0f, 0.5f, 0.0f); // orange
vec3 baseColor2 = vec3(1.0f, 0.2f, 0.0f); // red
vec3 baseColor3 = vec3(1.0f, 1.0f, 0.0f); // yellow


float noise(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void main()
{
    vec4 texColor = texture(ourTexture, TexCoord);

    float intensity = abs(sin(time * 3.0));
    float randomNoise = noise(TexCoord + time * 0.1);

    vec3 fireColor;
    if (intensity < 0.33) {
        fireColor = mix(baseColor1, baseColor2, intensity * 3.0);
    } else if (intensity < 0.66) {
        fireColor = mix(baseColor2, baseColor3, (intensity - 0.33) * 3.0);
    } else {
        fireColor = mix(baseColor3, baseColor1, (intensity - 0.66) * 3.0);
    }

    fireColor += randomNoise * 0.1;

    vec3 finalColor = texColor.rgb * fireColor; 
    FragColor = vec4(finalColor, texColor.a);
}
