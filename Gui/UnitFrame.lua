local Gui = chronoUI.Gui or {};
local UnitFrame = chronoUI.Gui.UnitFrame or {};
Gui.UnitFrame = UnitFrame;
chronoUI.Gui = Gui;

-- The width of the UnitFrame
local frameWidth = 512;
-- The height of the UnitFrame
local frameHeight = 85;

-- Creates a UnitFrame and writes it to self.frame
-- name: The name of the UnitFrame
-- creationParams: A table containing all paremeters required for creating a UnitFrame
local function UniFrame_Create(self, name, creationParams)
    if not self then error("self == nil") end
    if not name then error("name == nil") end
    
    local f = Gui.makeFrame("Button", frameWidth, frameHeight, name, UIParent, "SecureUnitButtonTemplate");
    
    -- Initialize f
    do
        f:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", add);
        f:SetFrameStrata("BACKGROUND");
        f:SetScale(creationParams.scale);
        
        f:RegisterForDrag("LeftButton");
        f:SetMovable(true);
        --f:SetScript("OnDragStart", f.StartMoving);
        --f:SetScript("OnDragStop", f.StopMovingOrSizing);

        f:RegisterForClicks('LeftButtonUp', 'RightButtonUp');
        f:SetAttribute("*type1", "target");
        f:SetAttribute("*type2", "menu");
        f:SetScript("OnEnter",ShowTooltip);
        f:SetScript("OnLeave",HideTooltip);
        
        local showmenu = function()
            ToggleDropDownMenu(1, nil, PlayerFrameDropDown, "PlayerFrame", 106, 27);
        end
        SecureUnitButton_OnLoad(f, "player", showmenu);
        self.frame = f;
    end

    local hpBar = chronoUI.Gui.AngledBar:new(nil, creationParams.hpBar);
    -- Initialize hpBar
    do
        hpBar.frame:SetParent(f);
        hpBar.frame:SetPoint("TOP", f);
        hpBar:SetBarPercentage(75);
        f.hpBar = hpBar;
    end

    local powerBar = chronoUI.Gui.AngledBar:new(nil, creationParams.powerBar);
    -- Initialize powerBar
    do
        powerBar.frame:SetParent(f);
        
        local inset = 0;
        if creationParams.powerBar.isShort then inset = -14; end
        
        f.power = Gui.makeFontString(
            powerBar.frame,
            creationParams.powerBar.font,
            creationParams.powerBar.fontSize,
            creationParams.powerBar.fontColor
        );
        powerBar.frame:SetPoint("TOP", hpBar.frame, "BOTTOM", inset, 0);
        powerBar:SetBarPercentage(75);
        f.powerBar = powerBar;
    end

    -- Initialize FontStrings
    do
        local params = {
            powerBar.frame,
            creationParams.hpBar.font,
            creationParams.hpBar.fontSize,
            creationParams.hpBar.fontColor
        };
        f.name = Gui.makeFontString(unpack(params));
        f.name:SetPoint("RIGHT", hpBar.frame, "RIGHT", 0, 32);
        f.name:SetText(UnitName("player"));
        
        f.level = Gui.makeFontString(unpack(params));
        f.level:SetPoint("RIGHT", f.name, "LEFT", 0, 0);
        f.level:SetText(UnitLevel("player").." - ");
        
        f.hp = Gui.makeFontString(unpack(params));
        f.hp:SetPoint("LEFT", hpBar.frame, "LEFT", 50, 0);
        
        f.power:SetPoint("LEFT", powerBar.frame, "LEFT", 120, 0);
    end
    
    local castBar = chronoUI.Gui.CastBar:new(name.."CastBar", creationParams.castBar);
    -- Initialize castBar
    do
        castBar.bar.frame:SetParent(f);
        castBar.bar.frame:SetPoint("RIGHT", UIParent, "CENTER", 0, -250);
        castBar.bar:SetBarPercentage(25);
        f.castBar = castBar;
    end
    
    return f;
end

function UnitFrame:new(name, creationParams)
    local object = {
    };
    
    setmetatable(object, self);
    self.__index = self;
    
    UniFrame_Create(object, name, creationParams);
    
    return object;
end

function UnitFrame:ToggleDrag()
    self.frame.castBar.bar:ToggleDrag();
    if self.dragging then
        self.dragging = false;
        self.frame:SetBackdrop(nil);
        
        self.frame:SetScript("OnDragStart", nil);
        self.frame:SetScript("OnDragStop", nil);
    else
        self.frame.castBar.bar.frame:Show()
        self.dragging = true;
        self.frame:SetBackdrop( { 
            bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
            edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
            tile = true, tileSize = 16, edgeSize = 16, 
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        });
        
        self.frame:SetBackdropColor(0,0,0,1);
        
        self.frame:SetScript("OnDragStart", self.frame.StartMoving);
        self.frame:SetScript("OnDragStop", self.frame.StopMovingOrSizing);
    end
end
