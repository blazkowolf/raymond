const std = @import("std");
const rl = @import("raylib");
const rlm = @import("raylib-math");

const tg = @import("./texgen.zig");
const oom = @import("./misc.zig").oom;

const window_width = 1600;
const window_height = 900;
const screen_width = 320;
const screen_height = 180;
const tex_width = 64;
const tex_height = 64;
const map_width = 24;
const map_height = 24;
const num_sprites = 19;
const mouse_x_sensitivity: comptime_float = 0.25;

const world_map = [map_width][map_height]u32{
    [_]u32{ 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 4, 4, 6, 4, 4, 6, 4, 6, 4, 4, 4, 6, 4 },
    [_]u32{ 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4 },
    [_]u32{ 8, 0, 3, 3, 0, 0, 0, 0, 0, 8, 8, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6 },
    [_]u32{ 8, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6 },
    [_]u32{ 8, 0, 3, 3, 0, 0, 0, 0, 0, 8, 8, 4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4 },
    [_]u32{ 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 4, 0, 0, 0, 0, 0, 6, 6, 6, 0, 6, 4, 6 },
    [_]u32{ 8, 8, 8, 8, 0, 8, 8, 8, 8, 8, 8, 4, 4, 4, 4, 4, 4, 6, 0, 0, 0, 0, 0, 6 },
    [_]u32{ 7, 7, 7, 7, 0, 7, 7, 7, 7, 0, 8, 0, 8, 0, 8, 0, 8, 4, 0, 4, 0, 6, 0, 6 },
    [_]u32{ 7, 7, 0, 0, 0, 0, 0, 0, 7, 8, 0, 8, 0, 8, 0, 8, 8, 6, 0, 0, 0, 0, 0, 6 },
    [_]u32{ 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 6, 0, 0, 0, 0, 0, 4 },
    [_]u32{ 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 8, 6, 0, 6, 0, 6, 0, 6 },
    [_]u32{ 7, 7, 0, 0, 0, 0, 0, 0, 7, 8, 0, 8, 0, 8, 0, 8, 8, 6, 4, 6, 0, 6, 6, 6 },
    [_]u32{ 7, 7, 7, 7, 0, 7, 7, 7, 7, 8, 8, 4, 0, 6, 8, 4, 8, 3, 3, 3, 0, 3, 3, 3 },
    [_]u32{ 2, 2, 2, 2, 0, 2, 2, 2, 2, 4, 6, 4, 0, 0, 6, 0, 6, 3, 0, 0, 0, 0, 0, 3 },
    [_]u32{ 2, 2, 0, 0, 0, 0, 0, 2, 2, 4, 0, 0, 0, 0, 0, 0, 4, 3, 0, 0, 0, 0, 0, 3 },
    [_]u32{ 2, 0, 0, 0, 0, 0, 0, 0, 2, 4, 0, 0, 0, 0, 0, 0, 4, 3, 0, 0, 0, 0, 0, 3 },
    [_]u32{ 1, 0, 0, 0, 0, 0, 0, 0, 1, 4, 4, 4, 4, 4, 6, 0, 6, 3, 3, 0, 0, 0, 3, 3 },
    [_]u32{ 2, 0, 0, 0, 0, 0, 0, 0, 2, 2, 2, 1, 2, 2, 2, 6, 6, 0, 0, 5, 0, 5, 0, 5 },
    [_]u32{ 2, 2, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 2, 2, 0, 5, 0, 5, 0, 0, 0, 5, 5 },
    [_]u32{ 2, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 2, 5, 0, 5, 0, 5, 0, 5, 0, 5 },
    [_]u32{ 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5 },
    [_]u32{ 2, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 2, 5, 0, 5, 0, 5, 0, 5, 0, 5 },
    [_]u32{ 2, 2, 0, 0, 0, 0, 0, 2, 2, 2, 0, 0, 0, 2, 2, 0, 5, 0, 5, 0, 0, 0, 5, 5 },
    [_]u32{ 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 5, 5, 5, 5, 5, 5, 5, 5, 5 },
};

const Sprite = struct {
    pos: rl.Vector2,
    tex_id: i32,

    fn init(pos: rl.Vector2, tex_id: i32) @This() {
        return .{
            .pos = pos,
            .tex_id = tex_id,
        };
    }
};

