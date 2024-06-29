script_name('mine')
script_version('1.0')


-- https://github.com/qrlk/moonloader-script-updater
local enable_autoupdate = true -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/qrlk/moonloader-script-updater/master/minified-example.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/qrlk/moonloader-script-updater/"
        end
    end
end


local imgui = require("imgui")
local math = require('math')
local encoding = require ("encoding")
local inicfg = require("inicfg")
local requests = require 'requests'
encoding.default = "CP1251"
u8 = encoding.UTF8
local window = imgui.ImBool(false)
local stone = {
	{1540.9029541016, 1337.7686767578,10.220677375793}, {1547.8120117188, 1335.373046875,10.220677375793}, {1538.9403076172, 1343.9681396484,10.220677375793}, {1526.5106201172, 1355.1710205078,10.220677375793}, {1546.8081054688, 1342.4279785156,10.220677375793}, {1554.3286132813, 1339.2788085938,10.220677375793}, {1544.9761962891, 1349.4897460938,10.220677375793}, {1528.3167724609, 1360.6761474609,10.220677375793}, {1535.9393310547, 1356.8100585938,10.220677375793}, {1554.3696289063, 1346.1929931641,10.220677375793}, {1534.4929199219, 1361.2609863281,10.150674819946}, {1547.06640625, 1354.1274414063,10.220677375793}, {1552.5185546875, 1350.568359375,10.150674819946}, {1532.6173095703, 1366.2770996094,10.220677375793}, {1540.1322021484, 1362.6451416016,10.220677375793}, {1548.2973632813, 1358.8093261719,10.220677375793}, {1559.0455322266, 1353.697265625,10.220677375793}, {1555.4373779297, 1358.0803222656,10.220677375793}, {1538.0380859375, 1371.3294677734,10.220677375793}, {1544.26953125, 1368.8140869141,10.150674819946}, {1548.4990234375, 1366.0892333984,10.220677375793}, {1556.4034423828, 1364.6060791016,10.220677375793}, {1545.1500244141, 1375.5305175781,10.220677375793}, {1557.2308349609, 1367.8425292969,10.150674819946}, {1555.7947998047, 1371.4030761719,10.220677375793}, {1471.9580078125, 1402.2395019531,10.150674819946}, {1468.4377441406, 1404.0093994141,10.150674819946}, {1487.5095214844, 1406.9700927734,10.150674819946}, {1473.7191162109, 1408.1401367188,10.150674819946}, {1463.7098388672, 1409.5635986328,10.150674819946}, {1469.6505126953, 1413.5925292969,10.150674819946}, {1464.5024414063, 1414.0994873047,10.150674819946}, {1494.9322509766, 1414.9981689453,10.150674819946}, {1480.9447021484, 1416.6342773438,10.150674819946}, {1469.2341308594, 1419.9776611328,10.150674819946}, {1491.2390136719, 1420.1030273438,10.150674819946}, {1482.3776855469, 1422.7626953125,10.150674819946}, {1499.8206787109, 1421.3438720703,10.150674819946}, {1474.3621826172, 1423.5063476563,10.150674819946}, {1486.3846435547, 1424.2886962891,10.150674819946}, {1469.62890625, 1426.1126708984,10.150674819946}, {1490.5583496094, 1426.3400878906,10.150674819946}, {1499.7803955078, 1425.9538574219,10.150674819946}, {1473.0395507813, 1436.3427734375,10.150674819946}, {1496.1909179688, 1434.9742431641,10.150674819946}, {1489.8193359375, 1436.1889648438,10.150674819946}, {1479.8551025391, 1437.8935546875,10.150674819946}, {1495.0734863281, 1439.3460693359,10.150674819946}, {1486.0015869141, 1443.0479736328,10.150674819946}, {1475.5809326172, 1445.0219726563,10.150674819946}, {1542.685546875, 1432.5336914063,10.120675086975}, {1549.6724853516, 1430.5285644531,10.150674819946}, {1524.1469726563, 1440.4639892578,10.150674819946}, {1521.1770019531, 1443.1424560547,10.150674819946}, {1552.4871826172, 1434.0261230469,10.150674819946}, {1547.4991455078, 1436.7049560547,10.120675086975}, {1519.76171875, 1446.6604003906,10.150674819946}, {1528.0910644531, 1445.2156982422,10.150674819946}, {1530.4245605469, 1445.0402832031,10.150674819946}, {1554.54296875, 1438.2830810547,10.150674819946}, {1523.0325927734, 1450.484375,10.150674819946}, {1551.4803466797, 1442.9039306641,10.150674819946}, {1525.5366210938, 1453.3852539063,10.150674819946}, {1545.0881347656, 1447.4676513672,10.150674819946}, {1533.1916503906, 1451.7672119141,10.150674819946}, {1534.0886230469, 1453.4187011719,10.150674819946}, {1557.134765625, 1445.2886962891,10.150674819946}, {1541.8455810547, 1452.3380126953,10.150674819946}, {1549.3311767578, 1452.7567138672,10.150674819946}, {1531.7457275391, 1459.5999755859,10.150674819946}, {1539.0570068359, 1458.1680908203,10.150674819946}, {1558.7974853516, 1452.5151367188,10.150674819946}, {1536.7550048828, 1460.8170166016,10.150674819946}, {1555.9562988281, 1455.8426513672,10.150674819946}, {1533.8286132813, 1495.994140625,10.120675086975}, {1538.0989990234, 1496.212890625,10.120675086975}, {1542.4123535156, 1495.8824462891,10.120675086975}, {1528.7946777344, 1500.7145996094,10.120675086975}, {1534.9041748047, 1501.5311279297,10.120675086975}, {1534.1175537109, 1503.7718505859,10.120675086975}, {1528.1975097656, 1505.8238525391,10.120675086975}, {1545.5771484375, 1503.2059326172,10.120675086975}, {1529.1400146484, 1510.0120849609,10.120675086975}, {1538.8145751953, 1508.9765625,10.120675086975}, {1550.4748535156, 1506.8676757813,10.120675086975}, {1565.9437255859, 1501.6575927734,10.120675086975}, {1530.0230712891, 1514.2196044922,10.120675086975}, {1560.3747558594, 1506.7386474609,10.120675086975}, {1553.1687011719, 1510.2126464844,10.120675086975}, {1542.7620849609, 1513.7098388672,10.120675086975}, {1546.5435791016, 1514.0378417969,10.120675086975}, {1533.4232177734, 1518.5197753906,10.120675086975}, {1567.3728027344, 1508.9645996094,10.120675086975}, {1554.2933349609, 1514.5506591797,10.120675086975}, {1538.8377685547, 1519.1943359375,10.120675086975}, {1563.9852294922, 1513.4145507813,10.120675086975}, {1543.2750244141, 1520.2899169922,10.120675086975}, {1547.0234375, 1521.5052490234,10.120675086975}, {1552.3963623047, 1520.7330322266,10.120675086975}, {1557.4342041016, 1519.6220703125,10.120675086975}
}
local IniFilename = 'mine'
local ini = inicfg.load({
	settings = {
		enable = false;
		tracer = false;
		limit = 1000;
		time = 370; -- 370
		id = 3931; -- 3931
	}
  }, IniFilename)
  inicfg.save(ini, IniFilename)
