----------------------------------------RUKSTONE----------------------------------------
local indexEE = 0;
local ScrollViewSpellList_BG;
local ScrollViewSpellsButton = {
    ["Helpful"] = {},
    ["Harmful"] = {}
};
local SpellWacherSearchBox;     -- the spell name in the edit box.
local SPellWacherButtonDisplay; -- the button that control the display of the spell
local SelectedSpellWacher;      -- the current selected spell (ID) from the GLOBAL wacher
local SelectedSpellDescription;
local SelectedSpellType = "Helpful";
function Healbot_OnSpellWacher_TabChange(key)
    if key ~= SelectedSpellType then
        SelectedSpellDescription:SetText("Select Spell");
        SelectedSpellWacher = nil;
    end
    SelectedSpellType = key;

    if key == "Helpful" then
        for k, x in pairs(ScrollViewSpellsButton["Helpful"]) do
            x:Show();
        end
        for k, x in pairs(ScrollViewSpellsButton["Harmful"]) do
            x:Hide();
        end
    else
        for k, x in pairs(ScrollViewSpellsButton["Helpful"]) do
            x:Hide();
        end

        for k, x in pairs(ScrollViewSpellsButton["Harmful"]) do
            x:Show();
        end
    end

    SPellWacherButtonDisplay:Hide();
end
function Healbot_OnSpellWacherScroll_Load(ScrollView) --this function is called only on "OnLoad"
    ScrollViewSpellList_BG = CreateFrame("Frame", nil, ScrollView);
    ScrollViewSpellList_BG:SetSize(200, 300);
    ScrollViewSpellList_BG.bg = ScrollViewSpellList_BG:CreateTexture(nil, "BACKGROUND");
    ScrollViewSpellList_BG.bg:SetAllPoints(true);
    ScrollView:SetScrollChild(ScrollViewSpellList_BG)
    SelectedSpellDescription = ScrollView:CreateFontString(nil, "OVERLAY", "GameFontNormal");
    SelectedSpellDescription:SetPoint("TOPLEFT", 250, 170);
    SelectedSpellDescription:SetSize(200, 300);
    SelectedSpellDescription:SetText("Select the spell in the list at your left and change the display mode using the button below");
    SelectedSpellDescription:SetTextHeight(18);
    if HealBot_GlobalsDefaults.WatchHoT[HealBot_PlayerClass_ER] then
        for k, v in pairs(HealBot_GlobalsDefaults.WatchHoT[HealBot_PlayerClass_ER]) do
            Healbot_WatchHot_Create_Spell_Button(k, "Helpful")
        end
    end

    indexEE = 0;
    for k, v in pairs(HealBot_GlobalsDefaults.Debuff_IgnoreList_R) do
        Healbot_WatchHot_Create_Spell_Button(k, "Harmful")
    end
    Hb_WachHotBlock()
    Healbot_OnSpellWacher_TabChange("Helpful");
end
function Healbot_SpellWacherOnTextChange(button)
    if ScrollViewSpellsButton[SelectedSpellType] then
        SpellWacherSearchBox = button:GetText()
        indexEE = 0;
        for k, value in pairs(ScrollViewSpellsButton[SelectedSpellType]) do
            if Healbot_StringSearch(k, SpellWacherSearchBox) then
                value:Show();
                value:SetPoint("TOP", ScrollViewSpellList_BG, "TOP", 0, indexEE)
                indexEE = indexEE - 30;
            elseif not Healbot_StringSearch(k, SpellWacherSearchBox) then
                value:Hide();
            else
                value:Show();
            end
        end
    end
