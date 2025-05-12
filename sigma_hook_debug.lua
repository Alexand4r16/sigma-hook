print("Script started")
local success, err = pcall(function()
    local Decimals = 4
    local Clock = os.clock()

    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")
    local HttpService = game:GetService("HttpService")

    -- Anti-Ban: Обфускация переменных
    getgenv().sigma_hook = {
        enabled = true,
        version = "v1",
        anti_ban = {
            spoof_id = HttpService:GenerateGUID(false),
            random_delay = function() return math.random(0.05, 0.15) end,
            max_cframe_change = 0.1, -- Максимальное изменение позиции за кадр
        }
    }

    print("Loading Tokyo UI Library...")
    local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/drillygzzly/Roblox-UI-Libs/main/1%20Tokyo%20Lib%20(FIXED)/Tokyo%20Lib%20Source.lua"))({
        cheatname = "sigma.hook",
        gamename = "fallen",
    })
    print("Library loaded")

    library:init()

    local Window1 = library.NewWindow({
        title = "sigma.hook | v1",
        size = UDim2.new(0, 510, 0.6, 6)
    })

    local assist = Window1:AddTab("  Assist  ")
    local visual = Window1:AddTab("  Visual  ")
    local misc = Window1:AddTab("  Misc  ")
    local SettingsTab = library:CreateSettingsTab(Window1)

    local Section1 = assist:AddSection("Aim Bot Settings", 1)
    local Section2 = assist:AddSection("Misc", 2)
    local Section3 = visual:AddSection("Player esp", 1)
    local Section4 = visual:AddSection("World esp", 2)
    local Section8 = visual:AddSection("Bots esp", 3)
    local Section5 = misc:AddSection("Rage", 1)
    local Section6 = misc:AddSection("Visuals", 2)
    local Section7 = misc:AddSection("Gun Mods", 3)

    -- Adding aimbot controls to Section1 (Aim Bot Settings)
    Section1:AddToggle({
        text = "Aimbot",
        flag = "aimbot_toggle",
        callback = function(state)
            library:SendNotification("Aimbot " .. (state and "Enabled" or "Disabled"), 6)
        end
    })

    Section1:AddBind({
        enabled = true,
        text = "Aimbot Keybind",
        tooltip = "Hold to activate Aimbot",
        mode = "hold",
        bind = "V",
        flag = "aimbot_bind",
        state = false,
        nomouse = false,
        risky = false,
        noindicator = false,
        callback = function(state)
            library.flags.aimbot_toggle = state
        end
    })

    Section1:AddSlider({
        text = "Aimbot Speed",
        flag = "aimbot_speed",
        min = 0,
        max = 1,
        value = 0.5,
        increment = 0.05
    })

    Section1:AddToggle({
        text = "FOV Circle",
        flag = "fov_circle_toggle",
        callback = function(state)
            library:SendNotification("FOV Circle " .. (state and "Enabled" or "Disabled"), 6)
        end
    })

    Section1:AddSlider({
        text = "FOV Radius",
        flag = "fov_radius",
        min = 0,
        max = 500,
        value = 100,
        increment = 1
    })

    -- Adding mod check to Section2 (Misc)
    local activeConnections = {}

    local function mod_check(player)
        if not player:IsDescendantOf(game) then
            return false
        end
        local role = player:GetRoleInGroup(1154360)
        if table.find({ "Game Moderator", "Developer", "Lead Developer", "Co-Founder", "Founder" }, role) then
            return true, role
        end
        return false
    end

    Section2:AddToggle({
        text = "Mod Check",
        flag = "mod_check",
        callback = function(enabled)
            if enabled then
                local messages = {}
                for _, player in ipairs(Players:GetPlayers()) do
                    local isMod, rank = mod_check(player)
                    if isMod then
                        table.insert(messages, rank .. " already in game! - " .. player.Name)
                    end
                end
                if #messages > 0 then
                    library:SendNotification(table.concat(messages, "\n"), 6)
                end
                table.insert(activeConnections, Players.PlayerAdded:Connect(function(player)
                    local isMod, rank = mod_check(player)
                    if isMod and library.flags.mod_check then
                        library:SendNotification(rank .. " joined - " .. player.Name, 6)
                    end
                end))
                table.insert(activeConnections, Players.PlayerRemoving:Connect(function(player)
                    local isMod, rank = mod_check(player)
                    if isMod and library.flags.mod_check then
                        library:SendNotification(rank .. " left - " .. player.Name, 6)
                    end
                end))
            else
                for _, connection in ipairs(activeConnections) do
                    connection:Disconnect()
                end
                activeConnections = {}
            end
        end
    })

    -- Adding toggles, sliders to Section3 (Player ESP)
    Section3:AddToggle({ text = "Enable ESP", flag = "enable_esp" })
    Section3:AddToggle({ text = "Show Name", flag = "show_name" })
    Section3:AddToggle({ text = "Show Box", flag = "show_box" })
    Section3:AddToggle({ text = "Show Distance", flag = "show_distance" })
    Section3:AddToggle({ text = "Show Weapon", flag = "show_weapon" })
    Section3:AddToggle({ text = "Show Health", flag = "show_health" })
    Section3:AddToggle({ text = "Show Tracer", flag = "show_tracer" })
    Section3:AddToggle({ text = "Show Head", flag = "show_head" })
    Section3:AddToggle({ text = "Enable Skeletons", flag = "enable_skeletons" })
    Section3:AddSlider({ text = "Skeleton Thickness", flag = "skeleton_thickness", min = 1, max = 5, value = 2 })

    -- Adding Bots ESP to Section8
    Section8:AddToggle({ text = "Soldier Name", flag = "soldier_Name" })
    Section8:AddToggle({ text = "Boss Name", flag = "boss_Name" })
    Section8:AddToggle({ text = "Show Health", flag = "soldier_Health" })
    Section8:AddToggle({ text = "Show Distance", flag = "soldier_Distance" })
    Section8:AddColor({ text = "Soldier Color", flag = "soldier_Color", value = Color3.fromRGB(255, 255, 255) })
    Section8:AddColor({ text = "Boss Color", flag = "boss_Color", value = Color3.fromRGB(255, 0, 0) })

    -- Adding toggles, binds, and sliders to Section5 (Rage)
    Section5:AddToggle({ text = "Fly", flag = "fly_toggle" })
    Section5:AddBind({
        enabled = true,
        text = "Fly Keybind",
        mode = "hold",
        bind = "E",
        flag = "fly_bind",
        callback = function(state)
            library.flags.fly_bind = state
        end
    })
    Section5:AddSlider({ text = "Fly Speed", flag = "fly_speed_value", min = 0, max = 70, value = 30 })
    Section5:AddToggle({ text = "Manipulation", flag = "manipulation_toggle" })
    Section5:AddBind({
        enabled = true,
        text = "Manipulation Keybind",
        mode = "toggle",
        bind = "M",
        flag = "manipulation_bind",
        callback = function(state)
            library.flags.manipulation_bind = state
        end
    })
    Section5:AddToggle({ text = "No Clip", flag = "noclip" })
    Section5:AddBind({
        enabled = true,
        text = "No Clip Keybind",
        mode = "hold",
        bind = "N",
        flag = "noclip_key",
        callback = function(state)
            library.flags.noclip_key = state
        end
    })
    Section5:AddToggle({ text = "Underground", flag = "underground_toggle" })
    Section5:AddBind({
        enabled = true,
        text = "Underground Keybind",
        mode = "toggle",
        bind = "V",
        flag = "underground_bind",
        callback = function(state)
            library.flags.underground_bind = state
        end
    })

    -- Adding toggles, binds, and sliders to Section6 (Visuals)
    Section6:AddToggle({ text = "Free Cam", flag = "free_cam_toggle" })
    Section6:AddBind({
        enabled = true,
        text = "Free Cam Keybind",
        mode = "hold",
        bind = "F",
        flag = "free_cam_bind",
        callback = function(state)
            library.flags.free_cam_bind = state
        end
    })
    Section6:AddSlider({ text = "Free Cam Speed", flag = "free_cam_speed", min = 0, max = 10, value = 5 })
    Section6:AddSlider({ text = "Free Cam Sensitivity", flag = "free_cam_sensitivity", min = 0, max = 1, value = 0.5 })
    Section6:AddToggle({ text = "Third Person Key", flag = "third_person_toggle" })
    Section6:AddBind({
        enabled = true,
        text = "Third Person Keybind",
        mode = "hold",
        bind = "T",
        flag = "third_person_bind",
        callback = function(state)
            library.flags.third_person_bind = state
        end
    })
    Section6:AddSlider({ text = "Third Person Distance", flag = "third_person_distance", min = 1, max = 10, value = 5, increment = 0.1 })
    Section6:AddToggle({ text = "Camera FOV", flag = "camera_fov_toggle" })
    Section6:AddSlider({ text = "Camera FOV Value", flag = "camera_fov_value", min = 30, max = 120, value = 70, increment = 1 })
    Section6:AddToggle({ text = "Zoom", flag = "zoom_toggle" })
    Section6:AddBind({
        enabled = true,
        text = "Zoom Keybind",
        mode = "hold",
        bind = "Z",
        flag = "zoom_bind",
        callback = function(state)
            library.flags.zoom_bind = state
        end
    })
    Section6:AddSlider({ text = "Zoom Value", flag = "zoom_value", min = 10, max = 60, value = 30, increment = 1 })

    -- Gun Mods Logic
    local gun_mods = {
        old_recoil1 = nil,
        old_recoil2 = nil,
        old_spread = {},
        old_fire_rate = {},
    }

    Section7:AddToggle({
        text = "No Recoil",
        flag = "no_recoil_toggle",
        callback = function(state)
            library:SendNotification("No Recoil " .. (state and "Enabled" or "Disabled"), 6)
            for _, tbl in getgc(true) do
                if type(tbl) ~= "table" then continue end
                local recoil_start = rawget(tbl, "RecoilStart")
                local recoil_finish = rawget(tbl, "RecoilFinish")
                if recoil_start and recoil_finish and type(recoil_start) == "function" and type(recoil_finish) == "function" then
                    if state then
                        gun_mods.old_recoil1 = gun_mods.old_recoil1 or recoil_start
                        gun_mods.old_recoil2 = gun_mods.old_recoil2 or recoil_finish
                        rawset(tbl, "RecoilStart", function() return 0, 0 end)
                        rawset(tbl, "RecoilFinish", function() return 0, 0 end)
                    else
                        if gun_mods.old_recoil1 then rawset(tbl, "RecoilStart", gun_mods.old_recoil1) end
                        if gun_mods.old_recoil2 then rawset(tbl, "RecoilFinish", gun_mods.old_recoil2) end
                        gun_mods.old_recoil1 = nil
                        gun_mods.old_recoil2 = nil
                    end
                end
            end
        end
    })

    Section7:AddToggle({
        text = "No Spread",
        flag = "no_spread_toggle",
        callback = function(state)
            library:SendNotification("No Spread " .. (state and "Enabled" or "Disabled"), 6)
            for _, tbl in getgc(true) do
                if type(tbl) ~= "table" then continue end
                local spread_table = rawget(tbl, "Spread")
                if spread_table and typeof(spread_table) == "table" then
                    for _, spread_stuff in spread_table do
                        for i, v in spread_stuff do
                            if type(v) == "number" then
                                gun_mods.old_spread[spread_stuff] = gun_mods.old_spread[spread_stuff] or {}
                                gun_mods.old_spread[spread_stuff][i] = gun_mods.old_spread[spread_stuff][i] or v
                                spread_stuff[i] = state and 0 or gun_mods.old_spread[spread_stuff][i]
                            end
                        end
                    end
                end
            end
        end
    })

    Section7:AddToggle({
        text = "Fire Rate",
        flag = "fire_rate_toggle",
        callback = function(state)
            library:SendNotification("Fire Rate " .. (state and "Enabled" or "Disabled"), 6)
            for _, tbl in getgc(true) do
                if type(tbl) ~= "table" then continue end
                for _, key in pairs({"FireRate", "RateOfFire", "ShotDelay", "Cooldown"}) do
                    local value = rawget(tbl, key)
                    if value and type(value) == "number" then
                        if not gun_mods.old_fire_rate[tbl] then gun_mods.old_fire_rate[tbl] = {} end
                        gun_mods.old_fire_rate[tbl][key] = gun_mods.old_fire_rate[tbl][key] or value
                        if state then
                            if key == "FireRate" or key == "RateOfFire" then
                                rawset(tbl, key, value * library.flags.fire_rate_boost)
                            else
                                rawset(tbl, key, value / library.flags.fire_rate_boost)
                            end
                        else
                            rawset(tbl, key, gun_mods.old_fire_rate[tbl][key])
                        end
                    end
                end
            end
        end
    })

    Section7:AddSlider({
        text = "Fire Rate Boost",
        flag = "fire_rate_boost",
        min = 1,
        max = 3,
        value = 1
    })

    -- Enhanced ESP Logic
    local local_player = Players.LocalPlayer
    local camera = Workspace.CurrentCamera or error("Camera not found")
    local viewport_size = camera.ViewportSize
    local lplayer_name = local_player.Name

    local esp = {
        drawings = {},
        connections = {},
        errors = {},
    }

    -- Fly Logic
    local fly_hack = {
        velocity = nil,
    }

    local function update_fly()
        local character = local_player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChild("Humanoid")
        if not root or not humanoid then
            if fly_hack.velocity and fly_hack.velocity.Parent then
                fly_hack.velocity:Destroy()
                fly_hack.velocity = nil
            end
            return
        end
        if library.flags.fly_toggle and library.flags.fly_bind then
            if not fly_hack.velocity then
                fly_hack.velocity = Instance.new("BodyVelocity")
                fly_hack.velocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                fly_hack.velocity.Parent = root
            end
            local move_direction = Vector3.new()
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then move_direction = move_direction + camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then move_direction = move_direction - camera.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then move_direction = move_direction - camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then move_direction = move_direction + camera.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move_direction = move_direction + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move_direction = move_direction - Vector3.new(0, 1, 0) end
            if move_direction.Magnitude > 0 then move_direction = move_direction.Unit end
            local fly_speed = math.max(library.flags.fly_speed_value, 10)
            fly_hack.velocity.Velocity = move_direction * fly_speed
            -- Fix walking animation
            humanoid.PlatformStand = true
            -- Anti-Ban: Ограничение скорости
            if fly_speed > 50 then
                fly_hack.velocity.Velocity = move_direction * 50
            end
            task.wait(getgenv().sigma_hook.anti_ban.random_delay())
        else
            if fly_hack.velocity and fly_hack.velocity.Parent then
                fly_hack.velocity:Destroy()
                fly_hack.velocity = nil
            end
            humanoid.PlatformStand = false
        end
    end

    -- Aimbot Logic
    local target_enhancements = {
        target = {
            entry = nil,
            part = nil,
            distance = 0
        }
    }

    local player_esp = {
        functions = {}
    }

    function player_esp.functions.get_player()
        local closest_player = nil
        local closest_part = nil
        local closest_distance = math.huge
        local camera_pos = camera.CFrame.Position
        local center_screen = viewport_size / 2

        for _, player in pairs(Players:GetPlayers()) do
            if player == local_player or not player.Character then continue end
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local head = player.Character:FindFirstChild("Head")
            if not humanoid or not head or humanoid.Health <= 0 then continue end
            if player.Team == local_player.Team then continue end
            local head_pos = head.Position
            local raycastParams = RaycastParams.new()
            raycastParams.FilterDescendantsInstances = {local_player.Character}
            raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            local result = Workspace:Raycast(camera_pos, (head_pos - camera_pos).Unit * 1000, raycastParams)
            if result and result.Instance:IsDescendantOf(player.Character) then
                local screen_pos, on_screen = camera:WorldToViewportPoint(head_pos)
                if on_screen then
                    local screen_dist = (Vector2.new(screen_pos.X, screen_pos.Y) - center_screen).Magnitude
                    if screen_dist <= library.flags.fov_radius then
                        local distance = (head_pos - camera_pos).Magnitude
                        if distance < closest_distance then
                            closest_distance = distance
                            closest_player = player
                            closest_part = head
                        end
                    end
                end
            end
        end
        return closest_player, closest_part
    end

    local aiming = false
    UserInputService.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            aiming = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton2 then
            aiming = false
        end
    end)

    local function update_aimbot()
        local entry, closest_part = player_esp.functions.get_player()
        if closest_part and (closest_part ~= target_enhancements.target.part) then
            target_enhancements.target.part = closest_part
            target_enhancements.target.entry = entry
            target_enhancements.target.distance = (closest_part.Position - camera.CFrame.Position).Magnitude / 3.57
        else
            if not closest_part then
                target_enhancements.target.entry = nil
                target_enhancements.target.part = nil
                target_enhancements.target.distance = 0
            end
        end
        if target_enhancements.target.entry and target_enhancements.target.part and target_enhancements.target.entry ~= local_player then
            if library.flags.aimbot_toggle and (aiming or library.flags.aimbot_bind) then
                local enemy_pos = target_enhancements.target.part.Position
                camera.CFrame = library.flags.aimbot_speed ~= 1 and camera.CFrame:Lerp(CFrame.lookAt(camera.CFrame.Position, enemy_pos), library.flags.aimbot_speed) or CFrame.lookAt(camera.CFrame.Position, enemy_pos)
                -- Anti-Ban: Случайная задержка
                task.wait(getgenv().sigma_hook.anti_ban.random_delay())
            end
        end
    end

    -- FOV Circle Logic
    local fov_circle = {
        FieldOfView = nil,
        Frame = nil,
        Stroke = nil,
    }

    do
        local FieldOfView = Instance.new("ScreenGui")
        FieldOfView.Parent = game:GetService("CoreGui")
        FieldOfView.IgnoreGuiInset = true
        local Frame = Instance.new("Frame")
        Frame.Visible = false
        Frame.BackgroundTransparency = 1
        Frame.Size = UDim2.new(0, library.flags.fov_radius * 2, 0, library.flags.fov_radius * 2)
        Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
        Frame.AnchorPoint = Vector2.new(0.5, 0.5)
        Frame.Parent = FieldOfView
        Frame.ZIndex = 2
        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(1, 0)
        UICorner.Parent = Frame
        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Color3.new(1, 1, 1)
        Stroke.Thickness = 2
        Stroke.Transparency = 0
        Stroke.Parent = Frame
        fov_circle.FieldOfView = FieldOfView
        fov_circle.Frame = Frame
        fov_circle.Stroke = Stroke
    end

    local function update_fov_circle()
        if fov_circle.Frame then
            fov_circle.Frame.Visible = library.flags.fov_circle_toggle
            fov_circle.Frame.Size = UDim2.new(0, library.flags.fov_radius * 2, 0, library.flags.fov_radius * 2)
            fov_circle.Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
        end
    end

    -- No-Clip Logic
    local function update_noclip()
        local local_char = local_player.Character
        if library.flags.noclip and library.flags.noclip_key then
            local plr_model = local_char or local_player.CharacterAdded:Wait()
            if plr_model then
                for _, child in pairs(plr_model:GetDescendants()) do
                   if child:IsA("BasePart") then
                        child.CanCollide = false
                   end
                end
            end
            -- Anti-Ban: Случайная задержка
            task.wait(getgenv().sigma_hook.anti_ban.random_delay())
        else
            local plr_model = local_char
            if plr_model then
                for _, child in pairs(plr_model:GetDescendants()) do
                    if child:IsA("BasePart") then
                        child.CanCollide = true
                    end
                end
            end
        end
    end

    -- Free Cam Logic
    local free_cam = {
        enabled = false,
        old_type = nil,
        old_behavior = nil,
        yaw = 0,
        pitch = 0,
    }

    local function update_free_cam()
        local camera = Workspace.CurrentCamera
        local local_char = local_player.Character
        local uis = UserInputService
        if not camera then return end
        if library.flags.free_cam_toggle and library.flags.free_cam_bind then
            if not free_cam.enabled then
                free_cam.enabled = true
                free_cam.old_type = camera.CameraType
                free_cam.old_behavior = uis.MouseBehavior
                camera.CameraType = Enum.CameraType.Scriptable
                uis.MouseBehavior = Enum.MouseBehavior.LockCenter
                if local_char and local_char:FindFirstChild("HumanoidRootPart") then
                    local_char.HumanoidRootPart.Anchored = true
                end
            end
        else
            if free_cam.enabled then
                free_cam.enabled = false
                camera.CameraType = free_cam.old_type
                uis.MouseBehavior = free_cam.old_behavior
                if local_char and local_char:FindFirstChild("HumanoidRootPart") then
                    local_char.HumanoidRootPart.Anchored = false
                end
            end
        end
        if free_cam.enabled then
            local delta = uis:GetMouseDelta()
            free_cam.pitch = math.clamp(free_cam.pitch - delta.Y * library.flags.free_cam_sensitivity, -80, 80)
            free_cam.yaw = free_cam.yaw - delta.X * library.flags.free_cam_sensitivity
            camera.CFrame = CFrame.new(camera.CFrame.Position)
                    * CFrame.Angles(0, math.rad(free_cam.yaw), 0)
                    * CFrame.Angles(math.rad(free_cam.pitch), 0, 0)
            local move = Vector3.zero
            if uis:IsKeyDown(Enum.KeyCode.W) then move = move + Vector3.new(0, 0, -1) end
            if uis:IsKeyDown(Enum.KeyCode.A) then move = move + Vector3.new(-1, 0, 0) end
            if uis:IsKeyDown(Enum.KeyCode.S) then move = move + Vector3.new(0, 0, 1) end
            if uis:IsKeyDown(Enum.KeyCode.D) then move = move + Vector3.new(1, 0, 0) end
            if uis:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
            if uis:IsKeyDown(Enum.KeyCode.LeftShift) then move = move + Vector3.new(0, -1, 0) end
            if move.Magnitude > 0 then
                camera.CFrame = camera.CFrame + (camera.CFrame - camera.CFrame.Position):VectorToWorldSpace(
                    move.Unit * math.min(library.flags.free_cam_speed, 5) -- Anti-Ban: Ограничение скорости
                )
            end
            if local_char and local_char:FindFirstChild("HumanoidRootPart") then
                local_char.HumanoidRootPart.CFrame = camera.CFrame
            end
            -- Anti-Ban: Случайная задержка
            task.wait(getgenv().sigma_hook.anti_ban.random_delay())
        end
    end

    -- Third Person Logic
    local third_person = {
        enabled = false,
        default_subject = nil,
        default_type = nil,
    }

    local function update_third_person()
        local camera = Workspace.CurrentCamera
        if not camera then return end
        local character = local_player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if library.flags.third_person_toggle and library.flags.third_person_bind and root then
            if not third_person.enabled then
                third_person.enabled = true
                third_person.default_subject = camera.CameraSubject
                third_person.default_type = camera.CameraType
                camera.CameraType = Enum.CameraType.Scriptable
            end
            local distance = math.max(library.flags.third_person_distance, 1)
            local offset = root.CFrame.LookVector * -distance + Vector3.new(0, 2, 0)
            local camera_pos = root.Position + offset
            camera.CFrame = CFrame.new(camera_pos, root.Position)
            -- Anti-Ban: Случайная задержка
            task.wait(getgenv().sigma_hook.anti_ban.random_delay())
        else
            if third_person.enabled then
                third_person.enabled = false
                camera.CameraType = third_person.default_type or Enum.CameraType.Custom
                camera.CameraSubject = third_person.default_subject or local_player.Character and local_player.Character:FindFirstChild("Humanoid")
                third_person.default_subject = nil
                third_person.default_type = nil
            end
        end
    end

    -- Manipulation Logic
    local remake = {
        enabled = false,
        startReplica = nil,
        startPosition = nil,
        remakePosition = nil,
        distanceText = Drawing.new("Text"),
        character = nil,
        diedConnection = nil,
    }

    remake.distanceText.Size = 18
    remake.distanceText.Center = true
    remake.distanceText.Outline = true
    remake.distanceText.Visible = false
    remake.distanceText.Position = Vector2.new(
        camera.ViewportSize.X / 2,
        camera.ViewportSize.Y / 2 + 50
    )

    local FORCEFIELD_COLOR = BrickColor.new("Really blue")
    local SHOW_DISTANCE_TEXT = true
    local WALK_SPEED = 16
    local MAX_DISTANCE = 8

    local function createClone(character, color)
        local replica = Instance.new("Model")
        replica.Name = "ForcefieldClone_" .. getgenv().sigma_hook.anti_ban.spoof_id -- Anti-Ban: Уникальное имя
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                local clone = Instance.new("Part")
                clone.Size = part.Size
                clone.CFrame = part.CFrame
                clone.Anchored = true
                clone.CanCollide = false
                clone.Material = Enum.Material.ForceField
                clone.BrickColor = color
                local mesh = part:FindFirstChildWhichIsA("SpecialMesh")
                if mesh then
                    local meshClone = Instance.new("SpecialMesh")
                    pcall(function()
                        meshClone.MeshType = mesh.MeshType
                        meshClone.MeshId = mesh.MeshId
                        meshClone.TextureId = mesh.TextureId
                        meshClone.Scale = mesh.Scale
                    end)
                    meshClone.Parent = clone
                end
                clone.Parent = replica
            end
        end
        replica.Parent = workspace
        return replica
    end

    local function ManipulationReset()
        remake.enabled = false
        if remake.startReplica then
            remake.startReplica:Destroy()
            remake.startReplica = nil
        end
        remake.distanceText.Visible = false
        if remake.character and remake.character:FindFirstChild("HumanoidRootPart") then
            remake.character.HumanoidRootPart.Anchored = false
        end
    end

    local function updateCharacterReferences()
        remake.character = local_player.Character or local_player.CharacterAdded:Wait()
        remake.character:WaitForChild("HumanoidRootPart")
        remake.character:WaitForChild("Humanoid")
        if remake.diedConnection then remake.diedConnection:Disconnect() end
        remake.diedConnection = remake.character.Humanoid.Died:Connect(ManipulationReset)
    end

    local function update_manipulation(deltaTime)
        if library.flags.manipulation_toggle and library.flags.manipulation_bind then
            if not remake.enabled then
                remake.enabled = true
                local root = remake.character and remake.character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.Anchored = true
                    remake.startPosition = root.Position
                    remake.remakePosition = root.Position
                    remake.startReplica = createClone(remake.character, FORCEFIELD_COLOR)
                    if SHOW_DISTANCE_TEXT then remake.distanceText.Visible = true end
                end
            end
        else
            if remake.enabled then ManipulationReset() end
            return
        end
        if remake.enabled then
            local root = remake.character and remake.character:FindFirstChild("HumanoidRootPart")
            if root then
                local dir = Vector3.new()
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Vector3.new(0, 0, -1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir + Vector3.new(-1, 0, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir + Vector3.new(0, 0, 1) end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Vector3.new(1, 0, 0) end
                if dir.Magnitude > 0 then dir = dir.Unit * WALK_SPEED * deltaTime end
                local newPos = root.Position + root.CFrame:VectorToWorldSpace(dir)
                local dist = (newPos - remake.startPosition).Magnitude
                if dist > MAX_DISTANCE then
                    newPos = remake.startPosition + (newPos - remake.startPosition).Unit * MAX_DISTANCE
                end
                -- Anti-Ban: Плавное изменение позиции
                root.CFrame = root.CFrame:Lerp(CFrame.new(newPos), getgenv().sigma_hook.anti_ban.max_cframe_change)
                remake.remakePosition = newPos
                if SHOW_DISTANCE_TEXT then
                    local d = (remake.remakePosition - remake.startPosition).Magnitude
                    remake.distanceText.Text = string.format("Manipulating: %.2f", d)
                    remake.distanceText.Color = Color3.new(1, 1, 1)
                end
                -- Anti-Ban: Случайная задержка
                task.wait(getgenv().sigma_hook.anti_ban.random_delay())
            end
        end
    end

    updateCharacterReferences()
    local_player.CharacterAdded:Connect(function()
        ManipulationReset()
        updateCharacterReferences()
    end)

    -- Camera FOV and Zoom Logic
    local camera_settings = {
        default_fov = camera.FieldOfView or 70,
        default_subject = nil,
        default_type = nil,
    }

    local function update_camera()
        local camera = Workspace.CurrentCamera
        if not camera then return end
        if free_cam.enabled or third_person.enabled then return end
        if library.flags.zoom_toggle and library.flags.zoom_bind then
            camera.FieldOfView = library.flags.zoom_value
        elseif library.flags.camera_fov_toggle then
            camera.FieldOfView = library.flags.camera_fov_value
        else
            camera.FieldOfView = camera_settings.default_fov
            camera.CameraType = camera_settings.default_type or Enum.CameraType.Custom
            camera.CameraSubject = camera_settings.default_subject or local_player.Character and local_player.Character:FindFirstChild("Humanoid")
        end
        -- Anti-Ban: Случайная задержка
        task.wait(getgenv().sigma_hook.anti_ban.random_delay())
    end

    local function init_camera_settings()
        local camera = Workspace.CurrentCamera
        if camera then
            camera_settings.default_fov = camera.FieldOfView
            camera_settings.default_subject = camera.CameraSubject
            camera_settings.default_type = camera.CameraType
        end
    end
    init_camera_settings()

    -- Underground Logic
    getgenv().underground = -1.9
    local underground_enabled = false
    local animation = Instance.new("Animation")
    animation.AnimationId = "rbxassetid://13435049596"
    local danceTrack
    local dysenc = {}
    local temp = 1

    local function update_underground()
        if library.flags.underground_toggle and library.flags.underground_bind then
            if not underground_enabled then
                underground_enabled = true
                pcall(function()
                    danceTrack = local_player.Character:FindFirstChildWhichIsA("Humanoid"):LoadAnimation(animation)
                    danceTrack.Looped = true
                    danceTrack:Play()
                end)
            end
            if local_player.Character and local_player.Character.PrimaryPart then
                dysenc[1] = local_player.Character.PrimaryPart.CFrame
                dysenc[2] = local_player.Character.PrimaryPart.AssemblyLinearVelocity
                local SpoofThis = local_player.Character.PrimaryPart.CFrame
                SpoofThis = (SpoofThis + Vector3.new(0, getgenv().underground, 0)) * CFrame.Angles(0, 0, 0)
                local_player.Character.PrimaryPart.CFrame = SpoofThis
                RunService.RenderStepped:Wait()
                if local_player.Character and local_player.Character.PrimaryPart then
                    local_player.Character.PrimaryPart.CFrame = dysenc[1]
                    local_player.Character.PrimaryPart.AssemblyLinearVelocity = dysenc[2]
                end
            end
            -- Anti-Ban: Случайная задержка
            task.wait(getgenv().sigma_hook.anti_ban.random_delay())
        else
            if underground_enabled then
                underground_enabled = false
                pcall(function()
                    if danceTrack then
                        danceTrack:Stop()
                        danceTrack:Destroy()
                    end
                end)
            end
        end
    end

    -- Bots ESP Logic
    local bot_drawings = {}

    local function esp_for_character(character, nameFlag, healthFlag, distanceFlag, colorFlag)
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local hum = character:FindFirstChild("Humanoid")
        if not hrp or not hum then return end

        local text = Drawing.new("Text")
        text.Size = 14
        text.Color = library.flags[colorFlag]
        text.Outline = true
        text.Center = true
        text.Visible = false

        bot_drawings[character] = text

        local conn
        conn = RunService.RenderStepped:Connect(function()
            if not character:IsDescendantOf(workspace) or hum.Health <= 0 then
                text:Remove()
                bot_drawings[character] = nil
                conn:Disconnect()
                return
            end

            if (character.Name:lower() == "soldier" and not library.flags["soldier_Name"]) or 
               ((character.Name == "Bruno" or character.Name == "Boris") and not library.flags["boss_Name"]) then
                text.Visible = false
            else
                local head_pos = hrp.Position + Vector3.new(0, 3, 0)
                local text_screen, on_screen = camera:WorldToViewportPoint(head_pos)

                local displayText = ""
                if library.flags[nameFlag] then 
                    displayText = displayText .. character.Name 
                end
                if healthFlag and library.flags[healthFlag] then
                    if character.Name:lower() == "soldier" then
                        displayText = string.format("Soldier - %d HP", math.floor(hum.Health))
                    else
                        displayText = string.format("%s - %d HP", character.Name, math.floor(hum.Health))
                    end
                end
                if distanceFlag and library.flags[distanceFlag] then
                    local distance = math.floor((hrp.Position - camera.CFrame.Position).Magnitude)
                    displayText = displayText .. string.format(" - %d s", distance)
                end

                text.Position = Vector2.new(text_screen.X, text_screen.Y)
                text.Text = displayText
                text.Visible = on_screen
                text.Color = library.flags[colorFlag]
            end
            -- Anti-Ban: Случайная задержка
            task.wait(getgenv().sigma_hook.anti_ban.random_delay())
        end)
    end

    local function initialize_bot_esp()
        local function on_character_added(character)
            if character:IsA("Model") and (character.Name:lower() == "soldier" or character.Name == "Bruno" or character.Name == "Boris") then
                if character.Name:lower() == "soldier" then
                    esp_for_character(character, "soldier_Name", "soldier_Health", "soldier_Distance", "soldier_Color")
                elseif character.Name == "Bruno" or character.Name == "Boris" then
                    esp_for_character(character, "boss_Name", "soldier_Health", "soldier_Distance", "boss_Color")
                end
            end
        end

        for _, obj in ipairs(workspace:GetDescendants()) do
            on_character_added(obj)
        end

        workspace.DescendantAdded:Connect(on_character_added)
    end

    initialize_bot_esp()

    -- Function to get the equipped tool
    local function get_tool(character)
        if not character then return "None" end
        for _, value in pairs(character:GetChildren()) do
            if
                value.Name ~= "HolsterModel"
                and value:IsA("Model")
                and value.Name ~= "Hair"
                and (value:FindFirstChild("Detail") or value:FindFirstChild("Main") or value:FindFirstChild("Handle") or
                    value:FindFirstChild("Attachments") or value:FindFirstChild("ArrowAttach") or value:FindFirstChild("Attach"))
                and value.PrimaryPart
            then
                return value.Name
            end
        end
        return "None"
    end

    -- Function to get bounding box dimensions
    local function get_bounding_dimensions(character)
        if not character or not character:IsA("Model") then
            esp.errors["unknown"] = "Invalid character model"
            return nil
        end
        local root = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChildWhichIsA("BasePart")
        if not root then
            esp.errors["unknown"] = "No root part found"
            return nil
        end
        local head = character:FindFirstChild("Head")
        local cframe, size = character:GetBoundingBox()
        if cframe and size and size.Magnitude >= 0.1 then
            size = size
        else
            esp.errors["unknown"] = "Invalid bounding box, using fallback"
            size = Vector3.new(
                head and head.Size and head.Size.X * 1.2 or 1.5,
                5,
                head and head.Size and head.Size.Z * 1.2 or 1.5
            )
            cframe = root.CFrame
        end
        return cframe, size, root.Position
    end

    -- Function to create ESP for a player
    local function create_espp(player)
        if player.Name == lplayer_name then return end
        local drawings = {
            name = Drawing.new("Text"),
            distance = Drawing.new("Text"),
            weapon = Drawing.new("Text"),
            box = Drawing.new("Square"),
            health = Drawing.new("Text"),
            tracer = Drawing.new("Line"),
            head = Drawing.new("Circle"),
            parts = {
                UpperTorso_LowerTorso = Drawing.new("Line"),
                UpperTorso_LeftUpperArm = Drawing.new("Line"),
                LeftUpperArm_LeftLowerArm = Drawing.new("Line"),
                LeftLowerArm_LeftHand = Drawing.new("Line"),
                UpperTorso_RightUpperArm = Drawing.new("Line"),
                RightUpperArm_RightLowerArm = Drawing.new("Line"),
                RightLowerArm_RightHand = Drawing.new("Line"),
                LowerTorso_LeftUpperLeg = Drawing.new("Line"),
                LeftUpperLeg_LeftLowerLeg = Drawing.new("Line"),
                LeftLowerLeg_LeftFoot = Drawing.new("Line"),
                LowerTorso_RightUpperLeg = Drawing.new("Line"),
                RightUpperLeg_RightLowerLeg = Drawing.new("Line"),
                RightLowerLeg_RightFoot = Drawing.new("Line"),
            }
        }
        drawings.name.Size = 14
        drawings.name.Color = Color3.fromRGB(255, 255, 255)
        drawings.name.Outline = true
        drawings.name.Center = true
        drawings.name.Visible = false
        drawings.distance.Size = 12
        drawings.distance.Color = Color3.fromRGB(255, 255, 255)
        drawings.distance.Outline = true
        drawings.distance.Visible = false
        drawings.weapon.Size = 12
        drawings.weapon.Color = Color3.fromRGB(255, 255, 255)
        drawings.weapon.Outline = true
        drawings.weapon.Center = true
        drawings.weapon.Visible = false
        drawings.box.Thickness = 2
        drawings.box.Color = Color3.fromRGB(255, 255, 255)
        drawings.box.Filled = false
        drawings.box.Visible = false
        drawings.health.Size = 12
        drawings.health.Color = Color3.fromRGB(255, 255, 255)
        drawings.health.Outline = true
        drawings.health.Center = true
        drawings.health.Visible = false
        drawings.tracer.Thickness = 1
        drawings.tracer.Color = Color3.fromRGB(255, 255, 255)
        drawings.tracer.Visible = false
        drawings.head.Thickness = 1
        drawings.head.Color = Color3.fromRGB(255, 255, 255)
        drawings.head.Filled = false
        drawings.head.Visible = false
        for _, line in pairs(drawings.parts) do
            line.Thickness = 2
            line.Color = Color3.fromRGB(255, 255, 255)
            line.Visible = false
        end
        esp.drawings[player] = drawings
    end

    -- Function to update ESP
    local function linepos(line, from, to, thickness, root)
        line.From = from
        line.To = to
        line.Thickness = thickness
        line.Visible = true
    end

    local function update_esp()
        if not library.flags.enable_esp then
            for _, drawings in pairs(esp.drawings) do
                for _, drawing in pairs(drawings) do
                    if type(drawing) == "table" then
                        for _, line in pairs(drawing) do
                            line.Visible = false
                        end
                    else
                        drawing.Visible = false
                    end
                end
            end
            return
        end
        for player, drawings in pairs(esp.drawings) do
            local character = player.Character
            local root = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChildWhichIsA("BasePart"))
            local humanoid = character and character:FindFirstChild("Humanoid")
            local head = character and character:FindFirstChild("Head")
            if not character or not root or not humanoid then
                esp.errors[player.Name] = "Missing character, root, or humanoid"
                for _, drawing in pairs(drawings) do
                    if type(drawing) == "table" then
                        for _, line in pairs(drawing) do
                            line.Visible = false
                        end
                    else
                        drawing.Visible = false
                    end
                end
                continue
            end
            local cframe, size, position = get_bounding_dimensions(character)
            if not cframe or not size then
                esp.errors[player.Name] = "Failed to get bounding dimensions"
                for _, drawing in pairs(drawings) do
                    if type(drawing) == "table" then
                        for _, line in pairs(drawing) do
                            line.Visible = false
                        end
                    else
                        drawing.Visible = false
                    end
                end
                continue
            end
            local pos, on_screen = camera:WorldToViewportPoint(position)
            local distance = (position - camera.CFrame.Position).Magnitude
            if on_screen then
                local top_left = camera:WorldToViewportPoint(position + Vector3.new(-size.X / 2, size.Y / 2, -size.Z / 2))
                local bottom_right = camera:WorldToViewportPoint(position + Vector3.new(size.X / 2, -size.Y / 2, size.Z / 2))
                local box_width = math.abs(top_left.X - bottom_right.X)
                local box_height = math.abs(top_left.Y - bottom_right.Y)
                if library.flags.show_name then
                    drawings.name.Visible = true
                    drawings.name.Text = player.DisplayName
                    drawings.name.Position = Vector2.new(pos.X, top_left.Y - 35)
                else
                    drawings.name.Visible = false
                end
                if library.flags.show_box then
                    drawings.box.Visible = true
                    drawings.box.Size = Vector2.new(box_width, box_height)
                    drawings.box.Position = Vector2.new(top_left.X, top_left.Y)
                else
                    drawings.box.Visible = false
                end
                if library.flags.show_distance then
                    drawings.distance.Visible = true
                    drawings.distance.Text = math.floor(distance) .. " studs"
                    drawings.distance.Position = Vector2.new(top_left.X + box_width + 5, top_left.Y)
                else
                    drawings.distance.Visible = false
                end
                if library.flags.show_weapon then
                    drawings.weapon.Visible = true
                    drawings.weapon.Text = get_tool(character)
                    drawings.weapon.Position = Vector2.new(pos.X, bottom_right.Y + 10)
                else
                    drawings.weapon.Visible = false
                end
                if library.flags.show_health then
                    local health = math.floor(humanoid.Health)
                    local max_health = humanoid.MaxHealth
                    local health_percent = health / max_health
                    drawings.health.Visible = true
                    drawings.health.Text = health .. "/" .. max_health
                    drawings.health.Position = Vector2.new(pos.X, top_left.Y - 20)
                    drawings.health.Color = Color3.new(1 - health_percent, health_percent, 0)
                else
                    drawings.health.Visible = false
                end
                if library.flags.show_tracer then
                    drawings.tracer.Visible = true
                    drawings.tracer.From = Vector2.new(viewport_size.X / 2, viewport_size.Y)
                    drawings.tracer.To = Vector2.new(pos.X, pos.Y)
                    drawings.tracer.Color = Color3.fromRGB(255, 255, 255)
                else
                    drawings.tracer.Visible = false
                end
                if library.flags.show_head and head then
                    local head_pos, head_on_screen = camera:WorldToViewportPoint(head.Position)
                    if head_on_screen then
                        local head_radius = head.Size.X * 60 / pos.Z * 0.6
                        drawings.head.Visible = true
                        drawings.head.Radius = head_radius
                        drawings.head.Position = Vector2.new(head_pos.X, head_pos.Y)
                    else
                        drawings.head.Visible = false
                    end
                else
                    drawings.head.Visible = false
                end
                if on_screen and library.flags.enable_skeletons and character and character:FindFirstChild("UpperTorso") and character:FindFirstChild("HumanoidRootPart") then
                    local get_parts = {
                        UpperTorso = "UpperTorso",
                        LowerTorso = "LowerTorso",
                        LeftUpperArm = "LeftUpperArm",
                        LeftLowerArm = "LeftLowerArm",
                        LeftHand = "LeftHand",
                        RightUpperArm = "RightUpperArm",
                        RightLowerArm = "RightLowerArm",
                        RightHand = "RightHand",
                        LeftUpperLeg = "LeftUpperLeg",
                        LeftLowerLeg = "LeftLowerLeg",
                        LeftFoot = "LeftFoot",
                        RightUpperLeg = "RightUpperLeg",
                        RightLowerLeg = "RightLowerLeg",
                        RightFoot = "RightFoot",
                    }
                    local positions = {}
                    local all_parts_valid = true
                    for _, detectable_part in pairs(get_parts) do
                        local part = character:FindFirstChild(detectable_part)
                        if part then
                            local world_pos = part.Position
                            local screenPos, onScreen = camera:WorldToViewportPoint(world_pos)
                            if onScreen and screenPos.Z > 0 then
                                positions[detectable_part] = Vector2.new(screenPos.X, screenPos.Y)
                            else
                                all_parts_valid = false
                                break
                            end
                        else
                            all_parts_valid = false
                            break
                        end
                    end
                    if not all_parts_valid then
                        for _, part in pairs(drawings.parts) do
                            part.Visible = false
                        end
                    else
                        linepos(drawings.parts.UpperTorso_LowerTorso, positions.UpperTorso, positions.LowerTorso, library.flags.skeleton_thickness, root)
                        linepos(drawings.parts.UpperTorso_LeftUpperArm, positions.UpperTorso, positions.LeftUpperArm, library.flags.skeleton_thickness, root)
                        linepos(drawings.parts.LeftUpperArm_LeftLowerArm, positions.LeftUpperArm, positions.LeftLowerArm, library.flags.skeleton_thickness, root)
                        linepos(drawings.parts.LeftLowerArm_LeftHand, positions.LeftLowerArm, positions.LeftHand, library.flags.skeleton_thickness, root)
                        linepos(drawings.parts.UpperTorso_RightUpperArm, positions.UpperTorso, positions.RightUpperArm, library.flags.skeleton_thickness, root)
                        linepos(drawings.parts.RightUpperArm_RightLowerArm, positions.RightUpperArm, positions.RightLowerArm, library.flags.skeleton_thickness, root)
                        linepos(drawings.parts.RightLowerArm_RightHand, positions.RightLowerArm, positions.RightHand, library.flags.skeleton_thickness, root)
                        linepos(drawings.parts.LowerTorso_LeftUpperLeg, positions.LowerTorso, positions.LeftUpperLeg, library.flags.skeleton_thickness, root)
                        linepos(drawings.parts.LeftUpperLeg_LeftLowerLeg, positions.LeftUpperLeg, positions.LeftLowerLeg, library.flags.skeleton_thickness, root)
                        linepos(drawings.parts.LeftLowerLeg_LeftFoot, positions.LeftLowerLeg, positions.LeftFoot, library.flags.skeleton_thickness, root)
                        linepos(drawings.parts.LowerTorso_RightUpperLeg, positions.LowerTorso, positions.RightUpperLeg, library.flags.skeleton_thickness, root)
                        linepos(drawings.parts.RightUpperLeg_RightLowerLeg, positions.RightUpperLeg, positions.RightLowerLeg, library.flags.skeleton_thickness, root)
                        linepos(drawings.parts.RightLowerLeg_RightFoot, positions.RightLowerLeg, positions.RightFoot, library.flags.skeleton_thickness, root)
                    end
                else
                    for _, part in pairs(drawings.parts) do
                        part.Visible = false
                    end
                end
            else
                for _, drawing in pairs(drawings) do
                    if type(drawing) == "table" then
                        for _, line in pairs(drawing) do
                            line.Visible = false
                        end
                    else
                        drawing.Visible = false
                    end
                end
            end
            -- Anti-Ban: Случайная задержка
            task.wait(getgenv().sigma_hook.anti_ban.random_delay())
        end
    end

    -- Function to remove ESP for a player
    local function remove_esp(player)
        if esp.drawings[player] then
            for _, drawing in pairs(esp.drawings[player]) do
                if type(drawing) == "table" then
                    for _, line in pairs(drawing) do
                        line:Remove()
                    end
                else
                    drawing:Remove()
                end
            end
            esp.drawings[player] = nil
        end
    end

    -- Initialize ESP for existing players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= local_player then create_espp(player) end
    end
    Players.PlayerAdded:Connect(function(player)
        if player ~= local_player then create_espp(player) end
    end)
    Players.PlayerRemoving:Connect(function(player)
        remove_esp(player)
    end)

    -- Anti-Ban: Очистка кэша Roblox
    local function clear_roblox_cache()
        pcall(function()
            local path = game:GetService("FileSystemService"):GetAppDataPath()
            local roblox_folder = path .. "\\Roblox"
            game:GetService("FileSystemService"):RemoveFolder(roblox_folder)
        end)
    end

    -- Anti-Ban: Подмена сетевых вызовов
    local oldFireServer = Instance.new("RemoteEvent").FireServer
    local oldInvokeServer = Instance.new("RemoteFunction").InvokeServer
    local function spoof_network_call(method, remote, ...)
        local args = {...}
        local spoofed_id = getgenv().sigma_hook.anti_ban.spoof_id
        table.insert(args, 1, spoofed_id)
        return method(remote, unpack(args))
    end
    hookfunction(Instance.new("RemoteEvent").FireServer, function(remote, ...)
        return spoof_network_call(oldFireServer, remote, ...)
    end)
    hookfunction(Instance.new("RemoteFunction").InvokeServer, function(remote, ...)
        return spoof_network_call(oldInvokeServer, remote, ...)
    end)

    -- Update everything every frame
    RunService.RenderStepped:Connect(function(deltaTime)
        update_esp()
        update_fly()
        update_manipulation(deltaTime)
        update_aimbot()
        update_free_cam()
        update_third_person()
        update_camera()
        update_noclip()
        update_fov_circle()
        update_underground()
    end)

    -- Cleanup on script end
    game:BindToClose(function()
        for player, _ in pairs(esp.drawings) do remove_esp(player) end
        for _, drawing in pairs(bot_drawings) do drawing:Remove() end
        if fly_hack.velocity and fly_hack.velocity.Parent then fly_hack.velocity:Destroy() end
        if remake.startReplica then remake.startReplica:Destroy() end
        if remake.distanceText then remake.distanceText:Remove() end
        if remake.diedConnection then remake.diedConnection:Disconnect() end
        if remake.character and remake.character:FindFirstChild("HumanoidRootPart") then
            remake.character.HumanoidRootPart.Anchored = false
        end
        if fov_circle.FieldOfView then fov_circle.FieldOfView:Destroy() end
        if danceTrack then 
            danceTrack:Stop()
            danceTrack:Destroy()
        end
        for _, connection in ipairs(activeConnections) do connection:Disconnect() end
        local camera = Workspace.CurrentCamera
        if camera then
            camera.CameraType = camera_settings.default_type or Enum.CameraType.Custom
            camera.CameraSubject = camera_settings.default_subject or local_player.Character and local_player.Character:FindFirstChild("Humanoid")
            camera.FieldOfView = camera_settings.default_fov
        end
        if free_cam.enabled then
            free_cam.enabled = false
            if camera then
                camera.CameraType = free_cam.old_type or Enum.CameraType.Custom
                UserInputService.MouseBehavior = free_cam.old_behavior or Enum.MouseBehavior.Default
            end
            local character = local_player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.Anchored = false
            end
        end
        -- Anti-Ban: Очистка кэша при выходе
        clear_roblox_cache()
    end)

    local Time = string.format("%."..tostring(Decimals).."f", os.clock() - Clock)
    library:SendNotification("Loaded In "..tostring(Time), 6)
end)

if not success then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Script Error",
        Text = tostring(err),
        Duration = 10
    })
end
