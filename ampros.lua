-- [[ RAYFIELD UI WITH AUTO HIT & UTILITY FEATURES ]] --
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
    Name = "AutoHit & Utility Panel",
    LoadingTitle = "Loading Systems...",
    LoadingSubtitle = "Advanced Automation",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    ConfigurationSaving = { Enabled = false }
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
local MainTab = Window:CreateTab("Auto Combat", 4483362458)

-- ==========================================
-- SECTION 1: AUTO HIT
-- ==========================================
local AutoHitSection = MainTab:CreateSection("Auto Hit System")

-- Function to find remote for hitting
local function GetHitRemote()
    local Remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
    if Remotes then
        -- Try different possible remote names
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
    CurrentValue = false,
    Flag = "AutoHit_Toggle",
    Callback = function(Value)
        AutoHitEnabled = Value
        if AutoHitEnabled then
            Rayfield:Notify({Title = "Auto Hit", Content = "Scanning for players...", Duration = 2})
            task.spawn(function()
                while AutoHitEnabled do
                    pcall(function()
                        local Target = GetNearestPlayer()
                        local HitRemote = GetHitRemote()
                        
                        if Target and HitRemote then
                            -- Face the target
                            local LocalChar = game:GetService("Players").LocalPlayer.Character
                            if LocalChar and LocalChar:FindFirstChild("HumanoidRootPart") then
                                local LookAt = CFrame.new(LocalChar.HumanoidRootPart.Position, Target.Character.HumanoidRootPart.Position)
                                LocalChar.HumanoidRootPart.CFrame = LookAt
                            end
                            
                            -- Fire the hit remote
                            HitRemote:FireServer(Target.Character)
                            
                            Rayfield:Notify({
                                Title = "Auto Hit",
                                Content = "Hit " .. Target.Name,
                                Duration = 1
                            })
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
    Name = "Hit Range (Studs)",
    Min = 5,
    Max = 30,
    Default = 15,
    Color = Color3.fromRGB(255, 0, 0),
    Increment = 1,
    ValueName = "studs",
    Flag = "Range_Slider",
    Callback = function(Value) 
        HitRange = Value 
    end,
})

