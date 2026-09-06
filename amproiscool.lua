-- [[ AUTO HIT & UTILITY PANEL - OBSIDIAN UI ]] --
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/Obsidian/main/source.lua"))()

local Window = Library:CreateWindow({
    Title = "AutoHit & Utility Panel",
    Center = true,
    AutoShow = true,
    TabWidth = 120,
})

-- Variables
local AutoHitEnabled = false
local AutoKillHiderEnabled = false
local AutoFreeLighterEnabled = false
local AutoSpikesDestroyEnabled = false
local HitRange = 15
local HitDelay = 0.5
local TeleportDelay = 0.1

-- Main Tab
local MainTab = Window:CreateTab("Auto Combat")

-- ==========================================
-- SECTION 1: AUTO HIT
-- ==========================================
local AutoHitSection = MainTab:CreateSection("Auto Hit System")

-- Function to find remote for hitting
local function GetHitRemote()
    local Remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    if Remotes then
        local HitRemote = Remotes:FindFirstChild("Fists") or 
                         Remotes:FindFirstChild("Fork") or
                         Remotes:FindFirstChild("Hit") or
                         Remotes:FindFirstChild("Attack") or
                         Remotes:FindFirstChild("Punch") or
                         Remotes:FindFirstChild("Swing")
        return HitRemote
    end
    return nil
end

