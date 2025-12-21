# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This is a content creation workspace for generating data-driven articles. The workflow uses a template-based approach where topic-specific content is defined in `prompt.md` and the generated article is written to `article.md`.

## File Structure

- **prompt.md**: Article writing template with Topic-specific content
- **article.md**: Output file containing the generated article

## Article Generation Workflow

1. Modify the "TOPIC-SPECIFIC CONTENT" section in `prompt.md`:
   - Define the topic and core argument
   - Specify required data and research
   - Outline key points to address

2. Generate the article by reading `prompt.md` and writing output to `article.md`

3. Do not return article content in chat output - write directly to `article.md`

## Critical Writing Requirements

### Writing Style Requirements
- IMPORTANT: Write like a story with a beginning, middle, and end
  - Beginning: Set up the question or problem (1-2 paragraphs)
  - Middle: Present evidence in a logical flow that builds toward a conclusion (bulk of article)
  - End: Clear conclusion that resolves the opening question (1-2 paragraphs)
- CRITICAL: Include specific numbers and data in the narrative itself, not just references to data existing
  - Bad: "Nvidia has seen enormous market cap growth"
  - Good: "Nvidia's market cap grew from $360B in 2020 to $3.1T in 2024"
  - Bad: "PE ratios remain within historical ranges"
  - Good: "Microsoft's P/E of 35 sits near its 5-year average of 33"
- Direct, concise narrative suitable for business executives
- Fact-based analysis with minimal adjectives
- Simple sentence structure and vocabulary (avoid jargon)
- Make scannable: bullet points, numbered lists, short paragraphs (2-3 sentences)
- Cite specific data sources for all statistics
- Include a "Sources" section at the end
- Avoid superlatives and phrases like "revolutionizing" or "game-changing"

### Narrative Flow Requirements
- Build arguments progressively in ONE direction - do not circle back to earlier points
- Each section should advance the narrative, not rehash previous sections
- Avoid contradictory section headers (e.g., don't say "data tells a different story" after already presenting the data)
- Order sections logically so the reader moves from setup → evidence → conclusion without backtracking
- If you establish a conclusion in one section, the next section should build on it, not re-examine it

## Data Validation & Verification Protocol

### MANDATORY: Complete Before Writing Any Article

**NOTE**: This workflow requires FMP MCP server configured with API key in local `.env` file. See `FMP-SETUP.md` for setup instructions.

#### Stage 1: Parse Prompt Requirements
After reading `prompt.md`, you MUST:
1. Extract all factual claims requiring verification
2. Identify specific data points needed (market caps, P/E ratios, revenue, valuations)
3. Create validation checklist in chat (show to user)

#### Stage 2: Hybrid Data Collection

**Use Financial APIs (FMP MCP) for:**
- Public company market caps
- P/E, P/S, P/B ratios
- Revenue, earnings, balance sheet data
- Historical financial trends (2-5 years)

**Use Web Research for:**
- Private company valuations (funding announcements)
- Qualitative industry context
- Historical market comparisons (dot-com bubble, etc.)
- Recent news (<30 days)
- Cross-verification of API data

#### Stage 3: Three-Source Verification (CRITICAL)

**ALL core financial metrics require 3 independent sources:**

**Source Hierarchy:**
1. Primary: FMP MCP API
2. Secondary: Yahoo/Google Finance (WebFetch)
3. Tertiary: SEC filings/Company IR (WebSearch)

**Tolerance Thresholds:**
- Market Cap: ±5% variance acceptable
- P/E Ratios: ±5% variance acceptable
- Revenue (reported): ±3% variance acceptable
- Private Valuations: ±10% variance acceptable

**Variance Example:**
- Source 1 (FMP): $3.2T
- Source 2 (Yahoo): $3.18T
- Source 3 (SEC): $3.22T
- Variance: 1.25% ✓ PASS (use median: $3.2T)

**Conflict Resolution:**
- All 3 sources agree (within tolerance): Use median value
- 2/3 sources agree: Use agreeing value, note discrepancy
- All diverge (>tolerance): HALT writing, flag conflict, request user guidance

#### Stage 4: Validate Prompt Assumptions

**Before writing, compare prompt claims vs verified data:**

**Action Required When Discrepancies Found:**
- <20% discrepancy: Adjust narrative, proceed
- >20% discrepancy: HALT, present findings to user:
  ```
  VALIDATION ALERT:
  Prompt assumes: [claim]
  Verified data: [conflicting finding]
  Discrepancy: X%

  Await user decision before proceeding
  ```

**Output Validation Summary:**
Present verification table before writing:
```
VALIDATION SUMMARY:
✓ Claim 1: Verified (FMP: X, Yahoo: X, SEC: X) - 2% variance
✓ Claim 2: Verified across 3 sources
⚠ Claim 3: Minor adjustment (prompt: X, actual: Y)
✗ Claim 4: CONFLICT - halting for review
```

#### Stage 5: Article Writing (Only After Validation Passes)

**Requirements:**
- Use exact verified numbers (median from 3 sources)
- Never use hedging language when exact data exists:
  - Bad: "approximately $4 trillion"
  - Good: "$4.4 trillion in December 2024"
- Cite sources inline where meaningful
- Include comprehensive Sources section at end

#### API Unavailability Fallback

If FMP MCP unavailable:
- Require 3 independent web sources
- Same tolerance thresholds apply
- Prioritize official sources (SEC, company IR)
- Document API unavailability in validation summary

### Research Instructions
Follow the "Data Validation & Verification Protocol" section above for all data gathering.
CRITICAL: Extract specific numbers from verified sources and embed them directly in the article narrative

---
