#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["PrivateHub-Test/PrivateHub-Test.csproj", "PrivateHub-Test/"]
RUN dotnet restore "PrivateHub-Test/PrivateHub-Test.csproj"
COPY . .
WORKDIR "/src/PrivateHub-Test"
RUN dotnet build "PrivateHub-Test.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "PrivateHub-Test.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "PrivateHub-Test.dll"]