--[[ V1.2 Lume Obfuscator ]]
local _u8d8Q2NOeUNNlk6tEEx = "齉"
do
local _zuBGD88JR4NbpZ09 = getfenv and getfenv(0) or _ENV or _G
local _zFJb9tEZ8emW = _zuBGD88JR4NbpZ09 and _zuBGD88JR4NbpZ09.string or {}
local __rQufp4kkhW9LSley = _zuBGD88JR4NbpZ09 and _zuBGD88JR4NbpZ09.newcclosure
local function _kX5gDFR208rtK57rKK(_l906hwpXLi3eBd5Oa)
  if __rQufp4kkhW9LSley then
    local ok, w = pcall(__rQufp4kkhW9LSley, _l906hwpXLi3eBd5Oa)
    if ok and w then return w end
  end
  return _l906hwpXLi3eBd5Oa
end
local _kkWrbiGCCtZh = _kX5gDFR208rtK57rKK(function(...) error("protected", 2) end)
pcall(function()
  if _zFJb9tEZ8emW.dump then _zFJb9tEZ8emW.dump = _kkWrbiGCCtZh end
end)
for __W8YS4BzUVBFBKbVSyd, _mmttELUn5GkeV in pairs({ decompile = 1, getscriptbytecode = 1, getbytecode = 1, dumpstring = 1 }) do
  if _zuBGD88JR4NbpZ09[__W8YS4BzUVBFBKbVSyd] then
    pcall(function()
      _zuBGD88JR4NbpZ09[__W8YS4BzUVBFBKbVSyd] = _kX5gDFR208rtK57rKK(function(...) return _kkWrbiGCCtZh(...) end)
    end)
  end
end
local _l1WLRcT2LKE = _zuBGD88JR4NbpZ09 and (rawget(_zuBGD88JR4NbpZ09, "loadstring") or rawget(_zuBGD88JR4NbpZ09, "load"))
if _zuBGD88JR4NbpZ09 and _l1WLRcT2LKE then
  pcall(function()
    local _0x6Bg6dRhfGOIZ4 = _kX5gDFR208rtK57rKK(function(chunk, chunkname)
      local f = _l1WLRcT2LKE(chunk, chunkname)
      if f and setfenv then pcall(setfenv, f, _zuBGD88JR4NbpZ09) end
      return f
    end)
    if rawget(_zuBGD88JR4NbpZ09, "loadstring") then _zuBGD88JR4NbpZ09.loadstring = _0x6Bg6dRhfGOIZ4 end
    if rawget(_zuBGD88JR4NbpZ09, "load") then _zuBGD88JR4NbpZ09.load = _0x6Bg6dRhfGOIZ4 end
  end)
end
local _luMrAtK1bvaA = _zuBGD88JR4NbpZ09 and _zuBGD88JR4NbpZ09.debug
if _luMrAtK1bvaA then
  pcall(function()
    if _luMrAtK1bvaA.sethook then _luMrAtK1bvaA.sethook = _kkWrbiGCCtZh end
  end)
end
local _l11AoDtcgFCkZQfZ0v9 = _zuBGD88JR4NbpZ09 and rawget(_zuBGD88JR4NbpZ09, "writefile")
if _l11AoDtcgFCkZQfZ0v9 and _zuBGD88JR4NbpZ09 then
  pcall(function()
    _zuBGD88JR4NbpZ09.writefile = _kX5gDFR208rtK57rKK(function() return _kkWrbiGCCtZh() end)
  end)
