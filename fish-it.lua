
-- // Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- // Load Orion UI
local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()

-- // Create Window
local Window = OrionLib:MakeWindow({
    Name = "🎣 Fish It Script | by @BANGCODE",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "FishIt_BANGCODE",
    IntroText = "Welcome to Fish It | BANGCODE Edition"
})

-- // Notify Function
local function Notify(title, text, duration)
    OrionLib:MakeNotification({
        Name = title,
        Content = text,
        Image = "rbxassetid://4483362458",
        Time = duration or 3
    })
end

-- // Tabs
local DevTab = Window:MakeTab({ Name = "Developer", Icon = "rbxassetid://7733658504", PremiumOnly = false })
local MainTab = Window:MakeTab({ Name = "Auto Fish", Icon = "rbxassetid://7733960981", PremiumOnly = false })
local PlayerTab = Window:MakeTab({ Name = "Player", Icon = "rbxassetid://7734053425", PremiumOnly = false })
local IslandsTab = Window:MakeTab({ Name = "Islands", Icon = "rbxassetid://7733771290", PremiumOnly = false })
local SettingsTab = Window:MakeTab({ Name = "Settings", Icon = "rbxassetid://7733911827", PremiumOnly = false })
local NPCTab = Window:MakeTab({ Name = "NPC", Icon = "rbxassetid://7733674079", PremiumOnly = false })
local EventTab = Window:MakeTab({ Name = "Event", Icon = "rbxassetid://7733964643", PremiumOnly = false })
local BoatTab = Window:MakeTab({ Name = "Spawn Boat", Icon = "rbxassetid://7733964711", PremiumOnly = false })
local RodTab = Window:MakeTab({ Name = "Buy Rod", Icon = "rbxassetid://7734053631", PremiumOnly = false })
local WeatherTab = Window:MakeTab({ Name = "Buy Weather", Icon = "rbxassetid://7734053439", PremiumOnly = false })
local BaitTab = Window:MakeTab({ Name = "Buy Bait", Icon = "rbxassetid://7734053557", PremiumOnly = false })

-- Developer Info
DevTab:AddParagraph("BANGCODE Script", "Thanks for using this script!\n\nDeveloper:\n- Tiktok: -\n- Instagram: @_bangicoo\n- GitHub: github.com/codeico\n\nKeep supporting!")
DevTab:AddButton({
    Name = "Instagram",
    Callback = function()
        setclipboard("https://instagram.com/_bangicoo")
        Notify("Instagram", "Copied to clipboard!", 3)
    end
})
DevTab:AddButton({
    Name = "GitHub",
    Callback = function()
        setclipboard("https://github.com/codeico")
        Notify("GitHub", "Copied to clipboard!", 3)
    end
})

-- AUTO FISHING
local autofish = false
local perfectCast = false
local autoRecastDelay = 0.5

MainTab:AddToggle({
    Name = "🎣 Enable Auto Fishing",
    Default = false,
    Callback = function(Value)
        autofish = Value
        if Value then
            task.spawn(function()
                while autofish do
                    pcall(function()
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
                    end)
                    task.wait(autoRecastDelay)
                end
            end)
        end
    end
})

MainTab:AddToggle({
    Name = "✨ Use Perfect Cast",
    Default = false,
    Callback = function(Value)
        perfectCast = Value
    end
})

MainTab:AddSlider({
    Name = "⏱️ Auto Recast Delay (seconds)",
    Min = 0.5,
    Max = 5,
    Default = autoRecastDelay,
    Increment = 0.1,
    Callback = function(Value)
        autoRecastDelay = Value
    end
})

-- (Fitur lain: Auto Sell, Spawn Boat, Buy Rod, Buy Weather, Buy Bait, Teleport, Event Scanner, Player Settings, Settings Tab, dll.)
-- Diteruskan sama persis seperti script gabungan yang kita susun sebelumnya
