# FMP MCP Server Setup Guide

This guide walks you through setting up the Financial Modeling Prep (FMP) MCP server for use with Claude Code to enable accurate, real-time financial data access for article generation.

**This setup uses HTTP transport** - the FMP server runs locally on port 8080 and Claude Code connects to it via HTTP.

---

## Prerequisites

- Claude Code installed on your system
- Node.js and npm installed (check with `node --version` and `npm --version`)
- Internet connection
- A separate terminal window to run the FMP server

---

## Step 1: Obtain FMP API Key

1. **Visit**: https://financialmodelingprep.com/developer/docs/
2. **Sign up** for a free account
3. **Navigate to** your dashboard after registration
4. **Copy your API key** (found under "API Keys" or "Dashboard")
   - Free tier provides: 250 requests/day
   - Sufficient for 10-15 articles per day

---

## Step 2: Create Project-Level MCP Configuration

We use a **project-specific MCP configuration** that connects to a locally running HTTP server.

1. **The `.mcp.json` file should already exist** with this configuration:

   ```json
   {
     "mcpServers": {
       "fmp-mcp": {
         "type": "http",
         "url": "http://localhost:8080/mcp"
       }
     }
   }
   ```

**Key configuration details:**
- `"type": "http"`: Uses HTTP transport to connect to the server
- `"url"`: Points to the locally running FMP server
- No API key in this file - it's passed when starting the server

---

## Step 3: Start the FMP MCP Server

**IMPORTANT**: The server must be running before Claude Code can connect to it.

1. **Open a separate terminal window**

2. **Navigate to your project directory**:
   ```bash
   cd /path/to/content-creator
   ```

3. **Update the API key in .env file**:  
   ```
   # FMP (Financial Modeling Prep) API Configuration
   # Get your API key from: https://site.financialmodelingprep.com/developer/docs
   # Replace `your_actual_api_key_here` with your FMP API key.

   FMP_ACCESS_TOKEN=your_actual_api_key_here 
   ```

4. **Start the server with your API key (or see convenience script below)**: 
   ```bash
   FMP_ACCESS_TOKEN=your_actual_api_key_here npx -y financial-modeling-prep-mcp-server
   ```

**Convenience Script (Recommended):**

For easier server management, use the included helper script:

```bash
# Start the server
./start-fmp-server.sh
```

The script will:
- Check if your API key is set
- Detect if port 8080 is already in use
- Start the server with helpful status messages

4. **Verify the server started successfully**. You should see:
   ```
   [McpServer] ✅ Routes configured successfully
   [FmpMcpServer] 🚀 MCP Server started successfully on port 8080
   [FmpMcpServer] 🏥 Health endpoint available at http://localhost:8080/healthcheck
   [FmpMcpServer] 🔌 MCP endpoint available at http://localhost:8080/mcp
   ```

5. **Keep this terminal window open** - the server must stay running while you use Claude Code.

**Optional: Test the server**
```bash
# In another terminal
curl http://localhost:8080/healthcheck
```

---

## Step 4: Launch Claude Code and Verify Connection

1. **With the FMP server running**, launch Claude Code in this project directory:
   ```bash
   claude code
   ```

2. **Test the connection** by asking Claude:
   ```
   Is the FMP MCP server connected? If so, get the current market cap for Apple (AAPL).
   ```

**Expected behavior:**
- Claude should confirm FMP MCP is available
- Claude should return Apple's current market capitalization
- You should see data sourced from Financial Modeling Prep

**If the test fails:**
- **Most common issue**: Server not running - check your terminal window
- Verify the server is running on port 8080 (check the terminal output)
- Confirm `.mcp.json` exists and has the correct HTTP configuration
- Restart your Claude Code session
- Check server logs in the terminal for error messages

---

## Step 5: Test with Content Creation Workflow

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
content-creator/
├── .claude/                # Claude Code session data (gitignored)
├── .env                    # env file with API keys (Not committed by Git Ignore rules)
├── .mcp.json               # HTTP MCP configuration (safe to commit)
├── .mcp.json.example       # Template for others
├── .gitignore              # Git ignore rules
├── CLAUDE.md               # Validation workflow instructions
├── FMP-SETUP.md            # This file
├── start-fmp-server.sh     # Helper script to start FMP server
├── prompt.md               # Article template
└── article.md              # Generated output
```

---

## Troubleshooting

### Error: "Port 8080 already in use"

**Cause**: Another process is using port 8080, or you already have the FMP server running

**Solution**:
1. Check if you already have the server running in another terminal
2. Kill the existing process:
   ```bash
   lsof -ti:8080 | xargs kill
   ```
3. Start the server again

### Error: "Rate limit exceeded"

**Cause**: Exceeded 250 requests/day on free tier

**Solution**:
1. Wait 24 hours for quota reset
2. Upgrade to paid FMP tier ($14-29/month for higher limits)
3. Use fallback web research workflow temporarily

### Error: "Cannot find module financial-modeling-prep-mcp-server"

**Cause**: NPX unable to download package

**Solution**:
1. Check internet connection
2. Clear npm cache: `npm cache clean --force`
3. Try again with npx -y flag (auto-install)
4. Manually install globally: `npm install -g financial-modeling-prep-mcp-server`

### Claude Code doesn't see the HTTP server

**Cause**: Configuration issue or server not running

**Solution**:
1. Verify `.mcp.json` has the correct HTTP configuration:
   ```json
   {
     "mcpServers": {
       "fmp-mcp": {
         "type": "http",
         "url": "http://localhost:8080/mcp"
       }
     }
   }
   ```
2. Test the server manually: `curl http://localhost:8080/healthcheck`
3. Restart Claude Code after verifying the server is running

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

1. **Keep API keys private**
   - Never commit your API key to version control
   - Don't share in chat, screenshots, or documentation
   - The API key is only used when starting the server (via `FMP_ACCESS_TOKEN=`)
   - Rotate keys immediately if exposed at https://financialmodelingprep.com

2. **The `.mcp.json` file is SAFE to commit**
   - It only contains the HTTP endpoint configuration
   - No secrets or API keys are stored in this file
   - Can be shared with team members

3. **Use environment variables for the server**
   - Store your API key in a shell script or environment file
   - Example `.env` file approach:
     ```bash
     # .env (add to .gitignore!)
     export FMP_ACCESS_TOKEN=your_api_key_here
     ```
   - Then source it: `source .env && npx -y financial-modeling-prep-mcp-server`

**Project portability:**
- Team members only need to:
  1. Clone the repo
  2. Get their own FMP API key
  3. Start the server with their API key
  4. Launch Claude Code
- No configuration file changes needed
- The `.mcp.json` file works for everyone

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
