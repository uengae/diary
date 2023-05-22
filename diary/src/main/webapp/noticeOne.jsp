<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*" %>
<%
	// 유효성 검사
	if (request.getParameter("noticeNo") == null){
		response.sendRedirect("./home.jsp");
		return;
	}
	
	// 리스트로 돌아갈때 원래 있던 리스트로 돌아가기위해서 currentPage 값을 받아옴
	String currentPage = request.getParameter("currentPage");
	System.out.println(currentPage + "<- noticeOne currentPage");
	
	// currentPage가 값이 없을때를 위한 분기처리
	if (currentPage == null
			|| currentPage.equals("")){
		currentPage = "1";
	}
	
	// 값을 특정하기위한 noticeNo을 가져온다.
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	
	// db연동 및 쿼리문 실행
	Class.forName("org.mariadb.jdbc.Driver");
	java.sql.Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	String sql = "select notice_no noticeNo, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, createdate, updatedate from notice where notice_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, noticeNo); //stmt의 1번째 ?를 noticeNo로 바꾸겠다.
	System.out.println(stmt + " <-- stmt");
	ResultSet rs = stmt.executeQuery();
	
	// ArrayList에 값을 집어 넣어준다.
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs.next()){
		Notice n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");
		n.noticeTitle = rs.getString("noticeTitle");
		n.noticeContent = rs.getString("noticeContent");
		n.noticeWriter = rs.getString("noticeWriter");
		n.createdate = rs.getString("createdate");
		n.updatedate = rs.getString("updatedate");
		noticeList.add(n);
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
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
	<div class="container-fluid"><!-- 메인메뉴 -->
		<a class="navbar-brand" href="./home.jsp">홈으로</a>
		<a class="navbar-brand" href="./noticeList.jsp">공지 리스트</a>
		<a class="navbar-brand" href="./scheduleList.jsp">일정 리스트</a>
	</div>
</nav>	
	<h1>공지 상세</h1>
	<%
		for (Notice n : noticeList){
	%>
	<table class="table table-striped">
		<tr>
			<td>notice_no</td>
			<td><%=n.noticeNo%></td>
		</tr>
		<tr>
			<td>notice_title</td>
			<td><%=n.noticeTitle%></td>
		</tr>
		<tr>
			<td>notice_content</td>
			<td><%=n.noticeContent%></td>
		</tr>
		<tr>
			<td>notice_writer</td>
			<td><%=n.noticeWriter%></td>
		</tr>
		<tr>
			<td>createdate</td>
			<td><%=n.createdate%></td>
		</tr>
		<tr>
			<td>updatedate</td>
			<td><%=n.updatedate%></td>
		</tr>
	</table>
	<div>
		<form action="./updateNoticeForm.jsp?noticeNo=<%=n.noticeNo%>" method="post" id="update"></form>
		<form action="./deleteNoticeForm.jsp?noticeNo=<%=n.noticeNo%>" method="post" id="delete"></form>
		<form action="./noticeList.jsp?currentPage=<%=currentPage%>" method="post" id="undo"></form>
	<%
		}
	%>
		&nbsp; <button class="btn btn-primary" type="submit" form="update">수정</button>
		&nbsp; <button class="btn btn-primary" type="submit" form="delete">삭제</button>
		&nbsp; <button class="btn btn-primary" type="submit" form="undo">리스트로 돌아가기</button>
	</div>
</body>
</html>