class MeshDrawer {
	// The constructor is a good place for taking care of the necessary initializations.
	constructor() {
		this.prog = InitShaderProgram(meshVS, meshFS);
		this.mvpLoc = gl.getUniformLocation(this.prog, 'mvp');
		this.modelViewLoc = gl.getUniformLocation(this.prog, 'modelView');
		this.showTexLoc = gl.getUniformLocation(this.prog, 'showTex');
		this.useGouraudLoc = gl.getUniformLocation(this.prog, 'useGouraud');

		this.vertPosLoc = gl.getAttribLocation(this.prog, 'pos');
		this.texCoordLoc = gl.getAttribLocation(this.prog, 'texCoord');
		this.normalLoc = gl.getAttribLocation(this.prog, 'normal');


		this.vertbuffer = gl.createBuffer();
		this.texbuffer = gl.createBuffer();
		this.normalbuffer = gl.createBuffer();

		this.ambientLoc = gl.getUniformLocation(this.prog, 'ambient');
		this.enableLightingLoc = gl.getUniformLocation(this.prog, 'enableLighting');
		this.lightSourceLoc = gl.getUniformLocation(this.prog, 'lightPos');
		this.numTriangles = 0;
	}

	setMesh(vertPos, texCoords, normalCoords) {
		gl.bindBuffer(gl.ARRAY_BUFFER, this.vertbuffer);
		gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(vertPos), gl.STATIC_DRAW);

		// update texture coordinates
		gl.bindBuffer(gl.ARRAY_BUFFER, this.texbuffer);
		gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(texCoords), gl.STATIC_DRAW);

		gl.bindBuffer(gl.ARRAY_BUFFER, this.normalbuffer);
		gl.bufferData(gl.ARRAY_BUFFER, new Float32Array(normalCoords), gl.STATIC_DRAW);

		this.numTriangles = vertPos.length / 3;
	}

	// This method is called to draw the triangular mesh.
	// The argument is the transformation matrix, the same matrix returned
	// by the GetModelViewProjection function above.
	draw(trans, modelView, lightX, lightY, lightZ, transZ) {
		gl.useProgram(this.prog);

		gl.uniformMatrix4fv(this.mvpLoc, false, trans);
		gl.uniformMatrix4fv(this.modelViewLoc, false, modelView);

		gl.bindBuffer(gl.ARRAY_BUFFER, this.vertbuffer);
		gl.enableVertexAttribArray(this.vertPosLoc);
		gl.vertexAttribPointer(this.vertPosLoc, 3, gl.FLOAT, false, 0, 0);

		gl.bindBuffer(gl.ARRAY_BUFFER, this.texbuffer);
		gl.enableVertexAttribArray(this.texCoordLoc);
		gl.vertexAttribPointer(this.texCoordLoc, 2, gl.FLOAT, false, 0, 0);

		gl.bindBuffer(gl.ARRAY_BUFFER, this.normalbuffer);
		gl.enableVertexAttribArray(this.normalLoc);
		gl.vertexAttribPointer(this.normalLoc, 3, gl.FLOAT, false, 0, 0);

		gl.uniform3fv(this.lightSourceLoc, ([lightX, lightY, lightZ])); // Example light direction
		
		gl.drawArrays(gl.TRIANGLES, 0, this.numTriangles);

	}

	// This method is called to set the texture of the mesh.
	// The argument is an HTML IMG element containing the texture data.
	setTexture(img) {
		const texture = gl.createTexture();
		gl.bindTexture(gl.TEXTURE_2D, texture);

		// You can set the texture image data using the following command.
		gl.texImage2D(
			gl.TEXTURE_2D,
			0,
			gl.RGB,
			gl.RGB,
			gl.UNSIGNED_BYTE,
			img);

		// Set texture parameters 
		if (isPowerOf2(img.width) && isPowerOf2(img.height)) {
			console.log("power of 2")
			gl.generateMipmap(gl.TEXTURE_2D);
		} else {
			// burayı non power of 2 için değiştirecekler
			console.error("non power of 2, you should implement this part to accept non power of 2 textures")
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
			gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
		}


		gl.useProgram(this.prog);
		gl.activeTexture(gl.TEXTURE0);
		gl.bindTexture(gl.TEXTURE_2D, texture);
		const sampler = gl.getUniformLocation(this.prog, 'tex');
		gl.uniform1i(sampler, 0);
	}

	// This method is called when the user changes the state of the
	// "Show Texture" checkbox. 
	// The argument is a boolean that indicates if the checkbox is checked.
	showTexture(show) {
		gl.useProgram(this.prog);
		gl.uniform1i(this.showTexLoc, show);
	}

	enableLighting(show) {
		gl.useProgram(this.prog);
		gl.uniform1i(this.enableLightingLoc, show);
	}

	setAmbientLight(ambient) {
		gl.useProgram(this.prog);
		gl.uniform1f(this.ambientLoc, ambient);
	}

	setShadingMethod(useGouraud) {
		gl.useProgram(this.prog);
		gl.uniform1i(this.useGouraudLoc, useGouraud);
	}
}


