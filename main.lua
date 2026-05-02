-- WindUI hub script snippet: version fetch + UI recheck button
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local version = "2026.V.0.2"
local lisencetype = "Release"
local HttpService = game:GetService("HttpService")

-- current fetched remote version (initial empty)
local updatedVersion = ""

-- fetch function (returns string or nil,err)
local function fetchVersion()
    local ok, res = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/sharpydevv/SharpHub/refs/heads/main/hub/assets/currentversion.txt")
    end)
    if ok and type(res) == "string" then
        return res:gsub("^%s+", ""):gsub("%s+$", "") -- trim
    end
    return nil, res
end

-- Optional background updater (keeps updatedVersion fresh every 5s)
task.spawn(function()
    while true do
        local v, err = fetchVersion()
        if v and v ~= updatedVersion then
            updatedVersion = v
            -- If you want to update the UI from the background loop, uncomment below:
            -- pcall(function() NVR:SetDesc(updatedVersion) end)
            print("Background fetched version:", updatedVersion)
        end
        task.wait(5)
    end
end)

-- Create UI window
local Window = WindUI:CreateWindow({
    Title = "SharpHub",
    Icon = "axe",
    Author = "by sharpy",
    Folder = "sharpydevv",
    Size = UDim2.fromOffset(580, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    ToggleKey = Enum.KeyCode.LeftShift,
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = false,
    ScrollBarEnabled = true,
    User = { Enabled = true, Anonymous = false },
})

Window:Tag({
    Title = version,
    Icon = "github",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 13,
})

Window:Tag({
    Title = "Lisence: ".. lisencetype,
    Icon = "id-card",
    Color = Color3.fromHex("#F5F227"),
    Radius = 13,
})

local InformationTab = Window:Tab({
    Title = "Information",
    Icon = "info",
    Locked = false,
})
InformationTab:Select()
InformationTab:Paragraph({
    Title = "Information",
    Desc = "If the updated version text states unknown, please click the recheck button, it'll start working.",
    Color = "White",
    Image = "info",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
})
InformationTab:Paragraph({
    Title = "Lisence Info",
    Desc = lisencetype,
    Color = "White",
    Image = "id-card",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
})

local VRRN = InformationTab:Paragraph({
    Title = "Version",
    Desc = version,
    Color = "White",
    Image = "circle-arrow-down",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
})

-- NVR paragraph shows the currently fetched remote version (starts empty)
local NVR = InformationTab:Paragraph({
    Title = "Newest Version Released",
    Desc = updatedVersion ~= "" and updatedVersion or "Unknown",
    Color = "White",
    Image = "star",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
})

-- Re-check button: fetches remote version, assigns updatedVersion, updates NVR only
local FetchNewestVersion = InformationTab:Button({
    Title = "Recheck Version",
    Justify = "Center",
    IconAlign = "Left",
    Icon = "star",
    Callback = function()
        -- set loading text
        pcall(function()
            if NVR.SetDesc then
                NVR:SetDesc("Checking...")
            elseif NVR.Update then
                NVR:Update({ Desc = "Checking..." })
            end
        end)

        -- fetch version
        local v, err = fetchVersion()
        if not v then
            warn("Failed to fetch version:", err)
            pcall(function()
                if NVR.SetDesc then
                    NVR:SetDesc("Failed")
                elseif NVR.Update then
                    NVR:Update({ Desc = "Failed" })
                end
            end)
            return
        end

        -- update value and UI
        updatedVersion = v
        pcall(function()
            if NVR.SetDesc then
                NVR:SetDesc(updatedVersion)
            elseif NVR.Update then
                NVR:Update({ Desc = updatedVersion })
            end
        end)

        print("Rechecked version:", updatedVersion)
    end
})


local UniversalTab = Window:Tab({
    Title = "Universal Scripts",
    Icon = "joystick",
    Locked = false,
})

local UniTabTextTop = UniversalTab:Paragraph({
    Title = "About Universal Scripts",
    Desc = "Universal Scripts can be used in any game (don't get caught :-)",
    Color = "White",
    Image = "app-window",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
})

--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local MightyClicker = UniversalTab:Button({
    Title = "AutoClicking Script",
    Desc = "Autoclicker Script",
    Locked = false,
    Callback = function()
--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
loadstring(game:HttpGet("https://raw.githubusercontent.com/KEV1Npkrl/Roblox-AutoClicker-v1.0/refs/heads/main/AutoClicker%20v1.0"))()
    end
})
local InfiniteYield = UniversalTab:Button({
    Title = "Infinite Yield",
    Desc = "Admin Script by: EdgeIY on Github",
    Locked = false,
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end
})

local flyinfo = UniversalTab:Paragraph({
    Title = "Fly",
    Desc = "Fly Controls",
    Color = "White",
    Image = "star",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
})
local FlyButton = UniversalTab:Button({
    Title = "Fly Script",
    Desc = "Fly Script UI",
    Locked = false,
    Callback = function()
    --// Prevent duplicate execution
if _G.FlyGuiV8Loaded then return end
_G.FlyGuiV8Loaded = true

--// Services
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

--// Player & Character
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

--// Configuration
local flySpeed = 1
local flyTransparency = 0.75
local FLYING = false
local isFlyToggledOn = false
local useCFrameFly = false
local bodyGyro, bodyVelocity, CFloop, noclipConnection

--// Control scheme
local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}

--// GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyGuiV8"
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true

local uiScale = Instance.new("UIScale", screenGui)

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Parent = screenGui
mainFrame.Size = UDim2.new(0, 250, 0, 170)
mainFrame.Position = UDim2.new(0.5, -125, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 35)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true

local uiCorner = Instance.new("UICorner", mainFrame)
uiCorner.CornerRadius = UDim.new(0, 8)

local uiStroke = Instance.new("UIStroke", mainFrame)
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(0, 0, 0)

local headerFrame = Instance.new("Frame", mainFrame)
headerFrame.Size = UDim2.new(1, 0, 0, 40)
headerFrame.BackgroundTransparency = 1

local titleLabel = Instance.new("TextLabel", headerFrame)
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "Fly Gui V8 by Botak"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Center

local closeButton = Instance.new("TextButton", headerFrame)
closeButton.Size = UDim2.new(0, 12, 0, 12); closeButton.Position = UDim2.new(1, -22, 0.5, -6)
closeButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60); closeButton.Text = ""
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(1, 0)

local minimizeButton = Instance.new("TextButton", headerFrame)
minimizeButton.Size = UDim2.new(0, 12, 0, 12); minimizeButton.Position = UDim2.new(1, -40, 0.5, -6)
minimizeButton.BackgroundColor3 = Color3.fromRGB(241, 196, 15); minimizeButton.Text = ""
Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(1, 0)

local cframeToggle = Instance.new("TextButton", headerFrame)
cframeToggle.Size = UDim2.new(0, 24, 0, 20); cframeToggle.Position = UDim2.new(1, -68, 0.5, -10)
cframeToggle.BackgroundColor3 = Color3.fromRGB(44, 46, 51); cframeToggle.Font = Enum.Font.GothamBold
cframeToggle.Text = "CF"; cframeToggle.TextColor3 = Color3.fromRGB(255, 255, 255); cframeToggle.TextSize = 12
Instance.new("UICorner", cframeToggle).CornerRadius = UDim.new(0, 4)
local cframeStroke = Instance.new("UIStroke", cframeToggle); cframeStroke.Color = Color3.fromRGB(20, 20, 20)

local bodyFrame = Instance.new("Frame", mainFrame)
bodyFrame.Size = UDim2.new(1, 0, 1, -40); bodyFrame.Position = UDim2.new(0, 0, 0, 40)
bodyFrame.BackgroundTransparency = 1

local flyButton = Instance.new("TextButton", bodyFrame)
flyButton.Size = UDim2.new(1, -20, 0, 35); flyButton.Position = UDim2.new(0, 10, 0, 10)
flyButton.BackgroundColor3 = Color3.fromRGB(44, 46, 51); flyButton.Font = Enum.Font.Gotham
flyButton.Text = "Fly"; flyButton.TextColor3 = Color3.fromRGB(255, 255, 255); flyButton.TextSize = 16
Instance.new("UICorner", flyButton).CornerRadius = UDim.new(0, 6)
local flyStroke = Instance.new("UIStroke", flyButton); flyStroke.Color = Color3.fromRGB(20, 20, 20)

local speedSliderLabel = Instance.new("TextLabel", bodyFrame)
speedSliderLabel.Size = UDim2.new(1, -20, 0, 20); speedSliderLabel.Position = UDim2.new(0, 10, 0, 55)
speedSliderLabel.BackgroundTransparency = 1; speedSliderLabel.Font = Enum.Font.Gotham
speedSliderLabel.Text = "Speed: 1"; speedSliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedSliderLabel.TextSize = 14; speedSliderLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedSlider = Instance.new("Frame", bodyFrame)
speedSlider.Size = UDim2.new(1, -20, 0, 6); speedSlider.Position = UDim2.new(0, 10, 0, 80)
speedSlider.BackgroundColor3 = Color3.fromRGB(20, 22, 25)
Instance.new("UICorner", speedSlider).CornerRadius = UDim.new(0, 3)

local sliderBar = Instance.new("Frame", speedSlider)
sliderBar.Size = UDim2.new(0, 0, 1, 0); sliderBar.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(0, 3)

local sliderHandle = Instance.new("TextButton", speedSlider)
sliderHandle.Size = UDim2.new(0, 18, 0, 18); sliderHandle.Position = UDim2.new(0, -9, 0.5, -9)
sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); sliderHandle.Text = ""
Instance.new("UICorner", sliderHandle).CornerRadius = UDim.new(1, 0)

