package com.sist.haebollangce.lounge.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.sist.haebollangce.lounge.model.InterLoungeDAO;
import com.sist.haebollangce.lounge.model.LoungeBoardDTO;

@Service
public class LoungeService implements InterLoungeService {

	// === 의존객체 주입 (Type 에 따라 알아서 Bean 을 주입해준다.)
	@Autowired
	private InterLoungeDAO  dao;

	// === #2. 게시판 글쓰기 완료 요청 ===
	@Override
	public int loungeAdd(LoungeBoardDTO lgboardvo) throws Exception {
		int n = dao.loungeAdd(lgboardvo);
		System.out.println("Service 에서 n : " + n);
		return n;
	}

	// --- #3-1. 페이징 처리 안한 검색어 없는 전체 글 목록 보기 ---
	@Override
	public List<LoungeBoardDTO> lgboardListNoSearch() {
		List<LoungeBoardDTO> lgboardList = dao.lgboardListNoSearch();
		return lgboardList;
	}
	
}