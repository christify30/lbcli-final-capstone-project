# Which tx in block 216,351 spends the coinbase output of block 216,128?
coinbase_txid=$(bitcoin-cli -signet getblock $(bitcoin-cli -signet getblockhash 216128) | jq -r '.tx[0]')

bitcoin-cli -signet getblock $(bitcoin-cli -signet getblockhash 216351) | jq -r '.tx[]' | while read txid; do
  bitcoin-cli -signet getrawtransaction "$txid" true | jq -e --arg cb "$coinbase_txid" '.vin[] | select(.txid == $cb)' >/dev/null && echo "$txid" && break
done