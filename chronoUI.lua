local gfind = string.gmatch;

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
    
    Core.imageFolder = "Interface\\AddOns\\chronoUI\\img\\";
    Core.fontFolder = "Interface\\AddOns\\chronoUI\\Fonts\\";
    
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
    
    chronoUI_profiles.current = "default";
    
    for name, module in pairs(self.Modules) do
        module.db = chronoUI_profiles;
        
        local profile = module:InitializeDefaultProfile();
        chronoUI_profiles.default[name] = profile;
    end
    
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

function Core:Round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0);
    return math.floor(num * mult + 0.5) / mult;
end

-- Normalizes the given rgba color to a range of 0 - 1
function Core:NormalizeFromRGBA(r, g, b, a)
    return { r = r / 255, g = g / 255, b = b / 255, a = a / 255 };
end

function Core:EnsureType(variable,  typeName)
    if not type(variable) == typeName then
        error(string.format("Type Mismatch!\nRequired %s got %s\n%s", typeName, type(variable), debugstack()));
    end
end

    local resolution = GetCVar("gxResolution")
    for screenwidth, screenheight in gfind(resolution, "(.+)x(.+)") do
      local scale = (min(2, max(.64, 768/screenheight)))
      SetCVar("UseUIScale", 1)
      SetCVar("UIScale", scale)

      -- scale UIParent to native screensize
      UIParent:SetWidth(screenwidth)
      UIParent:SetHeight(screenheight)
      UIParent:SetPoint("CENTER",0,0)
      end


    local clr = 0.1294117647058824;
    local alpha = 1;