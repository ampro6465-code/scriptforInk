-- [[ AUTO HIT & UTILITY PANEL - RAYFIELD UI ]] --
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
local HiderScanDelay = 0.5

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
        local HitRemote = Remotes:FindFirstChild("Fists") or 
                         Remotes:FindFirstChild("Fork") or
                         Remotes:FindFirstChild("Hit") or
                         Remotes:FindFirstChild("Attack") or
                         Remotes:FindFirstChild("Punch") or
                         Remotes:FindFirstChild("Swing") or
                         Remotes:FindFirstChild("Melee")
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
            Rayfield:Notify({
                Title = "Auto Hit",
                Content = "Scanning for players...",
                Duration = 2
            })
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
        else
            Rayfield:Notify({
                Title = "Auto Hit",
                Content = "Disabled",
                Duration = 1
            })
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
            Rayfield:Notify({
                Title = "Auto Kill Hider",
                Content = "Searching for Hiders...",
                Duration = 2
            })
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
                                
                                -- Check for Hider in name
                                if Player.Name:lower():find("hider") or 
                                   Player.DisplayName:lower():find("hider") then
                                    IsHider = true
                                end
                                
                                -- Check for Hider attribute/tag
                                if Player.Character:FindFirstChild("Hider") or
                                   Player.Character:FindFirstChild("HiderTag") or
                                   Player.Character:FindFirstChild("IsHider") then
                                    IsHider = true
                                end
                                
                                -- Check for Hider in character parts
                                for _, Child in ipairs(Player.Character:GetChildren()) do
                                    if Child.Name and Child.Name:lower():find("hider") then
                                        IsHider = true
                                        break
                                    end
                                end
                                
                                if IsHider and Player.Character:FindFirstChild("HumanoidRootPart") then
                                    local LocalRoot = LocalPlayer.Character.HumanoidRootPart
                                    local HiderRoot = Player.Character.HumanoidRootPart
                                    
                                    -- Teleport to hider
                                    LocalRoot.CFrame = CFrame.new(HiderRoot.Position + Vector3.new(0, 2, 0))
                                    task.wait(TeleportDelay)
                                    
                                    -- Hit the hider
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
                    task.wait(HiderScanDelay)
                end
            end)
        else
            Rayfield:Notify({
                Title = "Auto Kill Hider",
                Content = "Disabled",
                Duration = 1
            })
        end
    end,
})

