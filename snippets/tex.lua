
local in_mathzone = function()
  -- The `in_mathzone` function requires the VimTeX plugin
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

local out_mathzone = function()
  -- The `in_mathzone` function requires the VimTeX plugin
  return vim.fn['vimtex#syntax#in_mathzone']() == 0
end

local in_quantikz = function()
  -- The `in_mathzone` function requires the VimTeX plugin
  local dct = vim.fn['vimtex#env#get_inner']()
  return dct.name == "quantikz"
end

-- Abbreviations used in this article and the LuaSnip docs
local ls = require("luasnip")
local s = ls.snippet
-- local sn = ls.snippet_node
-- local t = ls.text_node
local i = ls.insert_node
-- local f = ls.function_node
-- local d = ls.dynamic_node
-- local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

return {

  -- \begin{whatever} environment
  s({trig="bb", snippetType="autosnippet"},
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

  -- \begin{quantikz} + \begin{figure} environment
  s({trig="qf", snippetType="autosnippet"},
    fmta(
[[
\begin{figure}[ht]
\begin{quantikz}
    & <> &
\end{quantikz}
\begin{quantikz}
\end{figure}
]],
      {
        i(1),
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

  -- \begin{enumerate}
  s({trig = "tm", snippetType="autosnippet", condition = out_mathzone},
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
  s({trig = "nm", snippetType="autosnippet", condition = out_mathzone},
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

  --- Snippets for textmode ---
  -- \textit{}
  s({trig = "tt", snippetType="autosnippet"},
    fmta(
      "\\textit{<>}",
      {
        i(1),
      }
    )
  ),

  -- \textbf{}
  s({trig = "bf", snippetType="autosnippet"},
    fmta(
      "\\textbf{<>}",
      {
        i(1),
      }
    )
  ),

  -- \ref{}
  s({trig = "bf", snippetType="autosnippet", condition = out_mathzone},
    fmta(
      "\\ref{<>}",
      {
        i(1),
      }
    )
  ),

  -- \cite{}
  s({trig = "bf", snippetType="autosnippet"},
    fmta(
      "\\cite{<>}",
      {
        i(1),
      }
    )
  ),

  -- \section{}
  s({trig = "sct", snippetType="autosnippet"},
    fmta(
      "\\section{<>}",
      {
        i(1),
      }
    )
  ),

  --- Snippets for mathmode ---
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

  -- \ket{}
  s({trig = "kk", snippetType="autosnippet", condition = in_mathzone},
    fmta(
      "\\ket{<>}",
      {
        i(1),
      }
    )
  ),

  -- \bmod
  s({trig = "bmd", snippetType="autosnippet", condition = in_mathzone},
    fmta(
      "\\bmod",
      { }
    )
  ),

  -- \omega
  s({trig = "mg", snippetType="autosnippet", condition = in_mathzone},
    fmta(
      "\\omega",
      { }
    )
  ),

  -- \times
  s({trig = "tms", snippetType="autosnippet", condition = in_mathzone},
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

