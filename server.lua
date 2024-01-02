GlobalState.Showgrove1 = true
GlobalState.Showgrove2 = true
GlobalState.Grove1Owner = nil
GlobalState.Grove2Owner = nil
GlobalState.housename = nil

RegisterNetEvent('cr_housing:Purchase')
AddEventHandler('cr_housing:Purchase', function(housePrice, houseName, houseLocation)
    xPlayer = Aspire.GetCharacterFromId(source)
    local xInventory = xPlayer.inventory
    local playerMoney = xPlayer.getAccount('bank').money
    if playerMoney >= housePrice then
        xPlayer.removeAccountMoney('bank', housePrice)
        Aspire.Log("realestate", '' .. " Purchased " .. houseName .. " for $" .. housePrice .. ' at ' .. houseLocation .. '', "", "purple", { xPlayer })
    else
        xPlayer.Notification('You do not have enough money to make that purchase')
end
end)

--RegisterNetEvent('cr_housing:RecieveHouse')
--AddEventHandler('cr_housing:RecieveHouse', function(houseName, player, housePrice)
  --  MySQL.Async.insert('INSERT INTO `houses` (`housenames`, `ownerid`, `houseprices`) VALUES (@housename, @ownerid, @houseprice)', {
    --    ['@housename'] = houseName,
      --  ['@ownerid'] = player,
      --  ['@houseprice'] = housePrice
   -- })
--end)

RegisterNetEvent('cr_housing:RecieveHouse')
AddEventHandler('cr_housing:RecieveHouse', function(houseName)
    local xPlayer = Aspire.GetCharacterFromId(source)
    MySQL.Async.execute('UPDATE houses SET ownerid = @id WHERE housenames = @housename', {
        ['@id'] = xPlayer.identifier,
        ['@housename'] = houseName
    }, function()
    end)
end)

RegisterNetEvent('cr_housing:gethouseid')
AddEventHandler('cr_housing:gethouseid', function(houseName)
    local src = source
    MySQL.Async.fetchAll('SELECT houseid FROM houses WHERE housenames = @housename', {
        ['@housename'] = houseName
    }, function(result)
        house = result[1].houseid
        TriggerClientEvent('cr_housing:gethouseidclient', src, house)
    end)
end)

RegisterNetEvent('cr_housing:GetidfromHouse')
AddEventHandler('cr_housing:GetidfromHouse', function(houseName)
    local src = source
    local xPlayer = Aspire.GetCharacterFromId(source)
    MySQL.Async.fetchAll('SELECT ownerid, housenames FROM houses WHERE housenames = @housename', {
        ['@housename'] = houseName
    }, function(result)
        ownerid = result[1].ownerid
        housename = result[1].housenames
        TriggerClientEvent('bomshotsister', src, ownerid, housename)
    end)
end)

RegisterNetEvent('cr_housing:IsInHouse')
AddEventHandler('cr_housing:IsInHouse', function(houseName)
    local src = source 
    local xPlayer = Aspire.GetCharacterFromId(source)
    MySQL.Async.fetchAll('SELECT ownerid, inhouse FROM houses WHERE housenames = @housename', {
        ['@housename'] = houseName
    }, function(result)
        identifier = result[1].ownerid
        inhouse = result[1].inhouse
        TriggerClientEvent('IsInHouseClient', src,  identifier, inhouse)
    end)
end)

RegisterNetEvent('cr_housing:enterHouse')
AddEventHandler('cr_housing:enterHouse', function(houseName)
    local xPlayer = Aspire.GetCharacterFromId(source)
    MySQL.Async.execute('UPDATE houses SET inhouse = @inhouse WHERE housenames = @housename', {
        ['@inhouse'] = true,
        ['@housename'] = houseName
    }, function()
    end)
end)

RegisterNetEvent('cr_housing:updateroomnumber')
AddEventHandler('cr_housing:updateroomnumber', function(player, houseName)
    MySQL.Async.execute('UPDATE houses SET roomnumber = @inhouse WHERE housenames = @housename', {
        ['@roomnumber'] = player,
        ['@housename'] = houseName
    }, function()
    end)
end)

RegisterNetEvent('cr_housing:exitHouse')
AddEventHandler('cr_housing:exitHouse', function(houseName)
    local xPlayer = Aspire.GetCharacterFromId(source)
    MySQL.Async.execute('UPDATE houses SET inhouse = @inhouse WHERE housenames = @housename', {
        ['@inhouse'] = false,
        ['@housename'] = houseName
    }, function()
    end)
end)

RegisterNetEvent('cr_housing:setroutingtonormal')
AddEventHandler('cr_housing:setroutingtonormal', function()
    local player = Aspire.GetCharacterFromId(source).identifier
    local bucket = SetPlayerRoutingBucket(source, 0)
end)

RegisterNetEvent('cr_housing:getrouting')
AddEventHandler('cr_housing:getrouting', function()
    local src = source
    local player = Aspire.GetCharacterFromId(source).identifier
    bucket = GetPlayerRoutingBucket(source)
    TriggerClientEvent('cr_housing:getroutingclient', src, bucket)
end)


RegisterNetEvent('cr_housing:setroutingtoid')
AddEventHandler('cr_housing:setroutingtoid', function(houseId)
    src = source
    player = Aspire.GetCharacterFromId(source).identifier
    SetPlayerRoutingBucket(src, houseId)
end)

RegisterNetEvent('cr_housing:getplayername')
AddEventHandler('cr_housing:getplayername', function(houseName)
    src = source
    MySQL.Async.fetchAll('SELECT ownerid FROM houses WHERE housenames = @housename', {
        ['@housename'] = houseName
    }, function(result)
        ownerID = result[1].ownerid
    end)
    MySQL.Async.fetchAll('SELECT firstname, lastname FROM characters WHERE accountid = @id', {
        ['@id'] = Aspire.GetCharacterFromId(source).identifier
    }, function(result)
        playerfirstname = result[1].firstname
        playerlastname = result[1].lastname
        TriggerClientEvent('cr_housing:getplayernameclient', ownerID, playerfirstname, playerlastname)
    end)
end)

RegisterNetEvent('cr_housing:getidfromname')
AddEventHandler('cr_housing:getidfromname', function(houseName, firstname, lastname)
    src = source
    xPlayer = Aspire.GetCharacterFromId(targetID)
    MySQL.Async.fetchAll('SELECT ownerid FROM houses WHERE housenames = @housename', {
        ['@housename'] = houseName
    }, function(result)
        ownerID = result[1].ownerid
    end)
    MySQL.Async.fetchAll('SELECT accountid FROM characters WHERE firstname = @firstname AND lastname = @lastname', {
        ['@firstname'] = firstname,
        ['@lastname'] = lastname
    }, function(result)
        targetID = result[1].accountid
        TriggerClientEvent('cr_housing:getidfromnameclient', ownerID, targetID)
    end)
end)