<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@page import="java.util.*"%>
<%@page import="vo.*"%>
<%
	// 유요성 코드 추가 -> 분기 -> return
	if(request.getParameter("noticeNo") == null) {
		response.sendRedirect("./noticeList.jsp");
		return;
	}
	
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	
	// db 연동 및 쿼리문 실행
	Class.forName("org.mariadb.jdbc.Driver");
	java.sql.Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	String sql = "select notice_no noticeNO, notice_title noticeTitle, notice_content noticeContent, notice_writer noticeWriter, createdate, updatedate from notice where notice_no = ?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, noticeNo); //stmt의 1번째 ?를 noticeNo로 바꾸겠다.
	System.out.println(stmt + " <-- stmt");
	ResultSet rs = stmt.executeQuery();
	
	// ArrayList에 값을 집어 넣어준다.
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while (rs.next()) {
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
	<h1>수정폼</h1>
	<div>
		<%
			// 잘못된 값을 입력했을 때 msg를 띄우기 위함
			if (request.getParameter("msg") != null) {
		%>
				<%=request.getParameter("msg")%>
		<%
				
			}
		%>
	</div>
		<%
			for(Notice n : noticeList) {
		%>
	<form action="./updateNoticeAction.jsp" method="post" id="submit">
		<table class="table table-striped">
			<tr>
				<td>
					notice_no
				</td>
				<td>
					<input type="number" name="noticeNo"
						value="<%=n.noticeNo%>" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td>
					notice_pw
				</td>
				<td>
					<input type="password" name="noticePw">
				</td>
			</tr>
			<tr>
				<td>
					notice_title
				</td>
				<td>
					<input type="text" name="noticeTitle"
						value="<%=n.noticeTitle%>">
				</td>
			</tr>
			<tr>
				<td>
					notice_content
				</td>
				<td>
					<textarea rows="5" cols="80" name="noticeContent"><%=n.noticeContent%></textarea>	
				</td>
			</tr>
			<tr>
				<td>
					notice_writer
				</td>
				<td>
					<%=n.noticeWriter%>
				</td>
			</tr>
			<tr>
				<td>
					createdate
				</td>
				<td>
					<%=n.createdate%>
				</td>
			</tr>
			<tr>
				<td>
					updatedate
				</td>
				<td>
					<%=n.updatedate%>
				</td>
			</tr>
		</table>
	</form>
	<form action="./noticeOne.jsp?noticeNo=<%=n.noticeNo%>" method="post" id="cancle">
	</form>
		<%
			}
		%>
		<div>
			&nbsp; <button class="btn btn-primary" type="submit" form="submit">수정</button>
			&nbsp; <button class="btn btn-primary" type="submit" form="cancle">취소</button>
		</div>
</body>
</html>