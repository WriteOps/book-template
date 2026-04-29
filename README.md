<p align="center">
  <img src="https://raw.githubusercontent.com/WriteOps/.github/main/logo.png" alt="WriteOps" width="160" style="display: block; border-radius: 10px;" />
</p>

<p align="center">
  <b>A professional book-as-code starter kit.</b> Generate publisher-ready PDF books from Markdown using a fully automated pipeline.
</p>

<p align="center">
  <b><a href="https://github.com/WriteOps/book-template/wiki">Documentation</a></b>
  |
  <b><a href="https://github.com/WriteOps/book-template">GitHub</a></b>
</p>

[![Build PDF](https://github.com/WriteOps/book-template/actions/workflows/build-pdf.yml/badge.svg)](https://github.com/WriteOps/book-template/actions/workflows/build-pdf.yml)

## ✨ Features

- **Markdown Power:** Write your book in simple Markdown.
- **Pro Layout:** Uses the [Eisvogel](https://github.com/Wandmalfarbe/pandoc-latex-template) LaTeX template for stunning "O'Reilly-style" PDFs.
- **Automated Build:** One command to merge chapters, fix image paths, and compile the PDF.
- **Diagrams & Math:** Native support for Mermaid diagrams and KaTeX math formulas.
- **Environment Agnostic:** Fully configured Docker and VS Code DevContainer setup.
- **CI/CD Ready:** Automatically builds and releases your book PDF via GitHub Actions.

## 🚀 Getting Started

1.  Click the **"Use this template"** button above.
2.  Open the repository in **VS Code**.
3.  Reopen in **Dev Container** when prompted.
4.  Run the build:
    ```bash
    pnpm run build
    ```
5.  Find your book at `output/book.pdf`.

## 🛠️ Local Installation (Without Docker)

If you prefer to run the build script directly on your machine, you'll need the following tools:

### 1. Pandoc (3.0+)
Pandoc is the engine that converts Markdown to LaTeX.
- **macOS:** `brew install pandoc`
- **Linux:** `sudo apt-get install pandoc`
- **Windows:** `winget install pandoc`

### 2. TeX Live
You need a LaTeX distribution to generate the PDF. This template requires the `koma-script` bundle.
- **macOS (MacTeX):** `brew install --cask mactex-no-gui`
- **Linux:** `sudo apt-get install texlive-latex-base texlive-fonts-recommended texlive-extra-utils texlive-latex-extra`

### 3. Node.js & pnpm
Required for rendering Mermaid diagrams.
- Install [Node.js](https://nodejs.org/)
- Install pnpm: `npm install -g pnpm`
- Run `pnpm install` in the project root.

## 📂 Project Structure

Check out the [Getting Started Guide](./docs/1.getting-started.md) for a detailed breakdown.

## 📚 References & Resources

To customize your book further, check out these official documentations:

- **[Pandoc Manual: LaTeX Variables](https://pandoc.org/MANUAL.html#variables-for-latex)** - Every variable you can use in your `metadata.yml`.
- **[Eisvogel Template Docs](https://github.com/Wandmalfarbe/pandoc-latex-template)** - Detailed styling options for the layout used in this template.
- **[Mermaid Diagrams](https://mermaid.js.org/)** - Syntax for creating charts and diagrams.
- **[KaTeX Math](https://katex.org/docs/supported.html)** - Support for mathematical formulas.

---

Built with ❤️ by [WriteOps](https://github.com/WriteOps).
