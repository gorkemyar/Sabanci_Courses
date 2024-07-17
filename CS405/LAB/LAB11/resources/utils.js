async function loadObjFile(url) {
    const response = await fetch(url);
    const text = await response.text();
    console.log(text)
    return parseObj(text);
}
function parseObj(objString) {
    const vertices = [];
    const textures = [];
    const normals = [];
    const faces = [];

    const lines = objString.split('\n');
    for (let line of lines) {
        const parts = line.trim().split(/\s+/);
        switch (parts[0]) {
            case 'v':
                vertices.push(...parts.slice(1).map(Number));
                break;
            case 'vt':
                textures.push(...parts.slice(1).map(Number));
                break;
            case 'vn':
                normals.push(...parts.slice(1).map(Number));
                break;
            case 'f':
                const faceParts = parts.slice(1).map(p => {
                    // Each part may be in format vertex/texture/normal
                    const [v, vt, vn] = p.split('/').map(Number);
                    return { v, vt, vn };
                });
                // Check if the face is a quad
                if (faceParts.length === 4) {
                    // Split quad into two triangles
                    faces.push([faceParts[0], faceParts[1], faceParts[2]]);
                    faces.push([faceParts[0], faceParts[2], faceParts[3]]);
                } else {
                    // It's already a triangle
                    faces.push(faceParts);
                }
                break;
        }
    }

    return { vertices, textures, normals, faces };
}
