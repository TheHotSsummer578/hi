-- Script for locking onto the closest player within 150 studs

local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local targetRange = 150  -- Max distance for locking on to another player
local isAiming = false   -- Aiming state (toggle with B key)
local closestPlayer = nil
local closestHumanoidRootPart = nil

-- Function to toggle the targeting system
local function toggleAiming()
    isAiming = not isAiming
    if isAiming then
        print("Aiming mode ON")
    else
        print("Aiming mode OFF")
    end
end

-- Function to find the closest player within range
local function findClosestPlayer()
    local closestDistance = targetRange
    closestPlayer = nil
    closestHumanoidRootPart = nil

    for _, otherPlayer in pairs(game.Players:GetPlayers()) do
        -- Ignore the local player and check for a valid target
        if otherPlayer ~= player and otherPlayer.Character then
            local character = otherPlayer.Character
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

            if humanoidRootPart then
                local distance = (player.Character.HumanoidRootPart.Position - humanoidRootPart.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = otherPlayer
                    closestHumanoidRootPart = humanoidRootPart
                end
            end
        end
    end
end

-- Function to aim at the closest player's HumanoidRootPart
local function aimAtTarget()
    if closestHumanoidRootPart then
        -- Update the camera to aim at the target (lock on)
        local camera = workspace.CurrentCamera
        camera.CFrame = CFrame.new(camera.CFrame.Position, closestHumanoidRootPart.Position)
    end
end

-- Listen for the B key press to toggle aiming
userInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.B and not gameProcessed then
        toggleAiming()
    end
end)

-- Main loop to check for closest player and aim when necessary
while true do
    wait(0.1)  -- Update every 0.1 seconds to check for new closest player
    if isAiming then
        -- Find the closest player to lock onto
        findClosestPlayer()
        if closestHumanoidRootPart then
            aimAtTarget()  -- Aim at the closest target if found
        end
    end
end
