local module = {}

export type Instrument = {
    displayName: string,
}

export type LinkedEvent = {
    activityID: string,
}

export type FlareEvent = {
    activeRegionNum: number,
    beginTime: string, -- ISO 8601 format: "YYYY-MM-DDTHH:MMZ"
    catalog: string,
    classType: string,
    endTime: string,
    flrID: string,
    instruments: { Instrument }?,
    link: string,
    linkedEvents: { LinkedEvent }?,
    note: string,
    peakTime: string,
    sourceLocation: string,
    submissionTime: string,
    versionId: number,
}

--[=[ Example Data:
{
    activeRegionNum = 14207,
    beginTime = "2025-09-04T10:48Z",
    catalog = "M2M_CATALOG",
    classType = "C2.8",
    endTime = "2025-09-04T10:59Z",
    flrID = "2025-09-04T10:48:00-FLR-001",
    instruments = {
        {
            displayName = "GOES-P: EXIS 1.0-8.0",
        },
    },
    link = "https://webtools.ccmc.gsfc.nasa.gov/DONKI/view/FLR/41045/-1",
    linkedEvents = {
        {
            activityID = "2025-09-04T13:09:00-CME-001",
        },
    },
    note = "",
    peakTime = "2025-09-04T10:55Z",
    sourceLocation = "N30E18",
    submissionTime = "2025-09-05T00:06Z",
    versionId = 1,
}
]=]

local function formatDate(isoDate: string): string
    local year, month, day, hour, min = string.match(isoDate, "(%d%d%d%d)%-(%d%d)%-(%d%d)T(%d%d):(%d%d)Z")

    local monthNames = {
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"
    }

    if year and month and day and hour and min then
        local monthName = monthNames[tonumber(month)::number]
        return string.format("%s %d, %s at %s:%s UTC", monthName, tonumber(day)::number, year, hour, min)
    else
        return "Invalid date format"
    end
end

function module.parse(flareEvent: FlareEvent): string
    local text = ""

    text ..= `Flare ID: {flareEvent.flrID}, Class: {flareEvent.classType}\n`
    text ..= `Source: {flareEvent.sourceLocation}, Catalog {flareEvent.catalog}\n`
    text ..= `Start: {formatDate(flareEvent.beginTime)}, End: {formatDate(flareEvent.endTime)}\n`
    text ..= `Peak: {formatDate(flareEvent.peakTime)}, Observed: {formatDate(flareEvent.submissionTime)}\n`
    if flareEvent.instruments then
        text ..= `Instruments: {#flareEvent.instruments}\n`
        for index, instrument in flareEvent.instruments do
            text ..= "\t" .. instrument.displayName .. "\n"
        end
    end
    if flareEvent.linkedEvents then
        text ..= `Linked Events: {#flareEvent.linkedEvents}\n`
        for index, event in flareEvent.linkedEvents do
            text ..= "\t" .. event.activityID .. "\n"
        end
    end
    text ..= `{if flareEvent.note then "Note: " .. flareEvent.note .. "\n" else ""}`

    return text
end


return module