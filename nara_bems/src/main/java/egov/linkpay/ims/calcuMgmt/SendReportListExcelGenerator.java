package egov.linkpay.ims.calcuMgmt;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDataFormat;
import org.apache.poi.hssf.usermodel.HSSFFont;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.util.Region;
import org.springframework.web.servlet.view.document.AbstractExcelView;

import egov.linkpay.ims.common.common.CommonMessageDic;
import egov.linkpay.ims.common.common.CommonUtils;

/**------------------------------------------------------------
 * Package Name   : net.ionpay.dashboard.tradingviews
 * File Name      : VacctInputNotiExcelGenerator.java
 * Description    : 
 * Author         : hgkim, 2016. 07. 1.
 * Modify History : Just Created.
 ------------------------------------------------------------*/
public class SendReportListExcelGenerator extends AbstractExcelView {
    Logger log = Logger.getLogger(this.getClass());
    
    @SuppressWarnings({ "unchecked", "deprecation" })
    @Override
    protected void buildExcelDocument(Map<String, Object> objExcelMap, HSSFWorkbook workbook, HttpServletRequest req, HttpServletResponse res) throws Exception {
        String strExcelName = "";

        Map<String,Object>       objReqMap    = null;
        List<Map<String,Object>> objExcelData = null;
        
        HSSFCellStyle cellLeftStyle      = null;
        HSSFCellStyle cellCenterStyle    = null;
        HSSFCellStyle cellNumCenterStyle = null;
        HSSFCellStyle cellRightStyle     = null;
        HSSFCellStyle cellTitleStyle     = null;
        HSSFCellStyle cellSubTitleStyle  = null;
        
        HSSFFont      fontTitle          = null;
        HSSFFont      fontSubTitle       = null;
        HSSFSheet     sheet              = null;
        HSSFRow       menuRow            = null;
        HSSFCell      cell               = null;
        
        try {
            strExcelName = (String) objExcelMap.get("excelName");
            objExcelData = (List<Map<String,Object>>) objExcelMap.get("excelData"); //디비에서 가져온 값
            objReqMap    = (Map<String,Object>) objExcelMap.get("reqData"); //FORM에서 가져온 값
            
            res.setContentType("application/msexcel");
            res.setHeader("Content-Disposition", "attachment; filename=" + strExcelName + ".xls");
            
            cellLeftStyle      = workbook.createCellStyle();
            cellCenterStyle    = workbook.createCellStyle();
            cellNumCenterStyle = workbook.createCellStyle();
            cellRightStyle     = workbook.createCellStyle();
            cellTitleStyle     = workbook.createCellStyle();
            cellSubTitleStyle  = workbook.createCellStyle();
            fontTitle          = workbook.createFont();
            fontSubTitle       = workbook.createFont();
            
            cellRightStyle.setDataFormat(HSSFDataFormat.getBuiltinFormat("#,##0"));
            cellNumCenterStyle.setDataFormat(HSSFDataFormat.getBuiltinFormat("#,##0"));
            
            CommonUtils.CoverCellStyle(workbook, cellLeftStyle,      HSSFCellStyle.ALIGN_LEFT,   HSSFCellStyle.VERTICAL_CENTER);
            CommonUtils.CoverCellStyle(workbook, cellCenterStyle,    HSSFCellStyle.ALIGN_CENTER, HSSFCellStyle.VERTICAL_CENTER);
            CommonUtils.CoverCellStyle(workbook, cellNumCenterStyle, HSSFCellStyle.ALIGN_CENTER, HSSFCellStyle.VERTICAL_CENTER);
            CommonUtils.CoverCellStyle(workbook, cellRightStyle,     HSSFCellStyle.ALIGN_RIGHT,  HSSFCellStyle.VERTICAL_CENTER);
            CommonUtils.CoverCellStyle(workbook, cellTitleStyle,     fontTitle, HSSFCellStyle.ALIGN_CENTER,  HSSFCellStyle.VERTICAL_CENTER, 24);
            CommonUtils.CoverCellStyle(workbook, cellSubTitleStyle,  fontSubTitle, HSSFCellStyle.ALIGN_CENTER,  HSSFCellStyle.VERTICAL_CENTER, 10);
            
            sheet = workbook.createSheet(strExcelName);            
            
            menuRow = sheet.createRow(2);
            cell = menuRow.createCell(1);
            if(objReqMap.get("EXCEL_TYPE").equals("EXCEL"))
            {
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )0 , ( int) 21, (short )0 ));
            	sheet. addMergedRegion (new Region(( int) 0 , ( short )1 , ( int) 1, (short )10 ));
            	sheet. addMergedRegion (new Region(( int) 2 , ( short )1 , ( int) 3, (short )10 ));
            	
