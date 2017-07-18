local Module = chronoUI:RegisterModule("PlayerFrame");
if not Module then return; end

local gfind = string.gmatch;
local sfind = string.find;

Module:RegisterEvent("ADDON_LOADED");

function Module:ADDON_LOADED(name)
    if name ~= "chronoUI" then
        return;
    end
    
    if self.myDb.enabled then
        self:CreateFrame();
        self:SetScript("OnUpdate", self.OnUpdate);
        
        if self.myDb.disableBlizzardCastBar then
            self:DisableBlizzardCastBar();
        end
    end
end

function Module:CreateFrame()
    local creationParams = {
        --scale = 4,
        scale = self.myDb.scale,
        hpBar = self.myDb.hpBar,
        powerBar = self.myDb.powerBar,
        castBar = self.myDb.castBar,
    };
    
    self.unitFrame = chronoUI.Gui.UnitFrame:new("chronoUIPlayerFrame", creationParams);
    self.unitFrame.frame:SetPoint("CENTER", UIParent, "CENTER", -360, 0);
end

function Module:ToggleDrag()
    if self.dragging then
        self.dragging = false;
        self.frame:SetBackdrop(nil);
        
        self.frame:SetMovable(false);
    else
        self.dragging = true;
        self.frame:SetBackdrop( { 
            bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 16, 
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        });
        
        self.frame:SetBackdropColor(0,0,0,1);
        
        self.frame:SetMovable(true);
    end
end

function Module:OnUpdate(timeDelta)
    local healthPct = 100 / UnitHealthMax("player") * UnitHealth("player");
    local powerPct = 100 / UnitManaMax("player") * UnitMana("player");
    
    if self.myDb.hpBar.enabled then
        self.unitFrame.frame.hpBar:SetBarPercentage(healthPct);
        self.unitFrame.frame.hp:SetText(UnitHealth("player").." / "..UnitHealthMax("player").." ("..chronoUI.Round(healthPct,1).."%)");
    end
    
    self.unitFrame.frame.powerBar:SetBarPercentage(powerPct);
    
    self.unitFrame.frame.power:SetText(UnitMana("player").." / "..UnitManaMax("player").." ("..chronoUI.Round(powerPct,1).."%)");
    
    self.total = self.total or 0;
    self.total = self.total + timeDelta * 10;
    self.total2 = self.total2 or 30;
    self.total2 = self.total2 + timeDelta * 10;
    
    --self.unitFrame.frame.hpBar:SetBarPercentage(self.total);
    --self.unitFrame.frame.powerBar:SetBarPercentage(self.total2);
    --self.unitFrame.frame.castBar.bar:SetBarPercentage(self.total);
    --self.unitFrame.frame.castBar.bar.frame:Show();
    
    if(self.total >= 100) then
        self.total = 0;
    end
    if(self.total2 >= 100) then
        self.total2 = 0;
    end
end

function Module:InitializeDefaultProfile()
    self.myDb = self.db[self.db.current]["PlayerFrame"] or {
        enabled = true,
        disableBlizzardCastBar = true,
        scale = 0.6,
        hpBar = {
            enabled = true,
            leftToRight = true,
            invertColors = false,
            foregroundColor = {0.129, 0.129, 0.129, 1.000},
            backgroundColor = {0.498, 0.000, 0.000, 0.4000},
            font = "Interface\\Addons\\chronoUI\\Fonts\\DroidSansMono.ttf",
            fontSize = 18,
            fontColor = {0.74, 0.74, 0.74, 1},
        },
        powerBar = {
            enabled = true,
            leftToRight = true,
            invertColors = false,
            flipBar = true,
            isShort = true,
            foregroundColor = {0.129, 0.129, 0.129, 1.000},
            backgroundColor = {0.000, 0.000, 0.698, 0.4000},
            font = "Interface\\Addons\\chronoUI\\Fonts\\DroidSansMono.ttf",
            fontSize = 18,
            fontColor = {0.74, 0.74, 0.74, 1},
        },
        castBar = {
            enabled = true,
            leftToRight = true,
            invertColors = false,
            foregroundColor = {0.988, 0.470, 0.019, 1.000},
            backgroundColor = {0.129, 0.129, 0.129, 1.000},
            barTexture = "cast-bar",
            borderTexture = "cast-bar-border",
            barHeight = 16,
            font = "Interface\\Addons\\chronoUI\\Fonts\\DroidSansMono.ttf",
            fontSize = 28,
            fontColor = {1.000, 1.000, 1.000, 1.000},
        }
    };
    
    return self.myDb;
