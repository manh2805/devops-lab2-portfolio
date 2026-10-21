$ErrorActionPreference = "Stop"

# Luon tao file trong thu muc chua script
Set-Location $PSScriptRoot

New-Item -ItemType Directory -Path "screenshots" -Force | Out-Null

@'
{
  "name": "devops-lab2-docker",
  "version": "1.0.0",
  "description": "DevOps Lab 2 - Docker Lean Demo",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  }
}
'@ | Set-Content -Path "package.json" -Encoding utf8

@'
const http = require('http');

const server = http.createServer((req, res) => {
    res.writeHead(200, { 'Content-Type': 'application/json' });
    res.end(JSON.stringify({
        message: 'Hello from Docker!',
        lab: 'DevOps Lab 2 - Lean Principle',
        timestamp: new Date().toISOString(),
        node_version: process.version,
        platform: process.platform
    }));
});

const PORT = 3000;
server.listen(PORT, '0.0.0.0', () => {
    console.log(`Server running at http://localhost:${PORT}`);
    console.log(`Environment: Node.js ${process.version} on ${process.platform}`);
});
'@ | Set-Content -Path "server.js" -Encoding utf8

@'
FROM node:18-alpine
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
'@ | Set-Content -Path "Dockerfile" -Encoding utf8

@'
node_modules
.git
screenshots
*.zip
'@ | Set-Content -Path ".dockerignore" -Encoding utf8

Write-Host ""
Write-Host "=== SETUP COMPLETED ===" -ForegroundColor Green
Write-Host "Created project files and screenshots folder."
Get-ChildItem -Force