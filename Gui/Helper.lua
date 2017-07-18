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

