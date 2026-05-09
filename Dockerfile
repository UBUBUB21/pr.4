FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["pr.4.csproj", "./"]
RUN dotnet restore "pr.4.csproj"

COPY . .
RUN dotnet build "pr.4.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "pr.4.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

EXPOSE 8080

ENV ASPNETCORE_URLS=http://+:8080
ENV ASPNETCORE_ENVIRONMENT=Production
COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "pr.4.dll"]
