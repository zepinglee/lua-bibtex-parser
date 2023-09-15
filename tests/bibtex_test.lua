require("busted.runner")()

local lbp = require("lua-bibtex-parser")

local inspect = require("inspect")
local json = require("dkjson")
local lfs = require("lfs")


local fixture_dir = "./tests/fixtures"


local function read_file(path)
  local file = io.open(path, "r")
  if not file then
    error(string.format('Cannot open "%s"', path))
  end
  local content = file:read("*a")
  file:close()
  return content
end


describe("lua-bibtex-parser", function()
  local bib_files = {}
  for bib_file in lfs.dir(fixture_dir) do
    if string.match(bib_file, "%.bib$") then
      table.insert(bib_files, bib_file)
    end
  end

  table.sort(bib_files)

  for _, bib_file in ipairs(bib_files) do
    local title = bib_file
    it(title, function ()
      local bib_path = fixture_dir .. "/" .. bib_file
      local content = read_file(bib_path)
      local library, exceptions = lbp.parse(content)

      local out = {
        preamble = library.preamble,
        entries = {},
        exceptions = {},
      }
      for _, entry in ipairs(library.entries) do
        local entry_out = {
          type = entry.type,
          key = entry.key,
          fields = {},
        }
        for _, field in ipairs(entry.fields) do
          entry_out.fields[field.name] = field.value
        end
        table.insert(out.entries, entry_out)
      end
      for _, exception in ipairs(library.exceptions) do
        table.insert(out.exceptions, {
          level = exception.level,
          line = exception.line,
          message = exception.message,
        })
      end
      -- print(inspect(out))

      local baseline_path = string.gsub(bib_path, "%.bib$", ".json")
      local baseline_content = read_file(baseline_path)
      local baseline = json.decode(baseline_content)

      assert.same(baseline, out)

    end)
  end

end)
