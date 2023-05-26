<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	request.setCharacterEncoding("utf-8");
	
	// 유효성 검사
	if (request.getParameter("scheduleNo") == null
			|| request.getParameter("scheduleNo").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	
	// 삭제할 schedule 특정하기위한 schedueleNo와 schedulePw를 특정
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	String schedulePw = request.getParameter("schedulePw");
	System.out.println(schedulePw + "<-- deleteScheduleAction pw");
	
	// db 연동 및 쿼리문 실행
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	String sql = "delete from schedule where schedule_num = ? and schedule_pw = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, scheduleNo);
	stmt.setString(2, schedulePw);
	System.out.println(stmt + " <-- deleteScheduleAction stmt");
	int row = stmt.executeUpdate();
	
	// m를 따로 출력안하고 api에 사용되는 형태로 사용하기 때문에 m을 그대로 둔다
	int y = Integer.parseInt(request.getParameter("y"));
	int m = Integer.parseInt(request.getParameter("m"));
	int d = Integer.parseInt(request.getParameter("d"));
	
	if (row == 1){
		System.out.println("정상 입력");
		response.sendRedirect("./scheduleListByDate.jsp?y=" + y + "&m=" + m + "&d=" + d);
	} else {
		System.out.println("비정상 입력");
		response.sendRedirect("./deleteScheduleForm.jsp?scheduleNo=" + scheduleNo);
	}
	
%>