-- Hit Delay Slider
local HitDelaySlider = MainTab:CreateSlider({
    Name = "Hit Delay (Seconds)",
    Min = 0.1,
    Max = 2,
    Default = 0.5,
    Color = Color3.fromRGB(255, 255, 0),
    Increment = 0.1,
    ValueName = "sec",
    Flag = "HitDelay_Slider",
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
    CurrentValue = false,
    Flag = "AutoKillHider_Toggle",
    Callback = function(Value)
        AutoKillHiderEnabled = Value
        if AutoKillHiderEnabled then
            Rayfield:Notify({Title = "Auto Kill Hider", Content = "Searching for Hiders...", Duration = 2})
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
                                -- Check if player is a hider (check for specific attributes or name)
                                local IsHider = false
                                
                                -- Check for Hider in name or tags
                                if Player.Name:lower():find("hider") or 
                                   Player.DisplayName:lower():find("hider") then
                                    IsHider = true
                                end
                                
                                -- Check for Hider attribute
                                if Player.Character:FindFirstChild("Hider") or
                                   Player.Character:FindFirstChild("HiderTag") then
                                    IsHider = true
                                end
                                
                                -- Check for specific Hider folder or parts
                                for _, Child in ipairs(Player.Character:GetChildren()) do
                                    if Child.Name:lower():find("hider") then
                                        IsHider = true
                                        break
                                    end
                                end
                                
                                if IsHider and Player.Character:FindFirstChild("HumanoidRootPart") then
                                    -- Teleport to hider and kill
                                    local LocalRoot = LocalPlayer.Character.HumanoidRootPart
                                    local HiderRoot = Player.Character.HumanoidRootPart
                                    
                                    LocalRoot.CFrame = CFrame.new(HiderRoot.Position + Vector3.new(0, 2, 0))
                                    task.wait(TeleportDelay)
                                    
                                    -- Try to hit the hider
                                    local HitRemote = GetHitRemote()
                                    if HitRemote then
                                        HitRemote:FireServer(Player.Character)
                                        
                                        Rayfield:Notify({
                                            Title = "Hider Killed",
                                            Content = "Killed " .. Player.Name,
                                            Duration = 1.5
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
    end,
})

-- ==========================================
-- SECTION 3: FREE LIGHTER
-- ==========================================
local LighterSection = MainTab:CreateSection("Lighter Utility")

local AutoFreeLighterToggle = MainTab:CreateToggle({
    Name = "Auto Collect Free Lighter",
    CurrentValue = false,
    Flag = "AutoFreeLighter_Toggle",
    Callback = function(Value)
        AutoFreeLighterEnabled = Value
        if AutoFreeLighterEnabled then
            Rayfield:Notify({Title = "Free Lighter", Content = "Searching for Lighters...", Duration = 2})
            task.spawn(function()
                while AutoFreeLighterEnabled do
                    pcall(function()
                        local LocalPlayer = game:GetService("Players").LocalPlayer
                        local Character = LocalPlayer.Character
                        if not Character then 
                            task.wait(0.5)
                            return 
                        end
                        
                        -- Search workspace for lighters
                        for _, Object in ipairs(game:GetService("Workspace"):GetDescendants()) do
                            if Object.Name and Object.Name:lower():find("lighter") then
                                -- Check if it's a valid object
                                if Object:IsA("BasePart") or Object:IsA("MeshPart") or Object:IsA("Tool") then
                                    -- Clone or move to character
                                    local Clone = Object:Clone()
                                    Clone.Parent = Character
                                    Clone.Anchored = false
                                    
                                    -- If it's a tool, equip it
                                    if Clone:IsA("Tool") then
                                        LocalPlayer.Backpack:ClearAllChildren()
                                        Clone.Parent = LocalPlayer.Backpack
                                    end
                                    
                                    -- Destroy original
                                    Object:Destroy()
                                    
                                    Rayfield:Notify({
                                        Title = "Lighter Found",
                                        Content = "Collected lighter!",
                                        Duration = 1
                                    })
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
    CurrentValue = false,
    Flag = "AutoSpikesDestroy_Toggle",
    Callback = function(Value)
        AutoSpikesDestroyEnabled = Value
        if AutoSpikesDestroyEnabled then
            Rayfield:Notify({Title = "Spike Destroyer", Content = "Removing all spikes...", Duration = 2})
            task.spawn(function()
                while AutoSpikesDestroyEnabled do
                    pcall(function()
                        local SpikeCount = 0
                        
                        -- Search and destroy spikes
                        for _, Object in ipairs(game:GetService("Workspace"):GetDescendants()) do
                            if Object.Name and Object.Name:lower():find("spike") then
                                if Object:IsA("BasePart") or Object:IsA("MeshPart") then
                                    Object:Destroy()
                                    SpikeCount = SpikeCount + 1
                                end
                            end
                        end
                        
                        if SpikeCount > 0 then
                            Rayfield:Notify({
                                Title = "Spikes Removed",
                                Content = "Destroyed " .. SpikeCount .. " spikes",
                                Duration = 1
                            })
                        end
                    end)
                    task.wait(2) -- Scan every 2 seconds
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
                Rayfield:Notify({
                    Title = "Manual Hit",
                    Content = "Hit " .. Target.Name,
                    Duration = 2
                })
            else
                Rayfield:Notify({
                    Title = "Error",
                    Content = "No target found or no remote available!",
                    Duration = 2
                })
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
            Rayfield:Notify({
                Title = "Spikes Destroyed",
                Content = "Removed " .. Count .. " spikes!",
                Duration = 2
            })
        end)
    end,
})

-- ==========================================
-- STATUS DISPLAY
-- ==========================================
local StatusSection = MainTab:CreateSection("Status")

-- Status Notify
Rayfield:Notify({
    Title = "Panel Loaded!",
    Content = "All systems ready",
    Duration = 3
})

-- Debug function to check remotes
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
        -- Check in other places
        print("Checking Workspace...")
        for _, Child in ipairs(game:GetService("Workspace"):GetChildren()) do
            if Child.Name:lower():find("remote") then
                print("Found in Workspace:", Child.Name)
            end
        end
    end
end

-- Uncomment this line to see debug info in console
-- DebugRemotes()
