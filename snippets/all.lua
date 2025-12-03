local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

local link = s({
  trig = "link",
  name = "Link",
  dscr = "Web link"
}, {
  t("`"),
  i(1, "Title"),
  t(" <"),
  i(2, "link"),
  t(">`_"),
  i(0)
})

return { link }

