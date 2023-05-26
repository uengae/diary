<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	request.setCharacterEncoding("utf-8");

	// 요청값 유효성 검사
	if(request.getParameter("noticeNo") == null) {
		response.sendRedirect("./noticeList.jsp");
		return;
	}
	
	// 삭제할 내용의 noticeNo를 받아옴
	int noticeNo = Integer.parseInt(request.getParameter("noticeNo"));
	System.out.println(noticeNo + " <-- deleteNoticeForm param noticeNo");
	
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
	<h1>공지 삭제</h1>
	<form action="./deleteNoticeAction.jsp" method="post" id="delet">
		<table class="table table-striped">
			<tr>
				<td>notice_no</td>
				<td>
					<input type="text" name="noticeNo" value="<%=noticeNo%>" readonly="readonly">
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
	<form action="./noticeOne.jsp?noticeNo=<%=noticeNo%>" method="post" id="cancle"></form>
	<!-- 버튼 모양 통일을 위해 form에 id 넣어서 버튼 만듦 -->
	&nbsp; <button class="btn btn-primary" type="submit" form="delete">삭제</button>
	&nbsp; <button class="btn btn-primary" type="submit" form="cancle">취소</button>
</body>
</html>