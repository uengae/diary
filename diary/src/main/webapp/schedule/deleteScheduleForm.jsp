<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%
	request.setCharacterEncoding("utf-8");
	
	// 유효성 검증
	if (request.getParameter("scheduleNo") == null
			|| request.getParameter("scheduleNo").equals("")){
		response.sendRedirect("./scheduleListByDate.jsp");
		return;
	}
	
	// 값을 특정하기 위한 scheduleNo 가져옴
	int scheduleNo = Integer.parseInt(request.getParameter("scheduleNo"));
	
	// db연동 및 쿼리문 실행
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	String sql = "select schedule_time scheduleTime, schedule_memo scheduleMemo, schedule_date scheduleDate from schedule where schedule_num = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, scheduleNo);
	System.out.println(stmt + " <-- deleteScheduleForm stmt");
	ResultSet rs = stmt.executeQuery();
	System.out.println(rs + " <-- deleteSchduleForm rs");
	
	// db에서 schedule_date 값을 가지고 와서 y, m, d로 저장함
	// 취소눌렀을때 이전 페이지로 넘어가기 위함
	// 데이터 하나만 읽으면 돼서 ArrayList로 안바꿈
	// if 밖에서 s를 써야 하기때문에 선언 먼저한다.
	Schedule s = null;
	if (rs.next()){
		s = new Schedule();
		s.scheduleTime = rs.getString("scheduleTime");
		s.scheduleMemo = rs.getString("scheduleMemo");
		s.scheduleDate = rs.getString("scheduleDate");
	}
	String y = s.scheduleDate.substring(0, 4);
	int m = Integer.parseInt(s.scheduleDate.substring(5, 7)) - 1 ;
	String d = s.scheduleDate.substring(8);
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
	<h1>일정을 삭제 하시겠습니까</h1>
	<form action="./deleteScheduleAction.jsp?scheduleNo=<%=scheduleNo%>&y=<%=y%>&m=<%=m%>&d=<%=d%>" method="post" id="delete">
	<table class="table table-striped">
		<tr>
			<th>스케쥴 시간</th>
			<th>스케쥴 내용</th>
		</tr>
		<tr>
			<td>
				<%=s.scheduleTime%>
			</td>
			<td>
				<%=s.scheduleMemo%>
			</td>
		</tr>
		<tr>
			<td colspan="2">
				비밀번호 입력 : 
				<input type="password" name="schedulePw">
			</td>
		</tr>
	</table>
	</form>
	<form action="./scheduleListByDate.jsp?scheduleNo=<%=scheduleNo%>&y=<%=y%>&m=<%=m%>&d=<%=d%>" method="post" id="cancle">
	</form>
	<!-- pw값을 넘길려면 form을 써야하는데 버튼 모양 달라지는게 싫어서 form을 2개 만들어서 서로 다른 action을 넣어서 나타냄 -->
	&nbsp; <button class="btn btn-primary" type="submit" form="delete">삭제</button>
	&nbsp; <button class="btn btn-primary" type="submit" form="cancle">취소</button>
</body>
</html>