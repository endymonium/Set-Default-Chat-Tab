local _, ns = ...

-- slash commands
SLASH_SDCT1, SLASH_SDCT2 = '/setdefaultchattab', '/sdct';
local function handler(msg, editBox)
    local command, rest = msg:match("^(%S*)%s*(.-)$")

    if command == 'get' then
        ns:l("Current default chat tab index: " .. (DEFAULT_CHAT_TAB or "not set"))

    -- elseif command == 'list' then
    --     WorkOnAllChatFrames()

    elseif command == 'set' then
        ns:l("Set chat tab index to " .. rest)
        DEFAULT_CHAT_TAB = rest

    -- elseif command == 'test' then
    --     SetDefaultChatTab()

    else
        ns:l("Possible commands:")
        ns:l("  /sdct get     print current value")
        ns:l("  /sdct set <idx>   list all chat tabs")
    end
end
SlashCmdList["SDCT"] = handler;