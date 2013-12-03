--{{{ IMPORTS 
local gears = require("gears")
awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local wibox = require("wibox")
beautiful = require("beautiful")
naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")     
--}}}

-- {{{ Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ USER PREFERENCES ENVIRONMENT
dir = os.getenv("HOME").."/.config/awesome" --DIR DE LA CONF DE AWESOME
beautiful.init(dir.."/themes/default/theme.lua")

naughty.config.defaults.fg = color.CYAN
naughty.config.defaults.border_color = '#006666'

env = {
     interface  = "eth1",
      terminal  = os.getenv("TERMINAL") or "urxvt",
        editor  = os.getenv("EDITOR") or "vim",
       browser  = "firefox",
    wallpapers  = "/store/multimedia/pictures/"

      }

editor_cmd = env.terminal .. " -e " .. env.editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"
altkey = "Mod1"

-- Table of layouts to cover with awful.layout.inc, order matters.

-- {{{ KEYBOARD MULTIMEDIA ACTIONS 
local keyboard_action = {
           raisevol = "amixer set Speaker 2%+",
     raisevolMaster = "amixer set Master 2%+",
           lowervol = "amixer set Speaker 2%-",
     lowervolMaster = "amixer set Master 2%-",
               mute = "amixer set 'Master' toggle",
               next = "mpc next",
               prev = "mpc prev",
               play = "mpc toggle",
               stop = "mpc stop",
               Mail = env.terminal .. " -e mutt"
             --Mail = env.browser .. " http://www.gmail.com"
                 }

--}}}

--{{{ LAYOUTS ------------------------------------------------------
--require("menu") --Menu de Awesome
layouts =
{
     awful.layout.suit.tile,
     awful.layout.suit.tile.left,
     awful.layout.suit.tile.bottom,
     awful.layout.suit.tile.top,
     awful.layout.suit.fair,
     awful.layout.suit.fair.horizontal,
     --awful.layout.suit.spiral,        -- 7
     --awful.layout.suit.spiral.dwindle,-- 8
     awful.layout.suit.max,
     --awful.layout.suit.max.fullscreen,
     awful.layout.suit.magnifier,
     awful.layout.suit.floating
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ AUTORUN APPS INIT

function run_once(prg, args)
  if not prg then
    do return nil end
  end
  if not args then
    args=""
  end
  awful.util.spawn_with_shell('pgrep -f -u $USER -x ' .. prg .. ' || (' .. prg .. ' ' .. args ..')')
end


autorun = false
autorunApps = { "cairo-dock" }

if autorun then
    for app = 1, #autorunApps do
          run_once(autorunApps[app])
    end
end



--}}}

-- {{{ CONFIGS POR TAG -----------------------------------------------
index = 1
labels = { "1:sys", "2:term", "3:vim", "4:dev", "5:hack","6:www","7:im"}
workspace = {}
for d = 1, #labels do -- VISIBILIDAD POR CADA TAG
    workspace[d] = { witop = true, wibottom = true }
end

--}}}

-- {{{ TAGS ----------------------------------------------------------
tags = {}
for s = 1, screen.count() do
    --tags[s] = awful.tag(labels,s, layouts[2])
    tags[s] = awful.tag(labels,s, layouts[9])
end
--}}}

-- {{{ Menu
-- Create a laucher widget and a main menu
require("menu") --Menu de Awesome

--VIM LIKES
awful.menu.menu_keys = { up    = { "k", "Up" },
                         down  = { "j", "Down" },
                         exec  = { "l", "Return", "Right" },
                         enter = { "Right" },
                         back  = { "h", "Left" },
                         close = { "q", "Escape" },
                       }

-- {{{ KEYBOARD ACTIONS 
local keyboard_action = {
           raisevol = "amixer set Speaker 2%+",
     raisevolMaster = "amixer set Master 2%+",
           lowervol = "amixer set Speaker 2%-",
     lowervolMaster = "amixer set Master 2%-",
               mute = "amixer set 'Master' toggle",
               next = "mpc next",
               prev = "mpc prev",
               play = "mpc toggle",
               stop = "mpc stop",
             Mail = env.terminal .. " -e mutt"
             --Mail = env.browser .. " http://www.gmail.com"
                 }

--}}}

-- Menubar configuration
menubar.utils.terminal = env.terminal -- Set the terminal for applications that require it
menubar.geometry = { with = nil, height = nil, x = 18, y = 0}
menubar.show_categories = false
menubar.label = setColor("Run: ", "CYAN")
-- }}}

--{{{ ESCAPE CHARS

function escape(text)
    local xml_entities = {
        ["\""] = "&quot;",
        ["&"]  = "&amp;",
        ["'"]  = "&apos;",
        ["<"]  = "&lt;",
        [">"]  = "&gt;"
    }
return text and text:gsub("[\"&'<>]", xml_entities)
end
--}}}

--{{{HIDDEN TAGS TO SHOW PROMPT
function taghidde(t, bool)
     for s = 1, screen.count() do
         for i, t in ipairs(tags[s]) do
           awful.tag.setproperty(t, "hide", bool)
          end
     end
end
--}}}

--{{{

function naughty_error(text)
     if text then
         naughty.notify({ text = text, timeout = 3, 
                          fg = "#FF0000", --RED
                          border_color = "#610101", 
                          position = "top_right" })
     end
end

--}}}

--{{{ NOTIFY VOLUME LEVEL 
-- msg es para no mostrar mas de una notificacion
function getVolumenLevel()
     if msg ~= nil then
          naughty.destroy(msg)
          naughty.destroy(coverart_nf)
     end
     local f = io.popen(dir..'/bash/w4rlockVolumen.sh')
     local pcm = setColor("PCM: ") ..setColor(f:read(),"YELLOW").."\n"
     pcm = pcm .. setColor("MST: ")..setColor(f:read(),"YELLOW")
     
     msg = naughty.notify({ text=pcm, timeout=1, border_color = "#006666",
                            icon=dir.."/images/emblem-sound2.png"
                          })
end
--}}}

-- {{{ TIMERS (UPDATE WIDGETS) 
timers = {}
timers["cpu"] = timer({ timeout = 2 })
timers["cpu"]:connect_signal("timeout", function()
                         update_temp()
                         end)
timers["mpd"] = timer({ timeout = 2})
timers["mpd"]:connect_signal("timeout", function() now_playing_update() end)

timers["mpd"]:start()
timers["cpu"]:start()

-- {{{ Wibox

--{{{ MEM 

mem = wibox.widget.textbox()
vicious.register(mem,vicious.widgets.mem, setColor("MEM:")..setColor("$1% $2MB","DARKCYAN"),2)

--}}}

--{{{ TEMP CPU 
tempwidget = wibox.widget.textbox()
function update_temp()
     local inf = io.popen(dir.."/bash/w4rlockInfo.sh -t")
     temp_core = inf:read()

     if temp_core ~= "" then 
          tempwidget:set_markup(setColor('TEM: ') .. setColor(temp_core,"DARKCYAN"))
     end
     inf:close()
end
--}}}

--{{{ MPD AUDIO 
local coverart_nf
now_playing = ""
mpdwidget = wibox.widget.textbox()
function now_playing_update()
     local inf = io.popen(dir.."/bash/w4rlockInfo.sh -m")
     now_playing = inf:read()

     if now_playing ~= " - " then 
        if now_playing:len() > 57 then
           now_playing = now_playing:sub(1,57).."..."
        end
        mpdwidget:set_markup(setColor(" "..escape(now_playing)))
     else
        now_playing = ""
        mpdwidget:set_markup(setColor(" MPD:")..setColor(" -- ","DARKCYAN"))
     end
     inf:close()
end
mpdwidget:buttons(awful.util.table.join(
awful.button({ }, 1, function () 
                        awful.util.spawn_with_shell(keyboard_action.prev) 
                        now_playing_update()
                        coverart_show()
                     end),
    awful.button({ }, 3, function () 
                          awful.util.spawn_with_shell(keyboard_action.next) 
                          now_playing_update()
                          coverart_show()
                        end)))

mpdwidget:connect_signal("mouse::enter", function() coverart_show() end)
mpdwidget:connect_signal("mouse::leave", function() notify_destroy(msg) end)

-- }}}

--{{{ NOTIFY SHOW MPD 
function coverart_show()
    notify_destroy(msg)
    --naughty.destroy(msg)
    if now_playing ~= "" then
         local img = awful.util.pread(dir.."/bash/w4rlockCoverart.sh")
         local ico = img

         -- Leo la info
         local musicSH = io.popen(dir.."/bash/w4rlockMusicinfo.sh")

         -- Quito caracteres especiales
         local txt = setColor("Title:  ") .. setColor(escape(musicSH:read()),"YELLOW") .. "\n"
                  .. setColor("Artist: ") .. setColor(escape(musicSH:read()),"YELLOW") .. "\n"
                  .. setColor("Album:  ") .. setColor(escape(musicSH:read()),"YELLOW") .. "\n"
                  .. setColor("Genre:  ") .. setColor(escape(musicSH:read()),"YELLOW") .. "\n"
                  .. setColor("Year:   ") .. setColor(escape(musicSH:read()),"YELLOW") 
                   --.. setColor("Time:   ") .. setColor(escape(musicSH:read()),"YELLOW")
         musicSH:close()
         -- Muestro la notificacion
         -- Para que la notificacion no moleste cuando escribimos en la shell
         local pos
         if mywibox_bottom[mouse.screen].visible then
              --SI SE CAMBIO DE POSICION EL WIBOX QUE CONTIENE EL WIDGET DEL MPD LO SIGO
              pos = awful.wibox.get_position(mywibox_bottom[mouse.screen]).."_left"
         else
              pos = "top_right"
         end

         --coverart_nf = naughty.notify({
         msg  = naughty.notify({
                       icon = ico, 
                       icon_size = 61, 
                       timeout = 3,
                       text = txt, 
                       border_color = "#006666",
                       position = pos
                       })
     end
end
-- }}}

-- {{{ NOTIFY DESTROY 
function notify_destroy(notificacion)
    if notificacion ~= nil then
        naughty.destroy(notificacion)
    end
end
-- }}}
--{{{ SEPARATOR 

spacer = wibox.widget.textbox()
spacer:set_markup(setColor(" :: ","MAGENTA"))

--}}}

--{{{ WIBOX_HIDE 
function wibox_hide()
    mywibox[mouse.screen].visible = workspace[index].witop
    mywibox_bottom[mouse.screen].visible = workspace[index].wibottom
end
--}}}

--{{{ CLOCK - DATE 

require("calendar")     
datewidget = wibox.widget.textbox()
--vicious.register(datewidget, vicious.widgets.date, setColor("%X ","YELLOW"), 2)
vicious.register(datewidget, vicious.widgets.date, setColor("%X ","YELLOW"), 2)
--http://www.lua.org/pil/22.1.html

datewidget:connect_signal("mouse::enter", function() show_calendar(7) end)
datewidget:connect_signal("mouse::leave", remove_calendar)
 
--datewidget:buttons(awful.util.table.join(
   --awful.button({ }, 1, function() add_calendar(-1) end),
   --awful.button({ }, 3, function() add_calendar(1) end)
--))
--}}}

-- {{{ PLAY SOUND BACKGROUND
function play_sound(path)
     awful.util.spawn_with_shell("mplayer -quiet " .. path .. " > /dev/null 2>&1")
end
-- }}}

--{{{ NOTIFY BATTERY NOTEBOOK 
function battery_low()
     naughty_error("Danger battery low")
     play_sound(dir.."/sounds/battery_low.mp3")
end
--}}}

--{{{ BATTERY NOTEBOOK 

batwidget = wibox.widget.textbox()
--vicious.register(batwidget, vicious.widgets.bat, setColor("BAT: ")..setColor("$1$2% $3","DARKCYAN"), 61, "BAT0")
vicious.register(batwidget, vicious.widgets.bat, 
function (widget, args)
     if (args[1] == '-' and args[2] == 20 or args[2] == 15) then
          battery_low()
     end
     return setColor('BAT: ')..setColor(args[1]..args[2]..' '..args[3],"DARKCYAN")
end
, 61, "BAT0")

--}}}



-- Create a wibox for each screen and add it
mywibox = {}
mywibox_bottom = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    mywibox_bottom[s] = awful.wibox({ position = "bottom", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    right_layout:add(batwidget)
    right_layout:add(spacer)
    right_layout:add(tempwidget)
    right_layout:add(spacer)
    right_layout:add(mem)
    right_layout:add(spacer)
    right_layout:add(mpdwidget)
    right_layout:add(spacer)
    right_layout:add(datewidget)
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout_bottom = wibox.layout.align.horizontal()
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)

    layout_bottom:set_middle(mytasklist[s])

    mywibox[s]:set_widget(layout)
    mywibox_bottom[s]:set_widget(layout_bottom)
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 1, function () awful.util.spawn_with_shell('setWallpaper.sh -r ' .. env.wallpapers) end),
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
  --{{{ KEYBOARD MULTIMEDIA
    awful.key({}, "XF86AudioMute", function() awful.util.spawn_with_shell(keyboard_action.mute) end),
    awful.key({}, "XF86AudioRaiseVolume",
      function() --++++++++++++++++++++++++++++++++++++++++++++++++ PCM UP
        awful.util.spawn_with_shell(keyboard_action.raisevol)
        awful.util.spawn_with_shell(keyboard_action.raisevolMaster)
        getVolumenLevel()
      end),
    awful.key({}, "XF86AudioLowerVolume",
      function() --++++++++++++++++++++++++++++++++++++++++++++++++ PCM DOWN
        awful.util.spawn_with_shell(keyboard_action.lowervol) 
        awful.util.spawn_with_shell(keyboard_action.lowervolMaster)
        getVolumenLevel()
      end),
    awful.key({}, "XF86AudioNext",
      function() --++++++++++++++++++++++++++++++++++++++++++++++++ NEXT SONG 
        awful.util.spawn_with_shell(keyboard_action.next) 
        now_playing_update()
        coverart_show() 
      end),
    awful.key({}, "XF86AudioPrev",
      function()--+++++++++++++++++++++++++++++++++++++++++++++++++ PREVIOUS SONG
        awful.util.spawn_with_shell(keyboard_action.prev)
        now_playing_update()
        coverart_show() 
      end),
    awful.key({}, "XF86AudioPause", function() awful.util.spawn_with_shell(keyboard_action.pause) end ),
    awful.key({}, "XF86AudioStop", function() awful.util.spawn_with_shell(keyboard_action.stop) end ),
    awful.key({}, "XF86AudioPlay", function() awful.util.spawn_with_shell(keyboard_action.play) end ),
    awful.key({}, "XF86Mail", function() awful.util.spawn_with_shell(keyboard_action.Mail) end ),
--}}}

    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    awful.key({ modkey,           }, "b", function () 
                                              workspace[index].witop = not mywibox[mouse.screen].visible
                                              mywibox[mouse.screen].visible = not mywibox[mouse.screen].visible 
                                            end),
    --awful.key({ modkey, "Control" }, "Space", function () 
                                                      --mytasklist[1].visible = not mytasklist[1].visible end),
    awful.key({ modkey,           }, "v", function ()   
                                              workspace[index].wibottom = not mywibox_bottom[mouse.screen].visible
                                              mywibox_bottom[mouse.screen].visible = not mywibox_bottom[mouse.screen].visible 
                                              notify_destroy(coverart_nf)
                                            end),
    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey, "Control" }, "t",      function () awful.util.spawn("thunar")  end),
    awful.key({ modkey, "Control" }, "c",      function () awful.util.spawn("chromium")  
                                               end),
    awful.key({ modkey, "Control" }, "f",      function () awful.util.spawn("firefox") end),
    awful.key({ modkey, "Control" }, "m",      function () 
                                                           if now_playing ~= "" then 
                                                                 coverart_show()           
                                                           end                         end),
    awful.key({ modkey, "Control" }, "g",      function () awful.util.spawn("gimp")    end),
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(env.terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),
    awful.key({ modkey,           }, "h",      function () awful.tag.incmwfact(0.05)    end),
    awful.key({ modkey,           }, "l",      function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey,  "Shift"  }, "h",      function () awful.tag.incmwfact(0.15)     end),
    awful.key({ modkey,  "Shift"  }, "l",      function () awful.tag.incmwfact(-0.15)    end),
    awful.key({ modkey, "Control" }, "l",      function () awful.tag.incncol(2)          end),
    awful.key({ modkey, "Control" }, "h",      function () awful.tag.incncol(-2)         end),
    awful.key({ modkey,           }, "space",  function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space",  function () awful.layout.inc(layouts, -1) end),
    awful.key({ modkey,           }, "z",      function (c) 
                                                    if awful.client.floating.get(c) then
                                                       awful.client.moveresize(0,0,20,0)   
                                                    end                                 
                                               end),
    awful.key({ modkey, "Shift"   }, "z",      function (c) 
                                                    if awful.client.floating.get(c) then
                                                       awful.client.moveresize(0,0,-20,0)  
                                                    end 
                                               end),
    awful.key({ modkey,           }, "<",      function (c) 
                                                    if awful.client.floating.get(c) then
                                                       awful.client.moveresize(0,0,0,20)   
                                                    end
                                               end),
    awful.key({ modkey, "Shift"   }, "<",      function (c) 
                                                    if awful.client.floating.get(c) then
                                                       awful.client.moveresize(0,0,0,-20)
                                                    end                                 
                                               end),
    awful.key({ modkey, "Shift"   }, "a",      function (c)
                                                    if awful.client.floating.get(c) then
                                                       awful.client.moveresize(0,0,-20,-20)
                                                    end
                                               end),
    awful.key({ modkey,           }, "a",      function (c) 
                                                    if awful.client.floating.get(c) then
                                                       awful.client.moveresize(0,0,20,20)  
                                                    end
                                               end),
    awful.key({ modkey, altkey    }, "h",      function (c) 
                                                    if awful.client.floating.get(c) then
                                                         awful.client.moveresize(-12,0,0,0)  
                                                    end
                                               end),
    awful.key({ modkey, altkey    }, "l",      function (c) 
                                                    if awful.client.floating.get(c) then
                                                         awful.client.moveresize(12,0,0,0)  
                                                    end
                                               end),
    awful.key({ modkey, altkey    }, "j",      function (c) 
                                                    if awful.client.floating.get(c) then
                                                         awful.client.moveresize(0,12,0,0)  
                                                    end
                                               end),
    awful.key({ modkey, altkey    }, "k",      function (c) 
                                                    if awful.client.floating.get(c) then
                                                         awful.client.moveresize(0,-12,0,0)  
                                                    end
                                               end),
    -- Prompt
    --awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),
    --awful.key({ modkey },            "r",     function () 
    --awful.util.spawn_with_shell("dmenu_run -b -i -nf '#04B4AE' -nb '#000000' -sf '#000000' -sb '#00FFFF'") end),
    
    awful.key({ modkey }, "r", function() menubar.show() end),
    awful.key({ modkey }, "p", function() menubar.show() end),
    awful.key({ modkey }, "x",
              function ()
                  taghidde(nil,true)
                  awful.prompt.run({ prompt = setColor("Run Lua cod3: ","CYAN")},
                  mypromptbox[mouse.screen].widget,
                  function(arg)
                    taghidde(nil,false)
                    --awful.util.eval
                    res,val = pcall(loadstring(arg))
                    if not res then
                         naughty_error("Invalid lua code: "..arg)
                    end
                  end,
                  function() --completion_callback
                     taghidde(nil,false) 
                  end,
                  awful.util.getdir("cache") .. "/history_eval",
                  120,       --history_max
                  function() --done_callback
                    taghidde(nil,false)
                  end 
                  )
              end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "t",      function (c) 
                                                    if beautiful.border_focus == '#000000' then
                                                        beautiful.border_focus = '#585858'
                                                    else
                                                        beautiful.border_focus = '#000000'
                                                    end
                                                    c.border_focus = beautiful.border_focus  end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            c.minimized = true
        end),
    awful.key({ modkey,           }, "s",      function (c) c.size_hints_honor = not c.size_hints_honor end),
    awful.key({ modkey, "Shift"   }, "m",      awful.client.floating.toggle                     ),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber))
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                            index = i
                            wibox_hide()
                        end
                        --Oculto la notificacion cuando cambio de tag
                        notify_destroy(coverart_nf)
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "Cairo-dock" },
      properties = { floating = true, 
                     border_width = 0
                   }},
    { rule = { class = "wbar" },
      properties = { floating = true, 
                     border_width = 0
                   }},
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local title = awful.titlebar.widget.titlewidget(c)
        title:buttons(awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                ))

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(title)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", 
    function(c) 
      c.border_color = beautiful.border_focus 
      c.opacity = 0.2
    end)
client.connect_signal("unfocus", 
    function(c) 
      c.border_color = beautiful.border_normal 
      c.opacity = 0.3
    end)

--awful.util.spawn_with_shell("sleep 2 && xsetroot -cursor_name left_ptr")
--wibox_hide()
awful.util.spawn_with_shell("sleep 2 && xrandr --output HDMI1 --primary --mode 1920x1080")
awful.util.spawn_with_shell("sleep 2 && cairo-dock")
-- }}}

-- vim: foldmethod=marker:filetype=lua:expandtab:shiftwidth=5:tabstop=5:softtabstop=5:textwidth=80
