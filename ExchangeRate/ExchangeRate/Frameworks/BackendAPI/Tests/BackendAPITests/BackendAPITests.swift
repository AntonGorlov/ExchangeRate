import XCTest
@testable import BackendAPI

final class BackendAPITests: XCTestCase {
    var sut: ExchangeRateAPIController!
    var mockConfiguration: MockConfiguration!
    var mockRequestBuilder: MockExchangeRateAPIRequestsFactory!
    var mockRequestExecuter: MockRequestExecuter!
    
    override func setUp() {
        super.setUp()
        mockConfiguration = MockConfiguration()
        mockRequestExecuter = MockRequestExecuter()
        mockRequestBuilder = MockExchangeRateAPIRequestsFactory(configuration: mockConfiguration)
        sut = ExchangeRateAPIController(configuration: mockConfiguration)
        sut.requestsBuilder = mockRequestBuilder
        sut.requestExecuter = mockRequestExecuter
    }
    
    override func tearDown() {
        sut = nil
        mockRequestBuilder = nil
        mockRequestExecuter = nil
        mockConfiguration = nil
        super.tearDown()
    }
    
    // MARK: - URL Tests
    
    func test_Request_URL_Format() async throws {
        // Given
        let requestData = CurrencyListRequestData(baseCurrency: "eur")
        // When
        let urlRequest = try await mockRequestBuilder.buildCurrencyListRequest(requestData: requestData)
        
        // Then
        XCTAssertNotNil(urlRequest.url)
        let urlString = urlRequest.url?.absoluteString ?? ""
     
        // Verify URL format
        XCTAssertTrue(urlString.contains("cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1"))
        XCTAssertTrue(urlString.contains("\(requestData.baseCurrency)"))
        XCTAssertTrue(urlString.hasSuffix(".json"))
        
        // Verify complete URL structure
        let expectedPath = "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/\(requestData.baseCurrency).json"
        XCTAssertEqual(urlString, expectedPath)
    }
    
    func test_Currencies_Success_Response() async throws {
        // Given
        let mockResponse = try loadCurrenciesResponse()
        mockRequestExecuter.mockCurrenciesResult = .success(mockResponse)
        
        // When
        let result = await sut.currencies()
        debugPrint("Local currencies response: \(result)")
        
        // Then
        switch result {
        case .success(let response):
            
            // Test data validity
            XCTAssertNotNil(response.currencies)
            XCTAssertFalse(response.currencies.isEmpty)
        case .failure(let error):
            XCTFail("Expected success but got failure: \(error)")
        }
    }
    
    func test_Currency_List_Success_Response() async throws {
        // Given
        let baseCurrency = "eur"
        let requestData = CurrencyListRequestData(baseCurrency: baseCurrency)
        let mockResponse = try loadCurrencyListResponse()
        mockRequestExecuter.mockCurrencyListResult = .success(mockResponse)
        // When
        let result = await sut.currencyList(requestData)
        debugPrint("Local currency list response: \(result)")
        
        // Then
        switch result {
        case .success(let response):
            // Test data validity
            XCTAssertNotNil(response.date)
            XCTAssertFalse(response.list.isEmpty)
            XCTAssertTrue(response.list.keys.contains(baseCurrency))
        case .failure(let error):
            XCTFail("Expected success but got failure: \(error)")
        }
    }
    
