-- Initialize Player & Character
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- UI Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = player.PlayerGui
ScreenGui.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0.2, 0, 0.4, 0)
MainFrame.Position = UDim2.new(0.01, 0, 0.01, 0)
MainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.new(0.3, 0.3, 0.3)
MainFrame.Parent = ScreenGui

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Text = "Blox Fruits Farm & Spawn"
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.TextScaled = true
TitleLabel.Size = UDim2.new(1, 0, 0.15, 0)
TitleLabel.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
TitleLabel.Parent = MainFrame

local SpawnButton = Instance.new("TextButton")
SpawnButton.Text = "Spawn Fruit"
SpawnButton.TextColor3 = Color3.new(1, 1, 1)
SpawnButton.TextScaled = true
SpawnButton.Size = UDim2.new(1, 0, 0.2, 0)
SpawnButton.Position = UDim2.new(0, 0, 0.2, 0)
SpawnButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
SpawnButton.Parent = MainFrame

local AutoFarmToggle = Instance.new("TextButton")
AutoFarmToggle.Text = "Auto Farm: OFF"
AutoFarmToggle.TextColor3 = Color3.new(1, 1, 1)
AutoFarmToggle.TextScaled = true
AutoFarmToggle.Size = UDim2.new(1, 0, 0.2, 0)
AutoFarmToggle.Position = UDim2.new(0, 0, 0.45, 0)
AutoFarmToggle.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
AutoFarmToggle.Parent = MainFrame

-- Fruit Definitions
local fruits = {
    { name = "Spin", rarity = "Common" },
    { name = "Spring", rarity = "Common" },
    { name = "Bomb", rarity = "Common" },
    { name = "Smoke", rarity = "Common" },
    { name = "Flame", rarity = "Common" },
    { name = "Ice", rarity = "Uncommon" },
    { name = "Sand", rarity = "Uncommon" },
    { name = "Dark", rarity = "Uncommon" },
    { name = "Light", rarity = "Uncommon" },
    { name = "Magma", rarity = "Rare" },
    { name = "Rubber", rarity = "Rare" },
    { name = "String", rarity = "Rare" },
    { name = "Quake", rarity = "Rare" },
    { name = "Gravity", rarity = "Rare" },
    { name = "Buddha", rarity = "Legendary" },
    { name = "Phoenix", rarity = "Legendary" },
    { name = "Control", rarity = "Legendary" },
    { name = "Shadow", rarity = "Legendary" },
    { name = "Venom", rarity = "Mythic" },
    { name = "Spirit", rarity = "Mythic" },
    { name = "Dough", rarity = "Mythic" },
    { name = "Dragon", rarity = "Mythic" }
}

-- Fruit Spawning Function
local function spawnFruit()
    local fruitIndex = math.random(1, #fruits)
    local fruitName = fruits[fruitIndex].name

    -- Send a RemoteEvent to the server to spawn the fruit.
    local spawnEvent = game:GetService("ReplicatedStorage"):FindFirstChild("SpawnFruitEvent")
    if spawnEvent then
        spawnEvent:FireServer(fruitName, rootPart.Position)
        print("Spawning fruit: " .. fruitName)
    else
        warn("SpawnFruitEvent not found! The script will not spawn fruits.")
    end
end

-- Auto-Farm Logic
local autoFarmEnabled = false

local function autoFarm()
    while autoFarmEnabled do
        -- Spawn a fruit
        spawnFruit()

        -- Wait a short time before spawning another fruit
        task.wait(5)

        -- Attempt to collect any nearby fruits
        local collectEvent = game:GetService("ReplicatedStorage"):FindFirstChild("CollectFruitEvent")
        if collectEvent then
            collectEvent:FireServer()
            print("Collecting nearby fruits.")
        else
            warn("CollectFruitEvent not found! The script will not collect fruits.")
        end
    end
end

-- Button Actions
SpawnButton.MouseButton1Click:Connect(function()
    spawnFruit()
end)

AutoFarmToggle.MouseButton1Click:Connect(function()
    autoFarmEnabled = not autoFarmEnabled
    if autoFarmEnabled then
        AutoFarmToggle.Text = "Auto Farm: ON"
        task.spawn(autoFarm)
    else
        AutoFarmToggle.Text = "Auto Farm: OFF"
    end
end)
