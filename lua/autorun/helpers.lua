function Say(...)

    local first=true
    local msg=""

    for _,val in pairs{...} do
      if first then
           first = false
       else
           msg=msg..' '
       end
       msg=msg..tostring(val)
    end

    msg = msg:gsub("\n",""):gsub(";",":"):gsub("\"","'")

    if SERVER then
        game.ConsoleCommand("say "..msg.."\n")
    elseif chatbox and chatbox.SendChatMessage then
        chatbox.SendChatMessage(msg)
    else
        RunConsoleCommand("say",msg)
    end

end
say = Say
