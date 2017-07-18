local Gui = chronoUI.Gui or {};
chronoUI.Gui = Gui;

-- Creates a FontString from the given parent and returns it
-- parent: The frame to which this FontString belongs
-- font: The font to use
-- fontSize: The font size to use
-- fontColor: An array of normalized colors arranged in the order {r,g,b,a}
-- returns: The newly created FontString
function Gui.makeFontString(parent, font, fontSize, fontColor)
    local f = parent:CreateFontString(nil, "OVERLAY");
    f:SetJustifyH("CENTER");
    f:SetFont(font, fontSize, "OUTLINE");
    if fontColor then f:SetTextColor(unpack(fontColor)); end
    return f;
end

-- Creates a Texture from the given parent and returns it
-- parent: The frame to which this Texture belongs
-- layer: he layer to the Texture should be drawn in
-- width: The width of the Texture
-- height: The height of the Texture
-- texture: The relative path from `chronoUI.imageFolder` to the texture
-- color: An array of normalized colors arranged in the order {r,g,b,a}
function Gui.makeTexture(parent, layer, width, height, texture, color)
    local t = parent:CreateTexture(nil, layer);
    t:SetHeight(height);
    t:SetWidth(width);
    if texture then t:SetTexture(chronoUI.imageFolder..texture); end
    if color then t:SetVertexColor(unpack(color)); end
    return t;
end

-- Creates a Frame from the given parameters
-- frameType: The type of frame to create
-- width: The width of the frame
-- height: The height of the frame
-- name: The name of the frame
-- parent: The frame's parent frame
-- inherits: The frame from which to inherit
function Gui.makeFrame(frameType, width, height, name, parent, inherits)
    local f = CreateFrame(frameType, name, parent, inherits);
    f:SetWidth(width);
    f:SetHeight(height);
    return f;
end

-- Creates a CheckButton from the given parameters
-- width: The width of the CheckButton
-- height: The height of the CheckButton
-- parent: The CheckButton's parent frame
-- state: The state the button should occupy after creation
-- callback: Will be called when the CheckButton is clicked. Takes the CheckButton as a parameter
-- normalTexture: The texture of the CheckButton when it is disabled. Defaults to "Settings\\checkbutton"
-- checkedTexture: The texture of the CheckButton when it is checked. Defaults to "Settings\\checkbutton-checked"
function Gui.makeCheckButton(width, height, parent, state, callback, normalTexture, checkedTexture)
    local f = Gui.makeFrame("CheckButton", width, height, nil, parent);
    
    f.normalTexture = chronoUI.imageFolder..(normalTexture or "Settings\\checkbutton");
    f.checkedTexture = chronoUI.imageFolder..(checkedTexture or "Settings\\checkbutton-checked");
    
    if state then
        f:SetNormalTexture(f.checkedTexture);
    else
        f:SetNormalTexture(f.normalTexture);
    end
    
    -- TODO: Doesn't work without. Investigate
    f:SetScript("OnShow", function() this:SetChecked(state); end);
    
    f:SetScript("OnClick", function()
        if this:GetChecked() then
            this:SetNormalTexture(this.checkedTexture);
        else
            this:SetNormalTexture(this.normalTexture);
        end
        if callback then
            callback(this);
        end
    end);
    
    return f;
end

-- Creates a Slider from the given parameters
-- name: The text the Slider will be labeled with. (Not the global name)
-- width: The width of the Slider
-- parent: The Slider's parent frame
-- min: The smallest possible value
-- max: The biggest possible value
-- initial: The value the Slider starts with
-- callback: Gets called when the Slider's value changes. Takes the slider as a parameter
function Gui.makeSlider(name, width, parent, min, max, step, initial, callback)
    local f = Gui.makeFrame("Slider", width, 8, nil, parent);
    f:SetOrientation("HORIZONTAL");
    f:SetThumbTexture(chronoUI.imageFolder.."slider-thumb");
    f:SetMinMaxValues(min, max);
    f:SetValueStep(step);
    f:SetValue(initial);
    f:SetBackdrop( { 
        bgFile = chronoUI.imageFolder.."bg-modern",
        edgeFile = chronoUI.imageFolder.."border-narrow",
        
        tile = true, tileSize = 256, edgeSize = 4,
    });
    f:SetBackdropBorderColor(0, 0, 0, 1);
    
    f.name = Gui.makeFontString(f, chronoUI.fontFolder.."DroidSansMono.ttf", 10);
    f.name:SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 8);
    f.name:SetText(name);
    
    f.min = Gui.makeFontString(f, chronoUI.fontFolder.."DroidSansMono.ttf", 8);
    f.min:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, 0);
    f.min:SetText(min);
    
    f.max = Gui.makeFontString(f, chronoUI.fontFolder.."DroidSansMono.ttf", 8);
    f.max:SetPoint("TOPRIGHT", f, "BOTTOMRIGHT", 0, 0);
    f.max:SetText(max);
    
    f.current = Gui.makeFontString(f, chronoUI.fontFolder.."DroidSansMono.ttf", 8);
    f.current:SetPoint("TOP", f, "BOTTOM", 0, 0);
    f.current:SetText(chronoUI:Round(initial, 1));
    
    f:SetScript("OnValueChanged", function()
        this.current:SetText(chronoUI:Round(this:GetValue(), 1));
        if callback then
            callback(this);
        end
    end);
    
    return f;
end
