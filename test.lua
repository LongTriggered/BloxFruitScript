if not game:IsLoaded() then
    game.Loaded:Wait()
end

local default_config
if not _G.Setting then
    default_config = true
    _G.Setting    = {
        AutoFarmFruitFully             = true,
        WeaponToAttack      = "Melee", -- "Sword", "Melee", "FruitM1"
        Team                = "Marines",
        SkipFruitSetting = {
            FullStorage     = false,
            Common          = false,
            Uncommon        = false,
            Rare            = false,
            Legendary       = false,
            Mythical        = false,
                            },
        RandomFruit         = true,
        InstantTp           = true,
        NoUI                = false,
        WhiteScreen         = false,
        HopServer           = {["Enable"] = false, ["Wait Time"]   = 60},
        Webhook             = {["Enable"] = false, ["WebhookLink"] = ""}
    }
else
    default_config = false
end
---------------- variables
local workspace         = game:GetService('Workspace')
local PlayerService     = game:GetService('Players')
local replicatedstorage = game:GetService("ReplicatedStorage")
local TeleportService   = game:GetService("TeleportService")
local HttpService       = game:GetService("HttpService")
local RunService        = game:GetService("RunService")
local CollectionService = game:GetService("CollectionService")
local Player            = PlayerService.LocalPlayer
local farming           = false
local sf                = _G.Setting

local fruit_ids = {
    ["Rocket Fruit"] = "rbxassetid://15060012861",
    ["Spin Fruit"] = "rbxassetid://15057683975",
    ["Blade Fruit"] = "rbxassetid://15104782377",
    ["Spring Fruit"] = "rbxassetid://15105281957",
    ["Bomb Fruit"] = "rbxassetid://15116740364",
    ["Smoke Fruit"] = "rbxassetid://15116696973",
    ["Spike Fruit"] = "rbxassetid://15107005807",
    ["Flame Fruit"] = "rbxassetid://15111584216",
    ["Falcon Fruit"] = "rbxassetid://15112469964",
    ["Ice Fruit"] = "rbxassetid://15100433167",
    ["Sand Fruit"] = "rbxassetid://15111517529",
    ["Dark Fruit"] = "rbxassetid://15111553409",
    ["Diamond Fruit"] = "rbxassetid://15112600534",
    ["Light Fruit"] = "rbxassetid://15100283484",
    ["Rubber Fruit"] = "rbxassetid://15104817760",
    ["Barrier Fruit"] = "rbxassetid://15100485671",
    ["Ghost Fruit"] = "rbxassetid://15112333093",
    ["Magma Fruit"] = "rbxassetid://15105350415",
    ["Quake Fruit"] = "rbxassetid://15057718441",
    ["Buddha Fruit"] = "rbxassetid://15100313696",
    ["Love Fruit"] = "rbxassetid://15116730102",
    ["Spider Fruit"] = "rbxassetid://15116967784",
    ["Sound Fruit"] = "rbxassetid://14661873358",
    ["Phoenix Fruit"] = "rbxassetid://15100246632",
    ["Portal Fruit"] = "rbxassetid://15112215862",
    ["Rumble Fruit"] = "rbxassetid://15116747420",
    ["Pain Fruit"] = "rbxassetid://15116721173",
    ["Blizzard Fruit"] = "rbxassetid://15100384816",
    ["Gravity Fruit"] = "rbxassetid://15100299740",
    ["T-Rex Fruit"] = "rbxassetid://15708895165",
    ["Mammoth Fruit"] = "rbxassetid://14661837634",
    ["Dough Fruit"] = "rbxassetid://15100273645",
    ["Shadow Fruit"] = "rbxassetid://15112263502",
    ["Venom Fruit"] = "https://assetdelivery.roblox.com/v1/asset/?id=10395893751", -- Special deo biet tai sao
    ["Control Fruit"] = "rbxassetid://15100184583",
    ["Gas Fruit"] = "",
    ["Spirit Fruit"] = "",
    ["Leopard Fruit"] = "rbxassetid://15106768588",
    ["Yeti Fruit"] = "",
    ["Kitsune Fruit"] = "rbxassetid://15482881956",
    ["Dragon Fruit"] = "rbxassetid://115237822212661"
}
local fruitType = { --Done
  --  LoadedFruit = false,
    Factory = false, -- Done
    PirateRaid = false,
    Natural = false, -- Done
 --   DroppedFruit = false, -- Done--Done -- Done
 --   SeaEvent = false,
 --   Others = false,
    Random = false,
}

if Player.Team == nil then
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", tostring(sf.Team)) 
    print('remote join team called')
end

repeat task.wait() until game:GetService('Players').LocalPlayer.Team ~= nil
repeat task.wait() until game:GetService('Players').LocalPlayer.Character


