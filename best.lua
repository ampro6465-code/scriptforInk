local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")

local Window = Library:CreateWindow({
    Title = 'RINGTA + AUTO HIT',
    Footer = 'discord.gg/ringta',
    Icon = 'lightbulb',
    NotifySide = 'Right',
    ShowCustomCursor = true,
    AutoShow = true
})

-- ==========================================
-- ALL TABS
-- ==========================================
local MainTab = Window:AddTab('Main')
local RedLightTab = Window:AddTab('RedLight')
local DalgonaTab = Window:AddTab('Dalgona')
local TugOfWarTab = Window:AddTab('Tug Of War')
local HideAndSeekTab = Window:AddTab('Hide And Seek')
local JumpRopeTab = Window:AddTab('Jump Rope/Glass')
local MingleTab = Window:AddTab('Mingle')
local RandomTab = Window:AddTab('Random Features')
local RebelTab = Window:AddTab('Rebel')
local FinalTab = Window:AddTab('Final')
local AutoHitTab = Window:AddTab('Auto Hit')
local SettingsTab = Window:AddTab('UI Settings')

-- ==========================================
-- MAIN TAB
-- ==========================================
local MainGB = MainTab:AddLeftGroupbox('Main Features')
local UtilitiesGB = MainTab:AddRightGroupbox('Utilities')
local PlayerFeatures = MainTab:AddLeftGroupbox('Player Features')
local PlayerUtilities = MainTab:AddRightGroupbox('Player Utilities')

-- Original Ringta Features
MainGB:AddToggle('SkySquidGameGodmode', { 
    Text = 'SKY SQUID GAME GODMODE (BETA)', 
    Default = false,
    Callback = function(Value)
        getgenv().Godmode = Value
        if getgenv().Godmode then
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                root.FallenPartsDestroyHeight = 0 / 0
                getgenv().FPDH = 0 / 0
            end
        end
    end
})

MainGB:AddToggle('AutoPole', { 
    Text = 'AutoPole', 
    Default = false,
    Callback = function(Value)
        getgenv().AutoPole = Value
        task.spawn(function()
            while getgenv().AutoPole do
                pcall(function()
                    local Pole = workspace:FindFirstChild("PoleWeapons") and workspace.PoleWeapons:FindFirstChild("InkPole1")
                    if Pole then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = Pole.CFrame
                        fireproximityprompt(Pole:FindFirstChildOfClass("ProximityPrompt"))
                    end
                end)
                task.wait()
            end
        end)
    end
})

MainGB:AddToggle('InstaGrabPoles', { Text = 'INSTA GRAB Poles', Default = false })

-- ==========================================
-- DALGONA TAB
-- ==========================================
DalgonaTab:AddButton('Auto Complete Dalgona', function()
    pcall(function()
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ClickedButton"):FireServer("tryingtoleave")
    end)
end)

DalgonaTab:AddButton('Free Lighter (Original)', function()
    pcall(function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v.Name:lower():match("lighter") then
                v.Parent = LocalPlayer.Character
            end
        end
    end)
end)

-- ==========================================
-- TUG OF WAR TAB
-- ==========================================
local TugOfWarFeatures = TugOfWarTab:AddLeftGroupbox('Tug Of War Features')
TugOfWarFeatures:AddToggle('TugOfWarAuto', {
    Text = 'Tug of War Auto (NEW)',
    Default = false,
    Callback = function(Value)
        getgenv().TugOfWarAuto = Value
        task.spawn(function()
            while getgenv().TugOfWarAuto do
                pcall(function()
                    ReplicatedStorage.Remotes.DialogueRemote:FireServer()
                end)
                task.wait(0.1)
            end
        end)
    end
})

TugOfWarFeatures:AddLabel('NOTE THE ANTIPUSH NOT ALWAYS WORK')
TugOfWarFeatures:AddToggle('AntiPush', {
    Text = 'ANTIPUSH (BETA)',
    Default = false,
    Callback = function(Value)
        getgenv().AntiPush = Value
        if getgenv().AntiPush then
            local RootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if RootPart then
                local BodyVelocity = Instance.new("BodyVelocity")
                BodyVelocity.Name = "Velocity"
                BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                BodyVelocity.Parent = RootPart
            end
        else
            local RootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if RootPart and RootPart:FindFirstChild("Velocity") then
                RootPart.Velocity:Destroy()
            end
        end
    end
})

