# Contributing to dotnet-enterprise-itsm

Thank you for your interest in contributing to **dotnet-enterprise-itsm**! We welcome contributions from developers, DevOps engineers, and ITIL practitioners.

---

## Code of Conduct & Principles

1. **Be Respectful:** Treat fellow contributors with kindness, empathy, and professionalism.
2. **Enterprise Standards:** Maintain architectural purity (Clean / Onion Architecture), strict typing, and separation of concerns.
3. **Quality Gate:** All contributions must pass CI with >= 95% test coverage.

---

## How to Contribute

### 1. Reporting Bugs
- Check the [existing issues](https://github.com/Berkaybbayramoglu/dotnet-enterprise-itsm/issues) to ensure the bug hasn't already been reported.
- If not, create a new issue using our **Bug Report** template. Include your operating system, .NET SDK version, and steps to reproduce.

### 2. Suggesting Enhancements
- Open an issue using the **Feature Request** template.
- Articulate the business problem and how the feature aligns with ITIL 4 service management practices.

### 3. Submitting Pull Requests
1. **Fork & Branch:** Create a branch for your fix or feature (`git checkout -b feat/my-feature` or `fix/my-fix`).
2. **Coding Guidelines:**
   - Follow Clean Architecture: `Domain` has zero external dependencies; business logic resides in `Application`; EF Core and external adapters live in `Infrastructure`.
   - Adhere to the project's `.editorconfig` rules.
3. **Testing:**
   - Add unit tests under `tests/ItsTool.UnitTests/` for any new service, validator, or handler.
   - Run tests locally:
     ```bash
     dotnet test ItsTool.sln --configuration Release
     ```
   - Ensure all tests pass and coverage remains above 95%.
4. **Commit Format:** Use [Conventional Commits](https://www.conventionalcommits.org/) (e.g. `feat: ...`, `fix: ...`, `docs: ...`, `test: ...`).
5. **Open a PR:** Submit your pull request targeting `main`. Fill in the PR template details.

---

## Need Help?
Feel free to open an issue or start a discussion for questions regarding architecture, local setup, or design choices.
