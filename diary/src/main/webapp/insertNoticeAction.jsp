<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Connection" %>
<%@ page import = "java.sql.DriverManager" %>
<%@ page import = "java.sql.PreparedStatement" %>
<%
	//post방식 인코딩 처리
	request.setCharacterEncoding("utf-8"); 

	// validation(요청 파라미터값 유효성 검사)
	if(request.getParameter("noticeTitle") == null 
			|| request.getParameter("noticeContent") == null	
			|| request.getParameter("noticeWriter") == null
			|| request.getParameter("noticePw") == null
			|| request.getParameter("noticeTitle").equals("")
			|| request.getParameter("noticeContent").equals("")
			|| request.getParameter("noticeWriter").equals("")
			|| request.getParameter("noticePw").equals("")) {
		
		response.sendRedirect("./insertNoticeForm.jsp");
		return;
	}
	
	String noticeTitle = request.getParameter("noticeTitle");
	String noticeContent = request.getParameter("noticeContent");
	String noticeWriter = request.getParameter("noticeWriter");
	String noticePw = request.getParameter("noticePw");
    // 파라미터값 디버깅코드 추가	
	System.out.println(noticeTitle + "<- insertNoticeAction noticeTitle");
	System.out.println(noticeContent + "<- insertNoticeAction noticeContent");
	System.out.println(noticeWriter + "<- insertNoticeAction noticeWriter");
	System.out.println(noticePw + "<- insertNoticeAction noticePw");

    // 값들을 DB 테이블 입력
    // db 연동 및 쿼리문 실행
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	
	String sql = "insert into notice(notice_title, notice_content, notice_writer, notice_pw, createdate, updatedate) values(?,?,?,?,now(),now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// ?가 4개 이므로 1~4까지 설정하면된다.
	stmt.setString(1, noticeTitle);
	stmt.setString(2, noticeContent);
	stmt.setString(3, noticeWriter);
	stmt.setString(4, noticePw);
    // stmt 디버깅 코드 추가
	System.out.println(stmt + " <- insertNoticeAction stmt");

	int row = stmt.executeUpdate(); // 디버깅 1(ex:2)이면 1행(ex:2행)입력성공, 0이면 입력된 행이 없다
	// row값을 이용한 디버깅 코드 추가
	System.out.println(row + " <- insertNoticeAction row");
	// conn.commit(); // conn.setAutoCommit(true); 디폴트 값이 true라 자동커밋 -> commit생략 가능
	
	// redirection
	response.sendRedirect("./noticeList.jsp");
%>