local transparencyLabel = Instance.new("TextLabel", bodyFrame)
transparencyLabel.Size = UDim2.new(0.5, -15, 0, 30); transparencyLabel.Position = UDim2.new(0, 10, 0, 95)
transparencyLabel.BackgroundTransparency = 1; transparencyLabel.Font = Enum.Font.Gotham
transparencyLabel.Text = "Transparency:"; transparencyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
transparencyLabel.TextSize = 14; transparencyLabel.TextXAlignment = Enum.TextXAlignment.Left

local transparencyBox = Instance.new("TextBox", bodyFrame)
transparencyBox.Size = UDim2.new(0.5, -15, 0, 30); transparencyBox.Position = UDim2.new(0.5, 5, 0, 95)
transparencyBox.BackgroundColor3 = Color3.fromRGB(20, 22, 25); transparencyBox.Font = Enum.Font.Gotham
transparencyBox.Text = tostring(flyTransparency); transparencyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
transparencyBox.TextSize = 14; transparencyBox.ClearTextOnFocus = false
Instance.new("UICorner", transparencyBox).CornerRadius = UDim.new(0, 4)

--// Dragging Logic
local function makeDraggable(guiObject, dragHandle)
    local dragging = false; local dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, dragStart, startPos = true, input.Position, guiObject.Position
        end
    end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
