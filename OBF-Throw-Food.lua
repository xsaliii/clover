local cloneref = cloneref or function(i) return i end
local Players = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local TweenService = cloneref(game:GetService("TweenService"))
local VirtualUser = cloneref(game:GetService("VirtualUser"))
local Random = Random.new()

local Env = getgenv()
Env.CentrixHub = Env.CentrixHub or {}
Env.CentrixHub.Settings = Env.CentrixHub.Settings or {
    AutoThrow = false,
    ThrowDelay = 0.5,
    EquipOnCatch = true,
    AutoPullUp = false,
    AutoClick2x = true,
    AutoEquipLoop = false,
    AutoUpgradeStand = false,
    AutoUpgradeFood = false,
    TweenSpeed = 28,
    TotalThrows = 0,
    TotalBonusTaps = 0,
    LastAnimal = "None",
    LastRarity = "None",
    CurrentStatus = "Idle",
    TrainingStatus = "Not Training",
}
local Settings = Env.CentrixHub.Settings

local LocalPlayer = Players.LocalPlayer
local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = Shared:WaitForChild("Remotes")
local Config = ReplicatedStorage:WaitForChild("Config")

local GameConfig, StandsConfig, FoodsConfig
pcall(function() GameConfig = require(Config:WaitForChild("GameConfig")) end)
pcall(function() StandsConfig = require(Config:WaitForChild("StandsConfig")) end)
pcall(function() FoodsConfig = require(Config:WaitForChild("FoodsConfig")) end)

local DataController, PlotController, TrainingController, ThrowController
local ThrowMeter, RevealSequence, CameraRig, ClientState, HUDController
pcall(function()
    local Ctrl = LocalPlayer.PlayerScripts.Client.Controllers
    DataController = require(Ctrl:WaitForChild("DataController"))
    PlotController = require(Ctrl:WaitForChild("PlotController"))
    TrainingController = require(Ctrl:WaitForChild("TrainingController"))
    ThrowController = require(Ctrl:WaitForChild("ThrowController"))
    ThrowMeter = require(Ctrl:WaitForChild("ThrowMeter"))
    RevealSequence = require(Ctrl:WaitForChild("RevealSequence"))
    CameraRig = require(Ctrl:WaitForChild("CameraRig"))
    ClientState = require(Ctrl:WaitForChild("ClientState"))
    HUDController = require(Ctrl:WaitForChild("HUDController"))
end)

local Hub = {}

Hub.Util = {}
Hub.Util.ErrorHandler = function(err)
    warn("[Centrix Hub Error] " .. tostring(err) .. "\n" .. debug.traceback())
end

Hub.Util.SafeCall = function(fn, ...)
    return xpcall(fn, Hub.Util.ErrorHandler, ...)
end

Hub.Util.isThrowing = function()
    if ThrowController and ThrowController.Start and getupvalues then
        local ok, up = pcall(getupvalues, ThrowController.Start)
        if ok and up and up[1] ~= nil then return up[1] == true end
    end
    return ClientState and ClientState.Busy == "Throw"
end

Hub.Util.stopThrow = function()
    Hub.Util.SafeCall(function()
        if setupvalue and ThrowController and ThrowController.Start then
            setupvalue(ThrowController.Start, 1, false)
        end
    end)
    Hub.Util.SafeCall(function() Remotes.Invoke("Throw_Cancel") end)
    if ClientState then ClientState.Busy = nil end
    Hub.Util.SafeCall(function() if CameraRig and CameraRig.Release then CameraRig.Release() end end)
    
    local cam = workspace.CurrentCamera
    if cam then
        cam.CameraType = Enum.CameraType.Custom
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then cam.CameraSubject = hum end
    end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then root.Anchored = false end
end

Hub.Waypoints = {}
Hub.Waypoints.getThrowArea = function()
    local area = workspace:FindFirstChild("StarterArea")
    if area then return CFrame.new(area.Position.X, area.Position.Y + 1.5, area.Position.Z) end
    return CFrame.new(0, 3.5, -45)
end

Hub.Waypoints.getPreThrowSpot = function()
    local area = workspace:FindFirstChild("StarterArea")
    if area then return CFrame.new(area.Position.X, area.Position.Y + 1.5, area.Position.Z + area.Size.Z / 2 + 5) end
    return CFrame.new(0, 3.5, -35)
