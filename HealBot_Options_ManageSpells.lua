local DropDown_SpellType
local Spell_NameEditBox
local indexEE = 0
local ScrollViewContent = nil;
local ShowSpellOnHud_CheckBox
local CanRess = false;
local ShowOnHUD = false;

function HealBot_Options_ManageSpells(self)
    if _G["HealBot_Options_SpellManager"] then
        _G["HealBot_Options_SpellManager"]:Show()
    end
end

local function Healbot_Options_SpellManager_DropDown_ChangeValue(dropdown, id)
    if dropdown == DropDown_SpellType then
        if id == 1 then --Spell
            _G["HealBot_Options_SpellManager_CanResurect"]:Show();
            _G["Healbot_Options_SpellManager_Dispells_F"]:Hide();
            ShowSpellOnHud_CheckBox:Show();
        elseif id == 2 then --Dispell
            _G["Healbot_Options_SpellManager_Dispells_F"]:Show();
            _G["HealBot_Options_SpellManager_CanResurect"]:Hide();
            ShowSpellOnHud_CheckBox:Hide();
        elseif id == 3 then --Buff
            _G["HealBot_Options_SpellManager_CanResurect"]:Hide();
            _G["Healbot_Options_SpellManager_Dispells_F"]:Hide();
            ShowSpellOnHud_CheckBox:Hide();
        else
            _G["Healbot_Options_SpellManager_Dispells_F"]:Hide();
            _G["HealBot_Options_SpellManager_CanResurect"]:Hide();
            ShowSpellOnHud_CheckBox:Hide();
        end
    end
end
function HealBot_Options_SpellManager_DropDown_Initialize(dropdown, values)
    dropdown.Texts = {}
    for key, value in pairs(values) do
        dropdown.Texts[key] = value
        local info = UIDropDownMenu_CreateInfo()
        info.text = value
        info.func = function(self)
            UIDropDownMenu_SetSelectedID(dropdown, self:GetID())
            UIDropDownMenu_SetText(dropdown, value)
            Healbot_Options_SpellManager_DropDown_ChangeValue(dropdown, self:GetID())
        end
        UIDropDownMenu_AddButton(info)
    end
end

function HealBot_Options_ManageSpells_InitDropDown(dropdown)
    local values = { "Spell", "Dispell", "Buff" }
    DropDown_SpellType = dropdown
    UIDropDownMenu_Initialize(dropdown, function()
        HealBot_Options_SpellManager_DropDown_Initialize(dropdown, values)
    end)
    UIDropDownMenu_SetSelectedID(dropdown, 1)
end

local function CreateCustomSpellButton(SpellTable, content)
    local button = CreateFrame("Button", nil, content)
    button:SetPoint("TOP", content, "TOP", 0, indexEE)
    button:SetSize(200, 25)
    button:SetText(SpellTable.Spell)
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

    button:HookScript("OnClick", function()
        healbot_options_ManageSpells_SelectSpell(SpellTable)
    end)

    SpellTable.Button = button
end
function healbot_options_ManageSpells_SelectSpell(SpellTable)
    UIDropDownMenu_SetSelectedID(DropDown_SpellType, SpellTable.SpellType)
    UIDropDownMenu_SetText(DropDown_SpellType, DropDown_SpellType.Texts[SpellTable.SpellType])

    Spell_NameEditBox:SetText(SpellTable.Spell)
    if SpellTable.SpellType == 2 then
        _G["HealBot_Options_SpellManager_Dispell_Poison"]:SetChecked(SpellTable.Dispell_Poison);
        _G["HealBot_Options_SpellManager_Dispell_Curse"]:SetChecked(SpellTable.Dispell_Curse);
        _G["HealBot_Options_SpellManager_Dispell_Magic"]:SetChecked(SpellTable.Dispell_Magic);
        _G["HealBot_Options_SpellManager_Dispell_Disese"]:SetChecked(SpellTable.Dispell_Disese);
    elseif SpellTable.SpellType == 1 then
        CanRess = SpellTable.CanResurect
        _G["HealBot_Options_SpellManager_CanResurect"]:SetChecked(CanRess or false);
        if not CanRess then
            ShowSpellOnHud_CheckBox:Show();
            ShowSpellOnHud_CheckBox:SetChecked(SpellTable.ShowOnHUD);
        else
            ShowSpellOnHud_CheckBox:Hide();
        end
    end
    Healbot_Options_SpellManager_DropDown_ChangeValue(DropDown_SpellType, SpellTable.SpellType)
end

function HealBot_Options_SpellManager_CreateOrSaveSpell()
    local spellName = Spell_NameEditBox:GetText()
    local spellinf = GetSpellInfo(spellName);
    if not spellinf then
        print("Invalid Spell: " .. spellName);
        return;
    end
    if not Healbot_Custom_SpellManager[spellName] then
        Healbot_Custom_SpellManager[spellName] = {}
        Healbot_Custom_SpellManager[spellName].Spell = spellinf;
        CreateCustomSpellButton(Healbot_Custom_SpellManager[spellName], ScrollViewContent)
    end

    Healbot_Custom_SpellManager[spellName].SpellType = UIDropDownMenu_GetSelectedID(DropDown_SpellType);
    if Healbot_Custom_SpellManager[spellName].SpellType == 1 then
        CanRess = _G["HealBot_Options_SpellManager_CanResurect"]:GetChecked();
        Healbot_Custom_SpellManager[spellName].CanResurect = CanRess;
        if not CanRess then
            Healbot_Custom_SpellManager[spellName].ShowOnHUD = ShowOnHUD
        end
    elseif Healbot_Custom_SpellManager[spellName].SpellType == 2 then
        Healbot_Custom_SpellManager[spellName].Dispell_Poison = _G["HealBot_Options_SpellManager_Dispell_Poison"]
            :GetChecked() and true or false;
        Healbot_Custom_SpellManager[spellName].Dispell_Curse = _G["HealBot_Options_SpellManager_Dispell_Curse"]
            :GetChecked() and true or false;
        Healbot_Custom_SpellManager[spellName].Dispell_Disese = _G["HealBot_Options_SpellManager_Dispell_Disese"]
            :GetChecked() and true or false;
        Healbot_Custom_SpellManager[spellName].Dispell_Magic = _G["HealBot_Options_SpellManager_Dispell_Magic"]
            :GetChecked() and true or false;
    end

    Healbot_Options_SpellManager_AddNewSpell(Healbot_Custom_SpellManager[spellName])
end

function HealBot_Options_ManageSpells_ScrollFrame_OnSpellsLoad(self)
    ScrollViewContent = self
    ShowSpellOnHud_CheckBox = _G["HealBot_Options_SpellManager_ShowOnHUD"]
    Spell_NameEditBox = _G["HealBot_Options_SpellManager_SpellName"]

    Healbot_Options_SpellManager_LoadCustomSpells();

    for key, value in pairs(Healbot_Custom_SpellManager) do
        CreateCustomSpellButton(value, ScrollViewContent)
    end
end

function Healbot_Options_SpellManager_CanResurect_Click(self)
    CanRess = self:GetChecked();
    if CanRess then
        ShowSpellOnHud_CheckBox:Hide();
    else
        ShowSpellOnHud_CheckBox:Show();
    end
end

function Healbot_Options_SpellManager_ShowOnHUD_Click(self)
    ShowOnHUD = self:GetChecked();
end
