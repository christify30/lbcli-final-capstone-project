# what block height was this tx mined ?
# 49990a9c8e60c8cba979ece134124695ffb270a98ba39c9824e42c4dc227c7eb

CLI="bitcoin-cli -signet"
TXID="49990a9c8e60c8cba979ece134124695ffb270a98ba39c9824e42c4dc227c7eb"

BLOCKHASH=$($CLI getrawtransaction "$TXID" 1 \
  | jq -r .blockhash)

$CLI getblock "$BLOCKHASH" 1 \
  | jq -r .height
