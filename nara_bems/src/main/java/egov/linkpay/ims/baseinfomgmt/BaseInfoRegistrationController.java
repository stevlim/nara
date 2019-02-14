package egov.linkpay.ims.baseinfomgmt;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.builder.ToStringBuilder;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import egov.linkpay.ims.baseinfomgmt.service.BaseInfoMgmtService;
import egov.linkpay.ims.baseinfomgmt.service.BaseInfoRegistrationService;
import egov.linkpay.ims.common.common.CommonDDLB;
import egov.linkpay.ims.common.common.CommonMap;
import egov.linkpay.ims.common.common.CommonMessage;
import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;
import net.sf.json.JSONObject;
import egov.linkpay.ims.common.common.CommonDDLB.DDLBType;

/**------------------------------------------------------------
 * Package Name   : egov.linkpay.ims.baseinfomgmt
 * File Name      : BaseInfoMgmtController.java
 * Description    : 기본정보 - 기본정보 조회
 * Author         : ChoiIY, 2017. 04. 17.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
@Controller
@RequestMapping(value="/baseInfoMgmt/baseInfoRegistration")
public class BaseInfoRegistrationController {
    Logger log = Logger.getLogger(this.getClass());

    @Resource(name="baseInfoMgmtService")
    private BaseInfoMgmtService baseInfoMgmtService;

    @Resource(name="baseInfoRegistrationService")
    private BaseInfoRegistrationService baseInfoRegistrationService;

    /**--------------------------------------------------
    기본정보 조회 페이지
     ----------------------------------------------------*/
    @RequestMapping(value = "/baseInfoRegistration.do")
    public String baseInfoRegistration(Model model, CommonMap commonMap) throws Exception
    {
    	log.info( "기본정보조회-Start -" );
    	List< Map< String, String > > listMap = new ArrayList<>();

    	String codeCl = "";
        model.addAttribute("MENU",               commonMap.get("MENU_GRP_NO"));
        model.addAttribute("SUBMENU",            commonMap.get("MENU_NO"));
        model.addAttribute("MENU_TITLE",         CommonMessageDic.getMessage(commonMap.get("MENU_GRP_NM").toString()));
        model.addAttribute("MENU_SUBMENU_TITLE", CommonMessageDic.getMessage(commonMap.get("MENU_NM").toString()));
        model.addAttribute("AUTH_CD",            commonMap.get("AUTH_CD"));
        model.addAttribute("MENU_GROUP_TYPE",    CommonDDLB.menuType(DDLBType.EDIT));

        model.addAttribute("MER_SEARCH",          CommonDDLB.merchantType6());
        model.addAttribute("NH_CATEGORY_LIST",  CommonDDLB.nHCategoryList());
        model.addAttribute("DEPOSIT_LIMIT",  CommonDDLB.depositLimit());

        model.addAttribute("ACQ_DAY",  CommonDDLB.Acq_Day());


        try
        {
        	//카테고리(대분류) 조회
        	log.info( "기본정보조회-1- 카테고리(대분류)" );
        	listMap = baseInfoRegistrationService.selectKindCd();
        	model.addAttribute("BIG_CATEGORY_LIST", CommonDDLB.ListOption(listMap));

        	//카테고리(대분류) 조회
        	log.info( "기본정보조회-2- 카테고리(소분류)" );
        	listMap = baseInfoRegistrationService.selectSCateList();
        	model.addAttribute("SMALL_CATEGORY_LIST", CommonDDLB.sListOption(listMap));
        	//가맹점유형
        	log.info( "기본정보조회-3- 가맹점 유형" );
        	codeCl ="0012";
        	listMap = baseInfoRegistrationService.selectCodeCl(codeCl);
        	model.addAttribute("MBS_CD_LIST", CommonDDLB.ListOption(listMap));

        	//상점유형
        	log.info( "기본정보조회-4- 상점유형" );
        	listMap = baseInfoRegistrationService.selectMallTypeCd();
        	model.addAttribute("MALL_CD_LIST", CommonDDLB.ListOption(listMap));

        	//접수경로
        	log.info( "기본정보조회-5- 접수경로" );
        	codeCl ="0007";
        	listMap = baseInfoRegistrationService.selectCodeCl(codeCl);
        	model.addAttribute("RECV_CH", CommonDDLB.ListOption(listMap));

        	log.info( "기본정보조회-6- 매입구분" );
        	codeCl ="0013";
        	listMap = baseInfoRegistrationService.selectCodeCl(codeCl);
        	model.addAttribute("ACQ_CD", CommonDDLB.ListOption(listMap));

        	log.info( "기본정보조회-7- VAN 조회" );
        	codeCl ="0003";
        	listMap = baseInfoRegistrationService.selectCodeCl(codeCl);
        	model.addAttribute("VAN_CD", CommonDDLB.ListOption(listMap));

        	log.info("기본정보조회-8- 은행코드 조회");
        	codeCl = "0001";
        	listMap = baseInfoRegistrationService.selectCodeCl(codeCl);
        	model.addAttribute("BANK_CD", CommonDDLB.ListOption(listMap));

        	log.info("기본정보조회-9- 인증형태 조회");
        	codeCl = "0057";
        	listMap = baseInfoRegistrationService.selectCodeCl(codeCl);
        	model.addAttribute("AUTH_TYPE", CommonDDLB.AuthTypeOption(listMap));

        	log.info("기본정보조회-10- 취소가능여부 조회");
        	codeCl = "0016";
        	listMap = baseInfoRegistrationService.selectCodeCl(codeCl);
        	model.addAttribute("CC_CL_CD", CommonDDLB.CancelCdOption(listMap));

        	log.info("기본정보조회-00- 정산주기 리스트조회");
        	codeCl = "0038";
        	listMap = baseInfoRegistrationService.selectCodeCl(codeCl);
        	model.addAttribute("STMT_CYCLE_CD", CommonDDLB.ListOption(listMap));


        	log.info("기본정보조회-11- 담당자 조회");
        	Map<String,Object> dataMap = new HashMap<String, Object>();
        	dataMap.put( "dept", "ALL" );
        	dataMap.put( "part", "ALL" );
        	dataMap.put( "duty", "ALL" );
        	dataMap.put( "appAuth", "ALL" );
        	dataMap.put( "status", "0" );

        	listMap = baseInfoRegistrationService.selectEmplList(dataMap);
        	model.addAttribute("EMP_MANAGER", CommonDDLB.MngOption(listMap));

        	log.info("기본정보조회-12- major card 조회");
        	List<Map<String, String>> jCardList = new ArrayList<Map<String, String>>();
        	Map<String, String> cardMap = new HashMap<String, String>();
        	JSONObject jCardMap = new JSONObject();
        	dataMap.put( "code2", "pur" );
        	listMap = baseInfoRegistrationService.selectCardList( dataMap);
        	for(int i=0; i<listMap.size(); i++){
        		cardMap = listMap.get( i );
        		log.info( "majorCardData : "  + cardMap );
        		jCardMap = JSONObject.fromObject( cardMap );
        		jCardList.add( jCardMap );
        	}
        	model.addAttribute("majorCard", jCardList);

        	log.info("기본정보조회-13- over card 조회");
        	List<Map<String, String>> jCardList1 = new ArrayList<Map<String, String>>();
        	Map<String, String> cardMap1 = new HashMap<String, String>();
        	JSONObject jCardMap1 = new JSONObject();
        	dataMap.put( "code2", "over" );
        	listMap = baseInfoRegistrationService.selectCardList( dataMap);
        	for(int i=0; i<listMap.size(); i++){
        		cardMap1 = listMap.get( i );
        		log.info( "overCardData : "  + cardMap1 );
        		jCardMap1 = JSONObject.fromObject( cardMap1 );
        		jCardList1.add( jCardMap1 );
        	}
        	model.addAttribute("overCard", jCardList1);

        	log.info("기본정보조회-14- minor card 조회");
        	List<Map<String, String>> jCardList2 = new ArrayList<Map<String, String>>();
        	Map<String, String> cardMap2 = new HashMap<String, String>();
        	JSONObject jCardMap2 = new JSONObject();
        	dataMap.put( "code2", "*" );
        	listMap = baseInfoRegistrationService.selectCardList( dataMap);
        	for(int i=0; i<listMap.size(); i++){
        		cardMap2 = listMap.get( i );
        		log.info( "overCardData : "  + cardMap2 );
        		jCardMap2 = JSONObject.fromObject( cardMap2 );
        		jCardList2.add( jCardMap2 );
        	}
        	model.addAttribute("minorCard", jCardList2);

        	log.info("기본정보조회-15- 정산 주기 조회");
        	List<Map<String, String>> stmtCycleList = new ArrayList<Map<String, String>>();
        	Map<String, String> stmtCycleMap = new HashMap<String, String>();
        	JSONObject jStmtCycleMap = new JSONObject();
        	dataMap.put( "CODE_CL", "0038" );
        	listMap = baseInfoRegistrationService.selectCodeCl((String)dataMap.get( "CODE_CL" ));
        	for(int i=0; i<listMap.size(); i++){
        		stmtCycleMap = listMap.get( i );
        		log.info( "overCardData : "  + stmtCycleMap );
        		jStmtCycleMap = JSONObject.fromObject( stmtCycleMap );
        		stmtCycleList.add( jStmtCycleMap );
        	}
        	model.addAttribute("stmtCycleCd", stmtCycleList);

        	log.info("기본정보조회-16- GID 조회");
        	listMap = baseInfoRegistrationService.selectGidList();
        	model.addAttribute("GID_LIST", CommonDDLB.GidListOption(DDLBType.CHECK, listMap));

        	log.info("기본정보조회-17- VID 조회");
        	listMap = baseInfoRegistrationService.selectVidList();
        	model.addAttribute("VID_LIST", CommonDDLB.VidListOption(DDLBType.CHECK, listMap));
//        	log.info( "기본정보조회-10- 관리자 권한 조회" );
//        	List<Map<String,Object>> list= new ArrayList<Map<String,Object>>();
//        	list = baseInfoMgmtService.selectEmpAuthSearch(dataMap);
        }
        catch(Exception e)
        {
        	log.error( "기본정보조회-Exception :" , e );
        }

        log.info( "기본정보조회- End -" );
        return "/baseInfoMgmt/baseInfoMgmt/baseInfoRegistration";
    }
    //카테고리 소분류 조회
    @RequestMapping(value="/selectCateList.do", method=RequestMethod.POST)
    public ModelAndView selectCategory(@RequestBody String strJsonParameter) throws Exception {
    	ModelAndView        objMv  = new ModelAndView();
    	Map< String, Object > objMap = new HashMap<String, Object>();
    	List<Map<String,String>> objList = new ArrayList<Map<String, String>>();
        int    intResultCode    = 0;
        String strResultMessage = "";
        try
        {
            if (!CommonUtils.isNullorEmpty(strJsonParameter))
            {
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                CommonUtils.initSearchRange(objMap);
                String bigCate = (String)objMap.get( "BS_KIND_CD" );
                objList = baseInfoRegistrationService.selectCateList(bigCate);
                objMv.addObject("SMALL_CATEGORY_LIST", CommonDDLB.sListOption(objList));
            }
            else
            {
                intResultCode    = 9999;
                strResultMessage = "Fail";
            }
        }
        catch(Exception e)
        {
            intResultCode    = 9999;
            strResultMessage = "Exception Fail";
            log.error("selectCateList.do exception : " , e);
        }
        finally
        {
        	 if (intResultCode == 0)
             {
                 objMv = CommonUtils.resultSuccess(objMv);
             }
             else
             {
                 objMv = CommonUtils.resultFail(objMv, strResultMessage);
             }
        }

    	objMv.setViewName("jsonView");

        return objMv;
    }
    //사업자 정보 조회
    @RequestMapping(value="/selectCoNo.do", method=RequestMethod.POST)
    public ModelAndView selectCoNo(@RequestBody String strJsonParameter) throws Exception {
        ModelAndView        objMv  = new ModelAndView();
        Map<String, Object> objMap = new HashMap<String, Object>();
        List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        int    intResultCode    = 0;
        String strResultMessage = "";

        try
        {
            if (!CommonUtils.isNullorEmpty(strJsonParameter))
            {
            	log.info( "사업자정보조회 파라미터  null 체크" );
                objMap = CommonUtils.jsonToMap(strJsonParameter);
                log.info( "사업자정보조회 파라미터  : " + objMap );
                CommonUtils.initSearchRange(objMap);
                objList = baseInfoRegistrationService.selectCoNo(objMap);
                objMv.addObject( "data", objList);
            }
            else
            {
                intResultCode    = 9999;
                strResultMessage = "Exception Fail";
            }
        }
        catch(Exception e)
        {
            intResultCode    = 9999;
	   		strResultMessage = "Exception Fail";
            log.error("selectCoNo-Exception : " , e);
        }
        finally
        {
            if (intResultCode == 0)
            {
                objMv = CommonUtils.resultSuccess(objMv);
            }
            else
            {
                objMv = CommonUtils.resultFail(objMv, strResultMessage);
            }
        }

        objMv.setViewName("jsonView");

        return objMv;
    }
    //기본정보 전체 insert
    @RequestMapping(value = "/insertBaseInfo.do" , method=RequestMethod.POST)
    public ModelAndView insertBaseInfo(@RequestBody String strJsonParameter) throws Exception
    {
    	ModelAndView objMv  = new ModelAndView();
    	Map< String, Object > objMap = new HashMap<String, Object>();
    	Map< String, Object > paramMap = new HashMap<String, Object>();
    	List< Map< String, Object > > objList = new ArrayList<Map< String, Object >>();
    	log.info( "기본정보조회-insert- Start -" );
        int    intResultCode    = 0;
        String strResultMessage = "";
    	try
    	{
            if (!CommonUtils.isNullorEmpty(strJsonParameter))
            {
            	log.info( "기본정보조회-insert-1-파라미터 null 체크 " );
            	objMap = CommonUtils.jsonToMap(strJsonParameter);
            	//등록 전 사업자 번호 체크
            	log.info( "기본정보조회-insert-1-파라미터 : " + objMap );
            	objList = baseInfoRegistrationService.selectCoNo(objMap);
            	if(objList.size() > 0 )
            	{
	            	String kindCd = (String)(objMap.get( "BS_KIND_CD" )) +":"+ (String)(objMap.get( "SmallCategory" ));
	            	objMap.put( "bsKindCd", kindCd );
	            	log.info( "기본정보조회-insert-1-파라미터 : " + objMap );
	            	CommonUtils.initSearchRange(objMap);

	            	paramMap = baseInfoRegistrationService.parameterSetting( objMap );
	            	objMap.put( "paramMap", paramMap );
	            	baseInfoRegistrationService.insertBaseInfo(objMap);
	            	log.info( "기본정보조회-전체정보 update-1-기타정보 : " +objMap );
	            	baseInfoRegistrationService.updateEtcInfo(objMap);

	            	log.info( "기본정보조회-전체정보 update-1-정산정보 : " +objMap );
	            	baseInfoRegistrationService.updateSettleInfo(objMap);

	            	log.info( "기본정보조회-전체정보 update-1-결제수단정보 : " +objMap );
		           	baseInfoRegistrationService.updatePayType(objMap);
            	}
            	else
            	{
            		//사업자 번호 없음
            		log.info( "기본정보조회-insert 1- 사업자 번호 없음");
            		objMv.addObject( "resultCode" , "9999" );
            		objMv.addObject( "resultMessage" , "존재하는 사업자 번호를 입력하세요." );
            	}
            }
            else
            {
            	log.info( "기본정보조회-insert-1-파라미터 null " );
            	intResultCode = 9999;
    	   		strResultMessage = "Fail";
            }

    	}
    	catch(Exception e)
    	{
    		log.error( "기본정보조회-Exception : ", e );
    		intResultCode = 9999;
	   		strResultMessage = "Exception Fail";
    	}
        finally
        {
        	  if (intResultCode == 0)
        	  {
                  objMv = CommonUtils.resultSuccess(objMv);
              }
        	  else
        	  {
                  objMv = CommonUtils.resultFail(objMv, strResultMessage);
              }
		}
    	objMv.setViewName("jsonView");

    	log.info( "기본정보조회-insert- End -" );
        return objMv;
    }
    //기본정보 전체 UPDATE
    @RequestMapping(value = "/baseAllUpdate.do")
    public ModelAndView baseAllUpdate(@RequestBody String strJsonParameter) throws Exception
    {
    	ModelAndView objMv  = new ModelAndView();
    	Map< String, Object > objMap = new HashMap<String, Object>();
    	Map< String, Object > paramMap = new HashMap<String, Object>();
    	List< Map< String, Object > > objList = new ArrayList<Map< String, Object >>();
    	int intResultCode = 0 ;
    	String strResultMessage = "";
    	log.info( "기본정보조회-전체정보 update- Start -" );
    	try
    	{
            if (!CommonUtils.isNullorEmpty(strJsonParameter))
            {
            	log.info( "기본정보조회-전체정보 update-1-파라미터 null 체크 " );
            	objMap = CommonUtils.jsonToMap(strJsonParameter);
            	//등록 전 사업자 번호 체크
            	log.info( "기본정보조회-전체정보 update-1-파라미터 : " + objMap );
            	objList = baseInfoRegistrationService.selectCoNo(objMap);
            	if(objList.size() > 0 )
            	{
            		paramMap = baseInfoRegistrationService.parameterSetting( objMap );
            		log.info( "기본정보조회-전체정보 update-1-셋팅 파라미터: " +paramMap );
	            	objMap.put( "paramMap", paramMap );
	            	CommonUtils.initSearchRange(objMap);
	            	log.info( "기본정보조회-전체정보 update-1-파라미터 : " +objMap );

	            	log.info( "기본정보조회-전체정보 update-1-일반정보 : " +objMap );
	            	baseInfoRegistrationService.updateNormalInfo(objMap);

	            	log.info( "기본정보조회-전체정보 update-1-기타정보 : " +objMap );
	            	baseInfoRegistrationService.updateEtcInfo(objMap);

	            	log.info( "기본정보조회-전체정보 update-1-정산정보 : " +objMap );
	            	baseInfoRegistrationService.updateSettleInfo(objMap);

	            	log.info( "기본정보조회-전체정보 update-1-결제수단정보 : " +objMap );
		           	baseInfoRegistrationService.updatePayType(objMap);
            	}
            	else
            	{
            		//사업자 번호 없음
            		log.info( "기본정보조회-전체정보 update-1- 사업자 번호 없음");
            		objMv.addObject( "resultCode" , "9999" );
            		objMv.addObject( "resultMessage" , "존재하는 사업자 번호를 입력하세요." );

            	}
            }
            else
            {
            	log.info( "기본정보조회-전체정보 update-1-파라미터 null " );
            	intResultCode = 9999;
    	   		strResultMessage = "Fail";
            }

    	}
    	catch(Exception e)
    	{
    		log.error( "기본정보조회-Exception : ", e );
    		intResultCode = 9999;
	   		strResultMessage = "Exception Fail";
    	}
    	finally
        {
        	  if (intResultCode == 0)
        	  {
                  objMv = CommonUtils.resultSuccess(objMv);
              }
        	  else
        	  {
                  objMv = CommonUtils.resultFail(objMv, strResultMessage);
              }
		}
    	log.info( "기본정보조회-전체정보 update- End -" );
    	objMv.setViewName("jsonView");
        return objMv;
    }
    //일반정보 UPDATE
   @RequestMapping(value = "/normalReg.do", method=RequestMethod.POST)
    public ModelAndView normalRegist(@RequestBody String strJsonParameter) throws Exception
    {
    	ModelAndView objMv  = new ModelAndView();
    	Map< String, Object > objMap = new HashMap<String, Object>();
    	List< Map< String, Object > > objList = new ArrayList<Map< String, Object >>();
    	int intResultCode = 0 ;
    	int resultCd = 0;
    	String strResultMessage = "";
    	log.info( "기본정보조회-일반정보 update- Start -" );
    	try
    	{
            if (!CommonUtils.isNullorEmpty(strJsonParameter))
            {
            	log.info( "기본정보조회-일반정보 update-1-파라미터 null 체크 " );
            	objMap = CommonUtils.jsonToMap(strJsonParameter);
            	String kindCd = (String)(objMap.get( "BS_KIND_CD" )) +":"+ (String)(objMap.get( "SmallCategory" ));
            	objMap.put( "bsKindCd", kindCd );
            	log.info( "기본정보조회-일반정보 update-1-파라미터 : " +objMap );
            	CommonUtils.initSearchRange(objMap);
            	//등록 전 사업자 번호 체크
            	objList = baseInfoRegistrationService.selectCoNo(objMap);
            	if(objList.size() > 0 )
            	{
            		//사업자 번호 존재
            		log.info( "기본정보조회-일반정보 update-1-  " );
            		baseInfoRegistrationService.updateNormalInfo(objMap);
            	}
            	else
            	{
            		//사업자 번호 없음
            		log.info( "기본정보조회-일반정보 update-1- 사업자 번호 없음");
            		resultCd = 9999;
            		objMv.addObject( "resultCode" , resultCd);
            		objMv.addObject( "resultMessage" , "존재하는 사업자 번호를 입력하세요." );
            	}
            }
            else
            {
            	log.info( "기본정보조회-일반정보 update-1-파라미터 null " );
            	intResultCode = 9999;
    	   		strResultMessage = "Fail";
            }

    	}
    	catch(Exception e)
    	{
    		log.error( "기본정보조회-Exception : ", e );
    		intResultCode = 9999;
	   		strResultMessage = "Exception Fail";
    	}
    	finally
        {
        	  if (intResultCode == 0)
        	  {
                  objMv = CommonUtils.resultSuccess(objMv);
              }
        	  else
        	  {
                  objMv = CommonUtils.resultFail(objMv, strResultMessage);
              }
		}
    	log.info( "기본정보조회-일반정보 update- End -" );
    	objMv.setViewName("jsonView");
        return objMv;
    }
   @RequestMapping(value = "/etcReg.do", method=RequestMethod.POST)
   public ModelAndView etcRegist(@RequestBody String strJsonParameter) throws Exception
   {
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	int intResultCode = 0 ;
	   	String strResultMessage = "";
	   	log.info( "기본정보조회-기타정보 update- Start -" );
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
		           	log.info( "기본정보조회-기타정보 update-1-파라미터 null 체크 " );
		           	objMap = CommonUtils.jsonToMap(strJsonParameter);
		           	log.info( "기본정보조회-기타정보 update-1-파라미터 : " + objMap );
		           	CommonUtils.initSearchRange(objMap);
		           	baseInfoRegistrationService.updateEtcInfo(objMap);
	           }
	           else
	           {
	        	   log.info( "기본정보조회-기타정보 update-1-파라미터 null " );
	        	   intResultCode = 9999;
	   	   		   strResultMessage = "Fail";
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "기본정보조회-Exception : ", e );
	   		intResultCode = 9999;
	   		strResultMessage = "Exception Fail";
	   	}
	   	finally
        {
        	  if (intResultCode == 0)
        	  {
                  objMv = CommonUtils.resultSuccess(objMv);
              }
        	  else
        	  {
                  objMv = CommonUtils.resultFail(objMv, strResultMessage);
              }
		}
	   	log.info( "기본정보조회-기타정보 update- End -" );
	   	objMv.setViewName("jsonView");
	    return objMv;
   }
   @RequestMapping(value = "/settleReg.do", method=RequestMethod.POST)
   public ModelAndView settleRegist(@RequestBody String strJsonParameter) throws Exception
   {
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	Map< String, Object > paramMap = new HashMap<String, Object>();
	   	int intResultCode = 0 ;
	   	String strResultMessage = "";
	   	log.info( "기본정보조회-정산정보 update- Start -" );
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
		           	log.info( "기본정보조회-정산정보 update-1-파라미터 null 체크 " );
		           	objMap = CommonUtils.jsonToMap(strJsonParameter);
		           	log.info( "기본정보조회-정산정보 update-1-파라미터 : " + objMap );
		           	CommonUtils.initSearchRange(objMap);
		           	baseInfoRegistrationService.updateSettleInfo(objMap);
	           }
	           else
	           {
	        	   log.info( "기본정보조회-정산정보 update-1-파라미터 null " );
	        	   intResultCode = 9999;
	        	   strResultMessage = "fail";
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "기본정보조회-Exception : ", e );
	   		intResultCode = 9999;
	   		strResultMessage = "Exception Fail";
	   	}
	   	finally
        {
        	  if (intResultCode == 0)
        	  {
                  objMv = CommonUtils.resultSuccess(objMv);
              }
        	  else
        	  {
                  objMv = CommonUtils.resultFail(objMv, strResultMessage);
              }
		}
	   	log.info( "기본정보조회-정산정보 update- End -" );
	   	objMv.setViewName("jsonView");
	    return objMv;
   }
   @RequestMapping(value = "/payTypeReg.do", method=RequestMethod.POST)
   public ModelAndView payTypeRegist(@RequestBody String strJsonParameter) throws Exception
   {
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	Map< String, Object > paramMap = new HashMap<String, Object>();
	   	int intResultCode = 0 ;
	   	String strResultMessage = "";
	   	log.info( "기본정보조회-결제수단 update- Start -" );
	   	try
	   	{
	   			if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
		           	log.info( "기본정보조회-결제수단 update-1-파라미터 null 체크 " );
		           	objMap = CommonUtils.jsonToMap(strJsonParameter);
		           	log.info( "기본정보조회-결제수단 update-1-파라미터 : " + objMap );
		           	CommonUtils.initSearchRange(objMap);
		        	paramMap = baseInfoRegistrationService.parameterSetting( objMap );
            		objMap.put( "paramMap", paramMap );
		           	baseInfoRegistrationService.updatePayType(objMap);
		           	//카드 가맹점 테이블 UPDATE (TB_CARD_MBS)
		           	//baseInfoRegistrationService.updateCardMbs(paramMap);
		           	for(int i=0; i<objMap.size(); i++)
		           {

		           }
	           }
	           else
	           {
	        	   log.info( "기본정보조회-결제수단 update-1-파라미터 null " );
	        	   intResultCode = 9999;
	        	   strResultMessage = "fail";
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "기본정보조회-Exception : ", e );
	   		intResultCode = 9999;
	   		strResultMessage = "Exception Fail";
	   	}
	   	finally
        {
        	  if (intResultCode == 0)
        	  {
                  objMv = CommonUtils.resultSuccess(objMv);
              }
        	  else
        	  {
                  objMv = CommonUtils.resultFail(objMv, strResultMessage);
              }
		}
	   	log.info( "기본정보조회-결제수단 update- End -" );
	   	objMv.setViewName("jsonView");
	    return objMv;
   }
   @RequestMapping(value = "/selectBaseInfo.do", method=RequestMethod.POST)
   public ModelAndView selectBaseInfo(@RequestBody String strJsonParameter) throws Exception
   {
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	Map< String, Object > dataMap = new HashMap<String, Object>();
	   	List< Map< String, Object > > cardPayInfo = new ArrayList<Map<String, Object>>();
	   	List< Map< String, Object > > vidInfo = new ArrayList<Map<String, Object>>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
	    int    intPageTotalCnt  = 0;
        int    intResultCode    = 0;
        String strResultMessage = "";
	   	log.info( "기본정보조회- SELECT - Start -" );
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
	        	   log.info( "기본정보조회-SELECT-1-파라미터 null 체크 " );
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   log.info("기본정보조회-SELECT-1-파라미터 : "+objMap);
	        	   CommonUtils.initSearchRange(objMap);
		           //기존 SELECT
		           //objList = 	baseInfoRegistrationService.selectBaseInfo(objMap);

		           //TB_CO & TB_MBS SELECT
        	   	   dataMap = 	baseInfoMgmtService.baseInfo(objMap);

	        	   if(objMap.get( "MER_VAL" ).equals("2")) //mid
	        	   {
	        		   if(dataMap.get( "resultCd").equals( "0000" ) ){
	        			   log.info( "기본정보조회-SELECT-1-mid setting midInfo" );
	        			   objMv.addObject( "midInfo", dataMap.get( "midInfo" ) );
	        			   objMv.addObject( "cateList", dataMap.get( "cateList" ) );
	        			   log.info( "기본정보조회-SELECT-1-mid setting settleFeeInfo" );
	        			   objMv.addObject( "settleFeeInfo", dataMap.get( "settleFeeInfo" ) );

	        			   log.info( "기본정보조회-SELECT-1-mid setting settleServiceInfo" );
	        			   objMv.addObject( "settleServiceInfo", dataMap.get( "settleServiceInfo" ) );

	        			   log.info( "기본정보조회-SELECT-1-mid setting settleFee" );
	        			   objMv.addObject( "settleFee", dataMap.get( "settleFee" ) );

	        			   log.info( "기본정보조회-SELECT-1-mid setting compFee" );
	        			   objMv.addObject( "compFee", dataMap.get( "compFee" ) );

	        			   log.info( "기본정보조회-SELECT-1-mid setting cardInfo" );
	        			   objMv.addObject( "cardInfo", dataMap.get( "cardInfo" ) );

	        			   log.info( "기본정보조회-SELECT-1-mid setting cardBillInfo" );
	        			   objMv.addObject( "cardBillInfo", dataMap.get( "cardBillInfo" ) );

	        			   log.info( "기본정보조회-SELECT-1-mid setting settleCycle Info" );
	        			   objMv.addObject( "settleCycle", dataMap.get( "settleCycle" ) );

	        			   log.info( "기본정보조회-SELECT-1-mid setting payType Info" );
	        			   objMv.addObject( "payType", dataMap.get( "payType" ) );

	        			   log.info( "기본정보조회-SELECT-1-mid setting useCard Info" );
	        			   objMv.addObject( "useCard", dataMap.get( "useCard" ) );

	        			   log.info( "기본정보조회-SELECT-1-mid setting overCard Info" );
	        			   objMv.addObject( "overCardCd", dataMap.get( "overCardCd" ) );

	        			   log.info( "기본정보조회-SELECT-1-mid setting majorCard Info" );
	        			   objMv.addObject( "majorCardCd", dataMap.get( "majorCardCd" ) );

	        			   log.info( "기본정보조회-SELECT-1-mid setting minorCard Info" );
	        			   objMv.addObject( "minorCardCd", dataMap.get( "minorCardCd" ) );

	        			   log.info( "기본정보조회-SELECT-1-mid setting stmtCycleCd Info" );
	        			   objMv.addObject( "stmtCycleCd", dataMap.get( "stmtCycleCd" ) );
	        		   }
	        		   else
	        		   {
	        			   log.info( "기본정보조회-SELECT-1-mid resultCd : "  + dataMap.get( "resultCd" ) );
	        			   intResultCode = 9999;
	        		   }
	        	   }
	        	   else if(objMap.get( "MER_VAL" ).equals("3"))//GID
	        	   {
	        		  if(dataMap.get( "resultCd").equals( "0000" ) )
	        		  {
	        		  log.info( "기본정보조회-SELECT-1-gid" );
	        		  log.info( "기본정보조회-SELECT-1-gid setting gidInfo" );
	        		  objMv.addObject( "gidInfo", dataMap.get( "gidInfo" ) );
	        		  log.info( "기본정보조회-SELECT-1-gid,mid info" );
	        		  objMv.addObject( "gidMidInfo", dataMap.get( "gidMidInfo" ));
	        		  log.info( "기본정보조회-SELECT-1-gid banklist info" );
	        		  objMv.addObject( "gidBankList", dataMap.get( "gidBankList" ));
	        		  }
	        		   else
	        		   {
	        			   log.info( "기본정보조회-SELECT-1-gid resultCd : "  + dataMap.get( "resultCd" ) );
	        			   intResultCode = 9999;
	        		   }
	        	   }
	        	   else if(objMap.get( "MER_VAL" ).equals("4"))//VID
	        	   {
	        		   if(dataMap.get( "resultCd" ).equals( "0000" )){
	        			   log.info( "기본정보조회-SELECT-1-vid" );
	        			   log.info( "기본정보조회-SELECT-1-vid vid info " );
	        			   objMv.addObject( "vidInfo", dataMap.get( "vidInfo" ) );
	        			   log.info( "기본정보조회-SELECT-1-vid vid fee info" );
	        			   objMv.addObject( "vidFeeInfo", dataMap.get( "vidFeeInfo" ));
	        			   log.info( "기본정보조회-SELECT-1-vid, mid info " );
	        			   objMv.addObject( "vidMidInfo", dataMap.get( "vidMidInfo" ));
	        			   log.info( "기본정보조회-SELECT-1-vid bankList info " );
	        			   objMv.addObject( "vidBankList", dataMap.get( "vidBankList" ));
	        		   }
	        		   else
	        		   {
	        			   log.info( "기본정보조회-SELECT-1-vid resultCd : "  + dataMap.get( "resultCd" ) );
	        			   intResultCode = 9999;
	        		   }
	        	   }
	           }
	           else
	           {
	        	   log.info( "기본정보조회-SELECT-1-파라미터 null " );
	           }
	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "기본정보조회-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}

	   	objMv.setViewName("jsonView");
	   	log.info( "기본정보조회-SELECT - End -" );
	    return objMv;
   }
   //mid 중복체크
   @RequestMapping(value = "/dupIdChk.do", method=RequestMethod.POST)
   public ModelAndView dupIdChk(@RequestBody String strJsonParameter) throws Exception
   {
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
        int intResultCode    = 0;
        int intDupCnt = 0;
        String strResultMessage = "";
	   	log.info( "기본정보조회- MID중복체크 - Start -" );
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
	        	   log.info( "기본정보조회-중복체크-1-파라미터 null 체크 " );
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   log.info("기본정보조회-중복체크-1-파라미터 : "+objMap);
	        	   CommonUtils.initSearchRange(objMap);
		           intDupCnt = 	baseInfoRegistrationService.dupIdChk(objMap);
		           objMv.addObject( "intDupCnt", intDupCnt );
		           if(intDupCnt > 0)
		           {
		        	   intResultCode = 9999;
		        	   strResultMessage = "중복된 ID가 존재합니다.";
		           }
	           }
	           else
	           {
	        	   log.info( "기본정보조회-중복체크-1-파라미터 null " );
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "기본정보조회-Exception : ", e );
	   	}
	   	finally
	   	{
	   		if (intResultCode == 0)
            {
                objMv = CommonUtils.resultSuccess(objMv);
            }
            else
            {
                objMv = CommonUtils.resultFail(objMv, strResultMessage);
            }
	   	}

	   	objMv.setViewName("jsonView");
	   	log.info( "기본정보조회-중복체크 - End -" );
	    return objMv;
   }
   //gid 조회
   @RequestMapping(value = "/selectGidInfo.do", method=RequestMethod.POST)
   public ModelAndView selectGidInfo(@RequestBody String strJsonParameter) throws Exception
   {
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        int intResultCode    = 0;
        int intPageTotalCnt = 0;
        String strResultMessage = "";
	   	log.info( "기본정보조회- GID정보조회 - Start -" );
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   log.info( "기본정보조회- GID정보조회 - GID : " + objMap );
	        	   CommonUtils.initSearchRange(objMap);
	               objList = 	baseInfoRegistrationService.selectGidInfo((String)objMap.get( "MER_ID" ));
		           if(objList.size() == 0)
		           {
		        	   intResultCode = 9999;

		           }
	           }
	           else
	           {
	        	   log.info( "기본정보조회-GID정보조회-1-파라미터 null " );
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "기본정보조회-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}

	   	objMv.setViewName("jsonView");
	   	log.info( "기본정보조회-GID정보조회 - End -" );
	    return objMv;
   }
   //vid 조회
   @RequestMapping(value = "/selectVidInfo.do", method=RequestMethod.POST)
   public ModelAndView selectVidInfo(@RequestBody String strJsonParameter) throws Exception
   {
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
	   	List<Map<String,Object>> objList1 = new ArrayList<Map<String, Object>>();
        int intResultCode    = 0;
        int intPageTotalCnt = 0;
        String strResultMessage = "";
	   	log.info( "기본정보조회- VID정보조회 - Start -" );
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   log.info( "기본정보조회- VID정보조회 - GID : " + objMap );
	        	   CommonUtils.initSearchRange(objMap);
	               objList = 	baseInfoRegistrationService.selectVidInfo((String)objMap.get( "MER_ID" ));
	               objList1 = 	baseInfoRegistrationService.selectVidFeeInfo(objMap);
		           if(objList.size() == 0 || objList.size() == 0)
		           {
		        	   intResultCode = 9999;
		        	   log.info( "기본정보조회-VID정보조회-1-select fail" );
		           }
		           else
		           {
		        	   //vid조회중 fee조회해와서 화면에 뿌리기
		        	   objMv.addObject( "dataFee", objList1 );
		           }
	           }
	           else
	           {
	        	   log.info( "기본정보조회-VID정보조회-1-파라미터 null " );
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "기본정보조회-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}

	   	objMv.setViewName("jsonView");
	   	log.info( "기본정보조회-VID정보조회 - End -" );
	    return objMv;
   }
   //카드 결제 수단 TB_CARD_MBS

   //승인 대기 조회 테이블  결제수단 TB_CODE-> CODE_CL='0052' DESC3='pm_cd
   @RequestMapping(value = "/selectApproList.do" )
   public ModelAndView selectApproList(@RequestBody String strJsonParameter) throws Exception
   {
	    ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	List<Map< String, Object >> objList = new ArrayList<Map<String, Object>>();
	   	Map< String, Object > dataMap = new HashMap<String, Object>();
	   	int intResultCode = 0;
	   	int intPageTotalCnt = 0;
	   	String strResultMessage = "";
	   	log.info( "기본정보조회-승인대기조회- Start -" );
	   	try
	   	{
	   			if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
		           	log.info( "기본정보조회-승인대기조회-1-파라미터 null 체크 " );
		           	objMap = CommonUtils.jsonToMap(strJsonParameter);
		           	log.info( "기본정보조회-승인대기조회-1-파라미터 : " + objMap );
		           	CommonUtils.initSearchRange(objMap);
		           	objList = baseInfoRegistrationService.selectApproList(objMap);
		           	intPageTotalCnt = (Integer)baseInfoRegistrationService.selectApproListTotal(objMap);
	           }
	           else
	           {
	        	   log.info( "기본정보조회-승인대기조회-1-파라미터 null " );
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "기본정보조회-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}
	   	objMv.setViewName("jsonView");
	   	log.info( "기본정보조회-승인대기조회- End -" );
	    return objMv;
   }
   //기본정보 GID INSERT
   @RequestMapping(value = "/insertGidRegist.do" , method=RequestMethod.POST)
   public ModelAndView insertGidRegist(@RequestBody String strJsonParameter) throws Exception
   {
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	log.info( "기본정보조회-GidRegist- Start -" );
        int    intResultCode    = 0;
        String strResultMessage = "";
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
		           	log.info( "기본정보조회-GidRegist-1-파라미터 null 체크 " );
		           	objMap = CommonUtils.jsonToMap(strJsonParameter);
		           	log.info( "기본정보조회-GidRegist-1-파라미터 : " + objMap );
		           	CommonUtils.initSearchRange(objMap);

		           	baseInfoRegistrationService.insertGidRegist(objMap);
	           }
	           else
	           {
	           		log.info( "기본정보조회-GidRegist-1-파라미터 null " );
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "기본정보조회-Exception : ", e );
	   	}
	       finally
	       {
	       	  if (intResultCode == 0)
	       	  {
	                 objMv = CommonUtils.resultSuccess(objMv);
	             }
	       	  else
	       	  {
	                 objMv = CommonUtils.resultFail(objMv, strResultMessage);
	             }
			}

	   	objMv.setViewName("jsonView");
	   log.info( "기본정보조회-GidRegist- End -" );
       return objMv;
   }
 //기본정보 VID INSERT
   @RequestMapping(value = "/insertVidRegist.do" , method=RequestMethod.POST)
   public ModelAndView insertVidRegist(@RequestBody String strJsonParameter) throws Exception
   {
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	log.info( "기본정보조회-VidRegist- Start -" );
        int    intResultCode    = 0;
        String strResultMessage = "";
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
		           	log.info( "기본정보조회-VidRegist-1-파라미터 null 체크 " );
		           	objMap = CommonUtils.jsonToMap(strJsonParameter);
		           	log.info( "기본정보조회-VidRegist-1-파라미터 : " + objMap );
		           	CommonUtils.initSearchRange(objMap);

		            baseInfoRegistrationService.insertVidRegist(objMap);


	           }
	           else
	           {
	           		log.info( "기본정보조회-VidRegist-1-파라미터 null " );
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "기본정보조회-Exception : ", e );
	   	}
	       finally
	       {
	       	  if (intResultCode == 0)
	       	  {
	                 objMv = CommonUtils.resultSuccess(objMv);
	             }
	       	  else
	       	  {
	                 objMv = CommonUtils.resultFail(objMv, strResultMessage);
	             }
			}

	   	objMv.setViewName("jsonView");
	   log.info( "기본정보조회-VidRegist- End -" );
       return objMv;
   }
   //기본정보(GID) UPDATE
   @RequestMapping(value = "/baseGidUpdate.do", method=RequestMethod.POST)
    public ModelAndView baseGidUpdate(@RequestBody String strJsonParameter) throws Exception
    {
    	ModelAndView objMv  = new ModelAndView();
    	Map< String, Object > objMap = new HashMap<String, Object>();
    	log.info( "기본정보조회 -GID정보 update- Start -" );
    	try
    	{
            if (!CommonUtils.isNullorEmpty(strJsonParameter))
            {
            	log.info( "기본정보조회-GID정보 update-1-파라미터 null 체크 " );
            	objMap = CommonUtils.jsonToMap(strJsonParameter);
            	log.info( "기본정보조회-GID정보 update-1-파라미터 : " +objMap );
            	CommonUtils.initSearchRange(objMap);
            	baseInfoRegistrationService.updateGidInfo(objMap);
            }
            else
            {
            	log.info( "기본정보조회-GID정보 update-1-파라미터 null " );
            }

    	}
    	catch(Exception e)
    	{
    		log.error( "기본정보조회-Exception : ", e );
    	}

    	log.info( "기본정보조회-GID정보 update- End -" );
        return objMv;
    }
   //기본정보(GID) UPDATE
   @RequestMapping(value = "/baseVidUpdate.do", method=RequestMethod.POST)
    public ModelAndView baseVidUpdate(@RequestBody String strJsonParameter) throws Exception
    {
    	ModelAndView objMv  = new ModelAndView();
    	Map< String, Object > objMap = new HashMap<String, Object>();
    	log.info( "기본정보조회 -VID정보 update- Start -" );
    	try
    	{
            if (!CommonUtils.isNullorEmpty(strJsonParameter))
            {
            	log.info( "기본정보조회-VID정보 update-1-파라미터 null 체크 " );
            	objMap = CommonUtils.jsonToMap(strJsonParameter);
            	log.info( "기본정보조회-VID정보 update-1-파라미터 : " +objMap );
            	CommonUtils.initSearchRange(objMap);
            	baseInfoRegistrationService.updateVidInfo(objMap);
            }
            else
            {
            	log.info( "기본정보조회-VID정보 update-1-파라미터 null " );
            }

    	}
    	catch(Exception e)
    	{
    		log.error( "기본정보조회-Exception : ", e );
    	}

    	log.info( "기본정보조회-VID정보 update- End -" );
        return objMv;
    }

   @RequestMapping(value = "/merchantReg.do" , method=RequestMethod.POST)
   public ModelAndView merchantReg(@RequestBody String strJsonParameter) throws Exception
   {
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	Map< String, Object > dataMap = new HashMap<String, Object>();
	   	log.info( "기본정보조회-승인반려 update- Start -" );
        int    intResultCode    = 0;
        String strResultMessage = "";
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
		           	log.info( "기본정보조회-승인반려 update-1-파라미터 null 체크 " );
		           	objMap = CommonUtils.jsonToMap(strJsonParameter);
		           	log.info( "기본정보조회-승인반려 update-1-파라미터 : " + objMap );
		           	CommonUtils.initSearchRange(objMap);

		           	dataMap = baseInfoRegistrationService.merchantReg(objMap);
		           	if(dataMap == null)
		           	{
		           		log.info( "기본정보조회-승인반려 update data x" );
		           		intResultCode = 9999;
		           	}
	           }
	           else
	           {
	           		log.info( "기본정보조회-승인반려 update-1-파라미터 null " );
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "기본정보조회-Exception : ", e );
	   	}
	       finally
	       {
	       	  if (intResultCode == 0)
	       	  {
	                 objMv = CommonUtils.resultSuccess(objMv);
	             }
	       	  else
	       	  {
	                 objMv = CommonUtils.resultFail(objMv, strResultMessage);
	             }
			}

	   	objMv.setViewName("jsonView");
	   log.info( "기본정보조회-승인반려 update- End -" );
       return objMv;
   }
   //해외카드 fee list 조회
   @RequestMapping(value = "/selectFeeRegOverCardLst.do", method=RequestMethod.POST)
   public ModelAndView selectFeeRegOverCardLst(@RequestBody String strJsonParameter) throws Exception
   {
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	Map< String, Object > dataMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
	   	List<Map<String,Object>> objList1 = new ArrayList<Map<String, Object>>();
        int intResultCode    = 0;
        int intPageTotalCnt = 0;
        String strResultMessage = "";
	   	log.info( "기본정보조회- MID Fee OverCardList - Start -" );
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   log.info( "기본정보조회- MID Fee OverCardList  - : " + objMap );
	        	   CommonUtils.initSearchRange(objMap);
	               dataMap = 	baseInfoRegistrationService.selectFeeRegOverCardLst(objMap);
		           if(dataMap == null)
		           {
		        	   intResultCode = 9999;
		        	   log.info( "기본정보조회-MID Fee OverCardList -1-select fail" );
		           }
		           else
		           {
		        	   log.info( "기본정보조회-MID Fee OverCardList -1-select success" );
		        	   objMv.addObject( "cardList", dataMap.get( "cardList" ));
		        	   log.info( "기본정보조회-MID Fee OverCardList -1-cardList setting" );
		        	   objMv.addObject( "feeList", dataMap.get( "feeList" ));
		        	   log.info( "기본정보조회-MID Fee OverCardList -1-feeList setting" );
		        	   objMv.addObject( "feeAddList", dataMap.get( "feeAddList" ));
		        	   log.info( "기본정보조회-MID Fee OverCardList -1-feeAddList setting" );
		           }
	           }
	           else
	           {
	        	   log.info( "기본정보조회-MID Fee OverCardList -1-파라미터 null " );
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "기본정보조회-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}

	   	objMv.setViewName("jsonView");
	   	log.info( "기본정보조회-MID Fee OverCardList  - End -" );
	    return objMv;
   }
   @RequestMapping(value = "/selectFeeRegCardLst.do", method=RequestMethod.POST)
   public ModelAndView selectFeeRegCardLst(@RequestBody String strJsonParameter) throws Exception
   {
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	Map< String, Object > dataMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
	   	List<Map<String,Object>> objList1 = new ArrayList<Map<String, Object>>();
        int intResultCode    = 0;
        int intPageTotalCnt = 0;
        String strResultMessage = "";
	   	log.info( "기본정보조회- MID Fee CardList - Start -" );
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   log.info( "기본정보조회- MID Fee CardList  - : " + objMap );
	        	   CommonUtils.initSearchRange(objMap);
	               dataMap = 	baseInfoRegistrationService.selectFeeRegCardLst(objMap);
		           if(dataMap == null)
		           {
		        	   intResultCode = 9999;
		        	   log.info( "기본정보조회-MID Fee CardList -1-select fail" );
		           }
		           else
		           {
		        	   log.info( "기본정보조회-MID Fee CardList -1-select success" );
		        	   objMv.addObject( "cardList", dataMap.get( "cardList" ));
		        	   log.info( "기본정보조회-MID Fee CardList -1-cardList setting" );
		        	   objMv.addObject( "feeList", dataMap.get( "feeList" ));
		        	   log.info( "기본정보조회-MID Fee CardList -1-feeList setting" );
		        	   objMv.addObject( "feeAddList", dataMap.get( "feeAddList" ));
		        	   log.info( "기본정보조회-MID Fee CardList -1-feeAddList setting" );
		           }
	           }
	           else
	           {
	        	   log.info( "기본정보조회-MID Fee CardList -1-파라미터 null " );
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "기본정보조회-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}

	   	objMv.setViewName("jsonView");
	   	log.info( "기본정보조회-MID Fee CardList  - End -" );
	    return objMv;
   }
   @RequestMapping(value = "/selectMbsNo.do", method=RequestMethod.POST)
   public ModelAndView selectMbsNo(@RequestBody String strJsonParameter) throws Exception
   {
	   	ModelAndView objMv  = new ModelAndView();
	   	Map< String, Object > objMap = new HashMap<String, Object>();
	   	Map< String, Object > dataMap = new HashMap<String, Object>();
	   	List<Map<String,Object>> objList = new ArrayList<Map<String, Object>>();
        int intResultCode    = 0;
        int intPageTotalCnt = 0;
        String strResultMessage = "";
	   	log.info( "기본정보조회- MbsNo SELECT- Start -" );
	   	try
	   	{
	           if (!CommonUtils.isNullorEmpty(strJsonParameter))
	           {
	        	   objMap = CommonUtils.jsonToMap(strJsonParameter);
	        	   log.info( "기본정보조회- MbsNo SELECT  - : " + objMap );
	        	   CommonUtils.initSearchRange(objMap);
	               dataMap = 	baseInfoRegistrationService.selectMbsNo(objMap);
		           if(dataMap == null)
		           {
		        	   intResultCode = 9999;
		        	   log.info( "기본정보조회-MbsNo SELECT -1-select fail" );
		           }
		           else
		           {
		        	   log.info( "기본정보조회-MbsNo SELECT -1-select success" );
		        	   objMv.addObject( "cardList", dataMap.get( "cardList" ));
		        	   log.info( "기본정보조회-MbsNo SELECT -1-cardList setting" );
		        	   objMv.addObject( "feeList", dataMap.get( "feeList" ));
		        	   log.info( "기본정보조회-MbsNo SELECT -1-feeList setting" );
		        	   objMv.addObject( "feeAddList", dataMap.get( "feeAddList" ));
		        	   log.info( "기본정보조회-MbsNo SELECT -1-feeAddList setting" );
		           }
	           }
	           else
	           {
	        	   log.info( "기본정보조회-MbsNo SELECT -1-파라미터 null " );
	           }

	   	}
	   	catch(Exception e)
	   	{
	   		log.error( "기본정보조회-Exception : ", e );
	   	}
	   	finally
	   	{
	   		objMv = CommonUtils.resultList(objMv, objMap, objList, intPageTotalCnt, intResultCode, strResultMessage);
	   	}

	   	objMv.setViewName("jsonView");
	   	log.info( "기본정보조회-MbsNo SELECT  - End -" );
	    return objMv;
   }
}
