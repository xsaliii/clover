local p = game:GetService("Players")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local ws = game:GetService("Workspace")
local plr = p.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local cam = ws.CurrentCamera
local pgui = plr:FindFirstChildOfClass("PlayerGui") or plr:WaitForChild("PlayerGui")
local sgs = game:GetService("StarterGui")
local cgs = game:GetService("CoreGui")
local rs2 = game:GetService("ReplicatedStorage")

local L = {hit = 0, saved = {}}

local _rawget = rawget
local _rawset = rawset
local _getmetatable = getmetatable
local _setmetatable = setmetatable
local _type = type
local _pcall = pcall

local function banner()
    print([[
$$$$$$$\                                                                    $$\ 
$$  __$$\                                                                   $$ |
$$ |  $$ |$$\   $$\  $$$$$$\   $$$$$$\   $$$$$$$\  $$$$$$$\  $$$$$$\   $$$$$$$ |
$$$$$$$\ |$$ |  $$ |$$  __$$\  \____$$\ $$  _____|$$  _____|$$  __$$\ $$  __$$ |
$$  __$$\ $$ |  $$ |$$ /  $$ | $$$$$$$ |\$$$$$$\  \$$$$$$\  $$$$$$$$ |$$ /  $$ |
$$ |  $$ |$$ |  $$ |$$ |  $$ |$$  __$$ | \____$$\  \____$$\ $$   ____|$$ |  $$ |
$$$$$$$  |\$$$$$$$ |$$$$$$$  |\$$$$$$$ |$$$$$$$  |$$$$$$$  |\$$$$$$$\ \$$$$$$$ |
\_______/  \____$$ |$$  ____/  \_______|\_______/ \_______/  \_______| \_______|
          $$\   $$ |$$ |                                                        
          \$$$$$$  |$$ |                                                        
           \______/ \__|                                                        
]])
    print("bypass by x.saliii")
    print("========================================")
end

local function mt(o)
    if _type(o) ~= "userdata" and _type(o) ~= "table" then return nil end
    local m = _getmetatable(o)
    if _type(m) ~= "table" then return nil end
    return m
end

local function ischeck()
    local st = (debug and debug.traceback) and debug.traceback() or ""
    return st:find("check") or st:find("detect") or st:find("anticheat")
        or st:find("monitor") or st:find("scan") or st:find("verify")
        or st:find("ban") or st:find("kick") or st:find("spy")
end

local function safeSet(t,k,v)
    _pcall(function() _rawset(t,k,v) end)
end

local function safeIndex(t,k)
    local ok,res = _pcall(function() return _rawget(t,k) end)
    if ok then return res end
    return nil
end

local function orig(t, k, oldi)
    if _type(oldi) == "function" then
        return oldi(t, k)
    elseif _type(oldi) == "table" then
        local v = oldi[k]
        return v
    end
    if _type(t) == "table" then
        return _rawget(t, k)
    end
    return nil
end

local function addBypass() L.hit = L.hit + 1 end

_pcall(function()
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
    local hum  = char:FindFirstChildOfClass("Humanoid");   if not hum  then return end
    L.saved.pos = root.Position
    L.saved.hp  = hum.Health
    local m = mt(root); if not m then return end
    local oldi = safeIndex(m,"__index")
    safeSet(m,"__index",function(t,k)
        if ischeck() then
            if k == "Position" then return L.saved.pos end
            if k == "Velocity" then return Vector3.new(0,0,0) end
            if k == "CFrame"   then return CFrame.new(L.saved.pos) end
        end
        return orig(t,k,oldi)
    end)
    _pcall(function() _setmetatable(root,m) end)
    addBypass()
end)

