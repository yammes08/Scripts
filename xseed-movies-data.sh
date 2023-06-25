# Modified version of https://github.com/bakerboy448/StarrScripts/blob/main/xseed.sh
#!/bin/bash

xseed_host="cross-seed"
xseed_port="2468"

# Confirm app and set variables
if [ -n "$radarr_eventtype" ]; then
    app="radarr"
    filePath=${radarr_moviefile_path}
    eventType=${radarr_eventtype}
else
    echo "Unknown Event Type. Failing."
    exit 1
fi
echo "$app detected with event type $eventType"

# Handle Test Event
if [ "$eventType" == "Test" ]; then
    echo "Test passed for $app. FilePath: $filePath"
    exit 0
fi
# Ensure we have a filePath. If we do, search.
if [ -n "$filePath" ]; then
    echo "Search triggered for FilePath $filePath"
    xseed_resp=$(curl --silent --output /dev/null --write-out "%{http_code}" -XPOST http://"$xseed_host":"$xseed_port"/api/webhook --data-urlencode path="$filePath")
    echo ""
else
    echo "FilePath is empty from $app. Skipping cross-seed search."
    exit 0
fi
# Handle Cross Seed Response
if [ "$xseed_resp" == "204" ]; then # 204 = Success per Xseed docs
    echo "Success. cross-seed search triggered by $app for FilePath: $filePath"
    exit 0
else
    echo "cross-seed webhook failed - HTTP Code $xseed_resp from $app for FilePath: $filepath"
    exit 1
fi
