# ExchangeRate
Real-Time Exchange Rate Tracker 

I use a free API to get currency exchange.
https://github.com/fawazahmed0/exchange-api

I used 2 requests:
Lists all the available currencies in prettified json format:

https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies.json

Get the currency list with EUR as base currency:

https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/eur.json

This request has the “euro” currency by default, after adding the first favorite currency we use it for further requests

A modular architecture in the form of BackendAPI has been added to the project. The main advantage is that it can be used in MacOS, iPadOS or iOS with any client-side implementation.

Wrote some tests for the project and BackendAPI.
You need to press command+U to run.

Enjoy.

![image](https://github.com/user-attachments/assets/920b0d1b-e081-445f-8ccd-1ecebc5e715e)
