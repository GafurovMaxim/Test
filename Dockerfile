FROM mcr.microsoft.com/dotnet/runtime:6.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["TestConsole/TestConsole.csproj", "TestConsole/"]
RUN dotnet restore "TestConsole/TestConsole.csproj"
COPY . .
WORKDIR "/src/TestConsole"
RUN dotnet build "TestConsole.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "TestConsole.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TestConsole.dll"]