local backpack = Player.Backpack
local Sea
local WaitPos
if game.PlaceId == 2753915549 then
    Sea, WaitPos  = 1, CFrame.new(0,0,0)
elseif game.PlaceId == 4442272183 then
    Sea, WaitPos = 2, CFrame.new(-372.479919, 142.649261, 250.736328, 0.990156472, -8.74954083e-08, 0.139964879, 9.28591817e-08, 1, -3.17916289e-08, -0.139964879, 4.4475712e-08, 0.990156472)
elseif game.PlaceId == 7449423635 then
	Sea, WaitPos = 3, CFrame.new(-5065.8525390625, 314.5509948730469, -3000.853515625)
end

function bypass_ac()
    for i, v in pairs((game:GetService("Players")).LocalPlayer.Character:GetDescendants()) do
        if v:IsA("LocalScript") then
            if v.Name == "General" or v.Name == "Shiftlock" or v.Name == "FallDamage" or v.Name == "4444" or v.Name == "CamBob" or v.Name == "JumpCD" or v.Name == "Looking" or v.Name == "Run" then
                v:Destroy();
            end;
        end;
    end;
    for i, v in pairs((game:GetService("Players")).LocalPlayer.PlayerScripts:GetDescendants()) do
        if v:IsA("LocalScript") then
            if v.Name == "RobloxMotor6DBugFix" or v.Name == "Clans" or v.Name == "Codes" or v.Name == "CustomForceField" or v.Name == "MenuBloodSp" or v.Name == "PlayerList" then
                v:Destroy();
            end;
        end;
    end;
end

function create_tag(instance, Name, Value)
    instance:SetAttribute(Name,Value)
end

function delayTask(taskname)
    fruitType[taskname] = true
    print('delayed '..taskname)
    task.wait(0.4)
    print('finish delayed '.. taskname .. "\n")
    fruitType[taskname] = false
end

function reword_fruit(Name)
    local Word = Name:split(" ")[1]
	return `{Word}-{Word}`
end

function character()
    return Player.Character or Player.CharacterAdded:Wait()
end

function get_inventory()
    return replicatedstorage.Remotes.CommF_:InvokeServer("getInventory")
end

local notify_module = require(game:GetService("ReplicatedStorage").Notification)
function ingame_notify(msg)
    notify_module.new("<Color=Yellow>"..msg.."<Color=/>"):Display()
end

local FruitCap = Player.Data.FruitCap.Value
local raritykey = {"Common", "Uncommon", "Rare","Legendary", "Mythical"}
function skip_fruit(FruitName) -- 0 = common, 1 = uncommon, 2 = rare, 3 = legendary, 4 = mythical 
        for _,v in pairs(get_inventory()) do
            if v.Type == "Blox Fruit" then
                if v.Name == reword_fruit(FruitName) then -- vd: Doi "Spider Fruit" -> "Spider-Spider"

                    if sf.SkipFruitSetting.FullStorage then
                        if v.Count >= FruitCap then
                            print('Skipped '..FruitName.." due to full storage")
                            return true
                        end
                    end

                    local keymap = raritykey[v.Rarity+1]
                    if keymap and sf.SkipFruitSetting[keymap] == true then
                        print('Skipped '..FruitName.." due to skip [".. keymap .. " Fruit]")
                        return true
                    end
                end
            end
        end
    return false
end

function get_natural_fruit_name(instance)
    if instance:FindFirstChild('Fruit') and not instance:FindFirstChild('EatRemote') then -- fruit tu nhien
        local found_fruit_name = false
        for fruitname, fruitid in pairs(fruit_ids) do --- quet fruitlist
            if instance.Fruit:FindFirstChild('Fruit') or instance.Fruit:FindFirstChild('Idle') then
                pcall(function()
                    if instance.Fruit.Fruit.MeshId == fruitid or instance.Fruit.Idle.AnimationId == fruitid then
                        found_fruit_name = true
                        instance.Name = tostring(fruitname)
                    end
                end)
            end
        end
        if not found_fruit_name then
            instance.Name = "Unknow Fruit"
        end
        print("******************************** New fruit spawned: ["..instance.Name.."] ********************************)")
        ingame_notify("New fruit spawned: ["..instance.Name.."]")
    end
end

function fire_handle(instance)
    local distance = (instance.Position - character().HumanoidRootPart.Position).Magnitude
    if distance >= 12 then
        return
    end
    firetouchinterest( character().HumanoidRootPart ,instance, 0) -- start
    task.wait()
    firetouchinterest( character().HumanoidRootPart ,instance, 1) -- end
end

function disable_seat()
    if character() and character():FindFirstChild('Humanoid') and character().Humanoid.Health > 0 then
    character():FindFirstChild('Humanoid').Sit = false
    end
end