end

Hub.Waypoints.getTrainingSpot = function()
    local spot
    Hub.Util.SafeCall(function()
        if TrainingController and TrainingController.BindSpot and getupvalues then
            spot = (getupvalues(TrainingController.BindSpot))[1]
        end
    end)
    if spot and spot:IsA("BasePart") then return CFrame.new(spot.Position + Vector3.new(0, 1.5, 0)) end
    
    local props = workspace:FindFirstChild("LocalPlotProps")
    if props then
        local area = props:FindFirstChild("TrainingArea")
        local target = area and area:FindFirstChild("TrainingSpot")
        if target and target:IsA("BasePart") then return CFrame.new(target.Position + Vector3.new(0, 1.5, 0)) end
    end
    
    local plotPart
    Hub.Util.SafeCall(function() 
        if PlotController and PlotController.GetPlotPart then plotPart = PlotController.GetPlotPart() end 
    end)
    
    if plotPart then
        local offset = Vector3.new(-16, 2.5, -30.5)
        if GameConfig and GameConfig.Plot and GameConfig.Plot.TrainingSpotOffset then
            offset = GameConfig.Plot.TrainingSpotOffset + Vector3.new(0, 2, 0)
        end
        return CFrame.new(plotPart.Position + offset)
    end
    return CFrame.new(34, 4, -8)
end

Hub.Waypoints.getPlotCenter = function()
    local plotPart
    Hub.Util.SafeCall(function() 
        if PlotController and PlotController.GetPlotPart then plotPart = PlotController.GetPlotPart() end 
    end)
    if plotPart then return CFrame.new(plotPart.Position + Vector3.new(0, 3, 0)) end
    return nil
end

Hub.Actions = {}
Hub.Actions.EquipBest = function()
    Hub.Util.SafeCall(function()
        local res = Remotes.Plot_EquipBest:InvokeServer()
        if res and res.Ok and HUDController and HUDController.Notify then
            local placed = res.Placed or 0
            local removed = res.Removed or 0
            if placed == 0 and removed == 0 then
                HUDController.Notify("Best animals already equipped", "Info")
            else
                HUDController.Notify(string.format("Equipped %d animals", placed), "Success")
            end
        end
    end)
end

Hub.Actions.UpgradeStand = function()
    Hub.Util.SafeCall(function()
        if not DataController or not StandsConfig then return end
        local tier = DataController:Get("Stand") or 0
        local money = DataController:Get("Money") or 0
        local nextStand = StandsConfig.Get(tier + 1)
        if nextStand and nextStand.Price and money >= nextStand.Price then
            local res = Remotes.Stand_Upgrade:InvokeServer()
            if res and res.Ok and HUDController and HUDController.Notify then
                HUDController.Notify("Stand upgraded to tier " .. tostring(res.NewIndex or (tier + 1)), "Success")
            end
        end
    end)
end

Hub.Actions.UpgradeFood = function()
    Hub.Util.SafeCall(function()
        if not DataController or not FoodsConfig then return end
        local money = DataController:Get("Money") or 0
        local folder = DataController:GetFolder()
        local owned = folder and folder:FindFirstChild("OwnedFoods")
        local current = DataController:Get("EquippedFood") or 1
        local best = current
        for i = 1, 42 do
            if owned and owned:FindFirstChild(tostring(i)) then
                if i > best then best = i end
            else
                local fd = FoodsConfig.Get(i)
                if fd and fd.Price and money >= fd.Price then
                    local res = Remotes.Shop_Buy:InvokeServer(i)
                    if res and res.Ok then best = math.max(best, i) end
                end
            end
        end
        if best > current then Remotes.Shop_Equip:InvokeServer(best) end
    end)
end

Hub.AutoThrow = {
    Thread = nil,
    Tween = nil,
    Enabled = false
}

Hub.AutoThrow.CancelTween = function(self)
    if self.Tween then
        Hub.Util.SafeCall(function() self.Tween:Cancel() end)
        self.Tween = nil
    end
end