makeDraggable(mainFrame, headerFrame)

--// Noclip Function
local function NoclipLoop()
    if character ~= nil then
        for _, child in pairs(character:GetDescendants()) do
            if child:IsA("BasePart") and child.CanCollide == true then child.CanCollide = false end
        end
    end
end

--// Flight Functions
local function startCFrameFlyLoop()
    if not character or not character:FindFirstChild("Head") then return end; FLYING = true
    local Head = character.Head; Head.Anchored = true
    CFloop = RunService.Heartbeat:Connect(function(deltaTime)
        local effectiveSpeed = flySpeed * 10; local moveDirection = humanoid.MoveDirection * (effectiveSpeed * deltaTime)
        local headCFrame, camera = Head.CFrame, workspace.CurrentCamera; local cameraCFrame = camera.CFrame
        local cameraOffset = headCFrame:ToObjectSpace(cameraCFrame).Position
        cameraCFrame = cameraCFrame * CFrame.new(-cameraOffset.X, -cameraOffset.Y, -cameraOffset.Z + 1)
        local cameraPosition, headPosition = cameraCFrame.Position, headCFrame.Position
        local objectSpaceVelocity = CFrame.new(cameraPosition, Vector3.new(headPosition.X, cameraPosition.Y, headPosition.Z)):VectorToObjectSpace(moveDirection)
        Head.CFrame = CFrame.new(headPosition) * (cameraCFrame - cameraPosition) * CFrame.new(objectSpaceVelocity)
    end)
end

local function startBodyMoverFlyLoop()
    if not character or not rootPart or not humanoid then return end; FLYING = true
    noclipConnection = RunService.Heartbeat:Connect(NoclipLoop)
    task.spawn(function()
        bodyGyro = Instance.new('BodyGyro', rootPart); bodyGyro.P = 9e4; bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9); bodyGyro.CFrame = rootPart.CFrame
        bodyVelocity = Instance.new('BodyVelocity', rootPart); bodyVelocity.Velocity = Vector3.new(0, 0, 0); bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        if humanoid then humanoid.PlatformStand = true end
        repeat
            task.wait()
            local camera = workspace.CurrentCamera
            local moveVector = ((camera.CFrame.LookVector * (CONTROL.F + CONTROL.B)) + ((camera.CFrame * CFrame.new((CONTROL.L + CONTROL.R), (CONTROL.Q + CONTROL.E) * 0.2, 0).p) - camera.CFrame.p))
            bodyVelocity.Velocity = moveVector.Magnitude > 0 and moveVector.Unit * flySpeed or Vector3.new(0,0,0)
            bodyGyro.CFrame = camera.CFrame
        until not FLYING or not rootPart.Parent
        if bodyGyro then bodyGyro:Destroy() end; if bodyVelocity then bodyVelocity:Destroy() end
        if humanoid and humanoid.Parent then humanoid.PlatformStand = false end
        CONTROL = {F=0,B=0,L=0,R=0,Q=0,E=0}
    end)
end

--// Helper Functions
local function updateSlider(input)
    local sliderWidth = speedSlider.AbsoluteSize.X; local newX = math.clamp(input.Position.X - speedSlider.AbsolutePosition.X, 0, sliderWidth)
    local percentage = newX / sliderWidth; flySpeed = 1 + (percentage * 499) 
    speedSliderLabel.Text = string.format("Speed: %.0f", flySpeed)
    sliderBar.Size = UDim2.new(percentage, 0, 1, 0); sliderHandle.Position = UDim2.new(percentage, -9, 0.5, -9)
end

local function setFlying(state)
    isFlyToggledOn = state
    if FLYING == state or not character or not character.Parent then return end
    flyButton.TextColor3 = state and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(255, 255, 255)
    flyStroke.Color = state and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(20, 20, 20)

    if state then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.Transparency = flyTransparency end
        end
        if useCFrameFly then
            for _, part in ipairs(character:GetDescendants()) do if part:IsA("BasePart") then part.CanCollide = false end end
            startCFrameFlyLoop()
        else
            startBodyMoverFlyLoop()
        end
    else
        FLYING = false
        if CFloop then CFloop:Disconnect(); CFloop = nil end
        if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
        if character and character:FindFirstChild("Head") then character.Head.Anchored = false end
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
                if part.Name ~= "HumanoidRootPart" then part.Transparency = 0 end
            end
        end
    end
end

--// Keybind Handlers
local keyMap = {[Enum.KeyCode.W]="F",[Enum.KeyCode.S]="B",[Enum.KeyCode.A]="L",[Enum.KeyCode.D]="R",[Enum.KeyCode.Q]="Q",[Enum.KeyCode.E]="E"}
local valueMap = {[Enum.KeyCode.W]=1,[Enum.KeyCode.S]=-1,[Enum.KeyCode.A]=-1,[Enum.KeyCode.D]=1,[Enum.KeyCode.Q]=-1,[Enum.KeyCode.E]=1}
UserInputService.InputBegan:Connect(function(input, gpe) if gpe or not keyMap[input.KeyCode] then return end CONTROL[keyMap[input.KeyCode]] = valueMap[input.KeyCode] end)
UserInputService.InputEnded:Connect(function(input) if keyMap[input.KeyCode] then CONTROL[keyMap[input.KeyCode]] = 0 end end)

