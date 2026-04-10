local ls = require 'luasnip'
local i = ls.insert_node
local s = ls.snippet
local t = ls.text_node

return {
  s('clg', {
    t 'console.log(',
    i(1, 'value'),
    t ')',
  }),
}
