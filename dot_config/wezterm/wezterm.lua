local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.automatically_reload_config = true

config.font_size = 12.0
config.use_ime = true
config.window_background_opacity = 0.80
config.macos_window_background_blur = 20
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

config.window_frame = {
	inactive_titlebar_bg = "none",
	active_titlebar_bg = "none",
}
config.window_background_gradient = {
	colors = { "#000000" },
}
config.show_new_tab_button_in_tab_bar = false
config.tab_max_width = 50
config.show_close_tab_button_in_tabs = false
config.colors = {
	tab_bar = {
		inactive_tab_edge = "none",
	},
}
local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_lower_right_triangle
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_upper_left_triangle

-- タブタイトル用のキャッシュ
local tab_title_cache = {}

wezterm.on("update-status", function(window, pane)
	local pane_id = pane:pane_id()
	local info = pane:get_foreground_process_info()
	if info and info.cwd then
		local cwd = info.cwd
		local dir_name = cwd:match("([^/]+)$") or cwd

		-- git worktree判定
		local title = dir_name
		local success, stdout = wezterm.run_child_process({ "git", "-C", cwd, "rev-parse", "--git-common-dir" })
		if success then
			local git_common = stdout:gsub("%s+$", "")
			local _, git_dir_out = wezterm.run_child_process({ "git", "-C", cwd, "rev-parse", "--git-dir" })
			if git_dir_out then
				local git_dir = git_dir_out:gsub("%s+$", "")
				if git_common ~= git_dir then
					-- worktreeの場合もdir_nameのみ表示
					title = dir_name
				end
			end
		end

		tab_title_cache[pane_id] = title
	end
end)

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local background = "#5c6d74"
	local foreground = "#FFFFFF"
	local edge_background = "none"

	if tab.is_active then
		background = "#ae8b2d"
		foreground = "#FFFFFF"
	end

	local edge_foreground = background
	local pane = tab.active_pane
	local cached_title = tab_title_cache[pane.pane_id]
	local tab_title = cached_title or pane.title
	local title = "   " .. wezterm.truncate_right(tab.tab_index + 1 .. ": " .. tab_title, max_width - 1) .. "   "

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_LEFT_ARROW },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = title },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = SOLID_RIGHT_ARROW },
	}
end)

config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 2000 }
config.disable_default_key_bindings = true
config.keys = require("keybinds").keys
config.key_tables = require("keybinds").key_tables

-- ============================================
-- Git Worktree 管理
-- ============================================

local act = wezterm.action

-- gitリポジトリのルートを取得
local function get_git_root(cwd)
	local success, stdout = wezterm.run_child_process({ "git", "-C", cwd, "rev-parse", "--show-toplevel" })
	if success then
		return stdout:gsub("%s+$", "")
	end
	return nil
end

-- リポジトリ名を取得
local function get_repo_name(git_root)
	return git_root:match("([^/]+)$")
end

-- Worktree一覧を取得
local function get_worktrees(cwd)
	local success, stdout = wezterm.run_child_process({ "git", "-C", cwd, "worktree", "list", "--porcelain" })
	if not success then
		return nil
	end

	local worktrees = {}
	local current_path = nil

	for line in stdout:gmatch("[^\n]+") do
		if line:match("^worktree ") then
			current_path = line:match("^worktree (.+)")
		elseif line:match("^branch ") and current_path then
			local branch = line:match("^branch refs/heads/(.+)")
			table.insert(worktrees, { path = current_path, branch = branch or "detached" })
		elseif line:match("^detached") and current_path then
			table.insert(worktrees, { path = current_path, branch = "(detached)" })
		end
	end

	return worktrees
end

-- 1. Worktree選択
wezterm.on("select-worktree", function(window, pane)
	local cwd_url = pane:get_current_working_dir()
	if not cwd_url then
		window:toast_notification("wezterm", "ディレクトリを取得できません", nil, 3000)
		return
	end
	local cwd = cwd_url.file_path

	local worktrees = get_worktrees(cwd)
	if not worktrees or #worktrees == 0 then
		window:toast_notification("wezterm", "gitリポジトリではありません", nil, 3000)
		return
	end

	local choices = {}
	for _, wt in ipairs(worktrees) do
		table.insert(choices, { id = wt.path, label = wt.branch .. "  →  " .. wt.path })
	end

	window:perform_action(
		act.InputSelector({
			title = "Worktree を選択",
			choices = choices,
			action = wezterm.action_callback(function(win, p, id, label)
				if id then
					win:perform_action(act.SpawnCommandInNewTab({ cwd = id }), p)
				end
			end),
		}),
		pane
	)
end)