end
function Healbot_StringSearch(value, StartWith)
    StartWith = string.lower(StartWith);
    value = string.lower(value);

    return value:sub(0, #StartWith) == StartWith;
end
local function MyFrameOnclick(self)
    local r = false;
    if SelectedSpellType == "Helpful" then
        if HealBot_Globals.WatchHoT[HealBot_PlayerClass_ER][SelectedSpellWacher] then
            if HealBot_Globals.WatchHoT[HealBot_PlayerClass_ER][SelectedSpellWacher] == 1 then
                HealBot_Globals.WatchHoT[HealBot_PlayerClass_ER][SelectedSpellWacher] = 2;
                SPellWacherButtonDisplay:SetText("Self Cast Only")
                r = true;
            elseif HealBot_Globals.WatchHoT[HealBot_PlayerClass_ER][SelectedSpellWacher] == 2 then
                HealBot_Globals.WatchHoT[HealBot_PlayerClass_ER][SelectedSpellWacher] = 3;
                SPellWacherButtonDisplay:SetText("ALL")
                r = true;
            elseif HealBot_Globals.WatchHoT[HealBot_PlayerClass_ER][SelectedSpellWacher] == 3 then
                HealBot_Globals.WatchHoT[HealBot_PlayerClass_ER][SelectedSpellWacher] = 1;
                SPellWacherButtonDisplay:SetText("Dont Show")
                r = true;

            end
        end
    else
        if HealBot_Globals.Debuff_IgnoreList_R[SelectedSpellWacher] == true then
            HealBot_Globals.Debuff_IgnoreList_R[SelectedSpellWacher] = false;
            SPellWacherButtonDisplay:SetText("Hide")
            SelectedSpellDescription:SetText("[" ..
                SelectedSpellWacher .. "]" .. " Will be Displayed on the UI")
            r = true;
        else
            HealBot_Globals.Debuff_IgnoreList_R[SelectedSpellWacher] = true;
            SPellWacherButtonDisplay:SetText("Show")
            SelectedSpellDescription:SetText("[" ..
                SelectedSpellWacher .. "]" .. " Will be hidden on the UI")
            r = true;
        end
    end
    if r == true then
        --reset the HUD for the new config
        HealBot_SetResetFlag("SOFT"); 
    end

end
function Healbot_OnSpellButtonClickDisplayHotOption(self) --this function is called on LOAD.
    SelectedSpellWacher = HEALBOT_RENEW;
    SPellWacherButtonDisplay = self;
    SPellWacherButtonDisplay:HookScript("OnClick", MyFrameOnclick)
    SPellWacherButtonDisplay:HookScript("OnEnter", Healbot_OnEnter_123)
    SPellWacherButtonDisplay:HookScript("OnLeave", Healbot_OnLeave_123)
    --SPellWacherButtonDisplay:SetText("Self Cast Only");
    --MyFrameOnclick(self,SPellWacherButtonDisplay)
end
function Healbot_OnEnter_123(self, motion)
    GameTooltip:SetOwner(self, "ANCHOR_TOP")
    if self:GetText() == "Self Cast Only" then
        GameTooltip:AddLine("" .. "[" .. SelectedSpellWacher .. "]" .. " Will only show on the HUD if casted by yorself.")
    elseif self:GetText() == "ALL" then
        GameTooltip:AddLine("" ..
            "[" .. SelectedSpellWacher .. "]" .. " will show on the HUD if a player have this spell active.")
    elseif self:GetText() == "Dont Show" then
        GameTooltip:AddLine("" .. "[" .. SelectedSpellWacher .. "]" .. " will not Show on HUD")
    end
    GameTooltip:Show()
end
function Healbot_OnLeave_123(self, motion)
    GameTooltip:Hide()
end
local function Btt_click_ed(self, ...) --this function is called when player click on one of the spells / it will select the current spell and the current state of it.
    SPellWacherButtonDisplay:Show();
    SelectedSpellWacher = self:GetText();
    if SelectedSpellType == "Helpful" then
        if HealBot_Globals.WatchHoT[HealBot_PlayerClass_ER][SelectedSpellWacher] then
            if HealBot_Globals.WatchHoT[HealBot_PlayerClass_ER][SelectedSpellWacher] == 1 then
                SPellWacherButtonDisplay:SetText("Dont Show")
                SelectedSpellDescription:SetText("[" ..
                    SelectedSpellWacher .. "]" .. " Will be hidden in the UI.")
            elseif HealBot_Globals.WatchHoT[HealBot_PlayerClass_ER][SelectedSpellWacher] == 2 then
                SPellWacherButtonDisplay:SetText("Self Cast Only")
                SelectedSpellDescription:SetText("[" ..
                    SelectedSpellWacher .. "]" .. " Will only be displayed if casted by yourself.")
            elseif HealBot_Globals.WatchHoT[HealBot_PlayerClass_ER][SelectedSpellWacher] == 3 then
                SPellWacherButtonDisplay:SetText("ALL")
                SelectedSpellDescription:SetText("[" ..
                    SelectedSpellWacher .. "]" .. " Will be displayed if enyone cast it.")
            end
        end
    else
        if HealBot_Globals.Debuff_IgnoreList_R[SelectedSpellWacher] == true then
            SPellWacherButtonDisplay:SetText("Dont Show")
            SelectedSpellDescription:SetText("[" ..
                SelectedSpellWacher .. "]" .. " Will be hidden in the UI.")
        elseif HealBot_Globals.Debuff_IgnoreList_R[SelectedSpellWacher] == true then
            SPellWacherButtonDisplay:SetText("Show")
            SelectedSpellDescription:SetText("[" ..
                SelectedSpellWacher .. "]" .. " Will be displayed In the UI.")

        end
    end
end
function Healbot_WatchHot_Create_Spell_Button(spell, tab)
    if not spell or not tab then
        return
    end
    if not ScrollViewSpellsButton[tab][spell] then
        local button = CreateFrame("Button", nil, ScrollViewSpellList_BG)
        ScrollViewSpellsButton[tab][spell] = button;

        button:SetPoint("TOP", ScrollViewSpellList_BG, "TOP", 0, indexEE)
        button:SetWidth(200)
        button:SetHeight(25)

        button:SetText(spell)
        button:SetNormalFontObject("GameFontNormal")

        local ntex = button:CreateTexture()
        ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")

        ntex:SetTexCoord(0, 0.625, 0, 0.6875)
        ntex:SetAllPoints()
        button:SetNormalTexture(ntex)

        local htex = button:CreateTexture()
        htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
        htex:SetTexCoord(0, 0.625, 0, 0.6875)
        htex:SetAllPoints()
        button:SetHighlightTexture(htex)

        local ptex = button:CreateTexture()
        ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
        ptex:SetTexCoord(0, 0.625, 0, 0.6875)
        ptex:SetAllPoints()
        button:SetPushedTexture(ptex)
        indexEE = indexEE - 30

        button:HookScript("OnClick",Btt_click_ed);
    end
end
function Hb_WachHotBlock()
    HealBot_GlobalsDefaults.hbExcludeSpells = {}
    HealBot_GlobalsDefaults.hbExcludeSpells["Rejuvenating"] = 1
    HealBot_GlobalsDefaults.hbExcludeSpells["Sacred Shield"] = 1
    HealBot_GlobalsDefaults.hbExcludeSpells["Preservation"] = 1
    if HealBot_Globals.hbExcludeSpells == nil then
        HealBot_Globals.hbExcludeSpells = {}
    end
    for key, value in pairs(HealBot_GlobalsDefaults.hbExcludeSpells) do
        if HealBot_Globals.hbExcludeSpells[key] == nil then
            HealBot_Globals.hbExcludeSpells[key] = value
        end
    end
end
------------------------------------------------------------------------------------------