local limit = imgui.ImInt(ini.settings.limit)
url = requests.get("https://pastebin.com/raw/6jjU5YQn") -- Отправляем GET запрос к нашей таблице
nicks = decodeJson(url.text) -- Получаем её, декодируем
nicks = nicks["private"]
local good = false

function main()


	while not isSampAvailable() do wait(100) end
	local _, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local nick = sampGetPlayerNickname(id)
	for idata in nicks:gmatch('[^ ]+') do
		if nick == idata then
			good = true
		end
	end
	if good then


		local font = renderCreateFont("Arial", 20, 5)
		local start = os.time()
		imgui.Process = false
		window.v = false
		themesDark()
		gen()
	
	
		sampRegisterChatCommand('mine', function ()
			window.v = not window.v
		end)
		sampRegisterChatCommand('mineact', function ()
			if ini.settings.enable == false then
				ini.settings.enable = true
				sampAddChatMessage(('mine on'), -1)
			else
				ini.settings.enable = false
				sampAddChatMessage(('mine off'), -1)
			end
			inicfg.save(ini, IniFilename)
		end)
		sampRegisterChatCommand('minelimit', function (arg)
			if tonumber(arg) then
				ini.settings.limit = tonumber(arg)
				inicfg.save(ini, IniFilename)
				sampAddChatMessage(('minelimit = '..ini.settings.limit), -1)
			else
				sampAddChatMessage(('/minelimit число. Текущее значение '..ini.settings.limit), -1)
			end
		end)
	
	
		  while true do wait(0)
			imgui.Process = window.v
	
	
			if ini.settings.enable then
				local x2,y2,z2 = getCharCoordinates(PLAYER_PED)
				local x10, y10 = convert3DCoordsToScreen(x2,y2,z2)
				
		
				for _,v in pairs(stone) do
					local x1, y1 = convert3DCoordsToScreen(v[1], v[2], v[3])
					local distance = string.format("%.1f", getDistanceBetweenCoords3d(v[1], v[2], v[3], x2, y2, z2))
		
					if isPointOnScreen(v[1], v[2], v[3], 0.1) and tonumber(distance) < ini.settings.limit then
						renderFontDrawText(font, (v[4]), x1, y1, 0xFFFF0000) -- model.." "..distance.." "..x.." "..y.." "..z
						drawCircleIn3d(v[1], v[2], v[3], 0.5, 0xFFFF0000, 5, 100)
					end
				end
		
		
				for _, v in pairs(getAllObjects()) do
					if isObjectOnScreen(v) then
						local result, x, y, z = getObjectCoordinates(v)
						local x1, y1 = convert3DCoordsToScreen(x,y,z)
						local model = getObjectModel(v)
						local distance = string.format("%.1f", getDistanceBetweenCoords3d(x, y, z, x2, y2, z2))
		
						if model == ini.settings.id then -- 3931
							if result and isPointOnScreen(x, y, z, 0.1) and tonumber(distance) < ini.settings.limit then
								drawCircleIn3d(x,y,z, 0.5, 0xFF00FF00, 5, 100)
								if ini.settings.tracer then
									renderDrawLine(x1, y1, x10, y10, 5.0, 0xFF00FF00) -- непрозрачный красный цвет
								end
							end
						end
					end
				end
	
	
				if os.time() - start >= 1 then
					start = os.time()
					for _, v in ipairs(stone) do
						if v[4] < ini.settings.time then
							v[4] = v[4] - 1
						elseif v[4] == 0 then
							v[4] = ini.settings.time
						end
					end
				end
			end
	
	
		end	
		

	else
		sampAddChatMessage('Сорри приват', -1)
	end