-- Function to get nearest player
local function GetNearestPlayer()
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local Character = LocalPlayer.Character
    if not Character or not Character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local RootPart = Character.HumanoidRootPart
    local NearestPlayer = nil
    local NearestDistance = HitRange
    
    for _, Player in ipairs(game:GetService("Players"):GetPlayers()) do
        if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            local Distance = (RootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
            if Distance < NearestDistance then
                NearestDistance = Distance
                NearestPlayer = Player
            end
        end
    end
    
    return NearestPlayer
end

local AutoHitToggle = MainTab:CreateToggle({
    Name = "Auto Hit (Scan & Attack Nearest Player)",
    Default = false,
    Callback = function(Value)
        AutoHitEnabled = Value
        if AutoHitEnabled then
            print("Auto Hit Enabled")
            task.spawn(function()
                while AutoHitEnabled do
                    pcall(function()
                        local Target = GetNearestPlayer()
                        local HitRemote = GetHitRemote()
                        
                        if Target and HitRemote then
                            local LocalChar = game:GetService("Players").LocalPlayer.Character
                            if LocalChar and LocalChar:FindFirstChild("HumanoidRootPart") then
                                local LookAt = CFrame.new(LocalChar.HumanoidRootPart.Position, Target.Character.HumanoidRootPart.Position)
                                LocalChar.HumanoidRootPart.CFrame = LookAt
                            end
                            
                            HitRemote:FireServer(Target.Character)
                            print("Hit: " .. Target.Name)
                        end
                    end)
                    task.wait(HitDelay)
                end
            end)
        end
    end,
})

-- Hit Range Slider
local RangeSlider = MainTab:CreateSlider({
    Name = "Hit Range",
    Min = 5,
    Max = 30,
    Default = 15,
    Suffix = " studs",
    Callback = function(Value) 
        HitRange = Value 
    end,
})

-- Hit Delay Slider
local HitDelaySlider = MainTab:CreateSlider({
    Name = "Hit Delay",
    Min = 0.1,
    Max = 2,
    Default = 0.5,
    Suffix = " seconds",
    Callback = function(Value) 
        HitDelay = Value 
    end,
})

-- ==========================================
-- SECTION 2: AUTO KILL HIDER
-- ==========================================
local HiderSection = MainTab:CreateSection("Auto Kill Hider")

local AutoKillHiderToggle = MainTab:CreateToggle({
    Name = "Auto Kill Hider Players",
    Default = false,
    Callback = function(Value)
        AutoKillHiderEnabled = Value
        if AutoKillHiderEnabled then
            print("Auto Kill Hider Enabled")
            task.spawn(function()
                while AutoKillHiderEnabled do
                    pcall(function()
                        local LocalPlayer = game:GetService("Players").LocalPlayer
                        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
                            task.wait(0.5)
                            return 
                        end
                        
                        for _, Player in ipairs(game:GetService("Players"):GetPlayers()) do
                            if Player ~= LocalPlayer and Player.Character then
                                local IsHider = false
                                
                                if Player.Name:lower():find("hider") or 
                                   Player.DisplayName:lower():find("hider") then
                                    IsHider = true
                                end
                                
                                if Player.Character:FindFirstChild("Hider") or
                                   Player.Character:FindFirstChild("HiderTag") then
                                    IsHider = true
                                end
                                
                                for _, Child in ipairs(Player.Character:GetChildren()) do
                                    if Child.Name:lower():find("hider") then
                                        IsHider = true
                                        break
                                    end
                                end
                                
                                if IsHider and Player.Character:FindFirstChild("HumanoidRootPart") then
                                    local LocalRoot = LocalPlayer.Character.HumanoidRootPart
                                    local HiderRoot = Player.Character.HumanoidRootPart
                                    
                                    LocalRoot.CFrame = CFrame.new(HiderRoot.Position + Vector3.new(0, 2, 0))
                                    task.wait(TeleportDelay)
                                    
                                    local HitRemote = GetHitRemote()
                                    if HitRemote then
                                        HitRemote:FireServer(Player.Character)
                                        print("Killed Hider: " .. Player.Name)
                                    end
                                end
                            end
                        end
                    end)
                    task.wait(0.5)
                end
            end)
        end
    end,
})

-- ==========================================
-- SECTION 3: FREE LIGHTER
-- ==========================================
local LighterSection = MainTab:CreateSection("Lighter Utility")

local AutoFreeLighterToggle = MainTab:CreateToggle({
    Name = "Auto Collect Free Lighter",
    Default = false,
    Callback = function(Value)
        AutoFreeLighterEnabled = Value
        if AutoFreeLighterEnabled then
            print("Auto Free Lighter Enabled")
            task.spawn(function()
                while AutoFreeLighterEnabled do
                    pcall(function()
                        local LocalPlayer = game:GetService("Players").LocalPlayer
                        local Character = LocalPlayer.Character
                        if not Character then 
                            task.wait(0.5)
                            return 
                        end
                        
                        for _, Object in ipairs(game:GetService("Workspace"):GetDescendants()) do
                            if Object.Name and Object.Name:lower():find("lighter") then
                                if Object:IsA("BasePart") or Object:IsA("MeshPart") or Object:IsA("Tool") then
                                    local Clone = Object:Clone()
                                    Clone.Parent = Character
                                    Clone.Anchored = false
                                    
                                    if Clone:IsA("Tool") then
                                        LocalPlayer.Backpack:ClearAllChildren()
                                        Clone.Parent = LocalPlayer.Backpack
                                    end
                                    
                                    Object:Destroy()
                                    print("Collected Lighter!")
                                end
                            end
                        end
                    end)
                    task.wait(1)
                end
            end)
        end
    end,
})

-- ==========================================
-- SECTION 4: DESTROY SPIKES
-- ==========================================
local SpikeSection = MainTab:CreateSection("Spike Destroyer")

local AutoSpikesDestroyToggle = MainTab:CreateToggle({
    Name = "Auto Destroy Spikes",
    Default = false,
    Callback = function(Value)
        AutoSpikesDestroyEnabled = Value
        if AutoSpikesDestroyEnabled then
            print("Auto Destroy Spikes Enabled")
            task.spawn(function()
                while AutoSpikesDestroyEnabled do
                    pcall(function()
                        local SpikeCount = 0
                        
                        for _, Object in ipairs(game:GetService("Workspace"):GetDescendants()) do
                            if Object.Name and Object.Name:lower():find("spike") then
                                if Object:IsA("BasePart") or Object:IsA("MeshPart") then
                                    Object:Destroy()
                                    SpikeCount = SpikeCount + 1
                                end
                            end
                        end
                        
                        if SpikeCount > 0 then
                            print("Destroyed " .. SpikeCount .. " spikes")
                        end
                    end)
                    task.wait(2)
                end
            end)
        end
    end,
})

-- ==========================================
-- SECTION 5: MANUAL UTILITIES
-- ==========================================
local UtilitySection = MainTab:CreateSection("Manual Utilities")

-- Manual Hit Button
local ManualHitButton = MainTab:CreateButton({
    Name = "Hit Nearest Player (Manual)",
    Callback = function()
        pcall(function()
            local Target = GetNearestPlayer()
            local HitRemote = GetHitRemote()
            
            if Target and HitRemote then
                HitRemote:FireServer(Target.Character)
                print("Manually hit: " .. Target.Name)
            else
                print("No target found or no remote available!")
            end
        end)
    end,
})

-- Manual Destroy Spikes Button
local DestroySpikesButton = MainTab:CreateButton({
    Name = "Destroy All Spikes (Once)",
    Callback = function()
        pcall(function()
            local Count = 0
            for _, Object in ipairs(game:GetService("Workspace"):GetDescendants()) do
                if Object.Name and Object.Name:lower():find("spike") then
                    if Object:IsA("BasePart") or Object:IsA("MeshPart") then
                        Object:Destroy()
                        Count = Count + 1
                    end
                end
            end
            print("Removed " .. Count .. " spikes!")
        end)
    end,
})

-- ==========================================
-- SECTION 6: STATUS / INFO
-- ==========================================
local StatusSection = MainTab:CreateSection("Status")

local StatusLabel = MainTab:CreateLabel("Panel Loaded Successfully!")

-- Debug function
local function DebugRemotes()
    print("=== DEBUG: CHECKING REMOTES ===")
    local Remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    if Remotes then
        print("Remotes folder found!")
        for _, Child in ipairs(Remotes:GetChildren()) do
            print("Remote found:", Child.Name, Child.ClassName)
        end
    else
        print("No Remotes folder found in ReplicatedStorage")
        print("Checking Workspace...")
        for _, Child in ipairs(game:GetService("Workspace"):GetChildren()) do
            if Child.Name:lower():find("remote") then
                print("Found in Workspace:", Child.Name)
            end
        end
    end
end

-- Uncomment to debug
-- DebugRemotes()
