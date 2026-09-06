-- [[ AUTO HIT & UTILITY PANEL - SIMPLE UI ]] --

-- Create simple UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoHitUI"
ScreenGui.Parent = game:GetService("Players").LocalPlayer.PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 350, 0, 500)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BackgroundTransparency = 0.15
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "⚡ AutoHit & Utility Panel ⚡"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = MainFrame

-- Variables
local AutoHitEnabled = false
local AutoKillHiderEnabled = false
local AutoFreeLighterEnabled = false
local AutoSpikesDestroyEnabled = false
local HitRange = 15
local HitDelay = 0.5

-- Function to create toggle
local function CreateToggle(parent, yPos, name, callback)
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(0.9, 0, 0, 30)
    ToggleBtn.Position = UDim2.new(0.05, 0, 0, yPos)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    ToggleBtn.Text = "❌ " .. name
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.Font = Enum.Font.Gotham
    ToggleBtn.TextSize = 14
    ToggleBtn.Parent = parent
    
    local enabled = false
    
    ToggleBtn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            ToggleBtn.Text = "✅ " .. name
        else
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            ToggleBtn.Text = "❌ " .. name
        end
        callback(enabled)
    end)
    
    return ToggleBtn
end

-- Auto Hit Toggle
CreateToggle(MainFrame, 50, "Auto Hit", function(Value)
    AutoHitEnabled = Value
    if AutoHitEnabled then
        print("Auto Hit Enabled")
        task.spawn(function()
            while AutoHitEnabled do
                pcall(function()
                    local LocalPlayer = game:GetService("Players").LocalPlayer
                    local Char = LocalPlayer.Character
                    if Char and Char:FindFirstChild("HumanoidRootPart") then
                        for _, Player in ipairs(game:GetService("Players"):GetPlayers()) do
                            if Player ~= LocalPlayer and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                                local Dist = (Char.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude
                                if Dist <= HitRange then
                                    local Remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                                    if Remotes then
                                        local HitRemote = Remotes:FindFirstChild("Fists") or Remotes:FindFirstChild("Fork") or Remotes:FindFirstChild("Hit")
                                        if HitRemote then
                                            HitRemote:FireServer(Player.Character)
                                            print("Hit:", Player.Name)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(HitDelay)
            end
        end)
    end
end)

-- Auto Kill Hider Toggle
CreateToggle(MainFrame, 90, "Auto Kill Hider", function(Value)
    AutoKillHiderEnabled = Value
    if AutoKillHiderEnabled then
        print("Auto Kill Hider Enabled")
        task.spawn(function()
            while AutoKillHiderEnabled do
                pcall(function()
                    local LocalPlayer = game:GetService("Players").LocalPlayer
                    if not LocalPlayer.Character then return end
                    
                    for _, Player in ipairs(game:GetService("Players"):GetPlayers()) do
                        if Player ~= LocalPlayer and Player.Character and Player.Name:lower():find("hider") then
                            if Player.Character:FindFirstChild("HumanoidRootPart") then
                                LocalPlayer.Character.HumanoidRootPart.CFrame = Player.Character.HumanoidRootPart.CFrame
                                task.wait(0.1)
                                
                                local Remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
                                if Remotes then
                                    local HitRemote = Remotes:FindFirstChild("Fists") or Remotes:FindFirstChild("Hit")
                                    if HitRemote then
                                        HitRemote:FireServer(Player.Character)
                                        print("Killed Hider:", Player.Name)
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
end)

-- Auto Free Lighter Toggle
CreateToggle(MainFrame, 130, "Auto Free Lighter", function(Value)
    AutoFreeLighterEnabled = Value
    if AutoFreeLighterEnabled then
        print("Auto Free Lighter Enabled")
        task.spawn(function()
            while AutoFreeLighterEnabled do
                pcall(function()
                    local LocalPlayer = game:GetService("Players").LocalPlayer
                    for _, Object in ipairs(game:GetService("Workspace"):GetDescendants()) do
                        if Object.Name and Object.Name:lower():find("lighter") then
                            if Object:IsA("BasePart") or Object:IsA("MeshPart") then
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
end)

-- Auto Destroy Spikes Toggle
CreateToggle(MainFrame, 170, "Auto Destroy Spikes", function(Value)
    AutoSpikesDestroyEnabled = Value
    if AutoSpikesDestroyEnabled then
        print("Auto Destroy Spikes Enabled")
        task.spawn(function()
            while AutoSpikesDestroyEnabled do
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
                    if Count > 0 then
                        print("Destroyed", Count, "spikes")
                    end
                end)
                task.wait(2)
            end
        end)
    end
end)

print("✅ Simple UI Loaded! Use the buttons to toggle features.")
