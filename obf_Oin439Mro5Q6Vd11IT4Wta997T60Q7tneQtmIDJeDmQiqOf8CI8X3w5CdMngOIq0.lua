if getgenv().PMAO == true then return end
getgenv().PMAO = true

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/TheOneAthos/PremiumHub/refs/heads/main/S1?token=GHSAT0AAAAAADA7UJO2TNVRL27WYQOBKCUSZ7ABU7A"))()
local Veynx = lib.new("Athos | Arcane Odyssey v1.2.8 [TEST]")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local CurrentCamera = Workspace.CurrentCamera
local RunService = game:GetService("RunService")

local CurrentCamera = workspace.CurrentCamera

local Map = Workspace:WaitForChild("Map", 10)
local DarkSeaFolder = Map.SeaContent:WaitForChild("DarkSea",10)
local NPCs = Workspace:WaitForChild("NPCs")
local BoatsFolder = Workspace:WaitForChild("Boats")

local RS = game:GetService("ReplicatedStorage"):WaitForChild("RS",10)
local Remotes = RS:WaitForChild("Remotes")
local TeleportBind = Instance.new("BindableFunction")

local MagicModule = require(RS.Modules.Magic)
local MeleeModule = require(RS.Modules.Melee)
local BasicModule = require(RS.Modules.Basic)
local InventoryModule = require(RS.Modules.Inventory)

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local TpDebounce, FillDebounce, HecatePart, HoverFrameConnection = false, false, nil, nil

local ModifiedMagic, ModifiedMelee, ModifiedWeapon = nil, nil, nil
local EpiESPGui = nil

local DropdownTpList, MagicList, MeleeList, WeaponList = {}, {}, {}, {}

local remotes = {
    "DealAttackDamage",
    "DealStrengthDamage",
    "DealWeaponDamage",
    "DealMagicDamage",
    "DealDamageBoat",
    "DealDamageBoat3"
}

local AnimationPacks = {
    "Coward",
    "Boss",
    "Cute",
    "Lazy",
    "Fighter",
}

for _, Folder in Map:GetChildren() do
    if Folder:FindFirstChild("Center") then table.insert(DropdownTpList, Folder.Name) end
end

for _,Magic in MagicModule["Types"] do
    table.insert(MagicList, _)
end

for _,Magic in MeleeModule["Types"] do
    table.insert(MeleeList, _)
end

for _,Item in InventoryModule["Items"] do
    if not Item["WeaponType"] then continue end

    table.insert(WeaponList, _)
end

local var = {
    dmgValue = false,
    dmgMulti = 1,
    godmode = false,
    NPCBlock = false,
    FastBoatRepair = false,
    RepairMulti = 1,
    NoTracking = false,
    StaminaReduction = false,
    OneTapStructure = false,
    QuickFillBottles = false,
    ToggleLightning = false,
    DrinkBottleSilent = false,
    AutoFish = false,
    AutoWash = false,
    HecateNotifier = false,
    EpicenterESP = false,
    BoatESP = false,
    FishAnywhere = false,
}

local uiPages = {}
local uiSecs = {}

uiPages.Main = Veynx:addPage("Main")
uiPages.Exploits = Veynx:addPage("Exploits")
uiPages.DSExploits = Veynx:addPage("Dark Sea")
uiPages.Travel = Veynx:addPage("Teleports")
uiPages.Misc = Veynx:addPage("Misc")

uiSecs.Godmode = uiPages.Main:addSection("Godmode")
uiSecs.dmgExploits = uiPages.Main:addSection("Damage Exploits")
uiSecs.NPCE = uiPages.Main:addSection("NPC Exploits")
uiSecs.DSE = uiPages.DSExploits:addSection("Dark sea exploits")
uiSecs.UI = uiPages.Main:addSection("UI")

uiSecs.TP = uiPages.Travel:addSection("Teleports")

uiSecs.Misc = uiPages.Misc:addSection("Misc")
uiSecs.Discord = uiPages.Misc:addSection("Discord")