end


function imgui.OnDrawFrame()
	if window.v then
		imgui.SetNextWindowPos(imgui.ImVec2(800.0, 400.0), imgui.Cond.FirstUseEver)
		imgui.SetNextWindowSize(imgui.ImVec2(300.0, 300.0), imgui.Cond.FirstUseEver)
		imgui.Begin('mine', window, imgui.WindowFlags.NoResize + imgui.WindowFlags.NoCollapse + imgui.WindowFlags.ShowBorders)
		if ini.settings.enable == false then
			if imgui.Button((u8'Вх включить'), imgui.ImVec2(200, 50)) then
				ini.settings.enable = true
				inicfg.save(ini, IniFilename)
			end
		else
			if imgui.Button((u8'Вх выключить'), imgui.ImVec2(200, 50)) then
				ini.settings.enable = false
				inicfg.save(ini, IniFilename)
			end
		end

		if ini.settings.tracer == false then
			if imgui.Button((u8'Трейсер включить'), imgui.ImVec2(200, 50)) then
				ini.settings.tracer = true
				inicfg.save(ini, IniFilename)
			end
		else
			if imgui.Button((u8'Трейсер выключить'), imgui.ImVec2(200, 50)) then
				ini.settings.tracer = false
				inicfg.save(ini, IniFilename)
			end
		end
		if imgui.InputInt(('##'), limit) then
			ini.settings.limit = limit.v
			inicfg.save(ini, IniFilename)
		end
		imgui.Text((u8'id %s'):format(ini.settings.id))
		imgui.Text((u8'time %s'):format(ini.settings.time))
		imgui.Text((u8'Крутые чувачки:'))
		local d = 1
		for idata in nicks:gmatch('[^ ]+') do
			imgui.Text((u8'%s. %s'):format(d, idata))
			d = d + 1
		end
		imgui.End()
	end
