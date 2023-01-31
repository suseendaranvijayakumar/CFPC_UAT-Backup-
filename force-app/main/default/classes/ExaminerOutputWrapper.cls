public class ExaminerOutputWrapper{
	public boolean responseStatus;
	public String message;	//Success
	public cls_openExams[] openExams;
	public class cls_openExams {
		public Integer examId;	//75
		public String requiredDesignationEnglish;	//CCFP (EM)
		public String requiredDesignationFrench;	//CCMF (MU)
	}
	public static ExaminerOutputWrapper parse(String json){
		return (ExaminerOutputWrapper) System.JSON.deserialize(json, ExaminerOutputWrapper.class);
	}

	/*static testMethod void testParse() {
		String json=		'{'+
		'    "responseStatus": true,'+
		'    "message": "Success",'+
		'    "openExams": ['+
		'        {'+
		'            "examId": 75,'+
		'            "requiredDesignationEnglish": "CCFP (EM)",'+
		'            "requiredDesignationFrench": "CCMF (MU)"'+
		'        }'+
		'    ]'+
		'}';
		ExaminerOutputWrapper obj = parse(json);
		System.assert(obj != null);
	}*/
}