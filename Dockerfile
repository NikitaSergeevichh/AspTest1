#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["AspTest1.csproj", "."]
RUN dotnet restore "./AspTest1.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "AspTest1.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "AspTest1.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "AspTest1.dll"]