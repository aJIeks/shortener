json.id @link.id
json.hash @link.key
json.long_url @link.url
json.url shorted_url(@link.key)
json.visits @link.visits.size
