const std = @import("std");

const Raymond = @This();

pub const State = union(enum) {
    title: void,
    playing: void,
    paused: void,
    game_over: void,

    pub fn update(self: *State, context: *Raymond, delta_time: f32) ?State {
        _ = self;
        _ = context;
        _ = delta_time;
        return null;
    }

    pub fn draw(self: State) void {
        _ = self;
    }
};

// Fields

/// Current application state
state: State,

pub fn init(initial_state: State) Raymond {
    return .{ .state = initial_state };
}

pub fn update(self: *Raymond, delta_time: f32) void {
    const new_state = self.state.update(self, delta_time);
    if (new_state) |s| {
        self.state = s;
    }
}

pub fn draw(self: Raymond) void {
    self.state.draw();
}

test "Raymond init sets state" {
    const raymond = Raymond.init(.title);
    try std.testing.expectEqual(raymond.state, .title);
}

test "Raymond update doesn't change state when null" {
    var raymond = Raymond.init(.title);
    raymond.update(0);
    try std.testing.expectEqual(raymond.state, .title);
}
