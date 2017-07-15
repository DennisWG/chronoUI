local _G = _G or getfenv(0);
local Core = _G.chronoUI or CreateFrame("Frame");
_G.chronoUI = Core;

-- initialization
do
SLASH_RELOAD1 = "/rl";
    function SlashCmdList.RELOAD()
      ReloadUI();
    end
    
    Core.Modules = {};
    
    local function Print(...)
        local msg = "";
        for i=2, select("#", ...) do
            msg = msg..tostring(select(i, ...)).."    ";
        end
        DEFAULT_CHAT_FRAME:AddMessage(msg);
    end
    
    Core.Print = Print;
    
    Core:SetScript("OnEvent", function(self, event, ...)
        if self[event] then
            self[event](self, ...);
        end
    end);
    
    Core:RegisterEvent("ADDON_LOADED");
end

-- Initializes the default profile if it hasn't been
function Core:InitializeProfile()
    chronoUI_profiles = chronoUI_profiles or
    {
        default =
        {
            
        }
    };
    
    for name, module in pairs(self.Modules) do
        local profile = module:InitializeDefaultProfile();
        chronoUI_profiles.default[name] = profile;
    end
    
    chronoUI_profiles.current = "default";
    
    self.db = chronoUI_profiles;
end

function Core:ADDON_LOADED(name)
    if name ~= "chronoUI" then
        return;
    end

    self:Print("chronoUI loaded!");
    self:InitializeProfile();
end

-- Registers a module by the given name
-- name: The name of the module
-- returns: A newly created module
function Core:RegisterModule(name)
    local module = self.Modules[name];
    if module then
        return module;
    end
    
    module = CreateFrame("Frame", nil, self);
    module:SetScript("OnEvent", function(self, event, ...)
        if module[event] then
            module[event](self, ...);
        end
    end);
    
    module.Print = Core.Print;
    
    self.Modules[name] = module;
    return module;
end

-- Returns the module with the given name or nil if no such module exists
function Core:GetModule(name)
    return self.Modules[name];
end