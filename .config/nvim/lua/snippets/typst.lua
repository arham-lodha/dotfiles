local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

-- ==========================================
-- TREE-SITTER CONTEXT FUNCTIONS
-- ==========================================

local function in_mathzone()
  local node = vim.treesitter.get_node()
  while node do
    if node:type() == "math" or node:type() == "equation" then
      return true
    end
    node = node:parent()
  end
  return false
end

local function not_mathzone()
  return not in_mathzone()
end

-- ==========================================
-- SNIPPET DEFINITIONS
-- ==========================================

return {

  -- -----------------------------------------
  -- TEXT MODE (Markup)
  -- -----------------------------------------

  -- Inline Math
  s({ trig = "mk", snippetType = "autosnippet" }, fmta("$<>$", { i(1) }), { condition = not_mathzone }),

  -- Display Math
  s(
    { trig = "dm", snippetType = "autosnippet" },
    fmta(
      [[
      $ <> $
    ]],
      { i(1) }
    ),
    { condition = not_mathzone }
  ),

  -- -----------------------------------------
  -- MATH MODE
  -- -----------------------------------------

  -- Fraction (trigger with //)
  s({ trig = "//", snippetType = "autosnippet" }, fmta("(<>) / (<>)", { i(1), i(2) }), { condition = in_mathzone }),

  -- Limit
  s(
    { trig = "lim", snippetType = "autosnippet", wordTrig = true },
    fmta("lim_(<>) <>", { i(1), i(2) }),
    { condition = in_mathzone }
  ),

  -- Summation
  s(
    { trig = "sum", snippetType = "autosnippet", wordTrig = true },
    fmta("sum_(<>)^(<>) <>", {
      i(1, "i=1"),
      i(2, "n"),
      i(3),
    }),
    { condition = in_mathzone }
  ),

  -- Integral
  s(
    { trig = "int", snippetType = "autosnippet", wordTrig = true },
    fmta("integral_(<>)^(<>) <>", {
      i(1, "0"),
      i(2, "oo"),
      i(3),
    }),
    { condition = in_mathzone }
  ),

  -- Product
  s(
    { trig = "prod", snippetType = "autosnippet", wordTrig = true },
    fmta("product_(<>)^(<>) <>", {
      i(1, "i=1"),
      i(2, "n"),
      i(3),
    }),
    { condition = in_mathzone }
  ),

  -- Parentheses Matrix
  s(
    { trig = "pmat", snippetType = "autosnippet" },
    fmta(
      [[
      mat(
        delim: "(",
        <>
      )
    ]],
      { i(1) }
    ),
    { condition = in_mathzone }
  ),

  -- Bracket Matrix
  s(
    { trig = "bmat", snippetType = "autosnippet" },
    fmta(
      [[
      mat(
        delim: "[",
        <>
      )
    ]],
      { i(1) }
    ),
    { condition = in_mathzone }
  ),

  -- Fast Subscript (trigger with __)
  s(
    { trig = "__", snippetType = "autosnippet", wordTrig = false },
    fmta("_(<>) ", { i(1) }),
    { condition = in_mathzone }
  ),

  -- Fast Superscript / Power (trigger with ^^)
  s(
    { trig = "^^", snippetType = "autosnippet", wordTrig = false },
    fmta("^(<>) ", { i(1) }),
    { condition = in_mathzone }
  ),
}
