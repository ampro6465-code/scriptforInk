-- [[ AUTO HIT & UTILITY PANEL - COMPACT ]] --
local R=loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local W=R:CreateWindow({Name="AutoHit & Utility",LoadingTitle="Loading...",Theme="Default",ConfigurationSaving={Enabled=false}})

local A,H,D,KD,LD,SD=false,15,0.5,0.1,0.5,0.5
local T=W:CreateTab("Auto Combat",4483362458)

local function GetRemote()
local R=game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
if R then return R:FindFirstChild("Fists")or R:FindFirstChild("Fork")or R:FindFirstChild("Hit")or R:FindFirstChild("Attack")or R:FindFirstChild("Punch")or R:FindFirstChild("Swing")or R:FindFirstChild("Melee")end end

local function GetTarget()
local L=game.Players.LocalPlayer
local C=L.Character
if not C or not C:FindFirstChild("HumanoidRootPart")then return end
local R=C.HumanoidRootPart
local T,nil
local D=H
for _,P in pairs(game.Players:GetPlayers())do
if P~=L and P.Character and P.Character:FindFirstChild("HumanoidRootPart")then
local Dist=(R.Position-P.Character.HumanoidRootPart.Position).Magnitude
if Dist<D then D=Dist;T=P end end end
return T end

T:CreateSection("Auto Hit")
T:CreateToggle({Name="Auto Hit",CurrentValue=false,Flag="AH",Callback=function(V)A=V
if A then task.spawn(function()while A do pcall(function()local T=GetTarget()local R=GetRemote()if T and R then local C=game.Players.LocalPlayer.Character if C and C:FindFirstChild("HumanoidRootPart")then C.HumanoidRootPart.CFrame=CFrame.new(C.HumanoidRootPart.Position,T.Character.HumanoidRootPart.Position)end R:FireServer(T.Character)R:Notify({Title="Hit",Content=T.Name,Duration=1})end end)task.wait(H)end end)else R:Notify({Title="Disabled",Duration=1})end end})

T:CreateSlider({Name="Range",Min=5,Max=30,Default=15,Color=Color3.fromRGB(255,0,0),Increment=1,ValueName="studs",Flag="Rng",Callback=function(V)H=V end})
T:CreateSlider({Name="Delay",Min=0.1,Max=2,Default=0.5,Color=Color3.fromRGB(255,255,0),Increment=0.1,ValueName="sec",Flag="Dly",Callback=function(V)H=V end})

T:CreateSection("Hider Kill")
T:CreateToggle({Name="Auto Kill Hider",CurrentValue=false,Flag="HK",Callback=function(V)KD=V
if KD then task.spawn(function()while KD do pcall(function()local L=game.Players.LocalPlayer if not L.Character or not L.Character:FindFirstChild("HumanoidRootPart")then task.wait(0.5)return end for _,P in pairs(game.Players:GetPlayers())do if P~=L and P.Character then local IH=false if P.Name:lower():find("hider")or P.DisplayName:lower():find("hider")then IH=true end if P.Character:FindFirstChild("Hider")or P.Character:FindFirstChild("HiderTag")or P.Character:FindFirstChild("IsHider")then IH=true end for _,C in ipairs(P.Character:GetChildren())do if C.Name and C.Name:lower():find("hider")then IH=true break end end if IH and P.Character:FindFirstChild("HumanoidRootPart")then local LR=L.Character.HumanoidRootPart local HR=P.Character.HumanoidRootPart LR.CFrame=CFrame.new(HR.Position+Vector3.new(0,2,0))task.wait(0.1)local R=GetRemote()if R then R:FireServer(P.Character)R:Notify({Title="Hider Killed",Content=P.Name,Duration=1.5})end end end end end)task.wait(SD)end end)else R:Notify({Title="Disabled",Duration=1})end end})

