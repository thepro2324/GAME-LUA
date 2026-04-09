local socket = require("socket")

-- רנדר נותנת לנו פורט במשתנה סביבה, אם לא קיים נשתמש ב-10000
local port = os.getenv("PORT") or 10000
local server = assert(socket.bind("*", port))
server:settimeout(0)

local clients = {}

print("Server started on port: " .. port)

while true do
    -- קבלת חיבורים חדשים
    local client = server:accept()
    if client then
        client:settimeout(0)
        table.insert(clients, client)
        print("New player connected!")
    end

    -- קריאת מידע מכל השחקנים
    for i = #clients, 1, -1 do
        local c = clients[i]
        local data, err = c:receive()
        
        if not err then
            -- שליחת המידע שקיבלנו לכל שאר השחקנים (Broadcast)
            for _, other_client in ipairs(clients) do
                if other_client ~= c then
                    other_client:send(data .. "\n")
                end
            end
        elseif err == "closed" then
            print("Player disconnected")
            table.remove(clients, i)
        end
    end
    
    socket.sleep(0.01) -- שומר על המעבד שלא יקפוץ ל-100%
end
