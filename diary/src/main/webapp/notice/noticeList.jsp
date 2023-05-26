<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import = "java.util.*"%>
<%@ page import = "vo.*" %>
<%
	// 요청 분석(currentPage, ...)
	// 현재 페이지
	int currentPage = 1; 
	
	if (request.getParameter("currentPage") != null){
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	System.out.println(currentPage + " <-- currentPage");
	
	// 페이지당 출력할 행의 수
	int rowPerPage = 10;
	
	// 시작 행번호
	int startRow = (currentPage - 1) * rowPerPage;
	
	//db연결 설정
	Class.forName("org.mariadb.jdbc.Driver");
	java.sql.Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary", "root", "java1234");
	
	// 쿼리문
	// select notice_no, notice_title, createdate from notice
	// order by createdate desc
	// limit 0, 5;
	String sql = "select notice_no noticeNo, notice_title noticeTitle, createdate from notice order by createdate desc limit ?, ?"; 
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, startRow);
	stmt.setInt(2, rowPerPage);
	System.out.println(stmt + " <-- stmt");
	
	// 출력할 공지 데이터
	ResultSet rs = stmt.executeQuery();
	// 자료구조 ResultSet타입을 일반적인 자료구조타입(자바 배열 or 기본 API 타입)
	// ResultSet -> ArrayList<Notice>
	// ArrayList에 값을 집어 넣어준다.
	ArrayList<Notice> noticeList = new ArrayList<Notice>();
	while(rs.next()){
		Notice n = new Notice();
		n.noticeNo = rs.getInt("noticeNo");
		n.noticeTitle = rs.getString("noticeTitle");
		n.createdate = rs.getString("createdate");
		noticeList.add(n);
	}
	
	// select count(*) from notice
	PreparedStatement stmt2 = conn.prepareStatement(
		"select count(*) from notice");
	ResultSet rs2 = stmt2.executeQuery();
	
	int totalRow = 0;
	if (rs2.next()) {
		totalRow = rs2.getInt("count(*)");
	}
	int lastPage = totalRow / rowPerPage;
	if (totalRow % rowPerPage != 0) {
		lastPage += 1;
	}
	// 페이지 수 나열
	int pagePerPage = 10;
	int startPageNum = ((currentPage - 1) / pagePerPage) * pagePerPage + 1;
	
	// 마지막 페이지 수 나열
	int maxPageNum = startPageNum + pagePerPage - 1;
	
	// 마지막 페이지 예외 처리
	if (maxPageNum > lastPage) {
		maxPageNum = lastPage;
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
	<h1>공지 리스트</h1>
	<table class="table table-striped">
		<tr>
			<th>notice_title</th>
			<th>createdate</th>
		</tr>
		<%
				for(Notice n : noticeList) {
		%>
				<tr>
					<td>
						<a href="./noticeOne.jsp?noticeNo=<%=n.noticeNo%>&currentPage=<%=currentPage%>">
						<%=n.noticeTitle%>
						</a>
					</td>
					<td><%=n.createdate.substring(0, 10)%></td>
				</tr>
		<%
			}
		%>
	</table>
	<table class="table table-primary">
		<tr>
		<%
			// 첫페이지
			if (startPageNum > 1) {
		%>
			<td>
				<a href="./noticeList.jsp?currentPage=<%=currentPage - pagePerPage%>">
					이전
				</a>
			</td>
		<%
			}
		
			for (int i = startPageNum; i <= maxPageNum; i++) {
		%>
				<td>
				<a href="./noticeList.jsp?currentPage=<%=i%>">
				<%=i%>
				</a>
				</td>
		<%
			}
			
			// 마지막 페이지
			if (maxPageNum < lastPage) {
		%>
			<td>
				<a href="./noticeList.jsp?currentPage=<%=currentPage + pagePerPage%>">
					다음
				</a>
			</td>
		<%
			}
		%>
		</tr>
	</table>
	<form action="./insertNoticeForm.jsp" method="post">
		&nbsp; <button class="btn btn-primary" type="submit" name="currentPage" value="<%=currentPage%>">공지 입력</button>
	</form>
	
	
</body>
</html>