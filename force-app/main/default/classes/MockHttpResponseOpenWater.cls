global class MockHttpResponseOpenWater implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        
        
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"success": true , "token": "xyz1321321vdshgghdvashjd","responseStatus":false}');
        res.setStatusCode(200);
        return res;
    }
}