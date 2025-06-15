# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Install Node.js for React build
RUN apt-get update && \
    apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Copy the project file and restore dependencies
COPY FinalProjectTest/FinalProjectTest.csproj FinalProjectTest/
RUN dotnet restore FinalProjectTest/FinalProjectTest.csproj

# Copy all source code
COPY FinalProjectTest/ FinalProjectTest/

# Build React frontend
WORKDIR /src/FinalProjectTest/ClientApp
RUN npm install && npm run build

# Build .NET backend
WORKDIR /src/FinalProjectTest
RUN dotnet publish -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .

EXPOSE 10000
ENV ASPNETCORE_ENVIRONMENT=Production
ENV ASPNETCORE_URLS=http://+:10000

ENTRYPOINT ["dotnet", "FinalProjectTest.dll"]