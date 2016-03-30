import net, jester, asyncdispatch, asyncfile, os, strutils, math, json

var splashes: seq[string] = @[]

# Load the splashes
proc loadSplashes() {.async} =
    let file = openAsync(CurDir & "/splash.txt", fmRead)
    let data = await file.readAll()
    for line in splitLines(data):
        splashes.add(line)
    file.close()

settings:
    port = Port(23340)

routes:
    get "/splash":
        let j = %*
            {
                "status": 200,
                "content": random(splashes)
            }
        
        if @"callback" == nil or @"callback" == "":
            resp $j
        else:
            # For jsonp requests
            resp "/**/ typeof " & @"callback" & " === 'function' && " & @"callback" & "(" & $j & ");"
        
waitFor loadSplashes()
runForever()
