local Gui = chronoUI.Gui or {};
local AngledBar = Gui.AngledBar or {};
Gui.AngledBar = AngledBar;
chronoUI.Gui = Gui;

-- Creates an AngledBar and writes it to self.frame
local function AngledBar_Create(self)
    local makeTex = function(layer, width, height, texture)
        local clr = 0.1294117647058824;
        local alpha = 1;
        local t = self.frame:CreateTexture(nil, layer);
        t:SetHeight(height);
        t:SetWidth(width);
        t:SetTexture("Interface\\Addons\\chronoUI\\img\\"..texture);
        t:SetVertexColor(clr, clr, clr, alpha);
        return t;
    end
    
    local f = CreateFrame("Frame", nil, UIParent);
    f:SetFrameStrata("BACKGROUND");
    f:SetHeight(64);
    f:SetWidth(512);
    f:SetScale(0.6);
    self.frame = f;
    
    local barWidth = 512;
    local barHeight = 32;
    
    local barTexture = "hp-bar";
    local overlayTexture = "hp-bar-border";
    
    if self.flipBar then
        barTexture = barTexture.."-flipped";
        overlayTexture = overlayTexture.."-flipped";
    end

    f.background = makeTex("BACKGROUND", barWidth, barHeight, barTexture);
    f.background:SetPoint("CENTER", f);
    if self.invertColors then
        f.background:SetVertexColor(0.498, 0.0, 0.0, alpha);
    end

    f.overlay = makeTex("OVERLAY", barWidth, barHeight, overlayTexture);
    f.overlay:SetPoint("CENTER", f);
    f.overlay:SetVertexColor(0, 0, 0,alpha);
    
    f.bar = makeTex("BORDER", barWidth, barHeight, barTexture);
    f.bar:SetPoint("RIGHT", f.background);
    if not self.invertColors then
        f.bar:SetVertexColor(0.498, 0.0, 0.0, alpha);
    end
    
    return f;
end

-- Creates and returns a new AngledBar
-- invertColors: Inverts the colors of the forground and the background
-- leftToRightGrowth: The bar grows from left to right
-- flipBar: Flips the bar horizontally
function AngledBar:new(invertColors, leftToRightGrowth, flipBar)
    local object = {};
    setmetatable(object, self);
    self.__index = self;
    
    object.invertColors = invertColors or false;
    object.leftToRightGrowth = leftToRightGrowth or false;
    object.flipBar = flipBar or false;
    AngledBar_Create(object);
    
    return object;
end

-- Moves the bar to the given percentage
function AngledBar:SetBarPercentage(pct)
    local newWidth = pct / 100;
    
    if self.leftToRightGrowth then
        newWidth = (100 - pct) / 100;
    end
    
    self.frame.bar:SetTexCoordModifiesRect(true);
    self.frame.bar:SetTexCoord(0, newWidth, 0, 1);
end
