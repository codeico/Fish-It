--[[
    🔥 BANGCODE Fish It Pro - Enhanced Edition 🔥
    
    Premium Fish It script with enhanced features:
    • Professional UI/UX Design
    • Enhanced Branding & Notifications
    • Improved User Experience
    • All Original Features + More
    
    Developers: BANGCODE
    Instagram: @_bangicoo
    GitHub: github.com/codeico
    
    💎 Premium Quality • Trusted by Thousands
--]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- BANGCODE Anti Ghost Touch System
local ButtonCooldowns = {}
local BUTTON_COOLDOWN = 0.5

local function CreateSafeCallback(originalCallback, buttonId)
    return function(...)
        local currentTime = tick()
        if ButtonCooldowns[buttonId] and currentTime - ButtonCooldowns[buttonId] < BUTTON_COOLDOWN then
            return
        end
        ButtonCooldowns[buttonId] = currentTime
        
        local success, result = pcall(originalCallback, ...)
        if not success then
            warn("BANGCODE Error:", result)
        end
    end
end

--- BANGCODE add new feature and variable
local Players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
if not player or not replicatedStorage then return end

-- Load Rayfield with optimized sidebar-style configuration
local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua"))()

-- Create Window positioned like a LEFT SIDEBAR
local Window = Rayfield:CreateWindow({
    Name = "🔥 BANGCODE Fish It Pro",
    LoadingTitle = "BANGCODE Fish It Pro",
    LoadingSubtitle = "by @BANGCODE - Premium Quality",
    Theme = "DarkBlue",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BANGCODE",
        FileName = "FishItPro"
    },
    KeySystem = false,
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    TabWidth = 160,
    Size = UDim2.fromOffset(420, 650), -- Narrower width like sidebar
    Position = UDim2.fromScale(0.01, 0.05) -- Far left positioning
})

-- Compact sidebar-style tabs
local InfoTab = Window:CreateTab("🏷️ INFO", "crown")
local MainTab = Window:CreateTab("🎣 FISH", "fish") 
local ShopTab = Window:CreateTab("🛒 SHOP", "shopping-cart")
local TeleportTab = Window:CreateTab("🌍 TELEPORT", "map")
local PlayerTab = Window:CreateTab("👤 PLAYER", "user")
local UtilityTab = Window:CreateTab("⚙️ UTILITY", "settings")

-- Remotes
local net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("_Index"):WaitForChild("sleitnick_net@0.2.0"):WaitForChild("net")
local rodRemote = net:WaitForChild("RF/ChargeFishingRod")
local miniGameRemote = net:WaitForChild("RF/RequestFishingMinigameStarted")
local finishRemote = net:WaitForChild("RE/FishingCompleted")
local equipRemote = net:WaitForChild("RE/EquipToolFromHotbar")

-- State Variables
local AutoSell = false
local autofish = false
local perfectCast = false
local ijump = false
local autoRecastDelay = 0.5
local enchantPos = Vector3.new(3231, -1303, 1402)
local fishCaught = 0
local itemsSold = 0

local featureState = {
    AutoSell = false,
}

local function NotifySuccess(title, message)
	Rayfield:Notify({ Title = "🔥 BANGCODE - " .. title, Content = message, Duration = 3, Image = "circle-check" })
end

local function NotifyError(title, message)
	Rayfield:Notify({ Title = "🔥 BANGCODE - " .. title, Content = message, Duration = 3, Image = "ban" })
end

local function NotifyInfo(title, message)
	Rayfield:Notify({ Title = "🔥 BANGCODE - " .. title, Content = message, Duration = 4, Image = "info" })
end

-- ═══════════════════════════════════════════════════════════════
-- 🏷️ BANGCODE INFO TAB - Sidebar Style Layout
-- ═══════════════════════════════════════════════════════════════

InfoTab:CreateParagraph({
    Title = "🔥 BANGCODE Fish It Pro v2.0",
    Content = "Premium script with enhanced UI/UX, anti-ghost touch system, and professional quality guaranteed.\n\n💎 Created by BANGCODE - Trusted by thousands of users worldwide!"
})

