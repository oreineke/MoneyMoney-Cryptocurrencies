-- Copyright (c) 2022 Olaf Reineke

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
  version = 1.1,
  description = "Cryptocurrency asset tracking",
  services = {"Cryptocurrencies"}
}

local debug = false -- enter "debug" as the account password the turn on
local cryptoInfosUrl = "https://api.kraken.com/0/public/Ticker?pair="
local defaultAccountName = "Cryptocurrencies"

local cryptoCurrencyNames = {}
cryptoCurrencyNames["1INCH"] = "1inch"
cryptoCurrencyNames["AAVE"] = "Aave"
cryptoCurrencyNames["ACA"] = "Acala"
cryptoCurrencyNames["ACH"] = "Alchemy Pay"
cryptoCurrencyNames["ADA"] = "Cardano"
cryptoCurrencyNames["ADX"] = "Ambire Adex"
cryptoCurrencyNames["AGLD"] = "Adventure Gold"
cryptoCurrencyNames["AIR"] = "Altair"
cryptoCurrencyNames["AKT"] = "Akash"
cryptoCurrencyNames["ALCX"] = "Alchemix"
cryptoCurrencyNames["ALGO"] = "Algorand"
cryptoCurrencyNames["ALICE"] = "My Neighbor Alice"
cryptoCurrencyNames["ANKR"] = "Ankr"
cryptoCurrencyNames["ANT"] = "Aragon"
cryptoCurrencyNames["APE"] = "ApeCoin"
cryptoCurrencyNames["API3"] = "API3"
cryptoCurrencyNames["ASTR"] = "Astar"
cryptoCurrencyNames["ATLAS"] = "Star Atlas"
cryptoCurrencyNames["ATOM"] = "Cosmos"
cryptoCurrencyNames["AUDIO"] = "Audius"
cryptoCurrencyNames["AVAX"] = "Avalanche"
cryptoCurrencyNames["AXS"] = "Axie Infinity Shards"
cryptoCurrencyNames["BADGER"] = "Badger DAO"
cryptoCurrencyNames["BAL"] = "Balancer"
cryptoCurrencyNames["BAND"] = "Band Protocol"
cryptoCurrencyNames["BAT"] = "Basic Attention Token"
cryptoCurrencyNames["BCH"] = "Bitcoin Cash"
cryptoCurrencyNames["BICO"] = "Biconomy"
cryptoCurrencyNames["BIT"] = "BitDAO"
cryptoCurrencyNames["BNC"] = "Bifrost"
cryptoCurrencyNames["BNT"] = "Bancor"
cryptoCurrencyNames["BOND"] = "Barnbridge"
cryptoCurrencyNames["BTC"] = "Bitcoin"
cryptoCurrencyNames["CFG"] = "Centrifuge"
cryptoCurrencyNames["CHR"] = "Chromia"
cryptoCurrencyNames["CHZ"] = "Chiliz"
cryptoCurrencyNames["COMP"] = "Compound"
cryptoCurrencyNames["COTI"] = "COTI"
cryptoCurrencyNames["CQT"] = "Covalent"
cryptoCurrencyNames["CRV"] = "Curve DAO Token"
cryptoCurrencyNames["CTSI"] = "Cartesi"
cryptoCurrencyNames["CVC"] = "Civic"
cryptoCurrencyNames["CVX"] = "Convex"
cryptoCurrencyNames["DAI"] = "Dai"
cryptoCurrencyNames["DASH"] = "Dash"
cryptoCurrencyNames["DOGE"] = "Dogecoin"
cryptoCurrencyNames["DOT"] = "Polkadot"
cryptoCurrencyNames["DYDX"] = "dYdX"
cryptoCurrencyNames["ENJ"] = "Enjin"
cryptoCurrencyNames["ENS"] = "Ethereum Naming Service"
cryptoCurrencyNames["EOS"] = "EOS"
cryptoCurrencyNames["ETC"] = "Ethereum Classic"
cryptoCurrencyNames["ETH"] = "Ethereum"
cryptoCurrencyNames["ETH2"] = "Ethereum 2.0"
cryptoCurrencyNames["EWT"] = "Energy Web Token"
cryptoCurrencyNames["FET"] = "Fetch.ai"
cryptoCurrencyNames["FIDA"] = "Bonfida"
cryptoCurrencyNames["FIL"] = "Filecoin"
cryptoCurrencyNames["FLOW"] = "Flow"
cryptoCurrencyNames["FTM"] = "Fantom"
cryptoCurrencyNames["FXS"] = "Frax Share"
cryptoCurrencyNames["GALA"] = "Gala Games"
cryptoCurrencyNames["GARI"] = "Gari Network"
cryptoCurrencyNames["GHST"] = "Aavegotchi"
cryptoCurrencyNames["GLMR"] = "Moonbeam"
cryptoCurrencyNames["GMT"] = "STEPN"
cryptoCurrencyNames["GNO"] = "Gnosis"
cryptoCurrencyNames["GRT"] = "The Graph"
cryptoCurrencyNames["GST"] = "Green Satoshi Token"
cryptoCurrencyNames["ICP"] = "Internet Computer Protocol"
cryptoCurrencyNames["ICX"] = "ICON"
cryptoCurrencyNames["IDEX"] = "IDEX"
cryptoCurrencyNames["IMX"] = "Immutable X"
cryptoCurrencyNames["INJ"] = "Injective Protocol"
cryptoCurrencyNames["JASMY"] = "JasmyCoin"
cryptoCurrencyNames["KAR"] = "Karura"
cryptoCurrencyNames["KAVA"] = "Kava"
cryptoCurrencyNames["KEEP"] = "Keep Network"
cryptoCurrencyNames["KILT"] = "KILT"
cryptoCurrencyNames["KIN"] = "Kin"
cryptoCurrencyNames["KINT"] = "Kintsugi"
cryptoCurrencyNames["KNC"] = "Kyber Network"
cryptoCurrencyNames["KP3R"] = "Keep3r"
cryptoCurrencyNames["KSM"] = "Kusama"
cryptoCurrencyNames["LDO"] = "LIDO DAO"
cryptoCurrencyNames["LINK"] = "Chainlink"
cryptoCurrencyNames["LPT"] = "LivePeer"
cryptoCurrencyNames["LRC"] = "Loopring"
cryptoCurrencyNames["LSK"] = "Lisk"
cryptoCurrencyNames["LTC"] = "Litecoin"
cryptoCurrencyNames["LUNA"] = "Terra Classic"
cryptoCurrencyNames["LUNA2"] = "Terra 2.0"
cryptoCurrencyNames["MANA"] = "Decentra​land"
cryptoCurrencyNames["MASK"] = "Mask Network"
cryptoCurrencyNames["MATIC"] = "Polygon"
cryptoCurrencyNames["MC"] = "Merit Circle"
cryptoCurrencyNames["MINA"] = "Mina"
cryptoCurrencyNames["MIR"] = "Mirror Protocol"
cryptoCurrencyNames["MKR"] = "MakerDAO"
cryptoCurrencyNames["MLN"] = "Enzyme Finance"
cryptoCurrencyNames["MNGO"] = "Mango"
cryptoCurrencyNames["MOVR"] = "Moonriver"
cryptoCurrencyNames["MSOL"] = "Marinade SOL"
cryptoCurrencyNames["MULTI"] = "Multichain"
cryptoCurrencyNames["MV"] = "GensoKishi Metaverse"
cryptoCurrencyNames["NANO"] = "Nano"
cryptoCurrencyNames["NMR"] = "Numeraire"
cryptoCurrencyNames["NYM"] = "NYM"
cryptoCurrencyNames["OCEAN"] = "OCEAN Token"
cryptoCurrencyNames["OGN"] = "Origin Protocol"
cryptoCurrencyNames["OMG"] = "OMG Network"
cryptoCurrencyNames["ORCA"] = "Orca"
cryptoCurrencyNames["OXT"] = "Orchid"
cryptoCurrencyNames["OXY"] = "Oxygen"
cryptoCurrencyNames["PAXG"] = "PAX Gold"
cryptoCurrencyNames["PERP"] = "Perpetual Protocol"
cryptoCurrencyNames["PHA"] = "Phala"
cryptoCurrencyNames["PLA"] = "PlayDapp"
cryptoCurrencyNames["POLIS"] = "Star Atlas DAO"
cryptoCurrencyNames["POWR"] = "Powerledger"
cryptoCurrencyNames["PSTAKE"] = "PStake"
cryptoCurrencyNames["QNT"] = "Quant"
cryptoCurrencyNames["QTUM"] = "Qtum"
cryptoCurrencyNames["RAD"] = "Radicle"
cryptoCurrencyNames["RARE"] = "SuperRare"
cryptoCurrencyNames["RARI"] = "Rarible"
cryptoCurrencyNames["RAY"] = "Raydium"
cryptoCurrencyNames["RBC"] = "Rubic"
cryptoCurrencyNames["REN"] = "Ren"
cryptoCurrencyNames["REP"] = "Augur"
cryptoCurrencyNames["REPV2"] = "Augur v2"
cryptoCurrencyNames["REQ"] = "Request"
cryptoCurrencyNames["RLC"] = "iExec RLC"
cryptoCurrencyNames["RNDR"] = "Render"
cryptoCurrencyNames["ROOK"] = "KeeperDAO"
cryptoCurrencyNames["RUNE"] = "THORChain"
cryptoCurrencyNames["SAMO"] = "Samoyed Coin"
cryptoCurrencyNames["SAND"] = "Sand"
cryptoCurrencyNames["SBR"] = "Saber"
cryptoCurrencyNames["SC"] = "Siacoin"
cryptoCurrencyNames["SCRT"] = "Secret Network"
cryptoCurrencyNames["SDN"] = "Shiden"
cryptoCurrencyNames["SGB"] = "Songbird"
cryptoCurrencyNames["SHIB"] = "Shiba Inu"
cryptoCurrencyNames["SNX"] = "Synthetix"
cryptoCurrencyNames["SOL"] = "Solana"
cryptoCurrencyNames["SPELL"] = "Spell Token"
cryptoCurrencyNames["SRM"] = "Serum"
cryptoCurrencyNames["STEP"] = "Step Finance"
cryptoCurrencyNames["STORJ"] = "Storj"
cryptoCurrencyNames["SUPER"] = "SuperFarm"
cryptoCurrencyNames["SUSHI"] = "Sushi"
cryptoCurrencyNames["T"] = "Threshold"
cryptoCurrencyNames["TBTC"] = "tBTC"
cryptoCurrencyNames["TLM"] = "Alien Worlds"
cryptoCurrencyNames["TOKE"] = "Tokemak"
cryptoCurrencyNames["TRIBE"] = "Tribe"
cryptoCurrencyNames["TRX"] = "TRON"
cryptoCurrencyNames["TVK"] = "Terra Virtua Kolect"
cryptoCurrencyNames["UMA"] = "Universal Market Access"
cryptoCurrencyNames["UNI"] = "Uniswap"
cryptoCurrencyNames["USDC"] = "USD Coin"
cryptoCurrencyNames["USDT"] = "Tether USD"
cryptoCurrencyNames["UST"] = "TerraUSD Classic"
cryptoCurrencyNames["WAVES"] = "Waves"
cryptoCurrencyNames["WBTC"] = "Wrapped Bitcoin"
cryptoCurrencyNames["WOO"] = "Woo Network"
cryptoCurrencyNames["XBT"] = "Bitcoin"
cryptoCurrencyNames["XLM"] = "Lumen"
cryptoCurrencyNames["XMR"] = "Monero"
cryptoCurrencyNames["XRP"] = "Ripple"
cryptoCurrencyNames["XRT"] = "Robonomics"
cryptoCurrencyNames["XTZ"] = "Tezos"
cryptoCurrencyNames["YFI"] = "Yearn Finance"
cryptoCurrencyNames["YGG"] = "Yield Guild Games"
cryptoCurrencyNames["ZEC"] = "Zcash"
cryptoCurrencyNames["ZRX"] = "0x"

