//uniform mat4 uMVPMatrix;
//uniform mat4 uSTMatrix;
attribute vec4 position;
attribute mediump vec4 texturecoordinate;
//varying vec2 vTextureCoord;
varying mediump vec2 calcTexCoord;
void main() {
    //gl_Position = uMVPMatrix * aPosition;
    gl_Position = position;
    //vTextureCoord = (uSTMatrix * aTextureCoord).xy;
    calcTexCoord = texturecoordinate.xy;
}