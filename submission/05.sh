# How many satoshis did this transaction pay for fee?: b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb
TXID="b71fb9ab7707407cc7265591e0c0d47d07afede654f91de1f63c0cb522914bcb"
CLI="bitcoin-cli -signet"

$CLI getrawtransaction "$TXID" 1 > tx.json

sum_outputs_sat=$(
  jq '[.vout[].value] 
      | map(.*100000000 | floor) 
      | add' tx.json
)

sum_inputs_sat=$(
  jq -c '.vin[]' tx.json | while read -r vin; do
    prev_txid=$(jq -r '.txid'   <<<"$vin")
    prev_vout=$(jq -r '.vout'   <<<"$vin")
    $CLI getrawtransaction "$prev_txid" 1 \
      | jq ".vout[$prev_vout].value * 100000000 | floor"
  done \
  | awk '{total += $1} END {printf "%.0f\n", total}'
)

fee_sat=$(( sum_inputs_sat - sum_outputs_sat ))

echo "${fee_sat}"