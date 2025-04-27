repeat task.wait() until game:IsLoaded()
local player                = game:GetService("Players")
local replicatedstorage     = game:GetService("ReplicatedStorage")
local workspace             = game:GetService("Workspace") 
local notify_module = require(game:GetService("ReplicatedStorage").Notification)
local SeatPath
if game.PlaceId == 7449423635 then
    SeatPath = workspace.Map.Turtle:GetChildren()
elseif game.PlaceId == 4442272183 then
    SeatPath = workspace.Map.Dressrosa:GetChildren()
else
    error("wrong game")
end

function ingame_notify(msg)
    notify_module.new("<Color=Yellow>"..msg.."<Color=/>"):Display()
end

if #getgenv().Setting["Main Accs"] == 0 or #getgenv().Setting["Alt Accs"] == 0 then
    ingame_notify("There is no account in main or alt accounts")
    error("There is no account in main or alt accounts")
end

local mainacc   = false
local altacc    = false
function get_main_and_alt_inserver()
    local player_name = string.lower(player.LocalPlayer.Name)
    for i,v in pairs(getgenv().Setting["Main Accs"]) do
        if string.lower(v) == player_name then
            mainacc = true
            return ingame_notify("found main acc")
        end
    end
    for i,v in pairs(getgenv().Setting["Alt Accs"]) do
        if string.lower(v) == player_name then
            altacc = true
           return ingame_notify("found alt acc")
        end
    end
    if not mainacc and not altacc then
        ingame_notify("Unknown account ( cannot match this account with main or alt accs)")
        error("Unknown account ( cannot match this account with main or alt accs)")
        return 
    end
end

-- function reword_fruit(Name)
--     local Word = Name:split(" ")[1]
-- 	return `{Word}-{Word}`
-- end

function get_inventory()
    return replicatedstorage.Remotes.CommF_:InvokeServer("getInventory")
end

local useless_fruit_table   = {}
local good_fruit_table      = {}
function get_fruit()
    for index ,v in pairs(get_inventory()) do
        if v.Type == "Blox Fruit" then
            if v.Rarity < 3 then
                table.insert(useless_fruit_table, v.Name)
            else
                table.insert(good_fruit_table, v.Name)
            end
        end
    end
end

local resetting_fruit
function remove_useless_fruit()
    if getgenv().Setting["Remove Under 1m Fruit"] and altacc then
        for index ,v in pairs(useless_fruit_table) do
            ingame_notify("Removing Under-1m-fruit")
            resetting_fruit = true
            replicatedstorage.Remotes.CommF_:InvokeServer("LoadFruit", v)
            player.LocalPlayer.Character:BreakJoints()
            player.LocalPlayer.CharacterAdded:Wait()
            repeat task.wait() until player.LocalPlayer.Character and player.LocalPlayer.Character:FindFirstChild('Humanoid')
            task.wait(1)
        end
        resetting_fruit = false
    end
end

function tp(P1)
    Distance = (P1.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
    local Speed = 1000000000
   tping = game:GetService("TweenService"):Create(
        game.Players.LocalPlayer.Character.HumanoidRootPart,
        TweenInfo.new(Distance/Speed, Enum.EasingStyle.Linear),
        {CFrame = P1 * CFrame.fromAxisAngle(Vector3.new(1,0,0), math.rad(0))}
    )
    tping:Play()
end

function check_alt(name_to_check)
    name_to_check = string.lower(name_to_check)
    for i,v in pairs(getgenv().Setting["Alt Accs"]) do
        if string.lower(v) == name_to_check then
            return true
        end
    end
    for i,v in pairs(getgenv().Setting["Main Accs"]) do
        if string.lower(v) == name_to_check then
            return true
        end
    end
    return false
end

local found = false
function getchair()
    for i,v in ipairs(SeatPath) do
        if v.Name == "TradeTable" then
            local Seat1 =   v:FindFirstChild('P1')
            local Seat2 =   v:FindFirstChild('P2')
            local P1    =   Seat1.Occupant
            local P2    =   Seat2.Occupant
            if (P1 and P1.Parent.Name == player.LocalPlayer.Name) and (P2 and not check_alt(P2.Parent.Name) ) then
                game.Players.LocalPlayer.Character.Humanoid.Sit = false
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Seat1.CFrame * CFrame.new(0,0,5)
                wait(1.5)

            elseif (P2 and P2.Parent.Name == player.LocalPlayer.Name) and (P1 and not check_alt(P1.Parent.Name) ) then
                game.Players.LocalPlayer.Character.Humanoid.Sit = false
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Seat2.CFrame * CFrame.new(0,0,5)
                wait(1.5)
            end

            if P1 and check_alt(P1.Parent.Name) and not P2 then
                found = true
                tp(Seat2.CFrame)
                task.wait(1)

            elseif P2 and check_alt(P2.Parent.Name) and not P1 then
                found = true
                tp(Seat1.CFrame)
                task.wait(1)
                auto_trade()
            elseif not P1 and not P2 then
                found = true
                tp(Seat1.CFrame)
                task.wait(1)
                auto_trade()
            end
        end
    end
    if not found then
        ingame_notify("Could not find seat")
    end
end

function auto_trade()
    game.Players.LocalPlayer.PlayerGui.Notifications.Enabled = false
    if mainacc then
        if found then
            for i,v in pairs(useless_fruit_table) do
                replicatedstorage.Remotes.TradeFunction:InvokeServer("addItem", v)
                if i >= 4 then
                    break
                end
            end
        end
    elseif altacc then
        if found then
            for i,v in pairs(good_fruit_table) do
                replicatedstorage.Remotes.TradeFunction:InvokeServer("addItem", v)
                if i >= 4 then
                    break
                end
            end
        end
    end
end

get_main_and_alt_inserver()
get_fruit()
remove_useless_fruit()
while wait() do
getchair()
end