-- A table holding the list of cryptocurrency assests by [fiatCurrency].
-- Each crypto asset has fields "cryptoCurrency", "cryptoAmount" and "fiatAmount", for example:
--
--   cryptoAssets["USD"] == [
--    {
--     cryptoCurrency = "BTC,"
--     cryptoAmmount = 1.234,
--     fiatAmount = 3000.3
--    },
--    {
--     cryptoCurrency = "ETH,"
--     cryptoAmmount = 23,
--     fiatAmount = 40.3
--    }
--   ]
--
--   cryptoAssets["EUR"] == [
--    {
--     cryptoCurrency = "BCH,"
--     cryptoAmmount = 234.234,
--     fiatAmount = 1.3
--    },
--    {
--     cryptoCurrency = "ETH,"
--     cryptoAmmount = 5.6,
--     fiatAmount = 1000
--    }
--   ]
--
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
        .. " (example: \"1.2BTC@200USD : 3XRP@10.0EUR : 2XMR@10.1USD\")"
    end

    if debug then
      print("Handling crypto asset:", cryptoAmount, cryptoCurrency, "@", fiatAmount, fiatCurrency)
    end

    if cryptoAssets[fiatCurrency] == nil then
      cryptoAssets[fiatCurrency] = {}
    end

    table.insert(cryptoAssets[fiatCurrency], {
      cryptoCurrency = cryptoCurrency,
      cryptoAmount = tonumber(cryptoAmount),
      fiatAmount = tonumber(fiatAmount)
    })
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
    local cryptoInfos = requestCryptoInfos(fiatCurrency, cryptoAssetsForFiatCurrency)

    for _, asset in ipairs(cryptoAssetsForFiatCurrency) do
      if debug then
        print("Refresh asset: " .. asset.cryptoCurrency)
      end

      security = {
        market = "kraken.com",
        quantity = asset.cryptoAmount,
        purchasePrice = asset.fiatAmount
      }

      local cryptoInfo = cryptoInfos[asset.cryptoCurrency]

      if cryptoInfo == nil then
        security.name = "Unknown cryptocurrency (please correct in account username): " .. cryptoCurrency
      else
        security.name = cryptoInfo.name
        security.price = cryptoInfo.price
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
-- "name" and "price" (in the supplied fiat currency) for all crypto currencies listed
-- in the assests defined in the supplied cryptoAssetsForFiatCurrency table
function requestCryptoInfos(fiatCurrency, cryptoAssetsForFiatCurrency)
  local cryptoInfos = {}

  for _, asset in ipairs(cryptoAssetsForFiatCurrency) do
    if debug then
      print("Retrieve infos for pair: " .. asset.cryptoCurrency .. "/" .. fiatCurrency)
    end

    local request = cryptoInfosUrl ..  asset.cryptoCurrency .. fiatCurrency
    local response = connection:request("GET", request, {}, "", {Accept = "application/json"})
    local json = JSON(response):dictionary()

    for _, xerror in ipairs(json.error) do -- handle errors in response
      errorMessage = "Error fetching quotes for currency " .. fiatCurrency .. " from " .. request
      if xerror.type ~= nil then
        errorMessage = errorMessage .. ": " .. xerror.type
      end
      if xerror.mesg ~= nil then
        errorMessage = errorMessage .. " (" .. xerror.mesg .. ")"
      end

      error(errorMessage)
    end

    for _, ticker in pairs(json.result) do
      cryptoInfos[asset.cryptoCurrency] = {
        name = cryptoCurrencyName(asset.cryptoCurrency) .. " (" .. asset.cryptoCurrency .. ")",
        price = tonumber(ticker["c"][1])
      }
    end
  end

  return cryptoInfos
end

-- Return the full name of a cryptoCurrency
function cryptoCurrencyName(cryptoCurrency)
  local cryptoCurrencyName = cryptoCurrencyNames[cryptoCurrency]
  if cryptoCurrencyName == nil then
    return cryptoCurrency
  else
    return cryptoCurrencyName
  end
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

-- SIGNATURE: MCwCFBvsB/H03Gv+gZ91r4BzD9VigRFEAhR2dTr77Y7gL9/eU8Obxv5xSUOCMQ==
