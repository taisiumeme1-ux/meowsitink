-- [[ Fynix Kaitun by Meow - ULTIMATE ANTI-BUG EDITION ]]
-- Phiên bản: Sea 1 (Full Optimized)

if _G.FynixKaitunLoaded then return end
_G.FynixKaitunLoaded = true

-- === THIẾT LẬP HỆ THỐNG ===
local plr = game.Players.LocalPlayer
local replicated = game:GetService("ReplicatedStorage")
local remote = replicated.Remotes.CommF_
local vUser = game:GetService("VirtualUser")
local tweenService = game:GetService("TweenService")

-- Chống AFK
plr.Idled:Connect(function()
    vUser:CaptureController()
    vUser:ClickButton2(Vector2.new())
end)

-- === DỮ LIỆU NHIỆM VỤ (FULL SEA 1) ===
local Sea1_Data = {
    {Level = 0, EName = "Bandit", QName = "BanditQuest1", QID = 1, NPC = CFrame.new(1060, 16, 1547)},
    {Level = 15, EName = "Monkey", QName = "MonkeyQuest1", QID = 1, NPC = CFrame.new(-1598, 37, 153)},
    {Level = 30, EName = "Gorilla", QName = "MonkeyQuest1", QID = 2, NPC = CFrame.new(-1598, 37, 153)},
    {Level = 60, EName = "Brute", QName = "PirateVillageQuest", QID = 2, NPC = CFrame.new(-1115, 5, 3855)},
    {Level = 120, EName = "Chief Petty Officer", QName = "MarineQuest2", QID = 1, NPC = CFrame.new(-4842, 23, 4363)},
    {Level = 150, EName = "Sky Bandit", QName = "SkyQuest", QID = 1, NPC = CFrame.new(-4841, 718, -2620)},
    {Level = 190, EName = "Dark Master", QName = "SkyQuest", QID = 2, NPC = CFrame.new(-4841, 718, -2620)},
    {Level = 210, EName = "Snow Soldier", QName = "SnowQuest", QID = 1, NPC = CFrame.new(1385, 25, -1297)},
    {Level = 250, EName = "Yeti", QName = "SnowQuest", QID = 2, NPC = CFrame.new(1385, 25, -1297)},
    {Level = 300, EName = "Magma Soldier", QName = "MagmaQuest", QID = 1, NPC = CFrame.new(-5313, 12, 8515)},
    {Level = 350, EName = "Military Soldier", QName = "MarineQuest2", QID = 1, NPC = CFrame.new(-4842, 23, 4363)},
    {Level = 425, EName = "Fishman Warrior", QName = "FishmanQuest", QID = 1, NPC = CFrame.new(61122, 18, 1565)},
    {Level = 500, EName = "God's Guard", QName = "UpperSkyQuest1", QID = 1, NPC = CFrame.new(-7861, 5545, -381)},
    {Level = 575, EName = "Shanda", QName = "UpperSkyQuest2", QID = 1, NPC = CFrame.new(-7861, 5545, -381)},
    {Level = 625, EName = "Galley Pirate", QName = "FountainQuest", QID = 1, NPC = CFrame.new(5259, 38, 4050)}
}

-- === HÀM BỔ TRỢ (CHUYÊN SÂU) ===
function _tp(cf)
    if not plr.Character:FindFirstChild("HumanoidRootPart") then return end
    pcall(function()
        plr.Character.HumanoidRootPart.CFrame = cf
    end)
end

function EquipTool()
    for _, tool in pairs(plr.Backpack:GetChildren()) do
        if tool:IsA("Tool") and tool.ToolTip == "Melee" then
            plr.Character.Humanoid:EquipTool(tool)
        end
    end
end

function CheckItem(name)
    local inv = remote:InvokeServer("getInventory")
    for _, item in pairs(inv) do
        if item.Name == name then return true end
    end
    return false
end

-- === GIAO DIỆN FYNIX KAITUN (CHI TIẾT) ===
local Gui = Instance.new("ScreenGui", plr.PlayerGui)
Gui.Name = "FynixKaitunByMeow"

