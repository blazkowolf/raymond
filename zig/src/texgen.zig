const std = @import("std");
const rl = @import("raylib");

// const tex_width = 64;
// const tex_height = 64;

fn oom(err: std.mem.Allocator.Error) noreturn {
    _ = err catch {};
    @panic("Out of memory");
}

fn fromRGB(rgb: u24) rl.Color {
    return rl.Color{
        .r = @intCast((rgb >> 16) & 0xFF),
        .g = @intCast((rgb >> 8) & 0xFF),
        .b = @intCast(rgb & 0xFF),
        .a = 0xFF,
    };
}

pub fn genImageDiagonalCross(
    allocator: std.mem.Allocator,
    width: usize,
    height: usize,
) rl.Image {
    var pixels = allocator.alloc(rl.Color, width * height) catch |err| oom(err);

    for (0..height) |y| {
        for (0..width) |x| {
            const cond: u24 = @intCast(@intFromBool(x != y and x != width - y));
            pixels[y * width + x] = fromRGB(65536 * 254 * cond);
        }
    }

    return rl.Image{
        .data = @ptrCast(pixels),
        .width = @intCast(width),
        .height = @intCast(height),
        .format = .pixelformat_uncompressed_r8g8b8a8,
        .mipmaps = 1,
    };
}

pub fn genImageSlopedGreyscale(
    allocator: std.mem.Allocator,
    width: usize,
    height: usize,
) rl.Image {
    var pixels = allocator.alloc(rl.Color, width * height) catch |err| oom(err);

    for (0..height) |y| {
        for (0..width) |x| {
            const xy_color: u24 = @as(u24, @intCast(y)) * 128 / @as(u24, @intCast(height)) + @as(u24, @intCast(x)) * 128 / @as(u24, @intCast(height));
            pixels[y * width + x] = fromRGB(
                xy_color + 256 * xy_color + 65536 * xy_color,
            );
        }
    }

    return rl.Image{
        .data = @ptrCast(pixels),
        .width = @intCast(width),
        .height = @intCast(height),
        .format = .pixelformat_uncompressed_r8g8b8a8,
        .mipmaps = 1,
    };
}

pub fn genImageSlopedYellowGradient(
    allocator: std.mem.Allocator,
    width: usize,
    height: usize,
) rl.Image {
    var pixels = allocator.alloc(rl.Color, width * height) catch |err| oom(err);

    for (0..height) |y| {
        for (0..width) |x| {
            const xy_color: u24 = @as(u24, @intCast(y)) * 128 / @as(u24, @intCast(height)) + @as(u24, @intCast(x)) * 128 / @as(u24, @intCast(height));
            pixels[y * width + x] = fromRGB(256 * xy_color + 65536 * xy_color);
        }
    }

    return rl.Image{
        .data = @ptrCast(pixels),
        .width = @intCast(width),
        .height = @intCast(height),
        .format = .pixelformat_uncompressed_r8g8b8a8,
        .mipmaps = 1,
    };
}

pub fn genImageXorGreyscale(
    allocator: std.mem.Allocator,
    width: usize,
    height: usize,
) rl.Image {
    var pixels = allocator.alloc(rl.Color, width * height) catch |err| oom(err);

    for (0..height) |y| {
        for (0..width) |x| {
            const xor_color: u24 = (@as(u24, @intCast(x)) * 256 / @as(u24, @intCast(width))) ^ (@as(u24, @intCast(y)) * 256 / @as(u24, @intCast(height)));
            pixels[y * width + x] = fromRGB(
                xor_color + 256 * xor_color + 65536 * xor_color,
            );
        }
    }

    return rl.Image{
        .data = @ptrCast(pixels),
        .width = @intCast(width),
        .height = @intCast(height),
        .format = .pixelformat_uncompressed_r8g8b8a8,
        .mipmaps = 1,
    };
}

pub fn genImageXorGreen(
    allocator: std.mem.Allocator,
    width: usize,
    height: usize,
) rl.Image {
    var pixels = allocator.alloc(rl.Color, width * height) catch |err| oom(err);

    for (0..height) |y| {
        for (0..width) |x| {
            const xor_color: u24 = (@as(u24, @intCast(x)) * 256 / @as(u24, @intCast(width))) ^ (@as(u24, @intCast(y)) * 256 / @as(u24, @intCast(height)));
            pixels[y * width + x] = fromRGB(256 * xor_color);
        }
    }

    return rl.Image{
        .data = @ptrCast(pixels),
        .width = @intCast(width),
        .height = @intCast(height),
        .format = .pixelformat_uncompressed_r8g8b8a8,
        .mipmaps = 1,
    };
}