function anti_afk()
    Player.Idled:connect(function() -- Anti Afk
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):Button1Down(Vector2.new(0, 0))
        wait(1)
        game:GetService("VirtualUser"):Button1Up(Vector2.new(0, 0))
    end)
end

function create_force()
    if not character().HumanoidRootPart:FindFirstChild("BodyClip") then
        local Force    = Instance.new("BodyVelocity")
        Force.Name     = "BodyClip"
        Force.Parent   = character().HumanoidRootPart
        Force.MaxForce = Vector3.new(100000,100000,100000)
        Force.Velocity = Vector3.new(0,0,0)
    end
end
    
function remove_force()
    if  character().HumanoidRootPart:FindFirstChild("BodyClip") then
        character().HumanoidRootPart:FindFirstChild("BodyClip"):Destroy()
    end
end

local tweening
function tp(targetCFrame, InstantTp)
    if not character():FindFirstChild('Humanoid') or character().Humanoid.Health <= 0 then
        return
    end
    disable_seat()
    if tweening then
        tweening:Cancel()
    end

    if InstantTp then
            if tweening then
                tweening:Cancel()
                task.wait(1)
            end
            character().HumanoidRootPart.CFrame = targetCFrame
        return
    end

    local targetPosition = targetCFrame.Position
    local playerPosition = character().HumanoidRootPart.Position
    -- local direction = (targetPosition - playerPosition).Unit
    local distance = (targetPosition - playerPosition).Magnitude
    local tp_speed = 200
        if distance <= 45 then
            tp_speed = 10000000
        elseif distance < 50 then
            tp_speed = 2000
        elseif distance < 150 then
            tp_speed = 800
        elseif distance < 250 then
            tp_speed = 600
        elseif distance < 500 then
            tp_speed = 400
        elseif distance < 750 then
            tp_speed = 360
        elseif distance >= 1000 then
            tp_speed = 360
        end
        create_force()
        character().HumanoidRootPart.CFrame = CFrame.new(playerPosition.X, targetPosition.Y, playerPosition.Z)
        tweening =  game:GetService("TweenService"):Create(
                    character().HumanoidRootPart,
                    TweenInfo.new(distance/tp_speed, Enum.EasingStyle.Linear),
                    {CFrame = targetCFrame})

        tweening:Play()
        -- Tween.Completed:Connect(function(status)
        -- if status == Enum.PlaybackState.Completed then
        -- end
        -- end)
end

