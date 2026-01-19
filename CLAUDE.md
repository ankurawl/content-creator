# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

This is a content creation workspace so anyone can generate data-driven articles. The workflow uses a high level outline of a topic and relevant content in `input.md`. Then claude has to generates an article and writes it to `article.md`. 

## Reference Files 

1. **INPUT**: input.md - Topic, Expected narrative and other details to write the article. 
2. **OUTPUT**: article.md - Output file containing the generated article. 


## Critical Writing Requirements

### Writing Style Requirements

- IMPORTANT: Write like a story with a beginning, middle, and end
  - Beginning: Set up the question or problem (1-2 paragraphs)
  - Middle: Present evidence in a logical flow that builds toward a conclusion (bulk of article)
  - End: Clear conclusion that resolves the opening question (1-2 paragraphs)
- CRITICAL: Include specific numbers, data and other facts inside the article narrative.  
  - Bad: "Nvidia has seen enormous market cap growth"
  - Good: "Nvidia's market cap grew from $360B in 2020 to $3.1T in 2024"
  - Bad: "PE ratios remain within historical ranges"
  - Good: "Microsoft's P/E of 35 sits near its 5-year average of 33"

- REFERENCE: See writing style for posts under the posts tab on https://ankur-aggarwal.me  

**Do:**
- Direct, concise narrative suitable for business executives
- Fact-based analysis with minimal adjectives; Use specific numbers and company names
- Simple sentence structure and vocabulary (avoid jargon)
- Make the article easy to scan; include headers, sections, numbered lists, short paragraphs 
- Include a "Sources" section at the end; cite sources for all facts and statistics in the article 

**Don't:**
- Make unsupported claims about causation
- Oversimplify complex economic factors
- Ignore counterarguments (briefly acknowledge them) 
- Use jargon without explanation 
- Exceed 500 words (±25 words acceptable) 

### Narrative Flow Requirements
- Build arguments progressively in ONE direction - do not circle back to earlier points
- Each section should advance the narrative, not rehash previous sections
- Avoid contradictory section headers (e.g., don't say "data tells a different story" after already presenting the data)
- Order sections logically so the reader moves from setup → evidence → conclusion without backtracking
- If you establish a conclusion in one section, the next section should build on it, not re-examine it

## Data Validation & Verification Protocol

### MANDATORY: Complete Before Writing Any Article

#### Stage 1: Parse Prompt Requirements
You MUST:
1. Extract all factual claims requiring verification
2. Identify specific data points needed (market cap, P/E ratio, revenue, valuation, other numbers)
3. Create validation checklist in chat (show to user)

#### Stage 2: Hybrid Data Collection

**Use Financial APIs (FMP MCP) for:**
- Public company market caps
- P/E, P/S, P/B ratios
- Revenue, earnings, balance sheet data
- Historical financial trends (2-5 years)
- Any other information disclosed by companies in their regulatory filings 

**Use Web Research for: (avoid outdated or unreliable data)**
- Private company valuations (funding announcements)
- Qualitative industry context
- Historical market comparisons (dot-com bubble, etc.)
- Recent news (<100 days)
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
- Private Valuations: ±15% variance acceptable

**Variance Example:**
- Source 1 (FMP): $3.2T
- Source 2 (Yahoo): $3.18T
- Source 3 (SEC): $3.22T
- Variance: 1.25% ✓ PASS (use median: $3.2T)

**Conflict Resolution:**
- All 3 sources agree (within tolerance): Use median value
- 2/3 sources agree: Use agreeing value, note discrepancy
- All diverge (>tolerance): flag conflicts; make reasonable assumptions; call out implications 


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
