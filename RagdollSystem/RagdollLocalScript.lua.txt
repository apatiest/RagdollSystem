-- Place it under StarterPlayerScripts

local function WaitForInstance(Instance1)
	if not Instance1 then
		repeat
			task.wait()
		until Instance1
	end
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local GettingUp = Remotes:WaitForChild("GettingUp")


local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

Character = Player.Character or Player.CharacterAdded:Wait()
Humanoid = Character:WaitForChild("Humanoid")
WaitForInstance(Character)
WaitForInstance(Humanoid)

Player.CharacterAdded:Connect(function(NewCharacter)
	Character = NewCharacter
	Humanoid = Character:WaitForChild("Humanoid")
	WaitForInstance(Character)
	WaitForInstance(Humanoid)
end)

UserInputService.JumpRequest:Connect(function()
	GettingUp:FireServer()
end)
