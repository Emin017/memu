// Copyright (c) 2024 Emin
// MEMU is licensed under Mulan PSL v2.
// You can use this software according to the terms and conditions of the Mulan PSL v2.
// You may obtain a copy of Mulan PSL v2 at:
//          http://license.coscl.org.cn/MulanPSL2
// THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND,
// EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT,
// MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
// See the Mulan PSL v2 for more details.

const std = @import("std");
const c = @import("cpu/cpu.zig");
const halt = @import("cpu/exu.zig").isHalt;

pub const reg_display = @import("cpu/reg.zig").reg_display;
pub const inst_cycle = @import("cpu/exu.zig").exu_cycle;

pub fn main() void {
    c.cpu.pc = 0;
    while (!halt()) {
        inst_cycle();
        c.cpu.pc += 4;
    }
    reg_display();
}
