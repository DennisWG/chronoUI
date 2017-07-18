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
