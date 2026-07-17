-- Centralized server-side audit log. It deliberately has no dependency on a framework.
Gravity.Webhooks = Gravity.Webhooks or {}

local DEFAULT_COLORS = {
    success = 3066993,
    warning = 15105570,
    error = 15158332,
    info = 3447003,
}

local function safeValue(value, depth)
    depth = depth or 0
    if depth > 4 then return Gravity.Translate('webhook_not_available') end
    local valueType = type(value)
    if valueType == 'nil' or valueType == 'string' or valueType == 'number' or valueType == 'boolean' then return value end
    if valueType ~= 'table' then return tostring(value) end

    local result = {}
    for key, item in pairs(value) do
        result[tostring(key)] = safeValue(item, depth + 1)
    end
    return result
end

local function playerData(source)
    source = tonumber(source)
    if not source or source <= 0 then return nil end
    local identifiers = {}
    for _, identifier in ipairs(GetPlayerIdentifiers(source)) do
        local identifierType, value = identifier:match('^(.-):(.*)$')
        if identifierType and value then identifiers[identifierType] = identifier end
    end

    local cash = 0
    if Bridge.Adapter then cash = Bridge.GetMoney(source, 'cash') end
    return {
        source = source,
        name = GetPlayerName(source) or Gravity.Translate('webhook_unknown_player'),
        cash = cash,
        identifiers = identifiers,
        identifier = Bridge.GetIdentifier(source),
    }
end

local function formatFields(data, available)
    local fields = {}
    for key, value in pairs(data) do
        if key ~= 'message' and key ~= 'title' then
            local encoded = type(value) == 'table' and json.encode(value) or tostring(value)
            local localizedKey = Gravity.Translate('webhook_field_' .. tostring(key))
            fields[#fields + 1] = { name = localizedKey == ('webhook_field_' .. tostring(key)) and tostring(key) or
            localizedKey, value = encoded:sub(1, 1024), inline = true }
            if #fields >= available then break end
        end
    end
    return fields
end

local function labelForEvent(event)
    local labels = {
        ['player.joining'] = 'webhook_event_player_joining',
        ['player.dropped'] = 'webhook_event_player_dropped',
        ['money.add'] = 'webhook_event_money_add',
        ['money.remove'] = 'webhook_event_money_remove',
        ['inventory.add'] = 'webhook_event_inventory_add',
        ['inventory.remove'] = 'webhook_event_inventory_remove',
        ['banking.deposit'] = 'webhook_event_banking_deposit',
        ['banking.withdraw'] = 'webhook_event_banking_withdraw',
    }
    return labels[event] and Gravity.Translate(labels[event]) or event
end

local function discordPayload(record, config)
    local fields = {}
    if record.player then
        local identifiers = record.player.identifiers or {}
        local discordId = identifiers.discord and identifiers.discord:gsub('discord:', '')
        fields = {
            { name = Gravity.Translate('webhook_field_name'),    value = record.player.name,                                                                            inline = true },
            { name = Gravity.Translate('webhook_field_id'),      value = tostring(record.player.source),                                                                inline = true },
            { name = Gravity.Translate('webhook_field_cash'),    value = ('%s %s'):format(record.player.cash or 0, Gravity.Translate('webhook_currency')),              inline = true },
            { name = Gravity.Translate('webhook_field_steam'),   value = identifiers.steam or Gravity.Translate('webhook_not_available'),                               inline = false },
            { name = Gravity.Translate('webhook_field_license'), value = identifiers.license or record.player.identifier or Gravity.Translate('webhook_not_available'), inline = false },
            { name = Gravity.Translate('webhook_field_ip'),      value = identifiers.ip or Gravity.Translate('webhook_not_available'),                                  inline = false },
            { name = Gravity.Translate('webhook_field_discord'), value = discordId and ('<@%s>'):format(discordId) or Gravity.Translate('webhook_not_available'),       inline = false },
        }
    end
    local details = formatFields(record.data, 25 - #fields)
    for _, field in ipairs(details) do fields[#fields + 1] = field end

    local description = record.data.message
    if not description then
        description = Gravity.Translate('webhook_event', record.event)
        if record.data.reason then description = ('%s\n%s'):format(description,
                Gravity.Translate('webhook_reason', record.data.reason)) end
    end
    return {
        username = config.username,
        avatar_url = config.avatarUrl,
        embeds = { {
            title = ('**%s**'):format(record.data.title or labelForEvent(record.event)),
            description = tostring(description):sub(1, 4096),
            color = config.color or DEFAULT_COLORS[record.level] or DEFAULT_COLORS.info,
            fields = fields,
            footer = { text = Gravity.Translate('webhook_footer', os.date('%d-%m-%Y %H:%M:%S')) },
            timestamp = record.timestamp,
        } },
    }
end

--- Creates a structured audit record and exposes it through the server event.
---@param event string
---@param data table|nil
---@param options table|nil { source = number, level = 'info'|'success'|'warning'|'error' }
function Gravity.Log(event, data, options)
    Gravity.AssertServer()
    options = options or {}
    local record = {
        event = tostring(event),
        timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ'),
        framework = Bridge.Framework,
        resource = GetInvokingResource() or GetCurrentResourceName(),
        level = options.level or 'info',
        player = playerData(options.source),
        data = safeValue(data or {}),
    }

    TriggerEvent('gravity_bridge:server:log', record)
    return record
end

--- Sends a Discord audit log to a webhook owned by the calling resource.
--- Keep the webhook URL in that resource's server-side configuration.
---@param url string
---@param event string
---@param data table|nil
---@param options table|nil { source = number, level = 'info'|'success'|'warning'|'error', username = string, avatarUrl = string, color = number }
---@return table|nil record
function Gravity.SendWebhook(url, event, data, options)
    Gravity.AssertServer()
    if type(url) ~= 'string' or url == '' then
        Gravity.Debug('Webhook not sent: a URL is required.')
        return nil
    end

    options = options or {}
    local record = Gravity.Log(event, data, options)
    local config = {
        username = options.username,
        avatarUrl = options.avatarUrl,
        color = options.color,
    }

    PerformHttpRequest(url, function(statusCode)
        if statusCode < 200 or statusCode >= 300 then
            Gravity.Debug('Discord webhook failed (HTTP %s).', statusCode)
        end
    end, 'POST', json.encode(discordPayload(record, config)), { ['Content-Type'] = 'application/json' })

    return record
end
