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
    instruments: { Instrument },
    link: string,
    linkedEvents: { LinkedEvent },
    note: string,
    peakTime: string,
    sourceLocation: string,
    submissionTime: string,
    versionId: number,
}

function module.parse(event: FlareEvent)

end


return module