<%@page import="javax.print.CancelablePrintJob"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import = "vo.*" %>
<%
	// target변수들 선언
	int targetYear = 0;
	int targetMonth = 0;
	
	// 년 or 월이 요청값에 넘어오지 않으면 오늘 날짜의 년/월값으로
	if (request.getParameter("targetYear") == null
			||request.getParameter("targetYear") == null) {
		Calendar c = Calendar.getInstance();
		targetYear = c.get(Calendar.YEAR);
		targetMonth = c.get(Calendar.MONTH);
	} else {
		targetYear = Integer.parseInt(request.getParameter("targetYear"));
		targetMonth = Integer.parseInt(request.getParameter("targetMonth"));
	}
	// 디버깅
	System.out.println(targetYear + " <--targetYear");
	System.out.println(targetMonth + " <--targetMonth");
	
	// 오늘 날짜
	Calendar today = Calendar.getInstance();
	int todayDate = today.get(Calendar.DATE);
	
	// targetMonth 1일의 요일?
	Calendar firstDay = Calendar.getInstance(); // 2023 4 24
	firstDay.set(Calendar.YEAR, targetYear); // 2023
	firstDay.set(Calendar.MONTH, targetMonth); // 4
	firstDay.set(Calendar.DATE, 1); // 1
	
	// api를 이용해서 달이 12 넘어갈때 랑 -1 이될때 year값을 계산한다.
	targetYear = firstDay.get(Calendar.YEAR);
	targetMonth = firstDay.get(Calendar.MONTH);
	
	int firstYoil = firstDay.get(Calendar.DAY_OF_WEEK); // 2023 4 1 이 몇번째 요일인지, 일1, 토7
	
	// 1일 앞의 빈 공백수
	int startBlank = firstYoil - 1;
	System.out.println(startBlank);
	
	// targetMonth 마지막일	
	int lastDate = firstDay.getActualMaximum(Calendar.DATE);
	
	// lastDate 날짜 뒤 공백칸의 수
	int endBlank = 0;
	if ((startBlank + lastDate) % 7 != 0) {
		endBlank = 7 - (startBlank + lastDate) % 7;
	}
	System.out.println(endBlank + "<--endBlank");
	
	// 전체 Td의 개수
	int totalTd = startBlank + lastDate + endBlank;
	System.out.println(totalTd + "<--totalTd");
	
	// 출력하는 전월 년/월/마지막 날짜 추출
	Calendar preMonth = Calendar.getInstance();
	preMonth.set(Calendar.YEAR, targetYear);
	preMonth.set(Calendar.MONTH, (targetMonth - 1));
	
	// 출력하는 전월 년/월
	int preTargetYear = preMonth.get(Calendar.YEAR);
	int preTargetMonth = preMonth.get(Calendar.MONTH);
	
	System.out.println(preTargetYear + "<-- preTargetYear");
	System.out.println(preTargetMonth + "<-- preTargetMonth");
	
	// 출력하는 전월 년/월/마지막 날짜 추출
	Calendar nextMonth = Calendar.getInstance();
	nextMonth.set(Calendar.YEAR, targetYear);
	nextMonth.set(Calendar.MONTH, (targetMonth + 1));
	
	 // 출력하는 다음달
	int nextTargetYear = nextMonth.get(Calendar.YEAR);
	int nextTargetMonth = nextMonth.get(Calendar.MONTH);
 	System.out.println(nextTargetYear + "<-- nextTargetYear");
	System.out.println(nextTargetMonth + "<-- nextTargetMonth"); 
	
	int preEndDateNum = preMonth.getActualMaximum(Calendar.DATE);
	System.out.println(preEndDateNum + "<-- preEndDateNum");
	
	// db 연동 및 쿼리문 실행
	Class.forName("org.mariadb.jdbc.Driver");
	Connection conn = DriverManager.getConnection(
			"jdbc:mariadb://127.0.0.1:3306/diary","root","java1234");
	String sql = "select schedule_no scheduleNo, day(schedule_date) scheduleDate, left(schedule_memo, 5) scheduleMemo, schedule_color scheduleColor from schedule where year(schedule_date) = ? and month(schedule_date) = ? order by date(schedule_date)";
	PreparedStatement stmt = conn.prepareStatement(sql);
	stmt.setInt(1, targetYear);
	stmt.setInt(2, targetMonth + 1);
	System.out.println(stmt + " <-- scheduleList stmt");
	ResultSet rs = stmt.executeQuery();
	System.out.println(rs + " <-- scheduleList rs");
	
	// ResultSet -> ArrayList<Schedule>
	// ArrayList에 값을 집어 넣어준다.
	ArrayList<Schedule> scheduleList = new ArrayList<Schedule>();
	while(rs.next()) {
		Schedule s = new Schedule();
		s.scheduleNo = rs.getInt("scheduleNo");
		s.scheduleDate = rs.getString("scheduleDate"); // 전체 날짜가 아닌 일 데이터
		s.scheduleMemo = rs.getString("scheduleMemo"); // 전체 메모가 아닌 5자만 출력 
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
	<div>
	<table class="position-relative start-50 translate-middle-x">
		<tr>
			<td>
				<a class="btn btn-outline-primary" href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth - 1%>">이전달</a>
			</td>
			<th style="font-size:40pt;">
				<%=targetYear%>년 <%=targetMonth + 1%>월
			</th>
			<td>
				<a class="btn btn-outline-primary" href="./scheduleList.jsp?targetYear=<%=targetYear%>&targetMonth=<%=targetMonth + 1%>">다음달</a>
			</td>
		</tr>
	</table>
	</div>
	<table class="table">
		<thead class="table-secondary">
			<tr>
				<th>일</th>
				<th>월</th>
				<th>화</th>
				<th>수</th>
				<th>목</th>
				<th>금</th>
				<th>토</th>
			</tr>
		</thead>
		<tr>
			<%
				for(int i = 0; i < totalTd; i += 1) {
					if(i != 0 && i % 7 == 0){
			%>
					</tr>
					<tr>
			<%
						
					}
					// 날짜 출력
					int num = i - startBlank + 1;
					
					// 전월 날짜 출력
					int preMonthDate = preEndDateNum - startBlank + 1;
					
					// 다음달 날짜 출력
					int nextMonthDate = i - lastDate - startBlank + 1;
					
					if(num > 0 && num <= lastDate) {
						String tdStyle = "";
						String btnColor = "";
						if (i % 7 == 0) {
							btnColor = "btn-outline-danger";
						} else if(i % 7 == 6) {
							btnColor = "btn-outline-primary";
						} else {
							btnColor = "btn-outline-dark";
						}
						// 오늘 날짜면
						if(today.get(Calendar.YEAR) == targetYear
							&& today.get(Calendar.MONTH) == targetMonth
							&& today.get(Calendar.DATE) == num) {
							tdStyle = "background-color: orange;";
						} else{
						}
			%>
							<td style = "<%=tdStyle%>">
								<div><!-- 날짜 숫자 -->
									<a class="btn btn-sm <%=btnColor%>" href="./scheduleListByDate.jsp?y=<%=targetYear%>&m=<%=targetMonth%>&d=<%=num%>" >
									<%=num%>
									</a>
								</div>
								<div><!-- 날짜별 일정 -->
									<%
										// cnt 는 값을 4개만 보여주기위함
										// blankCnt 는 안에 값이 없어도 4칸을 유지하기 위해 만듬
										int cnt = 0;
										int blankCnt = 4;
										for(Schedule s : scheduleList){
											if(num == Integer.parseInt(s.scheduleDate)) {
												cnt++;
												blankCnt--;
									%>
												<div style="color: <%=s.scheduleColor%>"><%=s.scheduleMemo%></div>
									<%
											}
											if (cnt == 4){
												cnt = 0;
												break;
											}
										}
										for(int j = 0; j < blankCnt; j++){
									%>
											<div>&nbsp;</div>
									<%
										}
									%>
								</div>
							</td>
			<%
					} else if (num < 1) {
			%>
					<td>
						<a class="btn btn-sm btn-outline-secondary" href="./scheduleListByDate.jsp?y=<%=preTargetYear%>&m=<%=preTargetMonth%>&d=<%=preMonthDate + i%>">
							<%=preMonthDate + i%>
						</a>
					</td>
			<%
					} else {
			%>
					<td>
						<a class="btn btn-sm btn-outline-secondary" href="./scheduleListByDate.jsp?y=<%=nextTargetYear%>&m=<%=nextTargetMonth%>&d=<%=nextMonthDate%>" class="text-muted">
							<%=nextMonthDate%>
						</a>
					</td>
			<%
					}
			%>
					
			<%
				}
			%>
		</tr>
	</table>
</body>
</html>