function tp_stable(targetCFrame, InstantTp)
    if not character():FindFirstChild('Humanoid') or character().Humanoid.Health <= 0 then
        return
    end

    if tweening then
        tweening:Cancel()
    end

    if InstantTp then
            if tweening then
                tweening:Cancel()
                task.wait(1)
            end
            character().HumanoidRootPart.CFrame = targetCFrame
        return
    end

    local targetPosition = targetCFrame.Position
    local playerPosition = character().HumanoidRootPart.Position
    -- local direction = (targetPosition - playerPosition).Unit
    local distance = (targetPosition - playerPosition).Magnitude
    local tp_speed = 360
        create_force()
        character().HumanoidRootPart.CFrame = CFrame.new(playerPosition.X, targetPosition.Y, playerPosition.Z)
        tweening =  game:GetService("TweenService"):Create(
                    character().HumanoidRootPart,
                    TweenInfo.new(distance/tp_speed, Enum.EasingStyle.Linear),
                    {CFrame = targetCFrame})

        tweening:Play()
        tweening.Completed:Connect(function(status)
            if status == Enum.PlaybackState.Completed then
                character().Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
end

function stop_tween()
    if tweening then
        tweening:Cancel()
        remove_force()
    end
end    

function check_tp()
    task.spawn(function()
        task.wait(10)
        local LastPos = character().HumanoidRootPart.Position
        while task.wait() do
            if tweening then
                if (LastPos-character().HumanoidRootPart.Position).Magnitude > 350 then
                    stop_tween()
                    task.wait(0.5)
                end
               LastPos = character().HumanoidRootPart.Position
            end
        end
    end)
end

function noclip()
    RunService.Stepped:Connect(function()
        if sf.AutoFarmFruitFully and tweening then
            for _, Item in pairs(character():GetDescendants()) do
                if Item:IsA("BasePart") then
                    Item.CanCollide = false
                end
            end
        end
    end)
end

-- function table_remove(tbl, pos)
--     local value = tbl[pos]
--     for i = pos, #tbl - 1 do
--         tbl[i] = tbl[i + 1]
--     end
--     tbl[#tbl] = nil
--     return value
-- end

function createTag(instance, Name, Value)
    instance:SetAttribute(Name, Value)
  end

function fileCreate(filename,table)
    writefile(Player.Name.. "_" ..filename.. ".json", HttpService:JSONEncode(table))
end

function sendJson(filename,data)
    fileCreate(filename,data)
    local fileData = readfile(Player.Name.. "_" ..filename.. ".json")
    -- URL avatar
    local AvatarUrl = "https://i.imgur.com/OBqZkBq.png" -- Thay bằng URL avatar của bạn

    -- Tạo nội dung body của yêu cầu với multipart/form-data
    local boundary = "------------------------" .. HttpService:GenerateGUID(false)
    local body = "--" .. boundary .. "\r\n"
        .. "Content-Disposition: form-data; name=\"file\"; filename=\"" .. Player.Name.. "_" ..filename.. ".json" .. "\"\r\n"
        .. "Content-Type: application/json\r\n\r\n"
        .. fileData .. "\r\n"
        .. "--" .. boundary .. "\r\n"
        .. "Content-Disposition: form-data; name=\"avatar_url\"\r\n\r\n"
        .. AvatarUrl .. "\r\n"
        .. "--" .. boundary .. "--"

    -- Định nghĩa headers
    local headers = {
        ["Content-Type"] = "multipart/form-data; boundary=" .. boundary,
        ["Content-Length"] = tostring(#body),
    }

    -- Gửi yêu cầu HTTP
    local requestFunction = http_request or request or HttpPost
    if requestFunction then
        local response = requestFunction({
            Url = sf.Webhook.WebhookLink or DiscordWebhookUrl or "",
            Method = "POST",
            Headers = headers,
            Body = body,
        })

        -- Hiển thị phản hồi để kiểm tra lỗi hoặc thành công
        if response then
            if tonumber(response.StatusCode) < 400 then
            print("Trạng thái: Successfully Excuted")
            game:GetService'StarterGui':SetCore("SendNotification", {
                Title = "Shin dep trai", -- Notification title
                Text = "Sent Data Successfully", -- Notification text
                Icon = "https://i.imgur.com/LOkRYqi.png", -- Notification icon (optional)
                Duration = 5, -- Duration of the notification (optional, may be overridden if more than 3 notifs appear)
                })
            else
            print("Trạng thái: Webhook failed")
            end
        else
            print("Không nhận được phản hồi từ máy chủ.")
        end
    else
        print("Không tìm thấy hàm gửi HTTP!")
    end
end

function store_fruit(FruitName)
    pcall(function()
            task.wait(1)
            if FruitName:FindFirstChild('EatRemote') and sf.AutoFarmFruitFully then
                print("storing "..FruitName.Name)
                replicatedstorage.Remotes.CommF_:InvokeServer("StoreFruit", reword_fruit(FruitName.Name), FruitName)
            end
        end)
end

function new_fruit_added(container)
    container.ChildAdded:Connect(function(child)
        spawn(function()
            checkFruitOrigin(child)
            store_fruit(child)
        end)
    end)
end

function enable_buso()
    if not character():FindFirstChild('HasBuso') then
        return replicatedstorage.Remotes.CommF_:InvokeServer("Buso")
    end
end

function set_property()
    sethiddenproperty(Player,"SimulationRadius",math.huge)
end

local currentEquippedWeapon = nil
function equip_tool()
    for i,v in pairs(backpack:GetChildren()) do
        if v:IsA("Tool") then
            if (v.ToolTip == sf.WeaponToAttack) or (sf.WeaponToAttack == "FruitM1" and v.ToolTip == "Blox Fruit") then
                character():FindFirstChild('Humanoid'):EquipTool(v)
                currentEquippedWeapon = v.Name
                return true
            end
        end
    end
    return false
end

local combat_module = require(replicatedstorage.Modules.Net)
local register_attack = replicatedstorage.Modules.Net:WaitForChild("RE/RegisterAttack")
local register_hit = combat_module:RemoteEvent("RegisterHit")
local combat_controller = require(replicatedstorage.Controllers.CombatController)

function hit()
    if not equip_tool() then return end
    enable_buso()
    combat_controller:Attack(character():FindFirstChild(currentEquippedWeapon),nil)
end

local is_hopping = false
local hop_counting_time = "Getting hopserver data"
function hop()
    if not sf.HopServer["Enable"] or is_hopping then
        return
    end

    local function serverhop_function() --- inf yield server  hop
        local servers = {}
        local req = http_request({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", game.PlaceId)})
        local body = HttpService:JSONDecode(req.Body)

        if body and body.data then
            for i, v in next, body.data do
                if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                    table.insert(servers, 1, v.id)
                end
            end
        end

        while #servers > 0 and task.wait(1) do
            TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], game.Players.LocalPlayer)
        end
    end

    -- local function serverhop_function() --normal server hop
    --     local PlaceID = game.PlaceId
    --     local AllIDs = {}
    --     local foundAnything = ""
    --     local actualHour = os.date("!*t").hour
    --     local Deleted = false
    --     function TPReturner()
    --         local Site;
    --         if foundAnything == "" then
    --             Site = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100'))
    --         else
    --             Site = HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Asc&limit=100&cursor=' .. foundAnything))
    --         end
    --         local ID = ""
    --         if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
    --             foundAnything = Site.nextPageCursor
    --         end
    --         local num = 0;
    --         for i,v in pairs(Site.data) do
    --             local Possible = true
    --             ID = tostring(v.id)
    --             if tonumber(v.maxPlayers) > tonumber(v.playing) then
    --                 for _,Existing in pairs(AllIDs) do
    --                     if num ~= 0 then
    --                         if ID == tostring(Existing) then
    --                             Possible = false
    --                         end
    --                     else
    --                         if tonumber(actualHour) ~= tonumber(Existing) then
    --                             local delFile = pcall(function()                                
    --                                 AllIDs = {}
    --                                 table.insert(AllIDs, actualHour)
    --                             end)
    --                         end
    --                     end
    --                     num = num + 1
    --                 end
    --                 if Possible == true then
    --                     table.insert(AllIDs, ID)
    --                     wait(.1)
    --                     pcall(function()
                            
    --                         wait()
    --                         TeleportService:TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
    --                     end)
    --                     wait(.1)
    --                 end
    --             end
    --         end
    --     end
    --     function Teleport() 
    --         while wait(.1) do
    --             pcall(function()
    --                 TPReturner()
    --                 if foundAnything ~= "" then
    --                     TPReturner()
    --                 end
    --             end)
    --         end
    --     end
    --     Teleport()
    -- end

    is_hopping = true
    task.spawn(function()
        for i = sf.HopServer["Wait Time"] , 0, -1 do
            hop_counting_time = "Waiting to hop server..."..tostring(i).."s"
            task.wait(1)
        end

        if farming == true or not sf.HopServer["Enable"] then
            is_hopping = false
            status_label:Refresh("Hopping cancelled")
            return
        end
        hop_counting_time = "Hopping"
        serverhop_function()
    end)
end

function random_fruit()
    task.spawn(function()
        task.wait(4)
        while task.wait(10) do
            if sf.RandomFruit and sf.AutoFarmFruitFully and not farming then
                for _, v in pairs(fruitType) do
                    if v == true then
                        return
                    end
                end
                replicatedstorage.Remotes.CommF_:InvokeServer("Cousin","Buy")
                delayTask("Random")
            end
        end
    end)
end

function farm_utility(v)
    v.Humanoid.WalkSpeed = 0
    v.Humanoid.JumpPower = 0
    v.HumanoidRootPart.CanCollide = false
    v.Head.CanCollide = false
    v.Humanoid:ChangeState(11)
    v.HumanoidRootPart.CanQuery = false
    v.HumanoidRootPart.Size = Vector3.new(64, 64, 64)
    if v.Humanoid:FindFirstChild('Animator') then
        v.Humanoid.Animator:Destroy();
    end
    if not v.HumanoidRootPart:FindFirstChild("Lock") then
        local lock = Instance.new("BodyVelocity")
        lock.Parent = v.HumanoidRootPart
        lock.Name = "Lock"
        lock.MaxForce = Vector3.new(100000, 100000, 100000)
        lock.Velocity = Vector3.new(0, 0, 0)
    end
    if v:FindFirstChild('Busy') then
        v.Busy.Value = true
    end
    if v:FindFirstChild('Stun') then
        v.Stun.Value = 1;
    end;
    set_property()
end

function finding_fruit()
    for _,v in pairs(workspace:GetChildren()) do
        if v:FindFirstChild("Fruit") and v:FindFirstChild('Handle') then

            if skip_fruit(v.Name) then
                continue
            end

            local natural = false
            if not v:FindFirstChild("EatRemote") then
                natural = true
                task.wait(10)
            end 

            status_label:Refresh("Teleporting to "..v.Name)
            repeat
                pcall(function()
                    tp(v.Handle.CFrame, sf.InstantTp)
                   -- fire_handle(v.Handle)
                    farming = true
                    disable_seat()
                end)
                RunService.Heartbeat:wait()
            until not sf.AutoFarmFruitFully or not v or v.Parent ~= workspace

            if natural then
                delayTask("Natural")
            end            
            task.wait(1)
        end
    end
    farming = false
    hop()
end

function update_label()
    if not is_hopping or not sf.HopServer["Enable"] then
        task.spawn(function()
            for i=1,3 do
                task.wait(.3)
                status_label:Refresh("Waiting"..string.rep("." , i).."\n".."Time after joined server: "..tostring(math.round(time()))..'s')
            end
        end)
    else
        status_label:Refresh(hop_counting_time)
    end  
end

function auto_fruit_sea1()
    for _,v in pairs(workspace:GetChildren()) do
        if v:FindFirstChild("Fruit") and v:FindFirstChild('Handle') then

            if skip_fruit(v.Name) then
                continue
            end

            local natural = false
            if not v:FindFirstChild("EatRemote") then
                natural = true
            end 

            repeat RunService.Heartbeat:wait()
                pcall(function()
                    tp(v.Handle.CFrame, sf.InstantTp)
                    fire_handle(v.Handle)
                    farming = true
                    disable_seat()
                    status_label:Refresh("Teleporting to "..v.Name)
                end)
            until not sf.AutoFarmFruitFully or not v or v.Parent ~= workspace

            if natural then
                delayTask("Natural")
            end
            task.wait(1)
        end
    end

    farming = false
    disable_seat()
    hop()
    if not is_hopping then
        task.spawn(function()
            for i=1,3 do
                task.wait(.3)
                status_label:Refresh("Waiting"..string.rep("." , i).."\n".."Time after joined server: "..tostring(math.round(time()))..'s')
            end
        end)
    else
        status_label:Refresh(hop_counting_time)
    end  
end

function auto_fruit_sea2()
    for _,v in pairs(workspace.Enemies:GetChildren()) do
        if v.Name == "Core" and v:FindFirstChild('Humanoid') and v.Humanoid.Health > 0 then 

            repeat task.wait(1e-9)
                pcall(function()
                    farming = true   
                    tp(CFrame.new(426.444153, 178.586456, -429.883057))
                    equip_tool()
                    enable_buso()
                    disable_seat()
                    set_property()
                    hit()
                    status_label:Refresh("Attacking Factory ")
                end)
            until not sf.AutoFarmFruitFully or not v.Parent or (v:FindFirstChild('Humanoid') and v.Humanoid.Health <= 0)

            delayTask("Factory")
        end
    end
    for _,v in pairs(workspace:GetChildren()) do
        if v:FindFirstChild("Fruit") and v:FindFirstChild('Handle') then

            if skip_fruit(v.Name) then
                continue
            end

            local natural = false
            if not v:FindFirstChild("EatRemote") then
                natural = true
            end 

            repeat RunService.Heartbeat:wait()
                pcall(function()
                    tp(v.Handle.CFrame, sf.InstantTp)
                    fire_handle(v.Handle)
                    farming = true
                    disable_seat()
                    status_label:Refresh("Teleporting to "..v.Name)
                end)
            until not sf.AutoFarmFruitFully or not v or v.Parent ~= workspace

            if natural then
                delayTask("Natural")
            end        
            task.wait(1)
        end
    end

    farming = false
    disable_seat()
    tp(WaitPos)
    hop()
    if not is_hopping then
        task.spawn(function()
            for i=1,3 do
                task.wait(.3)
            status_label:Refresh("Waiting"..string.rep("." , i).."\n".."Time after joined server: "..tostring(math.round(time()))..'s')
            end
        end)
    else
        status_label:Refresh(hop_counting_time)
    end
end


local PirateRaid = false
task.spawn(newcclosure(function()
    local ChatFrame = Player.PlayerGui.Chat.Frame.ChatChannelParentFrame.Frame_MessageLogDisplay.Scroller
    ChatFrame.ChildAdded:Connect(function(child)
        task.spawn(function()
            local label = child:FindFirstChild("TextLabel")
            if label and label.Text == "Pirates have been spotted approaching the castle!" then
                PirateRaid = true
            end
            if label and label.Text == "Good job! Anybody who defeated at least 1 pirate" then
                PirateRaid = false
            end
        end)
    end)
end))

local PirateRaidMob = {
      "Galley Pirate", "Galley Captain", "Raider", "Mercenary",
    "Vampire", "Zombie", "Snow Trooper", "Winter Warrior",
    "Lab Subordinate", "Horned Warrior", "Magma Ninja", "Lava Pirate",
    "Ship Deckhand", "Ship Engineer", "Ship Steward", "Ship Officer",
    "Arctic Warrior", "Snow Lurker", "Sea Soldier", "Water Fighter"
}

function auto_fruit_sea3()
    if (WaitPos.Position - character().HumanoidRootPart.Position).Magnitude > 1000 then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-5065.8525390625, 314.5509948730469, -3000.853515625))
        tp(WaitPos)
    end
    while task.wait() do
        if PirateRaid then
            if (WaitPos.Position - character().HumanoidRootPart.Position).Magnitude > 1000 then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance",Vector3.new(-5065.8525390625, 314.5509948730469, -3000.853515625))
                tp(WaitPos)
            end
        end
        if workspace.Enemies:FindFirstChild("Galley Pirate") or workspace.Enemies:FindFirstChild("Galley Captain") or workspace.Enemies:FindFirstChild("Raider") or workspace.Enemies:FindFirstChild("Mercenary") or workspace.Enemies:FindFirstChild("Vampire") or workspace.Enemies:FindFirstChild("Zombie") or workspace.Enemies:FindFirstChild("Snow Trooper") or workspace.Enemies:FindFirstChild("Winter Warrior") or workspace.Enemies:FindFirstChild("Lab Subordinate") or workspace.Enemies:FindFirstChild("Horned Warrior") or workspace.Enemies:FindFirstChild("Magma Ninja") or workspace.Enemies:FindFirstChild("Lava Pirate") or workspace.Enemies:FindFirstChild("Ship Deckhand") or workspace.Enemies:FindFirstChild("Ship Engineer") or workspace.Enemies:FindFirstChild("Ship Steward") or workspace.Enemies:FindFirstChild("Ship Officer") or workspace.Enemies:FindFirstChild("Arctic Warrior") or workspace.Enemies:FindFirstChild("Snow Lurker") or workspace.Enemies:FindFirstChild("Sea Soldier") or workspace.Enemies:FindFirstChild("Water Fighter") then
            for _,v in pairs(workspace.Enemies:GetChildren()) do
                if table.find(PirateRaidMob, v.Name) then
                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('HumanoidRootPart') then
                        local Tanky = false
                        if v.HumanoidRootPart:FindFirstChild('TankyParticles') then
                            Tanky = true
                        end
                        repeat task.wait(1e-9)
                            pcall(function()
                                farming = true               
                                tp(v.HumanoidRootPart.CFrame * CFrame.new(0, -30, 0))
                                farm_utility(v)
                                hit()
                                status_label:Refresh("Attacking Pirate Raid ")
                            end)
                        until not sf.AutoFarmFruitFully or not v.Parent or (v:FindFirstChild('Humanoid') and v.Humanoid.Health <= 0)
                        if not Tanky then
                            tp(WaitPos * CFrame.new(0,-50,0))
                            else
                            delayTask("PirateRaid")
                        end
                    end
                end
            end
        else
            finding_fruit()
            update_label()
        end
    end
end

function start_main_farm()
    task.spawn(function()
        if sf.AutoFarmFruitFully then
            if Sea == 1 then
                auto_fruit_sea1()
            elseif Sea == 2 then
                auto_fruit_sea2()
            elseif Sea == 3 then
                auto_fruit_sea3()
            end
        end
    end)
end

function start_farm_chest()
    task.spawn(function()
        while task.wait() do
            if sf.AutoFarmChest and not farming and not PirateRaid then
                local Position = character():GetPivot().Position
                local Chests = CollectionService:GetTagged("_ChestTagged")
                local Distance, Nearest = math.huge
                for i = 1, #Chests do
                    local Chest = Chests[i]
                    local Magnitude = (Chest:GetPivot().Position - Position).Magnitude
                    if (not Chest:GetAttribute("IsDisabled") and (Magnitude < Distance)) then
                        Distance, Nearest = Magnitude, Chest
                    end
                end
                if Nearest then
                    local ChestPosition = Nearest:GetPivot().Position
                    local CFrameTarget = CFrame.new(ChestPosition)
                    tp_stable(CFrameTarget)
                end
            end
	    end
    end)
end

------------------------------------------------- FruitNotifier
function get_dropped_fruit(instance) -- Check Fruit tu nhien va fruit drop
if sf.Webhook.Enable then
        if instance:FindFirstChild("Fruit") and instance:FindFirstChild('EatRemote') then -- check xem phai fruit da drop ko
            createTag(instance , "FruitSource", "DroppedFruit")
        end
    end
end

function checkFruitOrigin(FruitName)
    if sf.Webhook.Enable then
        task.wait(0.2)
        if FruitName:FindFirstChild("Fruit") and not FruitName:GetAttribute("Notify") then
            for i,v in pairs(fruitType) do
                if v == true then
                    createTag(FruitName, "Notify", true) -- check may cai con lai
                    return sendJson("NewFruit", {Name = (FruitName.Name) , Source = i} ) ,          print((FruitName.Name)..' from: '..i)
                end
            end
            if FruitName:GetAttribute("FruitSource") == "DroppedFruit" then -- check fruit drop
                createTag(FruitName, "Notify", true)
                return sendJson("NewFruit", {Name = (FruitName.Name) , Source = "DroppedFruit"} ) , print((FruitName.Name).." duoc drop")
            end
        end
    end
end

------------- UI
local DiscordLib = loadstring(game:HttpGet"https://raw.githubusercontent.com/LongTriggered/BloxFruitScript/refs/heads/main/UILIB")()

local win = DiscordLib:Window("Shin Fully Fruit Auto Farm ( dawid#7205's UI Library)")

local serv = win:Server("Status", "imagelink")

local lbls = serv:Channel("Main Status")

status_label = lbls:Label("Shin dep trai",Color3.fromRGB(255, 204, 255))


local mainui = win:Server("Main", "http://www.roblox.com/asset/?id=6031075938")
local channel_mainui = mainui:Channel("Auto Farm")

channel_mainui:Toggle("Fully Auto Farm Fruit( Stackable )", sf.AutoFarmFruitFully, function(bool)
    sf.AutoFarmFruitFully = bool
    if not bool then
        task.wait(0.5)
        stop_tween()
    end
end)

channel_mainui:Toggle("Auto Farm Chest ( Stackable )", sf.AutoFarmChest, function(bool)
    sf.AutoFarmChest = bool
    if not bool then
        task.wait(0.5)
        stop_tween()
    end
end)

channel_mainui:Toggle("White Screen", sf.WhiteScreen, function(bool)
    sf.WhiteScreen = bool
    RunService:Set3dRenderingEnabled(not bool)
end)

local input_jobid = ""
channel_mainui:Textbox("Job Id", "Shin dep trai vkl",  false,  function(t)       
    input_jobid = t
end)

channel_mainui:Button("Join server with input job id", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, input_jobid, Player)
end)

