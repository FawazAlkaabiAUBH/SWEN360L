local net = require("@lune/net")
local serde = require("@lune/serde")
local stdio = require("@lune/stdio")
local envget = require("./lib/env")


local ENDPOINT = "https://api.nasa.gov/DONKI/FLR"
--?startDate=YYYY-MM-DD&endDate=YYYY-MM-DD&api_key=TOKEN_HERE

local DATE_PATTERN = "(%d%d%d%d%-%d%d%-%d%d)"

local env = envget.read("./.env")

local token: string = env.NASA_KEY

local function getApiEndpoint(startDate: string, endDate: string)
    return ENDPOINT .. `?startDate={startDate}&endDate={endDate}&api_key={token}`
end

-- TODO: parse solar flare data

local flareData

print("Date format: YYYY-MM-DD")
local startDate, endDate = stdio.prompt("text", "Date Start"), stdio.prompt("text", "Date End")

startDate = startDate:match(DATE_PATTERN)
endDate = endDate:match(DATE_PATTERN)

if not endDate or #endDate == 0 then
    endDate = os.date("%Y-%m-%d")
end

if not startDate then
    error("Start Date is invalid.")
end

print("Getting solar flare data...")

local response = net.request(getApiEndpoint(startDate, endDate))
if response.ok then
    flareData = serde.decode("json", response.body)
else
    error(`Response failed. HTTP {response.statusCode}. {response.statusMessage}`)
end

print(`Solar flares detected: {#flareData}`)

while true do
    local idx: number? = tonumber(stdio.prompt("text", "Select Solar flare"))
    local data = flareData[idx]
    if idx and data then
        print(flareData[idx])
    else
        print("Invalid number. Exiting.")
        break
    end
end
