local CentrixUI = {}
CentrixUI.Version = "4.6.0"

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

local Assets = {
    ["lucide-accessibility"] = "rbxassetid://10709751939",
    ["lucide-activity"] = "rbxassetid://10709752035",
    ["lucide-air-vent"] = "rbxassetid://10709752131",
    ["lucide-airplay"] = "rbxassetid://10709752254",
    ["lucide-alarm-check"] = "rbxassetid://10709752405",
    ["lucide-alarm-clock"] = "rbxassetid://10709752630",
    ["lucide-alarm-clock-off"] = "rbxassetid://10709752508",
    ["lucide-alarm-minus"] = "rbxassetid://10709752732",
    ["lucide-alarm-plus"] = "rbxassetid://10709752825",
    ["lucide-album"] = "rbxassetid://10709752906",
    ["lucide-alert-circle"] = "rbxassetid://10709752996",
    ["lucide-alert-octagon"] = "rbxassetid://10709753064",
    ["lucide-alert-triangle"] = "rbxassetid://10709753149",
    ["lucide-align-center"] = "rbxassetid://10709753570",
    ["lucide-align-center-horizontal"] = "rbxassetid://10709753272",
    ["lucide-align-center-vertical"] = "rbxassetid://10709753421",
    ["lucide-align-end-horizontal"] = "rbxassetid://10709753692",
    ["lucide-align-end-vertical"] = "rbxassetid://10709753808",
    ["lucide-align-horizontal-distribute-center"] = "rbxassetid://10747779791",
    ["lucide-align-horizontal-distribute-end"] = "rbxassetid://10747784534",
    ["lucide-align-horizontal-distribute-start"] = "rbxassetid://10709754118",
    ["lucide-align-horizontal-justify-center"] = "rbxassetid://10709754204",
    ["lucide-align-horizontal-justify-end"] = "rbxassetid://10709754317",
    ["lucide-align-horizontal-justify-start"] = "rbxassetid://10709754436",
    ["lucide-align-horizontal-space-around"] = "rbxassetid://10709754590",
    ["lucide-align-horizontal-space-between"] = "rbxassetid://10709754749",
    ["lucide-align-justify"] = "rbxassetid://10709759610",
    ["lucide-align-left"] = "rbxassetid://10709759764",
    ["lucide-align-right"] = "rbxassetid://10709759895",
    ["lucide-align-start-horizontal"] = "rbxassetid://10709760051",
    ["lucide-align-start-vertical"] = "rbxassetid://10709760244",
    ["lucide-align-vertical-distribute-center"] = "rbxassetid://10709760351",
    ["lucide-align-vertical-distribute-end"] = "rbxassetid://10709760434",
    ["lucide-align-vertical-distribute-start"] = "rbxassetid://10709760612",
    ["lucide-align-vertical-justify-center"] = "rbxassetid://10709760814",
    ["lucide-align-vertical-justify-end"] = "rbxassetid://10709761003",
    ["lucide-align-vertical-justify-start"] = "rbxassetid://10709761176",
    ["lucide-align-vertical-space-around"] = "rbxassetid://10709761324",
    ["lucide-align-vertical-space-between"] = "rbxassetid://10709761434",
    ["lucide-anchor"] = "rbxassetid://10709761530",
    ["lucide-angry"] = "rbxassetid://10709761629",
    ["lucide-annoyed"] = "rbxassetid://10709761722",
    ["lucide-aperture"] = "rbxassetid://10709761813",
    ["lucide-apple"] = "rbxassetid://10709761889",
    ["lucide-archive"] = "rbxassetid://10709762233",
    ["lucide-archive-restore"] = "rbxassetid://10709762058",
    ["lucide-armchair"] = "rbxassetid://10709762327",
    ["lucide-arrow-big-down"] = "rbxassetid://10747796644",
    ["lucide-arrow-big-left"] = "rbxassetid://10709762574",
    ["lucide-arrow-big-right"] = "rbxassetid://10709762727",
    ["lucide-arrow-big-up"] = "rbxassetid://10709762879",
    ["lucide-arrow-down"] = "rbxassetid://10709767827",
    ["lucide-arrow-down-circle"] = "rbxassetid://10709763034",
    ["lucide-arrow-down-left"] = "rbxassetid://10709767656",
    ["lucide-arrow-down-right"] = "rbxassetid://10709767750",
    ["lucide-arrow-left"] = "rbxassetid://10709768114",
    ["lucide-arrow-left-circle"] = "rbxassetid://10709767936",
    ["lucide-arrow-left-right"] = "rbxassetid://10709768019",
    ["lucide-arrow-right"] = "rbxassetid://10709768347",
    ["lucide-arrow-right-circle"] = "rbxassetid://10709768226",
    ["lucide-arrow-up"] = "rbxassetid://10709768939",
    ["lucide-arrow-up-circle"] = "rbxassetid://10709768432",
    ["lucide-arrow-up-down"] = "rbxassetid://10709768538",
    ["lucide-arrow-up-left"] = "rbxassetid://10709768661",
    ["lucide-arrow-up-right"] = "rbxassetid://10709768787",
    ["lucide-asterisk"] = "rbxassetid://10709769095",
    ["lucide-at-sign"] = "rbxassetid://10709769286",
    ["lucide-award"] = "rbxassetid://10709769406",
    ["lucide-axe"] = "rbxassetid://10709769508",
    ["lucide-axis-3d"] = "rbxassetid://10709769598",
    ["lucide-baby"] = "rbxassetid://10709769732",
    ["lucide-backpack"] = "rbxassetid://10709769841",
    ["lucide-baggage-claim"] = "rbxassetid://10709769935",
    ["lucide-banana"] = "rbxassetid://10709770005",
    ["lucide-banknote"] = "rbxassetid://10709770178",
    ["lucide-bar-chart"] = "rbxassetid://10709773755",
    ["lucide-bar-chart-2"] = "rbxassetid://10709770317",
    ["lucide-bar-chart-3"] = "rbxassetid://10709770431",
    ["lucide-bar-chart-4"] = "rbxassetid://10709770560",
    ["lucide-bar-chart-horizontal"] = "rbxassetid://10709773669",
    ["lucide-barcode"] = "rbxassetid://10747360675",
    ["lucide-baseline"] = "rbxassetid://10709773863",
    ["lucide-bath"] = "rbxassetid://10709773963",
    ["lucide-battery"] = "rbxassetid://10709774640",
    ["lucide-battery-charging"] = "rbxassetid://10709774068",
    ["lucide-battery-full"] = "rbxassetid://10709774206",
    ["lucide-battery-low"] = "rbxassetid://10709774370",
    ["lucide-battery-medium"] = "rbxassetid://10709774513",
    ["lucide-beaker"] = "rbxassetid://10709774756",
    ["lucide-bed"] = "rbxassetid://10709775036",
    ["lucide-bed-double"] = "rbxassetid://10709774864",
    ["lucide-bed-single"] = "rbxassetid://10709774968",
    ["lucide-beer"] = "rbxassetid://10709775167",
    ["lucide-bell"] = "rbxassetid://10709775704",
    ["lucide-bell-minus"] = "rbxassetid://10709775241",
    ["lucide-bell-off"] = "rbxassetid://10709775320",
    ["lucide-bell-plus"] = "rbxassetid://10709775448",
    ["lucide-bell-ring"] = "rbxassetid://10709775560",
    ["lucide-bike"] = "rbxassetid://10709775894",
    ["lucide-binary"] = "rbxassetid://10709776050",
    ["lucide-bitcoin"] = "rbxassetid://10709776126",
    ["lucide-bluetooth"] = "rbxassetid://10709776655",
    ["lucide-bluetooth-connected"] = "rbxassetid://10709776240",
    ["lucide-bluetooth-off"] = "rbxassetid://10709776344",
    ["lucide-bluetooth-searching"] = "rbxassetid://10709776501",
    ["lucide-bold"] = "rbxassetid://10747813908",
    ["lucide-bomb"] = "rbxassetid://10709781460",
    ["lucide-bone"] = "rbxassetid://10709781605",
    ["lucide-book"] = "rbxassetid://10709781824",
    ["lucide-book-open"] = "rbxassetid://10709781717",
    ["lucide-bookmark"] = "rbxassetid://10709782154",
    ["lucide-bookmark-minus"] = "rbxassetid://10709781919",
    ["lucide-bookmark-plus"] = "rbxassetid://10709782044",
    ["lucide-bot"] = "rbxassetid://10709782230",
    ["lucide-box"] = "rbxassetid://10709782497",
    ["lucide-box-select"] = "rbxassetid://10709782342",
    ["lucide-boxes"] = "rbxassetid://10709782582",
    ["lucide-briefcase"] = "rbxassetid://10709782662",
    ["lucide-brush"] = "rbxassetid://10709782758",
    ["lucide-bug"] = "rbxassetid://10709782845",
    ["lucide-building"] = "rbxassetid://10709783051",
    ["lucide-building-2"] = "rbxassetid://10709782939",
    ["lucide-bus"] = "rbxassetid://10709783137",
    ["lucide-cake"] = "rbxassetid://10709783217",
    ["lucide-calculator"] = "rbxassetid://10709783311",
    ["lucide-calendar"] = "rbxassetid://10709789505",
    ["lucide-calendar-check"] = "rbxassetid://10709783474",
    ["lucide-calendar-check-2"] = "rbxassetid://10709783392",
    ["lucide-calendar-clock"] = "rbxassetid://10709783577",
    ["lucide-calendar-days"] = "rbxassetid://10709783673",
    ["lucide-calendar-heart"] = "rbxassetid://10709783835",
    ["lucide-calendar-minus"] = "rbxassetid://10709783959",
    ["lucide-calendar-off"] = "rbxassetid://10709788784",
    ["lucide-calendar-plus"] = "rbxassetid://10709788937",
    ["lucide-calendar-range"] = "rbxassetid://10709789053",
    ["lucide-calendar-search"] = "rbxassetid://10709789200",
    ["lucide-calendar-x"] = "rbxassetid://10709789407",
    ["lucide-calendar-x-2"] = "rbxassetid://10709789329",
    ["lucide-camera"] = "rbxassetid://10709789686",
    ["lucide-camera-off"] = "rbxassetid://10747822677",
    ["lucide-car"] = "rbxassetid://10709789810",
    ["lucide-carrot"] = "rbxassetid://10709789960",
    ["lucide-cast"] = "rbxassetid://10709790097",
    ["lucide-charge"] = "rbxassetid://10709790202",
    ["lucide-check"] = "rbxassetid://10709790644",
    ["lucide-check-circle"] = "rbxassetid://10709790387",
    ["lucide-check-circle-2"] = "rbxassetid://10709790298",
    ["lucide-check-square"] = "rbxassetid://10709790537",
    ["lucide-chef-hat"] = "rbxassetid://10709790757",
    ["lucide-cherry"] = "rbxassetid://10709790875",
    ["lucide-chevron-down"] = "rbxassetid://10709790948",
    ["lucide-chevron-first"] = "rbxassetid://10709791015",
    ["lucide-chevron-last"] = "rbxassetid://10709791130",
    ["lucide-chevron-left"] = "rbxassetid://10709791281",
    ["lucide-chevron-right"] = "rbxassetid://10709791437",
    ["lucide-chevron-up"] = "rbxassetid://10709791523",
    ["lucide-chevrons-down"] = "rbxassetid://10709796864",
    ["lucide-chevrons-down-up"] = "rbxassetid://10709791632",
    ["lucide-chevrons-left"] = "rbxassetid://10709797151",
    ["lucide-chevrons-left-right"] = "rbxassetid://10709797006",
    ["lucide-chevrons-right"] = "rbxassetid://10709797382",
    ["lucide-chevrons-right-left"] = "rbxassetid://10709797274",
    ["lucide-chevrons-up"] = "rbxassetid://10709797622",
    ["lucide-chevrons-up-down"] = "rbxassetid://10709797508",
    ["lucide-chrome"] = "rbxassetid://10709797725",
    ["lucide-circle"] = "rbxassetid://10709798174",
    ["lucide-circle-dot"] = "rbxassetid://10709797837",
    ["lucide-circle-ellipsis"] = "rbxassetid://10709797985",
    ["lucide-circle-slashed"] = "rbxassetid://10709798100",
    ["lucide-citrus"] = "rbxassetid://10709798276",
    ["lucide-clapperboard"] = "rbxassetid://10709798350",
    ["lucide-clipboard"] = "rbxassetid://10709799288",
    ["lucide-clipboard-check"] = "rbxassetid://10709798443",
    ["lucide-clipboard-copy"] = "rbxassetid://10709798574",
    ["lucide-clipboard-edit"] = "rbxassetid://10709798682",
    ["lucide-clipboard-list"] = "rbxassetid://10709798792",
    ["lucide-clipboard-signature"] = "rbxassetid://10709798890",
    ["lucide-clipboard-type"] = "rbxassetid://10709798999",
    ["lucide-clipboard-x"] = "rbxassetid://10709799124",
    ["lucide-clock"] = "rbxassetid://10709805144",
    ["lucide-clock-1"] = "rbxassetid://10709799535",
    ["lucide-clock-10"] = "rbxassetid://10709799718",
    ["lucide-clock-11"] = "rbxassetid://10709799818",
    ["lucide-clock-12"] = "rbxassetid://10709799962",
    ["lucide-clock-2"] = "rbxassetid://10709803876",
    ["lucide-clock-3"] = "rbxassetid://10709803989",
    ["lucide-clock-4"] = "rbxassetid://10709804164",
    ["lucide-clock-5"] = "rbxassetid://10709804291",
    ["lucide-clock-6"] = "rbxassetid://10709804435",
    ["lucide-clock-7"] = "rbxassetid://10709804599",
    ["lucide-clock-8"] = "rbxassetid://10709804784",
    ["lucide-clock-9"] = "rbxassetid://10709804996",
    ["lucide-cloud"] = "rbxassetid://10709806740",
    ["lucide-cloud-cog"] = "rbxassetid://10709805262",
    ["lucide-cloud-drizzle"] = "rbxassetid://10709805371",
    ["lucide-cloud-fog"] = "rbxassetid://10709805477",
    ["lucide-cloud-hail"] = "rbxassetid://10709805596",
    ["lucide-cloud-lightning"] = "rbxassetid://10709805727",
    ["lucide-cloud-moon"] = "rbxassetid://10709805942",
    ["lucide-cloud-moon-rain"] = "rbxassetid://10709805838",
    ["lucide-cloud-off"] = "rbxassetid://10709806060",
    ["lucide-cloud-rain"] = "rbxassetid://10709806277",
    ["lucide-cloud-rain-wind"] = "rbxassetid://10709806166",
    ["lucide-cloud-snow"] = "rbxassetid://10709806374",
    ["lucide-cloud-sun"] = "rbxassetid://10709806631",
    ["lucide-cloud-sun-rain"] = "rbxassetid://10709806475",
    ["lucide-cloudy"] = "rbxassetid://10709806859",
    ["lucide-clover"] = "rbxassetid://10709806995",
    ["lucide-code"] = "rbxassetid://10709810463",
    ["lucide-code-2"] = "rbxassetid://10709807111",
    ["lucide-codepen"] = "rbxassetid://10709810534",
    ["lucide-codesandbox"] = "rbxassetid://10709810676",
    ["lucide-coffee"] = "rbxassetid://10709810814",
    ["lucide-cog"] = "rbxassetid://10709810948",
    ["lucide-coins"] = "rbxassetid://10709811110",
    ["lucide-columns"] = "rbxassetid://10709811261",
    ["lucide-command"] = "rbxassetid://10709811365",
    ["lucide-compass"] = "rbxassetid://10709811445",
    ["lucide-component"] = "rbxassetid://10709811595",
    ["lucide-concierge-bell"] = "rbxassetid://10709811706",
    ["lucide-connection"] = "rbxassetid://10747361219",
    ["lucide-contact"] = "rbxassetid://10709811834",
    ["lucide-contrast"] = "rbxassetid://10709811939",
    ["lucide-cookie"] = "rbxassetid://10709812067",
    ["lucide-copy"] = "rbxassetid://10709812159",
    ["lucide-copyleft"] = "rbxassetid://10709812251",
    ["lucide-copyright"] = "rbxassetid://10709812311",
    ["lucide-corner-down-left"] = "rbxassetid://10709812396",
    ["lucide-corner-down-right"] = "rbxassetid://10709812485",
    ["lucide-corner-left-down"] = "rbxassetid://10709812632",
    ["lucide-corner-left-up"] = "rbxassetid://10709812784",
    ["lucide-corner-right-down"] = "rbxassetid://10709812939",
    ["lucide-corner-right-up"] = "rbxassetid://10709813094",
    ["lucide-corner-up-left"] = "rbxassetid://10709813185",
    ["lucide-corner-up-right"] = "rbxassetid://10709813281",
    ["lucide-cpu"] = "rbxassetid://10709813383",
    ["lucide-croissant"] = "rbxassetid://10709818125",
    ["lucide-crop"] = "rbxassetid://10709818245",
    ["lucide-cross"] = "rbxassetid://10709818399",
    ["lucide-crosshair"] = "rbxassetid://10709818534",
    ["lucide-crown"] = "rbxassetid://10709818626",
    ["lucide-cup-soda"] = "rbxassetid://10709818763",
    ["lucide-curly-braces"] = "rbxassetid://10709818847",
    ["lucide-currency"] = "rbxassetid://10709818931",
    ["lucide-database"] = "rbxassetid://10709818996",
    ["lucide-delete"] = "rbxassetid://10709819059",
    ["lucide-diamond"] = "rbxassetid://10709819149",
    ["lucide-dice-1"] = "rbxassetid://10709819266",
    ["lucide-dice-2"] = "rbxassetid://10709819361",
    ["lucide-dice-3"] = "rbxassetid://10709819508",
    ["lucide-dice-4"] = "rbxassetid://10709819670",
    ["lucide-dice-5"] = "rbxassetid://10709819801",
    ["lucide-dice-6"] = "rbxassetid://10709819896",
    ["lucide-dices"] = "rbxassetid://10723343321",
    ["lucide-diff"] = "rbxassetid://10723343416",
    ["lucide-disc"] = "rbxassetid://10723343537",
    ["lucide-divide"] = "rbxassetid://10723343805",
    ["lucide-divide-circle"] = "rbxassetid://10723343636",
    ["lucide-divide-square"] = "rbxassetid://10723343737",
    ["lucide-dollar-sign"] = "rbxassetid://10723343958",
    ["lucide-download"] = "rbxassetid://10723344270",
    ["lucide-download-cloud"] = "rbxassetid://10723344088",
    ["lucide-droplet"] = "rbxassetid://10723344432",
    ["lucide-droplets"] = "rbxassetid://10734883356",
    ["lucide-drumstick"] = "rbxassetid://10723344737",
    ["lucide-edit"] = "rbxassetid://10734883598",
    ["lucide-edit-2"] = "rbxassetid://10723344885",
    ["lucide-edit-3"] = "rbxassetid://10723345088",
    ["lucide-egg"] = "rbxassetid://10723345518",
    ["lucide-egg-fried"] = "rbxassetid://10723345347",
    ["lucide-electricity"] = "rbxassetid://10723345749",
    ["lucide-electricity-off"] = "rbxassetid://10723345643",
    ["lucide-equal"] = "rbxassetid://10723345990",
    ["lucide-equal-not"] = "rbxassetid://10723345866",
    ["lucide-eraser"] = "rbxassetid://10723346158",
    ["lucide-euro"] = "rbxassetid://10723346372",
    ["lucide-expand"] = "rbxassetid://10723346553",
    ["lucide-external-link"] = "rbxassetid://10723346684",
    ["lucide-eye"] = "rbxassetid://10723346959",
    ["lucide-eye-off"] = "rbxassetid://10723346871",
    ["lucide-factory"] = "rbxassetid://10723347051",
    ["lucide-fan"] = "rbxassetid://10723354359",
    ["lucide-fast-forward"] = "rbxassetid://10723354521",
    ["lucide-feather"] = "rbxassetid://10723354671",
    ["lucide-figma"] = "rbxassetid://10723354801",
    ["lucide-file"] = "rbxassetid://10723374641",
    ["lucide-file-archive"] = "rbxassetid://10723354921",
    ["lucide-file-audio"] = "rbxassetid://10723355148",
    ["lucide-file-audio-2"] = "rbxassetid://10723355026",
    ["lucide-file-axis-3d"] = "rbxassetid://10723355272",
    ["lucide-file-badge"] = "rbxassetid://10723355622",
    ["lucide-file-badge-2"] = "rbxassetid://10723355451",
    ["lucide-file-bar-chart"] = "rbxassetid://10723355887",
    ["lucide-file-bar-chart-2"] = "rbxassetid://10723355746",
    ["lucide-file-box"] = "rbxassetid://10723355989",
    ["lucide-file-check"] = "rbxassetid://10723356210",
    ["lucide-file-check-2"] = "rbxassetid://10723356100",
    ["lucide-file-clock"] = "rbxassetid://10723356329",
    ["lucide-file-code"] = "rbxassetid://10723356507",
    ["lucide-file-cog"] = "rbxassetid://10723356830",
    ["lucide-file-cog-2"] = "rbxassetid://10723356676",
    ["lucide-file-diff"] = "rbxassetid://10723357039",
    ["lucide-file-digit"] = "rbxassetid://10723357151",
    ["lucide-file-down"] = "rbxassetid://10723357322",
    ["lucide-file-edit"] = "rbxassetid://10723357495",
    ["lucide-file-heart"] = "rbxassetid://10723357637",
    ["lucide-file-image"] = "rbxassetid://10723357790",
    ["lucide-file-input"] = "rbxassetid://10723357933",
    ["lucide-file-json"] = "rbxassetid://10723364435",
    ["lucide-file-json-2"] = "rbxassetid://10723364361",
    ["lucide-file-key"] = "rbxassetid://10723364605",
    ["lucide-file-key-2"] = "rbxassetid://10723364515",
    ["lucide-file-line-chart"] = "rbxassetid://10723364725",
    ["lucide-file-lock"] = "rbxassetid://10723364957",
    ["lucide-file-lock-2"] = "rbxassetid://10723364861",
    ["lucide-file-minus"] = "rbxassetid://10723365254",
    ["lucide-file-minus-2"] = "rbxassetid://10723365086",
    ["lucide-file-output"] = "rbxassetid://10723365457",
    ["lucide-file-pie-chart"] = "rbxassetid://10723365598",
    ["lucide-file-plus"] = "rbxassetid://10723365877",
    ["lucide-file-plus-2"] = "rbxassetid://10723365766",
    ["lucide-file-question"] = "rbxassetid://10723365987",
    ["lucide-file-scan"] = "rbxassetid://10723366167",
    ["lucide-file-search"] = "rbxassetid://10723366550",
    ["lucide-file-search-2"] = "rbxassetid://10723366340",
    ["lucide-file-signature"] = "rbxassetid://10723366741",
    ["lucide-file-spreadsheet"] = "rbxassetid://10723366962",
    ["lucide-file-symlink"] = "rbxassetid://10723367098",
    ["lucide-file-terminal"] = "rbxassetid://10723367244",
    ["lucide-file-text"] = "rbxassetid://10723367380",
    ["lucide-file-type"] = "rbxassetid://10723367606",
    ["lucide-file-type-2"] = "rbxassetid://10723367509",
    ["lucide-file-up"] = "rbxassetid://10723367734",
    ["lucide-file-video"] = "rbxassetid://10723373884",
    ["lucide-file-video-2"] = "rbxassetid://10723367834",
    ["lucide-file-volume"] = "rbxassetid://10723374172",
    ["lucide-file-volume-2"] = "rbxassetid://10723374030",
    ["lucide-file-warning"] = "rbxassetid://10723374276",
    ["lucide-file-x"] = "rbxassetid://10723374544",
    ["lucide-file-x-2"] = "rbxassetid://10723374378",
    ["lucide-files"] = "rbxassetid://10723374759",
    ["lucide-film"] = "rbxassetid://10723374981",
    ["lucide-filter"] = "rbxassetid://10723375128",
    ["lucide-fingerprint"] = "rbxassetid://10723375250",
    ["lucide-flag"] = "rbxassetid://10723375890",
    ["lucide-flag-off"] = "rbxassetid://10723375443",
    ["lucide-flag-triangle-left"] = "rbxassetid://10723375608",
    ["lucide-flag-triangle-right"] = "rbxassetid://10723375727",
    ["lucide-flame"] = "rbxassetid://10723376114",
    ["lucide-flashlight"] = "rbxassetid://10723376471",
    ["lucide-flashlight-off"] = "rbxassetid://10723376365",
    ["lucide-flask-conical"] = "rbxassetid://10734883986",
    ["lucide-flask-round"] = "rbxassetid://10723376614",
    ["lucide-flip-horizontal"] = "rbxassetid://10723376884",
    ["lucide-flip-horizontal-2"] = "rbxassetid://10723376745",
    ["lucide-flip-vertical"] = "rbxassetid://10723377138",
    ["lucide-flip-vertical-2"] = "rbxassetid://10723377026",
    ["lucide-flower"] = "rbxassetid://10747830374",
    ["lucide-flower-2"] = "rbxassetid://10723377305",
    ["lucide-focus"] = "rbxassetid://10723377537",
    ["lucide-folder"] = "rbxassetid://10723387563",
    ["lucide-folder-archive"] = "rbxassetid://10723384478",
    ["lucide-folder-check"] = "rbxassetid://10723384605",
    ["lucide-folder-clock"] = "rbxassetid://10723384731",
    ["lucide-folder-closed"] = "rbxassetid://10723384893",
    ["lucide-folder-cog"] = "rbxassetid://10723385213",
    ["lucide-folder-cog-2"] = "rbxassetid://10723385036",
    ["lucide-folder-down"] = "rbxassetid://10723385338",
    ["lucide-folder-edit"] = "rbxassetid://10723385445",
    ["lucide-folder-heart"] = "rbxassetid://10723385545",
    ["lucide-folder-input"] = "rbxassetid://10723385721",
    ["lucide-folder-key"] = "rbxassetid://10723385848",
    ["lucide-folder-lock"] = "rbxassetid://10723386005",
    ["lucide-folder-minus"] = "rbxassetid://10723386127",
    ["lucide-folder-open"] = "rbxassetid://10723386277",
    ["lucide-folder-output"] = "rbxassetid://10723386386",
    ["lucide-folder-plus"] = "rbxassetid://10723386531",
    ["lucide-folder-search"] = "rbxassetid://10723386787",
    ["lucide-folder-search-2"] = "rbxassetid://10723386674",
    ["lucide-folder-symlink"] = "rbxassetid://10723386930",
    ["lucide-folder-tree"] = "rbxassetid://10723387085",
    ["lucide-folder-up"] = "rbxassetid://10723387265",
    ["lucide-folder-x"] = "rbxassetid://10723387448",
    ["lucide-folders"] = "rbxassetid://10723387721",
    ["lucide-form-input"] = "rbxassetid://10723387841",
    ["lucide-forward"] = "rbxassetid://10723388016",
    ["lucide-frame"] = "rbxassetid://10723394389",
    ["lucide-framer"] = "rbxassetid://10723394565",
    ["lucide-frown"] = "rbxassetid://10723394681",
    ["lucide-fuel"] = "rbxassetid://10723394846",
    ["lucide-function-square"] = "rbxassetid://10723395041",
    ["lucide-gamepad"] = "rbxassetid://10723395457",
    ["lucide-gamepad-2"] = "rbxassetid://10723395215",
    ["lucide-gauge"] = "rbxassetid://10723395708",
    ["lucide-gavel"] = "rbxassetid://10723395896",
    ["lucide-gem"] = "rbxassetid://10723396000",
    ["lucide-ghost"] = "rbxassetid://10723396107",
    ["lucide-gift"] = "rbxassetid://10723396402",
    ["lucide-gift-card"] = "rbxassetid://10723396225",
    ["lucide-git-branch"] = "rbxassetid://10723396676",
    ["lucide-git-branch-plus"] = "rbxassetid://10723396542",
    ["lucide-git-commit"] = "rbxassetid://10723396812",
    ["lucide-git-compare"] = "rbxassetid://10723396954",
    ["lucide-git-fork"] = "rbxassetid://10723397049",
    ["lucide-git-merge"] = "rbxassetid://10723397165",
    ["lucide-git-pull-request"] = "rbxassetid://10723397431",
    ["lucide-git-pull-request-closed"] = "rbxassetid://10723397268",
    ["lucide-git-pull-request-draft"] = "rbxassetid://10734884302",
    ["lucide-glass"] = "rbxassetid://10723397788",
    ["lucide-glass-2"] = "rbxassetid://10723397529",
    ["lucide-glass-water"] = "rbxassetid://10723397678",
    ["lucide-glasses"] = "rbxassetid://10723397895",
    ["lucide-globe"] = "rbxassetid://10723404337",
    ["lucide-globe-2"] = "rbxassetid://10723398002",
    ["lucide-grab"] = "rbxassetid://10723404472",
    ["lucide-graduation-cap"] = "rbxassetid://10723404691",
    ["lucide-grape"] = "rbxassetid://10723404822",
    ["lucide-grid"] = "rbxassetid://10723404936",
    ["lucide-grip-horizontal"] = "rbxassetid://10723405089",
    ["lucide-grip-vertical"] = "rbxassetid://10723405236",
    ["lucide-hammer"] = "rbxassetid://10723405360",
    ["lucide-hand"] = "rbxassetid://10723405649",
    ["lucide-hand-metal"] = "rbxassetid://10723405508",
    ["lucide-hard-drive"] = "rbxassetid://10723405749",
    ["lucide-hard-hat"] = "rbxassetid://10723405859",
    ["lucide-hash"] = "rbxassetid://10723405975",
    ["lucide-haze"] = "rbxassetid://10723406078",
    ["lucide-headphones"] = "rbxassetid://10723406165",
    ["lucide-heart"] = "rbxassetid://10723406885",
    ["lucide-heart-crack"] = "rbxassetid://10723406299",
    ["lucide-heart-handshake"] = "rbxassetid://10723406480",
    ["lucide-heart-off"] = "rbxassetid://10723406662",
    ["lucide-heart-pulse"] = "rbxassetid://10723406795",
    ["lucide-help-circle"] = "rbxassetid://10723406988",
    ["lucide-hexagon"] = "rbxassetid://10723407092",
    ["lucide-highlighter"] = "rbxassetid://10723407192",
    ["lucide-history"] = "rbxassetid://10723407335",
    ["lucide-home"] = "rbxassetid://10723407389",
    ["lucide-hourglass"] = "rbxassetid://10723407498",
    ["lucide-ice-cream"] = "rbxassetid://10723414308",
    ["lucide-image"] = "rbxassetid://10723415040",
    ["lucide-image-minus"] = "rbxassetid://10723414487",
    ["lucide-image-off"] = "rbxassetid://10723414677",
    ["lucide-image-plus"] = "rbxassetid://10723414827",
    ["lucide-import"] = "rbxassetid://10723415205",
    ["lucide-inbox"] = "rbxassetid://10723415335",
    ["lucide-indent"] = "rbxassetid://10723415494",
    ["lucide-indian-rupee"] = "rbxassetid://10723415642",
    ["lucide-infinity"] = "rbxassetid://10723415766",
    ["lucide-info"] = "rbxassetid://10723415903",
    ["lucide-inspect"] = "rbxassetid://10723416057",
    ["lucide-italic"] = "rbxassetid://10723416195",
    ["lucide-japanese-yen"] = "rbxassetid://10723416363",
    ["lucide-joystick"] = "rbxassetid://10723416527",
    ["lucide-key"] = "rbxassetid://10723416652",
    ["lucide-keyboard"] = "rbxassetid://10723416765",
    ["lucide-lamp"] = "rbxassetid://10723417513",
    ["lucide-lamp-ceiling"] = "rbxassetid://10723416922",
    ["lucide-lamp-desk"] = "rbxassetid://10723417016",
    ["lucide-lamp-floor"] = "rbxassetid://10723417131",
    ["lucide-lamp-wall-down"] = "rbxassetid://10723417240",
    ["lucide-lamp-wall-up"] = "rbxassetid://10723417356",
    ["lucide-landmark"] = "rbxassetid://10723417608",
    ["lucide-languages"] = "rbxassetid://10723417703",
    ["lucide-laptop"] = "rbxassetid://10723423881",
    ["lucide-laptop-2"] = "rbxassetid://10723417797",
    ["lucide-lasso"] = "rbxassetid://10723424235",
    ["lucide-lasso-select"] = "rbxassetid://10723424058",
    ["lucide-laugh"] = "rbxassetid://10723424372",
    ["lucide-layers"] = "rbxassetid://10723424505",
    ["lucide-layout"] = "rbxassetid://10723425376",
    ["lucide-layout-dashboard"] = "rbxassetid://10723424646",
    ["lucide-layout-grid"] = "rbxassetid://10723424838",
    ["lucide-layout-list"] = "rbxassetid://10723424963",
    ["lucide-layout-template"] = "rbxassetid://10723425187",
    ["lucide-leaf"] = "rbxassetid://10723425539",
    ["lucide-library"] = "rbxassetid://10723425615",
    ["lucide-life-buoy"] = "rbxassetid://10723425685",
    ["lucide-lightbulb"] = "rbxassetid://10723425852",
    ["lucide-lightbulb-off"] = "rbxassetid://10723425762",
    ["lucide-line-chart"] = "rbxassetid://10723426393",
    ["lucide-link"] = "rbxassetid://10723426722",
    ["lucide-link-2"] = "rbxassetid://10723426595",
    ["lucide-link-2-off"] = "rbxassetid://10723426513",
    ["lucide-list"] = "rbxassetid://10723433811",
    ["lucide-list-checks"] = "rbxassetid://10734884548",
    ["lucide-list-end"] = "rbxassetid://10723426886",
    ["lucide-list-minus"] = "rbxassetid://10723426986",
    ["lucide-list-music"] = "rbxassetid://10723427081",
    ["lucide-list-ordered"] = "rbxassetid://10723427199",
    ["lucide-list-plus"] = "rbxassetid://10723427334",
    ["lucide-list-start"] = "rbxassetid://10723427494",
    ["lucide-list-video"] = "rbxassetid://10723427619",
    ["lucide-list-x"] = "rbxassetid://10723433655",
    ["lucide-loader"] = "rbxassetid://10723434070",
    ["lucide-loader-2"] = "rbxassetid://10723433935",
    ["lucide-locate"] = "rbxassetid://10723434557",
    ["lucide-locate-fixed"] = "rbxassetid://10723434236",
    ["lucide-locate-off"] = "rbxassetid://10723434379",
    ["lucide-lock"] = "rbxassetid://10723434711",
    ["lucide-log-in"] = "rbxassetid://10723434830",
    ["lucide-log-out"] = "rbxassetid://10723434906",
    ["lucide-luggage"] = "rbxassetid://10723434993",
    ["lucide-magnet"] = "rbxassetid://10723435069",
    ["lucide-mail"] = "rbxassetid://10734885430",
    ["lucide-mail-check"] = "rbxassetid://10723435182",
    ["lucide-mail-minus"] = "rbxassetid://10723435261",
    ["lucide-mail-open"] = "rbxassetid://10723435342",
    ["lucide-mail-plus"] = "rbxassetid://10723435443",
    ["lucide-mail-question"] = "rbxassetid://10723435515",
    ["lucide-mail-search"] = "rbxassetid://10734884739",
    ["lucide-mail-warning"] = "rbxassetid://10734885015",
    ["lucide-mail-x"] = "rbxassetid://10734885247",
    ["lucide-mails"] = "rbxassetid://10734885614",
    ["lucide-map"] = "rbxassetid://10734886202",
    ["lucide-map-pin"] = "rbxassetid://10734886004",
    ["lucide-map-pin-off"] = "rbxassetid://10734885803",
    ["lucide-maximize"] = "rbxassetid://10734886735",
    ["lucide-maximize-2"] = "rbxassetid://10734886496",
    ["lucide-medal"] = "rbxassetid://10734887072",
    ["lucide-megaphone"] = "rbxassetid://10734887454",
    ["lucide-megaphone-off"] = "rbxassetid://10734887311",
    ["lucide-meh"] = "rbxassetid://10734887603",
    ["lucide-menu"] = "rbxassetid://10734887784",
    ["lucide-message-circle"] = "rbxassetid://10734888000",
    ["lucide-message-square"] = "rbxassetid://10734888228",
    ["lucide-mic"] = "rbxassetid://10734888864",
    ["lucide-mic-2"] = "rbxassetid://10734888430",
    ["lucide-mic-off"] = "rbxassetid://10734888646",
    ["lucide-microscope"] = "rbxassetid://10734889106",
    ["lucide-microwave"] = "rbxassetid://10734895076",
    ["lucide-milestone"] = "rbxassetid://10734895310",
    ["lucide-minimize"] = "rbxassetid://10734895698",
    ["lucide-minimize-2"] = "rbxassetid://10734895530",
    ["lucide-minus"] = "rbxassetid://10734896206",
    ["lucide-minus-circle"] = "rbxassetid://10734895856",
    ["lucide-minus-square"] = "rbxassetid://10734896029",
    ["lucide-monitor"] = "rbxassetid://10734896881",
    ["lucide-monitor-off"] = "rbxassetid://10734896360",
    ["lucide-monitor-speaker"] = "rbxassetid://10734896512",
    ["lucide-moon"] = "rbxassetid://10734897102",
    ["lucide-more-horizontal"] = "rbxassetid://10734897250",
    ["lucide-more-vertical"] = "rbxassetid://10734897387",
    ["lucide-mountain"] = "rbxassetid://10734897956",
    ["lucide-mountain-snow"] = "rbxassetid://10734897665",
    ["lucide-mouse"] = "rbxassetid://10734898592",
    ["lucide-mouse-pointer"] = "rbxassetid://10734898476",
    ["lucide-mouse-pointer-2"] = "rbxassetid://10734898194",
    ["lucide-mouse-pointer-click"] = "rbxassetid://10734898355",
    ["lucide-move"] = "rbxassetid://10734900011",
    ["lucide-move-3d"] = "rbxassetid://10734898756",
    ["lucide-move-diagonal"] = "rbxassetid://10734900164",
    ["lucide-move-diagonal-2"] = "rbxassetid://10734898934",
    ["lucide-move-horizontal"] = "rbxassetid://10734899414",
    ["lucide-move-vertical"] = "rbxassetid://10734899821",
    ["lucide-music"] = "rbxassetid://10734905958",
    ["lucide-music-2"] = "rbxassetid://10734900215",
    ["lucide-music-3"] = "rbxassetid://10734905665",
    ["lucide-music-4"] = "rbxassetid://10734905823",
    ["lucide-navigation"] = "rbxassetid://10734906744",
    ["lucide-navigation-2"] = "rbxassetid://10734906332",
    ["lucide-navigation-2-off"] = "rbxassetid://10734906144",
    ["lucide-navigation-off"] = "rbxassetid://10734906580",
    ["lucide-network"] = "rbxassetid://10734906975",
    ["lucide-newspaper"] = "rbxassetid://10734907168",
    ["lucide-octagon"] = "rbxassetid://10734907361",
    ["lucide-option"] = "rbxassetid://10734907649",
    ["lucide-outdent"] = "rbxassetid://10734907933",
    ["lucide-package"] = "rbxassetid://10734909540",
    ["lucide-package-2"] = "rbxassetid://10734908151",
    ["lucide-package-check"] = "rbxassetid://10734908384",
    ["lucide-package-minus"] = "rbxassetid://10734908626",
    ["lucide-package-open"] = "rbxassetid://10734908793",
    ["lucide-package-plus"] = "rbxassetid://10734909016",
    ["lucide-package-search"] = "rbxassetid://10734909196",
    ["lucide-package-x"] = "rbxassetid://10734909375",
    ["lucide-paint-bucket"] = "rbxassetid://10734909847",
    ["lucide-paintbrush"] = "rbxassetid://10734910187",
    ["lucide-paintbrush-2"] = "rbxassetid://10734910030",
    ["lucide-palette"] = "rbxassetid://10734910430",
    ["lucide-palmtree"] = "rbxassetid://10734910680",
    ["lucide-paperclip"] = "rbxassetid://10734910927",
    ["lucide-party-popper"] = "rbxassetid://10734918735",
    ["lucide-pause"] = "rbxassetid://10734919336",
    ["lucide-pause-circle"] = "rbxassetid://10735024209",
    ["lucide-pause-octagon"] = "rbxassetid://10734919143",
    ["lucide-pen-tool"] = "rbxassetid://10734919503",
    ["lucide-pencil"] = "rbxassetid://10734919691",
    ["lucide-percent"] = "rbxassetid://10734919919",
    ["lucide-person-standing"] = "rbxassetid://10734920149",
    ["lucide-phone"] = "rbxassetid://10734921524",
    ["lucide-phone-call"] = "rbxassetid://10734920305",
    ["lucide-phone-forwarded"] = "rbxassetid://10734920508",
    ["lucide-phone-incoming"] = "rbxassetid://10734920694",
    ["lucide-phone-missed"] = "rbxassetid://10734920845",
    ["lucide-phone-off"] = "rbxassetid://10734921077",
    ["lucide-phone-outgoing"] = "rbxassetid://10734921288",
    ["lucide-pie-chart"] = "rbxassetid://10734921727",
    ["lucide-piggy-bank"] = "rbxassetid://10734921935",
    ["lucide-pin"] = "rbxassetid://10734922324",
    ["lucide-pin-off"] = "rbxassetid://10734922180",
    ["lucide-pipette"] = "rbxassetid://10734922497",
    ["lucide-pizza"] = "rbxassetid://10734922774",
    ["lucide-plane"] = "rbxassetid://10734922971",
    ["lucide-play"] = "rbxassetid://10734923549",
    ["lucide-play-circle"] = "rbxassetid://10734923214",
    ["lucide-plus"] = "rbxassetid://10734924532",
    ["lucide-plus-circle"] = "rbxassetid://10734923868",
    ["lucide-plus-square"] = "rbxassetid://10734924219",
    ["lucide-podcast"] = "rbxassetid://10734929553",
    ["lucide-pointer"] = "rbxassetid://10734929723",
    ["lucide-pound-sterling"] = "rbxassetid://10734929981",
    ["lucide-power"] = "rbxassetid://10734930466",
    ["lucide-power-off"] = "rbxassetid://10734930257",
    ["lucide-printer"] = "rbxassetid://10734930632",
    ["lucide-puzzle"] = "rbxassetid://10734930886",
    ["lucide-quote"] = "rbxassetid://10734931234",
    ["lucide-radio"] = "rbxassetid://10734931596",
    ["lucide-radio-receiver"] = "rbxassetid://10734931402",
    ["lucide-rectangle-horizontal"] = "rbxassetid://10734931777",
    ["lucide-rectangle-vertical"] = "rbxassetid://10734932081",
    ["lucide-recycle"] = "rbxassetid://10734932295",
    ["lucide-redo"] = "rbxassetid://10734932822",
    ["lucide-redo-2"] = "rbxassetid://10734932586",
    ["lucide-refresh-ccw"] = "rbxassetid://10734933056",
    ["lucide-refresh-cw"] = "rbxassetid://10734933222",
    ["lucide-refrigerator"] = "rbxassetid://10734933465",
    ["lucide-regex"] = "rbxassetid://10734933655",
    ["lucide-repeat"] = "rbxassetid://10734933966",
    ["lucide-repeat-1"] = "rbxassetid://10734933826",
    ["lucide-reply"] = "rbxassetid://10734934252",
    ["lucide-reply-all"] = "rbxassetid://10734934132",
    ["lucide-rewind"] = "rbxassetid://10734934347",
    ["lucide-rocket"] = "rbxassetid://10734934585",
    ["lucide-rocking-chair"] = "rbxassetid://10734939942",
    ["lucide-rotate-3d"] = "rbxassetid://10734940107",
    ["lucide-rotate-ccw"] = "rbxassetid://10734940376",
    ["lucide-rotate-cw"] = "rbxassetid://10734940654",
    ["lucide-rss"] = "rbxassetid://10734940825",
    ["lucide-ruler"] = "rbxassetid://10734941018",
    ["lucide-russian-ruble"] = "rbxassetid://10734941199",
    ["lucide-sailboat"] = "rbxassetid://10734941354",
    ["lucide-save"] = "rbxassetid://10734941499",
    ["lucide-scale"] = "rbxassetid://10734941912",
    ["lucide-scale-3d"] = "rbxassetid://10734941739",
    ["lucide-scaling"] = "rbxassetid://10734942072",
    ["lucide-scan"] = "rbxassetid://10734942565",
    ["lucide-scan-face"] = "rbxassetid://10734942198",
    ["lucide-scan-line"] = "rbxassetid://10734942351",
    ["lucide-scissors"] = "rbxassetid://10734942778",
    ["lucide-screen-share"] = "rbxassetid://10734943193",
    ["lucide-screen-share-off"] = "rbxassetid://10734942967",
    ["lucide-scroll"] = "rbxassetid://10734943448",
    ["lucide-search"] = "rbxassetid://10734943674",
    ["lucide-send"] = "rbxassetid://10734943902",
    ["lucide-separator-horizontal"] = "rbxassetid://10734944115",
    ["lucide-separator-vertical"] = "rbxassetid://10734944326",
    ["lucide-server"] = "rbxassetid://10734949856",
    ["lucide-server-cog"] = "rbxassetid://10734944444",
    ["lucide-server-crash"] = "rbxassetid://10734944554",
    ["lucide-server-off"] = "rbxassetid://10734944668",
    ["lucide-settings"] = "rbxassetid://10734950309",
    ["lucide-settings-2"] = "rbxassetid://10734950020",
    ["lucide-share"] = "rbxassetid://10734950813",
    ["lucide-share-2"] = "rbxassetid://10734950553",
    ["lucide-sheet"] = "rbxassetid://10734951038",
    ["lucide-shield"] = "rbxassetid://10734951847",
    ["lucide-shield-alert"] = "rbxassetid://10734951173",
    ["lucide-shield-check"] = "rbxassetid://10734951367",
    ["lucide-shield-close"] = "rbxassetid://10734951535",
    ["lucide-shield-off"] = "rbxassetid://10734951684",
    ["lucide-shirt"] = "rbxassetid://10734952036",
    ["lucide-shopping-bag"] = "rbxassetid://10734952273",
    ["lucide-shopping-cart"] = "rbxassetid://10734952479",
    ["lucide-shovel"] = "rbxassetid://10734952773",
    ["lucide-shower-head"] = "rbxassetid://10734952942",
    ["lucide-shrink"] = "rbxassetid://10734953073",
    ["lucide-shrub"] = "rbxassetid://10734953241",
    ["lucide-shuffle"] = "rbxassetid://10734953451",
    ["lucide-sidebar"] = "rbxassetid://10734954301",
    ["lucide-sidebar-close"] = "rbxassetid://10734953715",
    ["lucide-sidebar-open"] = "rbxassetid://10734954000",
    ["lucide-sigma"] = "rbxassetid://10734954538",
    ["lucide-signal"] = "rbxassetid://10734961133",
    ["lucide-signal-high"] = "rbxassetid://10734954807",
    ["lucide-signal-low"] = "rbxassetid://10734955080",
    ["lucide-signal-medium"] = "rbxassetid://10734955336",
    ["lucide-signal-zero"] = "rbxassetid://10734960878",
    ["lucide-siren"] = "rbxassetid://10734961284",
    ["lucide-skip-back"] = "rbxassetid://10734961526",
    ["lucide-skip-forward"] = "rbxassetid://10734961809",
    ["lucide-skull"] = "rbxassetid://10734962068",
    ["lucide-slack"] = "rbxassetid://10734962339",
    ["lucide-slash"] = "rbxassetid://10734962600",
    ["lucide-slice"] = "rbxassetid://10734963024",
    ["lucide-sliders"] = "rbxassetid://10734963400",
    ["lucide-sliders-horizontal"] = "rbxassetid://10734963191",
    ["lucide-smartphone"] = "rbxassetid://10734963940",
    ["lucide-smartphone-charging"] = "rbxassetid://10734963671",
    ["lucide-smile"] = "rbxassetid://10734964441",
    ["lucide-smile-plus"] = "rbxassetid://10734964188",
    ["lucide-snowflake"] = "rbxassetid://10734964600",
    ["lucide-sofa"] = "rbxassetid://10734964852",
    ["lucide-sort-asc"] = "rbxassetid://10734965115",
    ["lucide-sort-desc"] = "rbxassetid://10734965287",
    ["lucide-speaker"] = "rbxassetid://10734965419",
    ["lucide-sprout"] = "rbxassetid://10734965572",
    ["lucide-square"] = "rbxassetid://10734965702",
    ["lucide-star"] = "rbxassetid://10734966248",
    ["lucide-star-half"] = "rbxassetid://10734965897",
    ["lucide-star-off"] = "rbxassetid://10734966097",
    ["lucide-stethoscope"] = "rbxassetid://10734966384",
    ["lucide-sticker"] = "rbxassetid://10734972234",
    ["lucide-sticky-note"] = "rbxassetid://10734972463",
    ["lucide-stop-circle"] = "rbxassetid://10734972621",
    ["lucide-stretch-horizontal"] = "rbxassetid://10734972862",
    ["lucide-stretch-vertical"] = "rbxassetid://10734973130",
    ["lucide-strikethrough"] = "rbxassetid://10734973290",
    ["lucide-subscript"] = "rbxassetid://10734973457",
    ["lucide-sun"] = "rbxassetid://10734974297",
    ["lucide-sun-dim"] = "rbxassetid://10734973645",
    ["lucide-sun-medium"] = "rbxassetid://10734973778",
    ["lucide-sun-moon"] = "rbxassetid://10734973999",
    ["lucide-sun-snow"] = "rbxassetid://10734974130",
    ["lucide-sunrise"] = "rbxassetid://10734974522",
    ["lucide-sunset"] = "rbxassetid://10734974689",
    ["lucide-superscript"] = "rbxassetid://10734974850",
    ["lucide-swiss-franc"] = "rbxassetid://10734975024",
    ["lucide-switch-camera"] = "rbxassetid://10734975214",
    ["lucide-sword"] = "rbxassetid://10734975486",
    ["lucide-swords"] = "rbxassetid://10734975692",
    ["lucide-syringe"] = "rbxassetid://10734975932",
    ["lucide-table"] = "rbxassetid://10734976230",
    ["lucide-table-2"] = "rbxassetid://10734976097",
    ["lucide-tablet"] = "rbxassetid://10734976394",
    ["lucide-tag"] = "rbxassetid://10734976528",
    ["lucide-tags"] = "rbxassetid://10734976739",
    ["lucide-target"] = "rbxassetid://10734977012",
    ["lucide-tent"] = "rbxassetid://10734981750",
    ["lucide-terminal"] = "rbxassetid://10734982144",
    ["lucide-terminal-square"] = "rbxassetid://10734981995",
    ["lucide-text-cursor"] = "rbxassetid://10734982395",
    ["lucide-text-cursor-input"] = "rbxassetid://10734982297",
    ["lucide-thermometer"] = "rbxassetid://10734983134",
    ["lucide-thermometer-snowflake"] = "rbxassetid://10734982571",
    ["lucide-thermometer-sun"] = "rbxassetid://10734982771",
    ["lucide-thumbs-down"] = "rbxassetid://10734983359",
    ["lucide-thumbs-up"] = "rbxassetid://10734983629",
    ["lucide-ticket"] = "rbxassetid://10734983868",
    ["lucide-timer"] = "rbxassetid://10734984606",
    ["lucide-timer-off"] = "rbxassetid://10734984138",
    ["lucide-timer-reset"] = "rbxassetid://10734984355",
    ["lucide-toggle-left"] = "rbxassetid://10734984834",
    ["lucide-toggle-right"] = "rbxassetid://10734985040",
    ["lucide-tornado"] = "rbxassetid://10734985247",
    ["lucide-toy-brick"] = "rbxassetid://10747361919",
    ["lucide-train"] = "rbxassetid://10747362105",
    ["lucide-trash"] = "rbxassetid://10747362393",
    ["lucide-trash-2"] = "rbxassetid://10747362241",
    ["lucide-tree-deciduous"] = "rbxassetid://10747362534",
    ["lucide-tree-pine"] = "rbxassetid://10747362748",
    ["lucide-trees"] = "rbxassetid://10747363016",
    ["lucide-trending-down"] = "rbxassetid://10747363205",
    ["lucide-trending-up"] = "rbxassetid://10747363465",
    ["lucide-triangle"] = "rbxassetid://10747363621",
    ["lucide-trophy"] = "rbxassetid://10747363809",
    ["lucide-truck"] = "rbxassetid://10747364031",
    ["lucide-tv"] = "rbxassetid://10747364593",
    ["lucide-tv-2"] = "rbxassetid://10747364302",
    ["lucide-type"] = "rbxassetid://10747364761",
    ["lucide-umbrella"] = "rbxassetid://10747364971",
    ["lucide-underline"] = "rbxassetid://10747365191",
    ["lucide-undo"] = "rbxassetid://10747365484",
    ["lucide-undo-2"] = "rbxassetid://10747365359",
    ["lucide-unlink"] = "rbxassetid://10747365771",
    ["lucide-unlink-2"] = "rbxassetid://10747397871",
    ["lucide-unlock"] = "rbxassetid://10747366027",
    ["lucide-upload"] = "rbxassetid://10747366434",
    ["lucide-upload-cloud"] = "rbxassetid://10747366266",
    ["lucide-usb"] = "rbxassetid://10747366606",
    ["lucide-user"] = "rbxassetid://10747373176",
    ["lucide-user-check"] = "rbxassetid://10747371901",
    ["lucide-user-cog"] = "rbxassetid://10747372167",
    ["lucide-user-minus"] = "rbxassetid://10747372346",
    ["lucide-user-plus"] = "rbxassetid://10747372702",
    ["lucide-user-x"] = "rbxassetid://10747372992",
    ["lucide-users"] = "rbxassetid://10747373426",
    ["lucide-utensils"] = "rbxassetid://10747373821",
    ["lucide-utensils-crossed"] = "rbxassetid://10747373629",
    ["lucide-venetian-mask"] = "rbxassetid://10747374003",
    ["lucide-verified"] = "rbxassetid://10747374131",
    ["lucide-vibrate"] = "rbxassetid://10747374489",
    ["lucide-vibrate-off"] = "rbxassetid://10747374269",
    ["lucide-video"] = "rbxassetid://10747374938",
    ["lucide-video-off"] = "rbxassetid://10747374721",
    ["lucide-view"] = "rbxassetid://10747375132",
    ["lucide-voicemail"] = "rbxassetid://10747375281",
    ["lucide-volume"] = "rbxassetid://10747376008",
    ["lucide-volume-1"] = "rbxassetid://10747375450",
    ["lucide-volume-2"] = "rbxassetid://10747375679",
    ["lucide-volume-x"] = "rbxassetid://10747375880",
    ["lucide-wallet"] = "rbxassetid://10747376205",
    ["lucide-wand"] = "rbxassetid://10747376565",
    ["lucide-wand-2"] = "rbxassetid://10747376349",
    ["lucide-watch"] = "rbxassetid://10747376722",
    ["lucide-waves"] = "rbxassetid://10747376931",
    ["lucide-webcam"] = "rbxassetid://10747381992",
    ["lucide-wifi"] = "rbxassetid://10747382504",
    ["lucide-wifi-off"] = "rbxassetid://10747382268",
    ["lucide-wind"] = "rbxassetid://10747382750",
    ["lucide-wrap-text"] = "rbxassetid://10747383065",
    ["lucide-wrench"] = "rbxassetid://10747383470",
    ["lucide-x"] = "rbxassetid://10747384394",
    ["lucide-x-circle"] = "rbxassetid://10747383819",
    ["lucide-x-octagon"] = "rbxassetid://10747384037",
    ["lucide-x-square"] = "rbxassetid://10747384217",
    ["lucide-zoom-in"] = "rbxassetid://10747384552",
    ["lucide-zoom-out"] = "rbxassetid://10747384679",
}

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
    local lucide = Assets[icon] or Assets["lucide-" .. icon]
    return callback(lucide or icon)