-- Hider Scan Delay Slider
local HiderDelaySlider = MainTab:CreateSlider({
    Name = "Hider Scan Delay (Seconds)",
    Min = 0.1,
    Max = 2,
    Default = 0.5,
    Color = Color3.fromRGB(255, 0, 255),
    Increment = 0.1,
    ValueName = "sec",
    Flag = "HiderDelay_Slider",
    Callback = function(Value) 
        HiderScanDelay = Value 
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
            Rayfield:Notify({
                Title = "Free Lighter",
                Content = "Searching for Lighters...",
                Duration = 2
            })
            task.spawn(function()
                while AutoFreeLighterEnabled do
                    pcall(function()
                        local LocalPlayer = game:GetService("Players").LocalPlayer
                        local Character = LocalPlayer.Character
                        if not Character then 
                            task.wait(0.5)
                            return 
                        end
                        
                        local LighterCount = 0
                        
                        -- Search workspace for lighters
                        for _, Object in ipairs(game:GetService("Workspace"):GetDescendants()) do
                            if Object.Name and Object.Name:lower():find("lighter") then
                                -- Check if it's a valid object
                                if Object:IsA("BasePart") or Object:IsA("MeshPart") or Object:IsA("Tool") then
                                    -- Check if object is not already in character
                                    if Object.Parent ~= Character and Object.Parent ~= LocalPlayer.Backpack then
                                        local Clone = Object:Clone()
                                        Clone.Parent = Character
                                        Clone.Anchored = false
                                        
                                        -- If it's a tool, equip it
                                        if Clone:IsA("Tool") then
                                            -- Clear backpack and equip
                                            for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                                                tool:Destroy()
                                            end
                                            Clone.Parent = LocalPlayer.Backpack
                                        end
                                        
                                        -- Destroy original
                                        Object:Destroy()
                                        LighterCount = LighterCount + 1
                                    end
                                end
                            end
                        end
                        
                        if LighterCount > 0 then
                            Rayfield:Notify({
                                Title = "Lighter Found",
                                Content = "Collected " .. LighterCount .. " lighter(s)!",
                                Duration = 1.5
                            })
                        end
                    end)
                    task.wait(1)
                end
            end)
        else
            Rayfield:Notify({
                Title = "Free Lighter",
                Content = "Disabled",
                Duration = 1
            })
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
            Rayfield:Notify({
                Title = "Spike Destroyer",
                Content = "Removing all spikes...",
                Duration = 2
            })
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
        else
            Rayfield:Notify({
                Title = "Spike Destroyer",
                Content = "Disabled",
                Duration = 1
            })
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

-- Manual Collect Lighters Button
local CollectLightersButton = MainTab:CreateButton({
    Name = "Collect All Lighters (Once)",
    Callback = function()
        pcall(function()
            local LocalPlayer = game:GetService("Players").LocalPlayer
            local Character = LocalPlayer.Character
            if not Character then return end
            
            local Count = 0
            for _, Object in ipairs(game:GetService("Workspace"):GetDescendants()) do
                if Object.Name and Object.Name:lower():find("lighter") then
                    if Object:IsA("BasePart") or Object:IsA("MeshPart") or Object:IsA("Tool") then
                        if Object.Parent ~= Character and Object.Parent ~= LocalPlayer.Backpack then
                            local Clone = Object:Clone()
                            Clone.Parent = Character
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
            Rayfield:Notify({
                Title = "Lighters Collected",
                Content = "Collected " .. Count .. " lighters!",
                Duration = 2
            })
        end)
    end,
})

-- ==========================================
-- SECTION 6: DEBUG & STATUS
-- ==========================================
local DebugSection = MainTab:CreateSection("Debug & Info")

-- Debug Button
local DebugButton = MainTab:CreateButton({
    Name = "Debug: Check Remotes",
    Callback = function()
        print("=== DEBUG: CHECKING REMOTES ===")
        local Remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        if Remotes then
            print("✅ Remotes folder found!")
            for _, Child in ipairs(Remotes:GetChildren()) do
                print("📡 Remote found:", Child.Name, Child.ClassName)
            end
            Rayfield:Notify({
                Title = "Debug",
                Content = "Check console for remote list (F9)",
                Duration = 3
            })
        else
            print("❌ No Remotes folder found in ReplicatedStorage")
            print("🔍 Checking other locations...")
            
            -- Check Workspace
            for _, Child in ipairs(game:GetService("Workspace"):GetChildren()) do
                if Child.Name:lower():find("remote") then
                    print("📡 Found in Workspace:", Child.Name)
                end
            end
            
            -- Check ReplicatedStorage directly
            for _, Child in ipairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                if Child.Name:lower():find("remote") then
                    print("📡 Found in ReplicatedStorage root:", Child.Name)
                end
            end
            
            Rayfield:Notify({
                Title = "Debug",
                Content = "No Remotes folder found. Check console.",
                Duration = 3
            })
        end
    end,
})

-- Status Label
local StatusLabel = MainTab:CreateLabel("✅ Panel Loaded Successfully!")

-- ==========================================
-- FINAL NOTIFICATION
-- ==========================================
Rayfield:Notify({
    Title = "Panel Loaded!",
    Content = "All systems ready",
    Duration = 3
})

print("✅ AutoHit & Utility Panel Loaded Successfully!")
print("📌 Features: Auto Hit | Kill Hider | Free Lighter | Destroy Spikes")
