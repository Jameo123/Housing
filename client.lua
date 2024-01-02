function GetDistance(originCoords, objectCoords)
    return #(originCoords - objectCoords)
end

function Draw3DText(x, y, z, text, scale)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
    SetTextScale(1, 0.35)
    SetTextFont(6)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEdge(3, 0, 0, 0, 255)
    SetTextOutline() 
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
end

function OpenRealEstateMenu(houseName, housePrice, houseLocation)
    local elements = {
        {label = 'Purchase ' .. houseName .. '',  value = 'house_purchase'}
    }

    Aspire.UI.Menu.CloseAll()

    Aspire.UI.Menu.Open('default', GetCurrentResourceName(), 'govbuilding',
        {
            title    = "Real Estate",
            align    = 'bottom-right',
            elements = elements
        },

    function(data, menu)
        if data.current.value == 'house_purchase' then
                Aspire.UI.Menu.Open('default', GetCurrentResourceName(), 'house_purchase',
                {
                    title    = "Are you sure you want to purchase for $" .. housePrice .. '',
                    align    = 'bottom-right',
                    elements = {
                        {label = 'No',  value = 'go_back'},
                        {label = 'Yes',  value = 'go_forward'}
                    }
                },
        
                    function(data2, menu2)
                        if data2.current.value == 'go_back' then
                            Aspire.UI.Menu.CloseAll()
                        elseif data2.current.value == 'go_forward' then
                            Aspire.UI.Menu.CloseAll()
                            if houseName == houseNames[1] then
                            Aspire.Notification('You have purchased ' .. houseName .. '')
                            TriggerServerEvent('cr_housing:Purchase', housePrice, houseName, houseLocation)
                            TriggerServerEvent('cr_housing:RecieveHouse', houseNames[1])
                            elseif houseName == houseNames[2] then
                            Aspire.Notification('You have purchased ' .. houseName .. '')
                            TriggerServerEvent('cr_housing:Purchase', housePrice, houseName, houseLocation)
                            TriggerServerEvent('cr_housing:RecieveHouse', houseNames[2])
                            elseif houseName == houseNames[3] then
                            Aspire.Notification('You have purchased ' .. houseName .. '')
                            TriggerServerEvent('cr_housing:Purchase', housePrice, houseName, houseLocation)
                            TriggerServerEvent('cr_housing:RecieveHouse', houseNames[3])
                        end
                    end
                    end, 
        
            function(data2, menu2)
                menu2.close()
            end)
        end
    end, 

    function(data, menu)
        menu.close()
    end)
end

function OpenHouseMenu(houseName, targetfirstName, targetlastName, houseInteriorLocation)
    local elements = {
        {label = 'Invite Players',  value = 'inv_players'}
    }

    Aspire.UI.Menu.CloseAll()

    Aspire.UI.Menu.Open('default', GetCurrentResourceName(), 'govbuilding',
        {
            title    = "" .. houseName .. "",
            align    = 'bottom-right',
            elements = elements
        },

    function(data, menu)
        if data.current.value == 'inv_players' and targetfirstName == nil and targetlastName == nil then
            Aspire.UI.Menu.CloseAll()
            Aspire.Notification('No Players Nearby')
        else
            TriggerServerEvent('cr_housing:getidfromname', houseName, targetfirstName, targetlastName)
                Aspire.UI.Menu.Open('default', GetCurrentResourceName(), 'inv_players',
                {
                    title    = 'Invite Player',
                    align    = 'bottom-right',
                    elements = {
                        {label = '' .. targetfirstName .. '' .. targetlastName .. '', value = 'go_forward'}
                    }
                },
                    function(data2, menu2)
                        if data2.current.value == 'go_back' then
                            Aspire.UI.Menu.CloseAll()
                        elseif data2.current.value == 'go_forward' then
                            Aspire.UI.Menu.CloseAll()
                            SetEntityCoords(targetclient, houseInteriorLocation.x, houseInteriorLocation.y, houseInteriorLocation.z, true, true, false, false)
                    end
                    end, 
        
            function(data2, menu2)
                menu2.close()
            end)
        end
    end, 

    function(data, menu)
        menu.close()
    end)
end

RegisterNetEvent('bomshotsister')
AddEventHandler('bomshotsister', function(ownerid, housename)
        ownerid = ownerid
        houseowner = ownerid
        housename = housename
        houselabel = housename
end)

