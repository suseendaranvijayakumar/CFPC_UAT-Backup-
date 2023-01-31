@isTest
global class MockHttpResponseGenerator implements HttpCalloutMock {
    global static HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('https://www.google.com/recaptcha/api/siteverify', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        if(req.getBody().contains('success.false')){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"success": true , "score": 0}');
            res.setStatusCode(200);
            return res;
        }else if(req.getBody().contains('success.null')){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ "score": 0}');
            res.setStatusCode(200);
            return res;
        }else if(req.getBody().contains('score.null')){
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{ "success": true}');
            res.setStatusCode(200);
            return res;
        }else{            
        // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"success": true , "score": 1}');
            res.setStatusCode(200);
            return res;
        }
    }
}