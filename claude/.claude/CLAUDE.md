@RTK.md
@GIT.md

<!-- build-brief:instructions:start -->
## build-brief

- Prefer `build-brief gradle ...` for PATH Gradle and `build-brief ./gradlew ...` for the project wrapper.
- For chained shell commands, rewrite each Gradle segment individually, for example `build-brief gradle test && build-brief gradle check`.
- Use the default `build-brief` output for routine Gradle work; clean success cases stay intentionally short.
- Use the default `build-brief` output for report-style commands like `tasks`, `help`, `projects`, `dependencies`, and `dependencyInsight`; their report bodies are preserved.
- Use `build-brief gradle --stacktrace ...` or `build-brief ./gradlew --stacktrace ...` when you need Gradle stack traces.
- `build-brief` normalizes output-shaping flags like `--quiet`, `--warn`, `--warning-mode ...`, and `--console ...` so its reducer keeps working reliably.
- Let Gradle daemon reuse happen by default; `build-brief` strips explicit `--daemon` and `--no-daemon` overrides instead of forcing daemon-off behavior.
- Keep the raw log path in your response when build diagnostics may need deeper inspection.
- RTK is installed on this machine. Prefer `build-brief` directly for Gradle commands instead of wrapping Gradle work in RTK first.
- If this tool rewrites or intercepts raw Gradle commands, let that path route chained `&&`, `||`, and `;` Gradle segments to `build-brief` too instead of sending Gradle through RTK first.

### Hook guidance

- If this tool supports command hooks, add a guardrail that reminds or rewrites routine `gradle`/`./gradlew` usage to `build-brief gradle ...` or `build-brief ./gradlew ...` where safe, including chained `&&`, `||`, and `;` shell segments.
- Keep raw Gradle available as a fallback for unusual cases or when full unfiltered output is explicitly needed.

### Plugin guidance

- The managed Claude Code plugin installs a local marketplace and registers a local `build-brief` plugin with `claude plugin install`.
- Its `PreToolUse` hook blocks routine raw `gradle` and `./gradlew` Bash commands, including chained `&&`, `||`, and `;` Gradle segments, and suggests the `build-brief rewrite ...` result instead.
- Claude Code hooks provide the blocking guardrail, not an in-place command rewrite, so keep raw Gradle available when you intentionally want to bypass it.
<!-- build-brief:instructions:end -->