uiSecs.BoatExploits = uiPages.Exploits:addSection("Boat Exploits")
uiSecs.ItemExploits = uiPages.Exploits:addSection("Item Exploits")
uiSecs.PlayerExploits = uiPages.Exploits:addSection("Player Exploits")
uiSecs.FishExploits = uiPages.Exploits:addSection("Fish Exploits")
uiSecs.MagicExploits = uiPages.Exploits:addSection("Magic Exploits")
uiSecs.MeleeExploits = uiPages.Exploits:addSection("Melee Exploits")
uiSecs.WepExploits = uiPages.Exploits:addSection("Weapon Exploits")

uiSecs.Godmode:addToggle("Godmode.", false, function(value)
    var["godmode"] = value
end)

uiSecs.NPCE:addToggle("No NPC Aggro.", false, function(value)
    var["NPCBlock"] = value
end)

uiSecs.PlayerExploits:addToggle("No location tracking.", false, function(value)
    var["NoTracking"] = value
end)

uiSecs.PlayerExploits:addToggle("Spawn dark sea lightning", false, function(value)
    var["ToggleLightning"] = value
end)

uiSecs.PlayerExploits:addToggle("Reduced stamina consumption.", false, function(value)
    var["StaminaReduction"] = value
end)

uiSecs.PlayerExploits:addButton("Discover all islands.", function(value)
    for _,Island in Map:GetChildren() do
        if Island:FindFirstChild("Center") then
            Remotes.Misc.UpdateLastSeen:FireServer(Island.Name, "")
        end
    end
end)

uiSecs.dmgExploits:addSlider("Damage multiplier amount.", 1, 1, 15, function(value)
    var["dmgMulti"] = value
end)

uiSecs.dmgExploits:addToggle("Damage multiplier.", false, function(value)
    var["dmgValue"] = value

    Veynx:Notify("Warning!", "This multiplies damage against players, use it wisely.")
end)

uiSecs.BoatExploits:addToggle("Ship repair multiplier.", false, function(value)
    var["FastBoatRepair"] = value
end)

uiSecs.BoatExploits:addSlider("Ship repair multi (costs galleons).", 1, 1, 50, function(value)
    var["RepairMulti"] = value
end)

uiSecs.MagicExploits:addToggle("One tap buildings/structures.", false, function(value)
    var["OneTapStructure"] = value
end)

uiSecs.FishExploits:addToggle("Auto fish toggle.", false, function(value)
    var["AutoFish"] = value
end)

uiSecs.FishExploits:addToggle("Fish anywhere.", false, function(value)
    var["FishAnywhere"] = value

    if value == false then
        task.delay(1, function()
            require(RS.Modules.Basic).OceanLevel = 400
        end)
    end
end)

uiSecs.UI:addKeybind("Toggle UI.", Enum.KeyCode.Equals, function(value)
    Veynx:toggle()
end)

uiSecs.ItemExploits:addButton("Quick fill empty bottles.", function(value)
    if FillDebounce == true then return end
    FillDebounce = true

    local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    Humanoid:UnequipTools()

    for i = 1,100 do
        Remotes.Misc.EmptyBottle:FireServer()
    end

    task.delay(1, function()
        FillDebounce = false
    end)
end)

uiSecs.DSE:addButton("Disable dark sea rain.", function()
    Workspace.Camera:WaitForChild("OverheadFX",10).DSRain.Lifetime = NumberRange.new(0,0)
    Workspace.Camera:WaitForChild("OverheadFX",10).DSRain2.Lifetime = NumberRange.new(0,0)

    Veynx:Notify("Warning!", "Once you die you need to re-toggle this.")
end)

