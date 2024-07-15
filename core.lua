local addonName, ns = ...

-- main frame
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_LOGOUT")


-- SetDefaultChatTab
function ChangeToDefaultTab()
    if DEFAULT_CHAT_TAB == nil then
        ns:l("Not setting default chat tab, as DEFAULT_CHAT_TAB is nil")
    else
        FCF_SelectDockFrame(_G["ChatFrame" .. DEFAULT_CHAT_TAB])
        ns:l("Changed chat tab to " .. DEFAULT_CHAT_TAB)
    end
end

-- Main Frame OnEvent
frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" then
        if arg1 == addonName then
            ns:l("addon loaded (DEFAULT_CHAT_TAB=" .. (DEFAULT_CHAT_TAB or "not set") .. ")")
            ChangeToDefaultTab()
        end
    end
end)

-- map icon
local addon = LibStub("AceAddon-3.0"):NewAddon("SetDefaultChatTab")
local SetDefaultChatTabLDB = LibStub("LibDataBroker-1.1"):NewDataObject(
    "SetDefaultChatTab", {
        type = "data source",
        -- text = addonName,
        icon = "Interface\\Icons\\ui_chat",
        OnClick = function(self, button)
            if button == "LeftButton" then
                local dropDown = CreateFrame("Frame", "SetDefaultChatTab", UIParent, "UIDropDownMenuTemplate")

                UIDropDownMenu_Initialize(dropDown, function(self, level, menuList)
                    -- header one
                    local info = UIDropDownMenu_CreateInfo()
                    info.isTitle = true
                    info.text = "Chat Frames"
                    UIDropDownMenu_AddButton(info)
                    
                    -- chat frames
                    for i = 1, NUM_CHAT_WINDOWS do
                        local name, fontSize, r, g, b, alpha, shown, locked, docked, uninteractable = GetChatWindowInfo(i)
                        if docked then
                            local info = UIDropDownMenu_CreateInfo()
                            info.text = name
                            info.arg1 = i
                            info.checked = (i == tonumber(DEFAULT_CHAT_TAB))
                            info.func = function(_, arg1)
                                ns:l('SetValue --> ' .. (arg1 or "not Set"))
                                if arg1 then
                                    DEFAULT_CHAT_TAB = arg1
                                end
                            end
                            UIDropDownMenu_AddButton(info)
                        end
                    end

                    -- header Debug
                    local info = UIDropDownMenu_CreateInfo()
                    info.isTitle = true
                    info.text = "Debug"
                    UIDropDownMenu_AddButton(info)

                    local info = UIDropDownMenu_CreateInfo()
                    info.text = "Test"
                    info.isNotRadio = true
                    info.func = function(_, arg1)
                        ChangeToDefaultTab()
                    end
                    UIDropDownMenu_AddButton(info)
                end, "MENU")

                ToggleDropDownMenu(1, nil, dropDown, "cursor", 3, -3)

            elseif button == "RightButton" then
                ReloadUI()
            end
        end,
        OnTooltipShow = function(tooltip)
            tooltip:SetText("Set Default Chat Tab")
            tooltip:AddLine("Left-click to open / close", 1, 1, 1)
            tooltip:AddLine("Right-click to Reload Ui", 1, 1, 1)
        end
    })
local icon = LibStub("LibDBIcon-1.0")

function addon:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("SetDefaultChatTabDB", { profile = { minimap = { hide = false } } })
    icon:Register("SetDefaultChatTab", SetDefaultChatTabLDB, self.db.profile.minimap)
end