Hub.AutoThrow.SafeTween = function(self, targetCF, speed)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    if typeof(targetCF) == "Vector3" then targetCF = CFrame.new(targetCF) end
    
    self:CancelTween()
    local dist = (root.Position - targetCF.Position).Magnitude
    if dist < 3 then return true end
    
    local sp = speed or Settings.TweenSpeed
    local dur = math.clamp(dist / sp, 0.1, 15)
    local tw = TweenService:Create(root, TweenInfo.new(dur, Enum.EasingStyle.Linear), { CFrame = targetCF })
    self.Tween = tw
    tw:Play()
    
    local timeout = os.clock() + dur + 1
    while tw.PlaybackState == Enum.PlaybackState.Playing do
        if not self.Enabled then
            tw:Cancel()
            self.Tween = nil
            return false
        end
        if os.clock() > timeout then break end
        task.wait(0.05)
    end
    self.Tween = nil
    return true
end

Hub.AutoThrow.Stop = function(self)
    self.Enabled = false
    Settings.AutoThrow = false
    if self.Thread then
        Hub.Util.SafeCall(function() task.cancel(self.Thread) end)
        self.Thread = nil
    end
    self:CancelTween()
    Hub.Util.stopThrow()
end

Hub.AutoThrow.Process = function(self)
    if not self.Enabled then return end

    if TrainingController and TrainingController.IsRunning and TrainingController.IsRunning() then
        Hub.Util.SafeCall(function() TrainingController.Stop() end)
        local t = os.clock()
        while TrainingController.IsRunning() and os.clock() - t < 2.5 do task.wait(0.05) end
    end
    if ClientState and ClientState.Busy == "Training" then
        Hub.Util.SafeCall(function() Remotes.Invoke("Training_Stop") end)
        task.wait(0.2)
        ClientState.Busy = nil
    end
    if not self.Enabled then return end

    if Hub.Util.isThrowing() then
        Hub.Util.stopThrow()
        task.wait(0.2)
    end
    if not self.Enabled then return end

    Settings.CurrentStatus = "Moving to throw area"
    if not self:SafeTween(Hub.Waypoints.getPreThrowSpot()) then return end
    task.wait(Random:NextNumber(0.1, 0.2))
    if not self.Enabled then return end

    if not self:SafeTween(Hub.Waypoints.getThrowArea()) then return end

    Settings.CurrentStatus = "Throwing..."
    local timeout = os.clock() + 1.5
    while self.Enabled and not Hub.Util.isThrowing() and os.clock() < timeout do
        task.wait(0.05)
    end

    if self.Enabled and not Hub.Util.isThrowing() then
        Hub.Util.SafeCall(function()
            if ThrowController and ThrowController.Start then
                task.spawn(ThrowController.Start)
            end
        end)
        timeout = os.clock() + 1.5
        while self.Enabled and not Hub.Util.isThrowing() and os.clock() < timeout do
            task.wait(0.05)
        end
    end

    if not self.Enabled then return end

    if Hub.Util.isThrowing() then
        Settings.CurrentStatus = "Food in air (auto-skipping)"
        local throwTimeout = os.clock() + 25
        while self.Enabled and Hub.Util.isThrowing() and os.clock() < throwTimeout do
            task.wait(0.1)
        end
        
        if Hub.Util.isThrowing() then Hub.Util.stopThrow() end
        Settings.TotalThrows = Settings.TotalThrows + 1
        Settings.CurrentStatus = "Throw complete!"
        
        if Settings.EquipOnCatch then task.spawn(Hub.Actions.EquipBest) end
        if Settings.AutoUpgradeFood then task.spawn(Hub.Actions.UpgradeFood) end
        if Settings.AutoUpgradeStand then task.spawn(Hub.Actions.UpgradeStand) end
    end
end

Hub.AutoThrow.Start = function(self)
    self:Stop()
    self.Enabled = true
    Settings.AutoThrow = true
    self.Thread = task.spawn(function()
        while self.Enabled do
            Hub.Util.SafeCall(function() self:Process() end)
            task.wait(math.max(0.1, Settings.ThrowDelay) + Random:NextNumber(0.05, 0.15))
        end
    end)
end

Hub.AutoThrow.ThrowOnce = function(self)
    task.spawn(function()
        local oldEnabled = self.Enabled
        self.Enabled = true
        Settings.AutoThrow = true
        Hub.Util.SafeCall(function() self:Process() end)
        self.Enabled = oldEnabled
        Settings.AutoThrow = oldEnabled
        if not oldEnabled then self:Stop() end
    end)
end

