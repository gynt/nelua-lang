local fs = require 'nelua.utils.fs'
local pegger = require 'nelua.utils.pegger'
local stringer = require 'nelua.utils.stringer'
local tabler = require 'nelua.utils.tabler'
local console = require 'nelua.utils.console'
local config = require 'nelua.configer'.get()
local version = require 'nelua.version'

local lua_compiler = {
  source_extension = '.lua'
}

function lua_compiler.has_source_extension(filename)
  return filename:find('%.lua$')
end

function lua_compiler.generate_code(luacode, luafile)
  -- file heading
  local hash = stringer.hash(luacode)
  local heading = string.format(
[[-- Generated by %s
-- Compile Hash: %s

]], version.NELUA_VERSION, hash)
  local sourcecode = heading .. luacode

  -- check if write is actually needed
  local current_sourcecode = fs.readfile(luafile)
  if not config.no_cache and current_sourcecode and current_sourcecode == sourcecode then
    if config.verbose then console.info("using cached generated " .. luafile) end
    return luafile
  end

  fs.eensurefilepath(luafile)
  fs.ewritefile(luafile, sourcecode)
  if config.verbose then console.info("generated " .. luafile) end
end

function lua_compiler.compile_binary(luafile)
  return luafile, true
end

function lua_compiler.get_run_command(binaryfile, runargs)
  -- generate compile command
  local args = pegger.split_execargs(config.lua_options)
  table.insert(args, fs.abspath(binaryfile))
  tabler.insertvalues(args, runargs)
  return config.lua, args
end

return lua_compiler
