const std = @import("std");
const rl = @import("raylib");

const tg = @import("./texgen.zig");
const oom = @import("./misc.zig").oom;

const window_width = 1280;
const window_height = 960;
const screen_width = 320;
const screen_height = 240;
const tex_width = 64;
const tex_height = 64;
const map_width = 24;
const map_height = 24;

const world_map = [map_width][map_height]u32{
    [_]u32{ 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 7, 7, 7, 7, 7, 7, 7, 7 },
    [_]u32{ 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 7 },
    [_]u32{ 4, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7 },
    [_]u32{ 4, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7 },
    [_]u32{ 4, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 7 },
    [_]u32{ 4, 0, 4, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 5, 7, 7, 0, 7, 7, 7, 7, 7 },
    [_]u32{ 4, 0, 5, 0, 0, 0, 0, 5, 0, 5, 0, 5, 0, 5, 0, 5, 7, 0, 0, 0, 7, 7, 7, 1 },
    [_]u32{ 4, 0, 6, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 5, 7, 0, 0, 0, 0, 0, 0, 8 },
    [_]u32{ 4, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 7, 7, 1 },
    [_]u32{ 4, 0, 8, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 5, 7, 0, 0, 0, 0, 0, 0, 8 },
    [_]u32{ 4, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 5, 7, 0, 0, 0, 7, 7, 7, 1 },
    [_]u32{ 4, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 0, 5, 5, 5, 5, 7, 7, 7, 7, 7, 7, 7, 1 },
    [_]u32{ 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 0, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6 },
    [_]u32{ 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4 },
    [_]u32{ 6, 6, 6, 6, 6, 6, 0, 6, 6, 6, 6, 0, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6, 6 },
    [_]u32{ 4, 4, 4, 4, 4, 4, 0, 4, 4, 4, 6, 0, 6, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3 },
    [_]u32{ 4, 0, 0, 0, 0, 0, 0, 0, 0, 4, 6, 0, 6, 2, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2 },
    [_]u32{ 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6, 2, 0, 0, 5, 0, 0, 2, 0, 0, 0, 2 },
    [_]u32{ 4, 0, 0, 0, 0, 0, 0, 0, 0, 4, 6, 0, 6, 2, 0, 0, 0, 0, 0, 2, 2, 0, 2, 2 },
    [_]u32{ 4, 0, 6, 0, 6, 0, 0, 0, 0, 4, 6, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 2 },
    [_]u32{ 4, 0, 0, 5, 0, 0, 0, 0, 0, 4, 6, 0, 6, 2, 0, 0, 0, 0, 0, 2, 2, 0, 2, 2 },
    [_]u32{ 4, 0, 6, 0, 6, 0, 0, 0, 0, 4, 6, 0, 6, 2, 0, 0, 5, 0, 0, 2, 0, 0, 0, 2 },
    [_]u32{ 4, 0, 0, 0, 0, 0, 0, 0, 0, 4, 6, 0, 6, 2, 0, 0, 0, 0, 0, 2, 0, 0, 0, 2 },
    [_]u32{ 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3 },
};

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    var pos = rl.Vector2.init(22, 11.5); // (X,Y) start position
    var dir = rl.Vector2.init(-1, 0); // Initial direction vector
    var camera_plane = rl.Vector2.init(0, 0.66); // 2D raycaster camera plane

    rl.initWindow(window_width, window_height, "raymond");
    defer rl.closeWindow(); // Close window and OpenGL context

    const buffer = rl.Image{
        .data = @ptrCast(allocator.alloc(rl.Color, screen_width * screen_height) catch |err| oom(err)),
        .width = @intCast(screen_width),
        .height = @intCast(screen_height),
        .format = .pixelformat_uncompressed_r8g8b8a8,
        .mipmaps = 1,
    }; // No need to free since using arena allocator

    const screen_texture = rl.loadTextureFromImage(buffer);
    defer screen_texture.unload();

    var texture = [8]rl.Image{
        tg.genImageDiagonalCross(allocator, tex_width, tex_height),
        tg.genImageSlopedGreyscale(allocator, tex_width, tex_height),
        tg.genImageSlopedYellowGradient(allocator, tex_width, tex_height),
        tg.genImageXorGreyscale(allocator, tex_width, tex_height),
        tg.genImageXorGreen(allocator, tex_width, tex_height),
        tg.genImageRedBricks(allocator, tex_width, tex_height),
        tg.genImageRedGradient(allocator, tex_width, tex_height),
        tg.genImageFlatGrey(allocator, tex_width, tex_height),
    };

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
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
            const old_plane_x = camera_plane.x;
            camera_plane.x = camera_plane.x * @cos(-rot_speed) - camera_plane.y * @sin(-rot_speed);
            camera_plane.y = old_plane_x * @sin(-rot_speed) + camera_plane.y * @cos(-rot_speed);
        }

        if (rl.isKeyDown(rl.KeyboardKey.key_a)) {
            const old_dir_x = dir.x;
            dir.x = dir.x * @cos(rot_speed) - dir.y * @sin(rot_speed);
            dir.y = old_dir_x * @sin(rot_speed) + dir.y * @cos(rot_speed);
            const old_plane_x = camera_plane.x;
            camera_plane.x = camera_plane.x * @cos(rot_speed) - camera_plane.y * @sin(rot_speed);
            camera_plane.y = old_plane_x * @sin(rot_speed) + camera_plane.y * @cos(rot_speed);
        }

        for (0..screen_width) |x| {
            // Clear out buffer with zero values
            rl.imageDrawLine(@constCast(&buffer), @intCast(x), 0, @intCast(x), screen_height, rl.Color.black);

            const camera_x: f64 = 2 * @as(f64, @floatFromInt(x)) / @as(f64, @floatFromInt(screen_width)) - 1;
            const ray_dir = rl.Vector2.init(
                dir.x + camera_plane.x * @as(f32, @floatCast(camera_x)),
                dir.y + camera_plane.y * @as(f32, @floatCast(camera_x)),
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

            const perp_wall_dist: f32 = if (side == 0) (side_dist.x - delta_dist.x) else (side_dist.y - delta_dist.y);

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

            // Texturing calculations
            const tex_num = world_map[@intCast(map_x)][@intCast(map_y)] - 1;

            var wall_x: f32 = if (side == 0) pos.y + perp_wall_dist * ray_dir.y else pos.x + perp_wall_dist * ray_dir.x;
            wall_x -= @floor(wall_x);

            var tex_x: i32 = @intFromFloat(
                wall_x * @as(f32, @floatFromInt(tex_width)),
            );
            if (side == 0 and ray_dir.x > 0) {
                tex_x = tex_width - tex_x - 1;
            }
            if (side == 1 and ray_dir.y < 0) {
                tex_x = tex_width - tex_x - 1;
            }

            const step: f32 = 1.0 * @as(
                f32,
                @floatFromInt(tex_height),
            ) / @as(
                f32,
                @floatFromInt(line_height),
            );

            var tex_pos: f32 = (@as(f32, @floatFromInt(draw_start)) - @as(f32, @floatFromInt(@divFloor(screen_height, 2))) + @as(f32, @floatFromInt(@divFloor(line_height, 2)))) * step;

            // rl.clearBackground(rl.Color.black);
            for (@intCast(draw_start)..@intCast(draw_end)) |y| {
                const tex_y: i32 = @as(i32, @intFromFloat(tex_pos)) & (tex_height - 1);
                tex_pos += step;
                var color = texture[tex_num].getColor(tex_x, tex_y);
                if (side == 1) {
                    color = color.brightness(-0.5);
                }
                rl.imageDrawPixel(@constCast(&buffer), @intCast(x), @intCast(y), color);
            }
        }

        rl.updateTexture(screen_texture, buffer.data);

        {
            rl.beginDrawing();
            defer rl.endDrawing();

            rl.clearBackground(rl.Color.black);
            // rl.drawTexture(screen_texture, 0, 0, rl.Color.white);
            rl.drawTextureEx(
                screen_texture,
                rl.Vector2.init(0, 0),
                0,
                window_width / screen_width,
                rl.Color.white,
            );
            rl.drawFPS(window_width - 100, 50);
        }
    }
}