end


function onReceiveRpc(id, bs)
	if id == 47 and ini.settings.enable then
		local oid = raknetBitStreamReadInt16(bs)
		local object = sampGetObjectHandleBySampId(oid)
		if doesObjectExist(object) then
			if getObjectModel(object) == ini.settings.id then
				local res, x, y, z = getObjectCoordinates(object)
				x = math_round( x, 3 )
				y = math_round( y, 3 )
				z = math_round( z, 3 )
				for _, v in ipairs(stone) do
					local x1 = math_round( v[1], 3 )
					local y1 = math_round( v[2], 3 )
					local z1 = math_round( v[3], 3 )
					if x == x1 and y == y1 and z == z1 then
						v[4] = ini.settings.time-1
					end
				end
			end
		end
		return true
	end

	if id == 58 and ini.settings.enable then
		local oid = raknetBitStreamReadInt16(bs)
		local object = sampGetObjectHandleBySampId(oid)
		if doesObjectExist(object) then
			if getObjectModel(object) == ini.settings.id then
				local res, x, y, z = getObjectCoordinates(object)
				x = math_round( x, 3 )
				y = math_round( y, 3 )
				z = math_round( z, 3 )
				for _, v in ipairs(stone) do
					local x1 = math_round( v[1], 3 )
					local y1 = math_round( v[2], 3 )
					local z1 = math_round( v[3], 3 )
					if x == x1 and y == y1 and z == z1 then
						v[4] = ini.settings.time
					end
				end
			end
		end
		return true
	end
end


drawCircleIn3d = function(x, y, z, radius, color, width, polygons)
    local step = math.floor(360 / (polygons or 36))
    local sX_old, sY_old
    for angle = 0, 360, step do 
        local _, sX, sY, sZ, _, _ = convert3DCoordsToScreenEx(radius * math.cos(math.rad(angle)) + x , radius * math.sin(math.rad(angle)) + y , z)
        if sZ > 1 then
            if sX_old and sY_old then
                renderDrawLine(sX, sY, sX_old, sY_old, width, color)
            end
            sX_old, sY_old = sX, sY
        end
    end
end


function gen()
	for _, v in ipairs(stone) do
		v[4] = ini.settings.time
	end
end


function math_round( roundIn , roundDig ) -- первый аргумент - число которое надо округлить, второй аргумент - количество символов после запятой.
    local mul = math.pow( 10, roundDig )
    return ( math.floor( ( roundIn * mul ) + 0.5 )/mul )
end


