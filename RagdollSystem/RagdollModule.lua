-- Create a folder under ServerStorage called "Modules" and place it under, rename the module to "Ragdoll"

local Players = game:GetService("Players")
local PhysicsService = game:GetService("PhysicsService")

local module = {}


local function CreateGroup(name)
	if not pcall(function() PhysicsService:GetRegisteredCollisionGroup(name) end) then
		PhysicsService:RegisterCollisionGroup(name)
	end
end

CreateGroup("RagdollParts")
CreateGroup("RootPart")


PhysicsService:CollisionGroupSetCollidable("RagdollParts", "RootPart", false)
PhysicsService:CollisionGroupSetCollidable("RagdollParts", "RagdollParts", false)

local function AddCollision(Part)
	local Collision = Instance.new("Part")
	Collision.Name = "Collision"
	Collision.Transparency = 1
	Collision.CanCollide = true
	Collision.CanTouch = false
	Collision.CanQuery = false
	Collision.Massless = true
	Collision.Size = Part.Size/tonumber(2) or Vector3.new(1,1,1)
	Collision.CFrame = Part.CFrame
	Collision.Parent = Part

	Collision.CollisionGroup = "RagdollParts"

	local Weld = Instance.new("WeldConstraint")
	Weld.Part0 = Part
	Weld.Part1 = Collision
	Weld.Parent = Collision
end

function module.EnableRagdoll(Character)
	local Humanoid = Character:WaitForChild("Humanoid")
	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	HumanoidRootPart.CollisionGroup = "RootPart"
	Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
	Humanoid.PlatformStand = true

	for index,joint in pairs(Character:GetDescendants()) do
		if joint:IsA("Motor6D") then
			local socket = Instance.new("BallSocketConstraint")
			local a1 = Instance.new("Attachment")
			local a2 = Instance.new("Attachment")
			a1.Parent = joint.Part0
			a2.Parent = joint.Part1
			socket.Parent = joint.Parent
			socket.Attachment0 = a1
			socket.Attachment1 = a2
			a1.CFrame = joint.C0
			a2.CFrame = joint.C1
			socket.LimitsEnabled = true
			socket.TwistLimitsEnabled = true
			AddCollision(joint.Part1)
			joint.Enabled = false
		end
	end
	for i, v in pairs(Character:GetDescendants()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
			v.CollisionGroup = "RagdollParts"
		end
	end
end

local function ResetVelocity(Part)
	Part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
	Part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
	Part.RotVelocity = Vector3.new(0, 0, 0)
end

function module.DisableRagdoll(Character)
	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	local Humanoid = Character:WaitForChild("Humanoid")
	HumanoidRootPart.Anchored = true
	ResetVelocity(HumanoidRootPart)
	for index,joint in pairs(Character:GetDescendants()) do

		if joint:IsA("Motor6D") then
			ResetVelocity(joint.Part1)
			joint.Enabled = true
		end

		if joint.Name == "BallSocketConstraint" or joint.Name == "Attachment" or joint.Name == "Collision" then
			joint:Destroy()
		end
	end
	Humanoid.PlatformStand = false
	Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	task.wait(0.03)
	HumanoidRootPart.Anchored = false
end



return module
