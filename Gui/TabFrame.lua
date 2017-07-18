local Gui = chronoUI.Gui or {};
local TabFrame = chronoUI.Gui.TabFrame or {};
Gui.TabFrame = TabFrame;
chronoUI.Gui = Gui;

local function TabFrame_Create(self, name, creationParams)
    self.frame = Gui.makeFrame("Frame", self.width, self.height, name, creationParams.parent);
    
    self.frame:SetBackdrop( { 
        bgFile = chronoUI.imageFolder.."bg-modern",
        edgeFile = chronoUI.imageFolder.."border-modern",
        tile = true, tileSize = 256, edgeSize = 16,
    });
    
    self.frame:SetBackdropBorderColor(0, 0, 0, 1);
    self.frame:SetBackdropColor(0, 0, 0, 1);
end

-- Creates a TabFrame and writes it to self.frame
-- name: The name of the TabFrame
-- creationParams: A table containing all paremeters required for creating a TabFrame
function TabFrame:new(name, creationParams)
    local object = {
        impl = {
            tabs = {},
        },
        
        topToBottom = creationParams.topToBottom,
        normalTexture = creationParams.normalTexture,
        selectedTexture = creationParams.selectedTexture,
        width = creationParams.width,
        height = creationParams.height,
        tabWidth = creationParams.tabWidth,
        tabHeight = creationParams.tabHeight,
        fontSize = creationParams.fontSize,
    };
    
    setmetatable(object, self);
    self.__index = self;
    
    TabFrame_Create(object, name, creationParams);
    
    return object;
end

-- Adds a new Tab to the TabFrame and returns it
function TabFrame:AddTab(name)
    local parent = self.impl.lastTab or self.frame;
    
    local tab = Gui.makeFrame("Button", self.tabWidth, self.tabHeight, name, parent);
    tab:SetNormalTexture(self.normalTexture);
    
    if self.impl.lastTab then
        if self.topToBottom then
            tab:SetPoint("TOP", self.impl.lastTab, "BOTTOM", 0, 1);
        else
            tab:SetPoint("LEFT", self.impl.lastTab, "RIGHT", -1, 0);
        end
    else
        tab:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, 0);
    end
    
    tab:SetScript("OnClick", function()
        if self.impl.SelectedTab then
            local lastTab = self.impl.tabs[self.impl.SelectedTab];
            lastTab:SetNormalTexture(self.normalTexture);
            lastTab.content:Hide();
        end
        
        self.impl.SelectedTab = name;
        local newTab = self.impl.tabs[name];
        newTab:SetNormalTexture(self.selectedTexture);
        newTab.content:Show();
    end);
    
    tab.title = Gui.makeFontString(tab, chronoUI.fontFolder.."DroidSansMono.ttf", self.fontSize);
    tab.title:SetPoint("CENTER", tab, "CENTER", 0, 0);
    tab.title:SetText(name);
    
    local contentWidth = self.width;
    local contentHeight = self.height;
    local offsetX = 0;
    local offsetY = 0;
    
    if self.topToBottom then
        contentWidth = contentWidth - self.tabWidth;
        offsetX = self.tabWidth;
    else
        contentHeight = contentHeight - self.tabHeight;
        offsetY = -self.tabHeight;
    end
    
    tab.content = Gui.makeFrame("Frame", contentWidth, contentHeight, nil, tab);
    tab.content:SetPoint("TOPLEFT", self.frame, "TOPLEFT", offsetX, offsetY);
    
    tab.content:SetBackdrop( { 
        bgFile = chronoUI.imageFolder.."bg-modern",
        edgeFile = chronoUI.imageFolder.."border-modern",
        tile = true, tileSize = 256, edgeSize = 16,
    });
    
    tab.content:SetBackdropBorderColor(0, 0, 0, 1);
    tab.content:Hide();
    
    self.impl.lastTab = tab;
    self.impl.tabs[name] = tab;
    
    return tab;
end

-- Selects a tab by its given name
function TabFrame:SelectTab(name)
    self.impl.SelectedTab = name;
    local newTab = self.impl.tabs[name];
    newTab:SetNormalTexture(self.selectedTexture);
    newTab.content:Show();
end