function themesDark()
	imgui.SwitchContext()
	local style = imgui.GetStyle()
	local colors = style.Colors
	local clr = imgui.Col
	local ImVec4 = imgui.ImVec4
	local ImVec2 = imgui.ImVec2
	style.WindowPadding = ImVec2(15, 15)
	style.WindowRounding = 15.0
	style.FramePadding = ImVec2(5, 5)
	style.ItemSpacing = ImVec2(12, 8)
	style.ItemInnerSpacing = ImVec2(8, 6)
	style.IndentSpacing = 25.0
	style.ScrollbarSize = 15.0
	style.ScrollbarRounding = 15.0
	style.GrabMinSize = 15.0
	style.GrabRounding = 7.0
	style.ChildWindowRounding = 8.0
	style.FrameRounding = 6.0
	colors[clr.Text] = ImVec4(0.95, 0.96, 0.98, 1.00)
	colors[clr.TextDisabled] = ImVec4(0.36, 0.42, 0.47, 1.00)
	colors[clr.WindowBg] = ImVec4(0.11, 0.15, 0.17, 1.00)
	colors[clr.ChildWindowBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
	colors[clr.PopupBg] = ImVec4(0.08, 0.08, 0.08, 0.94)
	colors[clr.Border] = ImVec4(0.43, 0.43, 0.50, 0.50)
	colors[clr.BorderShadow] = ImVec4(0.00, 0.00, 0.00, 0.00)
	colors[clr.FrameBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.FrameBgHovered] = ImVec4(0.12, 0.20, 0.28, 1.00)
	colors[clr.FrameBgActive] = ImVec4(0.09, 0.12, 0.14, 1.00)
	colors[clr.TitleBg] = ImVec4(0.09, 0.12, 0.14, 0.65)
	colors[clr.TitleBgCollapsed] = ImVec4(0.00, 0.00, 0.00, 0.51)
	colors[clr.TitleBgActive] = ImVec4(0.08, 0.10, 0.12, 1.00)
	colors[clr.MenuBarBg] = ImVec4(0.15, 0.18, 0.22, 1.00)
	colors[clr.ScrollbarBg] = ImVec4(0.02, 0.02, 0.02, 0.39)
	colors[clr.ScrollbarGrab] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.ScrollbarGrabHovered] = ImVec4(0.18, 0.22, 0.25, 1.00)
	colors[clr.ScrollbarGrabActive] = ImVec4(0.09, 0.21, 0.31, 1.00)
	colors[clr.ComboBg] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.CheckMark] = ImVec4(0.28, 0.56, 1.00, 1.00)
	colors[clr.SliderGrab] = ImVec4(0.28, 0.56, 1.00, 1.00)
	colors[clr.SliderGrabActive] = ImVec4(0.37, 0.61, 1.00, 1.00)
	colors[clr.Button] = ImVec4(0.20, 0.25, 0.29, 1.00)
	colors[clr.ButtonHovered] = ImVec4(0.28, 0.56, 1.00, 1.00)
	colors[clr.ButtonActive] = ImVec4(0.06, 0.53, 0.98, 1.00)
	colors[clr.Header] = ImVec4(0.20, 0.25, 0.29, 0.55)
	colors[clr.HeaderHovered] = ImVec4(0.26, 0.59, 0.98, 0.80)
	colors[clr.HeaderActive] = ImVec4(0.26, 0.59, 0.98, 1.00)
	colors[clr.ResizeGrip] = ImVec4(0.26, 0.59, 0.98, 0.25)
	colors[clr.ResizeGripHovered] = ImVec4(0.26, 0.59, 0.98, 0.67)
	colors[clr.ResizeGripActive] = ImVec4(0.06, 0.05, 0.07, 1.00)
	colors[clr.CloseButton] = ImVec4(0.40, 0.39, 0.38, 0.16)
	colors[clr.CloseButtonHovered] = ImVec4(0.40, 0.39, 0.38, 0.39)
	colors[clr.CloseButtonActive] = ImVec4(0.40, 0.39, 0.38, 1.00)
	colors[clr.PlotLinesHovered] = ImVec4(1.00, 0.43, 0.35, 1.00)
	colors[clr.PlotHistogram] = ImVec4(0.90, 0.70, 0.00, 1.00)
	colors[clr.PlotLines] = ImVec4(0.61, 0.61, 0.61, 1.00)
	colors[clr.PlotHistogramHovered] = ImVec4(1.00, 0.60, 0.00, 1.00)
	colors[clr.TextSelectedBg] = ImVec4(0.25, 1.00, 0.00, 0.43)
	colors[clr.ModalWindowDarkening] = ImVec4(1.00, 0.98, 0.95, 0.73)
end