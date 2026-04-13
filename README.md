# Gas Town Operator Room with tmux

This README explains the tmux setup we created for running and observing **Gas Town** on macOS.

It is written for someone who is new to both:

* **tmux**
* **Gas Town**

---

## 1. What this setup is for

This tmux setup gives you a stable **operator room** for Gas Town.

Instead of opening random Terminal tabs and losing track of what is running, you get one tmux session with named windows:

* `mayor`
* `feed`
* `agents`
* `rig`
* `scratch`

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

This matches the way you want to operate Gas Town:

* one place to **give commands**
* one place to **watch activity**
* one place to **inspect running agents**
* one place to **verify repo changes**
* one place for **temporary work**

---

# 2. What tmux is

`tmux` is a **terminal multiplexer**.

That means it lets you run multiple terminal workspaces inside one Terminal window, and it keeps them alive even if you detach and come back later.

### Basic tmux hierarchy

```text
tmux
└── session
    └── windows
        └── panes
```

Meaning:

* **session** = the overall workspace
* **window** = like a tab inside tmux
* **pane** = a split terminal inside a window

In our setup:

* session = `gastown-ops`
* windows = `mayor`, `feed`, `agents`, `rig`, `scratch`
* panes = splits inside `feed`, `agents`, and `rig`

---

# 3. The tmux ideas you need to know

You do **not** need to learn all of tmux to use this setup.

You mainly need these.

## Prefix key

tmux commands start with a prefix.

Default tmux prefix:

```text
Ctrl+b
```

That means:

1. press `Ctrl+b`
2. release
3. press another key

Example:

```text
Ctrl+b w
```

opens the window list.

---

# 4. tmux commands you’ll use most

## Move between windows

```text
Ctrl+b n
```

Next window

```text
Ctrl+b p
```

Previous window

```text
Ctrl+b w
```

Show window list and choose one

### Practical use

This is how you move between:

* `mayor`
* `feed`
* `agents`
* `rig`
* `scratch`

---

## See tmux sessions

```text
Ctrl+b s
```

Show session list

### Practical use

If you ever end up with more than one tmux session, this lets you jump between them.

---

## Split panes

You do not need these often because the script already creates the main panes, but they are useful.

```text
Ctrl+b %
```

Split vertically

```text
Ctrl+b "
```

Split horizontally

---

## Move between panes

```text
Ctrl+b then arrow key
```

Move to another pane

Example:

* `Ctrl+b` then left arrow
* `Ctrl+b` then down arrow

---

## Detach from tmux

```text
Ctrl+b d
```

This exits the tmux view but leaves everything running.

This is one of the biggest benefits of tmux.

### Practical use

You can leave Gas Town running, close your Terminal tab, then come back later.

---

## Reattach later

From a normal shell, not from inside tmux:

```bash
tmux attach -t gastown-ops
```

Or with your helper:

```bash
gtops_attach
```

---

# 5. How to scroll up and down in tmux

This is the part that usually trips up new tmux users.

When a window like `mayor` prints a lot of text, your normal mouse wheel may not work the way you expect unless tmux mouse support is enabled and the program in that pane is not capturing input.

The most reliable way to scroll is **copy mode**.

## Enter copy mode

```text
Ctrl+b [
```

That puts you into tmux scrollback mode.

## Move around in copy mode

Use these keys:

```text
Up / Down arrows     move line by line
Page Up / Page Down  move by pages
g                    jump to the top
G                    jump to the bottom
```

Because your tmux config uses vi-style keys, these also work:

```text
k        up
j        down
Ctrl+u   half page up
Ctrl+d   half page down
```

## Exit copy mode

```text
q
```

or

```text
Enter
```

## The simplest beginner pattern

When `mayor` prints a lot of text:

1. press `Ctrl+b [`
2. use `Page Up`, `Page Down`, arrows, `j`, or `k`
3. press `q` to leave scroll mode

## Mouse scrolling

Your tmux config has:

```tmux
set -g mouse on
```

So in many cases you can also use:

* two-finger scroll on a trackpad
* mouse wheel

But when that feels inconsistent, use **copy mode**. It is the dependable method.

## Why this matters for Gas Town

The `mayor` window often outputs a lot of text. The `feed` window can also move quickly. Copy mode gives you a dependable way to inspect earlier output without losing your place.

---

# 6. How to start this setup

## Start the operator room

From a normal terminal:

```bash
gtops
```

Or target a rig:

```bash
gtops gastown-ops innercheck
```

That launches the tmux session and opens the windows.

---

## Inside the mayor window

Once the session opens, run:

```bash
gt mayor attach
```

That is the intended next step.