--// Respawn Handler
player.CharacterAdded:Connect(function(newChar)
    if CFloop then CFloop:Disconnect(); CFloop = nil end
    if noclipConnection then noclipConnection:Disconnect(); noclipConnection = nil end
    FLYING = false; character = newChar
    humanoid = newChar:WaitForChild("Humanoid"); rootPart = newChar:WaitForChild("HumanoidRootPart")
    if isFlyToggledOn then setFlying(true) end
end)

--// GUI Interactions
closeButton.MouseButton1Click:Connect(function()
    _G.FlyGuiV8Loaded = false; screenGui:Destroy()
end)
flyButton.MouseButton1Click:Connect(function() setFlying(not isFlyToggledOn) end)
cframeToggle.MouseButton1Click:Connect(function()
    useCFrameFly = not useCFrameFly
    cframeToggle.TextColor3 = useCFrameFly and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(255, 255, 255)
    cframeStroke.Color = useCFrameFly and Color3.fromRGB(88, 101, 242) or Color3.fromRGB(20, 20, 20)
end)

--// FIXED: Minimize button functionality
local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    bodyFrame.Visible = not isMinimized
    local targetSize = isMinimized and UDim2.new(0, 250, 0, 40) or UDim2.new(0, 250, 0, 170)
    TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Size = targetSize}):Play()
end)

