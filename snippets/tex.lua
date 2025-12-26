

-- Abbreviations used in this article and the LuaSnip docs
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

return {
  -- Example of a multiline text node
  s({trig = "(%a+)ff", trigEngine = "pattern", wordTrig = false},
    fmta( [[<>\frac{<>}{<>}]],
      {f( function(_, snip) return snip.captures[1] end ),
	i(1), i(2) })),
  s({trig = "lines", dscr = "Demo: a text node with three lines."},
    {
      t({"Line 1", "Line 2", "Line 3"})
    }
  ),

  -- s({trig="ff", dscr="Expands 'ff' into '\frac{}{}'"},
  --   {
  --     t("\\frac{"),
  --     i(1),  -- insert node 1
  --     t("}{"),
  --     i(2),  -- insert node 2
  --     t("}")
  --   }
  -- ),
}