Hub.Loops = {}
Hub.Loops.AutoClick = function()
    while task.wait(Random:NextNumber(0.12, 0.18)) do
        if Settings.AutoClick2x then
            Hub.Util.SafeCall(function()
                local pg = LocalPlayer:FindFirstChild("PlayerGui")
                if not pg then return end
                local bonus = pg:FindFirstChild("TapBonus", true)
                if bonus and bonus:IsA("ImageButton") and bonus.Visible and bonus.Active then
                    if firesignal then firesignal(bonus.Activated) end
                    local rx = Random:NextInteger(-10, 10)
                    local ry = Random:NextInteger(-10, 10)
                    VirtualUser:ClickButton1(bonus.AbsolutePosition + bonus.AbsoluteSize / 2 + Vector2.new(rx, ry))
                end
            end)
        end
    end
end

Hub.Loops.AutoTrain = function()
    local trainingActive = false
    while task.wait(0.2) do
        if Settings.AutoPullUp and not Settings.AutoThrow then
            if not trainingActive then
                if Hub.Util.isThrowing() then Hub.Util.stopThrow() task.wait(0.2) end
                trainingActive = true
                Settings.CurrentStatus = "Moving to training stand"
                Settings.TrainingStatus = "Walking to stand"
                Hub.AutoThrow:SafeTween(Hub.Waypoints.getTrainingSpot(), Settings.TweenSpeed)
                task.wait(0.2)
            end
            if not (TrainingController and TrainingController.IsRunning and TrainingController.IsRunning()) then
                if not (ClientState and ClientState.Busy) then
                    Hub.Util.SafeCall(function()
                        if TrainingController and TrainingController.Start then
                            task.spawn(TrainingController.Start)
                        end
                    end)
                    local t = os.clock()
                    while not (TrainingController and TrainingController.IsRunning and TrainingController.IsRunning()) and os.clock() - t < 2 do
                        task.wait(0.05)
                    end
                end
            end
            if TrainingController and TrainingController.IsRunning and TrainingController.IsRunning() then
                Settings.CurrentStatus = "Training active"
                Settings.TrainingStatus = "Training"
            end
            if Settings.AutoUpgradeStand then Hub.Actions.UpgradeStand() end
            task.wait(0.5)
        elseif trainingActive then
            trainingActive = false
            Settings.TrainingStatus = "Stopping..."
            if TrainingController and TrainingController.IsRunning and TrainingController.IsRunning() then
                Hub.Util.SafeCall(function() TrainingController.Stop() end)
                local t = os.clock()
                while TrainingController.IsRunning() and os.clock() - t < 3 do task.wait(0.05) end
            end
            Hub.Util.SafeCall(function() Remotes.Invoke("Training_Stop") end)
            task.wait(0.2)
            Hub.AutoThrow:SafeTween(Hub.Waypoints.getTrainingSpot() * CFrame.new(0, 0, 7), Settings.TweenSpeed)
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then root.Anchored = false end
            Settings.TrainingStatus = "Not training"
            Settings.CurrentStatus = "Idle"
        end
    end
end

Hub.Loops.AutoEquip = function()
    while task.wait(10) do
        if Settings.AutoEquipLoop then Hub.Actions.EquipBest() end
    end
end

Hub.Util.SafeCall(function()
    local orig = Remotes.Invoke
    Remotes.Invoke = function(name, ...)
        local args = { ... }
        if name == "Throw_Resolve" and Settings.AutoThrow then 
            args[1] = 1 
        end
        local res = orig(name, table.unpack(args))
        if name == "Throw_Resolve" and type(res) == "table" and res.Ok then
            Hub.Util.SafeCall(function()
                local m = res.ModelName or (res.Result and res.Result.ModelName)
                local r = res.Rarity or (res.Result and res.Result.Rarity)
                if m then Settings.LastAnimal = tostring(m) end
                if r then Settings.LastRarity = tostring(r) end
            end)
        end
        return res
    end
end)

Hub.Util.SafeCall(function()
    if ThrowMeter then
        ThrowMeter.TestAutoTap = 0.36
        local orig = ThrowMeter.new
        ThrowMeter.new = function(...)
            local inst = orig(...)
            if inst then inst.Locked = true end
            return inst
        end
    end
end)

