local module = {}

module["Name"] = "Xs's Utilities"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local FLYING = false
local QEfly = true
local iyflyspeed = 1
local vehicleflyspeed = 1
local IYMouse = Players.LocalPlayer:GetMouse()

local function getRoot(char)
    local rootPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    return rootPart
end

local function sFLY(vfly)
    repeat wait() until Players.LocalPlayer and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    repeat wait() until IYMouse
    if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end

    local T = getRoot(Players.LocalPlayer.Character)
    local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
    local SPEED = 0

    local function FLY()
        FLYING = true
        local BG = Instance.new('BodyGyro')
        local BV = Instance.new('BodyVelocity')
        BG.P = 9e4
        BG.Parent = T
        BV.Parent = T
        BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
        BG.cframe = T.CFrame
        BV.velocity = Vector3.new(0, 0, 0)
        BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
        task.spawn(function()
            repeat wait()
                if not vfly and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
                    Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
                end
                if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
                    SPEED = 50
                elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
                    SPEED = 0
                end
                if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
                    BV.velocity = ((workspace.CurrentCamera.CFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CFrame.p)) * SPEED
                    lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
                elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
                    BV.velocity = ((workspace.CurrentCamera.CFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CFrame.p)) * SPEED
                else
                    BV.velocity = Vector3.new(0, 0, 0)
                end
                BG.cframe = workspace.CurrentCamera.CFrame
            until not FLYING
            CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
            SPEED = 0
            BG:Destroy()
            BV:Destroy()
            if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
                Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
            end
        end)
    end
    flyKeyDown = IYMouse.KeyDown:Connect(function(KEY)
        if KEY:lower() == 'w' then
            CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
        elseif KEY:lower() == 's' then
            CONTROL.B = - (vfly and vehicleflyspeed or iyflyspeed)
        elseif KEY:lower() == 'a' then
            CONTROL.L = - (vfly and vehicleflyspeed or iyflyspeed)
        elseif KEY:lower() == 'd' then 
            CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
        elseif QEfly and KEY:lower() == 'e' then
            CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed)*2
        elseif QEfly and KEY:lower() == 'q' then
            CONTROL.E = -(vfly and vehicleflyspeed or iyflyspeed)*2
        end
        pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
    end)
    flyKeyUp = IYMouse.KeyUp:Connect(function(KEY)
        if KEY:lower() == 'w' then
            CONTROL.F = 0
        elseif KEY:lower() == 's' then
            CONTROL.B = 0
        elseif KEY:lower() == 'a' then
            CONTROL.L = 0
        elseif KEY:lower() == 'd' then
            CONTROL.R = 0
        elseif KEY:lower() == 'e' then
            CONTROL.Q = 0
        elseif KEY:lower() == 'q' then
            CONTROL.E = 0
        end
    end)
    FLY()
end

local function NOFLY()
    FLYING = false
    if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
    if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
        Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
    end
    pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

local function gotoPlayer(targetPlayer)
    local character = targetPlayer.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local targetPosition = character.HumanoidRootPart.Position
        local playerCharacter = Players.LocalPlayer.Character
        if playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart") then
            playerCharacter.HumanoidRootPart.CFrame = CFrame.new(targetPosition + Vector3.new(0, 5, 0))
        end
    end
end

module[1] = {
    Type = "Button",
    Args = {"Toggle Fly", function(Self)
        if FLYING then
            NOFLY()
        else
            sFLY()
        end
    end}
}

module[2] = {
    Type = "Button",
    Args = {"Noclip", function(Self)
        local player = Players.LocalPlayer
        local character = player.Character
        if character then
            for _, v in pairs(character:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = not v.CanCollide
                end
            end
        end
    end}
}

local playerCount = 3
for _, player in pairs(Players:GetPlayers()) do
    if player ~= Players.LocalPlayer then
        module[playerCount] = {
            Type = "Button",
            Args = {player.Name, function(Self)
                gotoPlayer(player)
            end}
        }
        playerCount = playerCount + 1
    end
end

_G.Modules[#_G.Modules + 1] = module
return module
