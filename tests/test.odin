package tests

import r3d "../"
import "core:log"
import "core:testing"
import "core:time"
import rl "vendor:raylib"


@(test)
initial_test :: proc(t: ^testing.T) {
	log.info("STARTING TEST")
	rl.InitWindow(640, 480, "Hello")
	rl.SetTargetFPS(60)
	r3d.Init(640, 480, .FXAA + .Aspect_Keep)

	mesh := r3d.GenMeshSphere(1.0, 16, 32, true)
	material := r3d.GetDefaultMaterial()

	// Setup lighting
	light := r3d.CreateLight(.DIR)
	r3d.SetLightDirection(light, rl.Vector3{-1, -1, -1})
	r3d.SetLightActive(light, true)

	// Camera setup
	camera := rl.Camera3D {
		position   = {-10, 10, 10},
		target     = {0, 0, 0},
		up         = {0, 1, 0},
		fovy       = 60.0,
		projection = .PERSPECTIVE,
	}

	// Main loop
	start := time.now()
	for time.duration_seconds(time.diff(start, time.now())) < 5 {
		rl.BeginDrawing()
		rl.ClearBackground(rl.BLACK)
		r3d.Begin(camera)
		r3d.DrawMesh(&mesh, &material, rl.Matrix(1))
		r3d.End()
		rl.EndDrawing()
	}

	r3d.UnloadMesh(&mesh)
	r3d.Close()
	rl.CloseWindow()
}