local sea_teleport_remote = {
    [1] = "TravelMain",
    [2] = "TravelDressrosa",
    [3] = "TravelZou"
}

for i = 1,3 do
    if i ~= Sea then
        channel_mainui:Button("Teleport to Sea "..i, function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(sea_teleport_remote[i])
        end)
    end
end

local setting_mainui = mainui:Channel("Settings")

setting_mainui:Dropdown("Weapon to attack", {"Melee", "Blox Fruit ( Fruit M1 )", "Sword"}, function(bool)
    if bool == "Blox Fruit ( Fruit M1 )" then
        sf.WeaponToAttack = "FruitM1"
    else
        sf.WeaponToAttack = bool
    end
end)

setting_mainui:Toggle("Random fruit", sf.RandomFruit, function(bool)
    sf.RandomFruit = bool
end)

setting_mainui:Toggle("Hop Server", sf.HopServer["Enable"], function(bool)
    sf.HopServer["Enable"] = bool
end)

setting_mainui:Toggle("Instant TP", sf.InstantTp, function(bool)
    sf.InstantTp = bool
end)

setting_mainui:Toggle("Webhook", sf.Webhook.Enable, function(bool)
    sf.Webhook.Enable = bool
end)

setting_mainui:Label("Skip Fruit Options")

setting_mainui:Toggle("Full Storage", sf.SkipFruitSetting.FullStorage, function(bool)
    sf.SkipFruitSetting.FullStorage = bool
end)

