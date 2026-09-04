using ItsTool.Infrastructure.Services;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Moq;
using Xunit;

namespace ItsTool.UnitTests.Services;

public class LocalFileStorageServiceTests
{
    private readonly string _testPath = Path.Combine(Path.GetTempPath(), "ItsmTestUploads");

    public LocalFileStorageServiceTests()
    {
        if (Directory.Exists(_testPath)) Directory.Delete(_testPath, true);
    }

    [Fact]
    public async Task SaveFileAsync_ShouldRejectInvalidMime()
    {
        var configMock = new Mock<IConfiguration>();
        configMock.Setup(c => c["FileStorage:BasePath"]).Returns(_testPath);
        var service = new LocalFileStorageService(configMock.Object);

        var fileMock = new Mock<IFormFile>();
        fileMock.Setup(f => f.ContentType).Returns("application/x-msdownload"); // .exe
        fileMock.Setup(f => f.FileName).Returns("test.exe");
        
        await Assert.ThrowsAsync<InvalidOperationException>(() => service.SaveFileAsync(fileMock.Object, 1));
    }

    [Fact]
    public async Task SaveFileAsync_ShouldRejectLargeFile()
    {
        var configMock = new Mock<IConfiguration>();
        configMock.Setup(c => c["FileStorage:BasePath"]).Returns(_testPath);
        var service = new LocalFileStorageService(configMock.Object);

        var fileMock = new Mock<IFormFile>();
        fileMock.Setup(f => f.ContentType).Returns("application/pdf");
        fileMock.Setup(f => f.Length).Returns(15 * 1024 * 1024); // 15MB
        fileMock.Setup(f => f.FileName).Returns("test.pdf");
        
        await Assert.ThrowsAsync<InvalidOperationException>(() => service.SaveFileAsync(fileMock.Object, 1));
    }
}
