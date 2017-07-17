local Gui = chronoUI.Gui or {};
local AngledBar = Gui.AngledBar or {};
Gui.AngledBar = AngledBar;
chronoUI.Gui = Gui;

-- The size of the bar textures
local barWidth = 512;
-- The size of the small bar textures
local smallBarWidth = 438;

-- Creates an AngledBar and writes it to self.frame
-- name: The name of the AngledBar. Must be set if the user can place this frame
local function AngledBar_Create(self, name, creationParams)
    local makeTex = function(layer, width, height, texture)
        local t = self.frame:CreateTexture(nil, layer);
        t:SetHeight(height);
        t:SetWidth(width);
        t:SetTexture("Interface\\Addons\\chronoUI\\img\\"..texture);
        if creationParams.invertColors or creationParams.leftToRightGrowth then
            t:SetVertexColor(unpack(creationParams.foregroundColor));
        else
            t:SetVertexColor(unpack(creationParams.backgroundColor));
        end
        return t;
    end
    
    local barHeight = 32;
    
    local f = CreateFrame("Frame", name, UIParent);
    f:SetFrameStrata("BACKGROUND");
    f:SetHeight(barHeight + 10);
    f:SetWidth(barWidth);
    f:RegisterForDrag("LeftButton");
    f:SetScript("OnDragStart", f.StartMoving);
    f:SetScript("OnDragStop", f.StopMovingOrSizing);
    self.frame = f;
    
    local barTexture = "hp-bar";
    local overlayTexture = "hp-bar-border";
    
    if creationParams.isShort then
        barTexture = barTexture.."-short";
        overlayTexture = overlayTexture.."-short";
    end
    
    if creationParams.flipBar then
        barTexture = barTexture.."-flipped";
        overlayTexture = overlayTexture.."-flipped";
    end

    f.background = makeTex("BACKGROUND", barWidth, barHeight, barTexture);
    f.background:SetPoint("CENTER", f);

    f.overlay = makeTex("OVERLAY", barWidth, barHeight, overlayTexture);
    f.overlay:SetPoint("RIGHT", f);
    f.overlay:SetVertexColor(0, 0, 0,alpha);
    
    f.bar = makeTex("BORDER", barWidth, barHeight, barTexture);
    f.bar:SetPoint("RIGHT", f.background);
    if creationParams.invertColors or creationParams.leftToRightGrowth then
        f.bar:SetVertexColor(unpack(creationParams.backgroundColor));
    else
        f.bar:SetVertexColor(unpack(creationParams.foregroundColor));
    end
end

-- Creates and returns a new AngledBar
-- name: The name of the AngledBar. Must be set if the user can place this frame
-- creationParams.foregroundColor: The color of the foreground. Defaults to 0.129|0.129|0.129|1.000 (rgba)
-- creationParams.backgroundColor: The color of the background. Defaults to 0.498|0.000|0.000|1.000 (rgba)
-- creationParams.invertColors: Inverts the colors of the forground and the background. Defaults to false
-- creationParams.leftToRight: The bar grows from left to right. Defaults to false
-- creationParams.flipBar: Flips the bar horizontally. Defaults to false
-- creationParams.isShort: Uses the shorter bar texture if set. Defaults to false
function AngledBar:new(name, creationParams)
    local creationParams = creationParams or {};
    creationParams.foregroundColor = creationParams.foregroundColor or {0.129, 0.129, 0.129, 1.000};
    creationParams.backgroundColor = creationParams.backgroundColor or {0.498, 0.000, 0.000, 1.000};
    creationParams.invertColors = creationParams.invertColors or false;
    creationParams.leftToRightGrowth = creationParams.leftToRightGrowth or false;
    creationParams.flipBar = creationParams.flipBar or false;
    creationParams.isShort = creationParams.isShort or false;
    
    local object = {
        leftToRightGrowth = creationParams.leftToRight or false,
        isShort = creationParams.isShort or false,
    };
    
    setmetatable(object, self);
    self.__index = self;
    
    AngledBar_Create(object, name, creationParams);
    
    return object;
end

-- Moves the bar to the given percentage
function AngledBar:SetBarPercentage(pct)
    local width = barWidth;
    local missing = 0;
    
    if self.isShort then
        width = smallBarWidth;
        missing = (barWidth - smallBarWidth) / barWidth;
    end
    
    local relativeWidth = width / barWidth;
    local newWidth = relativeWidth * pct / 100 + missing;
    
    if self.leftToRightGrowth then
        newWidth = relativeWidth * (100 - pct) / 100 + missing;
    end
    
    self.frame.bar:SetTexCoordModifiesRect(true);
    self.frame.bar:SetTexCoord(0, newWidth, 0, 1);
end

function AngledBar:ToggleDrag()
    if self.dragging then
        self.dragging = false;
        self.frame:SetBackdrop(nil);
        
        self.frame:SetMovable(false);
        self.frame:EnableMouse(false);
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
        self.frame:EnableMouse(true);
    end
end
