import './style.css';
import * as THREE from 'three';
import {
    OrbitControls
} from 'three/examples/jsm/controls/OrbitControls'

import vertex from './shaders/vertex.glsl';
import fragment from './shaders/fragment.glsl';


function main() {
    const canvas = document.querySelector('#canvas');
    const renderer = new THREE.WebGLRenderer({
        canvas
    });

    const fov = 75;
    const aspect = 2; // the canvas default
    const near = 0.1;
    const far = 1000;
    const camera = new THREE.PerspectiveCamera(fov, aspect, near, far);
    camera.position.z = 10;

    const scene = new THREE.Scene();

    const planeWidth = 10;
    const planeHeight = 10;
    const planeWidthSegments = 100;
    const planeHeightegments = 100;
    const planeGeometry = new THREE.PlaneGeometry(planeWidth, planeHeight, planeWidthSegments, planeHeightegments);

    const axis = new THREE.AxesHelper(10);
    scene.add(axis);
    
    const uniforms = {
        uTime: { value: 0 },
    }

    const planeMaterial = new THREE.ShaderMaterial({
        wireframe: false,
        transparent: true,
        side: THREE.DoubleSide,
        depthTest: true,
        depthWrite: false,
        uniforms,
        vertexShader: vertex,
        fragmentShader: fragment
    })

    const plane = new THREE.Mesh(planeGeometry, planeMaterial);

    scene.add(plane);

    const color = 0xFFFFFF;
    const intensity = 1;
    const light = new THREE.DirectionalLight(color, intensity);
    light.position.set(-1, 2, 4);
    scene.add(light);

    renderer.render(scene, camera);

    function resizeRendererToDisplaySize(renderer) {
        const canvas = renderer.domElement;
        const pixelRatio = window.devicePixelRatio;
        const width = canvas.clientWidth * pixelRatio | 0;
        const height = canvas.clientHeight * pixelRatio | 0;
        const needResize = canvas.width !== width || canvas.height !== height;
        if (needResize) {
            renderer.setSize(width, height, false);
        }
        return needResize;
    }

    const controls = new OrbitControls( camera, renderer.domElement );

    function render(time) {
        time *= 0.001; // convert time to seconds

        plane.material.uniforms.uTime.value = time;

        if (resizeRendererToDisplaySize(renderer)) {
            const canvas = renderer.domElement;
            camera.aspect = canvas.clientWidth / canvas.clientHeight;
            camera.updateProjectionMatrix();
        }

        controls.update();

        renderer.render(scene, camera);

        requestAnimationFrame(render);
    }
    requestAnimationFrame(render);
}

main();