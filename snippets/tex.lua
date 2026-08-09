
local in_math_func = function()
  -- The `in_mathzone` function requires the VimTeX plugin
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

local out_math_func = function()
  -- The `in_mathzone` function requires the VimTeX plugin
  return not in_math_func()
end

local make_condition = require("luasnip.extras.conditions").make_condition

local out_math = make_condition(out_math_func)
local in_math = make_condition(in_math_func)

local in_quantikz = function()
  -- The `in_mathzone` function requires the VimTeX plugin
  local dct = vim.fn['vimtex#env#get_inner']()
  return dct.name == "quantikz"
end

-- Abbreviations used in this article and the LuaSnip docs
local ls = require("luasnip")
local s = ls.snippet
-- local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
-- local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local line_begin = require("luasnip.extras.conditions.expand").line_begin
local postfix = require("luasnip.extras.postfix").postfix

local tex = {}
tex.in_mathzone = function()
        return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

tex.in_text = function()
        return not tex.in_mathzone()
end

return {

  -- \begin{whatever} environment
  s({trig="bb", snippetType="autosnippet", condition = line_begin},
    fmta(
      --- Snippets for environment creation ---
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
    s({trig="ee", snippetType="autosnippet", condition=out_math * line_begin},
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

    -- \begin{quantikz} + \begin{figure} environment
    s({trig="qk", snippetType="autosnippet"},
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

    -- $ ... $
    s({trig = "ii", snippetType="autosnippet", condition = out_math},
        fmta(
            "$<>$",
            {
                i(1),
            }
        )
    ),

    -- \begin{itemize}
    s({trig = "tm", snippetType="autosnippet", condition = out_math * line_begin},
        fmta(
[[
\begin{itemize}
  \item <>
\end{itemize}
]],
            {
                i(1),
            }
        )
    ),


    -- \begin{enumerate}
    s({trig = "nm", snippetType="autosnippet", condition = line_begin * out_math},
        fmta(
[[
\begin{enumerate}
  \item <>
\end{enumerate}
]],
            {
                i(1),
            }
        )
    ),

    --- Snippets for commands in textmode ---
    -- \textit{}
    s({trig = "tt", snippetType="autosnippet", condition=out_math},
        fmta(
            "\\textit{<>}",
            {
                i(1),
            }
        )
    ),

    -- \textbf{}
    s({trig = "bf", snippetType="autosnippet", condition=in_math},
        fmta(
            "\\textbf{<>}",
            {
                i(1),
            }
        )
    ),

    -- \ref{}
    s({trig = "bf", snippetType="autosnippet", condition = out_math},
        fmta(
            "\\ref{<>}",
            {
                i(1),
            }
        )
    ),

  -- \cite{}
  s({trig = "bf", snippetType="autosnippet", condition = out_math},
    fmta(
      "\\cite{<>}",
      {
        i(1),
      }
    )
  ),

  -- \section{}
  s({trig = "sct", snippetType="autosnippet", condition = out_math},
    fmta(
      "\\section{<>}",
      {
        i(1),
      }
    )
  ),

  --- Snippets for mathmode ---

  -- \text{}
  s({trig = "tx", snippetType="autosnippet", condition = in_math},
    fmta(
      "\\text{<>}",
      {
        i(1),
      }
    )
  ),

  -- \frac{}{}
  s({trig = "ff", snippetType="autosnippet", condition = in_math},
    fmta(
      "\\frac{<>}{<>}",
      {
        i(1),
        i(2),
      }
    )
  ),

  -- \ket{}
  s({trig = "kk", snippetType="autosnippet", condition = in_math},
    fmta(
      "\\ket{<>}",
      {
        i(1),
      }
    )
  ),

  -- \bmod
  s({trig = "bmd", snippetType="autosnippet", condition = in_math},
    fmta(
      "\\bmod",
      { }
    )
  ),

  -- \omega
  s({trig = "mg", snippetType="autosnippet", condition = in_math},
    fmta(
      "\\omega",
      { }
    )
  ),

  -- \times
  s({trig = "tms", snippetType="autosnippet", condition = in_math},
    fmta(
      "\\otimes",
      { }
    )
  ),

  --- Snippets for quantikz ---

  -- \gate{}
  s({trig = "gt", snippetType="autosnippet", condition = in_quantikz},
    fmta(
      "\\gate{<>}",
      {
        i(1),
      }
    )
  ),

  -- \ctrl{}
  s({trig = "ct", snippetType="autosnippet", condition = in_quantikz},
    fmta(
      "\\ctrl{<>}",
      {
        i(1),
      }
    )
  ),

  -- \targ{}
  s({trig = "tg", snippetType="autosnippet", condition = in_quantikz},
    fmta(
      "\\targ{}",
      {
      }
    )
  ),
  -- \lstick{}
  s({trig = "ls", snippetType="autosnippet", condition = in_quantikz},
    fmta(
      "\\lstick{<>}",
      {
        i(1),
      }
    )
  ),
}