InfoTab:CreateParagraph({
    Title = "✨ Enhanced Features",
    Content = "🛡️ Anti-Ghost Touch System\n🎨 Improved UI/UX Design\n📊 Live Status Monitoring\n🔧 Professional Error Handling\n⚡ Optimized Performance\n🎯 User-Friendly Interface"
})

InfoTab:CreateParagraph({
    Title = "📱 Follow BANGCODE",
    Content = "Stay updated with the latest scripts and features!\n\n• Instagram: @_bangicoo\n• GitHub: github.com/codeico\n\nYour support helps us create better tools!"
})

InfoTab:CreateButton({ 
    Name = "📷 Copy Instagram Link", 
    Callback = CreateSafeCallback(function() 
        setclipboard("https://instagram.com/_bangicoo") 
        NotifySuccess("Social Media", "Instagram link copied! Follow for updates and support!")
    end, "instagram")
})

InfoTab:CreateButton({ 
    Name = "💻 Copy GitHub Link", 
    Callback = CreateSafeCallback(function() 
        setclipboard("https://github.com/codeico") 
        NotifySuccess("Social Media", "GitHub link copied! Check out more premium scripts!")
    end, "github")
})

-- ═══════════════════════════════════════════════════════════════
-- 🎣 AUTO FISH TAB - Professional Fishing System
-- ═══════════════════════════════════════════════════════════════

MainTab:CreateParagraph({
    Title = "🎣 BANGCODE Auto Fish System",
    Content = "Professional auto fishing with perfect cast technology and customizable settings."
})

MainTab:CreateToggle({
    Name = "🔥 Enable Auto Fishing",
    CurrentValue = false,
    Callback = CreateSafeCallback(function(val)
        autofish = val
        if val then
            NotifySuccess("Auto Fish", "BANGCODE auto fishing started! Professional quality guaranteed.")
            task.spawn(function()
                while autofish do
                    pcall(function()
                        equipRemote:FireServer(1)
                        task.wait(0.1)

                        local timestamp = perfectCast and 9999999999 or (tick() + math.random())
                        rodRemote:InvokeServer(timestamp)
                        task.wait(0.1)

                        local x = perfectCast and -1.238 or (math.random(-1000, 1000) / 1000)
                        local y = perfectCast and 0.969 or (math.random(0, 1000) / 1000)

                        miniGameRemote:InvokeServer(x, y)
                        task.wait(1.3)
                        finishRemote:FireServer()
                        
                        fishCaught = fishCaught + 1
                    end)
                    task.wait(autoRecastDelay)
                end
            end)
        else
            NotifyInfo("Auto Fish", "Auto fishing stopped by user.")
        end
    end, "autofish")
})

MainTab:CreateToggle({
    Name = "✨ Perfect Cast Mode",
    CurrentValue = false,
    Callback = CreateSafeCallback(function(val)
        perfectCast = val
        NotifySuccess("Perfect Cast", "Perfect cast mode " .. (val and "activated" or "deactivated") .. "!")
    end, "perfectcast")
})

MainTab:CreateSlider({
    Name = "⏱️ Auto Recast Delay",
    Range = {0.5, 5},
    Increment = 0.1,
    CurrentValue = autoRecastDelay,
    Callback = function(val)
        autoRecastDelay = val
    end
})

-- Auto Sell Section
local AutoSellToggle = MainTab:CreateToggle({
    Name = "💰 Auto Sell Items (Teleport to Alex)",
    CurrentValue = false,
    Flag = "AutoSell",
    Callback = CreateSafeCallback(function(value)
        featureState.AutoSell = value
        if value then
            NotifySuccess("Auto Sell", "BANGCODE auto sell activated! Professional teleportation system enabled.")
            task.spawn(function()
                while featureState.AutoSell and player do
                    pcall(function()
                        if not (player.Character and player.Character:FindFirstChild("HumanoidRootPart")) then return end

                        local npcContainer = replicatedStorage:FindFirstChild("NPC")
                        local alexNpc = npcContainer and npcContainer:FindFirstChild("Alex")

                        if not alexNpc then
                            NotifyError("Error", "NPC 'Alex' not found! Auto sell disabled.")
                            featureState.AutoSell = false
                            AutoSellToggle:Set(false)
                            return
                        end

                        local originalCFrame = player.Character.HumanoidRootPart.CFrame
                        local npcPosition = alexNpc.WorldPivot.Position

                        player.Character.HumanoidRootPart.CFrame = CFrame.new(npcPosition)
                        task.wait(1)

                        replicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/SellAllItems"]:InvokeServer()
                        task.wait(1)

                        player.Character.HumanoidRootPart.CFrame = originalCFrame
                        itemsSold = itemsSold + 1
                    end)
                    task.wait(20)
                end
            end)
        else
            NotifyInfo("Auto Sell", "Auto sell system disabled.")
        end
    end, "autosell")
})

