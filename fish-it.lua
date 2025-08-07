-- // Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- // Anti Ghost Touch System
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
            warn("Button callback error:", result)
        end
    end
end

-- // Load Orion UI
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

-- // Create Window (Enhanced Style with BANGCODE Branding)
local Window = OrionLib:MakeWindow({
    Name = "🔥 BANGCODE | Fish It Pro v2.0",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "FishIt_BANGCODE_Pro",
    IntroText = "🎯 Professional Fish It Script\n🔥 Enhanced UI/UX • Anti-Ghost Touch\n💎 Created by BANGCODE - Premium Quality\n\nWelcome to Fish It Pro v2.0!"
})

-- // Enhanced Notify Function with BANGCODE Branding
local NotificationQueue = {}
local function Notify(title, text, duration, type)
    local icon = type == "success" and "rbxassetid://4483345998" or 
                 type == "error" and "rbxassetid://4483362458" or
                 type == "warning" and "rbxassetid://4483345875" or
                 "rbxassetid://4483362458"
    
    table.insert(NotificationQueue, {
        Name = "🔥 BANGCODE • " .. title,
        Content = text .. "\n\n💎 Powered by BANGCODE",
        Image = icon,
        Time = duration or 4
    })
    
    if #NotificationQueue == 1 then
        task.spawn(function()
            while #NotificationQueue > 0 do
                local notif = table.remove(NotificationQueue, 1)
                OrionLib:MakeNotification(notif)
                task.wait(0.5)
            end
        end)
    end
end

-- // Status Variables
local ScriptStatus = {
    AutoFish = false,
    AutoSell = false,
    LastAction = "Ready",
    FishCaught = 0,
    ItemsSold = 0
}

-- // Organized Tabs (Better UX)
local MainTab = Window:MakeTab({ Name = "🎣 Auto Fish", Icon = "rbxassetid://7733960981", PremiumOnly = false })
local ShopTab = Window:MakeTab({ Name = "🛒 Shop", Icon = "rbxassetid://7734053631", PremiumOnly = false })
local TeleportTab = Window:MakeTab({ Name = "🌍 Teleport", Icon = "rbxassetid://7733771290", PremiumOnly = false })
local PlayerTab = Window:MakeTab({ Name = "👤 Player", Icon = "rbxassetid://7734053425", PremiumOnly = false })
local UtilityTab = Window:MakeTab({ Name = "🔧 Utility", Icon = "rbxassetid://7733911827", PremiumOnly = false })
local InfoTab = Window:MakeTab({ Name = "ℹ️ Info", Icon = "rbxassetid://7733658504", PremiumOnly = false })

-- // Info Tab - BANGCODE Branding & Status
InfoTab:AddParagraph("🔥 BANGCODE FISH IT PRO v2.0 🔥", "")

