 # Cryptocurrencies
"Cryptocurrencies" is an extension for the [MoneyMoney Application](https://moneymoney-app.com).

## Purpose
The "Cryprocurrencies" extension allows you to show all your cryptocurrency assets, like Bitcoins or Ethers, in MoneyMoney as securities, along with their current price, purchase price and gains (or, hopefully not, losses):

![MoneyMoney screenshot of cryptocurrency assets](images/Assets%20USD.png)

Current crypto prices are automatically obtained from kraken.com.

## Security, Data Protection
Although this extension is not officially endorsed by the makers of MoneyMoney, it has been provided to them and has been signed by them.

Also, feel free to check the source code youself.

This extension does *not* collect or share any kind of data.

The only external connect this extension will make is to a kraken.com webservice to query the current prices for *all* available cryptocurrencies in the fiat currencies you use (during a refresh of your securities account).

This extension will *not* leak the kind or amount of cryptocurrencies you own to Kraken!

## Installation
1. Download the file [Cryptocurrencies.lua](https://github.com/oreineke/MoneyMoney-Cryptocurrencies/releases/download/Current/Cryptocurrencies.lua).
2. In "MoneyMoney", open the menu "Help", then click on "Show Database in Finder".
3. Copy the file "Cryptocurrencies.lua" downloaded in step 1 into the "Extensions" folder that opened in step 2.

## Usage
1. Create a new account, select "Others", then "Cryptocurrencies":
   
   ![Screenshot Add Account Step 1](images/Add%20Account%20Step%201.png) 
2. In the "**Username**" field, define your cryptocurrency assets (amount & purchase price): 
   
   ![Screenshot Add Account Step 2](images/Add%20Account%20Step%202.png)

   For example, if you have **0.02 BTC** that you bought **at 40730.2 USD** and **1.2 BCH** bought **at 547.3 USD**, enter the following:
    
         0.02 BTC @ 40730.2 USD : 1.2 BCH @ 547.3 USD
   
   Here, a colon (":") separates each asset definition, and each asset definition is of the form 
   
   `<crypto amount> <crypto currency> @ <fiat purchase price> <fiat purchase currency>`
   
   (where "fiat" stands for classical currencies, like "EUR" or "USD").
   
   Spaces are optional, case doesn't matter, and a comma is treated as a dot, so you may also write the above example as:

         0,02btc@40730,2usd:1,2bch@547,3usd

   Check the [Kraken Cryptocurrency Prices Page](https://www.kraken.com/prices) for a list of available cryptocurrencies.

   Whatever you enter in the "**Password**" field is not used (unless you enter "debug" as the password, which will cause additional information to be visible in the MoneyMoney "Log" window). 
   
   Make sure to check the "Save Password" box.

3. You will now be presented with the accounts to be added, one for each fiat currency used in the assets definition. Edit the names if you want to, then click "Done":
   ![3. Add Accout](images/Add%20Account%20Step%203.png)
 
If you later want to change you crypto assets, just edit the account login data from one of the cryptocurrency accounts:

![Update Assets](images/Update%20Assets.png)

## Legal Disclaimer
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.