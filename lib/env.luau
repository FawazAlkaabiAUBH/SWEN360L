local fs = require("@lune/fs")

return {
    read = function(path: string?)
        local contents = fs.readFile(path or "./.env")
        local env = {}
        for line in contents:gmatch("[^\r\n]+") do
            local k,v = line:match("^%s*([%w_]+)%s*=%s*(.-)%s*$")
            if k and v then
                env[k] = v
            end
        end
        return env
    end
}