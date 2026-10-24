local CentrixUI = {}
CentrixUI.Version = "4.7.0"

local DEFAULT_LUCIDE_URL = "https://raw.githubusercontent.com/xsaliii/clover/refs/heads/main/ui/lucide_icon.lua"

local function SafeClone(inst)
    if type(cloneref) == "function" then
        local ok, res = pcall(cloneref, inst)
        if ok and res then return res end
    end
    return inst
end

local function SafeService(name)
    return SafeClone(game:GetService(name))
end

local function HighIdentity()
    if type(setthreadidentity) == "function" then
        pcall(setthreadidentity, 7)
    elseif type(syn) == "table" and type(syn.set_thread_identity) == "function" then
        pcall(syn.set_thread_identity, 7)
    end
end

local function ResetIdentity()
    if type(setthreadidentity) == "function" then
        pcall(setthreadidentity, 2)
    elseif type(syn) == "table" and type(syn.set_thread_identity) == "function" then
        pcall(syn.set_thread_identity, 2)
    end
end

local HiddenParent, UsedHidden = (function()
    if type(gethui) == "function" then
        local ok, h = pcall(gethui)
        if ok and h then return h, true end
    end
    if type(get_hidden_gui) == "function" then
        local ok, h = pcall(get_hidden_gui)
        if ok and h then return h, true end
    end
    return nil, false
end)()

local FAKE_GUI_NAMES = {
    "RobloxGui", "PlayerList", "RobloxLoadingScreen",
    "PurchasePrompt", "NotificationLayer", "RobloxPromptGui",
}

local function RandomGuiName()
    return FAKE_GUI_NAMES[math.random(1, #FAKE_GUI_NAMES)]
end

local function CreateSpoofedGui(realName)
    local gui = Instance.new("ScreenGui")
    gui.Name = UsedHidden and realName or RandomGuiName()
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 9999
    gui.IgnoreGuiInset = true
    if UsedHidden then
        gui.Parent = HiddenParent
    else
        local core = SafeService("CoreGui")
        HighIdentity()
        pcall(function() gui.Parent = core end)
        ResetIdentity()
        if syn and type(syn.protect_gui) == "function" then
            pcall(syn.protect_gui, gui)
        elseif type(protect_gui) == "function" then
            pcall(protect_gui, gui)
        elseif type(getgenv) == "function" and getgenv() and type(getgenv().protect_gui) == "function" then
            pcall(getgenv().protect_gui, gui)
        end
    end
    return gui
end

local TweenService = SafeService("TweenService")
local RunService = SafeService("RunService")
local UserInputService = SafeService("UserInputService")
local Players = SafeService("Players")
local CoreGui = SafeService("CoreGui")
local Lighting = SafeService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local FONT = Font.new("rbxasset://fonts/families/GothamSSm.json")
local FONT_TITLE = Font.new("rbxassetid://12187365364")
local FONT_BOLD = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
local FONT_MEDIUM = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)

local Assets = {}
local AssetsLoaded = false
local AssetsLoading = false
local AssetsWaiters = {}

local function LoadAssets(url)
    if AssetsLoaded or AssetsLoading then return end
    AssetsLoading = true
    task.spawn(function()
        local ok, tbl = pcall(function()
            local fn = loadstring(game:HttpGet(url or DEFAULT_LUCIDE_URL))
            if not fn then return nil end
            return fn()
        end)
        if ok and type(tbl) == "table" then
            for k, v in pairs(tbl) do Assets[k] = v end
        end
        AssetsLoaded = true
        AssetsLoading = false
        for _, cb in ipairs(AssetsWaiters) do
            pcall(cb)
        end
        AssetsWaiters = {}
    end)
end

local function OnAssetsReady(cb)
    if AssetsLoaded then
        cb()
        return
    end
    table.insert(AssetsWaiters, cb)
    LoadAssets(nil)
end

local function New(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then
            pcall(function() inst[k] = v end)
        end
    end
    for _, child in ipairs(children or {}) do
        if child then child.Parent = inst end
    end
    if props and props.Parent then
        inst.Parent = props.Parent
    end
    return inst
end

local function Tween(inst, time, props, style, dir)
    if not inst or not inst.Parent then return end
    local ok, t = pcall(function()
        return TweenService:Create(inst, TweenInfo.new(time or 0.2, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), props)
    end)
    if ok and t then
        t:Play()
        return t
    end
    return nil
end

local function Round(n, r)
    if not r or r == 0 then return math.floor(n + 0.5) end
    local m = 10 ^ r
    return math.floor(n * m + 0.5) / m
end

local function MakeRipple(frame, input, color)
    if not frame or not input then return end
    local ok, ax = pcall(function() return frame.AbsolutePosition end)
    if not ok or not ax then return end
    local x = input.Position.X - ax.X
    local y = input.Position.Y - ax.Y
    local w = frame.AbsoluteSize.X
    local h = frame.AbsoluteSize.Y
    if w <= 0 or h <= 0 then return end
    local maxSize = math.max(w, h) * 2.2
    local ripple = New("Frame", {
        Size = UDim2.fromOffset(0, 0),
        Position = UDim2.fromOffset(x, y),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = color or Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.8,
        ZIndex = 10,
        BorderSizePixel = 0,
        Parent = frame
    }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })
    Tween(ripple, 0.55, {
        Size = UDim2.fromOffset(maxSize, maxSize),
        BackgroundTransparency = 1
    })
    task.delay(0.6, function()
        if ripple and ripple.Parent then ripple:Destroy() end
    end)
end

local FileIO = { CanSave = false, CanLoad = false, CanList = false, CanDelete = false }
do
    local okWrite = pcall(function() return typeof(writefile) end)
    local okMake = pcall(function() return typeof(makefolder) end)
    local okIsFolder = pcall(function() return typeof(isfolder) end)
    local okRead = pcall(function() return typeof(readfile) end)
    local okIsFile = pcall(function() return typeof(isfile) end)
    local okList = pcall(function() return typeof(listfiles) end)
    local okDel = pcall(function() return typeof(delfile) end)
    FileIO.CanSave = okWrite and okMake and okIsFolder and typeof(writefile) == "function" and typeof(makefolder) == "function" and typeof(isfolder) == "function"
    FileIO.CanLoad = okRead and okIsFile and typeof(readfile) == "function" and typeof(isfile) == "function"
    FileIO.CanList = okList and typeof(listfiles) == "function"
    FileIO.CanDelete = okDel and typeof(delfile) == "function"
end

function FileIO.EnsureFolder(name)
    if not FileIO.CanSave then return false end
    local ok, exists = pcall(isfolder, name)
    if ok and exists then return true end
    return pcall(makefolder, name)
end

function FileIO.Write(path, content)
    if not FileIO.CanSave then return false end
    return pcall(writefile, path, content)
end

function FileIO.Read(path)
    if not FileIO.CanLoad then return nil end
    local ok, exists = pcall(isfile, path)
    if not ok or not exists then return nil end
    local ok2, content = pcall(readfile, path)
    if ok2 then return content end
    return nil
end

function FileIO.ListFiles(folder)
    if not FileIO.CanList then return {} end
    local ok, files = pcall(listfiles, folder)
    return (ok and files) or {}
end

function FileIO.DeleteFile(path)
    if not FileIO.CanDelete then return false end
    return pcall(delfile, path)
end

local function LoadAssetAsync(url, callback)
    if not url or url == "" or type(url) ~= "string" then
        return callback(nil)
    end
    if url:sub(1, 11) == "rbxassetid:" or url:sub(1, 11) == "rbxasset://" then
        return callback(url)
    end
    if url:sub(1, 4) ~= "http" then
        return callback("rbxassetid://" .. url)
    end
    task.spawn(function()
        local asset = nil
        local hasCustom = typeof(getcustomasset) == "function"
        local hasWrite = typeof(writefile) == "function"
        local hasFile = typeof(isfile) == "function"
        if hasCustom and hasWrite and hasFile then
            local hashNum = 5381
            for i = 1, #url do
                hashNum = ((hashNum * 33) + url:byte(i)) % 2147483647
            end
            local filename = "centrix_" .. tostring(hashNum) .. ".png"
            local exists = false
            pcall(function() exists = isfile(filename) end)
            if not exists then
                local okFetch, body = pcall(function() return game:HttpGet(url) end)
                if okFetch and body and type(body) == "string" and #body > 0 then
                    local okWrite = pcall(writefile, filename, body)
                    if okWrite then exists = true end
                end
            end
            if exists then
                local okAsset, result = pcall(getcustomasset, filename)
                if okAsset and result and type(result) == "string" then
                    asset = result
                end
            end
        end
        callback(asset)
    end)
end

function CentrixUI:GetIcon(name)
    if not name or type(name) ~= "string" then return nil end
    if name:sub(1, 11) == "rbxassetid:" or name:sub(1, 11) == "rbxasset://" then
        return name
    end
    if name:sub(1, 4) == "http" then
        return name
    end
    return Assets[name] or Assets["lucide-" .. name]
end

function CentrixUI:ResolveIcon(icon, callback)
    if not icon or icon == "" or type(icon) ~= "string" then
        return callback(nil)
    end
    if icon:sub(1, 11) == "rbxassetid:" or icon:sub(1, 11) == "rbxasset://" then
        return callback(icon)
    end
    if icon:sub(1, 4) == "http" then
        return LoadAssetAsync(icon, callback)
    end
    local found = Assets[icon] or Assets["lucide-" .. icon]
    if found then
        return callback(found)
    end
    task.spawn(function()
        OnAssetsReady(function()
            local found2 = Assets[icon] or Assets["lucide-" .. icon]
            callback(found2)
        end)
    end)
end

function CentrixUI:ListIcons()
    local list = {}
    for k, _ in pairs(Assets) do
        if k:sub(1, 7) == "lucide-" then
            table.insert(list, k)
        end
    end
    table.sort(list)
    return list
end

function CentrixUI:PreloadIcon(url, callback)
    return LoadAssetAsync(url, callback)
end

function CentrixUI:EnsureAssetsLoaded()
    LoadAssets(nil)
end

local Themes = {}

Themes.Dark = {
    Name = "Dark",
    Accent = Color3.fromRGB(255, 255, 255),
    AccentContrast = Color3.fromRGB(0, 0, 0),
    Background = Color3.fromRGB(10, 10, 10),
    Background2 = Color3.fromRGB(18, 18, 18),
    Border = Color3.fromRGB(38, 38, 38),
    InnerBorder = Color3.fromRGB(52, 52, 52),
    TitleBarLine = Color3.fromRGB(26, 26, 26),
    Tab = Color3.fromRGB(200, 200, 200),
    Element = Color3.fromRGB(255, 255, 255),
    ElementBorder = Color3.fromRGB(38, 38, 38),
    ElementTransparency = 0.94,
    Hover = Color3.fromRGB(255, 255, 255),
    HoverChange = 0.06,
    Text = Color3.fromRGB(245, 245, 245),
    SubText = Color3.fromRGB(140, 140, 140),
    ToggleSlider = Color3.fromRGB(150, 150, 150),
    ToggleToggled = Color3.fromRGB(255, 255, 255),
    ToggleOn = Color3.fromRGB(34, 197, 94),
    ToggleOff = Color3.fromRGB(55, 55, 55),
    SliderRail = Color3.fromRGB(45, 45, 45),
    DropdownFrame = Color3.fromRGB(30, 30, 30),
    DropdownHolder = Color3.fromRGB(16, 16, 16),
    DropdownBorder = Color3.fromRGB(45, 45, 45),
    DropdownOption = Color3.fromRGB(255, 255, 255),
    Keybind = Color3.fromRGB(30, 30, 30),
    Input = Color3.fromRGB(30, 30, 30),
    InputFocused = Color3.fromRGB(22, 22, 22),
    InputIndicator = Color3.fromRGB(255, 255, 255),
    Dialog = Color3.fromRGB(16, 16, 16),
    DialogHolder = Color3.fromRGB(10, 10, 10),
    DialogHolderLine = Color3.fromRGB(32, 32, 32),
    DialogButton = Color3.fromRGB(30, 30, 30),
    DialogButtonBorder = Color3.fromRGB(55, 55, 55),
    DialogBorder = Color3.fromRGB(45, 45, 45),
    DialogInput = Color3.fromRGB(24, 24, 24),
    DialogInputLine = Color3.fromRGB(255, 255, 255),
    Ripple = Color3.fromRGB(255, 255, 255),
    Success = Color3.fromRGB(76, 175, 80),
    Warning = Color3.fromRGB(240, 200, 100),
    Error = Color3.fromRGB(211, 47, 47),
    Info = Color3.fromRGB(200, 200, 200),
    Shadow = Color3.fromRGB(0, 0, 0),
}

Themes.Light = {
    Name = "Light",
    Accent = Color3.fromRGB(0, 0, 0),
    AccentContrast = Color3.fromRGB(255, 255, 255),
    Background = Color3.fromRGB(252, 252, 252),
    Background2 = Color3.fromRGB(244, 244, 244),
    Border = Color3.fromRGB(216, 216, 216),
    InnerBorder = Color3.fromRGB(200, 200, 200),
    TitleBarLine = Color3.fromRGB(228, 228, 228),
    Tab = Color3.fromRGB(70, 70, 70),
    Element = Color3.fromRGB(0, 0, 0),
    ElementBorder = Color3.fromRGB(216, 216, 216),
    ElementTransparency = 0.95,
    Hover = Color3.fromRGB(0, 0, 0),
    HoverChange = 0.05,
    Text = Color3.fromRGB(15, 15, 15),
    SubText = Color3.fromRGB(120, 120, 120),
    ToggleSlider = Color3.fromRGB(255, 255, 255),
    ToggleToggled = Color3.fromRGB(255, 255, 255),
    ToggleOn = Color3.fromRGB(34, 197, 94),
    ToggleOff = Color3.fromRGB(200, 200, 200),
    SliderRail = Color3.fromRGB(215, 215, 215),
    DropdownFrame = Color3.fromRGB(242, 242, 242),
    DropdownHolder = Color3.fromRGB(252, 252, 252),
    DropdownBorder = Color3.fromRGB(215, 215, 215),
    DropdownOption = Color3.fromRGB(0, 0, 0),
    Keybind = Color3.fromRGB(242, 242, 242),
    Input = Color3.fromRGB(242, 242, 242),
    InputFocused = Color3.fromRGB(234, 234, 234),
    InputIndicator = Color3.fromRGB(0, 0, 0),
    Dialog = Color3.fromRGB(252, 252, 252),
    DialogHolder = Color3.fromRGB(245, 245, 245),
    DialogHolderLine = Color3.fromRGB(228, 228, 228),
    DialogButton = Color3.fromRGB(240, 240, 240),
    DialogButtonBorder = Color3.fromRGB(210, 210, 210),
    DialogBorder = Color3.fromRGB(216, 216, 216),
    DialogInput = Color3.fromRGB(242, 242, 242),
    DialogInputLine = Color3.fromRGB(0, 0, 0),
    Ripple = Color3.fromRGB(0, 0, 0),
    Success = Color3.fromRGB(76, 175, 80),
    Warning = Color3.fromRGB(200, 150, 60),
    Error = Color3.fromRGB(211, 47, 47),
    Info = Color3.fromRGB(80, 80, 80),
    Shadow = Color3.fromRGB(0, 0, 0),
}

Themes.Minimal = Themes.Dark
Themes.MinimalLight = Themes.Light

local ThemePresets = { Dark = {}, Light = {} }
for k, v in pairs(Themes.Dark) do ThemePresets.Dark[k] = v end
for k, v in pairs(Themes.Light) do ThemePresets.Light[k] = v end

local ThemeOverrides = {}
local Registry = {}
local CurrentTheme = "Dark"
local ActiveWindow = nil

local function ContrastFor(c)
    local lum = 0.299 * c.R + 0.587 * c.G + 0.114 * c.B
    if lum > 0.55 then return Color3.new(0, 0, 0) end
    return Color3.new(1, 1, 1)
end

local function GetTheme(key)
    local t = Themes[CurrentTheme]
    if t and t[key] ~= nil then return t[key] end
    return Themes.Dark[key]
end

local function Register(obj, tag)
    if not tag or not obj then return obj end
    local entry = { Object = obj, Properties = tag }
    table.insert(Registry, entry)
    for prop, key in pairs(tag) do
        local v = GetTheme(key)
        if v ~= nil then pcall(function() obj[prop] = v end) end
    end
    return obj
end

local function OverrideTag(obj, tag)
    for _, entry in ipairs(Registry) do
        if entry.Object == obj then
            entry.Properties = tag
            for prop, key in pairs(tag) do
                local v = GetTheme(key)
                if v ~= nil then pcall(function() entry.Object[prop] = v end) end
            end
            return obj
        end
    end
    return Register(obj, tag)
end

local function UpdateTheme()
    for i = #Registry, 1, -1 do
        local entry = Registry[i]
        if not entry.Object or not entry.Object.Parent then
            table.remove(Registry, i)
        else
            for prop, key in pairs(entry.Properties) do
                local v = GetTheme(key)
                if v ~= nil then pcall(function() entry.Object[prop] = v end) end
            end
        end
    end
end

local function ClearRegistry()
    for i = #Registry, 1, -1 do
        table.remove(Registry, i)
    end
end

function CentrixUI:SetTheme(name)
    if not Themes[name] then return end
    CurrentTheme = name
    UpdateTheme()
end

function CentrixUI:GetTheme() return CurrentTheme end

function CentrixUI:SetAccentColor(color)
    if typeof(color) ~= "Color3" then return end
    for name, t in pairs(Themes) do
        ThemeOverrides[name] = ThemeOverrides[name] or {}
        ThemeOverrides[name].Accent = color
        ThemeOverrides[name].AccentContrast = ContrastFor(color)
        t.Accent = color
        t.AccentContrast = ContrastFor(color)
    end
    UpdateTheme()
end

function CentrixUI:OverrideTheme(key, value)
    if key == nil then return end
    local t = Themes[CurrentTheme]
    if not t then return end
    ThemeOverrides[CurrentTheme] = ThemeOverrides[CurrentTheme] or {}
    ThemeOverrides[CurrentTheme][key] = value
    t[key] = value
    UpdateTheme()
end

function CentrixUI:ResetThemeOverride(key)
    if key then
        for name in pairs(ThemeOverrides) do
            ThemeOverrides[name][key] = nil
            if ThemePresets[name] then Themes[name][key] = ThemePresets[name][key] end
        end
    else
        for name in pairs(ThemeOverrides) do ThemeOverrides[name] = nil end
        for name, preset in pairs(ThemePresets) do
            if Themes[name] then
                for k, v in pairs(preset) do Themes[name][k] = v end
            end
        end
    end
    UpdateTheme()
end

function CentrixUI:GetThemeOverrides()
    return ThemeOverrides[CurrentTheme] or {}
end

local Acrylic = { Enabled = false, Effect = nil }

function Acrylic.Enable()
    if Acrylic.Effect then return end
    local e = Instance.new("DepthOfFieldEffect")
    e.Name = "CentrixUI_Acrylic"
    e.FarIntensity = 0
    e.InFocusRadius = 0.1
    e.NearIntensity = 0.85
    e.Parent = Lighting
    Acrylic.Effect = e
    Acrylic.Enabled = true
end

function Acrylic.Disable()
    if Acrylic.Effect then
        Acrylic.Effect:Destroy()
        Acrylic.Effect = nil
    end
    Acrylic.Enabled = false
end

local function SafeCallback(fn, ...)
    if not fn then return end
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("[CentrixUI] Callback error: " .. tostring(err))
    end
end

local function SerializeValue(el)
    if el.ConfigType == "Toggle" then
        return el:GetValue() and "true" or "false"
    elseif el.ConfigType == "Slider" then
        return tostring(el:GetValue())
    elseif el.ConfigType == "Input" then
        local v = tostring(el:GetValue() or "")
        return (v:gsub("\n", "\\n"))
    elseif el.ConfigType == "Dropdown" then
        if el:IsMulti() then
            local parts = {}
            for k, _ in pairs(el:GetValue()) do table.insert(parts, k) end
            return table.concat(parts, "\1")
        else
            return tostring(el:GetValue() or "")
        end
    elseif el.ConfigType == "Keybind" then
        return tostring(el:GetValue())
    elseif el.ConfigType == "Colorpicker" then
        local c = el:GetValue()
        return string.format("%d,%d,%d,%d", math.floor(c.R * 255), math.floor(c.G * 255), math.floor(c.B * 255), math.floor((el:GetTransparency() or 0) * 100))
    end
    return ""
end

local function DeserializeValue(el, raw)
    if el.ConfigType == "Toggle" then
        el:SetValue(raw == "true", true)
    elseif el.ConfigType == "Slider" then
        local n = tonumber(raw)
        if n then el:SetValue(n, true) end
    elseif el.ConfigType == "Input" then
        el:SetValue((raw:gsub("\\n", "\n")), true)
    elseif el.ConfigType == "Dropdown" then
        if el:IsMulti() then
            local t = {}
            for part in raw:gmatch("[^\1]+") do table.insert(t, part) end
            el:SetValue(t, true)
        else
            if raw ~= "" then el:SetValue(raw, true) end
        end
    elseif el.ConfigType == "Keybind" then
        el:SetValue(raw)
    elseif el.ConfigType == "Colorpicker" then
        local r, g, b, a = raw:match("^(%d+),(%d+),(%d+),(%d+)$")
        if r and g and b then
            local c = Color3.fromRGB(tonumber(r), tonumber(g), tonumber(b))
            local tr = a and (tonumber(a) / 100) or 0
            el:SetValue(c, tr, true)
        end
    end
end

local function CreateElement(title, desc, parent, interactable, rippleColor, icon)
    local self = {}

    local Frame = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = GetTheme("Element"),
        BackgroundTransparency = GetTheme("ElementTransparency"),
        Text = "",
        AutoButtonColor = false,
        ClipsDescendants = true,
        Parent = parent
    }, {
        New("UICorner", { CornerRadius = UDim.new(0, 8) }),
        New("UIStroke", {
            Color = GetTheme("ElementBorder"),
            Transparency = 0.5,
            Thickness = 1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        })
    })
    Register(Frame, { BackgroundColor3 = "Element", BackgroundTransparency = "ElementTransparency" })

    local hasIcon = icon ~= nil
    local IconImage
    local LabelHolder = New("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(hasIcon and 42 or 14, 0),
        Size = UDim2.new(1, hasIcon and -62 or -34, 0, 0),
        Parent = Frame
    }, {
        New("UIListLayout", {
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 2)
        }),
        New("UIPadding", {
            PaddingTop = UDim.new(0, 14),
            PaddingBottom = UDim.new(0, 14)
        })
    })

    if hasIcon then
        IconImage = New("ImageLabel", {
            Image = "",
            ImageColor3 = GetTheme("SubText"),
            Size = UDim2.fromOffset(18, 18),
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 14, 0.5, 0),
            BackgroundTransparency = 1,
            Parent = Frame
        })
        Register(IconImage, { ImageColor3 = "SubText" })
        CentrixUI:ResolveIcon(icon, function(asset)
            if asset and IconImage and IconImage.Parent then
                IconImage.Image = asset
            end
        end)
    end

    local TitleLabel = New("TextLabel", {
        FontFace = FONT_MEDIUM,
        Text = title,
        TextColor3 = GetTheme("Text"),
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        Parent = LabelHolder
    })
    Register(TitleLabel, { TextColor3 = "Text" })

    local DescLabel = New("TextLabel", {
        FontFace = FONT,
        Text = desc or "",
        TextColor3 = GetTheme("SubText"),
        TextSize = 12,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        AutomaticSize = Enum.AutomaticSize.Y,
        Size = UDim2.fromOffset(180, 14),
        BackgroundTransparency = 1,
        Visible = (desc and desc ~= "") and true or false,
        Parent = LabelHolder
    })
    Register(DescLabel, { TextColor3 = "SubText" })

    self.Frame = Frame
    self.TitleLabel = TitleLabel
    self.DescLabel = DescLabel
    self.LabelHolder = LabelHolder
    self.IconImage = IconImage
    self.Disabled = false

    if interactable then
        local hoverBase = GetTheme("ElementTransparency")
        Frame.MouseEnter:Connect(function()
            if self.Disabled then return end
            hoverBase = GetTheme("ElementTransparency")
            Tween(Frame, 0.14, { BackgroundTransparency = math.max(0, hoverBase - GetTheme("HoverChange")) })
        end)
        Frame.MouseLeave:Connect(function()
            if self.Disabled then return end
            Tween(Frame, 0.18, { BackgroundTransparency = GetTheme("ElementTransparency") })
        end)
        Frame.MouseButton1Down:Connect(function(input)
            if self.Disabled then return end
            Tween(Frame, 0.07, { BackgroundTransparency = math.max(0, hoverBase - GetTheme("HoverChange") * 2) })
            pcall(function() MakeRipple(Frame, input, rippleColor or GetTheme("Ripple")) end)
        end)
        Frame.MouseButton1Up:Connect(function()
            if self.Disabled then return end
            Tween(Frame, 0.1, { BackgroundTransparency = math.max(0, hoverBase - GetTheme("HoverChange")) })
        end)
    end

    function self:SetTitle(t) TitleLabel.Text = t; return self end
    function self:SetLabel(t) TitleLabel.Text = t; return self end
    function self:SetDesc(d)
        DescLabel.Text = d or ""
        DescLabel.Visible = (d and d ~= "") and true or false
        return self
    end
    function self:SetVisible(v) Frame.Visible = not not v; return self end
    function self:SetOrder(n) Frame.LayoutOrder = n or 0; return self end
    function self:SetDisabled(v)
        self.Disabled = not not v
        Frame.BackgroundTransparency = self.Disabled and math.max(GetTheme("ElementTransparency"), 0.7) or GetTheme("ElementTransparency")
        Frame.Active = not self.Disabled
        TitleLabel.TextTransparency = self.Disabled and 0.4 or 0
        DescLabel.TextTransparency = self.Disabled and 0.4 or 0
    end
    function self:Highlight(color)
        if self._highlighting then return end
        self._highlighting = true
        local stroke = Frame:FindFirstChildOfClass("UIStroke")
        if not stroke then
            stroke = New("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Thickness = 1,
                Parent = Frame
            })
        end
        local origColor = stroke.Color
        local origThickness = stroke.Thickness
        local origTransparency = stroke.Transparency
        stroke.Color = color or GetTheme("Accent")
        stroke.Thickness = 2
        stroke.Transparency = 0
        Tween(stroke, 0.8, { Transparency = 1 })
        task.delay(1, function()
            if stroke and stroke.Parent then
                stroke.Color = origColor
                stroke.Thickness = origThickness
                stroke.Transparency = origTransparency
            end
            self._highlighting = false
        end)
    end
    function self:Destroy()
        for i = #Registry, 1, -1 do
            local e = Registry[i]
            if e.Object == Frame or (e.Object and e.Object:IsDescendantOf(Frame)) then
                table.remove(Registry, i)
            end
        end
        Frame:Destroy()
    end

    return self