transparencyBox.FocusLost:Connect(function(enterPressed)
    local num = tonumber(transparencyBox.Text)
    if num and num >= 0 and num <= 1 then flyTransparency = num
        if FLYING then for _, part in ipairs(character:GetDescendants()) do if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then part.Transparency = flyTransparency end end end
    else transparencyBox.Text = tostring(flyTransparency) end
end)
local isDraggingSlider = false
sliderHandle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingSlider = true; updateSlider(input) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDraggingSlider = false end end)
UserInputService.InputChanged:Connect(function(input) if isDraggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end end)
    end
})--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local battleinfo = UniversalTab:Paragraph({
    Title = "fighting games",
    Desc = "u can use these in pvps or like rivals or stuff",
    Color = "White",
    Image = "star",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
})
local espbutton = UniversalTab:Button({
    Title = "esp and aimbot",
    Desc = "esp and aimbot script",
    Locked = false,
    Callback = function()
        --[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
-- Roblox ESP + Aimbot Script (Advanced Version)
-- Compatible with most executors

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- ESP Settings
local ESPEnabled = true
local TeamCheck = false
local ShowDistance = true
local ShowHealth = true
local ShowName = true
local ShowBoxes = true
local ShowTracers = true

-- Aimbot Settings
local AimbotEnabled = false
local AimbotKey = Enum.UserInputType.MouseButton2 -- Right Click
local AimbotKeybind = Enum.KeyCode.Q -- Press Q to toggle
local AimbotFOV = 200
local AimbotSmoothing = 0.1 -- Lower = snappier, Higher = smoother
local AimbotPart = "Head" -- Head, HumanoidRootPart, Torso
local VisibleCheck = true
local ShowFOVCircle = true
local AimbotTeamCheck = true
local PredictMovement = false
local PredictionStrength = 0.15

-- ESP Color Settings
local ESPSettings = {
    BoxColor = Color3.fromRGB(255, 255, 255),
    TracerColor = Color3.fromRGB(255, 255, 255),
    NameColor = Color3.fromRGB(255, 255, 255),
    HealthBarColor = Color3.fromRGB(0, 255, 0),
    TeamColor = true,
    MaxDistance = 2000,
    TextSize = 14,
    BoxThickness = 2,
}

-- Storage
local ESPObjects = {}
local FOVCircle
local TargetPart = nil

-- Utility Functions
local function CreateDrawing(type, properties)
    local drawing = Drawing.new(type)
    for property, value in pairs(properties) do
        drawing[property] = value
    end
    return drawing
end

local function GetDistanceColor(distance)
    if distance < 50 then
        return Color3.fromRGB(255, 0, 0)
    elseif distance < 100 then
        return Color3.fromRGB(255, 165, 0)
    elseif distance < 150 then
        return Color3.fromRGB(255, 255, 0)
    elseif distance < 200 then
        return Color3.fromRGB(0, 255, 0)
    else
        return Color3.fromRGB(0, 255, 255)
    end
end

-- Aimbot Functions
local function IsVisible(targetPart)
    if not VisibleCheck then return true end
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.IgnoreWater = true
    
    local ray = workspace:Raycast(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position), raycastParams)
    
    return ray == nil or ray.Instance:IsDescendantOf(targetPart.Parent)
end

local function GetClosestPlayerToCursor()
    local closestPlayer = nil
    local shortestDistance = AimbotFOV
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if AimbotTeamCheck and player.Team == LocalPlayer.Team then
                continue
            end
            
            local character = player.Character
            if character and character:FindFirstChild(AimbotPart) and character:FindFirstChild("Humanoid") then
                local humanoid = character.Humanoid
                if humanoid.Health > 0 then
                    local targetPart = character[AimbotPart]
                    
                    if IsVisible(targetPart) then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                        
                        if onScreen then
                            local mousePos = UserInputService:GetMouseLocation()
                            local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                            
                            if distance < shortestDistance then
                                closestPlayer = player
                                shortestDistance = distance
                            end
                        end
                    end
                end
            end
        end
    end
    
    return closestPlayer
end

local function AimAt(targetPlayer)
    if not targetPlayer or not targetPlayer.Character then return end
    
    local character = targetPlayer.Character
    local targetPart = character:FindFirstChild(AimbotPart)
    
    if not targetPart then return end
    
    local targetPos = targetPart.Position
    
    -- Prediction
    if PredictMovement and targetPart.Parent:FindFirstChild("HumanoidRootPart") then
        local velocity = targetPart.Parent.HumanoidRootPart.Velocity
        targetPos = targetPos + (velocity * PredictionStrength)
    end
    
    -- Smooth aim
    local currentCFrame = Camera.CFrame
    local targetCFrame = CFrame.new(Camera.CFrame.Position, targetPos)
    
    Camera.CFrame = currentCFrame:Lerp(targetCFrame, AimbotSmoothing)
end

-- ESP Functions
local function CreateESP(player)
    if ESPObjects[player] then return end
    
    local esp = {
        BoxOutline = CreateDrawing("Square", {
            Thickness = ESPSettings.BoxThickness + 1,
            Filled = false,
            Color = Color3.new(0, 0, 0),
            Visible = false,
            ZIndex = 1
        }),
        Box = CreateDrawing("Square", {
            Thickness = ESPSettings.BoxThickness,
            Filled = false,
            Color = ESPSettings.BoxColor,
            Visible = false,
            ZIndex = 2
        }),
        Tracer = CreateDrawing("Line", {
            Thickness = 1.5,
            Color = ESPSettings.TracerColor,
            Visible = false,
            ZIndex = 1
        }),
        Name = CreateDrawing("Text", {
            Size = ESPSettings.TextSize,
            Center = true,
            Outline = true,
            Color = ESPSettings.NameColor,
            Visible = false,
            ZIndex = 3
        }),
        Distance = CreateDrawing("Text", {
            Size = ESPSettings.TextSize - 2,
            Center = true,
            Outline = true,
            Color = Color3.fromRGB(255, 255, 255),
            Visible = false,
            ZIndex = 3
        }),
        HealthBarOutline = CreateDrawing("Square", {
            Thickness = 1,
            Filled = false,
            Color = Color3.new(0, 0, 0),
            Visible = false,
            ZIndex = 1
        }),
        HealthBarBackground = CreateDrawing("Square", {
            Thickness = 1,
            Filled = true,
            Color = Color3.fromRGB(30, 30, 30),
            Visible = false,
            ZIndex = 2
        }),
        HealthBar = CreateDrawing("Square", {
            Thickness = 1,
            Filled = true,
            Color = ESPSettings.HealthBarColor,
            Visible = false,
            ZIndex = 3
        }),
        HealthText = CreateDrawing("Text", {
            Size = 12,
            Center = false,
            Outline = true,
            Color = Color3.fromRGB(255, 255, 255),
            Visible = false,
            ZIndex = 4
        }),
    }
    
    ESPObjects[player] = esp
end

local function RemoveESP(player)
    if not ESPObjects[player] then return end
    
    for _, drawing in pairs(ESPObjects[player]) do
        drawing:Remove()
    end
    
    ESPObjects[player] = nil
end

local function UpdateESP(player)
    if not ESPEnabled then return end
    if player == LocalPlayer then return end
    if not ESPObjects[player] then CreateESP(player) end
    
    local esp = ESPObjects[player]
    local character = player.Character
    
    if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Humanoid") then
        for _, drawing in pairs(esp) do
            drawing.Visible = false
        end
        return
    end
    
    local humanoid = character.Humanoid
    local rootPart = character.HumanoidRootPart
    local head = character:FindFirstChild("Head")
    
    if TeamCheck and player.Team == LocalPlayer.Team then
        for _, drawing in pairs(esp) do
            drawing.Visible = false
        end
        return
    end
    
    local distance = (Camera.CFrame.Position - rootPart.Position).Magnitude
    
    if distance > ESPSettings.MaxDistance then
        for _, drawing in pairs(esp) do
            drawing.Visible = false
        end
        return
    end
    
    local rootPos, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
    
    if not onScreen then
        for _, drawing in pairs(esp) do
            drawing.Visible = false
        end
        return
    end
    
    local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
    local legPos = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 3, 0))
    
    local height = math.abs(headPos.Y - legPos.Y)
    local width = height / 2
    
    local color = ESPSettings.TeamColor and player.TeamColor.Color or GetDistanceColor(distance)
    
    if ShowBoxes then
        esp.Box.Size = Vector2.new(width, height)
        esp.Box.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2)
        esp.Box.Color = color
        esp.Box.Visible = true
        
        esp.BoxOutline.Size = Vector2.new(width, height)
        esp.BoxOutline.Position = Vector2.new(rootPos.X - width/2, rootPos.Y - height/2)
        esp.BoxOutline.Visible = true
    else
        esp.Box.Visible = false
        esp.BoxOutline.Visible = false
    end
    
    if ShowTracers then
        esp.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
        esp.Tracer.To = Vector2.new(rootPos.X, rootPos.Y + height/2)
        esp.Tracer.Color = color
        esp.Tracer.Visible = true
    else
        esp.Tracer.Visible = false
    end
    
    if ShowName then
        esp.Name.Text = player.DisplayName ~= player.Name and player.DisplayName .. " (@" .. player.Name .. ")" or player.Name
        esp.Name.Position = Vector2.new(rootPos.X, rootPos.Y - height/2 - 18)
        esp.Name.Color = color
        esp.Name.Visible = true
    else
        esp.Name.Visible = false
    end
    
    if ShowDistance then
        esp.Distance.Text = "[" .. math.floor(distance) .. " studs]"
        esp.Distance.Position = Vector2.new(rootPos.X, rootPos.Y - height/2 - 4)
        esp.Distance.Color = color
        esp.Distance.Visible = true
    else
        esp.Distance.Visible = false
    end
    
    if ShowHealth then
        local healthPercent = humanoid.Health / humanoid.MaxHealth
        local barWidth = 4
        local barHeight = height
        
        esp.HealthBarOutline.Size = Vector2.new(barWidth + 2, barHeight + 2)
        esp.HealthBarOutline.Position = Vector2.new(rootPos.X - width/2 - barWidth - 4, rootPos.Y - height/2 - 1)
        esp.HealthBarOutline.Visible = true
        
        esp.HealthBarBackground.Size = Vector2.new(barWidth, barHeight)
        esp.HealthBarBackground.Position = Vector2.new(rootPos.X - width/2 - barWidth - 3, rootPos.Y - height/2)
        esp.HealthBarBackground.Visible = true
        
        local healthColor
        if healthPercent > 0.75 then
            healthColor = Color3.fromRGB(0, 255, 0)
        elseif healthPercent > 0.5 then
            healthColor = Color3.fromRGB(173, 255, 47)
        elseif healthPercent > 0.25 then
            healthColor = Color3.fromRGB(255, 165, 0)
        else
            healthColor = Color3.fromRGB(255, 0, 0)
        end
        
        esp.HealthBar.Size = Vector2.new(barWidth, barHeight * healthPercent)
        esp.HealthBar.Position = Vector2.new(rootPos.X - width/2 - barWidth - 3, rootPos.Y + height/2 - (barHeight * healthPercent))
        esp.HealthBar.Color = healthColor
        esp.HealthBar.Visible = true
        
        esp.HealthText.Text = tostring(math.floor(humanoid.Health))
        esp.HealthText.Position = Vector2.new(rootPos.X - width/2 - barWidth - 20, rootPos.Y)
        esp.HealthText.Visible = true
    else
        esp.HealthBarOutline.Visible = false
        esp.HealthBarBackground.Visible = false
        esp.HealthBar.Visible = false
        esp.HealthText.Visible = false
    end
