# Gas Town Operator Room with tmux

This guide explains how to run Gas Town inside a small tmux-based operator room on macOS.

It is designed for people who are new to:

- tmux
- Gas Town

It assumes you already have:

- `tmux` installed
- Gas Town installed and working
- a town root at `~/gt` unless you override `GT_ROOT`

This setup uses three files:

```text
README.md
scripts/gastown-ops
shell/gastown-helpers.zsh
```

For local machine use, the usual install paths are:

```text
~/bin/gastown-ops
~/.config/gastown/gastown-helpers.zsh
```

---

## What this setup gives you

This setup creates one tmux session named `gastown-ops` with these windows:

- `mayor`
- `feed`
- `agents`
- `rig`
- `scratch`

Think of it like this:

```text
Terminal.app
└── tmux session: gastown-ops
    ├── mayor   -> command and control
    ├── feed    -> live activity and problems
    ├── agents  -> active sessions and tmux state
    ├── rig     -> repo work and verification
    └── scratch -> temporary commands and notes
```

That gives you:

- one place to talk to Gas Town
- one place to monitor activity
- one place to inspect sessions and agents
- one place to verify repo changes
- one place for temporary commands

---

## What tmux is

`tmux` is a terminal multiplexer.

It lets you run multiple terminal workspaces inside one Terminal window and keep them alive even after you detach.

Basic structure:

```text
tmux
└── session
    └── windows
        └── panes
```

Meaning:

- **session** = the overall workspace
- **window** = like a tab
- **pane** = a split terminal inside a window

In this setup:

- session = `gastown-ops`
- windows = `mayor`, `feed`, `agents`, `rig`, `scratch`
- panes = the splits inside `feed`, `agents`, and `rig`

---

## Repo layout

A clean repo layout looks like this:

```text
README.md
scripts/gastown-ops
shell/gastown-helpers.zsh
```

Suggested local install:

```text
~/bin/gastown-ops
~/.config/gastown/gastown-helpers.zsh
```

---

## Installation

### 1. Save the operator script

Copy the repo script into:

```bash
~/bin/gastown-ops
```

Make it executable:

```bash
chmod +x ~/bin/gastown-ops
```

### 2. Make sure `~/bin` is on your PATH

Add this to `~/.zshrc` if needed:

```bash
export PATH="$HOME/bin:$PATH"
```

### 3. Save the helper file

Copy the helper file into:

```bash
~/.config/gastown/gastown-helpers.zsh
```

### 4. Source the helper file from `~/.zshrc`

Add this line:

```bash
source ~/.config/gastown/gastown-helpers.zsh
```

### 5. Reload your shell

```bash
source ~/.zshrc
```

---

## tmux basics you actually need

tmux commands start with a prefix.

Default prefix:

```text
Ctrl+b
```

That means:

1. press `Ctrl+b`
2. release
3. press another key

### Move between windows

```text
Ctrl+b n   next window
Ctrl+b p   previous window
Ctrl+b w   window list
```

### Move between panes

```text
Ctrl+b then arrow key
```

### Session list

```text
Ctrl+b s
```

### Detach from tmux

```text
Ctrl+b d
```

This leaves everything running and returns you to your normal shell.

### Reattach later

From a normal shell:

```bash
gtops_attach
```

or:

```bash
tmux attach -t gastown-ops
```

---

## How to scroll in tmux

This is one of the biggest beginner pain points.

When a pane like `mayor` prints a lot of text, the most reliable way to scroll back is tmux copy mode.

### Enter copy mode

```text
Ctrl+b [
```

### Move around in copy mode

```text
Up / Down arrows     move line by line
Page Up / Page Down  move by pages
g                    jump to top
G                    jump to bottom
j                    down
k                    up
Ctrl+u               half page up
Ctrl+d               half page down
```

### Exit copy mode

```text
q
```

or:

```text
Enter
```

### Mouse scrolling

If your tmux config has mouse support enabled, trackpad or mouse wheel scrolling may work.

But when it feels inconsistent, use:

```text
Ctrl+b [
```

That is the dependable method.

---

## Starting the operator room

### Generic start

```bash
gtops
```

### Start with a specific rig name

```bash
gtops gastown-ops <rig-name>
```

This starts or reattaches the tmux session.

When the session opens, go to the `mayor` window and run:

```bash
gt mayor attach
```

---

## What each window is for

### `mayor`

This is your main command window.

Use it to:

- attach to the Mayor
- issue high-level instructions
- operate Gas Town at the top level

Typical command:

```bash
gt mayor attach
```

Mental model:

```text
control room / orchestration console
```

---

### `feed`

This is your live activity monitor.

