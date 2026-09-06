local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local Window = Library:CreateWindow({
    Title = 'AUTO HIT & UTILITY',
    Footer = 'discord.gg/yourdiscord',
    Icon = 'target',
    NotifySide = 'Right',
    ShowCustomCursor = true,
    AutoShow = true
})

-- ==========================================
-- TABS
-- ==========================================
local MainTab = Window:AddTab('Main')
local CombatTab = Window:AddTab('Combat')
local UtilityTab = Window:AddTab('Utility')
local HiderTab = Window:AddTab('Hider')
local SpikeTab = Window:AddTab('Spikes')
local LighterTab = Window:AddTab('Lighter')
local SettingsTab = Window:AddTab('Settings')

-- ==========================================
-- MAIN TAB
-- ==========================================
local MainGB = MainTab:AddLeftGroupbox('Main Features')
local UtilitiesGB = MainTab:AddRightGroupbox('Utilities')

-- Auto Hit Main Toggle
MainGB:AddToggle('AutoHitToggle', {
    Text = '⚔️ AUTO HIT (Scan & Attack)',
    Default = false,
    Callback = function(Value)
        getgenv().AutoHit = Value
        task.spawn(function()
            while getgenv().AutoHit do
                pcall(function()
                    local HitRange = getgenv().HitRange or 15
                    local HitRemote = nil
                    
                    -- Find hit remote
                    local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
                    if Remotes then
                        HitRemote = Remotes:FindFirstChild("Fists") or 
                                   Remotes:FindFirstChild("Fork") or
                                   Remotes:FindFirstChild("Hit") or
                                   Remotes:FindFirstChild("Attack") or
                                   Remotes:FindFirstChild("Punch") or
                                   Remotes:FindFirstChild("Swing") or
                                   Remotes:FindFirstChild("Melee")
                    end
                    
                    if HitRemote and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                                if Distance <= HitRange then
                                    -- Face target
                                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                                        LocalPlayer.Character.HumanoidRootPart.Position,
                                        player.Character.HumanoidRootPart.Position
                                    )
                                    -- Hit
                                    HitRemote:FireServer(player.Character)
                                    task.wait(0.1)
                                end
                            end
                        end
                    end
                end)
                task.wait(getgenv().HitDelay or 0.5)
            end
        end)
    end
})

-- Hit Range Slider
MainGB:AddSlider('HitRangeSlider', {
    Text = 'Hit Range (Studs)',
    Default = 15,
    Min = 5,
    Max = 30,
    Callback = function(Value)
        getgenv().HitRange = Value
    end
})

-- Hit Delay Slider
MainGB:AddSlider('HitDelaySlider', {
    Text = 'Hit Delay (Seconds)',
    Default = 0.5,
    Min = 0.1,
    Max = 2,
    Callback = function(Value)
        getgenv().HitDelay = Value
    end
})

-- Manual Hit Button
MainGB:AddButton('👊 Manual Hit Nearest', function()
    pcall(function()
        local HitRemote = nil
        local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
        if Remotes then
            HitRemote = Remotes:FindFirstChild("Fists") or 
                       Remotes:FindFirstChild("Fork") or
                       Remotes:FindFirstChild("Hit")
        end
        
        if HitRemote and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local Nearest = nil
            local NearestDist = 9999
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if Distance < NearestDist then
                        NearestDist = Distance
                        Nearest = player
                    end
                end
            end
            
            if Nearest then
                HitRemote:FireServer(Nearest.Character)
                Library:Notify({
                    Title = "Hit",
                    Description = "Hit " .. Nearest.Name,
                    Time = 2
                })
            end
        end
    end)
end)

-- ==========================================
-- COMBAT TAB
-- ==========================================
local CombatFeatures = CombatTab:AddLeftGroupbox('Combat Features')
local CombatUtilities = CombatTab:AddRightGroupbox('Combat Utilities')

