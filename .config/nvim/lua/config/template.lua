-- =============================================================================
-- Typst template scaffolder
-- =============================================================================
-- Provides:
--   :Template          — interactive scaffolder. Pick a template, choose a
--                        project name, and decide whether to create a new
--                        subdirectory or populate the current one.
--
--   :TypstSyncPrelude  — installs (symlinks) the @local/my-prelude package
--                        into Typst's local-packages directory. Run once
--                        after first install; idempotent.
--
-- Templates live in ~/.config/nvim/templates/<name>/, and any directory there
-- containing a `main.typ` is treated as a template (so my-prelude is skipped).
--
-- Placeholders substituted in *.typ / *.bib / *.md / *.txt files:
--   {{TITLE}}   the project name you typed
--   {{AUTHOR}}  M.author below
--   {{DATE}}    today's date (e.g. April 25, 2026)
--   {{COURSE}}  asked for when scaffolding "homework"
-- =============================================================================

local M = {}

-- ----------------------------------------------------------------------------
-- Config — edit to taste
-- ----------------------------------------------------------------------------
M.author = "Arham Lodha"
M.templates_dir = vim.fn.stdpath("config") .. "/templates"
M.prelude_name = "my-prelude"
M.prelude_version = "1.0.0"

-- ----------------------------------------------------------------------------
-- Helpers
-- ----------------------------------------------------------------------------

-- Where Typst looks for `@local` packages on this OS.
local function typst_local_packages_dir()
  if vim.fn.has("mac") == 1 or vim.fn.has("macunix") == 1 then
    return vim.fn.expand("~/Library/Application Support/typst/packages/local")
  end
  local xdg = vim.env.XDG_DATA_HOME
  if xdg and xdg ~= "" then
    return xdg .. "/typst/packages/local"
  end
  return vim.fn.expand("~/.local/share/typst/packages/local")
end

-- Symlink the prelude source into Typst's local-packages dir if not already
-- present. Symlink (not copy) so edits propagate immediately.
local function ensure_prelude_installed()
  local src = M.templates_dir .. "/" .. M.prelude_name .. "/" .. M.prelude_version
  if vim.fn.isdirectory(src) == 0 then
    return false, "prelude source missing: " .. src
  end
  local dest_root = typst_local_packages_dir()
  local dest_pkg = dest_root .. "/" .. M.prelude_name
  local dest = dest_pkg .. "/" .. M.prelude_version

  -- Already installed? (covers symlinks and real dirs.)
  if vim.uv.fs_lstat(dest) ~= nil then
    return true
  end

  vim.fn.mkdir(dest_pkg, "p")
  local ok, err = vim.uv.fs_symlink(src, dest)
  if not ok then
    return false, "symlink failed: " .. (err or "?")
  end
  return true
end

-- Directories under templates_dir that look like templates (have main.typ).
local function list_templates()
  local out = {}
  local handle = vim.uv.fs_scandir(M.templates_dir)
  if not handle then
    return out
  end
  while true do
    local name, ttype = vim.uv.fs_scandir_next(handle)
    if not name then
      break
    end
    if ttype == "directory" and name ~= M.prelude_name then
      if vim.fn.filereadable(M.templates_dir .. "/" .. name .. "/main.typ") == 1 then
        table.insert(out, name)
      end
    end
  end
  table.sort(out)
  return out
end

local function read_file(path)
  local f = io.open(path, "rb")
  if not f then
    return nil
  end
  local data = f:read("*a")
  f:close()
  return data
end

local function write_file(path, data)
  local f, err = io.open(path, "wb")
  if not f then
    return false, err
  end
  f:write(data)
  f:close()
  return true
end

-- Replace {{KEY}} with vars[KEY]. Only the listed extensions get substitution.
local SUB_EXTS = { typ = true, bib = true, md = true, txt = true, toml = true }

local function substitute(data, vars)
  for k, v in pairs(vars) do
    data = data:gsub("{{" .. k .. "}}", function()
      return v
    end)
  end
  return data
end

local function copy_file(src, dst, vars)
  local data = read_file(src)
  if not data then
    return false, "read " .. src
  end
  local ext = src:match("%.([^./]+)$") or ""
  if SUB_EXTS[ext] then
    data = substitute(data, vars)
  end
  return write_file(dst, data)
end

-- Recursively copy directory contents (substituting placeholders in text files).
local function copy_tree(src, dst, vars)
  local handle = vim.uv.fs_scandir(src)
  if not handle then
    return false, "scandir " .. src
  end
  while true do
    local name, ttype = vim.uv.fs_scandir_next(handle)
    if not name then
      break
    end
    local s = src .. "/" .. name
    local d = dst .. "/" .. name
    if ttype == "directory" then
      vim.fn.mkdir(d, "p")
      local ok, err = copy_tree(s, d, vars)
      if not ok then
        return false, err
      end
    else
      local ok, err = copy_file(s, d, vars)
      if not ok then
        return false, err
      end
    end
  end
  return true
