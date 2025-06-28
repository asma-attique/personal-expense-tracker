# Use the official .NET SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build

WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the source code
COPY . ./

# Build and publish the app to the out folder
RUN dotnet publish -c Release -o out

# Use the ASP.NET Core runtime image for running the app
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime

WORKDIR /app
COPY --from=build /app/out .

# Expose port 80 to the outside world
EXPOSE 80

ENTRYPOINT ["dotnet", "ExpenseTracker.dll"]
