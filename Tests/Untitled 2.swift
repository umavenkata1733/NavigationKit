
import XCTest
@testable import YourModuleName // Replace with your actual module name

class BNCNetworkManagerTests: XCTestCase {
    
    // MARK: - Mock Classes
    
    class MockNetworkAdapter: NetworkAdapter {
        var mockResult: Result<NetworkDecodedSuccess<MockDecodable>, Error> = .success(NetworkDecodedSuccess(decoded: MockDecodable(), response: MockResponse(), request: MockRequest()))
        
        override func sendRequest<T: Decodable>(
            to endPoint: Endpoint,
            in environment: Environment,
            with additionalHeader: [String: String] = [:],
            expecting: T.Type,
            including body: Data? = nil,
            timeout: Double? = nil,
            retryConfig: RetryConfig? = nil
        ) async throws -> NetworkDecodedSuccess<T> {
            switch mockResult {
            case .success(let success):
                return success as! NetworkDecodedSuccess<T>
            case .failure(let error):
                throw error
            }
        }
    }
    
    class MockBNCBenefitsBffService: BNCBenefitsBffService {
        var mockHeaders: [String: String] = ["Authorization": "Bearer token"]
        var mockValidationResult: Bool = true
        
        func getRequiredBffHeaders(for endPoint: BNCMobileEndpoint) -> [String: String] {
            return mockHeaders
        }
        
        func validateResponse<T: Decodable>(for response: NetworkDecodedResult<T>) -> Bool {
            return mockValidationResult
        }
    }
    
    class MockEndpoint: BNCMobileEndpoint {
        var path: String = "/test/path"
        var requiredAUth: Bool = true
    }
    
    struct MockResponse: NetwokResponse {
        var statusCode: Int = 200
        var header: [String: String] = [:]
        
        func localizedString(forStatusCode statucCode: Int) -> String {
            return "OK"
        }
    }
    
    struct MockRequest: NetworkRequest {
        var url: URL? = URL(string: "https://example.com")
        var httpMethod: String? = "GET"
        var allHttpHeaderFields: [String: String]? = [:]
        var httpBody: Data? = nil
        
        init() {}
        
        init?(to endPoint: Endpoint, in environment: Environment, including body: Data?) {
            // Implementation for the test
        }
    }
    
    struct MockDecodable: Decodable, Equatable {
        var id: String = "test-id"
    }
    
    // MARK: - Properties
    
    var networkManager: BNCNetworkManager!
    var mockAdapter: MockNetworkAdapter!
    var mockBffService: MockBNCBenefitsBffService!
    var mockEnvironment: BNCMobileServiceEnvironment!
    var mockEndpoint: MockEndpoint!
    
    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
        
        mockAdapter = MockNetworkAdapter()
        mockBffService = MockBNCBenefitsBffService()
        mockEnvironment = BNCMobileServiceEnvironment(baseURL: URL(string: "https://example.com")!)
        mockEndpoint = MockEndpoint()
        