            	sheet. addMergedRegion (new Region(( int) 4 , ( short )1 , ( int) 5, (short )6 ));
            	
            	sheet. addMergedRegion (new Region(( int) 4 , ( short )7 , ( int) 5, (short )7 ));

            	sheet. addMergedRegion (new Region(( int) 6 , ( short )1 , ( int) 7, (short )10 ));
            	
            	sheet. addMergedRegion (new Region(( int) 8 , ( short )1 , ( int) 8, (short)1 ));
            	sheet. addMergedRegion (new Region(( int) 9 , ( short )1 , ( int) 13, (short)1 ));
            	
            	sheet. addMergedRegion (new Region(( int) 9 , ( short )5 , ( int) 12, (short)5 ));
            	sheet. addMergedRegion (new Region(( int) 9 , ( short )6 , ( int) 12, (short)6 ));
            	sheet. addMergedRegion (new Region(( int) 9 , ( short )7 , ( int) 12, (short)7 ));
            	sheet. addMergedRegion (new Region(( int) 9 , ( short )10 , ( int) 12, (short)10 ));
            	
            	sheet. addMergedRegion (new Region(( int) 14 , ( short )1 , ( int) 14, (short )10 ));
            	
            	sheet. addMergedRegion (new Region(( int) 15 , ( short )1 , ( int) 17, (short )1 ));
            	sheet. addMergedRegion (new Region(( int) 15 , ( short )4 , ( int) 17, (short )10 ));
            	
            	sheet. addMergedRegion (new Region(( int) 18 , ( short )1 , ( int) 18, (short )10 ));
            	
            	sheet. addMergedRegion (new Region(( int) 19 , ( short )1 , ( int) 21, (short )5 ));
            	sheet. addMergedRegion (new Region(( int) 19 , ( short )6 , ( int) 21, (short )6 ));
            	sheet. addMergedRegion (new Region(( int) 20 , ( short )7 , ( int) 21, (short )7 ));
            	sheet. addMergedRegion (new Region(( int) 20 , ( short )8 , ( int) 21, (short )8 ));
            	sheet. addMergedRegion (new Region(( int) 20 , ( short )9 , ( int) 21, (short )9 ));
            	sheet. addMergedRegion (new Region(( int) 20 , ( short )10 , ( int) 21, (short )10 ));
            	
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_MENU_SUB_0109"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(2);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(3);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(4);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(5);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(6);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(7);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(8);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(9);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(10);
            	cell.setCellStyle(cellCenterStyle);
            	
            	menuRow = sheet.createRow(3);
            	cell = menuRow.createCell(1);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(2);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(3);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(4);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(5);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(6);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(7);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(8);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(9);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(10);
            	cell.setCellStyle(cellCenterStyle);
            	