MainTab:CreateButton({
    Name = "📊 Show Session Stats",
    Callback = CreateSafeCallback(function()
        local stats = string.format("BANGCODE Session Statistics:\n\n🎣 Fish Caught: %d\n💰 Items Sold: %d\n⚡ Auto Fish: %s\n🛒 Auto Sell: %s", 
            fishCaught, itemsSold, 
            autofish and "Active" or "Inactive",
            featureState.AutoSell and "Active" or "Inactive"
        )
        NotifyInfo("Session Stats", stats)
    end, "session_stats")
})

-- ═══════════════════════════════════════════════════════════════
-- 🛒 SHOP TAB - Comprehensive Shopping System
-- ═══════════════════════════════════════════════════════════════

ShopTab:CreateParagraph({
    Title = "🛒 BANGCODE Premium Shop",
    Content = "Professional shopping system with organized categories and enhanced user experience."
})

-- Fishing Rods Section
ShopTab:CreateParagraph({
    Title = "🎣 Premium Fishing Rods",
    Content = "Select a rod to purchase using coins."
})

local rods = {
    { Name = "Luck Rod", Price = "350 Coins", ID = 79, Desc = "Luck: 50% | Speed: 2% | Weight: 15 kg" },
    { Name = "Carbon Rod", Price = "900 Coins", ID = 76, Desc = "Luck: 30% | Speed: 4% | Weight: 20 kg" },
    { Name = "Grass Rod", Price = "1.50k Coins", ID = 85, Desc = "Luck: 55% | Speed: 5% | Weight: 250 kg" },
    { Name = "Damascus Rod", Price = "3k Coins", ID = 77, Desc = "Luck: 80% | Speed: 4% | Weight: 400 kg" },
    { Name = "Ice Rod", Price = "5k Coins", ID = 78, Desc = "Luck: 60% | Speed: 7% | Weight: 750 kg" },
    { Name = "Lucky Rod", Price = "15k Coins", ID = 4, Desc = "Luck: 130% | Speed: 7% | Weight: 5k kg" },
    { Name = "Midnight Rod", Price = "50k Coins", ID = 80, Desc = "Luck: 100% | Speed: 10% | Weight: 10k kg" },
    { Name = "Steampunk Rod", Price = "215k Coins", ID = 6, Desc = "Luck: 175% | Speed: 19% | Weight: 25k kg" },
    { Name = "Chrome Rod", Price = "437k Coins", ID = 7, Desc = "Luck: 229% | Speed: 23% | Weight: 250k kg" },
    { Name = "Astral Rod", Price = "1M Coins", ID = 5, Desc = "Luck: 350% | Speed: 43% | Weight: 550k kg" }
}

for _, rod in ipairs(rods) do
    ShopTab:CreateButton({
        Name = rod.Name .. " (" .. rod.Price .. ")",
        Callback = CreateSafeCallback(function()
            pcall(function()
                replicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseFishingRod"]:InvokeServer(rod.ID)
                NotifySuccess("Rod Purchase", "Successfully bought " .. rod.Name .. "! " .. rod.Desc)
            end)
        end, "rod_" .. rod.ID)
    })
end

-- Fishing Baits Section
ShopTab:CreateParagraph({
    Title = "🪱 Premium Fishing Baits",
    Content = "Buy bait to enhance fishing luck and effects."
})