        networkManager = BNCNetworkManager(environment: mockEnvironment, bffService: mockBffService)
        // Replace the network adapter with our mock
        // Note: This requires making the networkAdapter property accessible for testing
        // You might need to add a setter method or make it internal instead of private
        networkManager.networkAdapter = mockAdapter
    }
    
    override func tearDown() {
        networkManager = nil
        mockAdapter = nil
        mockBffService = nil
        mockEnvironment = nil
        mockEndpoint = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testInit() {
        // Test that the initialization properly sets up the environment and BFF service
        XCTAssertNotNil(networkManager)
        // You'll need to make these properties accessible for testing
        XCTAssertIdentical(networkManager.benefitsbffService as? MockBNCBenefitsBffService, mockBffService)
        XCTAssertEqual(networkManager.environment.baseURL, mockEnvironment.baseURL)
    }
    
    func testRequiredHeaders() {
        // Test that the required headers are correctly obtained from the BFF service
        let expectedHeaders = ["Authorization": "Bearer token"]
        mockBffService.mockHeaders = expectedHeaders
        
        let headers = networkManager.requiredHeaders(endPoint: mockEndpoint)
        
        XCTAssertEqual(headers, expectedHeaders)
    }
    
    func testUpdateHeaders() {
        // Test that updating headers works correctly
        let initialHeaders: [String: String] = [:]
        let updatedHeaders = ["Content-Type": "application/json"]
        
        XCTAssertEqual(networkManager.sharedHeaders, initialHeaders)
        
        networkManager.updateHeaders(updatedHeaders)
        
        XCTAssertEqual(networkManager.sharedHeaders, updatedHeaders)
    }
    
    func testSendRequest_Success() async {
        // Test the successful response path
        let expectation = XCTestExpectation(description: "Network request completed successfully")
        
        let mockData = MockDecodable()
        let mockResponse = MockResponse()
        let mockRequest = MockRequest()
        
        mockAdapter.mockResult = .success(NetworkDecodedSuccess(decoded: mockData, response: mockResponse, request: mockRequest))
        
        networkManager.sendRequest(
            endpoint: mockEndpoint,
            expecting: MockDecodable.self
        ) { result in
            switch result {
            case .success(let data, let response, let request):
                XCTAssertEqual(data as? MockDecodable, mockData)
                XCTAssertEqual(response.statusCode, mockResponse.statusCode)
                XCTAssertEqual(request.url, mockRequest.url)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testSendRequest_Failure() async {
        // Test the error path
        let expectation = XCTestExpectation(description: "Network request completed with failure")
        
        let networkError = NetworkError.timeout
        
        mockAdapter.mockResult = .failure(networkError)
        
        networkManager.sendRequest(
            endpoint: mockEndpoint,
            expecting: MockDecodable.self
        ) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error, _, _):
                XCTAssertEqual(error as? NetworkError, networkError)
                expectation.fulfill()
            }
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testSendRequest_WithBody() async {
        // Test sending a request with a body
        let expectation = XCTestExpectation(description: "Network request with body completed")
        
        let mockData = MockDecodable()
        let mockResponse = MockResponse()
        let mockRequest = MockRequest()
        let requestBody = "test".data(using: .utf8)
        
        mockAdapter.mockResult = .success(NetworkDecodedSuccess(decoded: mockData, response: mockResponse, request: mockRequest))
        
        // Spy on the adapter's sendRequest call to verify the body is passed correctly
        let originalMethod = mockAdapter.sendRequest
        
        var capturedBody: Data?
        mockAdapter.sendRequest = { endPoint, environment, additionalHeader, expecting, body, timeout, retryConfig in
            capturedBody = body
            return try await originalMethod(endPoint, environment, additionalHeader, expecting, body, timeout, retryConfig)
        }
        
        networkManager.sendRequest(
            endpoint: mockEndpoint,
            including: requestBody,
            expecting: MockDecodable.self
        ) { _ in
            XCTAssertEqual(capturedBody, requestBody)
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testHandleResponse_Success() {
        // Test the successful response handling
        let expectation = XCTestExpectation(description: "Handle successful response")
        
        let mockData = MockDecodable()
        let mockResponse = MockResponse()
        let mockRequest = MockRequest()
        let successResult: NetworkDecodedResult<MockDecodable> = .success(mockData, mockResponse, mockRequest)
        
        networkManager.handleResponse(
            decodedNetworkResult: successResult,
            requestHeaders: [:],
            isAuthenticated: true
        ) { result in
            switch result {
            case .success(let data, let response, let request):
                XCTAssertEqual(data as? MockDecodable, mockData)
                XCTAssertEqual(response.statusCode, mockResponse.statusCode)
                XCTAssertEqual(request.url, mockRequest.url)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testHandleResponse_Failure() {
        // Test the failure response handling
        let expectation = XCTestExpectation(description: "Handle failure response")
        
        let networkError = NetworkError.timeout
        let mockResponse = MockResponse()
        let mockRequest = MockRequest()
        let failureResult: NetworkDecodedResult<MockDecodable> = .failure(networkError, mockResponse, mockRequest)
        
        networkManager.handleResponse(
            decodedNetworkResult: failureResult,
            requestHeaders: [:],
            isAuthenticated: true
        ) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error, let response, let request):
                XCTAssertEqual(error as? NetworkError, networkError)
                XCTAssertEqual(response?.statusCode, mockResponse.statusCode)
                XCTAssertEqual(request?.url, mockRequest.url)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testHandleResponse_NonHTTPResponse() {
        // Test handling a non-HTTP response
        let expectation = XCTestExpectation(description: "Handle non-HTTP response")
        
        class CustomResponse: NetwokResponse {
            var statusCode: Int = 200
            var header: [String: String] = [:]
            
            func localizedString(forStatusCode statucCode: Int) -> String {
                return "Custom"
            }
        }
        
        let mockData = MockDecodable()
        let customResponse = CustomResponse()
        let mockRequest = MockRequest()
        let successResult: NetworkDecodedResult<MockDecodable> = .success(mockData, customResponse, mockRequest)
        
        networkManager.handleResponse(
            decodedNetworkResult: successResult,
            requestHeaders: [:],
            isAuthenticated: true
        ) { result in
            switch result {
            case .success(let data, let response, let request):
                XCTAssertEqual(data as? MockDecodable, mockData)
                XCTAssertEqual(response.statusCode, customResponse.statusCode)
                XCTAssertEqual(request.url, mockRequest.url)
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    // Additional tests for edge cases
    
    func testSendRequest_WithHeadersMerging() async {
        // Test that headers are correctly merged
        let expectation = XCTestExpectation(description: "Headers are correctly merged")
        
        let requiredHeaders = ["Authorization": "Bearer token"]
        let sharedHeaders = ["Content-Type": "application/json"]
        let expectedMergedHeaders = ["Authorization": "Bearer token", "Content-Type": "application/json"]
        
        mockBffService.mockHeaders = requiredHeaders
        networkManager.updateHeaders(sharedHeaders)
        
        // Spy on the adapter's sendRequest call to verify headers are merged correctly
        let originalMethod = mockAdapter.sendRequest
        
        var capturedHeaders: [String: String]?
        mockAdapter.sendRequest = { endPoint, environment, additionalHeader, expecting, body, timeout, retryConfig in
            capturedHeaders = additionalHeader
            return try await originalMethod(endPoint, environment, additionalHeader, expecting, body, timeout, retryConfig)
        }
        
        networkManager.sendRequest(
            endpoint: mockEndpoint,
            expecting: MockDecodable.self
        ) { _ in
            XCTAssertEqual(capturedHeaders, expectedMergedHeaders)
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
    
    func testSendRequest_PrioritizesCurrentHeadersOverShared() async {
        // Test that current headers take priority over shared headers
        let expectation = XCTestExpectation(description: "Current headers take priority")
        
        let requiredHeaders = ["Content-Type": "application/xml", "Authorization": "Bearer token"]
        let sharedHeaders = ["Content-Type": "application/json"]
        let expectedMergedHeaders = ["Content-Type": "application/xml", "Authorization": "Bearer token"]
        
        mockBffService.mockHeaders = requiredHeaders
        networkManager.updateHeaders(sharedHeaders)
        
        // Spy on the adapter's sendRequest call to verify headers priority
        let originalMethod = mockAdapter.sendRequest
        
        var capturedHeaders: [String: String]?
        mockAdapter.sendRequest = { endPoint, environment, additionalHeader, expecting, body, timeout, retryConfig in
            capturedHeaders = additionalHeader
            return try await originalMethod(endPoint, environment, additionalHeader, expecting, body, timeout, retryConfig)
        }
        
        networkManager.sendRequest(
            endpoint: mockEndpoint,
            expecting: MockDecodable.self
        ) { _ in
            XCTAssertEqual(capturedHeaders, expectedMergedHeaders)
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}

// Extension to make the NetworkDecodedSuccess type for our tests
extension NetworkDecodedSuccess {
    init(decoded: T, response: NetwokResponse, request: NetworkRequest) {
        self.decoded = decoded
        self.response = response
        self.request = request
    }
}
