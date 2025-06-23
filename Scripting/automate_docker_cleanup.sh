#!/bin/bash

echo "Running full system Prune ..."
echo "Deleting unused images, stopped containers, unused volumes, networks and cache.."
docker system prune -f -a --volumes

echo "✅ Docker cleanup complete!"
