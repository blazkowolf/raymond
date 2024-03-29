package main

import "core:fmt"
import m "core:math"
import ml "core:math/linalg"
import rl "vendor:raylib"

SCREEN_WIDTH, SCREEN_HEIGHT :: 1280, 720
MAP_WIDTH, MAP_HEIGHT :: 24, 24

world_map := [MAP_WIDTH][MAP_HEIGHT]i32 {
	{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 0, 0, 0, 0, 3, 0, 3, 0, 3, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 2, 2, 0, 2, 2, 0, 0, 0, 0, 3, 0, 3, 0, 3, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 4, 0, 4, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 4, 0, 0, 0, 0, 5, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 4, 0, 4, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 4, 0, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1},
	{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
}

// WallKind :: union {
// 	Empty,
// }

Player :: struct {
	pos, dir: ml.Vector2f32,
}

Camera :: struct {
	pos, plane: ml.Vector2f32,
}

player := Player{}
camera := rl.Camera2D{}

main :: proc() {
	player.pos.x, player.pos.y = 22, 12  // x and y start position
	player.dir.x, player.dir.y = -1, 0  // Initial direction vector
	camera_plane_x, camera_plane_y: f32 = 0, .66 // 2D raycaster version of camera plane
	camera.zoom = 1.0

	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "raymond")
	defer rl.CloseWindow()

	rl.SetTargetFPS(60)

	for !rl.WindowShouldClose() {
		rl.BeginDrawing(); defer rl.EndDrawing()

		rl.ClearBackground(rl.BLACK)

		rl.BeginMode2D(camera); defer rl.EndMode2D()

		for x in 0 ..< SCREEN_WIDTH {
			// Calculate the ray position and direction
			camera.target.x = 2 * f32(x) / f32(SCREEN_WIDTH) - 1

			ray_dir := ml.Vector2f32{}
			ray_dir.x = player.dir.x + camera_plane_x * camera.target.x
			ray_dir.y = player.dir.y + camera_plane_y * camera.target.x

			// Which box of the map we're in
			map_x, map_y := i32(player.pos.x), i32(player.pos.y)

			// Length of ray from current position to next x or y-side
			side_dist := ml.Vector2f32{}

			// Length of ray from one x or y-side to next x or y-side
			delta_dist := get_delta_dist(ray_dir)

			// What direction to step in x or y-direction (either +1 or -1)
			step_x, step_y: i32

			hit: bool // Was there a wall hit?
			side: u32 // Was a north/south or an east/west wall hit?

			if ray_dir.x < 0 {
				step_x = -1
				side_dist.x = (player.pos.x - f32(map_x)) * delta_dist.x
			} else {
				step_x = 1
				side_dist.x = (f32(map_x) + 1.0 - player.pos.x) * delta_dist.x
			}

			if ray_dir.y < 0 {
				step_y = -1
				side_dist.y = (player.pos.y - f32(map_y)) * delta_dist.y
			} else {
				step_y = 1
				side_dist.y = (f32(map_y) + 1.0 - player.pos.y) * delta_dist.y
			}

			// Perform DDA
			for hit == false {
				// Jump to next map square, either in x or y-direction
				if side_dist.x < side_dist.y {
					side_dist.x += delta_dist.x
					map_x += step_x
					side = 0
				} else {
					side_dist.y += delta_dist.y
					map_y += step_y
					side = 1
				}

				// Check if ray hit a will
				if world_map[map_x][map_y] > 0 do hit = true
			}

			// Calculate distance projected on camera direction (Euclidean distance gives fisheye effect!)
			// perp_wall_dist := (side_dist.x - delta_dist.x) if side == 0 else (side_dist.y - delta_dist.y)
			perp_wall_dist: f32
			if side == 0 do perp_wall_dist = (side_dist.x - delta_dist.x)
			else do perp_wall_dist = (side_dist.y - delta_dist.y)

			// Calculate line height to draw on screen
			line_height := u32(SCREEN_HEIGHT / perp_wall_dist)

			// Calculate lowest and highest pixel to fill current stripe
			draw_start: i32 = max(0, (-line_height / 2 + SCREEN_HEIGHT / 2))
			draw_end: i32 = min(SCREEN_HEIGHT - 1, (line_height / 2 + SCREEN_HEIGHT / 2))
			// draw_start: i32 = -line_height / 2 + SCREEN_HEIGHT / 2
			// if draw_start < 0 do draw_start = 0
			// draw_end: i32 = line_height / 2 + SCREEN_HEIGHT / 2
			// if draw_end >= SCREEN_HEIGHT do draw_end = SCREEN_HEIGHT - 1

			// Choose wall color
			color: rl.Color
			switch world_map[map_x][map_y] {
			case 1: color = rl.RED
			case 2: color = rl.GREEN
			case 3: color = rl.BLUE
			case 4: color = rl.WHITE
			case:   color = rl.YELLOW
			}

			// Give x and y sides different brightness
			if side == 1 {
				color = rl.ColorBrightness(color, -0.5)
			}

			rl.DrawLine(x, draw_start, x, draw_end, color)
		}

		rl.DrawText(fmt.ctprintf("FPS: %v", rl.GetFPS()), SCREEN_WIDTH - 100, 50, 20, rl.WHITE)

		frame_time := rl.GetFrameTime()

		// Speed modifiers
		move_speed, rot_speed := frame_time * 5.0, frame_time * 3.0

		// Move forward if no wall is in front of you
		if rl.IsKeyDown(rl.KeyboardKey.W) || rl.IsKeyDown(rl.KeyboardKey.UP) {
			if world_map[cast(i32) (player.pos.x + player.dir.x * move_speed)][i32(player.pos.y)] == 0 {
				player.pos.x += player.dir.x * move_speed
			}
			if world_map[i32(player.pos.x)][cast(i32) (player.pos.y + player.dir.y * move_speed)] == 0 {
				player.pos.y += player.dir.y * move_speed
			}
		}

		// Move backwards if no wall is behind you
		if rl.IsKeyDown(rl.KeyboardKey.S) || rl.IsKeyDown(rl.KeyboardKey.DOWN) {
			if world_map[cast(i32) (player.pos.x - player.dir.x * move_speed)][i32(player.pos.y)] == 0 {
				player.pos.x -= player.dir.x * move_speed
			}
			if world_map[i32(player.pos.x)][cast(i32) (player.pos.y - player.dir.y * move_speed)] == 0 {
				player.pos.y -= player.dir.y * move_speed
			}
		}

		// Rotate to the right
		if rl.IsKeyDown(rl.KeyboardKey.RIGHT) {
			odir_x := player.dir.x
			player.dir.x = player.dir.x * m.cos(-rot_speed) - player.dir.y * m.sin(-rot_speed)
			player.dir.y = odir_x * m.sin(-rot_speed) + player.dir.y * m.cos(-rot_speed)
			oplane_x := camera_plane_x
			camera_plane_x = camera_plane_x * m.cos(-rot_speed) - camera_plane_y * m.sin(-rot_speed)
			camera_plane_y = oplane_x * m.sin(-rot_speed) + camera_plane_y * m.cos(-rot_speed)
		}

		// Rotate to the left
		if rl.IsKeyDown(rl.KeyboardKey.LEFT) {
			odir_x := player.dir.x
			player.dir.x = player.dir.x * m.cos(rot_speed) - player.dir.y * m.sin(rot_speed)
			player.dir.y = odir_x * m.sin(rot_speed) + player.dir.y * m.cos(rot_speed)
			oplane_x := camera_plane_x
			camera_plane_x = camera_plane_x * m.cos(rot_speed) - camera_plane_y * m.sin(rot_speed)
			camera_plane_y = oplane_x * m.sin(rot_speed) + camera_plane_y * m.cos(rot_speed)
		}
	}
}

get_delta_dist :: proc(ray_dir: ml.Vector2f32) -> (delta_dist: ml.Vector2f32) {
	// delta_dist.x = 1e30 if ray_dir.x == 0 else abs(1 / ray_dir.x)
	// delta_dist.y = 1e30 if ray_dir.y == 0 else abs(1 / ray_dir.y)
	delta_dist.x = m.sqrt(1 + (ray_dir.y * ray_dir.y) / (ray_dir.x * ray_dir.x))
	delta_dist.y = m.sqrt(1 + (ray_dir.x * ray_dir.x) / (ray_dir.y * ray_dir.y))
	return
}