local baits = {
    { Name = "Topwater Bait", Price = "100 Coins", ID = 10, Desc = "Luck: 8%" },
    { Name = "Luck Bait", Price = "1k Coins", ID = 2, Desc = "Luck: 10%" },
    { Name = "Midnight Bait", Price = "3k Coins", ID = 3, Desc = "Luck: 20%" },
    { Name = "Chroma Bait", Price = "290k Coins", ID = 6, Desc = "Luck: 100%" },
    { Name = "Dark Matter Bait", Price = "630k Coins", ID = 8, Desc = "Luck: 175%" },
    { Name = "Corrupt Bait", Price = "1.15M Coins", ID = 15, Desc = "Luck: 200% | Mutation: 10% | Shiny: 10%" }
}

for _, bait in ipairs(baits) do
    ShopTab:CreateButton({
        Name = bait.Name .. " (" .. bait.Price .. ")",
        Callback = CreateSafeCallback(function()
            pcall(function()
                replicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseBait"]:InvokeServer(bait.ID)
                NotifySuccess("Bait Purchase", "Successfully bought " .. bait.Name .. "! " .. bait.Desc)
            end)
        end, "bait_" .. bait.ID)
    })
end

-- Weather Events Section
ShopTab:CreateParagraph({
    Title = "🌤️ Weather Events",
    Content = "Trigger special weather events to enhance fishing."
})

local weathers = {
    { Name = "Wind", Price = "10k Coins", Desc = "Increases Rod Speed" },
    { Name = "Snow", Price = "15k Coins", Desc = "Adds Frozen Mutations" },
    { Name = "Cloudy", Price = "20k Coins", Desc = "Increases Luck" },
    { Name = "Storm", Price = "35k Coins", Desc = "Increase Rod Speed And Luck" },
    { Name = "Shark Hunt", Price = "300k Coins", Desc = "Shark Hunt Event" }
}

for _, w in ipairs(weathers) do
    ShopTab:CreateButton({
        Name = w.Name .. " (" .. w.Price .. ")",
        Callback = CreateSafeCallback(function()
            pcall(function()
                replicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseWeatherEvent"]:InvokeServer(w.Name)
                NotifySuccess("Weather Event", "Successfully triggered " .. w.Name .. "! " .. w.Desc)
            end)
        end, "weather_" .. w.Name)
    })
end

-- Boats Section
ShopTab:CreateParagraph({
    Title = "🛥️ Premium Boats",
    Content = "Spawn professional boats with enhanced stats."
})

local standard_boats = {
    { Name = "Small Boat", ID = 1, Desc = "Acceleration: 160% | Passengers: 3 | Top Speed: 120%" },
    { Name = "Kayak", ID = 2, Desc = "Acceleration: 180% | Passengers: 1 | Top Speed: 155%" },
    { Name = "Jetski", ID = 3, Desc = "Acceleration: 240% | Passengers: 2 | Top Speed: 280%" },
    { Name = "Highfield Boat", ID = 4, Desc = "Acceleration: 180% | Passengers: 3 | Top Speed: 180%" },
    { Name = "Speed Boat", ID = 5, Desc = "Acceleration: 200% | Passengers: 4 | Top Speed: 220%" },
    { Name = "Fishing Boat", ID = 6, Desc = "Acceleration: 180% | Passengers: 8 | Top Speed: 230%" },
    { Name = "Mini Yacht", ID = 14, Desc = "Acceleration: 140% | Passengers: 10 | Top Speed: 290%" },
    { Name = "Hyper Boat", ID = 7, Desc = "Acceleration: 240% | Passengers: 7 | Top Speed: 400%" }
}

for _, boat in ipairs(standard_boats) do
    ShopTab:CreateButton({
        Name = "🛥️ " .. boat.Name,
        Callback = CreateSafeCallback(function()
            pcall(function()
                replicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/DespawnBoat"]:InvokeServer()
                task.wait(2)
                replicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/SpawnBoat"]:InvokeServer(boat.ID)
                NotifySuccess("Boat Spawn", "Successfully spawned " .. boat.Name .. "! " .. boat.Desc)
            end)
        end, "boat_" .. boat.ID)
    })
end

-- ═══════════════════════════════════════════════════════════════
-- 🌍 TELEPORT TAB - Advanced Teleportation Network
-- ═══════════════════════════════════════════════════════════════

