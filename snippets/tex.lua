
local in_mathzone = function()
  -- The `in_mathzone` function requires the VimTeX plugin
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

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
  -- \begin{whatever} environment
  s({trig="bb", snippetType="autosnippet"},
    fmta(
[[
\begin{<>}
    <>
\end{<>}
]],
      {
	i(1),
	i(2),
	rep(1),  -- this node repeats insert node i(1)
      }
    )
  ),

  -- \begin{equation} environment
  s({trig="ee", snippetType="autosnippet"},
    fmta(
[[
\begin{equation}
    <>
\end{equation}
]],
      {
	i(1),
      }
    )
  ),

  -- \begin{quantikz} environment
  s({trig="qq", snippetType="autosnippet"},
    fmta(
[[
\begin{quantikz}
    & <> &
\end{quantikz}
]],
      {
	i(1),
      }
    )
  ),

  -- \frac{}{}
  s({trig = "ff", snippetType="autosnippet", condition = in_mathzone},
    fmta(
      "\\frac{<>}{<>}",
      {
	i(1),
	i(2),
      }
    )
  ),
  -- $ ... $
  s({trig = "ii", snippetType="autosnippet"},
    fmta(
      "$<>$",
      {
	i(1),
      }
    )
  ),
}
