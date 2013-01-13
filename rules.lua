-- {{{ RULES
awful.rules.rules = {

    --{{{ PROPERTIES 
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     size_hints_honor = false
                   }},
    --}}}

    --{{{ MPLAYER
    --{ rule = { class = "MPlayer" },
      --properties = { 
                     --floating = true,
                     --tag = tags[1][5],
                     --switchtotag = true,
                     --geometry = { x=20, y=40, height=390, width=500 },   
                     --size_hints_honor = false
                   --}},
    --}}}

    --{{{ FIREFOX
    { rule = { class = "Firefox" },
      properties = { tag = tags[1][5],
                     switchtotag = true,
                     --floating = true
                     --skip_taskbar = true
                     border_with = 0
                    }},
    --}}} 
    
    --{{{ FIREFOX DOWNLOAD
    { rule = { class = "Firefox",
               instance = "Download" },
      properties = { tag = tags[1][5],
                     switchtotag = true,
                     floating = true,
                     geometry = { x=20, y=40, height=220, width=420 },   
                     --skip_taskbar = true,
                     border_with = 0
                    }},
    --}}} 

    --{{{ UZBL
    { rule = { instance = "uzbl-tabbed" },
      properties = { tag = tags[1][6],
                     switchtotag = true,
                     --skip_taskbar = true
                     --floating = true
                     border_with = 0
                    }},
    --}}}

    --{{{ CHROMIUM 
    { rule = { instance = "chromium" },
      properties = { tag = tags[1][6],
                     switchtotag = true,
                     --floating = true
                     --skip_taskbar = true
                     border_with = 0
                    }},
    --}}}

    --{{{ MYSQL WORKBENCH
    { rule = { class = "Mysql-workbench-bin" },
      properties = { tag = tags[1][4],
                     switchtotag = true,
                     floating = true
                    }},
    --}}}

    --{{{ ECLIPSE
    { rule = { class = "Eclipse" },
      properties = { tag = tags[1][4],
                     switchtotag = true,
                     floating = true
                    }},
    --}}}
    
    --{{{ TRANSMISSION
    { rule = { class = "Transmission" },
      properties = { tag = tags[1][7],
                     switchtotag = false,
                     floating = true
                    }},
    --}}}
    --{{{ GIMP
    { rule = { class = "gimp" },
      properties = { floating = true }},
      
    { rule = { class = "Galculator" },
      properties = { floating = true }}
    -- Set Firefox to always map on tags number 2 of screen 1.
   --  { rule = { class = "Firefox" },
    --  properties = { tag = tags[1][1] } }
    --}}}
}
-- }}}

--{{{ EXAMPLE 
--{rule = { instance = "Navigator", 
--          class    = "Namoroka", 
--          role     = "browser"
--        },
--properties = { border_with = 1,
--               skip_taskbar= true,
--               tag         = tags[1][6],
--               switchtotag = true,
--               floating    = true,
--               focus       = false,
--               geometry = { 
--                          x=50,
--                          y=120,
--                          height=290,
--                          width=300
--                          }
--               bellow = true,
--               above = false,
--               maximized_vertical = true,
--               maximized_horizontal = false,
--
--             }
--}}}
