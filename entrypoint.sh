#!/bin/sh

GITHUB_TOKEN=$1
GIPHY_API_KEY=$2

# Get PR number
pr_number=$(jq -r '.pull_request.number' "$GITHUB_EVENT_PATH")
echo "PR Number: $pr_number"

# Fetch GIF from Giphy
giphy_response=$(curl -s \
  "https://api.giphy.com/v1/gifs/random?api_key=$GIPHY_API_KEY&tag=thank%20you&rating=g")

echo "Giphy Response: $giphy_response"

# Extract GIF URL
gif_url=$(echo "$giphy_response" | jq -r '.data.images.downsized.url')
echo "GIF URL: $gif_url"

# Post comment on the Pull Request
response=$(curl -s -X POST \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/$GITHUB_REPOSITORY/issues/$pr_number/comments" \
  -d "{
    \"body\": \"PR - #$pr_number.\n\n🎉 Thank you for this contribution!\n\n![GIF]($gif_url)\"
  }")

echo "GitHub Response: $response"
echo "Comment URL: $(echo "$response" | jq -r '.html_url')"