pub fn genImageRedBricks(
    allocator: std.mem.Allocator,
    width: usize,
    height: usize,
) rl.Image {
    var pixels = allocator.alloc(rl.Color, width * height) catch |err| oom(err);

    for (0..height) |y| {
        for (0..width) |x| {
            const cond: u24 = @as(u24, @intCast(@intFromBool(x % 16 != 0 and y % 16 != 0)));
            pixels[y * width + x] = fromRGB(65536 * 192 * cond);
        }
    }

    return rl.Image{
        .data = @ptrCast(pixels),
        .width = @intCast(width),
        .height = @intCast(height),
        .format = .pixelformat_uncompressed_r8g8b8a8,
        .mipmaps = 1,
    };
}

pub fn genImageRedGradient(
    allocator: std.mem.Allocator,
    width: usize,
    height: usize,
) rl.Image {
    var pixels = allocator.alloc(rl.Color, width * height) catch |err| oom(err);

    for (0..height) |y| {
        for (0..width) |x| {
            const y_color: u24 = @as(u24, @intCast(y)) * 256 / @as(u24, @intCast(height));
            pixels[y * width + x] = fromRGB(65536 * y_color);
        }
    }

    return rl.Image{
        .data = @ptrCast(pixels),
        .width = @intCast(width),
        .height = @intCast(height),
        .format = .pixelformat_uncompressed_r8g8b8a8,
        .mipmaps = 1,
    };
}

pub fn genImageFlatGrey(
    allocator: std.mem.Allocator,
    width: usize,
    height: usize,
) rl.Image {
    var pixels = allocator.alloc(rl.Color, width * height) catch |err| oom(err);

    for (0..height) |y| {
        for (0..width) |x| {
            pixels[y * width + x] = fromRGB(128 + 256 * 128 + 65536 * 128);
        }
    }

    return rl.Image{
        .data = @ptrCast(pixels),
        .width = @intCast(width),
        .height = @intCast(height),
        .format = .pixelformat_uncompressed_r8g8b8a8,
        .mipmaps = 1,
    };
}

// pub fn main() anyerror!void {
//     var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
//     defer arena.deinit();
//
//     const allocator = arena.allocator();
//
//     var texture: [8]rl.Texture2D = [_]rl.Texture2D{undefined} ** 8;
//
//     rl.initWindow(1280, 720, "texgen");
//     defer rl.closeWindow();
//
//     const red_black_cross = genImageDiagonalCross(
//         allocator,
//         tex_width,
//         tex_height,
//     );
//     const sloped_greyscale = genImageSlopedGreyscale(
//         allocator,
//         tex_width,
//         tex_height,
//     );
//     const sloped_yellow_gradient = genImageSlopedYellowGradient(
//         allocator,
//         tex_width,
//         tex_height,
//     );
//     const xor_greyscale = genImageXorGreyscale(
//         allocator,
//         tex_width,
//         tex_height,
//     );
//     const xor_green = genImageXorGreen(allocator, tex_width, tex_height);
//     const red_bricks = genImageRedBricks(allocator, tex_width, tex_height);
//     const red_gradient = genImageRedGradient(allocator, tex_width, tex_height);
//     const flat_grey = genImageFlatGrey(allocator, tex_width, tex_height);
//
//     // Doing the following causes double-free error since the arena is freed at the end of the program
//     // defer red_black_cross.unload();
//
//     texture[0] = red_black_cross.toTexture();
//     texture[1] = sloped_greyscale.toTexture();
//     texture[2] = sloped_yellow_gradient.toTexture();
//     texture[3] = xor_greyscale.toTexture();
//     texture[4] = xor_green.toTexture();
//     texture[5] = red_bricks.toTexture();
//     texture[6] = red_gradient.toTexture();
//     texture[7] = flat_grey.toTexture();
//
//     defer texture[0].unload();
//     defer texture[1].unload();
//     defer texture[2].unload();
//     defer texture[3].unload();
//     defer texture[4].unload();
//     defer texture[5].unload();
//     defer texture[6].unload();
//     defer texture[7].unload();
//
//     rl.setTargetFPS(60);
//
//     while (!rl.windowShouldClose()) {
//         rl.beginDrawing();
//         defer rl.endDrawing();
//
//         rl.clearBackground(rl.Color.ray_white);
//
//         for (0..8) |i| {
//             rl.drawTexture(
//                 texture[i],
//                 @as(i32, @intCast(i)) * texture[i].width,
//                 0,
//                 rl.Color.white,
//             );
//         }
//
//         rl.drawFPS(rl.getScreenWidth() - 90, 20);
//     }
// }
