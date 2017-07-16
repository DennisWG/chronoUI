local Gui = chronoUI.Gui or {};
local AngledBar = Gui.AngledBar or {};
Gui.AngledBar = AngledBar;
chronoUI.Gui = Gui;

-- Creates an AngledBar and writes it to self.frame
local function AngledBar_Create(self)
    local makeTex = function(layer, width, height, texture)
        local t = self.frame:CreateTexture(nil, layer);
        t:SetHeight(height);
        t:SetWidth(width);
        t:SetTexture("Interface\\Addons\\chronoUI\\img\\"..texture);
        if self.invertColors then
            t:SetVertexColor(self.foregroundColor[1], self.foregroundColor[2], self.foregroundColor[3], self.foregroundColor[4]);
        else
            t:SetVertexColor(self.backgroundColor[1], self.backgroundColor[2], self.backgroundColor[3], self.backgroundColor[4]);
        end
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

    f.overlay = makeTex("OVERLAY", barWidth, barHeight, overlayTexture);
    f.overlay:SetPoint("CENTER", f);
    f.overlay:SetVertexColor(0, 0, 0,alpha);
    
    f.bar = makeTex("BORDER", barWidth, barHeight, barTexture);
    f.bar:SetPoint("RIGHT", f.background);
    if self.invertColors then
        f.bar:SetVertexColor(self.backgroundColor[1], self.backgroundColor[2], self.backgroundColor[3], self.backgroundColor[4]);
    else
        f.bar:SetVertexColor(self.foregroundColor[1], self.foregroundColor[2], self.foregroundColor[3], self.foregroundColor[4]);
    end
end

-- Creates and returns a new AngledBar
-- foregroundColor: The color of the foreground. Defaults to 0.129|0.129|0.129|1.000 (rgba)
-- backgroundColor: The color of the background. Defaults to 0.498|0.000|0.000|1.000 (rgba)
-- invertColors: Inverts the colors of the forground and the background. Defaults to false
-- leftToRightGrowth: The bar grows from left to right. Defaults to false
-- flipBar: Flips the bar horizontally. Defaults to false
function AngledBar:new(foregroundColor, backgroundColor, invertColors, leftToRightGrowth, flipBar)
    local object = {};
    setmetatable(object, self);
    self.__index = self;
    
    object.foregroundColor = foregroundColor or {0.129, 0.129, 0.129, 1.000};
    object.backgroundColor = backgroundColor or {0.498, 0.000, 0.000, 1.000};
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