end

local Section = {}
Section.__index = Section

function Section.new(tab, title, order, opts)
    opts = opts or {}
    local self = setmetatable({}, Section)
    self.Tab = tab
    self.Title = title
    self.Elements = {}

    local SectionRoot = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        LayoutOrder = order or 1,
        Parent = tab.Container
    }, {
        New("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder })
    })

    local collapsible = opts.Collapsible or false
    local collapsed = opts.Collapsed or false

    local Header = New("Frame", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Parent = SectionRoot
    })

    local AccentBar = New("Frame", {
        Size = UDim2.fromOffset(2, 13),
        Position = UDim2.fromOffset(0, 4),
        BackgroundColor3 = GetTheme("Accent"),
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        Parent = Header
    }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })
    Register(AccentBar, { BackgroundColor3 = "Accent" })

    local TitleLabel = New("TextLabel", {
        FontFace = FONT_BOLD,
        Text = title,
        TextColor3 = GetTheme("Text"),
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Position = UDim2.fromOffset(10, 0),
        Size = UDim2.new(1, collapsible and -30 or -10, 1, 0),
        BackgroundTransparency = 1,
        Parent = Header
    })
    Register(TitleLabel, { TextColor3 = "Text" })

    local Chevron
    if collapsible then
        Chevron = New("ImageLabel", {
            Image = "",
            ImageColor3 = GetTheme("SubText"),
            Size = UDim2.fromOffset(14, 14),
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -2, 0.5, 0),
            BackgroundTransparency = 1,
            Parent = Header
        })
        Register(Chevron, { ImageColor3 = "SubText" })
        CentrixUI:ResolveIcon(collapsed and "chevron-down" or "chevron-up", function(asset)
            if asset and Chevron and Chevron.Parent then
                Chevron.Image = asset
            end
        end)
    end

    local ElementsContainer = New("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Visible = not collapsed,
        LayoutOrder = 2,
        Parent = SectionRoot
    }, {
        New("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder })
    })

    self.Container = ElementsContainer
    self.Root = SectionRoot
    self.Header = Header
    self.Collapsible = collapsible

    table.insert(tab.Sections, self)

    local function applyCollapsed(v)
        collapsed = not not v
        ElementsContainer.Visible = not collapsed
        if Chevron then
            CentrixUI:ResolveIcon(collapsed and "chevron-down" or "chevron-up", function(asset)
                if asset and Chevron and Chevron.Parent then
                    Chevron.Image = asset
                end
            end)
        end
    end

    if collapsible then
        Header.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                applyCollapsed(not collapsed)
            end
        end)
        Header.MouseEnter:Connect(function()
            Tween(TitleLabel, 0.12, { TextTransparency = 0.15 })
        end)
        Header.MouseLeave:Connect(function()
            Tween(TitleLabel, 0.12, { TextTransparency = 0 })
        end)
    end

    function self:SetCollapsed(v)
        if not collapsible then return end
        applyCollapsed(v)
    end
    function self:IsCollapsed() return collapsed end
    function self:SetTitle(t) TitleLabel.Text = t or ""; return self end

    local function RegisterElement(el, cfgType, cfgKey)
        el.ConfigType = cfgType
        el.ConfigKey = cfgKey
        el._parentTab = tab
        el._parentSection = self
        el._parentSectionTitle = self.Title
        if not tab.Window._allElements then tab.Window._allElements = {} end
        table.insert(tab.Window._allElements, el)
        return el
    end

    function self:AddButton(cfg)
        cfg = cfg or {}
        local el = CreateElement(cfg.Title or "Button", cfg.Description, ElementsContainer, true, nil, cfg.Icon)
        local Arrow = New("ImageLabel", {
            Image = "",
            ImageColor3 = GetTheme("SubText"),
            Size = UDim2.fromOffset(16, 16),
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -14, 0.5, 0),
            BackgroundTransparency = 1,
            Parent = el.Frame
        })
        Register(Arrow, { ImageColor3 = "SubText" })
        CentrixUI:ResolveIcon("chevron-right", function(asset)
            if asset and Arrow and Arrow.Parent then
                Arrow.Image = asset
            end
        end)
        el.Frame.MouseButton1Click:Connect(function()
            if el.Disabled then return end
            SafeCallback(cfg.Callback)
        end)
        table.insert(self.Elements, el)
        return el
    end

    function self:AddParagraph(cfg)
        cfg = cfg or {}
        local el = CreateElement(cfg.Title or "Paragraph", cfg.Content, ElementsContainer, false, nil, cfg.Icon)
        el.Frame.BackgroundTransparency = 0.97
        el.Frame.AutoButtonColor = false
        function el:UpdateParagraph(t, c)
            if t ~= nil then self:SetTitle(t) end
            if c ~= nil then self:SetDesc(c) end
            return self
        end
        function el:SetContent(c)
            self:SetDesc(c)
            return self
        end
        table.insert(self.Elements, el)
        return el
    end

    function self:AddLabel(cfg)
        cfg = cfg or {}
        local el = CreateElement(cfg.Text or cfg.Title or "Label", cfg.Description or cfg.Content, ElementsContainer, false, nil, cfg.Icon)
        el.Frame.BackgroundTransparency = 1
        el.Frame.AutoButtonColor = false
        table.insert(self.Elements, el)
        return el
    end

    function self:AddDivider()
        local D = New("Frame", {
            Size = UDim2.new(1, 0, 0, 1),
            BackgroundColor3 = GetTheme("Border"),
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Parent = ElementsContainer
        })
        Register(D, { BackgroundColor3 = "Border" })
        return { Destroy = function() D:Destroy() end }
    end

    function self:AddSpacer(height)
        local s = New("Frame", {
            Size = UDim2.new(1, 0, 0, height or 8),
            BackgroundTransparency = 1,
            Parent = ElementsContainer
        })
        return { Instance = s, Destroy = function() s:Destroy() end }
    end

    function self:AddRow(opts)
        opts = opts or {}
        local Row = New("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Parent = ElementsContainer
        }, {
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, opts.Padding or 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        })
        return {
            Instance = Row,
            Frame = Row,
            AddFrame = function(fprops)
                fprops = fprops or {}
                if not fprops.Size then
                    fprops.Size = UDim2.new(0.5, -(opts.Padding or 6) / 2, 0, 40)
                end
                fprops.Parent = Row
                return New("Frame", fprops)
            end,
            Destroy = function() Row:Destroy() end,
        }
    end

    function self:AddFrame(props)
        props = props or {}
        if not props.Size then props.Size = UDim2.new(1, 0, 0, 40) end
        if props.BackgroundTransparency == nil then props.BackgroundTransparency = 1 end
        props.Parent = ElementsContainer
        local f = New("Frame", props)
        return {
            Instance = f,
            Frame = f,
            Destroy = function() f:Destroy() end,
            SetOrder = function(n) f.LayoutOrder = n end,
        }
    end

    function self:AddGroup()
        local g = New("CanvasGroup", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Parent = ElementsContainer
        }, {
            New("UIListLayout", { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder })
        })
        return {
            Instance = g,
            SetOpacity = function(a) g.GroupTransparency = 1 - math.clamp(a or 1, 0, 1) end,
            Destroy = function() g:Destroy() end,
        }
    end

    function self:AddToggle(cfg)
        cfg = cfg or {}
        local el = CreateElement(cfg.Title or "Toggle", cfg.Description, ElementsContainer, true, nil, cfg.Icon)
        el.LabelHolder.Size = UDim2.new(1, -64, 0, 0)

        local state = { Value = cfg.Default or false }

        local Track = New("Frame", {
            Size = UDim2.fromOffset(42, 24),
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -14, 0.5, 0),
            BackgroundColor3 = state.Value and GetTheme("ToggleOn") or GetTheme("ToggleOff"),
            BackgroundTransparency = 0,
            Parent = el.Frame
        }, {
            New("UICorner", { CornerRadius = UDim.new(1, 0) }),
            New("UIStroke", {
                Color = GetTheme("InnerBorder"),
                Thickness = 1,
                Transparency = state.Value and 1 or 0.5
            })
        })

        local Knob = New("Frame", {
            Size = UDim2.fromOffset(18, 18),
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, state.Value and 21 or 3, 0.5, 0),
            BackgroundColor3 = state.Value and Color3.fromRGB(255, 255, 255) or GetTheme("ToggleSlider"),
            BorderSizePixel = 0,
            ZIndex = 2,
            Parent = Track
        }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })

        local function render(animate)
            local targetPos = state.Value and 21 or 3
            local targetTrack = state.Value and GetTheme("ToggleOn") or GetTheme("ToggleOff")
            local targetKnob = state.Value and Color3.fromRGB(255, 255, 255) or GetTheme("ToggleSlider")
            local targetStroke = state.Value and 1 or 0.5
            if animate then
                Tween(Knob, 0.22, { Position = UDim2.new(0, targetPos, 0.5, 0) }, Enum.EasingStyle.Quint)
                Tween(Track, 0.22, { BackgroundColor3 = targetTrack }, Enum.EasingStyle.Quint)
                Tween(Knob, 0.22, { BackgroundColor3 = targetKnob }, Enum.EasingStyle.Quint)
                local stroke = Track:FindFirstChildOfClass("UIStroke")
                if stroke then Tween(stroke, 0.22, { Transparency = targetStroke }, Enum.EasingStyle.Quint) end
            else
                Knob.Position = UDim2.new(0, targetPos, 0.5, 0)
                Track.BackgroundColor3 = targetTrack
                Knob.BackgroundColor3 = targetKnob
                local stroke = Track:FindFirstChildOfClass("UIStroke")
                if stroke then stroke.Transparency = targetStroke end
            end
        end

        el.Frame.MouseButton1Click:Connect(function()
            if el.Disabled then return end
            state.Value = not state.Value
            render(true)
            SafeCallback(cfg.Callback, state.Value)
            SafeCallback(el.Changed, state.Value)
            if tab.Window and tab.Window._scheduleSave then tab.Window._scheduleSave() end
        end)

        function el:SetValue(v, silent)
            state.Value = not not v
            render(true)
            if not silent then
                SafeCallback(cfg.Callback, state.Value)
                SafeCallback(el.Changed, state.Value)
                if tab.Window and tab.Window._scheduleSave then tab.Window._scheduleSave() end
            end
        end
        function el:GetValue() return state.Value end
        function el:OnChanged(fn) el.Changed = fn; fn(state.Value) end

        render(false)
        table.insert(self.Elements, el)
        RegisterElement(el, "Toggle", cfg.ConfigKey or (tab.Title .. "::" .. self.Title .. "::" .. (cfg.Title or "Toggle")))
        return el
    end

    function self:AddSlider(cfg)
        cfg = cfg or {}
        local el = CreateElement(cfg.Title or "Slider", cfg.Description, ElementsContainer, false, nil, cfg.Icon)
        el.LabelHolder.Size = UDim2.new(1, -256, 0, 0)

        local min, max = cfg.Min or 0, cfg.Max or 100
        local rounding = cfg.Rounding or 0
        local value = cfg.Default or min

        local Controls = New("Frame", {
            Size = UDim2.new(0, 240, 1, 0),
            Position = UDim2.new(1, -14, 0, 0),
            AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1,
            Parent = el.Frame
        }, {
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
        })

        local ValueInput = New("TextBox", {
            FontFace = FONT_MEDIUM,
            Text = tostring(value),
            TextColor3 = GetTheme("Text"),
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Center,
            BackgroundColor3 = GetTheme("Input"),
            BackgroundTransparency = 0.85,
            ClearTextOnFocus = false,
            Size = UDim2.fromOffset(30, 22),
            LayoutOrder = 1,
            Parent = Controls
        }, {
            New("UICorner", { CornerRadius = UDim.new(0, 6) }),
            New("UIStroke", {
                Transparency = 0.5,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = GetTheme("InnerBorder"),
                Thickness = 1
            })
        })
        Register(ValueInput, { TextColor3 = "Text", BackgroundColor3 = "Input" })

        local Rail = New("Frame", {
            Size = UDim2.fromOffset(128, 6),
            BackgroundColor3 = GetTheme("SliderRail"),
            BackgroundTransparency = 0.3,
            LayoutOrder = 2,
            Parent = Controls
        }, {
            New("UICorner", { CornerRadius = UDim.new(1, 0) })
        })
        Register(Rail, { BackgroundColor3 = "SliderRail" })

        local Fill = New("Frame", {
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundColor3 = GetTheme("Accent"),
            BackgroundTransparency = 0,
            Parent = Rail
        }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })
        Register(Fill, { BackgroundColor3 = "Accent" })

        local Knob = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.fromOffset(14, 14),
            BackgroundColor3 = GetTheme("Accent"),
            BorderSizePixel = 0,
            ZIndex = 3,
            Parent = Rail
        }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })
        Register(Knob, { BackgroundColor3 = "Accent" })

        local dragging = false
        local editing = false

        local function setValue(v, silent)
            value = Round(math.clamp(v, min, max), rounding)
            local alpha = (max - min) > 0 and ((value - min) / (max - min)) or 0
            Knob.Position = UDim2.new(alpha, 0, 0.5, 0)
            Fill.Size = UDim2.fromScale(alpha, 1)
            if not editing then ValueInput.Text = tostring(value) end
            if not silent then
                SafeCallback(cfg.Callback, value)
                SafeCallback(el.Changed, value)
                if tab.Window and tab.Window._scheduleSave then tab.Window._scheduleSave() end
            end
        end

        local function updateFromX(inputX)
            local railAbs = Rail.AbsolutePosition
            local railSize = Rail.AbsoluteSize
            if railSize.X <= 0 then return end
            local alpha = math.clamp((inputX - railAbs.X) / railSize.X, 0, 1)
            setValue(min + (max - min) * alpha)
        end

        local railClick = Rail.InputBegan:Connect(function(input)
            if el.Disabled then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                updateFromX(input.Position.X)
                Tween(Knob, 0.15, { Size = UDim2.fromOffset(18, 18) }, Enum.EasingStyle.Quint)
            end
        end)

        local moveConn = UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                updateFromX(input.Position.X)
            end
        end)

        local endConn = UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    dragging = false
                    Tween(Knob, 0.2, { Size = UDim2.fromOffset(14, 14) }, Enum.EasingStyle.Quint)
                end
            end
        end)

        ValueInput.Focused:Connect(function()
            editing = true
            Tween(ValueInput, 0.15, { BackgroundTransparency = 0.5 })
            OverrideTag(ValueInput, { BackgroundColor3 = "InputFocused" })
        end)

        ValueInput.FocusLost:Connect(function()
            editing = false
            Tween(ValueInput, 0.15, { BackgroundTransparency = 0.85 })
            OverrideTag(ValueInput, { BackgroundColor3 = "Input" })
            local num = tonumber(ValueInput.Text)
            if num then
                setValue(num)
            else
                ValueInput.Text = tostring(value)
            end
        end)

        local textConn = ValueInput:GetPropertyChangedSignal("Text"):Connect(function()
            if not editing then return end
            local num = tonumber(ValueInput.Text)
            if num then
                local clamped = math.clamp(num, min, max)
                if clamped ~= num then
                    value = Round(clamped, rounding)
                else
                    value = Round(num, rounding)
                end
                local alpha = (max - min) > 0 and ((value - min) / (max - min)) or 0
                Knob.Position = UDim2.new(alpha, 0, 0.5, 0)
                Fill.Size = UDim2.fromScale(alpha, 1)
                SafeCallback(cfg.Callback, value)
                SafeCallback(el.Changed, value)
                if tab.Window and tab.Window._scheduleSave then tab.Window._scheduleSave() end
            end
        end)

        function el:SetValue(v, silent) setValue(v, silent) end
        function el:GetValue() return value end
        function el:OnChanged(fn) el.Changed = fn; fn(value) end

        local baseDestroy = el.Destroy
        function el:Destroy()
            if railClick then railClick:Disconnect() end
            if moveConn then moveConn:Disconnect() end
            if endConn then endConn:Disconnect() end
            if textConn then textConn:Disconnect() end
            baseDestroy()
        end

        setValue(value, true)
        table.insert(self.Elements, el)
        RegisterElement(el, "Slider", cfg.ConfigKey or (tab.Title .. "::" .. self.Title .. "::" .. (cfg.Title or "Slider")))
        return el
    end

    function self:AddInput(cfg)
        cfg = cfg or {}
        local el = CreateElement(cfg.Title or "Input", cfg.Description, ElementsContainer, false, nil, cfg.Icon)
        el.LabelHolder.Size = UDim2.new(1, -146, 0, 0)

        local value = cfg.Default or ""

        local InputFrame = New("Frame", {
            Size = UDim2.fromOffset(156, 32),
            Position = UDim2.new(1, -14, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = GetTheme("Input"),
            BackgroundTransparency = 0.85,
            Parent = el.Frame
        }, {
            New("UICorner", { CornerRadius = UDim.new(0, 5) }),
            New("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Transparency = 0.5,
                Color = GetTheme("InnerBorder"),
                Thickness = 1
            })
        })
        Register(InputFrame, { BackgroundColor3 = "Input" })

        local Input = New("TextBox", {
            FontFace = FONT,
            Text = value,
            PlaceholderText = cfg.Placeholder or "Enter text...",
            TextColor3 = GetTheme("Text"),
            PlaceholderColor3 = GetTheme("SubText"),
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -20, 1, -4),
            Position = UDim2.fromOffset(10, 2),
            ClearTextOnFocus = false,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = InputFrame
        })
        Register(Input, { TextColor3 = "Text", PlaceholderColor3 = "SubText" })

        local Indicator = New("Frame", {
            Size = UDim2.new(1, -10, 0, 1),
            Position = UDim2.new(0, 5, 1, -3),
            BackgroundColor3 = GetTheme("InputIndicator"),
            BackgroundTransparency = 0.5,
            Parent = InputFrame
        }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })
        Register(Indicator, { BackgroundColor3 = "InputIndicator" })

        local function setValue(v, silent)
            if cfg.Numeric and v ~= "" and not tonumber(v) then v = value end
            if cfg.MaxLength and #v > cfg.MaxLength then v = v:sub(1, cfg.MaxLength) end
            value = v
            if Input.Text ~= v then Input.Text = v end
            if not silent then
                SafeCallback(cfg.Callback, value)
                SafeCallback(el.Changed, value)
                if tab.Window and tab.Window._scheduleSave then tab.Window._scheduleSave() end
            end
        end

        Input.Focused:Connect(function()
            Tween(Indicator, 0.15, { BackgroundTransparency = 0 })
            OverrideTag(InputFrame, { BackgroundColor3 = "InputFocused" })
        end)
        Input.FocusLost:Connect(function()
            Tween(Indicator, 0.15, { BackgroundTransparency = 0.5 })
            OverrideTag(InputFrame, { BackgroundColor3 = "Input" })
            if cfg.Finished then setValue(Input.Text) end
        end)

        if not cfg.Finished then
            Input:GetPropertyChangedSignal("Text"):Connect(function()
                setValue(Input.Text)
            end)
        end

        function el:SetValue(v, silent) setValue(v, silent) end
        function el:GetValue() return value end
        function el:OnChanged(fn) el.Changed = fn; fn(value) end

        table.insert(self.Elements, el)
        RegisterElement(el, "Input", cfg.ConfigKey or (tab.Title .. "::" .. self.Title .. "::" .. (cfg.Title or "Input")))
        return el
    end

    function self:AddKeybind(cfg)
        cfg = cfg or {}
        local el = CreateElement(cfg.Title or "Keybind", cfg.Description, ElementsContainer, true, nil, cfg.Icon)
        el.LabelHolder.Size = UDim2.new(1, -120, 0, 0)

        local state = {
            Value = cfg.Default or Enum.KeyCode.F,
            Mode = cfg.Mode or "Toggle",
            Toggled = false
        }
        if typeof(state.Value) == "EnumItem" then state.Value = state.Value.Name end

        local KeyLabel = New("TextLabel", {
            FontFace = FONT_MEDIUM,
            Text = state.Value,
            TextColor3 = GetTheme("Text"),
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Center,
            Size = UDim2.new(0, 0, 1, 0),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1
        })
        Register(KeyLabel, { TextColor3 = "Text" })

        local KeyFrame = New("TextButton", {
            Size = UDim2.fromOffset(0, 30),
            Position = UDim2.new(1, -14, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = GetTheme("Keybind"),
            BackgroundTransparency = 0.85,
            AutomaticSize = Enum.AutomaticSize.X,
            Text = "",
            AutoButtonColor = false,
            Parent = el.Frame
        }, {
            New("UICorner", { CornerRadius = UDim.new(0, 5) }),
            New("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) }),
            New("UIStroke", {
                Transparency = 0.5,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = GetTheme("InnerBorder"),
                Thickness = 1
            }),
            KeyLabel
        })
        Register(KeyFrame, { BackgroundColor3 = "Keybind" })

        local listening = false
        local listenConn, listenEndConn

        local function stopListening()
            if listenConn then listenConn:Disconnect() listenConn = nil end
            if listenEndConn then listenEndConn:Disconnect() listenEndConn = nil end
            listening = false
        end

        local clickConn = KeyFrame.MouseButton1Click:Connect(function()
            if el.Disabled or listening then return end
            listening = true
            KeyLabel.Text = "..."
            task.wait(0.15)
            listenConn = UserInputService.InputBegan:Connect(function(input)
                local keyName
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    keyName = input.KeyCode.Name
                    SafeCallback(cfg.ChangedCallback, input.KeyCode)
                elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                    keyName = "MouseLeft"
                    SafeCallback(cfg.ChangedCallback, Enum.UserInputType.MouseButton1)
                elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                    keyName = "MouseRight"
                    SafeCallback(cfg.ChangedCallback, Enum.UserInputType.MouseButton2)
                end
                if keyName then
                    state.Value = keyName
                    KeyLabel.Text = keyName
                    SafeCallback(el.Changed, state.Value)
                    stopListening()
                    if tab.Window and tab.Window._scheduleSave then tab.Window._scheduleSave() end
                end
            end)
            listenEndConn = UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Focus or input.UserInputType == Enum.UserInputType.Touch then
                    stopListening()
                    KeyLabel.Text = state.Value
                end
            end)
        end)

        local globalConn = UserInputService.InputBegan:Connect(function(input)
            if listening or UserInputService:GetFocusedTextBox() then return end
            if el.Disabled then return end
            if state.Mode == "Toggle" then
                local matches = false
                if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == state.Value then
                    matches = true
                elseif state.Value == "MouseLeft" and input.UserInputType == Enum.UserInputType.MouseButton1 then
                    matches = true
                elseif state.Value == "MouseRight" and input.UserInputType == Enum.UserInputType.MouseButton2 then
                    matches = true
                end
                if matches then
                    state.Toggled = not state.Toggled
                    SafeCallback(cfg.Callback, state.Toggled)
                    SafeCallback(el.Clicked, state.Toggled)
                end
            end
        end)

        function el:SetValue(key, mode)
            if typeof(key) == "EnumItem" then key = key.Name end
            state.Value = key or state.Value
            state.Mode = mode or state.Mode
            KeyLabel.Text = state.Value
        end
        function el:GetValue() return state.Value end
        function el:GetState()
            if state.Mode == "Always" then return true end
            if state.Mode == "Hold" then
                if state.Value == "MouseLeft" then return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) end
                if state.Value == "MouseRight" then return UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) end
                local ok, res = pcall(function() return UserInputService:IsKeyDown(Enum.KeyCode[state.Value]) end)
                return ok and res or false
            end
            return state.Toggled
        end
        function el:OnChanged(fn) el.Changed = fn; fn(state.Value) end
        function el:OnClick(fn) el.Clicked = fn end

        local baseDestroy = el.Destroy
        function el:Destroy()
            stopListening()
            if clickConn then clickConn:Disconnect() end
            if globalConn then globalConn:Disconnect() end
            baseDestroy()
        end

        table.insert(self.Elements, el)
        RegisterElement(el, "Keybind", cfg.ConfigKey or (tab.Title .. "::" .. self.Title .. "::" .. (cfg.Title or "Keybind")))
        return el
    end

    function self:AddDropdown(cfg)
        cfg = cfg or {}
        local el = CreateElement(cfg.Title or "Dropdown", cfg.Description, ElementsContainer, false, nil, cfg.Icon)
        el.LabelHolder.Size = UDim2.new(1, -190, 0, 0)

        local values = cfg.Values or {}
        local multi = cfg.Multi or false
        local value = multi and {} or cfg.Default

        local ValueLabel = New("TextLabel", {
            FontFace = FONT,
            Text = "--",
            TextColor3 = GetTheme("Text"),
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, -36, 1, 0),
            Position = UDim2.fromOffset(12, 0),
            BackgroundTransparency = 1,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = el.Frame
        })
        Register(ValueLabel, { TextColor3 = "Text" })

        local Chevron = New("ImageLabel", {
            Image = "",
            ImageColor3 = GetTheme("SubText"),
            Size = UDim2.fromOffset(14, 14),
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -10, 0.5, 0),
            BackgroundTransparency = 1,
            Parent = el.Frame
        })
        Register(Chevron, { ImageColor3 = "SubText" })
        CentrixUI:ResolveIcon("chevron-down", function(asset)
            if asset and Chevron and Chevron.Parent then
                Chevron.Image = asset
            end
        end)

        local DropBtn = New("TextButton", {
            Size = UDim2.fromOffset(180, 32),
            Position = UDim2.new(1, -14, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = GetTheme("DropdownFrame"),
            BackgroundTransparency = 0.85,
            Text = "",
            AutoButtonColor = false,
            Parent = el.Frame
        }, {
            New("UICorner", { CornerRadius = UDim.new(0, 5) }),
            New("UIStroke", {
                Transparency = 0.5,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Color = GetTheme("InnerBorder"),
                Thickness = 1
            }),
            ValueLabel,
            Chevron
        })
        Register(DropBtn, { BackgroundColor3 = "DropdownFrame" })

        local Popup
        local opened = false
        local needsSearch = #values > 15

        local function updateDisplay()
            local text = ""
            if multi then
                local parts = {}
                for k, _ in pairs(value) do table.insert(parts, k) end
                table.sort(parts)
                text = table.concat(parts, ", ")
            else
                text = tostring(value or "")
            end
            ValueLabel.Text = text ~= "" and text or "--"
        end

        local function buildOptions()
            if Popup then Popup:Destroy() end

            local searchHeight = needsSearch and 38 or 0
            local popupHeight = math.min(#values * 32 + searchHeight + 12, 320)

            local ListLayout = New("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder })
            local OptionList = New("ScrollingFrame", {
                Size = UDim2.new(1, -10, 1, -10 - searchHeight),
                Position = UDim2.fromOffset(5, 5 + searchHeight),
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ScrollBarThickness = 3,
                ScrollBarImageTransparency = 0.9,
                ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
                CanvasSize = UDim2.fromScale(0, 0),
                ScrollingDirection = Enum.ScrollingDirection.Y,
            }, { ListLayout })
            ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                OptionList.CanvasSize = UDim2.fromOffset(0, ListLayout.AbsoluteContentSize.Y)
            end)

            Popup = New("Frame", {
                BackgroundColor3 = GetTheme("DropdownHolder"),
                Size = UDim2.fromOffset(190, popupHeight),
                Visible = false,
                ZIndex = 500,
                Parent = ActiveWindow and ActiveWindow.GUI or nil
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 8) }),
                New("UIStroke", {
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = GetTheme("DropdownBorder"),
                    Transparency = 0.4,
                    Thickness = 1
                })
            })
            Register(Popup, { BackgroundColor3 = "DropdownHolder" })

            local searchInput
            if needsSearch then
                local SearchBox = New("Frame", {
                    Size = UDim2.new(1, -10, 0, 32),
                    Position = UDim2.fromOffset(5, 4),
                    BackgroundColor3 = GetTheme("Input"),
                    BackgroundTransparency = 0.9,
                    Parent = Popup
                }, {
                    New("UICorner", { CornerRadius = UDim.new(0, 4) }),
                    New("UIStroke", {
                        Transparency = 0.55,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Color = GetTheme("InnerBorder"),
                        Thickness = 1
                    })
                })
                Register(SearchBox, { BackgroundColor3 = "Input" })
                local SearchIcon = New("ImageLabel", {
                    Image = "",
                    ImageColor3 = GetTheme("SubText"),
                    Size = UDim2.fromOffset(12, 12),
                    Position = UDim2.fromOffset(9, 10),
                    BackgroundTransparency = 1,
                    Parent = SearchBox
                })
                Register(SearchIcon, { ImageColor3 = "SubText" })
                CentrixUI:ResolveIcon("search", function(asset)
                    if asset and SearchIcon and SearchIcon.Parent then
                        SearchIcon.Image = asset
                    end
                end)
                searchInput = New("TextBox", {
                    FontFace = FONT,
                    Text = "",
                    PlaceholderText = "Search...",
                    PlaceholderColor3 = GetTheme("SubText"),
                    TextColor3 = GetTheme("Text"),
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    BackgroundTransparency = 1,
                    ClearTextOnFocus = false,
                    Position = UDim2.fromOffset(26, 0),
                    Size = UDim2.new(1, -32, 1, 0),
                    Parent = SearchBox
                })
                Register(searchInput, { TextColor3 = "Text", PlaceholderColor3 = "SubText" })
            end
            OptionList.Parent = Popup

            local currentOptions = {}
            local function renderOptions(filter)
                for _, b in ipairs(currentOptions) do
                    if b and b.Parent then b:Destroy() end
                end
                currentOptions = {}
                for _, optName in ipairs(values) do
                    local matches = filter == "" or string.find(string.lower(optName), string.lower(filter), 1, true) ~= nil
                    if matches then
                        local isActive = multi and value[optName] or (not multi and value == optName)
                        local Btn = New("TextButton", {
                            Size = UDim2.new(1, 0, 0, 30),
                            BackgroundColor3 = GetTheme("DropdownOption"),
                            BackgroundTransparency = isActive and 0.85 or 1,
                            Text = "",
                            AutoButtonColor = false,
                            Parent = OptionList
                        }, {
                            New("UICorner", { CornerRadius = UDim.new(0, 4) }),
                            New("TextLabel", {
                                FontFace = FONT,
                                Text = optName,
                                TextColor3 = GetTheme("Text"),
                                TextSize = 13,
                                TextXAlignment = Enum.TextXAlignment.Left,
                                Size = UDim2.new(1, -20, 1, 0),
                                Position = UDim2.fromOffset(10, 0),
                                BackgroundTransparency = 1,
                                TextTruncate = Enum.TextTruncate.AtEnd
                            })
                        })
                        Register(Btn, { BackgroundColor3 = "DropdownOption" })
                        for _, c in ipairs(Btn:GetChildren()) do
                            if c:IsA("TextLabel") then Register(c, { TextColor3 = "Text" }) end
                        end
                        Btn.MouseEnter:Connect(function()
                            if not isActive then Tween(Btn, 0.12, { BackgroundTransparency = 0.9 }) end
                        end)
                        Btn.MouseLeave:Connect(function()
                            if not isActive then Tween(Btn, 0.12, { BackgroundTransparency = 1 }) end
                        end)
                        Btn.MouseButton1Click:Connect(function()
                            if multi then
                                if value[optName] then value[optName] = nil else value[optName] = true end
                            else
                                value = optName
                            end
                            updateDisplay()
                            renderOptions(searchInput and searchInput.Text or "")
                            SafeCallback(cfg.Callback, value)
                            SafeCallback(el.Changed, value)
                            if tab.Window and tab.Window._scheduleSave then tab.Window._scheduleSave() end
                            if not multi then
                                opened = false
                                Popup.Visible = false
                                Tween(Chevron, 0.2, { Rotation = 0 })
                            end
                        end)
                        table.insert(currentOptions, Btn)
                    end
                end
                OptionList.CanvasSize = UDim2.fromOffset(0, ListLayout.AbsoluteContentSize.Y + 4)
            end
            renderOptions("")
            if searchInput then
                searchInput:GetPropertyChangedSignal("Text"):Connect(function()
                    renderOptions(searchInput.Text)
                end)
            end
        end

        local function positionPopup()
            if not Popup or not Popup.Parent then return end
            local abs = DropBtn.AbsolutePosition
            local sz = Popup.Size
            local screenH = workspace.CurrentCamera.ViewportSize.Y
            local y
            if abs.Y + DropBtn.AbsoluteSize.Y + sz.Y.Offset > screenH then
                y = abs.Y - sz.Y.Offset - 4
            else
                y = abs.Y + DropBtn.AbsoluteSize.Y + 4
            end
            Popup.Position = UDim2.fromOffset(abs.X, y)
        end

        local clickConn = DropBtn.MouseButton1Click:Connect(function()
            opened = not opened
            if opened then
                buildOptions()
                positionPopup()
                Popup.Visible = true
                Tween(Chevron, 0.2, { Rotation = 180 }, Enum.EasingStyle.Quart)
            else
                if Popup then Popup.Visible = false end
                Tween(Chevron, 0.2, { Rotation = 0 }, Enum.EasingStyle.Quart)
            end
        end)

        local closeConn = UserInputService.InputBegan:Connect(function(input)
            if not opened then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if not Popup or not Popup.Parent then return end
                local pos = input.Position
                local pAbs, pSize = Popup.AbsolutePosition, Popup.AbsoluteSize
                local bAbs, bSize = DropBtn.AbsolutePosition, DropBtn.AbsoluteSize
                local inPopup = pos.X >= pAbs.X and pos.X <= pAbs.X + pSize.X and pos.Y >= pAbs.Y and pos.Y <= pAbs.Y + pSize.Y
                local inBtn = pos.X >= bAbs.X and pos.X <= bAbs.X + bSize.X and pos.Y >= bAbs.Y and pos.Y <= bAbs.Y + bSize.Y
                if not inPopup and not inBtn then
                    opened = false
                    Popup.Visible = false
                    Tween(Chevron, 0.2, { Rotation = 0 }, Enum.EasingStyle.Quart)
                end
            end
        end)

        local absConn = DropBtn:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
            if opened then positionPopup() end
        end)

        if cfg.Default then
            if multi and type(cfg.Default) == "table" then
                for _, v in ipairs(cfg.Default) do
                    if table.find(values, v) then value[v] = true end
                end
            elseif not multi and table.find(values, cfg.Default) then
                value = cfg.Default
            end
        end

        function el:SetValue(v, silent)
            if multi then
                value = {}
                if type(v) == "table" then
                    for _, item in ipairs(v) do
                        if table.find(values, item) then value[item] = true end
                    end
                end
            else
                if table.find(values, v) then value = v end
            end
            updateDisplay()
            if not silent then
                SafeCallback(cfg.Callback, value)
                SafeCallback(el.Changed, value)
                if tab.Window and tab.Window._scheduleSave then tab.Window._scheduleSave() end
            end
        end
        function el:SetValues(newValues)
            values = newValues or {}
            if multi then
                local nextValue = {}
                for item in pairs(value) do
                    if table.find(values, item) then nextValue[item] = true end
                end
                value = nextValue
            elseif value ~= nil and not table.find(values, value) then
                value = nil
            end
            needsSearch = #values > 15
            updateDisplay()
        end
        function el:Refresh(newValues, newValue, silent)
            el:SetValues(newValues)
            if newValue ~= nil then el:SetValue(newValue, silent) end
            return el
        end
        function el:Reset(silent)
            local resetValue = multi and {} or nil
            if cfg.Default ~= nil then resetValue = cfg.Default end
            el:SetValue(resetValue, silent)
            return el
        end
        function el:IsMulti() return multi end
        function el:GetValue() return value end
        function el:OnChanged(fn) el.Changed = fn; fn(value) end

        local baseDestroy = el.Destroy
        function el:Destroy()
            if clickConn then clickConn:Disconnect() end
            if closeConn then closeConn:Disconnect() end
            if absConn then absConn:Disconnect() end
            if Popup then Popup:Destroy() end
            baseDestroy()
        end

        updateDisplay()
        table.insert(self.Elements, el)
        RegisterElement(el, "Dropdown", cfg.ConfigKey or (tab.Title .. "::" .. self.Title .. "::" .. (cfg.Title or "Dropdown")))
        return el
    end

    function self:AddColorpicker(cfg)
        cfg = cfg or {}
        local el = CreateElement(cfg.Title or "Color", cfg.Description, ElementsContainer, true, nil, cfg.Icon)
        el.LabelHolder.Size = UDim2.new(1, -100, 0, 0)

        local value = cfg.Default or Color3.fromRGB(255, 255, 255)
        local transparency = cfg.Transparency or 0
        local supportsTransparency = cfg.Transparency ~= nil

        local Preview = New("Frame", {
            Size = UDim2.fromOffset(30, 30),
            Position = UDim2.new(1, -14, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundColor3 = value,
            BackgroundTransparency = transparency,
            Parent = el.Frame
        }, {
            New("UICorner", { CornerRadius = UDim.new(0, 5) }),
            New("UIStroke", { Transparency = 0.5, Color = GetTheme("InnerBorder"), Thickness = 1 })
        })

        local function openPicker()
            local h, s, v = Color3.toHSV(value)
            local workingTransparency = transparency

            local dialog = ActiveWindow:Dialog({
                Title = cfg.Title or "Color",
                Content = "",
                Buttons = {
                    { Title = "Confirm", Callback = function()
                        value = Color3.fromHSV(h, s, v)
                        transparency = workingTransparency
                        Preview.BackgroundColor3 = value
                        Preview.BackgroundTransparency = transparency
                        SafeCallback(cfg.Callback, value)
                        SafeCallback(el.Changed, value)
                        if tab.Window and tab.Window._scheduleSave then tab.Window._scheduleSave() end
                    end },
                    { Title = "Cancel" }
                }
            })

            dialog.Root.Size = UDim2.fromOffset(320, 400)

            local SV = New("ImageLabel", {
                Size = UDim2.fromOffset(180, 180),
                Position = UDim2.fromOffset(20, 55),
                BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                Image = "rbxassetid://4155801252",
                BorderSizePixel = 0,
                Parent = dialog.Root
            }, { New("UICorner", { CornerRadius = UDim.new(0, 5) }) })

            local svCursor = New("Frame", {
                Size = UDim2.fromOffset(14, 14),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(s, 0, 1 - v, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                ZIndex = 2,
                Parent = SV
            }, {
                New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                New("UIStroke", { Thickness = 2, Color = Color3.fromRGB(0, 0, 0), Transparency = 0.3 })
            })

            local HueBar = New("Frame", {
                Size = UDim2.fromOffset(18, 180),
                Position = UDim2.fromOffset(214, 55),
                BorderSizePixel = 0,
                Parent = dialog.Root
            }, {
                New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                New("UIGradient", {
                    Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(1 / 6, Color3.fromRGB(255, 255, 0)),
                        ColorSequenceKeypoint.new(2 / 6, Color3.fromRGB(0, 255, 0)),
                        ColorSequenceKeypoint.new(3 / 6, Color3.fromRGB(0, 255, 255)),
                        ColorSequenceKeypoint.new(4 / 6, Color3.fromRGB(0, 0, 255)),
                        ColorSequenceKeypoint.new(5 / 6, Color3.fromRGB(255, 0, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                    }),
                    Rotation = 90
                })
            })

            local hueCursor = New("Frame", {
                Size = UDim2.fromOffset(16, 16),
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.new(0.5, 0, h, 0),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                ZIndex = 2,
                Parent = HueBar
            }, {
                New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                New("UIStroke", { Thickness = 2, Color = Color3.fromRGB(0, 0, 0), Transparency = 0.3 })
            })

            local AlphaBar
            local alphaCursor
            if supportsTransparency then
                AlphaBar = New("Frame", {
                    Size = UDim2.fromOffset(18, 180),
                    Position = UDim2.fromOffset(252, 55),
                    BackgroundColor3 = Color3.fromHSV(h, s, v),
                    BorderSizePixel = 0,
                    Parent = dialog.Root
                }, {
                    New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                    New("UIGradient", {
                        Transparency = NumberSequence.new({
                            NumberSequenceKeypoint.new(0, 0),
                            NumberSequenceKeypoint.new(1, 1)
                        }),
                        Rotation = 90
                    })
                })
                alphaCursor = New("Frame", {
                    Size = UDim2.fromOffset(16, 16),
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0.5, 0, 1 - workingTransparency, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    ZIndex = 2,
                    Parent = AlphaBar
                }, {
                    New("UICorner", { CornerRadius = UDim.new(1, 0) }),
                    New("UIStroke", { Thickness = 2, Color = Color3.fromRGB(0, 0, 0), Transparency = 0.3 })
                })
            end

            local HexFrame = New("Frame", {
                Size = UDim2.fromOffset(110, 30),
                Position = UDim2.fromOffset(20, 250),
                BackgroundColor3 = GetTheme("DialogInput"),
                BackgroundTransparency = 0.85,
                Parent = dialog.Root
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 4) }),
                New("UIStroke", {
                    Transparency = 0.5,
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = GetTheme("InnerBorder"),
                    Thickness = 1
                })
            })
            Register(HexFrame, { BackgroundColor3 = "DialogInput" })

            local HexInput = New("TextBox", {
                FontFace = FONT,
                Text = "#" .. value:ToHex(),
                TextColor3 = GetTheme("Text"),
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -12, 1, 0),
                Position = UDim2.fromOffset(8, 0),
                ClearTextOnFocus = false,
                Parent = HexFrame
            })
            Register(HexInput, { TextColor3 = "Text" })

            local RGBContainer = New("Frame", {
                Size = UDim2.fromOffset(150, 30),
                Position = UDim2.fromOffset(140, 250),
                BackgroundTransparency = 1,
                Parent = dialog.Root
            }, {
                New("UIListLayout", {
                    Padding = UDim.new(0, 6),
                    FillDirection = Enum.FillDirection.Horizontal,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            })

            local function makeRGBField(initial, order)
                local holder = New("Frame", {
                    Size = UDim2.fromOffset(46, 30),
                    BackgroundColor3 = GetTheme("DialogInput"),
                    BackgroundTransparency = 0.85,
                    LayoutOrder = order,
                    Parent = RGBContainer
                }, {
                    New("UICorner", { CornerRadius = UDim.new(0, 4) }),
                    New("UIStroke", {
                        Transparency = 0.5,
                        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                        Color = GetTheme("InnerBorder"),
                        Thickness = 1
                    })
                })
                Register(holder, { BackgroundColor3 = "DialogInput" })
                local input = New("TextBox", {
                    FontFace = FONT,
                    Text = tostring(initial),
                    TextColor3 = GetTheme("Text"),
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 1),
                    ClearTextOnFocus = false,
                    Parent = holder
                })
                Register(input, { TextColor3 = "Text" })
                return input
            end

            local rVal, gVal, bVal = math.floor(value.R * 255), math.floor(value.G * 255), math.floor(value.B * 255)
            local RInput = makeRGBField(rVal, 1)
            local GInput = makeRGBField(gVal, 2)
            local BInput = makeRGBField(bVal, 3)

            local syncing = false

            local function syncUI()
                SV.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                svCursor.Position = UDim2.new(s, 0, 1 - v, 0)
                hueCursor.Position = UDim2.new(0.5, 0, h, 0)
                if AlphaBar then AlphaBar.BackgroundColor3 = Color3.fromHSV(h, s, v) end
                if alphaCursor then alphaCursor.Position = UDim2.new(0.5, 0, 1 - workingTransparency, 0) end
                local c = Color3.fromHSV(h, s, v)
                rVal, gVal, bVal = math.floor(c.R * 255), math.floor(c.G * 255), math.floor(c.B * 255)
                syncing = true
                HexInput.Text = "#" .. c:ToHex()
                RInput.Text = tostring(rVal)
                GInput.Text = tostring(gVal)
                BInput.Text = tostring(bVal)
                syncing = false
            end

            SV.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                        local ax, ay = SV.AbsolutePosition.X, SV.AbsolutePosition.Y
                        local bx, by = ax + SV.AbsoluteSize.X, ay + SV.AbsoluteSize.Y
                        s = math.clamp((Mouse.X - ax) / (bx - ax), 0, 1)
                        v = 1 - math.clamp((Mouse.Y - ay) / (by - ay), 0, 1)
                        syncUI()
                        RunService.RenderStepped:Wait()
                    end
                end
            end)

            HueBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                        local ay = HueBar.AbsolutePosition.Y
                        local by = ay + HueBar.AbsoluteSize.Y
                        h = math.clamp((Mouse.Y - ay) / (by - ay), 0, 1)
                        syncUI()
                        RunService.RenderStepped:Wait()
                    end
                end
            end)

            if AlphaBar then
                AlphaBar.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        while UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) do
                            local ay = AlphaBar.AbsolutePosition.Y
                            local by = ay + AlphaBar.AbsoluteSize.Y
                            workingTransparency = 1 - math.clamp((Mouse.Y - ay) / (by - ay), 0, 1)
                            syncUI()
                            RunService.RenderStepped:Wait()
                        end
                    end
                end)
            end

            HexInput.FocusLost:Connect(function()
                if syncing then return end
                local txt = HexInput.Text
                if txt:sub(1, 1) ~= "#" then txt = "#" .. txt end
                local ok, c = pcall(Color3.fromHex, txt)
                if ok and typeof(c) == "Color3" then
                    h, s, v = Color3.toHSV(c)
                end
                syncUI()
            end)

            local function applyRGBInput()
                if syncing then return end
                local r = math.clamp(tonumber(RInput.Text) or rVal, 0, 255)
                local g = math.clamp(tonumber(GInput.Text) or gVal, 0, 255)
                local b = math.clamp(tonumber(BInput.Text) or bVal, 0, 255)
                local c = Color3.fromRGB(r, g, b)
                h, s, v = Color3.toHSV(c)
                syncUI()
            end
            RInput.FocusLost:Connect(applyRGBInput)
            GInput.FocusLost:Connect(applyRGBInput)
            BInput.FocusLost:Connect(applyRGBInput)

            syncUI()
        end

        el.Frame.MouseButton1Click:Connect(function()
            if el.Disabled then return end
            openPicker()
        end)

        function el:SetValue(c, t, silent)
            if typeof(c) == "Color3" then value = c end
            if t then transparency = t end
            Preview.BackgroundColor3 = value
            Preview.BackgroundTransparency = transparency
            if not silent then
                SafeCallback(cfg.Callback, value)
                SafeCallback(el.Changed, value)
                if tab.Window and tab.Window._scheduleSave then tab.Window._scheduleSave() end
            end
        end
        function el:GetValue() return value end
        function el:GetTransparency() return transparency end
        function el:OnChanged(fn) el.Changed = fn; fn(value) end

        table.insert(self.Elements, el)
        RegisterElement(el, "Colorpicker", cfg.ConfigKey or (tab.Title .. "::" .. self.Title .. "::" .. (cfg.Title or "Color")))
        return el
    end

    return self