uiSecs.DSE:addButton("Disable fog circle.", function()
    local Sky1 = LocalPlayer.PlayerGui.Temp.DarkSea:FindFirstChild("DarkSky1")
    local Sky2 = LocalPlayer.PlayerGui.Temp.DarkSea:FindFirstChild("DarkSky2")

    if not Sky1 then return end
    if not Sky2 then return end
    Sky1:FindFirstChildOfClass("SpecialMesh"):Destroy()
    Sky2:FindFirstChildOfClass("SpecialMesh"):Destroy()

    local CSky1 = CurrentCamera:FindFirstChild("DarkSky1")
    local CSky2 = CurrentCamera:FindFirstChild("DarkSky2")
    if not CSky1 then return end
    if not CSky2 then return end
    CSky1:FindFirstChildOfClass("SpecialMesh"):Destroy()
    CSky2:FindFirstChildOfClass("SpecialMesh"):Destroy()
end)

uiSecs.DSE:addButton("Fast cargo ship repair.", function()
    Veynx:Notify("Warning!", "You need at least 1 cargo for this to work.\nTier/upgrades do not matter.")

    for _, NPC in Workspace.NPCs:GetChildren() do
        if (NPC.Name == "Edward Kenton" or NPC.Name == "Edward Kenton2") or
           (NPC.Name == "Enizor" or NPC.Name == "Enizor2" or NPC.Name == "EnizorC") then
            if NPC:FindFirstChildOfClass("Model") == nil then continue end

            local Captain = NPC:FindFirstChildOfClass("Model"):FindFirstChild("Captain")
            if Captain and Captain.Value == LocalPlayer then
                for i=1, 100 do
                    Remotes.Boats.UnloadShip:FireServer(Captain.Parent, "Repair", "Use as much as possible.")
                end
                break
            end
        end
    end
end)

uiSecs.DSE:addToggle("Epicenter ESP", false, function(value)
    var["EpicenterESP"] = value
    local CenterPart = Map:FindFirstChild("The Epicenter") and Map:FindFirstChild("The Epicenter").Center
    
    if not var["EpicenterESP"] then
        if EpiESPGui then
            EpiESPGui:Destroy()
            EpiESPGui = nil
        end
        if HoverFrameConnection then
            HoverFrameConnection:Disconnect()
            HoverFrameConnection = nil
        end
        return
    end

    if not EpiESPGui then
        EpiESPGui = Instance.new("ScreenGui")
        EpiESPGui.Parent = game:GetService("CoreGui")

        Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(0, 50, 0, 50)
        Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        Frame.BorderSizePixel = 2
        Frame.Parent = EpiESPGui
        Frame.Visible = false
    end

    if HoverFrameConnection then
        HoverFrameConnection:Disconnect()
        HoverFrameConnection = nil
    end

    HoverFrameConnection = RunService.RenderStepped:Connect(function()
        if not var["EpicenterESP"] then
            if EpiESPGui then
                EpiESPGui:Destroy()
                EpiESPGui = nil
            end
            if HoverFrameConnection then
                HoverFrameConnection:Disconnect()
                HoverFrameConnection = nil
            end
            return
        end

        if CenterPart then
            local screenPosition, onScreen = CurrentCamera:WorldToViewportPoint(CenterPart.Position)

            if onScreen then
                Frame.Position = UDim2.new(0, screenPosition.X - 25, 0, screenPosition.Y - 25)
                Frame.Visible = true
            else
                Frame.Visible = false
            end
        end
    end)
end)

uiSecs.DSE:addToggle("Toggle auto wash bin.", false, function(value)
    var["AutoWash"] = value
end)

uiSecs.DSE:addToggle("Hecate essence notifier.", false, function(value)
    var["HecateNotifier"] = value
end)

uiSecs.PlayerExploits:addButton("Toggle insanity effects.", function(value)
    local InsanityLocalScript = LocalPlayer.PlayerGui:WaitForChild("Temp",10):FindFirstChild("Insanity")
    InsanityLocalScript.Disabled = not InsanityLocalScript.Disabled
end)

uiSecs.Misc:addButton("ArcaneYield (modded IY).", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Idktbh12z/ArcaneYIELD/refs/heads/main/main.lua"))()
end)

