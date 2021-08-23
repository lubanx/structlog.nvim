# structlog.nvim

[![test](https://github.com/Tastyep/structlog.nvim/actions/workflows/test.yaml/badge.svg)](https://github.com/Tastyep/structlog.nvim/actions/workflows/test.yaml)
[![sanitize](https://github.com/Tastyep/structlog.nvim/actions/workflows/sanitize.yaml/badge.svg)](https://github.com/Tastyep/structlog.nvim/actions/workflows/sanitize.yaml)
[![Documentation](https://github.com/Tastyep/structlog.nvim/actions/workflows/documentation.yaml/badge.svg)](https://tastyep.github.io/structlog.nvim/)

Structured Logging for nvim, using Lua

### Why using it

- Configurable
- Extendable
- Easy-to-use
- Unit-Tested

### Usage
#### Create and Use

``` lua
local log = require("structlog")

local logger = log.Logger("name", log.level.INFO, {
  log.sinks.Console({
    processors = {
      log.processors.Namer(),
      log.processors.Timestamper("%H:%M:%S"),
    },
    formatter = log.formatters.Format( --
      "%s [%s] %s: %-30s",
      { "timestamp", "level", "logger_name", "msg" }
    ),
  }),
})

logger:info("A log message")
logger:warn("A log message with keyword arguments", { warning = "something happened" })
```

``` bash
10:32:40 [INFO] name: A log message
10:32:40 [WARN] name: A log message with keyword arguments     warning="something happened"
```

#### Configure and Retrieve

``` lua
local log = require("structlog")

log.configure({
  name = {
    level = log.level.INFO,
    sinks = {
      log.sinks.Console({
        processors = {
          log.processors.Namer(),
          log.processors.Timestamper("%H:%M:%S"),
        },
        formatter = log.formatters.Format( --
          "%s [%s] %s: %-30s",
          { "timestamp", "level", "logger_name", "msg" },
        ),
      }),
    },
  },
  other_logger = {...},
})

local logger = log.get_logger("name")
```

### Example

``` lua
local log = require("structlog")

log.configure({
  name = {
    level = log.level.INFO,
    sinks = {
      log.sinks.Console({
        processors = {
          log.processors.Namer(),
          log.processors.StackWriter({ "line", "file" }, { max_parents = 0 }),
          log.processors.Timestamper("%H:%M:%S"),
        },
        formatter = log.formatters.FormatColorizer( --
          "%s [%s] %s: %-30s",
          { "timestamp", "level", "logger_name", "msg" },
          { level = log.formatters.FormatColorizer.color_level() }
        ),
      }),
      log.sinks.File("./test.log", {
        processors = {
          log.processors.Namer(),
          log.processors.StackWriter({ "line", "file" }, { max_parents = 3 }),
          log.processors.Timestamper("%H:%M:%S"),
        },
        formatter = log.formatters.Format( --
          "%s [%s] %s: %-30s",
          { "timestamp", "level", "logger_name", "msg" }
        ),
      }),
    },
  },
  -- other_logger = {...}
})

local logger = log.get_logger("name")
logger:info("A log message")
logger:warn("A log message with keyword arguments", { warning = "something happened" })
```

![image](https://user-images.githubusercontent.com/3267228/130428431-94a65c67-553c-4daa-843a-5316b092321b.png)

``` bash
cat test.log:
10:43:23 [INFO] name: A log message                            file="lua/lsp/null-ls/formatters.lua", line=9
10:43:23 [WARN] name: A log message with keyword arguments     file="lua/lsp/null-ls/formatters.lua", line=10, warning="something happened"
```