Hub.Util.SafeCall(function()
    if RevealSequence and RevealSequence.Run then
        local orig = RevealSequence.Run
        RevealSequence.Run = function(ctx)
            if Settings.AutoThrow and ctx and ctx.Result then
                Hub.Util.SafeCall(function()
                    local animals = (DataController and DataController:Get("Animals")) or {}
                    for _, a in pairs(animals) do
                        if a.ModelName == ctx.Result.ModelName then
                            ctx.CanSkip = true
                            ctx.Owned = true
                            break
                        end
                    end
                end)
            end
            return orig(ctx)
        end
    end
end)

Hub.Util.SafeCall(function()
    if ThrowController and ThrowController.Finished then
        ThrowController.Finished:Connect(function(payload)
            if type(payload) == "table" then
                Hub.Util.SafeCall(function()
                    local m = payload.ModelName or (payload.Result and payload.Result.ModelName)
                    local r = payload.Rarity or (payload.Result and payload.Result.Rarity)
                    if m then Settings.LastAnimal = tostring(m) end
                    if r then Settings.LastRarity = tostring(r) end
                end)
            end
        end)
    end
end)

Hub.Util.SafeCall(function()
    Remotes.Training_Bonus.OnClientEvent:Connect(function(bonusId)
        if Settings.AutoClick2x then
            task.spawn(function()
                Hub.Util.SafeCall(function()
                    local res = Remotes.Training_TapBonus:InvokeServer(bonusId)
                    if res and res.Ok then Settings.TotalBonusTaps = Settings.TotalBonusTaps + 1 end
                end)
            end)
        end
    end)
end)

task.spawn(Hub.Loops.AutoClick)
task.spawn(Hub.Loops.AutoTrain)
task.spawn(Hub.Loops.AutoEquip)

local CentrixUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/xsaliii/clover/refs/heads/main/ui/CentrixUi.luau"))()

local Window = CentrixUI:CreateWindow({
    Title = "Centrix Hub",
    Subtitle = "Throw Food For Animals",
    Size = UDim2.fromOffset(640, 480),
    MinSize = Vector2.new(500, 360),
    Draggable = true,
    Resizable = true,
    UseBlur = false,
    DefaultTab = "Main",
    ToggleKeybind = Enum.KeyCode.RightShift,
})

local MainTab = Window:AddTab({ Title = "Main", Icon = "Lucide:play" })
local PlotTab = Window:AddTab({ Title = "Plot & Shop", Icon = "Lucide:shopping-bag" })
local WaypointTab = Window:AddTab({ Title = "Waypoints", Icon = "Lucide:map-pin" })
local SettingsTab = Window:AddTab({ Title = "Settings", Icon = "Lucide:settings" })

local ThrowSection = MainTab:AddSection({ Title = "Throw Automation", Icon = "Lucide:send" })
local StatsSection = MainTab:AddSection({ Title = "Statistics", Icon = "Lucide:bar-chart" })
local TrainSection = MainTab:AddSection({ Title = "Pull Up Automation", Icon = "Lucide:dumbbell" })
local TrainStats = MainTab:AddSection({ Title = "Training Stats", Icon = "Lucide:bar-chart" })

local AnimalSection = PlotTab:AddSection({ Title = "Animals & Plot", Icon = "Lucide:paw-print" })
local UpgradeSection = PlotTab:AddSection({ Title = "Auto Upgrades", Icon = "Lucide:arrow-up" })

local PlotWp = WaypointTab:AddSection({ Title = "Plot Locations", Icon = "Lucide:map-pin" })
local WorldWp = WaypointTab:AddSection({ Title = "World Locations", Icon = "Lucide:globe" })

local HubSection = SettingsTab:AddSection({ Title = "Hub Settings", Icon = "Lucide:settings" })

ThrowSection:AddToggle({
    Title = "Auto Throw (100% Power)",
    Description = "Automatically throws food at full power.",
    Icon = "Lucide:send",
    Default = false,
    Callback = function(v)
        if v then
            Settings.AutoPullUp = false
            if ClientState and ClientState.Busy == "Training" then
                Hub.Util.SafeCall(function() if TrainingController then TrainingController.Stop() end end)
                Hub.Util.SafeCall(function() Remotes.Training_Stop:InvokeServer() end)
                task.wait(0.2)
                ClientState.Busy = nil
            end
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then root.Anchored = false end
            Hub.AutoThrow:Start()
        else
            Settings.CurrentStatus = "Idle"
            Hub.AutoThrow:Stop()
        end
        Window:Notify({ Title = "Auto Throw", Text = v and "Enabled." or "Disabled.", Type = v and "success" or "info", Duration = 2 })
    end,
})

