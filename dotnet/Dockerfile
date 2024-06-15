# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS base

# EXPOSE 80
# EXPOSE 443

# COPY ["src/Afl.CBA.CustomerInfo.Api/", "src/Afl.CBA.CustomerInfo.Api/"]
# COPY ["src/Afl.CBA.CustomerInfo.Services/", "src/Afl.CBA.CustomerInfo.Services/"]
# COPY ["src/Afl.CBA.CustomerInfo.Data/", "src/Afl.CBA.CustomerInfo.Data/"]
# COPY ["src/Afl.CBA.CustomerInfo.Models/", "src/Afl.CBA.CustomerInfo.Models/"]
# COPY ["src/Afl.CBA.CustomerInfo.Core/", "src/Afl.CBA.CustomerInfo.Core/"]

# RUN dotnet restore "src/Afl.CBA.CustomerInfo.Api/Afl.CBA.CustomerInfo.Api.csproj"

# WORKDIR "src/Afl.CBA.CustomerInfo.Api"

# RUN dotnet publish -c Release -o /app/publish

# FROM mcr.microsoft.com/dotnet/aspnet:6.0

# WORKDIR /app
# COPY --from=base /app/publish .
# ENTRYPOINT ["dotnet", "Afl.CBA.CustomerInfo.Api.dll"]




# ################## GRPC ###############
# FROM mcr.microsoft.com/dotnet/sdk:6.0 AS base

# EXPOSE 5075

# COPY ["src/Afl.CBA.CustomerInfo.GrpcApi/", "src/Afl.CBA.CustomerInfo.GrpcApi/"]
# COPY ["src/Afl.CBA.CustomerInfo.Services/", "src/Afl.CBA.CustomerInfo.Services/"]
# COPY ["src/Afl.CBA.CustomerInfo.Data/", "src/Afl.CBA.CustomerInfo.Data/"]
# COPY ["src/Afl.CBA.CustomerInfo.Models/", "src/Afl.CBA.CustomerInfo.Models/"]
# COPY ["src/Afl.CBA.CustomerInfo.Core/", "src/Afl.CBA.CustomerInfo.Core/"]

# RUN dotnet restore "src/Afl.CBA.CustomerInfo.GrpcApi/Afl.CBA.CustomerInfo.GrpcApi.csproj"

# WORKDIR "src/Afl.CBA.CustomerInfo.GrpcApi"

# RUN dotnet publish -c Release -o /app/publish

# FROM mcr.microsoft.com/dotnet/aspnet:6.0

# WORKDIR /app
# COPY --from=base /app/publish .
# ENTRYPOINT ["dotnet", "Afl.CBA.CustomerInfo.GrpcApi.dll"]