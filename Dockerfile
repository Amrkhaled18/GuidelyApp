FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

# Copy everything
COPY . .

# Frontend
WORKDIR /app/ClientApp
RUN npm install
RUN npm run build

# Backend
WORKDIR /app
RUN dotnet publish FinalProjectTest.csproj -c Release -o /out

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app
COPY --from=build /out .

ENTRYPOINT ["dotnet", "FinalProjectTest.dll"]