local log = require("structlog")
local processors = log.processors

local logger = log.Logger("test", {})

describe("StackWriter", function()
  describe("line option", function()
    it("should add an emtpy value if not present", function()
      local info = {}
      local debugger = function()
        return info
      end
      local writer = processors.StackWriter({ "line" }, { debugger = debugger })

      local expected = ""
      local kwargs = writer(logger, {})
      assert.equals(expected, kwargs.line)
    end)
    it("should add the current line", function()
      local info = {
        currentline = 1,
      }
      local debugger = function()
        return info
      end
      local writer = processors.StackWriter({ "line" }, { debugger = debugger })

      local kwargs = writer(logger, {})
      assert.equals(info.currentline, kwargs.line)
    end)
    it("should add the line range if currentline is not available", function()
      local info = {
        linedefined = 1,
        lastlinedefined = 5,
      }
      local debugger = function()
        return info
      end
      local writer = processors.StackWriter({ "line" }, { debugger = debugger })

      local expected = string.format("[%d-%d]", info.linedefined, info.lastlinedefined)
      local kwargs = writer(logger, {})
      assert.equals(expected, kwargs.line)
    end)
  end)

  describe("file option", function()
    it("should add an empty value if not present", function()
      local info = {}
      local debugger = function()
        return info
      end
      local writer = processors.StackWriter({ "file" }, { debugger = debugger })

      local expected = ""
      local kwargs = writer(logger, {})
      assert.equals(expected, kwargs.file)
    end)
    it("should add the file", function()
      local info = {
        source = "@path/to/lua/file.lua",
      }
      local debugger = function()
        return info
      end
      local writer = processors.StackWriter({ "file" }, { debugger = debugger })

      local expected = string.format("%s", info.source:sub(2))
      local kwargs = writer(logger, {})
      assert.equals(expected, kwargs.file)
    end)
    it("should add the file truncated up to max_parents", function()
      local info = {
        source = "@path/to/lua/file.lua",
      }
      local debugger = function()
        return info
      end
      local writer = processors.StackWriter({ "file" }, { debugger = debugger, max_parents = 0 })

      local expected = "file.lua"
      local kwargs = writer(logger, {})
      assert.equals(expected, kwargs.file)
    end)
    it("should add the file's full path if max_parents is too big", function()
      local info = {
        source = "@path/to/lua/file.lua",
      }
      local debugger = function()
        return info
      end
      local writer = processors.StackWriter({ "file" }, { debugger = debugger, max_parents = 999 })

      local expected = string.format("%s", info.source:sub(2))
      local kwargs = writer(logger, {})
      assert.equals(expected, kwargs.file)
    end)
  end)
end)
