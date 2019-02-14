package egov.linkpay.ims.businessmgmt.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Service;

import egov.linkpay.ims.businessmgmt.dao.SubmallDAO;

@Service("subMallService")
public class SubMallServiceImpl implements SubMallService
{
	 Logger log = Logger.getLogger(this.getClass());
	
	 @Resource(name="submallDAO")
	 private SubmallDAO submallDAO; 
	 
	 @Override
    public Map<String, Object> selectCardStatusList(Map<String, Object> objMap) throws Exception {
		 Map<String, Object> resultMap = new HashMap<String, Object>();
		 List<Map<String, Object>> aLst = new ArrayList<Map<String, Object>>();
		 List<Map<String, Object>> aLst1 = new ArrayList<Map<String, Object>>();
		 
		 aLst = submallDAO.selectCardStatusList(objMap);
		 
		 resultMap.put("data" , aLst);
		 
		 if(aLst.size() > 0 )
		 {
			 for(int i=0; i<aLst.size(); i++)
			 {
				 Map<String, Object> map = aLst.get( i );
				 log.info("map : " + map);
				 aLst1 = submallDAO.selectCardStatusInfo(map);
			 }
			 log.info( "cardLst : " + aLst1 );
			 resultMap.put("cardList" , aLst1);
			 /**
			  * 카드 등록 정보 
			  *  0: 비씨, 1: 국민, 2: 외환, 3: 삼성, 4: 신한, 5: 현대 , 6 : 롯데  , 7 : 농협
			  */
			 String[]  cardInfo   = new String[8]; // 기본 카드 사이즈 만큼
			 String status = null;
			 String retMsg = null;
			 int cardCode =0;
			 int rCode = 0;
			 int i = 0;
			 for (;i<8 ; i++)				cardInfo[i] = "&nbsp;";
			 
			 List<Map<String, Object>> cardLst = new ArrayList<Map<String, Object>>();
			 resultMap.put( "cardLst" , cardLst );
			 if( aLst1.size()>0){
				 for(i = 0; i < aLst1.size(); i++) {
					 Map<String, Object> infoMap = (Map<String, Object>)aLst1.get(i);
					 log.info("infoMap  : " + infoMap);
					 //fn_cd,  sName  
					 // 01: 비씨 / 02: 국민 / 03: 외환 / 04: 삼성 / 06: 신한 / 07: 현대 / 08 : 롯데   / 12 : 농협  > fn_cd   값은 고정값 ( From. 김택규K )
					 cardCode = Integer.parseInt((String)infoMap.get("CP_CD"));
					 status = (String)infoMap.get("SNAME");
					 
					 // 5이상은 -1 하면되나...switch로 진행.
					 switch(cardCode) {
					 case  1 : rCode=0;  	break;		// 비씨
					 case  2 : rCode=1;		break;		// 국민
					 case  3 : rCode=2;		break;		// 외환
					 case  4 : rCode=3; 		break;		// 삼성
					 case  6 : rCode=4;		break;		// 신한
					 case  7 : rCode=5;		break;		// 현대
					 case  8 : rCode=6;		break;		// 롯데
					 case  12 : rCode=7;		break;		// 농협
					 default:	rCode=-1;	break;
					 }		
					 
					 if(rCode>=0){
						 cardInfo[rCode]=status;
					 }
					 log.info( "cardInfo : " + cardInfo[rCode] );
					 Map<String, Object> cardMap = new HashMap<>();
					 cardMap.put( "status"+i , cardInfo[rCode] );
					 cardLst.add( cardMap);
					 log.info( "cardMap : " + cardMap );
				 }
			 }
			 resultMap.put("cardInfo", cardLst);
		 }
		 
        return resultMap;
    }
    
    @Override
    public Object selectCardStatusListTotal(Map<String, Object> objMap) throws Exception {
        return submallDAO.selectCardStatusListTotal(objMap);
    }
    
