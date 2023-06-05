<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<% String ctxPath = request.getContextPath(); %> 

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> 



<script type="text/javascript">

  	$(document).ready(function(){
	
  		lggoReadComment();  // 문자 시작되자마자 페이징 처리안한 댓글 읽어오기
  		
  		// -- 엔터치면 댓글입력됨 --
		$("input#commentContent").keyup(function(e){
			if (e.keyCode == 13) { 
				lgcgoAddWrite();
			}
		});
  		
		// 페이지 로딩 시 스크롤 위치를 저장
		/* $(window).addEventListener('beforeunload', function() {
		  	localStorage.setItem('scrollPosition', window.pageYOffset);
		}); */
		
  	});// end of $(document).ready(function(){})-------------------------------

  	
  	// === Function Declaration === //
  	
  	// == 스크롤위치 저장 == 
  	function restoreScrollPosition() {
	  	// 이전 스크롤 위치를 로컬 스토리지에서 가져옴
	  	var scrollPosition = localStorage.getItem('scrollPosition');

	  	// 이전 스크롤 위치가 존재하면 스크롤 이동
	  	if (scrollPosition) {
	    	window.scrollTo(0, scrollPosition);
	  	}
	}

  	// == 댓글쓰기 ==
  	function lgcgoAddWrite() {
  		
		const commentContent = $("input#commentContent").val().trim();
  		
  		if(commentContent == "") {
  			alert("댓글 내용을 입력하세요.");
  			return; // 종료
  		}
  		
  		$.ajax({
  			url:"<%= ctxPath%>/lounge/loungeaddComment",
  			data:{"fk_userid":$("input#fk_userid").val(), 
  			      "name":$("input#name").val(), 
  			      "content":$("input#commentContent").val(),
  			      "parentSeq":$("input#parentSeq").val()} ,
  		
		    type:"post",
    		dataType:"json",
    		success:function(json){
    			console.log("~~~ 확인뇽 : " + JSON.stringify(json));
    			// ~~~ 확인뇽 : {"name":"망나뇽수진","n":0}
    			
    			if(json.n == 0) {
    				alert("댓글쓰기 실패");
    			}
    			else {
    				lggoReadComment();	// 페이징 처리 안한 댓글 읽어오기
				}
    			$("input#commentContent").val(""); // 댓글이 써졌든 아니든 이제 댓글칸 비워주기 			
    		},
    		error: function(request, status, error){
                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
  			      
  		});//end of $.ajax()----------------------------------
  		
  	}//end of function lgcgoAddWrite()----------------
  	

    function lgccgoAddWrite(fk_seq, depthno, groupno) {
        
  		// 예시) /lounge/loungeView URL에 파라미터 추가하여 이동
        var url = '/lounge/loungeView?seq=' + ${requestScope.lgboarddto.seq};
        url += '&fk_seq=' + fk_seq;
        url += '&groupno=' + groupno;
        url += '&depthno=' + depthno;
        location.href = url;
    }

  	
 	// === 댓글 페이징 처리안하고 읽어오기  
  	function lggoReadComment() {
  		
  		$.ajax({
			url:'<%= ctxPath%>/lounge/loungereadComment',
			data: {"parentSeq":"${requestScope.lgboarddto.seq}"},
			dataType:"json",
			success:function(json){
			//	console.log("~~~ 확인뇽 : " + JSON.stringify(json));
			//	console.log("~~~ 확인뇽 json.length : " + json.length); //-> 여기서 값은 잘 나오지만 $ 앞에 \ 를 안써줘서 값이 안나왔었다
				
				let html = ``;
  				if(json.length > 0) {
  					$.each(json, function(index, item){
  						
  						if (item.depthno == 0) {
	  						html += ` <div class="d-flex flex-row mb-3"> 
			                		 	<img style="border: solid 3px #eee; border-radius: 100%; width:45px; height: 45px; vertical-align: top;" src="http://images.munto.kr/production-user/1684469607083-photo-g1p6z-101851-0?s=48x48" /> 
			  	              		 	<div class="c-details"> 
			  	                     		<h5 class="mb-1 ml-3 lounge_comment_userid"><span class="lounge_comment_name">\${item.name}</span></h5> 
			  	                     		<div class="c-details">
			  		                 			<h6 class="mb-0 ml-3 lounge_comment_content">\${item.content}</h6>
			  	                	 		</div>
			  	                	 		<div class="c-details"> 
			  	                				<small class="mb-0 ml-3" style="color:gray;">\${item.regdate}</small>
			  	                				<small type="button" class="mb-0 ml-2" style="color:gray;" onclick="lgccgoAddWrite(\${item.fk_seq}, \${item.depthno}, \${item.groupno});">답글달기</small> 
			  	                	 		</div>
			  	                		</div> 
		  	              		 	  </div>`; 
  						} 
  						
  						else if (item.depthno > 0) {
  							let padding = parseInt(item.depthno)*40;
  							html += ` <div class="d-flex flex-row mb-3" style="padding-left:\${padding}px"> 
  										<img style="border: solid 3px #eee; border-radius: 100%; width:45px; height: 45px; vertical-align: top;" src="http://images.munto.kr/production-user/1684469607083-photo-g1p6z-101851-0?s=48x48" /> 
			  	              		 	<div class="c-details"> 
			  	                     		<h5 class="mb-1 ml-3 lounge_comment_userid"><span class="lounge_comment_name">\${item.name}</span></h5> 
			  	                     		<div class="c-details">
			  		                 			<h6 class="mb-0 ml-3 lounge_comment_content">\${item.content}</h6>
			  	                	 		</div>
			  	                	 		<div class="c-details"> 
			  	                				<small class="mb-0 ml-3" style="color:gray;">\${item.regdate}</small>
			  	                				<small type="button" class="mb-0 ml-2" style="color:gray;" onclick="lgccgoAddWrite(\${item.fk_seq}, \${item.depthno}, \${item.groupno})">답글달기</small>
											</div> 
			  	                		</div> 
			              		 	</div>`;
  						}
  					});
  				}
  				else {
  					html += ` <div>댓글이 존재하지 않습니다.</div> `
  				}
  				$("div#lgcommentDisplay").html(html);
  			},
  			error: function(request, status, error){
                alert("code: "+request.status+"\n"+"message: "+request.responseText+"\n"+"error: "+error);
            }
  			
  		});//end of $.ajax()--------------------------------------
  		
  	}//end of function lggoReadComment()----------------
  	
  	
</script>


<div class=" container-fluid mt-5 mb-5 mx-auto bg-white">
	<div class="row col-md-10 mx-auto my-5 justify-content-center" style="width:50%; ">
	
		<c:if test="${not empty requestScope.lgboarddto}">
		    <div class="card p-3 mb-5 mt-5" >
		        <div class="d-flex justify-content-between">
		            <div class="d-flex flex-row align-items-center">
		                <div><img style="border-radius:60%; width:60px; height: 60px;" src="http://images.munto.kr/production-user/1684469607083-photo-g1p6z-101851-0?s=48x48" /> </div>
		                <div class="c-details">
		                    <h6 class="mb-0 ml-4">${lgboarddto.name}</h6> 
		                    <span class="ml-4">
		                    	<c:if test="${lgboarddto.regDate_ago == 0}">today new</c:if>
		                        <c:if test="${lgboarddto.regDate_ago > 0}">${lgboarddto.regDate_ago} days ago</c:if>
		                    </span>
		                </div>
		            </div>
		            <div class="badge2"> <span>follow</span> </div>
		        </div>
		        <div class="mt-4">
		            <img style="width:100%;" src="http://images.munto.kr/production-feed/1684289174510-photo-spznw-42282-0?s=1080x1080" />
		            <div class="mt-3">
		            	<h4>${lgboarddto.subject}</h4>
		                <div>${lgboarddto.content}</div>
		                <div style="border:solid 1px silver; border-radius:7px; margin:10px; padding:7px;"> 첨부파일 |  
		                	<a href="<%= request.getContextPath() %>/lounge/lgdownload?seq=${lgboarddto.seq}" style="color:black;">${lgboarddto.orgFilename} ( <fmt:formatNumber value="${lgboarddto.fileSize}" pattern="#,###" /> bytes ) </a>
		                	<%-- <c:if test="${sessionScope.loginuser != null}">
		               			<a href="<%= request.getContextPath() %>/download.action?seq=${requestScope.boardvo.seq}">${requestScope.boardvo.orgFilename}</a>
		               		</c:if>
		               		<c:if test="${sessionScope.loginuser == null}">
		               			${requestScope.boardvo.orgFilename}
		               		</c:if> --%>
		                </div>
		                <div class="mt-4"> 
		                	<span class="text1 ">
		                		<img src="https://images.munto.kr/munto-web/ic_action_like-empty-black_30px.svg?s=32x32"/>${lgboarddto.likeCount}
		                		<img src="https://images.munto.kr/munto-web/ic_action_comment_30px.svg?s=32x32"/>${lgboarddto.commentCount}
		                		<img src="https://images.munto.kr/munto-web/info_group.svg?s=32x32"/>${lgboarddto.readCount}
		                	</span> 
		                	
					        <span class="dropup">
								<a class="nav-link dropdown-toggle headerfont" data-toggle="dropdown"><i class="fa-solid fa-ellipsis" style="color: #0d0d0d;"></i></a>
								<ul class="dropdown-menu">
									<li><i class="dropdown-item fa-solid fa-pen btnEdit" style="color: gray;" onclick="javascript:location.href='<%= ctxPath%>/lounge/loungeEdit?seq=${requestScope.lgboarddto.seq}'">&nbsp;글 수정하기</i></li>
									<li><i class="dropdown-item fa-solid fa-trash btnDelete" style="color:gray;" onclick="javascript:location.href='<%= ctxPath%>/lounge/loungeDel?seq=${requestScope.lgboarddto.seq}'">&nbsp;글 삭제하기</i></li>
								</ul>
							</span>
		                	
		                </div>
		            </div>
		        </div>
		        
		     
		    	<!-- 댓글쓰기 폼 추가 (로그인했을때만 가능)-->
		    <%--<c:if test="${not empty sessionScope.loginuser}">--%>
		    	<form name="addWriteFrm" id="addWriteFrm" style="margin-top: 20px;">
			    	<div class="d-flex flex-row align-items-center">
		                <div > 
		                	<img style="border: solid 3px #eee; border-radius: 100%; width:45px; height: 45px; vertical-align: top;" src="https://blogpfthumb-phinf.pstatic.net/MjAyMzAzMjZfMTcg/MDAxNjc5ODA1Nzg5MTA1.q_8Sgd5xxiU_c6miUoEzA8hlH3NQxSN7b0MrRsFUFkwg.Blbzms8HupOJpb4xBiGh9sKEXI7dluwLxcNeyuo6Ry4g.PNG.jin970510/profileImage.png?type=w161" /> 
		                </div>
		                <div style="width:100%;">
		                	<input type="hidden" name="fk_userid" id="fk_userid" value="sudin" /> 
		                	<input type="hidden" name="name" id="name" value="망나뇽수진" /> 
		                    
		                    <div class=" c-details">
		                    	<h6 class="mb-0 ml-2 lounge_comment_content align-items-center">
		                    		
		                    		<!-- 댓글쓰기인 경우 -->
		                    		<c:if test="${requestScope.fk_seq eq ''}">
				                    	<input type="text" name="content" id="commentContent" style="border-radius:10px; border: solid 3px #eee; height: 35px; width:90%;" placeholder=" 댓글달기.." /> 
			                    	</c:if>
			                    	
			                    	<!-- 대댓글쓰기인 경우 -->
		                    		<c:if test="${requestScope.fk_seq ne ''}">
				                    	<input type="text" name="content" id="commentContent" style="border-radius:10px; border: solid 3px #eee; height: 35px; width:90%;" placeholder=" ${requestScope.name} 님에게 댓글달기.." /> 
			                    	</c:if>
			                    	
								   	<%-- === #9-4. 답변글쓰기가 추가된 경우 시작 === --%>
								   	<input type="hidden" name="fk_seq" size="1" value="${requestScope.fk_seq}" /> 
								   	<input type="hidden" name="groupno" size="1" value="${requestScope.groupno}" />   	
								   	<input type="hidden" name="depthno" size="1" value="${requestScope.depthno}" />  
								   	<%--=== 답변글쓰기가 추가된 경우 끝 === --%>
   	
			                    	<%-- 댓글에 달리는 원게시물의 글번호(즉, 부모글 글번호) --%>
			                    	<input type="hidden" name="parentSeq" id="parentSeq" value="${requestScope.lgboarddto.seq}"/>&nbsp;
			                    	<button type="button" class="btn btn-habol btn-sm" style="width:50px;" onclick="lgcgoAddWrite()">게시</button>
		                    	</h6>
		                	</div>
		                </div>
		            </div>
		        </form>
		    <%--</c:if>--%>
		    	<!-- 댓글쓰기끝 -->
		    	
		    	<hr style="border: solid 1px #eee;">
		    	
		    	<!-- 댓글보기 -->
				<div id="lgcommentDisplay"></div>
	            <!-- 댓글보기 끝-->
	            
		    </div>
	    </c:if>
	</div>
</div>

