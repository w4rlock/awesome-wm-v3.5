require("imap")

imap_user = "warlock.gpl"
imap_pass = "0000000000000000000"

o_imap = imap.new("imap.gmail.com", 993, "sslv3", "Inbox", 5)
_, o_imap.errmsg = o_imap:connect()
spanClose   = "</span>"
spanValue   = "<span foreground='#04B4AE'>"

-- Login using username and passowrd
_, o_imap.errmsg = o_imap:login(imap_user, imap_pass)
w_imap = widget({ type = "textbox", align = "right" })
local nuevos=0

function getMsg() 
	local messages = {}
	local content = ""
	-- The fetch function takes 3 optional arguments: fetch_recent (default:
	-- true), fetch_unread (default: false) and fetch_all (default: false).
	local res, msg = o_imap:fetch(false,true)

	if res then
	   -- On success fetch() returns a table with information on the messages
	   -- that matched the search criteria (unread/recent/total). A message
	   -- information is represented as a table with the keys size, from and
	   -- subject that contain the message's size, from and subject header.
	   --
	   -- ! Please not that imap.lua does not (yet?) decode encoded from or
	   -- ! subject headers.
	   local k,v
	   for k,v in pairs(msg) do
		  table.insert(messages, v.from .. " " .. v.subject)
	   end
	   
	   -- Now assemble the content to be displayed by the popup. Couldn't think
	   -- of a better way to avoid a newline at the last line: So each line ist
	   -- stored in a table that es afterwards joined to a string.
	   local i
	   for i = 1, #messages do
		  content = content .. messages[i]
	   if i < #messages then content = content .. "\n" end
	end
	   
	if #messages == 0 then content = "\t--Empty--" end
		--{ title = "<span color='green'>" .. o_imap.server .. ":" .. o_imap.port .. "</span>",
	   content = awful.util.escape(content)
	   o_imap.popup = naughty.notify({ text = content,
									   timeout = 0,
									   screen = mouse.screen,
									   position  = "top_right", width = 500 })
	else
	   o_imap.errmsg = msg
	end
end

--[[
   [awful.button({ }, 2, function () 
   [if o_imap.logged_in then
   [   o_imap:logout()
   [   w_imap.text = " -"
   [else
   [   o_imap:connect()
   [   o_imap:login(imap_user, imap_pass)
   [   w_imap.text = "?"
   [end
   [end)
   ]]

function avisoNewMsg()
local txt = "Ha recibido un nuevo msg."
naughty.notify({ text = txt, timeout = 0, screen = mouse.screen, position  = "top_right",
				 border_color = "#006666",
				 fg = "#00FFFF",
				 run = function() awful.util.spawn("urxvt -e mutt") 
				 end
				})
end

timerA = timer({ timeout = 50 })
timerA:add_signal("timeout", function()
  if o_imap.logged_in then
	 local res, msg = o_imap:check()
	 o_imap.errmsg = msg
	 if res then
		--w_imap.text = res.total .. ":" .. res.unread .. ":" .. res.recent
		w_imap.text = spanValue .. res.unread ..' '.. spanClose
		if res.unread > nuevos and nuevos ~= 0 then
			avisoNewMsg()
		end
		nuevos=res.unread
	 --else
		--w_imap.text = " -"
	 end
  --else
	 --if o_imap.errmsg then
		--w_imap.text = "E"
	 --end
end --End of function
end)
timerA:start()
-- The check() function returns a table with the number of unread, recent and total messages in the mailbox.
-- In addition the imap library provides three separate functions that return the number of total, 
-- unread and recent messages: o_imap:recent(), o_imap:unread() and o_imap:total().
