#!/bin/bash

echo "Building CodeArena Docker Sandbox Images..."
echo ""

languages=("python" "javascript" "java" "cpp")

for lang in "${languages[@]}"; do
  echo "Building codearena-sandbox-${lang}..."
  docker build -f Dockerfile.${lang} -t codearena-sandbox-${lang} .

  if [ $? -eq 0 ]; then
    echo "✓ codearena-sandbox-${lang} built successfully"
  else
    echo "✗ Failed to build codearena-sandbox-${lang}"
    exit 1
  fi
  echo ""
done

echo "All Docker sandbox images built successfully!"
echo ""
echo "Available images:"
docker images | grep codearena-sandbox
