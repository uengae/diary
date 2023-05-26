<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	request.setCharacterEncoding("utf-8");

	// 요청값 유효성 검사
	if(request.getParameter("noticeNo") == null
			|| request.getParameter("noticePw") == null
			|| request.getParameter("noticeNo").equals("")
			|| request.getParameter("noticePw").equals("")) {
		response.sendRedirect("./noticeList.jsp");
		return;
	}
	
	// 값을 특정하기위해 noticeNo와 noticePw을 가져옴
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	String noticePw = request.getParameter("noticePw");
	
	// 디버깅
	System.out.println(noticeNo + " <-- deleteNoticeAction param noticeNo");
	System.out.println(noticePw + " <-- deleteNoticeAction param noticePw");
	
	// db 연결 및 쿼리문 실행
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	String sql = "delete from notice where notice_no=? and notice_pw=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, noticeNo);
	stmt.setString(2, noticePw);
	
	// 디버깅
	System.out.println(stmt + " <-- deleteNoticeAction sql");

	int row = stmt.executeUpdate();
	// 디버깅
	System.out.println(row + " <-- deleteNoticeAction row");
	
	if(row == 0) { // 비빌번호 틀려서 삭제행이 0행
		// 아무 변화 없을때 페이지 그대로 남도록 설정
		response.sendRedirect("./deleteNoticeForm.jsp?noticeNo=" + noticeNo);
	} else {
		response.sendRedirect("./noticeList.jsp");
	}
%>