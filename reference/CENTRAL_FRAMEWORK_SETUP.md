# How to Use as a Central Framework

Instead of copying this entire folder for every new book, you can treat this `_New_Book_Starter_Kit` as a central "library" and reference it from your individual book projects.

This ensures that when you update a module (like `_ANTI_AI_CORE.md`), **all** your book projects automatically benefit from the improvement.

## Method 1: Symbolic Links (Recommended)

This method creates a "shortcut" folder in your new project that points to the central `modules` folder. To the AI and your file system, it looks like the files are right there.

1.  **Create your new project folder:**
    ```bash
    mkdir MyNewBook
    cd MyNewBook
    ```

2.  **Link the `modules` folder:**
    Run this command (replace the path with the actual path to your starter kit):
    ```bash
    # Linux / Mac / WSL / PowerShell 7+
    ln -s /mnt/c/Users/toast/Documents/Books/_New_Book_Starter_Kit/modules ./modules
    ```
    *(Note: On standard Windows Command Prompt, use `mklink /D modules "C:\Users\toast\Documents\Books\_New_Book_Starter_Kit\modules"`)*

3.  **Copy the Config Files:**
    You still need your own `CLAUDE.md` and `GEMINI.md` because they contain project-specific details (Characters, Plot, Tone).
    ```bash
    cp /mnt/c/Users/toast/Documents/Books/_New_Book_Starter_Kit/CLAUDE.md .
    cp /mnt/c/Users/toast/Documents/Books/_New_Book_Starter_Kit/GEMINI.md .
    ```

4.  **Ready!**
    Your `CLAUDE.md` will work without changes because it looks for `modules/File.md`, and your symbolic link makes that path valid.

---

## Method 2: Absolute Paths

If you prefer not to use links, you can edit your `CLAUDE.md` to point directly to the central files.

1.  **Copy the Config Files** to your new project.
2.  **Edit `CLAUDE.md`** to use full paths:

    ```markdown
    ### Foundation (Always Active)
    - `/mnt/c/Users/toast/Documents/Books/_New_Book_Starter_Kit/modules/_MASTER_STORYTELLER_CORE.md`
    - `/mnt/c/Users/toast/Documents/Books/_New_Book_Starter_Kit/modules/_AUTHOR_VOICE_BUILDER.md`
    ...
    ```

*Pros:* Explicit and clear.
*Cons:* If you move the Starter Kit, you break every project's links.

## Method 3: Git Submodules (Advanced)

If you want to version control exactly *which* version of the framework a book uses (to prevent an update from breaking an old book):

1.  Initialize your new book as a git repo.
2.  Add the Starter Kit as a submodule:
    ```bash
    git submodule add <URL_TO_STARTER_KIT_REPO> modules
    ```