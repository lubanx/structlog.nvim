local log = require("structlog")
local formatters = log.formatters

local logger = log.Logger("test", log.level.INFO, {})

describe("Pattern", function()
  it("should format kwargs into a string", function()
    local formatter = formatters.Pattern("[%s] %s", { "level", "msg" })

    local kwargs = { level = log.level.INFO, msg = "test", events = {} }
    local expected = string.format("[%s] %s", kwargs.level, kwargs.msg)
    local message = formatter(logger, vim.deepcopy(kwargs))
    assert.equals(expected, message)
  end)

  it("should format kwargs into a string and add remaining events if present", function()
    local formatter = formatters.Pattern("[%s] %s", { "level", "msg" })

    local kwargs = { level = log.level.INFO, msg = "test", test = 1, events = { nest = { "test" } } }
    local expected = string.format(
      "[%s] %s nest=%s, test=%d",
      kwargs.level,
      kwargs.msg,
      vim.inspect(kwargs.events.nest, { newline = "" }),
      kwargs.test
    )
    local message = formatter(logger, vim.deepcopy(kwargs))
    assert.equals(expected, message)
  end)
end)