<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link id="theme" rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
	<div class="container-fluid"><!-- 메인메뉴 -->
		<a class="navbar-brand" href="./home.jsp">홈으로</a>
		<a class="navbar-brand" href="./noticeList.jsp">공지 리스트</a>
		<a class="navbar-brand" href="./scheduleList.jsp">일정 리스트</a>
	</div>
</nav>
	<!-- 날짜순 최근 공지 5개 -->
	<%
		// db 연결
		Class.forName("org.mariadb.jdbc.Driver");
		java.sql.Connection conn = DriverManager.getConnection(
				"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
		
		// 최근 공지 5개
		// 쿼리문 실행
		String sql1 = "select notice_no noticeNo, notice_title noticeTitle, left(createdate, 10) createdate from notice order by createdate desc limit 0, 5";
		PreparedStatement stmt = conn.prepareStatement(sql1);
		System.out.println(stmt + " <-- stmt");
		ResultSet rs = stmt.executeQuery();
		
		// ArrayList에 값을 집어 넣어준다.
		ArrayList<Notice> noticeList = new ArrayList<Notice>();
		while(rs.next()){
			Notice n = new Notice();
			n.noticeNo = rs.getInt("noticeNo");
			n.noticeTitle = rs.getString("noticeTitle");
			n.createdate = rs.getString("createdate");
			noticeList.add(n);
		}
		
		
		// 오늘 일정
		// 쿼리문 실행
		String sql2 = "select schedule_no scheduleNo, schedule_date scheduleDate, schedule_time scheduleTime, left(schedule_memo, 10) scheduleMemo, schedule_color scheduleColor from schedule where schedule_date = curdate() order by schedule_time asc";
		PreparedStatement stmt2 = conn.prepareStatement(sql2);
		System.out.println(stmt2 + " <-- stmt");
		ResultSet rs2 = stmt2.executeQuery();
		
		ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
		while(rs2.next()) {
			Schedule s = new Schedule();
			s.scheduleNo = rs.getInt("scheduleNo");
			s.scheduleTime = rs.getString("scheduleTime"); 
			s.scheduleDate = rs.getString("scheduleDate"); 
			s.scheduleMemo = rs.getString("scheduleMemo"); 
			s.scheduleColor = rs.getString("scheduleColor");
			scheduleList.add(s);
		}
	%>
	<h1>공지 사항</h1>
	<table class="table table-striped">
		<tr>
			<th>notice_title</th>
			<th>createdate</th>
		</tr>
		<%
			for (Notice n : noticeList){
		%>
				<tr>
					<td>
						<a href="./noticeOne.jsp?noticeNo=<%=n.noticeNo%>">
						<%=n.noticeTitle%>
						</a>
					</td>
					<td><%=n.createdate%></td>
				</tr>
		<%
			}
		%>
	</table>
	<h1>오늘 일정</h1>
	<table class="table">
		<tr>
			<th>schedule_date</th>
			<th>schedule_time</th>
			<th>schedule_memo</th>
		</tr>
		<%
			for(Schedule s : scheduleList){
		%>
				<tr style="background-color: <%=s.scheduleColor%>;">
					<td>
						<%=s.scheduleDate%>
					</td>
					<td>
						<%=s.scheduleTime%>
					</td>
					<td>
						<a href="./scheduleOne.jsp?scheduleNo=<%=s.scheduleNo%>">
						<%=s.scheduleMemo%>
						</a>
					</td>
				</tr>
		<%
			}
		%>
	</table>
	<h1>다이어리 프로젝트</h1>
	<table class="table table-striped">
		<tr>
			<td>
				사용한 프로그램 : Eclipse, HeidiSQL
			</td>
		</tr>
		<tr>
			<td>
				사용 언어: java, SQL, Bootstrap
			</td>
		</tr>
		<tr>
			<td>
				사용 DB: MariaDB
			</td>
		</tr>
		<tr>
			<td>
				과제 내용 : Calendar API를 이용해서 달력을 출력하고 DB와 연동하여 schedule과 notice를 출력하라<br>
				Calendar API를 이용하여 달력을 만들고 DB를 연동해서 DB에 데이터 입력과 데이터 수정, 데이터 출력, 데이터 삭제를 실습하였다.<br>
				JSP를 이용해서 action 페이지와 form 페이지를 오가며 데이터 출력을 위한 java코드를 짰다.<br>
				추가적으로 게시판 페이지 10페이지씩 나누는 것과 달력에서 전달과 다음달의 날짜까지 출력하는것을 했다
			</td>
		</tr>
	</table>
</body>
</html>