TeleportTab:CreateParagraph({
    Title = "🌍 BANGCODE Teleport System",
    Content = "Professional teleportation with enhanced safety and user experience."
})

-- Islands Section
TeleportTab:CreateParagraph({
    Title = "🏝️ Islands & Locations",
    Content = "Quick teleport to all major islands and locations."
})

local islandCoords = {
    ["01"] = { name = "Weather Machine", position = Vector3.new(-1471, -3, 1929) },
    ["02"] = { name = "Esoteric Depths", position = Vector3.new(3157, -1303, 1439) },
    ["03"] = { name = "Tropical Grove", position = Vector3.new(-2038, 3, 3650) },
    ["04"] = { name = "Stingray Shores", position = Vector3.new(-32, 4, 2773) },
    ["05"] = { name = "Kohana Volcano", position = Vector3.new(-519, 24, 189) },
    ["06"] = { name = "Coral Reefs", position = Vector3.new(-3095, 1, 2177) },
    ["07"] = { name = "Crater Island", position = Vector3.new(968, 1, 4854) },
    ["08"] = { name = "Kohana", position = Vector3.new(-658, 3, 719) },
    ["09"] = { name = "Winter Fest", position = Vector3.new(1611, 4, 3280) },
    ["10"] = { name = "Esoteric Island", position = Vector3.new(1987, 4, 1400) }
}

for _, data in pairs(islandCoords) do
    TeleportTab:CreateButton({
        Name = data.name,
        Callback = CreateSafeCallback(function()
            local char = Workspace.Characters:FindFirstChild(LocalPlayer.Name)
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(data.position + Vector3.new(0, 5, 0))
                NotifySuccess("Teleported!", "Successfully teleported to " .. data.name .. "!")
            else
                NotifyError("Teleport Failed", "Character or HumanoidRootPart not found!")
            end
        end, "island_" .. data.name)
    })
end

-- NPCs Section
TeleportTab:CreateParagraph({
    Title = "👥 NPCs & Shops",
    Content = "Quick teleport to all important NPCs and shop locations."
})

local npcFolder = ReplicatedStorage:WaitForChild("NPC")
for _, npc in ipairs(npcFolder:GetChildren()) do
    TeleportTab:CreateButton({
        Name = "Teleport to " .. npc.Name,
        Callback = CreateSafeCallback(function()
            local npcCandidates = Workspace:GetDescendants()
            for _, descendant in ipairs(npcCandidates) do
                if descendant.Name == npc.Name and descendant:FindFirstChild("HumanoidRootPart") then
                    local myChar = LocalPlayer.Character
                    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
                    if myHRP then
                        myHRP.CFrame = descendant.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                        NotifySuccess("Teleport Success", "Successfully teleported to " .. npc.Name .. "!")
                        return
                    end
                end
            end
            NotifyError("Teleport Failed", "NPC " .. npc.Name .. " not found in workspace!")
        end, "npc_" .. npc.Name)
    })
end

-- ═══════════════════════════════════════════════════════════════
-- 👤 PLAYER TAB - Character Enhancement
-- ═══════════════════════════════════════════════════════════════

PlayerTab:CreateParagraph({
    Title = "👤 BANGCODE Player Enhancement",
    Content = "Professional character modifications with safety features."
})

-- Movement Section
PlayerTab:CreateToggle({
    Name = "∞ Infinite Jump",
    CurrentValue = false,
    Callback = CreateSafeCallback(function(val)
        ijump = val
        NotifySuccess("Infinite Jump", "Infinite jump " .. (val and "activated" or "deactivated") .. "!")
    end, "infinite_jump")
})

UserInputService.JumpRequest:Connect(function()
    if ijump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

PlayerTab:CreateSlider({
    Name = "🏃‍♂️ Walk Speed",
    Range = {16, 150},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(val)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = val end
    end
})

PlayerTab:CreateSlider({
    Name = "🦘 Jump Power",
    Range = {50, 500},
    Increment = 10,
    CurrentValue = 35,
    Callback = function(val)
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = val
        end
    end
})

-- Unlimited Oxygen Feature
local blockUpdateOxygen = false

PlayerTab:CreateToggle({
    Name = "🫁 Unlimited Oxygen",
    CurrentValue = false,
    Flag = "BlockUpdateOxygen",
    Callback = CreateSafeCallback(function(value)
        blockUpdateOxygen = value
        NotifySuccess("Oxygen System", "Unlimited oxygen " .. (value and "activated" or "deactivated") .. "!")
    end, "unlimited_oxygen")
})

-- Hook FireServer for Oxygen
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if method == "FireServer" and tostring(self) == "URE/UpdateOxygen" and blockUpdateOxygen then
        return nil -- prevent call
    end

    return oldNamecall(self, unpack(args))
end))

