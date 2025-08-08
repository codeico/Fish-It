-- Combined Auto Expedition and UI Utility Script
-- Expedition Auto Logic by Oevani + Utility Enhancements by KG3L

-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Window Setup
local Window = Rayfield:CreateWindow({
   Name = "Expedition Antarctica Script - BANGCODE",
   Icon = 0,
   LoadingTitle = "Welcome",
   LoadingSubtitle = "by BANGCODE",
   Theme = "Default",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "ExpeditionAntarcticaConfig",
      FileName = "Settings"
   },
   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = true
   },
   KeySystem = false
})

-- UI Tabs
local MainTab = Window:CreateTab("🏔️ Main", nil)
local MiscTab = Window:CreateTab("🔧 Misc", nil)
local Section = MainTab:CreateSection("Movement")
local MiscSection = MiscTab:CreateSection("Utilities")

-- === CONFIGURABLE STATS === --
local CurrentSpeed = 16
local CurrentJump = 50
local AutoFarmActive = false
local NoclipActive = false
local FogRemoved = false

-- === CHECKPOINT DETECTION FUNCTION === --
local function waitForCheckpoint(maxWaitTime)
    local startTime = tick()
    local player = game.Players.LocalPlayer
    
    while tick() - startTime < (maxWaitTime or 5) do
        -- Check for common checkpoint indicators
        local leaderstats = player:FindFirstChild("leaderstats")
        if leaderstats then
            local checkpoint = leaderstats:FindFirstChild("Checkpoint") or leaderstats:FindFirstChild("Stage")
            if checkpoint then
                print("Current checkpoint: " .. tostring(checkpoint.Value))
            end
        end
        
        -- Check for checkpoint parts in workspace
        for _, obj in pairs(workspace:GetChildren()) do
            if string.find(string.lower(obj.Name), "checkpoint") or 
               string.find(string.lower(obj.Name), "camp") then
                local distance = (player.Character.HumanoidRootPart.Position - obj.Position).Magnitude
                if distance < 50 then
                    print("Near checkpoint: " .. obj.Name)
                end
            end
        end
        
        wait(0.1)
    end
end

-- === IMPROVED TELEPORT FUNCTION === --
local function teleportToCheckpoint(name, cframe)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        -- Teleport slightly above the checkpoint
        local adjustedCFrame = cframe + Vector3.new(0, 5, 0)
        char.HumanoidRootPart.CFrame = adjustedCFrame
        
        -- Wait a moment then move to exact position
        wait(0.5)
        char.HumanoidRootPart.CFrame = cframe
        
        -- Wait for checkpoint detection
        print("Teleported to " .. name .. ", checking for checkpoint...")
        waitForCheckpoint(3)
        
        -- Try walking a bit to trigger checkpoint
        wait(0.5)
        char.Humanoid:MoveTo(char.HumanoidRootPart.Position + Vector3.new(5, 0, 0))
        wait(1)
        char.Humanoid:MoveTo(char.HumanoidRootPart.Position + Vector3.new(-5, 0, 0))
    end
end

-- === UPDATED TELEPORT COORDINATES === --
local Camps = {
    ["Camp 1"] = CFrame.new( -(4236.6 -(114 + 404)), 227.4, 723.6 -(106 + 382) ),
    ["Camp 2"] = CFrame.new(1789.7, 0, -137),
    ["Camp 3"] = CFrame.new(5892.1, 0, -20.3),
    ["Camp 4"] = CFrame.new(8992.2, 0, 102.6),
    ["South Pole"] = CFrame.new(11001.9, 0, 103)
}

-- === AUTO CHECKPOINT FARM === --
MainTab:CreateToggle({
    Name = "🤖 Auto Checkpoint Farm",
    CurrentValue = false,
    Flag = "AutoCheckpoint",
    Callback = function(Value)
        AutoFarmActive = Value
        if Value then
            spawn(function()
                while AutoFarmActive do
                    for name, cframe in pairs(Camps) do
                        if not AutoFarmActive then break end
                        print("Auto farming: " .. name)
                        teleportToCheckpoint(name, cframe)
                        wait(2) -- Wait between checkpoints
                    end
                    if AutoFarmActive then
                        wait(5) -- Wait before repeating cycle
                    end
                end
            end)
        end
    end
})

-- === MANUAL TELEPORT BUTTONS === --
for name, cframe in pairs(Camps) do
    MainTab:CreateButton({
        Name = "🚩 Teleport to " .. name,
        Callback = function()
            teleportToCheckpoint(name, cframe)
        end
    })
end