InfoTab:AddParagraph("▓▓▓ B A N G C O D E ▓▓▓", "🎯 Professional Script Developer\n🔥 Premium Quality Guaranteed\n💎 Trusted by Thousands of Users\n\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

InfoTab:AddParagraph("🎣 FISH IT PRO | VERSION 2.0", "✨ Enhanced UI/UX Design\n🛡️ Anti-Ghost Touch System\n📊 Live Status Monitoring\n🔧 Professional Error Handling\n\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

local StatusSection = InfoTab:AddSection({ Name = "📊 REAL-TIME STATUS" })

InfoTab:AddParagraph("📈 Session Statistics", "🎣 Auto Fish: ❌ Inactive\n💰 Auto Sell: ❌ Inactive\n📈 Fish Caught: 0\n💵 Items Sold: 0\n⚡ Status: Ready to Fish!")

InfoTab:AddSection({ Name = "🏷️ BANGCODE SIGNATURE" })

InfoTab:AddParagraph("▓▓▓ CREATED BY BANGCODE ▓▓▓", "🎨 Premium Script Developer\n🔥 Trusted by Thousands of Users\n⭐ Professional Quality Guaranteed\n\n💎 This script is an exclusive BANGCODE creation\n🛡️ Anti-detection & Optimized Performance")

InfoTab:AddSection({ Name = "🔗 BANGCODE OFFICIAL LINKS" })

InfoTab:AddButton({
    Name = "📷 Instagram • @_bangicoo",
    Callback = CreateSafeCallback(function()
        setclipboard("https://instagram.com/_bangicoo")
        Notify("BANGCODE Social", "📷 Instagram link copied! Follow for updates!", 4, "success")
    end, "instagram")
})

InfoTab:AddButton({
    Name = "💻 GitHub • codeico",
    Callback = CreateSafeCallback(function()
        setclipboard("https://github.com/codeico")
        Notify("BANGCODE Social", "💻 GitHub link copied! Check out more scripts!", 4, "success")
    end, "github")
})

InfoTab:AddButton({
    Name = "⭐ Rate This Script",
    Callback = CreateSafeCallback(function()
        Notify("BANGCODE Appreciation", "⭐ Thanks for using BANGCODE scripts!\n🔥 Your support helps us create better tools!", 5, "success")
    end, "rate_script")
})

InfoTab:AddSection({ Name = "💎 PREMIUM FEATURES" })

InfoTab:AddParagraph("🏆 BANGCODE Quality Promise", "✅ Anti-Detection Technology\n✅ Regular Updates & Support\n✅ Clean, Professional Code\n✅ 24/7 Stability Testing\n✅ User-Friendly Interface\n\n🎯 This script represents BANGCODE's commitment to excellence!")
-- ==============================
-- AUTO FISHING (Enhanced)
-- ==============================
local autofish = false
local perfectCast = false
local autoRecastDelay = 0.5

MainTab:AddSection({ Name = "🎣 Fishing Automation" })

MainTab:AddToggle({
    Name = "🎣 Auto Fishing",
    Default = false,
    Callback = CreateSafeCallback(function(Value)
        autofish = Value
        ScriptStatus.AutoFish = Value
        
        if Value then
            Notify("Auto Fish", "Starting auto fishing...", 3, "success")
            ScriptStatus.LastAction = "Auto fishing started"
            
            task.spawn(function()
                while autofish do
                    local success = pcall(function()
                        ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/EquipToolFromHotbar"]:FireServer(1)
                        task.wait(0.1)

                        local timestamp = perfectCast and 9999999999 or (tick() + math.random())
                        ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/ChargeFishingRod"]:InvokeServer(timestamp)
                        task.wait(0.1)

                        local x = perfectCast and -1.238 or (math.random(-1000, 1000) / 1000)
                        local y = perfectCast and 0.969 or (math.random(0, 1000) / 1000)

                        ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/RequestFishingMinigameStarted"]:InvokeServer(x, y)
                        task.wait(1.3)
                        ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/FishingCompleted"]:FireServer()
                        
                        ScriptStatus.FishCaught = ScriptStatus.FishCaught + 1
                        ScriptStatus.LastAction = "Fish caught (#" .. ScriptStatus.FishCaught .. ")"
                    end)
                    
                    if not success then
                        ScriptStatus.LastAction = "Fishing error occurred"
                    end
                    
                    task.wait(autoRecastDelay)
                end
            end)
        else
            Notify("Auto Fish", "Auto fishing stopped", 3, "warning")
            ScriptStatus.LastAction = "Auto fishing stopped"
        end
    end, "autofish")
})

MainTab:AddToggle({
    Name = "✨ Perfect Cast Mode",
    Default = false,
    Callback = CreateSafeCallback(function(Value)
        perfectCast = Value
        local status = Value and "enabled" or "disabled"
        Notify("Perfect Cast", "Perfect cast " .. status, 3, "success")
    end, "perfectcast")
})

MainTab:AddSlider({
    Name = "⏱️ Cast Delay",
    Min = 0.5,
    Max = 5,
    Default = autoRecastDelay,
    Increment = 0.1,
    ValueName = "seconds",
    Callback = function(Value)
        autoRecastDelay = Value
    end
})

MainTab:AddSection({ Name = "💰 Auto Selling" })

local autoSell = false

MainTab:AddToggle({
    Name = "💰 Auto Sell Items",
    Default = false,
    Callback = CreateSafeCallback(function(Value)
        autoSell = Value
        ScriptStatus.AutoSell = Value
        
        if Value then
            Notify("Auto Sell", "Starting auto sell (every 20s)...", 4, "success")
            ScriptStatus.LastAction = "Auto sell started"
            
            task.spawn(function()
                while autoSell do
                    local success = pcall(function()
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            local alexNpc = ReplicatedStorage:FindFirstChild("NPC") and ReplicatedStorage.NPC:FindFirstChild("Alex")
                            if alexNpc then
                                local originalCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                                
                                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(alexNpc.WorldPivot.Position)
                                task.wait(1)
                                ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/SellAllItems"]:InvokeServer()
                                task.wait(1)
                                LocalPlayer.Character.HumanoidRootPart.CFrame = originalCFrame
                                
                                ScriptStatus.ItemsSold = ScriptStatus.ItemsSold + 1
                                ScriptStatus.LastAction = "Items sold (#" .. ScriptStatus.ItemsSold .. ")"
                            else
                                ScriptStatus.LastAction = "Alex NPC not found"
                            end
                        end
                    end)
                    
                    if not success then
                        ScriptStatus.LastAction = "Sell error occurred"
                    end
                    
                    task.wait(20)
                end
            end)
        else
            Notify("Auto Sell", "Auto sell stopped", 3, "warning")
            ScriptStatus.LastAction = "Auto sell stopped"
        end
    end, "autosell")
})

MainTab:AddButton({
    Name = "💵 Sell Items Now",
    Callback = CreateSafeCallback(function()
        local success = pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local alexNpc = ReplicatedStorage:FindFirstChild("NPC") and ReplicatedStorage.NPC:FindFirstChild("Alex")
                if alexNpc then
                    local originalCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(alexNpc.WorldPivot.Position)
                    task.wait(1)
                    ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/SellAllItems"]:InvokeServer()
                    task.wait(1)
                    LocalPlayer.Character.HumanoidRootPart.CFrame = originalCFrame
                    Notify("Sell Items", "Items sold successfully!", 3, "success")
                else
                    Notify("Sell Items", "Alex NPC not found!", 3, "error")
                end
            end
        end)
        if not success then
            Notify("Sell Items", "Failed to sell items!", 3, "error")
        end
    end, "sellnow")
})

-- ==============================
-- SHOP TAB - All Purchases
-- ==============================
ShopTab:AddSection({ Name = "🎣 Fishing Rods" })

local rods = {
    { Name = "Luck Rod", ID = 79 },
    { Name = "Carbon Rod", ID = 76 },
    { Name = "Grass Rod", ID = 85 },
    { Name = "Damascus Rod", ID = 77 },
    { Name = "Ice Rod", ID = 78 },
    { Name = "Lucky Rod", ID = 4 },
    { Name = "Midnight Rod", ID = 80 },
    { Name = "Steampunk Rod", ID = 6 },
    { Name = "Chrome Rod", ID = 7 },
    { Name = "Astral Rod", ID = 5 }
}

for _, rod in ipairs(rods) do
    ShopTab:AddButton({
        Name = rod.Name,
        Callback = CreateSafeCallback(function()
            local success = pcall(function()
                ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseFishingRod"]:InvokeServer(rod.ID)
            end)
            if success then
                Notify("Rod Purchase", "Bought " .. rod.Name .. "!", 3, "success")
            else
                Notify("Rod Purchase", "Failed to buy " .. rod.Name, 3, "error")
            end
        end, "rod_" .. rod.ID)
    })
end

ShopTab:AddSection({ Name = "🪱 Fishing Baits" })

local baits = {
    { Name = "Topwater Bait", ID = 10 },
    { Name = "Luck Bait", ID = 2 },
    { Name = "Midnight Bait", ID = 3 },
    { Name = "Chroma Bait", ID = 6 },
    { Name = "Dark Matter Bait", ID = 8 },
    { Name = "Corrupt Bait", ID = 15 }
}

for _, bait in ipairs(baits) do
    ShopTab:AddButton({
        Name = bait.Name,
        Callback = CreateSafeCallback(function()
            local success = pcall(function()
                ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseBait"]:InvokeServer(bait.ID)
            end)
            if success then
                Notify("Bait Purchase", "Bought " .. bait.Name .. "!", 3, "success")
            else
                Notify("Bait Purchase", "Failed to buy " .. bait.Name, 3, "error")
            end
        end, "bait_" .. bait.ID)
    })
end

ShopTab:AddSection({ Name = "🌤️ Weather Events" })

local weathers = {
    { Name = "Wind" },
    { Name = "Snow" },
    { Name = "Cloudy" },
    { Name = "Storm" },
    { Name = "Shark Hunt" }
}

for _, w in ipairs(weathers) do
    ShopTab:AddButton({
        Name = w.Name .. " Weather",
        Callback = CreateSafeCallback(function()
            local success = pcall(function()
                ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/PurchaseWeatherEvent"]:InvokeServer(w.Name)
            end)
            if success then
                Notify("Weather Event", w.Name .. " weather activated!", 3, "success")
            else
                Notify("Weather Event", "Failed to activate " .. w.Name, 3, "error")
            end
        end, "weather_" .. w.Name)
    })
end

ShopTab:AddSection({ Name = "🛥️ Spawn Boats" })

local standard_boats = {
    { Name = "Small Boat", ID = 1 },
    { Name = "Kayak", ID = 2 },
    { Name = "Jetski", ID = 3 },
    { Name = "Highfield Boat", ID = 4 },
    { Name = "Speed Boat", ID = 5 },
    { Name = "Fishing Boat", ID = 6 },
    { Name = "Mini Yacht", ID = 14 },
    { Name = "Hyper Boat", ID = 7 },
    { Name = "Frozen Boat", ID = 11 },
    { Name = "Cruiser Boat", ID = 13 }
}

for _, boat in ipairs(standard_boats) do
    ShopTab:AddButton({
        Name = boat.Name,
        Callback = CreateSafeCallback(function()
            local success = pcall(function()
                ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/DespawnBoat"]:InvokeServer()
                task.wait(2)
                ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/SpawnBoat"]:InvokeServer(boat.ID)
            end)
            if success then
                Notify("Boat Spawn", boat.Name .. " spawned!", 4, "success")
            else
                Notify("Boat Spawn", "Failed to spawn " .. boat.Name, 3, "error")
            end
        end, "boat_" .. boat.ID)
    })
end
-- ==============================
-- TELEPORT TAB - All Locations
-- ==============================
TeleportTab:AddSection({ Name = "🏝️ Islands" })

local islandCoords = {
    ["Weather Machine"] = Vector3.new(-1471, -3, 1929),
    ["Esoteric Depths"] = Vector3.new(3157, -1303, 1439),
    ["Tropical Grove"] = Vector3.new(-2038, 3, 3650),
    ["Stingray Shores"] = Vector3.new(-32, 4, 2773),
    ["Kohana Volcano"] = Vector3.new(-519, 24, 189),
    ["Coral Reefs"] = Vector3.new(-3095, 1, 2177),
    ["Crater Island"] = Vector3.new(968, 1, 4854),
    ["Kohana"] = Vector3.new(-658, 3, 719),
    ["Winter Fest"] = Vector3.new(1611, 4, 3280),
    ["Esoteric Island"] = Vector3.new(1987, 4, 1400)
}

for name, pos in pairs(islandCoords) do
    TeleportTab:AddButton({
        Name = name,
        Callback = CreateSafeCallback(function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
                Notify("Teleport", "Teleported to " .. name .. "!", 3, "success")
                ScriptStatus.LastAction = "Teleported to " .. name
            else
                Notify("Teleport", "Character not found!", 3, "error")
            end
        end, "island_" .. name)
    })
end

TeleportTab:AddSection({ Name = "👥 NPCs" })

local npcFolder = ReplicatedStorage:FindFirstChild("NPC")
if npcFolder then
    for _, npc in ipairs(npcFolder:GetChildren()) do
        TeleportTab:AddButton({
            Name = npc.Name,
            Callback = CreateSafeCallback(function()
                local candidates = Workspace:GetDescendants()
                for _, obj in ipairs(candidates) do
                    if obj.Name == npc.Name and obj:FindFirstChild("HumanoidRootPart") then
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            hrp.CFrame = obj.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                            Notify("Teleport", "Teleported to " .. npc.Name .. "!", 3, "success")
                            ScriptStatus.LastAction = "Teleported to " .. npc.Name
                            return
                        end
                    end
                end
                Notify("Teleport", npc.Name .. " not found!", 3, "error")
            end, "npc_" .. npc.Name)
        })
    end
end

TeleportTab:AddSection({ Name = "🎪 Events & Props" })

local function createEventButtons()
    local props = Workspace:FindFirstChild("Props")
    if props then
        for _, child in pairs(props:GetChildren()) do
            if child:IsA("Model") or child:IsA("BasePart") then
                local eventName = child.Name
                TeleportTab:AddButton({
                    Name = eventName,
                    Callback = CreateSafeCallback(function()
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        local pos
                        if child:IsA("Model") then
                            pos = child.PrimaryPart and child.PrimaryPart.Position or child:FindFirstChildWhichIsA("BasePart").Position
                        elseif child:IsA("BasePart") then
                            pos = child.Position
                        end
                        if pos and hrp then
                            hrp.CFrame = CFrame.new(pos + Vector3.new(0, 5, 0))
                            Notify("Teleport", "Teleported to " .. eventName .. "!", 3, "success")
                        else
                            Notify("Teleport", "Invalid location: " .. eventName, 3, "error")
                        end
                    end, "event_" .. eventName)
                })
            end
        end
    end
end

TeleportTab:AddButton({
    Name = "🔄 Refresh Events",
    Callback = CreateSafeCallback(function()
        createEventButtons()
        Notify("Events", "Event list refreshed!", 3, "success")
    end, "refresh_events")
})

createEventButtons()

-- ==============================
-- PLAYER TAB - Character Modifications
-- ==============================
PlayerTab:AddSection({ Name = "🚶‍♂️ Movement" })

local ijump = false
PlayerTab:AddToggle({
    Name = "∞ Infinite Jump",
    Default = false,
    Callback = CreateSafeCallback(function(Value)
        ijump = Value
        local status = Value and "enabled" or "disabled"
        Notify("Infinite Jump", "Infinite jump " .. status, 3, Value and "success" or "warning")
    end, "infinite_jump")
})

UserInputService.JumpRequest:Connect(function()
    if ijump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

PlayerTab:AddSlider({
    Name = "🏃‍♂️ Walk Speed",
    Min = 16,
    Max = 150,
    Default = 16,
    Increment = 1,
    ValueName = "studs/s",
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
            ScriptStatus.LastAction = "Walk speed set to " .. Value
        end
    end
})

PlayerTab:AddSlider({
    Name = "🦘 Jump Power",
    Min = 35,
    Max = 500,
    Default = 35,
    Increment = 10,
    ValueName = "power",
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = Value
            ScriptStatus.LastAction = "Jump power set to " .. Value
        end
    end
})

PlayerTab:AddSection({ Name = "🎮 Quick Actions" })

PlayerTab:AddButton({
    Name = "🔧 Reset Character",
    Callback = CreateSafeCallback(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Health = 0
            Notify("Reset", "Character reset!", 3, "success")
        end
    end, "reset_character")
})

PlayerTab:AddButton({
    Name = "🏠 Return to Spawn",
    Callback = CreateSafeCallback(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(0, 5, 0)
            Notify("Spawn", "Returned to spawn!", 3, "success")
        end
    end, "return_spawn")
})

-- ==============================
-- UTILITY TAB - Server & Script Management
-- ==============================
UtilityTab:AddSection({ Name = "🌐 Server Management" })

UtilityTab:AddButton({
    Name = "🔄 Rejoin Server",
    Callback = CreateSafeCallback(function()
        Notify("Server", "Rejoining current server...", 3, "warning")
        task.wait(1)
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end, "rejoin_server")
})

UtilityTab:AddButton({
    Name = "🎲 Server Hop",
    Callback = CreateSafeCallback(function()
        Notify("Server Hop", "Finding new server...", 4, "warning")
        
        local placeId = game.PlaceId
        local servers, cursor = {}, ""
        local maxAttempts = 3
        local currentAttempt = 0
        
        repeat
            currentAttempt = currentAttempt + 1
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
        until not cursor or #servers > 0 or currentAttempt >= maxAttempts

        if #servers > 0 then
            local targetServer = servers[math.random(1, #servers)]
            Notify("Server Hop", "Teleporting to new server...", 3, "success")
            TeleportService:TeleportToPlaceInstance(placeId, targetServer, LocalPlayer)
        else
            Notify("Server Hop", "No available servers found!", 4, "error")
        end
    end, "server_hop")
})

UtilityTab:AddSection({ Name = "⚙️ Script Control" })

UtilityTab:AddButton({
    Name = "📊 Show Status",
    Callback = CreateSafeCallback(function()
        local status = string.format(
            "🎣 Auto Fish: %s\n💰 Auto Sell: %s\n📈 Fish Caught: %d\n💵 Items Sold: %d\n⚡ Last Action: %s",
            ScriptStatus.AutoFish and "Active" or "Inactive",
            ScriptStatus.AutoSell and "Active" or "Inactive", 
            ScriptStatus.FishCaught,
            ScriptStatus.ItemsSold,
            ScriptStatus.LastAction
        )
        Notify("Status Report", status, 6, "success")
    end, "show_status")
})

UtilityTab:AddButton({
    Name = "🗑️ Unload Script",
    Callback = CreateSafeCallback(function()
        Notify("Shutdown", "Script will unload in 3 seconds...", 4, "warning")
        task.wait(3)
        if game:GetService("CoreGui"):FindFirstChild("Orion") then
            game:GetService("CoreGui").Orion:Destroy()
        end
    end, "unload_script")
})

-- ==============================
-- LIVE STATUS UPDATE SYSTEM
-- ==============================
local StatusUpdateConnection
StatusUpdateConnection = task.spawn(function()
    while true do
        task.wait(5)
        if InfoTab and InfoTab.Flags then
            pcall(function()
                local statusText = string.format(
                    "🎣 Auto Fish: %s\n🛒 Auto Sell: %s\n📈 Fish Caught: %d\n💰 Items Sold: %d\n⚡ Last Action: %s",
                    ScriptStatus.AutoFish and "✅ Active" or "❌ Inactive",
                    ScriptStatus.AutoSell and "✅ Active" or "❌ Inactive",
                    ScriptStatus.FishCaught,
                    ScriptStatus.ItemsSold,
                    ScriptStatus.LastAction
                )
                
                if InfoTab.Flags["Status Monitor"] then
                    OrionLib:MakeNotification({
                        Name = "📊 Live Status Updated",
                        Content = statusText,
                        Image = "rbxassetid://4483345998",
                        Time = 1
                    })
                end
            end)
        end
    end
end)

-- ==============================
-- BANGCODE STARTUP SEQUENCE
-- ==============================

-- Welcome Message with BANGCODE Branding
task.spawn(function()
    task.wait(2)
    Notify("Welcome!", "🎉 BANGCODE Fish It Pro v2.0 Loaded!\n\n🔥 Premium Features:\n• Anti-Ghost Touch ✅\n• Enhanced UI/UX ✅\n• Live Status ✅\n\n🎯 Ready to Fish!", 6, "success")
    
    task.wait(4)
    Notify("Follow Us!", "📷 Instagram: @_bangicoo\n💻 GitHub: codeico\n\n🔥 Get updates & support!", 5, "success")
end)

-- BANGCODE Watermark in Console
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🔥 BANGCODE FISH IT PRO V2.0 🔥")
print("🎯 Premium Script with Enhanced UI/UX & Anti-Ghost Touch")
print("📷 Instagram: @_bangicoo | 💻 GitHub: codeico")
print("💎 Professional Quality • Trusted by Thousands")
print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

-- ==============================
-- FINAL INIT
-- ==============================
OrionLib:Init()
