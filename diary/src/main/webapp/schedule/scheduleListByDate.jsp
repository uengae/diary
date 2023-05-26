<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8");
	
	// y, m, d 값이 null or "" -> redirection scheduleList.jsp
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
	// 자바api 에서는 12월은 11, 마리아db는 12월은 12
	int m = Integer.parseInt(request.getParameter("m")) + 1;
	int d = Integer.parseInt(request.getParameter("d"));
	
	System.out.println(y + ", " + m + ", " + d + " <-- scheduleListByDate y, m, d 값");
	
	// int형을 String형으로 바꾸기위해 ""를 더해줬다.
	String strM = m + "";
	if(m<10) {
		strM = "0" + strM;
	}
	String strD = d + "";
	if(d<10) {
		strD = "0" + strD;
	}
	
	// 날짜 변수 형태에 맞춰서 새로 변수 지정
	String wholeDate = y + "-" + strM + "-" + strD;
	System.out.println(wholeDate);
	
	// db연동 및 쿼리문 실행
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	String sql = "select schedule_no scheduleNo, schedule_time scheduleTime, schedule_memo scheduleMemo, schedule_color scheduleColor from schedule where schedule_date=? order by schedule_time asc";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setString(1, wholeDate);
	System.out.println(stmt + " <-- scheduleListByDate stmt");
	ResultSet rs = stmt.executeQuery();
	System.out.println(rs + " <-- scheduleListByDate rs");
	
	// ArrayList에 값을 집어 넣어준다.
	// ArrayList<데이터 타입> 변수명 = ArrayList<데이터 타입>(크기);
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()) {
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleTime = rs.getString("scheduleTime"); 
		s.scheduleMemo = rs.getString("scheduleMemo"); 
		s.scheduleColor = rs.getString("scheduleColor");
		scheduleList.add(s);
	}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link id="theme" rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
</head>
<body>
	<div>
		<jsp:include page="/inc/headMainBar.jsp"></jsp:include>
	</div>
	<h1>스케쥴 입력</h1>
	<!-- m 값을 넘겨줄때 api값으로 생각해야 하기때문에 m에 -1을 해준다 -->
	<form action="./insertScheduleAction.jsp?y=<%=y%>&m=<%=m-1%>&d=<%=d%>" method="post" id="submit">
		<table class="table table-striped">
			<tr>
				<th>schedule_date</th>
				<td>
					<input type="date" name="scheduleDate" value="<%=y%>-<%=strM%>-<%=strD%>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<th>schedule_time</th>
				<td>
					<input type="time" name="scheduleTime">
				</td>
			</tr>
			<tr>
				<th>schedule_color</th>
				<td>
					<input type="color" name="scheduleColor">
				</td>
			</tr>
			<tr>
				<th>schedule_memo</th>
				<td>
					<textarea rows="3" cols="80" name="scheduleMemo"></textarea>
				</td>
			</tr>
			<tr>
				<th>schedule_pw</th>
				<td>
					<input type="password" name="schedulePw">
				</td>
			</tr>
		</table>
	</form>
	<form action="./scheduleList.jsp?targetYear=<%=y%>&targetMonth=<%=m - 1%>" method="post" id="undo"></form>
		&nbsp; <button class="btn btn-primary" type="submit" form="submit">스케쥴 입력</button>
		&nbsp; <button class="btn btn-primary" type="submit" form="undo">스케쥴 리스트로 돌아가기</button>
		
	<h1><%=y%>년 <%=m%>월 <%=d%>일 스케쥴 목록</h1>
	<table class="table table-striped">
		<tr>
			<th>스케쥴 시간</th>
			<th>스케쥴 내용</th>
			<th>수정</th>
			<th>삭제</th>
		</tr>
	<%
			for (Schedule s : scheduleList) {
	%>
		<tr style="background-color: <%=s.scheduleColor%>;">
			<td>
				<%=s.scheduleTime%>
			</td>
			<td>
				<%=s.scheduleMemo%>
			</td>
			<td>
				<a href="./updateScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">
				수정
				</a>
			</td>
			<td>
				<a href="./deleteScheduleForm.jsp?scheduleNo=<%=s.scheduleNo%>">
				삭제
				</a>
			</td>
		</tr>
	<%
			}
	%>
	</table>
</body>
</html>