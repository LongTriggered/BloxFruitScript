
repeat task.wait() until game:IsLoaded()
local player                = game:GetService("Players")
local replicatedstorage     = game:GetService("ReplicatedStorage")
local workspace             = game:GetService("Workspace") 
local notify_module = require(replicatedstorage.Notification)
local SeatPath
if game.PlaceId == 7449423635 then
    SeatPath = workspace.Map.Turtle:GetChildren()
elseif game.PlaceId == 4442272183 then
    SeatPath = workspace.Map.Dressrosa:GetChildren()
else
    error("wrong game")
end

if player.LocalPlayer.Team == nil then
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Marines") 
end
repeat task.wait() until game:GetService('Players').LocalPlayer.Team ~= nil
repeat task.wait() until game:GetService('Players').LocalPlayer.Character
task.wait(1)

function ingame_notify(msg)
    notify_module.new("<Color=Yellow>"..msg.."<Color=/>"):Display()
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

function clear_tables(...)
    for _, tbl in ipairs({...}) do
        for k in pairs(tbl) do
            tbl[k] = nil
        end
    end
end


local useless_fruit_table  = {}
local highest_price_fruit  = {}
local main_fruit_list = {}
local alt_fruit_list = {}
function get_fruit_value()
    clear_tables(useless_fruit_table, highest_price_fruit, main_fruit_list)
    ingame_notify("Checked Player's Fruit")
    for _ ,v in pairs(get_inventory()) do
        if v.Type == "Blox Fruit" then
            table.insert(main_fruit_list, { name = v.Name, value = v.Value})

            if v.Rarity < 3 then
                table.insert(useless_fruit_table, v.Name)
            else
                table.insert(highest_price_fruit, {name = v.Name, value = v.Value})
            end
        end
    end
    table.sort(highest_price_fruit, function(a, b)
         return a.value > b.value 
    end)

    table.sort(main_fruit_list, function(a, b)
        return a.value < b.value
    end)
end

function remove_useless_fruit()
    if getgenv().Setting["Remove Under 1m Fruit"] and altacc then
        for _ ,v in pairs(useless_fruit_table) do
            ingame_notify("Removing Under-1m-fruit")
            replicatedstorage.Remotes.CommF_:InvokeServer("LoadFruit", v)
            player.LocalPlayer.Character:BreakJoints()
            player.LocalPlayer.CharacterAdded:Wait()
            repeat task.wait() until player.LocalPlayer.Character and player.LocalPlayer.Character:FindFirstChild('Humanoid')
            task.wait(1)
        end
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

function check_valid_acc(name_to_check)
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

local TradeUI = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("Trade")

TradeUI:GetPropertyChangedSignal("Visible"):Connect(function()
    if TradeUI.Visible then
            task.wait(2)
            auto_trade()
    end
end)

function start_trade()
    while task.wait(.01) do
        local found = false
        local emptyseat
        for i,v in ipairs(SeatPath) do
            if v.Name == "TradeTable" then
                local Seat1 =   v:FindFirstChild('P1')
                local Seat2 =   v:FindFirstChild('P2')
                local P1    =   Seat1.Occupant
                local P2    =   Seat2.Occupant
                -- Check if partner is not valid
                if (P1 and P1.Parent.Name == player.LocalPlayer.Name) and (P2 and not check_valid_acc(P2.Parent.Name) ) then
                    game.Players.LocalPlayer.Character.Humanoid.Sit = false
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Seat1.CFrame * CFrame.new(0,0,5)
                    ingame_notify("Trading with unknown account")
                    found = false
                    task.wait(1.5)
                    break

                elseif (P2 and P2.Parent.Name == player.LocalPlayer.Name) and (P1 and not check_valid_acc(P1.Parent.Name) ) then
                    game.Players.LocalPlayer.Character.Humanoid.Sit = false
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Seat2.CFrame * CFrame.new(0,0,5)
                    found = false
                    ingame_notify("Trading with unknown account")
                    taks.wait(1.5)
                    break
                end

                if game:GetService("Players").LocalPlayer.PlayerGui.Main.Trade.Visible == false and not found then
                    if P1 and P1.Parent.Name ~= player.LocalPlayer.Name and check_valid_acc(P1.Parent.Name) and not P2 then
                        found = true
                        tp(Seat2.CFrame)
                        break

                    elseif P2 and P2.Parent.Name ~= player.LocalPlayer.Name and check_valid_acc(P2.Parent.Name) and not P1 then
                        found = true
                        tp(Seat1.CFrame)
                        break
                    end
                end

                if not P1 and not P2 and not emptyseat then
                    emptyseat = Seat1
                end

            end
        end

        if not found and emptyseat then
            found = true
            tp(emptyseat.CFrame)
        end
    end
end

function get_alt_fruit()
    clear_tables(alt_fruit_list)
    for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Main["Trade"].Container["2"].Frame:GetChildren()) do
        if v.Name ~= "UIGridLayout" and v.Name ~= "EmptyTemplate" and v.Name ~= "Template" and v.Name ~= "TextLabel" then
            local fruitvalue = v.Type.TextLabel.Text
            fruitvalue = fruitvalue:gsub(",", "")  -- Gỡ dấu phẩy
            fruitvalue = fruitvalue:gsub("%$", "")
            alt_fruit_list[1] = {name = v.Name, value = tonumber(fruitvalue)}
            return true
        end
    end
    return false