const sprite = [num_sprites]Sprite{
    // green light in front of player start position
    Sprite.init(rl.Vector2.init(20.5, 11.5), 10),

    // green lights in every room
    Sprite.init(rl.Vector2.init(18.5, 4.5), 10),
    Sprite.init(rl.Vector2.init(10.0, 4.5), 10),
    Sprite.init(rl.Vector2.init(10.0, 12.5), 10),
    Sprite.init(rl.Vector2.init(3.5, 6.5), 10),
    Sprite.init(rl.Vector2.init(3.5, 20.5), 10),
    Sprite.init(rl.Vector2.init(3.5, 14.5), 10),
    Sprite.init(rl.Vector2.init(14.5, 20.5), 10),

    // row of pillars in front of wall: fisheye test
    Sprite.init(rl.Vector2.init(18.5, 10.5), 9),
    Sprite.init(rl.Vector2.init(18.5, 11.5), 9),
    Sprite.init(rl.Vector2.init(18.5, 12.5), 9),

    // some barrels around the map
    Sprite.init(rl.Vector2.init(21.5, 1.5), 8),
    Sprite.init(rl.Vector2.init(15.5, 1.5), 8),
    Sprite.init(rl.Vector2.init(16.0, 1.8), 8),
    Sprite.init(rl.Vector2.init(16.2, 1.2), 8),
    Sprite.init(rl.Vector2.init(3.5, 2.5), 8),
    Sprite.init(rl.Vector2.init(9.5, 15.5), 8),
    Sprite.init(rl.Vector2.init(10.0, 15.1), 8),
    Sprite.init(rl.Vector2.init(10.5, 15.8), 8),
};

const CellTag = enum {
    wall,
    empty,
};

const Wall = struct {};
const Empty = struct {};

const Cell = union(CellTag) {
    wall: Wall,
    empty: Empty,
};

const Side = enum {
    horizontal, // North/South
    vertical, // East/West
};

