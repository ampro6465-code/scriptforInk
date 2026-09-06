-- [[ FINAL FIXED RAYFIELD UI - ALL FEATURES INTEGRATED ]] --

local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

local Window = Rayfield:CreateWindow({
   Name = "Game Automation Panel V2",
   LoadingTitle = "Loading Systems...",
   LoadingSubtitle = "by AI",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   ConfigurationSaving = { Enabled = false }
})

-- Variables
local AutoQTEEnabled = false
local FriendQTEEnabled = false
local AutoDalgonaEnabled = false
local ClickDelay = 0.1
local DalgonaDelay = 0.5
local TargetPosition = Vector3.new(-43.84, 1025.06, 136.77)

-- Function for Method 1 QTE (Nil Instances)
local function FindQTREmote()
    for _, Object in getnilinstances() do
        if Object.Name == "RemoteForQTE" and Object:IsA("RemoteEvent") then return Object end
    end
    return nil
end

local MainTab = Window:CreateTab("Main Cheats", 4483362458)

-- ==========================================
-- SECTION 1: QTE AUTOMATION (BOTH METHODS)
-- ==========================================
local QTESection = MainTab:CreateSection("QTE Systems")

-- Method 1 (Your Cobalt Remote)
local QTEToggle = MainTab:CreateToggle({
   Name = "Enable QTE (Method 1 - Hidden)",
   CurrentValue = false,
   Flag = "QTE_Toggle_1", 
   Callback = function(Value)
      AutoQTEEnabled = Value
      if AutoQTEEnabled then
          task.spawn(function()
              while AutoQTEEnabled do
                  local Event = FindQTREmote()
                  if Event then Event:FireServer() end
                  task.wait(ClickDelay)
              end
          end)
      end
   end,
})

-- Method 2 (Dost Waala Fixed Code)
local FriendQTEToggle = MainTab:CreateToggle({
   Name = "Enable QTE (Method 2 - Replicated)",
   CurrentValue = false,
   Flag = "QTE_Toggle_2", 
   Callback = function(Value)
      FriendQTEEnabled = Value
      if FriendQTEEnabled then
          Rayfield:Notify({Title = "Status", Content = "Friend's QTE Method Active!", Duration = 2})
          task.spawn(function()
              while FriendQTEEnabled do
                  pcall(function()
                      -- ReplicatedStorage ke andar Remotes folder se target kiya
                      local RemotesFolder = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 5)
                      if RemotesFolder then
                          local BindableEvent = RemotesFolder:WaitForChild("TemporaryReachedBindable", 5)
                          if BindableEvent then
                              -- Aapke dost ka data packet wrapper fixed structure ke sath
                              BindableEvent:FireServer({ QTEGood = true })
                          end
                      end
                  end)
                  task.wait(ClickDelay)
              end
          end)
      end
   end,
})

-- Common Speed Slider for both QTEs
local SpeedSlider = MainTab:CreateSlider({
   Name = "QTE Speed/Delay (Seconds)",
   Min = 0.01,
   Max = 1,
   Default = 0.1,
   Color = Color3.fromRGB(255, 255, 255),
   Increment = 0.01,
   ValueName = "sec",
   Flag = "Delay_Slider", 
   Callback = function(Value) ClickDelay = Value end,
})

-- ==========================================
-- SECTION 2: DALGONA AUTOMATION
-- ==========================================
local DalgonaSection = MainTab:CreateSection("Dalgona Minigame")

local DalgonaToggle = MainTab:CreateToggle({
   Name = "Auto Complete Dalgona",
   CurrentValue = false,
   Flag = "Dalgona_Toggle",
   Callback = function(Value)
      AutoDalgonaEnabled = Value
      if AutoDalgonaEnabled then
          task.spawn(function()
              while AutoDalgonaEnabled do
                  local DalgonaEvent = game:GetService("ReplicatedStorage"):WaitForChild("Remotes", 5):WaitForChild("DALGONATEMPREMPTE", 5)
                  if DalgonaEvent then
                      DalgonaEvent:FireServer({ Completed = true })
                  end
                  task.wait(DalgonaDelay)
              end
          end)
      end
   end,
})

-- ==========================================
-- SECTION 3: RLGL TELEPORT
-- ==========================================
local RLGLSection = MainTab:CreateSection("Red Light, Green Light")

local RLGLButton = MainTab:CreateButton({
   Name = "Teleport to RLGL Finish Line",
   Callback = function()
      local Player = game:GetService("Players").LocalPlayer
      if Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
          Player.Character.HumanoidRootPart.CFrame = CFrame.new(TargetPosition)
          Rayfield:Notify({Title = "RLGL Status", Content = "Teleported!", Duration = 2})
       end
   end,
})

Rayfield:Notify({Title = "Panel Loaded!", Content = "All systems operational", Duration = 3})