local Main = Instance.new("Frame", Gui)
Main.Size = UDim2.new(0, 500, 0, 300)
Main.Position = UDim2.new(0.5, -250, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
local Stroke = Instance.new("UIStroke", Main)
Stroke.Color = Color3.fromRGB(255, 170, 0)
Stroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "Fynix Kaitun by Meow | Sea 1"
Title.TextColor3 = Color3.fromRGB(255, 170, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.BackgroundTransparency = 1

local StatusLabel = Instance.new("TextLabel", Main)
StatusLabel.Size = UDim2.new(1, -40, 0, 40)
StatusLabel.Position = UDim2.new(0, 20, 0, 50)
StatusLabel.Text = "Status: Initializing..."
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Font = Enum.Font.GothamMedium
StatusLabel.BackgroundTransparency = 1
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left

local ItemContainer = Instance.new("ScrollingFrame", Main)
ItemContainer.Size = UDim2.new(1, -40, 0, 150)
ItemContainer.Position = UDim2.new(0, 20, 0, 100)
ItemContainer.BackgroundTransparency = 1
ItemContainer.CanvasSize = UDim2.new(0, 0, 2, 0)
ItemContainer.ScrollBarThickness = 4

local function CreateCheck(name, order)
    local f = Instance.new("Frame", ItemContainer)
    f.Size = UDim2.new(1, 0, 0, 35)
    f.Position = UDim2.new(0, 0, 0, (order-1)*40)
    f.BackgroundTransparency = 1
    
    local dot = Instance.new("Frame", f)
    dot.Size = UDim2.new(0, 12, 0, 12)
    dot.Position = UDim2.new(0, 5, 0.3, 0)
    dot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    
    local txt = Instance.new("TextLabel", f)
    txt.Size = UDim2.new(1, -30, 1, 0)
    txt.Position = UDim2.new(0, 30, 0, 0)
    txt.Text = name
    txt.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt.Font = Enum.Font.Gotham
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.BackgroundTransparency = 1
    return dot
end

local DotSaber = CreateCheck("Saber (Sword)", 1)
local DotStep = CreateCheck("Black Leg (Melee)", 2)
local DotElec = CreateCheck("Electric (Melee)", 3)
local DotFish = CreateCheck("Fishman Kung Fu (Melee)", 4)

-- === VÒNG LẶP CHÍNH (LOGIC FARM & QUEST) ===
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local lv = plr.Data.Level.Value
            
            -- 1. Cập nhật Item Check
            if CheckItem("Saber") then DotSaber.BackgroundColor3 = Color3.fromRGB(50, 255, 50) end
            if CheckItem("Black Leg") then DotStep.BackgroundColor3 = Color3.fromRGB(50, 255, 50) end
            
            -- 2. Chuyển Sea khi Level >= 700
            if lv >= 700 then
                StatusLabel.Text = "Status: Level 700! Going to Sea 2..."
                _tp(CFrame.new(-490, 12, 4085))
                remote:InvokeServer("TravelMain")
                return
            end

            -- 3. Quản lý Stats (Tự cộng Melee)
            if plr.Data.StatsPoints.Value > 0 then
                remote:InvokeServer("AddStats", "Melee", plr.Data.StatsPoints.Value)
            end

            -- 4. Nhận Quest
            if not plr.PlayerGui.Main.Quest.Visible then
                local questToTake = nil
                for i = #Sea1_Data, 1, -1 do
                    if lv >= Sea1_Data[i].Level then
                        questToTake = Sea1_Data[i]
                        break
                    end
                end
                
                if questToTake then
                    StatusLabel.Text = "Status: Moving to NPC " .. questToTake.EName
                    _tp(questToTake.NPC)
                    if (plr.Character.HumanoidRootPart.Position - questToTake.NPC.p).Magnitude < 20 then
                        remote:InvokeServer("StartQuest", questToTake.QName, questToTake.QID)
                    end
                end
            else
                -- Đang thực hiện Quest
                local qName = plr.PlayerGui.Main.Quest.Container.QuestTarget.Text:gsub("Kill ", ""):gsub(" %d+/%d+", "")
                local enemy = workspace.Enemies:FindFirstChild(qName)
                
                if enemy and enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
                    StatusLabel.Text = "Status: Farming " .. qName
                    EquipTool()
                    _tp(enemy.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0))
                    
                    -- Gom quái và đánh
                    enemy.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                    enemy.HumanoidRootPart.CanCollide = false
                    replicated.Remotes.Validator:FireServer(math.huge)
                    remote:InvokeServer("Attack", { [1] = 0 })
                else
                    -- Anti-stuck: Nếu ko có quái thì bay về bãi đợi
                    StatusLabel.Text = "Status: Waiting for enemy..."
                    for i = #Sea1_Data, 1, -1 do
                        if lv >= Sea1_Data[i].Level then
                            _tp(Sea1_Data[i].NPC * CFrame.new(0, 50, 0))
                            break
                        end
                    end
                end
            end
        end)
    end
end)

-- Vòng lặp Fast Attack (Chạy độc lập để cực nhanh)
task.spawn(function()
    while task.wait() do
        if plr.Character:FindFirstChildOfClass("Tool") then
            replicated.Remotes.Validator:FireServer(math.huge)
            remote:InvokeServer("Attack", { [1] = 0 })
            vUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end
    end
end)
