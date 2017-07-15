local Module = chronoUI:RegisterModule("PlayerFrame");
if not Module then return; end

Module:RegisterEvent("ADDON_LOADED");

function Module:ADDON_LOADED(name)
    if name ~= "chronoUI" then
        return;
    end
    self:Print("Hi!");
end

function Module:InitializeDefaultProfile()
    return {
        enabled = true,
    };
end