-- 2. Worktree作成
wezterm.on("create-worktree", function(window, pane)
	local cwd_url = pane:get_current_working_dir()
	if not cwd_url then
		window:toast_notification("wezterm", "ディレクトリを取得できません", nil, 3000)
		return
	end
	local cwd = cwd_url.file_path

	local git_root = get_git_root(cwd)
	if not git_root then
		window:toast_notification("wezterm", "gitリポジトリではありません", nil, 3000)
		return
	end

	-- ブランチ一覧を取得
	local success, stdout = wezterm.run_child_process({ "git", "-C", cwd, "branch", "-a", "--format=%(refname:short)" })
	if not success then
		window:toast_notification("wezterm", "ブランチ一覧を取得できません", nil, 3000)
		return
	end

	local choices = {}
	-- 新規ブランチ作成オプション
	table.insert(choices, { id = "__new__", label = "[新規ブランチを作成]" })

	for branch in stdout:gmatch("[^\n]+") do
		-- origin/HEAD -> xxx のようなエントリをスキップ
		if not branch:match("->") then
			table.insert(choices, { id = branch, label = branch })
		end
	end

	local repo_name = get_repo_name(git_root)
	local parent_dir = git_root:match("(.+)/[^/]+$")

	window:perform_action(
		act.InputSelector({
			title = "Worktree を作成するブランチを選択",
			choices = choices,
			action = wezterm.action_callback(function(win, p, id, label)
				if not id then
					return
				end

				if id == "__new__" then
					-- 新規ブランチ名を入力
					win:perform_action(
						act.PromptInputLine({
							description = "新しいブランチ名を入力:",
							action = wezterm.action_callback(function(w, pa, line)
								if not line or line == "" then
									return
								end
								local branch_name = line:gsub("%s+", "-")
								local worktree_path = parent_dir .. "/" .. repo_name .. "-" .. branch_name
								local result, out, err = wezterm.run_child_process({
									"git",
									"-C",
									git_root,
									"worktree",
									"add",
									"-b",
									branch_name,
									worktree_path,
								})
								if result then
									w:toast_notification("wezterm", "Worktree作成: " .. branch_name, nil, 3000)
									w:perform_action(act.SpawnCommandInNewTab({ cwd = worktree_path }), pa)
								else
									w:toast_notification("wezterm", "作成失敗: " .. (err or ""), nil, 5000)
								end
							end),
						}),
						p
					)
				else
					-- 既存ブランチでworktree作成
					local branch_name = id:gsub("^origin/", "")
					local worktree_path = parent_dir .. "/" .. repo_name .. "-" .. branch_name
					local result, out, err =
						wezterm.run_child_process({ "git", "-C", git_root, "worktree", "add", worktree_path, id })
					if result then
						win:toast_notification("wezterm", "Worktree作成: " .. branch_name, nil, 3000)
						win:perform_action(act.SpawnCommandInNewTab({ cwd = worktree_path }), p)
					else
						win:toast_notification("wezterm", "作成失敗: " .. (err or ""), nil, 5000)
					end
				end
			end),
		}),
		pane
	)
end)

-- 3. Worktree削除
wezterm.on("remove-worktree", function(window, pane)
	local cwd_url = pane:get_current_working_dir()
	if not cwd_url then
		window:toast_notification("wezterm", "ディレクトリを取得できません", nil, 3000)
		return
	end
	local cwd = cwd_url.file_path

	local git_root = get_git_root(cwd)
	if not git_root then
		window:toast_notification("wezterm", "gitリポジトリではありません", nil, 3000)
		return
	end

	local worktrees = get_worktrees(cwd)
	if not worktrees or #worktrees <= 1 then
		window:toast_notification("wezterm", "削除できるworktreeがありません", nil, 3000)
		return
	end

	-- メインworktree以外を選択肢に
	local choices = {}
	for _, wt in ipairs(worktrees) do
		if wt.path ~= git_root then
			table.insert(choices, { id = wt.path, label = wt.branch .. "  →  " .. wt.path })
		end
	end

	if #choices == 0 then
		window:toast_notification("wezterm", "削除できるworktreeがありません", nil, 3000)
		return
	end

	window:perform_action(
		act.InputSelector({
			title = "削除する Worktree を選択",
			choices = choices,
			action = wezterm.action_callback(function(win, p, id, label)
				if id then
					local result, out, err =
						wezterm.run_child_process({ "git", "-C", git_root, "worktree", "remove", id })
					if result then
						win:toast_notification("wezterm", "Worktree削除: " .. id, nil, 3000)
					else
						-- --forceで再試行
						win:toast_notification("wezterm", "強制削除を試行中...", nil, 2000)
						local result2, out2, err2 =
							wezterm.run_child_process({ "git", "-C", git_root, "worktree", "remove", "--force", id })
						if result2 then
							win:toast_notification("wezterm", "Worktree強制削除: " .. id, nil, 3000)
						else
							win:toast_notification("wezterm", "削除失敗: " .. (err2 or ""), nil, 5000)
						end
					end
				end
			end),
		}),
		pane
	)
end)

return config
