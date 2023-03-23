name = "Player Dodge"
description = "Dodges players on Cubecraft eggwars (and mabye other gamemodes)"

leave3 = false
show10 = true

client.settings.addBool("Leave at 3 seconds if a player to dodge remains in the game.", "leave3")
client.settings.addBool("Creates a warning message 10 seconds before the game starts.", "show10")


if fs.exist("blocked.txt") == false then
    print("No file for blocked users.")
end

-- Functions

function addplayer(args)
    file = io.open("blocked.txt", "a")
    file:write(args .. "\n")
    io.close(file)
end

function delplayer(args)
    file = io.open("blocked.txt", "r")
    local new = file:read("a")
    print(new)
    io.close(file)
    new = string.gsub(new, args .. "\n", "")
    print(new)
    file = io.open("blocked.txt", "w")
    file:write(new)
    io.close(file)
end

function listplayers()
    file = io.open("blocked.txt", "r")
    print("§3==================\n§a" .. file:read("*a") .. "§3==================")
    io.close(file)
end
function checkdodge(leave, showd, showc)
    local dodge = 0
    file = io.open("blocked.txt", "r")
local dplayers = file:read("*a")
for i, player in pairs(server.players()) do
    if string.find(dplayers, player) == nil then else
        dodge = dodge + 1
        if showd == true then print("§l§7[§cWarning§7]§r §5Player §e§l" .. player .. " §e§5is on dodge list and is in game.") end
    end
if dodge > 0 and leave == true then
    dodge = -1
    client.execute("execute /hub")
end

end
if dodge == 0 and showc == true then
    print("§aYour game have no players to dodge.")
end
end

function onChat(msg, usr, type)
    if msg == "§6§6Server is now §r§6§6§lFULL§r§6§6! Game starting in §r§e§e§r§e§e10§r§e§e seconds§r§6§6!§r" then
        checkdodge(false, show10, false)
    end
    if msg == "§9§9§r§9§9EggWars§r§9§9 is starting in §r§e§e§r§e§e3§r§e§e seconds§r§9§9.§r" then
        if leave3 == false then
            checkdodge(false)
        elseif leave3 == true then
            checkdodge(true)
        end
    end
    file = io.open("chat.txt", "a")
    file:write(msg .. "\n")
    io.close(file)
end


registerCommand("addplayer", addplayer)
registerCommand("delplayer", delplayer)
registerCommand("listplayers", listplayers)
event.listen("KeyboardInput", function(key, down)
    if down == true then
        if key == 56 then
            checkdodge()
        end
    end
end)
event.listen("ChatMessageAdded", function(message, username, type, xuid)
    onChat(message, username, type)
end)
