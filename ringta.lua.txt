local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/addons/SaveManager.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")

local Window = Library:CreateWindow({
    Title = 'RINGTA',
    Footer = 'discord.gg/ringta',
    Icon = 'lightbulb',
    NotifySide = 'Right',
    ShowCustomCursor = true,
    AutoShow = true
})

local MainTab = Window:AddTab('Main')
local RedLightTab = Window:AddTab('RedLight')
local DalgonaTab = Window:AddTab('Dalgona')
local TugOfWarTab = Window:AddTab('Tug Of War')
local HideAndSeekTab = Window:AddTab('Hide And Seek')
local JumpRopeTab = Window:AddTab('Jump Rope/Glass Bridge')
local MingleTab = Window:AddTab('Mingle')
local RandomTab = Window:AddTab('Random Features')
local RebelTab = Window:AddTab('Rebel')
local FinalTab = Window:AddTab('Final')
local UISettingsTab = Window:AddTab('UI Settings')

local MainGB = MainTab:AddLeftGroupbox('Main Features')
local UtilitiesGB = MainTab:AddRightGroupbox('Utilities')
local PlayerFeatures = MainTab:AddLeftGroupbox('Player Features')
local PlayerUtilities = MainTab:AddRightGroupbox('Player Utilities')

DalgonaTab:AddButton('Auto Complete Dalgona', function()
    pcall(function()
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ClickedButton"):FireServer("tryingtoleave")
    end)
end)

DalgonaTab:AddButton('Free Lighter', function()
    pcall(function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v.Name:lower():match("lighter") then
                v.Parent = LocalPlayer.Character
            end
        end
    end)
end)

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

Library:SetLibrary()
Library:SetIgnoreIndexes()
Library:SetFolder('ringta')
Library:Notify({
    Title = "RINGTA",
    Description = "DO NOT USE IN PC ONLY MOBILE FOR INK GAMES SCRIPT",
    Time = 5
})

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes()
ThemeManager:SetFolder('ringta')
SaveManager:SetFolder('ringta/EUT')
SaveManager:BuildConfigSection(UISettingsTab)
ThemeManager:ApplyToTab(UISettingsTab)
