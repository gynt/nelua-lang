local euluna_parser = require 'euluna.parsers.euluna_parser'
local plfile = require 'pl.file'
local configer = require 'euluna.configer'
local runner = {}

function runner.run(argv)
  local config = configer.parse(argv)

  local input
  local infile
  if config.eval then
    input = config.input
  else
    input = assert(plfile.read(config.input))
    infile = config.input
  end

  local ast = assert(euluna_parser:parse(input))

  if config.lint then return end

  --[[
  if config.print_ast then
    print(ast:tostring())
    return 0
  end
  ]]

  local generator = require('euluna.generators.' .. config.generator .. '_generator')
  local code = generator:generate(ast)

  if config.print_code then
    print(code)
    return 0
  end

  local compiler = generator.compiler
  local ok,status,sout,serr = compiler.run(code, infile, config.output)
  if sout then io.stdout:write(sout) end
  if serr then io.stderr:write(serr) end
  return status
end

return runner
