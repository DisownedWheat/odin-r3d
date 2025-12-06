package tests

import r3d "../"
import rl "../raylib"
import "core:log"
import "core:testing"
import "core:time"


@(test)
initial_test :: proc(t: ^testing.T) {
	log.info("STARTING TEST")
	rl.InitWindow(800, 600, "Test")
	rl.SetTargetFPS(60)

	r3d.Init(800, 600, .NONE)

	plane := r3d.GenMeshPlane(1000, 1000, 1, 1, true)
	sphere := r3d.GenMeshSphere(0.5, 64, 64, true)
	material := r3d.GetDefaultMaterial()

	r3d.SetAmbientColor({100, 100, 100, 255})
	light := r3d.CreateLight(.SPOT)

	{
		r3d.LightLookAt(light, {0, 10, 5}, {0, 0, 0})
		r3d.EnableShadow(light, 4096)
		r3d.SetLightActive(light, true)
	}

	// Camera setup
	camera := rl.Camera3D {
		position   = {0, 2, 2},
		target     = {0, 0, 0},
		up         = {0, 1, 0},
		fovy       = 60.0,
		projection = .PERSPECTIVE,
	}

	// Main loop
	start := time.now()
	for time.duration_seconds(time.diff(start, time.now())) < 10 {
		rl.UpdateCamera(&camera, .ORBITAL)
		rl.BeginDrawing()
		r3d.Begin(camera)
		r3d.DrawMesh(&plane, &material, rl.MatrixTranslate(0, -0.5, 0))
		r3d.DrawMesh(&sphere, &material, rl.MatrixTranslate(0, 0, 0))
		r3d.End()

		rl.DrawFPS(10, 10)

		buttonValue := rl.GuiMessageBox(
			{50, 50, 200, 100},
			"Hello",
			"This is a message",
			"OK;Cancel",
		)
		if buttonValue > 0 {
			log.info(buttonValue)
		}
		rl.EndDrawing()
	}

	r3d.UnloadMesh(&sphere)
	r3d.UnloadMesh(&plane)
	r3d.Close()
	rl.CloseWindow()
}
