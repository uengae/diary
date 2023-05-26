<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8");
		
	if (request.getParameter("scheduleNo") == null
			|| request.getParameter("scheduleNo").equals("")){
			response.sendRedirect("./scheduleList.jsp");
			return;
	}
	
	// 값을 특정하기위한 scheduleNo를 받아옴
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	
	// db 연동 및 쿼리문 실행
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	String sql = "select schedule_time scheduleTime, schedule_memo scheduleMemo, schedule_color scheduleColor, schedule_date scheduleDate from schedule where schedule_num=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, scheduleNo);
	System.out.println(stmt + " <-- scheduleListByDate stmt");
	ResultSet rs = stmt.executeQuery();
	System.out.println(rs + " <-- scheduleListByDate rs");
	
	// 값이 한개 이기 때문에 ArrayList 사용하지 않음
	rs.next();
	Schedule s = new Schedule();
	s.scheduleTime = rs.getString("scheduleTime");
	s.scheduleMemo = rs.getString("scheduleMemo");
	s.scheduleColor = rs.getString("scheduleColor");
	s.scheduleDate = rs.getString("scheduleDate");
	
	// y, m, d 나누기
	String y = s.scheduleDate.substring(0, 4);
	int m = Integer.parseInt(s.scheduleDate.substring(5, 7));
	int d = Integer.parseInt(s.scheduleDate.substring(8));
	
	// m 과 d 는 문자형으로 나타낼때 1~9일때 앞에 0이 붙어야해서 분기줌
	String strM = m + "";
	if(m<10) {
		strM = "0" + strM;
	}
	String strD = d + "";
	if(d<10) {
		strD = "0" + strD;
	}
	
	System.out.println(strM + " <-- scheduleListByDate strM");
	
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
	<form action="./updateScheduleAction.jsp?scheduleNo=<%=scheduleNo%>" method="post" id="update">
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
					<input type="time" name="scheduleTime" value="<%=s.scheduleTime%>">
				</td>
			</tr>
			<tr>
				<th>schedule_color</th>
				<td>
					<input type="color" name="scheduleColor" value="<%=s.scheduleColor%>">
				</td>
			</tr>
			<tr>
				<th>schedule_memo</th>
				<td>
					<textarea rows="3" cols="80" name="scheduleMemo"><%=s.scheduleMemo%></textarea>
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
	<form action="./scheduleListByDate.jsp?scheduleNo=<%=scheduleNo%>&y=<%=y%>&m=<%=m - 1%>&d=<%=d%>" method="post" id="cancle"></form>
	&nbsp; <button class="btn btn-primary" type="submit" form="update">수정</button>
	&nbsp; <button class="btn btn-primary" type="submit" form="cancle">취소</button>
</body>
</html>