---

# 7. What each window is for

This is the part that matters most.

---

## `mayor`

### What it is

This is your **main command window**.

### What you do here

You use this window to:

* attach to the Mayor
* issue high-level instructions
* interact with Gas Town at the top level

### Typical command

```bash
gt mayor attach
```

### How it fits development

This is where you act like the operator or manager of the system.

Examples:

* ask Gas Town to work on a bug
* start or inspect coordination work
* guide the system at a high level

### Mental model

Think of `mayor` as:

```text
control room / chief-of-staff / orchestrator console
```

### Example workflow

You enter the `mayor` window and start the session:

```bash
gt mayor attach
```

Then you guide work from there.

---

## `feed`

### What it is

This is your **live activity monitor**.

### What panes it has

Left pane:

```bash
gt feed
```

Right pane:

```bash
gt feed --problems
```

### What you do here

You use this window to watch:

* current activity
* work moving through the town
* issues, stalled behavior, or suspicious output

### How it fits development

This is like your dashboard.

Use it when you want to answer:

* Is the town doing work right now?
* Is anything failing?
* Are there blocked or unhealthy workers?

### Mental model

Think of `feed` as:

```text
live event stream + trouble monitor
```

### Example workflow

After asking the Mayor to do something, switch to `feed` and watch whether activity appears and whether problems show up.

---

## `agents`

### What it is

This is your **agent/session inspection window**.

### What panes it has

Pane 1:

```bash
gt agents
```

Pane 2:

```bash
tmux ls
```

Pane 3:
instructions / notes

### What you do here

You use this window to inspect:

* what Gas Town thinks is running
* what tmux sessions actually exist
* whether there are mismatches or too much session sprawl

### How it fits development

This is very useful when:

* something seems stuck
* you want to see active workers
* you are learning how Gas Town maps onto tmux
* you want to debug session behavior

### Mental model

Think of `agents` as:

```text
system inventory + session map
```

### Example questions this window helps answer

* Do I actually have agents running?
* Are tmux sessions alive?
* Is Gas Town showing active agents but tmux is missing something?
* Did something die silently?

---

## `rig`

### What it is

This is your **repo work and verification window**.

### What panes it has

Top pane:
current directory / file listing

Bottom-left pane:
git status

Bottom-right pane:
free pane for tests, server, diffs, or logs

### What you do here

You use this window for normal development support work:

* verify you are in the right repo
* inspect files
* run tests
* check git status
* inspect diffs
* run app commands

### How it fits development

This is where you validate what the system is changing.

The Mayor may coordinate work, and `feed` may show activity, but `rig` is where you verify the actual codebase.

### Mental model

Think of `rig` as:

```text
human review and verification workspace
```

### Example uses

In the free pane you might run:

```bash
pnpm test
```

or

```bash
npm run dev
```

or

```bash
git diff
```

This is the window where you maintain confidence that the work happening in Gas Town lines up with the repo state you care about.

---

## `scratch`

### What it is

This is your **temporary work area**.

It is not a formal Gas Town concept. It is just good operator hygiene.

### What you do here

Use it for:

* one-off commands
* temporary notes
* grep/find work
* experiments
* commands you do not want cluttering the main windows

### How it fits development

This keeps the important windows clean.

Instead of polluting `mayor` or `rig`, use `scratch` when you want to try something quickly.

### Mental model

Think of `scratch` as:

```text
clipboard / workbench / throwaway terminal
```

---

# 8. Recommended beginner workflow

Here is the simple daily pattern.

## Step 1: start the room

```bash
gtops gastown-ops innercheck
```

## Step 2: in `mayor`, attach

```bash
gt mayor attach
```

## Step 3: inspect `feed`

Use:

```text
Ctrl+b w
```

Select `feed`.

Watch for activity and problems.

## Step 4: inspect `agents`

Look at:

* `gt agents`
* `tmux ls`

This helps you understand what Gas Town is running.

## Step 5: inspect `rig`

Check:

* current folder
* `git status`
* tests or app runtime

## Step 6: use `scratch` for one-offs

Do temporary work there instead of cluttering the important windows.

## Step 7: scroll back when needed

If any window outputs too much text:

```text
Ctrl+b [
```

Then use arrow keys, Page Up/Page Down, or `j` and `k`.

Press `q` when done.

## Step 8: detach when done

```text
Ctrl+b d
```

## Step 9: later, reattach

```bash
gtops_attach
```

---

# 9. Shutdown and restart

## Recommended stop command

From a normal terminal tab:

```bash
cd ~/gt
gt down
```

### Why use a separate terminal tab

This keeps shutdown separate from your operator view and reduces confusion while you are still learning tmux.

