local uiFaded = false
local ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	while ESX.GetPlayerData().job2 == nil do
		Citizen.Wait(10)
	end

	local xPlayer = ESX.GetPlayerData()
	local cash, dirtycash, bank = 0, 0, 0

	for i = 1, #xPlayer.accounts, 1 do
		if xPlayer.accounts[i].name == 'cash' then
			cash = ESX.Math.GroupDigits(xPlayer.accounts[i].money)
		elseif xPlayer.accounts[i].name == 'dirtycash' then
			dirtycash = ESX.Math.GroupDigits(xPlayer.accounts[i].money)
		elseif xPlayer.accounts[i].name == 'bank' then
			bank = ESX.Math.GroupDigits(xPlayer.accounts[i].money)
		end
	end
	while not FirstActivate do 
		Wait(2000)
		SendNUIMessage({
			action = 'setInfos',
			infos = {
				{
					name = 'money',
					value = cash
				},
				{
					name = 'black_money',
					value = dirtycash
				},
				{
					name = 'bank',
					value = bank
				},
				{
					name = 'job',
					value = ('%s - <strong>%s</strong>'):format(xPlayer.job.label, xPlayer.job.grade_label)
				},
				{
					name = 'job2',
					value = ('%s - <strong>%s</strong>'):format(xPlayer.job2.label, xPlayer.job2.grade_label)
				}
			}
		})
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	local cash, dirtycash, bank = 0, 0, 0

	for i = 1, #xPlayer.accounts, 1 do
		if xPlayer.accounts[i].name == 'cash' then
			cash = ESX.Math.GroupDigits(xPlayer.accounts[i].money)
		elseif xPlayer.accounts[i].name == 'dirtycash' then
			dirtycash = ESX.Math.GroupDigits(xPlayer.accounts[i].money)
		elseif xPlayer.accounts[i].name == 'bank' then
			bank = ESX.Math.GroupDigits(xPlayer.accounts[i].money)
		end
	end

	SendNUIMessage({
		action = 'setInfos',
		infos = {
			{
				name = 'money',
				value = cash
			},
			{
				name = 'black_money',
				value = dirtycash
			},
			{
				name = 'bank',
				value = bank
			},
			{
				name = 'job',
				value = ('%s - <strong>%s</strong>'):format(xPlayer.job.label, xPlayer.job.grade_label)
			},
			{
				name = 'job2',
				value = ('%s - <strong>%s</strong>'):format(xPlayer.job2.label, xPlayer.job2.grade_label)
			}
		}
	})
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	SendNUIMessage({
		action = 'setInfos',
		infos = {
			{
				name = 'job',
				value = ('%s - %s'):format(job.label, job.grade_label)
			}
		}
	})
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	SendNUIMessage({
		action = 'setInfos',
		infos = {
			{
				name = 'job2',
				value = ('%s - %s'):format(job2.label, job2.grade_label)
			}
		}
	})
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)

	if account.name == 'dirtycash' then
		SendNUIMessage({
			action = 'setInfos',
			infos = {
				{
					name = 'black_money',
					value = ESX.Math.GroupDigits(account.money)
				}
			}
		})
	elseif account.name == 'bank' then
		SendNUIMessage({
			action = 'setInfos',
			infos = {
				{
					name = 'bank',
					value = ESX.Math.GroupDigits(account.money)
				}
			}
		})
	elseif account.name == 'cash' then
		SendNUIMessage({
			action = 'setInfos',
			infos = {
				{
					name = 'money',
					value = ESX.Math.GroupDigits(account.money)
				}
			}
		})
	end
end)

nbPlayerTotal = 0
RegisterNetEvent("ui:update")
AddEventHandler("ui:update", function(nbPlayerTotal)
	SendNUIMessage({
		type = "online-count",
		onlineCount = nbPlayerTotal
	})
end)

AddEventHandler('tempui:toggleUi', function(value)
	uiFaded = value

	if uiFaded then
		SendNUIMessage({action = 'fadeUi', value = true})
	else
		SendNUIMessage({action = 'fadeUi', value = false})
	end
end)

RegisterNUICallback('firstactivate', function()
	FirstActivate = true
end)

Citizen.CreateThread(function()
	local uiComponents = {'infos', 'statuts'}
	local inFrontend = false

	SendNUIMessage({action = 'hideUi', value = false})

	for i = 1, #uiComponents, 1 do
		SendNUIMessage({action = 'hideComponent', component = uiComponents[i], value = false})
	end

	while true do
		Citizen.Wait(250)

		HideHudComponentThisFrame(1) -- Wanted Stars
		HideHudComponentThisFrame(2) -- Weapon Icon
		HideHudComponentThisFrame(3) -- Cash
		HideHudComponentThisFrame(4) -- MP Cash
		HideHudComponentThisFrame(6) -- Vehicle Name
		HideHudComponentThisFrame(7) -- Area Name
		HideHudComponentThisFrame(8) -- Vehicle Class
		HideHudComponentThisFrame(9) -- Street Name
		HideHudComponentThisFrame(13) -- Cash Change
		HideHudComponentThisFrame(17) -- Save Game
		HideHudComponentThisFrame(20) -- Weapon Stats

		if not uiFaded then
			if IsPauseMenuActive() or IsPlayerSwitchInProgress() then
				if not inFrontend then
					inFrontend = true
					SendNUIMessage({action = 'hideUi', value = true})
				end
			else
				if inFrontend then
					inFrontend = false
					SendNUIMessage({action = 'hideUi', value = false})
				end
			end
		end
	end
end)