uiSecs.Misc:addButton("Quick clear notoriety.", function()
    Remotes.UI.ClearBounty:InvokeServer("ClearNotoriety")
end)

uiSecs.Misc:addDropdown("Animation Packs", AnimationPacks, function(value)
    BasicModule.GetAnimationPack = function()
        return tostring(value)
    end
    Veynx:Notify("Warning!", "This wont apply until you reset.")
end)

uiSecs.Discord:addButton("Join our discord!", function()
    local Module = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Discord%20Inviter/Source.lua"))()
    Module.Join("https://discord.gg/S4dpMhaCcs")
end)

uiSecs.TP:addDropdown("Teleports", DropdownTpList, function(value)
    if TpDebounce then return end
    TpDebounce = true
    local Island = Map:FindFirstChild(value)
    if not Island then return end

    local Center = Island:FindFirstChild("Center")
    if not Center then return end

    if value == "Harvest Island" then
        local OldPos = Center.Position

        Center.Position = Vector3.new(7236, 598, 343)

        task.delay(1, function()
            Center.Position = OldPos
        end)
    end

    local LandingPos = value == "Mount Othrys" and CFrame.new(0,-25000,0) or CFrame.new(0, 1000, 0)

    LocalPlayer.Character.HumanoidRootPart.CFrame = Center.CFrame * LandingPos
    task.wait()
    LocalPlayer.Character.HumanoidRootPart.Anchored = true

    task.delay(15, function()
        LocalPlayer.Character.HumanoidRootPart.Anchored = false
        TpDebounce = false
    end)
end)

-- Magic Exploits

uiSecs.MagicExploits:addDropdown("[Magic]", MagicList, function(value)
    if not MagicModule["Types"][value] then return end

    ModifiedMagic = value
end)

uiSecs.MagicExploits:addTextbox("Size", "1", function(value)
    if not ModifiedMagic then return end
    if not tonumber(value) then return end
    local num = tonumber(value)
    if num > 75 then Veynx:Notify("Warning!", "This could break your game if you set it too high. \n Suggested value: 75") end

    MagicModule["Types"][ModifiedMagic].Size = num
end)

uiSecs.MagicExploits:addTextbox("Speed", "1", function(value)
    if not ModifiedMagic then return end
    if not tonumber(value) then return end
    local num = tonumber(value)
    if num > 3 then Veynx:Notify("Warning!", "This could break your game if you set it too high. \n Suggested value: <3") end

    MagicModule["Types"][ModifiedMagic].Speed = num
end)

uiSecs.MagicExploits:addTextbox("Imbue Speed", "1", function(value)
    if not ModifiedMagic then return end
    if not tonumber(value) then return end
    local num = tonumber(value)
    if num > 3 then Veynx:Notify("Warning!", "This could break your game if you set it too high. \n Suggested value: <3") end

    MagicModule["Types"][ModifiedMagic].ImbueSpeed = num
end)

-- Melee Exploits

uiSecs.MeleeExploits:addDropdown("[Fighting Style]", MeleeList, function(value)
    if not MeleeModule["Types"][value] then return end

    ModifiedMelee = value
end)

uiSecs.MeleeExploits:addTextbox("Size", "1", function(value)
    if not ModifiedMelee then return end
    if not tonumber(value) then return end
    local num = tonumber(value)
    if num > 5 then Veynx:Notify("Warning!", "This could break your game if you set it too high. \n Suggested value: < 5") end

    MeleeModule["Types"][ModifiedMelee].Size = num
end)

uiSecs.MeleeExploits:addTextbox("Speed", "1", function(value)
    if not ModifiedMelee then return end
    if not tonumber(value) then return end
    local num = tonumber(value)
    if num > 3 then Veynx:Notify("Warning!", "This could break your game if you set it too high. \n Suggested value: < 3") end

    MeleeModule["Types"][ModifiedMelee].Speed = num
end)