end

-- Names of files/dirs in src that already exist in dst.
local function would_clobber(src, dst)
  local conflicts = {}
  local handle = vim.uv.fs_scandir(src)
  if not handle then
    return conflicts
  end
  while true do
    local name = vim.uv.fs_scandir_next(handle)
    if not name then
      break
    end
    if vim.uv.fs_lstat(dst .. "/" .. name) ~= nil then
      table.insert(conflicts, name)
    end
  end
  return conflicts
end

local function slugify(s)
  return (s:lower():gsub("[^%w%-_]+", "-"):gsub("^%-+", ""):gsub("%-+$", ""))
end

-- ----------------------------------------------------------------------------
-- Main interactive flow
-- ----------------------------------------------------------------------------
function M.run()
  -- 0. Make sure the prelude is reachable as @local/my-prelude.
  local ok, err = ensure_prelude_installed()
  if not ok then
    vim.notify("Prelude install warning: " .. (err or "?"), vim.log.levels.WARN)
  end

  -- 1. Pick a template.
  local templates = list_templates()
  if #templates == 0 then
    vim.notify("No templates found in " .. M.templates_dir, vim.log.levels.ERROR)
    return
  end

  vim.ui.select(templates, { prompt = "Select template:" }, function(template)
    if not template then
      return
    end

    -- 2. Project name.
    vim.ui.input({ prompt = "Project name: " }, function(project_name)
      if not project_name or project_name == "" then
        return
      end

      -- 3. Destination.
      vim.ui.select(
        { "Create new subdirectory", "Populate current directory" },
        { prompt = "Destination:" },
        function(dest_choice)
          if not dest_choice then
            return
          end

          local cwd = vim.fn.getcwd()
          local target_dir
          local new_subdir = dest_choice == "Create new subdirectory"

          if new_subdir then
            local slug = slugify(project_name)
            if slug == "" then
              slug = "project"
            end
            target_dir = cwd .. "/" .. slug
            if vim.uv.fs_lstat(target_dir) ~= nil then
              vim.notify("Directory already exists: " .. target_dir, vim.log.levels.ERROR)
              return
            end
            vim.fn.mkdir(target_dir, "p")
          else
            target_dir = cwd
            local conflicts = would_clobber(M.templates_dir .. "/" .. template, target_dir)
            if #conflicts > 0 then
              vim.notify(
                "Refusing to overwrite: " .. table.concat(conflicts, ", "),
                vim.log.levels.ERROR
              )
              return
            end
          end

          -- 4. Homework needs a course name. Synchronous prompt is fine here.
          local course = ""
          if template == "homework" then
            course = vim.fn.input("Course (e.g. MATH 533): ", "")
            if course == "" then
              course = "Course"
            end
          end

          local vars = {
            TITLE = project_name,
            AUTHOR = M.author,
            DATE = os.date("%B %d, %Y"),
            COURSE = course,
          }

          local ok2, err2 = copy_tree(M.templates_dir .. "/" .. template, target_dir, vars)
          if not ok2 then
            vim.notify("Copy failed: " .. (err2 or "?"), vim.log.levels.ERROR)
            return
          end

          -- 5. cd + open main.typ.
          if new_subdir then
            vim.cmd("lcd " .. vim.fn.fnameescape(target_dir))
          end
          local main = target_dir .. "/main.typ"
          if vim.fn.filereadable(main) == 1 then
            vim.cmd("edit " .. vim.fn.fnameescape(main))
          end
          vim.notify(
            "Scaffolded '" .. template .. "' at " .. target_dir,
            vim.log.levels.INFO
          )
        end
      )
    end)
  end)
end

-- ----------------------------------------------------------------------------
-- Setup — registers :Template and :TypstSyncPrelude
-- ----------------------------------------------------------------------------
function M.setup()
  vim.api.nvim_create_user_command("Template", M.run, {
    desc = "Scaffold a Typst project from a template",
  })

  vim.api.nvim_create_user_command("TypstSyncPrelude", function()
    local ok2, err2 = ensure_prelude_installed()
    if ok2 then
      vim.notify(
        "Prelude installed at "
          .. typst_local_packages_dir()
          .. "/"
          .. M.prelude_name
          .. "/"
          .. M.prelude_version,
        vim.log.levels.INFO
      )
    else
      vim.notify("Prelude install failed: " .. (err2 or "?"), vim.log.levels.ERROR)
    end
  end, { desc = "Symlink local Typst prelude into Typst's packages dir" })
end

return M
