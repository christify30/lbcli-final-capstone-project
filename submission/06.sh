# Only one tx in block 243,821 signals opt-in RBF. What is its txid?
for txid in $(bitcoin-cli -signet getblock $(bitcoin-cli -signet getblockhash 243821) | jq -r '.tx[]'); do
    # Check if any input has nSequence < 0xFFFFFFFE (4294967294)
    bitcoin-cli -signet getrawtransaction "$txid" true | \
    jq -e '.vin[] | select(.sequence < 4294967294)' >/dev/null && \
    echo "RBF-signaling txid: $txid" && break
done
