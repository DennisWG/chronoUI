local Module = chronoUI:RegisterModule("Settings");
if not Module then return; end

Module:RegisterEvent("ADDON_LOADED");

local windowWidth = 600;
local windowHeight = 450;
local titleHeight = 30;
local panelWidth = 126;

function Module:ADDON_LOADED(name)
    if name ~= "chronoUI" then
        return;
    end
    
    if not self.myDb.enabled then
        return;
    end
    
    SLASH_CHRONOUI1 = "/chronoui";
    SLASH_CHRONOUI2 = "/cui";
    function SlashCmdList.CHRONOUI()
        if self.frame:IsVisible() then
            self.frame:Hide();
        else
            self.frame:Show();
        end
        self:Print("cui");
    end
    
    self:CreateFrame();
    self:Print("Settings loaded");
end

function Module:OpenProfiles()
    self:Print("Module:OpenProfiles()");
end

function Module:OpenPlayer()
    if not self.ProfilesWindow then
        local params = {
            --topToBottom = true,
            parent = self.frame,
            width = windowWidth - panelWidth,
            height = windowHeight - titleHeight,
            normalTexture = chronoUI.imageFolder.."Settings\\normal",
            selectedTexture = chronoUI.imageFolder.."Settings\\selected",
            tabWidth = 128,
            tabHeight = 32,
        };
        self.ProfilesWindow = chronoUI.Gui.TabFrame:new(nil, params);
        self.ProfilesWindow.frame:SetPoint("TOPLEFT", self.frame, "TOPLEFT", panelWidth + 1, -titleHeight - 1);
        
        self.ProfilesWindow:AddTab("Testing");
        self.ProfilesWindow:AddTab("Foo");
        self.ProfilesWindow:AddTab("Bar");
    end
    
    if self.ProfilesWindow.frame:IsVisible() then
        return;
    end
    
    self.ProfilesWindow.frame:Show();
    
    self:Print("Module:OpenPlayer()");
end

function Module:CreateCategory(name)
    self.frame[name] = CreateFrame("Button", nil, self.frame);
    self.frame[name]:SetWidth(128);
    self.frame[name]:SetHeight(32);
    self.frame[name]:SetNormalTexture(chronoUI.imageFolder.."Settings\\normal");
    
    self.frame[name].title = self.frame[name]:CreateFontString(nil, "OVERLAY");
    self.frame[name].title:SetJustifyH("CENTER");
    self.frame[name].title:SetFont(chronoUI.fontFolder.."DroidSansMono.ttf", 32, "OUTLINE");
    self.frame[name].title:SetPoint("LEFT", self.frame[name], "LEFT", 4, 0);
    self.frame[name].title:SetText(name);
    
    if not self.lastButton then
        self.frame[name]:SetPoint("TOPLEFT", self.frame, 0, -titleHeight - 1);
    else
        self.frame[name]:SetPoint("TOP", self.lastButton, "BOTTOM", 0, 1);
    end
    
    self.frame[name]:SetScript("OnClick", function()
        if self.selectedCategory then
            self.frame[self.selectedCategory]:SetNormalTexture(chronoUI.imageFolder.."Settings\\normal");
        end
        
        self.selectedCategory = name;
        self.frame[name]:SetNormalTexture(chronoUI.imageFolder.."Settings\\selected");
        
        self["Open"..name](self);
    end);
    
    self.lastButton = self.frame[name];
end

