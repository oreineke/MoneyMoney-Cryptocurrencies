-- Copyright (c) 2021 Olaf Reineke

-- A Cryptocurrency extension for MoneyMoney (see https://moneymoney-app.com):
--  Defines cryptocurrency assets (amount & purchase price) via the account username
--  Determines cryptocurrency asset prices via kraken.com
--  Shows cryptocurrency assets as securities (grouped by fiat currency)
--
-- Use the account username to define your crypto assets as a colon (":")
-- separated list of expressions (where "fiat" stands for classical currencies,
-- like "EUR" or "USD"):
--
--  <crypto amount> <crypto currency> @ <fiat purchase price> <fiat purchase currency>
--
-- For example:
--
--  1.234 BTC @ 3000.3 USD : 12 ETH @ 100 EUR
--
-- means that you own 1.234 BTC which you have bought at 3000.3 USD, and 12 ETH
-- bought at 100 EUR.
--
-- Since spaces are optional, case doesn't matter, and a comma is treated as a
-- dot, you may also write the above as:
--
--  1,234btc@3000,3usd:12eth@100eur
--
-- If you enter "debug" as the account password, the extension will print debug
-- information to the MoneyMoney protocol window. Otherwise, the password does
-- matter.

WebBanking {
  version = 1.0,
  description = "A Cryptocurrency asset tracking extension for MoneyMoney",
  services = {"Cryptocurrencies"}
}

local debug = false -- enter "debug" as the account password the turn on
local cryptoInfosUrl = "https://www.kraken.com/api/internal/cryptowatch/markets/assets?limit=100&assetName=new&asset="
local defaultAccountName = "Cryptocurrencies"

-- A two dimensional table holding the cryptocurrency assests by [fiatCurrency][cryptoCurrency].
-- Each crypto asset has fields "cryptoAmount" and "fiatAmount", for example:
--
--   cryptoAssets["USD"]["BTC"] == {
--     cryptoAmmount = 1.234,
--     fiatAmount = 3000.3
--   }
--
--   cryptoAssets["EUR"]["ETH"] == {
--     cryptoAmmount = 12,
--     fiatAmount = 100
--   }
local cryptoAssets = {}

local connection = Connection()

function SupportsBank(protocol, bankCode)
  return protocol == ProtocolWebBanking and bankCode == "Cryptocurrencies"
end

function InitializeSession(protocol, bankCode, username, customer, password)
  if (password == "debug") then
    debug = true
  end

  if debug then
    print("Crypto assets definition:", username)
  end

  assetsDefinitions = username:gsub("%s+", ""):gsub(",", ".")

  for assetDefinition in string.gmatch(assetsDefinitions, "[^:]+") do
    start, _, cryptoAmount, cryptoCurrency, fiatAmount, fiatCurrency =
      string.find(string.upper(assetDefinition), "^(%d*[,.]?%d*)(%u+)@(%d*[,.]?%d*)(%u%u%u)$")

    if (start == nil) then
      return "This is not a valid crypto asset definition: " .. assetDefinition
        .. " (example: 1.2BTC@200USD)"
    end

    if debug then
      print("Handling crypto asset:", cryptoAmount, cryptoCurrency, "@", fiatAmount, fiatCurrency)
    end

    if cryptoAssets[fiatCurrency] == nil then
      cryptoAssets[fiatCurrency] = {}
    end

    cryptoAssets[fiatCurrency][cryptoCurrency] = {
      cryptoAmount = tonumber(cryptoAmount),
      fiatAmount = tonumber(fiatAmount)
    }
  end
end

function ListAccounts(knownAccounts)
  local accounts = {}

  for fiatCurrency, _ in pairs(cryptoAssets) do
    if debug then
      print("List accounts: " .. fiatCurrency)
    end

    accounts[#accounts + 1] = {
      type = "AccountTypePortfolio",
      portfolio = true,
      name = defaultAccountName .. " (" .. fiatCurrency .. ")",
      accountNumber = defaultAccountName .. " (" .. fiatCurrency .. ")",
      currency = fiatCurrency
    }
  end

  return accounts
end

function RefreshAccount(account, since)
  local securities = {}

  local fiatCurrency = account.currency
  local cryptoAssetsForFiatCurrency = cryptoAssets[fiatCurrency]

  if not isEmptyTable(cryptoAssetsForFiatCurrency) then
    cryptoInfos = requestCryptoInfos(fiatCurrency)

    for cryptoCurrency, asset in pairs(cryptoAssetsForFiatCurrency) do
      cryptoInfo = cryptoInfos[cryptoCurrency]

      security = {
        market = "kraken.com",
        quantity = asset.cryptoAmount,
        purchasePrice = asset.fiatAmount
      }

      if cryptoInfo == nil then
        security.name = "Unknown cryptocurrency (please correct in account username): " .. cryptoCurrency
      else
        security.name = cryptoInfos[cryptoCurrency].name
        security.price = cryptoInfos[cryptoCurrency].price
      end

      securities[#securities + 1] = security
    end
  end

  return {
    securities = securities
  }
end

function EndSession()
end

-- For the supplied fiatCurrency, return a table by [cryptoCurrency], containing
-- "name" and "price" (in the supplied fiat currency) of all known crypto currencies
function requestCryptoInfos(fiatCurrency)
  local request = cryptoInfosUrl .. fiatCurrency
  local response = connection:request("GET", request, {}, "", {Accept = "application/json"})
  local json = JSON(response):dictionary()

  for _, xerror in ipairs(json.errors) do -- handle errors in response
    errorMessage = "Error fetching quotes for currency " .. fiatCurrency .. " from " .. request
    if xerror.type ~= nil then
      errorMessage = errorMessage .. ": " .. xerror.type
    end
    if xerror.mesg ~= nil then
      errorMessage = errorMessage .. " (" .. xerror.mesg .. ")"
    end

    error(errorMessage)
  end

  local cryptoInfos = {}
  for _, result in ipairs(json.result) do
    cryptoInfos[result.asset] = {
      name = result.name .. " (" .. result.asset .. ")",
      price = result.price
    }
  end

  return cryptoInfos
end

-- Return true, if the supplied table is nil or empty
function isEmptyTable(table)
  if table == nill then
    return true
  end

  local size = 0
  for _ in pairs(table) do
    size = size + 1
  end

  return size == 0
end

-- SIGNATURE: MCwCFEHZst3WJVCWZWz55+beNxpvluSvAhQo75pCBFSRZZKv3oqUlat+h/+Yrg==