ThrowSection:AddToggle({
    Title = "Equip Best Pets on Catch",
    Description = "Equips best animals after each successful catch.",
    Icon = "Lucide:star",
    Default = true,
    Callback = function(v) Settings.EquipOnCatch = v end,
})

ThrowSection:AddSlider({
    Title = "Throw Interval Delay",
    Description = "Delay between throws.",
    Icon = "Lucide:clock",
    Min = 0.1,
    Max = 3,
    Default = 0.5,
    Decimals = 1,
    Callback = function(v) Settings.ThrowDelay = v end,
})

ThrowSection:AddButton({
    Title = "Throw Once Now",
    Description = "Performs one throw immediately.",
    Icon = "Lucide:send",
    Callback = function() Hub.AutoThrow:ThrowOnce() end,
})

local statusLbl = StatsSection:AddLabel("Status: Idle")
local throwsLbl = StatsSection:AddLabel("Total Throws: 0")
local lastLbl = StatsSection:AddLabel("Last Catch: None")
local rarityLbl = StatsSection:AddLabel("Rarity: None")

TrainSection:AddToggle({
    Title = "Auto Pull Up Bar",
    Description = "Automatically trains at pull up stand.",
    Icon = "Lucide:dumbbell",
    Default = false,
    Callback = function(v)
        Settings.AutoPullUp = v
        if v then
            Hub.AutoThrow:Stop()
            if ClientState and ClientState.Busy == "Throw" then Hub.Util.stopThrow() end
        else
            Hub.AutoThrow:CancelTween()
            if TrainingController and TrainingController.Stop then
                Hub.Util.SafeCall(function() TrainingController.Stop() end)
            end
            Hub.Util.SafeCall(function() Remotes.Training_Stop:InvokeServer() end)
            task.wait(0.3)
            Hub.AutoThrow:SafeTween(Hub.Waypoints.getTrainingSpot() * CFrame.new(0, 0, 7), Settings.TweenSpeed)
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then root.Anchored = false end
        end
        Window:Notify({ Title = "Auto Pull Up", Text = v and "Enabled." or "Disabled.", Type = v and "success" or "info", Duration = 2 })
    end,
})

TrainSection:AddToggle({
    Title = "Auto Click 2x Minigame",
    Description = "Clicks the 2x bonus minigame automatically.",
    Icon = "Lucide:hand",
    Default = true,
    Callback = function(v) Settings.AutoClick2x = v end,
})

TrainSection:AddButton({
    Title = "Start Training (Walk to Stand)",
    Icon = "Lucide:play",
    Callback = function()
        task.spawn(function()
            Hub.AutoThrow:SafeTween(Hub.Waypoints.getTrainingSpot(), Settings.TweenSpeed)
            task.wait(0.2)
            if not (TrainingController and TrainingController.IsRunning and TrainingController.IsRunning()) then
                Hub.Util.SafeCall(function()
                    if TrainingController and TrainingController.Start then task.spawn(TrainingController.Start) end
                end)
            end
        end)
    end,
})

TrainSection:AddButton({
    Title = "Stop Training (Step Back)",
    Icon = "Lucide:square",
    Callback = function()
        task.spawn(function()
            if TrainingController and TrainingController.IsRunning and TrainingController.IsRunning() then
                Hub.Util.SafeCall(function() TrainingController.Stop() end)
                local t = os.clock()
                while TrainingController.IsRunning() and os.clock() - t < 3 do task.wait(0.05) end
            end
            Hub.Util.SafeCall(function() Remotes.Invoke("Training_Stop") end)
            task.wait(0.2)
            Hub.AutoThrow:SafeTween(Hub.Waypoints.getTrainingSpot() * CFrame.new(0, 0, 7), Settings.TweenSpeed)
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then root.Anchored = false end
        end)
    end,
})

local trainLbl = TrainStats:AddLabel("Training: Not Training")
local bonusLbl = TrainStats:AddLabel("2x Claims: 0")

