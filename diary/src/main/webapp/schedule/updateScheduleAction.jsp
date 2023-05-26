<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	request.setCharacterEncoding("utf-8");
	
	// 유효성 검사
	if (request.getParameter("scheduleDate") == null
			|| request.getParameter("scheduleTime") == null
			|| request.getParameter("scheduleDate").equals("")
			|| request.getParameter("scheduleTime").equals("")) {
		response.sendRedirect("./scheduleListByDate.jsp");
		return;
	}
	
	// 수정하기 위한 데이터를 받아온다.
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String schedulePw = request.getParameter("schedulePw");
	
	// db연동 및 쿼리문 실행
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	String sql = "update schedule set schedule_time=?, schedule_memo=?, schedule_color=?, updatedate=now() where schedule_num = ? and schedule_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	System.out.println(stmt + " <--updateScheduleAction stmt");
	stmt.setString(1, scheduleTime);
	stmt.setString(2, scheduleMemo);
	stmt.setString(3, scheduleColor);
	stmt.setInt(4, scheduleNo);
	stmt.setString(5, schedulePw);
	int row = stmt.executeUpdate();
	
	// 비밀 번호 틀렸을때 페이지에 남게 하는 분기
	if (row == 1){
		System.out.println("정상 입력");
	} else {
		System.out.println("비정상 입력");
		response.sendRedirect("./updateScheduleForm.jsp?scheduleNo=" + scheduleNo);
		return;
	}
	
	// y, m, d 자르기
	String y = scheduleDate.substring(0, 4);
	int m = Integer.parseInt(scheduleDate.substring(5, 7)) - 1;
	String d = scheduleDate.substring(8);
	
	System.out.println(y + ", " + m + ", " + d + " <-- insertScheduleAction y, m, d");
	
	response.sendRedirect("./scheduleListByDate.jsp?y=" + y + "&m=" + m + "&d=" + d);
	
	
%>