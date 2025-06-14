FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

# Install Node.js
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs && \
    node -v && npm -v

# ✅ Copy full project (with React client)
COPY . .

# Frontend build
WORKDIR /app/ClientApp
RUN npm install
RUN npm run build

# Backend build
WORKDIR /app
RUN dotnet publish FinalProjectTest.csproj -c Release -o /out

# Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=build /out .

ENTRYPOINT ["dotnet", "FinalProjectTest.dll"]