pub fn main() anyerror!void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const allocator = arena.allocator();

    var pos = rl.Vector2.init(22, 11.5); // (X,Y) start position
    var dir = rl.Vector2.init(-1, 0); // Initial direction vector
    var camera_plane = rl.Vector2.init(0, 0.66); // 2D raycaster camera plane

    rl.setConfigFlags(@enumFromInt(
        @intFromEnum(rl.ConfigFlags.flag_msaa_4x_hint) |
            @intFromEnum(rl.ConfigFlags.flag_vsync_hint),
    ));
    rl.initWindow(window_width, window_height, "raymond");
    defer rl.closeWindow(); // Close window and OpenGL context

    rl.disableCursor();

    rl.setWindowMonitor(rl.getCurrentMonitor());

    const buffer = rl.Image{
        .data = @ptrCast(allocator.alloc(rl.Color, screen_width * screen_height) catch |err| oom(err)),
        .width = @intCast(screen_width),
        .height = @intCast(screen_height),
        .format = .pixelformat_uncompressed_r8g8b8a8,
        .mipmaps = 1,
    }; // No need to free since using arena allocator

    const screen_texture = rl.loadTextureFromImage(buffer);
    defer screen_texture.unload();

    var texture = [11]rl.Image{
        // Textures
        rl.loadImage("../pics/eagle.png"),
        rl.loadImage("../pics/redbrick.png"),
        rl.loadImage("../pics/purplestone.png"),
        rl.loadImage("../pics/greystone.png"),
        rl.loadImage("../pics/bluestone.png"),
        rl.loadImage("../pics/mossy.png"),
        rl.loadImage("../pics/wood.png"),
        rl.loadImage("../pics/colorstone.png"),
        // Sprites
        rl.loadImage("../pics/barrel.png"),
        rl.loadImage("../pics/pillar.png"),
        rl.loadImage("../pics/greenlight.png"),
    };

    rl.setTargetFPS(60);

    while (!rl.windowShouldClose()) {
        const delta_time = rl.getFrameTime();
        const move_speed: f32 = delta_time * 5;
        const rot_speed: f32 = delta_time * 3;

        const forward = rl.isKeyDown(.key_w) or rl.isKeyDown(.key_up);
        const backward = rl.isKeyDown(.key_s) or rl.isKeyDown(.key_down);
        const strafe_right = rl.isKeyDown(.key_d);
        const strafe_left = rl.isKeyDown(.key_a);
        const rotate_right = rl.isKeyDown(.key_right);
        const rotate_left = rl.isKeyDown(.key_left);

        if (forward) {
            if (world_map[@intFromFloat(pos.x + dir.x * move_speed)][@intFromFloat(pos.y)] == 0) {
                pos.x += dir.x * move_speed;
            }
            if (world_map[@intFromFloat(pos.x)][@intFromFloat(pos.y + dir.y * move_speed)] == 0) {
                pos.y += dir.y * move_speed;
            }
        }

        if (strafe_right) {
            if (world_map[@intFromFloat(pos.x + camera_plane.x * move_speed)][@intFromFloat(pos.y)] == 0) {
                pos.x += camera_plane.x * move_speed;
            }
            if (world_map[@intFromFloat(pos.x)][@intFromFloat(pos.y + camera_plane.y * move_speed)] == 0) {
                pos.y += camera_plane.y * move_speed;
            }
        }

        if (backward) {
            if (world_map[@intFromFloat(pos.x - dir.x * move_speed)][@intFromFloat(pos.y)] == 0) {
                pos.x -= dir.x * move_speed;
            }
            if (world_map[@intFromFloat(pos.x)][@intFromFloat(pos.y - dir.y * move_speed)] == 0) {
                pos.y -= dir.y * move_speed;
            }
        }

        if (strafe_left) {
            if (world_map[@intFromFloat(pos.x - camera_plane.x * move_speed)][@intFromFloat(pos.y)] == 0) {
                pos.x -= camera_plane.x * move_speed;
            }
            if (world_map[@intFromFloat(pos.x)][@intFromFloat(pos.y - camera_plane.y * move_speed)] == 0) {
                pos.y -= camera_plane.y * move_speed;
            }
        }

        if (rotate_right) {
            dir = rlm.vector2Rotate(dir, -rot_speed);
            camera_plane = rlm.vector2Rotate(camera_plane, -rot_speed);
        }

        if (rotate_left) {
            dir = rlm.vector2Rotate(dir, rot_speed);
            camera_plane = rlm.vector2Rotate(camera_plane, rot_speed);
        }

        // Mouse look
        const mouse_delta = rl.getMouseDelta();
        if (rlm.vector2Equals(mouse_delta, rlm.vector2Zero()) == 0) {
            // Negate mouse delta to move in correct direction
            const speed: f32 = -mouse_delta.x * delta_time * mouse_x_sensitivity;
            dir = rlm.vector2Rotate(dir, speed);
            camera_plane = rlm.vector2Rotate(camera_plane, speed);
        }

        rl.imageClearBackground(@constCast(&buffer), rl.Color.black);

        // Floor casting
        for ((@divFloor(screen_height, 2) + 1)..screen_height) |y| {
            // Ray direction for leftmost ray (x = 0) and rightmost ray (x = w)
            const ray_dir_left = rlm.vector2Subtract(dir, camera_plane);
            const ray_dir_right = rlm.vector2Add(dir, camera_plane);

            // Current y-position compared to the center of the screen (the horizon)
            const p: i32 = @as(i32, @intCast(y)) - @divFloor(screen_height, 2);

            // Vertical position of the camera
            const camera_pos_z: f32 = 0.5 * @as(
                f32,
                @floatFromInt(screen_height),
            );

            // Horizontal distance from the camera to the floor for the current row.
            // 0.5 is the z-position exactly in the middle between floor and ceiling.
            const row_dist: f32 = camera_pos_z / @as(f32, @floatFromInt(p));

            // Calculate the real word step vector we have to add for each x (parallel to the camera plane).
            // Adding step-by-step avoids multiplications with a weight in the inner loop.
            const ray_dir_delta = rlm.vector2Subtract(
                ray_dir_right,
                ray_dir_left,
            );

            const floor_step = rlm.vector2Divide(
                rlm.vector2Scale(ray_dir_delta, row_dist),
                rl.Vector2.init(
                    @floatFromInt(screen_width),
                    @floatFromInt(screen_width),
                ),
            );

            // Real world coordinates of the leftmost column.
            // This will be updated as we step to the right.
            var floor = rlm.vector2Add(
                pos,
                rlm.vector2Scale(ray_dir_left, row_dist),
            );

            for (0..screen_width) |x| {
                // The cell coordinate is simply gotten from the integer parts of floor.x and floor.y
                const cell_x: i32 = @intFromFloat(floor.x);
                const cell_y: i32 = @intFromFloat(floor.y);

                // Get the texture coordinate from the fractional part
                const tx: i32 = @as(i32, @intFromFloat(@as(f32, @floatFromInt(tex_width)) * (floor.x - @as(f32, @floatFromInt(cell_x))))) & (tex_width - 1);
                const ty: i32 = @as(i32, @intFromFloat(@as(f32, @floatFromInt(tex_height)) * (floor.y - @as(f32, @floatFromInt(cell_y))))) & (tex_height - 1);

                floor = rlm.vector2Add(floor, floor_step);

                // Choose texture and draw the pixel
                const floor_tex_id: u32 = 3;
                const ceil_tex_id: u32 = 6;

                var color: rl.Color = undefined;

                // Floor
                color = texture[floor_tex_id].getColor(tx, ty).brightness(-0.5);
                rl.imageDrawPixel(
                    @constCast(&buffer),
                    @intCast(x),
                    @intCast(y),
                    color,
                );

                // Ceiling (symmetrical, at screen_height - y - 1 instead of y)
                color = texture[ceil_tex_id].getColor(tx, ty).brightness(-0.5);
                rl.imageDrawPixel(
                    @constCast(&buffer),
                    @intCast(x),
                    @intCast(screen_height - y - 1),
                    color,
                );
            }
        }

        // Wall casting
        for (0..screen_width) |x| {
            const camera_x: f32 = 2 * @as(f32, @floatFromInt(x)) / @as(f32, @floatFromInt(screen_width)) - 1;
            const ray_dir = rlm.vector2Add(
                dir,
                rlm.vector2Scale(camera_plane, camera_x),
            );

            var map_x: i32 = @intFromFloat(pos.x);
            var map_y: i32 = @intFromFloat(pos.y);

            // Length of ray from current position to next x/y-side
            var side_dist = rlm.vector2Zero();

            const delta_dist = rl.Vector2.init(
                if (ray_dir.x == 0) 1e30 else @fabs(1 / ray_dir.x),
                if (ray_dir.y == 0) 1e30 else @fabs(1 / ray_dir.y),
            );

            var step_x: i32 = undefined;
            var step_y: i32 = undefined;

            var hit: bool = false;

            var side: Side = undefined;

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
                    side = .vertical;
                } else {
                    side_dist.y += delta_dist.y;
                    map_y += step_y;
                    side = .horizontal;
                }

                hit = world_map[@intCast(map_x)][@intCast(map_y)] > 0;
            }

            const perp_wall_dist: f32 = if (side == .vertical) (side_dist.x - delta_dist.x) else (side_dist.y - delta_dist.y);

            const line_height: i32 = @intFromFloat(@divFloor(
                @as(f32, @floatFromInt(screen_height)) * 1.333333333, // Approximate ratio to acheive equal wall width/height
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

            var wall_x: f32 = if (side == .vertical) pos.y + perp_wall_dist * ray_dir.y else pos.x + perp_wall_dist * ray_dir.x;
            wall_x -= @floor(wall_x);

            var tex_x: i32 = @intFromFloat(
                wall_x * @as(f32, @floatFromInt(tex_width)),
            );
            if (side == .vertical and ray_dir.x > 0) {
                tex_x = tex_width - tex_x - 1;
            }
            if (side == .horizontal and ray_dir.y < 0) {
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

            for (@intCast(draw_start)..@intCast(draw_end)) |y| {
                const tex_y: i32 = @as(i32, @intFromFloat(tex_pos)) & (tex_height - 1);
                tex_pos += step;
                var color = texture[tex_num].getColor(tex_x, tex_y);
                if (side == .horizontal) {
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
            rl.drawTextureEx(
                screen_texture,
                rl.Vector2.init(0, 0),
                0,
                window_width / screen_width,
                rl.Color.white,
            );
            rl.drawFPS(window_width - 100, 20);
        }
    }
}
