//! # Global variables

/// Window width in pixels (16:9)
pub const window_width = 1600;
/// Window height in pixels (16:9)
pub const window_height = 900;
/// Screen surface buffer width
pub const screen_width = 320;
/// Screen surface buffer height
pub const screen_height = 180;
/// Texture width in same units as `screen_width`/`screen_height`
pub const tex_width = 64;
/// Texture height in same units as `screen_width`/`screen_height`
pub const tex_height = 64;
/// Number of map cells on the x-axis
pub const map_width = 24;
/// Number of map cells on the y-axis
pub const map_height = 24;
/// Number of sprites in the world
pub const num_sprites = 19;
/// Mouse sensitivity coefficient applied on the x-axis
pub const mouse_x_sensitivity: comptime_float = 0.25;