_pcall(function()
    local function hideGui(instance)
        if not instance then return end
        local m = mt(instance); if not m then return end
        local oldi = safeIndex(m,"__index")
        safeSet(m,"__index",function(t,k)
            if ischeck() then
                if k == "GetChildren"    then return function() return {} end end
                if k == "FindFirstChild" then return function() return nil end end
                if k == "GetDescendants" then return function() return {} end end
                if k == "ScreenGui"      then return nil end
            end
            return orig(t,k,oldi)
        end)
        _pcall(function() _setmetatable(instance,m) end)
    end
    hideGui(pgui); hideGui(sgs); hideGui(cgs)
    addBypass()
end)

_pcall(function()
    local all = game:GetDescendants()
    for i = 1, #all do
        local r = all[i]
        if r:IsA("RemoteEvent") or r:IsA("RemoteFunction") then
            _pcall(function()
                local m = mt(r); if not m then return end
                local oldi = safeIndex(m,"__index")
                safeSet(m,"__index",function(t,k)
                    if ischeck() then
                        if k == "FireServer" or k == "InvokeServer" or k == "OnServerEvent" then
                            return function() end
                        end
                    end
                    return orig(t,k,oldi)
                end)
                _pcall(function() _setmetatable(r,m) end)
            end)
        end
    end
    addBypass()
end)

_pcall(function()
    local m = mt(uis); if not m then return end
    local oldi = safeIndex(m,"__index")
    safeSet(m,"__index",function(t,k)
        if k == "IsKeyDown" then
            return function(self,key)
                if ischeck() then
                    local keys = {Enum.KeyCode.W,Enum.KeyCode.A,Enum.KeyCode.S,Enum.KeyCode.D,Enum.KeyCode.Space,Enum.KeyCode.LeftShift}
                    for _, k2 in ipairs(keys) do
                        if key == k2 then return false end
                    end
                end
                local o = orig(t,k,oldi)
                if _type(o) == "function" then return o(self,key) end
                return false
            end
        end
        if k == "GetMouseDelta" then
            return function(self)
                if ischeck() then return Vector2.new(0,0) end
                local o = orig(t,k,oldi)
                if _type(o) == "function" then return o(self) end
                return Vector2.new(0,0)
            end
        end
        return orig(t,k,oldi)
    end)
    _pcall(function() _setmetatable(uis,m) end)
    addBypass()
end)

_pcall(function()
    local mouse = plr:GetMouse()
    if not mouse then return end
    local mm = mt(mouse); if not mm then return end
    local moldi = safeIndex(mm,"__index")
    safeSet(mm,"__index",function(t,k)
        if k == "GetPosition" then
            return function(self)
                if ischeck() then return Vector2.new(960,540) end
                local o = orig(t,k,moldi)
                if _type(o) == "function" then return o(self) end
                return Vector2.new(0,0)
            end
        end
        if k == "Hit" then
            return function(self)
                if ischeck() then return nil end
                local o = orig(t,k,moldi)
                if _type(o) == "function" then return o(self) end
                return nil
            end
        end
        return orig(t,k,moldi)
    end)
    _pcall(function() _setmetatable(mouse,mm) end)
    addBypass()
end)

_pcall(function()
    local oldf = Instance.FindFirstChild
    if oldf then
        Instance.FindFirstChild = function(self, n)
            if ischeck() then
                if self:IsA("PlayerGui") or self:IsA("StarterGui") or self:IsA("CoreGui") then return nil end
                if n and (n:find("Gui") or n:find("Screen")) then return nil end
            end
            return oldf(self, n)
        end
        addBypass()
    end
end)

_pcall(function()
    local oldn = Instance.new
    Instance.new = function(cls, parent)
        if ischeck() then
            if cls == "ScreenGui" or cls == "BillboardGui" or cls == "SurfaceGui" then return nil end
        end
        return oldn(cls, parent)
    end
    addBypass()
end)

_pcall(function()
    local oldw = wait
    wait = function(t)
        if ischeck() then return oldw(t * 20) end
        return oldw(t)
    end
    addBypass()
end)

_pcall(function()
    local oldt = tick
    tick = function()
        if ischeck() then return oldt() + math.random(-10,10) end
        return oldt()
    end
    addBypass()
end)

