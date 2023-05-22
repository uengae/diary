<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	// 1. request 인코딩 설정
	request.setCharacterEncoding("utf-8");

	// 2. 4개의 값을 확인(디버깅)
	System.out.println(request.getParameter("noticeNo")
			+ "<-- updateNoticeAction.jsp noticeNo");
	System.out.println(request.getParameter("noticeTitle")
			+ "<-- updateNoticeAction.jsp noticeTitle");
	System.out.println(request.getParameter("noticeContent")
			+ "<-- updateNoticeAction.jsp noticeContent");
	System.out.println(request.getParameter("noticePw")
			+ "<-- updateNoticeAction.jsp noticePw");
	
	// 3. 2번 유효성검정 -> 잘못된 결과 -> 분기 -> 코드진행 종료(return)
	// -> 리다이렉션(updateNoticeForm.jsp?noticeNo=&msg=)
	if (request.getParameter("noticeNo") == null
		|| request.getParameter("noticeNo").equals("")) {
		response.sendRedirect("./updateNoticeForm.jsp");
		return;
	}
	String msg = null;
	if (request.getParameter("noticeTitle") == null // 항상 null값 먼저 분기 처리
		||request.getParameter("noticeTitle").equals("")) {
			msg = "noticeTitle is requied";
	} else if (request.getParameter("noticeContent") == null
		||request.getParameter("noticeContent").equals("")) {
			msg = "noticeContent is requied";
	} else if (request.getParameter("noticePw") == null
		||request.getParameter("noticePw").equals("")) {
			msg = "noticePw is requied";
	}

	if (msg != null ){ // 위 if 문에 하나라도 해당된다.
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="
							+ request.getParameter("noticeNo")
							+ "&msg="
							+ msg);
		return;
	}
	
	// 4. 요청값들을 변수에 할당(형변화)
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	String noticePw = request.getParameter("noticePw");
	System.out.println(noticeNo + "<-- updateNoticeAction.jsp noticeNo");
	System.out.println(noticeTitle + "<-- updateNoticeAction.jsp noticeNo");
	System.out.println(noticeContent + "<-- updateNoticeAction.jsp noticeNo");
	System.out.println(noticePw + "<-- updateNoticeAction.jsp noticeNo");
	
	// 5. mariadb RDBMS에 update문을 전송한다.
	Class.forName("org.mariadb.jdbc.Driver");
	
	java.sql.Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	String sql = "UPDATE notice SET notice_title=?, notice_content=?, updatedate=now() WHERE notice_no=? and notice_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, noticeTitle);
	stmt.setString(2, noticeContent);
	stmt.setInt(3, noticeNo);
	stmt.setString(4, noticePw);
	System.out.println(stmt + "<-- stmt");
	
	int row = stmt.executeUpdate(); //적용된 행의 수
	// 5번의 결과에 페이지(View)를 분기한다.
	if (row == 0) {
		response.sendRedirect("./updateNoticeForm.jsp?noticeNo="
				+ request.getParameter("noticeNo")
				+ "&msg=incorrect noticePw");
	} else if (row == 1) {
		response.sendRedirect("./noticeOne.jsp?noticeNo=" + noticeNo);
	} else {
		// update문 실행을 취소(rollback) 해야 한다.
		System.out.println("error row값: " + row);
	}
%>