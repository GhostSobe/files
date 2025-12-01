Services = setmetatable({}, {
    __index = function(self, name)
        local success, cache = pcall(function()
            return cloneref(game:GetService(name))
        end)
        if success then
            rawset(self, name, cache)
            return cache
        else
            error("Invalid Roblox Service: " .. tostring(name))
        end
    end
})

Lighting = cloneref(game:GetService("Lighting"))
RunService = Services.RunService

local Terrain = workspace:FindFirstChildOfClass("Terrain")
Terrain.WaterWaveSize = 0
Terrain.WaterWaveSpeed = 0
Terrain.WaterReflectance = 0
Terrain.WaterTransparency = 1
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.FogStart = 9e9
settings().Rendering.QualityLevel = 1
for i, v in pairs(game:GetDescendants()) do
    if v:IsA("BasePart") then
        v.Material = "Plastic"
        v.Reflectance = 0
        v.BackSurface = "SmoothNoOutlines"
        v.BottomSurface = "SmoothNoOutlines"
        v.FrontSurface = "SmoothNoOutlines"
        v.LeftSurface = "SmoothNoOutlines"
        v.RightSurface = "SmoothNoOutlines"
        v.TopSurface = "SmoothNoOutlines"
    elseif v:IsA("Decal") then
        v.Transparency = 1
    elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
        v.Lifetime = NumberRange.new(0)
    end
end
for i, v in pairs(Lighting:GetDescendants()) do
    if v:IsA("PostEffect") then
        v.Enabled = false
    end
end
workspace.DescendantAdded:Connect(function(child)
    task.spawn(function()
        if
            child:IsA("ForceField")
            or child:IsA("Sparkles")
            or child:IsA("Smoke")
            or child:IsA("Fire")
            or child:IsA("Beam")
        then
            RunService.Heartbeat:Wait()
            child:Destroy()
        end
    end)
end)
