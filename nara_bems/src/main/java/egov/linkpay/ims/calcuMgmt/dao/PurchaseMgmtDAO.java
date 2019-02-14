package egov.linkpay.ims.calcuMgmt.dao;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import egov.linkpay.ims.common.common.BaseDAO;

@Repository("purchaseMgmtDAO")
public class PurchaseMgmtDAO extends BaseDAO
{
	Logger logger = Logger.getLogger(this.getClass());
	
	public Object selectAcqProcFlg(Map<String,Object> paramMap) throws Exception {
		return selectOne( "purchaseMgmt.selectAcqProcFlg", paramMap);
    }
	@SuppressWarnings( "unchecked" )
	public List< Map<String,Object> > selectAcqTransDay(Map<String, Object> paramMap) throws Exception{
		String bizDay = (String)selectOne( "purchaseMgmt.selectAcqBizDay", paramMap);
		paramMap.put( "bizDay", bizDay );
		return selectList( "purchaseMgmt.selectAcqTransDay", paramMap);
	}
	@SuppressWarnings( "unchecked" )
	public List< Map<String,Object> > selectAcqVerifyTrans(Map<String, Object> paramMap) throws Exception{
		return selectList( "purchaseMgmt.selectAcqVerifyTrans", paramMap);
	}
	@SuppressWarnings( "unchecked" )
	public List< Map<String,Object> > selectAcqException(Map<String, Object> paramMap) throws Exception{
		return selectList( "purchaseMgmt.selectAcqException", paramMap);
	}
	@SuppressWarnings( "unchecked" )
	public List< Map<String,Object> > selectAcqCanResr(Map<String, Object> paramMap) throws Exception{
		return selectList( "purchaseMgmt.selectAcqCanResr", paramMap);
	}
	@SuppressWarnings( "unchecked" )
	public List< Map<String,Object> > selectAcqRetry(Map<String, Object> paramMap) throws Exception{
		return selectList( "purchaseMgmt.selectAcqRetry", paramMap);
	}
	@SuppressWarnings( "unchecked" )
	public List< Map<String,Object> > selectAcqList(Map<String, Object> paramMap) throws Exception{
		return selectList( "purchaseMgmt.selectAcqList", paramMap);
	}
	//매입검증 차이건 리스트
	@SuppressWarnings( "unchecked" )
	public List< Map<String,Object> > selectAcqGap(Map<String, Object> paramMap) throws Exception{
		return selectList( "purchaseMgmt.selectAcqGap", paramMap);
	}
	public int selectAcqGapTotal(Map<String, Object> paramMap) throws Exception{
		return (Integer)selectOne( "purchaseMgmt.selectAcqGapTotal", paramMap);
	}
	@SuppressWarnings( "unchecked" )
	public List< Map<String,Object> > selectAcqCntOfVan(Map<String, Object> paramMap) throws Exception{
		return selectList( "purchaseMgmt.selectAcqCntOfVan", paramMap);
	}
	//매입결과 내역 리스트 조회
	@SuppressWarnings( "unchecked" )
	public List< Map<String,Object> > selectAcqTidRsltList(Map<String, Object> paramMap) throws Exception{
		return selectList( "purchaseMgmt.selectAcqTidRsltList", paramMap);
	}
	public int selectAcqTidRsltListTotal(Map<String, Object> paramMap) throws Exception{
		return (Integer)selectOne( "purchaseMgmt.selectAcqTidRsltListTotal", paramMap);
	}
	//매입결과 정보 조회
	@SuppressWarnings( "unchecked" )
	public List< Map<String,Object> > selectAcqTidRsltInfo(Map<String, Object> paramMap) throws Exception{
		return selectList( "purchaseMgmt.selectAcqTidRsltInfo", paramMap);
	}
	//매입결과 결과 리스트 조회
	@SuppressWarnings( "unchecked" )
	public List< Map<String,Object> > selectAcqRsltList(Map<String, Object> paramMap) throws Exception{
		return selectList( "purchaseMgmt.selectAcqRsltList", paramMap);
	}
	public int selectAcqRsltListTotal(Map<String, Object> paramMap) throws Exception{
		return (Integer)selectOne( "purchaseMgmt.selectAcqRsltListTotal", paramMap);
	}
	//반송조회/처리 리스트 조회
	@SuppressWarnings( "unchecked" )
	public List< Map<String,Object> > selectAcqRetList(Map<String, Object> paramMap) throws Exception{
		return selectList( "purchaseMgmt.selectAcqRetList", paramMap);
	}
	public int selectAcqRetListTotal(Map<String, Object> paramMap) throws Exception{
		return (Integer)selectOne( "purchaseMgmt.selectAcqRetListTotal", paramMap);
	}
	public int updateRetProc(Map<String, Object> paramMap) throws Exception{
		return  (Integer)update( "purchaseMgmt.updateRetProc", paramMap);
	}
	public int insertProcRetReAcq(Map<String, Object> paramMap) throws Exception{
		return (Integer)insert( "purchaseMgmt.insertProcRetReAcq", paramMap);
	}
}