uiSecs.MeleeExploits:addTextbox("Imbue Speed", "1", function(value)
    if not ModifiedMelee then return end
    if not tonumber(value) then return end
    local num = tonumber(value)
    if num > 3 then Veynx:Notify("Warning!", "This could break your game if you set it too high. \n Suggested value: < 3") end

    MeleeModule["Types"][ModifiedMelee].ImbueSpeed = num
end)

-- Weapon Exploits

uiSecs.WepExploits:addDropdown("Weapon", WeaponList, function(value)
    if not InventoryModule["Items"][value] then return end

    ModifiedWeapon = value
end)

uiSecs.WepExploits:addTextbox("Size", "1", function(value)
    if not ModifiedWeapon then return end
    if not tonumber(value) then return end
    local num = tonumber(value)
    if num > 75 then Veynx:Notify("Warning!", "This could break your game if you set it too high. \n Suggested value: < 75") end

    InventoryModule["Items"][ModifiedWeapon]["Specs"]["Attack Size"]["Value"] = num
end)

uiSecs.WepExploits:addTextbox("Speed", "1", function(value)
    if not ModifiedWeapon then return end
    if not tonumber(value) then return end
    local num = tonumber(value)
    if num > 3 then Veynx:Notify("Warning!", "This could break your game if you set it too high. \n Suggested value: < 3") end

    InventoryModule["Items"][ModifiedWeapon]["Specs"]["Attack Speed"]["Value"] = num
end)

-- End

uiSecs.MeleeExploits:addToggle("Drink Bottles Silently", false, function(value)
    var["DrinkBottleSilent"] = value   

    Veynx:Notify("Keybind!", "The default keybind is '.'")
end)

UserInputService.InputBegan:connect(function(Input, IsChatBox)
    if IsChatBox then return end
    if var["DrinkBottleSilent"] ~= true then return end

    if Input.KeyCode == Enum.KeyCode.Period then
        Remotes.Misc.EmptyBottle:FireServer(true)
    end
end)

-- End

task.spawn(function()
    LocalPlayer.Character.ChildAdded:connect(function(Child)
        if var["AutoFish"] == false then return end
        if Child.Name ~= "FishBiteGoal" then return end

        repeat Remotes.Misc.ToolAction:FireServer(LocalPlayer.Character:FindFirstChildOfClass("Tool")) task.wait(0.1) until Child.Parent == nil

        task.delay(1, function()
            Remotes.Misc.ToolAction:FireServer(LocalPlayer.Character:FindFirstChildOfClass("Tool"))
        end)
    end)
end)

task.spawn(function()
    while task.wait(3) do
        if var["AutoWash"] == true then Remotes.Boats.Wash:FireServer() end
    end
end)

task.spawn(function()
    while task.wait(0.05) do
        if var["FishAnywhere"] == true then require(RS.Modules.Basic).OceanLevel = LocalPlayer.Character.HumanoidRootPart.Position.Y - 1 end
    end
end)

task.spawn(function()
    while task.wait(5) do
        if var["HecateNotifier"] == true then 
            for _,Child in DarkSeaFolder:GetChildren() do
                if Child.Name ~= "Island" then continue end
                if not Child:FindFirstChild("HecateEssence") then continue end

                StarterGui:SetCore("SendNotification", {
                    Title = "Hecate found!";
                    Text = "Click the button below to teleport.";
                    Duration = 5;
                    Button1 = "Teleport";
                    Callback =  TeleportBind
                })

                HecatePart = Child:FindFirstChild("HecateEssence")
            end
        end
    end
end)

task.spawn(function()
    TeleportBind.OnInvoke = function()
        if HecatePart == nil then return end

        LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame = HecatePart.CFrame
    end
end)

task.spawn(function()
    while task.wait(1) do
        for _,Player in ReplicatedStorage.RS.UnloadPlayers:GetChildren() do
            Player.Parent = game.Workspace.NPCs
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        for _,Instance in LocalPlayer.PlayerGui:GetChildren() do
            if Instance.Name:lower() == "deathscreen" then
                Instance.Enabled = false
            end
        end
    end
end)

