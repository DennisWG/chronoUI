local Gui = chronoUI.Gui or {};
local CastBar = chronoUI.Gui.CastBar or {};
Gui.CastBar = CastBar;
chronoUI.Gui = Gui;

-- The width of the CastBar
local frameWidth = 512;
-- The height of the CastBar
local frameHeight = 32;

-- Creates a CastBar and writes it to self.frame
-- name: The name of the CastBar
-- creationParams: A table containing all paremeters required for creating a CastBar
local function CastBar_Create(self, name, creationParams)
    
    local castBar = chronoUI.Gui.AngledBar:new(nil, creationParams);
    -- Initialize castBar
    do
        castBar.frame:SetScript("OnUpdate", function(self, timeDelta)
            if not self.currentSpellInfo then
                return;
            end
            
            local info = self.currentSpellInfo;            
            local currentTime = GetTime();
            local percentage = (info.endTime - currentTime) / (info.endTime - info.startTime) * 100;
            
            castBar:SetBarPercentage(100 - percentage);
            
            castBar.frame.timer:SetText(string.format("%.1f", info.endTime - currentTime));
        end);
        
        castBar.frame:SetScript("OnEvent", function(self, event, unit, spell, rank, c, d, e)
            if event == "UNIT_SPELLCAST_STOP"
            or event == "UNIT_SPELLCAST_CHANNEL_STOP"
            or event == "UNIT_SPELLCAST_FAILED"
            or event == "UNIT_SPELLCAST_INTERRUPTED" then
                self.currentSpellInfo = nil;
                self.currentCastTime = nil;
                return self:Hide();
            end
            
            if not spell then
                return;
            end
            
            local fullSpellName = spell;
            if rank and rank ~= "" then
                fullSpellName = fullSpellName.."("..rank..")";
            end
            
            local name, rank, _, icon, startTime, endTime = UnitCastingInfo(unit);
            
            if not name or not rank or not icon or not info then
                return;
            end
            
            self:Show();
            
            castBar.frame.name:SetText(fullSpellName);
            self.icon:SetTexture(icon);
            
            self.currentSpellInfo = { 
                name = name,
                rank = rank,
                icon = icon,
                startTime = startTime * 0.001,
                endTime = endTime * 0.001,
                delay = 0,
            };
            
            self.currentCastTime = 0;
        end);
        
        castBar.frame:RegisterEvent("UNIT_SPELLCAST_START");
        castBar.frame:RegisterEvent("UNIT_SPELLCAST_STOP");
        castBar.frame:RegisterEvent("UNIT_SPELLCAST_DELAYED");
        castBar.frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START");
        castBar.frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP");
        castBar.frame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_UPDATE");
        castBar.frame:RegisterEvent("UNIT_SPELLCAST_FAILED");
        castBar.frame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED");
        castBar.frame:Hide();
        self.bar = castBar;
    end
    
    -- Create Icons and FontStrings
    do
        castBar.frame.icon = castBar.frame:CreateTexture(nil, "OVERLAY");
        castBar.frame.icon:SetHeight(64);
        castBar.frame.icon:SetWidth(64);
        castBar.frame.icon:SetPoint("BOTTOMRIGHT", castBar.frame, "TOPRIGHT");
        castBar.frame.icon:SetTexture("Interface\\Icons\\Spell_Nature_HealingTouch");
        
        castBar.frame.name = castBar.frame:CreateFontString(nil, "OVERLAY");
        castBar.frame.name:SetJustifyH("CENTER");
        castBar.frame.name:SetFont(creationParams.font, creationParams.fontSize, "OUTLINE");
        castBar.frame.name:SetTextColor(unpack(creationParams.fontColor));
        castBar.frame.name:SetPoint("RIGHT", castBar.frame.icon, "LEFT", 0, 0);
        castBar.frame.name:SetText("Healing Touch(Rank2)");
        
        castBar.frame.timer = castBar.frame:CreateFontString(nil, "OVERLAY");
        castBar.frame.timer:SetJustifyH("CENTER");
        castBar.frame.timer:SetFont(creationParams.font, creationParams.fontSize, "OUTLINE");
        castBar.frame.timer:SetTextColor(unpack(creationParams.fontColor));
        castBar.frame.timer:SetPoint("RIGHT", castBar.frame, "LEFT", 0, 0);
        castBar.frame.timer:SetText("1.5");
    end
end

function CastBar:new(name, creationParams)
    local creationParams = creationParams or {};
    creationParams.barTexture = creationParams.barTexture or "cast-bar";
    creationParams.borderTexture = creationParams.borderTexture or "cast-bar-border";
    creationParams.barHeight = creationParams.barHeight  or 16;
    
    local object = {
    };
    
    setmetatable(object, self);
    self.__index = self;
    
    CastBar_Create(object, name, creationParams);
    
    return object;
end