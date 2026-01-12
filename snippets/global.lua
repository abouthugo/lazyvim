return {
  ["AI decisionFraming"] = {
    prefix = "ai-decisionframing",
    body = {
      "You are my writing co-pilot.",
      "- Context: [business mode, audience, decision & timeframe, constraints, data caveats]",
      "- Goal: Draft a concise brief that answers:",
      "\t1) What changed?",
      "\t2) Why?",
      "\t3) So what?",
      "\t4) Now what?",
      "- Tone: Clear, non-jargon.",
      "Max 250 words. Add a 1-line TL;DR.",
    },
  },
  ["AI tech2Biz"] = {
    prefix = "ai-tech2biz",
    body = {
      "You are a translator for non-technical execs.",
      "- Input: [technical finding, SQL, Python output]",
      "- Audience: [role, VP Product]",
      "- Decision Needed: [X by Y]",
      "- Rewrite:",
      "\t1) 3 bullets: impact on revenue/cost/risk",
      "\t2) Confidence & caveats",
      "\t3) A single recommended action with owner & deadline",
    },
  },
  ["AI draft"] = {
    prefix = "ai-draft",
    body = {
      "You are my editor.",
      "- Audience: [e.g, Product Leadership]",
      "- Objective: [approve plan]",
      "\nRevise this draft for clarity, brevity, and flow.",
      "Replace jargon, keep numbers, keep nuance.",
      "Return:",
      "\t1) improved text",
      "\t2) 3 notes on what you changed and why",
    },
  },
  ["AI Analysis Planning"] = {
    prefix = "ai-planning",
    body = {
      "You are a senior analytics lead.",
      "- Problem: [business question]",
      "- Metric(s): [define]",
      "- Decisions: [which levers may change]",
      'Design an analysis plan: hypotheses, required data, cuts/segments, pitfalls, success criteria, and the "decision table" we\'ll hand to the stakeholders',
    },
  },
  ["AI AskMe"] = {
    prefix = "ai-ask",
    body = {
      "Before doing anything, ask me 5 clarifying questions that would change the output, then propose 2 alternative approaches and their trade-offs.",
      "Goal: best possible answer for [audience/decision]",
    },
  },
  ["AI ideal commit history"] = {
    prefix = "ai-commit-history",
    body = {
      "Reimplement the current branch on a new branch with a clean, narrative-quality git commit history suitable for reviewer comprehension.",
    },
  },
  ["AI Topic Research"] = {
    prefix = "ai-topic-research",
    body = {
      "What would be a good group of people to explore $0? What would they say?",
    },
  },
  ["Snippet Entry"] = {
    prefix = "snip",
    body = {
      '\t["$1"] = {',
      '\t\tprefix = "$2",',
      "\t\tbody = $0",
      "\t}",
    },
  },
  ["YYYY-MM-DD Date"] = {
    prefix = "today",
    body = "$CURRENT_YEAR-$CURRENT_MONTH-$CURRENT_DATE",
  },
}
