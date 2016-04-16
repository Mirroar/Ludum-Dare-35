SandboxLevel = class(Level)
levels.sandbox = SandboxLevel

function SandboxLevel:construct()
    Level.construct(self)

    self.mapOffset.x = -15
    self.mapOffset.y = 50
end

function SandboxLevel:EntityEaten(entityType, x, y)
    Level.EntityEaten(self, entityType, x, y)

    if entityType == 'food' then
        self:SpawnEntity(entityType)
    end
end