---

# 9A. Start-of-day and end-of-day routine

This is the simplest routine to follow when you begin work and when you are done for the day.

## Start of day

### 1. Open a normal Terminal tab

Go to your Gas Town root:

```bash
cd ~/gt
```

### 2. Start your operator room

```bash
gtops gastown-ops innercheck
```

Or, if you are not targeting a rig:

```bash
gtops
```

### 3. In the `mayor` window, attach to the Mayor

```bash
gt mayor attach
```

### 4. Check the room quickly

Look at:

* `feed` to see current activity
* `agents` to see what is running
* `rig` to confirm you are in the right place

This gives you a fast health check before you start real work.

### 5. Begin work

Use:

* `mayor` for high-level direction
* `feed` for monitoring
* `agents` for inspection
* `rig` for repo verification
* `scratch` for one-off commands

## End of day

When you are done working and want to shut down your computer, follow this routine.

### 1. Stop giving new work

Do not start a new task in the `mayor` window right before leaving.

### 2. Check `feed`

Look at the `feed` window and see whether the town is still busy or whether there are visible problems.

### 3. Check `agents`

Look at the `agents` window and see what is still running.

### 4. Park or hand off anything important

If you are in the middle of something and want to preserve the state of your work, avoid just abandoning it mentally. Make a quick note for yourself in `scratch`, or use Gas Town workflow commands that fit your process.

### 5. Detach from tmux

Inside tmux:

```text
Ctrl+b d
```

This cleanly detaches your operator room.

### 6. From a normal Terminal tab, stop Gas Town

Use your regular day-to-day stop command:

```bash
cd ~/gt
gt down
```

### 7. If the system behaved strangely, do a cleaner shutdown

If Gas Town seemed unhealthy, mismatched, or stuck, use:

```bash
cd ~/gt
gt shutdown
```

### 8. Shut down your Mac

Once Gas Town has been stopped, shut down your computer normally.

## Simple rule of thumb

Use this:

```text
Normal day  -> gt down
Weird day   -> gt shutdown
```

## End-of-day quick checklist

```text
1. Stop assigning new work
2. Check feed
3. Check agents
4. Park or note anything important
5. Detach from tmux
6. Run: cd ~/gt && gt down
7. Shut down Mac
```

---

# 10. Common mistakes

## Mistake 1: running `tmux attach` inside tmux

If you run:

```bash
tmux attach -t gastown-ops
```

from inside tmux, you may get:

```text
sessions should be nested with care, unset $TMUX to force
```

### Why

Because you are already inside a tmux session.

### What to do instead

Use:

* `Ctrl+b w`
* `Ctrl+b s`
* `Ctrl+b n`
* `Ctrl+b p`

---

## Mistake 2: forgetting the Mayor command

Opening the room does **not** automatically attach the Mayor.

You still need to run:

```bash
gt mayor attach
```

in the `mayor` window.

---

## Mistake 3: not knowing how to scroll

If the `mayor` or `feed` window prints too much text, enter copy mode:

```text
Ctrl+b [
```

Then navigate and press `q` to exit.

---

## Mistake 4: using the wrong window for the wrong job

A simple rule:

* `mayor` = control
* `feed` = monitoring
* `agents` = inspection
* `rig` = repo verification
* `scratch` = temporary work

---

# 11. Quick reference

## Start room

```bash
gtops gastown-ops innercheck
```

## In mayor

```bash
gt mayor attach
```

## Stop town

```bash
cd ~/gt
gt down
```

## Detach tmux

```text
Ctrl+b d
```

## Reattach tmux

```bash
gtops_attach
```

## Window list

```text
Ctrl+b w
```

## Session list

```text
Ctrl+b s
```

## Next window

```text
Ctrl+b n
```

## Previous window

```text
Ctrl+b p
```

## Move panes

```text
Ctrl+b then arrow key
```

## Scroll back

```text
Ctrl+b [
```

Then use arrows, Page Up/Page Down, `j`, `k`, `g`, `G`, and press `q` to exit.

---

# 12. Best mental model for a beginner

Here is the simplest way to think about the whole setup:

```text
mayor   = tell Gas Town what to do
feed    = watch what is happening
agents  = see who is running
rig     = inspect the repo and validate work
scratch = do temporary side work
```

If you remember just that, the setup will feel much less confusing.

---

# 13. Appendix A: current `gastown-ops` script

See the gastown-ops file in this repo

---

# 14. Appendix B: zsh helpers

See the zsh-helpers file in this repo contains the helpers.

Add these to your `~/.zshrc`:

Then reload:

```bash
source ~/.zshrc
```