end

-- Create FOV Circle
FOVCircle = CreateDrawing("Circle", {
    Thickness = 2,
    NumSides = 64,
    Radius = AimbotFOV,
    Filled = false,
    Color = Color3.fromRGB(255, 255, 255),
    Transparency = 0.5,
    Visible = ShowFOVCircle,
    ZIndex = 1000
})

-- Main Loops
local function ESPLoop()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            UpdateESP(player)
        end
    end
end

local function AimbotLoop()
    if AimbotEnabled then
        local isAiming = UserInputService:IsMouseButtonPressed(AimbotKey)
        
        if isAiming then
            local target = GetClosestPlayerToCursor()
            if target then
                AimAt(target)
            end
        end
    end
    
    -- Update FOV Circle
    if ShowFOVCircle then
        local mousePos = UserInputService:GetMouseLocation()
        FOVCircle.Position = mousePos
        FOVCircle.Radius = AimbotFOV
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end
end

-- Events
Players.PlayerAdded:Connect(function(player)
    CreateESP(player)
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESP(player)
    end
end

local ESPConnection = RunService.RenderStepped:Connect(ESPLoop)
local AimbotConnection = RunService.RenderStepped:Connect(AimbotLoop)

-- Keybinds
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == AimbotKeybind then
        AimbotEnabled = not AimbotEnabled
        
        if _G.MainFrame then
            _G.MainFrame.ToggleAimbot.Text = "Aimbot: " .. (AimbotEnabled and "ON" or "OFF")
            _G.MainFrame.ToggleAimbot.BorderColor3 = AimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        end
        
        print("Aimbot " .. (AimbotEnabled and "Enabled" or "Disabled"))
    end
end)

-- GUI Creation
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ESPAimbotMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if gethui then
    ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game.CoreGui
else
    ScreenGui.Parent = game.CoreGui
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
MainFrame.Position = UDim2.new(0.02, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 280, 0, 520)
MainFrame.Parent = ScreenGui
MainFrame.Active = true
MainFrame.Draggable = true
_G.MainFrame = MainFrame

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(0.7, 0, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "ESP + Aimbot"
Title.TextColor3 = Color3.fromRGB(0, 255, 0)
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0.05, 0, 0, 0)
Title.Parent = TitleBar

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinimizeBtn.BorderSizePixel = 1
MinimizeBtn.BorderColor3 = Color3.fromRGB(0, 255, 0)
MinimizeBtn.Position = UDim2.new(0.75, 0, 0.15, 0)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 28)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 20
MinimizeBtn.Parent = TitleBar

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
CloseBtn.BorderSizePixel = 1
CloseBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.Position = UDim2.new(0.87, 0, 0.15, 0)
CloseBtn.Size = UDim2.new(0, 30, 0, 28)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 0, 0)
CloseBtn.TextSize = 18
CloseBtn.Parent = TitleBar

-- Content Frame
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Name = "ContentFrame"
ContentFrame.BackgroundTransparency = 1
ContentFrame.Position = UDim2.new(0, 0, 0, 45)
ContentFrame.Size = UDim2.new(1, 0, 1, -50)
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 700)
ContentFrame.ScrollBarThickness = 4
ContentFrame.Parent = MainFrame