-- Kill Aura
CombatFeatures:AddToggle('KillAuraToggle', {
    Text = '💀 KILL AURA (Range Based)',
    Default = false,
    Callback = function(Value)
        getgenv().KillAura = Value
        task.spawn(function()
            while getgenv().KillAura do
                pcall(function()
                    local HitRemote = nil
                    local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
                    if Remotes then
                        HitRemote = Remotes:FindFirstChild("Fists") or 
                                   Remotes:FindFirstChild("Fork") or
                                   Remotes:FindFirstChild("Hit")
                    end
                    
                    if HitRemote and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                local Distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                                if Distance < 15 then
                                    HitRemote:FireServer(player.Character)
                                end
                            end
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

-- Fling All
CombatFeatures:AddToggle('FlingAllToggle', {
    Text = '🌀 FLING ALL PLAYERS',
    Default = false,
    Callback = function(Value)
        getgenv().FlingAll = Value
        task.spawn(function()
            while getgenv().FlingAll do
                pcall(function()
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local hum = player.Character:FindFirstChildOfClass("Humanoid")
                            if hum then
                                hum:ChangeState(Enum.HumanoidStateType.Seated)
                                hum:ChangeState(Enum.HumanoidStateType.Ragdoll)
                            end
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
                                LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(9999, 9999, 9999)
                            end
                        end
                    end
                end)
                task.wait()
            end
        end)
    end
})

-- Stop Fling Button
CombatUtilities:AddButton('🛑 Stop Fling', function()
    getgenv().FlingAll = false
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    end
    Library:Notify({
        Title = "Fling Stopped",
        Description = "All players fling disabled",
        Time = 2
    })
end)

-- ==========================================
-- HIDER TAB
-- ==========================================
local HiderFeatures = HiderTab:AddLeftGroupbox('Hider Features')
local HiderUtilities = HiderTab:AddRightGroupbox('Hider Utilities')

-- Auto Kill Hider
HiderFeatures:AddToggle('KillHidersToggle', {
    Text = '🔍 KILL HIDERS (Auto Detect)',
    Default = false,
    Callback = function(Value)
        getgenv().KillHiders = Value
        task.spawn(function()
            while getgenv().KillHiders do
                pcall(function()
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            -- Check if player is a hider
                            local IsHider = false
                            
                            if player.Name:lower():find("hider") or 
                               player.DisplayName:lower():find("hider") then
                                IsHider = true
                            end
                            
                            if player.Character:FindFirstChild("Hider") or
                               player.Character:FindFirstChild("HiderTag") then
                                IsHider = true
                            end
                            
                            for _, Child in ipairs(player.Character:GetChildren()) do
                                if Child.Name:lower():find("hider") then
                                    IsHider = true
                                    break
                                end
                            end
                            
                            if IsHider and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                -- Teleport to hider
                                LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0)
                                task.wait(0.1)
                                
                                -- Hit the hider
                                local HitRemote = nil
                                local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
                                if Remotes then
                                    HitRemote = Remotes:FindFirstChild("Fists") or 
                                               Remotes:FindFirstChild("Fork") or
                                               Remotes:FindFirstChild("Hit")
                                end
                                
                                if HitRemote then
                                    HitRemote:FireServer(player.Character)
                                    Library:Notify({
                                        Title = "Hider Killed",
                                        Description = "Killed " .. player.Name,
                                        Time = 1.5
                                    })
                                end
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
})

-- Teleport to Random Hider
HiderUtilities:AddButton('🎯 TP to Random Hider', function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if player.Name:lower():find("hider") and LocalPlayer.Character then
                LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
                Library:Notify({
                    Title = "Teleported",
                    Description = "To " .. player.Name,
                    Time = 2
                })
                break
            end
        end
    end
end)

-- ==========================================
-- SPIKE TAB
-- ==========================================
local SpikeFeatures = SpikeTab:AddLeftGroupbox('Spike Features')
local SpikeUtilities = SpikeTab:AddRightGroupbox('Spike Utilities')

-- Auto Destroy Spikes
SpikeFeatures:AddToggle('AutoDestroySpikes', {
    Text = '⚡ AUTO DESTROY SPIKES',
    Default = false,
    Callback = function(Value)
        getgenv().AutoSpikes = Value
        task.spawn(function()
            while getgenv().AutoSpikes do
                pcall(function()
                    local Count = 0
                    for _, Object in ipairs(Workspace:GetDescendants()) do
                        if Object.Name and Object.Name:lower():find("spike") then
                            if Object:IsA("BasePart") or Object:IsA("MeshPart") then
                                Object:Destroy()
                                Count = Count + 1
                            end
                        end
                    end
                    if Count > 0 then
                        Library:Notify({
                            Title = "Spikes Removed",
                            Description = "Destroyed " .. Count .. " spikes",
                            Time = 1
                        })
                    end
                end)
                task.wait(2)
            end
        end)
    end
})

-- Destroy Spikes Button
SpikeUtilities:AddButton('🗑️ Destroy All Spikes (Once)', function()
    local Count = 0
    for _, Object in ipairs(Workspace:GetDescendants()) do
        if Object.Name and Object.Name:lower():find("spike") then
            if Object:IsA("BasePart") or Object:IsA("MeshPart") then
                Object:Destroy()
                Count = Count + 1
            end
        end
    end
    Library:Notify({
        Title = "Spikes Destroyed",
        Description = "Removed " .. Count .. " spikes!",
        Time = 2
    })
end)

-- ==========================================
-- LIGHTER TAB
-- ==========================================
local LighterFeatures = LighterTab:AddLeftGroupbox('Lighter Features')
local LighterUtilities = LighterTab:AddRightGroupbox('Lighter Utilities')

-- Auto Collect Lighters
LighterFeatures:AddToggle('AutoCollectLighters', {
    Text = '🔥 AUTO COLLECT LIGHTERS',
    Default = false,
    Callback = function(Value)
        getgenv().AutoLighter = Value
        task.spawn(function()
            while getgenv().AutoLighter do
                pcall(function()
                    local Count = 0
                    for _, Object in ipairs(Workspace:GetDescendants()) do
                        if Object.Name and Object.Name:lower():find("lighter") then
                            if Object:IsA("BasePart") or Object:IsA("MeshPart") or Object:IsA("Tool") then
                                if LocalPlayer.Character then
                                    local Clone = Object:Clone()
                                    Clone.Parent = LocalPlayer.Character
                                    Clone.Anchored = false
                                    
                                    if Clone:IsA("Tool") then
                                        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                                            tool:Destroy()
                                        end
                                        Clone.Parent = LocalPlayer.Backpack
                                    end
                                    
                                    Object:Destroy()
                                    Count = Count + 1
                                end
                            end
                        end
                    end
                    if Count > 0 then
                        Library:Notify({
                            Title = "Lighters Collected",
                            Description = "Collected " .. Count .. " lighters!",
                            Time = 1.5
                        })
                    end
                end)
                task.wait(1)
            end
        end)
    end
})

-- Collect Lighters Button
LighterUtilities:AddButton('🔥 Collect All Lighters (Once)', function()
    local Count = 0
    for _, Object in ipairs(Workspace:GetDescendants()) do
        if Object.Name and Object.Name:lower():find("lighter") then
            if Object:IsA("BasePart") or Object:IsA("MeshPart") or Object:IsA("Tool") then
                if LocalPlayer.Character then
                    local Clone = Object:Clone()
                    Clone.Parent = LocalPlayer.Character
                    Clone.Anchored = false
                    
                    if Clone:IsA("Tool") then
                        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                            tool:Destroy()
                        end
                        Clone.Parent = LocalPlayer.Backpack
                    end
                    
                    Object:Destroy()
                    Count = Count + 1
                end
            end
        end
    end
    Library:Notify({
        Title = "Lighters Collected",
        Description = "Collected " .. Count .. " lighters!",
        Time = 2
    })
end)

-- ==========================================
-- UTILITY TAB
-- ==========================================
local UtilityFeatures = UtilityTab:AddLeftGroupbox('Utility Features')
local UtilityButtons = UtilityTab:AddRightGroupbox('Utility Buttons')

-- Noclip
UtilityFeatures:AddToggle('NoclipToggle', {
    Text = '🌊 NOCLIP',
    Default = false,
    Callback = function(Value)
        getgenv().Noclip = Value
        RunService.RenderStepped:Connect(function()
            if getgenv().Noclip and LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
})

-- Godmode
UtilityFeatures:AddToggle('GodmodeToggle', {
    Text = '🛡️ GODMODE (BETA)',
    Default = false,
    Callback = function(Value)
        getgenv().Godmode = Value
        if getgenv().Godmode then
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.FallenPartsDestroyHeight = 0 / 0
            end
        end
    end
})

-- WalkSpeed
UtilityFeatures:AddSlider('WalkSpeedSlider', {
    Text = '🏃 WalkSpeed',
    Default = 16,
    Min = 16,
    Max = 100,
    Callback = function(Value)
        getgenv().WalkSpeed = Value
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = Value
        end
    end
})

-- JumpPower
UtilityFeatures:AddSlider('JumpPowerSlider', {
    Text = '⬆️ JumpPower',
    Default = 50,
    Min = 50,
    Max = 200,
    Callback = function(Value)
        getgenv().JumpPower = Value
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.JumpPower = Value
        end
    end
})

-- Teleport Up
UtilityButtons:AddButton('⬆️ Teleport 100 Up', function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = root.CFrame + Vector3.new(0, 100, 0)
    end
end)

-- Teleport Down
UtilityButtons:AddButton('⬇️ Teleport 100 Down', function()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = root.CFrame - Vector3.new(0, 100, 0)
    end
end)

-- ==========================================
-- SETTINGS TAB
-- ==========================================
local SettingsGB = SettingsTab:AddLeftGroupbox('UI Settings')

SettingsGB:AddButton('💾 Save Settings', function()
    SaveManager:Save()
    Library:Notify({
        Title = "Saved",
        Description = "Settings saved successfully!",
        Time = 2
    })
end)

SettingsGB:AddButton('📂 Load Settings', function()
    SaveManager:Load()
    Library:Notify({
        Title = "Loaded",
        Description = "Settings loaded successfully!",
        Time = 2
    })
end)

-- ==========================================
-- NOTIFICATION
-- ==========================================
Library:Notify({
    Title = "AUTO HIT & UTILITY",
    Description = "All systems loaded successfully!",
    Time = 3
})

-- ==========================================
-- LIBRARY SETUP
-- ==========================================
Library:SetLibrary()
Library:SetIgnoreIndexes()
Library:SetFolder('autohit')

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes()
ThemeManager:SetFolder('autohit')
SaveManager:SetFolder('autohit/AHU')
SaveManager:BuildConfigSection(SettingsTab)
ThemeManager:ApplyToTab(SettingsTab)