-- === COORDINATE CHECKER === --
MainTab:CreateButton({
    Name = "📍 Get Current Coordinates",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = player.Character.HumanoidRootPart.Position
            local cframe = player.Character.HumanoidRootPart.CFrame
            
            -- Format coordinates
            local posStr = string.format("Position: %.1f, %.1f, %.1f", pos.X, pos.Y, pos.Z)
            local cframeStr = string.format("CFrame.new(%.1f, %.1f, %.1f)", pos.X, pos.Y, pos.Z)
            
            -- Print to console
            print("=== CURRENT COORDINATES ===")
            print(posStr)
            print("CFrame: " .. cframeStr)
            print("Full CFrame: " .. tostring(cframe))
            print("============================")
            
            -- Show notification
            Rayfield:Notify({
                Title = "Coordinates Copied",
                Content = "Check console for full coordinates",
                Duration = 5
            })
            
            -- Try to copy to clipboard if possible
            if setclipboard then
                setclipboard(cframeStr)
                Rayfield:Notify({
                    Title = "Copied to Clipboard",
                    Content = cframeStr,
                    Duration = 3
                })
            end
        end
    end
})

-- === DISTANCE CHECKER === --
MainTab:CreateButton({
    Name = "📏 Check Distance to Camps",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local currentPos = player.Character.HumanoidRootPart.Position
            
            print("=== DISTANCES TO CAMPS ===")
            for name, cframe in pairs(Camps) do
                local campPos = Vector3.new(cframe.X, cframe.Y, cframe.Z)
                local distance = (currentPos - campPos).Magnitude
                print(name .. ": " .. string.format("%.1f", distance) .. " studs")
            end
            print("==========================")
            
            Rayfield:Notify({
                Title = "Distance Check",
                Content = "Check console for distances to all camps",
                Duration = 3
            })
        end
    end
})

-- === COORDINATE SAVER === --
local SavedCoordinates = {}

MainTab:CreateTextBox({
    Name = "💾 Save Current Position",
    PlaceholderText = "Enter name for this position",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and Text ~= "" then
            local pos = player.Character.HumanoidRootPart.Position
            local cframe = CFrame.new(pos.X, pos.Y, pos.Z)
            SavedCoordinates[Text] = cframe
            
            print("Saved position '" .. Text .. "': " .. string.format("CFrame.new(%.1f, %.1f, %.1f)", pos.X, pos.Y, pos.Z))
            
            Rayfield:Notify({
                Title = "Position Saved",
                Content = "Saved as: " .. Text,
                Duration = 3
            })
        end
    end
})

-- === TELEPORT TO SAVED COORDINATES === --
MainTab:CreateDropdown({
    Name = "🎯 Teleport to Saved Position",
    Options = {},
    CurrentOption = "",
    Flag = "SavedPositions",
    Callback = function(Option)
        if SavedCoordinates[Option] then
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = SavedCoordinates[Option]
                Rayfield:Notify({
                    Title = "Teleported",
                    Content = "Moved to: " .. Option,
                    Duration = 2
                })
            end
        end
    end
})

-- === COORDINATE TOOLS SECTION === --
local CoordSection = MainTab:CreateSection("📍 Coordinate Tools")

-- === CHECKPOINT INFO === --
MainTab:CreateButton({
    Name = "ℹ️ Check Current Checkpoint",
    Callback = function()
        local player = game.Players.LocalPlayer
        local leaderstats = player:FindFirstChild("leaderstats")
        
        if leaderstats then
            for _, stat in pairs(leaderstats:GetChildren()) do
                if string.find(string.lower(stat.Name), "checkpoint") or 
                   string.find(string.lower(stat.Name), "stage") or
                   string.find(string.lower(stat.Name), "camp") then
                    Rayfield:Notify({
                        Title = "Checkpoint Info",
                        Content = stat.Name .. ": " .. tostring(stat.Value),
                        Duration = 5
                    })
                end
            end
        else
            Rayfield:Notify({
                Title = "No Leaderstats",
                Content = "Cannot find checkpoint information",
                Duration = 3
            })
        end
    end
})

-- === ADDITIONAL UTILITIES === --
MiscTab:CreateSlider({
    Name = "🏃 Walk Speed",
    Range = {1, 100},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        CurrentSpeed = Value
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end
})

MiscTab:CreateSlider({
    Name = "🦘 Jump Power",
    Range = {1, 200},
    Increment = 1,
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        CurrentJump = Value
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
        end
    end
})

-- Auto-apply speed and jump when character spawns
game.Players.LocalPlayer.CharacterAdded:Connect(function(char)
    wait(1)
    if char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = CurrentSpeed
        char.Humanoid.JumpPower = CurrentJump
    end
end)
