<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
		<div class="container-fluid"><!-- 메인메뉴 -->
			<a class="navbar-brand" href="<%=request.getContextPath()%>/home.jsp">홈으로</a>
			<a class="navbar-brand" href="<%=request.getContextPath()%>/notice/noticeList.jsp">공지 리스트</a>
			<a class="navbar-brand" href="<%=request.getContextPath()%>/schedule/scheduleList.jsp">일정 리스트</a>
		</div>
	</nav>
</body>
</html>