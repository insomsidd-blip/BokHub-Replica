-- BokHub-style Key UI (original recreation)
-- Safe standalone UI demo for Roblox Luau.
-- This does NOT connect to BokHub or authenticate against its servers.
-- Replace DEMO_KEY and implement your OWN trusted server-side validation
-- before using this for a real product.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local DEMO_KEY = "DITO-DEMO-2026" -- Change this for local testing only.

local old = playerGui:FindFirstChild("BokHubReplica")
if old then
    old:Destroy()
end

local theme = {
    background = Color3.fromRGB(12, 18, 28),
    panel = Color3.fromRGB(20, 29, 43),
    text = Color3.fromRGB(245, 247, 255),
    muted = Color3.fromRGB(157, 170, 192),
    purple = Color3.fromRGB(126, 76, 255),
    pink = Color3.fromRGB(185, 91, 255),
    green = Color3.fromRGB(77, 220, 153),
    red = Color3.fromRGB(255, 100, 110),
}

local gui = Instance.new("ScreenGui")
gui.Name = "BokHubReplica"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local shadow = Instance.new("Frame")
shadow.Name = "Main"
shadow.AnchorPoint = Vector2.new(0.5, 0.5)
shadow.Position = UDim2.fromScale(0.5, 0.5)
shadow.Size = UDim2.fromOffset(370, 278)
shadow.BackgroundColor3 = theme.background
shadow.BorderSizePixel = 0
shadow.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = shadow

local stroke = Instance.new("UIStroke")
stroke.Color = theme.purple
stroke.Transparency = 0.68
stroke.Thickness = 1
stroke.Parent = shadow

local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 48)),
    ColorSequenceKeypoint.new(1, theme.background),
})
gradient.Rotation = 35
gradient.Parent = shadow

local function make(className, properties, parent)
    local object = Instance.new(className)
    for property, value in pairs(properties) do
        object[property] = value
    end
    object.Parent = parent
    return object
end

local function label(parent, text, position, size, font, textSize, color)
    return make("TextLabel", {
        BackgroundTransparency = 1,
        Position = position,
        Size = size,
        Font = font or Enum.Font.Gotham,
        Text = text,
        TextSize = textSize or 13,
        TextColor3 = color or theme.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
    }, parent)
end

local topLine = make("Frame", {
    Position = UDim2.fromOffset(14, 14),
    Size = UDim2.new(1, -28, 0, 3),
    BackgroundColor3 = theme.purple,
    BorderSizePixel = 0,
}, shadow)
make("UICorner", {CornerRadius = UDim.new(1, 0)}, topLine)
local topGradient = make("UIGradient", {
    Color = ColorSequence.new(theme.purple, theme.pink),
}, topLine)

label(shadow, "BOKHUB", UDim2.fromOffset(20, 28), UDim2.new(1, -40, 0, 30),
    Enum.Font.GothamBlack, 22, theme.text)
label(shadow, "KEY AUTHENTICATION", UDim2.fromOffset(21, 59), UDim2.new(1, -42, 0, 18),
    Enum.Font.Gotham, 10, theme.muted)

local keyBox = make("TextBox", {
    Position = UDim2.fromOffset(20, 96),
    Size = UDim2.new(1, -40, 0, 42),
    BackgroundColor3 = Color3.fromRGB(10, 15, 25),
    BorderSizePixel = 0,
    ClearTextOnFocus = false,
    PlaceholderText = "Enter your license key...",
    PlaceholderColor3 = theme.muted,
    Text = "",
    TextColor3 = theme.text,
    TextSize = 13,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left,
}, shadow)
make("UICorner", {CornerRadius = UDim.new(0, 9)}, keyBox)
make("UIPadding", {
    PaddingLeft = UDim.new(0, 12),
    PaddingRight = UDim.new(0, 12),
}, keyBox)
make("UIStroke", {Color = Color3.fromRGB(65, 76, 100), Transparency = 0.55}, keyBox)

local status = label(shadow, "Waiting for license key", UDim2.fromOffset(21, 145),
    UDim2.new(1, -42, 0, 18), Enum.Font.Gotham, 11, theme.muted)

local verify = make("TextButton", {
    Position = UDim2.fromOffset(20, 177),
    Size = UDim2.new(1, -40, 0, 38),
    BackgroundColor3 = theme.purple,
    BorderSizePixel = 0,
    AutoButtonColor = true,
    Text = "VERIFY KEY",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 12,
    Font = Enum.Font.GothamBold,
}, shadow)
make("UICorner", {CornerRadius = UDim.new(0, 9)}, verify)
make("UIGradient", {
    Color = ColorSequence.new(theme.purple, theme.pink),
}, verify)

local copy = make("TextButton", {
    Position = UDim2.fromOffset(20, 224),
    Size = UDim2.new(1, -40, 0, 30),
    BackgroundColor3 = Color3.fromRGB(37, 45, 63),
    BorderSizePixel = 0,
    Text = "COPY DEMO KEY",
    TextColor3 = theme.text,
    TextSize = 10,
    Font = Enum.Font.GothamBold,
}, shadow)
make("UICorner", {CornerRadius = UDim.new(0, 8)}, copy)

label(shadow, "Original UI recreation • local demo only", UDim2.fromOffset(20, 257),
    UDim2.new(1, -40, 0, 13), Enum.Font.Gotham, 9, theme.muted)

local function setStatus(message, color)
    status.Text = message
    status.TextColor3 = color
end

verify.Activated:Connect(function()
    local entered = keyBox.Text:gsub("%s+", "")
    if entered == "" then
        setStatus("Please enter a key first.", theme.red)
        return
    end

    verify.Text = "CHECKING..."
    verify.Active = false
    task.wait(0.45)

    if entered == DEMO_KEY then
        setStatus("Demo key accepted. UI test successful.", theme.green)
        verify.Text = "VERIFIED"
    else
        setStatus("Invalid demo key. Try the local test key.", theme.red)
        verify.Text = "VERIFY KEY"
    end
    verify.Active = true
end)

copy.Activated:Connect(function()
    if typeof(setclipboard) == "function" then
        local ok = pcall(setclipboard, DEMO_KEY)
        if ok then
            copy.Text = "COPIED!"
            task.delay(1.2, function()
                if copy.Parent then copy.Text = "COPY DEMO KEY" end
            end)
        else
            setStatus("Clipboard is unavailable in this environment.", theme.muted)
        end
    else
        setStatus("Clipboard API is not available here.", theme.muted)
    end
end)

-- Drag window with mouse or touch.
local dragging = false
local dragInput
local dragStart
local startPosition

shadow.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPosition = shadow.Position
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        shadow.Position = UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        )
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input == dragInput or input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- Demo key for testing: DITO-DEMO-2026
