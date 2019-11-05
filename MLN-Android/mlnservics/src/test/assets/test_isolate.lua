---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by XiongFangyu.
--- DateTime: 2019-06-18 15:00
---

function in_isolate(n, s, b, t)
    local isolate = require('isolate')
    print('in_isolate-------------------------------------')
    print(n, s, b, t)
    local print_table = require("print_table")
    print_table.print_r(t)
    local code, msg = isolate.callback(n,s,b,t)
    print("callback",code, msg)
    print('in_isolate end-------------------------------------')
end

local isolate = require('isolate')
local data = {t={tt='tt', t2=2}, text="1", a='b', n=1, b=false, c=nil}
local num = 1
local str = 'a'
local bool = true

local function callback(n,s,b,t)
    print('in callback-------------------------------------')
    print(n, s, b, t)
    local print_table = require("print_table")
    print_table.print_r(t)
    print('in callback end-------------------------------------')
end
local code = 0
local msg = nil
code, msg = isolate.registerCallback(callback)
print('registerCallback',code, msg)
code, msg = isolate.create(in_isolate, num, str, bool, data)
print('create', code, msg)
data[0] = 0
data['text'] = 'text'
num = 2
str = 'b'
bool = false