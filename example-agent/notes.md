# example-agent — notes

This folder exists to demonstrate the repo convention (see top-level README):

- The real definition is `agent.md` in this subfolder.
- The top-level `example-agent.md` is a symlink to `example-agent/agent.md`,
  which is what Claude Code actually discovers.
- Supporting files like this one live alongside the definition and are ignored
  by Claude Code's agent discovery.

To create a real agent, copy this folder, rename it, update `agent.md`'s
frontmatter `name:`, and create the matching top-level symlink:

    cp -r example-agent my-agent
    # edit my-agent/agent.md, set name: my-agent
    ln -s my-agent/agent.md my-agent.md
