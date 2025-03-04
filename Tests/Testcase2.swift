//
//  Testcase2.swift
//  NavigationKit
//
//  Created by Anand on 3/4/25.
//

import XCTest
@testable import YourModuleName // Replace with your actual module name

class BNCNetworkManagerTests: XCTestCase {
    
    // MARK: - Mock Classes
    
    // Mock NetworkAdapter
    class MockNetworkAdapter: NetworkAdapter {
        enum MockResult {
            case success(Any, NetwokResponse, NetworkRequest)
            case failure(NetworkError, NetwokResponse?, NetworkRequest?)
            case throwError(Error)
        }
        
        var mockResult: MockResult = .success("", MockResponse(), MockRequest())
        var capturedEndpoint: Endpoint?
        var capturedEnvironment: Environment?
        var capturedHeaders: [String: String]?
        var capturedBody: Data?
        var capturedExpecting: Any.Type?
        
        override func sendRequest<T: Decodable>(
            to endPoint: Endpoint,
            in environment: Environment,
            with additionalHeader: [String: String],
            expecting: T.Type,
            including body: Data?,
            timeout: Double?,
            retryConfig: RetryConfig?
        ) async throws -> NetworkDecodedSuccess<T> {
            // Capture parameters for verification
            self.capturedEndpoint = endPoint
            self.capturedEnvironment = environment
            self.capturedHeaders = additionalHeader
            self.capturedBody = body
            self.capturedExpecting = expecting
            
            // Return mock result based on configuration
            switch mockResult {
            case .success(let decoded, let response, let request):
                if let typedDecoded = decoded as? T {
                    return NetworkDecodedSuccess(decoded: typedDecoded, response: response, request: request)
                } else {
                    throw NSError(domain: "TestError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Type mismatch in mock"])
                }
            case .failure(let error, _, _):
                throw error
            case .throwError(let error):
                throw error
            }
        }
    }
    
    // Mock BFF Service
    class MockBNCBenefitsBffService: BNCBenefitsBffService {
        var mockHeaders: [String: String] = [:]
        var validationResult = true
        
        func getRequiredBffHeaders(for endPoint: BNCMobileEndpoint) -> [String: String] {
            return mockHeaders
        }
        
        func validateResponse<T: Decodable>(for response: NetworkDecodedResult<T>) -> Bool {
            return validationResult
        }
    }
    
    // Mock Response
    struct MockResponse: NetwokResponse {
        var statusCode: Int = 200
        var header: [String: String] = [:]
        
        func localizedString(forStatusCode statusCode: Int) -> String {
            return "OK"
        }
    }
    
    // Mock Request
    struct MockRequest: NetworkRequest {
        var url: URL? = URL(string: "https://example.com")
        var httpMethod: String? = "GET"
        var allHttpHeaderFields: [String: String]? = [:]
        var httpBody: Data? = nil
        
        init() {}
        
        init?(to endPoint: Endpoint, in environment: Environment, including body: Data?) {
            // Simple implementation for testing
            self.url = URL(string: "https://\(environment.host)/\(endPoint.path)")
            self.httpMethod = "POST"
            self.allHttpHeaderFields = [:]
            self.httpBody = body
        }
    }
    
    // Mock Endpoint
    struct MockEndpoint: BNCMobileEndpoint {
        var path: String = "test/path"
        var requiredAUth: Bool = false
    }
    
    // Mock Data Model
    struct MockDecodable: Decodable, Equatable {
        let id: String
        let name: String
    }
    
    // MARK: - Properties
    
    var networkManager: BNCNetworkManager!
    var mockAdapter: MockNetworkAdapter!
    var mockBffService: MockBNCBenefitsBffService!
    var mockEnvironment: BNCMobileServiceEnvironment!
    
    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
        
        mockAdapter = MockNetworkAdapter()
        mockBffService = MockBNCBenefitsBffService()
        mockEnvironment = BNCMobileServiceEnvironment(baseURL: URL(string: "https://api.example.com")!)
        
        networkManager = BNCNetworkManager(environment: mockEnvironment, bffService: mockBffService)
        // Replace the networkAdapter with our mock - you may need to expose it for testing
        networkManager.networkAdapter = mockAdapter
    }
    
    override func tearDown() {
        networkManager = nil
        mockAdapter = nil
        mockBffService = nil
        mockEnvironment = nil
        super.tearDown()
    }
    
    // MARK: - Test Cases
    
    func testSendRequest_Success() {
        // Set up expected values
        let endpoint = MockEndpoint()
        let mockData = MockDecodable(id: "123", name: "Test")
        let mockResponse = MockResponse()
        let mockRequest = MockRequest()
        
        // Configure mock to return success
        mockAdapter.mockResult = .success(mockData, mockResponse, mockRequest)
        
        // Configure BFF service headers
        mockBffService.mockHeaders = ["Auth": "Bearer token"]
        
        // Set up shared headers
        networkManager.updateHeaders(["Content-Type": "application/json"])
        
        // Set up expectation
        let expectation = XCTestExpectation(description: "Network request completed successfully")
        
        // Execute the method under test
        networkManager.sendRequest(
            endpoint: endpoint,
            expecting: MockDecodable.self
        ) { result in
            // Verify success case is handled correctly
            switch result {
            case .success(let data, let response, let request):
                // Verify the decoded data
                let decodedData = data as? MockDecodable
                XCTAssertEqual(decodedData, mockData)
                
                // Verify response
                XCTAssertEqual(response.statusCode, 200)
                
                // Verify request
                XCTAssertEqual(request.url, mockRequest.url)
                
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        // Wait for async operation to complete
        wait(for: [expectation], timeout: 1.0)
        
        // Verify adapter was called with correct parameters
        XCTAssertTrue(mockAdapter.capturedEndpoint is MockEndpoint)
        XCTAssertEqual(mockAdapter.capturedEnvironment?.host, "api.example.com")
        
        // Verify headers were merged correctly
        XCTAssertEqual(mockAdapter.capturedHeaders?["Auth"], "Bearer token")
        XCTAssertEqual(mockAdapter.capturedHeaders?["Content-Type"], "application/json")
    }
    
    func testSendRequest_WithRequestBody() {
        // Set up test data
        let endpoint = MockEndpoint()
        let requestBody = try? JSONEncoder().encode(["key": "value"])
        let mockData = MockDecodable(id: "123", name: "Test")
        
        // Configure mock to return success
        mockAdapter.mockResult = .success(mockData, MockResponse(), MockRequest())
        
        // Set up expectation
        let expectation = XCTestExpectation(description: "Network request with body completed")
        
        // Execute the method under test
        networkManager.sendRequest(
            endpoint: endpoint,
            including: requestBody,
            expecting: MockDecodable.self
        ) { _ in
            expectation.fulfill()
        }
        
        // Wait for async operation to complete
        wait(for: [expectation], timeout: 1.0)
        
        // Verify body was passed correctly
        XCTAssertEqual(mockAdapter.capturedBody, requestBody)
    }
    
    func testSendRequest_NetworkError() {
        // Set up test data
        let endpoint = MockEndpoint()
        let networkError = NetworkError.timeout
        
        // Configure mock to return error
        mockAdapter.mockResult = .failure(networkError, nil, nil)
        
        // Set up expectation
        let expectation = XCTestExpectation(description: "Network request failed with NetworkError")
        
        // Execute the method under test
        networkManager.sendRequest(
            endpoint: endpoint,
            expecting: MockDecodable.self
        ) { result in
            // Verify failure case is handled correctly
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error, _, _):
                XCTAssertEqual(error as? NetworkError, networkError)
                expectation.fulfill()
            }
        }
        
        // Wait for async operation to complete
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSendRequest_NonNetworkError() {
        // Set up test data
        let endpoint = MockEndpoint()
        let error = NSError(domain: "TestError", code: 123, userInfo: nil)
        
        // Configure mock to throw a non-NetworkError
        mockAdapter.mockResult = .throwError(error)
        
        // Set up expectation
        let expectation = XCTestExpectation(description: "Network request failed with non-NetworkError")
        
        // Execute the method under test
        networkManager.sendRequest(
            endpoint: endpoint,
            expecting: MockDecodable.self
        ) { result in
            // Verify failure case is handled correctly
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error, _, _):
                // Should be converted to NetworkError.other
                XCTAssertTrue(error is NetworkError)
                expectation.fulfill()
            }
        }
        
        // Wait for async operation to complete
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSendRequest_HeaderMerging() {
        // Set up test data
        let endpoint = MockEndpoint()
        let mockData = MockDecodable(id: "123", name: "Test")
        
        // Configure mock to return success
        mockAdapter.mockResult = .success(mockData, MockResponse(), MockRequest())
        
        // Configure different sets of headers
        mockBffService.mockHeaders = [
            "Auth": "Bearer token",
            "Api-Version": "1.0"
        ]
        
        networkManager.updateHeaders([
            "Content-Type": "application/json",
            "Api-Version": "2.0" // This should be overridden by BFF header
        ])
        
        // Set up expectation
        let expectation = XCTestExpectation(description: "Network request with merged headers completed")
        
        // Execute the method under test
        networkManager.sendRequest(
            endpoint: endpoint,
            expecting: MockDecodable.self
        ) { _ in
            expectation.fulfill()
        }
        
        // Wait for async operation to complete
        wait(for: [expectation], timeout: 1.0)
        
        // Verify headers were merged correctly with BFF headers taking precedence
        XCTAssertEqual(mockAdapter.capturedHeaders?["Auth"], "Bearer token")
        XCTAssertEqual(mockAdapter.capturedHeaders?["Content-Type"], "application/json")
        XCTAssertEqual(mockAdapter.capturedHeaders?["Api-Version"], "1.0") // BFF header should win
    }
    
    func testHandleResponse_Success() {
        // Set up test data
        let mockData = MockDecodable(id: "123", name: "Test")
        let mockResponse = MockResponse()
        let mockRequest = MockRequest()
        let successResult: NetworkDecodedResult<MockDecodable> = .success(mockData, mockResponse, mockRequest)
        
        // Set up expectation
        let expectation = XCTestExpectation(description: "Handle successful response")
        
        // Execute the method under test
        networkManager.handleResponse(
            decodedNetworkResult: successResult,
            requestHeaders: ["Test": "Header"],
            isAuthenticated: false
        ) { result in
            // Verify result passes through correctly
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
        
        // Wait for async operation to complete
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testHandleResponse_Failure() {
        // Set up test data
        let error = NetworkError.timeout
        let mockResponse = MockResponse()
        let mockRequest = MockRequest()
        let failureResult: NetworkDecodedResult<MockDecodable> = .failure(error, mockResponse, mockRequest)
        
        // Set up expectation
        let expectation = XCTestExpectation(description: "Handle failure response")
        
        // Execute the method under test
        networkManager.handleResponse(
            decodedNetworkResult: failureResult,
            requestHeaders: ["Test": "Header"],
            isAuthenticated: false
        ) { result in
            // Verify failure passes through correctly
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let resultError, let response, let request):
                XCTAssertEqual(resultError as? NetworkError, error)
                XCTAssertEqual(response?.statusCode, mockResponse.statusCode)
                XCTAssertEqual(request?.url, mockRequest.url)
                expectation.fulfill()
            }
        }
        
        // Wait for async operation to complete
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testHandleResponse_NonHTTPResponse() {
        // Create a custom non-HTTP response
        class CustomResponse: NetwokResponse {
            var statusCode: Int = 0
            var header: [String: String] = [:]
            
            func localizedString(forStatusCode statusCode: Int) -> String {
                return "Custom Response"
            }
        }
        
        // Set up test data
        let mockData = MockDecodable(id: "123", name: "Test")
        let customResponse = CustomResponse()
        let mockRequest = MockRequest()
        let successResult: NetworkDecodedResult<MockDecodable> = .success(mockData, customResponse, mockRequest)
        
        // Set up expectation
        let expectation = XCTestExpectation(description: "Handle non-HTTP response")
        
        // Execute the method under test
        networkManager.handleResponse(
            decodedNetworkResult: successResult,
            requestHeaders: ["Test": "Header"],
            isAuthenticated: false
        ) { result in
            // For non-HTTP responses, should just pass through
            switch result {
            case .success:
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        // Wait for async operation to complete
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testRequiredHeaders() {
        // Set up test data
        let endpoint = MockEndpoint()
        let expectedHeaders = ["Auth": "Bearer token"]
        
        // Configure mock
        mockBffService.mockHeaders = expectedHeaders
        
        // Execute the method under test
        let headers = networkManager.requiredHeaders(endPoint: endpoint)
        
        // Verify correct headers returned
        XCTAssertEqual(headers, expectedHeaders)
    }
    
    func testUpdateHeaders() {
        // Initial state should be empty
        XCTAssertEqual(networkManager.sharedHeaders, [:])
        
        // Update headers
        let newHeaders = ["Content-Type": "application/json", "Accept": "application/json"]
        networkManager.updateHeaders(newHeaders)
        
        // Verify headers updated
        XCTAssertEqual(networkManager.sharedHeaders, newHeaders)
        
        // Update again - should replace
        let newerHeaders = ["Content-Type": "application/xml"]
        networkManager.updateHeaders(newerHeaders)
        
        // Verify headers replaced
        XCTAssertEqual(networkManager.sharedHeaders, newerHeaders)
    }
}

// MARK: - Helper Extensions

// Add for testing if needed - depends on your actual implementation
extension NetworkDecodedSuccess {
    init(decoded: T, response: NetwokResponse, request: NetworkRequest) {
        self.decoded = decoded
        self.response = response
        self.request = request
    }
}