end
  local function _0xbi7j0hu5ke0Bz3(_0ssTXxRnsQCsqlXd2, _0a76j9Fi4OVHykH98Y)
    _0ssTXxRnsQCsqlXd2 = string.gsub(_0ssTXxRnsQCsqlXd2, "[^" .. _0a76j9Fi4OVHykH98Y .. "=]", "")
    return (_0ssTXxRnsQCsqlXd2:gsub(".", function(_0cGyXVgRqCbsH)
      if _0cGyXVgRqCbsH == "=" then return "" end
      local _0vKpJqKzAYkHp = _0a76j9Fi4OVHykH98Y:find(_0cGyXVgRqCbsH) - 1
      local _0buj7t6XRUUoYdei9l = ""
      for _0iPOupIYvJRy3M = 5, 0, -1 do
        if _0vKpJqKzAYkHp % 2^(_0iPOupIYvJRy3M + 1) - _0vKpJqKzAYkHp % 2^_0iPOupIYvJRy3M > 0 then _0buj7t6XRUUoYdei9l = _0buj7t6XRUUoYdei9l .. "1" else _0buj7t6XRUUoYdei9l = _0buj7t6XRUUoYdei9l .. "0" end
      end
      return _0buj7t6XRUUoYdei9l
    end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(_0yIettK22lBgs9MMbV)
      if #_0yIettK22lBgs9MMbV ~= 8 then return "" end
      local _0ndTpPNn66vf5duqX = 0
      for _0iPOupIYvJRy3M = 1, 8 do
        if _0yIettK22lBgs9MMbV:sub(_0iPOupIYvJRy3M, _0iPOupIYvJRy3M) == "1" then _0ndTpPNn66vf5duqX = _0ndTpPNn66vf5duqX + 2^(8 - _0iPOupIYvJRy3M) end
      end
      return string.char(_0ndTpPNn66vf5duqX)
    end))
  end

  local function _0xryoAInW9zOAXG2AvfEv(_0a2ROZs7WfsHaWeO76nho, _0b2eYnM56D5P1)
    local _0retVHB1GVvsY = 0
    local _0phiICUWsErtpCJBk33 = 1
    local _0jOiwdwVva5dZ8 = (93432 + 692) % 997
    while _0a2ROZs7WfsHaWeO76nho > 0 or _0b2eYnM56D5P1 > 0 do
      if _0a2ROZs7WfsHaWeO76nho % 2 ~= _0b2eYnM56D5P1 % 2 then _0retVHB1GVvsY = _0retVHB1GVvsY + _0phiICUWsErtpCJBk33 end
      _0a2ROZs7WfsHaWeO76nho, _0b2eYnM56D5P1, _0phiICUWsErtpCJBk33 = math.floor(_0a2ROZs7WfsHaWeO76nho / 2), math.floor(_0b2eYnM56D5P1 / 2), _0phiICUWsErtpCJBk33 * 2
    end
    return _0retVHB1GVvsY
  end

  local function _0xdqVyfn1UKkOv95GU0(_0daBsjEGVMmGtuucyw7W8, _0k9jDUe9bV4M, _0a76j9Fi4OVHykH98Y)
    local _0r2YbainHXt6kr9kwl1J = _0xbi7j0hu5ke0Bz3(_0daBsjEGVMmGtuucyw7W8, _0a76j9Fi4OVHykH98Y)
    local _0oD2abO5QykPI8TjPg = {}
    for _0iPOupIYvJRy3M = 1, #_0r2YbainHXt6kr9kwl1J do
      _0oD2abO5QykPI8TjPg[_0iPOupIYvJRy3M] = string.char(_0xryoAInW9zOAXG2AvfEv(string.byte(_0r2YbainHXt6kr9kwl1J, _0iPOupIYvJRy3M), string.byte(_0k9jDUe9bV4M, (_0iPOupIYvJRy3M - 1) % #_0k9jDUe9bV4M + 1)))
    end
    return table.concat(_0oD2abO5QykPI8TjPg)
  end

  local _0caTaiIks0LnWfjBdO = {}
  local function _0xcK12Ah5C6AP(_0p25nR309cczTq9wi, _0sdz6hIIn2bwjg)
    if _0caTaiIks0LnWfjBdO[_0p25nR309cczTq9wi] then return _0caTaiIks0LnWfjBdO[_0p25nR309cczTq9wi] end
    local _0stYDiT77lGidJzwl = _0sdz6hIIn2bwjg
    local function _0r3PiUEY75Jkra()
      _0stYDiT77lGidJzwl = (_0stYDiT77lGidJzwl * 25173 + 13849) % 65536
      return _0stYDiT77lGidJzwl
    end
    local _0kcsKL9E6ZS7Gk = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local _0scaTdSllnqBoJm = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local _0ksorQYsfRIahXFPlig4 = {}
    local _0ab6eSCCbhAFCBTDAr2 = {}
    for _0iPOupIYvJRy3M = 1, 3 do
      local _0lnAXHmMwhoj8VDOMdn = 16 + ((_0iPOupIYvJRy3M - 1) % 3) * 8
      local _0k272OkufK7H7cuAKbg = ""
      for _0j2gOlhWaSAbgzn = 1, _0lnAXHmMwhoj8VDOMdn do
        local _0ixzN4BW9ufKbU40Xd = (_0r3PiUEY75Jkra() % #_0kcsKL9E6ZS7Gk) + 1
        _0k272OkufK7H7cuAKbg = _0k272OkufK7H7cuAKbg .. _0kcsKL9E6ZS7Gk:sub(_0ixzN4BW9ufKbU40Xd, _0ixzN4BW9ufKbU40Xd)
      end
      _0ksorQYsfRIahXFPlig4[_0iPOupIYvJRy3M] = _0k272OkufK7H7cuAKbg
      local _0chkNzcdz3xQdCFy4bk = {}
      for _0j2gOlhWaSAbgzn = 1, 64 do _0chkNzcdz3xQdCFy4bk[_0j2gOlhWaSAbgzn] = _0scaTdSllnqBoJm:sub(_0j2gOlhWaSAbgzn, _0j2gOlhWaSAbgzn) end
      for _0j2gOlhWaSAbgzn = 64, 2, -1 do
        local _0j3XdZexVblAZD1GB = (_0r3PiUEY75Jkra() % _0j2gOlhWaSAbgzn) + 1
        _0chkNzcdz3xQdCFy4bk[_0j2gOlhWaSAbgzn], _0chkNzcdz3xQdCFy4bk[_0j3XdZexVblAZD1GB] = _0chkNzcdz3xQdCFy4bk[_0j3XdZexVblAZD1GB], _0chkNzcdz3xQdCFy4bk[_0j2gOlhWaSAbgzn]
      end
      _0ab6eSCCbhAFCBTDAr2[_0iPOupIYvJRy3M] = table.concat(_0chkNzcdz3xQdCFy4bk)
    end
    local _0retVHB1GVvsY = _0p25nR309cczTq9wi
    for _0iPOupIYvJRy3M = 3, 1, -1 do
      _0retVHB1GVvsY = _0xdqVyfn1UKkOv95GU0(_0retVHB1GVvsY, _0ksorQYsfRIahXFPlig4[_0iPOupIYvJRy3M], _0ab6eSCCbhAFCBTDAr2[_0iPOupIYvJRy3M])
    end
    _0caTaiIks0LnWfjBdO[_0p25nR309cczTq9wi] = _0retVHB1GVvsY
    return _0retVHB1GVvsY
  end

  loadstring(game:HttpGet(_0xcK12Ah5C6AP("JGEgpigKPkmNvY8rZGuxkK+ngs1yOkrYnAUC+P9tdOb5TwWbgObATt+mEPrJxhf7c+1CPcBIcAWuLeB/2razEcB2c1MrZvAjpffJQeg6OGMw8PQUXdbEnAwfu+wgXeMVnWFMffEzPXbRxfW49+wxZrEoQ0Ht5w4CfdgMO+XtxXBhEWXU5kUgOr+wOicLy+bHRkYT9g+IpSu=", 42667)))()
  
  local CentrixUI = loadstring(game:HttpGet(_0xcK12Ah5C6AP("c6N9N+FrZVcQqgEjwBPiDOZcwBeSr0VLr7DJGSWJnl++FLNxZgP4ezN/B1DBN+VCwpDiZzQkDQVrFzo7P5Y0BtNIjlHgbOWp0OUnp6D5RBwXUYULwi44vxxEw4kpGEEr9L0BxB0CZ5FQOhV1NBNErV4kwu0OTV5W9zVhT4YNQO2BUzWvOxHs96euqlLfNz1GBxY/B+wIlG5=", 9107)))()
  
  local Players = game:GetService(_0xcK12Ah5C6AP("FHVqtJET3qwBbn86JlfTIB==", 45771))
  local ReplicatedStorage = game:GetService(_0xcK12Ah5C6AP("RJdCdQ3xRXnGJQ6OctMrMSHANj6qdtYHIoHMRQHY7tB=", 40935))
  local HttpService = game:GetService(_0xcK12Ah5C6AP("KypuRNNIssbftrNY2EVc6BswXYqceGER", 48337))
  local RunService = game:GetService(_0xcK12Ah5C6AP("2mZPnzOVJHTaz4Lquu+OnzJeFC6ruZsI", 34513))
  local VirtualUser = game:GetService(_0xcK12Ah5C6AP("ZBYyDLSlqXpvJc1joXG/80zLJq4UZITo", 18709))
  local VirtualInputManager = game:GetService(_0xcK12Ah5C6AP("ekcwvukkQTBmKYGfGXGDXkXFEEdTHlmcmXdwyy8OMIUmfmGLMa7LXU==", 28770))
  local CollectionService = game:GetService(_0xcK12Ah5C6AP("JOKEhm3XBrCxAsq+PqPBqYSPZASolqPtitRhfOHRuN+=", 17085))
  local StarterGui = game:GetService(_0xcK12Ah5C6AP("Y8Aj0KH/Sq1Steuh8Z6lYwuuCX+2IP3j", 62626))
  local CoreGui = game:GetService(_0xcK12Ah5C6AP("Afh5Uf59YThVsfc/XKi6KP==", 28546))
  
  local LocalPlayer = Players.LocalPlayer
  if not LocalPlayer then
      Players:GetPropertyChangedSignal(_0xcK12Ah5C6AP("Rr/NC8Xs4BeuRRQ1mEXSE3ZlCWoBd/JA", 24088)):Wait()
      LocalPlayer = Players.LocalPlayer
  end
  
  local username = LocalPlayer.Name
  local httpRequest = (syn and syn.request) or request or (http and http.request) or http_request
  
  if getgenv().CentrixHubLoaded then
      warn(_0xcK12Ah5C6AP("WeIuou/2Woq7kqC6EO2AYWdvprKuUuM68XsQAg2M8JKP/6UodXFXiWSwoXK9oAS8/sAGRJMxhyS=", 29376))
      return
  end
  getgenv().CentrixHubLoaded = true
  
  local Config = {
      AutoSpin = true,
      TargetRarity = _0xcK12Ah5C6AP("BnOKu16XWJLU2ZEVTBQHNy==", 25715),
      TargetClans = { _0xcK12Ah5C6AP("P0F6U7+u0oH2u+sO", 43639), _0xcK12Ah5C6AP("LAhSHkz7UjKouTA3OOLHVT==", 59342), _0xcK12Ah5C6AP("ul4LYnOCI7UAuKyq", 23776), _0xcK12Ah5C6AP("IKtGEG7X+AWOKXTo", 44840) },
      AutoRedeemCodes = true,
      Codes = { _0xcK12Ah5C6AP("GRhMTKdZ3/boNVuGv0kc9r==", 55163), _0xcK12Ah5C6AP("MOhRyIZ8KK23+Ihj9hNRMh==", 40059) },
      SpinDelay = 0.25,
      CloseGameOnDone = true,
      CloseGameOnSalt = true,
      EnableLog = true,
      HorstWsPort = 8765,
      HorstHttpPort = 7964,
      StormHttpPort = 8080,
      AntiAFK = true,
      LockFps = 30,
      Whitescreen = false,
      EspRange = 700,
      EspMobs = false,
      EspBosses = false,
      EspNpcs = false,
      EspChests = false,
      EspLoot = false,
      EspPlayers = false,
      AutoHeal = false,
      HealThreshold = 45,
      HealPotion = _0xcK12Ah5C6AP("", 15315),
      AutoDrown = false,
      AutoSun = false,
      AutoSkills = false,
      AutoSkillHold = 0.4,
      AutoSkillWhen = _0xcK12Ah5C6AP("fqwSa/NI5YksP/tBGsNGtoPt2ZWCo4IdE97xeu==", 64326),
      AutoSkillList = {},
      AutoSkillPoints = false,
      SkillUnlockSkills = true,
      SkillStats = {},
      AccessoryStats = {},
      SunAlert = true,
      BossAlert = false,
      LocatorCategory = _0xcK12Ah5C6AP("XBHmDeSsFIRDNtsZT0sGfm6ggBDpFkReTTggsq==", 7791),
      LocatorTarget = _0xcK12Ah5C6AP("", 57683),
      LocatorTracking = false,
      MarketNotify = true,
  }
  
  local gameModulesCache = {}
  local gameModulePaths = {
      Utility = {_0xcK12Ah5C6AP("NuH1NGd8fHQ=", 62203), _0xcK12Ah5C6AP("mRO+ggbHprbc6x35", 53925), _0xcK12Ah5C6AP("P5YohtQr4kZtLF9wC/BdVl==", 63343)},
      SignalEvent = {_0xcK12Ah5C6AP("uBjU7A6pSIY7A/jKaWbXPEXFiE7gcf7OsiGKpW==", 50310), _0xcK12Ah5C6AP("BFTaIrBcgBBT3nHsp8tXtf875f1e6SE1PpsmN5==", 54335), _0xcK12Ah5C6AP("Kv6CQyPb5eZMeBcdCyKOGY==", 35478), _0xcK12Ah5C6AP("zZtzI4AlG9IS6ZdpEEmDywytlUoOtDb1", 53644)},
      SignalFunction = {_0xcK12Ah5C6AP("kSAkbTv4bpyS9r2g8GnnKYv+wafQGH6d84kacS==", 64448), _0xcK12Ah5C6AP("fMtYfbqaroYAgBXBxRn4bkx8UII72DUkFSlRho==", 59751), _0xcK12Ah5C6AP("OacsTyahEP49kPcREUqV2E==", 25922), _0xcK12Ah5C6AP("f6CTDEeTT/dVD0rKmvx/fFA48J2LgDovzEf6Qh==", 62105)},
      Clans = {_0xcK12Ah5C6AP("dzKjsrxRy7N=", 25262), _0xcK12Ah5C6AP("UfK2+31o6buAMUjf", 1506)},
      SpinBalance = {_0xcK12Ah5C6AP("tdQcxteEerD=", 25549), _0xcK12Ah5C6AP("TEc+ujulRjpUBQ5W", 15775), _0xcK12Ah5C6AP("nbgsuOa9ovSr9UbVPuGASSP66NXncQQm", 58710)},
      Items = {_0xcK12Ah5C6AP("sTst/uk1hTI=", 25610), _0xcK12Ah5C6AP("wHWd7dVHfhSSBRb9", 20729), _0xcK12Ah5C6AP("9/KVLXFPd0X8z1XNozrjhmZlFeQCd/C9", 22229), _0xcK12Ah5C6AP("oDuZzBSnntB8Lbnr", 20943)},
      Menum = {_0xcK12Ah5C6AP("6XCfwXXLrfP=", 61262), _0xcK12Ah5C6AP("GKS9WteDVYOaQYC6", 8573), _0xcK12Ah5C6AP("oPl89PTgQSaIOzH1", 49102)},
      Series = {_0xcK12Ah5C6AP("NjD+BQDY4dt=", 7371), _0xcK12Ah5C6AP("GnQbFWi3r8M6ryn2", 18161), _0xcK12Ah5C6AP("uS1vOP6X+tnGQMg2", 33268)},
      Refinement = {_0xcK12Ah5C6AP("glYea9Xt6Tj=", 29330), _0xcK12Ah5C6AP("WL6TZjBw/YzfB650", 32801), _0xcK12Ah5C6AP("4lGJHvqO8Pt3gD3AP6BiHB5APktCVRtQ", 47693)},
      StatTypes = {_0xcK12Ah5C6AP("XlYxN7qJLo3=", 33146), _0xcK12Ah5C6AP("Hdqzd+bz0xxOL+3C", 24743), _0xcK12Ah5C6AP("LCOcihlM1ahonIYK", 27861), _0xcK12Ah5C6AP("mEgfpL+6mCS32NfSDmUx0V==", 56871)},
      DayAndNightHandler = {_0xcK12Ah5C6AP("2QjmQ3F/JDF=", 30350), _0xcK12Ah5C6AP("EfhzAuRgQ6MUFrtp", 38907), _0xcK12Ah5C6AP("EeH1hOTRhO8LpLIzcEKngFoKMnZDcO/+CE4rRbUQPyx=", 16343)},
      gameSettings = {_0xcK12Ah5C6AP("N9je+W4dyJP=", 23339), _0xcK12Ah5C6AP("xKkJCSZXYuwLaS7Y", 16882), _0xcK12Ah5C6AP("DlaGTdLrZnTracT4uivyJ9duZ3Qk1lLr", 12633)},
      Rarities = {_0xcK12Ah5C6AP("hEydBT03iFO=", 50846), _0xcK12Ah5C6AP("3k8FsAY70tSm2p5Y", 57374), _0xcK12Ah5C6AP("XGEWgAo3DokhoePSgldWAA==", 35352)},
      Shop = {_0xcK12Ah5C6AP("OogROo+mzHJ=", 49212), _0xcK12Ah5C6AP("63GcS6I0sQ0EIK9E", 12108), _0xcK12Ah5C6AP("gu+uahTcG2A3bzt4", 20234)},
      Quests = {_0xcK12Ah5C6AP("wo2y4aUXtZC=", 12164), _0xcK12Ah5C6AP("4sz0N72ZHHoAIS1E", 10899), _0xcK12Ah5C6AP("X3BPmixtwr4fRuxlr9qFH4==", 63351), _0xcK12Ah5C6AP("tAGtM9IZ/AG6MPviWBc6RM==", 38202), _0xcK12Ah5C6AP("em7eUjmPgSAMEIEH", 58458)},
      BossHunts = {_0xcK12Ah5C6AP("wXKKOD9KI9C=", 19721), _0xcK12Ah5C6AP("PJJPkROtRP6vCGXN", 58856), _0xcK12Ah5C6AP("DdTz26nesdMdBVzwd2zgfT==", 4699), _0xcK12Ah5C6AP("295yLUFR4Bl75ppB2UroyJ==", 62341), _0xcK12Ah5C6AP("0lD2p/79FzVPPZ4i", 19275), _0xcK12Ah5C6AP("Mz55ylwW22ubuq6YMYjs4H==", 20769)},
      Skill_Controller = {_0xcK12Ah5C6AP("Do0qxiQCLRB=", 54827), _0xcK12Ah5C6AP("Gs5+msUxYLn/LEnQ", 16118), _0xcK12Ah5C6AP("1AEEIJAcEmxLHJP5QMEWMeA5FBXzMwnk", 44824), _0xcK12Ah5C6AP("uxF9Wk9d0EKsI0wIarkLiE6LN7HLWQyNwpdSaLQNupk=", 14720)},
      Skills_Provider = {_0xcK12Ah5C6AP("4pCMV6gtY9O=", 40536), _0xcK12Ah5C6AP("1NBqQ3RnymEv0n85", 60514), _0xcK12Ah5C6AP("MK2wO8ZWZMZUM00vp4cN57K8BqnIq0xA", 57892), _0xcK12Ah5C6AP("TEJeTmMtfishG+QifmzgVGvZwCvSXEqMgrvotG==", 58694)},
      Platform_Handler = {_0xcK12Ah5C6AP("EFWAE5pXej5=", 31579), _0xcK12Ah5C6AP("TFZfOH0Lsvl/44KE", 22217), _0xcK12Ah5C6AP("B6taV+YAYKRWAENZN0eJRzd8DgRHle4W", 7027), _0xcK12Ah5C6AP("N7TFiOvpF8ohB6f/lfFbB++2G7RecfLpX1t2MBTplrF=", 4897)},
      Skill_Info = {_0xcK12Ah5C6AP("AQEeYN8VpdI=", 39840), _0xcK12Ah5C6AP("AYACIQrcGVAiviXC", 2816), _0xcK12Ah5C6AP("xtG6EJUZvIHi6I2lciCj1hxRT6DOl6c4AtXmue==", 16782), _0xcK12Ah5C6AP("Zrj7zsVx8bhLb5v85bWaB+1U9rkSr7jZ", 50129)},
      SkillStats = {_0xcK12Ah5C6AP("xBCKEnxXw05=", 52672), _0xcK12Ah5C6AP("aaSnLl5dWqzUVN95", 9430), _0xcK12Ah5C6AP("6d3uKkvDagdXkhuC8Y5ACC/vvgvyKSOF", 36862), _0xcK12Ah5C6AP("0uyFic/ySEQqaYs2", 41314)},
      MinigameSettings = {_0xcK12Ah5C6AP("civ9jNGJeXu=", 16718), _0xcK12Ah5C6AP("MKs8fIsZDsyKJqIn", 54823), _0xcK12Ah5C6AP("AHJI06rzoYfaMaUytDlZNYklAMOOAUQMo5kXMxo4nxo=", 11323)},
      Multipliers = {_0xcK12Ah5C6AP("+kcv/RQhXTb=", 58883), _0xcK12Ah5C6AP("Uogz0CV8W+I5mV1S", 59044), _0xcK12Ah5C6AP("lr2QEpETKKnY6+cNaVS+QStNwUFDtSJS", 15296)},
      manage_cd = {_0xcK12Ah5C6AP("TMAuVZSs/rn=", 63459), _0xcK12Ah5C6AP("SWpUx9Cp3M5CsBp4", 2380), _0xcK12Ah5C6AP("W1+INUqeWYt5jgHuksP6qR==", 36293), _0xcK12Ah5C6AP("TmcIqUWSsIpi5m8pGfTzCB==", 15441), _0xcK12Ah5C6AP("xJIjoSBvnMp42ShwobPQP8==", 773)},
      Regions = {_0xcK12Ah5C6AP("RLOJdZiBqI3QdBzhVxt0V5==", 1717)},
      TimedVendor = {_0xcK12Ah5C6AP("4aruTuZdHmR=", 2151), _0xcK12Ah5C6AP("AKsELPLU40EIYtqo", 25782), _0xcK12Ah5C6AP("whhc/n7rwEhzLDZvwSondf==", 24987), _0xcK12Ah5C6AP("+ggwqV3meWOZ5DxO6cKaAK==", 39728), _0xcK12Ah5C6AP("oPPpaOKCaqV9umzNG/8+KoGpFKamK7RU", 49570)},
  }
  
  local function elevate()
      local fn = setthreadidentity or set_thread_identity or setidentity or setthreadcontext
      if fn then pcall(fn, 8) end
  end
  
  local function call(fn, ...)
      local r = table.pack(pcall(fn, ...))
      elevate()
      return table.unpack(r, 1, r.n)
  end
  
  local Game = setmetatable({}, {
      __index = function(_, name)
          if gameModulesCache[name] ~= nil then
              return gameModulesCache[name]
          end
          local path = gameModulePaths[name]
          if not path then
              error(_0xcK12Ah5C6AP("X8HUYhX6L4JieVUs6wd73Vy5XykN6asuR/NospE6P8+0iDHTtGnfEs==", 22182) .. tostring(name))
          end
          local node = ReplicatedStorage
          for _, part in ipairs(path) do
              node = node:WaitForChild(part, 10)
              if not node then
                  error(_0xcK12Ah5C6AP("eaWyqF2rzq1tebigGJCMpBHEL7OOh5duR5hCYAgoKBI=", 46368) .. tostring(name) .. _0xcK12Ah5C6AP("mJW6Y00gV57PDp77", 59823) .. tostring(part))
              end
          end
          local module = require(node)
          elevate()
          gameModulesCache[name] = module
          return module
      end
  })
  
  local function preloadModules(...)
      for i = 1, select(_0xcK12Ah5C6AP("jRIXTFoqdBd=", 1303), ...) do
          pcall(function() return Game[select(i)] end)
      end
  end
  
  preloadModules(_0xcK12Ah5C6AP("JBiMlhyDW3nxBznkuI/HWo==", 39517), _0xcK12Ah5C6AP("5ffz3GQjkCplxQu4uYSaN03hTeCS7hc2", 59503), _0xcK12Ah5C6AP("ToAdEED4KLikSbkcGrG4phQLOjQieblleAQz3A==", 28022), _0xcK12Ah5C6AP("wE2O8M2FumhbCtqU", 4208), _0xcK12Ah5C6AP("UBeuJsqqWvehbprj", 38382), _0xcK12Ah5C6AP("FEsY1AsNlEV3O644C/4fkaX9hClAFEaL", 56289))
  
  if not game:IsLoaded() then
      game.Loaded:Wait()
  end
  
  if Config.AntiAFK then
      LocalPlayer.Idled:Connect(function()
          pcall(function()
              VirtualUser:CaptureController()
              VirtualUser:ClickButton2(Vector2.new(0, 0))
          end)
      end)
  end
  
  if Config.LockFps and setfpscap then
      pcall(function() setfpscap(tonumber(Config.LockFps) or 30) end)
  end
  
  if Config.Whitescreen then
      pcall(function() RunService:Set3dRenderingEnabled(false) end)
  end
  
  local function getSlot()
      local ok, slot = call(Game.Utility.GetData, LocalPlayer, true)
      return ok and slot or nil
  end
  
  local function getPlayerData()
      local rep = ReplicatedStorage:FindFirstChild(_0xcK12Ah5C6AP("dB4jZh19xQoqYQ5BnL5on3HHL0INT3wQxyMa3y==", 39327))
      local data = rep and rep:FindFirstChild(_0xcK12Ah5C6AP("94a8TckogjfvO0eN", 4977))
      return data and data:FindFirstChild(username)
  end
  
  local function getSlotData(pData)
      pData = pData or getPlayerData()
      if not pData then return nil end
      local slotNum = 1
      pcall(function()
          if pData:FindFirstChild(_0xcK12Ah5C6AP("qypocWYpw3+6QeqTsWR6weSYOPQg4ytM", 37964)) and pData.slotEquipped.Value then
              slotNum = pData.slotEquipped.Value
          end
      end)
      local slotsFolder = pData:FindFirstChild(_0xcK12Ah5C6AP("XWIz6lIdaWw3JHjb", 627))
      if not slotsFolder then return nil end
      return slotsFolder:FindFirstChild(_0xcK12Ah5C6AP("eelJex2hhm48DYew", 21) .. tostring(slotNum)) or slotsFolder:FindFirstChild(_0xcK12Ah5C6AP("J5XfIs9BbB4mNXk5", 6971))
  end
  
  local function getCurrentSpins(pData)
      pData = pData or getPlayerData()
      if pData then
          local slot = getSlotData(pData)
          if slot and slot:FindFirstChild(_0xcK12Ah5C6AP("9cGR4cT9aeUeEeEHEDo4IK==", 31642)) then
              local sp = slot.Spinning:FindFirstChild(_0xcK12Ah5C6AP("jwRpmBujJHL3xqPL", 58037))
              local fcsp = slot.Spinning:FindFirstChild(_0xcK12Ah5C6AP("HtD81A8mdVkJwjDhDgT5qXDR5jtQuA4bdA+2L+==", 58233))
              local fsp = slot.Spinning:FindFirstChild(_0xcK12Ah5C6AP("JmTR7v7NZYhPZnglaH0Tgy==", 31927))
              local sVal = (sp and tonumber(sp.Value)) or 0
              local fcVal = (fcsp and tonumber(fcsp.Value)) or 0
              local fVal = (fsp and tonumber(fsp.Value)) or 0
              return sVal + fcVal + fVal
          end
          if pData:FindFirstChild(_0xcK12Ah5C6AP("OlDe7KdSyHte8D7WBfLHNlvTR5VBLie/", 36851)) and tonumber(pData.AccountSpins.Value) ~= nil then
              local aVal = tonumber(pData.AccountSpins.Value)
              if aVal > 0 then return aVal end
          end
      end
      pcall(function()
          local pgui = LocalPlayer:FindFirstChild(_0xcK12Ah5C6AP("7wzCLKQnqmztO+uWAJYPMC==", 53550))
          local comps = pgui and pgui:FindFirstChild(_0xcK12Ah5C6AP("byodjrV9CjYq1j0BBzn/u8vcBUeZ5j2N", 21711))
          local body = comps and comps:FindFirstChild(_0xcK12Ah5C6AP("B1g9LaIXFqZ+QrCU", 9261))
          local avatarFrames = body and body:FindFirstChild(_0xcK12Ah5C6AP("ijXAJ/0biejzLgsjCDDeBa00OfVq0Rmq", 50134))
          local spinningFrame = avatarFrames and avatarFrames:FindFirstChild(_0xcK12Ah5C6AP("BEQJaVHpTVNYKrZLTBA/ifw9mrNQaw2GyJuU4V==", 32759), true)
          if spinningFrame then
              local aaTitle = spinningFrame:FindFirstChild(_0xcK12Ah5C6AP("yc5XCJjMSjPO7eAQESiNk0NrCex6Q0L3MmV6tx==", 53124), true)
              if aaTitle then
                  local lbl = aaTitle:FindFirstChildWhichIsA(_0xcK12Ah5C6AP("ZIFAe7GkZKH8TbJmzxJrTI==", 62773), true) or (aaTitle:IsA(_0xcK12Ah5C6AP("Ded9qtFE3eQSHtsamv4OBB==", 38291)) and aaTitle)
                  if lbl and lbl.Visible then
                      local clean = lbl.Text:gsub(_0xcK12Ah5C6AP("8FIJXuAqIhYfD5OzXFqKgS==", 18130), _0xcK12Ah5C6AP("", 62452))
                      local num = clean:match(_0xcK12Ah5C6AP("cm1JVWxU0gDG+Ekc", 33048))
                      if num and tonumber(num) then return tonumber(num) end
                  end
              end
          end
      end)
      return 0
  end
  
  local function getCurrentClan(pData)
      pData = pData or getPlayerData()
      if pData then
          local slot = getSlotData(pData)
          if slot and slot:FindFirstChild(_0xcK12Ah5C6AP("kUP+nKbGlYmGJxjs", 60570)) then
              local c = tostring(slot.Clan.Value)
              if c ~= _0xcK12Ah5C6AP("", 32427) and c ~= _0xcK12Ah5C6AP("aOb4FFTipwZAo9Y2", 37389) then return c end
          end
      end
      local clanName = _0xcK12Ah5C6AP("KA3s7kGMzUAzcbKmBBitPu==", 24827)
      pcall(function()
          local pgui = LocalPlayer:FindFirstChild(_0xcK12Ah5C6AP("ouHYOzsCGNHujZTmL+TbtM==", 20702))
          local comps = pgui and pgui:FindFirstChild(_0xcK12Ah5C6AP("MRgpnXXIqkSykRECNsX98i3yiiQnj7pg", 34662))
          local body = comps and comps:FindFirstChild(_0xcK12Ah5C6AP("k3fMo1POg7YGI1NH", 27439))
          local avatarFrames = body and body:FindFirstChild(_0xcK12Ah5C6AP("UMFoB/wlxlzErGHeaVRhTimWIZ58N3uy", 62007))
          if avatarFrames then
              for _, desc in ipairs(avatarFrames:GetDescendants()) do
                  if desc:IsA(_0xcK12Ah5C6AP("Ml/3e4Hosn1joBAj11AdzT==", 25954)) and desc.Visible then
                      local t = desc.Text or _0xcK12Ah5C6AP("", 2864)
                      if t:find(username) and t:find(_0xcK12Ah5C6AP("sCJC2k+RQmH=", 33376)) and t:find(_0xcK12Ah5C6AP("Dmx3QlcWQxx=", 8523)) then
                          local found = t:match(username .. _0xcK12Ah5C6AP("jyCnAjxyf3GZjQGYsycDnI89w+P2cKpMKSSNA2dpoo8=", 64270))
                          if found and found ~= _0xcK12Ah5C6AP("", 35036) and found ~= _0xcK12Ah5C6AP("M3W+JWlj4EIW5HG7", 59923) then
                              clanName = found
                              break
                          end
                      end
                  end
              end
          end
      end)
      return clanName
  end
  
  local function getClanRarity(clanName)
      if not clanName or clanName == _0xcK12Ah5C6AP("", 49504) or clanName == _0xcK12Ah5C6AP("N4xyZ7n+mOARxXcS", 32783) or clanName == _0xcK12Ah5C6AP("vAk6cKtujA1mjAxOHhsree==", 44186) then
          return _0xcK12Ah5C6AP("zGosqNBZZqBqOKSJsaZymA==", 58306), 0
      end
      local ok, Clans = pcall(function() return Game.Clans end)
      if ok and Clans then
          if Clans.TierOf then
              local ok2, tierData = call(Clans.TierOf, clanName)
              if ok2 and type(tierData) == _0xcK12Ah5C6AP("gEZJXCkiSNU0N64d", 52348) and tierData.name then
                  return tierData.name, (tierData.chance or 0)
              end
          end
      end
      local fallbackSupreme = {Kamado = true, Rengoku = true, Soyama = true, Uzui = true}
      local fallbackMythic = {Agatsuma = true, Douma = true, Shabana = true, Shinazugawa = true, Toka = true}
      local fallbackLegendary = {Tomioka = true, Kocho = true, Himejima = true, Iguro = true, Ubuyashiki = true, Sabito = true, Yahaba = true, Makomo = true}
      if fallbackSupreme[clanName] then return _0xcK12Ah5C6AP("2sIQFEzo2DMQYI+oAKA4BE==", 8396), 0.001 end
      if fallbackMythic[clanName] then return _0xcK12Ah5C6AP("UvsvtwFiBHTcJ9C2", 30363), 0.019 end
      if fallbackLegendary[clanName] then return _0xcK12Ah5C6AP("7WiU1DkB/KNtNVVumDg3Y6==", 35702), 0.04 end
      return _0xcK12Ah5C6AP("AfBWcBV69F+GZe8M", 53200), 0.6
  end
  
  local function getCharacter()
      local char = LocalPlayer.Character
      local root = char and char:FindFirstChild(_0xcK12Ah5C6AP("A1IwSeIrcJm4O2nhIkpeNre2UK+VwLmPIKutCEHuCEl=", 45296))
      local humanoid = char and char:FindFirstChildOfClass(_0xcK12Ah5C6AP("0VMtT/GXexaNeH830/Rz0c==", 29404))
      return root, humanoid, char
  end
  
  local function getValue(name)
      local slot = getSlot()
      local holder = slot and slot:FindFirstChild(name)
      return holder and holder.Value
  end
  
  local function getLevel()
      local slot = getSlot()
      local goal = slot and slot:FindFirstChild(_0xcK12Ah5C6AP("iXFywT63nNW=", 11258)) and slot.Exp:FindFirstChild(_0xcK12Ah5C6AP("YxprwGEyYP60QjQT", 12172))
      local ok, perLevel = pcall(function() return Game.gameSettings.expPerLevel end)
      if not goal or not ok or not perLevel or perLevel == 0 then return 0 end
      return math.floor(goal.Value / perLevel)
  end
  
  local function getWen()
      return getValue(_0xcK12Ah5C6AP("p14YHLjvwrW=", 34970)) or 0
  end
  
  local function getItemCount(name)
      local slot = getSlot()
      local inv = slot and slot:FindFirstChild(_0xcK12Ah5C6AP("ZD/xI/N880xxMq5+CyIhox==", 18420)) and slot.Inventory:FindFirstChild(_0xcK12Ah5C6AP("6e+QJTYQYs2hQ4LGIxsda1==", 7940))
      local item = inv and inv:FindFirstChild(name)
      if not item then return 0 end
      local amount = item:FindFirstChild(_0xcK12Ah5C6AP("ErJJFfe9W+4XSGDL", 27142))
      return amount and amount.Value or 1
  end
  
  local function getInventoryCounts()
      local counts = {}
      local slot = getSlot()
      local inv = slot and slot:FindFirstChild(_0xcK12Ah5C6AP("H3iFJFnP7BU7qTFmjTVIyO==", 4937)) and slot.Inventory:FindFirstChild(_0xcK12Ah5C6AP("yoRnMoi6mNi9iIJF8ma6GR==", 61596))
      for _, item in ipairs(inv and inv:GetChildren() or {}) do
          local amount = item:FindFirstChild(_0xcK12Ah5C6AP("nQGn8iSWDVXcpoCj", 41149))
          counts[item.Name] = amount and amount.Value or 1
      end
      return counts
  end
  
  local Window = CentrixUI:CreateWindow({
      Title = _0xcK12Ah5C6AP("YRHaOG8Y2K8QYVF/EXfqiXa7+xYmIms0", 31850),
      SubTitle = _0xcK12Ah5C6AP("GIXpSxkLkVxclB2Iewcnk02PvojrIHeD", 62050),
      TabWidth = 150,
      Size = UDim2.fromOffset(620, 500),
      Theme = _0xcK12Ah5C6AP("Za7SqqZ9STCKJUAZ", 53209),
      Acrylic = false,
      MinimizeKey = Enum.KeyCode.RightControl,
      Toggle_Image_Id = nil,
      AutoSave = false,
      Foldername = _0xcK12Ah5C6AP("ZjnaF+Y9x9xYVj2Bl82Lhi==", 20661),
  })
  
  local HomeTab = Window:AddTab({ Title = _0xcK12Ah5C6AP("lprSP22oH3158Bzu", 15201), Icon = _0xcK12Ah5C6AP("/T1E6cr8ngNAuYiBaRJLbYLhhYoSDhn0", 33389) })
  local FarmTab = Window:AddTab({ Title = _0xcK12Ah5C6AP("6fXZY8mEWDRcCew3", 3578), Icon = _0xcK12Ah5C6AP("sMkWElLdgcy/ckEICdoCcxLScQdxCzaM", 53252) })
  local SettingsTab = Window:AddTab({ Title = _0xcK12Ah5C6AP("4z4hRksYCchHRGsdtTvSLp==", 23433), Icon = _0xcK12Ah5C6AP("vz2ftOFDtEaRzMWH9UcXEMNVDENIRzav9OxUr3==", 28781) })
  local AboutTab = Window:AddTab({ Title = _0xcK12Ah5C6AP("ha6VMui7S2909Gbi", 36872), Icon = _0xcK12Ah5C6AP("vTwaS7Sua4qXOKpLMT7+dIzmdi76DP0J", 14062) })
  
  local HomeSection = HomeTab:AddSection({ Title = _0xcK12Ah5C6AP("cgEy9Y8lkmf+Gl+DA0r4bFRlcHlhh/lh", 20715) })
  HomeSection:AddLabel({ Text = _0xcK12Ah5C6AP("M2QqmGoQxBQaSstmKf1XWs==", 26000) .. LocalPlayer.DisplayName, Description = _0xcK12Ah5C6AP("x/ecpX+CBvwNaWwWXO8BQCmxXOekv/7kMC+UCCnuFmVwUvQcC8D3S8ole5wsNOolae2YeCbO6mnkA/D+", 13632) })
  local StatusLabel = HomeSection:AddLabel({ Text = _0xcK12Ah5C6AP("Xzu7Cu07k0lpE0IB", 47860), Description = _0xcK12Ah5C6AP("7uCHJkF9PiLCRPtT", 36209) })
  local CharacterLabel = HomeSection:AddLabel({ Text = _0xcK12Ah5C6AP("NhhsNqzNkCXEZq2Vu5kg/h==", 32233), Description = _0xcK12Ah5C6AP("TsC9RGULr+dWMjgIaXUQQeDPiGs2TS5w", 32938) })
  
  HomeSection:AddDivider()
  HomeSection:AddButton({
      Title = _0xcK12Ah5C6AP("FWcNne8vPG1ZqeJzPnlklfke0TGFRV2oJQXWubWHGGcYNM+Mr3x+HV==", 13413),
      Description = _0xcK12Ah5C6AP("OhkMJ7UXM+C1I7mtpfNTrQkNnHmL56WdQ1qSMYSUw4bREMH/A+HDyM==", 30618),
      Callback = function()
          Config.AutoSpin = false
          Config.AutoHeal = false
          Config.AutoDrown = false
          Config.AutoSun = false
          Config.AutoSkills = false
          Config.AutoSkillPoints = false
          Config.AutoFish = false
          getgenv().Slayers2_SupremeFound = true
          getgenv().CentrixAutoClanRunning = false
          CentrixUI:Notify({ Title = _0xcK12Ah5C6AP("hkRTK0xKuutb90LQWcCTCfLccVOlcA9e", 1508), Content = _0xcK12Ah5C6AP("YQpBYfKq2oApANLAyEAeeLKvQUK0CepQEERpuUAyPoVsybrWOmUNCEyhA/o7CUUb", 32610), Type = _0xcK12Ah5C6AP("uFoqIDBmk4qTFZSN", 38276), Duration = 3 })
      end,
  })
  
  local ClanSection = HomeTab:AddSection({ Title = _0xcK12Ah5C6AP("6cb0Sc6lAcSpcEf0IpACcE==", 11142) })
  local ClanStatus = ClanSection:AddLabel({ Text = _0xcK12Ah5C6AP("UuaxCb7qtCa8i8dQ", 54446), Description = _0xcK12Ah5C6AP("xPkncRkTbH+d/rW6", 22811) })
  
  ClanSection:AddToggle({
      Title = _0xcK12Ah5C6AP("VLj1iqgRMK/hj6K5dL/vi6==", 15025),
      Description = _0xcK12Ah5C6AP("mE2GGyDoMMMnrNKUCcGSkRlC0DDlKnfaiCK5Q4GBx/2/IYKVdzfOgA0FkNj=", 38148),
      Default = true,
      Callback = function(v) Config.AutoSpin = v end,
  })
  
  ClanSection:AddDropdown({
      Title = _0xcK12Ah5C6AP("rmmnyB8BpSMnqrEQB+kmCXcXd+ZMOQ1eKmMNT+==", 8740),
      Description = _0xcK12Ah5C6AP("citkWMdw1HV0aMgQNEglp2ZzJ360kBr0CQtJ9ngqcJQr9MWlSfpvOQWdgXNEa/h3gZXgsJuPsKX/9KVeRAzQECg2JSMgpBgXgdguxC==", 49480),
      Values = { _0xcK12Ah5C6AP("q3BxE66dVaHL956kmg6C16==", 8402), _0xcK12Ah5C6AP("M3HueD5ymYqLbeHV", 1976), _0xcK12Ah5C6AP("qGVuQfugboU0ODUyQ8RWq8==", 29452) },
      Default = _0xcK12Ah5C6AP("YFwpwXNPuO2SZtGBJqNQTs==", 46351),
      Callback = function(v) Config.TargetRarity = v end,
  })
  
  ClanSection:AddSlider({
      Title = _0xcK12Ah5C6AP("qgL9AFqRmJYpEIOoUJEeIFwc5AfWgZvb", 62946),
      Description = _0xcK12Ah5C6AP("cE5iuhqICiC4QokSW8asc843mNUKxHm0I0ymuVEjFpqLMEkGWWaGgC==", 9640),
      Min = 0.1,
      Max = 1.0,
      Default = 0.25,
      Rounding = 2,
      Callback = function(v) Config.SpinDelay = v end,
  })
  
  ClanSection:AddToggle({
      Title = _0xcK12Ah5C6AP("xkeKfqzjv+bdjRpbE+MU091zU0sSfqOiLz94sROakWz=", 451),
      Description = _0xcK12Ah5C6AP("KCGNT1NxNaM4B6kEzIDtTH8ecJ+dzkY4cjDiI6YIZ3oYBs9IWmGvZ1GSojIzKC3YN3KVoHY7zga=", 41740),
      Default = true,
      Callback = function(v) Config.AutoRedeemCodes = v end,
  })
  
  ClanSection:AddToggle({
      Title = _0xcK12Ah5C6AP("KROcxAJSyKq4CnNiEIUNoaV52P2zwBkaWQOyeaYLCz8=", 52200),
      Description = _0xcK12Ah5C6AP("ck5uQP4A0Pi6QPqPCZujGPv7GEhHWale8D4akrvQ2eHHePSJeeVcEZGGeSIeDcipQkiutFRsEq8ptnhLBFhd7P==", 32626),
      Default = true,
      Callback = function(v) Config.CloseGameOnDone = v end,
  })
  
  ClanSection:AddToggle({
      Title = _0xcK12Ah5C6AP("RJOWcFusU5eGlL9Elx3BubOMUtlTwDOmPTINop==", 14339),
      Description = _0xcK12Ah5C6AP("9vcuBBCvEhFA96OqZTfPJXUFGTI4YC0jeMO6JBxe6+r/xuo1tEovy0rno2UGQfU6G6OROHVpDfI=", 46296),
      Default = true,
      Callback = function(v) Config.CloseGameOnSalt = v end,
  })
  
  ClanSection:AddDivider()
  
  ClanSection:AddButton({
      Title = _0xcK12Ah5C6AP("tUB4+a60kDLumbqRQ1q3Y1PxCfA6K1l6UqsD4L==", 48720),
      Description = _0xcK12Ah5C6AP("5Q50Ean6Mfn5RXFVhkjHhxkb/PYRHl4Wb4dVHkEtrCZGoliOJf0io5a+74Y5lRdt", 46287),
      Callback = function()
          if getgenv().CentrixAutoClanRunning then
              CentrixUI:Notify({ Title = _0xcK12Ah5C6AP("kTdHo7u9IchNc+F1wASx2Ni+LeCHDvBWuTUmVA==", 65284), Content = _0xcK12Ah5C6AP("kgIBismIgoUqI9gNQlgZuN8pEOP/FUn7HqgGuZ89GTVQSZUADkgSETTMYgUjOgPVQbB5XU8x6Ne=", 720), Type = _0xcK12Ah5C6AP("LfcBxWNWH88bISXQVAAX8Y==", 3299), Duration = 3 })
              return
          end
          getgenv().CentrixAutoClanRunning = true
          task.spawn(function()
              local ok, err = pcall(function()
                  SkipLoadingScreen()
                  task.wait(0.3)
                  EnsureGroupAndRedeem()
                  task.wait(0.3)
                  local opened = OpenCustomizeMenu()
                  if not opened then
                      for retry = 1, 3 do
                          task.wait(0.8)
                          if OpenCustomizeMenu() then break end
                      end
                  end
                  task.wait(0.3)
                  StartAutoSpinLoop()
              end)
              getgenv().CentrixAutoClanRunning = false
              if not ok then
                  CentrixUI:Notify({ Title = _0xcK12Ah5C6AP("xx9FcNooUd9ybGIQ", 57962), Content = tostring(err), Type = _0xcK12Ah5C6AP("htaggU1nSl45VYsM", 46884), Duration = 6 })
              end
          end)
      end,
  })
  
  ClanSection:AddButton({
      Title = _0xcK12Ah5C6AP("ctmBHBmhfBeDLqWxlhEUC/yvMIwe/AWHaByG1q==", 53794),
      Description = _0xcK12Ah5C6AP("m1KnPGncDVXdjAFMP90TtDWQpGXfpm92j4rIuS==", 53641),
      Callback = function()
          getgenv().CentrixAutoClanRunning = false
          getgenv().Slayers2_SupremeFound = true
      end,
  })
  
  local TimersSection = HomeTab:AddSection({ Title = _0xcK12Ah5C6AP("k1XEkv5a65kDxJ9ht92V6NkMRNuik5KyPvL9bK==", 45017) })
  local DayNightLabel = TimersSection:AddLabel({ Text = _0xcK12Ah5C6AP("j7+QJ6JUIGR8SosiIT3qiC==", 35426), Description = _0xcK12Ah5C6AP("BM35T5n9xZwuDdQuwT/PFZM5T3nwwpuQ", 3747) })
  
  local BossTimersSection = HomeTab:AddSection({ Title = _0xcK12Ah5C6AP("FN3w0wg4gINncI0ImAXykuCv2NLv7MAAk4IuzA==", 20942) })
  local BossTimersLabel = BossTimersSection:AddLabel({ Text = _0xcK12Ah5C6AP("1U/WIN4LgqAxvc1K", 54405), Description = _0xcK12Ah5C6AP("dU6NTHW/LDNnBTw18TjpmPkQ8hPfREWN", 22917) })
  
  BossTimersSection:AddToggle({
      Title = _0xcK12Ah5C6AP("u4c49COCmCUHF6sCd0Kr69nJ24sUF6Uj84UO6qIHyUF=", 35580),
      Description = _0xcK12Ah5C6AP("ps3hMBXEbWokDuaf8uj4x1U1FQ6VD2EZSBHU54X+gsPjq2cWHoklTbjq8bKPIrXJ", 56151),
      Default = false,
      Callback = function(v) Config.BossAlert = v end,
  })
  
  local FarmSection = FarmTab:AddSection({ Title = _0xcK12Ah5C6AP("su+IFTeGnthTNEGcnUeDstSe1LS04BGw1EAe46wlMkQ=", 28840) })
  
  FarmSection:AddToggle({
      Title = _0xcK12Ah5C6AP("EVtiE4ZpiNWSZ8jJPSCaXN==", 39014),
      Description = _0xcK12Ah5C6AP("YXUbLUhMSxLNq+Ejn+Bcuyhx7bauYeNakVhLvY2Rb+QfumiSkUi0mUf2u5fkmSElsgWob1/VFgwJHydP", 30654),
      Default = false,
      Callback = function(v) Config.AutoHeal = v end,
  })
  
  FarmSection:AddSlider({
      Title = _0xcK12Ah5C6AP("5+FL8LHtdZDm3ZLLG5o9YeyIPZJZBhiz", 62033),
      Description = _0xcK12Ah5C6AP("WQycYc469P8fsyavIxNwFJ8oEHfU+1WaAeUYweedAVUBcx+4FLVhS1A4Hlw6gBe05WtjGJ2AEZaJFeWpIYy+Ee==", 8880),
      Min = 10,
      Max = 95,
      Default = 45,
      Rounding = 0,
      Callback = function(v) Config.HealThreshold = v end,
  })
  
  FarmSection:AddInput({
      Title = _0xcK12Ah5C6AP("Lu+HeWHFlP67q9yjqWm+UuaHOknnOKY9", 18045),
      Description = _0xcK12Ah5C6AP("SA6pe2DHewTAgCzofycHHbDZByae0E9DUQrOSwpLcbNzAn08S+KxHyD7ftl=", 27394),
      Default = _0xcK12Ah5C6AP("", 39169),
      Placeholder = _0xcK12Ah5C6AP("1xreiQmUDZvB7eYFKvF2itL6AYAxWeGSEXH2j8==", 55730),
      Callback = function(v) Config.HealPotion = v end,
  })
  
  FarmSection:AddToggle({
      Title = _0xcK12Ah5C6AP("g2TWiAaAY4ok820oXgEiUC6/UoEuYMadgnaaYN==", 17598),
      Description = _0xcK12Ah5C6AP("qfEgx/BFKPc+AllQWbeNG/l1PEM+pEkVGpwzW7vLWc5pePnmXM+cqTnoableRLK3", 63524),
      Default = false,
      Callback = function(v) Config.AutoSkills = v end,
  })
  
  FarmSection:AddSlider({
      Title = _0xcK12Ah5C6AP("wBiJwxLf/grfOh5w2jmXKYI3Y19uTVudFaAegY==", 23998),
      Description = _0xcK12Ah5C6AP("AsMuyXYW6qtjonyG+xMw1A1qHOkDmLMeEEeDDxYuNYAwIAHweP9ikAFep6MlC8CCcRBdCR2MqqD7ppFm", 33616),
      Min = 0,
      Max = 5,
      Default = 0.4,
      Rounding = 1,
      Callback = function(v) Config.AutoSkillHold = v end,
  })
  
  FarmSection:AddDropdown({
      Title = _0xcK12Ah5C6AP("+w0GBkgpwFN3FqTSIwEsFrPjDiobhRK+", 38151),
      Description = _0xcK12Ah5C6AP("Yn2V8cvsSnfbo6cPGNcOoUD16A0V0/y47nLabhc9aUW=", 18338),
      Values = { _0xcK12Ah5C6AP("OGeMOK9kF4ZSAYk0wIS1I3LhAhQiGKbfQZAhXl==", 46560), _0xcK12Ah5C6AP("3CAnM9hepOERi+dE", 53044) },
      Default = _0xcK12Ah5C6AP("iwfSikGvOdgYtmKQqcC5E+fhsluLxDEb6Ypnwm==", 58868),
      Callback = function(v) Config.AutoSkillWhen = v end,
  })
  
  FarmSection:AddToggle({
      Title = _0xcK12Ah5C6AP("rXeanu05VB5hUBhW5RzBh6hFDLXCR6qi", 29627),
      Description = _0xcK12Ah5C6AP("IA6ie1Yfj+YLIAr0g/uyk6K0e/GEImFPgJMPgW3TAteQAmuQn/FOg+Ub2r9OQmFe", 29718),
      Default = false,
      Callback = function(v) Config.AutoDrown = v end,
  })
  
  FarmSection:AddToggle({
      Title = _0xcK12Ah5C6AP("OES/lQsDaNmupYokAHdKgE==", 1756),
      Description = _0xcK12Ah5C6AP("ORMasiXbwyj3XBZEMdFuEaPyIW5yC0sUERGLISGEY2FWu05d94rmwwoOGtj1Gw0fO0TD8cZtXqGwmrY+", 12970),
      Default = false,
      Callback = function(v) Config.AutoSun = v end,
  })
  
  FarmSection:AddToggle({
      Title = _0xcK12Ah5C6AP("1AAYG1PWSo/SscyUIVqZtt/vKAyFdmHNutGNyZ==", 46969),
      Description = _0xcK12Ah5C6AP("Mj9IcPC9qPnBNU6qLn/hqqMobO764J7jMjIKSU1zM2q+LSMbTelNL7==", 47526),
      Default = true,
      Callback = function(v) Config.SunAlert = v end,
  })
  
  local SkillTreeSection = FarmTab:AddSection({ Title = _0xcK12Ah5C6AP("fzG1r48BCZGMAJCqeA+YuJkhSBB4jnuH", 38058) })
  local SkillTreeStatus = SkillTreeSection:AddLabel({ Text = _0xcK12Ah5C6AP("X4gpCZ3YdBCqCUE3zvwPKHNfBqEHuToc", 10319), Description = _0xcK12Ah5C6AP("ZcwZuEdzsTFbVmdB8yw2xoFMJvBBZp93", 22401) })
  
  SkillTreeSection:AddToggle({
      Title = _0xcK12Ah5C6AP("Cqo2ltsDiOqRmbXMFj+ZvFKIO76Ep9U8N7XrytSw+FW=", 29329),
      Description = _0xcK12Ah5C6AP("RLNs05dSB5mUSuBB+o7JqNm3Z9g1BivejLYwPbHSZoDeZDKpb3WrPl5oR3TeOiBcNqPXmjCFh4PsGyNozXGDrT7yqLTu0ECEm9BVP6gYjiG=", 19101),
      Default = false,
      Callback = function(v) Config.AutoSkillPoints = v end,
  })
  
  SkillTreeSection:AddToggle({
      Title = _0xcK12Ah5C6AP("rIhhpQoOED0ODCaqlBkrDiOXwq38pp/cHZPWOFt1HpfbLC0lpvSD+o==", 2643),
      Description = _0xcK12Ah5C6AP("EJDEs3E3A/qSe8K9e8FGkETpUequ8JdXh28g8z8Be2CQhTBqG3NH6Eh38z4GUa4WMIEd63bTR+E1A/KQwzpZuMjcEg1/UXQ9EgVDY4==", 47292),
      Default = true,
      Callback = function(v) Config.SkillUnlockSkills = v end,
  })
  
  SkillTreeSection:AddButton({
      Title = _0xcK12Ah5C6AP("wH+rBKIEaMn63xCYa2WPKJVfDCb9mEzwNDRTRHnkfO9=", 32785),
      Description = _0xcK12Ah5C6AP("T51FsfBQffI1Jc1jBwurB9I3RVBpDMdFM1xTBf3g2MBHm+ZDBmwXBmDCP9EQHceGAicTfyC4TcI=", 49571),
      Callback = function()
          task.spawn(function()
              local ok, err = pcall(SpendSkillPoints, true)
              if not ok then
                  CentrixUI:Notify({ Title = _0xcK12Ah5C6AP("K2kqtoMeIdf/jTZZiIPZA+SoaOGXAKLg", 25470), Content = tostring(err), Type = _0xcK12Ah5C6AP("dWOxi+xL4wB5TI1V", 39404), Duration = 5 })
              end
          end)
      end,
  })
  
  local AccessorySection = FarmTab:AddSection({ Title = _0xcK12Ah5C6AP("+g45u6IDDrXHSJAcKDra6J51tthHDAkeS6nLd3ysGBv=", 46077) })
  local AccessoryStatus = AccessorySection:AddLabel({ Text = _0xcK12Ah5C6AP("ZtLOSd6B3j8EFe5Db68EDuatVOjcT2ae", 11993), Description = _0xcK12Ah5C6AP("5XXjebDabDh0o/fN5PL7FHx/TKOmhnwj", 57439) })
  
  AccessorySection:AddButton({
      Title = _0xcK12Ah5C6AP("+dFfat632uI0KG+Af9vuKCz7Susvkp2yYtKH5GvNC+Oae4X7CGFEKCv05Lj=", 52060),
      Description = _0xcK12Ah5C6AP("CuRVLectL9pPVvAks9Srw0X0dHY8axN5CLW0k5IoTWNlQwo1TWkidwEoeL59wJAmkeBbFogLwWXVt+uqfvpmLJRteWE1whOi8JgriY==", 11616),
      Callback = function()
          task.spawn(function()
              local ok, err = pcall(EquipBestAccessories)
              if not ok then
                  AccessoryStatus:SetLabel(_0xcK12Ah5C6AP("AnpWDwcyJd+Xi2kfeh296o==", 41032) .. tostring(err))
              end
          end)
      end,
  })
  
  local EspSection = FarmTab:AddSection({ Title = _0xcK12Ah5C6AP("o0SQqmgxh/GWN1lJ09gFGu==", 61384) })
  
  local ESP_TOGGLES = {
      { key = _0xcK12Ah5C6AP("7w/zF7Cr8BLxRIFbNxOzWx==", 53817), title = _0xcK12Ah5C6AP("J4xvJSqASaZCg2cB", 22789), desc = _0xcK12Ah5C6AP("Rd3TZOpM47TCRVVVkiPGy4smansIZ4dO/byVHUd/d+SKg+r9wqyoFSsXJqHGCdVTsByAW+lAsB4HuOh8", 65045) },
      { key = _0xcK12Ah5C6AP("qNJLDh+M0RJ5clG+Lh42jh==", 2705), title = _0xcK12Ah5C6AP("bphDfbBJf/irmFGG", 7853), desc = _0xcK12Ah5C6AP("xiMERQ79UTD7Z87ujBE1eM9qaJuE20Tb6NqqftvrDxK=", 60135) },
      { key = _0xcK12Ah5C6AP("KBgoFib5FU/vwDhMJTh+18==", 13849), title = _0xcK12Ah5C6AP("ISLCGv+DhMsvs+/A", 6730), desc = _0xcK12Ah5C6AP("TRg2TZ+/YNaS55IfVIFBcK0BDAWyc3+g53xZcIgwYSBs7JextEQyvEgzcJtL61InxWBEpNiEjRBhjkrw", 46745) },
      { key = _0xcK12Ah5C6AP("lrfuMba3Q9dadqzTP3qYDs==", 26262), title = _0xcK12Ah5C6AP("e365sblH7430ulAe", 64846), desc = _0xcK12Ah5C6AP("cUcQTUVgOguCuxKdR8AKRrAztxcACyAveyW7VO==", 21684) },
      { key = _0xcK12Ah5C6AP("a1Lh119UY41+YFCnDd+pyd==", 55123), title = _0xcK12Ah5C6AP("xZsXwNx0O5FuM5XAZqdmsBYSW1isIaB1", 36312), desc = _0xcK12Ah5C6AP("4jTsWWtgaUsF44hfFZ3vrnnvjCs5S4rzrZ9/PfuOWatquOslj5QlGt==", 28449) },
      { key = _0xcK12Ah5C6AP("zDjjBe59PBpgsVeTh1Gj1V0yGwCrN2jG", 36899), title = _0xcK12Ah5C6AP("DUv5uHv3pTlil1azxtF2pd==", 38429), desc = _0xcK12Ah5C6AP("rbe0+AUvrvEslr0AeTZIVJzax30TzrKEOEXjPPq5zVO2lEfBt3uyYvEDAAES8sln", 44155) },
  }
  for _, entry in ipairs(ESP_TOGGLES) do
      EspSection:AddToggle({
          Title = entry.title,
          Description = entry.desc,
          Default = false,
          Callback = function(v) Config[entry.key] = v end,
      })
  end
  
  EspSection:AddSlider({
      Title = _0xcK12Ah5C6AP("iDQf7aKvtyLtJyjs", 19553),
      Description = _0xcK12Ah5C6AP("5+nBJeDZmKOnRtp9QxscQXOYvrxDprhjkSGlcSxXd3hlkZH5z3okcOKxUtpIv77u", 53795),
      Min = 100,
      Max = 3000,
      Default = 700,
      Rounding = 0,
      Callback = function(v) Config.EspRange = v end,
  })
  
  local LocatorSection = FarmTab:AddSection({ Title = _0xcK12Ah5C6AP("USrnIGmFEnY+GjXUV1a0ws==", 38) })
  local LocatorStatus = LocatorSection:AddLabel({ Text = _0xcK12Ah5C6AP("p5CzVoErXxM3nwAiiILVUQ==", 29011), Description = _0xcK12Ah5C6AP("6Lkjub+xzHHRlqXlJJMrNDXeH1PiIhTwHwkC/iUzVVzuVh/tB7dvqIthqbX=", 4207) })
  
  LocatorSection:AddDropdown({
      Title = _0xcK12Ah5C6AP("q1s/VbwCs3CNx5eDX4FUH2==", 23367),
      Description = _0xcK12Ah5C6AP("1h1IrYH8jocyy70ROiTL1hMcoBm0GJW5yr79B1HnVMC=", 15989),
      Values = { _0xcK12Ah5C6AP("jeE9OxIjSJSvsF5K1RIFrxwy46UqTx0P+hxinF==", 32227), _0xcK12Ah5C6AP("HeTfTXGHNI/Hu9xDEb1GHb2UnIYMap+xV9RGIz==", 22939), _0xcK12Ah5C6AP("v5GnJruwdHx8iF04FqxAIHxtNYOzNXzVRiyXFuJgZuG=", 64797), _0xcK12Ah5C6AP("qIhUqgK6OPHujJ3uAEpMIg4OSEq4MoH4JmhAHA==", 60612) },
      Default = _0xcK12Ah5C6AP("jrv2uS9KM+a3amBIgaggG+9GwVHLQz5SnGqhrg==", 9694),
      Callback = function(v)
          Config.LocatorCategory = v
          RefreshLocatorTargets()
      end,
  })
  
  LocatorSection:AddDropdown({
      Title = _0xcK12Ah5C6AP("iIv+PwV3GEGVkm+M", 39704),
      Description = _0xcK12Ah5C6AP("+KMTKt01jWWWlKd/LMY78feB3Qk1KrDScmWUkW==", 20358),
      Values = {},
      Default = _0xcK12Ah5C6AP("", 42795),
      Callback = function(v) Config.LocatorTarget = v end,
  })
  
  LocatorSection:AddButton({
      Title = _0xcK12Ah5C6AP("rechiuSsQ+4SYlSDMYM9Au==", 23568),
      Description = _0xcK12Ah5C6AP("U8jU0eok3dehGUEAUlX7PzbOUECLAADAiPNGkbEDkbeKc/GVaZVOagGkUdbjS7P9yeCwAmNGKfjN7W1M", 50310),
      Callback = function() StartTracking() end,
  })
  
  LocatorSection:AddButton({
      Title = _0xcK12Ah5C6AP("z6e3b1LJfDBjQDcPPTXDLSBxL1c82vxipkgyWx==", 2553),
      Description = _0xcK12Ah5C6AP("8k4EKtUIQow43mz4wnOzehmzCkOflewE5/UQoO==", 40004),
      Callback = function() StopTracking() end,
  })
  
  LocatorSection:AddButton({
      Title = _0xcK12Ah5C6AP("TzbKGST+sM42dF5Q2Ya9GPk7+piqdpan", 31457),
      Description = _0xcK12Ah5C6AP("YBN7C8ODASGhGGsYs6YvwSEc76+D7Gg6sd+3/EsKkd06w1YHe2gmFG0eQNL=", 49894),
      Callback = function() RefreshLocatorTargets() end,
  })
  
  local FishingSection = FarmTab:AddSection({ Title = _0xcK12Ah5C6AP("dzTBuoSKfJ01fs30XpCmCB0EZJOeq8Q7", 14997) })
  local FishingStatus = FishingSection:AddLabel({ Text = _0xcK12Ah5C6AP("lU9b6A2CT3aNnutCITq0KA==", 25372), Description = _0xcK12Ah5C6AP("J8Pl68anCrYZC+9K", 1656) })
  
  FishingSection:AddToggle({
      Title = _0xcK12Ah5C6AP("CR+sNFBMNyOUwzdKB2PXBP==", 3877),
      Description = _0xcK12Ah5C6AP("a8WFN8PCC7XtKUdppnG5Ng+TNcqAYIGU4Eb5AgqtKFRoAvkH2GS4KjwH2FSBK7qPCqqLKkVjO7+m4LnK", 53608),
      Default = false,
      Callback = function(v) Config.AutoFish = v end,
  })
  
  FishingSection:AddToggle({
      Title = _0xcK12Ah5C6AP("Xq6emFMd4QMnrqorbYTB8TKt2GKJrBW4", 7713),
      Description = _0xcK12Ah5C6AP("WBhxdKmzG354GzTRlhdXCXf9IhqrAuGvivnZMb5s8r2gQAMRG9GvseCvuP5=", 3828),
      Default = true,
      Callback = function(v) Config.InstantReel = v end,
  })
  
  local MarketSection = FarmTab:AddSection({ Title = _0xcK12Ah5C6AP("KQLmmwCl3EEqaYLVoqLJGuDX5HhGosgH0oB7GE==", 28890) })
  local MarketLabel = MarketSection:AddLabel({ Text = _0xcK12Ah5C6AP("NOqnS0BBDeAJWgzI", 37805), Description = _0xcK12Ah5C6AP("eZWfHoTDSoXNHmPUwST0nOAzceGTwOrh", 27362) })
  
  MarketSection:AddToggle({
      Title = _0xcK12Ah5C6AP("bx60gJUwQsmmUSctoUe5pY4lBl4O64mqAxGG5UGFXJU=", 26250),
      Description = _0xcK12Ah5C6AP("GlnJsiMZFqVA6HBLpDIKG68PvB4+VN8yQpnYjxMEFHvmEtsHVN4Xd6rx5i2rkqHtjYzsFism6iLqPicuPZgYDef1P6TMK02j", 61983),
      Default = true,
      Callback = function(v) Config.MarketNotify = v end,
  })
  
  local LoggingSection = SettingsTab:AddSection({ Title = _0xcK12Ah5C6AP("PxRxjuWmjutIReR9nuxXNx==", 23211) })
  
  LoggingSection:AddToggle({
      Title = _0xcK12Ah5C6AP("4mbD4QBsH+CoYkkJoSj01RDtrobIon+Ricr8Xm==", 57253),
      Description = _0xcK12Ah5C6AP("5zHxHXHLRK1nhmyLNciERl29ICRziYp80HnB1HL+d4e1523iHq2T6Q3RhmDqDZ1OdcDpNZjRP2jgJ2W/", 63093),
      Default = true,
      Callback = function(v) Config.EnableLog = v end,
  })
  
  LoggingSection:AddInput({
      Title = _0xcK12Ah5C6AP("Q5Ejx56TOJw0NWEsLE6WELl9bSWT2KoxMc6AcE==", 65024),
      Description = _0xcK12Ah5C6AP("WM5GXmNiVqrO2vhpR0avFaUnf0dI2EhePatSYr==", 26177),
      Default = _0xcK12Ah5C6AP("J2L1YCZ8wmLGPOCG", 29249),
      Numeric = true,
      Callback = function(v) Config.HorstWsPort = tonumber(v) or 8765 end,
  })
  
  LoggingSection:AddInput({
      Title = _0xcK12Ah5C6AP("3DyQUroafKM+ICrf0nLjKoaz2nKNu6MFTEUWqE==", 12866),
      Description = _0xcK12Ah5C6AP("zQzyQR8hjbUDg73TcErODr==", 28134),
      Default = _0xcK12Ah5C6AP("JsZ0p8oKBmou6tnG", 37645),
      Numeric = true,
      Callback = function(v) Config.HorstHttpPort = tonumber(v) or 7964 end,
  })
  
  LoggingSection:AddInput({
      Title = _0xcK12Ah5C6AP("w7zYrlq5jNpiNik5tPj1yygLWqzkr5ev4XaBsG==", 46405),
      Description = _0xcK12Ah5C6AP("Rp+kIza5QGJVEVIQUzGvyW2sC52y7rVvCIF0RpcyICsHSFabQ8lkmedhyCJ=", 52022),
      Default = _0xcK12Ah5C6AP("y1e5a15/W/dPIDSt", 31740),
      Numeric = true,
      Callback = function(v) Config.StormHttpPort = tonumber(v) or 8080 end,
  })
  
  local PerfSection = SettingsTab:AddSection({ Title = _0xcK12Ah5C6AP("a7qtTUAj0SirmiGeccAPnW6cFoybcBBw", 48732) })
  
  PerfSection:AddToggle({
      Title = _0xcK12Ah5C6AP("3duKO2lhezbb3HqzGnAky2==", 20364),
      Description = _0xcK12Ah5C6AP("MytS0rM9G1XXWyVjwH1WjylTyl5AWJh1Yqd9cSFAdeC=", 29628),
      Default = true,
      Callback = function(v) Config.AntiAFK = v end,
  })
  
  PerfSection:AddToggle({
      Title = _0xcK12Ah5C6AP("lM1aDfq7GqicFDlBoND6/n==", 23271),
      Description = _0xcK12Ah5C6AP("OkHV4hKnTB+XUHgPUvHgK0wRB2ybHQmLNBr/DZvanSYMFr8xvZvl6mqBH2D=", 19853),
      Default = true,
      Callback = function(v)
          Config.LockFps = v and 30 or nil
          if setfpscap then pcall(function() setfpscap(v and 30 or 240) end) end
      end,
  })
  
  PerfSection:AddToggle({
      Title = _0xcK12Ah5C6AP("pDD3PFwG1u2+t9oDF+wPz3IU1EtoRUL49XcoBDX4sXDf/3ndG3MkJ3==", 1803),
      Description = _0xcK12Ah5C6AP("ISRo2XBI21ECuxsyhRf/67po4GuUWRc02RuCpl9kIXcO2dJh299QPUkL9MJHoHpN2lBnAMBoTaArfBkx", 40459),
      Default = false,
      Callback = function(v)
          Config.Whitescreen = v
          pcall(function() RunService:Set3dRenderingEnabled(not v) end)
      end,
  })
  
  local AboutSection = AboutTab:AddSection({ Title = _0xcK12Ah5C6AP("by4Gxgy+DDLfwHijRtreDcDNrl3Lem2G", 28019) })
  AboutSection:AddParagraph({
      Title = _0xcK12Ah5C6AP("iBNhe/7BEd75Ohez03+FtT1+te+BehuU", 26116),
      Content = _0xcK12Ah5C6AP("pkiIZ6q5Sbm7eLiUaII5uVB0YQNTgGRTeIteYOK1kLCKkIBs8bcOKLcEeLmp3GEhKtC4KTIgAj9LQwmVXvNTSI8Gg+cmWm2EQTQtYjEY3SQplLJupQCRkG0mFMZ9EQWnQjKdkiRP5vR4ejIKxk0F84h8Yam1AIK+5i6IaM8uk4yw3kkvkiNh3LcftQQPQT9JSmIf6k8daKml8DmzR6QMM4iGgrRESnW0EvNx3nmYEvE2IGpK8GCS8bsaXSkU3iWXejKd9VyegV0PgjIca4B+YQB6EKIYYSiFA42fQ3yzkKEe8TkHAQEE5kKEpaRiAD9hKtmbaiRdakI2gnt0", 18604),
  })
  
  AboutSection:AddDivider()
  AboutSection:AddButton({
      Title = _0xcK12Ah5C6AP("0S74tcw4gfKJcPBTKJiGs1YbqZ+JmOjx", 25220),
      Description = _0xcK12Ah5C6AP("HKO/EGk2E2b4Q95U60qdHHDeZV6l4LKQECCdefsFe2fBeWwJK2ARN1fYeWxbj5a1Z2KRMYHzeBw8AzI3QWeTDCgIjFkbWnJI", 53266),
      Callback = function()
          local ok = pcall(function()
              setclipboard(_0xcK12Ah5C6AP("eEwFS6RUoT2kUNvGL/d4LTra6XvREdwECTdfTWMLaTEiEe27Mew4CfA73XdNkijI2V494JA515r=", 54482))
          end)
          CentrixUI:Notify({
              Title = _0xcK12Ah5C6AP("iynv46RYeIF7QjX1Dz8ImA==", 18864),
              Content = ok and _0xcK12Ah5C6AP("E0iwo9yNYUiWy9iXEIpN7RyUHR6QVVfRnQinyVUBw9XNVFU+pxDEI0Ui1VVFnUo2d0tBwygFjVt5T8zVHT+Z+U==", 13383) or _0xcK12Ah5C6AP("rfZvBJR58/jMPYgv8f4rxtj6MHBLeLVFxnZq4t2Ke5j0YHZH2h2Q2B1q8CJwoLJ3", 59687),
              Type = ok and _0xcK12Ah5C6AP("gYFKKWmpKEYKc2cUviATdz==", 16076) or _0xcK12Ah5C6AP("6Mciii8cO+gxMiYf", 15322),
              Duration = 5,
          })
      end,
  })
  
  AboutSection:AddDivider()
  AboutSection:AddParagraph({
      Title = _0xcK12Ah5C6AP("eVKJ57ASDSmrg312ZHmLea==", 54850),
      Content = _0xcK12Ah5C6AP("kOC0hg4xa0e31RU92jAeWdAFW3uCEOLkcXVmpyUfIIbRkRq2kjujMTAMmIkdmuCDi540hCAYdyB5Og8xeLKM1OV0BlkAYQL/IOYxcUMQ5RbWexLpOkF3dgFMIuVzIhK1kxp2CTbg43UUSIsEkt4gck==", 28572),
  })
  
  Window:SelectTab(1)
  
  local function SetClanStatus(text)
      ClanStatus:SetLabel(_0xcK12Ah5C6AP("A/qOeYUR3IScgtEjgcgJcq==", 42068) .. tostring(text))
  end
  
  local function SetStatus(text)
      StatusLabel:SetLabel(_0xcK12Ah5C6AP("GRiwGGu1e2M6cn6RynqM4n==", 28832) .. tostring(text))
  end
  
  local function SendUpdateToManagers(logMessage, isSupreme)
      if not Config.EnableLog then return end
      local cleanMsg = tostring(logMessage):gsub(_0xcK12Ah5C6AP("1ybIOEuyfUuRFXMK", 6901), _0xcK12Ah5C6AP("Ffb9by4bXma=", 21860))
  
      pcall(function()
          if _G.Horst_SetDescription then
              if isSupreme then
                  local sheetJson = HttpService:JSONEncode({
                      Username = username,
                      Rarity = _0xcK12Ah5C6AP("XApEL5QgVNJF1JUm1QiOfNpOfCDcA4IxUW7K/J==", 30039),
                      Status = _0xcK12Ah5C6AP("A/+arx7AeGqMAU9O75yxRf==", 7093),
                      Description = cleanMsg,
                      Time = os.date(_0xcK12Ah5C6AP("pokTCZEX7xNaRyNAEyXJDj1OlLig9yvvDiMMCSA9Bea=", 47673))
                  })
                  _G.Horst_SetDescription(cleanMsg, sheetJson)
              else
                  _G.Horst_SetDescription(cleanMsg)
              end
          end
      end)
  
      pcall(function()
          local wsConnect = (WebSocket and WebSocket.connect) or (syn and syn.websocket and syn.websocket.connect)
          if wsConnect then
              local ok, ws = pcall(function() return wsConnect(_0xcK12Ah5C6AP("4qesc66daAPZVAJWMjs4lFaDIndySVRgoMomH6==", 4816) .. tostring(Config.HorstWsPort)) end)
              if ok and ws then
                  pcall(function()
                      ws:Send(username .. _0xcK12Ah5C6AP("efcdaTb+v7E=", 35766) .. game.JobId)
                      ws:Send(_0xcK12Ah5C6AP("U9yoj+1Xm/QLjXDURQJpu/cw4ICGVcYE", 25106))
                      local payload = string.format(_0xcK12Ah5C6AP("gncxQp4mUgtXmpf3cdWVKkzhwhJpgP9g8Af5Kg450SUHg1cAWSHthC==", 38506), username, cleanMsg, HttpService:JSONEncode({
                          Games = _0xcK12Ah5C6AP("Q/uoROPOnQy=", 31819),
                          Playerdata = { fruits = { cleanMsg }, Weapons = {}, Materials = {}, Accessory = {}, Meelee = {} }
                      }))
                      ws:Send(payload)
                      task.wait(0.15)
                      ws:Close()
                  end)
              end
          end
      end)
  
      pcall(function()
          if httpRequest then
              for _, port in ipairs({ 7963, 7964, Config.HorstHttpPort }) do
                  pcall(function()
                      httpRequest({
                          Url = string.format(_0xcK12Ah5C6AP("TZ3sytkExCicVIXXm2SMOmV9YOSXtP7I829Q0O3mAmMO12Uv1ZnHOYUNOIbAm2tE1FiM1Cly2nIXKOPy1mXP14dk0WU0YGkN1Ok7YnaiKva=", 26518), tostring(port), username),
                          Method = _0xcK12Ah5C6AP("adov9ra/VLGxY/d/", 41261),
                          Headers = { [_0xcK12Ah5C6AP("VHh4O5pKGgtmNXn7VTKi0E10oSlaCfUM", 64437)] = _0xcK12Ah5C6AP("eTj8vTi+Z07KuU/n2q0ByyDHBbxJwHD1WHj4xUReXijvdUNri5Lzi94l2cIwtOiK", 37281) },
                          Body = cleanMsg,
                          Timeout = 1.0
                      })
                  end)
              end
          end
      end)
  
      pcall(function()
          if httpRequest then
              httpRequest({
                  Url = string.format(_0xcK12Ah5C6AP("XPCpm8grWPySWc2NFilVTWIWfDqbgivVLmgMTi1vC76z2iEkcYPkEnc9gxElEhYJaEgCMtjG4iM9EiqAFHg7+g51+vu2FYlWA03gQEqEmPY=", 50622), tostring(Config.StormHttpPort), username),
                  Method = _0xcK12Ah5C6AP("2YBRcg67SbgYo6Mr", 3632),
                  Headers = { [_0xcK12Ah5C6AP("eQgl0VuoQWUcCWX3bGNjSV7o+9aZaunb", 1550)] = _0xcK12Ah5C6AP("86rqPgLbbuyu3F9Dfk3hz68qBUhGbjEwQmRCZn9IKiys3oNf47ujLyBiBFmAV7G/8Y6T2Wy54nG6L6ov", 15273) },
                  Body = HttpService:JSONEncode({
                      account = username,
                      username = username,
                      description = cleanMsg,
                      status = cleanMsg,
                      done = (isSupreme == true)
                  }),
                  Timeout = 2
              })
          end
      end)
  end
  
  local function RequestAccountSwitch(isSupreme, finalMsg)
      SetClanStatus(_0xcK12Ah5C6AP("U9jxE9cA8KUGJNGNUYGriUuUSKyuyKkgxvDtii4GUqDJGO9F0Nbv0U==", 34164))
  
      local cleanMsg = tostring(finalMsg or (isSupreme and _0xcK12Ah5C6AP("eMwEDCho4aXPlhhGYmCZyCTacCgIpReJ", 45750) or _0xcK12Ah5C6AP("Vzk2Y1KEVptJuJAe", 1880))):gsub(_0xcK12Ah5C6AP("DT8tG68Vp1G4xR6M", 51397), _0xcK12Ah5C6AP("i6TeAcSGocO=", 318))
  
      pcall(function()
          if _G.Horst_SetDescription then
              if isSupreme then
                  local sheetJson = HttpService:JSONEncode({
                      Username = username,
                      Rarity = _0xcK12Ah5C6AP("AI/6g4AECEunNGO7Nd55t4QEzq1e9EEnu8+AYO==", 12544),
                      Status = _0xcK12Ah5C6AP("Ws6/fzS4bpLaWB1mNQ3zmB==", 52857),
                      Description = cleanMsg,
                      Time = os.date(_0xcK12Ah5C6AP("G0ce6k2EixTViZdZ6Wwitx4L0iu78xH4RZdfWI16P92=", 29241))
                  })
                  _G.Horst_SetDescription(cleanMsg, sheetJson)
              else
                  _G.Horst_SetDescription(cleanMsg)
              end
          end
      end)
  
      pcall(function()
          local wsConnect = (WebSocket and WebSocket.connect) or (syn and syn.websocket and syn.websocket.connect)
          if wsConnect then
              local ok, ws = pcall(function() return wsConnect(_0xcK12Ah5C6AP("zaIaBj9wBqg9fO9sH2TySlgLQ4jCk9wG9l8FF9==", 23679) .. tostring(Config.HorstWsPort or 8765)) end)
              if ok and ws then
                  local statusMode = isSupreme and _0xcK12Ah5C6AP("cNp+69gVILi6g+bC", 4042) or _0xcK12Ah5C6AP("k6lBbQsgqDYU8TIIHhF2q3==", 37970)
                  local payload = string.format(_0xcK12Ah5C6AP("OKQg+HGvWJ8ANim8rH8YSLKDF0QMFDBCobLN4Y==", 15952), username, statusMode, cleanMsg, HttpService:JSONEncode({
                      Games = _0xcK12Ah5C6AP("lTiYFytUm/e=", 62752),
                      Playerdata = { fruits = { cleanMsg } }
                  }))
                  ws:Send(payload)
                  task.wait(0.15)
                  ws:Close()
              end
          end
      end)
  
      pcall(function()
          if httpRequest then
              for _, port in ipairs({ 7963, 7964, Config.HorstHttpPort }) do
                  pcall(function()
                      httpRequest({
                          Url = string.format(_0xcK12Ah5C6AP("F93dBYdxRQYXQOFhZ2Bv2LTSQyArPNTb7wy1kNyEp9d8n25ILuc/liTfP9dHNlBsnXdNuXTiX2YHuLKqLgcUkNRTQdTaLNR0fzVc7iV7K9T=", 37311), tostring(port), username),
                          Method = _0xcK12Ah5C6AP("9jAoku0JyBuirpLX", 51806),
                          Headers = { [_0xcK12Ah5C6AP("6ajA6au+lgwy0MqG1Ioh1XwDy4gsWAnw", 14192)] = _0xcK12Ah5C6AP("qVAEWEdMD0bKQ0p2QVCf0PjqbHebxakqipYVbhjlTPZl/NlPbrqTPH684FY2/J4q", 27421) },
                          Body = cleanMsg,
                          Timeout = 1.0
                      })
                  end)
              end
          end
      end)
  
      if _G.Horst_AccountChangeDone then
          pcall(function() _G.Horst_AccountChangeDone() end)
      end
  
      pcall(function()
          if httpRequest then
              for _, port in ipairs({ 7963, 7964, Config.HorstHttpPort }) do
                  pcall(function()
                      httpRequest({
                          Url = string.format(_0xcK12Ah5C6AP("OctZI7O+gcXOuZIhaw/3giEnE2lao6CpwwNIexjgo7zKIIqhgwzLWkCXbgG5AYXsUiLZWNtXOgOKzZOMmkvBoulx9YI9k4VU", 32734), tostring(port), username),
                          Method = _0xcK12Ah5C6AP("iEgKKYzCOEayKaWE", 41566),
                          Headers = { [_0xcK12Ah5C6AP("JKDDJzDxlfx2eqLxrMYOeq4QCzxWeMuX", 50953)] = _0xcK12Ah5C6AP("7nSsmtDhkUj6k38T4X5HICpPIELnSM2oaDL6AJ8/7vPfRuIOuMyU61SZmMcEhMQb", 13940) },
                          Body = tostring(cleanMsg),
                          Timeout = 1.0
                      })
                  end)
              end
          end
      end)
  
      pcall(function()
          if httpRequest then
              httpRequest({
                  Url = string.format(_0xcK12Ah5C6AP("UvnOjCooynkZCn0Yk52vm1oVOUmZkqk6C8Ak2boaDdIlwfIiOoCYifIpidomCnmxIfG5Wgdwkfm6oxP1M5KBSOdpSOkbi7KmRfm/y1kzxn2=", 61448), tostring(Config.StormHttpPort or 8080), username),
                  Method = _0xcK12Ah5C6AP("UEv54RMbGAr2cDHG", 23810),
                  Headers = { [_0xcK12Ah5C6AP("CcCgKLB4uQgQWIBQK/U1f/yaaQ8qa4aY", 46994)] = _0xcK12Ah5C6AP("MgF1XGnVyRFBiCVCmnCrlEDK45t9JA+IF6TeAFNGiiub8DeO7UFrTGSjW0ZBX6sSGR167FRpWFSCTsRJ", 6057) },
                  Body = HttpService:JSONEncode({
                      account = username,
                      username = username,
                      description = cleanMsg,
                      done = (isSupreme == true),
                      status = _0xcK12Ah5C6AP("HATmWIEekyHLTPTY2wBmUA==", 2098)
                  }),
                  Timeout = 2
              })
          end
      end)
  
      task.wait(0.2)
  
      pcall(function()
          VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftAlt, false, game)
          VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.F4, false, game)
          VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.F4, false, game)
          VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftAlt, false, game)
      end)
  
      pcall(function()
          if httpRequest then
              httpRequest({
                  Url = _0xcK12Ah5C6AP("xBHrRS7o1BTjVW4z1849+3A1Awg6AHWrQRT3wS70aVSZI67XWgGHUY9ZE8Wu3ZhRhSKl2vWegSWUCSJ+", 24464) .. tostring(username),
                  Method = _0xcK12Ah5C6AP("o32ee/QXki1=", 54509),
                  Timeout = 1
              })
          end
      end)
  
      pcall(function() if kill_process then kill_process() elseif killprocess then killprocess() end end)
      pcall(function() if os and os.exit then os.exit() end end)
      pcall(function() game:Shutdown() end)
  end
  
  local function UniversalClickButton(btn)
      if getgenv().Slayers2_SupremeFound then return end
      if not btn or not btn:IsA(_0xcK12Ah5C6AP("dSJDRSegrSoeOGeR8SQFLr==", 46187)) then return end
      pcall(function()
          local clicked = false
          if getconnections then
              local c1 = getconnections(btn.MouseButton1Click)
              local c2 = getconnections(btn.Activated)
              if (#c1 > 0) or (#c2 > 0) then
                  for _, c in ipairs(c1) do pcall(function() c:Fire() end) end
                  for _, c in ipairs(c2) do pcall(function() c:Fire() end) end
                  clicked = true
              end
          end
          if not clicked and firesignal then
              pcall(function() firesignal(btn.MouseButton1Click) end)
              pcall(function() firesignal(btn.Activated) end)
              clicked = true
          end
          if not clicked then
              local pos = btn.AbsolutePosition
              local sz = btn.AbsoluteSize
              if sz.X > 0 and sz.Y > 0 then
                  VirtualInputManager:SendMouseButtonEvent(pos.X + sz.X / 2, pos.Y + sz.Y / 2, 0, true, game, 0)
                  task.wait(0.01)
                  VirtualInputManager:SendMouseButtonEvent(pos.X + sz.X / 2, pos.Y + sz.Y / 2, 0, false, game, 0)
              end
          end
      end)
  end
  
  local function ClickClaimRewardButton()
      local pgui = LocalPlayer:FindFirstChild(_0xcK12Ah5C6AP("CMX3LUgWMWxmcvS3QnN7lW==", 45982))
      local menuPopups = pgui and pgui:FindFirstChild(_0xcK12Ah5C6AP("Oi+AWYrHAdyA7L0+YW09PI9FAiPuOHVG", 53910))
      if menuPopups then
          for _, desc in ipairs(menuPopups:GetDescendants()) do
              if desc:IsA(_0xcK12Ah5C6AP("2HooE8FBTaO1pHjBkSWjyr==", 3569)) and desc.Visible ~= false then
                  local txt = tostring(desc.Text or _0xcK12Ah5C6AP("", 41006)):upper()
                  local n = tostring(desc.Name or _0xcK12Ah5C6AP("", 9744)):upper()
                  if txt:find(_0xcK12Ah5C6AP("g8hza8CUe9ExExCG", 47390)) or n:find(_0xcK12Ah5C6AP("VMAi181pQU1bXqxo", 16311)) or txt:find(_0xcK12Ah5C6AP("N16GdJtg9NwMU6b9", 48087)) then
                      UniversalClickButton(desc)
                      return true
                  end
              end
          end
      end
      return false
  end
  
  local isHandlingPopups = false
  local function AutoHandlePopupsAndConfirmYes()
      if isHandlingPopups then return end
      isHandlingPopups = true
      pcall(function()
          local pgui = LocalPlayer:FindFirstChild(_0xcK12Ah5C6AP("Q3sy9OIxIbITGWqkfiLIWA==", 41646))
          local menuPopups = pgui and pgui:FindFirstChild(_0xcK12Ah5C6AP("hr1h2NnLZetWqwlyH9NJ1mnsDeIxGerE", 27393))
          if menuPopups then
              for _, pop in ipairs(menuPopups:GetChildren()) do
                  local z = pop:FindFirstChild(_0xcK12Ah5C6AP("8i+XaaiHaB0kKyKbfAQ5aziIB60XGB+gMMDpRe==", 47841), true)
                  if z then
                      for _, f in ipairs(z:GetChildren()) do
                          if f:IsA(_0xcK12Ah5C6AP("SNTx9MmwmjlHqp9Q", 4257)) then
                              local confirmBtn = f:FindFirstChildWhichIsA(_0xcK12Ah5C6AP("Sp9S8s+IDS5Lo2sS8OIdm2==", 878), true)
                              if confirmBtn then
                                  UniversalClickButton(confirmBtn)
                              end
                          end
                      end
                  end
                  local spinner = pop:FindFirstChild(_0xcK12Ah5C6AP("t80juN2huhgEB8+0ArPLDd==", 51443), true)
                  if spinner then
                      local skipBtn = spinner:FindFirstChildWhichIsA(_0xcK12Ah5C6AP("wTMWL0CiMpRkye2IUDiNDnRu66lf3n+K", 863), true)
                      if skipBtn then
                          UniversalClickButton(skipBtn)
                      end
                  end
              end
          end
      end)
      task.wait(0.15)
      isHandlingPopups = false
  end
  
  task.spawn(function()
      pcall(function()
          local pgui = LocalPlayer:WaitForChild(_0xcK12Ah5C6AP("IU7Y+jeSDYWB4VNxdU7hNh==", 45553), 15)
          if not pgui then return end
          local menuPopups = pgui:WaitForChild(_0xcK12Ah5C6AP("XY5hnIoITy46HLGH1LRgBchWBb6M6o5j", 55877), 15)
          if not menuPopups then return end
          menuPopups.ChildAdded:Connect(function()
              task.wait(0.1)
              AutoHandlePopupsAndConfirmYes()
          end)
      end)
  end)
  
  local function SkipLoadingScreen()
      SetClanStatus(_0xcK12Ah5C6AP("2yPqwBJJaySrAoVTrY99K6a1N3P128J5i0Vmahm53GT1Xa1MSYPn8HB4UB9UKoG0", 4582))
      local pgui = LocalPlayer:WaitForChild(_0xcK12Ah5C6AP("wDU5twpvbdBTyF0v0FFNyF==", 1487), 15)
      if not pgui then return end
      local startTime = tick()
      while tick() - startTime < 10 do
          AutoHandlePopupsAndConfirmYes()
          local components = pgui:FindFirstChild(_0xcK12Ah5C6AP("Knj+KD+1xClrKd1/MKmdGkteKjGJChOG", 42084))
          if components and (components:FindFirstChild(_0xcK12Ah5C6AP("EpBwKuBsxU49d8Kx", 47834)) or (components:FindFirstChild(_0xcK12Ah5C6AP("wd8JXSffkSOFXDAv", 57315)) and components.Menu.Visible)) then
              break
          end
          local skipHolder = pgui:FindFirstChild(_0xcK12Ah5C6AP("TSSlmOBmNdT/HuNHld5yNhB+/0tINEXkb7Ql4+BiHyQqIeQsPQGcEQ==", 23251), true)
          if skipHolder then
              for _, btn in ipairs(skipHolder:GetDescendants()) do
                  if btn:IsA(_0xcK12Ah5C6AP("YpY+sAaXPbLghb1lw9AEYY==", 59963)) then
                      UniversalClickButton(btn)
                  end
              end
          end
          task.wait(0.2)
      end
  end
  
  local function EnsureGroupAndRedeem()
      SetClanStatus(_0xcK12Ah5C6AP("wNQssNNHsBzJoxA1kjCwqN1LCjORsIleYOP0LN5sGt7=", 62794))
  
      local TARGET_CODES = Config.Codes or { _0xcK12Ah5C6AP("8adZoV5O8buJkauDyKkd5G==", 60260), _0xcK12Ah5C6AP("4ScZVYtALhxeLih1AIbO8t==", 8851) }
  
      task.spawn(function()
          pcall(function()
              local comm = ReplicatedStorage:FindFirstChild(_0xcK12Ah5C6AP("ms1XKGpseC1QSjCaeyGtWdajGg7X6dziKAGt2C==", 28092))
              local sc = comm and comm:FindFirstChild(_0xcK12Ah5C6AP("DLDvE4UYZhNTjMPmedURlQBUYm6TEFBOfFH7Eh==", 51055))
              local signals = sc and sc:FindFirstChild(_0xcK12Ah5C6AP("8okUeZoQaQokuhSfMYm71S==", 41176))
              local sf = signals and signals:FindFirstChild(_0xcK12Ah5C6AP("7LsPRlsAnhOBjGNibPFLUIlo8liI8/wnoTSywI==", 7263))
              local remoteFunc = (sf and sf:IsA(_0xcK12Ah5C6AP("tHZMLglTycx9shTacH0ODs6AkHzq3BgmyPlzQg==", 11842)) and sf) or (sf and sf:FindFirstChild(_0xcK12Ah5C6AP("IbNbpcA19bsCFs5pTgCuF7==", 19903)) and sf.Function:IsA(_0xcK12Ah5C6AP("P8bpmxUVQbaLz/UmWR+ysNX/ss+7C4W5uYGn02==", 48634)) and sf.Function)
  
              local SignalFuncModule = nil
              pcall(function()
                  SignalFuncModule = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction)
              end)
  
              for _, TARGET_CODE in ipairs(TARGET_CODES) do
                  if remoteFunc then
                      pcall(function()
                          remoteFunc:InvokeServer(_0xcK12Ah5C6AP("eUMUhL79heCloAAKsT0tg8K4Gl9Tiz3E", 26964), TARGET_CODE)
                      end)
                  end
                  if SignalFuncModule and SignalFuncModule.ToServer then
                      pcall(function()
                          SignalFuncModule.ToServer(_0xcK12Ah5C6AP("V9dTfmLJ9fVErL7an0dNfuNxgxn5t7i5", 49261), TARGET_CODE)
                      end)
                  end
                  task.wait(0.4)
              end
          end)
      end)
  
      task.wait(1.0)
      return true
  end
  
  local function OpenCustomizeMenu()
      SetClanStatus(_0xcK12Ah5C6AP("+1QP2CUNMYh/+5UDic3XCkZtQSC16HaHIS0DYCJ+QRCo2OyoDYD8+wyDIwQf+RrS", 2060))
      local pgui = LocalPlayer:WaitForChild(_0xcK12Ah5C6AP("O1fziS1oiTxGF3AabuSyv1==", 9581), 15)
      if not pgui then return false end
      local components = pgui:WaitForChild(_0xcK12Ah5C6AP("lWYqsx5LLlDZWixB5tCMjXuGTB5Dq37N", 17481), 15)
      if not components then return false end
  
      local function IsInCustomize()
          local body = components:FindFirstChild(_0xcK12Ah5C6AP("y6IzRM26ioTYdkW0", 55712))
          local af = body and body:FindFirstChild(_0xcK12Ah5C6AP("EgGsJ/mKOWEpK3V9ijQ+NP+tFoLdtP9o", 59644))
          local menu = components:FindFirstChild(_0xcK12Ah5C6AP("BC6XmJuOs86CC1XO", 12860))
          return (af and af.Visible ~= false and af:FindFirstChild(_0xcK12Ah5C6AP("NWglq6+B49TwgaByP38WlMi6+NCVDUpfIcYTrB==", 33335), true) ~= nil) and (not menu or menu.Visible == false)
      end
  
      if IsInCustomize() then return true end
  
      local startTime = tick()
      while tick() - startTime < 12 do
          AutoHandlePopupsAndConfirmYes()
          local menu = components:FindFirstChild(_0xcK12Ah5C6AP("wuUxdIrZwdlfkdfG", 23320))
          if menu then
              local content = menu:FindFirstChild(_0xcK12Ah5C6AP("Ly2Hj6ywV52q5d47E59c/t==", 41560))
              local codesFrame = content and content:FindFirstChild(_0xcK12Ah5C6AP("xDVgQ5PCM5jt1ffC", 58904))
              if codesFrame and codesFrame.Visible then
                  codesFrame.Visible = false
              end
              local presenter = menu:FindFirstChild(_0xcK12Ah5C6AP("VHJS+iaTiBFWGxFrMv3O+OboF9azSnT2VF/dHC==", 25849)) and menu.OptionsHolder:FindFirstChild(_0xcK12Ah5C6AP("u1udHUmXOEkabhkT4Cm7y/bEfQQgQzSfaMNzvtOuCzBfu+u5QuDa2Q==", 52846))
              local btn = presenter and (presenter:FindFirstChildWhichIsA(_0xcK12Ah5C6AP("LwArFpNxTSnxFEorf6gdVE==", 14291), true) or (presenter:IsA(_0xcK12Ah5C6AP("MliwjAmSi97ttSgIduh++9==", 56567)) and presenter) or presenter:FindFirstChild(_0xcK12Ah5C6AP("XQ8z9we29MFyCwJe", 31289)))
              if not btn then
                  for _, desc in ipairs(menu:GetDescendants()) do
                      if (desc:IsA(_0xcK12Ah5C6AP("PBRe+B4SF+lodVWPNPfzAP==", 64969)) or desc:IsA(_0xcK12Ah5C6AP("6VbCkYGM5cP26sPEzCU1wqAQMDEPSqu8", 25710))) and desc.Visible ~= false then
                          if tostring(desc.Text or _0xcK12Ah5C6AP("", 13264)):upper():find(_0xcK12Ah5C6AP("8tLHvuHUXRjtysUFlADEsL==", 18674)) then
                              btn = (desc:IsA(_0xcK12Ah5C6AP("XKNnYeSNLegzIwRKfmQqWd==", 44798)) and desc) or desc:FindFirstAncestorWhichIsA(_0xcK12Ah5C6AP("1z+WH4rXaTpKFUtINt8PFi==", 51047)) or desc.Parent
                              break
                          end
                      end
                  end
              end
              if btn then UniversalClickButton(btn) end
          end
          if IsInCustomize() then return true end
          task.wait(0.3)
      end
      return IsInCustomize()
  end
  
  local function StartAutoSpinLoop()
      AutoHandlePopupsAndConfirmYes()
  
      local pData = ReplicatedStorage:WaitForChild(_0xcK12Ah5C6AP("DadZm+HmT52mYTL5HyLxuTLwgaEUOJ0KtF5bOL==", 17103), 15)
          and ReplicatedStorage.Player_Service:WaitForChild(_0xcK12Ah5C6AP("XSuO+DhPGxs8dK6h", 31508), 15)
          and ReplicatedStorage.Player_Service.Data:WaitForChild(username, 15)
  
      if not pData then return end
  
      local waitDataTime = tick()
      local currentClan = _0xcK12Ah5C6AP("kbdGZV4sLpxBB6RqJUiEJh==", 18481)
      local currentTier = _0xcK12Ah5C6AP("UlKORBxoDgZuRj+F", 41116)
      while tick() - waitDataTime < 10 do
          currentClan = getCurrentClan(pData)
          if currentClan ~= _0xcK12Ah5C6AP("A4fI2Rat2F7IJqwH2eO66e==", 48540) and currentClan ~= _0xcK12Ah5C6AP("", 42197) and currentClan ~= _0xcK12Ah5C6AP("qIQvKvCUOSLZr2qt", 25154) then break end
          task.wait(0.25)
      end
      currentTier = select(1, getClanRarity(currentClan))
  
      if currentTier == Config.TargetRarity or table.find(Config.TargetClans, currentClan) then
          local logMsg = string.format(_0xcK12Ah5C6AP("6NqgobDIooO5QP1GRufLMaHCp1TIRseIPVSaTW+8Ie41QVjsDlbRUaCZSCj0RofCYu+wMa0WoK01SZ9y", 43086), currentClan)
          SetClanStatus(_0xcK12Ah5C6AP("4BOZld9ZJO9ZDTrbdTBp490SNCNtWe9XjiPcpd5iW978cH9sDO3DLLjAALm5mOt+N+VjBc7Uldg1B5jysAwEXdLtu9LPUum4", 52323))
          SendUpdateToManagers(logMsg, true)
          if Config.CloseGameOnDone then RequestAccountSwitch(true, logMsg) end
          return
      end
  
      SetClanStatus(_0xcK12Ah5C6AP("DCwbIdWiKPLObuC9LbWKeDzzeUr2buwhy5399qZgeWFd4UFbypkwnd==", 7597))
      local spinsLeft = 0
      for _ = 1, 15 do
          spinsLeft = getCurrentSpins(pData)
          if spinsLeft > 0 then break end
          ClickClaimRewardButton()
          task.wait(0.4)
      end
  
      if spinsLeft <= 0 then
          pcall(function()
              local SignalFunc = require(ReplicatedStorage.Communication.ServerAndClient.Signals.SignalFunction)
              if SignalFunc and SignalFunc.ToServer then
                  for _, c in ipairs(Config.Codes or { _0xcK12Ah5C6AP("yOe6gMwLwT8XGUx1fTtLgM==", 53146), _0xcK12Ah5C6AP("+fVSWEOXSAj4QU90+3PFcm==", 50808) }) do
                      pcall(SignalFunc.ToServer, _0xcK12Ah5C6AP("6AsnH1rtEpVEjXtieClQyKlFltRVEXk/", 20851), c)
                      task.wait(0.25)
                  end
              end
          end)
          task.wait(0.6)
          spinsLeft = getCurrentSpins(pData)
      end
  
      if spinsLeft <= 0 then
          local logMsg = string.format(_0xcK12Ah5C6AP("EYodAWZ3ewGYpAg6JIWmALx3M3TYU+17pHb7nWz41QsIAL1PfISjk+AprIvjCVeF", 3872), currentClan, currentTier)
          SetClanStatus(_0xcK12Ah5C6AP("EYHCVWichnTTbqkjTJTBhQDetmoQhP+iXnTsDgW6hmVBsP+PUFfjjcgR7AixbpQd", 43523))
          SendUpdateToManagers(logMsg, false)
          if Config.CloseGameOnSalt then RequestAccountSwitch(false, logMsg) end
          return
      end
  
      local pgui = LocalPlayer.PlayerGui
      local avatarFrames = pgui.Components:WaitForChild(_0xcK12Ah5C6AP("e4uwVgECyxHLFz1S", 35095), 10):WaitForChild(_0xcK12Ah5C6AP("/FyRR2p3N2Vc/XUuRvVTYi1rA0tvFi7I", 53955), 10)
      local spinningFrame = avatarFrames:FindFirstChild(_0xcK12Ah5C6AP("BZugnCXsFcqgBrNzN18PuTZSBtJ68FlpK6N51G==", 465), true)
      if not spinningFrame then return end
  
      local btn = nil
      if spinningFrame:FindFirstChild(_0xcK12Ah5C6AP("idE0NhEEmjASOjBWwAR9TA==", 18228)) and spinningFrame.Spinner:FindFirstChild(_0xcK12Ah5C6AP("0alZHBfAJYIVC4Kj", 6845)) and spinningFrame.Spinner.Holder:FindFirstChild(_0xcK12Ah5C6AP("w20XohpMgFhjglI7Ttr+TCmA4Rr4hZY2", 17215)) then
          btn = spinningFrame.Spinner.Holder.SpinButton:FindFirstChildWhichIsA(_0xcK12Ah5C6AP("KTFF85HUD2MQa5FBalLOKW==", 60136), true) or spinningFrame.Spinner.Holder.SpinButton
      end
      if not btn then
          local spHolder = spinningFrame:FindFirstChild(_0xcK12Ah5C6AP("S+5VyYI9S1C9cXLIDGXrMIDYEY7+5uQ5", 12918), true)
          btn = spHolder and (spHolder:FindFirstChildWhichIsA(_0xcK12Ah5C6AP("Yny5T4BHaE51O5PEPYSzvA==", 48814), true) or spHolder)
      end
      if not btn then return end
  
      SendUpdateToManagers(string.format(_0xcK12Ah5C6AP("s7yACeSQoVtmA/8EuAy1mLcw+WQ8+C8SsjcPAIAuC2R9BaAkiAJSs/cmwIJz+aHAtIS9sESViTaQWBo4hBkmmj==", 62660), currentClan, currentTier, spinsLeft), false)
      SetClanStatus(_0xcK12Ah5C6AP("KspJEbYtKqhhKX9ooABLix13L9eY+Ote", 54144))
  
      local isSupremeWon = false
      local rollCount = 0
      local lastLogTime = tick()
      local consecutiveNoDrop = 0
  
      local slot = getSlotData(pData)
      local clanValObj = slot and slot:FindFirstChild(_0xcK12Ah5C6AP("tgAXW11eTEUvT5Mc", 35185))
      if clanValObj and clanValObj:IsA(_0xcK12Ah5C6AP("jKhXsPYrswr/MYLBH6o/s4==", 6895)) then
          clanValObj:GetPropertyChangedSignal(_0xcK12Ah5C6AP("FuJ5WWsZnI1g2XiU", 37429)):Connect(function()
              local c = tostring(clanValObj.Value)
              local t = select(1, getClanRarity(c))
              if t == Config.TargetRarity or table.find(Config.TargetClans, c) then
                  getgenv().Slayers2_SupremeFound = true
                  isSupremeWon = true
                  currentClan = c
                  currentTier = t
                  pcall(function()
                      if btn then
                          btn.Active = false
                          btn.Visible = false
                      end
                  end)
              end
          end)
      end
  
      while true do
          if not getgenv().CentrixAutoClanRunning then break end
          if getgenv().Slayers2_SupremeFound or isSupremeWon then
              isSupremeWon = true
              break
          end
  
          spinsLeft = getCurrentSpins(pData)
          currentClan = getCurrentClan(pData)
          currentTier = select(1, getClanRarity(currentClan))
  
          if currentTier == Config.TargetRarity or table.find(Config.TargetClans, currentClan) then
              getgenv().Slayers2_SupremeFound = true
              isSupremeWon = true
              pcall(function() if btn then btn.Active = false btn.Visible = false end end)
              break
          end
  
          local isInsufficient = false
          pcall(function()
              if btn then
                  if btn.Text and btn.Text:lower():find(_0xcK12Ah5C6AP("YPrIK2Ck8Kix42ooU3CuY1Qwa1VXKEoa", 3508)) then isInsufficient = true end
                  if btn.Parent then
                      for _, d in ipairs(btn.Parent:GetDescendants()) do
                          if (d:IsA(_0xcK12Ah5C6AP("br/Y6nKSjuTPMYrbM1idjr==", 58354)) or d:IsA(_0xcK12Ah5C6AP("2LcANBquNYg7u3lrdLtnuBbkdmdor0GE", 45385))) and d.Text:lower():find(_0xcK12Ah5C6AP("VggKbj/NgBiM5KEnSK/FUzKb6ynnT9TO", 14622)) then
                              isInsufficient = true
                              break
                          end
                      end
                  end
              end
          end)
  
          if spinsLeft <= 0 or isInsufficient then
              spinsLeft = 0
              break
          end
  
          if consecutiveNoDrop >= 6 then
              local checkAgain = getCurrentSpins(pData)
              if checkAgain <= 0 then
                  spinsLeft = 0
                  break
              else
                  consecutiveNoDrop = 0
                  if spinningFrame then
                      local newBtn = spinningFrame:FindFirstChild(_0xcK12Ah5C6AP("PeGkytiqCgN5GV3lUKgqWy+60f4LS2SA", 43734), true)
                      if newBtn then
                          btn = newBtn:FindFirstChildWhichIsA(_0xcK12Ah5C6AP("TNU8dbXFtnTnJ/o+iBXAi3==", 16269), true) or newBtn
                      end
                  end
                  task.wait(0.4)
              end
          end
  
          if tick() - lastLogTime >= 3.5 then
              lastLogTime = tick()
              SendUpdateToManagers(string.format(_0xcK12Ah5C6AP("jpBBgI1o21i7CWOL8SyR8WWFMGonGVF4A8DlYS1gM1oeySkgk7+mGmdrWtTsyz+Jc8SXDVu2A9bdCSCIK7p4qp==", 49958), currentClan, currentTier, spinsLeft), false)
              SetClanStatus(string.format(_0xcK12Ah5C6AP("x3gRl7nMk5SJMqJmeshajF+uftKfbxJSktNfrjK12cOVM94JkcksxQSilBR3PtGpahP3r8WK7jPFZtZo", 54889), currentClan, spinsLeft))
          end
  
          AutoHandlePopupsAndConfirmYes()
  
          local beforeSpins = spinsLeft
          local beforeClan = currentClan
  
          if getgenv().Slayers2_SupremeFound or isSupremeWon then break end
  
          UniversalClickButton(btn)
          rollCount = rollCount + 1
  
          local waitSpin = tick()
          local dropped = false
          while tick() - waitSpin < 0.75 do
              AutoHandlePopupsAndConfirmYes()
              local nowSpins = getCurrentSpins(pData)
              local nowClan = getCurrentClan(pData)
              local nowTier = select(1, getClanRarity(nowClan))
  
              if nowTier == Config.TargetRarity or table.find(Config.TargetClans, nowClan) then
                  getgenv().Slayers2_SupremeFound = true
                  isSupremeWon = true
                  currentClan = nowClan
                  currentTier = nowTier
                  pcall(function() if btn then btn.Active = false btn.Visible = false end end)
                  break
              end
  
              if nowSpins < beforeSpins or nowClan ~= beforeClan or nowSpins == 0 then
                  dropped = true
                  break
              end
              task.wait(0.02)
          end
  
          if getgenv().Slayers2_SupremeFound or isSupremeWon then
              isSupremeWon = true
              break
          end
  
          if not dropped then
              consecutiveNoDrop = consecutiveNoDrop + 1
              task.wait(0.06)
          else
              consecutiveNoDrop = 0
              task.wait(math.max(0.1, tonumber(Config.SpinDelay) or 0.25))
          end
      end
  
      task.wait(0.2)
      currentClan = getCurrentClan(pData)
      currentTier = select(1, getClanRarity(currentClan))
      spinsLeft = getCurrentSpins(pData)
  
      local finalLog = _0xcK12Ah5C6AP("", 60108)
      if isSupremeWon or currentTier == Config.TargetRarity or table.find(Config.TargetClans, currentClan) then
          finalLog = string.format(_0xcK12Ah5C6AP("G1l1SvJRWBSKgXZtHoZANJcu90OnYWBvsGExt01DS0ZOVccLB0oXsbMMWbapE3E3WWZ0y/1/EFKLESlf", 4864), currentClan)
          SetClanStatus(_0xcK12Ah5C6AP("lbtVb7/4iX8cE4NfcqY6fgHji7cvAQNRR1taLddY3dcZa4ZRiWPNHZdufBl8fztqXDdYTDUPTsOKasXm", 53527))
          SendUpdateToManagers(finalLog, true)
          if Config.CloseGameOnDone then RequestAccountSwitch(true, finalLog) end
      else
          finalLog = string.format(_0xcK12Ah5C6AP("0UKlyQmLZy7WWuONal2Ymo+eN0OHsgo2OCUPybHiQkPqOgGUbCdgxtWmsSK8KxSw", 32340), currentClan, currentTier)
          SetClanStatus(_0xcK12Ah5C6AP("26yxLPFylCQ6jfRE25eMqDudvcFEB7RQllaNXD1f26FgMyF6Rnx5qlQMXz7nM6aQ", 49781))
          SendUpdateToManagers(finalLog, false)
          if Config.CloseGameOnSalt then RequestAccountSwitch(false, finalLog) end
      end
  end
  
  task.spawn(function()
      pcall(function()
          local lp = LocalPlayer or Players.PlayerAdded:Wait()
          local pgui = lp:WaitForChild(_0xcK12Ah5C6AP("a84jmm4qg84UanUKU+dfaU==", 55358), 25)
          if not pgui then return end
          for _ = 1, 60 do
              local skipHolder = pgui:FindFirstChild(_0xcK12Ah5C6AP("D+gkzmgvV8Yfbt8an6DCC6eWgkDw7WsdChqYH+cmvqxmCGVUHJU578==", 649), true)
              if skipHolder then
                  for _, btn in ipairs(skipHolder:GetDescendants()) do
                      if btn:IsA(_0xcK12Ah5C6AP("wfgqs5g/jSJ6CSSKA5ZoIS==", 21567)) then
                          pcall(function()
                              for _, c in ipairs(getconnections(btn.MouseButton1Click)) do c:Fire() end
                              for _, c in ipairs(getconnections(btn.Activated)) do c:Fire() end
                              if firesignal then
                                  firesignal(btn.MouseButton1Click)
                                  firesignal(btn.Activated)
                              end
                          end)
                      end
                  end
              end
              local comps = pgui:FindFirstChild(_0xcK12Ah5C6AP("Jsz03LRSuFj9NHW5N7kVj081SQSluuDu", 18561))
              if comps and (comps:FindFirstChild(_0xcK12Ah5C6AP("f/bpKdp8ZddVYj8Q", 18420)) or comps:FindFirstChild(_0xcK12Ah5C6AP("yEJfYfVfFsV66fo1saA2OxJx8HUus0Rz", 20482), true)) then
                  break
              end
              task.wait(0.15)
          end
      end)
  end)
  
  local function guiParent()
      local ok, parent = pcall(function()
          return (gethui and gethui()) or CoreGui
      end)
      if ok and parent then return parent end
      return LocalPlayer:WaitForChild(_0xcK12Ah5C6AP("bWtzCAj/KWwK0tchpZNfIK==", 17583))
  end
  
  local espHolder = Instance.new(_0xcK12Ah5C6AP("ZiBhFN+3l1Uqa1FO", 4600))
  espHolder.Name = _0xcK12Ah5C6AP("RYI0L9nGCPFqRQO7mqe/9nkKCmGhqOGp", 39445)
  espHolder.Parent = guiParent()
  
  local espTags = {}
  local espPass = 0
  
  local ESP_COLORS = {
      mobs = Color3.fromRGB(255, 150, 90),
      bosses = Color3.fromRGB(235, 64, 96),
      npcs = Color3.fromRGB(110, 200, 255),
      chests = Color3.fromRGB(255, 214, 90),
      loot = Color3.fromRGB(150, 255, 150),
      players = Color3.fromRGB(255, 255, 255),
  }
  local ESP_CAPS = { mobs = 40, bosses = 12, npcs = 30, chests = 30, loot = 30, players = 30 }
  local CLOSED_STATES = { Opening = true, Opened = true, Despawned = true }
  local localUserId = LocalPlayer.UserId
  
  local function espTag(key, adornee, text, color)
      local entry = espTags[key]
      if not entry then
          local gui = Instance.new(_0xcK12Ah5C6AP("DnS8GHQgd7g7OArHXvjnGI6IESGKd3OH", 34310))
          gui.AlwaysOnTop = true
          gui.LightInfluence = 0
          gui.ResetOnSpawn = false
          gui.Size = UDim2.fromOffset(190, 56)
          gui.StudsOffset = Vector3.new(0, 3, 0)
          local label = Instance.new(_0xcK12Ah5C6AP("HXLO+gFqVFLThKWrCs+LCw==", 24566))
          label.BackgroundTransparency = 1
          label.Size = UDim2.fromScale(1, 1)
          label.Font = Enum.Font.GothamBold
          label.TextSize = 13
          label.TextStrokeTransparency = 0.4
          label.TextWrapped = true
          label.Parent = gui
          entry = { gui = gui, label = label }
          espTags[key] = entry
          gui.Parent = espHolder
      end
      entry.seen = espPass
      if entry.gui.Adornee ~= adornee then
          entry.gui.Adornee = adornee
      end
      entry.gui.MaxDistance = Config.EspRange
      entry.label.Text = text
      entry.label.TextColor3 = color
  end
  
  local function espSweep()
      for key, entry in pairs(espTags) do
          if entry.seen ~= espPass then
              entry.gui:Destroy()
              espTags[key] = nil
          end
      end
  end
  
  local function espHealth(humanoid)
      return string.format(_0xcK12Ah5C6AP("lUjvPb1dQ5Ebu/BVNuzXMdjjnVx8lzm0", 49627), math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
  end
  
  local function espDistance(a, b)
      return (b.Position - a.Position).Magnitude
  end
  
  local function espShow(category, candidates)
      table.sort(candidates, function(a, b) return a.distance < b.distance end)
      for i = 1, math.min(#candidates, ESP_CAPS[category]) do
          local c = candidates[i]
          espTag(c.key, c.part, string.format(_0xcK12Ah5C6AP("pf84IkE++ocEXfKc+U0/7kUPAbcWtA22", 30379), c.text, math.floor(c.distance)), ESP_COLORS[category])
      end
  end
  
  local function findRegionRoot()
      return workspace:FindFirstChild(_0xcK12Ah5C6AP("RKWbxySdoMWUfVoEkeGUUW==", 16584)) and workspace.Humanoids:FindFirstChild(_0xcK12Ah5C6AP("FYmFzSGgM9RUWpshGIuiTQ==", 28164))
  end
  
  local function espScanMobs(root)
      local wantMobs = Config.EspMobs
      local wantBosses = Config.EspBosses
      if not (wantMobs or wantBosses) then return end
      local regionRoot = findRegionRoot()
      if not regionRoot then return end
      local mobs, bosses = {}, {}
      for _, region in ipairs(regionRoot:GetChildren()) do
          local active = region:FindFirstChild(_0xcK12Ah5C6AP("VvJ0H/ZkRgS3PiANaFVef1fka9ajWB14", 14699))
          for _, folder in ipairs(active and active:GetChildren() or {}) do
              local rig = folder:FindFirstChild(folder.Name)
              if rig then
                  local part = rig:FindFirstChild(_0xcK12Ah5C6AP("EYMLKe1QIOn6OvH1PS9e6vpzkoaSA8SHoZaOIlkCIAA=", 16518))
                  local humanoid = rig:FindFirstChildOfClass(_0xcK12Ah5C6AP("AKcjNEZRAzAcIfDrlohoNo==", 47748))
                  if part and humanoid and humanoid.Health > 0 then
                      local d = espDistance(root, part)
                      if d <= Config.EspRange then
                          if folder:FindFirstChild(_0xcK12Ah5C6AP("ol5/bruPPrCmPS2fJGa9y2==", 15563)) then
                              if wantBosses then
                                  bosses[#bosses + 1] = { key = rig, part = part, distance = d, text = rig.Name .. _0xcK12Ah5C6AP("C7H0WZl2m0V=", 52065) .. espHealth(humanoid) }
                              end
                          elseif wantMobs and rig:GetAttribute(_0xcK12Ah5C6AP("6Y9whlQQAB2xfVUC", 28423)) == true then
                              mobs[#mobs + 1] = { key = rig, part = part, distance = d, text = rig.Name .. _0xcK12Ah5C6AP("Vl+WNEmU3dX=", 52534) .. espHealth(humanoid) }
                          end
                      end
                  end
              end
          end
      end
      espShow(_0xcK12Ah5C6AP("kDLTPVSQEdh7foSp", 20495), mobs)
      espShow(_0xcK12Ah5C6AP("rCUAeRUMmAXF7fnA", 3394), bosses)
  end
  
  local function espScanNpcs(root)
      if not Config.EspNpcs then return end
      local debree = workspace:FindFirstChild(_0xcK12Ah5C6AP("uR4kioPzK6CInffl", 57344))
      local regions = debree and debree:FindFirstChild(_0xcK12Ah5C6AP("5vDOxOAeHySqxCIjUAqrR0==", 58186))
      local list = {}
      for _, region in ipairs(regions and regions:GetChildren() or {}) do
          local stationary = region:FindFirstChild(_0xcK12Ah5C6AP("L8QQO6sasE0shD1wDdQ99qqoH6AWV6VNFDojPw==", 13419))
          for _, model in ipairs(stationary and stationary:GetChildren() or {}) do
              local part = model:IsA(_0xcK12Ah5C6AP("rOfdkJF9oKj4gqj4", 30234)) and model:FindFirstChild(_0xcK12Ah5C6AP("mblhND/MtYIuIWvfQy2JaXHgz/I6aN6d0n8bMFsEARS=", 27896))
              if part then
                  local d = espDistance(root, part)
                  if d <= Config.EspRange then
                      list[#list + 1] = { key = model, part = part, distance = d, text = model.Name }
                  end
              end
          end
      end
      espShow(_0xcK12Ah5C6AP("uDG+7m7MHWs9Jajd", 33617), list)
  end
  
  local function espScanChests(root)
      if not Config.EspChests then return end
      local folder = workspace:FindFirstChild(_0xcK12Ah5C6AP("4gF8YyKmY5KvyyDS", 62702))
      local list = {}
      for _, model in ipairs(folder and folder:GetChildren() or {}) do
          local state = model:GetAttribute(_0xcK12Ah5C6AP("udgoMe+dejmpGKI9tapgukaIOa8QOeoa", 59334))
          if model:IsA(_0xcK12Ah5C6AP("Vw73ZG8WdfBG+j5b", 57200)) and model:GetAttribute(_0xcK12Ah5C6AP("9Ybvfi9SMw9pDjFObyl3PD==", 56687)) ~= nil and model:GetAttribute(_0xcK12Ah5C6AP("yk0TfPSJ8xL5mSFc", 7292)) ~= true and not CLOSED_STATES[state] then
              local part = model:FindFirstChild(_0xcK12Ah5C6AP("FmjO+zcFBjjBY2NlgjLaSO==", 3493)) or model.PrimaryPart or model:FindFirstChildWhichIsA(_0xcK12Ah5C6AP("sTUhCEU+JeSWABcHjdYKFw==", 56122), true)
              if part and part:IsA(_0xcK12Ah5C6AP("DzMLNMUQNFHQU8StyBFA2F==", 65001)) then
                  local d = espDistance(root, part)
                  if d <= Config.EspRange then
                      local name = tostring(model:GetAttribute(_0xcK12Ah5C6AP("0DULgxumYxXsYh+IdrMY0d==", 56363)) or model.Name)
                      list[#list + 1] = { key = model, part = part, distance = d, text = name .. (state == _0xcK12Ah5C6AP("tSA1RnwEiS0dAr35", 60471) and _0xcK12Ah5C6AP("+Pd5qPcxzOl1fOb5fnEWKy9cv1TMyeuX", 23385) or _0xcK12Ah5C6AP("", 64983)) }
                  end
              end
          end
      end
      espShow(_0xcK12Ah5C6AP("BUyqVUSBrW4hUNeA", 54845), list)
  end
  
  local function isMyDrop(drop)
      local owner = drop:GetAttribute(_0xcK12Ah5C6AP("bTMvUVn2UTUPXQDeoDDaHFMj2FkvXFDL6b4xjb==", 17563))
      if typeof(owner) == _0xcK12Ah5C6AP("S/9+SMFPDMKohMzm", 9183) and owner ~= localUserId then return false end
      local reserved = drop:GetAttribute(_0xcK12Ah5C6AP("iOhqoOn/iu4BC/tKAZTrm3OCNj6bAbppJMOVbh==", 53661))
      if typeof(reserved) == _0xcK12Ah5C6AP("BaMjDsMDqvuAN4Pn", 2921) and not string.find(reserved, _0xcK12Ah5C6AP("g83iGTX9wvM=", 26964) .. localUserId .. _0xcK12Ah5C6AP("Xu2hoUlTqaa=", 30573), 1, true) then
          return false
      end
      return drop:GetAttribute(_0xcK12Ah5C6AP("lFD+VYSn+Ep0lNuP2M7ZpNURCYeYFD9+pSH0gu==", 34393)) == nil
  end
  
  local function espScanLoot(root)
      if not Config.EspLoot then return end
      local list = {}
      for _, drop in ipairs(CollectionService:GetTagged(_0xcK12Ah5C6AP("VNZSFNkzwPWkGZS3gnDyoO==", 13768))) do
          if drop:IsA(_0xcK12Ah5C6AP("VdqxlwGaO1B5+NYYit2Yf/==", 65005)) and drop.Parent and isMyDrop(drop) then
              local d = espDistance(root, drop)
              if d <= Config.EspRange then
                  local name = drop:GetAttribute(_0xcK12Ah5C6AP("OlgjLz+PSBXvOPdVPhjuFb==", 14089)) or drop:GetAttribute(_0xcK12Ah5C6AP("6GKEg5qQgYAgQiOJ", 14904)) or drop.Name
                  list[#list + 1] = { key = drop, part = drop, distance = d, text = tostring(name) }
              end
          end
      end
      espShow(_0xcK12Ah5C6AP("Duf72M2U9cystPxW", 38693), list)
  end
  
  local function espScanPlayers(root)
      if not Config.EspPlayers then return end
      local list = {}
      for _, player in ipairs(Players:GetPlayers()) do
          local char = player ~= LocalPlayer and player.Character
          local part = char and char:FindFirstChild(_0xcK12Ah5C6AP("ozCoCDtcKDmey1gXgF0MCkr5gKHJAEP/CNm2MEHBe+X=", 50806))
          local humanoid = char and char:FindFirstChildOfClass(_0xcK12Ah5C6AP("YLEgTKQUNLdsLBAJD+pDZe==", 2539))
          if part and humanoid then
              local d = espDistance(root, part)
              if d <= Config.EspRange then
                  list[#list + 1] = { key = char, part = part, distance = d, text = player.DisplayName .. _0xcK12Ah5C6AP("WwxaRV+2lCs=", 38560) .. espHealth(humanoid) }
              end
          end
      end
      espShow(_0xcK12Ah5C6AP("V96NG7TqdTQfKnPyoxyvbo==", 57453), list)
  end
  
  task.spawn(function()
      while getgenv().CentrixHubLoaded do
          espPass = espPass + 1
          local root = getCharacter()
          local any = Config.EspMobs or Config.EspBosses or Config.EspNpcs or Config.EspChests or Config.EspLoot or Config.EspPlayers
          if root and any then
              pcall(function()
                  espScanMobs(root)
                  espScanNpcs(root)
                  espScanChests(root)
                  espScanLoot(root)
                  espScanPlayers(root)
              end)
          end
          espSweep()
          task.wait(0.25)
      end
  end)
  
  local healFailedUntil = 0
  local function healWants()
      if not Config.AutoHeal or os.clock() < healFailedUntil then return false end
      local _, humanoid = getCharacter()
      if not humanoid or humanoid.Health <= 0 or humanoid.MaxHealth <= 0 then return false end
      local threshold = Config.HealThreshold
      if humanoid.Health / humanoid.MaxHealth * 100 > threshold then return false end
      if Config.HealPotion == _0xcK12Ah5C6AP("", 18356) then return false end
      return getItemCount(Config.HealPotion) > 0
  end
  
  local function healStep()
      if not healWants() then return end
      local name = Config.HealPotion
      if name == _0xcK12Ah5C6AP("", 51051) then return end
      local slot = getSlot()
      local inv = slot and slot:FindFirstChild(_0xcK12Ah5C6AP("g5OlNPEroifrrfXoEKQMAf==", 10911)) and slot.Inventory:FindFirstChild(_0xcK12Ah5C6AP("dMNvXyScTMW7r5hhttqNou==", 19525))
      local item = inv and inv:FindFirstChild(name)
      local id = item and item:FindFirstChild(_0xcK12Ah5C6AP("lUuZVg2JEUS=", 28774))
      if not id then return end
      local toolbar = slot and slot:FindFirstChild(_0xcK12Ah5C6AP("gTPPbH7a7AB80vAsHeQS0v==", 50003)) and slot.Inventory:FindFirstChild(_0xcK12Ah5C6AP("QQOuYg+UQSycuiUljBt2cE==", 56218))
      if not toolbar then return end
      local idx
      for i, key in ipairs({_0xcK12Ah5C6AP("0Zhn7xgQNzg=", 48733), _0xcK12Ah5C6AP("C/DRPfSDjfA=", 33394), _0xcK12Ah5C6AP("qURgtFW2VESBse4t", 32796), _0xcK12Ah5C6AP("F1Kw0FskgxJ1Q1v2", 20942), _0xcK12Ah5C6AP("QGf5i4G9iUfy+DQB", 37369)}) do
          local entry = toolbar:FindFirstChild(key)
          if entry and entry.Value == id.Value then idx = i break end
      end
      if not idx then
          healFailedUntil = os.clock() + 5
          return
      end
      local equipped = LocalPlayer:FindFirstChild(_0xcK12Ah5C6AP("rymI8wd+q1hS6w6OCyW2xCt8iMhwhyNX", 5752))
      local eqConfig = equipped and equipped:FindFirstChild(_0xcK12Ah5C6AP("bVYkogE/LjuaSmONuLKPjm==", 18554))
      if not eqConfig then return end
      local root, humanoid = getCharacter()
      if not root then return end
      local before = getItemCount(name)
      if eqConfig.Value ~= 0 then
          eqConfig.Value = 0
          task.wait(0.5)
      end
      eqConfig.Value = idx
      task.wait(0.5)
      pcall(function()
          Game.SignalEvent.ToServer(_0xcK12Ah5C6AP("SyJ/7D5D2DSquqO22tIJJqmKSwzdKnJU", 55868), _0xcK12Ah5C6AP("9PkXoHDmoeL5IGQe", 64083), root.Position)
      end)
      task.wait(2.1)
      pcall(function()
          Game.SignalEvent.ToServer(_0xcK12Ah5C6AP("e+7AgD0be+aFbBF8qe/qL9Y4NUZOqj5r", 5721), _0xcK12Ah5C6AP("69GuLz71aZd=", 27732), root.Position)
      end)
      task.wait(1)
      eqConfig.Value = 0
      if getItemCount(name) >= before then
          healFailedUntil = os.clock() + 5
      end
  end
  
  task.spawn(function()
      while getgenv().CentrixHubLoaded do
          pcall(healStep)
          task.wait(0.5)
      end
  end)
  
  local noDrownHooked = false
  local function hookAntiDrown()
      if noDrownHooked then return end
      noDrownHooked = true
      pcall(function()
          local Settings = Game.MinigameSettings
          local originalGet = Settings.Get
          Settings.Get = function(key, ...)
              if key == _0xcK12Ah5C6AP("N8w9VopQolR1XAASlglPN8c4F1B+Spex", 46015) and Config.AutoDrown and getgenv().CentrixHubLoaded then
                  return true
              end
              return originalGet(key, ...)
          end
      end)
      pcall(function()
          local Signal = Game.SignalEvent
          local originalToServer = Signal.ToServer
          Signal.ToServer = function(name, action, ...)
              if name == _0xcK12Ah5C6AP("rlq5HzDpGNSSuoeM", 12429) and action == _0xcK12Ah5C6AP("ES1kjZ94tUsh+UF3TLVo0JZSkKZvVGqt", 37553) and Config.AutoDrown and getgenv().CentrixHubLoaded then
                  return nil
              end
              return originalToServer(name, action, ...)
          end
      end)
  end
  
  task.spawn(function()
      task.wait(3)
      pcall(hookAntiDrown)
  end)
  
  local noSunHooked = false
  local function hookAntiSun()
      if noSunHooked then return end
      noSunHooked = true
      pcall(function()
          local Settings = Game.MinigameSettings
          local originalGet = Settings.Get
          Settings.Get = function(key, ...)
              if key == _0xcK12Ah5C6AP("ZE10c0298j12qUPpHx+sa1p+LV7+SvpW", 63273) and Config.AutoSun and getgenv().CentrixHubLoaded then
                  return true
              end
              return originalGet(key, ...)
          end
      end)
      pcall(function()
          local Signal = Game.SignalFunction
          local originalToServer = Signal.ToServer
          Signal.ToServer = function(name, inSun, ...)
              if name == _0xcK12Ah5C6AP("xAzpZuFsX62hBAnMXqJnEA==", 9197) and inSun == true and Config.AutoSun and getgenv().CentrixHubLoaded then
                  return originalToServer(name, false, ...)
              end
              return originalToServer(name, inSun, ...)
          end
      end)
  end
  
  task.spawn(function()
      task.wait(3)
      pcall(hookAntiSun)
  end)
  
  local function countdown(seconds)
      seconds = math.max(0, math.ceil(seconds))
      return string.format(_0xcK12Ah5C6AP("SyEAhLb3cbWckibXubeCk0==", 51398), seconds // 60, seconds % 60)
  end
  
  local function clockText(hours)
      local whole = math.floor(hours) % 24
      return string.format(_0xcK12Ah5C6AP("Ri5kQ0UQ1WdQTkMkNiMHrK==", 22967), whole, math.floor((hours - math.floor(hours)) * 60))
  end
  
  local alertedSunrise = false
  task.spawn(function()
      while getgenv().CentrixHubLoaded do
          pcall(function()
              local handler = Game.DayAndNightHandler
              if handler then
                  local okEnabled, enabled = call(handler.IsEnabled)
                  if okEnabled and enabled == false then
                      DayNightLabel:SetLabel(_0xcK12Ah5C6AP("/7unAekDfDjSwA+rrAiFYMjxAhXmwDyPYAmLkmXAvR5poDe+fEAWgR8dwhlque8AWeX1wAKdoA8Kvy8K/VX1vxeVaeXTB4y+", 10722))
                  else
                      local okNight, night = call(handler.IsNight)
                      local okLeft, left = call(handler.SecondsUntilPhaseChange)
                      local okHours, hours = call(handler.GetClockTime)
                      if okNight and okLeft and type(left) == _0xcK12Ah5C6AP("Myu7ObYcUekIgjuY", 45860) then
                          local race = getValue(_0xcK12Ah5C6AP("5Xgq3CUQ7H1DKhZt", 39263))
                          local lines = {}
                          if night then
                              lines[1] = string.format(_0xcK12Ah5C6AP("lPOQ5Jq7NzkKmQkwLzXg2bdvH2aInADFleE0Cvg6WV90nIZVLGOf9Q==", 15581), countdown(left))
                          else
                              lines[1] = string.format(_0xcK12Ah5C6AP("+Ef2mDfPWiRWI+uhq27bsYteWDXmIm7TWyzKMImgOje=", 19048), countdown(left))
                              if race == _0xcK12Ah5C6AP("UTEfmI1R8d0E81fP", 52926) and not Config.AutoSun then
                                  lines[2] = _0xcK12Ah5C6AP("KDcFCWIpQ2Jhy6n1QDnICDIG0DWeCBI8I6QQ7kohiHa=", 1624)
                              end
                          end
                          if okHours and type(hours) == _0xcK12Ah5C6AP("YYbwyyH+QqNqEgVi", 2252) then
                              lines[#lines + 1] = _0xcK12Ah5C6AP("kkWOQmQLKJtkjvlC", 36340) .. clockText(hours)
                          end
                          DayNightLabel:SetLabel(table.concat(lines, _0xcK12Ah5C6AP("waRe0dRFwwS=", 33640)))
                          if night and left <= 60 and not alertedSunrise then
                              alertedSunrise = true
                              if race == _0xcK12Ah5C6AP("qigXQkuTDDfBqhBy", 1918) and Config.SunAlert then
                                  CentrixUI:Notify({ Title = _0xcK12Ah5C6AP("RqqwzBR+UBdbzXaDswNHDD==", 36539), Content = string.format(_0xcK12Ah5C6AP("3dthnvRE+ofZ3BS2gBOTPEF3D5qhTb0u", 23149), countdown(left)), Type = _0xcK12Ah5C6AP("WEFmz5GGV7KpSjGCkEhyYE==", 31726), Duration = 6 })
                              end
                          elseif not night or left > 65 then
                              alertedSunrise = false
                          end
                      end
                  end
              end
          end)
          task.wait(1)
      end
  end)
  
  local wasBossUp = setmetatable({}, { __mode = _0xcK12Ah5C6AP("Mf5qFGezVB8=", 41480) })
  local bossWentDown = setmetatable({}, { __mode = _0xcK12Ah5C6AP("JS4HMTVmC3A=", 20156) })
  
  task.spawn(function()
      while getgenv().CentrixHubLoaded do
          pcall(function()
              local regionRoot = findRegionRoot()
              if not regionRoot then
                  task.wait(1)
                  return
              end
              local rows = {}
              local now = workspace:GetServerTimeNow()
              for _, region in ipairs(regionRoot:GetChildren()) do
                  local active = region:FindFirstChild(_0xcK12Ah5C6AP("JM49LMzrYqG8ScEPSY43qJuTV5kUMqrx", 52324))
                  for _, folder in ipairs(active and active:GetChildren() or {}) do
                      if folder:FindFirstChild(_0xcK12Ah5C6AP("geDohh5/QQRsOWFRRwnj5R==", 18795)) then
                          local rig = folder:FindFirstChild(folder.Name)
                          local humanoid = rig and rig:FindFirstChildOfClass(_0xcK12Ah5C6AP("95iiBxFf6YwZq5vL9dXr1B==", 23863))
                          local up = humanoid ~= nil and humanoid.Health > 0
                          local previous = wasBossUp[folder]
                          if up and previous == false and Config.BossAlert then
                              CentrixUI:Notify({ Title = _0xcK12Ah5C6AP("HcKKl2PV63cY9dNl", 28711), Content = folder.Name .. _0xcK12Ah5C6AP("ZQbCDptiI/dYxIva", 40488), Type = _0xcK12Ah5C6AP("HNZbo6YBB9Hu0Jz0UlEy2D==", 40051), Duration = 6 })
                          end
                          if not up and previous ~= false then
                              bossWentDown[folder] = os.clock()
                          end
                          wasBossUp[folder] = up
                          local left
                          if not up then
                              local info = folder:FindFirstChild(_0xcK12Ah5C6AP("OAcLpZviQulbS2cP7SyqLG==", 438))
                              local seconds = info and info:GetAttribute(_0xcK12Ah5C6AP("rfQaHFj6mgJQMgruXBlUWR==", 55361))
                              local despawned = folder:GetAttribute(_0xcK12Ah5C6AP("ageeOkSfEMyMigcIY11PaUPYHjO/qcBu", 15874))
                              if type(seconds) == _0xcK12Ah5C6AP("irk7SCKb3V45WwOi", 15241) and type(despawned) == _0xcK12Ah5C6AP("6lSEhxp8V1Ogb95h", 12833) then
                                  left = seconds - (now - despawned)
                              elseif type(seconds) == _0xcK12Ah5C6AP("3p5frgVNQGo85KE1", 62295) and bossWentDown[folder] then
                                  left = seconds - (os.clock() - bossWentDown[folder])
                              end
                          end
                          rows[#rows + 1] = { name = folder.Name, up = up, left = left and math.max(0, left) }
                      end
                  end
              end
              table.sort(rows, function(a, b)
                  if a.up ~= b.up then return a.up end
                  if (a.left ~= nil) ~= (b.left ~= nil) then return a.left ~= nil end
                  if a.left ~= b.left then return (a.left or 0) < (b.left or 0) end
                  return a.name < b.name
              end)
              local lines = {}
              for i, row in ipairs(rows) do
                  if i > 10 then break end
                  local state = row.up and _0xcK12Ah5C6AP("ZqpxRO6TSvDhz5wA", 58385) or (row.left and (_0xcK12Ah5C6AP("sC2pWsONKYOb0jnWIK7iic==", 7174) .. countdown(row.left)) or _0xcK12Ah5C6AP("FOpYX9NtHhp9ROwk", 53331))
                  lines[i] = string.format(_0xcK12Ah5C6AP("Jn3YYVOGPpcfYgGI", 5213), row.name, state)
              end
              if #lines == 0 then
                  BossTimersLabel:SetLabel(_0xcK12Ah5C6AP("CgOFCjpkh66KYVpMa2ElcLw021MwalrM9lEoQghdCfAfePF3K26CJj==", 9044))
              else
                  BossTimersLabel:SetLabel(table.concat(lines, _0xcK12Ah5C6AP("pZJxhHbVVgJ=", 7851)))
              end
          end)
          task.wait(1)
      end
  end)
  
  local skillController, skillProvider, skillPlatform
  local skillsConnected = false
  
  local function holder()
      local char = LocalPlayer.Character
      return char and (char:FindFirstChild(_0xcK12Ah5C6AP("O2ttoxMKKsr=", 19418)) or char:FindFirstChild(_0xcK12Ah5C6AP("J7jILiWNZ1FGha4L", 24209)))
  end
  
  local function skillReady(name)
      local shc = holder()
      if shc then
          local okCD, filterCd = call(Game.manage_cd.filter_cd_name, LocalPlayer, name)
          local cooldown = shc:FindFirstChild(filterCd or name)
          local started = cooldown and cooldown:GetAttribute(_0xcK12Ah5C6AP("9RQJ2NyQDSKifIK0DESaXP==", 36513))
          if cooldown and typeof(cooldown.Value) == _0xcK12Ah5C6AP("OTmtCLRYTDuDH6rV", 36841) and typeof(started) == _0xcK12Ah5C6AP("fOHIjtC/UdXdgp53", 51575)
              and os.clock() - started < cooldown.Value then
              return false, _0xcK12Ah5C6AP("j7HL7Qzn2PNIJOiMBuj1Kad+G871JPCE", 22775)
          end
      end
      local checked, _, unlocked = call(Game.SkillStats.GetRequirements, LocalPlayer, name)
      if checked and not unlocked then
          return false, _0xcK12Ah5C6AP("LVV8BpVWBdmkeLh3", 33001)
      end
      return true
  end
  
  local aimAt = nil
  
  local function hookSkillAim()
      if not skillPlatform then return end
      local original = skillPlatform.mousepos
      if type(original) ~= _0xcK12Ah5C6AP("WMz1e7qMgjCiopAx5SaZxW==", 58202) then return end
      skillPlatform.mousepos = function(...)
          local get = aimAt
          if get then
              local ok, pos = pcall(get)
              if ok and typeof(pos) == _0xcK12Ah5C6AP("qxlhAsQMGFDFmhik66dgBi==", 35972) then return pos end
          end
          return original(...)
      end
  end
  
  local function connectSkills()
      if skillsConnected or not LocalPlayer.Character then return end
      local ok = pcall(function()
          preloadModules(_0xcK12Ah5C6AP("MRALIMRbpTezeGOdWCm+WRxT8/ROyGGcqkeig/0KKge=", 22980), _0xcK12Ah5C6AP("XZnbrstWdO77jjR6qs/iFgxfW3JDQsciD3BxQ4==", 14849), _0xcK12Ah5C6AP("qjiZ9cGeMchOpECFnlKv8ciacsg0ugK8SeB7szNOBSk=", 39728), _0xcK12Ah5C6AP("hBqsbRBb1+O3V18C+B2JJ+gj08vSdAE0", 57479), _0xcK12Ah5C6AP("uuS+ZV0n1LadkkiJD526Ajw0IoGQlstm", 27780), _0xcK12Ah5C6AP("N+leZRBCMtMelOlhmiyGLR==", 15159))
          skillController = Game.Skill_Controller
          skillProvider = Game.Skills_Provider
          skillPlatform = Game.Platform_Handler
      end)
      if ok then
          hookSkillAim()
          skillsConnected = true
      end
  end
  
  task.spawn(function()
      while getgenv().CentrixHubLoaded and not skillsConnected do
          pcall(connectSkills)
          task.wait(1)
      end
  end)
  
  local function getSkillBar()
      if not skillProvider then return {} end
      local ok, keys = call(skillProvider.get_current_keys)
      if not ok then return {} end
      local bar = {}
      for i = 1, 10 do
          local entry = type(keys) == _0xcK12Ah5C6AP("iCA3amxoiqaHWM/e", 53730) and keys[i]
          if type(entry) == _0xcK12Ah5C6AP("gbB5MIFFmC4SBt0N", 20976) and type(entry.Name) == _0xcK12Ah5C6AP("yunzXSxkPoptLrkG", 60677) and entry.Name ~= _0xcK12Ah5C6AP("", 60960) then
              bar[#bar + 1] = { name = entry.Name, maxHold = tonumber(entry.Max_Hold) or 0 }
          end
      end
      return bar
  end
  
  local function skillTarget()
      local root = getCharacter()
      if not root then return nil end
      local regionRoot = findRegionRoot()
      if not regionRoot then return nil end
      local best, bestDist = nil, math.huge
      for _, region in ipairs(regionRoot:GetChildren()) do
          local active = region:FindFirstChild(_0xcK12Ah5C6AP("ylG8iaG9IqhJiWf+GiStCGEn/uhaFIVy", 14404))
          for _, folder in ipairs(active and active:GetChildren() or {}) do
              local rig = folder:FindFirstChild(folder.Name)
              if rig and rig:GetAttribute(_0xcK12Ah5C6AP("hBvKD4omFIJBSwZg", 35039)) == true then
                  local part = rig:FindFirstChild(_0xcK12Ah5C6AP("UR1KBKR/T3JnkFAWZnQmcmBFRTJcMY1QRcTmGRLu7b6=", 37447))
                  local humanoid = rig:FindFirstChildOfClass(_0xcK12Ah5C6AP("NUbhH959TtLQD6TXjUtae6==", 14551))
                  if part and humanoid and humanoid.Health > 0 then
                      local d = (part.Position - root.Position).Magnitude
                      if d <= 40 and d < bestDist then
                          best, bestDist = rig, d
                      end
                  end
              end
          end
      end
      return best
  end
  
  local function castSkill(skill, rig)
      if not skillController then return false end
      aimAt = function()
          local targetRoot = rig and rig.Parent and rig:FindFirstChild(_0xcK12Ah5C6AP("mpvy6JwywOiFCWQp98voXjmKr+mMuJ2TuaZ7QSSU9Am=", 9866))
          if targetRoot then return targetRoot.Position end
          local root = getCharacter()
          return root and (root.Position + root.CFrame.LookVector * 20) or nil
      end
      local ok, pressed = call(skillController.Attempt_Hold, skill.name, nil)
      if not ok or pressed ~= true then
          aimAt = nil
          return false
      end
      skillController.CurrentMax = skill.maxHold
      skillController.HeldSkill = skill.name
      local shc = holder()
      local hold = math.min(Config.AutoSkillHold, skill.maxHold or 0)
      local deadline = os.clock() + hold
      while getgenv().CentrixHubLoaded and shc and shc.Value == skill.name and os.clock() < deadline do
          task.wait(0.05)
      end
      if shc and shc.Value == skill.name then
          skillController.UnHoldBoolean = true
          local released = os.clock() + 1
          while getgenv().CentrixHubLoaded and shc.Value == skill.name and os.clock() < released do
              task.wait(0.05)
          end
      end
      aimAt = nil
      return true
  end
  
  task.spawn(function()
      while getgenv().CentrixHubLoaded do
          pcall(function()
              if Config.AutoSkills and skillsConnected then
                  local root, humanoid = getCharacter()
                  if root and humanoid and humanoid.Health > 0 then
                      local shc = holder()
                      if not (shc and (shc.Value ~= _0xcK12Ah5C6AP("", 58784) or shc:GetAttribute(_0xcK12Ah5C6AP("RDZVFfgWWrT=", 33399)) == true)) then
                          local rig = skillTarget()
                          if Config.AutoSkillWhen == _0xcK12Ah5C6AP("FrRdJ05knmihFvw3", 48641) or rig then
                              local bar = getSkillBar()
                              for _, skill in ipairs(bar) do
                                  if skill.name ~= _0xcK12Ah5C6AP("DrrJwIfl0AK60ZgX+9aC5s==", 50697) then
                                      local ok, why = skillReady(skill.name)
                                      if ok then
                                          if castSkill(skill, rig) then break end
                                      end
                                  end
                              end
                          end
                      end
                  end
              end
          end)
          task.wait(0.25)
      end
  end)
  
  local function getTree()
      local stats, skills = {}, {}
      local ok = pcall(function()
          local SkillService = ReplicatedStorage.CAM.Global.SkillService
          local Holder = require(SkillService.SkillTreeholder)
          local branches = Holder.GetBranches()
          local function walk(node, underStats)
              for _, child in ipairs(node or {}) do
                  if type(child) == _0xcK12Ah5C6AP("fUJEq+s0sKbkfWiw", 34320) and type(child.Name) == _0xcK12Ah5C6AP("mmfl6Vj1tGPj7a2y", 44749) then
                      if underStats then
                          if not table.find(stats, child.Name) then stats[#stats + 1] = child.Name end
                      elseif child.IsBranch then
                          walk(child, child.Name == _0xcK12Ah5C6AP("z5g50sNI7gNQd9kA", 56315))
                      elseif not table.find(skills, child.Name) then
                          skills[#skills + 1] = child.Name
                      end
                  end
              end
          end
          walk(branches, false)
      end)
      elevate()
      return stats, skills
  end
  
  local function statLevel(name)
      local slot = getSlot()
      local list = slot and slot:FindFirstChild(_0xcK12Ah5C6AP("WAqSpPwwScSFSuT787TK6dqZSmpJPT8viDTOUfw96EK86LWFHscVPz==", 45874))
      local entry = list and list:FindFirstChild(name)
      return entry and entry.Value or 0
  end
  
  local function nextSkillStep(name, isStat)
      local ok = pcall(function()
          preloadModules(_0xcK12Ah5C6AP("uctq19/CJcfrKVHdJCFsYBdMcpWTJRkf", 31576))
      end)
      if not ok then return nil end
      local SkillService = ReplicatedStorage.CAM.Global.SkillService
      local Stats = require(SkillService.Stats)
      local Holder = require(SkillService.SkillTreeholder)
      elevate()
      local index, requirements
      if isStat then
          local level = statLevel(name)
          local got, maxIndex = call(Stats.GetMaxIndexForCategory, name)
          if got and type(maxIndex) == _0xcK12Ah5C6AP("BpNQiCwNJPF0hjZH", 9321) and level >= maxIndex then return nil end
          index = level + 1
          local ok2, result = call(Stats.GetRequirementsAt, LocalPlayer, name, index)
          requirements = ok2 and result or nil
      else
          local ok2, unlocked = call(Stats.IsSkillUnlocked, LocalPlayer, name)
          if ok2 and unlocked then return nil end
          local ok3, result = call(Stats.GetRequirements, LocalPlayer, name)
          requirements = ok3 and result or nil
      end
      if type(requirements) ~= _0xcK12Ah5C6AP("xOIAWLhOGluuKml6", 34149) then return nil end
      local missing = {}
      for kind, value in pairs(requirements) do
          local solver = Holder.RequirementsSolver[kind]
          local met = true
          if solver then
              local ok4, can = call(solver.CanBuy, LocalPlayer, name, value)
              met = ok4 and can
          end
          if not met then
              if kind == _0xcK12Ah5C6AP("c3rmRGPI3grwLb8IDSsEU5PERbrHiBMG", 44191) then
                  missing[#missing + 1] = tostring(value) .. _0xcK12Ah5C6AP("l7xNabAXaKT=", 65154)
              elseif kind == _0xcK12Ah5C6AP("ctPbbeq7QSPKHVizVtqQeU==", 26822) then
                  missing[#missing + 1] = _0xcK12Ah5C6AP("cr8IarLDKJAkOrCogs+sjP==", 1878) .. tostring(value)
              elseif kind == _0xcK12Ah5C6AP("cISiHFDAr+kzrSAA", 31599) then
                  missing[#missing + 1] = _0xcK12Ah5C6AP("5VmPRfBBp0gJ/fAXUidpX4==", 62663) .. tostring(value)
              end
          end
      end
      return {
          name = name,
          index = index,
          cost = tonumber(requirements.SkillPoints) or 0,
          ready = #missing == 0,
          missing = missing,
      }
  end
  
  local spending = false
  local function SpendSkillPoints(announce)
      if spending then return end
      spending = true
      local bought, failed = {}, nil
      local stats, skills = getTree()
      for _ = 1, 20 do
          local ready = {}
          if Config.SkillUnlockSkills then
              for _, name in ipairs(skills) do
                  local step = nextSkillStep(name, false)
                  if step and step.ready then ready[#ready + 1] = step end
              end
              table.sort(ready, function(a, b) return a.cost < b.cost end)
          end
          local cheapest
          for _, name in ipairs(Config.SkillStats) do
              if table.find(stats, name) then
                  local step = nextSkillStep(name, true)
                  if step and step.ready and (not cheapest or step.cost < cheapest.cost) then
                      cheapest = step
                  end
              end
          end
          if cheapest then ready[#ready + 1] = cheapest end
          local step = ready[1]
          if not step or not getgenv().CentrixHubLoaded then break end
          local before = step.index and statLevel(step.name) or nil
          local ok, result = call(Game.SignalFunction.ToServer, _0xcK12Ah5C6AP("e2GbJ6FSbbfjXySae+COS0NwbbFdsiuuzmaDZir/X70SZxgzqIqFhF==", 46657), step.name)
          if not ok or result == false then
              failed = step
              break
          end
          local waited = 0
          local success = false
          while waited < 2 do
              task.wait(0.1)
              waited += 0.1
              if before then
                  if statLevel(step.name) > before then success = true break end
              else
                  local got, unlocked = call(Game.SkillStats.IsSkillUnlocked, LocalPlayer, step.name)
                  if got and unlocked then success = true break end
              end
          end
          if not success then
              failed = step
              break
          end
          bought[#bought + 1] = string.format(_0xcK12Ah5C6AP("1LCwE4KTLvA1ExxZtEEwTAO0ByZjcRRw", 27844), step.name, step.cost)
      end
      spending = false
      if #bought > 0 then
          CentrixUI:Notify({ Title = _0xcK12Ah5C6AP("BLvjOTz0ynJHaTHInGLuFFOba1zYKYOK", 58093), Content = _0xcK12Ah5C6AP("8VnAq3ptO4wQr4xTSEDoaO==", 21650) .. table.concat(bought, _0xcK12Ah5C6AP("usQXfdYqZRe=", 58244)), Type = _0xcK12Ah5C6AP("YFc9VkOMSdhD1+956tdGBE==", 56996), Duration = 6 })
      elseif announce then
          CentrixUI:Notify({ Title = _0xcK12Ah5C6AP("0wI9aBQKrmVm+0nj0TPCGhhVXyUyWhdK", 592), Content = _0xcK12Ah5C6AP("SbpzXlps8/lWpa/atf0YRD7V8Xx3XqVXyyVpRb7yA3Ly2aqgyqlZXnE+Sn/oyNpaoYVs+3JhWW//lZBtVDLXR/==", 28813), Type = _0xcK12Ah5C6AP("s2TUxSiMYsU6MVtS", 32767), Duration = 4 })
      end
  end
  
  task.spawn(function()
      while getgenv().CentrixHubLoaded do
          pcall(function()
              if Config.AutoSkillPoints then
                  SpendSkillPoints(false)
              end
          end)
          task.wait(5)
      end
  end)
  
  task.spawn(function()
      while getgenv().CentrixHubLoaded do
          pcall(function()
              local _, skills = getTree()
              local lines = {}
              lines[#lines + 1] = _0xcK12Ah5C6AP("Yt+VrnBwDJE8i7heYuEQXXE9Dvutw87PPngJlu==", 31547) .. tostring(getValue(_0xcK12Ah5C6AP("ONCrFKNfhBotd5Cc2MKpG8iuFa4mErc7", 38953)) or 0)
              if #skills > 0 then
                  local ready = {}
                  for _, name in ipairs(skills) do
                      local step = nextSkillStep(name, false)
                      if step and step.ready then ready[#ready + 1] = step.name end
                  end
                  if #ready > 0 then
                      lines[#lines + 1] = _0xcK12Ah5C6AP("slvFbCG5NJtTUBEwkgdmJn==", 65011) .. table.concat(ready, _0xcK12Ah5C6AP("lJpiBHUNLVX=", 365))
                  end
              end
              SkillTreeStatus:SetLabel(table.concat(lines, _0xcK12Ah5C6AP("esIPxt7ZFlI=", 47138)))
          end)
          task.wait(5)
      end
  end)
  
  local function flattenPoints(value, into)
      into = into or {}
      if typeof(value) == _0xcK12Ah5C6AP("6jd44W13GmTI4Kda", 34484) then
          into[#into + 1] = value.Position
      elseif typeof(value) == _0xcK12Ah5C6AP("WJuLOOAso6cIgRl9/Fy+1k==", 5812) then
          into[#into + 1] = value
      elseif type(value) == _0xcK12Ah5C6AP("ib2xis1c3ekKJrlo", 5504) then
          for _, item in ipairs(value) do
              flattenPoints(item, into)
          end
      end
      return into
  end
  
  local function eachRegionNpc(fn)
      local ok, regions = pcall(function()
          preloadModules(_0xcK12Ah5C6AP("tw/908kNAiysLgquqAq0jC==", 19734))
          return Game.Regions.Regions
      end)
      if not (ok and type(regions) == _0xcK12Ah5C6AP("j/yNEXc7j6ykU/De", 19602)) then return end
      for regionName, region in pairs(regions) do
          if type(region) == _0xcK12Ah5C6AP("ZG4EZamli7dqVgu9", 17153) then
              fn(regionName, region)
          end
      end
  end
  
  local locatorEntries = {}
  
  local function buildLocatorList(category)
      local list = {}
      if category == _0xcK12Ah5C6AP("BOezfopAOnDZumvO1ThbAmLoYRsEC2O9cvhHbo==", 11658) then
          eachRegionNpc(function(regionName, region)
              for _, npc in ipairs(type(region.Npcs) == _0xcK12Ah5C6AP("roRd99PiKO4EEZG/", 42330) and region.Npcs or {}) do
                  if type(npc) == _0xcK12Ah5C6AP("vqOm6Gqk2Z71QNRh", 61204) and type(npc.Name) == _0xcK12Ah5C6AP("ahJwYtLRlBLjaqJG", 26682) then
                      local kinds = Game.Menum and Game.Menum.npcType or {}
                      if npc.Type == kinds.Stationary or npc.Type == kinds.Idle then
                          local positions = flattenPoints(npc.Spawns)
                          if #positions > 0 then
                              local shop = (npc.Shop ~= nil or npc.RotatingShop ~= nil) and _0xcK12Ah5C6AP("hm9/P028MdnISimVsYSzkQ==", 18426) or _0xcK12Ah5C6AP("", 51200)
                              list[string.format(_0xcK12Ah5C6AP("c4rfFVV0TLFRREPUcdx8dX==", 35115), npc.Name, regionName, shop)] = { name = npc.Name, positions = positions, live = true }
                          end
                      end
                  end
              end
          end)
      elseif category == _0xcK12Ah5C6AP("ZiBYypzyIQqDaZFOx2mViQ3YSxB2iKXKvNZxiZ==", 38437) then
          eachRegionNpc(function(regionName, region)
              for _, npc in ipairs(type(region.Npcs) == _0xcK12Ah5C6AP("OTxVUZuAcYSnoYHm", 27798) and region.Npcs or {}) do
                  if type(npc) == _0xcK12Ah5C6AP("NtfWT7xwJq1TbXjv", 58585) and type(npc.Name) == _0xcK12Ah5C6AP("7e1GsupzkfqeI91k", 56320) then
                      local kinds = Game.Menum and Game.Menum.npcType or {}
                      local spawning = type(npc.SendOver) == _0xcK12Ah5C6AP("eJBPpfGaDpjkUb3Y", 58675) and npc.SendOver.Spawning
                      if npc.Type == kinds.Active and type(spawning) == _0xcK12Ah5C6AP("w8BmGFZe4LSAw8rQ", 48248) then
                          local positions = flattenPoints(spawning.Locations)
                          if #positions == 0 then positions = flattenPoints(spawning.Center) end
                          if #positions > 0 then
                              local boss = npc.SendOver.Boss ~= nil and _0xcK12Ah5C6AP("oX1vJqKxtIQIxB8g5BiZFJ==", 4253) or _0xcK12Ah5C6AP("", 58625)
                              list[string.format(_0xcK12Ah5C6AP("SOM+40C6WNax4AlYcVAMKH==", 45134), npc.Name, regionName, boss)] = { name = npc.Name, positions = positions }
                          end
                      end
                  end
              end
          end)
      elseif category == _0xcK12Ah5C6AP("WwL0ArkxvDLghDLsrSkyDxlVa7ioSwLwSY8OkqXQayE=", 10722) then
          eachRegionNpc(function(regionName, region)
              if regionName == _0xcK12Ah5C6AP("jOOIjUM7gXdR+OrC", 567) then return end
              local townPositions = flattenPoints(region.CrystalAt)
              if #townPositions == 0 then townPositions = flattenPoints(region.Spawns and region.Spawns[1]) end
              if #townPositions > 0 then
                  list[_0xcK12Ah5C6AP("jdFp8fiaIMYfL0Kv", 39686) .. regionName] = { name = regionName, positions = townPositions }
              end
              for _, shrine in ipairs(type(region.Shrines) == _0xcK12Ah5C6AP("nbwIqeG5w6UEGM8U", 18906) and region.Shrines or {}) do
                  local positions = type(shrine) == _0xcK12Ah5C6AP("jGSd2a9MkK2Z2xN0", 40268) and flattenPoints(shrine.At) or {}
                  if #positions > 0 then
                      list[_0xcK12Ah5C6AP("EyIzF1tK6cEbCk8PZ3GTY1==", 31454) .. tostring(shrine.Name or regionName)] = { name = tostring(shrine.Name or regionName), positions = positions }
                  end
              end
          end)
      elseif category == _0xcK12Ah5C6AP("MPQqmLekIz5rLs6+mIStgva4WKM9OiMwrsK332==", 32180) then
          pcall(function()
              preloadModules(_0xcK12Ah5C6AP("51FgxPOZAP3L20FOoK8M9Z8EJlo4eGVS", 7236))
              local markers = Game.gameSettings.TrainingMarkerPositions
              local forPlace = markers[game.PlaceId] or markers.Default
              for name, marker in pairs(forPlace or {}) do
                  if type(marker) == _0xcK12Ah5C6AP("hwbES3ptlRHyrQtM", 22687) and typeof(marker.Position) == _0xcK12Ah5C6AP("dEVgLij2xHEuGXgS6JU0hY==", 18717) then
                      list[tostring(name)] = { name = tostring(name), positions = { marker.Position } }
                  end
              end
          end)
      end
      return list
  end
  
  function RefreshLocatorTargets()
      locatorEntries = buildLocatorList(Config.LocatorCategory)
      local labels = {}
      for label in pairs(locatorEntries) do labels[#labels + 1] = label end
      table.sort(labels)
  end
  
  local locatorScreen = Instance.new(_0xcK12Ah5C6AP("NmrnGd1pVbtYNJAgGk/oV/==", 58451))
  locatorScreen.Name = _0xcK12Ah5C6AP("Nn73joNeqXB/hFHtFL9y7LzwTBZJ76tzd3wwzL==", 40129)
  locatorScreen.ResetOnSpawn = false
  locatorScreen.IgnoreGuiInset = true
  locatorScreen.DisplayOrder = 20
  locatorScreen.Enabled = false
  locatorScreen.Parent = guiParent()
  
  local locatorMarker = Instance.new(_0xcK12Ah5C6AP("cyaKTnmOfRHbRyJYPI5bIu==", 6383))
  locatorMarker.AnchorPoint = Vector2.new(0.5, 0.5)
  locatorMarker.AutomaticSize = Enum.AutomaticSize.XY
  locatorMarker.Size = UDim2.fromOffset(0, 0)
  locatorMarker.BackgroundColor3 = Color3.fromRGB(13, 12, 18)
  locatorMarker.BackgroundTransparency = 0.25
  locatorMarker.BorderSizePixel = 0
  locatorMarker.Font = Enum.Font.GothamBold
  locatorMarker.RichText = true
  locatorMarker.TextSize = 15
  locatorMarker.TextColor3 = Color3.fromRGB(240, 238, 246)
  locatorMarker.Text = _0xcK12Ah5C6AP("", 59293)
  locatorMarker.Parent = locatorScreen
  
  local locatorCorner = Instance.new(_0xcK12Ah5C6AP("ZDUboSDAAtmmsIUOZEpMZ/==", 34199))
  locatorCorner.CornerRadius = UDim.new(0, 6)
  locatorCorner.Parent = locatorMarker
  
  local locatorTarget = nil
  local locatorPosition = nil
  
  local function headingText(offset)
      local headings = { _0xcK12Ah5C6AP("vFfDpL9Ybu9=", 52685), _0xcK12Ah5C6AP("ygSyRGxXlvK=", 20941), _0xcK12Ah5C6AP("InIdYnORUQW=", 46430), _0xcK12Ah5C6AP("qd6dqHjsVce=", 39608), _0xcK12Ah5C6AP("TUrpNmqwMWE=", 6742), _0xcK12Ah5C6AP("OZ+o0uCCFTG=", 47494), _0xcK12Ah5C6AP("SBVy3d7o4d6=", 54077), _0xcK12Ah5C6AP("7QLzW6k/rak=", 28037) }
      local angle = math.deg(math.atan2(offset.X, -offset.Z))
      return headings[(math.floor((angle + 22.5) / 45) % 8) + 1]
  end
  
  local function whereText(position)
      local root = getCharacter()
      if not (root and typeof(position) == _0xcK12Ah5C6AP("lGQnox9gsKB/lL8g6zQHE6==", 4172)) then return _0xcK12Ah5C6AP("bI1QnODeJhDzGLk7DzRPNV==", 60613) end
      local offset = position - root.Position
      local studs = math.floor(Vector3.new(offset.X, 0, offset.Z).Magnitude)
      local height = math.floor(offset.Y)
      local vertical = _0xcK12Ah5C6AP("", 49361)
      if math.abs(height) >= 40 then
          vertical = string.format(_0xcK12Ah5C6AP("VXIkAvp7Q41HLEbmKSonhZ==", 58887), math.abs(height), height > 0 and _0xcK12Ah5C6AP("XcwpanOHk1b=", 34962) or _0xcK12Ah5C6AP("0G6DPzcUQFScE1bX", 36691))
      end
      if studs < 15 and vertical == _0xcK12Ah5C6AP("", 46730) then return _0xcK12Ah5C6AP("v8LDNNfpg8AKoMz/g166wCj6WYw2HVLV", 44258) end
      return string.format(_0xcK12Ah5C6AP("BIbXjjNBMAaHBLcpFGHjET5NGOLgHAmXjLUgsn==", 35163), headingText(offset), studs, vertical)
  end
  
  function StartTracking()
      local entry = locatorEntries[Config.LocatorTarget]
      if not entry then
          CentrixUI:Notify({ Title = _0xcK12Ah5C6AP("lVAQkfAxRB2iQILP6MTW6B==", 763), Content = _0xcK12Ah5C6AP("kecuNSmEy5AY6oqgGrAuhEAfH0iqGrQOGeJWhxcxIg5JsXhUf05gtQ==", 16216), Type = _0xcK12Ah5C6AP("A9DVaiMmSslieLcLfL93Sc==", 29682), Duration = 3 })
          return
      end
      locatorTarget = { label = Config.LocatorTarget, entry = entry }
      Config.LocatorTracking = true
      LocatorStatus:SetLabel(_0xcK12Ah5C6AP("h4DqxN12rioofw/E2TotVJ==", 39809) .. Config.LocatorTarget)
  end
  
  function StopTracking()
      locatorTarget = nil
      locatorPosition = nil
      locatorScreen.Enabled = false
      Config.LocatorTracking = false
      LocatorStatus:SetLabel(_0xcK12Ah5C6AP("txVw3pDETDGIqymg52Fr7uKIDRkP7zmadhOcRmMF+TS8LHD7FFDEH0OdZID=", 5259))
  end
  
  local function locateTarget()
      if not locatorTarget then return end
      local entry = locatorTarget.entry
      if entry.live then
          pcall(function()
              local model = nil
              local debree = workspace:FindFirstChild(_0xcK12Ah5C6AP("w88HfDaLkQr8Bx+D", 20420))
              local regions = debree and debree:FindFirstChild(_0xcK12Ah5C6AP("6Pq8Y+t0QP0jJ9uZjEEX9u==", 781))
              for _, region in ipairs(regions and regions:GetChildren() or {}) do
                  local stationary = region:FindFirstChild(_0xcK12Ah5C6AP("Bb6wjzfByL7BWUinWrOoHdRVSy7PTd5J0zbRdT==", 61865))
                  local found = stationary and stationary:FindFirstChild(entry.name)
                  if found and found:IsA(_0xcK12Ah5C6AP("GrjyStY1pY3lnNfm", 35739)) then
                      model = found
                      break
                  end
              end
              if model then
                  local ok, pivot = pcall(model.GetPivot, model)
                  if ok then
                      locatorPosition = pivot.Position
                      return
                  end
              end
          end)
      end
      local root = getCharacter()
      local best, bestDist = entry.positions[1], math.huge
      if root then
          for _, position in ipairs(entry.positions) do
              local d = (position - root.Position).Magnitude
              if d < bestDist then best, bestDist = position, d end
          end
      end
      locatorPosition = best
  end
  
  local function placeLocator()
      local camera = workspace.CurrentCamera
      if not (locatorTarget and locatorPosition and camera) then
          locatorScreen.Enabled = false
          return
      end
      locatorScreen.Enabled = true
      locatorMarker.Text = string.format(_0xcK12Ah5C6AP("N4oOH2XdBznBkYMPI7o6vW5dBXQCz8y0GE3vM4MVvyPqKhHfEl6dKyVoJWyhfKIWS7hGNewJeSWyUyFQMbFEE6==", 28736), locatorTarget.label, whereText(locatorPosition))
      local viewport = camera.ViewportSize
      local projected, onScreen = camera:WorldToViewportPoint(locatorPosition)
      if onScreen then
          locatorMarker.Position = UDim2.fromOffset(projected.X, math.max(projected.Y - 28, 48))
          return
      end
      local center = viewport / 2
      local offset = Vector2.new(projected.X, projected.Y) - center
      if projected.Z < 0 then offset = -offset end
      if offset.Magnitude < 1 then offset = Vector2.new(0, -1) end
      local scale = math.min((center.X - 48) / math.max(math.abs(offset.X), 1e-3), (center.Y - 48) / math.max(math.abs(offset.Y), 1e-3))
      local at = center + offset * scale
      locatorMarker.Position = UDim2.fromOffset(at.X, at.Y)
  end
  
  RunService.RenderStepped:Connect(function()
      if getgenv().CentrixHubLoaded and locatorTarget then
          pcall(placeLocator)
      end
  end)
  
  task.spawn(function()
      while getgenv().CentrixHubLoaded do
          pcall(function()
              if locatorTarget then
                  locateTarget()
                  local root = getCharacter()
                  if root and locatorPosition then
                      local flat = Vector3.new(locatorPosition.X - root.Position.X, 0, locatorPosition.Z - root.Position.Z).Magnitude
                      if flat <= 12 and math.abs(locatorPosition.Y - root.Position.Y) <= 20 then
                          local name = locatorTarget.label
                          StopTracking()
                          CentrixUI:Notify({ Title = _0xcK12Ah5C6AP("g5lbCTsHcw+lemUQQw6uIq==", 13192), Content = _0xcK12Ah5C6AP("1i13XZ/zyY/gfa9dZrzgACo2YqHmI94p", 5527) .. name, Type = _0xcK12Ah5C6AP("DJbfXZNagKT0HKNOlgonXx==", 18231), Duration = 4 })
                      end
                  end
              end
          end)
          task.wait(0.5)
      end
  end)
  
  RefreshLocatorTargets()
  
  local WEARABLE_KINDS = { _0xcK12Ah5C6AP("08OqGiS8cxOa8GS5PtjvRa==", 26766), _0xcK12Ah5C6AP("IAJx0ARFNDFHcNxIYwLQpw==", 45343), _0xcK12Ah5C6AP("wSNbLtoykGowNnQVnjw1yd==", 64974) }
  
  local function getWearables()
      local kinds = {}
      pcall(function()
          preloadModules(_0xcK12Ah5C6AP("c36kW/+iiK+1mKwK", 3682), _0xcK12Ah5C6AP("VN22DhRwtRk6vH8L", 54819))
          for _, kind in ipairs(WEARABLE_KINDS) do
              local value = Game.Menum.ItemEquipType[kind]
              if value ~= nil then kinds[value] = true end
          end
      end)
      local found = {}
      pcall(function()
          for name, definition in pairs(Game.Items) do
              if type(definition) == _0xcK12Ah5C6AP("jE8Sr2hp9GiM829M", 27742) and kinds[definition.EquipType] and type(definition.Stats) == _0xcK12Ah5C6AP("CIBKU7ouQqG8WC6l", 48242) then
                  found[name] = definition
              end
          end
      end)
      return found
  end
  
  local function getAccessoryScales()
      local scales = {}
      local wearables = getWearables()
      for _, definition in pairs(wearables) do
          if definition.Unobtainable ~= true then
              for stat, value in pairs(definition.Stats) do
                  if value == true then
                      scales[stat] = 1
                  elseif type(value) == _0xcK12Ah5C6AP("Bm7TG54AKjdBXTSk", 40993) and value > (scales[stat] or 0) then
                      scales[stat] = value
                  end
              end
          end
      end
      return scales
  end
  
  local function accessoryStats(name, definition, entry)
      local scaled = definition.Series ~= nil or definition.Refinable == true
      local tier, level = 1, nil
      if scaled then
          local ok, multiplier = call(Game.Series.Multiplier, entry)
          if ok and type(multiplier) == _0xcK12Ah5C6AP("T6Iot/ujchksG4DO", 19572) then tier = multiplier end
          local refine = entry:FindFirstChild(_0xcK12Ah5C6AP("fAleFL2DS7gztSw+97JrLb68LaSyTkxd", 38775))
          level = refine and refine.Value
      end
      local stats = {}
      for stat, value in pairs(definition.Stats) do
          if scaled and type(value) == _0xcK12Ah5C6AP("JHf9YsYbBY9JF0cO", 31555) then
              value *= tier
              if level then
                  local ok, refined = call(Game.Refinement.GetStatMultiplier, name, stat, level)
                  if ok and type(refined) == _0xcK12Ah5C6AP("jKIELp1c01I+KZT1", 1265) then value *= refined end
              end
          end
          stats[stat] = value
      end
      return stats
  end
  
  local function getOwnedAccessories()
      local slot = getSlot()
      local inv = slot and slot:FindFirstChild(_0xcK12Ah5C6AP("C8IOeD14aXTXXA1fp66Evk==", 28010)) and slot.Inventory:FindFirstChild(_0xcK12Ah5C6AP("91Z9UAutBSoNLCQlS48+k+==", 62479))
      local wearables = getWearables()
      local pool = {}
      for _, entry in ipairs(inv and inv:GetChildren() or {}) do
          local definition = wearables[entry.Name]
          local id = definition and entry:FindFirstChild(_0xcK12Ah5C6AP("KH4xS+0APkH=", 49946))
          if id and id.Value ~= 0 then
              pool[#pool + 1] = {
                  name = entry.Name,
                  id = id.Value,
                  stats = accessoryStats(entry.Name, definition, entry),
                  group = definition.ExclusiveGroup,
              }
          end
      end
      return pool
  end
  
  local function accessoryGain(piece, totals, wanted, scales, highest)
      local sum = 0
      for stat in pairs(wanted) do
          local value, scale = piece.stats[stat], scales[stat]
          if scale and scale > 0 then
              if value == true then
                  if not totals[stat] then sum += 1 end
              elseif type(value) == _0xcK12Ah5C6AP("Tu9GiX6/c7/N+7jj", 1625) then
                  if highest[stat] then
                      sum += (math.max(value, totals[stat] or 0) - (totals[stat] or 0)) / scale
                  else
                      sum += value / scale
                  end
              end
          end
      end
      return sum
  end
  
  local function chooseAccessories(pool, wanted, scales, highest, count)
      local chosen, taken, groups, totals = {}, {}, {}, {}
      for _ = 1, count do
          local best, bestGain
          for _, piece in ipairs(pool) do
              if not taken[piece] and not (piece.group and groups[piece.group]) then
                  local value = accessoryGain(piece, totals, wanted, scales, highest)
                  if value > 1e-9 and (not best or value > bestGain) then
                      best, bestGain = piece, value
                  end
              end
          end
          if not best then break end
          chosen[#chosen + 1] = best
          taken[best] = true
          if best.group then groups[best.group] = true end
          for stat, value in pairs(best.stats) do
              if value == true then
                  totals[stat] = true
              elseif type(value) == _0xcK12Ah5C6AP("w79kzDCplN0IKzzy", 54028) then
                  if highest[stat] then
                      totals[stat] = math.max(totals[stat] or 0, value)
                  else
                      totals[stat] = (totals[stat] or 0) + value
                  end
              end
          end
      end
      return chosen
  end
  
  function EquipBestAccessories()
      local slot = getSlot()
      if not slot then
          AccessoryStatus:SetLabel(_0xcK12Ah5C6AP("kdxtCnMFMDrnW0u2xBupAh6M4CEe5pEWMz7eInE0xhYOmhexamewMAG8khrj+dPx", 27314))
          return
      end
      local folder = slot:FindFirstChild(_0xcK12Ah5C6AP("NbqEFbE+FzNaOl5rDbG708==", 10257)) and slot.Inventory:FindFirstChild(_0xcK12Ah5C6AP("pXGGT4UHDiuIJvRNlXcv4pzR4qE+l07h", 38227)) and slot.Inventory.Accessories:FindFirstChild(_0xcK12Ah5C6AP("TwS+fFuXNvDw4Vg3", 62589))
      if not folder then
          AccessoryStatus:SetLabel(_0xcK12Ah5C6AP("J6HUJc4DEFl1SZQuPJBv8tE28chd6wX+hrZxWw8jEFQcS6M7J54OnZBIF1BUnjXpNsZuJfDvE71BJxBN", 47723))
          return
      end
      local wanted = {}
      for _, name in ipairs(Config.AccessoryStats) do wanted[name] = true end
      if next(wanted) == nil then
          CentrixUI:Notify({ Title = _0xcK12Ah5C6AP("4f+eHkHVaaEzAV7reApisO4y+V+Ftfcg", 30852), Content = _0xcK12Ah5C6AP("64ZV8LN+cdN8SFIpxBcScbbHdlInAXNqtf0O6iJeB7VXEwLZa4JvxFW7BWHtBtrOZCcl+fbpKVj=", 7551), Type = _0xcK12Ah5C6AP("X0D7lSgEtM1atLTvth1oBs==", 50965), Duration = 4 })
          return
      end
      local scales = getAccessoryScales()
      local highest = {}
      pcall(function()
          preloadModules(_0xcK12Ah5C6AP("JwkNRokpJMm9FZLodsY1P0==", 27427))
          highest = Game.StatTypes.HighestOnlyStats or {}
      end)
      local pool = getOwnedAccessories()
      local chosen = chooseAccessories(pool, wanted, scales, highest, 5)
      if #chosen == 0 then
          AccessoryStatus:SetLabel(_0xcK12Ah5C6AP("YHLPegn4WwLymczhgYbbu+H1jVTbNRBKiGHdo+94gH0=", 11838))
          return
      end
      local slotIds = {}
      for _, slotName in ipairs({ _0xcK12Ah5C6AP("TpIts6aKhCW=", 60257), _0xcK12Ah5C6AP("fpcwQgKkmqg=", 52720), _0xcK12Ah5C6AP("phhLcJP9Az0WqJoE", 55144), _0xcK12Ah5C6AP("HUWtpJNADOXIVpuA", 59537), _0xcK12Ah5C6AP("DuymijySIh8Ets0Y", 28511) }) do
          local entry = folder:FindFirstChild(slotName)
          if entry then
              slotIds[slotName] = type(entry.Value) == _0xcK12Ah5C6AP("OvGU+EMIYjOiSTnA", 13368) and entry.Value or 0
          end
      end
      local placed, empty, replaceable = {}, {}, {}
      local wantedIds = {}
      for _, piece in ipairs(chosen) do wantedIds[piece.id] = true end
      for _, slotName in ipairs({ _0xcK12Ah5C6AP("Vu0/eKMbdSm=", 49471), _0xcK12Ah5C6AP("VSQyN7VFdNP=", 54815), _0xcK12Ah5C6AP("4oBT1e4PzjocdCQ6", 8408), _0xcK12Ah5C6AP("c80vdQ2KAfZCtDsW", 3604), _0xcK12Ah5C6AP("U6tgciE54qYSwR0V", 39742) }) do
          local id = slotIds[slotName]
          if id ~= nil then
              if wantedIds[id] then
                  placed[id] = true
              elseif id == 0 then
                  empty[#empty + 1] = slotName
              else
                  replaceable[#replaceable + 1] = slotName
              end
          end
      end
      local equips = {}
      for _, piece in ipairs(chosen) do
          if not placed[piece.id] then
              local targetSlot = table.remove(empty, 1) or table.remove(replaceable, 1)
              if not targetSlot then break end
              equips[#equips + 1] = { slot = targetSlot, piece = piece }
          end
      end
      if #equips == 0 then
          AccessoryStatus:SetLabel(_0xcK12Ah5C6AP("mJB2hEe+0TEqNmpbtKeSF6EjLHSDzHTNrnB+kmKH/QRc+BJjVnYFrEf3qmfokHT9gMOrbcTMtcx=", 59535))
          return
      end
      for _, eq in ipairs(equips) do
          pcall(function()
              Game.SignalEvent.ToServer(_0xcK12Ah5C6AP("jOA2AijVQcAZXlPjV5ntjLgFRh5dFLh3QhX6Ni==", 13595), eq.slot, eq.piece.id, _0xcK12Ah5C6AP("z0i6NkVeXrT2+8bQ", 64033))
          end)
          task.wait(0.4)
      end
      AccessoryStatus:SetLabel(string.format(_0xcK12Ah5C6AP("YnQyC2pw5qLXXKso8wsjoBBFcdcXeDCwc2sVEHjcYdIt2qwpV+iz+p==", 51556), #equips))
      CentrixUI:Notify({ Title = _0xcK12Ah5C6AP("frDdfERJNsehaDT5BF9SKbOOf2E2vwg3", 32185), Content = string.format(_0xcK12Ah5C6AP("23a5Z9IUUpahkwFiIqF3Srp0QpEBLzC680H74QKG8jMBU/MKK8vDyG==", 50106), #equips), Type = _0xcK12Ah5C6AP("NWyCLmo7H523IWXhk+2x/I==", 1155), Duration = 5 })
  end
  
  local FishingActive = false
  local fishingRodSlot = nil
  
  task.spawn(function()
      while getgenv().CentrixHubLoaded do
          pcall(function()
              if Config.AutoFish then
                  local root, humanoid = getCharacter()
                  if not root or not humanoid or humanoid.Health <= 0 then
                      FishingStatus:SetLabel(_0xcK12Ah5C6AP("hLptlWUnx5pKo88vRxq7P+MvvQQGXZaebsRblJrCR+Zvjs8sHUMwnE8tRWb=", 6553))
                  else
                      if not fishingRodSlot then
                          local slot = getSlot()
                          local inv = slot and slot:FindFirstChild(_0xcK12Ah5C6AP("yNiq1yMw1cU/k4scH9VvSM==", 46620)) and slot.Inventory:FindFirstChild(_0xcK12Ah5C6AP("l6Nd2Byp/b9rVwO5/sEwdb==", 23705))
                          local toolbar = slot and slot:FindFirstChild(_0xcK12Ah5C6AP("Q28PeneEM66FCgKwA7jpmP==", 48098)) and slot.Inventory:FindFirstChild(_0xcK12Ah5C6AP("G5kaQ4yJqem4GON/GcpHOE==", 24948))
                          if inv and toolbar then
                              for i, key in ipairs({_0xcK12Ah5C6AP("TuhegCQ+G4j=", 22431), _0xcK12Ah5C6AP("mKGq+9OxpVb=", 33298), _0xcK12Ah5C6AP("Clcy4vhVxrMuRJrc", 45914), _0xcK12Ah5C6AP("tdg5gKsFyFtWNNDc", 9353), _0xcK12Ah5C6AP("x8IxDaIkT170HczW", 527)}) do
                                  local entry = toolbar:FindFirstChild(key)
                                  if entry then
                                      for _, item in ipairs(inv:GetChildren()) do
                                          local id = item:FindFirstChild(_0xcK12Ah5C6AP("Tw7yk1YUXsv=", 45267))
                                          if id and id.Value == entry.Value then
                                              local def = Game.Items[item.Name]
                                              if type(def) == _0xcK12Ah5C6AP("iD1rtr5hNjgoir4e", 59076) and def.Category == _0xcK12Ah5C6AP("x9muhB4f+I18mB3KKr28IC==", 51546) then
                                                  fishingRodSlot = i
                                              end
                                              break
                                          end
                                      end
                                  end
                                  if fishingRodSlot then break end
                              end
                          end
                      end
                      if fishingRodSlot then
                          local equipped = LocalPlayer:FindFirstChild(_0xcK12Ah5C6AP("+b6TUAbr176cUQg98L0LLAfygBf2b7EL", 28555)) and LocalPlayer.Items_Config:FindFirstChild(_0xcK12Ah5C6AP("cOoUwBD2yIfzIPr/yOqQD2==", 2202))
                          if equipped and equipped.Value ~= fishingRodSlot then
                              if equipped.Value ~= 0 then
                                  equipped.Value = 0
                                  task.wait(0.5)
                              end
                              equipped.Value = fishingRodSlot
                              task.wait(0.5)
                          end
                          pcall(function()
                              Game.SignalEvent.ToServer(_0xcK12Ah5C6AP("CE1BRZp/ARdeqWxMUW/Z09m3RZRaEPPR", 61312), _0xcK12Ah5C6AP("a6EwCZMhNLb=", 35192), root.Position - Vector3.new(0, 0, 10))
                          end)
                          FishingStatus:SetLabel(_0xcK12Ah5C6AP("It2zeYS/mLiQFtEJgWw32Rim4v6yuPH2", 46032))
                          task.wait(8)
                      else
                          FishingStatus:SetLabel(_0xcK12Ah5C6AP("em5zwrUcXfIVldOnlL89iCxNQRXS07pvtBlyFOlMgTatyA8J0LC5YRxuXB8WTBKl", 9262))
                      end
                  end
              end
          end)
          task.wait(1)
      end
  end)
  
  local announcedMarket = nil
  local MarketerData = nil
  
  task.spawn(function()
      pcall(function()
          local Content = ReplicatedStorage.Ouwland and ReplicatedStorage.Ouwland:FindFirstChild(_0xcK12Ah5C6AP("8Zq+FAdF9uIwB/RYFCcY9Q==", 62356))
          if not Content then return end
          local Misc = Content:FindFirstChild(_0xcK12Ah5C6AP("hcSQaIue4wQlJNNS", 48076))
          local Npcs = Misc and Misc:FindFirstChild(_0xcK12Ah5C6AP("67xHe9gTMqahtP1r", 5840))
          local BM = Npcs and Npcs:FindFirstChild(_0xcK12Ah5C6AP("d5VWd9V6soV828A8Z7sz2amYZysXc5swS7VjOo==", 29374))
          if BM and BM:IsA(_0xcK12Ah5C6AP("QHOdkg74usNMaGR+kjE6KASbI76YO8hE", 41052)) then
              local ok, data = pcall(require, BM)
              if ok then MarketerData = data end
          end
      end)
  end)
  
  task.spawn(function()
      while getgenv().CentrixHubLoaded do
          pcall(function()
              if MarketerData and MarketerData.TimedVendor then
                  local ok, state = call(Game.TimedVendor.GetState, MarketerData.TimedVendor)
                  if ok and type(state) == _0xcK12Ah5C6AP("W7IHXvB55ODQzcNe", 62662) then
                      if state.Active then
                          MarketLabel:SetLabel(string.format(_0xcK12Ah5C6AP("xsj7LW8r9hS4tsgNWCXLeLB7zhwdBBlziLPnx88ULBSbqwOaodwMio5m9qPLtk7QFq51vwFuibt8doT+tsXPDojw9kacdTGI", 21117), countdown(state.NextEdgeIn)))
                          if announcedMarket ~= state.Cycle and Config.MarketNotify then
                              announcedMarket = state.Cycle
                              CentrixUI:Notify({ Title = _0xcK12Ah5C6AP("bxSwXrl8T1Ar20S810MvDNRIwdfpRUg2", 34903), Content = string.format(_0xcK12Ah5C6AP("RXQ29zUu6M8MVl5gDymSLumyB1L8LWrLHqceEXhcFWctNrVz9FrIRvR6qIPS5a4kHBEy+DXNMuVe6uPuXIhJqPcZhv6oEamW", 41595), countdown(state.NextEdgeIn)), Type = _0xcK12Ah5C6AP("ACG/gm4gGsHkcg+mC2ybdm==", 58398), Duration = 6 })
                          end
                      else
                          MarketLabel:SetLabel(string.format(_0xcK12Ah5C6AP("j1WJL+pfdJQxEvHtMuRqN5VlMQGQF+ixMSelCTmCML0SEu5dMvm62ag1eup5LQx6b90lFy0GOyrwMsC4jZerBC==", 44281), countdown(state.NextEdgeIn)))
                          if announcedMarket ~= state.Cycle then announcedMarket = state.Cycle end
                      end
                  end
              end
          end)
          task.wait(2)
      end
  end)
  
  task.spawn(function()
      while getgenv().CentrixHubLoaded do
          pcall(function()
              local slot = getSlot()
              if slot then
                  local clan = slot:FindFirstChild(_0xcK12Ah5C6AP("jsLs5SrNHmj8GOxS", 36549)) and slot.Clan.Value or _0xcK12Ah5C6AP("uoolUUozJCqaegHo", 28196)
                  CharacterLabel:SetLabel(string.format(_0xcK12Ah5C6AP("jepx1IHt+c4xPNOOpHINbd7cBtVMNrAbTFq/0GaY+PkLeGkp3D1BZGFCPNiYN7WYdIVz1+BUZ4OZD77c", 15217),
                      getLevel(), tostring(getValue(_0xcK12Ah5C6AP("Ba7cNeb44oNtixzC", 58247))), tostring(clan), tostring(getWen())))
              end
          end)
          task.wait(2)
      end
  end)
  
  CentrixUI:Notify({
      Title = _0xcK12Ah5C6AP("8Rn9HnkMeiatS8gGP/ShSZMTpZucjvGj", 31737),
      Content = _0xcK12Ah5C6AP("XUSXD9heVxwljgPHduDWVOgiVu4PufI4YDh9fqH6Y1D=", 29643),
      Type = _0xcK12Ah5C6AP("Eg+b96K2uvE6Vy2jD9zflv==", 285),
      Duration = 5,
  })
end