-- Function to create buttons
local function CreateButton(name, text, position, callback)
    local button = Instance.new("TextButton")
    button.Name = name
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    button.BorderSizePixel = 1
    button.BorderColor3 = Color3.fromRGB(0, 255, 0)
    button.Position = position
    button.Size = UDim2.new(0.9, 0, 0, 32)
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 13
    button.Parent = ContentFrame
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Function to create slider
local function CreateSlider(name, text, min, max, default, position, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = name .. "Frame"
    sliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    sliderFrame.BorderSizePixel = 1
    sliderFrame.BorderColor3 = Color3.fromRGB(0, 255, 0)
    sliderFrame.Position = position
    sliderFrame.Size = UDim2.new(0.9, 0, 0, 50)
    sliderFrame.Parent = ContentFrame
    
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Font = Enum.Font.Gotham
    label.Text = text .. ": " .. tostring(default)
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 12
    label.Parent = sliderFrame
    
    local slider = Instance.new("TextButton")
    slider.Name = name
    slider.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    slider.BorderSizePixel = 0
    slider.Position = UDim2.new(0.05, 0, 0.5, 0)
    slider.Size = UDim2.new(0.9, 0, 0, 18)
    slider.Text = ""
    slider.Parent = sliderFrame
    
    local fill = Instance.new("Frame")
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    fill.BorderSizePixel = 0
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.Parent = slider
    
    local dragging = false
    
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
        end
    end)
    
    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = UserInputService:GetMouseLocation().X
            local sliderPos = slider.AbsolutePosition.X
            local sliderSize = slider.AbsoluteSize.X
            
            local percent = math.clamp((mousePos - sliderPos) / sliderSize, 0, 1)
            local value = min + (max - min) * percent
            
            fill.Size = UDim2.new(percent, 0, 1, 0)
            label.Text = text .. ": " .. string.format("%.2f", value)
            
            callback(value)
        end
    end)
    
    return sliderFrame
end

-- Create Section Labels
local function CreateSection(text, position)
    local section = Instance.new("TextLabel")
    section.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    section.BorderSizePixel = 0
    section.Position = position
    section.Size = UDim2.new(0.9, 0, 0, 25)
    section.Font = Enum.Font.GothamBold
    section.Text = text
    section.TextColor3 = Color3.fromRGB(0, 255, 0)
    section.TextSize = 14
    section.Parent = ContentFrame
    
    return section
end

-- ESP Section
local yPos = 10
CreateSection("ESP SETTINGS", UDim2.new(0.05, 0, 0, yPos))
yPos = yPos + 35

CreateButton("ToggleESP", "ESP: ON", UDim2.new(0.05, 0, 0, yPos), function()
    ESPEnabled = not ESPEnabled
    ContentFrame.ToggleESP.Text = "ESP: " .. (ESPEnabled and "ON" or "OFF")
    ContentFrame.ToggleESP.BorderColor3 = ESPEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)
yPos = yPos + 38

CreateButton("ToggleBoxes", "Boxes: ON", UDim2.new(0.05, 0, 0, yPos), function()
    ShowBoxes = not ShowBoxes
    ContentFrame.ToggleBoxes.Text = "Boxes: " .. (ShowBoxes and "ON" or "OFF")
    ContentFrame.ToggleBoxes.BorderColor3 = ShowBoxes and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)
yPos = yPos + 38

CreateButton("ToggleTracers", "Tracers: ON", UDim2.new(0.05, 0, 0, yPos), function()
    ShowTracers = not ShowTracers
    ContentFrame.ToggleTracers.Text = "Tracers: " .. (ShowTracers and "ON" or "OFF")
    ContentFrame.ToggleTracers.BorderColor3 = ShowTracers and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)
yPos = yPos + 38

CreateButton("ToggleName", "Names: ON", UDim2.new(0.05, 0, 0, yPos), function()
    ShowName = not ShowName
    ContentFrame.ToggleName.Text = "Names: " .. (ShowName and "ON" or "OFF")
    ContentFrame.ToggleName.BorderColor3 = ShowName and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)
yPos = yPos + 38

CreateButton("ToggleDistance", "Distance: ON", UDim2.new(0.05, 0, 0, yPos), function()
    ShowDistance = not ShowDistance
    ContentFrame.ToggleDistance.Text = "Distance: " .. (ShowDistance and "ON" or "OFF")
    ContentFrame.ToggleDistance.BorderColor3 = ShowDistance and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)
yPos = yPos + 38

CreateButton("ToggleHealth", "Health: ON", UDim2.new(0.05, 0, 0, yPos), function()
    ShowHealth = not ShowHealth
    ContentFrame.ToggleHealth.Text = "Health: " .. (ShowHealth and "ON" or "OFF")
    ContentFrame.ToggleHealth.BorderColor3 = ShowHealth and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)
yPos = yPos + 38

CreateButton("ToggleTeam", "Team Check: OFF", UDim2.new(0.05, 0, 0, yPos), function()
    TeamCheck = not TeamCheck
    ContentFrame.ToggleTeam.Text = "Team Check: " .. (TeamCheck and "ON" or "OFF")
    ContentFrame.ToggleTeam.BorderColor3 = TeamCheck and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)
yPos = yPos + 48

-- Aimbot Section
CreateSection("AIMBOT SETTINGS", UDim2.new(0.05, 0, 0, yPos))
yPos = yPos + 35

CreateButton("ToggleAimbot", "Aimbot: OFF", UDim2.new(0.05, 0, 0, yPos), function()
    AimbotEnabled = not AimbotEnabled
    ContentFrame.ToggleAimbot.Text = "Aimbot: " .. (AimbotEnabled and "ON" or "OFF")
    ContentFrame.ToggleAimbot.BorderColor3 = AimbotEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)
yPos = yPos + 38

