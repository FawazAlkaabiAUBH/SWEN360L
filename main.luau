local net = require("@lune/net")
local envget = require("./lib/env")

local token: string

local ENDPOINT = "https://api.nasa.gov/DONKI/FLR"
--?startDate=YYYY-MM-DD&endDate=YYYY-MM-DD&api_key=TOKEN_HERE

local env = envget.read("./.env")

local function getApiEndpoint(startDate: string, endDate: string)
    return ENDPOINT .. `?startDate={startDate}&endDate={endDate}&api_key={env.NASA_KEY}`
end

-- TODO: parse solar flare data

-- local response = net.request(getApiEndpoint("2024-01-01", "2025-01-01"))
-- if response.ok then
--     print(response.body)
-- end