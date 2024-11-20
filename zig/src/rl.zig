pub const Color = extern struct {
    r: u8,
    g: u8,
    b: u8,
    a: u8,

    pub const light_gray = Color.init(200, 200, 200, 255);
    pub const gray = Color.init(130, 130, 130, 255);
    pub const dark_gray = Color.init(80, 80, 80, 255);
    pub const yellow = Color.init(253, 249, 0, 255);
    pub const gold = Color.init(255, 203, 0, 255);
    pub const orange = Color.init(255, 161, 0, 255);
    pub const pink = Color.init(255, 109, 194, 255);
    pub const red = Color.init(230, 41, 55, 255);
    pub const maroon = Color.init(190, 33, 55, 255);
    pub const green = Color.init(0, 228, 48, 255);
    pub const lime = Color.init(0, 158, 47, 255);
    pub const dark_green = Color.init(0, 117, 44, 255);
    pub const sky_blue = Color.init(102, 191, 255, 255);
    pub const blue = Color.init(0, 121, 241, 255);
    pub const dark_blue = Color.init(0, 82, 172, 255);
    pub const purple = Color.init(200, 122, 255, 255);
    pub const violet = Color.init(135, 60, 190, 255);
    pub const dark_purple = Color.init(112, 31, 126, 255);
    pub const beige = Color.init(211, 176, 131, 255);
    pub const brown = Color.init(127, 106, 79, 255);
    pub const dark_brown = Color.init(76, 63, 47, 255);

    pub const white = Color.init(255, 255, 255, 255);
    pub const black = Color.init(0, 0, 0, 255);
    pub const blank = Color.init(0, 0, 0, 0);
    pub const magenta = Color.init(255, 0, 255, 255);
    pub const ray_white = Color.init(245, 245, 245, 255);

    pub fn init(r: u8, g: u8, b: u8, a: u8) Color {
        return Color{ .r = r, .g = g, .b = b, .a = a };
    }

    pub fn brightness(self: Color, factor: f32) Color {
        return ColorBrightness(self, factor);
    }
};

pub const Vector2 = extern struct {
    x: f32,
    y: f32,

    pub fn init(x: f32, y: f32) Vector2 {
        return .{ .x = x, .y = y };
    }

    pub fn zero() Vector2 {
        return Vector2Zero();
    }

    pub fn add(v1: Vector2, v2: Vector2) Vector2 {
        return Vector2Add(v1, v2);
    }

    pub fn subtract(v1: Vector2, v2: Vector2) Vector2 {
        return Vector2Subtract(v1, v2);
    }

    pub fn scale(v: Vector2, s: f32) Vector2 {
        return Vector2Scale(v, s);
    }

    pub fn divide(v1: Vector2, v2: Vector2) Vector2 {
        return Vector2Divide(v1, v2);
    }

    pub fn rotate(v: Vector2, angle: f32) Vector2 {
        return Vector2Rotate(v, angle);
    }

    pub fn equals(v1: Vector2, v2: Vector2) i32 {
        return @intCast(Vector2Equals(v1, v2));
    }
};

pub const ConfigFlags = packed struct {
    __reserved: bool = false,
    fullscreen_mode: bool = false,
    window_resizable: bool = false,
    window_undecorated: bool = false,
    window_transparent: bool = false,
    msaa_4x_hint: bool = false,
    vsync_hint: bool = false,
    window_hidden: bool = false,
    window_always_run: bool = false,
    window_minimized: bool = false,
    window_maximized: bool = false,
    window_unfocused: bool = false,
    window_topmost: bool = false,
    window_highdpi: bool = false,
    window_mouse_passthrough: bool = false,
    borderless_windowed_mode: bool = false,
    interlaced_hint: bool = false,
    __reserved2: bool = false,
    __reserved3: bool = false,
    __reserved4: bool = false,
    __reserved5: bool = false,
    __reserved6: bool = false,
    __reserved7: bool = false,
    __reserved8: bool = false,
    __reserved9: bool = false,
    __reserved10: bool = false,
    __reserved11: bool = false,
    __reserved12: bool = false,
    __reserved13: bool = false,
    __reserved14: bool = false,
    __reserved15: bool = false,
    __reserved16: bool = false,
};