end

local Tab = {}
Tab.__index = Tab

function Tab.new(window, title, icon)
    local self = setmetatable({}, Tab)
    self.Window = window
    self.Title = title
    self.Icon = icon
    self.Sections = {}
    self.Selected = false
    self.Index = window.TabCount + 1
    window.TabCount = self.Index

    local hasIcon = icon ~= nil

    local Frame = New("TextButton", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundTransparency = 1,
        BackgroundColor3 = GetTheme("Tab"),
        Text = "",
        AutoButtonColor = false,
        ClipsDescendants = true,
        LayoutOrder = self.Index,
        Parent = window.TabHolder
    }, {
        New("UICorner", { CornerRadius = UDim.new(0, 6) })
    })
    Register(Frame, { BackgroundColor3 = "Tab" })

    local TitleLabel = New("TextLabel", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = hasIcon and UDim2.new(0, 40, 0.5, 0) or UDim2.new(0, 14, 0.5, 0),
        Text = title,
        FontFace = FONT,
        TextColor3 = GetTheme("Text"),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Size = UDim2.new(1, -48, 1, 0),
        BackgroundTransparency = 1,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = Frame
    })
    Register(TitleLabel, { TextColor3 = "Text" })

    if hasIcon then
        local IconImage = New("ImageLabel", {
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.fromOffset(16, 16),
            Position = UDim2.new(0, 14, 0.5, 0),
            Image = "",
            ImageColor3 = GetTheme("Text"),
            BackgroundTransparency = 1,
            Parent = Frame
        })
        Register(IconImage, { ImageColor3 = "Text" })
        CentrixUI:ResolveIcon(icon, function(asset)
            if asset and IconImage and IconImage.Parent then
                IconImage.Image = asset
            end
        end)
    end

    local Scrolling = New("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = false,
        BottomImage = "rbxassetid://6889812791",
        MidImage = "rbxassetid://6889812721",
        TopImage = "rbxassetid://6276641225",
        ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
        ScrollBarImageTransparency = 0.9,
        ScrollBarThickness = 3,
        BorderSizePixel = 0,
        CanvasSize = UDim2.fromScale(0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Parent = window.ContainerHolder
    }, {
        New("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder }),
        New("UIPadding", {
            PaddingRight = UDim.new(0, 12),
            PaddingLeft = UDim.new(0, 2),
            PaddingTop = UDim.new(0, 2),
            PaddingBottom = UDim.new(0, 20)
        })
    })

    local listLayout = Scrolling:FindFirstChildOfClass("UIListLayout")
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Scrolling.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 20)
    end)

    Frame.MouseEnter:Connect(function()
        if not self.Selected then Tween(Frame, 0.15, { BackgroundTransparency = 0.9 }) end
    end)
    Frame.MouseLeave:Connect(function()
        if not self.Selected then Tween(Frame, 0.15, { BackgroundTransparency = 1 }) end
    end)
    Frame.MouseButton1Click:Connect(function()
        window:SelectTab(self.Index)
    end)

    self.Frame = Frame
    self.Container = Scrolling
    self.Scrolling = Scrolling

    function self:AddSection(cfg)
        cfg = cfg or {}
        return Section.new(self, cfg.Title or "Section", #self.Sections + 1, {
            Collapsible = cfg.Collapsible,
            Collapsed = cfg.Collapsed,
        })
    end

    function self:SetTransparency(t)
        Frame.BackgroundTransparency = t
    end

    function self:SetIcon(ic)
        if ic then
            local img = Frame:FindFirstChildOfClass("ImageLabel")
            if img then
                CentrixUI:ResolveIcon(ic, function(asset)
                    if asset and img and img.Parent then
                        img.Image = asset
                    end
                end)
            end
        end
    end

    window.Tabs[self.Index] = self
    return self
