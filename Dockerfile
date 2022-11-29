#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_ENVIRONMENT=Development
ENV ASPNETCORE_URLS=http://*:8080
#EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY . .
#COPY ["testDockerNet.csproj", "application/"]
RUN dotnet restore
RUN dotnet build -c Release -o out

FROM build AS publish
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

RUN ln -fs /usr/share/zoneinfo/Europe/Madrid /etc/localtime
RUN dpkg-reconfigure --frontend noninteractive tzdata

ENTRYPOINT ["dotnet", "testDockerNet.dll"]