setting_mainui:Toggle("Common", sf.SkipFruitSetting.Common, function(bool)
    sf.SkipFruitSetting.Common = bool
end)

setting_mainui:Toggle("Uncommon", sf.SkipFruitSetting.Uncommon, function(bool)
    sf.SkipFruitSetting.Uncommon = bool
end)

setting_mainui:Toggle("Rare", sf.SkipFruitSetting.Rare, function(bool)
    sf.SkipFruitSetting.Rare = bool
end)

setting_mainui:Toggle("Legendary", sf.SkipFruitSetting.Legendary, function(bool)
    sf.SkipFruitSetting.Legendary = bool
end)

setting_mainui:Toggle("Mythical", sf.SkipFruitSetting.Mythical, function(bool)
    sf.SkipFruitSetting.Mythical = bool
end)

Player.CharacterAdded:Connect(function(char) -- Refresh character với backpack khi player die
    new_fruit_added(char)
    new_fruit_added(Player:FindFirstChild("Backpack"))
    backpack = Player:FindFirstChild("Backpack")
    enable_buso()
end)

if Player.Character then -- lần đầu
    new_fruit_added(Player.Character)
    new_fruit_added(Player:FindFirstChild("Backpack"))
end

workspace.ChildAdded:Connect(function(instance)
    task.spawn(function()
        get_natural_fruit_name(instance)
        get_dropped_fruit(instance)
    end)
end)

for i,v in pairs(workspace:GetChildren()) do -- First check
    get_dropped_fruit(v)
    get_natural_fruit_name(v)
end

random_fruit()
noclip()
check_tp()
enable_buso()
start_main_farm()
start_farm_chest()
bypass_ac()
anti_afk()

for i,v in pairs(workspace:GetChildren()) do
    if v:FindFirstChild('Fruit') then
        ingame_notify("Fruit trong server: "..v.Name.."\n")
    end
end
if default_config then
    ingame_notify('Loaded default config')
    else
    ingame_notify('Loaded provided config')
end

ingame_notify('FIXED ATTACK ')
