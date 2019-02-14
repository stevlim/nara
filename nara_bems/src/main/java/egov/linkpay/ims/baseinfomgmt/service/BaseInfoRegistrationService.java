package egov.linkpay.ims.baseinfomgmt.service;

import java.util.List;
import java.util.Map;

public interface BaseInfoRegistrationService
{
	//카테고리 대분류
	List<Map<String, String>> selectKindCd() throws Exception;
	//기본정보 카테고리 소분류
	List<Map<String, String>> selectSCateList() throws Exception;
	//상점유형
	List<Map<String, String>> selectMallTypeCd() throws Exception;
	//tb_code 조회
	List<Map<String, String>> selectCodeCl(String CodeCl) throws Exception;
	List<Map<String, String>> selectGidList() throws Exception;
	List<Map<String, String>> selectVidList() throws Exception;
	//card list select
	List<Map<String, String>> selectCardList(Map<String, Object> objMap) throws Exception;
	//카테고리 소분류 조회
	List<Map<String, String>> selectCateList(String param) throws Exception;
	//기본정보조회-담당자 리스트 
	List<Map<String,String>> selectEmplList(Map< String, Object > paramMap) throws Exception;
	//mid 중복체크
	Integer dupIdChk(Map< String, Object > paramMap) throws Exception;
	//사업자정보조회
	List<Map<String,Object>> selectCoNo(Map< String, Object > paramMap) throws Exception;
	//기본정보조회
	List<Map<String,Object>> selectBaseInfo(Map< String, Object > paramMap) throws Exception;
	//기본정보조회
	List<Map<String,Object>> selectBaseInfoAll(Map< String, Object > paramMap) throws Exception;
	//기본정보조회-GID INFO
	List<Map<String,Object>> selectGidInfo(String param) throws Exception;
	//기본정보조회-VID INFO
	List<Map<String,Object>> selectVidInfo(String param) throws Exception;
	//기본정보조회-VID INFO FEE 조회
	List<Map<String,Object>> selectVidFeeInfo(Map< String, Object > paramMap) throws Exception;
	//기본정보조회-카드결제수단
	List<Map<String,Object>> selectCardPay(Map< String, Object > paramMap) throws Exception;
	//기본정보조회-승인대기리스트조회
	List<Map<String,Object>> selectApproList(Map< String, Object > paramMap) throws Exception;
	int selectApproListTotal(Map< String, Object > paramMap) throws Exception;
	
	String selectSettleCycleCode(Map< String, Object > paramMap) throws Exception;
	//tb_mbs 정보(전체) insert
	void insertBaseInfo(Map< String, Object > paramMap) throws Exception;
	//tb_grp GID정보 insert
	void insertGidRegist(Map< String, Object > paramMap) throws Exception;
	//tb_vgrp VID정보 insert
	void insertVidRegist(Map< String, Object > paramMap) throws Exception;
	//tb_mbs 일반 정보 update
	void updateNormalInfo( Map< String, Object > paramMap ) throws Exception;;
	//tb_mbs 기타 정보 update
	void updateEtcInfo( Map< String, Object > paramMap ) throws Exception;
	//tb_mbs 정산 정보 update
	void updateSettleInfo( Map< String, Object > paramMap ) throws Exception;
	//tb_mbs 결제수단 update
	void updatePayType( Map< String, Object > paramMap ) throws Exception;
	//기본정보 GID update
	void updateGidInfo( Map< String, Object > paramMap ) throws Exception;
	//기본정보 VID update
	void updateVidInfo( Map< String, Object > paramMap ) throws Exception;
	//기본정보조회
	Map<String,Object> merchantReg(Map< String, Object > paramMap) throws Exception;
	//기본정보조회-승인 mid-> overCard Fee LIST
	Map<String,Object> selectFeeRegOverCardLst(Map< String, Object > paramMap) throws Exception;
	//기본정보조회-승인 mid-> Card Fee LIST
	Map<String,Object> selectFeeRegCardLst(Map< String, Object > paramMap) throws Exception;
	//파라미터 서비스 호출 
	Map<String,Object> parameterSetting(Map< String, Object > paramMap) throws Exception;
	//기본정보조회-MID 수수료 중 가맹점 번호 등록 
	Map<String,Object> selectMbsNo(Map< String, Object > paramMap) throws Exception;
}