pub const PixelFormat = enum(c_int) {
    uncompressed_grayscale = 1,
    uncompressed_gray_alpha = 2,
    uncompressed_r5g6b5 = 3,
    uncompressed_r8g8b8 = 4,
    uncompressed_r5g5b5a1 = 5,
    uncompressed_r4g4b4a4 = 6,
    uncompressed_r8g8b8a8 = 7,
    uncompressed_r32 = 8,
    uncompressed_r32g32b32 = 9,
    uncompressed_r32g32b32a32 = 10,
    uncompressed_r16 = 11,
    uncompressed_r16g16b16 = 12,
    uncompressed_r16g16b16a16 = 13,
    compressed_dxt1_rgb = 14,
    compressed_dxt1_rgba = 15,
    compressed_dxt3_rgba = 16,
    compressed_dxt5_rgba = 17,
    compressed_etc1_rgb = 18,
    compressed_etc2_rgb = 19,
    compressed_etc2_eac_rgba = 20,
    compressed_pvrt_rgb = 21,
    compressed_pvrt_rgba = 22,
    compressed_astc_4x4_rgba = 23,
    compressed_astc_8x8_rgba = 24,
};

pub const Image = extern struct {
    data: *anyopaque,
    width: c_int,
    height: c_int,
    mipmaps: c_int,
    format: PixelFormat,

    pub fn init(file_name: []const u8) Image {
        return LoadImage(@ptrCast(file_name));
    }

    pub fn genColor(width: i32, height: i32, color: Color) Image {
        return GenImageColor(@intCast(width), @intCast(height), color);
    }

    pub fn unload(self: Image) void {
        UnloadImage(self);
    }

    pub fn clearBackground(self: *Image, color: Color) void {
        ImageClearBackground(@ptrCast(self), color);
    }

    pub fn drawPixel(self: *Image, x: i32, y: i32, color: Color) void {
        ImageDrawPixel(@ptrCast(self), @intCast(x), @intCast(y), color);
    }

    pub fn getColor(self: Image, x: i32, y: i32) Color {
        return GetImageColor(self, @intCast(x), @intCast(y));
    }
};

pub const Texture = extern struct {
    id: c_uint,
    width: c_int,
    height: c_int,
    mipmaps: c_int,
    format: PixelFormat,

    pub fn fromImage(image: Image) Texture {
        return LoadTextureFromImage(image);
    }

    pub fn unload(self: Texture) void {
        UnloadTexture(self);
    }

    pub fn update(self: Texture, pixels: *const anyopaque) void {
        UpdateTexture(self, pixels);
    }

    pub fn drawEx(
        self: Texture, 
        position: Vector2, 
        rotation: f32, 
        scale: f32, 
        tint: Color,
    ) void {
        DrawTextureEx(self, position, rotation, scale, tint);
    }
};

pub const Texture2D = Texture;

pub const KeyboardKey = enum(c_int) {
    @"null" = 0,
    apostrophe = 39,
    comma = 44,
    minus = 45,
    period = 46,
    slash = 47,
    zero = 48,
    one = 49,
    two = 50,
    three = 51,
    four = 52,
    five = 53,
    six = 54,
    seven = 55,
    eight = 56,
    nine = 57,
    semicolon = 59,
    equal = 61,
    a = 65,
    b = 66,
    c = 67,
    d = 68,
    e = 69,
    f = 70,
    g = 71,
    h = 72,
    i = 73,
    j = 74,
    k = 75,
    l = 76,
    m = 77,
    n = 78,
    o = 79,
    p = 80,
    q = 81,
    r = 82,
    s = 83,
    t = 84,
    u = 85,
    v = 86,
    w = 87,
    x = 88,
    y = 89,
    z = 90,
    space = 32,
    escape = 256,
    enter = 257,
    tab = 258,
    backspace = 259,
    insert = 260,
    delete = 261,
    right = 262,
    left = 263,
    down = 264,
    up = 265,
    page_up = 266,
    page_down = 267,
    home = 268,
    end = 269,
    caps_lock = 280,
    scroll_lock = 281,
    num_lock = 282,
    print_screen = 283,
    pause = 284,
    f1 = 290,
    f2 = 291,
    f3 = 292,
    f4 = 293,
    f5 = 294,
    f6 = 295,
    f7 = 296,
    f8 = 297,
    f9 = 298,
    f10 = 299,
    f11 = 300,
    f12 = 301,
    left_shift = 340,
    left_control = 341,
    left_alt = 342,
    left_super = 343,
    right_shift = 344,
    right_control = 345,
    right_alt = 346,
    right_super = 347,
    kb_menu = 348,
    left_bracket = 91,
    backslash = 92,
    right_bracket = 93,
    grave = 96,
    kp_0 = 320,
    kp_1 = 321,
    kp_2 = 322,
    kp_3 = 323,
    kp_4 = 324,
    kp_5 = 325,
    kp_6 = 326,
    kp_7 = 327,
    kp_8 = 328,
    kp_9 = 329,
    kp_decimal = 330,
    kp_divide = 331,
    kp_multiply = 332,
    kp_subtract = 333,
    kp_add = 334,
    kp_enter = 335,
    kp_equal = 336,
    back = 4,
    //menu = 82,
    volume_up = 24,
    volume_down = 25,
};

