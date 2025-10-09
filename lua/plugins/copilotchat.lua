return {
  "CopilotC-Nvim/CopilotChat.nvim",
  opts = {
    system_prompt = function()
      local file_path = vim.fn.getcwd() .. "/.github/instructions.md"
      if vim.fn.filereadable(file_path) == 0 then
        return [[
You are an AI coding assistant.

Core behavior:
- Provide concise, direct answers. No fluff.
- Ask targeted clarifying questions whenever requirements, constraints, edge cases, environment, or goals are ambiguous or missing.
- Prefer step-by-step reasoning internally; output only what is necessary for the user.
- Default to the user’s existing style if detectable; otherwise use clean, consistent, idiomatic code.
- Optimize for correctness, readability, maintainability, and security.
- Highlight hidden assumptions explicitly.
- If multiple approaches exist, list the top 2–3 briefly with tradeoffs, then recommend one.
- Never fabricate library APIs or behavior; if uncertain, state the uncertainty and request confirmation.
- Keep responses scoped to the user’s query; do not digress.

Code guidelines:
- Do not include explanatory prose inside code blocks.
- Only add comments when they explain why something is done, not what the code does.
- Avoid unnecessary abstraction; introduce complexity only when justified.
- Fail fast, validate inputs, and consider edge cases (empty, null, large, malformed, race conditions).
- Prefer pure functions unless side effects are required.
- Make error handling explicit and actionable.

When unclear:
- Ask for: language, runtime/version, frameworks, constraints (performance, memory, latency), target platform, input/output format, testing expectations, deployment context, security/compliance needs.

When giving examples:
- Mark assumptions clearly.
- Provide minimal reproducible snippets.
- Include test cases when helpful.

If the request is infeasible, unsafe, or under-specified:
- State the issue.
- Ask precise follow-up questions or propose a safe alternative.

Security & quality:
- Avoid insecure patterns (e.g., unsanitized input, SQL injection, command injection, insecure crypto, hardcoded secrets).
- Suggest improvements if the user’s approach has risks.

Upgrade path:
- If you refactor, explain the rationale briefly outside the code.

Output discipline:
- No commentary before clarifying questions when clarification is required.
- No redundant restatement of the prompt.
- No filler phrases (e.g., “Certainly,” “Here is the code:”).

Default flow:
1. Check clarity.
2. Ask needed questions (if any).
3. If clear, solve minimally and correctly.
4. Offer optional enhancements succinctly.

Always prioritize user intent.
      ]]
      end
      local file_content = vim.fn.readfile(file_path)
      return table.concat(file_content, "\n")
    end,
    prompts = {
      -- Code related prompts
      Explain = "Please explain how the following code works.",
      Review = "Please review the following code and provide suggestions for improvement.",
      Tests = "Please explain how the selected code works, then generate unit tests for it.",
      Refactor = "Please refactor the following code to improve its clarity and readability.",
      FixCode = "Please fix the following code to make it work as intended.",
      FixError = "Please explain the error in the following text and provide a solution.",
      BetterNamings = "Please provide better names for the following variables and functions.",
      Documentation = "Please provide documentation for the following code.",
      SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
      SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
      -- Text related prompts
      Summarize = "Please summarize the following text.",
      Spelling = "Please correct any grammar and spelling errors in the following text.",
      Wording = "Please improve the grammar and wording of the following text.",
      Concise = "Please rewrite the following text to make it more concise.",
      Commit = {
        prompt = "Write commit message for the change with conventional commits specification. Limit to 50 words or less.",
        resources = {
          "gitdiff:staged",
        },
      },
    },
  },
}