RegisterNetEvent('cr_housing:getroutingclient')
AddEventHandler('cr_housing:getroutingclient', function(bucket)
    bucket = bucket
    bucketid = bucket
end)

RegisterNetEvent('cr_housing:gethouseidclient')
AddEventHandler('cr_housing:gethouseidclient', function(house)
    house = house
    houseid = house
    houseid = tostring(houseid)
end)

RegisterNetEvent('cr_housing:getplayernameclient')
AddEventHandler('cr_housing:getplayernameclient', function(playerfirstname, playerlastname)
    playerfirstname = playerfirstname
    playerlastname = playerlastname
    firstname = playerfirstname
    lastname = playerlastname
end)

RegisterNetEvent('cr_housing:getidfromnameclient')
AddEventHandler('cr_housing:getidfromnameclient', function(targetID)
    targetID = targetID
    targetclient = targetID
end)

-- Grove Street 1
CreateThread(function()
    while true do
        Wait(0)
        local player = PlayerPedId()
        local playerPos = GetEntityCoords(player)
        if GetDistance(houseLocations[1], playerPos) < 1.0 then
            TriggerServerEvent('cr_housing:GetidfromHouse', houseNames[1])
            TriggerServerEvent('cr_housing:gethouseid', houseNames[1])
            TriggerServerEvent('cr_housing:getrouting')
            TriggerServerEvent('cr_housing:getplayername', houseNames[1])
            Wait(2000)
        elseif GetDistance(houseExitBlip[1], playerPos) < 1.0 then
            TriggerServerEvent('cr_housing:GetidfromHouse', houseNames[1])
            TriggerServerEvent('cr_housing:gethouseid', houseNames[1])
            TriggerServerEvent('cr_housing:getrouting')
            Wait(2000)
        elseif GetDistance(houseOwnerMenuCoords[1], playerPos) < 1.0 then
            TriggerServerEvent('cr_housing:GetidfromHouse', houseNames[1])
            TriggerServerEvent('cr_housing:gethouseid', houseNames[1])
            TriggerServerEvent('cr_housing:getrouting')
            Wait(2000)
        end
    end
    end)
    
    CreateThread(function()
        while true do
            Wait(0)
        local player = PlayerPedId()
        local playerPos = GetEntityCoords(player)
        local playerID = PlayerData.identifier
        local id = tostring(playerID)
        local id2 = tostring(houseowner)
        if GetDistance(houseLocations[1], playerPos) < 1.5 and houseowner == '0' then
            Draw3DText(houseLocations[1].x, houseLocations[1].y, houseLocations[1].z, ' ' .. houseNames[1] .. ' is avaliable for purchase')
            DrawMarker(20, houseLocations[1].x, houseLocations[1].y, houseLocations[1].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 120, 255, 120, 255, false, true, 2, nil, nil, false)
            Draw3DText(houseLocations[1].x, houseLocations[1].y, houseLocations[1].z + 0.09, '~y~[G]~y~', 2)
        elseif GetDistance(houseLocations[1], playerPos) < 1.5 and id == houseowner then
            Draw3DText(houseLocations[1].x, houseLocations[1].y, houseLocations[1].z, ' [G] Enter House')
            DrawMarker(27, houseLocations[1].x, houseLocations[1].y, houseLocations[1].z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 120, 255, 120, 255, false, false, 2, nil, nil, true)
        else
            end
        end
    end)
    
    CreateThread(function()
        while true do
            Wait(0)
        local player = PlayerPedId()
        local playerPos = GetEntityCoords(player)
        local playerID = PlayerData.identifier
        local id = tostring(playerID)
        if GetDistance(houseLocations[1], playerPos) < 1.5 and id == houseowner and IsControlJustReleased(0, 47) and houselabel == houseNames[1] then
            SetEntityCoords(player, houseInteriorLocations[1].x, houseInteriorLocations[1].y, houseInteriorLocations[1].z, false, false, false, true)
            TriggerServerEvent('cr_housing:setroutingtoid', houseID[1])
        elseif GetDistance(houseExitBlip[1], playerPos) < 1.5 and bucketid == houseID[1] then
            DrawMarker(27, houseExitBlip[1].x - 0.1, houseExitBlip[1].y + 0.3, houseExitBlip[1].z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 120, 255, 120, 255, false, false, 2, nil, nil, true)
            Draw3DText(houseExitBlip[1].x - 0.1, houseExitBlip[1].y + 0.3, houseExitBlip[1].z, '[G] Exit House')
         if GetDistance(houseExitBlip[1], playerPos) < 1.5 and IsControlJustReleased(0, 47) and bucketid == houseID[1] then
            SetEntityCoords(player, houseLocations[1].x, houseLocations[1].y, houseLocations[1].z, false, false, false, true) 
            TriggerServerEvent('cr_housing:setroutingtonormal')
         end
    end
    end
    end)
    
    CreateThread(function()
        while true do
            Wait(0)
        local player = PlayerPedId()
        local playerPos = GetEntityCoords(player)
        if GetDistance(houseLocations[1], playerPos) < 1.5 and IsControlJustReleased(0, 47) and houseowner == '0' then
        OpenRealEstateMenu(houseNames[1], housePrices[1], houseLocations[1])
            else     
        end
        end
    end)

    CreateThread(function()
        while true do
            Wait(0)
        local player = PlayerPedId()
        local playerPos = GetEntityCoords(player)
        local playerID = PlayerData.identifier
        local id = tostring(playerID)
        if GetDistance(houseOwnerMenuCoords[1], playerPos) < 1.5 and bucketid == houseID[1] then
            DrawMarker(27, houseOwnerMenuCoords[1].x, houseOwnerMenuCoords[1].y, houseOwnerMenuCoords[1].z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 120, 255, 120, 255, false, false, 2, nil, nil, true)
            Draw3DText(houseOwnerMenuCoords[1].x, houseOwnerMenuCoords[1].y, houseOwnerMenuCoords[1].z, '[G] House Menu')
        if GetDistance(houseOwnerMenuCoords[1], playerPos) < 1.5 and IsControlJustReleased(0, 47) and bucketid == houseID[1] then
            OpenHouseMenu(houseNames[1], firstname)
        end
    end
end
    end)