extern "c" fn InitWindow(width: c_int, height: c_int, title: [*c]const u8) void;
pub fn initWindow(width: usize, height: usize, title: []const u8) void {
    InitWindow(@intCast(width), @intCast(height), @ptrCast(title));
}

extern "c" fn CloseWindow() void;
pub fn closeWindow() void {
    CloseWindow();
}

extern "c" fn SetTargetFPS(fps: c_int) void;
pub fn setTargetFPS(fps: usize) void {
    SetTargetFPS(@intCast(fps));
}

extern "c" fn SetConfigFlags(flags: ConfigFlags) void;
pub fn setConfigFlags(flags: ConfigFlags) void {
    SetConfigFlags(flags);
}

extern "c" fn GetCurrentMonitor() c_int;
pub fn getCurrentMonitor() i32 {
    return @intCast(GetCurrentMonitor());
}

extern "c" fn SetWindowMonitor(monitor: c_int) void;
pub fn setWindowMonitor(monitor: i32) void {
    SetWindowMonitor(@intCast(monitor));
}

extern "c" fn DisableCursor() void;
pub fn disableCursor() void {
    DisableCursor();
}

extern "c" fn WindowShouldClose() bool;
pub fn windowShouldClose() bool {
    return WindowShouldClose();
}

extern "c" fn BeginDrawing() void;
pub fn beginDrawing() void {
    BeginDrawing();
}

extern "c" fn EndDrawing() void;
pub fn endDrawing() void {
    EndDrawing();
}

extern "c" fn ClearBackground(color: Color) void;
pub fn clearBackground(color: Color) void {
    ClearBackground(color);
}

extern "c" fn DrawText(text: [*c]const u8, posX: c_int, posY: c_int, fontSize: c_int, color: Color) void;
pub fn drawText(text: []const u8, pos_x: i32, pos_y: i32, font_size: usize, color: Color) void {
    DrawText(@ptrCast(text), @intCast(pos_x), @intCast(pos_y), @intCast(font_size), color);
}

extern "c" fn DrawFPS(posX: c_int, posY: c_int) void;
pub fn drawFPS(x: i32, y: i32) void {
    DrawFPS(@intCast(x), @intCast(y));
}

extern "c" fn GetFrameTime() f32;
pub fn getFrameTime() f32 {
    return GetFrameTime();
}

extern "c" fn IsKeyDown(key: KeyboardKey) bool;
pub fn isKeyDown(key: KeyboardKey) bool {
    return IsKeyDown(key);
}

extern "c" fn GetMouseDelta() Vector2;
pub fn getMouseDelta() Vector2 {
    return GetMouseDelta();
}

extern "c" fn ColorBrightness(color: Color, factor: f32) Color;

extern "c" fn LoadImage(fileName: [*c]const u8) Image;
extern "c" fn UnloadImage(image: Image) void;
extern "c" fn ImageClearBackground(image: [*c]Image, color: Color) void;
extern "c" fn ImageDrawPixel(image: [*c]Image, x: c_int, y: c_int, color: Color) void;
extern "c" fn GenImageColor(width: c_int, height: c_int, color: Color) Image;
extern "c" fn GetImageColor(image: Image, x: c_int, y: c_int) Color;

extern "c" fn LoadTextureFromImage(image: Image) Texture2D;
extern "c" fn UnloadTexture(texture: Texture2D) void;
extern "c" fn UpdateTexture(texture: Texture2D, pixels: *const anyopaque) void;
extern "c" fn DrawTextureEx(texture: Texture2D, position: Vector2, rotation: f32, scale: f32, tint: Color) void;

extern "c" fn Vector2Zero() Vector2;
extern "c" fn Vector2Add(v1: Vector2, v2: Vector2) Vector2;
extern "c" fn Vector2Subtract(v1: Vector2, v2: Vector2) Vector2;
extern "c" fn Vector2Scale(v: Vector2, scale: f32) Vector2;
extern "c" fn Vector2Divide(v1: Vector2, v2: Vector2) Vector2;
extern "c" fn Vector2Rotate(v: Vector2, angle: f32) Vector2;
extern "c" fn Vector2Equals(v1: Vector2, v2: Vector2) c_int;