    @Override
    public Object selectCardSubMallInfo(Map<String, Object> objMap) throws Exception {
        return submallDAO.selectCardSubMallInfo(objMap);
    }
    public int  insertSubCardReg(Map<String, Object> objMap) throws Exception {
    	int cnt = 1 ;
    	
    	try
    	{
    		 String strpCoNo = (String)objMap.get("coNo");
    		  String[] aCpCd = {"01","02","03","04","06","07","08","12"};
    		  
    		  List<Map<String, Object>> aLst = new ArrayList<Map<String, Object>>();
    		  
    		  for(int i = 0; i < aCpCd.length; i++) {
    		  	String strpSel = (String)objMap.get("sel"+aCpCd[i]);
    		  	String strpOldSel = (String)objMap.get("oldSel"+aCpCd[i]);
    		  	String strpReqDt = (String)objMap.get("req_dt"+aCpCd[i]);
    		  	String strpTxt = (String)objMap.get("txt"+aCpCd[i]);
    		  	String strpOldTxt = (String)objMap.get("oldtxt"+aCpCd[i]);
    		  	log.info( "data : " + aCpCd[i]  + " : " + ", strpSel : " +strpSel );
    		  	log.info( "data : " + aCpCd[i]  + " : " + ", strpOldSel : " +strpOldSel );
    		  	log.info( "data : " + aCpCd[i]  + " : " + ", strpReqDt : " +strpReqDt );
    		  	log.info( "data : " + aCpCd[i]  + " : " + ", strpTxt : " +strpTxt );
    		  	log.info( "data : " + aCpCd[i]  + " : " + ", strpOldTxt : " +strpOldTxt );
    		  	
    		  	
    		  	if(strpTxt== null || "".equals(strpTxt)){
    		  		strpTxt = "";
    		  	}
    		  	
    		  	Map<String, Object> map = new HashMap<String, Object>();
    		  	  	
    		  	if(strpOldSel==null || "".equals(strpOldSel)){
    		  	  	map.put("updType", "0");
    		  	}else{
    		  	  	if((strpSel ==null || strpSel.equals(strpOldSel)) 
    		  	  			&& (strpTxt ==null || strpTxt.equals(strpOldTxt)))continue;
    		  		map.put("updType", "1");
    		  	}
    		  	
    		  	map.put("coNo", strpCoNo);
    		  	map.put("cpCd", aCpCd[i]);
    		  	map.put("status", strpSel);
    		  	map.put("reqDt", strpReqDt);
    		  	map.put("bef_status", strpOldSel);
    		  	
    		  	map.put("retMsg", strpTxt);
    		  	log.info( "map : " + map );
    		    aLst.add(map);
    		  }
    		  
    		  log.info("list size : " + aLst.size());
    		if(aLst.size() > 0)
		  {
			  for(int i = 0; i < aLst.size(); i++) 
			  {
				  Map<String, Object> map = (Map<String, Object>)aLst.get(i);
				  log.info( "list Map : " + map );
				  map.put("worker", objMap.get( "worker" ));				
				  String updateType = (String)map.get("updType");
				  log.info( "updType : " + updateType  );
				  
				  if(updateType.equals( "0" ))
				  {
					  //insert data:submall
					  String reqDt = submallDAO.insertSubMallRsltManual(map).toString();
					  log.info(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>reqDt"+reqDt);
					  
					  //insert data:history
					  /*if(reqDt!=null && reqDt.length()>0){
					client.update("insSubMallRsltHistory", map);
				}*/
				  }
				  else
				  {
					  //update data:submall
					  cnt = submallDAO.updateSubMallRsltManual(map);
					  
					  //insert data:history
					  /*if(iRtn>0){
					client.update("insSubMallRsltHistory", map);
				}*/
					  
				  }
			  }
		  }
		  else{
			  cnt = 99;
		  }
    	}
    	catch(Exception e)
    	{
    		log.error( "Exception  : " , e );
    		cnt = -1;
    	}
    	
    		//submallDAO.insertSubCardReg(objMap);
        return cnt;
    }
}
