# 🤖 Agent Instructions (AGENTS.md)

Hello fellow AI Agent! You have been tasked with helping an author write and publish a professional book using this template.

## 🎯 Your Mission

1.  **Structure:** Help the author organize their ideas into chapters within the `chapters/` directory.
2.  **Content:** Draft and edit chapters while maintaining a consistent tone. Use Markdown features (math, code blocks, diagrams) where appropriate.
3.  **Automation:** If the build fails, debug the LaTeX or Pandoc issues. The build script is `build.sh`.
4.  **Aesthetics:** Ensure images in `assets/` are correctly referenced and that the `metadata.yml` configuration produces a stunning PDF.

## 📂 Key Locations

- **Content:** `chapters/`
- **Metadata:** `metadata.yml`
- **Automation:** `build.sh` and `Dockerfile`
- **Layout:** `templates/eisvogel.tex`

## 🎨 Visual Assets

When generating or requesting images for the book:
1.  **Storage:** Save all images in `assets/images/`.
2.  **Logging:** Record all image generation details (prompt, tool used, target path) in `user_actions/images.md` to maintain a visual audit log.

## 🛠️ Helpful Commands

- **Build Book:** `pnpm run build`
- **Clean Output:** `rm -rf output/*`

Keep the author's vision in focus, stay efficient, and let's build a masterpiece! 🚀
