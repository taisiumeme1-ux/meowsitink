-- [[ KAITUN SEA 1: ANTI-GOM QUÁI FIX (AUTO RESET POSITION) ]]
if _G.KaitunAntiCheatFix then return end
_G.KaitunAntiCheatFix = true

local replicated = game:GetService("ReplicatedStorage")
local remote = replicated.Remotes.CommF_
local plr = game.Players.LocalPlayer
local VU = game:GetService("VirtualUser")

-- 1. BIẾN THEO DÕI SÁT THƯƠNG
local lastHealth = 0
local lastDamageTime = tick()
local isResetting = false

-- 2. UI TRACKER
local ScreenGui = Instance.new("ScreenGui", plr.PlayerGui)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 200, 0, 100)
MainFrame.Position = UDim2.new(0, 20, 0, 120)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
MainFrame.BackgroundTransparency = 0.3

local function createLabel(text, pos)
    local label = Instance.new("TextLabel", MainFrame)
    label.Size = UDim2.new(1, 0, 0, 30)
    label.Position = UDim2.new(0, 0, 0, pos)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 14
    label.Text = text
    return label
end
local statusLabel = createLabel("Status: Running", 10)
local timerLabel = createLabel("Damage Timer: 0s", 40)

-- 3. LOGIC GOM QUÁI CÓ KIỂM TRA LỖI (ANTI-BUG)
local CenterPoint = nil

task.spawn(function()
    while task.wait() do
        if _G.ActiveFarm and CenterPoint and not isResetting then
            pcall(function()
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        if (v.HumanoidRootPart.Position - CenterPoint.p).Magnitude <= 350 then
                            -- Chỉ gom khi không trong trạng thái reset
                            v.HumanoidRootPart.CFrame = CenterPoint
                            v.HumanoidRootPart.CanCollide = false
                            sethiddenproperty(plr, "SimulationRadius", math.huge)
                        end
                    end
                end
            end)
        end
    end
end)

-- 4. FAST ATTACK & DAMAGE CHECK
task.spawn(function()
    while task.wait() do
        if _G.ActiveFarm then
            pcall(function()
                local tool = plr.Character:FindFirstChildOfClass("Tool")
                if tool and tool.ToolTip == "Melee" then
                    replicated.Remotes.Validator:FireServer(math.huge)
                    remote:InvokeServer("Attack", { [1] = 0 })
                    VU:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
        end
    end
end)

-- 5. CƠ CHẾ TỰ ĐỘNG BAY RA NGOÀI KHI QUÁI KHÔNG MẤT MÁU (FIX LỖI 3S)
task.spawn(function()
    while task.wait(0.5) do
        if _G.ActiveFarm and CenterPoint then
            local currentEnemy = nil
            for _, v in pairs(workspace.Enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and (v.HumanoidRootPart.Position - plr.Character.HumanoidRootPart.Position).Magnitude < 50 then
                    currentEnemy = v
                    break
                end
            end

            if currentEnemy then
                if currentEnemy.Humanoid.Health < lastHealth then
                    lastHealth = currentEnemy.Humanoid.Health
                    lastDamageTime = tick()
                end
                
                local noDamageDuration = tick() - lastDamageTime
                timerLabel.Text = string.format("No Damage: %.1fs", noDamageDuration)

                if noDamageDuration >= 3 and not isResetting then
                    isResetting = true
                    statusLabel.Text = "Status: Anti-Bug Active!"
                    statusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                    
                    -- Lệnh bay ra chỗ khác để reset quái
                    local originalCF = plr.Character.HumanoidRootPart.CFrame
                    plr.Character.HumanoidRootPart.CFrame = originalCF * CFrame.new(100, 50, 100) -- Bay ra xa 100 units
                    wait(1.5)
                    lastDamageTime = tick()
                    isResetting = false
                    statusLabel.Text = "Status: Running"
                    statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
                end
            else
                lastHealth = 0
            end
        end
    end
end)

-- 6. TP & DATA NHIỆM VỤ
function _tp(cf)
    pcall(function() plr.Character.HumanoidRootPart.CFrame = cf end)
end

local Quests = {
    {Level = 0, NPC = CFrame.new(1060, 16, 1547), QName = "BanditQuest1", QID = 1, Enemy = "Bandit", Center = CFrame.new(1145, 17, 1634)},
    {Level = 10, NPC = CFrame.new(-1598, 37, 153), QName = "MonkeyQuest1", QID = 1, Enemy = "Monkey", Center = CFrame.new(-1623, 37, 150)},
    {Level = 30, NPC = CFrame.new(-1598, 37, 153), QName = "MonkeyQuest1", QID = 2, Enemy = "Gorilla", Center = CFrame.new(-1233, 21, -496)},
    {Level = 60, NPC = CFrame.new(-1140, 4, 3828), QName = "PirateQuest1", QID = 1, Enemy = "Pirate", Center = CFrame.new(-1200, 4, 3915)},
    {Level = 175, NPC = CFrame.new(-4722, 10, 843), QName = "SnowQuest", QID = 1, Enemy = "Snow Bandit", Center = CFrame.new(-4664, 26, 730)},
}

task.spawn(function()
    while task.wait(0.3) do
        if isResetting then continue end
        
        local lv = plr.Data.Level.Value
        if not plr.PlayerGui.Main.Quest.Visible then
            _G.ActiveFarm = false
            CenterPoint = nil
            local target = nil
            for i = #Quests, 1, -1 do if lv >= Quests[i].Level then target = Quests[i] break end end
            if target then
                _tp(target.NPC)
                wait(1)
                remote:InvokeServer("StartQuest", target.QName, target.QID)
            end
        else
            _G.ActiveFarm = true
            local target = nil
            for i = #Quests, 1, -1 do if lv >= Quests[i].Level then target = Quests[i] break end end
            if target then
                CenterPoint = target.Center
                -- Di chuyển rung nhẹ (Circle Move) để tránh Anti-cheat
                local radius = 2
                local angle = tick() * 5
                local offset = Vector3.new(math.cos(angle) * radius, 25, math.sin(angle) * radius)
                _tp(CFrame.new(CenterPoint.p + offset))
            end
        end
    end
end)

-- Auto Redeem Codes & Team
remote:InvokeServer("RedeemFreeCode", "KITT_RESET")
pcall(function() if plr.Team.Name ~= "Pirates" then remote:InvokeServer("SetTeam", "Pirates") end end)

print("Kaitun Sea 1: Anti-Gom Quái Fix (3s Logic) Loaded!")
