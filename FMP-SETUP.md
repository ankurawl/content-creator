# FMP MCP Server Setup Guide

This guide walks you through setting up the Financial Modeling Prep (FMP) MCP server for use with Claude Code to enable accurate, real-time financial data access for article generation.

**This setup uses a local `.env` file** in the project folder to keep credentials project-specific and portable.

---

## Prerequisites

- Claude Desktop installed on your system
- Node.js and npm installed (check with `node --version` and `npm --version`)
- Internet connection

---

## Step 1: Obtain FMP API Key

1. **Visit**: https://financialmodelingprep.com/developer/docs/
2. **Sign up** for a free account
3. **Navigate to** your dashboard after registration
4. **Copy your API key** (found under "API Keys" or "Dashboard")
   - Free tier provides: 250 requests/day
   - Sufficient for 10-15 articles per day

**Save your API key** - you'll need it in Step 2.

---

## Step 2: Create Local .env File

1. **Navigate to the project directory**:
   ```bash
   cd /Library/exploring-claude/content-creator
   ```

2. **Create a `.env` file**:
   ```bash
   touch .env
   ```

3. **Open `.env` in your text editor** and add your FMP API key:
   ```
   FMP_API_KEY=your_actual_api_key_here
   ```

   **Example**:
   ```
   FMP_API_KEY=abc123def456ghi789jkl012mno345pqr678
   ```

4. **Save the file**

**Important**: The `.env` file stores sensitive credentials. Never commit it to version control.

---

## Step 3: Create Project-Level MCP Configuration

Instead of modifying the global Claude Desktop configuration, we'll create a **project-specific MCP settings file** in this folder.

1. **Create `.claude/mcp_settings.json` in the project directory**:

   ```bash
   mkdir -p .claude
   touch .claude/mcp_settings.json
   ```

2. **Open `.claude/mcp_settings.json` in your text editor**

3. **Add the FMP MCP server configuration**:

```json
{
  "mcpServers": {
    "fmp": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fmp"],
      "env": {}
    }
  }
}
```

**Key configuration details:**
- `"command": "npx"`: Uses npx to run the FMP MCP server package
- `"args": ["-y", "@modelcontextprotocol/server-fmp"]`: Auto-confirms and specifies the server package
- `"env": {}`: Empty object - the MCP server will automatically load `FMP_API_KEY` from the `.env` file in this directory

**If you need to add other MCP servers later**, add them inside the `mcpServers` object:

```json
{
  "mcpServers": {
    "fmp": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-fmp"],
      "env": {}
    },
    "another-server": {
      "command": "...",
      "args": ["..."]
    }
  }
}
```

4. **Save the file**

---

## Step 4: Configure Claude Code to Use Project Settings

When you launch Claude Code in this project directory, it will automatically detect and load `.claude/mcp_settings.json`.

**To verify the configuration is loaded:**
- Claude Code reads MCP settings from `.claude/mcp_settings.json` when present
- This takes precedence over global user-level settings for this project only
- Other projects remain unaffected

---

## Step 5: Verify MCP Server Connection

With project-level configuration, there's no need to restart Claude Desktop. Simply start or restart your Claude Code session in this project.

1. **Navigate to the project directory in your terminal**:
   ```bash
   cd /Library/exploring-claude/content-creator
   ```

2. **Start Claude Code** (if not already running):
   ```bash
   claude code
   ```

3. **Test the connection** by asking Claude to use the FMP MCP:

```
Can you check if the FMP MCP server is available? If so, get the current market cap for Apple (AAPL).
```

**Expected behavior:**
- Claude should confirm FMP MCP is available
- Claude should return Apple's current market capitalization
- You should see data sourced from Financial Modeling Prep

**If the test fails:**
- Check that your `.env` file exists in this directory: `/Library/exploring-claude/content-creator/.env`
- Verify the API key has no quotes or extra spaces in `.env`
- Confirm `.claude/mcp_settings.json` exists and is properly formatted (valid JSON)
- Restart your Claude Code session
- Check terminal/console for error messages

---

## Step 6: Test with Content Creation Workflow

Navigate to your content-creator directory and test the full validation workflow:

```
I'd like to write an article comparing Microsoft and Apple market caps. Can you validate the data using the new workflow?
```

**Expected behavior:**
- Claude parses data requirements
- Uses FMP MCP for market cap data
- Cross-verifies with Yahoo Finance and other sources
- Presents validation summary before writing

---

## Project Structure

After setup, your project should look like this:

```
/Library/exploring-claude/content-creator/
├── .claude/
│   └── mcp_settings.json   # Project-specific MCP configuration
├── .env                    # Your FMP API key (DO NOT COMMIT)
├── .env.example            # Template for others
├── .gitignore              # Excludes .env and .claude/ from version control
├── CLAUDE.md               # Validation workflow instructions
├── FMP-SETUP.md           # This file
├── prompt.md              # Article template
└── article.md             # Generated output
```

---

