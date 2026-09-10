# ==============================================================================
# Aşama 1: Base Runtime (Çalışma Zamanı Ortamı)
# ==============================================================================
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

# ==============================================================================
# Aşama 2: Build (Derleme Ortamı)
# ==============================================================================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Katman Önbelleği (Layer Caching): Önce sadece proje dosyaları kopyalanır
COPY ["src/ItsTool.Domain/ItsTool.Domain.csproj", "src/ItsTool.Domain/"]
COPY ["src/ItsTool.Application/ItsTool.Application.csproj", "src/ItsTool.Application/"]
COPY ["src/ItsTool.Infrastructure/ItsTool.Infrastructure.csproj", "src/ItsTool.Infrastructure/"]
COPY ["src/ItsTool.API/ItsTool.API.csproj", "src/ItsTool.API/"]

RUN dotnet restore "src/ItsTool.API/ItsTool.API.csproj"

# Kaynak kodları kopyala ve Release modda derle
COPY src/ src/
WORKDIR "/src/src/ItsTool.API"
RUN dotnet build "ItsTool.API.csproj" -c Release -o /app/build --no-restore

# ==============================================================================
# Aşama 3: Publish (Paketleme)
# ==============================================================================
FROM build AS publish
RUN dotnet publish "ItsTool.API.csproj" -c Release -o /app/publish /p:UseAppHost=false --no-restore

# ==============================================================================
# Aşama 4: Final İmaj (Üretim Ortamı)
# ==============================================================================
FROM base AS final
WORKDIR /app

# Derlenmiş DLL ve ayar dosyalarını kopyala
COPY --from=publish /app/publish .

# Web frontend statik dosyalarını wwwroot altına kopyala
COPY src/ItsTool.Web/wwwroot/ ./wwwroot/

# Dosya yüklemeleri için uploads dizinini oluştur ve app kullanıcısına yetki ver
RUN mkdir -p /app/uploads && chown -R app:app /app

# Güvenlik: Container içinde root olmayan 'app' kullanıcısı ile çalıştır
USER app

ENTRYPOINT ["dotnet", "ItsTool.API.dll"]