CreateButton("ToggleFOV", "FOV Circle: ON", UDim2.new(0.05, 0, 0, yPos), function()
    ShowFOVCircle = not ShowFOVCircle
    ContentFrame.ToggleFOV.Text = "FOV Circle: " .. (ShowFOVCircle and "ON" or "OFF")
    ContentFrame.ToggleFOV.BorderColor3 = ShowFOVCircle and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)
yPos = yPos + 38

CreateButton("ToggleVisible", "Visible Check: ON", UDim2.new(0.05, 0, 0, yPos), function()
    VisibleCheck = not VisibleCheck
    ContentFrame.ToggleVisible.Text = "Visible Check: " .. (VisibleCheck and "ON" or "OFF")
    ContentFrame.ToggleVisible.BorderColor3 = VisibleCheck and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)
yPos = yPos + 38

CreateButton("ToggleAimbotTeam", "Team Check: ON", UDim2.new(0.05, 0, 0, yPos), function()
    AimbotTeamCheck = not AimbotTeamCheck
    ContentFrame.ToggleAimbotTeam.Text = "Team Check: " .. (AimbotTeamCheck and "ON" or "OFF")
    ContentFrame.ToggleAimbotTeam.BorderColor3 = AimbotTeamCheck and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
end)
yPos = yPos + 38

CreateButton("CyclePart", "Aim Part: " .. AimbotPart, UDim2.new(0.05, 0, 0, yPos), function()
    local parts = {"Head", "HumanoidRootPart", "Torso"}
    local currentIndex = table.find(parts, AimbotPart)
    local nextIndex = (currentIndex % #parts) + 1
    AimbotPart = parts[nextIndex]
    ContentFrame.CyclePart.Text = "Aim Part: " .. AimbotPart
end)
yPos = yPos + 48

CreateSlider("FOVSlider", "FOV Size", 50, 500, AimbotFOV, UDim2.new(0.05, 0, 0, yPos), function(value)
    AimbotFOV = value
end)
yPos = yPos + 58

CreateSlider("SmoothSlider", "Smoothing", 0.01, 1, AimbotSmoothing, UDim2.new(0.05, 0, 0, yPos), function(value)
    AimbotSmoothing = value
end)
yPos = yPos + 58

CreateSlider("PredictSlider", "Prediction", 0, 0.5, PredictionStrength, UDim2.new(0.05, 0, 0, yPos), function(value)
    PredictionStrength = value
    PredictMovement = value > 0
end)
yPos = yPos + 68

-- Info Section
local InfoLabel = Instance.new("TextLabel")
InfoLabel.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
InfoLabel.BorderSizePixel = 0
InfoLabel.Position = UDim2.new(0.05, 0, 0, yPos)
InfoLabel.Size = UDim2.new(0.9, 0, 0, 60)
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.Text = "Keybind: Q to toggle aimbot\nHold Right Click to aim\nDrag title bar to move"
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoLabel.TextSize = 10
InfoLabel.TextWrapped = true
InfoLabel.Parent = ContentFrame

-- Minimize/Maximize functionality
local minimized = false
local originalSize = MainFrame.Size

MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    
    if minimized then
        MainFrame:TweenSize(UDim2.new(0, 280, 0, 40), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        MinimizeBtn.Text = "+"
        ContentFrame.Visible = false
    else
        MainFrame:TweenSize(originalSize, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        MinimizeBtn.Text = "-"
        ContentFrame.Visible = true
    end
end)

-- Close functionality
CloseBtn.MouseButton1Click:Connect(function()
    ESPConnection:Disconnect()
    AimbotConnection:Disconnect()
    
    for player, esp in pairs(ESPObjects) do
        RemoveESP(player)
    end
    
    FOVCircle:Remove()
    ScreenGui:Destroy()
    
    print("ESP + Aimbot Closed")
end)

print("ESP + Aimbot Loaded!")
print("Keybinds:")
print("  Q - Toggle Aimbot")
print("  Right Click (Hold) - Aim at target")
    end
})
-- startup one-time check for newer remote version
-- reusable fetch-and-update function
local function fetchAndUpdateUI(showLoading)
    if showLoading then
        pcall(function()
            if NVR.SetDesc then
                NVR:SetDesc("Checking...")
            elseif NVR.Update then
                NVR:Update({ Desc = "Checking..." })
            end
        end)
    end

    local v, err = fetchVersion()
    if not v then
        warn("Failed to fetch version:", err)
        pcall(function()
            if NVR.SetDesc then
                NVR:SetDesc("Failed")
            elseif NVR.Update then
                NVR:Update({ Desc = "Failed" })
            end
        end)
        return nil, err
    end

    updatedVersion = v

    pcall(function()
        if NVR.SetDesc then
            NVR:SetDesc(updatedVersion)
        elseif NVR.Update then
            NVR:Update({ Desc = updatedVersion })
        end
    end)

    return updatedVersion
end

-- Wire the Recheck button to use the function
-- (replace your current Callback with this)
Button.Callback = function()
    fetchAndUpdateUI(true)
end

-- Use the same function for the one-time startup check (no double code)
    local v, err = fetchVersion()
    if not v then
        warn("Failed to fetch version:", err)
        pcall(function()
            if NVR.SetDesc then
                NVR:SetDesc("Failed")
            elseif NVR.Update then
                NVR:Update({ Desc = "Failed" })
            end
        end)
        return
    end

    updatedVersion = v
    pcall(function()
        if NVR.SetDesc then
            NVR:SetDesc(updatedVersion)
        elseif NVR.Update then
            NVR:Update({ Desc = updatedVersion })
        end
    end)

    print("Rechecked version:", updatedVersion)
end