## Troubleshooting

### Error: "FMP MCP server not found"

**Cause**: MCP configuration file not found or incorrect format

**Solution**:
1. Verify `.claude/mcp_settings.json` exists in the project directory
2. Check that JSON is properly formatted (no trailing commas, proper quotes)
3. Restart your Claude Code session
4. Verify you're running Claude Code from the project directory: `/Library/exploring-claude/content-creator`

### Error: "API key invalid" or "Environment variable not found"

**Cause**: `.env` file not loading or incorrect format

**Solution**:
1. Verify `.env` exists in `/Library/exploring-claude/content-creator/` (same directory as `.claude/`)
2. Check format: `FMP_API_KEY=your_key` (no quotes, no spaces around `=`)
3. Ensure you're running Claude Code from the project directory
4. Log into FMP dashboard and verify your API key
5. Restart your Claude Code session after fixing `.env`

### Error: "Rate limit exceeded"

**Cause**: Exceeded 250 requests/day on free tier

**Solution**:
1. Wait 24 hours for quota reset
2. Upgrade to paid FMP tier ($14-29/month for higher limits)
3. Use fallback web research workflow temporarily

### Error: "Cannot find module @modelcontextprotocol/server-fmp"

**Cause**: NPX unable to download package

**Solution**:
1. Check internet connection
2. Manually install globally: `npm install -g @modelcontextprotocol/server-fmp`
3. Update `.claude/mcp_settings.json` to use global installation:
   ```json
   {
     "mcpServers": {
       "fmp": {
         "command": "mcp-server-fmp",
         "args": [],
         "env": {}
       }
     }
   }
   ```
4. Restart Claude Code session

### Error: "Working directory does not exist"

**Cause**: Running Claude Code from wrong directory

**Solution**:
1. Navigate to the correct project directory:
   ```bash
   cd /Library/exploring-claude/content-creator
   ```
2. Verify you're in the right place:
   ```bash
   ls -la .claude/mcp_settings.json .env
   ```
3. Start Claude Code from this directory:
   ```bash
   claude code
   ```

---

## Available FMP MCP Tools

Once configured, Claude can access:

- **Market Data**: Current and historical stock prices, market caps
- **Financial Ratios**: P/E, P/S, P/B, debt-to-equity, etc.
- **Income Statements**: Revenue, earnings, profit margins
- **Balance Sheets**: Assets, liabilities, equity
- **Cash Flow**: Operating, investing, financing cash flows
- **Company Profiles**: Sector, industry, description, executive info
- **Historical Data**: Multi-year trends for all metrics

---

## Rate Limits & Usage Best Practices

**Free Tier (250 requests/day):**
- Each company query typically uses 1-3 requests
- Average article with 10 companies = 20-30 requests
- Can write 8-12 articles per day comfortably

**Optimization Tips:**
1. Batch related queries together
2. Cache data during validation phase
3. Use web research for private companies (not in FMP)
4. Avoid redundant lookups (save verified data in notes)

**When to Upgrade to Paid Tier:**
- Writing >10 articles daily
- Need real-time (< 1 minute delay) data
- Require extended historical data (>5 years)
- Building automated workflows

---

## Security Best Practices

1. **Never commit `.env` to version control**
   - Already excluded in `.gitignore`
   - If accidentally committed, rotate your API key immediately

2. **DO commit `.claude/mcp_settings.json`**
   - This file contains no secrets (only server configuration)
   - Safe to share with team members
   - Allows consistent setup across different machines

3. **Use `.env.example` for sharing**
   - Template file showing required variables without actual keys
   - Safe to commit to version control

4. **Keep API keys private**
   - Don't share in chat, screenshots, or documentation
   - Rotate keys if exposed

**Project portability:**
- Team members only need to: (1) clone the repo, (2) add their own `.env` file, (3) start Claude Code
- No global configuration changes needed
- Each project can use different MCP servers without conflicts

---

## Fallback Strategy

If FMP MCP is unavailable or rate-limited, the validation workflow automatically falls back to:

1. **3 independent web sources** (same tolerance thresholds)
2. **Priority order**:
   - Yahoo Finance (WebFetch)
   - Google Finance (WebFetch)
   - SEC EDGAR filings (WebSearch)
   - Company investor relations (WebSearch)

This ensures article generation can continue even without API access.

---

## Next Steps

1. ✓ FMP API key obtained
2. ✓ Local `.env` file created with API key
3. ✓ Project-level `.claude/mcp_settings.json` created
4. ✓ Claude Code session started in project directory
5. ✓ Connection verified
6. **Ready to use**: Start writing articles with validated data!

**Benefits of project-level setup:**
- No changes to your global Claude Desktop configuration
- Each project can have different MCP servers
- Easy to share configuration with team members (commit `.claude/mcp_settings.json`)
- Portable across machines - just add `.env` file

Refer to `/Library/exploring-claude/content-creator/CLAUDE.md` for the complete validation workflow integrated into all article generation.