end

function Module:UpdateSetting(name, newValue)
    local reload;
    local subName = "";
    
    if sfind(name, "%.") then
        subName, name = gfind(name, "(.*%.)(.*)")();
    end
    
    if name == "enabled" and subName == "" then
        chronoUI.EnsureType(newValue, "boolean");
        newValue = not not newValue;
        
        if newValue then
            self:SetScript("OnUpdate", self.OnUpdate);
            self.unitFrame.frame:Show();
            
            if self.myDb.disableBlizzardCastBar then
                self:DisableBlizzardCastBar();
            end
        else
            self:SetScript("OnUpdate", nil);
            self.unitFrame.frame:Hide();
            self:EnableBlizzardCastBar();
        end
    -- name == "enabled"
    elseif name == "disableBlizzardCastBar" then
        chronoUI.EnsureType(newValue, "boolean");
        newValue = not not newValue;
        
        if newValue then
            self:DisableBlizzardCastBar();
        else
            self:EnableBlizzardCastBar();
        end
    --name == "disableBlizzardCastBar"
    elseif name == "scale" then
        chronoUI.EnsureType(newValue, "number");
        reload = true;
    --name == "scale"
    elseif name == "enabled" then
        chronoUI.EnsureType(newValue, "boolean");
        newValue = not not newValue;
        reload = true;
    --name == "enabled"
    elseif name == "leftToRight" then
        chronoUI.EnsureType(newValue, "boolean");
        newValue = not not newValue;
        reload = true;
    --name == "leftToRight"
    elseif name == "invertColors" then
        chronoUI.EnsureType(newValue, "boolean");
        newValue = not not newValue;
        reload = true;
    --name == "invertColors"
    elseif name == "flipBar" then
        chronoUI.EnsureType(newValue, "boolean");
        newValue = not not newValue;
        reload = true;
    --name == "flipBar"
    elseif name == "isShort" then
        chronoUI.EnsureType(newValue, "boolean");
        newValue = not not newValue;
        reload = true;
    --name == "isShort"
    elseif name == "foregroundColor" then
        chronoUI.EnsureType(newValue, "table");
        newValue = not not newValue;
        reload = true;
    --name == "foregroundColor"
    elseif name == "backgroundColor" then
        chronoUI.EnsureType(newValue, "table");
        newValue = not not newValue;
        reload = true;
    --name == "backgroundColor"
    elseif name == "font" then
        chronoUI.EnsureType(newValue, "string");
        newValue = not not newValue;
        reload = true;
    --name == "font"
    elseif name == "fontSize" then
        chronoUI.EnsureType(newValue, "number");
        newValue = not not newValue;
        reload = true;
    --name == "fontSize"
    elseif name == "fontColor" then
        chronoUI.EnsureType(newValue, "table");
        newValue = not not newValue;
        reload = true;
    --name == "fontColor"
    end
    
    RunScript("chronoUI.Modules.PlayerFrame.myDb."..subName..name.."="..tostring(newValue));
    if reload then
        self.unitFrame.frame:Hide();
        return self:CreateFrame();
    end
end

function Module:DisableBlizzardCastBar()
    CastingBarFrame.ShowOrig = CastingBarFrame.Show;
    CastingBarFrame.Show = function() end;
end

function Module:EnableBlizzardCastBar()
    if CastingBarFrame.ShowOrig then
        CastingBarFrame.Show = CastingBarFrame.ShowOrig;
    end
end
