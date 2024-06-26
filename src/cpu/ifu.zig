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
const vaddr = @import("../arch/rv64.zig").vaddr;
pub const Mem = @import("../mem.zig").MEM;

pub fn inst_fetch(pc: u64, M: *const [1024]u8) u32 {
    const inst_ptr = M[pc .. pc + 4];
    var inst: u32 = 0;
    for (inst_ptr, 0..) |ptr, i| {
        inst += @as(u32, ptr) << @intCast(i * 8);
    }
    return inst;
}