-- Grove Street 2
CreateThread(function()
    while true do
        Wait(0)
        local player = PlayerPedId()
        local playerPos = GetEntityCoords(player)
        if GetDistance(houseLocations[2], playerPos) < 1.0 then
            TriggerServerEvent('cr_housing:GetidfromHouse', houseNames[2])
            TriggerServerEvent('cr_housing:gethouseid', houseNames[2])
            TriggerServerEvent('cr_housing:getrouting')
            TriggerServerEvent('cr_housing:getplayername', houseNames[2])
            Wait(2000)
        elseif GetDistance(houseExitBlip[2], playerPos) < 1.0 then
            TriggerServerEvent('cr_housing:GetidfromHouse', houseNames[2])
            TriggerServerEvent('cr_housing:gethouseid', houseNames[2])
            TriggerServerEvent('cr_housing:getrouting')
            Wait(2000)
        elseif GetDistance(houseOwnerMenuCoords[2], playerPos) < 1.0 then
            TriggerServerEvent('cr_housing:GetidfromHouse', houseNames[2])
            TriggerServerEvent('cr_housing:gethouseid', houseNames[2])
            TriggerServerEvent('cr_housing:getrouting')
            Wait(2000)
        end
    end
    end)
    
    CreateThread(function()
        while true do
            Wait(0)
        local player = PlayerPedId()
        local playerPos = GetEntityCoords(player)
        local playerID = PlayerData.identifier
        local id = tostring(playerID)
        local id2 = tostring(houseowner)
        if GetDistance(houseLocations[2], playerPos) < 1.5 and houseowner == '0' then
            Draw3DText(houseLocations[2].x, houseLocations[2].y, houseLocations[2].z, ' ' .. houseNames[2] .. ' is avaliable for purchase')
            DrawMarker(20, houseLocations[2].x, houseLocations[2].y, houseLocations[2].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 120, 255, 120, 255, false, true, 2, nil, nil, false)
            Draw3DText(houseLocations[2].x, houseLocations[2].y, houseLocations[2].z + 0.09, '~y~[G]~y~', 2)
        elseif GetDistance(houseLocations[2], playerPos) < 1.5 and id == houseowner then
            Draw3DText(houseLocations[2].x, houseLocations[2].y, houseLocations[2].z, ' [G] Enter House')
            DrawMarker(27, houseLocations[2].x, houseLocations[2].y, houseLocations[2].z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 120, 255, 120, 255, false, false, 2, nil, nil, true)
        else
            end
        end
    end)
    
    CreateThread(function()
        while true do
            Wait(0)
        local player = PlayerPedId()
        local playerPos = GetEntityCoords(player)
        local playerID = PlayerData.identifier
        local id = tostring(playerID)
        if GetDistance(houseLocations[2], playerPos) < 1.5 and id == houseowner and IsControlJustReleased(0, 47) and houselabel == houseNames[2] then
            SetEntityCoords(player, houseInteriorLocations[2].x, houseInteriorLocations[2].y, houseInteriorLocations[2].z, false, false, false, true)
            TriggerServerEvent('cr_housing:setroutingtoid', houseID[2])
        elseif GetDistance(houseExitBlip[2], playerPos) < 1.5 and bucketid == houseID[2] then
            DrawMarker(27, houseExitBlip[2].x - 0.1, houseExitBlip[2].y + 0.3, houseExitBlip[2].z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 120, 255, 120, 255, false, false, 2, nil, nil, true)
            Draw3DText(houseExitBlip[2].x - 0.1, houseExitBlip[2].y + 0.3, houseExitBlip[2].z, '[G] Exit House')
         if GetDistance(houseExitBlip[2], playerPos) < 1.5 and IsControlJustReleased(0, 47) and bucketid == houseID[2] then
            SetEntityCoords(player, houseLocations[2].x, houseLocations[2].y, houseLocations[2].z, false, false, false, true) 
            TriggerServerEvent('cr_housing:setroutingtonormal')
         end
    end
    end
    end)
    
    CreateThread(function()
        while true do
            Wait(0)
        local player = PlayerPedId()
        local playerPos = GetEntityCoords(player)
        if GetDistance(houseLocations[2], playerPos) < 1.5 and IsControlJustReleased(0, 47) and houseowner == '0' then
        OpenRealEstateMenu(houseNames[2], housePrices[2], houseLocations[2])
            else     
        end
        end
    end)

    CreateThread(function()
        while true do
            Wait(0)
        local player = PlayerPedId()
        local playerPos = GetEntityCoords(player)
        local playerID = PlayerData.identifier
        local id = tostring(playerID)
        if GetDistance(houseOwnerMenuCoords[2], playerPos) < 1.5 and houseowner == id and houselabel == houseNames[2] and bucketid == houseID[2] then
            DrawMarker(27, houseOwnerMenuCoords[2].x, houseOwnerMenuCoords[2].y, houseOwnerMenuCoords[2].z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 120, 255, 120, 255, false, false, 2, nil, nil, true)
            Draw3DText(houseOwnerMenuCoords[2].x, houseOwnerMenuCoords[2].y, houseOwnerMenuCoords[2].z, '[G] House Menu')
        if GetDistance(houseOwnerMenuCoords[2], playerPos) < 1.5 and IsControlJustReleased(0, 47) and bucketid == houseID[2] then
            OpenHouseMenu(houseNames[2], firstname)
        end
    end
end
    end)


    -- Grove Street 3
    CreateThread(function()
        while true do
            Wait(0)
            local player = PlayerPedId()
            local playerPos = GetEntityCoords(player)
            if GetDistance(houseLocations[3], playerPos) < 1 then
                TriggerServerEvent('cr_housing:GetidfromHouse', houseNames[3])
                TriggerServerEvent('cr_housing:gethouseid', houseNames[3])
                TriggerServerEvent('cr_housing:getrouting')
                TriggerServerEvent('cr_housing:getplayername', houseNames[3])
                Wait(2000)
            elseif GetDistance(houseExitBlip[3], playerPos) < 1.0 then
                TriggerServerEvent('cr_housing:GetidfromHouse', houseNames[3])
                TriggerServerEvent('cr_housing:gethouseid', houseNames[3])
                TriggerServerEvent('cr_housing:getrouting')
                Wait(2000)
            elseif GetDistance(houseOwnerMenuCoords[3], playerPos) < 1.0 then
                TriggerServerEvent('cr_housing:GetidfromHouse', houseNames[3])
                TriggerServerEvent('cr_housing:gethouseid', houseNames[3])
                TriggerServerEvent('cr_housing:getrouting')
                Wait(2000)
    end
end
        end)
        
        CreateThread(function()
            while true do
                Wait(0)
            local player = PlayerPedId()
            local playerPos = GetEntityCoords(player)
            local playerID = PlayerData.identifier
            local id = tostring(playerID)
            local id2 = tostring(houseowner)
            if GetDistance(houseLocations[3], playerPos) < 1.5 and houseowner == '0' then
                Draw3DText(houseLocations[3].x, houseLocations[3].y, houseLocations[3].z, ' ' .. houseNames[3] .. ' is avaliable for purchase')
                DrawMarker(20, houseLocations[3].x, houseLocations[3].y, houseLocations[3].z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 120, 255, 120, 255, false, true, 2, nil, nil, false)
                Draw3DText(houseLocations[3].x, houseLocations[3].y, houseLocations[3].z + 0.09, '~y~[G]~y~', 2)
            elseif GetDistance(houseLocations[3], playerPos) < 1.5 and id == houseowner then
                Draw3DText(houseLocations[3].x, houseLocations[3].y, houseLocations[3].z, ' [G] Enter House')
                DrawMarker(27, houseLocations[3].x, houseLocations[3].y, houseLocations[3].z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 120, 255, 120, 255, false, false, 2, nil, nil, true)
            else
                end
            end
        end)
        
        CreateThread(function()
            while true do
                Wait(0)
            local player = PlayerPedId()
            local playerPos = GetEntityCoords(player)
            local playerID = PlayerData.identifier
            local id = tostring(playerID)
            if GetDistance(houseLocations[3], playerPos) < 1.5 and id == houseowner and IsControlJustReleased(0, 47) and houselabel == houseNames[3] then
                SetEntityCoords(player, houseInteriorLocations[3].x, houseInteriorLocations[3].y, houseInteriorLocations[3].z, false, false, false, true)
                TriggerServerEvent('cr_housing:setroutingtoid', houseID[3])
            elseif GetDistance(houseExitBlip[3], playerPos) < 1.5 and bucketid == houseID[3] then
                DrawMarker(27, houseExitBlip[3].x - 0.1, houseExitBlip[3].y + 0.3, houseExitBlip[3].z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 120, 255, 120, 255, false, false, 2, nil, nil, true)
                Draw3DText(houseExitBlip[3].x - 0.1, houseExitBlip[3].y + 0.3, houseExitBlip[3].z, '[G] Exit House')
             if GetDistance(houseExitBlip[3], playerPos) < 1.5 and IsControlJustReleased(0, 47) and bucketid == houseID[3] then
                SetEntityCoords(player, houseLocations[3].x, houseLocations[3].y, houseLocations[3].z, false, false, false, true) 
                TriggerServerEvent('cr_housing:setroutingtonormal')
             end
        end
        end
        end)
        
        CreateThread(function()
            while true do
                Wait(0)
            local player = PlayerPedId()
            local playerPos = GetEntityCoords(player)
            if GetDistance(houseLocations[3], playerPos) < 1.5 and IsControlJustReleased(0, 47) and houseowner == '0' then
            OpenRealEstateMenu(houseNames[3], housePrices[3], houseLocations[3])
                else     
            end
            end
        end)

        CreateThread(function()
            while true do
                Wait(0)
            local player = PlayerPedId()
            local playerPos = GetEntityCoords(player)
            local playerID = PlayerData.identifier
            local id = tostring(playerID)
            if GetDistance(houseOwnerMenuCoords[3], playerPos) < 1.5 and bucketid == houseID[3] then
                DrawMarker(27, houseOwnerMenuCoords[3].x, houseOwnerMenuCoords[3].y, houseOwnerMenuCoords[3].z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 120, 255, 120, 255, false, false, 2, nil, nil, true)
                Draw3DText(houseOwnerMenuCoords[3].x, houseOwnerMenuCoords[3].y, houseOwnerMenuCoords[3].z, '[G] House Menu')
            if GetDistance(houseOwnerMenuCoords[3], playerPos) < 1.5 and IsControlJustReleased(0, 47) and bucketid == houseID[3] then
                OpenHouseMenu(houseNames[3], firstname, lastname, houseInteriorLocations[3])
            end
        end
    end
        end)