end

function CentrixUI:ListIcons()
    local list = {}
    for k, _ in pairs(Assets) do
        table.insert(list, k)
    end
    table.sort(list)
    return list
end

function CentrixUI:PreloadIcon(url, callback)
    return LoadAssetAsync(url, callback)
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

    local IconImage
    local LabelHolder = New("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(icon and 42 or 14, 0),
        Size = UDim2.new(1, icon and -62 or -34, 0, 0),
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

    if icon then
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
                if asset:sub(1, 4) == "rbxassetid" or asset:sub(1, 11) == "rbxassetid:" or asset:sub(1, 9) == "rbxasset" then
                else
                    IconImage.ImageColor3 = Color3.new(1, 1, 1)
                end
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
            Image = collapsed and Assets["lucide-chevron-down"] or Assets["lucide-chevron-up"],
            ImageColor3 = GetTheme("SubText"),
            Size = UDim2.fromOffset(14, 14),
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -2, 0.5, 0),
            BackgroundTransparency = 1,
            Parent = Header
        })
        Register(Chevron, { ImageColor3 = "SubText" })
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
            Chevron.Image = collapsed and Assets["lucide-chevron-down"] or Assets["lucide-chevron-up"]
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
            if Chevron then Tween(Chevron, 0.12, { ImageTransparency = 0 }) end
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
            Image = Assets["lucide-chevron-right"],
            ImageColor3 = GetTheme("SubText"),
            Size = UDim2.fromOffset(16, 16),
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -14, 0.5, 0),
            BackgroundTransparency = 1,
            Parent = el.Frame
        })
        Register(Arrow, { ImageColor3 = "SubText" })
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
            Image = Assets["lucide-chevron-down"],
            ImageColor3 = GetTheme("SubText"),
            Size = UDim2.fromOffset(14, 14),
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -10, 0.5, 0),
            BackgroundTransparency = 1,
            Parent = el.Frame
        })
        Register(Chevron, { ImageColor3 = "SubText" })

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
                    Image = Assets["lucide-search"],
                    ImageColor3 = GetTheme("SubText"),
                    Size = UDim2.fromOffset(12, 12),
                    Position = UDim2.fromOffset(9, 10),
                    BackgroundTransparency = 1,
                    Parent = SearchBox
                })
                Register(SearchIcon, { ImageColor3 = "SubText" })
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

    local iconAsset = CentrixUI:GetIcon(icon)

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
        Position = iconAsset and UDim2.new(0, 40, 0.5, 0) or UDim2.new(0, 14, 0.5, 0),
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

    if iconAsset then
        local IconImage = New("ImageLabel", {
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.fromOffset(16, 16),
            Position = UDim2.new(0, 14, 0.5, 0),
            Image = iconAsset,
            ImageColor3 = GetTheme("Text"),
            BackgroundTransparency = 1,
            Parent = Frame
        })
        Register(IconImage, { ImageColor3 = "Text" })
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
            local asset = CentrixUI:GetIcon(ic)
            local img = Frame:FindFirstChildOfClass("ImageLabel")
            if img then
                img.Image = asset or ic
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
                Image = Assets[iconName],
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
        Btn.MouseEnter:Connect(function() Tween(Btn, 0.15, { BackgroundTransparency = 0.9 }) end)
        Btn.MouseLeave:Connect(function() Tween(Btn, 0.15, { BackgroundTransparency = 1 }) end)
        Btn.MouseButton1Click:Connect(callback)
        return Btn
    end

    local CloseBtn = MakeTitleButton("lucide-x", -6, function()
        Window:Dialog({
            Title = "Confirm",
            Content = "Are you sure you want to unload the interface?",
            Buttons = {
                { Title = "Confirm", Callback = function() Window:Destroy() end },
                { Title = "Cancel" }
            }
        })
    end)
    local MaxBtn = MakeTitleButton("lucide-maximize", -42, function()
        Window:Maximize(not Window.Maximized)
    end)
    local MinBtn = MakeTitleButton("lucide-minus", -78, function()
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

        local Root = New("CanvasGroup", {
            Size = UDim2.fromOffset(320, 180),
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
                    if dcfg.Icon:sub(1, 4) == "http" or dcfg.Icon:sub(1, 11) == "rbxassetid:" then
                        if not dcfg.IconColor then
                            IconImage.ImageColor3 = Color3.new(1, 1, 1)
                        end
                    end
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

        if dcfg.Content and dcfg.Content ~= "" then
            local contentLabel = New("TextLabel", {
                FontFace = FONT,
                Text = dcfg.Content,
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
            if iconValue:sub(1, 4) == "http" then
                IconImage.Image = Assets[TintIconForType(notifType)] or ""
                LoadAssetAsync(iconValue, function(asset)
                    if asset and IconImage and IconImage.Parent then
                        IconImage.Image = asset
                        if ncfg.IconColor == nil then
                            IconImage.ImageColor3 = Color3.new(1, 1, 1)
                        end
                    end
                end)
            elseif iconValue:sub(1, 11) == "rbxassetid:" or iconValue:sub(1, 11) == "rbxasset://" then
                IconImage.Image = iconValue
                if ncfg.IconColor == nil then
                    IconImage.ImageColor3 = Color3.new(1, 1, 1)
                end
            else
                local lucide = Assets[iconValue] or Assets["lucide-" .. iconValue]
                IconImage.Image = lucide or iconValue
            end
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
                Image = Assets["lucide-x"],
                ImageColor3 = GetTheme("SubText"),
                Size = UDim2.fromOffset(13, 13),
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundTransparency = 1,
                Parent = CloseBtn2
            })
        })
        Register(CloseBtn2:FindFirstChildOfClass("ImageLabel"), { ImageColor3 = "SubText" })

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

        Window.SearchButton = MakeTitleButton("lucide-search", -114, function()
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
            Image = Assets["lucide-search"],
            ImageColor3 = GetTheme("SubText"),
            Size = UDim2.fromOffset(18, 18),
            Position = UDim2.fromOffset(16, 16),
            BackgroundTransparency = 1,
            Parent = panel
        })
        Register(searchIcon, { ImageColor3 = "SubText" })

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
            Toggle = "lucide-toggle-right",
            Slider = "lucide-sliders-horizontal",
            Dropdown = "lucide-chevron-down",
            Input = "lucide-type",
            Keybind = "lucide-keyboard",
            Colorpicker = "lucide-palette",
            Element = "lucide-circle",
            Command = "lucide-terminal",
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

                local iconSrc = nil
                if entry.Icon then
                    iconSrc = CentrixUI:GetIcon(entry.Icon)
                end
                if not iconSrc then
                    iconSrc = Assets[typeToIcon[entry.Type] or "lucide-circle"]
                end

                local icon = New("ImageLabel", {
                    Image = iconSrc or "",
                    ImageColor3 = GetTheme("SubText"),
                    Size = UDim2.fromOffset(16, 16),
                    Position = UDim2.fromOffset(12, 12),
                    BackgroundTransparency = 1,
                    Parent = row
                })
                Register(icon, { ImageColor3 = "SubText" })

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
            maxBtnIcon.Image = self.Maximized and Assets["lucide-minimize"] or Assets["lucide-maximize"]
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
                        ResampleMode = Enum.ResamplerMode.Default,
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
