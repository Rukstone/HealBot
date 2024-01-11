--------------------------------------------------------------------------------
---experimental --- testing use of diferent combo box for fast set up for diferent specs
local ProfileDropDown = nil;
local TextBoxFrame = nil;

local function Load_ComboBox_Set(profile)
    if profile == nil then
        return;
    end
    if not HealBot_ComboSetProfiles[profile] then
        return;
    end
    HealBot_Config.CombotSetProfileSelected = profile
    HealBot_Config.EnabledKeyCombo = HealBot_ComboSetProfiles[profile]["EnabledKeyCombo"]
    HealBot_Config.DisabledKeyCombo = HealBot_ComboSetProfiles[profile]["DisabledKeyCombo"]
    HealBot_Config.EnabledSpellTrinket1 = HealBot_ComboSetProfiles[profile]["EnabledSpellTrinket1"]
    HealBot_Config.EnabledSpellTrinket2 = HealBot_ComboSetProfiles[profile]["EnabledSpellTrinket2"]
    HealBot_Config.DisabledSpellTrinket1 = HealBot_ComboSetProfiles[profile]["DisabledSpellTrinket1"]
    HealBot_Config.DisabledSpellTrinket2 = HealBot_ComboSetProfiles[profile]["DisabledSpellTrinket2"]
    HealBot_Config.EnabledSpellTarget = HealBot_ComboSetProfiles[profile]["EnabledSpellTarget"]
    HealBot_Config.DisabledSpellTarget = HealBot_ComboSetProfiles[profile]["DisabledSpellTarget"]
    HealBot_Options_ComboClass_Text();
    --HealBot_Update_SpellCombos();
end
local function SelectDropDownProfile(profile)
    HealBot_Config.CombotSetProfileSelected = profile
    UIDropDownMenu_SetText(ProfileDropDown, profile)
    UIDropDownMenu_SetSelectedValue(ProfileDropDown, profile, profile)
    Load_ComboBox_Set(profile);
end
local function CreateCombotSetProfile(profile)
    HealBot_Config.CombotSetProfileSelected = profile
    if not HealBot_ComboSetProfiles[profile] then
        Save_ComboBox_Set(profile);
    end
    SelectDropDownProfile(profile);
end
function Save_ComboBox_Set(profile)
    if not profile then
        return
    end
    if not HealBot_ComboSetProfiles then
        HealBot_ComboSetProfiles = {}
    end
    HealBot_ComboSetProfiles[profile] = {
        ["EnabledKeyCombo"] = HealBot_Config.EnabledKeyCombo,
        ["DisabledKeyCombo"] = HealBot_Config.DisabledKeyCombo,

        ["EnabledSpellTrinket1"] = HealBot_Config.EnabledSpellTrinket1,
        ["EnabledSpellTrinket2"] = HealBot_Config.EnabledSpellTrinket2,

        ["DisabledSpellTrinket1"] = HealBot_Config.DisabledSpellTrinket1,
        ["DisabledSpellTrinket2"] = HealBot_Config.DisabledSpellTrinket2,

        ["EnabledSpellTarget"] = HealBot_Config.EnabledSpellTarget,
        ["DisabledSpellTarget"] = HealBot_Config.DisabledSpellTarget,
    }
end

function HealBot_Options_ActionBarsCombo_Profile_OnLoad(self)
    ProfileDropDown = self;

    UIDropDownMenu_Initialize(ProfileDropDown, function ()
        for key, val in pairs(HealBot_ComboSetProfiles) do
            local info = UIDropDownMenu_CreateInfo()
            info.text = key;
            info.value = key;
            if HealBot_Config.CombotSetProfileSelected == key then
                info.checked = true
            else
                info.checked = false
            end
            info.func = SelectDropDownProfile(key)
            --[[
                info.func = function(self)
                SelectDropDownProfile(self.value)
            end
            ]]
            UIDropDownMenu_AddButton(info);
        end
    end);
    CreateCombotSetProfile(HealBot_Config.CombotSetProfileSelected);
    SelectDropDownProfile(HealBot_Config.CombotSetProfileSelected)


end

function HealBot_Options_ActionBarsComboProfile_Create(self)
    CreateCombotSetProfile(TextBoxFrame:GetText())
    TextBoxFrame:SetText("");
end

function HealBot_Options_ActionBarsComboProfile_Delete(self)
    if HealBot_ComboSetProfiles[HealBot_Config.CombotSetProfileSelected] then
        HealBot_ComboSetProfiles[HealBot_Config.CombotSetProfileSelected] = nil
    end
end

function HealBot_Options_ActionBarsCombo_ProfileTextBox_OnLoad(self)
    TextBoxFrame = self;
end