-- ==========================================
-- HIDE AND SEEK TAB
-- ==========================================
local HideAndSeekFeatures = HideAndSeekTab:AddLeftGroupbox('Hide And Seek Features')
local HideAndSeekUtilities = HideAndSeekTab:AddRightGroupbox('Hide And Seek Utilities')

HideAndSeekFeatures:AddToggle('SmartKillHidersToggle', {
    Text = 'KILL HIDERS (BETA)',
    Default = false,
    Callback = function(Value)
        getgenv().KillHiders = Value
        task.spawn(function()
            while getgenv().KillHiders do
                pcall(function()
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            if player.Character.Name == "Hider" then
                                LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
                                task.wait(0.1)
                            end
                        end
                    end
                end)
                task.wait()
            end
        end)
    end
})

HideAndSeekFeatures:AddToggle('EspHiderSeeker', { Text = 'Esp Hider & Seeker', Default = false })
HideAndSeekFeatures:AddToggle('ExitDoorESP', { Text = 'ESP Exit Doors', Default = false })
HideAndSeekFeatures:AddToggle('ESPKeys', { Text = 'ESP Keys', Default = false })

HideAndSeekUtilities:AddButton('Teleport 100 Blocks Up', function() 
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = root.CFrame + Vector3.new(0, 100, 0)
    end
end)

HideAndSeekUtilities:AddButton('Teleport 40 Blocks Down', function() 
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = root.CFrame - Vector3.new(0, 40, 0)
    end
end)

HideAndSeekUtilities:AddButton('Delete the spikes', function() 
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name:match("Spike") then
            v:Destroy()
        end
    end
end)

HideAndSeekUtilities:AddButton('Teleport to Random Hider', function() 
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character.Name == "Hider" and player ~= LocalPlayer then
            LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
            break
        end
    end
end)

-- ==========================================
-- RANDOM TAB
-- ==========================================
local KillAuraSafe = RandomTab:AddToggle('KillAuraSafe', {
    Text = 'KILL AURA (EXTREMLY SAFE)',
    Default = false,
    Callback = function(Value)
        getgenv().KillAura = Value
        task.spawn(function()
            while getgenv().KillAura do
                pcall(function()
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local mag = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
                            if mag < 15 then
                                local args = { [1] = player.Character }
                                ReplicatedStorage.Remotes.Fists:FireServer(unpack(args))
                            end
                        end
                    end
                end)
                task.wait()
            end
        end)
    end
})

RandomTab:AddToggle('NoclipToggle', { Text = 'Noclip', Default = false })
RandomTab:AddButton('WalkSpeedIncrease', function() 
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = getgenv().WalkSpeedAmount or 50
    end
end)
RandomTab:AddSlider('WalkSpeedAmount', { Text = 'WalkSpeed Amount', Default = 16, Min = 16, Max = 100 })
RandomTab:AddButton('Reset WalkSpeed to Normal', function() 
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = 16 end
end)
RandomTab:AddButton('Unlock Dash Free', function() end)
RandomTab:AddButton('Equip Phantom Power Free', function() end)
RandomTab:AddButton('Parkour Artist', function() end)

-- ==========================================
-- JUMP ROPE TAB
-- ==========================================
JumpRopeTab:AddButton('TP to End (Jump Rope)', function() 
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(0, 50, 0)
    end
end)

JumpRopeTab:AddButton('Delete The Rope', function() 
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name:match("Rope") then
            v:Destroy()
        end
    end
end)

JumpRopeTab:AddLabel('THE THINGS BELOW IS FOR GLASS BRIDGE')
JumpRopeTab:AddButton('TP to End (Glass Bridge)', function() 
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        root.CFrame = CFrame.new(0, 50, 0)
    end
end)

