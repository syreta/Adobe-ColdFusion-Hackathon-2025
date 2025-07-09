# Adobe ColdFusion Hackathon 2025

This repository contains [syreta's][syreta] official submission for the [Adobe ColdFusion Hackathon 2025][hackathon].

## 🏆 Hackathon Winner

We're proud to share that **we won the Adobe ColdFusion Hackathon 2025**!
Huge thanks to Adobe for organizing the event and making this challenge possible.

🔗 [Check out the announcement on LinkedIn](https://www.linkedin.com/posts/marktakata_coldfusion-hackathon-hackathon-activity-7342921459155030016-REhd)

## Project: LogScope

**LogScope** is a modern ColdFusion-based log analyzer that turns raw web server logs into interactive dashboards.
It visualizes trends, detects bots, and provides metrics like response time and status code distributions - all powered by Adobe ColdFusion 2025.

## Tech Stack

- Adobe ColdFusion 2025
- jQuery 3.7 + Bootstrap 5

## Key Features

- 📊 Interactive dashboards using `<cfchart>` (bar, pie, line, donut, area)
- 📁 CSV-based file selection & preview
- 🤖 Bot detection via User-Agent pattern matching
- ⏱️ Min, max, and average response time analysis
- 📃 PDF Report with custom theme
- ⚙️ Built using ColdFusion 2025 features:
  - Null-coalescing (`??`)
  - `csvRead()` with custom headers
  - Trailing comma on last element in arrays, structs, functions, ...
  - Modern `cfscript` struct & array syntax
  - Secure output via `encodeForHTML()`

## Submission Requirements

- ✅ Application must run on Adobe ColdFusion 2025
- 📁 Submissions must be self-contained and runnable (drop into `cfusion/wwwroot`)
- 🔓 Any included libraries must be open source licensed

## How to Run

1. Install ColdFusion 2025
2. Drop the files into `cfusion/wwwroot/logscope`
3. Add `.log` files into the `data/` folder
4. Visit: `http://localhost:8500/logscope/`

[hackathon]: https://adobe-cold-fusion-hackathon.meetus.adobeevents.com
[syreta]: https://www.syreta.com