task.spawn(function()
    local StaminaHook
    StaminaHook = hookmetamethod(game, "__namecall", newcclosure(function(self,...)
        local args = { ... }
        local method = getnamecallmethod()

        if not checkcaller() and (tostring(self) == "StaminaCost") and var["StaminaReduction"] == true then
            if args[1] then
                args[1] = 0
            end
        end

        return StaminaHook(self,unpack(args))
    end))
end)

task.spawn(function()
    local OneTapStructureHook
    OneTapStructureHook = hookmetamethod(game, "__namecall", newcclosure(function(self,...)
        local args = { ... }
        local method = getnamecallmethod()

        if not checkcaller() and (tostring(self) == "DamageStructure") and var["OneTapStructure"] == true then
            for i=1,1000 do
                self.InvokeServer(self, unpack(args))
            end
        end

        return OneTapStructureHook(self,unpack(args))
    end))
end)

task.spawn(function()
    local LightningHook
    LightningHook = hookmetamethod(game, "__namecall", newcclosure(function(self,...)
        local args = { ... }
        local method = getnamecallmethod()

        if not checkcaller() and (tostring(self) == "UpdateLastSeen") and var["ToggleLightning"] == true then
            if args[1] then
                args[1] = "The Dark Sea"
            end
            if args[2] then
                args[2] = ""
            end
        end

        return LightningHook(self,unpack(args))
    end))
end)

task.spawn(function()
    local NoTrackingHook
    NoTrackingHook = hookmetamethod(game, "__namecall", newcclosure(function(self,...)
        local args = { ... }
        local method = getnamecallmethod()

        if not checkcaller() and (tostring(self) == "UpdateLastSeen") and var["NoTracking"] == true then
            if args[1] then
                args[1] = ""
            end

            if args[2] then
                args[2] = ""
            end
        end

        return NoTrackingHook(self,unpack(args))
    end))
end)

task.spawn(function()
    local damageHook
    damageHook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local args = { ... }
        local method = getnamecallmethod()

        if not checkcaller() and table.find(remotes, tostring(self)) and var["dmgValue"] then
            for i = 1, var["dmgMulti"] do
                self.FireServer(self, unpack(args))
            end
        end

        return damageHook(self, unpack(args))
    end))
end)

task.spawn(function()
    local godHook
    godHook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local args = { ... }

        if not checkcaller() and (tostring(self) == "DealAttackDamage" or tostring(self) == "DealBossDamage") and var["godmode"] then
            if args[2] == LocalPlayer.Character then
                args[2] = nil
            end
        elseif not checkcaller() and tostring(self) == "DealMagicDamage" and var["godmode"] then
            if args[2] == LocalPlayer.Character then
                args[2] = nil
            end
        elseif not checkcaller() and (tostring(self) == "DealWeaponDamage" or tostring(self) == "DealStrengthDamage" ) and var["godmode"] then
            if args[3] == LocalPlayer.Character then
                args[3] = nil
            end
        elseif not checkcaller() and (tostring(self) == "TouchDamage") and var["godmode"] then
            return
        end

        return godHook(self, unpack(args))
    end))
end)

task.spawn(function()
    local blockHook
    blockHook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local args = { ... }
        local method = getnamecallmethod()

        if not checkcaller() and tostring(self) == "TargetBehavior" and method == "InvokeServer" and var["NPCBlock"] then
            return
        end

        return blockHook(self, unpack(args))
    end))
end)

task.spawn(function()
    local RepairHook
    RepairHook = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local args = { ... }
        local method = getnamecallmethod()

        if not checkcaller() and tostring(self) == "RepairHammer" and method == "InvokeServer" and var["FastBoatRepair"] then
            for i=1,var["RepairMulti"] do
                self.InvokeServer(self, unpack(args))
            end
        end

        return RepairHook(self, unpack(args))
    end))
end)