T:CreateSlider({Name="Scan Delay",Min=0.1,Max=2,Default=0.5,Color=Color3.fromRGB(255,0,255),Increment=0.1,ValueName="sec",Flag="SD",Callback=function(V)SD=V end})

T:CreateSection("Lighter")
T:CreateToggle({Name="Auto Collect Lighter",CurrentValue=false,Flag="CL",Callback=function(V)LD=V
if LD then task.spawn(function()while LD do pcall(function()local L=game.Players.LocalPlayer local C=L.Character if not C then task.wait(0.5)return end local Cnt=0 for _,O in pairs(game.Workspace:GetDescendants())do if O.Name and O.Name:lower():find("lighter")then if O:IsA("BasePart")or O:IsA("MeshPart")or O:IsA("Tool")then if O.Parent~=C and O.Parent~=L.Backpack then local Cl=O:Clone()Cl.Parent=C;Cl.Anchored=false if Cl:IsA("Tool")then for _,t in pairs(L.Backpack:GetChildren())do t:Destroy()end Cl.Parent=L.Backpack end O:Destroy();Cnt=Cnt+1 end end end end if Cnt>0 then R:Notify({Title="Lighters",Content="+"..Cnt,Duration=1.5})end end)task.wait(1)end end)else R:Notify({Title="Disabled",Duration=1})end end})

T:CreateSection("Spikes")
T:CreateToggle({Name="Auto Destroy Spikes",CurrentValue=false,Flag="DS",Callback=function(V)SD=V
if SD then task.spawn(function()while SD do pcall(function()local Cnt=0 for _,O in pairs(game.Workspace:GetDescendants())do if O.Name and O.Name:lower():find("spike")then if O:IsA("BasePart")or O:IsA("MeshPart")then O:Destroy();Cnt=Cnt+1 end end end if Cnt>0 then R:Notify({Title="Spikes",Content="-"..Cnt,Duration=1})end end)task.wait(2)end end)else R:Notify({Title="Disabled",Duration=1})end end})

T:CreateSection("Manual")
T:CreateButton({Name="Hit Now",Callback=function()pcall(function()local T=GetTarget()local R=GetRemote()if T and R then R:FireServer(T.Character)R:Notify({Title="Hit",Content=T.Name,Duration=2})else R:Notify({Title="Error",Content="No target",Duration=2})end end)end})
T:CreateButton({Name="Destroy Spikes",Callback=function()pcall(function()local Cnt=0 for _,O in pairs(game.Workspace:GetDescendants())do if O.Name and O.Name:lower():find("spike")then if O:IsA("BasePart")or O:IsA("MeshPart")then O:Destroy();Cnt=Cnt+1 end end end R:Notify({Title="Spikes",Content="-"..Cnt,Duration=2})end)end})
T:CreateButton({Name="Collect Lighters",Callback=function()pcall(function()local L=game.Players.LocalPlayer local C=L.Character if not C then return end local Cnt=0 for _,O in pairs(game.Workspace:GetDescendants())do if O.Name and O.Name:lower():find("lighter")then if O:IsA("BasePart")or O:IsA("MeshPart")or O:IsA("Tool")then if O.Parent~=C and O.Parent~=L.Backpack then local Cl=O:Clone()Cl.Parent=C;Cl.Anchored=false if Cl:IsA("Tool")then for _,t in pairs(L.Backpack:GetChildren())do t:Destroy()end Cl.Parent=L.Backpack end O:Destroy();Cnt=Cnt+1 end end end end R:Notify({Title="Lighters",Content="+"..Cnt,Duration=2})end)end})

T:CreateSection("Debug")
T:CreateButton({Name="Check Remotes",Callback=function()local R=game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")if R then local C=0 for _,C in pairs(R:GetChildren())do C=C+1 end R:Notify({Title="Remotes Found",Content=tostring(C),Duration=3})else R:Notify({Title="No Remotes",Content="Check F9",Duration=3})end end})
