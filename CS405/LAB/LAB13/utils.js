// This function takes the projection matrix, the translation, and two rotation angles (in radians) as input arguments.
// The two rotations are applied around x and y axes.
// It returns the combined 4x4 transformation matrix as an array in column-major order.
// The given projection matrix is also a 4x4 matrix stored as an array in column-major order.
// You can use the MatrixMult function defined in project4.html to multiply two 4x4 matrices in the same format.
function GetModelViewProjection(projectionMatrix, translationX, translationY, translationZ, rotationX, rotationY) {

      var trans1 = [
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            translationX, translationY, translationZ, 1
      ];
      var rotatXCos = Math.cos(rotationX);
      var rotatXSin = Math.sin(rotationX);

      var rotatYCos = Math.cos(rotationY);
      var rotatYSin = Math.sin(rotationY);

      var rotatx = [
            1, 0, 0, 0,
            0, rotatXCos, -rotatXSin, 0,
            0, rotatXSin, rotatXCos, 0,
            0, 0, 0, 1
      ]

      var rotaty = [
            rotatYCos, 0, -rotatYSin, 0,
            0, 1, 0, 0,
            rotatYSin, 0, rotatYCos, 0,
            0, 0, 0, 1
      ]

      var test1 = MatrixMult(rotaty, rotatx);
      var test2 = MatrixMult(trans1, test1);
      var mvp = MatrixMult(projectionMatrix, test2);

      return mvp;
}

function GetModelView(translationX, translationY, translationZ, rotationX, rotationY) {

      var trans1 = [
            1, 0, 0, 0,
            0, 1, 0, 0,
            0, 0, 1, 0,
            translationX, translationY, translationZ, 1
      ];
      var rotatXCos = Math.cos(rotationX);
      var rotatXSin = Math.sin(rotationX);

      var rotatYCos = Math.cos(rotationY);
      var rotatYSin = Math.sin(rotationY);

      var rotatx = [
            1, 0, 0, 0,
            0, rotatXCos, -rotatXSin, 0,
            0, rotatXSin, rotatXCos, 0,
            0, 0, 0, 1
      ]

      var rotaty = [
            rotatYCos, 0, -rotatYSin, 0,
            0, 1, 0, 0,
            rotatYSin, 0, rotatYCos, 0,
            0, 0, 0, 1
      ]

      var test1 = MatrixMult(rotaty, rotatx);
      var test2 = MatrixMult(trans1, test1);

      return test2;
}

function inverse(m) {
      dst = new Float32Array(16);
      var m00 = m[0 * 4 + 0];
      var m01 = m[0 * 4 + 1];
      var m02 = m[0 * 4 + 2];
      var m03 = m[0 * 4 + 3];
      var m10 = m[1 * 4 + 0];
      var m11 = m[1 * 4 + 1];
      var m12 = m[1 * 4 + 2];
      var m13 = m[1 * 4 + 3];
      var m20 = m[2 * 4 + 0];
      var m21 = m[2 * 4 + 1];
      var m22 = m[2 * 4 + 2];
      var m23 = m[2 * 4 + 3];
      var m30 = m[3 * 4 + 0];
      var m31 = m[3 * 4 + 1];
      var m32 = m[3 * 4 + 2];
      var m33 = m[3 * 4 + 3];
      var tmp_0 = m22 * m33;
      var tmp_1 = m32 * m23;
      var tmp_2 = m12 * m33;
      var tmp_3 = m32 * m13;
      var tmp_4 = m12 * m23;
      var tmp_5 = m22 * m13;
      var tmp_6 = m02 * m33;
      var tmp_7 = m32 * m03;
      var tmp_8 = m02 * m23;
      var tmp_9 = m22 * m03;
      var tmp_10 = m02 * m13;
      var tmp_11 = m12 * m03;
      var tmp_12 = m20 * m31;
      var tmp_13 = m30 * m21;
      var tmp_14 = m10 * m31;
      var tmp_15 = m30 * m11;
      var tmp_16 = m10 * m21;
      var tmp_17 = m20 * m11;
      var tmp_18 = m00 * m31;
      var tmp_19 = m30 * m01;
      var tmp_20 = m00 * m21;
      var tmp_21 = m20 * m01;
      var tmp_22 = m00 * m11;
      var tmp_23 = m10 * m01;

      var t0 = (tmp_0 * m11 + tmp_3 * m21 + tmp_4 * m31) -
            (tmp_1 * m11 + tmp_2 * m21 + tmp_5 * m31);
      var t1 = (tmp_1 * m01 + tmp_6 * m21 + tmp_9 * m31) -
            (tmp_0 * m01 + tmp_7 * m21 + tmp_8 * m31);
      var t2 = (tmp_2 * m01 + tmp_7 * m11 + tmp_10 * m31) -
            (tmp_3 * m01 + tmp_6 * m11 + tmp_11 * m31);
      var t3 = (tmp_5 * m01 + tmp_8 * m11 + tmp_11 * m21) -
            (tmp_4 * m01 + tmp_9 * m11 + tmp_10 * m21);

      var d = 1.0 / (m00 * t0 + m10 * t1 + m20 * t2 + m30 * t3);

      dst[0] = d * t0;
      dst[1] = d * t1;
      dst[2] = d * t2;
      dst[3] = d * t3;
      dst[4] = d * ((tmp_1 * m10 + tmp_2 * m20 + tmp_5 * m30) -
            (tmp_0 * m10 + tmp_3 * m20 + tmp_4 * m30));
      dst[5] = d * ((tmp_0 * m00 + tmp_7 * m20 + tmp_8 * m30) -
            (tmp_1 * m00 + tmp_6 * m20 + tmp_9 * m30));
      dst[6] = d * ((tmp_3 * m00 + tmp_6 * m10 + tmp_11 * m30) -
            (tmp_2 * m00 + tmp_7 * m10 + tmp_10 * m30));
      dst[7] = d * ((tmp_4 * m00 + tmp_9 * m10 + tmp_10 * m20) -
            (tmp_5 * m00 + tmp_8 * m10 + tmp_11 * m20));
      dst[8] = d * ((tmp_12 * m13 + tmp_15 * m23 + tmp_16 * m33) -
            (tmp_13 * m13 + tmp_14 * m23 + tmp_17 * m33));
      dst[9] = d * ((tmp_13 * m03 + tmp_18 * m23 + tmp_21 * m33) -
            (tmp_12 * m03 + tmp_19 * m23 + tmp_20 * m33));
      dst[10] = d * ((tmp_14 * m03 + tmp_19 * m13 + tmp_22 * m33) -
            (tmp_15 * m03 + tmp_18 * m13 + tmp_23 * m33));
      dst[11] = d * ((tmp_17 * m03 + tmp_20 * m13 + tmp_23 * m23) -
            (tmp_16 * m03 + tmp_21 * m13 + tmp_22 * m23));
      dst[12] = d * ((tmp_14 * m22 + tmp_17 * m32 + tmp_13 * m12) -
            (tmp_16 * m32 + tmp_12 * m12 + tmp_15 * m22));
      dst[13] = d * ((tmp_20 * m32 + tmp_12 * m02 + tmp_19 * m22) -
            (tmp_18 * m22 + tmp_21 * m32 + tmp_13 * m02));
      dst[14] = d * ((tmp_18 * m12 + tmp_23 * m32 + tmp_15 * m02) -
            (tmp_22 * m32 + tmp_14 * m02 + tmp_19 * m12));
      dst[15] = d * ((tmp_22 * m22 + tmp_16 * m02 + tmp_21 * m12) -
            (tmp_20 * m12 + tmp_23 * m22 + tmp_17 * m02));

      return dst;
}