_pcall(function()
    if task then
        local olds = task.spawn
        task.spawn = function(func, ...)
            local info = debug and debug.getinfo and debug.getinfo(func)
            if info and info.source and (info.source:find("check") or info.source:find("detect")) then
                return
            end
            return olds(func, ...)
        end
        addBypass()
    end
end)

_pcall(function()
    if task then
        local oldw = task.wait
        task.wait = function(t)
            if ischeck() then return oldw(t * 20) end
            return oldw(t)
        end
        addBypass()
    end
end)

_pcall(function()
    local m = mt(plr); if not m then return end
    local oldi = safeIndex(m,"__index")
    safeSet(m,"__index",function(t,k)
        if ischeck() then
            if k == "Team"            then return nil end
            if k == "IsInGroup"       then return function() return false end end
            if k == "GetRankInGroup"  then return function() return 0 end end
            if k == "MembershipType"  then return Enum.MembershipType.None end
            if k == "AccountAge"      then return 365 end
        end
        return orig(t,k,oldi)
    end)
    _pcall(function() _setmetatable(plr,m) end)
    addBypass()
end)

_pcall(function()
    if not cam then return end
    local m = mt(cam); if not m then return end
    local oldi = safeIndex(m,"__index")
    safeSet(m,"__index",function(t,k)
        if ischeck() then
            if k == "CFrame"        then return CFrame.new(L.saved.pos or Vector3.new(0,0,0)) end
            if k == "Position"      then return L.saved.pos or Vector3.new(0,0,0) end
            if k == "Focus"         then return CFrame.new(L.saved.pos or Vector3.new(0,0,0)) end
            if k == "CameraSubject" then return char end
        end
        return orig(t,k,oldi)
    end)
    _pcall(function() _setmetatable(cam,m) end)
    addBypass()
end)

_pcall(function()
    if debug and debug.getinfo then
        local oldi = debug.getinfo
        debug.getinfo = function(...)
            local info = oldi(...)
            if info and info.source and info.source:find("Lume") then
                info.source    = "[C]"
                info.name      = "anonymous"
                info.short_src = "[C]"
            end
            return info
        end
        addBypass()
    end
end)

_pcall(function()
    local oldgf = getfenv
    if oldgf then
        getfenv = function(level)
            if ischeck() then return oldgf(0) end
            return oldgf(level)
        end
        addBypass()
    end
end)

_pcall(function()
    local oldsf = setfenv
    if oldsf then
        setfenv = function(level, env)
            if ischeck() then return oldsf(level, oldsf(0)) end
            return oldsf(level, env)
        end
        addBypass()
    end
end)

_pcall(function()
    local oldr = require
    require = function(module)
        if _type(module) == "string"
           and (module:find("check") or module:find("detect") or module:find("anticheat")) then
            return {}
        end
        return oldr(module)
    end
    addBypass()
end)

_pcall(function()
    local oldl = loadstring
    if oldl then
        loadstring = function(code, chunk)
            if _type(code) == "string"
               and (code:find("check") or code:find("detect") or code:find("anticheat")) then
                return function() end
            end
            return oldl(code, chunk)
        end
        addBypass()
    end
end)

_pcall(function()
    local m = mt(rs2); if not m then return end
    local oldi = safeIndex(m,"__index")
    safeSet(m,"__index",function(t,k)
        if ischeck() then
            if k == "FindFirstChild" then return function() return nil end end
            if k == "GetChildren"    then return function() return {} end end
        end
        return orig(t,k,oldi)
    end)
    _pcall(function() _setmetatable(rs2,m) end)
    addBypass()
end)

_pcall(function()
    plr.CharacterAdded:Connect(function(ch)
        task.wait(0.1)
        char = ch
        L.saved = {}
        _pcall(function()
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then L.saved.pos = root.Position end
        end)
    end)
    addBypass()
end)

banner()
print("========================================")