function Module:CreateFrame()
    local makeSeperator = function(width, height, texture)
        local texture = chronoUI.imageFolder..texture;
        local t = self.frame:CreateTexture(nil, "OVERLAY");
        t:SetWidth(width);
        t:SetHeight(height);
        t:SetTexture(texture);
        t:SetVertexColor(0, 0, 0, 1);
        
        return t;
    end
    
    -- Main Window
    do
        self.frame = CreateFrame("Frame");
        self.frame:SetWidth(windowWidth);
        self.frame:SetHeight(windowHeight);
        self.frame:SetPoint("CENTER", UIParent);
        --self.frame:SetFrameStrata("FULLSCREEN");
        self.frame:RegisterForDrag("LeftButton");
        self.frame:SetMovable(true);
        self.frame:EnableMouse(true);
        self.frame:SetClampedToScreen(true);
        self.frame:SetScript("OnDragStart", self.frame.StartMoving);
        self.frame:SetScript("OnDragStop", self.frame.StopMovingOrSizing);
        
        self.frame:SetBackdrop( { 
            bgFile = chronoUI.imageFolder.."bg-modern",
            edgeFile = chronoUI.imageFolder.."border-modern",
            tile = true, tileSize = 256, edgeSize = 16,
            --insets = { left = 4, right = 4, top = 4, bottom = 0 }
        });
        
        self.frame:SetBackdropBorderColor(0, 0, 0, 1);
        
        local seperator = makeSeperator(windowWidth, 2, "line-simple-horizontal");
        seperator:SetPoint("TOP", self.frame, "TOP", 0, -titleHeight);
        
        seperator = makeSeperator(2, windowHeight - 32, "line-simple-vertical");
        seperator:SetPoint("TOPLEFT", self.frame, "TOPLEFT", panelWidth, -titleHeight - 1);
    end
    
    -- Controls
    do
        self.frame.close = CreateFrame("Button", nil, self.frame);
        self.frame.close:SetWidth(24);
        self.frame.close:SetHeight(24);
        self.frame.close:SetNormalTexture(chronoUI.imageFolder.."close");
        self.frame.close:SetPushedTexture(chronoUI.imageFolder.."close-highlight");
        self.frame.close:SetPoint("TOPRIGHT", self.frame, -4, -4);
        self.frame.close:SetScript("OnClick", function() self.frame:Hide(); end);
        
        self.frame.title = self.frame:CreateFontString(nil, "OVERLAY");
        self.frame.title:SetJustifyH("CENTER");
        self.frame.title:SetFont(chronoUI.fontFolder.."DroidSansMono.ttf", 32, "OUTLINE");
        --self.frame.title:SetTextColor(0.74, 0.74, 0.74, 1);
        self.frame.title:SetPoint("TOP", self.frame, "TOP", 0, -5);
        self.frame.title:SetText("chronoUI Settings");
        
        --[[
        self:CreateCategory("Profiles");
        self:CreateCategory("Player");
        ]]
        
        -- Tab View
        do
            local params = {
                topToBottom = true,
                parent = self.frame,
                width = windowWidth,
                height = windowHeight - titleHeight,
                normalTexture = chronoUI.imageFolder.."Settings\\normal",
                selectedTexture = chronoUI.imageFolder.."Settings\\selected",
                tabWidth = 128,
                tabHeight = 32,
                fontSize = 32,
            };
            
            self.tabView = chronoUI.Gui.TabFrame:new(nil, params);
            self.tabView.frame:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, -titleHeight - 1);
            
            -- "Profiles" tab
            do
                local content = self.tabView:AddTab("Profiles").content;
            end
            -- "General" tab
            do
                local content = self.tabView:AddTab("General").content;
            end
            -- "Player" tab
            do
                local content = self.tabView:AddTab("Player").content;
                local params = {
                    parent = content,
                    width = windowWidth - 128,
                    height = windowHeight - titleHeight,
                    normalTexture = chronoUI.imageFolder.."Settings\\normal",
                    selectedTexture = chronoUI.imageFolder.."Settings\\selected",
                    tabWidth = 80,
                    tabHeight = 20,
                    fontSize = 12,
                };
                content.view = chronoUI.Gui.TabFrame:new(nil, params);
                content.view.frame:SetPoint("TOPLEFT", content);
                local t = content.view:AddTab("General");
                local t = content.view:AddTab("Hp Bar");
                local t = content.view:AddTab("Power Bar");
                local t = content.view:AddTab("Cast Bar");
            end
            
            self.tabView:SelectTab("Player");
        end
    end
end

function Module:InitializeDefaultProfile()
    self.myDb = --[[self.db[self.db.current]["Settings"] or]] {
        enabled = true,
    };
    
    return self.myDb;
end