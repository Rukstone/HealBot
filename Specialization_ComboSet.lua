--------------------------------------------------------------------------------
---experimental --- testing use of diferent combo box for fast set up for diferent specs

local Specializations = {
    "Specialization I",
    "Specialization II",
    "Specialization III",
    "Specialization IV",
    "Specialization V",
    "Specialization VI",
    "Specialization VII",
    "Specialization VIII",
    "Specialization IX",
    "Specialization X",
    "Specialization XI",
    "Specialization XII",
    "Specialization XIII",
    "Specialization XIV",
    "Specialization XV",
    "Specialization XVI",
    "Specialization XVII",
    "Specialization XVIII",
    "Specialization XVIX",
    "Specialization XX",
}
local function Load_ComboBox_Set()
    if not HealBot_SpecializationComboSet[HealBot_Config.Selected_CombotSet] then
        HealBot_SpecializationComboSet[HealBot_Config.Selected_CombotSet] = HealBot_Config.EnabledKeyCombo
    end
    HealBot_Config.EnabledKeyCombo = HealBot_SpecializationComboSet[HealBot_Config.Selected_CombotSet]
    print("Specialization Set: " .. HealBot_Config.Selected_CombotSet .. " Has Loaded Sucessfuly!")
end
local function Select_Combo_Set(name)
    HealBot_Config.Selected_CombotSet = name
    Load_ComboBox_Set()
    Save_ComboBox_Set()
end
local function Create_Combo_Set()

end
local function Delet_Combo_Set()
    if HealBot_SpecializationComboSet[HealBot_Config.Selected_CombotSet] then
        table.remove(HealBot_SpecializationComboSet, HealBot_Config.Selected_CombotSet);
    end
end
function Save_ComboBox_Set()
    if HealBot_SpecializationComboSet[HealBot_Config.Selected_CombotSet] then
        HealBot_SpecializationComboSet[HealBot_Config.Selected_CombotSet] = HealBot_Config.EnabledKeyCombo
    else
        HealBot_SpecializationComboSet[HealBot_Config.Selected_CombotSet] = {}
        table.insert(HealBot_SpecializationComboSet[HealBot_Config.Selected_CombotSet], HealBot_Config.EnabledKeyCombo)
    end
end
local function OnPlayerChangeTalentGroup(value,event,msg)
    if event == "CHAT_MSG_SYSTEM" then
        if msg then
            local indexstart, indexend
            for key, value in pairs(Specializations) do
                indexstart, indexend = string.find(msg, value .. ".")
                if indexstart and indexend then
                    if indexstart > 0 and indexend > 0 then
                        local spe = string.sub(msg, indexstart, string.len(msg) -1)
                        if spe == value then
                            Select_Combo_Set(value)
                            break
                        end
                    end
                end
            end
        end
    elseif event == "PLAYER_ENTERING_WORLD" then

        --Get Player Specialization
    end
 
end

local frame = CreateFrame('Frame');
frame:RegisterEvent("CHAT_MSG_SYSTEM");
if HealBot_Config.Selected_CombotSet == nil then
    HealBot_Config.Selected_CombotSet = "Default-Specialization"
    frame:RegisterEvent("PLAYER_ENTERING_WORLD");

end
frame:SetScript("OnEvent", OnPlayerChangeTalentGroup);

------------------------------------------------------------------------------------------------