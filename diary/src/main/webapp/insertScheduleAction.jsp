<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	request.setCharacterEncoding("utf-8");

	// 입력값 입력 안하고 넘어갈시 다시 원래 자리로 오게 하기위해 먼저 y, m, d 값을 받아온다.
	if (request.getParameter("y") == null
			||request.getParameter("m") == null
			||request.getParameter("d") == null
			||request.getParameter("y").equals("")
			||request.getParameter("m").equals("")
			||request.getParameter("d").equals("")){
		response.sendRedirect("./scheduleList.jsp");
		return;
	}
	
	int y = Integer.parseInt(request.getParameter("y"));
	int m = Integer.parseInt(request.getParameter("m"));
	int d = Integer.parseInt(request.getParameter("d"));
	
	if (request.getParameter("scheduleDate") == null
			|| request.getParameter("scheduleTime") == null
			|| request.getParameter("schedulePw") == null
			|| request.getParameter("scheduleDate").equals("")
			|| request.getParameter("scheduleTime").equals("")
			|| request.getParameter("schedulePw").equals("")) {
		// 불완전한 입력 시 현재 페이지에 남도록 설정
		response.sendRedirect("./scheduleListByDate.jsp?y=" + y + "&m=" + m + "&d=" + d);
		return;
	}
	
	// 입력 값을 받아온다.
	String scheduleDate = request.getParameter("scheduleDate");
	String scheduleTime = request.getParameter("scheduleTime");
	String scheduleColor = request.getParameter("scheduleColor");
	String scheduleMemo = request.getParameter("scheduleMemo");
	String schedulePw = request.getParameter("schedulePw");
	
	System.out.println(scheduleDate + " <-- insertScheduleAction scheduleDate");
	System.out.println(scheduleTime + " <-- insertScheduleAction scheduleTime");
	System.out.println(scheduleColor + " <-- insertScheduleAction scheduleColor");
	System.out.println(scheduleMemo + " <-- insertScheduleAction scheduleMemo");
	System.out.println(schedulePw + " <-- insertScheduleAction schedulePw");
	
	// db연동 및 쿼리문 실행
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	String sql = "insert into schedule(schedule_date, schedule_time, schedule_memo, schedule_color, schedule_pw, createdate, updatedate) values(?,?,?,?,?,now(),now())";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, scheduleDate);
	stmt.setString(2, scheduleTime);
	stmt.setString(3, scheduleMemo);
	stmt.setString(4, scheduleColor);
	stmt.setString(5, schedulePw);
	System.out.println(stmt + " <-- insertScheduleAction stmt");
	
	int row = stmt.executeUpdate();
	
	// 디버깅
	if (row == 1){
		System.out.println("정상 입력");
	} else {
		System.out.println("비정상 입력");
		
	}
	
	System.out.println(y + ", " + m + ", " + d + " <-- insertScheduleAction y, m, d");
	
	response.sendRedirect("./scheduleListByDate.jsp?y=" + y + "&m=" + m + "&d=" + d);
	
	
%>