AnimalSection:AddToggle({
    Title = "Auto Equip Best (10s loop)",
    Description = "Re-equips best animals every 10 seconds.",
    Icon = "Lucide:star",
    Default = false,
    Callback = function(v)
        Settings.AutoEquipLoop = v
        if v then Hub.Actions.EquipBest() end
    end,
})

AnimalSection:AddButton({
    Title = "Equip Best Animals Now",
    Icon = "Lucide:star",
    Callback = function() Hub.Actions.EquipBest() end,
})

UpgradeSection:AddToggle({
    Title = "Auto Upgrade Pull Up Stand",
    Icon = "Lucide:arrow-up",
    Default = false,
    Callback = function(v)
        Settings.AutoUpgradeStand = v
        if v then Hub.Actions.UpgradeStand() end
    end,
})

UpgradeSection:AddButton({
    Title = "Upgrade Stand Once Now",
    Icon = "Lucide:arrow-up",
    Callback = function() Hub.Actions.UpgradeStand() end,
})

UpgradeSection:AddToggle({
    Title = "Auto Upgrade Foods",
    Icon = "Lucide:utensils",
    Default = false,
    Callback = function(v)
        Settings.AutoUpgradeFood = v
        if v then Hub.Actions.UpgradeFood() end
    end,
})

UpgradeSection:AddButton({
    Title = "Buy & Equip Highest Food Now",
    Icon = "Lucide:utensils",
    Callback = function() Hub.Actions.UpgradeFood() end,
})

PlotWp:AddButton({
    Title = "Tween to Pull Up Stand",
    Icon = "Lucide:map-pin",
    Callback = function()
        local cf = Hub.Waypoints.getTrainingSpot()
        if cf then Hub.AutoThrow:SafeTween(cf, Settings.TweenSpeed) end
    end,
})

PlotWp:AddButton({
    Title = "Tween to Plot Center",
    Icon = "Lucide:map-pin",
    Callback = function()
        local cf = Hub.Waypoints.getPlotCenter()
        if cf then Hub.AutoThrow:SafeTween(cf, Settings.TweenSpeed) end
    end,
})

WorldWp:AddButton({
    Title = "Tween to Throw Starter Area",
    Icon = "Lucide:globe",
    Callback = function() Hub.AutoThrow:SafeTween(Hub.Waypoints.getThrowArea(), Settings.TweenSpeed) end,
})

WorldWp:AddSlider({
    Title = "Tween Speed",
    Icon = "Lucide:gauge",
    Min = 15,
    Max = 60,
    Default = 28,
    Decimals = 0,
    Callback = function(v) Settings.TweenSpeed = v end,
})

HubSection:AddButton({
    Title = "Unload Centrix Hub",
    Icon = "Lucide:log-out",
    Callback = function()
        Settings.AutoPullUp = false
        Settings.AutoClick2x = false
        Settings.AutoEquipLoop = false
        Settings.AutoUpgradeStand = false
        Settings.AutoUpgradeFood = false
        Hub.AutoThrow:Stop()
        if TrainingController and TrainingController.Stop then
            Hub.Util.SafeCall(function() TrainingController.Stop() end)
        end
        Hub.Util.SafeCall(function() Remotes.Invoke("Training_Stop") end)
        Window:Destroy()
    end,
})

local UI_References = {
    { label = statusLbl, key = "CurrentStatus", prefix = "Status: " },
    { label = throwsLbl, key = "TotalThrows", prefix = "Total Throws: " },
    { label = lastLbl, key = "LastAnimal", prefix = "Last Catch: " },
    { label = rarityLbl, key = "LastRarity", prefix = "Rarity: " },
    { label = trainLbl, key = "TrainingStatus", prefix = "Training: " },
    { label = bonusLbl, key = "TotalBonusTaps", prefix = "2x Claims: " },
}

local CachedValues = {}

Hub.Loops.UIUpdater = function()
    while task.wait(0.2) do
        for _, item in ipairs(UI_References) do
            if item.label and item.label.Set then
                local currentText = tostring(Settings[item.key])
                if CachedValues[item.key] ~= currentText then
                    CachedValues[item.key] = currentText
                    Hub.Util.SafeCall(function()
                        item.label:Set(item.prefix .. currentText)
                    end)
                end
            end
        end
    end
end

task.spawn(Hub.Loops.UIUpdater)