end

local function GetButtonColors(title)
    local lower = string.lower(title or "")
    if lower == "yes" or lower == "confirm" or lower == "ok" or lower == "continue" or lower == "save" or lower == "apply" or lower == "enable" or lower == "accept" or lower == "done" then
        return Color3.fromRGB(34, 197, 94), Color3.fromRGB(255, 255, 255)
    elseif lower == "no" or lower == "cancel" or lower == "close" or lower == "delete" or lower == "deny" or lower == "dismiss" or lower == "disable" or lower == "decline" then
        return Color3.fromRGB(239, 68, 68), Color3.fromRGB(255, 255, 255)
    end
    return nil, nil
end

local function TintIconForType(notifType)
    local icons = {
        info = "lucide-info",
        success = "lucide-check-circle",
        warning = "lucide-alert-triangle",
        error = "lucide-alert-circle",
    }
    return icons[notifType] or "lucide-info"
end

local function ColorKeyForType(notifType)
    local colors = {
        info = "Info",
        success = "Success",
        warning = "Warning",
        error = "Error",
    }
    return colors[notifType] or "Info"
end

function CentrixUI:CreateWindow(cfg)
    cfg = cfg or {}
    assert(cfg.Title ~= nil, "CentrixUI: Window Title required")

    if ActiveWindow and not ActiveWindow.Destroyed then
        warn("[CentrixUI] Window already exists, returning existing")
        return ActiveWindow
    end

    LoadAssets(cfg.LucideURL or DEFAULT_LUCIDE_URL)

    CurrentTheme = cfg.Theme or "Dark"
    if not Themes[CurrentTheme] then CurrentTheme = "Dark" end

    local Window = {}
    Window.Tabs = {}
    Window.TabCount = 0
    Window.SelectedTab = nil
    Window.Minimized = false
    Window.Maximized = false
    Window.Destroyed = false
    Window._connections = {}
    Window._allElements = {}
    Window._searchEntries = {}
    Window.AutoSave = cfg.AutoSave or false
    Window.FolderName = cfg.Foldername or "Centrix"
    Window._opacity = 1
    Window._draggable = true
    Window._resizable = true

    local saveScheduled = false
    Window._scheduleSave = function()
        if not Window.AutoSave then return end
        if saveScheduled then return end
        saveScheduled = true
        task.delay(0.5, function()
            saveScheduled = false
            if Window.Destroyed then return end
            if not FileIO.CanSave then return end
            task.spawn(function()
                FileIO.EnsureFolder(Window.FolderName)
                local lines = {}
                for _, el in ipairs(Window._allElements) do
                    if el.ConfigKey and el.ConfigType then
                        local ok, v = pcall(SerializeValue, el)
                        if ok and v ~= nil then
                            table.insert(lines, el.ConfigKey .. "=" .. tostring(v))
                        end
                    end
                end
                FileIO.Write(Window.FolderName .. "/config.txt", table.concat(lines, "\n"))
            end)
        end)
    end

    local function track(conn)
        if conn then table.insert(Window._connections, conn) end
        return conn
    end

    local ScreenGui = CreateSpoofedGui("RobloxGui")
    Window.GUI = ScreenGui

    if cfg.Acrylic then Acrylic.Enable() end

    local Size = cfg.Size or UDim2.fromOffset(580, 460)
    local TabWidth = cfg.TabWidth or 160
    local viewportSize = workspace.CurrentCamera.ViewportSize

    local Main = New("CanvasGroup", {
        Name = "Main",
        Size = Size,
        Position = UDim2.fromOffset(
            math.floor((viewportSize.X - Size.X.Offset) / 2),
            math.floor((viewportSize.Y - Size.Y.Offset) / 2)
        ),
        BackgroundColor3 = GetTheme("Background"),
        BackgroundTransparency = 0,
        GroupTransparency = 0,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        ZIndex = 2,
        Parent = ScreenGui
    }, {
        New("UICorner", { CornerRadius = UDim.new(0, 10) }),
        New("UIStroke", { Color = GetTheme("Border"), Thickness = 1, Transparency = 0.25 })
    })
    Register(Main, { BackgroundColor3 = "Background" })

    Window.Root = Main
    Window.Size = Size
    Window.Position = Main.Position

    local Shadow = New("ImageLabel", {
        Image = "rbxassetid://8992230677",
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(Vector2.new(99, 99), Vector2.new(99, 99)),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(Size.X.Offset + 60, Size.Y.Offset + 60),
        Position = UDim2.fromOffset(0, 0),
        BackgroundTransparency = 1,
        ImageColor3 = GetTheme("Shadow"),
        ImageTransparency = 0.65,
        ZIndex = 1,
        Parent = ScreenGui
    })
    Register(Shadow, { ImageColor3 = "Shadow" })
    Window._Shadow = Shadow

    local function updateShadow()
        if not Shadow or not Shadow.Parent or not Main or not Main.Parent then return end
        local ms = Main.AbsoluteSize
        local mp = Main.AbsolutePosition
        Shadow.Size = UDim2.fromOffset(ms.X + 60, ms.Y + 60)
        Shadow.Position = UDim2.fromOffset(mp.X + ms.X / 2, mp.Y + ms.Y / 2)
    end
    track(Main:GetPropertyChangedSignal("Size"):Connect(updateShadow))
    track(Main:GetPropertyChangedSignal("Position"):Connect(updateShadow))
    task.defer(updateShadow)

    local TitleBar = New("Frame", {
        Name = "TitleBar",
        Size = UDim2.new(1, 0, 0, 44),
        BackgroundTransparency = 1,
        Parent = Main
    })

    local TitleLabel = New("TextLabel", {
        RichText = true,
        Text = cfg.Title,
        FontFace = FONT,
        TextColor3 = GetTheme("Text"),
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Size = UDim2.fromScale(0, 1),
        AutomaticSize = Enum.AutomaticSize.X,
        Position = UDim2.fromOffset(18, 0),
        BackgroundTransparency = 1,
        Parent = TitleBar
    })
    Register(TitleLabel, { TextColor3 = "Text" })

    local SubTitleLabel = New("TextLabel", {
        RichText = true,
        Text = cfg.SubTitle or "",
        FontFace = FONT,
        TextColor3 = GetTheme("SubText"),
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Size = UDim2.fromScale(0, 1),
        AutomaticSize = Enum.AutomaticSize.X,
        Position = UDim2.new(0, 18 + TitleLabel.TextBounds.X + 8, 0, 0),
        BackgroundTransparency = 1,
        Parent = TitleBar
    })
    Register(SubTitleLabel, { TextColor3 = "SubText" })

    local lastTitleWidth = 0
    track(TitleLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
        local w = TitleLabel.TextBounds.X
        if math.abs(w - lastTitleWidth) > 0.5 then
            lastTitleWidth = w
            SubTitleLabel.Position = UDim2.new(0, 18 + w + 8, 0, 0)
        end
    end))

    local Divider = New("Frame", {
        BackgroundColor3 = GetTheme("TitleBarLine"),
        BackgroundTransparency = 0.4,
        Size = UDim2.new(1, 0, 0, 1),
        Position = UDim2.new(0, 0, 1, 0),
        BorderSizePixel = 0,
        Parent = TitleBar
    })
    Register(Divider, { BackgroundColor3 = "TitleBarLine" })

    local function MakeTitleButton(iconName, xOffset, callback)
        local Btn = New("TextButton", {
            Size = UDim2.new(0, 32, 1, -10),
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, xOffset, 0, 5),
            BackgroundTransparency = 1,
            BackgroundColor3 = GetTheme("Text"),
            Text = "",
            AutoButtonColor = false,
            Parent = TitleBar
        }, {
            New("UICorner", { CornerRadius = UDim.new(0, 6) }),
            New("ImageLabel", {
                Image = "",
                ImageColor3 = GetTheme("Text"),
                Size = UDim2.fromOffset(15, 15),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Parent = Btn
            })
        })
        Register(Btn, { BackgroundColor3 = "Text" })
        local img = Btn:FindFirstChildOfClass("ImageLabel")
        Register(img, { ImageColor3 = "Text" })
        CentrixUI:ResolveIcon(iconName:gsub("lucide%-", ""), function(asset)
            if asset and img and img.Parent then
                img.Image = asset
            end
        end)
        Btn.MouseEnter:Connect(function() Tween(Btn, 0.15, { BackgroundTransparency = 0.9 }) end)
        Btn.MouseLeave:Connect(function() Tween(Btn, 0.15, { BackgroundTransparency = 1 }) end)
        Btn.MouseButton1Click:Connect(callback)
        return Btn
    end

    local CloseBtn = MakeTitleButton("x", -6, function()
        Window:Dialog({
            Title = "Confirm",
            Content = "Are you sure you want to unload the interface?",
            Buttons = {
                { Title = "Confirm", Callback = function() Window:Destroy() end },
                { Title = "Cancel" }
            }
        })
    end)
    local MaxBtn = MakeTitleButton("maximize", -42, function()
        Window:Maximize(not Window.Maximized)
    end)
    local MinBtn = MakeTitleButton("minus", -78, function()
        Window:Minimize()
    end)

    Window.MinButton = MinBtn
    Window.MaxButton = MaxBtn
    Window.CloseButton = CloseBtn

    local TabHolder = New("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ScrollBarThickness = 0,
        ScrollBarImageTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.fromScale(0, 0),
        ScrollingDirection = Enum.ScrollingDirection.Y
    }, {
        New("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder })
    })

    local Selector = New("Frame", {
        Size = UDim2.fromOffset(2, 18),
        BackgroundColor3 = GetTheme("Accent"),
        Position = UDim2.fromOffset(4, 22),
        AnchorPoint = Vector2.new(0, 0.5),
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = Main
    }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })
    Register(Selector, { BackgroundColor3 = "Accent" })

    local TabArea = New("Frame", {
        Size = UDim2.new(0, TabWidth, 1, -66),
        Position = UDim2.new(0, 12, 0, 54),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Parent = Main
    }, {
        New("UIPadding", { PaddingLeft = UDim.new(0, 6) }),
        TabHolder
    })

    local tabListLayout = TabHolder:FindFirstChildOfClass("UIListLayout")
    track(tabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabHolder.CanvasSize = UDim2.new(0, 0, 0, tabListLayout.AbsoluteContentSize.Y)
    end))

    local TabDisplay = New("TextLabel", {
        RichText = true,
        Text = "Tab",
        FontFace = FONT_TITLE,
        TextColor3 = GetTheme("Text"),
        TextSize = 26,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Size = UDim2.new(1, -16, 0, 30),
        Position = UDim2.fromOffset(TabWidth + 30, 56),
        BackgroundTransparency = 1,
        Parent = Main
    })
    Register(TabDisplay, { TextColor3 = "Text" })

    local ContainerHolder = New("CanvasGroup", {
        Size = UDim2.new(1, -TabWidth - 36, 1, -108),
        Position = UDim2.fromOffset(TabWidth + 30, 96),
        BackgroundTransparency = 1,
        GroupTransparency = 0,
        Parent = Main
    })

    Window.TabHolder = TabHolder
    Window.TabDisplay = TabDisplay
    Window.ContainerHolder = ContainerHolder
    Window.Selector = Selector
    Window.TitleBar = TitleBar
    Window.TabArea = TabArea

    local selectorTween
    local function moveSelector(targetY)
        if selectorTween then pcall(function() selectorTween:Cancel() end) end
        selectorTween = Tween(Selector, 0.35, { Position = UDim2.new(0, 4, 0, targetY) }, Enum.EasingStyle.Quart)
    end

    local dragging = false
    local resizing = false
    local resizeStart = nil
    local resizeStartSize = nil
    local dragStart = nil
    local dragStartPos = nil
    local dragMainSize = nil
    local lastClickTime = 0

    local function isOverTitleButton(pos)
        for _, btn in ipairs({ CloseBtn, MaxBtn, MinBtn, Window.SearchButton }) do
            if btn and btn.Parent then
                local ap = btn.AbsolutePosition
                local as = btn.AbsoluteSize
                if pos.X >= ap.X and pos.X <= ap.X + as.X and pos.Y >= ap.Y and pos.Y <= ap.Y + as.Y then
                    return true
                end
            end
        end
        return false
    end

    track(TitleBar.InputBegan:Connect(function(input)
        if Window._draggable == false then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if isOverTitleButton(input.Position) then return end
            local now = os.clock()
            if now - lastClickTime < 0.3 then
                Window:Maximize(not Window.Maximized)
                lastClickTime = 0
                return
            end
            lastClickTime = now
            dragging = true
            dragStart = Vector2.new(input.Position.X, input.Position.Y)
            dragStartPos = Vector2.new(Main.AbsolutePosition.X, Main.AbsolutePosition.Y)
            dragMainSize = Vector2.new(Main.AbsoluteSize.X, Main.AbsoluteSize.Y)
        end
    end))

    track(UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local cx, cy = input.Position.X, input.Position.Y
        local dx = cx - dragStart.X
        local dy = cy - dragStart.Y
        local nx = dragStartPos.X + dx
        local ny = dragStartPos.Y + dy
        local vs = workspace.CurrentCamera.ViewportSize
        local snap = 12
        if math.abs(nx) < snap then nx = 0 end
        if math.abs(nx + dragMainSize.X - vs.X) < snap then nx = vs.X - dragMainSize.X end
        if math.abs(ny) < snap then ny = 0 end
        if math.abs(ny + dragMainSize.Y - vs.Y) < snap then ny = vs.Y - dragMainSize.Y end
        Main.Position = UDim2.fromOffset(math.floor(nx + 0.5), math.floor(ny + 0.5))
    end))

    track(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                Window.Position = Main.Position
                Window.Size = Main.Size
            end
        end
    end))

    local ResizeHandle = New("TextButton", {
        Size = UDim2.fromOffset(18, 18),
        Position = UDim2.new(1, -18, 1, -18),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 20,
        Parent = Main
    })
    Window._resizeHandle = ResizeHandle

    ResizeHandle.InputBegan:Connect(function(input)
        if Window._resizable == false then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            resizeStart = Vector2.new(input.Position.X, input.Position.Y)
            resizeStartSize = Vector2.new(Main.AbsoluteSize.X, Main.AbsoluteSize.Y)
        end
    end)

    track(UserInputService.InputChanged:Connect(function(input)
        if not resizing then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local delta = Vector2.new(input.Position.X, input.Position.Y) - resizeStart
        local viewport = workspace.CurrentCamera.ViewportSize
        local maxWidth = math.max(480, viewport.X - Main.AbsolutePosition.X)
        local maxHeight = math.max(360, viewport.Y - Main.AbsolutePosition.Y)
        local width = math.clamp(resizeStartSize.X + delta.X, 480, maxWidth)
        local height = math.clamp(resizeStartSize.Y + delta.Y, 360, maxHeight)
        Main.Size = UDim2.fromOffset(math.floor(width), math.floor(height))
        Window.Size = Main.Size
    end))

    track(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
        end
    end))

    local NotifyHolder = New("Frame", {
        Position = UDim2.new(1, -24, 1, -24),
        Size = UDim2.new(0, 330, 1, -24),
        AnchorPoint = Vector2.new(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 900,
        Parent = ScreenGui
    }, {
        New("UIListLayout", {
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 10)
        })
    })

    local DialogLayer = New("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 999,
        Parent = ScreenGui
    })

    local DialogTint = New("TextButton", {
        Text = "",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        AutoButtonColor = false,
        TextTransparency = 1,
        Parent = DialogLayer
    })

    Window.DialogOpen = false

    function Window:Dialog(dcfg)
        dcfg = dcfg or {}
        self.DialogOpen = true
        DialogLayer.Visible = true
        Tween(DialogTint, 0.2, { BackgroundTransparency = 0.35 })

        local dialogContent = dcfg.Content or ""
        if dcfg.Detail and dcfg.Detail ~= "" then
            dialogContent = dialogContent ~= "" and (dialogContent .. "\n\nDetail:\n" .. dcfg.Detail) or ("Detail:\n" .. dcfg.Detail)
        end
        local estimatedLines = math.max(1, math.ceil(#dialogContent / 38))
        local dialogHeight = math.clamp(110 + estimatedLines * 18, 180, 320)

        local Root = New("CanvasGroup", {
            Size = UDim2.fromOffset(320, dialogHeight),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            BackgroundColor3 = GetTheme("Dialog"),
            GroupTransparency = 1,
            Parent = DialogLayer
        }, {
            New("UICorner", { CornerRadius = UDim.new(0, 10) }),
            New("UIStroke", { Transparency = 0.4, Color = GetTheme("DialogBorder"), Thickness = 1 })
        })
        Register(Root, { BackgroundColor3 = "Dialog" })

        local dialogScale = New("UIScale", { Scale = 1.06, Parent = Root })

        local hasIcon = dcfg.Icon ~= nil
        local titleX = hasIcon and 60 or 20
        local contentY = hasIcon and 58 or 52

        if hasIcon then
            local IconImage = New("ImageLabel", {
                Image = "",
                ImageColor3 = dcfg.IconColor or GetTheme("Accent"),
                Size = UDim2.fromOffset(28, 28),
                Position = UDim2.fromOffset(20, 22),
                BackgroundTransparency = 1,
                Parent = Root
            })
            if dcfg.IconColor == nil then
                Register(IconImage, { ImageColor3 = "Accent" })
            end
            CentrixUI:ResolveIcon(dcfg.Icon, function(asset)
                if asset and IconImage and IconImage.Parent then
                    IconImage.Image = asset
                end
            end)
        end

        local TitleLabel2 = New("TextLabel", {
            FontFace = FONT_BOLD,
            Text = dcfg.Title or "Dialog",
            TextColor3 = GetTheme("Text"),
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, -titleX - 20, 0, 24),
            Position = UDim2.fromOffset(titleX, 20),
            BackgroundTransparency = 1,
            Parent = Root
        })
        Register(TitleLabel2, { TextColor3 = "Text" })

        local ContentHolder = New("Frame", {
            Size = UDim2.new(1, -40, 1, -110),
            Position = UDim2.fromOffset(20, contentY),
            BackgroundTransparency = 1,
            Parent = Root
        })

        if dialogContent ~= "" then
            local contentLabel = New("TextLabel", {
                FontFace = FONT,
                Text = dialogContent,
                TextColor3 = GetTheme("Text"),
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
                TextWrapped = true,
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Parent = ContentHolder
            })
            Register(contentLabel, { TextColor3 = "Text" })
        end

        local BtnHolderFrame = New("Frame", {
            Size = UDim2.new(1, 0, 0, 58),
            Position = UDim2.new(0, 0, 1, -58),
            BackgroundColor3 = GetTheme("DialogHolder"),
            Parent = Root
        }, {
            New("UICorner", { CornerRadius = UDim.new(0, 10) })
        })
        Register(BtnHolderFrame, { BackgroundColor3 = "DialogHolder" })

        local topLine = New("Frame", {
            Size = UDim2.new(1, 0, 0, 1),
            BackgroundColor3 = GetTheme("DialogHolderLine"),
            BorderSizePixel = 0,
            Parent = BtnHolderFrame
        })
        Register(topLine, { BackgroundColor3 = "DialogHolderLine" })

        local ButtonHolder = New("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Parent = BtnHolderFrame
        }, {
            New("UIListLayout", {
                Padding = UDim.new(0, 10),
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                SortOrder = Enum.SortOrder.LayoutOrder
            }),
            New("UIPadding", { PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16) })
        })

        local buttons = dcfg.Buttons or { { Title = "OK" } }
        local count = #buttons

        local closed = false
        local function closeDialog()
            if closed then return end
            closed = true
            Tween(Root, 0.22, { GroupTransparency = 1 })
            Tween(dialogScale, 0.22, { Scale = 0.9 }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            Tween(DialogTint, 0.22, { BackgroundTransparency = 1 })
            task.wait(0.22)
            self.DialogOpen = false
            DialogLayer.Visible = false
            if Root and Root.Parent then Root:Destroy() end
        end

        for i, btnCfg in ipairs(buttons) do
            local btnTitle = btnCfg.Title or "Button"
            local customBg, customText = GetButtonColors(btnTitle)
            local Btn = New("TextButton", {
                Size = UDim2.new(1 / count, -((count - 1) * 10) / count, 0, 34),
                BackgroundColor3 = customBg or GetTheme("DialogButton"),
                BackgroundTransparency = customBg and 0.1 or 0.9,
                Text = btnTitle,
                FontFace = FONT_MEDIUM,
                TextColor3 = customText or GetTheme("Text"),
                TextSize = 13,
                AutoButtonColor = false,
                LayoutOrder = i,
                Parent = ButtonHolder
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 6) }),
                New("UIStroke", {
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Transparency = customBg and 1 or 0.6,
                    Color = customBg or GetTheme("DialogButtonBorder"),
                    Thickness = 1
                })
            })
            if not customBg then
                Register(Btn, { BackgroundColor3 = "DialogButton", TextColor3 = "Text" })
            end
            local baseTrans = customBg and 0.1 or 0.9
            Btn.MouseEnter:Connect(function() Tween(Btn, 0.12, { BackgroundTransparency = math.max(0, baseTrans - 0.08) }) end)
            Btn.MouseLeave:Connect(function() Tween(Btn, 0.12, { BackgroundTransparency = baseTrans }) end)
            Btn.MouseButton1Click:Connect(function()
                SafeCallback(btnCfg.Callback)
                closeDialog()
            end)
        end

        Tween(Root, 0.28, { GroupTransparency = 0 })
        Tween(dialogScale, 0.32, { Scale = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        return { Root = Root, Close = closeDialog }
    end

    local notifOrder = 0

    function Window:Notify(ncfg)
        ncfg = ncfg or {}
        notifOrder = notifOrder + 1

        local notifType = ncfg.Type or "info"
        local duration = ncfg.Duration or 5
        local typeColorKey = ColorKeyForType(notifType)

        local Root = New("Frame", {
            Size = UDim2.new(1, 0, 0, 68),
            BackgroundColor3 = GetTheme("Background2"),
            BackgroundTransparency = 0.05,
            LayoutOrder = notifOrder,
            Position = UDim2.fromOffset(80, 0),
            Parent = NotifyHolder
        }, {
            New("UICorner", { CornerRadius = UDim.new(0, 8) }),
            New("UIStroke", { Color = GetTheme("Border"), Transparency = 0.35, Thickness = 1 })
        })
        Register(Root, { BackgroundColor3 = "Background2" })

        local AccentBar = New("Frame", {
            Size = UDim2.new(0, 3, 1, -16),
            Position = UDim2.fromOffset(0, 8),
            BackgroundColor3 = GetTheme(typeColorKey),
            BorderSizePixel = 0,
            Parent = Root
        }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })
        Register(AccentBar, { BackgroundColor3 = typeColorKey })

        local IconImage = New("ImageLabel", {
            Image = "",
            ImageColor3 = ncfg.IconColor or GetTheme(typeColorKey),
            Size = UDim2.fromOffset(16, 16),
            Position = UDim2.fromOffset(14, 14),
            BackgroundTransparency = 1,
            Parent = Root
        })
        if ncfg.IconColor == nil then
            Register(IconImage, { ImageColor3 = typeColorKey })
        end

        local iconValue = ncfg.Icon
        if not iconValue or iconValue == "" then
            iconValue = TintIconForType(notifType)
        end

        if type(iconValue) == "string" then
            CentrixUI:ResolveIcon(iconValue, function(asset)
                if asset and IconImage and IconImage.Parent then
                    IconImage.Image = asset
                    if ncfg.IconColor == nil and (iconValue:sub(1, 4) == "http" or iconValue:sub(1, 11) == "rbxassetid:") then
                        IconImage.ImageColor3 = Color3.new(1, 1, 1)
                    end
                end
            end)
        end

        local TitleText = New("TextLabel", {
            FontFace = FONT_BOLD,
            Text = ncfg.Title or "Notification",
            TextColor3 = GetTheme("Text"),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Size = UDim2.new(1, -70, 0, 18),
            Position = UDim2.fromOffset(38, 12),
            BackgroundTransparency = 1,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Parent = Root
        })
        Register(TitleText, { TextColor3 = "Text" })

        local ContentText = New("TextLabel", {
            FontFace = FONT,
            Text = ncfg.Content or "",
            TextColor3 = GetTheme("SubText"),
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Size = UDim2.new(1, -50, 0, 16),
            Position = UDim2.fromOffset(38, 34),
            BackgroundTransparency = 1,
            Parent = Root
        })
        Register(ContentText, { TextColor3 = "SubText" })

        local CloseBtn2 = New("TextButton", {
            Size = UDim2.fromOffset(22, 22),
            Position = UDim2.new(1, -30, 0, 12),
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            Parent = Root
        }, {
            New("ImageLabel", {
                Image = "",
                ImageColor3 = GetTheme("SubText"),
                Size = UDim2.fromOffset(13, 13),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Parent = CloseBtn2
            })
        })
        local closeImg = CloseBtn2:FindFirstChildOfClass("ImageLabel")
        Register(closeImg, { ImageColor3 = "SubText" })
        CentrixUI:ResolveIcon("x", function(asset)
            if asset and closeImg and closeImg.Parent then
                closeImg.Image = asset
            end
        end)

        local ProgressTrack = New("Frame", {
            Size = UDim2.new(1, -24, 0, 2),
            Position = UDim2.new(0, 12, 1, -6),
            BackgroundColor3 = GetTheme("Border"),
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Parent = Root
        }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })
        Register(ProgressTrack, { BackgroundColor3 = "Border" })

        local ProgressFill = New("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = GetTheme(typeColorKey),
            BorderSizePixel = 0,
            Parent = ProgressTrack
        }, { New("UICorner", { CornerRadius = UDim.new(1, 0) }) })
        Register(ProgressFill, { BackgroundColor3 = typeColorKey })

        local closed = false
        local paused = false
        local elapsed = 0
        local timerConn

        local function close()
            if closed then return end
            closed = true
            if timerConn then timerConn:Disconnect() timerConn = nil end
            Tween(Root, 0.25, { Position = UDim2.fromOffset(80, 0) }, Enum.EasingStyle.Quart)
            Tween(Root, 0.25, { BackgroundTransparency = 1 })
            if ProgressTrack then Tween(ProgressTrack, 0.2, { BackgroundTransparency = 1 }) end
            task.delay(0.3, function()
                if Root and Root.Parent then Root:Destroy() end
            end)
        end

        CloseBtn2.MouseButton1Click:Connect(close)
        Root.MouseEnter:Connect(function() paused = true end)
        Root.MouseLeave:Connect(function() paused = false end)

        if duration > 0 then
            timerConn = RunService.RenderStepped:Connect(function(dt)
                if closed or paused then return end
                elapsed = elapsed + dt
                local progress = math.min(elapsed / duration, 1)
                if ProgressFill and ProgressFill.Parent then
                    ProgressFill.Size = UDim2.new(1 - progress, 0, 1, 0)
                end
                if progress >= 1 then close() end
            end)
        end

        Tween(Root, 0.4, { Position = UDim2.fromOffset(0, 0) }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

        return { Close = close }
    end

    function Window:NotifyDialog(ncfg)
        ncfg = ncfg or {}
        local notifType = ncfg.Type or "info"
        local colorKey = ColorKeyForType(notifType)
        return Window:Dialog({
            Title = ncfg.Title or "Notification",
            Content = ncfg.Content or "",
            Detail = ncfg.Detail or ncfg.Details,
            Icon = ncfg.Icon or TintIconForType(notifType),
            IconColor = ncfg.IconColor or GetTheme(colorKey),
            Buttons = ncfg.Buttons or { { Title = "OK" } }
        })
    end

    function Window:AddTab(tcfg)
        tcfg = tcfg or {}
        return Tab.new(self, tcfg.Title or "Tab", tcfg.Icon)
    end

    function Window:SelectTab(idx)
        idx = idx or 1
        if not self.Tabs[idx] then return end
        self.SelectedTab = idx
        for _, tab in pairs(self.Tabs) do
            tab:SetTransparency(1)
            tab.Selected = false
        end
        self.Tabs[idx]:SetTransparency(0.9)
        self.Tabs[idx].Selected = true
        TabDisplay.Text = self.Tabs[idx].Title
        task.defer(function()
            local tabFrame = self.Tabs[idx].Frame
            if tabFrame and tabFrame.Parent and Main and Main.Parent then
                local tabY = tabFrame.AbsolutePosition.Y - Main.AbsolutePosition.Y + tabFrame.AbsoluteSize.Y / 2
                moveSelector(tabY)
            end
        end)
        for _, c in pairs(self.Tabs) do
            c.Container.Visible = false
        end
        self.Tabs[idx].Container.Visible = true
        ContainerHolder.GroupTransparency = 1
        ContainerHolder.Position = UDim2.fromOffset(TabWidth + 40, 96)
        Tween(ContainerHolder, 0.25, { GroupTransparency = 0 })
        Tween(ContainerHolder, 0.32, { Position = UDim2.fromOffset(TabWidth + 30, 96) }, Enum.EasingStyle.Quart)
    end

    function Window:JumpToElement(el)
        if not el or not el._parentTab then return end
        Window:SelectTab(el._parentTab.Index)
        task.defer(function()
            task.wait(0.35)
            local section = el._parentSection
            if section and section.IsCollapsed and section:IsCollapsed() then
                section:SetCollapsed(false)
                task.wait(0.15)
            end
            local container = el._parentTab.Container
            if container and el.Frame and el.Frame.Parent then
                local elY = el.Frame.AbsolutePosition.Y - container.AbsolutePosition.Y + container.CanvasPosition.Y
                Tween(container, 0.4, { CanvasPosition = Vector2.new(0, math.max(0, elY - 40)) }, Enum.EasingStyle.Quart)
            end
            if el.Highlight then
                el:Highlight()
            end
        end)
    end

    function Window:RegisterSearchEntry(entry)
        if not entry or not entry.Name then return end
        Window._searchEntries = Window._searchEntries or {}
        table.insert(Window._searchEntries, entry)
        return entry
    end

    function Window:EnableSearch(opts)
        opts = opts or {}
        if Window._searchEnabled then return end
        Window._searchEnabled = true
        Window._searchKey = opts.Keybind or Enum.KeyCode.K

        Window.SearchButton = MakeTitleButton("search", -114, function()
            if Window._openSearch then Window._openSearch() end
        end)

        local overlay = New("Frame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Visible = false,
            ZIndex = 997,
            Parent = ScreenGui
        })

        local backdrop = New("TextButton", {
            Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            Parent = overlay
        })

        local panel = New("CanvasGroup", {
            Size = UDim2.fromOffset(500, 400),
            Position = UDim2.new(0.5, 0, 0.2, 0),
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundColor3 = GetTheme("Background"),
            GroupTransparency = 0,
            Parent = overlay
        }, {
            New("UICorner", { CornerRadius = UDim.new(0, 10) }),
            New("UIStroke", { Color = GetTheme("Border"), Thickness = 1, Transparency = 0.3 })
        })
        Register(panel, { BackgroundColor3 = "Background" })

        local searchIcon = New("ImageLabel", {
            Image = "",
            ImageColor3 = GetTheme("SubText"),
            Size = UDim2.fromOffset(18, 18),
            Position = UDim2.fromOffset(16, 16),
            BackgroundTransparency = 1,
            Parent = panel
        })
        Register(searchIcon, { ImageColor3 = "SubText" })
        CentrixUI:ResolveIcon("search", function(asset)
            if asset and searchIcon and searchIcon.Parent then
                searchIcon.Image = asset
            end
        end)

        local searchInput = New("TextBox", {
            FontFace = FONT,
            Text = "",
            PlaceholderText = "Search tabs, sections, elements...",
            PlaceholderColor3 = GetTheme("SubText"),
            TextColor3 = GetTheme("Text"),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(44, 0),
            Size = UDim2.new(1, -60, 0, 50),
            ClearTextOnFocus = false,
            Parent = panel
        })
        Register(searchInput, { TextColor3 = "Text", PlaceholderColor3 = "SubText" })

        local dividerLine = New("Frame", {
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.fromOffset(0, 50),
            BackgroundColor3 = GetTheme("Border"),
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Parent = panel
        })
        Register(dividerLine, { BackgroundColor3 = "Border" })

        local resultList = New("ScrollingFrame", {
            Size = UDim2.new(1, -20, 1, -60),
            Position = UDim2.fromOffset(10, 56),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageTransparency = 0.9,
            ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
            CanvasSize = UDim2.new(),
            Parent = panel
        }, {
            New("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder })
        })
        local resultLayout = resultList:FindFirstChildOfClass("UIListLayout")
        resultLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            resultList.CanvasSize = UDim2.fromOffset(0, resultLayout.AbsoluteContentSize.Y)
        end)

        local typeToIcon = {
            Toggle = "toggle-right",
            Slider = "sliders-horizontal",
            Dropdown = "chevron-down",
            Input = "type",
            Keybind = "keyboard",
            Colorpicker = "palette",
            Element = "circle",
            Command = "terminal",
        }

        local function buildEntries()
            local entries = {}
            for _, el in ipairs(Window._allElements) do
                if el._parentTab and el._parentSection and el.TitleLabel then
                    local title = el.TitleLabel.Text or "Element"
                    table.insert(entries, {
                        Name = title,
                        Type = el.ConfigType or "Element",
                        Category = el._parentTab.Title .. " > " .. el._parentSection.Title,
                        Tab = el._parentTab,
                        Section = el._parentSection,
                        Element = el,
                        SearchText = string.lower(title .. " " .. el._parentTab.Title .. " " .. el._parentSection.Title .. " " .. (el.ConfigType or "")),
                        Order = 1,
                    })
                end
            end
            for _, custom in ipairs(Window._searchEntries) do
                table.insert(entries, {
                    Name = custom.Name,
                    Type = custom.Category or "Command",
                    Category = custom.Category or "Commands",
                    Callback = custom.Callback,
                    Icon = custom.Icon,
                    SearchText = string.lower(custom.Name .. " " .. (custom.Category or "")),
                    Order = 0,
                })
            end
            return entries
        end

        local function renderResults(filter)
            for _, c in ipairs(resultList:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end
            local entries = buildEntries()
            local matches = {}
            for _, entry in ipairs(entries) do
                if filter == "" or string.find(entry.SearchText, string.lower(filter), 1, true) then
                    table.insert(matches, entry)
                end
            end
            table.sort(matches, function(a, b)
                if a.Order ~= b.Order then return a.Order < b.Order end
                return a.Name < b.Name
            end)
            for i, entry in ipairs(matches) do
                local row = New("TextButton", {
                    Size = UDim2.new(1, 0, 0, 40),
                    BackgroundColor3 = GetTheme("Element"),
                    BackgroundTransparency = 0.95,
                    Text = "",
                    AutoButtonColor = false,
                    LayoutOrder = i,
                    Parent = resultList
                }, {
                    New("UICorner", { CornerRadius = UDim.new(0, 6) })
                })
                Register(row, { BackgroundColor3 = "Element" })

                local iconName = entry.Icon or typeToIcon[entry.Type] or "circle"

                local icon = New("ImageLabel", {
                    Image = "",
                    ImageColor3 = GetTheme("SubText"),
                    Size = UDim2.fromOffset(16, 16),
                    Position = UDim2.fromOffset(12, 12),
                    BackgroundTransparency = 1,
                    Parent = row
                })
                Register(icon, { ImageColor3 = "SubText" })
                CentrixUI:ResolveIcon(iconName, function(asset)
                    if asset and icon and icon.Parent then
                        icon.Image = asset
                    end
                end)

                local label = New("TextLabel", {
                    FontFace = FONT_MEDIUM,
                    Text = entry.Name,
                    TextColor3 = GetTheme("Text"),
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, -60, 0, 18),
                    Position = UDim2.fromOffset(38, 5),
                    BackgroundTransparency = 1,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Parent = row
                })
                Register(label, { TextColor3 = "Text" })

                local cat = New("TextLabel", {
                    FontFace = FONT,
                    Text = entry.Category,
                    TextColor3 = GetTheme("SubText"),
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.new(1, -60, 0, 14),
                    Position = UDim2.fromOffset(38, 22),
                    BackgroundTransparency = 1,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    Parent = row
                })
                Register(cat, { TextColor3 = "SubText" })

                row.MouseEnter:Connect(function()
                    Tween(row, 0.12, { BackgroundTransparency = 0.9 })
                end)
                row.MouseLeave:Connect(function()
                    Tween(row, 0.12, { BackgroundTransparency = 0.95 })
                end)
                row.MouseButton1Click:Connect(function()
                    Window._closeSearch()
                    if entry.Callback then
                        SafeCallback(entry.Callback)
                    elseif entry.Element then
                        Window:JumpToElement(entry.Element)
                    end
                end)
            end
        end

        searchInput:GetPropertyChangedSignal("Text"):Connect(function()
            renderResults(searchInput.Text)
        end)

        backdrop.MouseButton1Click:Connect(function()
            Window._closeSearch()
        end)

        Window._searchOverlay = overlay
        Window._searchPanel = panel
        Window._searchInput = searchInput
        Window._searchBackdrop = backdrop

        Window._openSearch = function()
            overlay.Visible = true
            searchInput.Text = ""
            renderResults("")
            Tween(backdrop, 0.2, { BackgroundTransparency = 0.5 })
            panel.GroupTransparency = 1
            panel.Position = UDim2.new(0.5, 0, 0.15, 0)
            Tween(panel, 0.25, { GroupTransparency = 0, Position = UDim2.new(0.5, 0, 0.2, 0) }, Enum.EasingStyle.Quart)
            task.defer(function()
                if searchInput then
                    searchInput:CaptureFocus()
                end
            end)
        end

        Window._closeSearch = function()
            Tween(backdrop, 0.15, { BackgroundTransparency = 1 })
            Tween(panel, 0.2, { GroupTransparency = 1 })
            task.delay(0.2, function()
                if overlay then overlay.Visible = false end
                if searchInput then searchInput:ReleaseFocus() end
            end)
        end

        track(UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Window._searchKey and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                if overlay.Visible then
                    Window._closeSearch()
                else
                    Window._openSearch()
                end
            end
        end))

        track(UserInputService.InputEnded:Connect(function(input)
            if overlay.Visible and input.KeyCode == Enum.KeyCode.Escape then
                Window._closeSearch()
            end
        end))
    end

    function Window:EnableIsland(icfg)
        icfg = icfg or {}
        if Window._IslandRoot then return Window._IslandRoot end

        local YOffset = icfg.YOffset or 40
        local OpenText = icfg.OpenText or "open"
        local CloseText = icfg.CloseText or "close"
        local CompactW = icfg.CompactWidth or 90
        local CompactH = icfg.CompactHeight or 32
        local ExpandW = icfg.ExpandedWidth or 360
        local ExpandH = icfg.ExpandedHeight or 76
        local DefaultDuration = icfg.Duration or 4

        local Holder = New("Frame", {
            Name = "IslandHolder",
            Size = UDim2.fromOffset(420, 200),
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, YOffset),
            BackgroundTransparency = 1,
            ZIndex = 950,
            Parent = ScreenGui
        })

        local Island = New("CanvasGroup", {
            Name = "Island",
            Size = UDim2.fromOffset(CompactW, CompactH),
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 0),
            BackgroundColor3 = GetTheme("Background2"),
            BackgroundTransparency = 0.05,
            GroupTransparency = 0,
            ZIndex = 951,
            Parent = Holder
        }, {
            New("UICorner", { CornerRadius = UDim.new(1, 0) }),
            New("UIStroke", {
                Color = GetTheme("Border"),
                Thickness = 1.5,
                Transparency = 0.2,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            })
        })
        Register(Island, { BackgroundColor3 = "Background2" })

        local IslandScale = New("UIScale", { Scale = 1, Parent = Island })

        local ToggleText = New("TextLabel", {
            Name = "ToggleText",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = OpenText,
            FontFace = FONT_MEDIUM,
            TextColor3 = GetTheme("Text"),
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 952,
            Parent = Island
        })
        Register(ToggleText, { TextColor3 = "Text" })

        local NotifFrame = New("Frame", {
            Name = "NotifFrame",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Visible = false,
            ZIndex = 952,
            Parent = Island
        })

        local IconFrame = New("Frame", {
            Size = UDim2.fromOffset(44, 44),
            Position = UDim2.new(0, 16, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = GetTheme("Element"),
            BackgroundTransparency = 0.9,
            ZIndex = 953,
            Parent = NotifFrame
        }, {
            New("UICorner", { CornerRadius = UDim.new(1, 0) })
        })
        Register(IconFrame, { BackgroundColor3 = "Element" })

        local IconImage = New("ImageLabel", {
            Size = UDim2.fromOffset(20, 20),
            Position = UDim2.fromScale(0.5, 0.5),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Image = "",
            ZIndex = 954,
            Parent = IconFrame
        })

        local TextHolder = New("Frame", {
            Size = UDim2.new(1, -80, 1, 0),
            Position = UDim2.fromOffset(72, 0),
            BackgroundTransparency = 1,
            ZIndex = 953,
            Parent = NotifFrame
        })

        local TitleLabel = New("TextLabel", {
            Size = UDim2.new(1, 0, 0, 20),
            Position = UDim2.new(0, 0, 0.5, -18),
            BackgroundTransparency = 1,
            FontFace = FONT_BOLD,
            TextColor3 = GetTheme("Text"),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Text = "",
            ZIndex = 954,
            Parent = TextHolder
        })
        Register(TitleLabel, { TextColor3 = "Text" })

        local DescLabel = New("TextLabel", {
            Size = UDim2.new(1, 0, 0, 16),
            Position = UDim2.new(0, 0, 0.5, 4),
            BackgroundTransparency = 1,
            FontFace = FONT,
            TextColor3 = GetTheme("SubText"),
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            Text = "",
            ZIndex = 954,
            Parent = TextHolder
        })
        Register(DescLabel, { TextColor3 = "SubText" })

        local ProgressTrack = New("Frame", {
            Size = UDim2.new(1, -32, 0, 2),
            Position = UDim2.new(0, 16, 1, -8),
            BackgroundColor3 = GetTheme("Border"),
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            ZIndex = 953,
            Parent = NotifFrame
        }, {
            New("UICorner", { CornerRadius = UDim.new(1, 0) })
        })
        Register(ProgressTrack, { BackgroundColor3 = "Border" })

        local ProgressFill = New("Frame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = GetTheme("Accent"),
            BorderSizePixel = 0,
            ZIndex = 954,
            Parent = ProgressTrack
        }, {
            New("UICorner", { CornerRadius = UDim.new(1, 0) })
        })
        Register(ProgressFill, { BackgroundColor3 = "Accent" })

        local State = "toggle"
        local NotifQueue = {}
        local CurrentNotification = nil
        local CurrentNotificationId = 0
        local ToggleLock = false
        local showNotification

        local function getCorner() return Island:FindFirstChildOfClass("UICorner") end

        local function animateTo(w, h, isPill, duration)
            Tween(Island, duration, { Size = UDim2.fromOffset(w, h) }, Enum.EasingStyle.Quart)
            local corner = getCorner()
            if corner then
                local target = isPill and UDim.new(1, 0) or UDim.new(0, 24)
                Tween(corner, duration, { CornerRadius = target }, Enum.EasingStyle.Quart)
            end
        end

        local function updateToggleText()
            ToggleText.Text = Main.Visible and CloseText or OpenText
        end

        local function showToggle()
            State = "toggle"
            ToggleText.Visible = true
            NotifFrame.Visible = false
            animateTo(CompactW, CompactH, true, 0.4)
            updateToggleText()
        end

        local function dismissCurrent()
            if State ~= "notify" then return end
            CurrentNotification = nil
            if #NotifQueue > 0 then
                local nextNotif = table.remove(NotifQueue, 1)
                showNotification(nextNotif)
            else
                showToggle()
            end
        end

        showNotification = function(ncfg)
            State = "notify"
            CurrentNotification = ncfg
            CurrentNotificationId = CurrentNotificationId + 1
            local notificationId = CurrentNotificationId
            ToggleText.Visible = false
            NotifFrame.Visible = true

            TitleLabel.Text = ncfg.Title or "Notification"
            DescLabel.Text = ncfg.Content or ncfg.Detail or ncfg.Details or ""

            local colorKey = ColorKeyForType(ncfg.Type or "info")
            local hasCustomColor = ncfg.IconColor ~= nil

            IconImage.ImageColor3 = hasCustomColor and ncfg.IconColor or GetTheme(colorKey)

            local iconName = ncfg.Icon or TintIconForType(ncfg.Type or "info")
            local isCustomIcon = type(iconName) == "string" and (iconName:sub(1, 4) == "http" or iconName:sub(1, 11) == "rbxassetid:")

            if isCustomIcon and not hasCustomColor then
                IconImage.ImageColor3 = Color3.new(1, 1, 1)
            end

            CentrixUI:ResolveIcon(iconName, function(asset)
                if asset and IconImage and IconImage.Parent then
                    IconImage.Image = asset
                end
            end)

            local duration = ncfg.Duration or DefaultDuration

            task.spawn(function()
                if duration <= 0 then return end
                task.wait(duration)
                if State ~= "notify" or CurrentNotificationId ~= notificationId then return end
                if ProgressFill and ProgressFill.Parent then
                    Tween(ProgressFill, 0.18, { Size = UDim2.new(0, 0, 1, 0) }, Enum.EasingStyle.Linear)
                end
                task.wait(0.18)
                if State == "notify" and CurrentNotificationId == notificationId then
                    dismissCurrent()
                end
            end)

            ProgressFill.Size = UDim2.new(1, 0, 1, 0)
            if duration > 0 then
                Tween(ProgressFill, duration, { Size = UDim2.new(0, 0, 1, 0) }, Enum.EasingStyle.Linear)
            end
            animateTo(ExpandW, ExpandH, false, 0.45)
        end

        Window._IslandShowNotification = function(ncfg)
            if State == "notify" or #NotifQueue > 0 then
                table.insert(NotifQueue, ncfg)
            else
                showNotification(ncfg)
            end
        end

        function Window:IslandNotify(ncfg)
            if not Window._IslandRoot then
                warn("[CentrixUI] IslandNotify called but island not enabled. Call Window:EnableIsland() first.")
                return
            end
            ncfg = ncfg or {}
            if Window._IslandShowNotification then
                Window._IslandShowNotification(ncfg)
            end
        end

        function Window:SetIslandVisible(v)
            if Holder and Holder.Parent then
                Holder.Visible = not not v
            end
        end

        local IslandButton = New("TextButton", {
            Name = "IslandButton",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            Text = "",
            AutoButtonColor = false,
            Active = true,
            Selectable = false,
            ZIndex = 955,
            Parent = Island
        })

        Island.MouseEnter:Connect(function()
            if State == "toggle" then
                Tween(Island, 0.15, { BackgroundTransparency = 0 })
            end
        end)
        Island.MouseLeave:Connect(function()
            if State == "toggle" then
                Tween(Island, 0.15, { BackgroundTransparency = 0.05 })
            end
        end)
        IslandButton.MouseButton1Down:Connect(function()
            if State == "toggle" then
                Tween(IslandScale, 0.08, { Scale = 0.94 })
            end
        end)
        IslandButton.MouseButton1Up:Connect(function()
            if State == "toggle" then
                Tween(IslandScale, 0.12, { Scale = 1 })
            end
        end)
        IslandButton.MouseButton1Click:Connect(function()
            if State == "notify" then
                local current = CurrentNotification
                local detail = current and (current.Detail or current.Details)
                if detail and detail ~= "" and not current._DetailShown then
                    current._DetailShown = true
                    Window:NotifyDialog({
                        Title = current.Title or "Notification",
                        Content = current.Content or "",
                        Detail = detail,
                        Type = current.Type,
                        Icon = current.Icon,
                        IconColor = current.IconColor,
                        Buttons = current.Buttons
                    })
                else
                    dismissCurrent()
                end
            elseif not ToggleLock then
                ToggleLock = true
                Window:Toggle()
                task.wait(0.05)
                updateToggleText()
                task.delay(0.35, function()
                    ToggleLock = false
                end)
            end
        end)

        task.spawn(function()
            while Holder and Holder.Parent and not Window.Destroyed do
                updateToggleText()
                task.wait(0.15)
            end
        end)

        updateToggleText()

        Window._IslandRoot = Holder
        Window._IslandComponent = Island
        Window._IslandToggleText = ToggleText

        return Holder
    end

    function Window:Minimize()
        self.Minimized = not self.Minimized
        if self.Minimized then
            local scale = New("UIScale", { Scale = 1, Parent = Main })
            Tween(scale, 0.25, { Scale = 0.85 }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
            Tween(Main, 0.22, { BackgroundTransparency = 0.5 })
            task.delay(0.25, function()
                Main.Visible = false
                Main.BackgroundTransparency = 0
                if scale then scale:Destroy() end
            end)
        else
            Main.Visible = true
            Main.BackgroundTransparency = 0.5
            local scale = New("UIScale", { Scale = 0.85, Parent = Main })
            Tween(scale, 0.32, { Scale = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            Tween(Main, 0.25, { BackgroundTransparency = 0 })
            task.delay(0.35, function()
                if scale then scale:Destroy() end
            end)
        end
    end

    function Window:Toggle()
        if Main.Visible then
            Window:Minimize()
        else
            if Window.Minimized then
                Window:Minimize()
            else
                Main.Visible = true
            end
        end
    end

    function Window:Maximize(bool)
        self.Maximized = not not bool
        local maxBtnIcon = MaxBtn:FindFirstChildOfClass("ImageLabel")
        if maxBtnIcon then
            CentrixUI:ResolveIcon(self.Maximized and "minimize" or "maximize", function(asset)
                if asset and maxBtnIcon and maxBtnIcon.Parent then
                    maxBtnIcon.Image = asset
                end
            end)
        end
        if self.Maximized then
            self.PrevSize = Main.Size
            self.PrevPos = Main.Position
            local vs = workspace.CurrentCamera.ViewportSize
            Tween(Main, 0.25, {
                Size = UDim2.fromOffset(vs.X, vs.Y),
                Position = UDim2.fromOffset(0, 0)
            }, Enum.EasingStyle.Quart)
        else
            if self.PrevSize then
                Tween(Main, 0.25, {
                    Size = self.PrevSize,
                    Position = self.PrevPos or Main.Position
                }, Enum.EasingStyle.Quart)
            end
        end
        task.defer(function()
            self.Size = Main.Size
            self.Position = Main.Position
            updateShadow()
        end)
    end

    function Window:SetSize(size)
        self.Size = size
        Tween(Main, 0.18, { Size = size }, Enum.EasingStyle.Quart)
    end

    function Window:SetPosition(pos)
        self.Position = pos
        Tween(Main, 0.18, { Position = pos }, Enum.EasingStyle.Quart)
    end

    function Window:SetCornerRadius(radius)
        local corner = Main:FindFirstChildOfClass("UICorner")
        if corner then corner.CornerRadius = radius end
    end

    function Window:SetOpacity(alpha)
        self._opacity = math.clamp(alpha or 1, 0, 1)
        Main.GroupTransparency = 1 - self._opacity
        if Shadow and Shadow.Parent then
            Shadow.ImageTransparency = 0.65 + 0.35 * (1 - self._opacity)
        end
    end

    function Window:SetScale(scale)
        local s = Main:FindFirstChildOfClass("UIScale")
        if not s then s = Instance.new("UIScale", Main) end
        s.Scale = scale
    end

    function Window:SetFont(font)
        for _, d in ipairs(Main:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                pcall(function() d.FontFace = font end)
            end
        end
    end

    function Window:SetResizable(bool)
        self._resizable = not not bool
        if self._resizeHandle then self._resizeHandle.Visible = bool end
    end

    function Window:SetDraggable(bool)
        self._draggable = not not bool
    end

    function Window:SetVisible(bool)
        Main.Visible = not not bool
    end

    function Window:SetTitle(text)
        TitleLabel.Text = text
    end

    function Window:SetSubTitle(text)
        SubTitleLabel.Text = text or ""
    end

    local PRESET_FOLDER = "Centrix/Presets"

    function Window:SavePreset(name)
        if not FileIO.CanSave or not name or name == "" then return false, "No file access" end
        FileIO.EnsureFolder("Centrix")
        FileIO.EnsureFolder(PRESET_FOLDER)
        local lines = {}
        for _, el in ipairs(self._allElements) do
            if el.ConfigKey and el.ConfigType then
                local ok, v = pcall(SerializeValue, el)
                if ok and v ~= nil then
                    table.insert(lines, el.ConfigKey .. "=" .. tostring(v))
                end
            end
        end
        local ok = FileIO.Write(PRESET_FOLDER .. "/" .. name .. ".cfg", table.concat(lines, "\n"))
        return ok, ok and ("Preset '" .. name .. "' saved") or "Write failed"
    end

    function Window:LoadPreset(name)
        if not FileIO.CanLoad or not name then return false, "No file access" end
        local content = FileIO.Read(PRESET_FOLDER .. "/" .. name .. ".cfg")
        if not content or content == "" then return false, "Preset not found" end
        local config = {}
        for line in content:gmatch("[^\n]+") do
            local k, v = line:match("^([^=]+)=(.*)$")
            if k then config[k] = v end
        end
        for _, el in ipairs(self._allElements) do
            if el.ConfigKey and config[el.ConfigKey] ~= nil then
                pcall(function() DeserializeValue(el, config[el.ConfigKey]) end)
            end
        end
        return true, "Preset '" .. name .. "' loaded"
    end

    function Window:ListPresets()
        if not FileIO.CanList then return {} end
        local files = FileIO.ListFiles(PRESET_FOLDER)
        local out = {}
        for _, path in ipairs(files) do
            local name = path:match("([^/\\]+)%.cfg$")
            if name then table.insert(out, name) end
        end
        return out
    end

    function Window:DeletePreset(name)
        if not FileIO.CanDelete or not name then return false end
        return FileIO.DeleteFile(PRESET_FOLDER .. "/" .. name .. ".cfg")
    end

    function Window:OpenThemeEditor()
        local theme = Themes[CurrentTheme] or {}
        local keys = {}
        for k, v in pairs(theme) do
            if typeof(v) == "Color3" then
                table.insert(keys, k)
            end
        end
        table.sort(keys)

        local d = self:Dialog({
            Title = "Theme Editor - " .. CurrentTheme,
            Content = "",
            Buttons = {
                { Title = "Reset", Callback = function() CentrixUI:ResetThemeOverride(nil) end },
                { Title = "Close" }
            }
        })
        d.Root.Size = UDim2.fromOffset(460, 600)

        local list = New("ScrollingFrame", {
            Size = UDim2.new(1, -30, 1, -130),
            Position = UDim2.fromOffset(15, 60),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageTransparency = 0.9,
            ScrollBarImageColor3 = Color3.fromRGB(255, 255, 255),
            CanvasSize = UDim2.new(),
            Parent = d.Root
        }, {
            New("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder })
        })
        local listLayout = list:FindFirstChildOfClass("UIListLayout")
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            list.CanvasSize = UDim2.fromOffset(0, listLayout.AbsoluteContentSize.Y)
        end)

        for i, key in ipairs(keys) do
            local row = New("Frame", {
                Size = UDim2.new(1, -8, 0, 34),
                BackgroundColor3 = GetTheme("DialogInput"),
                BackgroundTransparency = 0.85,
                LayoutOrder = i,
                Parent = list
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 4) })
            })
            Register(row, { BackgroundColor3 = "DialogInput" })

            local label = New("TextLabel", {
                FontFace = FONT,
                Text = key,
                TextSize = 12,
                TextColor3 = GetTheme("Text"),
                TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2.new(1, -140, 1, 0),
                Position = UDim2.fromOffset(10, 0),
                BackgroundTransparency = 1,
                Parent = row
            })
            Register(label, { TextColor3 = "Text" })

            local swatch = New("Frame", {
                Size = UDim2.fromOffset(30, 20),
                Position = UDim2.new(1, -136, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = GetTheme(key),
                Parent = row
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 3) }),
                New("UIStroke", { Color = GetTheme("InnerBorder"), Transparency = 0.5, Thickness = 1 })
            })
            Register(swatch, { BackgroundColor3 = key })

            local hexBox = New("TextBox", {
                FontFace = FONT,
                Text = "#" .. GetTheme(key):ToHex(),
                TextSize = 11,
                TextColor3 = GetTheme("Text"),
                TextXAlignment = Enum.TextXAlignment.Center,
                BackgroundColor3 = GetTheme("DialogInput"),
                BackgroundTransparency = 0.5,
                Size = UDim2.fromOffset(76, 22),
                Position = UDim2.new(1, -96, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                ClearTextOnFocus = false,
                Parent = row
            }, {
                New("UICorner", { CornerRadius = UDim.new(0, 3) })
            })
            Register(hexBox, { TextColor3 = "Text", BackgroundColor3 = "DialogInput" })

            hexBox.FocusLost:Connect(function()
                local txt = hexBox.Text
                if txt:sub(1, 1) ~= "#" then txt = "#" .. txt end
                local ok, c = pcall(Color3.fromHex, txt)
                if ok and typeof(c) == "Color3" then
                    CentrixUI:OverrideTheme(key, c)
                    hexBox.Text = "#" .. c:ToHex()
                else
                    hexBox.Text = "#" .. GetTheme(key):ToHex()
                end
            end)
        end

        return d
    end

    function Window:Destroy()
        if self.Destroyed then return end
        self.Destroyed = true
        for _, conn in ipairs(self._connections) do
            pcall(function() conn:Disconnect() end)
        end
        self._connections = {}
        if ActiveWindow == self then ActiveWindow = nil end
        if Acrylic.Enabled then Acrylic.Disable() end
        local scale = New("UIScale", { Scale = 1, Parent = Main })
        Tween(scale, 0.28, { Scale = 0.8 }, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        Tween(Main, 0.25, { GroupTransparency = 1 })
        if Shadow and Shadow.Parent then
            Tween(Shadow, 0.25, { ImageTransparency = 1 })
        end
        task.delay(0.35, function()
            ClearRegistry()
            if ScreenGui and ScreenGui.Parent then ScreenGui:Destroy() end
        end)
    end

    local toggleImageId = cfg.Toggle_Image_Id
    if toggleImageId then
        task.spawn(function()
            LoadAssetAsync(toggleImageId, function(imageAsset)
                if not imageAsset or Window.Destroyed or not ScreenGui.Parent then return end
                task.defer(function()
                    if Window.Destroyed or not ScreenGui.Parent then return end
                    local BtnHolder = New("Frame", {
                        Size = UDim2.fromOffset(56, 56),
                        Position = UDim2.new(0.5, 0, 0, 14),
                        AnchorPoint = Vector2.new(0.5, 0),
                        BackgroundColor3 = GetTheme("Background2"),
                        BackgroundTransparency = 0.05,
                        ClipsDescendants = true,
                        ZIndex = 500,
                        Parent = ScreenGui
                    }, {
                        New("UICorner", { CornerRadius = UDim.new(0, 14) }),
                        New("UIStroke", {
                            Color = GetTheme("Border"),
                            Thickness = 1.5,
                            Transparency = 0.2
                        }),
                        New("UIPadding", {
                            PaddingTop = UDim.new(0, 6),
                            PaddingBottom = UDim.new(0, 6),
                            PaddingLeft = UDim.new(0, 6),
                            PaddingRight = UDim.new(0, 6)
                        })
                    })
                    Register(BtnHolder, { BackgroundColor3 = "Background2" })
                    local ImageBtn = New("ImageButton", {
                        Size = UDim2.fromScale(1, 1),
                        Position = UDim2.fromScale(0.5, 0.5),
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        BackgroundTransparency = 1,
                        Image = imageAsset,
                        ImageColor3 = Color3.fromRGB(255, 255, 255),
                        ScaleType = Enum.ScaleType.Fit,
                        ResamplerMode = Enum.ResamplerMode.Default,
                        ZIndex = 501,
                        Parent = BtnHolder
                    }, {
                        New("UIAspectRatioConstraint", {
                            AspectRatio = 1,
                            DominantAxis = Enum.DominantAxis.Width
                        })
                    })
                    ImageBtn.MouseEnter:Connect(function()
                        Tween(BtnHolder, 0.15, { BackgroundTransparency = 0 })
                        Tween(ImageBtn, 0.15, { Size = UDim2.fromScale(0.94, 0.94) })
                    end)
                    ImageBtn.MouseLeave:Connect(function()
                        Tween(BtnHolder, 0.15, { BackgroundTransparency = 0.05 })
                        Tween(ImageBtn, 0.15, { Size = UDim2.fromScale(1, 1) })
                    end)
                    ImageBtn.MouseButton1Down:Connect(function()
                        Tween(ImageBtn, 0.08, { Size = UDim2.fromScale(0.95, 0.95) })
                    end)
                    ImageBtn.MouseButton1Up:Connect(function()
                        Tween(ImageBtn, 0.12, { Size = UDim2.fromScale(0.94, 0.94) })
                    end)
                    ImageBtn.MouseButton1Click:Connect(function()
                        Window:Toggle()
                    end)
                    Window.ToggleButton = BtnHolder
                end)
            end)
        end)
    end

    ActiveWindow = Window

    local minimizeKey = cfg.MinimizeKey or Enum.KeyCode.RightControl
    track(UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == minimizeKey and not UserInputService:GetFocusedTextBox() then
            Window:Toggle()
        end
    end))

    if Window.AutoSave then
        task.delay(0.5, function()
            if not FileIO.CanLoad or Window.Destroyed then return end
            task.spawn(function()
                local path = Window.FolderName .. "/config.txt"
                local content = FileIO.Read(path)
                if not content or content == "" then return end
                local config = {}
                for line in content:gmatch("[^\n]+") do
                    local k, v = line:match("^([^=]+)=(.*)$")
                    if k then config[k] = v end
                end
                for _, el in ipairs(Window._allElements) do
                    if el.ConfigKey and config[el.ConfigKey] ~= nil then
                        pcall(function() DeserializeValue(el, config[el.ConfigKey]) end)
                    end
                end
            end)
        end)
    end

    return Window
end

function CentrixUI:Notify(ncfg)
    if ActiveWindow and not ActiveWindow.Destroyed then
        return ActiveWindow:Notify(ncfg)
    end
    warn("[CentrixUI] Notify called but no active window")
    return nil
end

function CentrixUI:IslandNotify(ncfg)
    if ActiveWindow and not ActiveWindow.Destroyed then
        return ActiveWindow:IslandNotify(ncfg)
    end
    return nil
end

function CentrixUI:NotifyDialog(ncfg)
    if ActiveWindow and not ActiveWindow.Destroyed then
        return ActiveWindow:NotifyDialog(ncfg)
    end
    return nil
end

function CentrixUI:ToggleAcrylic(bool)
    if bool then Acrylic.Enable() else Acrylic.Disable() end
end

function CentrixUI:GetConfigPath(foldername)
    return (foldername or "Centrix") .. "/config.txt"
end

function CentrixUI:ResetConfig(foldername)
    local path = (foldername or "Centrix") .. "/config.txt"
    if FileIO.CanSave then
        FileIO.Write(path, "")
        return true
    end
    return false
end

function CentrixUI:GetHiddenMode()
    return UsedHidden
end

if getgenv then
    getgenv().CentrixUI = CentrixUI
end

return CentrixUI