It has two panes:

Left pane:

```bash
gt feed
```

Right pane:

```bash
gt feed --problems
```

Use it to watch:

- current activity
- movement through the town
- visible problems or stalls

Mental model:

```text
event stream + trouble monitor
```

---

### `agents`

This is your agent and session inspection window.

It has three panes:

Pane 1:

```bash
gt agents
```

Pane 2:

```bash
tmux ls
```

Pane 3:

notes / reminders

Use it to inspect:

- what Gas Town thinks is running
- what tmux sessions actually exist
- mismatches between logical state and tmux state

Mental model:

```text
runtime inventory + session map
```

---

### `rig`

This is your repo verification window.

It has three panes:

- top pane for path and file listing
- bottom-left pane for `git status`
- bottom-right pane for tests, logs, diffs, or app runtime

Use it to:

- confirm you are in the right folder
- inspect repo changes
- run tests
- run app commands
- validate what the town is doing against the codebase

Mental model:

```text
human verification workspace
```

---

### `scratch`

This is your temporary workspace.

Use it for:

- one-off commands
- notes
- grep/find work
- experiments
- anything you do not want to clutter the core windows

Mental model:

```text
throwaway workbench
```

---

## Recommended daily workflow

### Start of day

1. Open a normal Terminal tab
2. Go to your town root:

```bash
cd ~/gt
```

3. Start the operator room:

```bash
gtops gastown-ops <rig-name>
```

or:

```bash
gtops
```

4. In the `mayor` window, attach:

```bash
gt mayor attach
```

5. Quickly inspect:

- `feed`
- `agents`
- `rig`

6. Start work

### During the day

Use:

- `mayor` for direction and coordination
- `feed` for monitoring
- `agents` for inspection
- `rig` for verification
- `scratch` for side work

If a pane prints too much text, scroll with:

```text
Ctrl+b [
```

### End of day

1. Stop giving new work
2. Check `feed`
3. Check `agents`
4. Make notes in `scratch` if needed
5. Detach from tmux:

```text
Ctrl+b d
```

6. From a normal Terminal tab, stop Gas Town:

```bash
cd ~/gt
gt down
```

7. If the system behaved strangely that day, use a cleaner shutdown:

```bash
cd ~/gt
gt shutdown
```

8. Shut down your Mac normally

Rule of thumb:

```text
Normal day  -> gt down
Weird day   -> gt shutdown
```

---

## Common mistakes

### Running `tmux attach` from inside tmux

You may see:

```text
sessions should be nested with care, unset $TMUX to force
```

That means you are already inside tmux.

Use these instead:

```text
Ctrl+b w
Ctrl+b s
Ctrl+b n
Ctrl+b p
```

### Forgetting to attach the Mayor

Opening the operator room does not automatically start the Mayor conversation.

You still need:

```bash
gt mayor attach
```

### Not knowing how to scroll back

Use:

```text
Ctrl+b [
```

Then navigate and press `q` to exit.

### Mixing shutdown commands into the active operator room

It is cleaner to run:

```bash
cd ~/gt
gt down
```

from a normal terminal tab.

---

## Quick reference

### Start room

```bash
gtops
```

or:

```bash
gtops gastown-ops <rig-name>
```

### In mayor

```bash
gt mayor attach
```

### Stop town

```bash
cd ~/gt
gt down
```

### Detach tmux

```text
Ctrl+b d
```

### Reattach tmux

```bash
gtops_attach
```

### Window list

```text
Ctrl+b w
```

### Session list

```text
Ctrl+b s
```

### Next window

```text
Ctrl+b n
```

### Previous window

```text
Ctrl+b p
```

### Move between panes

```text
Ctrl+b then arrow key
```

### Scroll back

```text
Ctrl+b [
```

Then use arrows, Page Up/Page Down, `j`, `k`, `g`, `G`, and press `q` to exit.

---

## Appendix A: helper file

Use the separate `gastown-helpers.zsh` file for shell helpers.

Suggested local path:

```bash
~/.config/gastown/gastown-helpers.zsh
```

Source it from `~/.zshrc`:

```bash
source ~/.config/gastown/gastown-helpers.zsh
```

---

## Appendix B: operator script

Use the separate `gastown-ops` file for the tmux session bootstrap.

Suggested local path:

```bash
~/bin/gastown-ops
```

Make it executable:

```bash
chmod +x ~/bin/gastown-ops
```

---

## Appendix C: suggested local setup

Add this to `~/.zshrc` if needed:

```bash
export PATH="$HOME/bin:$PATH"
source ~/.config/gastown/gastown-helpers.zsh
```

Then reload:

```bash
source ~/.zshrc
```