function transpose(m) {
      dst = new Float32Array(16);
      dst[0] = m[0];
      dst[1] = m[4];
      dst[2] = m[8];
      dst[3] = m[12];
      dst[4] = m[1];
      dst[5] = m[5];
      dst[6] = m[9];
      dst[7] = m[13];
      dst[8] = m[2];
      dst[9] = m[6];
      dst[10] = m[10];
      dst[11] = m[14];
      dst[12] = m[3];
      dst[13] = m[7];
      dst[14] = m[11];
      dst[15] = m[15];
      return dst;
}
function inverse3x3(m) {
      var a00 = m[0], a01 = m[1], a02 = m[2],
            a10 = m[3], a11 = m[4], a12 = m[5],
            a20 = m[6], a21 = m[7], a22 = m[8];

      var b01 = a22 * a11 - a12 * a21,
            b11 = -a22 * a10 + a12 * a20,
            b21 = a21 * a10 - a11 * a20;

      var det = a00 * b01 + a01 * b11 + a02 * b21;

      if (!det) {
            return null;
      }
      det = 1.0 / det;

      var out = new Float32Array(9);
      out[0] = b01 * det;
      out[1] = (-a22 * a01 + a02 * a21) * det;
      out[2] = (a12 * a01 - a02 * a11) * det;
      out[3] = b11 * det;
      out[4] = (a22 * a00 - a02 * a20) * det;
      out[5] = (-a12 * a00 + a02 * a10) * det;
      out[6] = b21 * det;
      out[7] = (-a21 * a00 + a01 * a20) * det;
      out[8] = (a11 * a00 - a01 * a10) * det;

      return out;
}

function transpose3x3(m) {
      var out = new Float32Array(9);
      out[0] = m[0];
      out[1] = m[3];
      out[2] = m[6];
      out[3] = m[1];
      out[4] = m[4];
      out[5] = m[7];
      out[6] = m[2];
      out[7] = m[5];
      out[8] = m[8];
      return out;
}
function getNormalMatrix(modelView) {
      let modelView3X3 = new Float32Array(9);
      modelView3X3[0] = modelView[0];
      modelView3X3[1] = modelView[1];
      modelView3X3[2] = modelView[2];
      modelView3X3[3] = modelView[4];
      modelView3X3[4] = modelView[5];
      modelView3X3[5] = modelView[6];
      modelView3X3[6] = modelView[8];
      modelView3X3[7] = modelView[9];
      modelView3X3[8] = modelView[10];
      let normalMatrix = inverse3x3(modelView3X3);
      normalMatrix = transpose3x3(normalMatrix);
      return normalMatrix;
}

function isPowerOf2(value) {
      return (value & (value - 1)) == 0;
}

function normalize(v, dst) {
      dst = dst || new Float32Array(3);
      var length = Math.sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);
      // make sure we don't divide by 0.
      if (length > 0.00001) {
            dst[0] = v[0] / length;
            dst[1] = v[1] / length;
            dst[2] = v[2] / length;
      }
      return dst;
}