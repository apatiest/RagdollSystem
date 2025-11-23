-- Put this in StarterCharacterScripts

local ServerStorage = game:GetService("ServerStorage")
local Modules = ServerStorage:WaitForChild("Modules")
local Ragdoll = require(Modules:WaitForChild("Ragdoll"))
local PickUpPlayers = require(Modules:WaitForChild("PickUpPlayers"))

local Character = script.Parent

if not Character:GetAttribute("Ragdoll") then
	Character:SetAttribute("Ragdoll", false)
end

local RagdollAt = Character:GetAttribute("Ragdoll")

Character:GetAttributeChangedSignal("Ragdoll"):Connect(function()
	RagdollAt = Character:GetAttribute("Ragdoll")
	if RagdollAt then
		Ragdoll.EnableRagdoll(Character)
	else
	Ragdoll.DisableRagdoll(Character)
	end
end)