            	menuRow = sheet.createRow(4);
            	cell = menuRow.createCell(7);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0658"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(8);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_SM_SR_0034"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(9);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_SM_SR_0036"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(10);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0659"));
            	cell.setCellStyle(cellCenterStyle);
            	
            	menuRow = sheet.createRow(5);
            	cell = menuRow.createCell(7);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(8);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(9);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(10);
            	cell.setCellStyle(cellCenterStyle);
            	
            	menuRow = sheet.createRow(8);
            	cell = menuRow.createCell(1);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0565"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(2);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0245"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(3);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0345"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(4);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0160"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(5);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0583"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(6);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_SM_SRM_0027"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(7);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0555"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(8);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0310"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(9);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0556"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(10);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0573"));
            	cell.setCellStyle(cellCenterStyle);
            	
            	String stmtDt = "";
            	int currentRow = 9;
            	if (objExcelData.isEmpty()){
            		
            		menuRow = sheet.createRow(15);
	            	cell = menuRow.createCell(1);
	            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0574"));
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(2);
	            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0585"));
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(3);
	            	cell.setCellStyle(cellCenterStyle);
	            	
	            	menuRow = sheet.createRow(16);
	            	cell = menuRow.createCell(1);
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(2);
	            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0587"));
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(3);
	            	cell.setCellStyle(cellCenterStyle);
	            	
	            	menuRow = sheet.createRow(17);
	            	cell = menuRow.createCell(1);
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(2);
	            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0565"));
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(3);
	            	cell.setCellStyle(cellCenterStyle);
	            	
                }else{
            		Map<String, Object> pmMap  = objExcelData.get( 0 );
            		pmMap = objExcelData.get( 0 );
            		
            		Map<String, Object> confMap  = objExcelData.get( 0 );
            		confMap = objExcelData.get( 0 );
            		
            		stmtDt = objReqMap.get( "stmtDt" )==null?"":(String)objReqMap.get( "stmtDt" );
            	
	            	menuRow = sheet.createRow(9);
	            	cell = menuRow.createCell(1);
	            	cell.setCellValue(stmtDt);
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(2);
	            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0280"));
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(3);
	            	cell.setCellValue(pmMap.get( "CARD_CNT" )==null?"":pmMap.get( "CARD_CNT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(4);
	            	cell.setCellValue(pmMap.get( "CARD_AMT" )==null?"":pmMap.get( "CARD_AMT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(5);
	            	cell.setCellValue(pmMap.get( "RESR_AMT" )==null?"":pmMap.get( "RESR_AMT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(6);
	            	cell.setCellValue(pmMap.get( "RESR_CC_AMT" )==null?"":pmMap.get( "RESR_CC_AMT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(7);
	            	cell.setCellValue(pmMap.get( "EXTRA_AMT" )==null?"":pmMap.get( "EXTRA_AMT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(8);
	            	cell.setCellValue(pmMap.get( "CARD_FEE" )==null?"":pmMap.get( "CARD_FEE" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(9);
	            	cell.setCellValue(pmMap.get( "CARD_VAT" )==null?"":pmMap.get( "CARD_VAT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(10);
	            	cell.setCellValue(pmMap.get( "DPST_AMT" )==null?"":pmMap.get( "DPST_AMT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	
	            	menuRow = sheet.createRow(10);
	            	cell = menuRow.createCell(1);
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(2);
	            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0281"));
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(3);
	            	cell.setCellValue(pmMap.get( "ACCNT_CNT" )==null?"":pmMap.get( "ACCNT_CNT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(4);
	            	cell.setCellValue(pmMap.get( "ACCNT_AMT" )==null?"":pmMap.get( "ACCNT_AMT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(5);
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(6);
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(7);
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(8);
	            	cell.setCellValue(pmMap.get( "ACCNT_FEE" )==null?"":pmMap.get( "ACCNT_FEE" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(9);
	            	cell.setCellValue(pmMap.get( "ACCNT_VAT" )==null?"":pmMap.get( "ACCNT_VAT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(10);
	            	cell.setCellStyle(cellCenterStyle);
	            	
	            	menuRow = sheet.createRow(11);
	            	cell = menuRow.createCell(1);
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(2);
	            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0282"));
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(3);
	            	cell.setCellValue(pmMap.get( "VACCT_CNT" )==null?"":pmMap.get( "VACCT_CNT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(4);
	            	cell.setCellValue(pmMap.get( "VACCT_AMT" )==null?"":pmMap.get( "VACCT_AMT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(5);
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(6);
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(7);
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(8);
	            	cell.setCellValue(pmMap.get( "VACCT_FEE" )==null?"":pmMap.get( "VACCT_FEE" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(9);
	            	cell.setCellValue(pmMap.get( "VACCT_VAT" )==null?"":pmMap.get( "VACCT_VAT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(10);
	            	cell.setCellStyle(cellCenterStyle);
	            	
	            	menuRow = sheet.createRow(12);
	            	cell = menuRow.createCell(1);
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(2);
	            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0283"));
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(3);
	            	cell.setCellValue(pmMap.get( "CP_CNT" )==null?"":pmMap.get( "CP_CNT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(4);
	            	cell.setCellValue(pmMap.get( "CP_AMT" )==null?"":pmMap.get( "CP_AMT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(5);
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(6);
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(7);
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(8);
	            	cell.setCellValue(pmMap.get( "CP_FEE" )==null?"":pmMap.get( "CP_FEE" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(9);
	            	cell.setCellValue(pmMap.get( "CP_VAT" )==null?"":pmMap.get( "CP_VAT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	
	            	menuRow = sheet.createRow(13);
	            	cell = menuRow.createCell(1);
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(2);
	            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0176"));
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(3);
	            	cell.setCellValue(pmMap.get( "TOT_CNT" )==null?"":pmMap.get( "TOT_CNT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(4);
	            	cell.setCellValue(pmMap.get( "TOT_AMT" )==null?"":pmMap.get( "TOT_AMT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(5);
	            	cell.setCellValue(pmMap.get( "CP_VAT" )==null?"":pmMap.get( "CP_VAT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(6);
	            	cell.setCellValue(pmMap.get( "CP_VAT" )==null?"":pmMap.get( "CP_VAT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(7);
	            	cell.setCellValue(pmMap.get( "EXTRA_AMT" )==null?"":pmMap.get( "EXTRA_AMT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(8);
	            	cell.setCellValue(pmMap.get( "RESR_AMT" )==null?"":pmMap.get( "RESR_AMT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(9);
	            	cell.setCellValue(pmMap.get( "RESR_CC_AMT" )==null?"":pmMap.get( "RESR_CC_AMT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(10);
	            	cell.setCellValue(pmMap.get( "DPST_AMT" )==null?"":pmMap.get( "DPST_AMT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	
	            	menuRow = sheet.createRow(15);
	            	cell = menuRow.createCell(1);
	            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0574"));
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(2);
	            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0585"));
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(3);
	            	cell.setCellValue(confMap.get( "CONF1_DNT" )==null?"":confMap.get( "CONF1_DNT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	
	            	menuRow = sheet.createRow(16);
	            	cell = menuRow.createCell(1);
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(2);
	            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0587"));
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(3);
	            	cell.setCellValue(confMap.get( "CONF2_DNT" )==null?"":confMap.get( "CONF2_DNT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	
	            	menuRow = sheet.createRow(17);
	            	cell = menuRow.createCell(1);
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(2);
	            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0565"));
	            	cell.setCellStyle(cellCenterStyle);
	            	cell = menuRow.createCell(3);
	            	cell.setCellValue(confMap.get( "CONF3_DNT" )==null?"":confMap.get( "CONF3_DNT" ).toString());
	            	cell.setCellStyle(cellCenterStyle);
	            	
            	}
            	menuRow = sheet.createRow(19);
            	cell = menuRow.createCell(6);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0660"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(7);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0661"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(8);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0662"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(9);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_SM_SR_0036"));
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(10);
            	cell.setCellValue(CommonMessageDic.getMessage("IMS_BIM_BM_0663"));
            	cell.setCellStyle(cellCenterStyle);
            	
            	menuRow = sheet.createRow(20);
            	cell = menuRow.createCell(6);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(7);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(8);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(9);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(10);
            	cell.setCellStyle(cellCenterStyle);
            	
            	menuRow = sheet.createRow(21);
            	cell = menuRow.createCell(6);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(7);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(8);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(9);
            	cell.setCellStyle(cellCenterStyle);
            	cell = menuRow.createCell(10);
            	cell.setCellStyle(cellCenterStyle);
            }

            
//            int currentRow = 9;

//            if (objExcelData.isEmpty()){
//                menuRow = sheet.createRow(currentRow);
//                
//                for(int i=0; i<11; i++) { 
//                    cell = menuRow.createCell(i);
//                    
//                    if (i == 0) {
//                        cell.setCellValue(CommonMessageDic.getMessage("IMS_DM_CPR_0013"));
//                    }
//                    
//                    cell.setCellStyle(cellCenterStyle);
//                }
//                
//                sheet.addMergedRegion(new CellRangeAddress(currentRow,currentRow,0,10));
//            } else {
//            	Map<String, Object> pmMap  = objExcelData.get( 0 );
//            	pmMap = objExcelData.get( 0 );
//            	
//            	Map<String, Object> confMap  = objExcelData.get( 0 );
//            	confMap = objExcelData.get( 0 );
//            	
//            	objReqMap.get( "stmtDt" );
//            	
//                for(Map<String, Object> objMap : objExcelData) {                    
//                    menuRow = sheet.createRow(currentRow);
//                    if (objReqMap.get("EXCEL_TYPE").equals("EXCEL")) 
//                    {                            
//                    	cell = menuRow.createCell(0);
//                    	cell.setCellValue(objMap.get( "STMT_DT" )==null?"":objMap.get( "STMT_DT" ).toString());
//                    	cell.setCellStyle(cellCenterStyle);
//                    	cell = menuRow.createCell(1);
//                    	cell.setCellValue(objMap.get( "ID" )==null?"":objMap.get( "ID" ).toString());
//                    	cell.setCellStyle(cellCenterStyle);
//                    	cell = menuRow.createCell(2);
//                    	cell.setCellValue(objMap.get( "CO_NM" )==null?"":objMap.get( "CO_NM" ).toString());
//                    	cell.setCellStyle(cellCenterStyle);
//                    	cell = menuRow.createCell(3);
//                    	cell.setCellValue(objMap.get( "REP_NM" )==null?"":objMap.get( "REP_NM" ).toString());
//                    	cell.setCellStyle(cellCenterStyle);
//                    	cell = menuRow.createCell(4);
//                    	cell.setCellValue(objMap.get( "PAY_ID_NM" )==null?"":objMap.get( "PAY_ID_NM" ).toString());
//                    	cell.setCellStyle(cellCenterStyle);
//                    	cell = menuRow.createCell(5);
//                    	cell.setCellValue(objMap.get( "CARD_CNT" )=="0"?"0":objMap.get( "CARD_CNT" ).toString());
//                    	cell.setCellStyle(cellCenterStyle);
//                    	cell = menuRow.createCell(6);
//                    	cell.setCellValue(objMap.get( "ACCNT_CNT" )=="0"?"0":objMap.get( "ACCNT_CNT" ).toString());
//                    	cell.setCellStyle(cellCenterStyle);
//                    	cell = menuRow.createCell(7);
//                    	cell.setCellValue(objMap.get( "VACCT_CNT" )=="0"?"0":objMap.get( "VACCT_CNT" ).toString());
//                    	cell.setCellStyle(cellCenterStyle);
//                    	cell = menuRow.createCell(8);
//                    	cell.setCellValue(objMap.get( "CP_CNT" )=="0"?"0":objMap.get( "CP_CNT" ).toString());
//                    	cell.setCellStyle(cellCenterStyle);
//                    	cell = menuRow.createCell(9);
//                    	cell.setCellValue(objMap.get( "RESR_AMT" )=="0"?"0":objMap.get( "RESR_AMT" ).toString());
//                    	cell.setCellStyle(cellCenterStyle);
//                    	cell = menuRow.createCell(10);
//                    	cell.setCellValue(objMap.get( "RESR_CC_AMT" )=="0"?"0":objMap.get( "RESR_CC_AMT" ).toString());
//                    	cell.setCellStyle(cellCenterStyle);
//                    	cell = menuRow.createCell(11);
//                    	cell.setCellValue(objMap.get( "EXTRA_AMT" )=="0"?"0":objMap.get( "EXTRA_AMT" ).toString());
//                    	cell.setCellStyle(cellCenterStyle);
//                    	cell = menuRow.createCell(12);
//                    	cell.setCellValue(objMap.get( "FEE" )==null?"":objMap.get( "FEE" ).toString());
//                    	cell.setCellStyle(cellCenterStyle);
//                    	cell = menuRow.createCell(13);
//                    	cell.setCellValue(objMap.get( "VAT" )==null?"":objMap.get( "VAT" ).toString());
//                    	cell.setCellStyle(cellCenterStyle);
//                    	cell = menuRow.createCell(14);
//                    	cell.setCellValue(objMap.get( "DPST_AMT" )==null?"":objMap.get( "DPST_AMT" ).toString());
//                    	cell.setCellStyle(cellCenterStyle);
//                    }
//                    currentRow++;
//                }
//            }
        } catch(Exception ex) {   
        	log.debug( "Exception : " ,ex );
            strExcelName = "Error";
            sheet = workbook.createSheet(strExcelName);            
            GetOccurredException(sheet);
        } finally {
            res.setHeader("Set-Cookie", "fileDownload=true; path=/;");
        }
    }    
    
    /**--------------------------------------------------
     * Method Name    : GetOccurredException
     * Description    : Occurred Exception
     * Author         : yangjeongmo, 2015. 10. 6.
     * Modify History : Just Created.
     ----------------------------------------------------*/
    private void GetOccurredException(HSSFSheet sheet) {
        HSSFRow  menuRow = sheet.createRow(0);
        HSSFCell cell    = menuRow.createCell(0);
        cell.setCellValue("Occurred Error.");
    }
}