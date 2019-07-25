
--Black popup in center of the screen
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
--     hs.alert.show("Hello World!")
--   end)


-- Standard IOS notification popup top right
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
--     hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
--   end)


-- Moves selected window 100 pixels to the right
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "H", function()
--     local win = hs.window.focusedWindow()
--     local f = win:frame()
--     f.x = f.x + 100
--     win:setFrame(f)
--   end)

-------------------------For display of the wifi ssid on the top bar------------------------------------
wifiWatcher = nil
function ssidChanged()
    local wifiName = hs.wifi.currentNetwork()
    if wifiName then
        wifiMenu:setTitle(wifiName)
    else
        wifiMenu:setTitle("Wifi OFF")
    end
end

wifiMenu = hs.menubar.newWithPriority(2147483645)
ssidChanged()
wifiWatcher = hs.wifi.watcher.new(ssidChanged):start()
-------------------------------------------------------------------------------------------------------

-- Displays a circle on the screen for pointing things out
mouseCircle = nil
mouseCircleTimer = nil
function mouseHighlight()
    -- Delete an existing highlight if it exists
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    -- Get the current co-ordinates of the mouse pointer
    mousepoint = hs.mouse.getAbsolutePosition()
    -- Prepare a big red circle around the mouse pointer
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircle:setStrokeColor({["red"]=0,["blue"]=1,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show()

    -- Set a timer to delete the circle after 3 seconds
    mouseCircleTimer = hs.timer.doAfter(3, function() mouseCircle:delete() end)
end
hs.hotkey.bind({"cmd","alt","shift"}, "D", mouseHighlight)

--attempting to send a text messsage to myself
hs.hotkey.bind({"cmd","alt","shift"}, "T", function()

end)

--These detect changes in the wifi?????????????
-- wifiWatcher = hs.wifi.watcher.new(ssidChanged)
-- wifiWatcher:start()

-- Lua spoons for running update portal and commandprocessor for cp and front end changes
-- keycode enterer
function updater(updateString)
    updateString:gsub(".", function(c)
        secondKey = false
        if c == ' ' then
            c = "space"
        elseif c == '&' then
            secondKey = true
            c = "7"
        end
        if secondKey then
            hs.eventtap.event.newKeyEvent("shift", true):post()
        end
        hs.eventtap.event.newKeyEvent(c, true):post()
        hs.eventtap.event.newKeyEvent(c, false):post()
        if secondKey then
            hs.eventtap.event.newKeyEvent("shift", false):post()
        end
    end)
    hs.eventtap.event.newKeyEvent("return", true):post()
    hs.eventtap.event.newKeyEvent("return", false):post()
end
-- install both the frontend and backend
hs.hotkey.bind({"cmd","alt","shift"}, "M", function()
    updateString = "sudo apt-get update && sudo apt-get install -y webscale-portal && sudo apt-get install lgcommandprocessor"
    print('updating, and installing portal and control')
    updater(updateString)
end)
-- only install the frontend
hs.hotkey.bind({"cmd","alt","shift"}, "P", function()
    updateString = "sudo apt-get update && sudo apt-get install -y webscale-portal"
    print('updating, and installing portal')
    updater(updateString)
end)
-- only install the backend
hs.hotkey.bind({"cmd","alt","shift"}, "L", function()
    updateString = "sudo apt-get update && sudo apt-get install lgcommandprocessor"
    print('updating, and installing control')
    updater(updateString)
end)

-- a spoon process that recognizes when you hiss sssssssssss and then does stuff
local popclick = require "hs.noises"
listener = nil
popclickListening = false

function noise1()
    print('I can hear you sound 1')
end

function noise2()
    print('I can hear you sound 2')
end

function noise3()
    print('I can hear you sound 3')
end


hs.hotkey.bind({"cmd","alt","shift"}, "B", function()
    if not popclickListening then
        listener:start()
        hs.alert.show("listening")
    else
        listener:stop()
        hs.alert.show("stopped listening")
    end
    popclickListening = not popclickListening
end)

function popclickInit()
    popclickListening = false
    listener = popclick.new(function(soundType)
        if soundType == 1 then
            noise1()
        elseif soundType == 2 then
            noise2()
        elseif soundType == 3 then
            noise3()
        end
    end)
end

popclickInit()