end
-----------------------------  Do not touch ----------------------------
local function recordHistory(history, player, action, fruits, total, diff)
    local entry = { player = player, action = action }
    if type(fruits) == "table" then
        entry.fruit = {}
        for _, f in ipairs(fruits) do
            table.insert(entry.fruit, string.format("%s (%.2f)", f.name, f.value))
        end
    else
        entry.fruit = { string.format("%s (%.2f)", fruits.name, fruits.value) }
    end
    if total then entry.total = total end
    if diff then entry.diff = string.format("%.2f%%", diff * 100) end
    table.insert(history, entry)
end
local function combinations(tbl, r)
    local results, n, combo = {}, #tbl
    combo = {}
    local function backtrack(start, depth)
        if depth > r then
            local copy = {}
            for _, v in ipairs(combo) do table.insert(copy, v) end
            table.insert(results, copy)
            return
        end
        for i = start, n - (r - depth) + 1 do
            combo[depth] = tbl[i]
            backtrack(i + 1, depth + 1)
        end
    end
    backtrack(1,1)
    return results
end
local function findBestCombo(available, maxSlots, minTotal, maxTotal)
    for r = math.min(maxSlots, #available), 1, -1 do
        for _, combo in ipairs(combinations(available, r)) do
            local sumVal = 0
            for _, f in ipairs(combo) do sumVal = sumVal + f.value end
            if sumVal >= minTotal and sumVal < maxTotal then
                return combo
            end
        end
    end
    return error('could not find any combos')
end
local function simulateTradeNoJSON(mainTbl, altTbl, maxSlots, maxDiff)
    -- sort
    table.sort(mainTbl, function(a,b) return a.value < b.value end)
    table.sort(altTbl, function(a,b) return a.value > b.value end)

    maxSlots = maxSlots or 4
    maxDiff  = maxDiff  or 0.4
    local history = {}

    -- sao chép mainTbl
    local availableMain = {}
    for _, f in ipairs(mainTbl) do table.insert(availableMain, f) end

    local selectedMain = {}
    local selectedAlt  = {}

    for _, altFruit in ipairs(altTbl) do
        if #selectedAlt >= maxSlots then break end

        -- tính tổng alt tạm
        local tempAlt = {}
        for _, f in ipairs(selectedAlt) do table.insert(tempAlt, f) end
        table.insert(tempAlt, altFruit)
        local totalAlt = 0
        for _, f in ipairs(tempAlt) do totalAlt = totalAlt + f.value end

        local minMain = totalAlt * (1 - maxDiff)
        local maxMain = totalAlt

        local best = findBestCombo(availableMain, maxSlots, minMain, maxMain)
        if best then
            table.insert(selectedAlt, altFruit)
            for _, f in ipairs(best) do
                table.insert(selectedMain, f)
                -- loại khỏi available
                for i,a in ipairs(availableMain) do
                    if a.name == f.name then
                        table.remove(availableMain, i)
                        break
                    end
                end
            end

            -- ghi lịch sử
            local sumMain = 0
            for _, f in ipairs(best) do sumMain = sumMain + f.value end
            local diffVal = (totalAlt - sumMain) / totalAlt
            recordHistory(history, 2, "offer", altFruit, totalAlt, diffVal)
            recordHistory(history, 1, "offer", best,     sumMain, diffVal)
        end
    end

    return {
        main_offer = selectedMain,
        alt_offer  = selectedAlt,
        history    = history,
    }
end
-- print("Player 1 đưa:")
-- for _, f in ipairs(result.main_offer) do
--     print(string.format(" - %s (%.2f)", f.name, f.value))
-- end
-- print("Player 2 đưa:")
-- for _, f in ipairs(result.alt_offer) do
--     print(string.format(" - %s (%.2f)", f.name, f.value))
-- end
-- print("\nLịch sử giao dịch:")
-- for _, entry in ipairs(result.history) do
--     local line = string.format("Player %d %s %s", entry.player, entry.action, table.concat(entry.fruit, ", "))
--     if entry.total then line = line .. string.format(" | Tổng: %.2f", entry.total) end
--     if entry.diff  then line = line .. string.format(" | Chênh lệch: %s", entry.diff) end
--     print(line)
-- end
----------------------------------------------------------------------

function auto_trade()
    ingame_notify("Processing trade")
    get_fruit_value()
    task.wait(1)
   -- game.Players.LocalPlayer.PlayerGui.Notifications.Enabled = false
    if mainacc then
            repeat task.wait(1) get_alt_fruit() until get_alt_fruit() == true
                local result = simulateTradeNoJSON(main_fruit_list, alt_fruit_list, 4, 0.4)
                print("**************************************************")
                print('partner fruit: '..alt_fruit_list[1].name)
                for i, v in ipairs(result.main_offer) do
                    print("given fruit: "..v.name)
                    replicatedstorage.Remotes.TradeFunction:InvokeServer("addItem", v.name)
                end
                print("**************************************************")
    elseif altacc then
            local highest = highest_price_fruit[1].name
            replicatedstorage.Remotes.TradeFunction:InvokeServer("addItem", highest)
    end
end

if #getgenv().Setting["Main Accs"] == 0 or #getgenv().Setting["Alt Accs"] == 0 then
    ingame_notify("There is no account in main or alt accounts")
    error("There is no account in main or alt accounts")
end

get_main_and_alt_inserver()
get_fruit_value()
remove_useless_fruit()
start_trade()
