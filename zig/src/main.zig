const std = @import("std");
const rl = @import("raylib");

const world_map = [24][24]u32{
    [_]u32{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
    [_]u32{ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    [_]u32{ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    [_]u32{ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    [_]u32{ 1, 0, 0, 0, 0, 0, 2, 2, 2, 2, 2, 0, 0, 0, 0, 3, 0, 3, 0, 3, 0, 0, 0, 1 },
    [_]u32{ 1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    [_]u32{ 1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 3, 0, 0, 0, 3, 0, 0, 0, 1 },
    [_]u32{ 1, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    [_]u32{ 1, 0, 0, 0, 0, 0, 2, 2, 0, 2, 2, 0, 0, 0, 0, 3, 0, 3, 0, 3, 0, 0, 0, 1 },
    [_]u32{ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    [_]u32{ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    [_]u32{ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    [_]u32{ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    [_]u32{ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    [_]u32{ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    [_]u32{ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    [_]u32{ 1, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    [_]u32{ 1, 4, 0, 4, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    [_]u32{ 1, 4, 0, 0, 0, 0, 5, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    [_]u32{ 1, 4, 0, 4, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    [_]u32{ 1, 4, 0, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    [_]u32{ 1, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    [_]u32{ 1, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1 },
    [_]u32{ 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1 },
};

pub fn main() anyerror!void {
    const screen_width = 800;
    const screen_height = 450;

    var pos = rl.Vector2.init(22, 12);
    var dir = rl.Vector2.init(-1, 0);
    var plane = rl.Vector2.init(0, 0.66);

    rl.initWindow(screen_width, screen_height, "raymond");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();

        for (0..screen_width) |x| {
            const camera_x: f64 = 2 * @as(f64, @floatFromInt(x)) / @as(f64, @floatFromInt(screen_width)) - 1;
            const ray_dir = rl.Vector2.init(
                dir.x + plane.x * @as(f32, @floatCast(camera_x)),
                dir.y + plane.y * @as(f32, @floatCast(camera_x)),
            );

            var map_x = @as(i32, @intFromFloat(pos.x));
            var map_y = @as(i32, @intFromFloat(pos.y));

            // Length of ray from current position to next x/y-side
            var side_dist = rl.Vector2.init(0, 0);

            const delta_dist = rl.Vector2.init(
                if (ray_dir.x == 0) 1e30 else @fabs(1 / ray_dir.x),
                if (ray_dir.y == 0) 1e30 else @fabs(1 / ray_dir.y),
            );

            var step_x: i32 = 0;
            var step_y: i32 = 0;

            var hit: bool = false;

            var side: i32 = 0;

            if (ray_dir.x < 0) {
                step_x = -1;
                side_dist.x = (pos.x - @as(f32, @floatFromInt(map_x))) * delta_dist.x;
            } else {
                step_x = 1;
                side_dist.x = (@as(f32, @floatFromInt(map_x)) + 1 - pos.x) * delta_dist.x;
            }

            if (ray_dir.y < 0) {
                step_y = -1;
                side_dist.y = (pos.y - @as(f32, @floatFromInt(map_y))) * delta_dist.y;
            } else {
                step_y = 1;
                side_dist.y = (@as(f32, @floatFromInt(map_y)) + 1 - pos.y) * delta_dist.y;
            }

            while (!hit) {
                if (side_dist.x < side_dist.y) {
                    side_dist.x += delta_dist.x;
                    map_x += step_x;
                    side = 0;
                } else {
                    side_dist.y += delta_dist.y;
                    map_y += step_y;
                    side = 1;
                }

                hit = world_map[@intCast(map_x)][@intCast(map_y)] > 0;
            }

            const perp_wall_dist: f64 = if (side == 0) (side_dist.x - delta_dist.x) else (side_dist.y - delta_dist.y);

            const line_height: i32 = @intFromFloat(@divFloor(
                @as(f32, @floatFromInt(screen_height)),
                perp_wall_dist,
            ));

            var draw_start: i32 = @divFloor(-line_height, 2) + @divFloor(screen_height, 2);
            if (draw_start < 0) {
                draw_start = 0;
            }

            var draw_end: i32 = @divFloor(line_height, 2) + @divFloor(screen_height, 2);
            if (draw_end >= screen_height) {
                draw_end = screen_height - 1;
            }

            var color = switch (world_map[@intCast(map_x)][@intCast(map_y)]) {
                1 => rl.Color.red,
                2 => rl.Color.green,
                3 => rl.Color.blue,
                4 => rl.Color.white,
                else => rl.Color.yellow,
            };

            if (side == 1) {
                color = rl.colorBrightness(color, -0.5);
            }

            rl.drawLine(@intCast(x), draw_start, @intCast(x), draw_end, color);
        }

        rl.drawFPS(screen_width - 100, 50);

        rl.clearBackground(rl.Color.black);

        const frame_time = rl.getFrameTime();
        const move_speed: f32 = frame_time * 5;
        const rot_speed: f32 = frame_time * 3;

        if (rl.isKeyDown(rl.KeyboardKey.key_w)) {
            if (world_map[@intFromFloat(pos.x + dir.x * move_speed)][@intFromFloat(pos.y)] == 0) {
                pos.x += dir.x * move_speed;
            }
            if (world_map[@intFromFloat(pos.x)][@intFromFloat(pos.y + dir.y * move_speed)] == 0) {
                pos.y += dir.y * move_speed;
            }
        }

        if (rl.isKeyDown(rl.KeyboardKey.key_s)) {
            if (world_map[@intFromFloat(pos.x - dir.x * move_speed)][@intFromFloat(pos.y)] == 0) {
                pos.x -= dir.x * move_speed;
            }
            if (world_map[@intFromFloat(pos.x)][@intFromFloat(pos.y - dir.y * move_speed)] == 0) {
                pos.y -= dir.y * move_speed;
            }
        }

        if (rl.isKeyDown(rl.KeyboardKey.key_d)) {
            const old_dir_x = dir.x;
            dir.x = dir.x * @cos(-rot_speed) - dir.y * @sin(-rot_speed);
            dir.y = old_dir_x * @sin(-rot_speed) + dir.y * @cos(-rot_speed);
            const old_plane_x = plane.x;
            plane.x = plane.x * @cos(-rot_speed) - plane.y * @sin(-rot_speed);
            plane.y = old_plane_x * @sin(-rot_speed) + plane.y * @cos(-rot_speed);
        }

        if (rl.isKeyDown(rl.KeyboardKey.key_a)) {
            const old_dir_x = dir.x;
            dir.x = dir.x * @cos(rot_speed) - dir.y * @sin(rot_speed);
            dir.y = old_dir_x * @sin(rot_speed) + dir.y * @cos(rot_speed);
            const old_plane_x = plane.x;
            plane.x = plane.x * @cos(rot_speed) - plane.y * @sin(rot_speed);
            plane.y = old_plane_x * @sin(rot_speed) + plane.y * @cos(rot_speed);
        }
    }
}
