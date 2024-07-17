function multiplyMatrices(matrixA, matrixB) {
    var result = [];

    for (var i = 0; i < 4; i++) {
        result[i] = [];
        for (var j = 0; j < 4; j++) {
            var sum = 0;
            for (var k = 0; k < 4; k++) {
                sum += matrixA[i * 4 + k] * matrixB[k * 4 + j];
            }
            result[i][j] = sum;
        }
    }

    // Flatten the result array
    return result.reduce((a, b) => a.concat(b), []);
}
function createIdentityMatrix() {
    return new Float32Array([
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    ]);
}
function createScaleMatrix(scale_x, scale_y, scale_z) {
    return new Float32Array([
        scale_x, 0, 0, 0,
        0, scale_y, 0, 0,
        0, 0, scale_z, 0,
        0, 0, 0, 1
    ]);
}

function createTranslationMatrix(x_amount, y_amount, z_amount) {
    return new Float32Array([
        1, 0, 0, x_amount,
        0, 1, 0, y_amount,
        0, 0, 1, z_amount,
        0, 0, 0, 1
    ]);
}

function createRotationMatrix_Z(radian) {
    return new Float32Array([
        Math.cos(radian), -Math.sin(radian), 0, 0,
        Math.sin(radian), Math.cos(radian), 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    ])
}

function createRotationMatrix_X(radian) {
    return new Float32Array([
        1, 0, 0, 0,
        0, Math.cos(radian), -Math.sin(radian), 0,
        0, Math.sin(radian), Math.cos(radian), 0,
        0, 0, 0, 1
    ])
}

function createRotationMatrix_Y(radian) {
    return new Float32Array([
        Math.cos(radian), 0, Math.sin(radian), 0,
        0, 1, 0, 0,
        -Math.sin(radian), 0, Math.cos(radian), 0,
        0, 0, 0, 1
    ])
}

function getTransposeMatrix(matrix) {
    return new Float32Array([
        matrix[0], matrix[4], matrix[8], matrix[12],
        matrix[1], matrix[5], matrix[9], matrix[13],
        matrix[2], matrix[6], matrix[10], matrix[14],
        matrix[3], matrix[7], matrix[11], matrix[15]
    ]);
}

const vertexShaderSource = `
attribute vec3 position;
attribute vec3 normal; // Normal vector for lighting

uniform mat4 modelViewMatrix;
uniform mat4 projectionMatrix;
uniform mat4 normalMatrix;

uniform vec3 lightDirection;

varying vec3 vNormal;
varying vec3 vLightDirection;

void main() {
    vNormal = vec3(normalMatrix * vec4(normal, 0.0));
    vLightDirection = lightDirection;

    gl_Position = vec4(position, 1.0) * projectionMatrix * modelViewMatrix; 
}

`

const fragmentShaderSource = `
precision mediump float;

uniform vec3 ambientColor;
uniform vec3 diffuseColor;
uniform vec3 specularColor;
uniform float shininess;

varying vec3 vNormal;
varying vec3 vLightDirection;

void main() {
    vec3 normal = normalize(vNormal);
    vec3 lightDir = normalize(vLightDirection);
    
    // Ambient component
    vec3 ambient = ambientColor;

    // Diffuse component
    float diff = max(dot(normal, lightDir), 0.0);
    vec3 diffuse = diff * diffuseColor;

    // Specular component (view-dependent)
    vec3 viewDir = vec3(0.0, 0.0, 1.0); // Assuming the view direction is along the z-axis
    vec3 reflectDir = reflect(-lightDir, normal);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), shininess);
    vec3 specular = spec * specularColor;

    gl_FragColor = vec4(ambient + diffuse + specular, 1.0);
}

`

/**
 * @WARNING DO NOT CHANGE ANYTHING ABOVE THIS LINE
 */



/**
 * 
 * @TASK1 Calculate the model view matrix by using the chatGPT
 */

function getChatGPTModelViewMatrix() {
    const transformationMatrix = new Float32Array([
    0.35355, -0.61237, 0.70711, 0.24495,
    0.61237, 0.35355, 0.70711, -0.20495,
    -0.70711, 0.70711, 0, 0,
    0, 0, 0, 1
]);

    return getTransposeMatrix(transformationMatrix);
}


/**
 * 
 * @TASK2 Calculate the model view matrix by using the given 
 * transformation methods and required transformation parameters
 * stated in transformation-prompt.txt
 */
function getModelViewMatrix() {
    // calculate the model view matrix by using the transformation
    // methods and return the modelView matrix in this method
    var translation_matrix = createTranslationMatrix(0.3, -0.25, 0);
    var scaling_matrix = createScaleMatrix(0.5, 0.5, 1);
    var rotation_matrix_x = createRotationMatrix_X(Math.PI / 6);
    var rotation_matrix_y = createRotationMatrix_Y(Math.PI / 4);
    var rotation_matrix_z = createRotationMatrix_Z(Math.PI / 3);

    var transformation_matrix = multiplyMatrices(rotation_matrix_y, rotation_matrix_x);
    transformation_matrix = multiplyMatrices(rotation_matrix_z, transformation_matrix);
    transformation_matrix = multiplyMatrices(scaling_matrix, transformation_matrix);
    transformation_matrix = multiplyMatrices(translation_matrix, transformation_matrix);

    return transformation_matrix

}

/**
 * 
 * @TASK3 Ask CHAT-GPT to animate the transformation calculated in 
 * task2 infinitely with a period of 10 seconds. 
 * First 5 seconds, the cube should transform from its initial 
 * position to the target position.
 * The next 5 seconds, the cube should return to its initial position.
 */
function getPeriodicMovement(startTime) {
  // Total duration of each cycle of the animation (in milliseconds)
  const cycleDuration = 10000; // 10 seconds

  // Time elapsed since the animation started
  const elapsedTime = (Date.now() - startTime) % cycleDuration;

  // Calculate the progress in the current cycle (between 0 and 1)
  const progressInCycle = elapsedTime / cycleDuration;

  // Define your initial and final transformation matrices for the object
  const initialTransform = createIdentityMatrix();
  const finalTransform = getModelViewMatrix();

  let interpolatedTransform;

  // Check if we are in the first 5 seconds (forward transformation)
  if (progressInCycle < 0.5) {
    // Interpolate forward from initial to final transformation
    interpolatedTransform = interpolateTransforms(initialTransform, finalTransform, progressInCycle * 2);
  } else {
    // Interpolate backward from final to initial transformation for the next 5 seconds
    const progressInBackwardCycle = (progressInCycle - 0.5) * 2;
    interpolatedTransform = interpolateTransforms(finalTransform, initialTransform, progressInBackwardCycle);
  }

  return interpolatedTransform;
}

// Example transformation matrix interpolation function
function interpolateTransforms(startTransform, endTransform, progress) {
  // You need to implement your own interpolation logic here
  // This can involve interpolating translation, rotation, and scale components
  // For a simple linear interpolation, you can do something like:
  const resultTransform = [];
  for (let i = 0; i < startTransform.length; i++) {
    const interpolatedValue = startTransform[i] + (endTransform[i] - startTransform[i]) * progress;
    resultTransform.push(interpolatedValue);
  }
  return resultTransform;
}