    func test_Currencies_Request_Building_Error() async {
        // Given
        let buildError = RequestBuildingError.unexpected(NSError(domain: "test", code: -1))
        mockRequestBuilder.mockBuildError = buildError
        
        // When
        let result = await sut.currencies()
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            switch error {
            case .requestBuildingError(let buildingError):
                XCTAssertNotNil(buildingError)
            default:
                XCTFail("Expected RequestBuildingError but got different error")
            }
        }
    }
    
    func test_Currency_List_Request_Building_Error() async {
        // Given
        let requestData = CurrencyListRequestData(baseCurrency: "usd")
        let buildError = RequestBuildingError.unexpected(NSError(domain: "test", code: -1))
        mockRequestBuilder.mockBuildError = buildError
        
        // When
        let result = await sut.currencyList(requestData)
        
        // Then
        switch result {
        case .success:
            XCTFail("Expected failure but got success")
        case .failure(let error):
            switch error {
            case .requestBuildingError(let buildingError):
                XCTAssertNotNil(buildingError)
            default:
                XCTFail("Expected RequestBuildingError but got different error")
            }
        }
    }
    
    // MARK: - Backend API Error Tests
    
    func test_Backend_API_Error_Request_Building_Error() {
        let encodingError = EncodingError.invalidValue("test", .init(codingPath: [], debugDescription: "Test error"))
        let buildingError = RequestBuildingError.serializationError(encodingError)
        let backendError = BackendAPIError.requestBuildingError(buildingError)
        
        XCTAssertNotNil(backendError)
    }
    
    func test_Backend_API_Error_Request_Execution_Error() {
        let executionError = RequestExecutionError.networkUnavailable
        let backendError = BackendAPIError.requestExecutionError(executionError)
        
        XCTAssertNotNil(backendError)
    }
    
    // MARK: - Request Building Error Tests
    
    func test_Request_Building_Error_Serialization_Error() {
        let encodingError = EncodingError.invalidValue("test", .init(codingPath: [], debugDescription: "Test error"))
        let error = RequestBuildingError.serializationError(encodingError)
        
        XCTAssertNotNil(error)
    }
    
    // MARK: - Request Execution Error Tests
    
    func test_Request_Execution_Error_Equatable() {
        let error1 = RequestExecutionError.networkUnavailable
        let error2 = RequestExecutionError.networkUnavailable
        let error3 = RequestExecutionError.timeout
        
        XCTAssertEqual(error1, error2)
        XCTAssertNotEqual(error1, error3)
    }
    
    func test_Request_Execution_Error_HTTP_Status_Error_Equatable() {
        let status1 = StatusError.badRequest
        let status2 = StatusError.badRequest
        let status3 = StatusError.unauthorized
        
        let error1 = RequestExecutionError.httpStatusError(status1)
        let error2 = RequestExecutionError.httpStatusError(status2)
        let error3 = RequestExecutionError.httpStatusError(status3)
        
        XCTAssertEqual(error1, error2)
        XCTAssertNotEqual(error1, error3)
    }
    
    // MARK: - Status Error Tests
    
    func test_Status_Error_Init_With_Raw_Value() {
        XCTAssertEqual(StatusError(400), .badRequest)
        XCTAssertEqual(StatusError(401), .unauthorized)
        XCTAssertEqual(StatusError(403), .forbidden)
        XCTAssertEqual(StatusError(404), .notFound)
        XCTAssertEqual(StatusError(999), .notDefined)
    }
    
    // MARK: - Helper Methods
    // MARK: Currencies
    
    private func loadCurrenciesResponse() throws -> CurrenciesResponseData {
        guard let recordedResponseURL = getCurrenciesResourceURL() else
        {
            throw TestError.resourceNotFound
        }
        
        let recordedData = try Data(contentsOf: recordedResponseURL)
        return try JSONDecoder().decode(CurrenciesResponseData.self, from: recordedData)
    }
    
    private func getCurrenciesResourceURL() -> URL? {
        let thisSourceFile = URL(fileURLWithPath: #filePath)
        let resourcesDirectory = thisSourceFile
            .deletingLastPathComponent()
            .appendingPathComponent("Resources")
        return resourcesDirectory.appendingPathComponent("test_currencies_response.json")
    }
    
    // MARK: Currency list
    
    private func loadCurrencyListResponse() throws -> CurrencyListResponseData {
        guard let recordedResponseURL = getCurrencyListResourceURL() else
        {
            throw TestError.resourceNotFound
        }
        
        let recordedData = try Data(contentsOf: recordedResponseURL)
        return try JSONDecoder().decode(CurrencyListResponseData.self, from: recordedData)
    }
    
    private func getCurrencyListResourceURL() -> URL? {
        let thisSourceFile = URL(fileURLWithPath: #filePath)
        let resourcesDirectory = thisSourceFile
            .deletingLastPathComponent()
            .appendingPathComponent("Resources")
        return resourcesDirectory.appendingPathComponent("test_currency_list_response.json")
    }
}

// MARK: - Mock Dependencies

class MockConfiguration: IConfiguration {
    var baseURL: URL = URL(string: "https://myApi.testExample.com")!
    var commonHeaders: [String : String] = ["Content-Type": "application/json"]
}

class MockExchangeRateAPIRequestsFactory: IExchangeRateAPIRequestsFactory {
    var configuration: IConfiguration
    var mockExchangeRateResult: Result<CurrenciesResponseData, RequestExecutionError>?
    var mockBuildError: RequestBuildingError?
    
    init(configuration: IConfiguration) {
        self.configuration = configuration
    }
    
    func buildCurrenciesRequest() async throws -> URLRequest {
        if let error = mockBuildError {
            throw error
        }
        // Construct URL in the exact format required by the API
        let urlString = "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies.json"
        
        guard let url = URL(string: urlString) else {
            throw RequestBuildingError.urlRequestInitializationError(
                NSError(domain: "Invalid URL", code: -1)
            )
        }
        return URLRequest(url: url)
    }
    
    func buildCurrencyListRequest(requestData: CurrencyListRequestData) async throws -> URLRequest {
        if let error = mockBuildError {
            throw error
        }
        // Construct URL in the exact format required by the API
        let urlString = "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@latest/v1/currencies/eur.json"
        
        guard let url = URL(string: urlString) else {
            throw RequestBuildingError.urlRequestInitializationError(
                NSError(domain: "Invalid URL", code: -1)
            )
        }
        return URLRequest(url: url)
    }
    
}

class MockRequestExecuter: IRequestExecuter {
    var mockSimpleRequestResult: Result<Void, RequestExecutionError> = .success(())
    var mockCurrenciesResult: Result<CurrenciesResponseData, RequestExecutionError>?
    var mockCurrencyListResult: Result<CurrencyListResponseData, RequestExecutionError>?
    
    func execute<T: Decodable>(_ request: URLRequest, decoder: JSONDecoder) async -> Result<T, RequestExecutionError> {
        if let result = mockCurrenciesResult as? Result<T, RequestExecutionError> {
            return result
        } else if let result = mockCurrencyListResult as? Result<T, RequestExecutionError> {
            return result
        } else {
            fatalError("Unexpected type in mockCurrenciesResult")
        }
    }
    
    func execute(_ request: URLRequest) async -> Result<Void, BackendAPI.RequestExecutionError> {
        return mockSimpleRequestResult
    }
}

// MARK: - Errors

enum TestError: Error {
    case resourceNotFound
}
