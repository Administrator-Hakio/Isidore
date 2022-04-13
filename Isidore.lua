--[[
	This game uses the library Isidore written by Administrator_Hakio.
	Copyright 2020 MIT License.
	
  ___  ___   ________   ___  __     ___   ________         ___   ________    ________     
 |\  \|\  \ |\   __  \ |\  \|\  \  |\  \ |\   __  \       |\  \ |\   ___  \ |\   ____\    
 \ \  \\\  \\ \  \|\  \\ \  \/  /_ \ \  \\ \  \|\  \      \ \  \\ \  \\ \  \\ \  \___|    
  \ \   __  \\ \   __  \\ \   ___  \\ \  \\ \  \\\  \      \ \  \\ \  \\ \  \\ \  \       
   \ \  \ \  \\ \  \ \  \\ \  \\ \  \\ \  \\ \  \\\  \   ___\ \  \\ \  \\ \  \\ \  \____  
    \ \__\ \__\\ \__\ \__\\ \__\\ \__\\ \__\\ \_______\ |\__\\ \__\\ \__\\ \__\\ \_______\
     \|__|\|__| \|__|\|__| \|__| \|__| \|__| \|_______| \|__| \|__| \|__| \|__| \|_______|                                                                           
--]]
--[[
	ATTENTION, IF YOU REMOVE/EDIT SOMETHING IN THIS SCRIPT, YOU WILL LOSE THE LICENCE OF THIS SCRIPT.
	BY LOOSING THE LICENCE, YOU WILL RISK A DMCA OF THIS GAME.
]]--

--// Initialization

local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local IsClient = RunService:IsClient()

local Isidore = {}
local CollectionMetatable = {}

--// Variables

local DebugPrint = false

--// Functions

local function printd(...)
	if DebugPrint then
		return print(...)
	end
end

local function BindToTag(Tag, Callback)
	CollectionService:GetInstanceAddedSignal(Tag):Connect(Callback)

	for _, TaggedItem in ipairs(CollectionService:GetTagged(Tag)) do
		Callback(TaggedItem)
	end
end

local function Retrieve(InstanceName, InstanceClass, InstanceParent)
	--// Finds an Instance by name and creates a new one if it doesen't exist

	local SearchInstance = nil
	local InstanceCreated = false

	if InstanceParent:FindFirstChild(InstanceName) then
		SearchInstance = InstanceParent[InstanceName]
	else
		InstanceCreated = true
		SearchInstance = Instance.new(InstanceClass)
		SearchInstance.Name = InstanceName
		SearchInstance.Parent = InstanceParent
	end

	return SearchInstance, InstanceCreated
end

Isidore.Libraries = setmetatable({}, CollectionMetatable)
Isidore.Libraries._Folder = Retrieve("Libraries", "Folder", ReplicatedStorage)
Isidore.Libraries._WaitCache = {}

function Isidore:LoadLibrary(Index)
	if self.Libraries[Index] then
		return require(self.Libraries[Index])
	else
		assert(IsClient, "The library \"" .. Index .. "\" does not exist!")
		printd("The client is yielding for the library \"" .. Index .. "\".")

		--// Coroutine yielding has been temporarily replaced with BindableEvents due to Roblox issues.

		local BindableEvent = Instance.new("BindableEvent")
		BindableEvent.Parent = script

		self.Libraries._WaitCache[BindableEvent] = Index
		return require(BindableEvent.Event:Wait())
	end
end