// Vertex shader source code
const meshVS = `
			precision mediump float;

			attribute vec3 pos; 
			attribute vec2 texCoord; 
			attribute vec3 normal;

			uniform bool useGouraud;
			uniform mat4 mvp;
			uniform mat4 modelView;
			uniform vec3 lightPos;
			uniform float ambient;

			varying vec2 v_texCoord; 
			varying vec3 v_normal;
			varying vec3 v_pos;
			varying vec4 v_color;

			void main()
			{
				// play around with the following lines to see how the light behaves differently
				v_texCoord = texCoord;
				v_normal = vec3(mvp * vec4(normal,1));
				v_pos = vec3(modelView * vec4(pos,1));

				if(useGouraud){
					vec3 normal = normalize(v_normal); // Normalize the normal
					vec3 lightdir = normalize(lightPos); // Normalize the light direction
					float diff = max(dot(normal, lightdir), 0.0); // Simple diffuse lighting

					vec3 viewDir = normalize(-v_pos); // We are looking along the z axis
					vec3 reflectDir = reflect(-lightdir, normal); // Compute reflection vector
					float spec = pow(max(dot(viewDir, reflectDir), 0.0), 128.0); // Compute specular component

					v_color = vec4(vec3(ambient + diff + spec), 1.0);
				}
				gl_Position = mvp * vec4(pos,1);
			}`;

const meshFS = `
			precision mediump float;

			uniform bool showTex;
			uniform bool enableLighting;
			uniform sampler2D tex;
			uniform vec3 lightPos;
			uniform float ambient;
			uniform bool useGouraud;

			varying vec2 v_texCoord;
			varying vec3 v_normal;
			varying vec3 v_pos;
			varying vec4 v_color;

			void main()
			{
				if(showTex && enableLighting){
					if(useGouraud){
						gl_FragColor = texture2D(tex, v_texCoord) * v_color;
					}
					else{
						vec3 normal = normalize(v_normal); // Normalize the normal
						vec3 lightdir = normalize(lightPos); // Normalize the light direction
						float diff = max(dot(normal, lightdir), 0.0); // Simple diffuse lighting

						vec3 viewDir = normalize(-v_pos); // We are looking along the z axis
						vec3 reflectDir = reflect(-lightdir, normal); // Compute reflection vector
						float spec = pow(max(dot(viewDir, reflectDir), 0.0), 128.0); // Compute specular component


						//float light = dot(normal, lightPos); // Simple diffuse lighting
						gl_FragColor = texture2D(tex, v_texCoord) * (ambient + diff + spec);
					}
				}
				else if(showTex){
					gl_FragColor = texture2D(tex, v_texCoord);
				}
				else if(enableLighting){
					if(useGouraud){
						gl_FragColor = v_color;
					}
					else{
						vec3 normal = normalize(v_normal); // Normalize the normal
						vec3 lightdir = normalize(lightPos); // Normalize the light direction
						float diff = max(dot(normal, lightdir), 0.0); // Simple diffuse lighting

						vec3 viewDir = normalize(-v_pos); // We are looking along the z axis
						vec3 reflectDir = reflect(-lightdir, normal); // Compute reflection vector
						float spec = pow(max(dot(viewDir, reflectDir), 0.0), 128.0); // Compute specular component

						gl_FragColor = vec4(vec3(ambient + diff + spec), 1.0);
					}
				}
				else{
					gl_FragColor =  vec4(1.0, 0, 0, 1.0);
				}
			}`;


///////////////////////////////////////////////////////////////////////////////////