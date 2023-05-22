<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	// 취소 눌렀을때 원래 있던 페이지로 가기위해 currentPage값을 받아옴 
	String currentPage = request.getParameter("currentPage");
	System.out.println(currentPage + "<- insertNoticeForm currentPage");
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>insertNoticeForm</title>
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
	<h1>공지 입력</h1>
	<form action="./insertNoticeAction.jsp" method="post" id="submit">
		<table class="table table-striped">
			<tr>
				<td>notice_title</td>
				<td>
					<input type="text" name="noticeTitle">
				</td>
			</tr>
			<tr>
				<td>notice_content</td>
				<td>
					<textarea rows="5" cols="80" name="noticeContent"></textarea>
				</td>
			</tr>
			<tr>
				<td>notice_writer</td>
				<td>
					<input type="text" name="noticeWriter">
				</td>
			</tr>
			<tr>
				<td>notice_pw</td>
				<td>
					<input type="password" name="noticePw">
				</td>
			</tr>
		</table>
	</form>
	<form action="./noticeList.jsp?currentPage=<%=currentPage%>" method="post" id="cancle">
	</form>
		&nbsp; <button class="btn btn-primary" type="submit" form="submit">입력</button>
		&nbsp; <button class="btn btn-primary" type="submit" form="cancle">취소</button>
</body>
</html>