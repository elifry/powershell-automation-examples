# Powershell Automation Examples

[![Tests Status](https://github.com/elifry/powershell-automation-examples/workflows/ci/badge.svg)](https://github.com/elifry/powershell-automation-examples/actions)

Powershell (7 & up) is a cross platform powerhouse of a scripting language, and is a great low-dependencies option for generating reports, working with repos, and working with databases and files, among other things.

This repo contains a few examples that include good structure and patterns that can kick off the creation of specially built tools and save development time. These examples follow a Medium-High complexity model. It contains over-engineered examples - on purpose - because it is intended to be used as a basis for a system of automation. When using, reduce complexity as necessary.

Similar scripts could be written in Bash or Python, but both of these are not as consistent across platforms.

## Example 1: Generate a Markdown Analytics Report from API Calls

Context: use API calls to gather data and create a report in markdown. No use of local repos. Uses a local env file for secrets.

### Structure

- 📂`/scripts/`
  - 📂`/analytics/`
    - [do-api-analytics.ps1](/scripts/analytics/do-api-analytics.ps1) - Actually does the analytics bit
  - 📂`/cache/` (generated folder - ignored by git) - Holds the API data as a cache
  - 📂`/general-utilities/`
    - [load-env.ps1](/scripts/general-utilities/load-env.ps1) - Loads a .env into environment
  - 📂`/markdown-snippets/`
    - [template-analytics.ps1](/scripts/markdown-snippets/template-analytics.md) - Template for analytics with replaceable sections
  - 📂`/output/` (generated folder - ignored by git) - Where the results file goes
    - api-results.md - Output markdown file
  - 📂`/test-analytics/`
    - [test-do-api-analytics.ps1](/scripts/test-analytics/test-do-api-analytics.ps1) - Tests for the analytics in this example
  - 📂`/test-groups/`
    - [test-example1.ps1](/scripts/test-groups/test-example1.ps1) - Tests for everything in this example
  - [analyze-api-items.ps1](/scripts/analyze-api-items.ps1) - Starting point. Does setup, does analysis, and shows results

### How to run

Run the "Example 1" Run and Debug action in VSCode. Alternatively, you can run the `scripts/analyze-api-items.ps1` script directly in powershell.

It will generate a sample markdown file and open it for you in VSCode.

## Tests

- 📂`/scripts/`
  - 📂`/test-analytics/`
    - [test-do-api-analytics.ps1](/scripts/test-analytics/test-do-api-analytics.ps1)
  - 📂`/test-general-utilities/`
    - [test-load-env.ps1](/scripts/test-general-utilities/test-load-env.ps1)
    - [sample.env](/scripts/test-general-utilities/sample.env) - Sample env file for testing
  - 📂`/test-groups/`
    - [test-all.ps1](/scripts/test-groups/test-all.ps1) - Runs all tests for all examples
      - 🚀 Tied to VSCode Launch Action "Run All Tests"
    - [test-example1.ps1](/scripts/test-groups/test-example1.ps1) - Tests for Example 1 (above)
      - 🚀 Tied to  VSCode Launch Action "Example 1 Tests"

> Note: Each example runs all tests for components used in that example, with overlap because they use common components. "Run All Tests/test-all" will only run each test once, without overlap.

---

Created by Elijah Fry, [License MIT](/LICENSE).
