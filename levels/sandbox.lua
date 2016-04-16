SandboxLevel = class(Level)
levels.sandbox = SandboxLevel

function SandboxLevel:construct()
    Level.construct(self)

    self.mapOffset.x = -15
    self.mapOffset.y = 50
end