-- ═══════════════════════════════════════════════════════════════
-- ⚙️ UTILITY TAB - System Management & Settings
-- ═══════════════════════════════════════════════════════════════

UtilityTab:CreateParagraph({
    Title = "⚙️ BANGCODE Utility System",
    Content = "Professional system management and utility features."
})

UtilityTab:CreateButton({ 
    Name = "🔄 Rejoin Server", 
    Callback = CreateSafeCallback(function() 
        NotifyInfo("Server", "Rejoining current server...")
        task.wait(1)
        TeleportService:Teleport(game.PlaceId, LocalPlayer) 
    end, "rejoin_server")
})

UtilityTab:CreateButton({ 
    Name = "🎲 Server Hop", 
    Callback = CreateSafeCallback(function()
        NotifyInfo("Server Hop", "Finding new server with better performance...")
        local placeId = game.PlaceId
        local servers, cursor = {}, ""
        repeat
            local url = "https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100" .. (cursor ~= "" and "&cursor=" .. cursor or "")
            local success, result = pcall(function()
                return HttpService:JSONDecode(game:HttpGet(url))
            end)
            if success and result and result.data then
                for _, server in pairs(result.data) do
                    if server.playing < server.maxPlayers and server.id ~= game.JobId then
                        table.insert(servers, server.id)
                    end
                end
                cursor = result.nextPageCursor or ""
            else
                break
            end
        until not cursor or #servers > 0

        if #servers > 0 then
            local targetServer = servers[math.random(1, #servers)]
            NotifySuccess("Server Hop", "Found optimal server! Connecting...")
            TeleportService:TeleportToPlaceInstance(placeId, targetServer, LocalPlayer)
        else
            NotifyError("Server Hop", "No available servers found! Try again later.")
        end
    end, "server_hop")
})

UtilityTab:CreateButton({ 
    Name = "🗑️ Unload Script", 
    Callback = CreateSafeCallback(function()
        NotifyInfo("BANGCODE", "Thank you for using BANGCODE Fish It Pro! Script will unload in 3 seconds...")
        task.wait(3)
        if game:GetService("CoreGui"):FindFirstChild("Rayfield") then
            game:GetService("CoreGui").Rayfield:Destroy()
        end
    end, "unload_script")
})

-- Welcome Messages
task.spawn(function()
    task.wait(2)
    NotifySuccess("Welcome!", "🔥 BANGCODE Fish It Pro v2.0 loaded successfully!\n\nPremium features activated:\n• Anti-Ghost Touch System ✅\n• Enhanced UI/UX Design ✅\n• Professional Error Handling ✅\n\n🎯 Ready to dominate Fish It!")
    
    task.wait(4)
    NotifyInfo("Follow BANGCODE!", "📷 Instagram: @_bangicoo\n💻 GitHub: codeico\n\n🔥 Follow us for updates, support, and exclusive beta access to new scripts!")
end)

-- Console Branding
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🔥 BANGCODE FISH IT PRO V2.0 🔥")
print("🎯 Premium Script with Enhanced UI/UX & Anti-Ghost Touch")
print("📷 Instagram: @_bangicoo | 💻 GitHub: codeico")
print("💎 Professional Quality • Trusted by Thousands")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- Performance Enhancements (from original script)
pcall(function()
    -- Enhance fishing rod modifiers
    local Modifiers = require(game:GetService("ReplicatedStorage").Shared.FishingRodModifiers)
    for key in pairs(Modifiers) do
        Modifiers[key] = 999999999
    end

    -- Enhance luck bait
    local bait = require(game:GetService("ReplicatedStorage").Baits["Luck Bait"])
    bait.Luck = 999999999
end)
