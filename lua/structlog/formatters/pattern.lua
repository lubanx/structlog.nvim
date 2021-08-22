--- Format entries listed in keys with the given format
-- Remaining entries will written as key=value
-- @param format A format to pass to string.format
-- @param keys The keys to pass as arguments to string.format
local function Pattern(format, keys)
  return function(_, kwargs)
    local format_args = {}

    for _, key in ipairs(keys) do
      table.insert(format_args, kwargs[key])
      kwargs[key] = nil
    end
    local output = string.format(format, unpack(format_args))

    -- Push remaining entries into events
    for k, v in pairs(kwargs) do
      if k ~= "events" then
        kwargs.events[k] = v
      end
    end

    if not vim.tbl_isempty(kwargs.events) then
      local events = vim.inspect(kwargs.events, { newline = "", indent = " " }):sub(2, -2)
      -- TODO: Implement our own inspect to avoid modifying user message
      output = output .. events:gsub(" = ", "=")
    end

    return output
  end
end

return Pattern