local HttpService = game:GetService("HttpService")

local ESPMod = {}

local RegisteredPieces = {}

local AllowedTypes = {
	"BasePart",
	"MeshPart",
	"Part"
}

ESPMod.Clear = function()
	for _, entry in ipairs(RegisteredPieces) do
		local part : Part, ui : BillboardGui = unpack(entry)
		if not ui then continue end

		ui:Destroy()
	end
	RegisteredPieces = {}
end

ESPMod.UnregisterESP = function(Part: BasePart)
	for i, entry in ipairs(RegisteredPieces) do
		local registeredPart : BasePart, ui : BillboardGui = unpack(entry)

		if registeredPart ~= Part then continue end
		if not ui then continue end

		ui:Destroy()
		table.remove(RegisteredPieces, i)
		break
	end
end

ESPMod.RegisterESP = function(Part: BasePart)
	if not Part then return end

	if not table.find(AllowedTypes, Part.ClassName) then
		return
	end

	for i, entry in RegisteredPieces do
		local registeredPart : BasePart, ui: BillboardGui = unpack(entry)

		if registeredPart == Part then return end
	end

	local UI = Instance.new("BillboardGui")
	local Frame = Instance.new("Frame")
	local TextLabel = Instance.new("TextLabel")
	local UiStroke = Instance.new("UIStroke")

	UI.Name = tostring(HttpService:GenerateGUID())
	UI.Parent = Part
	UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	UI.Active = true
	UI.AlwaysOnTop = true
	UI.LightInfluence = 1.000
	UI.Size = UDim2.new(0, 150, 0, 25)

	UI.StudsOffset = Vector3.new(0, 1.5, 0)
	UI.MaxDistance = math.huge

	Frame.Parent = UI
	Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame.BackgroundTransparency = 1.000
	Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Frame.BorderSizePixel = 0
	Frame.Size = UDim2.new(1, 0, 1, 0)

	TextLabel.Parent = Frame
	TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.BackgroundTransparency = 1.000
	TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TextLabel.BorderSizePixel = 0
	TextLabel.Size = UDim2.new(1, 0, 1, 0)
	TextLabel.Font = Enum.Font.FredokaOne
	TextLabel.TextColor3 = Color3.fromRGB(102, 102, 102)
	TextLabel.TextScaled = true
	TextLabel.TextSize = 14.000
	TextLabel.TextWrapped = false

	UiStroke.Color = Color3.new(255,255,255)
	UiStroke.Parent = TextLabel

	TextLabel.Text = Part.Name

	Part.Destroying:Connect(function()
		ESPMod.UnregisterESP(Part)
	end)

	Part:GetPropertyChangedSignal("Transparency"):Connect(function()
		if Part.Transparency ~= 1 then task.wait() return end

		ESPMod.UnregisterESP(Part)
	end)
end

return ESPMod