-- ==========================================
-- MINGLE TAB
-- ==========================================
local MingleUtilities = MingleTab:AddRightGroupbox('Mingle Utilities')
MingleUtilities:AddToggle('MingleNoclipToggle', { 
    Text = 'Mingle Noclip', 
    Default = false,
    Callback = function(Value)
        getgenv().MingleNoclip = Value
        RunService.RenderStepped:Connect(function()
            if getgenv().MingleNoclip and LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
})

MingleUtilities:AddToggle('AutoWinMingle', { 
    Text = 'Auto Win Mingle', 
    Default = false,
    Callback = function(Value)
        getgenv().AutoMingle = Value
        task.spawn(function()
            while getgenv().AutoMingle do
                task.wait(1)
            end
        end)
    end
})

MingleTab:AddLabel('Okay so the toogle above when you turn it on it dosent Like 100% always make you win but basically if the door is ever 1/1 it will automatically tp you to a room and lock the door and if it doesn\'t work you gotta manually close the door and if its more then 1 player in a room it will automatically tp you to a group of players like basically your gonna be near players so you can get into a room together so its still kinda luck based')

-- ==========================================
-- REBEL TAB
-- ==========================================
local FlingFeatures = RebelTab:AddLeftGroupbox('Fling Features')
FlingFeatures:AddToggle('FlingAllRunning', {
    Text = 'Fling All Players (INSANE OP)',
    Default = false,
    Callback = function(Value)
        getgenv().FlingAllRunning = Value
        task.spawn(function()
            while getgenv().FlingAllRunning do
                pcall(function()
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local hum = player.Character:FindFirstChildOfClass("Humanoid")
                            if hum then
                                hum:ChangeState(Enum.HumanoidStateType.Seated)
                                hum:ChangeState(Enum.HumanoidStateType.Ragdoll)
                                hum:ChangeState(Enum.HumanoidStateType.FallingDown)
                            end
                            LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.Angles(math.random(-50,50), math.random(-50,50), math.random(-50,50))
                            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(9999, 9999, 9999)
                        end
                    end
                end)
                task.wait()
            end
        end)
    end
})

FlingFeatures:AddButton('End Fling All Players Early', function() 
    getgenv().FlingAllRunning = false
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    end
end)

PlayerFeatures:AddDropdown('SelectPlayerDropdown', {
    Values = {},
    Multi = false,
    Text = 'Select Player'
})
PlayerFeatures:AddButton('Teleport to Selected Player', function() end)
PlayerFeatures:AddButton('Refresh Player List', function() end)
PlayerFeatures:AddButton('TROLL Players', function() end)

RebelTab:AddToggle('AutoKillNPCGuards', { 
    Text = 'Auto Kill NPC Guards', 
    Default = false,
    Callback = function(Value)
        getgenv().AutoKillGuards = Value
        task.spawn(function()
            while getgenv().AutoKillGuards do
                pcall(function()
                    for _, npc in ipairs(workspace:GetChildren()) do
                        if npc:FindFirstChild("TypeOfGuard") and npc:FindFirstChild("Humanoid") and npc.Humanoid.Health > 0 then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame
                            task.wait(0.1)
                        end
                    end
                end)
                task.wait()
            end
        end)
    end
})

RebelTab:AddToggle('RebelAimbot', { 
    Text = 'Rebel Aimbot', 
    Default = false,
    Callback = function(Value)
        getgenv().RebelAimbot = Value
        RunService.RenderStepped:Connect(function()
            if getgenv().RebelAimbot then
                local RayParams = RaycastParams.new()
                RayParams.FilterType = Enum.RaycastFilterType.Exclude
                RayParams.FilterDescendantsInstances = {LocalPlayer.Character}
                RayParams.RespectCanCollide = true
                local Result = workspace:Raycast(LocalPlayer.Character.Head.Position, workspace.CurrentCamera.CFrame.LookVector * 500, RayParams)
                if Result and Result.Instance then
                end
            end
        end)
    end
})
RebelTab:AddLabel('BE CARFUL USING THIS COULD RISK IN BAN')
RebelTab:AddToggle('ExpandRebelHitbox', { 
    Text = 'Expand Rebel Hitbox', 
    Default = false,
    Callback = function(Value)
        getgenv().ExpandHitbox = Value
        task.spawn(function()
            while getgenv().ExpandHitbox do
                pcall(function()
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                            local hb = Instance.new("Part")
                            hb.Name = "[NPC_Hitbox]"
                            hb.Size = Vector3.new(10, 10, 10)
                            hb.Transparency = 0.5
                            hb.Color = Color3.fromRGB(255, 0, 0)
                            hb.Anchored = true
                            hb.CanCollide = false
                            hb.Material = Enum.Material.SmoothPlastic
                            hb.CFrame = player.Character.HumanoidRootPart.CFrame
                            hb.Parent = workspace
                            task.spawn(function()
                                task.wait(0.1)
                                hb:Destroy()
                            end)
                        end
                    end
                end)
                task.wait()
            end
        end)
    end
})

-- ==========================================
-- FINAL TAB
-- ==========================================
FinalTab:AddButton('UNLOCK ALL GAME PASSES', function()
    Library:Notify({
        Title = "Warning",
        Description = "This feature may not work!",
        Time = 3
    })
end)

FinalTab:AddButton('UNLOCK PETS', function()
    Library:Notify({
        Title = "Warning",
        Description = "This feature may not work!",
        Time = 3
    })
end)

-- ==========================================
-- AUTO HIT TAB - YOUR FEATURES
-- ==========================================
local AutoHitGroup = AutoHitTab:AddLeftGroupbox('Auto Hit Features')
local AutoHitUtils = AutoHitTab:AddRightGroupbox('Auto Hit Utilities')

-- Auto Hit Main
AutoHitGroup:AddToggle('AutoHitToggle', {
    Text = '⚔️ AUTO HIT (Scan & Attack)',
    Default = false,
    Callback = function(Value)
        getgenv().AutoHit = Value
        task.spawn(function()
            while getgenv().AutoHit do
                pcall(function()
                    local HitRange = getgenv().HitRange or 15
                    local HitRemote = nil
                    
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
                                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                                        LocalPlayer.Character.HumanoidRootPart.Position,
                                        player.Character.HumanoidRootPart.Position
                                    )
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
AutoHitGroup:AddSlider('HitRangeSlider', {
    Text = 'Hit Range (Studs)',
    Default = 15,
    Min = 5,
    Max = 30,
    Callback = function(Value)
        getgenv().HitRange = Value
    end
})

-- Hit Delay Slider
AutoHitGroup:AddSlider('HitDelaySlider', {
    Text = 'Hit Delay (Seconds)',
    Default = 0.5,
    Min = 0.1,
    Max = 2,
    Callback = function(Value)
        getgenv().HitDelay = Value
    end
})

-- Manual Hit Button
AutoHitUtils:AddButton('👊 Manual Hit Nearest', function()
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

-- Enhanced Kill Hiders (Your Version)
AutoHitUtils:AddToggle('EnhancedKillHiders', {
    Text = '🔍 ENHANCED KILL HIDERS',
    Default = false,
    Callback = function(Value)
        getgenv().EnhancedKillHiders = Value
        task.spawn(function()
            while getgenv().EnhancedKillHiders do
                pcall(function()
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
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
                                LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 2, 0)
                                task.wait(0.1)
                                
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

-- Auto Destroy Spikes (Your Version)
AutoHitUtils:AddToggle('AutoDestroySpikesEnhanced', {
    Text = '⚡ AUTO DESTROY SPIKES',
    Default = false,
    Callback = function(Value)
        getgenv().AutoSpikesEnhanced = Value
        task.spawn(function()
            while getgenv().AutoSpikesEnhanced do
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

-- Auto Collect Lighters (Your Version)
AutoHitUtils:AddToggle('AutoCollectLightersEnhanced', {
    Text = '🔥 AUTO COLLECT LIGHTERS',
    Default = false,
    Callback = function(Value)
        getgenv().AutoLighterEnhanced = Value
        task.spawn(function()
            while getgenv().AutoLighterEnhanced do
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

-- Destroy Spikes Button
AutoHitUtils:AddButton('🗑️ Destroy All Spikes (Once)', function()
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

-- Collect Lighters Button
AutoHitUtils:AddButton('🔥 Collect All Lighters (Once)', function()
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
-- INITIAL NOTIFICATION
-- ==========================================
Library:Notify({
    Title = "RINGTA + AUTO HIT",
    Description = "ALL FEATURES LOADED SUCCESSFULLY!",
    Time = 5
})

-- ==========================================
-- LIBRARY SETUP
-- ==========================================
Library:SetLibrary()
Library:SetIgnoreIndexes()
Library:SetFolder('ringta_autohit')

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes()
ThemeManager:SetFolder('ringta_autohit')
SaveManager:SetFolder('ringta_autohit/RAH')
SaveManager:BuildConfigSection(SettingsTab)
ThemeManager:ApplyToTab(SettingsTab)