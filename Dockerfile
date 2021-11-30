#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["DockerAppWebApiEg2/DockerAppWebApiEg2.csproj", "DockerAppWebApiEg2/"]
RUN dotnet restore "DockerAppWebApiEg2/DockerAppWebApiEg2.csproj"
COPY . .
WORKDIR "/src/DockerAppWebApiEg2"
RUN dotnet build "DockerAppWebApiEg2.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DockerAppWebApiEg2.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DockerAppWebApiEg2.dll"]